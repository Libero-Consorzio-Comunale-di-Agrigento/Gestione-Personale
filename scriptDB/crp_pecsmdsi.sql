CREATE OR REPLACE PACKAGE PECSMDSI IS
/******************************************************************************
 NOME:        PECSMDSI
 DESCRIZIONE:                
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  06/03/2006 MS     Prima Emissione ( revisione CUD 2006 ) 
 1.1  10/03/2006 MS     Correzioni varie
 1.2  31/05/2006 MS     Aggiunto controllo per regime agevolato
 1.3  28/02/2007 MS     Sistemazione regime agevolato
 2.0  02/04/2007 MS     Gestione stampa da tabella archiviata ( Att. 19919 )
 2.1  27/09/2007 MS     Correzione per invalid number sul report
******************************************************************************/
FUNCTION  VERSIONE             RETURN VARCHAR2;
FUNCTION  STAMPA_VALORE 
( P_segno  in varchar2
, P_valore in number
) RETURN VARCHAR2;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, passo IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECSMDSI IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V2.1 del 27/09/2007';
END VERSIONE;
FUNCTION  STAMPA_VALORE 
( P_segno  in varchar2
, P_valore in number
) RETURN VARCHAR2 IS
P_stringa_stampa varchar2(16) := lpad('0',16,'0');
BEGIN
  BEGIN
    select decode( P_segno
                  , 'X',lpad(nvl(to_char(abs(nvl(P_valore,0))),'0'),16,'0')
                       , decode(sign(nvl(P_valore,0))
                               , -1, '-'||lpad(nvl(to_char(abs(nvl(P_valore,0))),'0'),15,'0')
                                        , lpad(nvl(to_char(nvl(P_valore,0)),'0'),16,'0')
                                )
                 )
     into P_stringa_stampa
     from dual;  
   END;
 RETURN P_stringa_stampa;
END;

PROCEDURE main (prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
DECLARE
--
-- Depositi e Contatori Vari
--
  D_ente            VARCHAR2(4);
  D_ambiente        VARCHAR2(8);
  D_utente          VARCHAR2(8);
  D_ci              number := null;  
  D_r1              varchar2(20);
  D_filtro_1        varchar2(15);
  D_segno           varchar2(1);
  D_pagina          number := 0;
  D_riga            number := 0;
  D_perc_irpef      INFORMAZIONI_EXTRACONTABILI.PERC_IRPEF_ORD%TYPE;
  D_lordo           NUMBER(15,5);
  D_no_sogg_rc      NUMBER(15,5);
  D_no_sogg         NUMBER(15,5);
  D_ipn_ord         NUMBER(15,5);
  D_ipt_acconto     NUMBER(15,5);
  D_alq_ac          NUMBER(4,2);
  D_c_inps          NUMBER(15,5);
  D_r_inps          NUMBER(15,5);
  D_r_enpam         NUMBER(15,5);
  D_reg_agevolato   NUMBER(15,5);
  D_altre_rit       NUMBER(15,5);

--
-- Variabili di Periodo
--
  D_anno            number;
  D_ini_a           date;
  D_fin_a           date;

BEGIN

--
-- Lettura parametri
--
   BEGIN  -- Estrazione Parametri di Selezione della Prenotazione
      BEGIN
      select substr(valore,1,4)
           , to_date('01'||substr(valore,1,4),'mmyyyy')
           , to_date('3112'||substr(valore,1,4),'ddmmyyyy')
        into D_anno,D_ini_a,D_fin_a
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_ANNO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              select anno
                   , to_date('01'||to_char(anno),'mmyyyy')
                   , to_date('3112'||to_char(anno),'ddmmyyyy')
                into D_anno,D_ini_a,D_fin_a
                from riferimento_fine_anno
               where rifa_id = 'RIFA';
      END;
      BEGIN
      select substr(valore,1,15)
        into D_filtro_1
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_FILTRO_1'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_filtro_1 := '%';
      END;

      BEGIN
      select substr(valore,1,1)
        into D_segno
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_SEGNO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_segno := null;
      END;
      
      BEGIN
      select valore
        into D_ci
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_CI'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_ci := null;
      END;

     BEGIN
      SELECT ENTE     D_ente
           , utente   D_utente
           , ambiente D_ambiente
        INTO D_ente,D_utente,D_ambiente
        FROM a_prenotazioni
       WHERE no_prenotazione = prenotazione
      ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             D_ente     := NULL;
             D_utente   := NULL;
             D_ambiente := NULL;
      END;

      BEGIN
      select upper(chiave)
        into D_r1
        from relazione_chiavi_estrazione
       where estrazione = 'FINE_ANNO'
         and sequenza = 1
      ;
      END;
   END;
    FOR CUR_RPFA IN 
       ( select distinct  rpfa.ci      ci
                        , rpfa.c1      c1
                        , rain.ni      ni
                        , rpfa.c5      c5
                        , rpfa.c6      c6
           from report_fine_anno           rpfa
              , rapporti_individuali       rain
              , classi_rapporto            clra
          where rpfa.anno  = D_anno
            and rpfa.ci    = nvl(D_ci,rpfa.ci)
            and nvl(rpfa.c1,' ') like nvl(upper(D_filtro_1),'%')
            and rain.ci  = rpfa.ci
            and clra.codice = rain.rapporto
            and clra.cat_fiscale in ('3','4')
            and not exists ( select 'x' 
                               from rapporti_diversi radi
                              where radi.ci_erede = rpfa.ci
                                and radi.rilevanza in ('L','R')
                                and radi.anno = D_anno
                           )
            and exists
               (select 'x'
                  from rapporti_individuali rain
                 where rain.ci = rpfa.ci
                   and (   rain.cc is null
                        or exists
                          (select 'x'
                             from a_competenze
                            where ente        = D_ente
                              and ambiente    = D_ambiente
                              and utente      = D_utente
                              and competenza  = 'CI'
                              and oggetto          = rain.cc
                          )
                       )
                 )
            and exists (select 'x' 
                          from denuncia_fiscale_autonomi defa
                         where defa.anno      = rpfa.anno
                           and defa.ci = rpfa.ci
                         group by defa.ci
                        having nvl(sum(defa.lordo),0) != 0
                      )
     order by rpfa.c5, rpfa.c6
     ) LOOP

     D_pagina := nvl(D_pagina,0) + 1;
     D_riga   := 1;
--
--  Inserimento Primo Record Dipendente
--
       insert into a_appoggio_stampe
       ( no_prenotazione, no_passo, pagina, riga, testo )
        values ( prenotazione
               , 1
               , D_pagina
               , D_riga
               , lpad(to_char(CUR_RPFA.ci),10,'0')||
                 rpad(D_r1,20,' ')||
                 rpad(nvl(CUR_RPFA.c1,' '),15,' ')||
                 lpad(to_char(CUR_RPFA.ni),8,'0')
               )
       ;
       commit;
-- 
-- Estrazione percentuale fissa da INEX
-- 
           BEGIN
            select perc_irpef_ord   
              into D_perc_irpef
              from informazioni_extracontabili
             where anno  = D_anno
               and ci    = CUR_RPFA.ci
            ;
           EXCEPTION WHEN NO_DATA_FOUND THEN
                D_perc_irpef := null;
           END;
-- 
-- Estrazione Percentuale da PRFI
-- 
           BEGIN
            select max(decode( D_perc_irpef
                             , null, null
                                   , prfi.alq_ac ))
              into D_alq_ac
              from progressivi_fiscali prfi
             where prfi.anno         = D_anno
               and prfi.mese         = 12
               and prfi.mensilita in ( select max(mensilita)
                                         from mensilita
                                        WHERE mese = 12
                                          AND tipo IN ('N','A','S')
                                     )
               and prfi.ci = CUR_RPFA.ci
            ;
           EXCEPTION WHEN NO_DATA_FOUND THEN
                  D_alq_ac := null;
           END;
           
-- 
-- Estrazione Estrazione dati da DEFA
-- 
           BEGIN
            select sum( nvl(defa.lordo,0))
                 , sum( nvl(defa.no_sogg_rc,0)) 
                 , sum( nvl(defa.no_sogg,0) )
                 , sum( nvl(defa.imponibile,0) )
                 , sum( nvl(defa.rit_acconto,0) )
                 , sum( nvl(defa.prev_erogante,0) )
                 , sum( nvl(defa.prev_lavoratore,0) )
                 , sum( nvl(defa.prev_enpam,0) )
                 , sum( nvl(defa.reg_agevolato,0) )
                 , sum( nvl(defa.altre_rit,0) )
              into D_lordo
                 , D_no_sogg_rc
                 , D_no_sogg
                 , D_ipn_ord
                 , D_ipt_acconto
                 , D_c_inps
                 , D_r_inps
                 , D_r_enpam
                 , D_reg_agevolato
                 , D_altre_rit
              from DENUNCIA_FISCALE_AUTONOMI defa
             where defa.anno         = D_anno
               and defa.ci = CUR_RPFA.ci
            ;
           EXCEPTION WHEN NO_DATA_FOUND THEN
                  D_lordo         := null;
                  D_no_sogg_rc    := null;
                  D_no_sogg       := null;
                  D_ipn_ord       := null;
                  D_ipt_acconto   := null;
                  D_c_inps        := null;
                  D_r_inps        := null;
                  D_r_enpam       := null;
                  D_reg_agevolato := null;
                  D_altre_rit     := null;
          END;

      IF nvl(D_lordo,0) + nvl(D_no_sogg_rc,0) + nvl(D_no_sogg,0) + nvl(D_ipn_ord,0)
       + nvl(D_ipt_acconto,0) + nvl(D_c_inps,0) + nvl(D_r_inps,0) != 0 THEN
--
--  Inserimento Dati Dipendente
--
       D_riga := 2;

       insert into a_appoggio_stampe
       ( no_prenotazione, no_passo, pagina, riga, testo )
        values ( prenotazione
               , 1
               , D_pagina
               , D_riga
               , rpad('TOTALE',15,' ')
               ||PECSMDSI.STAMPA_VALORE( D_segno,  D_lordo )
               ||rpad('NO_SOGG',15,' ')
               ||PECSMDSI.STAMPA_VALORE( D_segno, D_no_sogg )
               ||rpad('SOGG_ENPAM',15,' ')
               ||PECSMDSI.STAMPA_VALORE( D_segno, D_r_enpam )
               ||rpad('SOGG_INPS',15,' ')
               ||PECSMDSI.STAMPA_VALORE( D_segno, D_r_inps )
               ||rpad('ALTRE_RIT',15,' ')
               ||PECSMDSI.STAMPA_VALORE( D_segno, D_altre_rit )
               ||rpad('IPN_ORD',15,' ')
               ||PECSMDSI.STAMPA_VALORE( D_segno, D_ipn_ord )
               ||rpad('ALQ_ORD',15,' ')
               ||PECSMDSI.STAMPA_VALORE( D_segno, D_alq_ac )
               ||rpad('IPT_ORD',15,' ')
               ||PECSMDSI.STAMPA_VALORE( D_segno, D_ipt_acconto )
               ||rpad('NETTO',15,' ')
               ||decode( nvl(D_ipn_ord,0) 
                        ,0, lpad('0',16,' ')
                          , PECSMDSI.STAMPA_VALORE( D_segno, ( nvl( D_ipn_ord,0 ) - nvl(D_ipt_acconto,0) ))
                       )
               ||rpad('NETTO_PAG',15,' ')
               ||PECSMDSI.STAMPA_VALORE( D_segno, ( nvl( D_lordo,0 ) - nvl(D_ipt_acconto,0) - nvl(D_r_inps,0) - nvl(D_r_enpam,0) - nvl(D_altre_rit,0) ) )
               ||rpad('NOTA_INPS',15,' ')
               ||PECSMDSI.STAMPA_VALORE( D_segno, D_c_inps )
               );
       commit;
      END IF;
     END LOOP; -- CUR_RPFA
 end;
END;
END PECSMDSI;
/
