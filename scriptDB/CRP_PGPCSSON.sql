CREATE OR REPLACE PACKAGE Pgpcsson IS

/******************************************************************************
 NOME:          PGPCSSON TABELLA SERVIZI SENZA ONERE
 DESCRIZIONE:   Questa fase produce un file secondo il tracciato INPDAP ServSen.txt
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 2    10/06/2004   AM   Revisioni varie a seguito dei test sul Modulo
 3    01/07/2004   ML   Gestione Incarichi, e modifiche varie
 3.1  11/10/2004   ML   Modificato il tipo servizio di pegi da 0 a 100
 3.2  09/12/2005   ML   Modificata gestione assenze per interrompere il servizio solo se NON utile ai fini INPDAP (A9003).
                        Modificato inoltre l'accesso a COST (vedi cursore SER) perchè perdeva un pezzo di periodo nel caso
                        in cui l'al del servizio cadeva in un periodo di COST che iniziava successivamente al dal di PEGI. 
                        Gestione parametri data di partenza selezione e progressivo servizi (A13926).
******************************************************************************/
FUNCTION  VERSIONE                                                              RETURN VARCHAR2;
FUNCTION  GET_GG_SERVIZIO       (P_inizio in date, P_fine in date)              RETURN NUMBER;
PROCEDURE MAIN                  (prenotazione IN NUMBER,passo IN NUMBER);
PROCEDURE GET_ANNI_MESI_GG      (P_gg_servizio IN number, D_anni OUT number, D_mesi OUT number, D_giorni OUT number);
END;
/

CREATE OR REPLACE PACKAGE BODY Pgpcsson IS

FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V3.2 del 09/12/2005';
END VERSIONE;

FUNCTION GET_GG_SERVIZIO (P_inizio in date, P_fine in date) RETURN NUMBER IS
D_giorni number;
BEGIN
  SELECT sum(TRUNC(MONTHS_BETWEEN(LAST_DAY(NVL(P_fine,SYSDATE) + 1)
                                 ,LAST_DAY(P_inizio)
                                 )
                  ) * 30
            - LEAST(30,TO_NUMBER(TO_CHAR(P_inizio,'dd'))) + 1
            + LEAST(30,TO_NUMBER(TO_CHAR(NVL(P_fine,SYSDATE) + 1,'dd')) - 1)
            )                                     gg_servizio
    INTO D_giorni
    FROM dual
  ;
  RETURN D_giorni;
END GET_GG_SERVIZIO;

PROCEDURE GET_ANNI_MESI_GG (P_gg_servizio IN number, D_anni OUT number, D_mesi OUT number, D_giorni OUT number) IS
BEGIN
  SELECT TRUNC(P_gg_servizio / 360)                                       anni_serv
        ,TRUNC((P_gg_servizio - (TRUNC(P_gg_servizio / 360) * 360)) / 30) mesi_serv
        ,P_gg_servizio - (TRUNC(P_gg_servizio / 360)  *360 )
                       - (TRUNC((P_gg_servizio - (TRUNC(P_gg_servizio / 360) * 360)) / 30) *30)
                                                                                               gg_serv
    INTO D_anni
        ,D_mesi
        ,D_giorni
    FROM dual
  ; 
END GET_ANNI_MESI_GG ;

PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
DECLARE
  P_dummy        VARCHAR2(1);
  P_pagina       NUMBER;
  P_riga         NUMBER;
  P_ente         VARCHAR2(4);
  P_ambiente     VARCHAR2(8);
  P_utente       VARCHAR2(8);
  P_lingua       VARCHAR2(1);
  P_prog_ser     NUMBER;
  P_dal          DATE;
  D_inizio       DATE;
  D_fine         DATE;
  D_anni         NUMBER;
  D_mesi         NUMBER;
  D_giorni       NUMBER;
  D_gg_servizio  NUMBER;
  D_dep_ni       number;
  

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
    select to_date(substr(valore,1,10),'dd/mm/yyyy')
      into P_dal
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_DAL'
    ;
    EXCEPTION WHEN NO_DATA_FOUND 
              THEN P_dal := to_date(null);
  END;
  BEGIN 
    select to_number(valore)
      into P_prog_ser
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_PROG_SER'
    ;
    EXCEPTION WHEN NO_DATA_FOUND 
              THEN P_prog_ser := 0;
  END;

  P_dummy  := 'N';
  P_pagina := 1;
  P_riga   := 1;
  d_dep_ni := 0;

  D_gg_servizio := 0;
  D_anni   := 0;
  D_mesi   := 0;
  D_giorni := 0;

  BEGIN
    FOR DIP IN
       (SELECT rain.ni                       ni
             , i.ci                          ci
             , i.codice_fiscale              cf
             , i.previdenza                  previdenza
          FROM INPDAP i,rapporti_individuali rain
         where i.ci = rain.ci
         ORDER BY rain.ni,rain.ci
       ) LOOP
         IF D_dep_ni = 0 THEN
            D_dep_ni := dip.ni;
         ELSIF D_dep_ni != dip.ni THEN
            D_dep_ni := dip.ni;
            P_riga := 1;
         END IF;
         BEGIN
           FOR SER IN
           (SELECT  pegi.rilevanza                                            rilevanza
                   ,'100'                                                     tipo
                   ,DECODE(DIP.previdenza,'CPDEL',NVL(gest.posizione_cpd,' ')
                                                 ,NVL(gest.posizione_cps,' ')
                          )                                                   ENTE
                   ,SUBSTR('Servizio '||gest.nome,1,50)                       descrizione
                   ,greatest(PEGI.dal,COST.dal)                               dal
                   ,least(NVL(PEGI.al,SYSDATE),nvl(COST.al,to_date('3333333','j')))          al
                   ,DECODE( PEGI.tipo_rapporto
                          ,'TD' ,'Tempo Definito'
                                ,DECODE( NVL( PEGI.ore,cost.ore_lavoro)
                                       ,cost.ore_lavoro ,'Tempo Pieno'
                                                        ,'Part - Time'
                                       )
                          )                                                   tipologia
                   ,decode( nvl( pegi.ore,cost.ore_lavoro)
                          , cost.ore_lavoro,0
                                           ,NVL(round(PEGI.ore/decode(cost.ore_lavoro,0,1,cost.ore_lavoro)*100,2),0)
                          )                                                   perc_part_time
                   ,DECODE( NVL(PEGI.ore,cost.ore_lavoro)/decode(cost.ore_lavoro,0,1,cost.ore_lavoro)
                          ,.5,' '
                          ,1,' '
                            ,TO_CHAR( PEGI.dal,'dd/mm/yyyy'))                 data_decr_part
                   ,DECODE( NVL(PEGI.ore,cost.ore_lavoro)/decode(cost.ore_lavoro,0,1,cost.ore_lavoro)
                          ,.5,' ',1,' ','1')                                  decr_part
                   ,SUBSTR(qus7.mansione||'     ',1,20)                       qualifica
                   ,decode( NVL(PEGI.al,SYSDATE)
                          , NVL(PEGP.al,SYSDATE), NVL(SUBSTR(evra.descrizione,1,20),' ')
                                                , ' ')                        motivo_cess
                   ,decode( PEGI.DAL
                          , PEGP.DAL, NVL(to_char(pegp.numero_del),' ')
                                    , ' ')                                    numero_del_ass
                   ,decode( PEGI.DAL
                          , PEGP.DAL, NVL( TO_CHAR(dela.data,'dd/mm/yyyy'),'          ') 
                                    , ' ')                                    data_del_ass
                   ,decode( PEGI.DAL
                          , PEGP.DAL, NVL(to_char(pegp.anno_del),' ')  
                                    , ' ')                                    anno_del_ass
                   ,decode( PEGI.DAL
                          , PEGP.DAL, NVL(pegp.sede_del,' ')
                                    , ' ')                                    sede_del_ass            
                   ,NVL(TO_CHAR(pegp.numero_posto),' ')                       numero_del_cess
                   ,NVL( TO_CHAR(delc.data,'dd/mm/yyyy'),'          ')        data_del_cess
                   ,NVL(to_char(pegp.anno_posto),' ')                         anno_del_cess
                   ,NVL(pegp.sede_posto,' ')                                  sede_del_cess
                   ,' '                                                       trattenimento
                   ,' '                                                       carico_ente
                   ,' '                                                       serv_gior
                   ,' '                                                       giorni
                   ,' '                                                       data_tratt
              FROM  PERIODI_GIURIDICI                  PEGI
                   ,PERIODI_GIURIDICI                  pegp
                   ,DELIBERE                           dela
                   ,DELIBERE                           delc
                   ,EVENTI_RAPPORTO                    evra
                   ,CONTRATTI_STORICI                  cost
                   ,GESTIONI                           gest
                   ,QUALIFICHE_INPDAP                  qus7
                   ,QUALIFICHE_GIURIDICHE              qugi
             WHERE  PEGI.ci           = DIP.ci
               AND  pegp.ci           = PEGI.ci
               AND  PEGI.rilevanza    = 'Q'
               AND  pegp.rilevanza    = 'P'
               AND  pegp.ci           = PEGI.ci
               and  PEGI.dal         >= nvl(P_dal,to_date('2222222','j'))
               AND  PEGI.dal         >= pegp.dal
               AND  NVL(PEGI.al,TO_DATE('3333333','j'))
                                     <= NVL(pegp.al,TO_DATE('3333333','j'))
               AND  gest.codice       = PEGI.gestione
               AND  pegp.dal         <= SYSDATE
               AND  pegp.sede_del     = dela.sede          (+)
               AND  pegp.anno_del     = dela.anno          (+)
               AND  pegp.numero_posto = delc.numero        (+)
               AND  pegp.sede_posto   = delc.sede          (+)
               AND  pegp.anno_posto   = delc.anno          (+)
               AND  pegp.numero_del   = dela.numero        (+)
               AND  evra.codice (+)   = pegp.posizione
               and  qugi.numero       = 
                   (select substr(max(to_char(dal,'yyyymmdd')||qualifica),9)
                      from periodi_giuridici
                     where ci         = DIP.ci
                       and rilevanza  = 'S'
                       and dal       >= pegi.dal
                       and nvl(al,to_date('3333333','j')) <= nvl(pegi.al,to_date('3333333','j'))
                   )
               AND  nvl(PEGI.al,sysdate)    BETWEEN qugi.dal
                                                AND NVL(qugi.al,TO_DATE('3333333','j'))
               AND  cost.contratto    = qugi.contratto
/* inizio modifica del 9/12/2005 */
               and  pegi.dal         <= nvl(cost.al,to_date('3333333','j'))
               and nvl(pegi.al,to_date('3333333','j')) >= cost.dal
/* fine modifica del 9/12/2005 */
--               AND  nvl(PEGI.al,sysdate)    BETWEEN cost.dal
--                                                AND NVL(cost.al,TO_DATE('3333333','j'))
               AND  qus7.contratto_gp4 (+) = qugi.contratto
               AND  qus7.qualifica_gp4 (+) = qugi.codice
               AND  PEGI.dal    BETWEEN nvl(qus7.dal,to_date('2222222','j'))
                                    AND NVL(qus7.al,TO_DATE('3333333','j'))
            UNION
            SELECT  pegi.rilevanza                                            rilevanza
                   ,'100'                                                       tipo
                   ,DECODE(DIP.previdenza,'CPDEL',NVL(gest.posizione_cpd,' ')
                                                 ,NVL(gest.posizione_cps,' ')
                          )                                                   ENTE
                   ,SUBSTR('Servizio '||gest.nome,1,50)                       descrizione
                   ,greatest(PEGI.dal,COST.dal)                               dal
                   ,least(NVL(PEGI.al,SYSDATE),nvl(COST.al,to_date('3333333','j')))          al
                   ,DECODE( PEGI.tipo_rapporto
                          ,'TD' ,'Tempo Definito'
                                ,DECODE( NVL( PEGI.ore,cost.ore_lavoro)
                                       ,cost.ore_lavoro ,'Tempo Pieno'
                                                        ,'Part - Time'
                                       )
                          )                                                   tipologia
                   ,decode( nvl( pegi.ore,cost.ore_lavoro)
                          , cost.ore_lavoro,0
                                           ,NVL(round(PEGI.ore/decode(cost.ore_lavoro,0,1,cost.ore_lavoro)*100,2),0)
                          )                                                   perc_part_time
                   ,DECODE( NVL(PEGI.ore,cost.ore_lavoro)/decode(cost.ore_lavoro,0,1,cost.ore_lavoro)
                          ,.5,' '
                          ,1,' '
                            ,TO_CHAR( PEGI.dal,'dd/mm/yyyy'))                 data_decr_part
                   ,DECODE( NVL(PEGI.ore,cost.ore_lavoro)/decode(cost.ore_lavoro,0,1,cost.ore_lavoro)
                          ,.5,' ',1,' ','1')                                  decr_part
                   ,SUBSTR(qus7.mansione||'     ',1,20)                       qualifica
                   ,decode( NVL(PEGI.al,SYSDATE)
                          , NVL(PEGP.al,SYSDATE), NVL(SUBSTR(evra.descrizione,1,20),' ')
                                                , ' ')                        motivo_cess
                   ,decode( PEGI.DAL
                          , PEGP.DAL, NVL(to_char(pegp.numero_del),' ')
                                    , ' ')                                    numero_del_ass
                   ,decode( PEGI.DAL
                          , PEGP.DAL, NVL( TO_CHAR(dela.data,'dd/mm/yyyy'),'          ') 
                                    , ' ')                                    data_del_ass
                   ,decode( PEGI.DAL
                          , PEGP.DAL, NVL(to_char(pegp.anno_del),' ')  
                                    , ' ')                                    anno_del_ass
                   ,decode( PEGI.DAL
                          , PEGP.DAL, NVL(pegp.sede_del,' ')
                                    , ' ')                                    sede_del_ass            
                   ,NVL(TO_CHAR(pegp.numero_posto),' ')                       numero_del_cess
                   ,NVL( TO_CHAR(delc.data,'dd/mm/yyyy'),'          ')        data_del_cess
                   ,NVL(to_char(pegp.anno_posto),' ')                         anno_del_cess
                   ,NVL(pegp.sede_posto,' ')                                  sede_del_cess
                   ,' '                                                       trattenimento
                   ,' '                                                       carico_ente
                   ,' '                                                       serv_gior
                   ,' '                                                       giorni
                   ,' '                                                       data_tratt
              FROM  PERIODI_GIURIDICI                  PEGI
                   ,PERIODI_GIURIDICI                  pegp
                   ,DELIBERE                           dela
                   ,DELIBERE                           delc
                   ,EVENTI_RAPPORTO                    evra
                   ,CONTRATTI_STORICI                  cost
                   ,GESTIONI                           gest
                   ,QUALIFICHE_GIURIDICHE              qugi  
                   ,QUALIFICHE_INPDAP                  qus7                                     
             WHERE  PEGI.ci           = DIP.ci
               AND  pegp.ci           = PEGI.ci
               AND  PEGI.rilevanza    = 'I'
               AND  pegp.rilevanza    = 'P'
               AND  pegp.ci           = PEGI.ci
               and  PEGI.dal         >= nvl(P_dal,to_date('2222222','j'))
               AND  PEGI.dal         >= pegp.dal
               AND  NVL(PEGI.al,TO_DATE('3333333','j'))
                                     <= NVL(pegp.al,TO_DATE('3333333','j'))
               AND  gest.codice       = PEGI.gestione
               AND  pegp.dal         <= SYSDATE
               AND  pegp.sede_del     = dela.sede          (+)
               AND  pegp.anno_del     = dela.anno          (+)
               AND  pegp.numero_posto = delc.numero        (+)
               AND  pegp.sede_posto   = delc.sede          (+)
               AND  pegp.anno_posto   = delc.anno          (+)
               AND  pegp.numero_del   = dela.numero        (+)
               AND  evra.codice (+)   = pegp.posizione
               and  qugi.numero       = 
                   (select substr(max(to_char(dal,'yyyymmdd')||qualifica),9)
                      from periodi_giuridici
                     where ci         = DIP.ci
                       and rilevanza in ('S','E')
                       and dal       >= pegi.dal
                       and nvl(al,to_date('3333333','j')) <= nvl(pegi.al,to_date('3333333','j'))
                   )
               AND  nvl(PEGI.al,sysdate)  BETWEEN qugi.dal
                                              AND NVL(qugi.al,TO_DATE('3333333','j'))
               AND  cost.contratto    = qugi.contratto
/* inizio modifica del 9/12/2005 */
               and  pegi.dal         <= nvl(cost.al,to_date('3333333','j'))
               and nvl(pegi.al,to_date('3333333','j')) >= cost.dal
/* fine modifica del 9/12/2005 */
--               AND  nvl(PEGI.al,sysdate)  BETWEEN cost.dal
--                                              AND NVL(cost.al,TO_DATE('3333333','j'))
               AND  qus7.contratto_gp4 (+) = qugi.contratto
               AND  qus7.qualifica_gp4 (+) = qugi.codice
               AND  PEGI.dal    BETWEEN nvl(qus7.dal,to_date('2222222','j'))
                                    AND NVL(qus7.al,TO_DATE('3333333','j'))
             UNION
            SELECT  decode(DOGI.scd,'0','D','d')                             rilevanza
                   ,dogi.scd                                                 tipo
                   ,NVL(dogi.presso,' ')                                     ENTE
                   ,SUBSTR(dogi.descrizione,1,50)                            descrizione
                   ,greatest(dogi.dal,cost.dal)                              dal
                   ,least(NVL(dogi.al,SYSDATE),nvl(cost.al,to_date('3333333','j')))         al
                   ,NVL( decode( INSTR(dogi.note,'TIPOLOGIA RAPPORTO: ')
                               , 0, ' '
                                  , SUBSTR( dogi.note
                                          , INSTR(dogi.note,'TIPOLOGIA RAPPORTO: ')+20)
                                )
                       ,' ')                                                 tipologia
                   ,decode( dogi.dato_n1
                          , nvl(dogi.dato_n2,cost.ore_lavoro), 0
                          , NVL(round(dogi.dato_n1/decode( nvl(dogi.dato_n2,cost.ore_lavoro)
                                                         ,0, 1
                                                           , nvl(dogi.dato_n2,cost.ore_lavoro) )*100,2),0) )
                                                                             perc_part_time
                   ,DECODE( NVL(dogi.dato_n1,nvl(dogi.dato_n2,cost.ore_lavoro))
                                /decode(nvl(dogi.dato_n2,cost.ore_lavoro),0,1,nvl(dogi.dato_n2,cost.ore_lavoro))
                          ,.5,' ',1,' ',TO_CHAR( dogi.dal,'dd/mm/yyyy'))     data_decr_part
                   ,DECODE( NVL( dogi.dato_n1,nvl(dogi.dato_n2,cost.ore_lavoro))
                                /decode(nvl(dogi.dato_n2,cost.ore_lavoro),0,1,nvl(dogi.dato_n2,cost.ore_lavoro))
                          ,.5,' ',1,' ','1')                                 decr_part
                   ,NVL(SUBSTR(dogi.dato_a1,1,20),' ')                       qualifica
                   ,NVL(SUBSTR(dogi.dato_a2,1,20),' ')                       motivo_cess
                   ,NVL(to_char(dogi.numero_del),' ')                                   numero_del_ass
                   ,NVL( TO_CHAR(dela.data,'dd/mm/yyyy'),'          ')       data_del_ass
                   ,NVL(to_char(dogi.anno_del),' ')                                      anno_del_ass
                   ,NVL(dogi.sede_del,' ')                                    sede_del_ass 
                   ,' '                                                      numero_del_cess
                   ,'          '                                             data_del_cess
                   ,' '                                                       anno_del_cess
                   ,' '                                                     sede_del_cess
                   ,' '                                                      trattenimento
                   ,' '                                                      carico_ente
                   ,' '                                                      serv_gior
                   ,' '                                                      giorni
                   ,' '                                                      data_tratt
              FROM  DOCUMENTI_GIURIDICI                dogi
                   ,DELIBERE                           dela
                   ,CONTRATTI_STORICI                  cost
             WHERE  dogi.ci           = DIP.ci
               AND  dogi.sede_del     = dela.sede          (+)
               AND  dogi.anno_del     = dela.anno          (+)
               AND  dogi.numero_del   = dela.numero        (+)
               AND  dogi.evento       = 'SSON'
               and  DOGI.dal         >= nvl(P_dal,to_date('2222222','j'))
/* inizio modifica del 9/12/2005 */
               and  dogi.dal         <= nvl(cost.al,to_date('3333333','j'))
               and nvl(dogi.al,to_date('3333333','j')) >= cost.dal
/* fine modifica del 9/12/2005 */
--               AND  dogi.dal    between cost.dal
--                                    and nvl(cost.al,to_date('3333333','j'))
               AND  cost.contratto    =
                   (SELECT contratto
                      FROM RAPPORTI_GIURIDICI
                     WHERE ci     = dogi.ci
                   )
            ORDER BY 5
           ) LOOP
             D_inizio := SER.dal;
             D_fine   := SER.al;

 dbms_output.put_line('Inizio1: '||D_inizio||' Fine1: '||D_fine||' Rilevanza '||SER.rilevanza);

             P_dummy  := 'N';
             BEGIN
               IF SER.rilevanza in ('Q','D','I')  THEN
                  BEGIN
                    SELECT 'S'
                      INTO P_dummy
                      FROM dual
                     WHERE EXISTS
                          (SELECT 'x' FROM PERIODI_GIURIDICI x
                            WHERE ci           = DIP.ci
                                 AND rilevanza = 'A' 
                                 and assenza in (select codice from astensioni 
                                                  where servizio_inpdap = 'S'
                                                    and servizio        = 0)
                                 AND (   dal    BETWEEN SER.dal AND SER.al
                                      or nvl(al,to_date('3333333','j')) BETWEEN SER.dal AND SER.al )
                                 AND not exists
                                    (select 'x' from periodi_giuridici
                                      where ci        = DIP.ci
                                        and rilevanza = 'A' 
                                        and assenza in (select codice from astensioni 
                                                         where servizio_inpdap = 'S'
                                                           and servizio        = 0)
                                        and rowid     != x.rowid
                                        and dal       <= x.dal
                                        and nvl(al,to_date('3333333','j')) >= nvl(x.al,to_date('3333333','j'))
                                    )
                          )
                    ;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                            BEGIN
                              SELECT 'S'
                                INTO P_dummy
                                FROM dual
                               WHERE EXISTS
                                    (SELECT 'x' FROM PERIODI_GIURIDICI x
                                      WHERE ci           = DIP.ci
                                        AND rilevanza    = 'I' 
                                        AND SER.rilevanza != 'I'
                                        AND (   dal    BETWEEN SER.dal AND SER.al
                                             or nvl(al,to_date('3333333','j')) BETWEEN SER.dal AND SER.al )
                                        AND not exists
                                           (select 'x' from periodi_giuridici
                                             where ci        = DIP.ci
                                               and rilevanza = 'I'
                                               and SER.rilevanza != 'I'
                                               and rowid     != x.rowid
                                               and dal       <= x.dal
                                               and nvl(al,to_date('3333333','j')) >= nvl(x.al,to_date('3333333','j'))
                                           )
                                     )
                               ;
                            EXCEPTION WHEN NO_DATA_FOUND THEN P_dummy := 'N';
                            END;
                  END;

 dbms_output.put_line('dummy '||P_dummy);

                  IF P_dummy = 'N' THEN
                     D_gg_servizio := GET_GG_SERVIZIO(D_inizio,D_fine);
                     GET_ANNI_MESI_GG(D_gg_servizio,D_anni,D_mesi,D_giorni);
                     BEGIN
                       INSERT INTO a_appoggio_stampe
                             (no_prenotazione,no_passo,pagina,riga,testo)
                       SELECT prenotazione
                            , 1
                            , P_pagina
                            , P_riga
                            , DIP.cf||
                              '   '||
                              RPAD(P_riga+P_prog_ser,3,' ')||
                              RPAD(SER.tipo,3,' ')||
                              RPAD(SER.ENTE,8,' ')||
                              RPAD(SER.descrizione,50,' ')||
                              LPAD(TO_CHAR(D_inizio,'dd/mm/yyyy'),10,' ')||
                              LPAD(NVL(TO_CHAR(D_fine,'dd/mm/yyyy'),' '),10,' ')||
                              RPAD(D_anni,3,' ')||
                              RPAD(D_mesi,3,' ')||
                              RPAD(D_giorni,3,' ')||
                              RPAD(SER.tipologia,20,' ')||
                              RPAD(translate(SER.perc_part_time,'.',','),6,' ')||
                              LPAD(NVL( SER.data_decr_part,' '),10,' ')||
                              RPAD(SER.decr_part,15,' ')||
                              RPAD(nvl(SER.qualifica,' '),20,' ')||
                              RPAD(SER.motivo_cess,20,' ')||
                              decode( SER.sede_del_ass
                                    ,' ', rpad(' ',11,' ')
                                        , RPAD(SER.sede_del_ass||'-'||
                                               ser.numero_del_ass||'/'||
                                               substr(lpad(ser.anno_del_ass,4,0),3,2)
                                              ,11,' ')
                                    )||
                              LPAD(SER.data_del_ass,10,' ')||
                              decode( SER.sede_del_cess
                                    ,' ', rpad(' ',11,' ')
                                        , RPAD(SER.sede_del_cess||'-'||
                                               ser.numero_del_cess||'/'||
                                               substr(lpad(ser.anno_del_cess,4,0),3,2)
                                              ,11,' ')
                                    )||
                              LPAD(SER.data_del_cess,10,' ')||
                              RPAD(SER.trattenimento,1,' ')||
                              RPAD(SER.carico_ente,1,' ')||
                              RPAD(SER.giorni,1,' ')||
                              rpad(' ',6,' ')||
                              rpad(' ',10,' ')|| 
                              LPAD(to_char(DIP.ci),8,'0')
                         FROM dual
                       ;
                       P_riga := P_riga + 1 ;
                     END;
                  ELSIF P_dummy = 'S' THEN
-- Tratta i periodi di PEGI o DOGI scd O CON assenze
-- dbms_output.put_line('***** PEGI o DOGI scd O CON assenze');
                        BEGIN
 dbms_output.put_line('Inizio '||to_char(D_inizio)||' fine '||to_char(D_fine));

                          D_inizio := SER.dal;
                          D_fine   := SER.al;
                          FOR INC IN
                             (SELECT dal
                                    ,al,rilevanza
                                FROM PERIODI_GIURIDICI x
                               WHERE ci           = DIP.ci
                                 AND rilevanza    = 'A' 
                                 and assenza in (select codice from astensioni 
                                                  where servizio_inpdap = 'S'
                                                    and servizio        = 0)
                                 AND (   dal    BETWEEN SER.dal AND SER.al
                                      or nvl(al,to_date('3333333','j')) BETWEEN SER.dal AND SER.al )
                                 AND not exists
                                    (select 'x' from periodi_giuridici
                                      where ci         = DIP.ci
                                        and rilevanza  = 'A' 
                                        and assenza in (select codice from astensioni 
                                                         where servizio_inpdap = 'S'
                                                           and servizio        = 0)
                                        and rowid     != x.rowid
                                        and dal       <= x.dal
                                        and nvl(al,to_date('3333333','j')) >= nvl(x.al,to_date('3333333','j'))
                                    )
                               UNION
                              SELECT dal
                                    ,al,rilevanza
                                FROM PERIODI_GIURIDICI x
                               WHERE ci           = DIP.ci
                                 AND rilevanza    = 'I'
                                 and SER.rilevanza != 'I' 
                                 AND (   dal    BETWEEN SER.dal AND SER.al
                                      or nvl(al,to_date('3333333','j')) BETWEEN SER.dal AND SER.al )
                                 AND not exists
                                    (select 'x' from periodi_giuridici
                                      where ci         = DIP.ci
                                        and rilevanza  = 'I' 
                                        and SER.rilevanza != 'I' 
                                        and rowid     != x.rowid
                                        and dal       <= x.dal
                                        and nvl(al,to_date('3333333','j')) >= nvl(x.al,to_date('3333333','j'))
                                    )
                               ORDER BY 1
                             ) LOOP

 dbms_output.put_line('Lettura assenze: dal '||to_char(INC.dal)||' al '||to_char(INC.al)||' Ril. '||inc.rilevanza);

                               D_fine := INC.dal - 1;
                               D_gg_servizio := GET_GG_SERVIZIO(D_inizio,D_fine);
                               GET_ANNI_MESI_GG(D_gg_servizio,D_anni,D_mesi,D_giorni);
                               IF D_fine >= D_inizio THEN -- scrive il pezzo di PEGI pre-assenza
                                  BEGIN

dbms_output.put_line('Scrivo su a_appoggio Inizio: '||D_inizio||' Fine: '||D_fine);
-- dbms_output.put_line('Qualifica 2: '||SER.motivo_cess);

                                    INSERT INTO a_appoggio_stampe
                                          (no_prenotazione,no_passo,pagina,riga,testo)
                                    SELECT prenotazione
                                         , 1
                                         , P_pagina
                                         , P_riga
                                         , DIP.cf||
                                           '   '||
                                           RPAD(P_riga+P_prog_ser,3,' ')||
                                           RPAD(SER.tipo,3,' ')||
                                           RPAD(SER.ENTE,8,' ')||
                                           RPAD(SER.descrizione,50,' ')||
                                           LPAD(TO_CHAR(D_inizio,'dd/mm/yyyy'),10,'0')||
                                           LPAD(NVL(TO_CHAR(D_fine,'dd/mm/yyyy'),' '),10,'0')||
                                           RPAD(D_anni,3,' ')||
                                           RPAD(D_mesi,3,' ')||
                                           RPAD(D_giorni,3,' ')||
                                           RPAD(SER.tipologia,20,' ')||
                                           RPAD(translate(SER.perc_part_time,'.',','),6,' ')||
                                           LPAD(NVL( SER.data_decr_part,' '),10,' ')||
                                           RPAD(SER.decr_part,15,' ')||
                                           RPAD(nvl(SER.qualifica,' '),20,' ')||
                                           RPAD(SER.motivo_cess,20,' ')||
                                           decode( SER.sede_del_ass
                                                 ,' ', rpad(' ',11,' ')
                                                     , RPAD(SER.sede_del_ass||'-'||
                                                            ser.numero_del_ass||'/'||
                                                            substr(lpad(ser.anno_del_ass,4,0),3,2)
                                                           ,11,' ')
                                                 )||
                                           LPAD(SER.data_del_ass,10,' ')||
                                           decode( SER.sede_del_cess
                                                  ,' ', rpad(' ',11,' ')
                                                  , RPAD(SER.sede_del_cess||'-'||
                                                         ser.numero_del_cess||'/'||
                                                         substr(lpad(ser.anno_del_cess,4,0),3,2)
                                                        ,11,' ')
                                                 )||
                                           LPAD(SER.data_del_cess,10,' ')||
                                           RPAD(SER.trattenimento,1,' ')||
                                           RPAD(SER.carico_ente,1,' ')||
                                           RPAD(SER.giorni,1,' ')||
                                           rpad(' ',6,' ')||
                                           rpad(' ',10,' ')|| 
                                           LPAD(to_char(DIP.ci),8,'0')
                                      FROM dual
                                    ;
                                    P_riga := P_riga + 1 ;
                                  END;
                               END IF;
                               D_fine   := SER.al;
                               D_inizio := INC.al + 1;
dbms_output.put_line('Esce dal loop INC Inizio: '||D_inizio||' Fine: '||D_fine);

                             END LOOP; -- INC
                             IF D_fine >= D_inizio THEN -- scrive l'ultimo pezzo di PEGI post-assenza
                                D_gg_servizio := GET_GG_SERVIZIO(D_inizio,D_fine);
                                GET_ANNI_MESI_GG(D_gg_servizio,D_anni,D_mesi,D_giorni);
                                BEGIN

dbms_output.put_line('Scrivo su a_appoggio dopo INC Inizio: '||D_inizio||' Fine: '||D_fine);
-- dbms_output.put_line('Qualifica 3: '||SER.motivo_cess);

                                  INSERT INTO a_appoggio_stampe
                                        (no_prenotazione,no_passo,pagina,riga,testo)
                                  SELECT prenotazione
                                       , 1
                                       , P_pagina
                                       , P_riga
                                       , DIP.cf||
                                         '   '||
                                         RPAD(P_riga+P_prog_ser,3,' ')||
                                         RPAD(SER.tipo,3,' ')||
                                         RPAD(SER.ENTE,8,' ')||
                                         RPAD(SER.descrizione,50,' ')||
                                         LPAD(TO_CHAR(D_inizio,'dd/mm/yyyy'),10,'0')||
                                         LPAD(NVL(TO_CHAR(D_fine,'dd/mm/yyyy'),' '),10,'0')||
                                         RPAD(D_anni,3,' ')||
                                         RPAD(D_mesi,3,' ')||
                                         RPAD(D_giorni,3,' ')||
                                         RPAD(SER.tipologia,20,' ')||
                                         RPAD(translate(SER.perc_part_time,'.',','),6,' ')||
                                         LPAD(NVL( SER.data_decr_part,' '),10,' ')||
                                         RPAD(SER.decr_part,15,' ')||
                                         RPAD(nvl(SER.qualifica,' '),20,' ')||
                                         RPAD(SER.motivo_cess,20,' ')||
                                           decode( SER.sede_del_ass
                                                 ,' ', rpad(' ',11,' ')
                                                     , RPAD(SER.sede_del_ass||'-'||
                                                            ser.numero_del_ass||'/'||
                                                            substr(lpad(ser.anno_del_ass,4,0),3,2)
                                                           ,11,' ')
                                                 )||
                                           LPAD(SER.data_del_ass,10,' ')||
                                           decode( SER.sede_del_cess
                                                  ,' ', rpad(' ',11,' ')
                                                  , RPAD(SER.sede_del_cess||'-'||
                                                         ser.numero_del_cess||'/'||
                                                         substr(lpad(ser.anno_del_cess,4,0),3,2)
                                                        ,11,' ')
                                                 )||
                                           LPAD(SER.data_del_cess,10,' ')||
                                           RPAD(SER.trattenimento,1,' ')||
                                           RPAD(SER.carico_ente,1,' ')||
                                           RPAD(SER.giorni,1,' ')||
                                           rpad(' ',6,' ')||
                                           rpad(' ',10,' ')|| 
                                           LPAD(to_char(DIP.ci),8,'0')
                                    FROM dual
                                  ;
                                  P_riga := P_riga + 1 ;
                                END;
                             END IF;
                             END;
               END IF;
               ELSE
-- Tratta i periodi di DOGI scd != O
-- dbms_output.put_line('***** Documenti Giuridici scd no O');
               D_inizio := SER.dal;
               D_fine   := SER.al;
               D_gg_servizio := GET_GG_SERVIZIO(D_inizio,D_fine);
               GET_ANNI_MESI_GG(D_gg_servizio,D_anni,D_mesi,D_giorni);
             BEGIN
-- dbms_output.put_line('Scrivo su a_appoggio Inizio: '||D_inizio||' Fine: '||D_fine);
-- dbms_output.put_line('Tipologia DOGI: '||SER.tipologia);
dbms_output.put_line('Qualifica 4: '||SER.motivo_cess);
           INSERT INTO a_appoggio_stampe
           (no_prenotazione,no_passo,pagina,riga,testo)
           SELECT prenotazione
                , 1
                , P_pagina
                , P_riga
                , DIP.cf||
                  '   '||
                  RPAD(P_riga+P_prog_ser,3,' ')||
                  RPAD(SER.tipo,3,' ')||
                  RPAD(SER.ENTE,8,' ')||
                  RPAD(SER.descrizione,50,' ')||
                  LPAD(TO_CHAR(D_inizio,'dd/mm/yyyy'),10,'0')||
                  LPAD(NVL(TO_CHAR(D_fine,'dd/mm/yyyy'),' '),10,'0')||
                  RPAD(D_anni,3,' ')||
                  RPAD(D_mesi,3,' ')||
                  RPAD(D_giorni,3,' ')||
                  RPAD(SER.tipologia,20,' ')||
                  RPAD(translate(SER.perc_part_time,'.',','),6,' ')||
                  LPAD(NVL( SER.data_decr_part,' '),10,' ')||
                  RPAD(SER.decr_part,15,' ')||
                  RPAD(nvl(SER.qualifica,' '),20,' ')||
                  RPAD(SER.motivo_cess,20,' ')||
                  decode( SER.sede_del_ass
                        ,' ', rpad(' ',11,' ')
                            , RPAD(SER.sede_del_ass||'-'||
                                   ser.numero_del_ass||'/'||
                                   substr(lpad(ser.anno_del_ass,4,0),3,2)
                                  ,11,' ')
                        )||
                  LPAD(SER.data_del_ass,10,' ')||
                  decode( SER.sede_del_cess
                        ,' ', rpad(' ',11,' ')
                            , RPAD(SER.sede_del_cess||'-'||
                                   ser.numero_del_cess||'/'||
                                   substr(lpad(ser.anno_del_cess,4,0),3,2)
                                  ,11,' ')
                                  )||
                  LPAD(SER.data_del_cess,10,' ')||
                  RPAD(SER.trattenimento,1,' ')||
                  RPAD(SER.carico_ente,1,' ')||
                  RPAD(SER.giorni,1,' ')||
                  rpad(' ',6,' ')||
                  rpad(' ',10,' ')|| 
                  LPAD(to_char(DIP.ci),8,'0')
             FROM dual
           ;
           P_riga := P_riga + 1 ;
             END;
                      END IF;
             END;
             END LOOP; -- SER
           P_pagina := P_pagina + 1;
--         P_riga   := 1           ;
         END;
         END LOOP; -- DIP
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
END;
END;
END;
/
