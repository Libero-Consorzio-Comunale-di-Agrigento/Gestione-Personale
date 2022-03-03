CREATE OR REPLACE PACKAGE pgmitelo IS
/******************************************************************************
 NOME:          PGMITELO
 DESCRIZIONE:   Creazione delle righe di stampa delle note giuridiche. 
                Questa funzione inserisce nella tavola di lavoro TEMP_LONG le singole
                righe di stampa delle note giuridiche generate con l'esatta dimensione.
                Il passo successivo produrra` la stampa del Certificato Giuridico.
                Una fase ancora seguente si occupera` della eliminazione delle registra-
                zioni inserite nella tavola TEMP_LONG.
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    21/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY pgmitelo IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 21/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
	DECLARE
  P_certificato  VARCHAR2(4);
  P_ci           number;
  P_ni           number;
  P_decorrenza   VARCHAR2(2);
  P_note_ind     VARCHAR2(2);
  D_larg_note    number;
  D_i                   number;
  dep_carattere         number;
  dep_prenotazione      number(6);
  dep_progressivo       number;
  D_descrizione         VARCHAR2(250);
  BEGIN -- Estrazione Parametri di Selezione della Prenotazione
  BEGIN -- Estrazione Parametri di Selezione della Prenotazione
      select valore , no_prenotazione
        into P_certificato, dep_prenotazione
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_CERTIFICATO'
      ;
      select to_number(valore)
        into P_ci
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_CI'
      ;
      select max(ni)
        into P_ni
        from rapporti_individuali
       where ci = P_ci
      ;
  END;
  BEGIN -- Estrazione parametri essenziali del certificato richiesto
      select decorrenza
           , note_ind
        into P_decorrenza, P_note_ind
        from certificati
       where codice      = P_certificato
      ;
  END;
  IF P_decorrenza = 'SI'
     THEN D_larg_note := 46;
     ELSE D_larg_note := 53;
  END IF;
  BEGIN
    dep_progressivo := 1;
    FOR CURS_NOTE IN
       (select rilevanza
             , ci
             , pegi_dal   dal
             , pegi_note  note
          from pegi_p
         where ci           in (select rain.ci from rapporti_individuali rain
                                 where rain.ni = P_ni)
           and pegi_note is not null
         union
        select rilevanza
             , ci
             , pegi_dal   dal
             , pegi_note  note
          from pegi_qi
         where ci           in (select rain.ci from rapporti_individuali rain
                                 where rain.ni = P_ni)
           and pegi_note is not null
         union
        select rilevanza
             , ci
             , pegi_dal   dal
             , pegi_note  note
          from pegi_se
         where ci           in (select rain.ci from rapporti_individuali rain
                                 where rain.ni = P_ni)
           and pegi_note is not null
         union
        select rilevanza
             , ci
             , pegi_dal   dal
             , pegi_note  note
          from pegi_a
         where ci           in (select rain.ci from rapporti_individuali rain
                                 where rain.ni = P_ni)
           and pegi_note is not null
         union
        select 'D'
             , ci
             , dogi_del   dal
             , dogi_note  note
          from pegi_d
         where ci           in (select rain.ci from rapporti_individuali rain
                                 where rain.ni = P_ni)
           and dogi_note is not null
       ) LOOP
-- dbms_output.put_line(curs_note.ci||curs_note.note);
          BEGIN
          dep_carattere := 1;
          LOOP
            D_i :=nvl(instr(substr(CURS_NOTE.note,dep_carattere,D_larg_note),
                          chr(10)),0);
-- dbms_output.put_line(D_i);
            IF D_i = 0  THEN
               D_i := D_larg_note;
               IF dep_carattere+D_larg_note-1 < LENGTH(CURS_NOTE.note) THEN
                  FOR i IN REVERSE 1..D_larg_note LOOP
                      IF substr(CURS_NOTE.note,dep_carattere+i,1) = ' ' THEN
                         D_i := i+1;
                         EXIT;
                      END IF;
                  END LOOP;
               END IF;
            ELSE
              IF D_i = 1 THEN
                D_i := 0;
              END IF;
            END IF;
            IF D_i > 0 THEN
               D_descrizione := rtrim(replace(substr(CURS_NOTE.note,
                                                     dep_carattere,D_i),
                                              chr(10),null));
-- dbms_output.put_line(dep_prenotazione||dep_progressivo||CURS_NOTE.ci||CURS_NOTE.rilevanza||CURS_NOTE.dal||D_descrizione);
               insert into temp_long
                     (prenotazione,progressivo,ci,rilevanza,dal
                     ,descrizione,terminale)
               values(dep_prenotazione,
                      dep_progressivo,
                      CURS_NOTE.ci,
                      CURS_NOTE.rilevanza,
                      CURS_NOTE.dal,
                      D_descrizione,
                      null);
               dep_carattere := dep_carattere + D_i;
            ELSE
              dep_carattere := dep_carattere + 1;
            END IF;
            IF dep_carattere >= LENGTH(CURS_NOTE.note) THEN
              EXIT;
            END IF;
            dep_progressivo := dep_progressivo+1;
           END LOOP;
          END;
        END LOOP;
  commit;
END;
END;
begin
delete from temp_long
 where descrizione is null;
end;
end;
end;
/

