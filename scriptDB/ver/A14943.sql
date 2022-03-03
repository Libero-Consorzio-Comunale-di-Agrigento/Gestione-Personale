--Attività 14943. Nuova versione del trigger GESTIONI_AMMINISTRATIVE_TMA per inserire le nuove gestioni
-- in tutte le revisioni

CREATE OR REPLACE TRIGGER gestioni_amministrative_tma
   AFTER INSERT OR UPDATE
   ON gestioni_amministrative
   FOR EACH ROW
DECLARE
   tmpvar            NUMBER;
   dep_ni            NUMBER;
   dep_numero        NUMBER;
   dep_revisione_m   NUMBER;
   dep_revisione_a   NUMBER;
   dep_revisione_o   NUMBER;
   dep_dal_a         DATE;
   dep_dal_m         DATE;
   dep_dal_o         DATE;
   integrity_error   EXCEPTION;
   errno             INTEGER;
   errmsg            CHAR (200);
   dummy             INTEGER;
   FOUND             BOOLEAN;
BEGIN
   IF INSERTING THEN
      BEGIN
         tmpvar           := 0;

         /* Determino il numero individuale del nuovo settore */
         SELECT indi_sq.NEXTVAL
           INTO dep_ni
           FROM DUAL;

         /* Inserisce il soggetto anagrafico del settore amministrativo  e della UO*/
         INSERT INTO anagrafici
                     (ni, cognome, dal, codice_fiscale, cittadinanza, provincia_res, comune_res
                     ,cap_res, provincia_dom, comune_dom, cap_dom, utente, data_agg, denominazione
                     ,tipo_soggetto)
            SELECT dep_ni
                  ,:NEW.denominazione
                  ,TO_DATE ('01011900', 'ddmmyyyy')
                  ,'XXXXXXXXXXXXXXXX'
                  ,'I'
                  ,provincia_res
                  ,comune_res
                  ,cap
                  ,provincia_res
                  ,comune_res
                  ,cap
                  ,:NEW.utente
                  ,:NEW.data_agg
                  ,:NEW.denominazione
                  ,'E'
              FROM ente;

         FOR rest IN (SELECT   revisione
                              ,stato
                              ,dal
                              ,DATA
                          FROM revisioni_struttura
                      ORDER BY dal)
         LOOP
            INSERT INTO unita_organizzative
                        (ottica, ni, codice_uo, dal, unita_padre, unita_padre_ottica
                        ,unita_padre_dal, descrizione, tipo, suddivisione, revisione, utente
                        ,data_agg)
               SELECT 'GP4'
                     ,dep_ni
                     ,:NEW.codice
                     ,NVL (rest.dal, rest.DATA)
                     ,0
                     ,'GP4'
                     ,NVL (rest.dal, rest.DATA)
                     ,:NEW.denominazione
                     ,DECODE (rest.stato, 'M', 'T', 'P')
                     ,0
                     ,rest.revisione
                     ,:NEW.utente
                     ,:NEW.data_agg
                 FROM DUAL;
         END LOOP;

         /* Inserisce il settore amministrativo della Gestione (radice dell'albero) */
         SELECT sett_sq.NEXTVAL
           INTO dep_numero
           FROM DUAL;

         INSERT INTO settori_amministrativi
                     (numero, ni, codice, denominazione, gestione, assegnabile, data_agg, utente)
            SELECT dep_numero
                  ,dep_ni
                  ,:NEW.codice
                  ,:NEW.denominazione
                  ,:NEW.codice
                  ,'SI'
                  ,:NEW.data_agg
                  ,:NEW.utente
              FROM DUAL
             WHERE NOT EXISTS (SELECT 'x'
                                 FROM settori_amministrativi
                                WHERE codice = :NEW.codice);

         INSERT INTO settori
                     (gestione, codice, descrizione, numero, suddivisione, assegnabile)
            SELECT :NEW.codice
                  ,:NEW.codice
                  ,SUBSTR (:NEW.denominazione, 1, 30)
                  ,dep_numero
                  ,0
                  ,'NO'
              FROM DUAL
             WHERE NOT EXISTS (SELECT 'x'
                                 FROM settori
                                WHERE codice = :NEW.codice);
      /*
         Select MySeq.NextVal into tmpVar from dual;
         :NEW.SequenceColumn := tmpVar;
         :NEW.CreatedDate := Sysdate;
         :NEW.CreatedUser := User;
         EXCEPTION
           WHEN OTHERS THEN
             Null;
      */
      EXCEPTION
         WHEN integrity_error THEN
            integritypackage.initnestlevel;
            raise_application_error (errno, errmsg);
         WHEN OTHERS THEN
            integritypackage.initnestlevel;
            RAISE;
      END;
   END IF;                                                                         -- fine inserting

   IF UPDATING THEN
      dep_ni           := gp4_stam.get_ni (:NEW.codice);

      UPDATE unita_organizzative
         SET descrizione = :NEW.denominazione
            ,utente = :NEW.utente
            ,data_agg = :NEW.data_agg
            ,codice_uo = :NEW.codice
       WHERE ni = dep_ni;

      UPDATE settori_amministrativi
         SET denominazione = :NEW.denominazione
            ,gestione = :NEW.codice
            ,data_agg = :NEW.data_agg
            ,utente = :NEW.utente
       WHERE ni = dep_ni;
   END IF;                                                                          -- fine updating
END;
/
