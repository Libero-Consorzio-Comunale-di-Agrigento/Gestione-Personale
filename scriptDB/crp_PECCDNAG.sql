CREATE OR REPLACE PACKAGE PECCDNAG IS
/******************************************************************************
 NOME:          PECCDNAG
 DESCRIZIONE:   Creazione file per assunti / cessati INAIL
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    18/03/2002             
 2    07/07/2003 MS     Modifica ai parametri di selezione
 3    11/08/2004 MS     Modifica al tracciato
 3.1  29/10/2004 MS     Modifiche per difetti 
 3.2  07/09/2005 AM	Modifiche per ORAERR (? solo su alcune versioni di Oracle ?)
 3.3  19/09/2005 MS     Modifiche per inserimento stampa Att.12700
 3.4  02/12/2005 MS     Mod. Ordinamento e inserimento dati stampa Att. 13703
 3.5  05/12/2005 MS     Introduzione nuovo parametro per i Non Iscritti Att.13800
 3.6  27/12/2005 MS     Lettura posizione_inail da DGEST per Non Iscr. Att.13905
 3.7  20/01/2006 MS     Aggiunto trattamento delle assenze. Att 14110 
 3.8  26/01/2006 MS     Mod. gestioni particolari assenze. Att 14110.1
 3.9  08/02/2006 AM     Attivato NVL nel parametro P_tratta_assenze
 4.0  07/03/2006 MS     Revisione dell'estrazione dei dati ( Att.15199 )
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCDNAG IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V4.0 del 07/03/2006';
 END VERSIONE;
 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
 BEGIN
DECLARE
  D_ente        VARCHAR2(4);
  D_ambiente    VARCHAR2(8);
  D_utente      VARCHAR2(8);

  D_riga        number;
  D_riga_s1     number := 0;
  D_riga_s2     number := 0;

  D_al          date;
  D_dal         date;
  D_rapporto    varchar2(4);
  P_non_iscritti varchar2(1);
  P_tratta_assenze varchar2(1);
  P_cod_accesso varchar2(4);
  P_estero      varchar2(1);
  D_cognome     varchar2(40);
  D_nome        varchar2(30);
  D_cfis        varchar2(16);
  D_cfis_ente   varchar2(16);
  D_posizione   varchar2(8);
  D_posizione_aziendale   varchar2(8);

  V_settore     varchar2(15);
  V_profilo     varchar2(30);
  V_gestione    varchar2(4);
  BEGIN -- Estrazione Parametri di Prenotazione
     BEGIN
      select ente    
           , utente  
           , ambiente
        into D_ente, D_utente, D_ambiente
        from a_prenotazioni
       where no_prenotazione = prenotazione
      ;
     END;
     BEGIN
      select  to_date(valore,'dd/mm/yyyy')
        into D_dal
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_DAL'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
         SELECT trunc(SYSDATE)
           INTO D_dal
           FROM dual
         ;
      END;
-- dbms_output.put_line('dal :'||D_dal);
      BEGIN
      select to_date(valore,'dd/mm/yyyy')
        into D_al
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_AL'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_al := D_dal;
      END;
-- dbms_output.put_line('dal :'||D_al);
    BEGIN
      select substr(valore,1,4)
        into D_RAPPORTO
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_RAPPORTO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_RAPPORTO := '%';
      END;
      BEGIN
      select substr(valore,1,1)
        into P_non_iscritti
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_NON_ISCRITTI'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN 
              P_non_iscritti := NULL;
      END;
      BEGIN
      select substr(valore,1,1)
        into P_tratta_assenze
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_TRATTA_ASSENZE'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN 
              P_tratta_assenze := NULL;
      END;
      BEGIN
      select sele.valore_default    
        into P_cod_accesso
        from a_selezioni sele
      where  sele.voce_menu            = 'PECCDNAG'
        AND  sele.parametro            = 'P_COD_ACCESSO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              P_cod_accesso := '0000';
      END;
BEGIN
-- inserimento testata report
-- passo 2 e 3 per avere 2 report distinti
  D_riga_s1 := D_riga_s1+1;
  INSERT INTO a_appoggio_stampe (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
  SELECT prenotazione, 2 , 1, D_riga_s1
       , substr(
         rpad('Cod.Ind',8,' ')
       ||' '
       ||rpad('Nominativo',50,' ')
       ||' '
       ||rpad('Codice Fiscale',16,' ')
         ,1,132)
    FROM dual
  ;
  D_riga_s1 := D_riga_s1+1;
  INSERT INTO a_appoggio_stampe (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
  SELECT prenotazione, 2 , 1, D_riga_s1
       , substr(
         rpad(' ',9,' ')
       ||rpad('Inizio',10,' ')
       ||' '
       ||rpad('Fine',10,' ')
       ||' '
       ||rpad('Settore',16,' ')
       ||' '
       ||rpad('Profilo',30,' ')
       ||' '
       ||rpad('Posizione',9,' ')
         ,1,132)
    FROM dual
  ;
  D_riga_s1 := D_riga_s1+1;
  INSERT INTO a_appoggio_stampe (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
  SELECT prenotazione, 2 , 1, D_riga_s1
       , lpad('-',132,'-')
    FROM dual
  ;
  D_riga_s1 := D_riga_s1+1;
  INSERT INTO a_appoggio_stampe (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
  SELECT prenotazione, 2 , 1, D_riga_s1
       , lpad(' ',132,' ')
    FROM dual
  ;

  D_riga_s2 := D_riga_s2+1;
  INSERT INTO a_appoggio_stampe (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
  SELECT prenotazione, 3 , 1, D_riga_s2
       , substr(
         rpad('Codice Fiscale',16,' ')
       ||lpad(' ',2,' ')
       ||rpad('Inizio',10,' ')
       ||lpad(' ',2,' ')
       ||rpad('Fine',10,' ')
       ||lpad(' ',2,' ')
       ||rpad('Posizione',9,' ')
         ,1,132)
    FROM dual
  ;
  D_riga_s2 := D_riga_s2+1;
  INSERT INTO a_appoggio_stampe (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
  SELECT prenotazione, 3 , 1, D_riga_s2
       , lpad('-',132,'-')
    FROM dual
  ;
  D_riga_s2 := D_riga_s2+1;
  INSERT INTO a_appoggio_stampe (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
  SELECT prenotazione, 3 , 1, D_riga_s2
       , lpad(' ',132,' ')
    FROM dual
  ;
END;

 BEGIN
 D_riga := 0;
     FOR CURS IN
          ( SELECT rain.ci
                 , rain.ni
		 , rars.posizione_inail                               posizione
                 , decode( sign ( PEGI_p.dal - D_dal ) 
                         , -1 , to_char(null)
                              ,  to_char(PEGI_p.dal,'yyyymmdd') )     inizio
            	 , decode( sign ( nvl( PEGI_p.al, D_al+1) - D_al ) 
                         , 1, to_char(null)
                            , to_char(PEGI_p.al,'yyyymmdd') )         fine
                 , nvl(nvl( decode( sign ( PEGI_p.dal - D_dal ) , -1 , to_char(null),  to_char(PEGI_p.dal,'yyyymmdd') )
                          , decode( sign ( nvl( PEGI_p.al, D_al+1) - D_al ) , 1, to_char(null), to_char(PEGI_p.al,'yyyymmdd') )
                          ), '99999999')                              ordinamento
              FROM RAPPORTI_INDIVIDUALI         rain
            	 , RAPPORTI_RETRIBUTIVI_storici rars
            	 , PERIODI_GIURIDICI            PEGI_p
             WHERE   (   nvl(P_non_iscritti,' ') in ( 'S','T' )
                      or nvl(P_non_iscritti,' ') not in ( 'S','T' ) AND
                         rars.posizione_inail is not null  and 
                         exists ( select 'x' 
                                   from assicurazioni_inail
                                  where codice = rars.posizione_inail 
                               )
                    )
               AND  rars.ci                   = rain.ci
               AND  rain.ci                   = PEGI_p.ci
               AND  PEGI_p.rilevanza          = 'P'
               AND (  PEGI_p.dal between D_dal and D_al
                or    PEGI_p.al  between D_dal and D_al
	              )
	       and  rain.rapporto             like d_rapporto
               and  nvl(PEGI_p.al,D_al) between rars.dal and nvl(rars.al,nvl(PEGI_p.al,D_al))
               AND  ( nvl(P_tratta_assenze,' ') != 'X'
                   or P_tratta_assenze  = 'X' 
                  and not exists ( select 'x' 
                                     from periodi_giuridici
                                    where ci = pegi_p.ci
                                      and rilevanza = 'A'
                                      and ( al = pegi_p.al
                                         or dal = pegi_p.dal
                                          )
                                      and evento in ( select codice
                                                        from eventi_giuridici
                                                       where conto_annuale = '99'
                                                    )
                                 )
                    )
               and (   rain.cc is null
                    or exists
                       (select 'x'
                          from a_competenze
                          where ente        = D_ente
                            and ambiente    = D_ambiente
                            and utente      = D_utente
                            and competenza  = 'CI'
                            and oggetto     = rain.cc
                       )
                  )
            union
/* tratto dipendenti con assenza che inizia nel periodo */
            SELECT rain.ci
                 , rain.ni
                 , rars.posizione_inail                     posizione
                 , to_char(null)                            inizio
            	 , to_char(pegi_a.dal-1,'yyyymmdd')         fine
                 , nvl(nvl( to_char(pegi_a.dal-1,'yyyymmdd'), to_char(null) ), '99999999') ordinamento
               FROM RAPPORTI_INDIVIDUALI         rain
                  , RAPPORTI_RETRIBUTIVI_storici rars
                  , PERIODI_GIURIDICI            pegi_a
              WHERE P_tratta_assenze          = 'X'
                AND rars.ci                   = rain.ci
                AND rain.ci                   = pegi_a.ci
                AND pegi_a.rilevanza          = 'A'
                AND pegi_a.evento in ( select codice
                                         from eventi_giuridici
                                        where nvl(conto_annuale,0 ) = 99
                                      )
                AND not exists ( select 'x' 
                                   from periodi_giuridici 
                                  where nvl(al,D_al+1) = nvl(pegi_a.dal,D_dal)-1 
                                    and ci = pegi_a.ci 
                                    and rilevanza = 'A' 
                                    and evento = pegi_a.evento 
                               )
                AND not exists ( select 'x' 
                                   from periodi_giuridici 
                                  where dal = pegi_a.dal
                                    and ci = pegi_a.ci 
                                    and rilevanza = 'P' 
                               )
                AND nvl(PEGI_a.dal,D_dal)-1 between D_dal and D_al
                AND rain.rapporto             like d_rapporto
                AND nvl(pegi_a.al,D_al) between rars.dal and nvl(rars.al,nvl(pegi_a.al,D_al))
                AND (   rain.cc is null
                     or exists
                       (select 'x'
                          from a_competenze
                          where ente        = D_ente
                            and ambiente    = D_ambiente
                            and utente      = D_utente
                            and competenza  = 'CI'
                            and oggetto     = rain.cc
                       )
                  )
            union
/* tratto dipendenti con assenza che termina nel periodo */
            SELECT rain.ci
                 , rain.ni
		 , rars.posizione_inail                                posizione
                 , to_char(pegi_a.al+1,'yyyymmdd')                     inizio
            	 , to_char(null)                                       fine
                 , nvl(nvl( to_char(null),to_char(pegi_a.al+1,'yyyymmdd')), '99999999') ordinamento
               FROM RAPPORTI_INDIVIDUALI         rain
                  , RAPPORTI_RETRIBUTIVI_storici rars
                  , PERIODI_GIURIDICI            pegi_a
              WHERE P_tratta_assenze          = 'X'
                AND rars.ci                   = rain.ci
                AND rain.ci                   = pegi_a.ci
                AND pegi_a.rilevanza          = 'A'
                AND pegi_a.evento in ( select codice
                                         from eventi_giuridici
                                        where nvl(conto_annuale,0 ) = 99
                                      )
                AND not exists ( select 'x' 
                                   from periodi_giuridici 
                                  where dal = nvl(pegi_a.al,D_al)+1
                                    and ci = pegi_a.ci 
                                    and rilevanza = 'A' 
                                    and evento = pegi_a.evento 
                               )
                AND not exists ( select 'x' 
                                   from periodi_giuridici 
                                  where al = pegi_a.al
                                    and ci = pegi_a.ci 
                                    and rilevanza = 'P' 
                               )
                AND nvl(PEGI_a.al,D_al)+1  between D_dal and D_al
                AND rain.rapporto             like d_rapporto
                AND nvl(pegi_a.al,D_al) between rars.dal and nvl(rars.al,nvl(pegi_a.al,D_al))
                AND (   rain.cc is null
                     or exists
                       (select 'x'
                          from a_competenze
                          where ente        = D_ente
                            and ambiente    = D_ambiente
                            and utente      = D_utente
                            and competenza  = 'CI'
                            and oggetto     = rain.cc
                       )
                  )
            order by 6,4,5
        ) LOOP

          BEGIN
            select anag.cognome               cognome
		 , anag.nome                  nome
		 , anag.codice_fiscale        cfis
		 , decode(anag.cittadinanza
                          ,'I', null
                              , decode(lpad(nvl(anag.codice_fiscale,'X'),16,'X')
                                     , lpad('X',16,'X'), decode(lpad(nvl(anag.codice_fiscale_estero,'X'),16,'X') 
                                                               , lpad('X',16,'X'), 'X'
                                                                                 , null )
                                                       , null )
                        )
            into D_cognome, D_nome, D_cfis, P_estero
            from anagrafici anag
           where ni = CURS.ni
             and al is null
          ;
          EXCEPTION 
               WHEN NO_DATA_FOUND THEN 
                D_cognome := null;
                D_nome    := null;
                D_cfis    := null;
                P_estero  := null;
          END;

          BEGIN
          select LPAD( nvl( SUBSTR( ASIN.posizione ,1 ,DECODE(INSTR(ASIN.posizione,'/'),0, 8,INSTR(ASIN.posizione,'/')))
                           ,'0'),8,'0') posizione
            into D_posizione
            from assicurazioni_inail asin
           where codice = CURS.posizione
          ;
          EXCEPTION 
               WHEN NO_DATA_FOUND THEN 
                D_posizione := 'NON ISCR';
          END;

-- estrazione dati dai periodi giuridici
          BEGIN
            select substr(prpr.descrizione,1,30)
                 , sett.codice
                 , pegi_q.gestione
              into V_profilo
                 , V_settore
                 , V_gestione
              from figure_giuridiche figi
                 , periodi_giuridici pegi_q
                 , profili_professionali prpr
                 , settori sett
             where pegi_q.ci = CURS.ci
               and pegi_q.rilevanza = 'Q'
               and pegi_q.dal = ( select max(dal) 
                                    from periodi_giuridici pegi_q1
                                   where pegi_q1.ci        = pegi_q.ci
                                     and pegi_q1.rilevanza = 'Q' 
                                     and (   to_date(nvl(curs.inizio,to_char(D_dal,'yyyymmdd')),'yyyymmdd') 
                                             between pegi_q1.dal and nvl(pegi_q1.al,to_date('3333333','j'))
                                          or to_date(nvl(curs.fine,to_char(D_al,'yyyymmdd')),'yyyymmdd')
                                             between pegi_q1.dal and nvl(pegi_q1.al,to_date('3333333','j'))
                                         )
                                ) 
               and pegi_q.figura = figi.numero
               and nvl(pegi_q.al,to_date('3333333','j'))
                   between nvl(figi.dal,to_date('2222222','j'))
                       and nvl(figi.al ,to_date('3333333','j'))
               and prpr.codice (+) = figi.profilo 
               and sett.numero (+) = pegi_q.settore
           ;
          EXCEPTION 
               WHEN NO_DATA_FOUND THEN V_profilo := null; V_settore := null; v_gestione := null;
               WHEN TOO_MANY_ROWS THEN V_profilo := null; V_settore := null; v_gestione := null;
          END;

          BEGIN
          select LPAD( nvl( SUBSTR( GEST.posizione_inail,1 ,DECODE(INSTR(GEST.posizione_inail,'/')
                                                               ,0,8,INSTR(GEST.posizione_inail,'/')))
                            ,'0'),8,'0')
               , LPAD(gest.codice_fiscale,16,' ')
            into D_posizione_aziendale
               , D_cfis_ente
            from gestioni gest
           where codice = V_gestione
          ;
          EXCEPTION 
               WHEN NO_DATA_FOUND THEN
                 BEGIN
                    select LPAD(ente.codice_fiscale,16,' ')
                      into D_cfis_ente
                      from ente
                    ;
                EXCEPTION  
                     WHEN NO_DATA_FOUND THEN 
                       D_cfis_ente := lpad('0',16,'0');
                 END;
                 BEGIN
                  select LPAD( max( nvl( SUBSTR( GEST.posizione_inail,1 ,DECODE(INSTR(GEST.posizione_inail,'/')
                                                                               ,0,8,INSTR(GEST.posizione_inail,'/')))
                                        ,'0')),8,'0')
                    into D_posizione_aziendale
                    from gestioni gest
                  ;
                EXCEPTION  
                     WHEN NO_DATA_FOUND THEN 
                       D_posizione_aziendale := lpad('0',8,'0');
                END;
          END;

          BEGIN
/* Inserimento dati per file TXT */
          IF ( P_non_iscritti = 'T'
            or nvl(P_non_iscritti,'S') = 'S' and D_posizione != 'NON ISCR'
             ) THEN
          D_riga := D_riga+1;
          INSERT INTO a_appoggio_stampe
          (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
          SELECT prenotazione
               , 1
               , 1
               , D_riga
               , rpad(nvl(D_cfis,' '),16,' ')
               ||'0'
               ||lpad( decode( D_posizione
                              ,'NON ISCR', nvl(D_posizione_aziendale,'0')
                                         , nvl(D_posizione,'0')
                             ),8,'0')
               ||lpad(nvl(substr(CURS.inizio,1,4),'1'),4,'0')
               ||'-'
               ||lpad(nvl(substr(CURS.inizio,5,2),'01'),2,' ')
               ||'-'
               ||lpad(nvl(substr(CURS.inizio,7,2),'01'),2,' ')
               ||lpad(nvl(substr(CURS.fine,1,4),'9999'),4,'9')
               ||'-'
               ||lpad(nvl(substr(CURS.fine,5,2),'12'),2,' ')
               ||'-'
               ||lpad(nvl(substr(CURS.fine,7,2),'31'),2,' ')
               ||lpad(' ',2,' ')
               ||rpad(nvl(D_cfis_ente,' '),16,' ')
               ||lpad(nvl(P_cod_accesso,'0'),4,'0')
               ||lpad(' ',2,' ')
               ||lpad(' ',18,' ')
               ||lpad(nvl(P_estero,' '),'1',' ')
               ||rpad(decode(P_estero,'P',D_cognome,' '),40,' ')
               ||rpad(decode(P_estero,'P',D_nome,' '),40,' ')
            FROM dual
          ;
          END IF;

          BEGIN
/* Inserimento dati per report nominativo */
          IF ( P_non_iscritti in ('T','S')
            or P_non_iscritti is null and D_posizione != 'NON ISCR'
             ) THEN
          D_riga_s1 := D_riga_s1+1;
          INSERT INTO a_appoggio_stampe
          (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
          SELECT prenotazione
               , 2
               , 1
               , D_riga_s1
               , substr(
                 rpad(nvl(CURS.ci,0),8,' ')
               ||' '
               ||rpad(nvl(substr(D_cognome||' '||D_nome,1,50),' '),50,' ')
               ||' '
               ||rpad(nvl(D_cfis,' '),16,' ')
                 ,1,132)
            FROM dual
          ;
          D_riga_s1 := D_riga_s1+1;
          INSERT INTO a_appoggio_stampe
          (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
          SELECT prenotazione
               , 2
               , 1
               , D_riga_s1
               , substr(
                 rpad(' ',9,' ')
               ||rpad(decode(nvl(CURS.inizio,'00010101')
                            ,'00010101',' '
                                       , to_char(to_date(CURS.inizio,'yyyymmdd'),'dd/mm/yyyy')
                            ),10,' ')
               ||' '
               ||rpad(decode(nvl(CURS.fine,'99993112')
                            ,'99993112',' '
                                       , to_char(to_date(CURS.fine,'yyyymmdd'),'dd/mm/yyyy')
                            ),10,' ')
               ||' '
               ||rpad(nvl(V_settore,' '),16,' ')
               ||' '
               ||rpad(nvl(V_profilo,' '),30,' ')
               ||' '
               ||lpad( decode( D_posizione
                              ,'NON ISCR',nvl(D_posizione_aziendale,'0')
                                         ,nvl(D_posizione,'0')
                              ) ,8,'0')
               ||decode( D_posizione,'NON ISCR',' - NON ISCRITTO','')
                 ,1,132)
            FROM dual
          ;
          D_riga_s1 := D_riga_s1+1;
          INSERT INTO a_appoggio_stampe
          (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
          SELECT prenotazione
               , 2
               , 1
               , D_riga_s1
               , rpad(' ',132,' ')
            FROM dual
          ;
          END IF;
/* Inserimento dati per report uguale al txt */
          IF ( P_non_iscritti = 'T'
            or nvl(P_non_iscritti,'S') = 'S' and D_posizione != 'NON ISCR'
             ) THEN
          D_riga_s2 := D_riga_s2+1;
          INSERT INTO a_appoggio_stampe
          (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
          SELECT prenotazione
               , 3
               , 1
               , D_riga_s2
               , substr(
                 rpad(nvl(D_cfis,' '),16,' ')
               ||lpad(' ',2,' ')
               ||rpad(decode(nvl(CURS.inizio,'00010101')
                            ,'00010101','01/01/0001'
                                       , to_char(to_date(CURS.inizio,'yyyymmdd'),'dd/mm/yyyy')
                            ) ,10,' ')
               ||lpad(' ',2,' ')
               ||rpad(decode(nvl(CURS.fine,'99993112')
                            ,'99993112','31/12/9999'
                                       , to_char(to_date(CURS.fine,'yyyymmdd'),'dd/mm/yyyy')
                            ) ,10,' ')
               ||lpad(' ',2,' ')
               ||lpad(decode( D_posizione
                             ,'NON ISCR', nvl(D_posizione_aziendale,'0')
                                        , nvl(D_posizione,'0')
                             ),8,'0')
               ||decode( D_posizione,'NON ISCR',' - NON ISCRITTO','')
                 ,1,132)
            FROM dual
          ;
          END IF;
          commit;
          END;
        END;
      END LOOP;
   END;
  END;
END;
END;
/
