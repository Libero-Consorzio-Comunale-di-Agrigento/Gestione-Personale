CREATE OR REPLACE PACKAGE PECSMDMA IS
/******************************************************************************
 NOME:          PECSMDMA CREAZIONE SUPPORTO MAGNETICO DMA
 DESCRIZIONE:
      Questa fase stampa una elenco dei dipiendenti per il mese richiesto.
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI: Il PARAMETRO D_anno indica l'anno di riferimento della denuncia
              da elaborare.
              Il PARAMETRO D_mese indica il mese di riferimento della denuncia
              da elaborare.
              Il PARAMETRO D_gestione indica la gestione da elaborare.
 REVISIONI.
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    02/12/2004 GM     Prima Emissione
 1.1  23/02/2005 ML     Modificata la formattazione degli importi se valore 0 o null
 1.2  24/02/2004 ML     Aggiunti nuovi tipi rapporti per la totalizzazione delle caselle 7 e 8.
                        Inverita l'estrazione delle caselle B25 e A26
 1.3  30/03/2005 ML     Gestione nome file.txt con codice_fiscale_gestione||mese_anno.txt
 1.4  26/04/2005 AM     mod. la verisone per identificare chiaramente la patch 4.8.6
 1.5  02/05/2005 AM     sistemato periodo di riferimento con lpad
 1.6  04/05/2005 ML     Gestione intermediari
 1.7  05/05/2005 ML     Gestione cambio tipologia di fine servizio (deve creare due anagrafiche)
 1.8  05/05/2005 ML     Gestione quote personale non presente in denuncia_dma (ma solo denuncia_dma_quote)
 1.9  09/05/2005 ML     Modificata estrazione tipo_aliquota in CUR_TOT fondo credito
 2.0  09/05/2005 ML     Gestione frontespizi diversi in caso di dip. appartenenti ad altre amministrazioni
 2.1  25/05/2005 AM     Mod. il formato nella funzione format_dati per indicare sempre i decimali anche se
                        a zero; trattato anche separatore spazio sul nr. tel. e nr. fax
 2.2  27/05/2005 ML     Modificata estrazione tipo_aliquota in CUR_TOT previdenza (A11396)
	                Modificate having CUR_TOT, sostituito + con or. (A11412)
 2.3  30/05/2005 ML     Modificata estrazione riferimento in CUR_TOT per parametro tardivo = X (A11369)
 2.4  09/06/2005 ML     Attivazione ore riduzione personale scolastico (A11079)
 2.5  17/06/2005 ML     Modificato cursore GEST_APP, creava un frontespizio per ogni gestione anche a parita di
	  	        codice fiscale (A11725); estrazione comparto / sottocomparto sulla select dei dipendenti
 2.6  21/07/2005 ML     Gestione parametro P_forza_credito (A12015)
 2.7  25/07/2005 ML     Nuovi messaggi di errore relativi alla gestione
 2.8  24/08/2005 ML     Gestione invii multipli (A12373)
 2.9  22/09/2005 ML     Modifica condizioni select per totali quote (A12612).
 2.10 14/11/2005 ML     Sostituito gli spazi con 0 in tutte le occorrenza del campo "codice identificativo INPDAP" (A13467)
 2.11 15/11/2005 ML     Modificato CUT_TOT per totalizzazione errata della colonna T22 contr.solid.l166  (A13477)
 2.12 07/12/2005 ML     Modificata causale variazione in caso di parametro tardivo attivato (A13405).
 2.13 08/02/2006 ML     Modificata totalizzazione F1 con caratteristiche diverse da DDMA (A14686).
 2.14 14/02/2006 ML     Modificato allineamento campi progressivo inpdap e forma giuridica (A14875 - A14876).
 2.15 24/02/2006 ML     Aggiunto parametro per numero record invio file multipli (A14978).
 2.16 23/06/2006 ML     Doppia scrittura dei totali per semplificare la stampa (A16420).
 2.17 18/08/2006 ML     Modifica scrittura passo 99 in caso gestione_app per errore di indice doppio (A17155).
 2.18 13/10/2006 ML     Aggiunta riga 0 al passo 99 per indicazione parte totale in caso di file multipli (A18070).
 3.0  22/02/2007 ML     Migliorie per la lettura della gestione (A16441).
 3.1  30/05/2007 ML     Modifiche al controllo firmatario DMA (A21392).
 3.2  18/06/2007 ML     Migliorie per la lettura della gestione (A16441.0.1 - A16441.0.2 - 21392.0.1)).
 3.3  03/07/2007 ML     Emissione record Z2 :: Beta :: (A21749).
 3.4  11/07/2007 ML     Emissione record Z2 (A21942)
 3.5  27/07/2007 ML     Emissione record Z2 - sistemazione difetti da test (A21942.1.0)
 3.6  14/08/2007 ML     Emissione record Z2 - sistemazione difetti da test (A21942.1.1)
 3.7  21/08/2007 ML     Segnalazione per superamento 15 file (A21942.6.0)
 3.8  10/10/2007 ML     Gestione segnalazione P00105 - non esistono registrazioni da elaborare (A23154)
 3.9  31/10/2007 ML     Gestione distacchi funzionali (A23457)
******************************************************************************/
FUNCTION  VERSIONE                        RETURN VARCHAR2;
FUNCTION  FORMAT_DATI (P_importo number)  RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES (FORMAT_DATI, WNDS, WNPS);
 PROCEDURE MAIN  (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
 PROCEDURE INS_A ( PRENOTAZIONE IN NUMBER
                 , ins_invio     in NUMBER
                 , ins_prog      in NUMBER
                 , ins_anno      in NUMBER
                 , ins_cf_inte   in VARCHAR2
                 , ins_gest_cf   in VARCHAR2
                 , ins_tot_invii in NUMBER
                 );
 PROCEDURE INS_B ( PRENOTAZIONE IN NUMBER
                 , ins_invio    in NUMBER
                 , ins_pagina   in NUMBER
                 , ins_gest_cf  in VARCHAR2
                 , ins_gest_pr  IN NUMBER
                 , ins_app_cf   in VARCHAR2
                 , ins_attivita in VARCHAR2
                 , ins_forma    in NUMBER
                 , ins_cf_software in VARCHAR2
                 , ins_periodo  in VARCHAR2
                 , ins_gest_nome in VARCHAR2
                 , ins_gest_cat  in VARCHAR2
                 , ins_gest_ind_res in VARCHAR2
                 , ins_gest_cap     in VARCHAR2
                 , ins_gest_tel_res in VARCHAR2
                 , ins_gest_fax_res in VARCHAR2
                 , ins_gest_mail in VARCHAR2
                 , ins_app_nome in VARCHAR2
                 , ins_app_cat  in VARCHAR2
                 , ins_app_ind_res in VARCHAR2
                 , ins_app_cap     in VARCHAR2
                 , ins_app_tel_res in VARCHAR2
                 , ins_app_fax_res in VARCHAR2
                 , ins_app_mail in VARCHAR2
                 , ins_cf_fir   in VARCHAR2
                 , ins_cognome_fir in VARCHAR2
                 , ins_nome_fir    in VARCHAR2
                 , ins_sesso_fir   in VARCHAR2
                 , ins_dn_fir      in VARCHAR2
                 , ins_com_fir     in VARCHAR2
                 , ins_prov_fir    in VARCHAR2
                 , ins_num_inpdap  in NUMBER
                 , ins_data_inte   in VARCHAR2
                 , ins_cf_inte     in VARCHAR2
                 );
 PROCEDURE TOTALI ( PRENOTAZIONE    IN NUMBER
                  , tot_invio       in NUMBER
                  , tot_progr_invio in NUMBER
                  , tot_pagina      in out NUMBER
                  , tot_riga        in out NUMBER
                  , tot_pagina_b    in NUMBER
                  , tot_conta_c     in NUMBER
                  , tot_conta_d     in NUMBER
                  , tot_num_ord     in NUMBER
                  , tot_tardivo     in VARCHAR2
                  , tot_anno        in NUMBER
                  , tot_mese        in NUMBER
                  , tot_gest_cf     in VARCHAR2
                  , tot_progr       in NUMBER
                  , tot_app_cf      in VARCHAR2
                  , tot_num_b       in NUMBER
                  , tot_parte       in NUMBER
                  );
PROCEDURE TOTALI_Z2 ( PRENOTAZIONE  IN NUMBER
                    , tot_invio     in NUMBER
                    , tot_pagina    in out NUMBER
                    , tot_riga      in out NUMBER
                    , tot_pagina_b  in NUMBER
                    , tot_num_ord   in NUMBER
                    , tot_anno      in NUMBER
                    , tot_mese      in NUMBER
                    , tot_gest_cf   in VARCHAR2
                    , tot_progr     in NUMBER
                    , tot_app_cf    in VARCHAR2
                    , tot_num_b     in NUMBER
                    , tot_z2        in out NUMBER
                    );
END;
/
CREATE OR REPLACE PACKAGE BODY PECSMDMA IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
  BEGIN
    RETURN 'V3.9 del 31/10/2007';
  END VERSIONE;
 FUNCTION FORMAT_DATI (P_importo number) RETURN VARCHAR2 IS
    P_dato varchar2(16);
  BEGIN
    select decode( nvl(P_importo,0)
                 , 0, lpad(' ',16,' ')
                    , decode(trunc(P_importo)
                            , 0, decode( sign(P_importo)
                                       , -1, lpad('-0,'||nvl(lpad(to_char(abs(P_importo)*100),2,'0'),' '),16,' ')
                                           , lpad('0,'||nvl(lpad(to_char(P_importo*100),2,'0'),' '),16,' '))
                               , lpad(nvl(translate(to_char(P_importo,'999999999999.99'),'.',','),' '),16,' ')
                            )
                 )
       into P_dato
       from dual;
    RETURN P_dato;
  END FORMAT_DATI;
 PROCEDURE INS_A ( PRENOTAZIONE  in NUMBER
                 , ins_invio     in NUMBER
                 , ins_prog      in NUMBER
                 , ins_anno      in NUMBER
                 , ins_cf_inte   in VARCHAR2
                 , ins_gest_cf   in VARCHAR2
                 , ins_tot_invii in NUMBER
                 ) IS
   BEGIN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
      values ( prenotazione
             , ins_invio
        		 , 0
         		 , 1 -- riga fissa ad 1 per il record di tipo A
        		 , 'A'||
               rpad(' ',14,' ')||
               rpad('INP'||substr(ins_anno,3,4),5,' ')||
               decode(ins_cf_inte
                     , null, '01'
                           , '10')||
               rpad(decode( ins_cf_inte
                          , null, nvl(ins_gest_cf,' ')
                                , ins_cf_inte)
                   ,16,' ')||
               rpad(' ',483,' ')||
               decode( ins_tot_invii
                     , 1, lpad('0',4,'0')
                        , lpad(to_char(ins_prog),4,'0')
                     )||
               decode( ins_tot_invii
                     , 1, lpad('0',4,'0')
                        , lpad(to_char(ins_tot_invii),4,'0')
                     )||
               rpad(' ',100,' ')||
               rpad(' ',668,' ')||
               rpad(' ',400,' ')||
               rpad(' ',200,' ')||
			      'A'||
               lpad(' ',2,' ')
				  )
      ;
 END INS_A;
 PROCEDURE INS_B ( PRENOTAZIONE in NUMBER
                 , ins_invio    in NUMBER
                 , ins_pagina   in NUMBER
                 , ins_gest_cf  in VARCHAR2
                 , ins_gest_pr  IN NUMBER
                 , ins_app_cf   in VARCHAR2
                 , ins_attivita in VARCHAR2
                 , ins_forma    in NUMBER
                 , ins_cf_software in VARCHAR2
                 , ins_periodo  in VARCHAR2
                 , ins_gest_nome in VARCHAR2
                 , ins_gest_cat  in VARCHAR2
                 , ins_gest_ind_res in VARCHAR2
                 , ins_gest_cap     in VARCHAR2
                 , ins_gest_tel_res in VARCHAR2
                 , ins_gest_fax_res in VARCHAR2
                 , ins_gest_mail in VARCHAR2
                 , ins_app_nome in VARCHAR2
                 , ins_app_cat  in VARCHAR2
                 , ins_app_ind_res in VARCHAR2
                 , ins_app_cap     in VARCHAR2
                 , ins_app_tel_res in VARCHAR2
                 , ins_app_fax_res in VARCHAR2
                 , ins_app_mail in VARCHAR2
                 , ins_cf_fir   in VARCHAR2
                 , ins_cognome_fir in VARCHAR2
                 , ins_nome_fir    in VARCHAR2
                 , ins_sesso_fir   in VARCHAR2
                 , ins_dn_fir      in VARCHAR2
                 , ins_com_fir     in VARCHAR2
                 , ins_prov_fir    in VARCHAR2
                 , ins_num_inpdap  in NUMBER
                 , ins_data_inte   in VARCHAR2
                 , ins_cf_inte     in VARCHAR2
                 ) IS
  BEGIN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
  		values ( prenotazione
		         , ins_invio
    		         , ins_pagina
                         , 1
 		         , 'B'||
               rpad(ins_gest_cf,11,' ')||
               lpad(nvl(to_char(ins_gest_pr),'0'),5,'0')||
               lpad('1',8,'0')||
               rpad(' ',7,' ')||
               rpad(ins_app_cf,11,' ')||
               rpad(ins_gest_cf,11,' ')||
               lpad(nvl(to_char(ins_gest_pr),'0'),5,'0')||
               rpad(' ',7,' ')||
               rpad(nvl(ins_attivita,' '),5,' ')||
               rpad(nvl(ins_attivita,' '),5,' ')||
               lpad(nvl(to_char(ins_forma),'  '),2,'0')||
               rpad(nvl(ins_cf_software,' '),11,' ')||
               rpad(' ',1,' ')|| -- filler
               lpad(nvl(ins_periodo,' '),6,'0')||
               rpad(ins_gest_nome,60,' ')||  -- amministrazione/ente di dichiarante
               rpad(nvl(ins_gest_cat,' '),4,' ')||
               rpad(nvl(ins_gest_ind_res,' '),60,' ')||
               lpad(nvl(ins_gest_cap,' '),5,'0')||
               rpad(nvl(ins_gest_tel_res,' '),12,' ')||
               rpad(nvl(ins_gest_fax_res,' '),12,' ')||
               rpad(nvl(ins_gest_mail,' '),100,' ')||
               rpad(ins_app_nome,60,' ')||  -- amministrazione/ente di appartenenza
               rpad(nvl(ins_app_cat,' '),4,' ')||
               rpad(nvl(ins_app_ind_res,' '),60,' ')||
               lpad(nvl(ins_app_cap,' '),5,'0')||
               rpad(nvl(ins_app_tel_res,' '),12,' ')||
               rpad(nvl(ins_app_fax_res,' '),12,' ')||
               rpad(nvl(ins_app_mail,' '),100,' ')||
               rpad(ins_gest_nome,60,' ')||  -- sede di servizio
               rpad(nvl(ins_gest_cat,' '),4,' ')||
               rpad(nvl(ins_gest_ind_res,' '),60,' ')||
               lpad(nvl(ins_gest_cap,' '),5,'0')||
               rpad(nvl(ins_gest_tel_res,' '),12,' ')||
               rpad(nvl(ins_gest_fax_res,' '),12,' ')||
               rpad(nvl(ins_gest_mail,' '),100,' ')||
               rpad(nvl(ins_cf_fir,' '),16,' ')||  -- dati relativi al rappresentante firmatario
               rpad(nvl(ins_cognome_fir,' '),24,' ')||
               rpad(nvl(ins_nome_fir,' '),20,' ')||
               rpad(nvl(ins_sesso_fir,' '),1,' ')||
               rpad(nvl(ins_dn_fir,' '),8,' ')||
               rpad(nvl(ins_com_fir,' '),40,' ')||
               rpad(nvl(ins_prov_fir,' '),2,' ')||
               '1'||
               lpad(nvl(to_char(ins_num_inpdap),' '),8,'0')||
               lpad('0',8,'0')||  -- Numero di prospetti Z1. Il dato non lo conosciamo in questo momento provvederemo con un'aupdate
               lpad('0',8,'0')||
               lpad('0',8,'0')||
               rpad(nvl(ins_cf_inte,' '),16,' ')||
               rpad(decode(ins_cf_inte,null,' ','1'),1,' ')||
               rpad(' ',1,' ')||
               rpad(nvl(ins_data_inte,' '),8,' ')||
               rpad(decode(ins_cf_inte,null,' ','1'),1,' ')||
               rpad(' ',1,' ')||
               rpad(' ',1,' ')||
               lpad(' ',8,' ')||
               lpad(' ',8,' ')||
               lpad(' ',8,' ')||
               lpad(' ',8,' ')||
               rpad(' ',760,' ')||
               rpad(' ',23,' ')||
               rpad(' ',20,' ')||
               rpad(' ',34,' ')||
               'A'||
               lpad(' ',2,' ')
				  )
      ;
  END INS_B;
 PROCEDURE TOTALI ( PRENOTAZIONE    in NUMBER
                  , tot_invio       in NUMBER
                  , tot_progr_invio in NUMBER
                  , tot_pagina      in out NUMBER
                  , tot_riga        in out NUMBER
                  , tot_pagina_b    in NUMBER
                  , tot_conta_c     in NUMBER
                  , tot_conta_d     in NUMBER
                  , tot_num_ord     in NUMBER
                  , tot_tardivo     in VARCHAR2
                  , tot_anno        in NUMBER
                  , tot_mese        in NUMBER
                  , tot_gest_cf     in VARCHAR2
                  , tot_progr       in NUMBER
                  , tot_app_cf      in VARCHAR2
                  , tot_num_b       in NUMBER
                  , tot_parte       in NUMBER
                  ) IS
 BEGIN
   DECLARE
     TOT_conta_d  number;
     TOT_num_ord  number;
--     D_t031       number;
--     D_t032       number;
--     D_t033       number;
--     D_t034       number;
--     D_t035       number;
--     D_t036       number;
--     D_t037       number;
     BEGIN
--dbms_output.put_line('1 tot_invio '||to_char(tot_invio)||' tot_num_b '||to_char(tot_num_b));
--dbms_output.put_line('1 tot_gest_cf '||tot_gest_cf||' tot_app_cf '||tot_app_cf);
        tot_riga    := 0;
        tot_conta_d := 0;
        tot_num_ord := 0;
--dbms_output.put_line('tot_parte: '||to_char(tot_parte));
--dbms_output.put_line('pagina: tot_num_b '||tot_num_b||' tot_invio '||tot_invio);
        insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
    		values ( prenotazione
               , 98
    		       , decode( tot_num_b
                       , 1, tot_invio
                          , decode( tot_gest_cf
                                  , tot_app_cf, tot_invio+1
                                              , tot_invio* tot_num_b)
                       )
                 , 0
       		       , to_char(tot_parte));
--dbms_output.put_line('tot_invio '||tot_invio||' nr_file '||to_char((tot_invio-3)+1));
       FOR CUR_TOT IN
          (select CF_VERS             CF_VERS
                , CASSA               T004
                , TIPO_ALIQUOTA
                , decode( tot_tardivo
                        , 'X', substr(lpad(nvl(riferimento,tot_anno),6,'0'),3)
                             , decode( length(riferimento)
                                     , 4, TO_CHAR(riferimento)
                                        , lpad(TO_CHAR(riferimento),6,'0'))
                        )             RIFERIMENTO
                , IPN_PENS            t007
                , CONTR_PENS          t008
                , IPN_PENS_CN         t009
                , CONTR_PENS_CN       t010
                , IPN_PENS_SUD        t011
                , CONTR_PENS_SUD      t012
                , IPN_PENS_CN_407     t013
                , CONTR_PENS_CN_407   t014
                , IPN_PENS_SUD_407    t015
                , CONTR_PENS_SUD_407  t016
                , IPN_L135            t017
                , CONTR_L135          t018
                , IPN_SU_ECCEDENZA    t019
                , CONTR_SU_ECCEDENZA  t020
                , IPN_L166            t021
                , CONTR_L166          t022
                , IPN_TFS             t023
                , CONTR_TFS           t024
                , IPN_TFR             ta25
                , CONTR_TFR           ta26
                , ULT_IPN_TFR         tb25
                , CONTR_ULT_TFR       tb26
                , IPN_CASSA_CREDITO   t027
                , CONTR_CASSA_CREDITO t028
                , IPN_ENPDEDP         t029
                , CONTR_ENPDEDP       t030
                , RISCATTO_PENS       D_t031
                , RICONGIUNZIONE      D_t032
                , RISCATTO_TFS        D_t033
                , MUTUO               D_t034
                , PRESTITO            D_t035
                , RISCATTO_TFR        D_t036
                , SANZIONI            t037
                , CONTR_SOSPESO       t038
                , CONTR_CONGUAGLIO
             from totali_dma_z1
            where anno     = tot_anno
              and mese     = tot_mese
              and cf_dic   = tot_gest_cf
              and cf_app   = tot_app_cf
              and nr_file  = tot_progr_invio
          ) LOOP
--dbms_output.put_line('2 tot_invio '||to_char(tot_invio)||' tot_num_b '||to_char(tot_num_b));
--dbms_output.put_line('2 tot_gest_cf '||tot_gest_cf||' tot_app_cf '||tot_app_cf);
          -- inserisco il record dei TOTALI tipo D
          tot_conta_d  := tot_conta_d + 1;
          tot_pagina   := 90000 * tot_num_b;
          tot_riga     := tot_riga + 1;
          tot_num_ord  := tot_num_ord + 1;
--		dbms_output.put_line('conta d: '||to_char(tot_conta_d));
--dbms_output.put_line('TOTALI passo: '||tot_invio||' tot_pagina '||tot_pagina||' tot_riga '||tot_riga);
--dbms_output.put_line('TOTALI riferimento: '||CUR_TOT.riferimento||' - '||CUR_TOT.t028);
          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
      		values ( prenotazione
                 , tot_invio
       	   	     , tot_pagina
                 , tot_riga
    		         , decode( tot_conta_d,1,'D',null)||
                   decode( tot_conta_d,1,rpad(tot_gest_cf ,11,' '),null)||
                   decode( tot_conta_d,1,lpad(nvl(to_char(tot_progr),'0'),5,'0'),null)||
                   decode( tot_conta_d,1,lpad('1',8,'0'),null)||
                   decode( tot_conta_d,1,rpad(' ',7,' '),null)||
                   decode( tot_conta_d,1,rpad(tot_app_cf,11,' '),null)||
                   decode( tot_conta_d,1,rpad(tot_gest_cf ,11,' '),null)||
                   decode( tot_conta_d,1,lpad(nvl(to_char(tot_progr),'0'),5,'0'),null)||
                   decode( tot_conta_d,1,rpad(' ',7,' '),null)||
                   decode( tot_conta_d,1,rpad(' ',23,' '),null)|| -- filler
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'001'
                       ||rpad(nvl(CUR_TOT.CF_VERS ,' '),16,' ')||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'002'
                       ||lpad(decode( tot_gest_cf
                                    , CUR_TOT.CF_VERS,nvl(to_char(tot_progr),' ')
                                                     ,' '),16,' ')||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'004'
                       ||lpad(nvl(CUR_TOT.T004,' '),16,' ')|| -- DA DEFINIRE!!!
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'005'
                       ||lpad(nvl(CUR_TOT.riferimento,' '),16,' ')||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'006'
                       ||lpad(nvl(to_char(CUR_TOT.tipo_aliquota),' '),16,' ')||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'007'
                       ||format_dati( nvl(cur_tot.t007,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'008'
                       ||format_dati( nvl(cur_tot.t008,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'009'
                       ||format_dati( nvl(cur_tot.t009,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'010'
                       ||format_dati( nvl(cur_tot.t010,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'011'
                       ||format_dati( nvl(cur_tot.t011,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'012'
                       ||format_dati( nvl(cur_tot.t012,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'013'
                       ||format_dati( nvl(cur_tot.t013,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'014'
                       ||format_dati( nvl(cur_tot.t014,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'015'
                       ||format_dati( nvl(cur_tot.t015,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'016'
                       ||format_dati( nvl(cur_tot.t016,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'017'
                       ||format_dati( nvl(cur_tot.t017,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'018'
                       ||format_dati( nvl(cur_tot.t018,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'019'
                       ||format_dati( nvl(cur_tot.t019,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'020'
                       ||format_dati( nvl(cur_tot.t020,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'021'
                       ||format_dati( nvl(cur_tot.t021,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'022'
                       ||format_dati( nvl(cur_tot.t022,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'023'
                       ||format_dati( nvl(cur_tot.t023,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'024'
                       ||format_dati( nvl(cur_tot.t024,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'A25'
                       ||format_dati( nvl(cur_tot.tA25,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'B25'
                       ||format_dati( nvl(cur_tot.tB25,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'A26'
                       ||format_dati( nvl(cur_tot.tA26,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'B26'
                       ||format_dati( nvl(cur_tot.tB26,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'027'
                       ||format_dati( nvl(cur_tot.t027,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'028'
                       ||format_dati( nvl(cur_tot.t028,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'029'
                       ||format_dati( nvl(cur_tot.t029,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'030'
                       ||format_dati( nvl(cur_tot.t030,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'031'
                       ||format_dati( nvl(cur_tot.D_t031,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'032'
                       ||format_dati( nvl(cur_tot.D_t032,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'033'
                       ||format_dati( nvl(cur_tot.D_t033,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'034'
                       ||format_dati( nvl(cur_tot.D_t034,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'035'
                       ||format_dati( nvl(cur_tot.D_t035,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'036'
                       ||format_dati( nvl(cur_tot.D_t036,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'037'
                       ||format_dati( nvl(cur_tot.t037,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'038'
                       ||format_dati( nvl(cur_tot.t038,0))
                 )
          ;
--dbms_output.put_line('TOTALI passo: 98 '||' tot_pagina '||tot_pagina||'  tot_riga '||tot_riga);
          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
      		values ( prenotazione
                       , 98
    		       , decode( tot_num_b
                       , 1, tot_invio
                          , decode( tot_gest_cf
                                  , tot_app_cf, tot_invio+1
                                              , tot_invio* tot_num_b)
                       )
                       , tot_riga
       		       , decode( tot_conta_d,1,'D',null)||
                   decode( tot_conta_d,1,rpad(tot_gest_cf ,11,' '),null)||
                   decode( tot_conta_d,1,lpad(nvl(to_char(tot_progr),'0'),5,'0'),null)||
                   decode( tot_conta_d,1,lpad('1',8,'0'),null)||
                   decode( tot_conta_d,1,rpad(' ',7,' '),null)||
                   decode( tot_conta_d,1,rpad(tot_app_cf,11,' '),null)||
                   decode( tot_conta_d,1,rpad(tot_gest_cf ,11,' '),null)||
                   decode( tot_conta_d,1,lpad(nvl(to_char(tot_progr),'0'),5,'0'),null)||
                   decode( tot_conta_d,1,rpad(' ',7,' '),null)||
                   decode( tot_conta_d,1,rpad(' ',23,' '),null)|| -- filler
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'001'
                       ||rpad(nvl(CUR_TOT.CF_VERS ,' '),16,' ')||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'002'
                       ||lpad(decode( tot_gest_cf
                                    , CUR_TOT.CF_VERS,nvl(to_char(tot_progr),' ')
                                                     ,' '),16,' ')||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'004'
                       ||lpad(nvl(CUR_TOT.T004,' '),16,' ')|| -- DA DEFINIRE!!!
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'005'
                       ||lpad(nvl(CUR_TOT.riferimento,' '),16,' ')||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'006'
                       ||lpad(nvl(to_char(CUR_TOT.tipo_aliquota),' '),16,' ')||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'007'
                       ||format_dati( nvl(cur_tot.t007,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'008'
                       ||format_dati( nvl(cur_tot.t008,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'009'
                       ||format_dati( nvl(cur_tot.t009,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'010'
                       ||format_dati( nvl(cur_tot.t010,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'011'
                       ||format_dati( nvl(cur_tot.t011,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'012'
                       ||format_dati( nvl(cur_tot.t012,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'013'
                       ||format_dati( nvl(cur_tot.t013,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'014'
                       ||format_dati( nvl(cur_tot.t014,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'015'
                       ||format_dati( nvl(cur_tot.t015,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'016'
                       ||format_dati( nvl(cur_tot.t016,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'017'
                       ||format_dati( nvl(cur_tot.t017,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'018'
                       ||format_dati( nvl(cur_tot.t018,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'019'
                       ||format_dati( nvl(cur_tot.t019,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'020'
                       ||format_dati( nvl(cur_tot.t020,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'021'
                       ||format_dati( nvl(cur_tot.t021,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'022'
                       ||format_dati( nvl(cur_tot.t022,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'023'
                       ||format_dati( nvl(cur_tot.t023,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'024'
                       ||format_dati( nvl(cur_tot.t024,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'A25'
                       ||format_dati( nvl(cur_tot.tA25,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'B25'
                       ||format_dati( nvl(cur_tot.tB25,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'A26'
                       ||format_dati( nvl(cur_tot.tA26,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'B26'
                       ||format_dati( nvl(cur_tot.tB26,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'027'
                       ||format_dati( nvl(cur_tot.t027,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'028'
                       ||format_dati( nvl(cur_tot.t028,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'029'
                       ||format_dati( nvl(cur_tot.t029,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'030'
                       ||format_dati( nvl(cur_tot.t030,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'031'
                       ||format_dati( nvl(cur_tot.D_t031,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'032'
                       ||format_dati( nvl(cur_tot.D_t032,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'033'
                       ||format_dati( nvl(cur_tot.D_t033,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'034'
                       ||format_dati( nvl(cur_tot.D_t034,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'035'
                       ||format_dati( nvl(cur_tot.D_t035,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'036'
                       ||format_dati( nvl(cur_tot.D_t036,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'037'
                       ||format_dati( nvl(cur_tot.t037,0))||
                   'Z1'||lpad(to_char(tot_num_ord),3,'0')||'038'
                       ||format_dati( nvl(cur_tot.t038,0))
                 )
          ;
        END LOOP; -- CUR_TOT
-- aggiorno il record di tipo B per inserire il numero dei prospetti Z1
          update a_appoggio_stampe
             set testo = substr(testo,1,967)||lpad(tot_conta_C,8,'0')||lpad(tot_conta_d,8,'0')||substr(testo,984,1900)
           where no_prenotazione = prenotazione
             and pagina   = tot_pagina_B
             and no_passo = tot_invio
             and riga     = 1
          ;
    END;
  END TOTALI;
 PROCEDURE TOTALI_Z2 ( PRENOTAZIONE  in NUMBER
                  , tot_invio     in NUMBER
                  , tot_pagina    in out NUMBER
                  , tot_riga      in out NUMBER
                  , tot_pagina_b  in NUMBER
                  , tot_num_ord   in NUMBER
                  , tot_anno      in NUMBER
                  , tot_mese      in NUMBER
                  , tot_gest_cf   in VARCHAR2
                  , tot_progr     in NUMBER
                  , tot_app_cf    in VARCHAR2
                  , tot_num_b     in NUMBER
                  , tot_z2        in out NUMBER
                  ) IS
 BEGIN
   DECLARE
     TOT_num_ord  number;
     BEGIN
--dbms_output.put_line('1 tot_invio '||to_char(tot_invio)||' tot_num_b '||to_char(tot_num_b));
--dbms_output.put_line('1 tot_gest_cf '||tot_gest_cf||' tot_app_cf '||tot_app_cf);
        tot_z2 := 0;
        tot_num_ord := 0;
--dbms_output.put_line('tot_parte: '||to_char(tot_parte));
       FOR CUR_Z2 IN
          (select data_versamento
                , pagamento
                , conto_corrente
                , estremi_pagamento
                , cassa
                , decode( length(riferimento)
                        , 4, '01'||TO_CHAR(riferimento)
                           , lpad(TO_CHAR(riferimento),6,'0')) riferimento
                , versamento
                , contr_pens
                , contr_pens_cn
                , contr_pens_sud
                , contr_pens_cn_407
                , contr_pens_sud_407
                , contr_l135
                , contr_su_eccedenza
                , contr_l166
                , contr_tfs
                , contr_tfr
                , contr_ult_tfr
                , contr_cassa_credito
                , contr_enpdedp
                , riscatto_pens
                , ricongiunzione
                , riscatto_tfs
                , mutuo
                , prestito
                , riscatto_tfr
                , ruolo
                , vers_no_ipn
                , sanzioni
                , eccedenze
                , anticipazioni
             from totali_versamenti_dma
            where anno   = tot_anno
              and mese   = tot_mese
              and cf_dic = tot_gest_cf
           ) LOOP
          -- inserisco il record dei TOTALI tipo D
          tot_z2       := tot_z2 + 1;
          tot_pagina   := 90000 * tot_num_b;
          tot_riga     := tot_riga + 1;
          tot_num_ord  := tot_num_ord + 1;
-- dbms_output.put_line('conta d: '||to_char(tot_z2));
-- dbms_output.put_line('TOTALI Z2 '||tot_invio||' tot_pagina '||tot_pagina||'  tot_riga '||tot_riga||' riscatto_tfr '||cur_z2.riscatto_tfr);
          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
      		values ( prenotazione
    		         , tot_invio
       	   	     , tot_pagina
                 , tot_riga
        	       , 'Z2'||lpad(to_char(tot_num_ord),3,'0')||'001'
                       ||rpad(nvl(CUR_Z2.cassa ,' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'002'
                       ||lpad(nvl(CUR_Z2.riferimento,' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'003'
                       ||lpad(nvl(CUR_Z2.versamento,' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'004'
                       ||lpad(nvl(to_char(CUR_Z2.data_versamento,'ddmmyyyy'),' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'005'
                       ||lpad(nvl(CUR_Z2.pagamento,' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'006'
                       ||lpad(nvl(CUR_Z2.conto_corrente,' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'007'
                       ||lpad(nvl(CUR_Z2.estremi_pagamento,' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'008'
                       ||format_dati( nvl(CUR_Z2.contr_pens,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'009'
                       ||format_dati( nvl(cur_z2.contr_pens_cn,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'010'
                       ||format_dati( nvl(cur_z2.contr_pens_sud,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'011'
                       ||format_dati( nvl(cur_z2.contr_pens_cn_407,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'012'
                       ||format_dati( nvl(cur_z2.contr_pens_sud_407,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'013'
                       ||format_dati( nvl(cur_z2.contr_l135,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'014'
                       ||format_dati( nvl(cur_z2.contr_su_eccedenza,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'015'
                       ||format_dati( nvl(cur_z2.contr_l166,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'016'
                       ||format_dati( nvl(cur_z2.contr_tfs,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'A17'
                       ||format_dati( nvl(cur_z2.contr_tfr,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'B17'
                       ||format_dati( nvl(cur_z2.contr_ult_tfr,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'018'
                       ||format_dati( nvl(cur_z2.contr_cassa_credito,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'019'
                       ||format_dati( nvl(cur_z2.contr_enpdedp,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'020'
                       ||format_dati( nvl(cur_z2.riscatto_pens,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'021'
                       ||format_dati( nvl(cur_z2.ricongiunzione,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'022'
                       ||format_dati( nvl(cur_z2.riscatto_tfs,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'023'
                       ||format_dati( nvl(cur_z2.mutuo,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'024'
                       ||format_dati( nvl(cur_z2.prestito,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'025'
                       ||format_dati( nvl(cur_z2.riscatto_tfr,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'026'
                       ||rpad(nvl(cur_z2.ruolo,' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'027'
                       ||format_dati( nvl(cur_z2.vers_no_ipn,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'028'
                       ||format_dati( nvl(cur_z2.sanzioni,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'029'
                       ||format_dati( nvl(cur_z2.eccedenze,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'030'
                       ||format_dati( nvl(cur_z2.anticipazioni,0))
                 )
          ;
--dbms_output.put_line('TOTALI Z2 99 '||' tot_pagina '||tot_pagina||'  tot_riga '||tot_riga);
          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
      		values ( prenotazione
                 , 99
      		       , decode( tot_num_b
                         , 1, tot_invio
                            , decode( tot_gest_cf
                                    , tot_app_cf, tot_invio+1
                                                , tot_invio* tot_num_b)
                         )
                 , tot_riga
       		       , decode( tot_z2,1,'D',null)||
                   decode( tot_z2,1,rpad(tot_gest_cf ,11,' '),null)||
                   decode( tot_z2,1,lpad(nvl(to_char(tot_progr),'0'),5,'0'),null)||
                   decode( tot_z2,1,lpad('1',8,'0'),null)||
                   decode( tot_z2,1,rpad(' ',7,' '),null)||
                   decode( tot_z2,1,rpad(tot_app_cf,11,' '),null)||
                   decode( tot_z2,1,rpad(tot_gest_cf ,11,' '),null)||
                   decode( tot_z2,1,lpad(nvl(to_char(tot_progr),'0'),5,'0'),null)||
                   decode( tot_z2,1,rpad(' ',7,' '),null)||
                   decode( tot_z2,1,rpad(' ',23,' '),null)|| -- filler
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'001'
                       ||rpad(nvl(CUR_Z2.cassa ,' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'002'
                       ||lpad(nvl(CUR_Z2.riferimento,' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'003'
                       ||lpad(nvl(CUR_Z2.versamento,' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'004'
                       ||lpad(nvl(to_char(CUR_Z2.data_versamento,'ddmmyyyy'),' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'005'
                       ||lpad(nvl(CUR_Z2.pagamento,' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'006'
                       ||lpad(nvl(CUR_Z2.conto_corrente,' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'007'
                       ||lpad(nvl(CUR_Z2.estremi_pagamento,' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'008'
                       ||format_dati( nvl(CUR_Z2.contr_pens,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'009'
                       ||format_dati( nvl(cur_z2.contr_pens_cn,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'010'
                       ||format_dati( nvl(cur_z2.contr_pens_sud,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'011'
                       ||format_dati( nvl(cur_z2.contr_pens_cn_407,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'012'
                       ||format_dati( nvl(cur_z2.contr_pens_sud_407,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'013'
                       ||format_dati( nvl(cur_z2.contr_l135,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'014'
                       ||format_dati( nvl(cur_z2.contr_su_eccedenza,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'015'
                       ||format_dati( nvl(cur_z2.contr_l166,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'016'
                       ||format_dati( nvl(cur_z2.contr_tfs,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'A17'
                       ||format_dati( nvl(cur_z2.contr_tfr,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'B17'
                       ||format_dati( nvl(cur_z2.contr_ult_tfr,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'018'
                       ||format_dati( nvl(cur_z2.contr_cassa_credito,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'019'
                       ||format_dati( nvl(cur_z2.contr_enpdedp,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'020'
                       ||format_dati( nvl(cur_z2.riscatto_pens,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'021'
                       ||format_dati( nvl(cur_z2.ricongiunzione,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'022'
                       ||format_dati( nvl(cur_z2.riscatto_tfs,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'023'
                       ||format_dati( nvl(cur_z2.mutuo,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'024'
                       ||format_dati( nvl(cur_z2.prestito,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'025'
                       ||format_dati( nvl(cur_z2.riscatto_tfr,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'026'
                       ||rpad(nvl(cur_z2.ruolo,' '),16,' ')||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'027'
                       ||format_dati( nvl(cur_z2.vers_no_ipn,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'028'
                       ||format_dati( nvl(cur_z2.sanzioni,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'029'
                       ||format_dati( nvl(cur_z2.eccedenze,0))||
                   'Z2'||lpad(to_char(tot_num_ord),3,'0')||'030'
                       ||format_dati( nvl(cur_z2.anticipazioni,0))
                   )
          ;
        END LOOP; -- CUR_TOT
        -- Verifica se esistono record di riscatti e ricongiunzioni che NON hanno corrispondenza su
        -- denuncia_dma e quindi bisogna inserire uno specifico record di totali
          update a_appoggio_stampe
             set testo = substr(testo,1,983)||lpad(tot_z2,8,'0')||
                         decode( tot_invio
                               , 1, substr(testo,992)
                                  , substr(testo,992,53)||lpad(tot_z2,8,'0')||
                                    substr(testo,1053,848))
           where no_prenotazione = prenotazione
             and pagina   = tot_pagina_B
             and no_passo = tot_invio
             and riga     = 1
          ;
    END;
  END TOTALI_Z2;
  PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
  BEGIN
 DECLARE
  D_anno            NUMBER;
  D_mese            NUMBER;
  D_num_record      NUMBER;
  D_ini_mes         DATE;
  D_fin_mes         DATE;
  D_tardivo         VARCHAR2(1);
  D_cf_inte         VARCHAR2(16);
  D_data_inte       VARCHAR2(8);
  D_appartenenza    VARCHAR2(8);
  D_gestione        VARCHAR2(8);
  D_forza_credito   VARCHAR2(1);
  D_cod_fis         VARCHAR(16);
  D_temp            VARCHAR2(1);
  D_ctr_firmatario  NUMBER;
  D_ctr_dip         VARCHAR2(1);
  D_ctr_tot         VARCHAR2(1);
  D_ctr_file        VARCHAR2(1);
  D_cod_fis_fir     VARCHAR2(16);
  D_cognome_fir     VARCHAR2(40);
  D_nome_fir        VARCHAR2(36);
  D_sesso_fir       VARCHAR2(1);
  D_data_nas_fir    VARCHAR2(8);
  D_com_fir         VARCHAR2(40);
  D_prov_fir        VARCHAR2(2);
  D_num_inpdap      NUMBER;
  D_prog_mod        NUMBER :=0;
  D_num_ord         NUMBER :=1;
  D_pagina          NUMBER := 0;
  D_pagina_b        NUMBER := 0;
  D_riga            NUMBER :=0;
  D_cas_010         VARCHAR2(1);
  D_cas_015         VARCHAR2(1);
  D_dep_ci          number;
  D_count           NUMBER;
  D_conta_dett      NUMBER := 0;
  D_conta_C         NUMBER := 0;
  D_conta_D         NUMBER := 0;
  D_ci              NUMBER(8);
  D_rilevanza       VARCHAR2(2);
-- variabili per invii multipli
  progr_invio       NUMBER :=0;
  numero_invio      NUMBER;
  D_tot_rec		      NUMBER;
  D_tot_invii       NUMBER;
  D_righe_lette     NUMBER;
  D_ultimo_ci	      NUMBER;
  Dep_invio         NUMBER;
  Dep_num_b         NUMBER;
  Dep_nr_file       NUMBER;
  Dep_cf_app        VARCHAR2(16);
  tot_iscritti      NUMBER;
  tot_z1            NUMBER;
  tot_z2            NUMBER;
  Dep_tot_z2        NUMBER;
  tot_parte         NUMBER := 0;
-- Exception
  ERRORE            EXCEPTION;
 BEGIN
  -- Estrazione Parametri di Selezione della Prenotazione
  BEGIN
    select substr(valore,1,4)
      into D_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_ANNO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      select anno
        into D_anno
        from riferimento_retribuzione  -- riferimentro_retribuzione o riferimento_fine_anno?
       where rire_id = 'RIRE';
  END;
  BEGIN
    select lpad(substr(valore,1,2),2,0)
          ,to_date('01'||lpad(substr(valore,1,2),2,0)||to_char(D_anno),'ddmmyyyy')
          ,last_day(to_date(lpad(substr(valore,1,2),2,0)||to_char(D_anno),'mmyyyy'))
      into D_mese, D_ini_mes, D_fin_mes
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_MESE'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      select mese
            ,to_date('01'||lpad(to_char(mese),2,'0')||to_char(D_anno),'ddmmyyyy')
            ,last_day(to_date(lpad(to_char(mese),2,'0')||to_char(D_anno),'mmyyyy'))
        into D_mese, D_ini_mes, D_fin_mes
        from riferimento_retribuzione
       where rire_id = 'RIRE'
      ;
  END;
  BEGIN
    select valore
      into D_cf_inte
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CF_INTE'
    ;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_cf_inte := '';
  END;
  BEGIN
    select to_char(TO_DATE(valore,'dd/mm/yyyy'),'ddmmyyyy')
      into D_data_inte
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_DATA_INTE'
    ;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_data_inte := '';
  END;
  BEGIN
    select valore
      into D_tardivo
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_TARDIVO'
    ;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_tardivo := ' '; -- da chiedere
  END;
  BEGIN
    select valore
      into D_gestione
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_GESTIONE'
    ;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_gestione := '%';
  END;
  BEGIN
    select valore
      into D_appartenenza
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_APPARTENENZA'
    ;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_appartenenza := '%';
  END;
  BEGIN
    select valore
      into D_forza_credito
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_FORZA_CREDITO'
    ;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_forza_credito := 'N';
  END;
  BEGIN
    select valore_default
      into D_num_record
      from a_selezioni
     where voce_menu  = 'PECSMDMA'
       and parametro  = 'P_NUM_RECORD'
    ;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_num_record:= 20000;
  END;
  BEGIN
    select 'x'
      into D_ctr_dip
      from dual
     where exists
          (select 'x'
             from individui_dma
            where anno = D_anno
              and mese = D_mese
              and cf_dic in (select codice_fiscale
                               from gestioni
                              where codice like D_gestione
                            )
          );
    RAISE TOO_MANY_ROWS;
  EXCEPTION
       WHEN TOO_MANY_ROWS THEN null;
       WHEN NO_DATA_FOUND THEN
            update a_prenotazioni
               set errore = 'P00105'
                 , prossimo_passo = 99
             where no_prenotazione = prenotazione
            ;
            RAISE ERRORE;
  END;
  BEGIN
    select 'x'
      into D_ctr_tot
      from dual
     where exists
          (select 'x'
             from individui_dma
            where anno = D_anno
              and mese = D_mese
              and nr_file is null);
    RAISE TOO_MANY_ROWS;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN null;
       WHEN TOO_MANY_ROWS THEN
            update a_prenotazioni
               set errore = 'P00115'
                 , prossimo_passo = 99
             where no_prenotazione = prenotazione
            ;
            RAISE ERRORE;
  END;
  BEGIN
    select 'x'
      into D_ctr_file
      from dual
     where exists
          (select 'x'
             from individui_dma
            where anno = D_anno
              and mese = D_mese
              and nr_file > 15);
    RAISE TOO_MANY_ROWS;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN null;
       WHEN TOO_MANY_ROWS THEN
            update a_prenotazioni
               set errore = 'P00118'
                 , prossimo_passo = 99
             where no_prenotazione = prenotazione
            ;
            RAISE ERRORE;
  END;
--dbms_output.put_line('Numero_record: '||to_char(D_num_record));
  -- controllo che non ci siano piu gestioni con stesso codice fiscale e firmatario_dma pieno
  BEGIN
    select count(*)
      into D_ctr_firmatario
      from gestioni gest
     where firmatario_dma is not null
       and codice_fiscale in
          (select codice_fiscale
             from gestioni
            where codice_fiscale = gest.codice_fiscale
              and codice in (select gestione
                               from denuncia_dma
                              where anno = D_anno and mese = D_mese
                                and gestione       like D_gestione)
          )
    ;
    IF D_ctr_firmatario = 0 THEN
   	   update a_prenotazioni
	        set errore = 'P00114'  -- Da definire
            , prossimo_passo = 99
	      where no_prenotazione = prenotazione
  	   ;
       RAISE ERRORE;
    ELSIF D_ctr_firmatario > 1 THEN
   	   update a_prenotazioni
	        set errore = 'P01082'  -- Da definire
            , prossimo_passo = 99
	      where no_prenotazione = prenotazione
  	   ;
       RAISE ERRORE;
    END IF;
  END;
  -- controllo che il dato inserito nel parametro della gestione non determini l'estrazione di gestioni
  -- con codice_fiscale diversi
--dbms_output.put_line('Controllo codice fiscale');
  BEGIN
    select distinct rtrim(ltrim(codice_fiscale))
	   into D_cod_fis
      from denuncia_dma  dedm
          ,gestioni      gest
     where dedm.gestione LIKE D_gestione
       and firmatario_dma  is not null
       and gest.codice_fiscale =
          (select codice_fiscale from gestioni
            where codice = dedm.gestione)
       and dedm.anno        = D_anno
       and dedm.mese        = D_mese
    ;
	UPDATE a_selezioni
	   SET valore_default = D_cod_fis||'-'||lpad(D_mese,2,'0')||D_anno||'.txt'
	 WHERE voce_menu = 'PECSMDMA'
	   AND parametro = 'TXTFILE'
	;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  UPDATE a_prenotazioni
	     SET errore = 'P00112'
             , prossimo_passo = 99
	   WHERE no_prenotazione = prenotazione
	  ;
	RAISE errore;
    WHEN TOO_MANY_ROWS THEN
	   update a_prenotazioni
	      set errore = 'P00110'
           , prossimo_passo = 99
	    where no_prenotazione = prenotazione
	   ;
	   RAISE ERRORE;
  END;
  BEGIN -- inizio corpo
--  dbms_output.put_line('inizio corpo');
    D_conta_D := 0;
    FOR CUR_GEST IN
     (select gest.codice
           , gest.codice_fiscale
           , gest.nome
           , progressivo_inpdap
           , gest.codice_attivita
           , forma_giuridica
           , nvl(cf_software,gest.codice_fiscale) cf_software
           , decode( D_tardivo
                   , 'X', to_char(sysdate,'mmyyyy')
                        , lpad(to_char(D_mese),2,'0')||to_char(D_anno)
                   ) periodo
           , comu.codice_catasto
           , gest.indirizzo_res
           , gest.cap
           , decode(lpad(translate(nvl(replace(replace(replace(gest.tel_res,'/',''),'-',''),' ',''),' ')
                                  ,'0123456789','0000000000')
                         ,12,'0')
            ,'000000000000', replace(replace(replace(gest.tel_res,'/',''),'-',''),' ','')
                           , null)                   tel_res
           , decode(lpad(translate(nvl(replace(replace(replace(gest.fax_res,'/',''),'-',''),' ',''),' ')
                                   ,'0123456789','0000000000')
                        ,12,'0')
            ,'000000000000', replace(replace(replace(gest.fax_res,'/',''),'-',''),' ','')
                           , null)                   fax_res
           , gest.e_mail
           , firmatario_dma
--           , gest.comparto
--           , gest.sottocomparto
        from gestioni gest
           , ente     ente
           , comuni   comu
       where gest.codice_fiscale in
            (select codice_fiscale from gestioni
              where codice in (select gestione
                                 from denuncia_dma
                                where anno = D_anno
                                  and mese = D_mese
                                  and gestione like D_gestione
                              ))
--         and codice         like D_gestione
         and firmatario_dma is not null
         and comu.cod_comune    (+) = gest.comune_res
         and comu.cod_provincia (+) = gest.provincia_res)
    LOOP
--    dbms_output.put_line('cur gest');
      -- estraggo i dati relativi al rappresentante firmatario della denuncia che andranno inseriti nel record di tipo 'B''
      BEGIN
        select codice_fiscale
             , rain.cognome
             , rain.nome
             , sesso
             , substr(to_char(rain.data_nas
                             ,'ddmmyyyy'),1,8) data_nas
             , comu.descrizione
             , substr(decode(sign(199-comu.cod_provincia), -1,'  ', comu.sigla_provincia),1,2)
          into D_cod_fis_fir
             , D_cognome_fir
             , D_nome_fir
             , D_sesso_fir
             , D_data_nas_fir
             , D_com_fir
             , D_prov_fir
          from rapporti_individuali rain
             , anagrafici           anag
             , comuni               comu
         where rain.ci = CUR_GEST.firmatario_dma
           and rain.ni = anag.ni
           and anag.dal =
                        (select MAX(dal)
                           from ANAGRAFICI
                          where ni  = anag.ni
                            and dal <= D_fin_mes)
           and anag.comune_nas = comu.cod_comune
           and anag.provincia_nas = comu.cod_provincia
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
          null; -- si e sicuramente verificato qualche problema vedremo in seguito se inserire una segnalazione
      END;
-- Determino il numero degli invii
      select count(*)
        into D_tot_rec
        from denuncia_dma
       where anno = D_anno
         and mese = D_mese
         and gestione in (select codice
                            from gestioni
                           where codice_fiscale = CUR_GEST.codice_fiscale);
      D_tot_invii := ceil(D_tot_rec / D_num_record);
      -- inserisco il record di tipo 'A'
      numero_invio := 1;
      progr_invio  := progr_invio + 1;
      D_pagina     := 0;
      INS_A(prenotazione,numero_invio,progr_invio,D_anno,D_cf_inte,CUR_GEST.codice_fiscale,D_tot_invii);
FOR GEST_APP IN
   (select gest.codice
           , gest.codice_fiscale
           , gest.nome
           , comu.codice_catasto
           , gest.indirizzo_res
           , gest.cap
           , decode(lpad(translate(nvl(replace(replace(replace(gest.tel_res,'/',''),'-',''),' ',''),' ')
                                  ,'0123456789','0000000000')
                         ,12,'0')
            ,'000000000000', replace(replace(replace(gest.tel_res,'/',''),'-',''),' ','')
                           , null)                   tel_res
           , decode(lpad(translate(nvl(replace(replace(replace(gest.fax_res,'/',''),'-',''),' ',''),' ')
                                   ,'0123456789','0000000000')
                        ,12,'0')
            ,'000000000000', replace(replace(replace(gest.fax_res,'/',''),'-',''),' ','')
                           , null)                   fax_res
           , gest.e_mail
           , rownum num_b
        from gestioni gest
           , ente     ente
           , comuni   comu
       where codice in
            (select distinct nvl(gestione_app,cur_gest.codice)
               from denuncia_dma
              where anno = D_anno
                and mese = D_mese
                and ci >= nvl(D_ultimo_ci,0)
                and nvl(gestione_app,' ') like D_appartenenza
                and gestione in (select codice
                                   from gestioni
                                  where codice_fiscale = CUR_GEST.codice_fiscale)
            )
         and comu.cod_comune    (+) = gest.comune_res
         and comu.cod_provincia (+) = gest.provincia_res
         and (   gest.firmatario_dma is not null
              or gest.codice_fiscale != CUR_GEST.codice_fiscale)
       order by rownum
   ) LOOP
      -- inserisco il record di tipo 'B'
      D_pagina   := D_pagina + 1;
      D_pagina_b := D_pagina;
      INS_B(prenotazione,numero_invio,D_pagina,CUR_GEST.codice_fiscale,cur_gest.progressivo_inpdap
           ,GEST_APP.codice_fiscale,CUR_GEST.codice_attivita,CUR_GEST.forma_giuridica,CUR_GEST.cf_software
           ,CUR_GEST.periodo
           ,CUR_GEST.nome,CUR_GEST.codice_catasto,CUR_GEST.indirizzo_res,CUR_GEST.cap
           ,CUR_GEST.tel_res,CUR_GEST.fax_res,CUR_GEST.e_mail
           ,GEST_APP.nome,GEST_APP.codice_catasto,GEST_APP.indirizzo_res,GEST_APP.cap
           ,GEST_APP.tel_res,GEST_APP.fax_res,GEST_APP.e_mail
           ,D_cod_fis_fir,D_cognome_fir,D_nome_fir,D_sesso_fir,D_data_nas_fir,D_com_fir
           ,D_prov_fir,D_num_inpdap,D_data_inte,D_cf_inte
           );
      --commit;
      -- estraggo i dati per gli inserimenti del record TIPO C
      BEGIN
        D_conta_C  := 0;
        D_prog_mod := 0;
        D_dep_ci   := 0;
        D_righe_lette := 0;
        FOR CUR_ANA IN
         (select distinct rain.ci                         ci
             , idma.nr_file                               nr_file
             , anag.codice_fiscale                        cod_fis
             , anag.dal                                   dal
             , upper(anag.cognome)                        cognome
             , upper(anag.nome)                           nome
             , anag.data_nas                              data_nas
             , anag.sesso                                 sesso
             , nvl(comu_n.codice_catasto,' ')             cop_nas
             , nvl(comu_r.codice_catasto,' ')             cop_res
             , upper(anag.indirizzo_res)                  ind_res
             , anag.cap_res                               cap_res
             , decode(lpad(translate(nvl(replace(replace(replace(anag.tel_res,'/',''),'-',''),' ',''),' ')
                                    ,'0123456789','0000000000')
                           ,12,'0')
               ,'000000000000', replace(replace(replace(anag.tel_res,'/',''),'-',''),' ','')
                             , null)                      tel_res
             , decode(lpad(translate(nvl(replace(replace(replace(anag.fax_res,'/',''),'-',''),' ',''),' ')
                                     ,'0123456789','0000000000')
                          ,12,'0')
              ,'000000000000', replace(replace(replace(anag.fax_res,'/',''),'-',''),' ','')
                             , null)                      fax_res
             , anag.e_mail                                e_mail
             , ddma.fine_servizio                         fine_servizio
          from comuni                   comu_n
             , comuni                   comu_r
             , denuncia_dma             ddma
             , individui_dma            idma
             , anagrafici               anag
             , rapporti_individuali     rain
         where anag.ni  = rain.ni
           and anag.dal =
                        (select MAX(dal)
                           from ANAGRAFICI
                          where ni  = anag.ni
                            and dal <= D_fin_mes)
           and comu_n.cod_comune        = anag.comune_nas
           and comu_n.cod_provincia     = anag.provincia_nas
           and comu_r.cod_comune        = anag.comune_res
           and comu_r.cod_provincia     = anag.provincia_res
           and rain.ci = ddma.ci
           and ddma.anno = D_anno
           and ddma.mese = D_mese
           and ddma.ci >= nvl(D_ultimo_ci,0)
           and ddma.gestione in (select codice
                                   from gestioni
                                   where codice_fiscale = CUR_GEST.codice_fiscale)
           and nvl(ddma.gestione_app,ddma.gestione) in
                           (select codice
                              from gestioni
                             where codice_fiscale = GEST_APP.codice_fiscale)
           and idma.anno   = D_anno
           and idma.mese   = D_mese
           and idma.ci     = ddma.ci
           and idma.cf_dic = CUR_GEST.codice_fiscale
           and idma.cf_app = GEST_APP.codice_fiscale
        union
        select distinct rain.ci                           ci
             , idma.nr_file                               nr_file
             , anag.codice_fiscale                        cod_fis
             , anag.dal                                   dal
             , upper(anag.cognome)                        cognome
             , upper(anag.nome)                           nome
             , anag.data_nas                              data_nas
             , anag.sesso                                 sesso
             , nvl(comu_n.codice_catasto,' ')             cop_nas
             , nvl(comu_r.codice_catasto,' ')             cop_res
             , upper(anag.indirizzo_res)                  ind_res
             , anag.cap_res                               cap_res
             , decode(lpad(translate(nvl(replace(replace(replace(anag.tel_res,'/',''),'-',''),' ',''),' ')
                                    ,'0123456789','0000000000')
                           ,12,'0')
               ,'000000000000', replace(replace(replace(anag.tel_res,'/',''),'-',''),' ','')
                             , null)                      tel_res
             , decode(lpad(translate(nvl(replace(replace(replace(anag.fax_res,'/',''),'-',''),' ',''),' ')
                                     ,'0123456789','0000000000')
                          ,12,'0')
              ,'000000000000', replace(replace(replace(anag.fax_res,'/',''),'-',''),' ','')
                             , null)                      fax_res
             , anag.e_mail                                e_mail
             , trpr.fine_servizio                         fine_servizio
          from comuni                   comu_n
             , comuni                   comu_r
             , periodi_retributivi      pere
             , individui_dma            idma
             , anagrafici               anag
             , rapporti_individuali     rain
             , trattamenti_previdenziali trpr
         where anag.ni  = rain.ni
           and anag.dal =
                        (select MAX(dal)
                           from ANAGRAFICI
                          where ni  = anag.ni
                            and dal <= D_fin_mes)
           and comu_n.cod_comune        = anag.comune_nas
           and comu_n.cod_provincia     = anag.provincia_nas
           and comu_r.cod_comune        = anag.comune_res
           and comu_r.cod_provincia     = anag.provincia_res
           and trpr.codice              = pere.trattamento
           and pere.periodo             = last_day(to_date(lpad(D_mese,2,'0')||D_anno,'mmyyyy'))
           and pere.ci                  = rain.ci
           and pere.competenza          = 'A'
           and not exists
              (select 'x' from denuncia_dma
                where anno = D_anno
                  and mese = D_mese
                  and ci   = rain.ci
                  and ci >= nvl(D_ultimo_ci,0)
                  and gestione in (select codice
                                     from gestioni
                                    where codice_fiscale = CUR_GEST.codice_fiscale)
              )
           and exists
              (select 'x' from denuncia_dma_quote
                where anno = D_anno
                  and mese = D_mese
                  and ci   = rain.ci
                  and ci >= nvl(D_ultimo_ci,0)
--  identifica i dip. con solo quote e che appartengono al file in produzione
                  and gestione in (select codice
                                     from gestioni
                                    where codice_fiscale = CUR_GEST.codice_fiscale)
--  identifica i dip. con solo quote e che appartengono al frontespizio in trattamento
                  and gestione in (select codice
                                     from gestioni
                                    where codice_fiscale = GEST_APP.codice_fiscale)
              )
           and idma.anno    = D_anno
           and idma.mese    = D_mese
           and idma.ci      = rain.ci
           and idma.cf_dic  = CUR_GEST.codice_fiscale
           and idma.cf_app  = GEST_APP.codice_fiscale
        order by 2,1
          )
        LOOP
          -- estraggo il valore della casella 010 per il cambio di residenza (lo abbiamo inteso come cambio di residenza nello stesso mese di elaborazione)
          BEGIN
            select 'x'
              into D_temp
              from dual
             where exists (select *
                     from denuncia_dma
                    where ci = CUR_ANA.ci
                      and anno||lpad(mese,2,'0') < D_anno||lpad(D_mese,2,'0')
                      and gestione in (select codice
                                         from gestioni
                                        where codice_fiscale = CUR_GEST.codice_fiscale)
                                      )
            ;
            -- l'individuo ha giu un record su denuncia_dma per un mese o anno precedente devo controllare se ha cambiato residenza
            select count(*)
              into D_count
              from anagrafici           anag
                 , rapporti_individuali rain
                 , comuni               comu
             where rain.ci  = CUR_ANA.ci
               and anag.ni  = rain.ni
               and anag.dal < CUR_ANA.dal
               and to_char(anag.al,'mmyyyy') = lpad(D_mese,2,'0')||D_anno
               and comu.cod_comune        = anag.comune_res
               and comu.cod_provincia     = anag.provincia_res
               and (comu.codice_catasto          != CUR_ANA.cop_res
                    or anag.cap_res              != CUR_ANA.cap_res
                    or upper(anag.indirizzo_res) != CUR_ANA.ind_res
                   )
            ;
            -- se D_count e maggiore di zero vuol dire che ha cambiato residenza
            if d_count > 0 then
              D_cas_010 := '1';
            else
              D_cas_010 := ' ';
            end if;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              D_cas_010 := ' ';
          END;
          -- estraggo il valore della casella 015 per il fine servizio
          BEGIN
            select max(to_char(fine_servizio))
              into D_cas_015
              from denuncia_dma dedm
             where dedm.ci = CUR_ANA.ci
               and anno = D_anno
               and mese = D_mese
               and dal  = (select max(dal)
                             from denuncia_dma
                            where ci = dedm.ci
                              and anno = D_anno
                              and mese = D_mese
                              and gestione in (select codice
                                                 from gestioni
                                                where codice_fiscale = CUR_GEST.codice_fiscale)
                          )
               and dedm.gestione in (select codice
                                       from gestioni
                                      where codice_fiscale = CUR_GEST.codice_fiscale)
            ;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              D_cas_015 := ' ';
          END;
          IF CUR_ANA.nr_file != NVL(Dep_nr_file,1) THEN
--          IF D_tot_invii > 1 and D_righe_lette > D_num_record and nvl(D_dep_ci,0) != CUR_ANA.ci THEN
--dbms_output.put_line('chiamata 1, numero_invio '||numero_invio);
              tot_parte   := tot_parte + 1;
              TOTALI(prenotazione,numero_invio,progr_invio,D_pagina,D_riga,D_pagina_B
                    ,D_conta_C,D_conta_D,D_num_ord,D_tardivo,D_anno,D_mese
                    ,CUR_GEST.codice_fiscale,CUR_GEST.progressivo_inpdap
                    ,GEST_APP.codice_fiscale,GEST_APP.num_b,tot_parte);
              -- inserisco il record di tipo 'Z'
              D_pagina := 950000;
              insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
              values ( prenotazione
                     , numero_invio
              	     , D_pagina
              	     , 1			-- riga fissa ad 1 per il record di tipo Z
              	     , 'Z'||
                       lpad(' ',14,' ')||
                       lpad('1',9,'0')||  	-- il numero di recordo di tipo B dovrebbe essere sempre uguale ad uno
                       lpad(D_conta_C,9,'0')||
                       lpad(D_conta_D,9,'0')||
                       rpad('0',8,'0')||
                       lpad(' ',1847,' ')||
                       'A'||
                       lpad(' ',2,' ')
                 	   )
              ;
              progr_invio   := progr_invio  + 1;
              numero_invio  := numero_invio + 3;
              D_pagina      := 0;
              D_conta_C     := 0;
              D_dep_ci      := 0;
              D_righe_lette := 0;
              INS_A(prenotazione,numero_invio,progr_invio,D_anno,D_cf_inte,CUR_GEST.codice_fiscale,D_tot_invii);
              D_pagina   := D_pagina + 1;
              D_pagina_b := D_pagina;
              INS_B(prenotazione,numero_invio,D_pagina,CUR_GEST.codice_fiscale,cur_gest.progressivo_inpdap
                   ,GEST_APP.codice_fiscale,CUR_GEST.codice_attivita,CUR_GEST.forma_giuridica,CUR_GEST.cf_software
                   ,CUR_GEST.periodo
                   ,CUR_GEST.nome,CUR_GEST.codice_catasto,CUR_GEST.indirizzo_res,CUR_GEST.cap
                   ,CUR_GEST.tel_res,CUR_GEST.fax_res,CUR_GEST.e_mail
                   ,GEST_APP.nome,GEST_APP.codice_catasto,GEST_APP.indirizzo_res,GEST_APP.cap
                   ,GEST_APP.tel_res,GEST_APP.fax_res,GEST_APP.e_mail
                   ,D_cod_fis_fir,D_cognome_fir,D_nome_fir,D_sesso_fir,D_data_nas_fir,D_com_fir
                   ,D_prov_fir,D_num_inpdap,D_data_inte,D_cf_inte
                   );
              Dep_nr_file := cur_ana.nr_file;
          END IF;
          D_prog_mod := D_prog_mod + 1;
          D_pagina   := D_pagina   + 1;
          D_num_ord  := 1;
          D_riga     := 0;
          -- inserisco a riga zero i dati informativi del dip (ci,progressivo_modulo,numero_ordine,codice_fiscale)
          -- non richiesta esplicitamente nella denuncia ma per il momento la teniamo
          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
          values ( prenotazione
                 , numero_invio
                 , D_pagina
                 , D_riga
                 , lpad(CUR_ANA.CI,8)||
                   lpad(D_prog_mod,8,' ')||  -- progressivo modulo
                   lpad(D_num_ord,8,' ')||   -- numero ordine
                   rpad(CUR_GEST.codice_fiscale,16,' ')
                 )
          ;
          D_riga := 1;
          D_conta_C   := D_conta_C + 1;
          -- inserisco la sezione D0 (presente solo la prima volta per ogni dipendente)
          insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
          values ( prenotazione
                 , numero_invio
                 , D_pagina
                 , D_riga
            		 , 'C'||
                   rpad(CUR_GEST.codice_fiscale,11,' ')||
                   lpad(nvl(to_char(CUR_GEST.progressivo_inpdap),'0'),5,'0')||
                   lpad(D_prog_mod,8,'0')||  -- progressivo modulo
                   rpad(' ',7,' ')||
                   rpad(GEST_APP.codice_fiscale,11,' ')||
                   rpad(CUR_GEST.codice_fiscale,11,' ')||
                   lpad(nvl(to_char(CUR_GEST.progressivo_inpdap),'0'),5,'0')||
                   rpad(' ',7,' ')||
                   rpad(CUR_ANA.cod_fis,16,' ')||
                   rpad(' ',7,' ')||
                   'D0'||LPAD(to_char(D_num_ord),3,'0')||'001'
                       ||rpad(CUR_ANA.cod_fis,16,' ')||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'002'
                       ||RPAD(SUBSTR(nvl(CUR_ANA.cognome,' '),1,16),16,' ')||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'002'
                       ||DECODE( GREATEST(16,nvl(LENGTH(CUR_ANA.cognome),0))
                               , 16, RPAD(' ',16,' ')
                                   , '+'||RPAD(SUBSTR(CUR_ANA.cognome,17,15)
                                              ,15,' ')
                               )||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'002'
                       ||DECODE( GREATEST(31,nvl(LENGTH(CUR_ANA.cognome),0))
                               , 31, RPAD(' ',16,' ')
                                   , '+'||RPAD(SUBSTR(CUR_ANA.cognome,32,15)
                                              ,15,' ')
                               )||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'003'
                       ||RPAD(SUBSTR(nvl(CUR_ANA.nome,' '),1,16),16,' ')||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'003'
                       ||DECODE( GREATEST(16,nvl(LENGTH(CUR_ANA.nome),0))
                               , 16, RPAD(' ',16,' ')
                                   , '+'||RPAD(SUBSTR(CUR_ANA.nome,17,15)
                                              ,15,' ')
                               )||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'003'
                       ||DECODE( GREATEST(31,nvl(LENGTH(CUR_ANA.nome),0))
                               , 31, RPAD(' ',16,' ')
                                   , '+'||RPAD(SUBSTR(CUR_ANA.nome,32,15)
                                              ,15,' ')
                               )||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'004'
                       ||rpad(CUR_ANA.sesso,16,' ')||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'005'
                       ||LPAD(NVL(TO_CHAR(CUR_ANA.data_nas,'ddmmyyyy'),' '),16,' ')||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'006'
                       ||rpad(CUR_ANA.cop_nas,16,' ')||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'007'
                       ||rpad(CUR_ANA.cop_res,16,' ')||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'008'
                       ||RPAD(SUBSTR(nvl(CUR_ANA.ind_res,' '),1,16),16,' ')||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'008'
                       ||DECODE( GREATEST(16,LENGTH(nvl(CUR_ANA.ind_res,' ')))
                               , 16, RPAD(' ',16,' ')
                                   , '+'||RPAD(SUBSTR(CUR_ANA.ind_res,17,15)
                                              ,15,' ')
                               )||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'008'
                       ||DECODE( GREATEST(31,LENGTH(nvl(CUR_ANA.ind_res,' ')))
                               , 31, RPAD(' ',16,' ')
                                   , '+'||RPAD(SUBSTR(CUR_ANA.ind_res,32,15)
                                              ,15,' ')
                               )||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'009'
                       ||lpad(nvl(CUR_ANA.cap_res,' '),16,' ')||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'010'
                       ||rpad(D_cas_010,16,' ')||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'011'
                       ||rpad(nvl(CUR_ANA.tel_res,' '),16,' ')||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'012'
                       ||rpad(nvl(CUR_ANA.fax_res,' '),16,' ')||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'013'
                       ||RPAD(SUBSTR(nvl(CUR_ANA.e_mail,' '),1,16),16,' ')||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'013'
                       ||DECODE( GREATEST(16,LENGTH(nvl(CUR_ANA.e_mail,' ')))
                               , 16, RPAD(' ',16,' ')
                                   , '+'||RPAD(SUBSTR(CUR_ANA.e_mail,17,15)
                                              ,15,' ')
                               )||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'013'
                       ||DECODE( GREATEST(31,LENGTH(nvl(CUR_ANA.e_mail,' ')))
                               , 31, RPAD(' ',16,' ')
                                   , '+'||RPAD(SUBSTR(CUR_ANA.e_mail,32,15)
                                              ,15,' ')
                               )||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'013'
                       ||DECODE( GREATEST(46,LENGTH(nvl(CUR_ANA.e_mail,' ')))
                               , 46, RPAD(' ',16,' ')
                                   , '+'||RPAD(SUBSTR(CUR_ANA.e_mail,47,15)
                                              ,15,' ')
                               )||
                   'D0'||LPAD(TO_CHAR(D_num_ord),3,'0')||'015'
                       ||lpad(nvl(to_char(CUR_ANA.fine_servizio),' '),16,' ')
                 )
          ;
          D_CONTA_DETT  := 0;
          FOR CUR_E0_V1 IN
            (select decode(D_tardivo,'X','V1',rilevanza) rilevanza
                  , dal
                  , al
                  , decode(D_tardivo||rilevanza,'XE0',nvl(tipo_aliquota,'1'),tipo_aliquota) tipo_aliquota
                  , decode(D_tardivo||rilevanza,'XE0','2',causale_variazione) causale_variazione
                  , cassa_pensione
                  , cassa_previdenza
                  , decode( D_forza_credito
                          , 'N', cassa_credito
                          , 'A', decode( nvl(contr_cassa_credito,0)
                                       , 0, null
                                          , cassa_credito)
                               , decode( nvl(ipn_cassa_credito,0)+nvl(contr_cassa_credito,0)
                                       , 0, null
                                          , '9')) cassa_credito
                  , cassa_enpdedp
                  , dedm.codice
                  , posizione
                  , nvl(decode(qualifica
                                ,'OTPRAN', null
                                ,'OTPRPN', null
                                ,'OTPRSN', null
                                ,'OTPRTN', null
                                         , qualifica
                               ) ,'999999') qualifica
                  , causa_cessazione
                  , tipo_impiego
                  , tipo_servizio
                  , tipo_part_time
                  , translate(perc_part_time,'.',',') perc_part_time
                  , ore_ridotte
                  , gg_utili
                  , substr(maggiorazioni,1,3)   mag_1
                  , substr(maggiorazioni,4,6)   mag_2
                  , substr(maggiorazioni,7,9)   mag_3
                  , substr(maggiorazioni,10,12) mag_4
                  , gg_mag_1
                  , gg_mag_2
                  , gg_mag_3
                  , gg_mag_4
                  , decode( sign(magg_l165)
                          , -1, decode(rilevanza,'E0',null,magg_l165)
                              , magg_l165) magg_l165
                  , decode( sign(comp_fisse)
                          , -1, decode(rilevanza,'E0',null,comp_fisse)
                              , comp_fisse) comp_fisse
                  , decode( sign(comp_accessorie)
                          , -1, decode(rilevanza,'E0',null,comp_accessorie)
                              , comp_accessorie) comp_accessorie
                  , decode( sign(comp_18)
                          , -1, decode(rilevanza,'E0',null,comp_18)
                              , comp_18) comp_18
                  , decode( sign(iis_conglobata)
                          , -1, decode(rilevanza,'E0',null,iis_conglobata)
                              , iis_conglobata) iis_conglobata
                  , decode( sign(ind_non_a)
                          , -1, decode(rilevanza,'E0',null,ind_non_a)
                              , ind_non_a) ind_non_a
                  , decode( sign(ipn_pens_periodo)
                          , -1, decode(rilevanza,'E0',null,ipN_pens_periodo)
                              , ipn_pens_periodo) ipn_pens_periodo
                  , decode( sign(contr_pens_periodo)
                          , -1, decode(rilevanza,'E0',null,contr_pens_periodo)
                              , contr_pens_periodo) contr_pens_periodo
                  , decode( sign(contr_su_eccedenza)
                          , -1, decode(rilevanza,'E0',null,contr_su_eccedenza)
                              , contr_su_eccedenza) contr_su_eccedenza
                  , decode( sign(ipn_tfs)
                          , -1, decode(rilevanza,'E0',null,ipn_tfs)
                              , ipn_tfs) ipn_tfs
                  , decode( sign(contr_tfs)
                          , -1, decode(rilevanza,'E0',null,contr_tfs)
                              , contr_tfs) contr_tfs
                  , decode( sign(ipn_tfr)
                          , -1, decode(rilevanza,'E0',null,ipn_tfr)
                              , ipn_tfr) ipn_tfr
                  , decode( sign(contr_ipn_tfr)
                          , -1, decode(rilevanza,'E0',null,contr_ipn_tfr)
                              , contr_ipn_tfr) contr_ipn_tfr
                  , decode( sign(ult_ipn_tfr)
                          , -1, decode(rilevanza,'E0',null,ult_ipn_tfr)
                              , ult_ipn_tfr) ult_ipn_tfr
                  , decode( sign(contr_ult_ipn_tfr)
                          , -1, decode(rilevanza,'E0',null,contr_ult_ipn_tfr)
                              , contr_ult_ipn_tfr) contr_ult_ipn_tfr
                  , decode( D_forza_credito
                          , 'A', decode( nvl(contr_cassa_credito,0)
                                       , 0, null
                                          , decode( sign(ipn_cassa_credito)
                                                  , -1, decode(rilevanza
                                                              ,'E0',null,ipn_cassa_credito)
                                                      , ipn_cassa_credito)
                                       )
                               , decode( sign(ipn_cassa_credito)
                                       , -1, decode(rilevanza,'E0',null,ipn_cassa_credito)
                                           , ipn_cassa_credito)
                          ) ipn_cassa_credito
                  , decode( D_forza_credito
                          , 'F', decode( sign(nvl(ipn_cassa_credito,0))
                                       , -1, decode(rilevanza
                                                   , 'E0', null, decode(nvl(contr_cassa_credito,0)
                                                                       , 0, -0.01
                                                                          , contr_cassa_credito)
                                                                       )
                                       , 0, null
                                          , decode(nvl(contr_cassa_credito,0)
                                                  , 0, 0.01
                                                     , contr_cassa_credito)
                                       )
                               , decode( sign(contr_cassa_credito)
                                       , -1, decode(rilevanza
                                                   ,'E0',null,contr_cassa_credito)
                                           , contr_cassa_credito)
                          ) contr_cassa_credito
                  , decode( sign(contr_enpdedp)
                          , -1, decode(rilevanza,'E0',null,contr_enpdedp)
                              , contr_enpdedp) contr_enpdedp
                  , decode( sign(tredicesima)
                          , -1, decode(rilevanza,'E0',null,tredicesima)
                              , tredicesima) tredicesima
                  , decode( sign(retr_teorico_tfr)
                          , -1, decode(rilevanza,'E0',null,retr_teorico_tfr)
                              , retr_teorico_tfr) retr_teorico_tfr
                  , decode( sign(retr_utile_tfr)
                          , -1, decode(rilevanza,'E0',null,retr_utile_tfr)
                              , retr_utile_tfr) retr_utile_tfr
                  , decode( sign(quota_solidarieta_l166)
                          , -1, decode(rilevanza,'E0',null,quota_solidarieta_l166)
                              , quota_solidarieta_l166) quota_solidarieta_l166
                  , decode( sign(contr_solidarieta_l166)
                          , -1, decode(rilevanza,'E0',null,contr_solidarieta_l166)
                              , contr_solidarieta_l166) contr_solidarieta_l166
                  , decode( sign(retr_l135)
                          , -1, decode(rilevanza,'E0',null,retr_l135)
                              , retr_l135) retr_l135
                  , decode( sign(contr_solidarieta_l135)
                          , -1, decode(rilevanza,'E0',null,contr_solidarieta_l135)
                              , contr_solidarieta_l135) contr_solidarieta_l135
                  , data_fine_calamita
                  , decode( sign(contr_pens_calamita)
                          , -1, decode(rilevanza,'E0',null,contr_pens_calamita)
                              , contr_pens_calamita) contr_pens_calamita
                  , decode( sign(contr_prev_calamita)
                          , -1, decode(rilevanza,'E0',null,contr_prev_calamita)
                              , contr_prev_calamita) contr_prev_calamita
                  , sanzione_pensione
                  , sanzione_previdenza
                  , sanzione_credito
                  , sanzione_enpdedp
                  , substr(to_char(data_sanzioni,'ddmmyyyy'),1,8) data_sanzioni
                  , tipo_accertamento
                  , translate(perc_l300,'.',',') perc_l300
                  , gest.comparto
                  , gest.sottocomparto
                  , decode( dedm.cf_amm_fisse
                          , null, null
                                , decode( dedm.tipo_impiego
                                        , '1' , '1'
                                        , '2' , '1'
                                        , '5' , '1'
                                        , '6' , '1'
                                        , '8' , '1'
                                        , '9' , '1'
                                        , '10', '1'
                                        , '13', '1'
                                        , '14', '1'
                                              , null)
                          ) tc_pens
                  , decode( dedm.cassa_pensione
                                        , null, null
                                              , dedm.cf_amm_fisse)  cfv_pens
                  , decode( dedm.cf_amm_fisse
                          , null, null
                                , decode( dedm.cassa_pensione
                                        , null, null
                                              , ipn_pens_periodo)
                          ) ipn_pens_vers
                  , decode( dedm.cf_amm_fisse
                          , null, null
                                , decode( dedm.cassa_pensione
                                        , null, null
                                              , contr_pens_periodo)
                          ) contr_pens_vers
                  , decode( dedm.cf_amm_fisse
                          , null, null
                                , decode( dedm.cassa_previdenza
                                        , null, null
                                              , decode( nvl(ipn_tfr,0)
                                                      , 0, '7'
                                                         , '8')
                                        )
                          ) tc_prev
                  , decode( dedm.cassa_previdenza
                                        , null, null
                                              , dedm.cf_amm_fisse)  cfv_prev
                  , decode( dedm.cf_amm_fisse
                          , null, null
                                , decode( dedm.cassa_previdenza
                                        , null, null
                                              , nvl(ipn_tfr,ipn_tfs))
                          ) ipn_prev_vers
                  , decode( dedm.cf_amm_fisse
                          , null, null
                                , decode( dedm.cassa_previdenza
                                        , null, null
                                              , nvl(contr_ipn_tfr,contr_tfs))
                          ) contr_prev_vers
                  , decode( dedm.cf_amm_fisse
                          , null, null
                                , decode( dedm.cassa_credito
                                        , null, null
                                              , '9')
                          ) tc_cred
                  , decode( dedm.cassa_credito
                                        , null, null
                                              , dedm.cf_amm_fisse)  cfv_cred
                  , decode( dedm.cf_amm_fisse
                          , null, null
                                , decode( dedm.cassa_credito
                                        , null, null
                                              , ipn_cassa_credito)
                          ) ipn_cred_vers
                  , decode( dedm.cf_amm_fisse
                          , null, null
                                , decode( dedm.cassa_credito
                                        , null, null
                                              , contr_cassa_credito)
                          ) contr_cred_vers
               from denuncia_dma dedm
                  , gestioni gest
              where mese = D_mese
                and anno = D_anno
                and ci   = CUR_ANA.ci
                and fine_servizio = CUR_ANA.fine_servizio
                and gestione in (select codice
                                   from gestioni
                                  where codice_fiscale = CUR_GEST.codice_fiscale)
                and nvl(gestione_app,gestione) in
                   (select codice
                      from gestioni
                     where codice_fiscale = GEST_APP.codice_fiscale)
                and gest.codice = dedm.gestione
              order by rilevanza, dal
            )
          LOOP
--dbms_output.put_line('ipn_tfr:'||CUR_E0_V1.ipn_tfr);
--dbms_output.put_line('contr_tfr:'||CUR_E0_V1.contr_ipn_tfr);
            BEGIN
              D_righe_lette := D_righe_lette + 1;
              D_conta_dett  := D_conta_dett  + 1;
              IF D_conta_dett = 1 THEN
                 null;
              ELSIF nvl(D_rilevanza,CUR_E0_V1.rilevanza) != CUR_E0_V1.rilevanza THEN -- Riparte il num_ord se la rilevanza e divesa per lo stesso ci
                 D_num_ord   := 1;
              ELSE
                 D_num_ord   := D_num_ord + 1;
              END IF;
              D_rilevanza := CUR_E0_V1.rilevanza;
              D_ci        := CUR_ANA.ci;
              D_riga      := D_riga + 1;
              -- inserisco la sezione E0_V1
              insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
              values
              ( prenotazione
              , numero_invio
              , D_pagina
              , D_riga
              , CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'000'
                    ||lpad(nvl(CUR_E0_V1.causale_variazione,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'001'
                    ||lpad(nvl(to_char(CUR_E0_V1.dal,'ddmmyyyy'),' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'002'
                    ||lpad(nvl(to_char(CUR_E0_V1.al,'ddmmyyyy'),' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'003'
                    ||lpad(nvl(CUR_E0_V1.cassa_pensione,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'004'
                    ||lpad(nvl(CUR_E0_V1.cassa_previdenza,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'005'
                    ||lpad(nvl(CUR_E0_V1.cassa_credito,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'006'
                    ||lpad(nvl(CUR_E0_V1.cassa_enpdedp,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'007'
                    ||rpad(decode(CUR_E0_V1.qualifica
                                 ,'999999', '99'
                                          , nvl(CUR_E0_V1.comparto,' ')),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'008'
                    ||rpad(decode(CUR_E0_V1.qualifica
                                 ,'999999', '99'
                                          , nvl(CUR_E0_V1.sottocomparto,' ')),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'009'
                    ||rpad(nvl(CUR_E0_V1.qualifica,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'010'
                    ||lpad(nvl(CUR_E0_V1.causa_cessazione,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'011'
                    ||lpad(nvl(CUR_E0_V1.tipo_impiego,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'012'
                    ||lpad(nvl(CUR_E0_V1.tipo_servizio,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'013'
                    ||rpad(nvl(CUR_E0_V1.tipo_part_time,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'014'
                    ||lpad(nvl(CUR_E0_V1.perc_part_time,' '),16,' ')|| -- da rivedere la perc_part_time
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'015'
                    ||decode( CUR_E0_V1.perc_part_time
                            , null, lpad(nvl(to_char(CUR_E0_V1.gg_utili),' '),16,' ')
                                  , lpad(' ',16,' ')
                            ) ||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'016'
                    ||lpad(nvl(CUR_E0_V1.mag_1,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'017'
                    ||lpad(nvl(to_char(CUR_E0_V1.gg_mag_1),' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'018'
                    ||lpad(nvl(CUR_E0_V1.mag_2,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'019'
                    ||lpad(nvl(to_char(CUR_E0_V1.gg_mag_2),' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'020'
                    ||lpad(nvl(CUR_E0_V1.mag_3,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'021'
                    ||lpad(nvl(to_char(CUR_E0_V1.gg_mag_3),' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'022'
                    ||lpad(nvl(CUR_E0_V1.mag_4,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'023'
                    ||lpad(nvl(to_char(CUR_E0_V1.gg_mag_4),' '),16,' ')||
                DECODE(CUR_E0_V1.RILEVANZA
                      ,'E0',NULL
                           ,CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'024'
                                               ||lpad(nvl(to_char(CUR_E0_V1.tipo_aliquota),' '),16,' '))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'025'
                    ||format_dati( nvl(CUR_E0_V1.magg_l165,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'026'
                    ||format_dati( nvl(CUR_E0_V1.comp_fisse,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'027'
                    ||format_dati( nvl(CUR_E0_V1.comp_accessorie,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'028'
                    ||format_dati( nvl(CUR_E0_V1.comp_18,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'029'
                    ||format_dati( nvl(CUR_E0_V1.iis_conglobata,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'031'
                    ||format_dati( nvl(CUR_E0_V1.ind_non_a,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'032'
                    ||format_dati( nvl(CUR_E0_V1.ipn_pens_periodo,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'033'
                    ||format_dati( nvl(CUR_E0_V1.contr_pens_periodo,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'034'
                    ||format_dati( nvl(CUR_E0_V1.contr_su_eccedenza,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'035'
                    ||format_dati( nvl(CUR_E0_V1.ipn_tfs,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'036'
                    ||format_dati( nvl(CUR_E0_V1.contr_tfs,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'A37'
                    ||format_dati( nvl(CUR_E0_V1.ipn_tfr,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'A38'
                    ||format_dati( nvl(CUR_E0_V1.contr_ipn_tfr,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'039'
                    ||format_dati( nvl(CUR_E0_V1.ipn_cassa_credito,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'040'
                    ||format_dati( nvl(CUR_E0_V1.contr_cassa_credito,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'041'
                    ||format_dati( nvl(CUR_E0_V1.contr_enpdedp,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'042'
                    ||format_dati( nvl(CUR_E0_V1.tredicesima,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'043'
                    ||format_dati( nvl(CUR_E0_V1.retr_teorico_tfr,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'044'
                    ||format_dati( nvl(CUR_E0_V1.retr_utile_tfr,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'045'
                    ||format_dati( nvl(CUR_E0_V1.quota_solidarieta_l166,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'046'
                    ||format_dati( nvl(CUR_E0_V1.contr_solidarieta_l166,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'047'
                    ||format_dati( nvl(CUR_E0_V1.retr_l135,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'048'
                    ||format_dati( nvl(CUR_E0_V1.contr_solidarieta_l135,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'049'
                    ||lpad(nvl(to_char(CUR_E0_V1.data_fine_calamita,'ddmmyyyy'),' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'050'
                    ||format_dati( nvl(CUR_E0_V1.contr_pens_calamita,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'051'
                    ||format_dati( nvl(CUR_E0_V1.contr_prev_calamita,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'052'
                    ||decode( CUR_E0_V1.rilevanza
                            , 'E0', lpad(' ',16,' ')
                                  , format_dati( nvl(CUR_E0_V1.sanzione_pensione,0))
                           )||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'053'
                    ||decode( CUR_E0_V1.rilevanza
                            , 'E0', lpad(' ',16,' ')
                                  , format_dati( nvl(CUR_E0_V1.sanzione_previdenza,0)
                                          )
                            )||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'054'
                    ||decode( CUR_E0_V1.rilevanza
                            , 'E0', lpad(' ',16,' ')
                                  , format_dati( nvl(CUR_E0_V1.sanzione_credito,0))
                            )||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'055'
                    ||decode( CUR_E0_V1.rilevanza
                            , 'E0', lpad(' ',16,' ')
                                  , format_dati( nvl(CUR_E0_V1.sanzione_enpdedp,0))
                            )||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'057'
                    ||lpad(nvl(CUR_E0_V1.tipo_accertamento,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'058'
                    ||lpad(nvl(CUR_E0_V1.data_sanzioni,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'059'
                    ||lpad(nvl(to_char(CUR_E0_V1.ore_ridotte),' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'060'
                    ||lpad(nvl(CUR_E0_V1.perc_l300,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'A61'
                    ||lpad(nvl(CUR_E0_V1.tc_pens,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'B61'
                    ||lpad(nvl(CUR_E0_V1.cfv_pens,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'E61'
                    ||format_dati(nvl(CUR_E0_V1.ipn_pens_vers,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'F61'
                    ||format_dati(nvl(CUR_E0_V1.contr_pens_vers,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'A62'
                    ||lpad(nvl(CUR_E0_V1.tc_prev,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'B62'
                    ||lpad(nvl(CUR_E0_V1.cfv_prev,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'E62'
                    ||format_dati(nvl(CUR_E0_V1.ipn_prev_vers,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'F62'
                    ||format_dati(nvl(CUR_E0_V1.contr_prev_vers,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'A63'
                    ||lpad(nvl(CUR_E0_V1.tc_cred,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'B63'
                    ||lpad(nvl(CUR_E0_V1.cfv_cred,' '),16,' ')||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'E63'
                    ||format_dati(nvl(CUR_E0_V1.ipn_cred_vers,0))||
                CUR_E0_V1.rilevanza||lpad(to_char(D_num_ord),3,'0')||'F63'
                    ||format_dati( nvl(CUR_E0_V1.contr_cred_vers,0))
           )
           ;
          END;
          END LOOP;
          D_num_ord := 0;
       IF D_Dep_ci != CUR_ANA.ci THEN
          FOR CUR_F1 IN
             (select lpad(riferimento,6,'0') riferimento
                   , cassa
                   , tipo_amm
                   , scadenza
                   , abs(importo) importo
                   , operazione
                   , sanzione
                   , cf_versante
                from denuncia_dma_quote
               where anno = D_anno
                 and mese = D_mese
                 and ci   = CUR_ANA.ci
                 and gestione in (select codice
                                    from gestioni
                                   where codice_fiscale = CUR_GEST.codice_fiscale)
             ) LOOP
                 D_num_ord   := D_num_ord + 1;
                 D_riga      := D_riga + 1;
                 insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                 values
                       ( prenotazione
                       , numero_invio
                       , D_pagina
                       , D_riga
                       , 'F1'||lpad(to_char(D_num_ord),3,'0')||'001'
                         ||lpad(nvl(CUR_F1.riferimento,' '),16,' ')||
                         'F1'||lpad(to_char(D_num_ord),3,'0')||'002'
                         ||lpad(nvl(CUR_F1.cassa,' '),16,' ')||
                         'F1'||lpad(to_char(D_num_ord),3,'0')||'003'
                         ||lpad(nvl(CUR_F1.tipo_amm,' '),16,' ')||
                         'F1'||lpad(to_char(D_num_ord),3,'0')||'004'
                         ||lpad(nvl(to_char(CUR_F1.scadenza,'ddmmyyyy'),' '),16,' ')||
                         'F1'||lpad(to_char(D_num_ord),3,'0')||'005'
                         ||format_dati( nvl(CUR_F1.importo,0))||
                         'F1'||lpad(to_char(D_num_ord),3,'0')||'006'
                         ||format_dati( nvl(CUR_F1.sanzione,0))||
                         'F1'||lpad(to_char(D_num_ord),3,'0')||'007'
                         ||lpad(nvl(CUR_F1.operazione,' '),16,' ')||
                         'F1'||lpad(to_char(D_num_ord),3,'0')||'008'
                         ||rpad(nvl(to_char(CUR_F1.cf_versante),' '),16,' ')
                       );
               END LOOP; -- cur_f1
          END IF;
          D_Dep_ci := CUR_ANA.ci;
          END LOOP; -- CUR_ANA
--dbms_output.put_line('chiamata 2/ numero invio: '||numero_invio);
          tot_parte   := tot_parte + 1;
          TOTALI(prenotazione,numero_invio,progr_invio,D_pagina,D_riga,D_pagina_B
                ,D_conta_C,D_conta_D,D_num_ord,D_tardivo,D_anno,D_mese
                ,CUR_GEST.codice_fiscale,CUR_GEST.progressivo_inpdap
                ,GEST_APP.codice_fiscale,GEST_APP.num_b,tot_parte);
          TOTALI_Z2(prenotazione,numero_invio,D_pagina,D_riga,D_pagina_B
                   ,D_num_ord,D_anno,D_mese
                   ,CUR_GEST.codice_fiscale,CUR_GEST.progressivo_inpdap
                   ,GEST_APP.codice_fiscale,GEST_APP.num_b,tot_z2);
      END;
      Dep_tot_z2 := tot_z2;
      Dep_num_b  := GEST_APP.num_b;
      Dep_cf_app := GEST_APP.codice_fiscale;
     END LOOP; -- GEST_APP
     Dep_invio := numero_invio;
   END LOOP; -- CUR_GEST
    -- inserisco il record di tipo 'Z'
    D_pagina := 950000;
--dbms_output.put_line('numero invio: '||numero_invio||'DEP invio: '||dep_invio);
    insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
    values ( prenotazione
           , numero_invio
    	     , D_pagina
	         , 1			-- riga fissa ad 1 per il record di tipo Z
	         , 'Z'||
             lpad(' ',14,' ')||
             lpad('1',9,'0')||  	-- il numero di recordo di tipo B dovrebbe essere sempre uguale ad uno
             lpad(D_conta_C,9,'0')||
             lpad(D_conta_D,9,'0')||
             rpad('0',8,'0')||
             lpad(' ',1847,' ')||
             'A'||
             lpad(' ',2,' ')
		       )
    ;
  END;  -- fine corpo
  IF D_tot_invii > 1 THEN
     select sum(substr(testo,968,8))
          , sum(substr(testo,976,8))
       into tot_iscritti,tot_z1
       from a_appoggio_stampe
      where no_prenotazione = PRENOTAZIONE
        and substr(testo,1,1) = 'B'
     ;
     update a_appoggio_stampe
        set testo = substr(testo,1,967)||
                    lpad(to_char(tot_iscritti),8,'0')||
                    lpad(to_char(tot_z1),8,'0')||
                    lpad(to_char(nvl(Dep_tot_z2,0)),8,'0')||
                    substr(testo,992,37)||
                    substr(testo,968,16)||
                    substr(testo,1045)
      where no_prenotazione = PRENOTAZIONE
        and substr(testo,1,1) = 'B'
     ;
 END IF;
 EXCEPTION
   WHEN ERRORE THEN
     null;
 END;
END;
END;
/
