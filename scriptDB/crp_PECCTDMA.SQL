CREATE OR REPLACE PACKAGE PECCTDMA IS
/******************************************************************************
 NOME:          PECCTDMA CALCOLO TOTALI DMA
 DESCRIZIONE:
      Questa calcola i totali della denuncia DMA.
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
 1    09/07/2007 ML     Prima Emissione (A21942)
 1.1  24/09/2207 ML     Chiave doppia in TOZ2_pk, totali errati (A22984).
 1.2  08/10/2007 ML     Gestione Z2 "doppi" (A23179)
 1.3  22/10/2007 ML     Gestione distacchi funzionali (A23457).
******************************************************************************/
FUNCTION  VERSIONE                        RETURN VARCHAR2;
PROCEDURE MAIN  (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
PROCEDURE TOTALI ( tot_cf            in varchar2
                 , tot_cf_app        in varchar2
                 , tot_cf_vers       in varchar2
                 , tot_nr_file       in number
                 , tot_forza_credito in varchar2
                 , tot_anno          in number
                 , tot_mese          in number
                 );
PROCEDURE TOTALI_Z2 ( tot_cf     in VARCHAR2
                    , tot_anno   in NUMBER
                    , tot_mese   in NUMBER
                    );
END;
/
CREATE OR REPLACE PACKAGE BODY PECCTDMA IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
  BEGIN
    RETURN 'V1.3 del 22/10/2007';
 END VERSIONE;
PROCEDURE TOTALI ( tot_cf            in varchar2
                 , tot_cf_app        in varchar2
                 , tot_cf_vers       in varchar2
                 , tot_nr_file       in number
                 , tot_forza_credito in varchar2
                 , tot_anno          in number
                 , tot_mese          in number
                 ) IS
BEGIN
   DECLARE
     D_t031       number;
     D_t032       number;
     D_t033       number;
     D_t034       number;
     D_t035       number;
     D_t036       number;
     D_t037       number;
     BEGIN
       FOR CUR_TOT IN
          (select nvl( to_char(riferimento)
                     , decode( to_char(dal,'mmyyyy')
                             , lpad(tot_mese,2,'0')||tot_anno, lpad(tot_mese,2,'0')||tot_anno
                                                             , to_char(tot_anno))
                     )                                    riferimento
                , nvl(tipo_aliquota,1)                    tipo_aliquota
                , cassa_pensione                          T004
                , sum(decode(tipo_impiego,'1'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                         ,'2'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                         ,'5'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                         ,'6'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                         ,'8'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                         ,'9'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
,'10',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
,'13',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
,'14',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
,'17',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
,'18',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                              , 0
                            )
                     )  T007
                , sum(decode(tipo_impiego,'1'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                         ,'2'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                         ,'5'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                         ,'6'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                         ,'8'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                         ,'9'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
,'10',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
,'13',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
,'14',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
,'17',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
,'18',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                              , 0
                           )
                     )  T008
                , sum(decode(tipo_impiego,'3'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
,'15',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                              , 0
                            )
                     )  T009
                , sum(decode(tipo_impiego,'3'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
,'15',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                              , 0
                            )
                     )  T010
                , sum(decode(tipo_impiego,'4'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                         ,'7'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
,'16',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                              , 0
                            )
                     )  T011
                , sum(decode(tipo_impiego,'4'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                         ,'7'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
,'16',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                              , 0
                            )
                     )  T012
                ,
sum(decode(tipo_impiego,'11',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                              ,0))    T013
                ,
sum(decode(tipo_impiego,'11',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                              ,0))  T014
                ,
sum(decode(tipo_impiego,'12',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                              ,0))    T015
                ,
sum(decode(tipo_impiego,'12',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                              ,0))  T016
                , sum(decode(rilevanza,'E0',decode(sign(retr_l135),-1,0,retr_l135)
                                           ,retr_l135))              T017
                ,
sum(decode(rilevanza,'E0',decode(sign(contr_solidarieta_l135),-1,0,contr_solidarieta_l135)
                                           ,contr_solidarieta_l135))                        T018
                ,
sum(decode(rilevanza,'E0',decode(sign(contr_su_eccedenza*100),-1,0,contr_su_eccedenza*100)
                                           ,contr_su_eccedenza*100))                        T019
                , sum(decode(rilevanza,'E0',decode(sign(contr_su_eccedenza),-1,0,contr_su_eccedenza)
                                           ,contr_su_eccedenza))                            T020
                ,
sum(decode(rilevanza,'E0',decode(sign(quota_solidarieta_l166),-1,0,quota_solidarieta_l166)
                                           ,quota_solidarieta_l166))                        T021
                ,
sum(decode(rilevanza,'E0',decode(sign(contr_solidarieta_l166),-1,0,contr_solidarieta_l166)
                                           ,contr_solidarieta_l166))                        T022
                , 0 T023
                , 0 T024
                , 0 TA25
                , 0 TB25
                , 0 TA26
                , 0 TB26
                , 0 T027
                , 0 T028
                , 0 T029
                , 0 T030
                , sum(decode(rilevanza,'E0',decode(sign(sanzione_pensione),-1,0,sanzione_pensione)
                                           ,sanzione_pensione))                T037
                ,
sum(decode(rilevanza,'E0',decode(sign(contr_pens_calamita),-1,0,contr_pens_calamita)
                                           ,contr_pens_calamita))              T038
             from denuncia_dma
            where anno = tot_anno
              and mese = tot_mese
              and ci  in
                 (select ci
                    from individui_dma
                   where anno       = tot_anno
                     and mese       = tot_mese
                     and nr_file    = tot_nr_file
                     and cf_dic     = tot_cf
                     and cf_app     = tot_cf_app
                     and nvl(cf_vers,tot_cf) = nvl(tot_cf_vers,' '))
              and cassa_pensione is not null
              and nvl(cf_amm_fisse,tot_cf) = nvl(tot_cf_vers,' ')
            group by cassa_pensione
                   , nvl(tipo_aliquota,1)
                   , nvl( to_char(riferimento)
                        , decode( to_char(dal,'mmyyyy')
                                , lpad(tot_mese,2,'0')||tot_anno, lpad(tot_mese,2,'0')||tot_anno
                                                                , to_char(tot_anno))
                        )
           having NVL(sum(decode(tipo_impiego,'1'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                         ,'2'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                         ,'5'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                         ,'6'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                         ,'8'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                         ,'9'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
,'10',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
,'13',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
,'14',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
,'17',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
,'18',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                              ,0
                            )
                     ),0)  != 0
               or NVL(sum(decode(tipo_impiego,'1'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                         ,'2'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                         ,'5'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                         ,'6'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                         ,'8'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                         ,'9'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
,'10',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
,'13',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
,'14',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
,'17',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
,'18',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                              ,0
                            )
                     ),0)  != 0
               or NVL(sum(decode(tipo_impiego,'3'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
,'15',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                              ,0
                            )
                     ),0)   != 0
               or NVL(sum(decode(tipo_impiego,'3'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
,'15',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                              ,0
                            )
                     ),0)   != 0
               or NVL(sum(decode(tipo_impiego,'4'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                         ,'7'
,decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
,'16',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                              ,0
                            )
                     ),0)   != 0
               or NVL(sum(decode(tipo_impiego,'4'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                         ,'7'
,decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
,'16',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                               ,0
                           )
                     ),0)   != 0
               or
NVL(sum(decode(tipo_impiego,'11',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                              ,0)),0)     != 0
               or
NVL(sum(decode(tipo_impiego,'11',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                              ,0)),0)   != 0
               or
NVL(sum(decode(tipo_impiego,'12',decode(rilevanza,'E0',decode(sign(ipn_pens_periodo),-1,0,ipn_pens_periodo)
                                                                    ,ipn_pens_periodo)
                                              ,0)),0)     != 0
               or
NVL(sum(decode(tipo_impiego,'12',decode(rilevanza,'E0',decode(sign(contr_pens_periodo),-1,0,contr_pens_periodo)
                                                                    ,contr_pens_periodo)
                                              ,0)),0)   != 0
               or NVL(sum(decode(rilevanza,'E0',decode(sign(retr_l135),-1,0,retr_l135)
                                           ,retr_l135)),0)               != 0
               or
NVL(sum(decode(rilevanza,'E0',decode(sign(contr_solidarieta_l135),-1,0,contr_solidarieta_l135)
                                           ,contr_solidarieta_l135)),0) != 0
               or
NVL(sum(decode(rilevanza,'E0',decode(sign(contr_su_eccedenza*100),-1,0,contr_su_eccedenza*100)
                                           ,contr_su_eccedenza*100)),0)   != 0
               or
NVL(sum(decode(rilevanza,'E0',decode(sign(contr_su_eccedenza),-1,0,contr_su_eccedenza)
                                           ,contr_su_eccedenza)),0)    != 0
               or
NVL(sum(decode(rilevanza,'E0',decode(sign(quota_solidarieta_l166),-1,0,quota_solidarieta_l166)
                                           ,quota_solidarieta_l166)),0)   != 0
               or
NVL(sum(decode(rilevanza,'E0',decode(sign(contr_solidarieta_l166),-1,0,contr_solidarieta_l166)
                                           ,quota_solidarieta_l166)),0)   != 0
               or
NVL(sum(decode(rilevanza,'E0',decode(sign(sanzione_pensione),-1,0,sanzione_pensione)
                                           ,sanzione_pensione)),0)     != 0
               or
NVL(sum(decode(rilevanza,'E0',decode(sign(contr_pens_calamita),-1,0,contr_pens_calamita)
                                           ,contr_pens_calamita)),0)             != 0
            union
           select nvl( to_char(riferimento)
                     , decode( to_char(dal,'mmyyyy')
                             , lpad(tot_mese,2,'0')||tot_anno, lpad(tot_mese,2,'0')||tot_anno
                                                             , to_char(tot_anno))
                     )  riferimento
                , nvl(tipo_aliquota,1)
                , cassa_previdenza  T004
                , 0 T007
                , 0 T008
                , 0 T009
                , 0 T010
                , 0 T011
                , 0 T012
                , 0 T013
                , 0 T014
                , 0 T015
                , 0 T016
                , 0 T017
                , 0 T018
                , 0 T019
                , 0 T020
                , 0 T021
                , 0 T022
                , sum(decode(rilevanza,'E0',decode(sign(ipn_tfs),-1,0,ipn_tfs)
                                           ,ipn_tfs))                          T023
                , sum(decode(rilevanza,'E0',decode(sign(contr_tfs),-1,0,contr_tfs)
                                           ,contr_tfs))                        T024
                , sum(decode(rilevanza,'E0',decode(sign(ipn_tfr),-1,0,ipn_tfr)
                                           ,ipn_tfr))                          TA25
                , sum(decode(rilevanza,'E0',decode(sign(ult_ipn_tfr),-1,0,ult_ipn_tfr)
                                           ,ult_ipn_tfr))                      TB25
                , sum(decode(rilevanza,'E0',decode(sign(contr_ipn_tfr),-1,0,contr_ipn_tfr)
                                           ,contr_ipn_tfr))                   TA26
                , sum(decode(rilevanza,'E0',decode(sign(contr_ult_ipn_tfr),-1,0,contr_ult_ipn_tfr)
                                           ,contr_ult_ipn_tfr))                TB26
                , 0 T027
                , 0 T028
                , 0 T029
                , 0 T030
                ,
sum(decode(rilevanza,'E0',decode(sign(sanzione_previdenza),-1,0,sanzione_previdenza)
                                           ,sanzione_previdenza))              T037
                ,
sum(decode(rilevanza,'E0',decode(sign(contr_prev_calamita),-1,0,contr_prev_calamita)
                                           ,contr_prev_calamita))              T038
             from denuncia_dma
            where anno = tot_anno
              and mese = tot_mese
              and ci  in
                 (select ci
                    from individui_dma
                   where anno     = tot_anno
                     and mese     = tot_mese
                     and nr_file  = tot_nr_file
                     and cf_dic   = tot_cf
                     and cf_app   = tot_cf_app
                     and nvl(cf_vers,tot_cf) = nvl(tot_cf_vers,' '))
              and cassa_previdenza is not null
              and nvl(cf_amm_fisse,tot_cf) = nvl(tot_cf_vers,' ')
            group by cassa_previdenza
                ,nvl( to_char(riferimento)
                     , decode( to_char(dal,'mmyyyy')
                             , lpad(tot_mese,2,'0')||tot_anno, lpad(tot_mese,2,'0')||tot_anno
                                                             , to_char(tot_anno))
                     )
                , nvl(tipo_aliquota,1)
           having NVL(sum(decode(rilevanza,'E0',decode(sign(ipn_tfs),-1,0,ipn_tfs)
                                           ,ipn_tfs)),0)         != 0
               or NVL(sum(decode(rilevanza,'E0',decode(sign(contr_tfs),-1,0,contr_tfs)
                                           ,contr_tfs)),0)       != 0
               or NVL(sum(decode(rilevanza,'E0',decode(sign(ipn_tfr),-1,0,ipn_tfr)
                                           ,ipn_tfr)),0)          != 0
               or NVL(sum(decode(rilevanza,'E0',decode(sign(contr_ipn_tfr),-1,0,contr_ipn_tfr)
                                           ,contr_ipn_tfr)),0)      != 0
               or NVL(sum(decode(rilevanza,'E0',decode(sign(ult_ipn_tfr),-1,0,ult_ipn_tfr)
                                           ,ult_ipn_tfr)),0)        != 0
               or
NVL(sum(decode(rilevanza,'E0',decode(sign(contr_ult_ipn_tfr),-1,0,contr_ult_ipn_tfr)
                                           ,contr_ult_ipn_tfr)),0)     != 0
               or
NVL(sum(decode(rilevanza,'E0',decode(sign(sanzione_previdenza),-1,0,sanzione_previdenza)
                                           ,sanzione_previdenza)),0)     != 0
               or
NVL(sum(decode(rilevanza,'E0',decode(sign(contr_prev_calamita),-1,0,contr_prev_calamita)
                                           ,contr_prev_calamita)),0)    != 0
           union
            select nvl( to_char(riferimento)
                     , decode( to_char(dal,'mmyyyy')
                             , lpad(tot_mese,2,'0')||tot_anno, lpad(tot_mese,2,'0')||tot_anno
                                                             , to_char(tot_anno))
                     )  riferimento
                , nvl(tipo_aliquota,1)
                , cassa_enpdedp  T004
                , 0 T007
                , 0 T008
                , 0 T009
                , 0 T010
                , 0 T011
                , 0 T012
                , 0 T013
                , 0 T014
                , 0 T015
                , 0 T016
                , 0 T017
                , 0 T018
                , 0 T019
                , 0 T020
                , 0 T021
                , 0 T022
                , 0 T023
                , 0 T024
                , 0 TA25
                , 0 TB25
                , 0 TA26
                , 0 TB26
                , 0 T027
                , 0 T028
                , sum(decode(rilevanza,'E0',decode(sign(ipn_cassa_credito),-1,0,ipn_cassa_credito)
                                           ,ipn_cassa_credito))                             T029
                , sum(decode(rilevanza,'E0',decode(sign(contr_enpdedp),-1,0,contr_enpdedp)
                                           ,contr_enpdedp))                                 T030
                , sum(decode(rilevanza,'E0',decode(sign(sanzione_enpdedp),-1,0,sanzione_enpdedp)
                                           ,sanzione_enpdedp))                              T037
                , sum(decode(cassa_pensione
                           , null,decode(cassa_previdenza
                                       , null,0
                                             ,decode(rilevanza,'E0',decode(sign(contr_prev_calamita)
                                                                          ,-1,0,contr_prev_calamita)
                                                                   ,contr_prev_calamita))
                                 ,decode(rilevanza,'E0',decode(sign(contr_pens_calamita)
                                                              ,-1,0,contr_pens_calamita)
                                                       ,contr_pens_calamita)))             T038
             from denuncia_dma
            where anno = tot_anno
              and mese = tot_mese
              and ci  in
                 (select ci
                    from individui_dma
                   where anno     = tot_anno
                     and mese     = tot_mese
                     and nr_file  = tot_nr_file
                     and cf_dic   = tot_cf
                     and cf_app   = tot_cf_app
                     and nvl(cf_vers,tot_cf) = nvl(tot_cf_vers,' '))
              and cassa_enpdedp    is not null
              and nvl(cf_amm_fisse,tot_cf) = nvl(tot_cf_vers,' ')
            group by cassa_enpdedp
                   , nvl(tipo_aliquota,1)
                   , nvl( to_char(riferimento)
                     , decode( to_char(dal,'mmyyyy')
                             , lpad(tot_mese,2,'0')||tot_anno, lpad(tot_mese,2,'0')||tot_anno
                                                             , to_char(tot_anno))
                     )
            having
NVL(sum(decode(rilevanza,'E0',decode(sign(ipn_cassa_credito),-1,0,ipn_cassa_credito)
                                           ,ipn_cassa_credito)),0)    != 0
               or NVL(sum(decode(rilevanza,'E0',decode(sign(contr_enpdedp),-1,0,contr_enpdedp)
                                           ,contr_enpdedp)),0)     != 0
               or NVL(sum(decode(rilevanza,'E0',decode(sign(sanzione_enpdedp),-1,0,sanzione_enpdedp)
                                           ,sanzione_enpdedp)),0)    != 0
               or NVL(sum(decode(cassa_pensione
                           , null,decode(cassa_previdenza
                                       , null,0
                                             ,decode(rilevanza,'E0',decode(sign(contr_prev_calamita)
                                                                          ,-1,0,contr_prev_calamita)
                                                                   ,contr_prev_calamita))
                                 ,decode(rilevanza,'E0',decode(sign(contr_pens_calamita)
                                                              ,-1,0,contr_pens_calamita)
                                                       ,contr_pens_calamita))),0)             != 0
             union
            select nvl( to_char(riferimento)
                     , decode( to_char(dal,'mmyyyy')
                             , lpad(tot_mese,2,'0')||tot_anno, lpad(tot_mese,2,'0')||tot_anno
                                                             , to_char(tot_anno))
                     )  riferimento
                , nvl(tipo_aliquota,1)
                , cassa_credito  T004  -- DA DEFINIRE!!!!
                , 0 T007
                , 0 T008
                , 0 T009
                , 0 T010
                , 0 T011
                , 0 T012
                , 0 T013
                , 0 T014
                , 0 T015
                , 0 T016
                , 0 T017
                , 0 T018
                , 0 T019
                , 0 T020
                , 0 T021
                , 0 T022
                , 0 T023
                , 0 T024
                , 0 TA25
                , 0 TB25
                , 0 TA26
                , 0 TB26
                , sum(decode( tot_forza_credito
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
                       )) ipn_cassa_credito
                , sum(decode( tot_forza_credito
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
                        )) contr_cassa_credito
                , 0                                                  T029
                , 0 T030
                , sum(decode(rilevanza,'E0',decode(sign(sanzione_credito),-1,0,sanzione_credito)
                                           ,sanzione_credito))                              T037
                , 0                                                  T038
             from denuncia_dma
            where anno = tot_anno
              and mese = tot_mese
              and ci  in
                 (select ci
                    from individui_dma
                   where anno     = tot_anno
                     and mese     = tot_mese
                     and nr_file  = tot_nr_file
                     and cf_dic   = tot_cf
                     and cf_app   = tot_cf_app
                     and nvl(cf_vers,tot_cf) = nvl(tot_cf_vers,' '))
              and cassa_credito    is not null
              and nvl(cf_amm_fisse,tot_cf)   = nvl(tot_cf_vers,' ')
            group by cassa_credito
                ,  nvl(tipo_aliquota,1)
                   , nvl( to_char(riferimento)
                     , decode( to_char(dal,'mmyyyy')
                             , lpad(tot_mese,2,'0')||tot_anno, lpad(tot_mese,2,'0')||tot_anno
                                                             , to_char(tot_anno))
                     )
           having nvl(sum(decode( tot_forza_credito
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
                       )),0) != 0
               or nvl(sum(decode( tot_forza_credito
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
                        )),0) != 0
               or NVL(sum(decode(rilevanza,'E0',decode(sign(sanzione_credito),-1,0,sanzione_credito)
                                           ,sanzione_credito)),0) != 0
           )
        LOOP
--dbms_output.put_line('2  tot_num_b '||to_char(tot_num_b));
--dbms_output.put_line('2 tot_gest_cf '||tot_cf||' tot_app_cf '||tot_cf_app||' tot_cf_vers '||tot_cf_vers);
          IF CUR_TOT.tipo_aliquota = '1' THEN
          -- estraggo i dati di riscatti e ricongiunzioni
             BEGIN
                select sum(decode( tipo_amm
                                 , '11', nvl(importo,0) * decode(operazione,'R',-1,1)
                                       , 0)) T031
                     , sum(decode( tipo_amm
                                 , '12', nvl(importo,0) * decode(operazione,'R',-1,1)
                                       , 0)) T032
                     , sum(decode( tipo_amm
                                 , '13', nvl(importo,0) * decode(operazione,'R',-1,1)
                                       , 0)) T033
                     , sum(decode( tipo_amm
                                 , '14', nvl(importo,0) * decode(operazione,'R',-1,1)
                                       , 0)) T034
                     , sum(decode( tipo_amm
                                 , '15', nvl(importo,0) * decode(operazione,'R',-1,1)
                                       , 0)) T035
                     , sum(decode( tipo_amm
                                 , '28', nvl(importo,0) * decode(operazione,'R',-1,1)
                                       , 0)) T036
                     , sum(nvl(sanzione,0)) t037
                  into D_t031,D_t032,D_t033,D_t034,D_t035,D_t036,D_t037
                  from denuncia_dma_quote ddmq
                 where anno = tot_anno
                   and mese = tot_mese
                   and gestione in (select codice
                                      from gestioni
                                     where codice_fiscale = tot_cf
                                   )
                   and ci  in
                      (select ci
                         from individui_dma
                        where anno     = tot_anno
                          and mese     = tot_mese
                          and nr_file  = tot_nr_file
                          and cf_dic   = tot_cf
                          and cf_app   = tot_cf_app
                          and cf_vers  = tot_cf_vers)
                   and exists
                      (select 'x' from gestioni
                        where codice =
                             (select nvl(max(nvl(gestione_app,gestione) ), ddmq.gestione)
                                from denuncia_dma
                               where anno     = tot_anno
                                 and mese     = tot_mese
                                 and ci       = ddmq.ci
                                 and gestione = ddmq.gestione
                             )
                          and codice_fiscale = tot_cf_app)
                   and cassa       = cur_tot.t004
                   and riferimento = cur_tot.riferimento
                   and cf_versante is null;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    D_t031 := null;
                    D_t032 := null;
                    D_t033 := null;
                    D_t034 := null;
                    D_t035 := null;
                    D_t036 := null;
                    D_t037 := null;
             END;
           END IF;
          -- inserisco il record dei TOTALI tipo D
          insert into totali_dma_z1
                ( ANNO
                , MESE
                , CF_DIC
                , CF_APP
                , CF_VERS
                , CASSA
                , TIPO_ALIQUOTA
                , RIFERIMENTO
                , NR_FILE
                , IPN_PENS
                , CONTR_PENS
                , IPN_PENS_CN
                , CONTR_PENS_CN
                , IPN_PENS_SUD
                , CONTR_PENS_SUD
                , IPN_PENS_CN_407
                , CONTR_PENS_CN_407
                , IPN_PENS_SUD_407
                , CONTR_PENS_SUD_407
                , IPN_L135
                , CONTR_L135
                , IPN_SU_ECCEDENZA
                , CONTR_SU_ECCEDENZA
                , IPN_L166
                , CONTR_L166
                , IPN_TFS
                , CONTR_TFS
                , IPN_TFR
                , ULT_IPN_TFR
                , CONTR_TFR
                , CONTR_ULT_TFR
                , IPN_CASSA_CREDITO
                , CONTR_CASSA_CREDITO
                , IPN_ENPDEDP
                , CONTR_ENPDEDP
                , RISCATTO_PENS
                , RICONGIUNZIONE
                , RISCATTO_TFS
                , MUTUO
                , PRESTITO
                , RISCATTO_TFR
                , SANZIONI
                , CONTR_SOSPESO
                , UTENTE
                , TIPO_AGG
                , DATA_AGG
                )
           select tot_anno
                , tot_mese
                , tot_cf
                , tot_cf_app
                , nvl(tot_cf_vers,tot_cf)
                , cur_tot.t004
                , cur_tot.tipo_aliquota
                , cur_tot.riferimento
                , tot_nr_file
                , cur_tot.T007
                , cur_tot.T008
                , cur_tot.T009
                , cur_tot.T010
                , cur_tot.T011
                , cur_tot.T012
                , cur_tot.T013
                , cur_tot.T014
                , cur_tot.T015
                , cur_tot.T016
                , cur_tot.T017
                , cur_tot.T018
                , cur_tot.T019
                , cur_tot.T020
                , cur_tot.T021
                , cur_tot.T022
                , cur_tot.T023
                , cur_tot.T024
                , cur_tot.TA25
                , cur_tot.TB25
                , cur_tot.TA26
                , cur_tot.TB26
                , cur_tot.T027
                , cur_tot.T028
                , cur_tot.T029
                , cur_tot.T030
                , D_t031
                , D_t032
                , D_t033
                , D_t034
                , D_t035
                , D_t036
                , nvl(cur_tot.T037,0) + nvl(D_t037,0)
                , cur_tot.T038
                , 'AUTO'
                , ''
                , sysdate
             from dual;
        END LOOP; -- CUR_TOT
        -- Verifica se esistono record di riscatti e ricongiunzioni che NON hanno corrispondenza su
        -- denuncia_dma e quindi bisogna inserire uno specifico record di totali
        FOR CUR_QUOTE IN
           (select cf_versante
                 , lpad(riferimento,6,'0')           riferimento
                 , '1'                               tipo_aliquota
                 , cassa                             T004  -- DA DEFINIRE!!!!
                 , sum(decode( tipo_amm
                             , '11', nvl(importo,0) * decode(operazione,'R',-1,1)
                                   , 0)) T031
                 , sum(decode( tipo_amm
                             , '12', nvl(importo,0) * decode(operazione,'R',-1,1)
                                   , 0)) T032
                 , sum(decode( tipo_amm
                             , '13', nvl(importo,0) * decode(operazione,'R',-1,1)
                                   , 0)) T033
                 , sum(decode( tipo_amm
                             , '14', nvl(importo,0) * decode(operazione,'R',-1,1)
                                   , 0)) T034
                 , sum(decode( tipo_amm
                             , '15', nvl(importo,0) * decode(operazione,'R',-1,1)
                                   , 0)) T035
                 , sum(decode( tipo_amm
                             , '28', nvl(importo,0) * decode(operazione,'R',-1,1)
                                   , 0)) T036
                 , sum(nvl(sanzione,0)) t037
              from denuncia_dma_quote ddmq
            where anno = tot_anno
              and mese = tot_mese
              and gestione in (select codice
                                 from gestioni
                                where codice_fiscale = tot_cf
                              )
              and ci  in
                 (select ci
                    from individui_dma
                   where anno     = tot_anno
                     and mese     = tot_mese
                     and nr_file  = tot_nr_file
                     and cf_dic   = tot_cf
                     and cf_app   = tot_cf_app
                     and nvl(cf_vers,' ')  = nvl(tot_cf_vers,' '))
              and exists (select 'x' from gestioni
                           where codice =
                                (select nvl(max(nvl(gestione_app,gestione) ), ddmq.gestione)
                                   from denuncia_dma
                                  where anno = tot_anno
                                    and mese = tot_mese
                                    and ci   = ddmq.ci
                                    and gestione = ddmq.gestione
                                )
                             and codice_fiscale = tot_cf_app)
              and(   not exists
                        (select 'x' from denuncia_dma
                          where anno = tot_anno
                            and mese = tot_mese
                            and ci  in
                 (select ci
                    from individui_dma
                   where anno     = tot_anno
                     and mese     = tot_mese
                     and nr_file  = tot_nr_file
                     and cf_dic   = tot_cf
                     and cf_app   = tot_cf_app
                     and nvl(cf_vers,' ')  = nvl(tot_cf_vers,' '))
                            and gestione in (select codice
                                               from gestioni
                                              where codice_fiscale = tot_cf
                                            ) -- non uguaglianza con dedp.gestione perche fa fede il cf versante e NON la nostra gestione
                            and nvl(gestione_app,gestione)
                                 in (select codice
                                       from gestioni
                                      where codice_fiscale = tot_cf_app
                                    )
                            and nvl( to_char(riferimento)
                                   , decode( to_char(dal,'mmyyyy')
                                           , lpad(tot_mese,2,'0')||tot_anno, lpad(tot_mese,2,'0')||tot_anno
                                                                           , to_char(tot_anno))
                                           ) = ddmq.riferimento
                            and (   cassa_pensione   = ddmq.cassa
                                 or cassa_previdenza = ddmq.cassa
                                 or cassa_credito    = ddmq.cassa)
                        )
                  or ddmq.cf_versante is not null)
            group by cf_versante,cassa,riferimento
          ) LOOP
          insert into totali_dma_z1
                ( ANNO
                , MESE
                , CF_DIC
                , CF_APP
                , CF_VERS
                , CASSA
                , TIPO_ALIQUOTA
                , RIFERIMENTO
                , NR_FILE
                , RISCATTO_PENS
                , RICONGIUNZIONE
                , RISCATTO_TFS
                , MUTUO
                , PRESTITO
                , RISCATTO_TFR
                , SANZIONI
                , UTENTE
                , TIPO_AGG
                , DATA_AGG
                )
           select tot_anno
                , tot_mese
                , tot_cf
                , tot_cf_app
                , nvl(tot_cf_vers,tot_cf)
                , cur_quote.t004
                , cur_quote.tipo_aliquota
                , cur_quote.riferimento
                , tot_nr_file
                , cur_quote.t031
                , cur_quote.t032
                , cur_quote.t033
                , cur_quote.t034
                , cur_quote.t035
                , cur_quote.t036
                , cur_quote.t037
                , 'AUTO'
                , ''
                , sysdate
             from dual;
          END LOOP; -- CUR_QUOTE
    END;
  END TOTALI;
PROCEDURE TOTALI_Z2 ( tot_cf     in VARCHAR2
                    , tot_anno   in NUMBER
                    , tot_mese   in NUMBER
                    ) IS
 BEGIN
   DECLARE
     D_z2_id      number;
     BEGIN
       FOR CUR_Z2 IN
          (select CF_DIC
                , CASSA
                , RIFERIMENTO
                , sum(CONTR_PENS)            CONTR_PENS
                , sum(CONTR_PENS_CN)         CONTR_PENS_CN
                , sum(CONTR_PENS_SUD)        CONTR_PENS_SUD
                , sum(CONTR_PENS_CN_407)     CONTR_PENS_CN_407
                , sum(CONTR_PENS_SUD_407)    CONTR_PENS_SUD_407
                , sum(CONTR_L135)            CONTR_L135
                , sum(CONTR_SU_ECCEDENZA)    CONTR_SU_ECCEDENZA
                , sum(CONTR_L166)            CONTR_L166
                , sum(CONTR_TFS)             CONTR_TFS
                , sum(CONTR_TFR)             CONTR_TFR
                , sum(CONTR_ULT_TFR)         CONTR_ULT_TFR
                , sum(CONTR_CASSA_CREDITO)   CONTR_CASSA_CREDITO
                , sum(CONTR_ENPDEDP)         CONTR_ENPDEDP
                , sum(RISCATTO_PENS)         RISCATTO_PENS
                , sum(RICONGIUNZIONE)        RICONGIUNZIONE
                , sum(RISCATTO_TFS)          RISCATTO_TFS
                , sum(MUTUO)                 MUTUO
                , sum(PRESTITO)              PRESTITO
                , sum(RISCATTO_TFR)          RISCATTO_TFR
                , sum(SANZIONI)              SANZIONI
             from totali_dma_z1
            where anno = tot_anno
              and mese = tot_mese
              and cf_dic = tot_cf
              and cf_vers = cf_dic
            group by CF_DIC
                   , CASSA
                   , RIFERIMENTO
          ) LOOP
            BEGIN
              select min(vdz2_id)
                into D_z2_id
                from versamenti_dma_z2
               where anno        = tot_anno
                 and mese        = tot_mese
                 and cf_dic      = cur_z2.cf_dic
                 and cassa       = cur_z2.cassa
                 and riferimento = cur_z2.riferimento
                 and versamento  = '31';
--dbms_output.put_line('D_z2_id '||D_z2_id||' tot_anno '||tot_anno||
--' tot_mese '||tot_mese||' cur_z2.cf_dic '||cur_z2.cf_dic||
--' cur_z2.cassa '||cur_z2.cassa||' cur_z2.riferimento '||cur_z2.riferimento);
           update totali_dma_z2 toz2
              set CONTR_PENS     = nvl(CONTR_PENS,0)     + nvl(toz2.CONTR_PENS,0)
                , CONTR_PENS_CN  = nvl(CONTR_PENS_CN,0)  + nvl(toz2.CONTR_PENS_CN,0)
                , CONTR_PENS_SUD = nvl(CONTR_PENS_SUD,0) + nvl(toz2.CONTR_PENS_SUD,0)
                , CONTR_PENS_CN_407  = nvl(CONTR_PENS_CN_407,0)  + nvl(toz2.CONTR_PENS_CN_407,0)
                , CONTR_PENS_SUD_407 = nvl(CONTR_PENS_SUD_407,0) + nvl(toz2.CONTR_PENS_SUD_407,0)
                , CONTR_L135         = nvl(CONTR_L135,0)         + nvl(toz2.CONTR_L135,0)
                , CONTR_SU_ECCEDENZA = nvl(CONTR_SU_ECCEDENZA,0) + nvl(toz2.CONTR_SU_ECCEDENZA,0)
                , CONTR_L166 = nvl(CONTR_L166,0) + nvl(toz2.CONTR_L166,0)
                , CONTR_TFS  = nvl(CONTR_TFS,0)  + nvl(toz2.CONTR_TFS,0)
                , CONTR_TFR  = nvl(CONTR_TFR,0)  + nvl(toz2.CONTR_TFR,0)
                , CONTR_ULT_TFR       = nvl(CONTR_ULT_TFR,0)       + nvl(toz2.CONTR_ULT_TFR,0)
                , CONTR_CASSA_CREDITO = nvl(CONTR_CASSA_CREDITO,0) + nvl(toz2.CONTR_CASSA_CREDITO,0)
                , CONTR_ENPDEDP  = nvl(CONTR_ENPDEDP,0)  + nvl(toz2.CONTR_ENPDEDP,0)
                , RISCATTO_PENS  = nvl(RISCATTO_PENS,0)  + nvl(toz2.RISCATTO_PENS,0)
                , RICONGIUNZIONE = nvl(RICONGIUNZIONE,0) + nvl(toz2.RICONGIUNZIONE,0)
                , RISCATTO_TFS = nvl(RISCATTO_TFS,0) + nvl(toz2.RISCATTO_TFS,0)
                , MUTUO        = nvl(MUTUO,0)        + nvl(toz2.MUTUO,0)
                , PRESTITO     = nvl(PRESTITO,0)     + nvl(toz2.PRESTITO,0)
                , RISCATTO_TFR = nvl(RISCATTO_TFR,0) + nvl(toz2.RISCATTO_TFR,0)
                , SANZIONI     = nvl(SANZIONI,0)     + nvl(toz2.SANZIONI,0)
                , UTENTE          = 'AUTO'
                , TIPO_AGG        = ''
                , DATA_AGG        = sysdate
            where vdz2_id = D_z2_id;
        IF SQL%NOTFOUND and D_z2_id is not null THEN
           insert into totali_dma_z2
                 ( VDZ2_ID
                 , CONTR_PENS
                 , CONTR_PENS_CN
                 , CONTR_PENS_SUD
                 , CONTR_PENS_CN_407
                 , CONTR_PENS_SUD_407
                 , CONTR_L135
                 , CONTR_SU_ECCEDENZA
                 , CONTR_L166
                 , CONTR_TFS
                 , CONTR_TFR
                 , CONTR_ULT_TFR
                 , CONTR_CASSA_CREDITO
                 , CONTR_ENPDEDP
                 , RISCATTO_PENS
                 , RICONGIUNZIONE
                 , RISCATTO_TFS
                 , MUTUO
                 , PRESTITO
                 , RISCATTO_TFR
                 , SANZIONI
                 , UTENTE
                 , TIPO_AGG
                 , DATA_AGG )
           select D_z2_id
                , cur_z2.CONTR_PENS
                , cur_z2.CONTR_PENS_CN
                , cur_z2.CONTR_PENS_SUD
                , cur_z2.CONTR_PENS_CN_407
                , cur_z2.CONTR_PENS_SUD_407
                , cur_z2.CONTR_L135
                , cur_z2.CONTR_SU_ECCEDENZA
                , cur_z2.CONTR_L166
                , cur_z2.CONTR_TFS
                , cur_z2.CONTR_TFR
                , cur_z2.CONTR_ULT_TFR
                , cur_z2.CONTR_CASSA_CREDITO
                , cur_z2.CONTR_ENPDEDP
                , cur_z2.RISCATTO_PENS
                , cur_z2.RICONGIUNZIONE
                , cur_z2.RISCATTO_TFS
                , cur_z2.MUTUO
                , cur_z2.PRESTITO
                , cur_z2.RISCATTO_TFR
                , cur_z2.SANZIONI
                , 'AUTO'
                , ''
                , sysdate
             from dual;
            END IF;
            IF D_z2_id is null THEN
                      select vdz2_sq.nextval
                        into D_z2_id
                        from dual;
                      insert into versamenti_dma_z2
                            ( VDZ2_ID
                            , ANNO
                            , MESE
                            , CF_DIC
                            , CASSA
                            , RIFERIMENTO
                            , VERSAMENTO
                            , UTENTE
                            , TIPO_AGG
                            , DATA_AGG
                            )
                       select D_z2_id
                            , tot_anno
                            , tot_mese
                            , cur_z2.cf_dic
                            , cur_z2.cassa
                            , cur_z2.riferimento
                            , '31'
                            , 'AUTO'
                            , ''
                            , sysdate
                         from dual;
           insert into totali_dma_z2
                 ( VDZ2_ID
                 , CONTR_PENS
                 , CONTR_PENS_CN
                 , CONTR_PENS_SUD
                 , CONTR_PENS_CN_407
                 , CONTR_PENS_SUD_407
                 , CONTR_L135
                 , CONTR_SU_ECCEDENZA
                 , CONTR_L166
                 , CONTR_TFS
                 , CONTR_TFR
                 , CONTR_ULT_TFR
                 , CONTR_CASSA_CREDITO
                 , CONTR_ENPDEDP
                 , RISCATTO_PENS
                 , RICONGIUNZIONE
                 , RISCATTO_TFS
                 , MUTUO
                 , PRESTITO
                 , RISCATTO_TFR
                 , SANZIONI
                 , UTENTE
                 , TIPO_AGG
                 , DATA_AGG )
            select D_z2_id
                , cur_z2.CONTR_PENS
                , cur_z2.CONTR_PENS_CN
                , cur_z2.CONTR_PENS_SUD
                , cur_z2.CONTR_PENS_CN_407
                , cur_z2.CONTR_PENS_SUD_407
                , cur_z2.CONTR_L135
                , cur_z2.CONTR_SU_ECCEDENZA
                , cur_z2.CONTR_L166
                , cur_z2.CONTR_TFS
                , cur_z2.CONTR_TFR
                , cur_z2.CONTR_ULT_TFR
                , cur_z2.CONTR_CASSA_CREDITO
                , cur_z2.CONTR_ENPDEDP
                , cur_z2.RISCATTO_PENS
                , cur_z2.RICONGIUNZIONE
                , cur_z2.RISCATTO_TFS
                , cur_z2.MUTUO
                , cur_z2.PRESTITO
                , cur_z2.RISCATTO_TFR
                , cur_z2.SANZIONI
                , 'AUTO'
                , ''
                , sysdate
             from dual;
            END IF;
/*            EXCEPTION WHEN NO_DATA_FOUND THEN
--dbms_output.put_line('passo dalle insert');
                      select vdz2_sq.nextval
                        into D_z2_id
                        from dual;
                      insert into versamenti_dma_z2
                            ( VDZ2_ID
                            , ANNO
                            , MESE
                            , CF_DIC
                            , CASSA
                            , RIFERIMENTO
                            , VERSAMENTO
                            , UTENTE
                            , TIPO_AGG
                            , DATA_AGG
                            )
                       select D_z2_id
                            , tot_anno
                            , tot_mese
                            , cur_z2.cf_dic
                            , cur_z2.cassa
                            , cur_z2.riferimento
                            , '31'
                            , 'AUTO'
                            , ''
                            , sysdate
                         from dual;
           insert into totali_dma_z2
                 ( VDZ2_ID
                 , CONTR_PENS
                 , CONTR_PENS_CN
                 , CONTR_PENS_SUD
                 , CONTR_PENS_CN_407
                 , CONTR_PENS_SUD_407
                 , CONTR_L135
                 , CONTR_SU_ECCEDENZA
                 , CONTR_L166
                 , CONTR_TFS
                 , CONTR_TFR
                 , CONTR_ULT_TFR
                 , CONTR_CASSA_CREDITO
                 , CONTR_ENPDEDP
                 , RISCATTO_PENS
                 , RICONGIUNZIONE
                 , RISCATTO_TFS
                 , MUTUO
                 , PRESTITO
                 , RISCATTO_TFR
                 , SANZIONI
                 , UTENTE
                 , TIPO_AGG
                 , DATA_AGG )
            select D_z2_id
                , cur_z2.CONTR_PENS
                , cur_z2.CONTR_PENS_CN
                , cur_z2.CONTR_PENS_SUD
                , cur_z2.CONTR_PENS_CN_407
                , cur_z2.CONTR_PENS_SUD_407
                , cur_z2.CONTR_L135
                , cur_z2.CONTR_SU_ECCEDENZA
                , cur_z2.CONTR_L166
                , cur_z2.CONTR_TFS
                , cur_z2.CONTR_TFR
                , cur_z2.CONTR_ULT_TFR
                , cur_z2.CONTR_CASSA_CREDITO
                , cur_z2.CONTR_ENPDEDP
                , cur_z2.RISCATTO_PENS
                , cur_z2.RICONGIUNZIONE
                , cur_z2.RISCATTO_TFS
                , cur_z2.MUTUO
                , cur_z2.PRESTITO
                , cur_z2.RISCATTO_TFR
                , cur_z2.SANZIONI
                , 'AUTO'
                , ''
                , sysdate
             from dual;
*/            END;
        END LOOP; -- CUR_TOT
    END;
  END TOTALI_Z2;
  PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
  BEGIN
 DECLARE
  D_prg_errore      NUMBER := 4000000;
  D_anno            NUMBER;
  D_mese            NUMBER;
  D_num_record      NUMBER;
d_num number;
  D_ini_mes         DATE;
  D_fin_mes         DATE;
  D_gestione        VARCHAR2(8);
  D_forza_credito   VARCHAR2(1);
  D_dep_ci          number;
  D_posticipato     VARCHAR2(1);
-- variabili per invii multipli
  D_nr_file         NUMBER;
  D_tot_rec		      NUMBER;
  D_tot_invii       NUMBER;
  D_righe_lette     NUMBER;
  D_ultimo_ci	      NUMBER;
  Dep_invio         NUMBER;
  Dep_num_b         NUMBER;
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
  SELECT valore
    INTO D_posticipato
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_POSTICIPATO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      D_posticipato := null;
END;
--CTR_VOCI (prenotazione, passo, D_anno, D_mese);
IF D_posticipato = 'X' THEN
  BEGIN
   SELECT decode(D_mese+1,13,1,D_mese+1)
--        , D_mese
        , decode(D_mese+1,13,D_anno+1,D_anno)
--        , D_anno
    INTO  D_mese
--        , D_mese_moco
        , D_anno
--        , D_anno_moco
    FROM  dual
  ;
  END;
ELSE
--  D_mese_moco := D_mese;
--  D_anno_moco := D_anno;
null;
END IF;
--dbms_output.put_line('Numero_record: '||to_char(D_num_record));
  BEGIN -- inizio corpo
    delete from individui_dma
     where anno    = D_anno
       and mese    = D_mese
       and cf_dic in
          (select codice_fiscale
             from gestioni
            where codice like D_gestione)
    ;
    delete from totali_dma_z1
     where anno    = D_anno
       and mese    = D_mese
       and cf_dic in
          (select codice_fiscale
             from gestioni
            where codice like D_gestione)
    ;
    delete from totali_dma_z2
     where vdz2_id        in
          (select vdz2_id
             from versamenti_dma_z2
            where anno    = D_anno
              and mese    = D_mese
              and cf_dic in
                 (select codice_fiscale
                    from gestioni
                   where codice like D_gestione)
          )
    ;
--  dbms_output.put_line('inizio corpo');
    FOR CUR_GEST IN
     (select gest.codice_fiscale
           , gest.codice
        from gestioni gest
       where gest.codice_fiscale in
            (select codice_fiscale from gestioni
              where codice in (select gestione
                                 from denuncia_dma
                                where anno = D_anno
                                  and mese = D_mese
                                  and gestione like D_gestione
                              ))
         and firmatario_dma is not null
     )
    LOOP
--dbms_output.put_line('cur gest '||cur_gest.codice||' '||cur_gest.codice_fiscale);
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
FOR GEST_APP IN
   (select gest.codice_fiscale
         , rownum num_b
     from gestioni gest
    where codice in
         (select distinct nvl(gestione_app,cur_gest.codice)
            from denuncia_dma
           where anno = D_anno
             and mese = D_mese
--             and ci >= nvl(D_ultimo_ci,0)
--             and nvl(gestione_app,' ') like D_appartenenza
             and gestione in (select codice
                                from gestioni
                               where codice_fiscale = CUR_GEST.codice_fiscale)
         )
      and (   gest.firmatario_dma is not null
           or gest.codice_fiscale != CUR_GEST.codice_fiscale)
    order by rownum
   ) LOOP
--dbms_output.put_line('cur gest '||cur_gest.codice||' '||cur_gest.codice_fiscale||' APP '||gest_app.codice_fiscale);
      BEGIN
        D_ultimo_ci   := 0;
        D_dep_ci      := 0;
        D_righe_lette := 0;
        D_nr_file     := 1;
d_num := 0;
        FOR CUR_CI IN
           (select ddma.ci             ci
                 , nvl(ddma.cf_amm_fisse,CUR_GEST.codice_fiscale)   cf_vers
                 , count(*)            righe
              from denuncia_dma        ddma
             where ddma.anno      = D_anno
               and ddma.mese      = D_mese
               and ddma.ci       >= nvl(D_ultimo_ci,0)
               and ddma.gestione in
                  (select codice
                     from gestioni
                    where codice_fiscale = CUR_GEST.codice_fiscale)
               and nvl(ddma.gestione_app,ddma.gestione) in
                  (select codice
                     from gestioni
                    where codice_fiscale = GEST_APP.codice_fiscale)
             group by ddma.ci,ddma.cf_amm_fisse
             union
            select distinct ddmq.ci       ci
                 , null                   cf_vers
                 , 1                      righe   -- è sufficiente 1 perchè è
                                                  -- il caso in cui non esiste
                                                  -- in denuncia_dma
              from denuncia_dma_quote     ddmq
             where ddmq.anno = D_anno
               and ddmq.mese = D_mese
               and ddmq.ci >= nvl(D_ultimo_ci,0)
               and ddmq.gestione in
                  (select codice
                     from gestioni
                    where codice_fiscale = CUR_GEST.codice_fiscale)
               and not exists
                  (select 'x' from denuncia_dma
                    where anno = D_anno
                      and mese = D_mese
                      and ci   = ddmq.ci
                      and gestione in
                         (select codice
                            from gestioni
                           where codice_fiscale = CUR_GEST.codice_fiscale)
                         )
             order by 1
           ) LOOP
d_num :=D_num + 1;
--dbms_output.put_line(' D_righe_lette '||D_righe_lette||' num ci '||d_num ||' righe ind '||cur_ci.righe||
--                     ' D_ultimo_ci '||D_ultimo_ci|| ' CUR_CI.ci ' ||CUR_CI.ci);
               BEGIN
                 IF D_righe_lette >  D_num_record THEN
                    D_nr_file     := D_nr_file + 1;
                    D_righe_lette := 0;
                 END IF;
                 insert into individui_dma
                        (anno,mese,cf_dic,cf_app,cf_vers,ci,nr_file)
                 values (D_anno,D_mese,CUR_GEST.codice_fiscale,GEST_APP.codice_fiscale
                        ,CUR_CI.cf_vers, CUR_CI.ci,D_nr_file)
                 ;
                 D_ultimo_ci   := cur_ci.ci;
                 D_righe_lette := D_righe_lette + cur_ci.righe;
               END;
             END LOOP;
      END;
     END LOOP; -- GEST_APP
   END LOOP; -- CUR_GEST
  END;       -- fine corpo
  BEGIN      -- inizio calcolo z1
    FOR CUR_Z1 IN
       (select distinct
               cf_dic
             , cf_app
             , cf_vers
             , nr_file
          from individui_dma
         where anno    = D_anno
           and mese    = D_mese
           and cf_dic in
              (select codice_fiscale
                 from gestioni
                where codice like D_gestione)
       ) LOOP
           TOTALI(cur_z1.cf_dic, cur_z1.cf_app, cur_z1.cf_vers, cur_z1.nr_file
                 ,D_forza_credito,D_anno,D_mese);
         END LOOP;
  END;       -- fine z1
  BEGIN      -- inizio calcolo z2
    FOR CUR_Z2 IN
       (select distinct
               cf_dic
          from individui_dma
         where anno    = D_anno
           and mese    = D_mese
           and cf_dic in
              (select codice_fiscale
                 from gestioni
                where codice like D_gestione)
       ) LOOP
--       dbms_output.put_line('1 cur_z2.cf_dic '||cur_z2.cf_dic||' D_anno '||D_anno||' D_mese '||D_mese);
           TOTALI_Z2(cur_z2.cf_dic, D_anno,D_mese);
           delete from versamenti_dma_z2 x
            where anno       = D_anno
              and mese       = D_mese
              and not exists
                 (select 'x' from totali_dma_z2
                   where vdz2_id = x.vdz2_id)
           ;
         END LOOP;
  END;-- fine z2
  BEGIN -- Controllo record con valori negativi
    FOR CUR_NEG in (select cf_dic
                   , cassa
                   , decode( length(riferimento)
                           , 4, '01'||TO_CHAR(riferimento)
                              , lpad(TO_CHAR(riferimento),6,'0')) riferimento
                   , versamento
                from totali_versamenti_dma
               where anno   = D_anno
                 and mese   = D_mese
--                 and cf_dic = (select distinct codice_fiscale
--                                 from gestioni
--                                where codice like nvl(D_gestione,'%')
--                              )
                 and (   nvl(contr_pens,0) < 0
                      or nvl(contr_pens_cn,0) < 0
                      or nvl(contr_pens_sud,0) < 0
                      or nvl(contr_pens_cn_407,0) < 0
                      or nvl(contr_pens_sud_407,0) < 0
                      or nvl(contr_l135,0) < 0
                      or nvl(contr_su_eccedenza,0) < 0
                      or nvl(contr_l166,0) < 0
                      or nvl(contr_tfs,0) < 0
                      or nvl(contr_tfr,0) < 0
                      or nvl(contr_ult_tfr,0) < 0
                      or nvl(contr_cassa_credito,0) < 0
                      or nvl(contr_enpdedp,0) < 0
                      or nvl(riscatto_pens,0) < 0
                      or nvl(ricongiunzione,0) < 0
                      or nvl(riscatto_tfs,0) < 0
                      or nvl(mutuo,0) < 0
                      or nvl(prestito,0) < 0
                      or nvl(riscatto_tfr,0) < 0
                      or nvl(vers_no_ipn,0) < 0
                      or nvl(sanzioni,0) < 0
                      or nvl(eccedenze,0) < 0
                      or nvl(anticipazioni,0) < 0
                     )
               ) LOOP
                   D_prg_errore := nvl(D_prg_errore,0) + 1;
                   INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
                   VALUES (prenotazione,1,D_prg_errore,' ',null);
                   D_prg_errore := nvl(D_prg_errore,0) + 1;
                   INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
                   VALUES (prenotazione,1,D_prg_errore,'P05840','record versamenti anno: '||TO_CHAR(D_anno)||' Mese: '||D_mese||' - Dichiarante: '||CUR_NEG.cf_dic||' - Cassa: '||CUR_NEG.cassa||' Rif.: '||CUR_NEG.riferimento);
                 END LOOP;
-- fine controllo negativi
  END;
  peccadma.titoli_segnalazioni(prenotazione,1);
  BEGIN
  update a_prenotazioni
     set prossimo_passo = 91,
         errore         = 'P00108'
   where no_prenotazione = prenotazione
     and exists (select 'x'
                   from a_appoggio_stampe
                  where no_prenotazione = prenotazione)
  ;
 IF SQL%NOTFOUND THEN
  update a_prenotazioni
     set prossimo_passo = 93,
         errore         = 'P00109'
   where no_prenotazione = prenotazione
     and exists (select 'x'
                   from a_segnalazioni_errore
                  where no_prenotazione = prenotazione)
  ;
 END IF;
 END;
 EXCEPTION
   WHEN ERRORE THEN
     null;
END;
END;
END;
/
