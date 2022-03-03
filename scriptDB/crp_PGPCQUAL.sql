CREATE OR REPLACE PACKAGE Pgpcqual IS
/******************************************************************************
 NOME:          crp_pgpcqual CREAZIONE FILE QUALIFICHE
 DESCRIZIONE:   Questa fase produce un file secondo il tracciato INPDAP qualifiche.txt
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
 1.1  08/09/2005     ML Sistemazione passi procedurali
 1.2  11/10/2005  AM-ML Sistemate le segnalazioni su a_segnalazioni_errore
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number,passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY Pgpcqual IS
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.2 del 11/10/2005';
   END VERSIONE;
PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
DECLARE
  P_pagina       NUMBER;
  P_riga         NUMBER := 0;
  P_ente         VARCHAR2(4);
  P_ambiente     VARCHAR2(8);
  P_utente       VARCHAR2(8);
  P_lingua       VARCHAR2(1);
  P_gestione     VARCHAR2(4);
  conta          number:=0;
  D_app          varchar2(1);
  --
  -- Estrazione Parametri di Selezione della Prenotazione
  --
BEGIN
  BEGIN
    SELECT ENTE
         , utente
         , ambiente
         , gruppo_ling
      INTO P_ente,P_utente,P_ambiente,P_lingua
      FROM a_prenotazioni
     WHERE no_prenotazione = prenotazione
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT SUBSTR(valore,1,4)
      INTO P_gestione
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_GESTIONE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  P_pagina       := 1;
  FOR CUR_GEST in
     (select posizione_cpd posizione_cp
        from gestioni
       where posizione_cpd IS NOT NULL
     	   AND codice      LIKE P_gestione
      union
      select posizione_cps posizione_cp
        from gestioni
       where posizione_cps IS NOT NULL
     	   AND codice      LIKE P_gestione
     ) LOOP
  P_pagina := P_pagina +1;
  FOR CUR_QUAL IN
   (SELECT  DISTINCT
          qus7.codice                           Codice,
          max(SUBSTR(qual.definizione,1,30))    Definizione,
          qugi.codice                           Codice_qualifica,
          max(decode(substr(qus7.mansione,1,20), null,
                                          DECODE( SUBSTR(qugi.contratto,1,2)
                                          ,'EP',DECODE( qual.qua_inps
                                                       ,1,'Salariati'
                                                       ,2,DECODE( INSTR(qugi.codice,'V')
                                                                 ,0,'Amministrativi'
                                                                   ,DECODE(SUBSTR(qugi.livello,1,1)
                                                                           ,'8','Graduati V.U.'
                                                                           ,'7','Graduati V.U.'
                                                                           ,'D','Graduati V.U.'
                                                                               ,'Vigili Urbani'
                                                                          )
                                                                )
                                                       ,3,'Amministrativi'
                                                      )
                                          ,'CA',DECODE( SUBSTR(qugi.ruolo,1,3)
                                                       ,'AMM','Amministrativi'
                                                       ,'TEC','Paramedici'
                                                       ,'SAN','Paramedici'
                                                       ,'SANA','Paramedici'
                                                       ,'SANM','Paramedici'
                                                             ,'XXX'
                                                      )
                                          ,'CD',DECODE( SUBSTR(qugi.ruolo,1,3)
                                                       ,'AMM','Amministrativi'
                                                       ,'PRO','Laureati non Medici'
                                                       ,'SAN','Laureati non Medici'
                                                       ,'SANA','Laureati non Medici'
                                                       ,'SANM','Laureati non Medici'
                                                       ,'TEC','Laureati non Medici'
                                                             ,'XXX'
                                                      )
                                          ,'ME','Sanitari'
                                               ,'XXX')
                                , substr(qus7.mansione,1,20))
          )    Mansione
    FROM  QUALIFICHE              qual
         ,QUALIFICHE_GIURIDICHE   qugi
         ,QUALIFICHE_INPDAP       qus7
   WHERE  qual.numero              = qugi.numero
     and  qugi.codice like qus7.qualifica_gp4
     and  qugi.contratto like qus7.contratto_gp4
     and  qugi.dal <= nvl(qus7.al, to_date('3333333', 'j'))
     and  nvl(qus7.dal, to_date('2222222', 'j')) <= nvl(qugi.al, to_date('3333333', 'j'))
	 group by qus7.codice,qugi.codice
 ) LOOP
P_riga := P_riga + 1;
   INSERT INTO a_appoggio_stampe
         (no_prenotazione,no_passo,pagina,riga,testo) VALUES
         (prenotazione,1,P_pagina,P_riga,
          RPAD(nvl(CUR_GEST.posizione_cp,' '),8  ,' ')||
          LPAD(nvl(CUR_QUAL.codice,' '),11,'0')||
          RPAD(' ',32,' ')||
          RPAD(nvl(CUR_QUAL.definizione,' '),30,' ')||
          RPAD(nvl(CUR_QUAL.mansione,' '),20,' ')
         );
END LOOP; -- CUR_QUAL --
END LOOP; -- CUR_GEST --
FOR CUR in
      (select qugi.contratto
             ,qugi.codice
             ,pegi.dal
             ,pegi.al
             ,pegi.ci
       from  periodi_giuridici     pegi,
             qualifiche_giuridiche qugi
       where pegi.rilevanza   = 'S'
       and   pegi.qualifica   = qugi.numero
       and   nvl(pegi.al,to_date('3333333','j')) between nvl(qugi.dal,to_date('2222222','j')) and nvl(qugi.al,to_date('3333333','j')) 
       AND   pegi.dal           = (SELECT MAX(dal)
                                             FROM PERIODI_GIURIDICI
                                            WHERE rilevanza  = 'S'
                                              and ci = pegi.ci
                                          )
       and   not exists (select 'x' from qualifiche_inpdap qus7
                         where   qugi.codice like qus7.qualifica_gp4
                         and   qugi.contratto like qus7.contratto_gp4
                         and   qugi.dal <= nvl(qus7.al, to_date('3333333', 'j'))
                         and   nvl(qus7.dal, to_date('2222222', 'j')) <= nvl(qugi.al, to_date('3333333', 'j')))
       )LOOP
        conta:=conta+1;   
       insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                       ,errore,precisazione)
      values( prenotazione,1,conta,'P04091','CI '||lpad(to_char(CUR.ci),8,' ')
            ||' Dal: '||lpad(to_char(CUR.dal,'dd/mm/yyyy'),10,' ')
--            ||' Al: '||nvl(lpad(to_char(CUR.al,'dd/mm/yyyy'),10,' '),lpad(' ',10,' '))
            ||' Qual. '||rpad(CUR.contratto,4,' ')||'/'||rpad(CUR.codice,8,' '));
    commit;
      END LOOP;
/*
begin
     select 'x' 
     into   D_app
     from   a_segnalazioni_errore
     where  no_prenotazione=prenotazione;
     raise  too_many_rows;
     exception
      when no_data_found then 
            update a_prenotazioni
           set prossimo_passo    = 93
           where no_prenotazione = prenotazione  ;
      when too_many_rows then
           update a_prenotazioni
           set prossimo_passo    = 91,
           errore                = 'P05808'
           where no_prenotazione = prenotazione;
    end;
    commit;
*/
END;
END;
END;
/

