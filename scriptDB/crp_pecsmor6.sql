CREATE OR REPLACE PACKAGE pecsmor6 IS
/******************************************************************************
 NOME:        PECSMOR6 
 DESCRIZIONE: Package per la produzione del cedolino Parametrico
 
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 
 REVISIONI:
 Rev. Data       Autore   Descrizione
 ---- ---------- ------   --------------------------------------------------------
 1.0  29/07/2003 DM       Prima emissione ( Att. 8928 )
 1.1  13/01/2004 DM       A1318
 1.2  22/07/2004 GM       A1318
 1.3  15/12/2004 GM       A8793
 1.4  21/02/2005 GM       A9815
 1.5  10/03/2005 GM       A9990
 1.6  02/05/2005 GM       A10945
 1.7  16/06/2005 GM       A11679
 1.8  17/06/2005 GM       A6645
 1.9  20/06/2005 GM       A9371
 1.10 30/06/2005 GM       A11798
 1.11 05/07/2005 GM       A11832
 1.12 19/10/2005 GM       A13073
 1.13 20/10/2005 GM       A13123
 1.14 15/05/2006 GM       A16162
 1.15 19/06/2006 GM       A15353
 1.16 06/09/2006 GM       A17514
 1.17 17/10/2006 MS       Modificata lettura dell'IPN_FAM ( A17262 )
 1.18 14/11/2006 GM       A18426 Modificata estrazione descrizioni voci orizzontali
 1.19 27/11/2006 GM       Modifica per inoltro MAIL
 1.20 06/12/2006 AD   Introdotta PROCEDURE RESET_P_PRENOTAZIONE_OLD per gestire
     elaborazione cedolini da portale e da DB
 1.21 07/02/2007 AM       Corretta la data di valuta
 1.22 03/05/2007 GM       Modificato passaggio parametro P_TIPO_DESFORMAT e select CAFA
 1.23 04/07/2007 GM       Modificata esposizione colonna Quantità
 1.24 23/08/2007 GM       Modifica Aggregazione voci SEL_MOCO  
 1.25 13/09/2007 GM       Aggiunta relazione tra moco.delibere e dere.tipo
******************************************************************************/
   sys_data_elab        varchar2(20);
   sys_prg_cedolino     varchar2(8);
   d_prg_cedolino       number(8);
   sys_num_pag_dip      varchar2(10);
   sys_pagina_app       varchar2(10);
   sys_tot_pagine_app   varchar2(10);
   sys_num_pag_eff      varchar2(10);
   sys_tot_pag_dip      varchar2(10);
   sys_num_pag          varchar2(5);
   sys_num_pag_app      varchar2(5);
   sys_num_pag_tot      varchar2(5);
   sys_imb1             varchar2(40);
   sys_imb2             varchar2(40);
   sys_imb3             varchar2(40);
   sys_imb1m            varchar2(10);
   sys_imb2m            varchar2(10);
   sys_imb3m            varchar2(10);
   sys_imb4m            varchar2(10);
   sys_imb5m            varchar2(10);
   sys_imb6m            varchar2(10);
   sys_num_dip          number := 0;
   sys_pagina           varchar2(6);
   sys_separatore_pag   varchar2(1);
   p_prenotazione_old   number := 0;
   p_ci_old             number := 0;
   p_fronte_retro       varchar2(100);
   p_lingua             varchar2(100);
   w_gruppo_ling        number;
   w_nr_ruo             number;
   ente_descrizione     varchar2(100);
   ente_indirizzo       varchar2(100);
   ente_comune          varchar2(100);
   ente_codice_fiscale  varchar2(100);
   ente_variabili_gepe  number;
   ente_prg_cedolino    number;
   ente_mesi_irpef      number;
   sys_esnc0            varchar2(40);
   sys_esnc1            varchar2(40);
   sys_esnc2            varchar2(40);
   sys_esnc3            varchar2(40);
   sys_esnc4            varchar2(40);
   sys_esnc5            varchar2(40);
   sys_esnc13           varchar2(40);
   sys_esnc17           varchar2(40);
   sys_esnc26           varchar2(40);
   sys_esnc27           varchar2(40);
   sys_esnc28           varchar2(40);            
   gest_codice          varchar2(4);
   gest_descrizione     varchar2(40);
   gest_indirizzo        varchar2(40);
   gest_comune           varchar2(40);
   gest_codice_fiscale   varchar2(100);
   gest_posizione_inps   varchar2(12);
   gest_posizione_inadel varchar2(12);
   gest_codice_inail     varchar2(11);
   rare_descrizione_banca varchar2(150);
   rare_descrizione_banca2 varchar2(150); --descrizione banca senza delega
   rare_delega            varchar2(55);
   rare_matricola       varchar2(8);
   rare_posizione_inail varchar2(12);
   rare_statistico1     varchar2(12);
   rare_statistico2     varchar2(12);
   rare_statistico3     varchar2(12);
   rare_codice_inps     varchar2(12);
   rare_cod_nazione     varchar2(2);
   rare_cin_eur         number;
   rare_cin_ita         varchar2(1);
   rare_conto_corrente  varchar2(15);
   rare_istituto        varchar2(5);
   rare_sportello       varchar2(5);
   iscr_codice_abi      varchar2(5);
   iscr_codice_cab      varchar2(5);
   anag_cognome_nome    varchar2(78);
   anag_data_nas     varchar2(8);
   anag_codice_fiscale varchar2(16);
   anag_indirizzo_dom varchar2(40);
   anag_comune_dom    varchar2(55);
   anag_indirizzo_res varchar2(40);
   anag_comune_res      varchar2(55);
   anag_presso        varchar2(40);
   anag_partita_iva     varchar(11);
   pegi_dal             varchar2(10);
   pegi_al              varchar2(10);
   w_pegi_dal           date;
   w_pegi_al            date;
   rain_rapporto     varchar2(4);
   rain_dal         varchar2(10);
   rain_ci              varchar2(8);
   rain_ci_st           varchar2(11);
   pere_gestione        varchar2(4);
   pere_posizione       varchar2(4);
   pere_ruolo           varchar2(4);
   pere_tipo_rapporto    varchar2(4);
   pere_ore              varchar2(8);
   pere_ore_coco_td      varchar2(8);
   pere_ore_coco         varchar2(8);
   pere_ore_td           varchar2(8);
   pere_settore          varchar(6);
   pere_sede             number;
   pere_figura           number;
   pere_qualifica        number;
   pere_dal              date;
   pere_al               date;
   rifu_funzionale       varchar2(8);
   rifu_cdc              varchar2(8);
   sedi_codice           varchar2(8);
   sedi_descrizione      varchar2(45);
   sett_codice           varchar2(15);
   sett_descrizione      varchar2(65);
   sett_cod_descrizione  varchar2(65);
   qugi_contratto        varchar2(4);
   qugi_codice           varchar2(8);
   qugi_livello          varchar2(4);
   qugi_dal              date;
   qugi_al               date;
   qual_descrizione      varchar2(40);
   figi_codice           varchar2(8);
   figi_descrizione      varchar2(120);
   figi_profilo          varchar2(4);
   figi_posizione        varchar2(4);
   prpr_descrizione      varchar2(120);
   pofu_codice           varchar2(4);
   pofu_descrizione      varchar2(120);
   aina_posizione        varchar2(12);
   mens_descrizione      varchar2(40);
   mens_periodo_comp     varchar2(40);
   mens_periodo_comp1    varchar2(40);
   mens_data_val1        varchar2(30);
   mens_data_val         varchar2(30);
   prfi_anni_anz         varchar2(12);
   prfi_mesi_anz         varchar2(12);
   prfi_giorni_anz       varchar2(12);
   qual_qua_inps         number;
   pegi_qual_dal         varchar2(8);
   pegi_qual_inps_dal    varchar2(8);
   w_conta_qua        number;
   moco_arr_pre          varchar2(12);
   moco_arr_att          varchar2(12);
   moco_totale_comp      varchar2(12);
   moco_totale_rit       varchar2(12);
   moco_netto            varchar2(15);
   sel_moco_sequenza     varchar2(5);
   sel_moco_descrizione  varchar2(40);
   sel_moco_data_rif     varchar2(10);
   sel_moco_voce         varchar2(10);
   sel_moco_sub          varchar2(2);
   sel_moco_imp          varchar2(40);
   sel_moco_tar          varchar2(40);
   sel_moco_qta          varchar2(40);
   sel_moco_imp_st       varchar2(40);
   sel_moco_tar_st       varchar2(40);
   sel_moco_qta_st       varchar2(40);
   sel_moco_imp_st_temp  varchar2(40);
   sel_moco_tar_st_temp  varchar2(40);
   sel_moco_qta_st_temp  varchar2(40);   
   sel_moco_arr          varchar2(1);
   sel_moco_input        varchar2(1);
   sel_moco_tipo_rapporto varchar2(4);
   sel_moco_ore          number;
   sel_moco_specie       varchar2(1);
   sel_moco_stampa_tar   varchar2(1);
   sel_moco_stampa_qta   varchar2(1);
   sel_moco_stampa_imp   varchar2(1);
   sel_moco_seq_ord      number;
   sel_moco_arr_ord      varchar2(1);
   sel_moco_riferimento  date;
   sel_note_sequenza     varchar2(4);
   sel_note_note         varchar(4000);
   sel_note_nota         number;
   sel_inec_anz_voce  varchar2(40);
   sel_inec_qual_descrizione  varchar2(40);
   sel_inec_anz_data  varchar2(10);
   sel_inec_anz_numero  varchar(10);
   sel_mov_oriz_des_v1  varchar2(60);
   sel_mov_oriz_des_v2  varchar2(60);
   sel_mov_oriz_des_v3  varchar2(60);
   sel_mov_oriz_val_v1  varchar2(60);
   sel_mov_oriz_val_v2  varchar2(60);
   sel_mov_oriz_val_v3  varchar2(60);
   sel_mov_oriz_des_v4  varchar2(60);
   sel_mov_oriz_des_v5  varchar2(60);
   sel_mov_oriz_des_v6  varchar2(60);
   sel_mov_oriz_val_v4  varchar2(60);
   sel_mov_oriz_val_v5  varchar2(60);
   sel_mov_oriz_val_v6  varchar2(60);
   sel_moco_tipo        varchar2(1);
   sel_imp_m_scaglione_ord   varchar2(16);
   sel_imp_m_aliquota_ord    varchar2(16);
   sel_imp_m_imposta_ord     varchar2(16);
   sel_imp_m_scaglione_sep   varchar2(16);
   sel_imp_m_aliquota_sep    varchar2(16);
   sel_imp_m_imposta_sep     varchar2(16);
   sel_imp_a_scaglione   varchar2(16);
   sel_imp_a_aliquota    varchar2(16);
   sel_imp_a_imposta     varchar2(16);
   dim_piede           number(2);
   dim_testa           number(2);
   contaerrori           number;
   continua              number;
   contarighe            number:=1;
   wriga             varchar2(4000);
   v_ritorna             varchar2(4000); -- anche se troppo non e mai poco...
   w_ultimo_cursore     varchar2(50):=null;
   w_riga_trattata     number;
   posizione         number;
   lunghezza         number;
   w_conta_des_f         number;
   w_conta_moco_f        number;
   w_conta_des_r         number;
   w_conta_moco_r        number;
   w_conta_note          number;
   w_conta_note_1        number;
   v_riga_note           number;
   v_note_rimaste        number;
   w_sequenza_moco       number;
   w_sequenza_note       number;
   cafa_cond_fis         varchar2(4);
   cafa_scaglione_coniuge varchar2(2);
   cafa_coniuge           varchar2(2);
   cafa_scaglione_figli   varchar2(2);
   cafa_figli             varchar2(2);
   cafa_figli_dd          varchar2(2);
   cafa_figli_mn          varchar2(2);
   cafa_figli_mn_dd       varchar2(2);
   cafa_figli_hh          varchar2(2);
   cafa_figli_hh_dd       varchar2(2);
   cafa_altri             varchar2(2);
   cafa_cond_fam          varchar2(4);
   cafa_nucleo_fam        varchar2(2);
   cafa_figli_fam         varchar2(2);
   cafa_assegno           varchar2(8);
   D_ipn_fam              number;
   D_tabella              varchar2(4);
   D_ass_figli            number;
   D_ass_fam              number;
   cofi_descrizione       varchar2(30);
   cofa_descrizione       varchar2(30);
   sel_mal_cod            varchar2(4);
   sel_mal_des            varchar2(120);
   sel_mal_dal            varchar2(10);
   sel_mal_al             varchar2(10);
   sel_mal_gg             varchar2(3);
   sel_mal_per            varchar2(5);
   sel_deli_sequenza      varchar2(5);
   sel_deli_descrizione   varchar2(40);
   sel_deli_riferimento   varchar2(10);
   sel_deli_voce          varchar2(10);
   sel_deli_imp           varchar2(40);
   sel_deli_tar           varchar2(40);
   sel_deli_qta           varchar2(40);
   sel_deli_anno_del      varchar2(4);
   sel_deli_numero_del    varchar2(7);
   sel_deli_sede_del      varchar2(4);
   sel_deli_causale       varchar2(30);
CURSOR sel_moco (p_ci number,p_anno number,p_mese number,p_mensilita varchar,p_gr_ling number
                ,p_stampa_fr in varchar) is
  select voec.sequenza sequenza
       ,decode
       ( max(upper(moco.input))
       ,'R','01/'||lpad(TO_CHAR(p_mese),2,0)||'/'||TO_CHAR(p_anno)
           ,decode
            ( max(moco.arr)
            ,'P',to_char(max(decode( upper(moco.input)
                                   , 'C', nvl(moco.data,nvl(moco.competenza,moco.riferimento))
                                        , moco.riferimento
                                   )
                            ),'dd/mm/yyyy')
            ,'C',to_char(max(decode( upper(moco.input)
                                   , 'C', nvl(moco.data,nvl(moco.competenza,moco.riferimento))
                                        , moco.riferimento
                                   )
                            ),'dd/mm/yyyy')
                ,decode
                 ( to_char(max(decode( upper(moco.input)
                                     , 'C', decode( moco.data
                                                  , null, nvl(moco.competenza,moco.riferimento)
                                                        , to_date('3333333','j')
                                                  )
                                     , 'A', moco.riferimento
                                          , to_date('3333333','j')
                                     )
                              ),'yyyy')
                 , p_anno
                 , '01/'||lpad(TO_CHAR(P_MESE),2,0)||'/'||TO_CHAR(p_anno)
                 , to_char(max(decode( upper(moco.input)
                                       , 'C', nvl(moco.data,nvl(moco.competenza,moco.riferimento))
                                            , moco.riferimento
                                        )
                                 ),'dd/mm/yyyy')
                 )
            )
      ) data_rif
      , max(moco.voce) voce ,max(moco.sub) sub
      , max(upper(moco.input)) input
      , to_char(sum(nvl(moco.imp,0))) imp
      , to_char(sum(nvl(moco.qta,0))) qta
      , to_char(sum(nvl(moco.tar,0))) tar
      , max(moco.arr) arr
      , max(decode(p_gr_ling,1,nvl(covo.descrizione,nvl(covo.descrizione_al1,covo.descrizione_al2))
                            ,2,nvl(covo.descrizione_al1,nvl(covo.descrizione,covo.descrizione_al2))
                            ,3,nvl(covo.descrizione_al2,nvl(covo.descrizione,covo.descrizione_al1))
                              ,nvl(covo.descrizione,nvl(covo.descrizione_al1,covo.descrizione_al2)))) descrizione
      , max(voec.tipo) tipo
      , to_char(decode(min(moco.tar)
                      ,max(moco.tar),decode(max(voec.classe)
                                           ,'R', nvl(sum(moco.tar
                                                    *decode(moco.input
                                                   ,'r',1
                                                       ,decode(voec.classe
                                                              ,'R',1
                                                                  ,sign(nvl(moco.qta,moco.imp)))
                                                    )),0)
                                           ,nvl(max(moco.tar),0)
                                           )
                      ,nvl(sum(moco.tar
                          *decode(moco.input
                         ,'r',1
                             ,decode(voec.classe
                                    ,'R',1
                                        ,sign(nvl(moco.qta,moco.imp)))
                          )),0)
                      )
               )                             tar_st
      , to_char(decode( max(voec.classe)
                       , 'R', nvl(max(moco.qta),0)
                            , nvl(sum(moco.qta),0)))  qta_st
      , to_char(nvl(sum(moco.imp),0))  imp_st
      , max(covo.stampa_tar) stampa_tar
      , max(covo.stampa_qta) stampa_qta
      , max(covo.stampa_imp) stampa_imp
      , max(moco.tipo_rapporto) tipo_rapporto
      , max(moco.ore) ore
      , max(voec.specie) specie
      , 10 seq_ord
      , decode(moco.arr
              ,null,'*'
                   ,moco.arr) arr_ord
      , max(moco.riferimento) riferimento
   from movimenti_contabili moco
      , voci_economiche voec
      , contabilita_voce covo
      , qualifiche_giuridiche qugi
  where moco.ci = p_ci
    and moco.anno = p_anno
    and moco.mese = p_mese
    and moco.mensilita = p_mensilita
    and moco.voce = voec.codice
    and moco.voce = covo.voce
    and moco.sub = covo.sub
    and nvl(moco.riferimento,last_day(to_date('01/'||lpad(TO_CHAR(P_MESE),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy')))
        between nvl(covo.dal,to_date('2222222','j'))
            and nvl(covo.al ,to_date('3333333','j'))
    and covo.stampa_fr = p_stampa_fr
    and 'NNN' != translate(translate(covo.stampa_tar||
                                     covo.stampa_qta||
                                     covo.stampa_imp
                                     , 'C', 'N')
                                     , 'B', 'N')
    and moco.qualifica = qugi.numero (+)
    and nvl(moco.riferimento,last_day(to_date('01/'||lpad(TO_CHAR(P_MESE),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy')))
        between nvl(qugi.dal,to_date('2222222','j'))
            and nvl(qugi.al ,to_date('3333333','j'))
    and moco.voce not in (select codice
                            from voci_economiche
                           where automatismo in ('ARR_PRE','ARR_ATT',
                                                 'ARR_ATT_S','ARR_ATT_N',
                                                 'ARR_ATT_SN',
                                                 'COMP','TRAT','NETTO')
                         )
    and not exists
        (select 'x'
           from estrazione_righe_contabili
           where estrazione = 'CEDOLINO_VOCI_ORIZZ'
             and voce = moco.voce
             and sub = moco.sub
             and moco.arr is null)
   group by moco.ci,voec.sequenza,moco.arr,moco.sub,covo.dal,
         decode( upper(moco.input)
               , 'R', decode(upper(sys_esnc26),'X',to_char(qugi.dal,'dd/mm/yyyy')||moco.ore||moco.tipo_rapporto
                                            ,to_char(moco.tar)
                            )
                    , to_char(qugi.dal,'dd/mm/yyyy')||moco.ore||moco.tipo_rapporto),
         decode( upper(moco.input)
               , 'R', decode(upper(sys_esnc27)
                            ,null,to_date(null)
                            ,'1',to_date(decode(to_char(moco.riferimento,'yyyy'),moco.anno,moco.anno,moco.anno-1),'yyyy')
                            ,'2',to_date(to_char(moco.riferimento,'yyyy'),'yyyy')
                            ,'3',decode(to_char(moco.riferimento,'yyyy')
                                       ,moco.anno,to_date(to_char(moco.riferimento,'yyyymm'),'yyyymm')
                                                 ,to_date(to_char(moco.riferimento,'yyyy'),'yyyy')  
                                       )
                            )       
                    , decode( voec.classe
                            , 'A', decode(upper(sys_esnc28)
                                         ,null,to_date(null)
                                         ,'X',to_date(to_char(moco.riferimento,'yyyymm'),'yyyymm')
                                         )
                            , 'R', to_date
                                   (to_char(nvl(moco.competenza,moco.riferimento)
                                           ,'yyyy')
                                   ,'yyyy')
                                 , moco.riferimento)),
         decode( voec.classe
               , 'R', moco.qta
                    , to_number(null))
having  nvl(sum(moco.tar),0) != 0 or
        nvl(sum(decode(voec.classe,'R',0,moco.qta)),0) != 0 or
        nvl(sum(moco.imp),0) != 0
  union
 select sequenza sequenza
      , null data_rif
      , null voce
      , null sub
      , null input
      , null imp
      , null qta
      , null tar
      , null arr
      , decode(p_gr_ling,1,nvl(descrizione,nvl(descrizione_al1,descrizione_al2))
                        ,2,nvl(descrizione_al1,nvl(descrizione,descrizione_al2))
                        ,3,nvl(descrizione_al2,nvl(descrizione,descrizione_al1))
                          ,nvl(descrizione,nvl(descrizione_al1,descrizione_al2))) descrizione
      , 'D' tipo
      , decode(p_gr_ling
              ,1,nvl(tariffa,nvl(tariffa_al1,tariffa_al2))
              ,2,nvl(tariffa_al1,nvl(tariffa,tariffa_al2))
              ,3,nvl(tariffa_al2,nvl(tariffa,tariffa_al1))
                ,nvl(tariffa,nvl(tariffa_al1,tariffa_al2))) tar_st
      , decode(p_gr_ling
              ,1,nvl(quantita,nvl(quantita_al1,quantita_al2))
              ,2,nvl(quantita_al1,nvl(quantita,quantita_al2))
              ,3,nvl(quantita_al2,nvl(quantita,quantita_al1))
                ,nvl(quantita,nvl(quantita_al1,quantita_al2))) qta_st
      , decode(p_gr_ling
              ,1,nvl(importo,nvl(importo_al1,importo_al2))
              ,2,nvl(importo_al1,nvl(importo,importo_al2))
              ,3,nvl(importo_al2,nvl(importo,importo_al1))
                ,nvl(importo,nvl(importo_al1,importo_al2))) imp_st
      , null stampa_tar
      , null stampa_qta
      , null stampa_imp
      , null tipo_rapporto
      , to_number(null) ore
      , null specie
      , sub seq_ord
      , 'D' arr_ord
      , to_date(null) riferimento
   from estrazione_note_cedolini
  where sequenza != 0
    and ((p_stampa_fr = 'F' and sub < 90)
         or
         (p_stampa_fr = 'R' and sub >= 90)
        )
  order by 1,21,22,4,23,9
  ;
CURSOR sel_mov_oriz (p_ci number,p_anno number,p_mese number,p_mensilita varchar,p_gr_ling number
                    ,p_stampa_fr in varchar) is
select   max(substr(esvc.note,1,instr(esvc.note,'?',1) -1))             des_v1
       , max(translate(decode( substr(lpad(esrc.sequenza,2,0),1,1)
                   , 1,decode( esrc.tipo
                              , 'T', decode(moco.tar
                                       ,0,null
                                         ,lpad(decode(trunc(moco.tar)
                                              ,0,decode(sign(moco.tar)
                                                   ,-1,'-'||trunc(moco.tar)
                                                      , trunc(moco.tar)
                                                 )
                                              , trunc(moco.tar)
                                              ),6)||
                                          decode(mod(moco.tar,trunc(moco.tar))
                                            ,0,'.00000'
                                              ,rpad(abs(mod(moco.tar,trunc(moco.tar))),6,'0')
                                          )
                                     )
                              , 'Q', moco.qta *
                                     decode(voec.tipo,'F',sign(moco.qta),1)
                              , 'I', decode(mod(nvl(moco.imp,0),trunc(nvl(moco.imp,0)))
                                                  ,0,lpad(nvl(moco.imp,0)
                                                             * decode(voec.tipo
                                                                      ,'T',-1,1)||',00',9)
                                                    ,lpad(decode(trunc(nvl(moco.imp,0))
                                                         ,0,decode(sign(nvl(moco.imp,0)                                                             * decode(voec.tipo
                                                                      ,'T',-1,1))
                                                              ,-1,'-'||trunc(nvl(moco.imp,0))
                                                                 , trunc(nvl(moco.imp,0))* decode(voec.tipo
                                                                      ,'T',-1,1)
                                                            )
                                                           ,trunc(nvl(moco.imp,0))* decode(voec.tipo
                                                                      ,'T',-1,1)
                                                         ),9)||rpad(abs(mod(moco.imp,trunc(moco.imp))),3,'0')
                                               ),null)),',.','.,')) val_v1
     , max(substr(esvc.note,instr(esvc.note,'?',1) +1,instr(esvc.note,'?',1,2)-instr(esvc.note,'?',1,1)-1))  des_v2
     , max(translate(decode( substr(lpad(esrc.sequenza,2,0),1,1)
                 , 2,decode( esrc.tipo
                              , 'T', decode(moco.tar
                                       ,0,null
                                         ,lpad(decode(trunc(moco.tar)
                                              ,0,decode(sign(moco.tar)
                                                   ,-1,'-'||trunc(moco.tar)
                                                      , trunc(moco.tar)
                                                 )
                                              , trunc(moco.tar)
                                              ),6)||
                                          decode(mod(moco.tar,trunc(moco.tar))
                                            ,0,'.00000'
                                              ,rpad(abs(mod(moco.tar,trunc(moco.tar))),6,'0')
                                          )
                                     )
                              , 'Q', moco.qta *
                                     decode(voec.tipo,'F',sign(moco.qta),1)
                              , 'I',decode(mod(nvl(moco.imp,0),trunc(nvl(moco.imp,0)))
                                                  ,0,lpad(nvl(moco.imp,0)
                                                             * decode(voec.tipo
                                                                      ,'T',-1,1)||',00',9)
                                                    ,lpad(decode(trunc(nvl(moco.imp,0))
                                                         ,0,decode(sign(nvl(moco.imp,0)                                                             * decode(voec.tipo
                                                                      ,'T',-1,1))
                                                              ,-1,'-'||trunc(nvl(moco.imp,0))
                                                                 , trunc(nvl(moco.imp,0))* decode(voec.tipo
                                                                      ,'T',-1,1)
                                                            )
                                                           ,trunc(nvl(moco.imp,0))* decode(voec.tipo
                                                                      ,'T',-1,1)
                                                         ),9)||rpad(abs(mod(moco.imp,trunc(moco.imp))),3,'0')
                                               ),null)),',.','.,')) val_v2
     , max(substr(esvc.note,instr(esvc.note,'?',1,2) +1,instr(esvc.note,'?',1,3)-instr(esvc.note,'?',1,2)-1))   des_v3
     , max(translate(decode( substr(lpad(esrc.sequenza,2,0),1,1)
                 , 3,decode( esrc.tipo
                              , 'T', decode(moco.tar
                                       ,0,null
                                         ,lpad(decode(trunc(moco.tar)
                                              ,0,decode(sign(moco.tar)
                                                   ,-1,'-'||trunc(moco.tar)
                                                      , trunc(moco.tar)
                                                 )
                                              , trunc(moco.tar)
                                              ),6)||
                                          decode(mod(moco.tar,trunc(moco.tar))
                                            ,0,'.00000'
                                              ,rpad(abs(mod(moco.tar,trunc(moco.tar))),6,'0')
                                          )
                                     )
                              , 'Q', moco.qta *
                                     decode(voec.tipo,'F',sign(moco.qta),1)
                              , 'I', decode(mod(nvl(moco.imp,0),trunc(nvl(moco.imp,0)))
                                                  ,0,lpad(nvl(moco.imp,0)
                                                             * decode(voec.tipo
                                                                      ,'T',-1,1)||',00',9)
                                                    ,lpad(decode(trunc(nvl(moco.imp,0))
                                                         ,0,decode(sign(nvl(moco.imp,0)                                                             * decode(voec.tipo
                                                                      ,'T',-1,1))
                                                              ,-1,'-'||trunc(nvl(moco.imp,0))
                                                                 , trunc(nvl(moco.imp,0))* decode(voec.tipo
                                                                      ,'T',-1,1)
                                                            )
                                                           ,trunc(nvl(moco.imp,0))* decode(voec.tipo
                                                                      ,'T',-1,1)
                                                         ),9)||rpad(abs(mod(moco.imp,trunc(moco.imp))),3,'0')
                                               ),null)),',.','.,')) val_v3
       , max(substr(esvc.note,instr(esvc.note,'?',1,3) +1,instr(esvc.note,'?',1,4)-instr(esvc.note,'?',1,3)-1))  des_v4
       , max(translate(decode( substr(lpad(esrc.sequenza,2,0),1,1)
                   , 4,decode( esrc.tipo
                              , 'T', decode(moco.tar
                                       ,0,null
                                         ,lpad(decode(trunc(moco.tar)
                                              ,0,decode(sign(moco.tar)
                                                   ,-1,'-'||trunc(moco.tar)
                                                      , trunc(moco.tar)
                                                 )
                                              , trunc(moco.tar)
                                              ),6)||
                                          decode(mod(moco.tar,trunc(moco.tar))
                                            ,0,'.00000'
                                              ,rpad(abs(mod(moco.tar,trunc(moco.tar))),6,'0')
                                          )
                                     )
                              , 'Q', moco.qta *
                                     decode(voec.tipo,'F',sign(moco.qta),1)
                              , 'I', decode(mod(nvl(moco.imp,0),trunc(nvl(moco.imp,0)))
                                                  ,0,lpad(nvl(moco.imp,0)
                                                             * decode(voec.tipo
                                                                      ,'T',-1,1)||',00',9)
                                                    ,lpad(decode(trunc(nvl(moco.imp,0))
                                                         ,0,decode(sign(nvl(moco.imp,0)                                                             * decode(voec.tipo
                                                                      ,'T',-1,1))
                                                              ,-1,'-'||trunc(nvl(moco.imp,0))
                                                                 , trunc(nvl(moco.imp,0))* decode(voec.tipo
                                                                      ,'T',-1,1)
                                                            )
                                                           ,trunc(nvl(moco.imp,0))* decode(voec.tipo
                                                                      ,'T',-1,1)
                                                         ),9)||rpad(abs(mod(moco.imp,trunc(moco.imp))),3,'0')
                                               ),null)),',.','.,')) val_v4
     , max(substr(esvc.note,instr(esvc.note,'?',1,4) +1,instr(esvc.note,'?',1,5)-instr(esvc.note,'?',1,4)-1))  des_v5
     , max(translate(decode( substr(lpad(esrc.sequenza,2,0),1,1)
                 , 5,decode( esrc.tipo
                              , 'T', decode(moco.tar
                                       ,0,null
                                         ,lpad(decode(trunc(moco.tar)
                                              ,0,decode(sign(moco.tar)
                                                   ,-1,'-'||trunc(moco.tar)
                                                      , trunc(moco.tar)
                                                 )
                                              , trunc(moco.tar)
                                              ),6)||
                                          decode(mod(moco.tar,trunc(moco.tar))
                                            ,0,'.00000'
                                              ,rpad(abs(mod(moco.tar,trunc(moco.tar))),6,'0')
                                          )
                                     )
                              , 'Q', moco.qta *
                                     decode(voec.tipo,'F',sign(moco.qta),1)
                              , 'I',decode(mod(nvl(moco.imp,0),trunc(nvl(moco.imp,0)))
                                                  ,0,lpad(nvl(moco.imp,0)
                                                             * decode(voec.tipo
                                                                      ,'T',-1,1)||',00',9)
                                                    ,lpad(decode(trunc(nvl(moco.imp,0))
                                                         ,0,decode(sign(nvl(moco.imp,0)                                                             * decode(voec.tipo
                                                                      ,'T',-1,1))
                                                              ,-1,'-'||trunc(nvl(moco.imp,0))
                                                                 , trunc(nvl(moco.imp,0))* decode(voec.tipo
                                                                      ,'T',-1,1)
                                                            )
                                                           ,trunc(nvl(moco.imp,0))* decode(voec.tipo
                                                                      ,'T',-1,1)
                                                         ),9)||rpad(abs(mod(moco.imp,trunc(moco.imp))),3,'0')
                                               ),null)),',.','.,')) val_v5
     , max(substr(esvc.note,instr(esvc.note,'?',1,5) +1,instr(esvc.note,'?',1,6)-instr(esvc.note,'?',1,5)-1)) des_v6
     , max(translate(decode( substr(lpad(esrc.sequenza,2,0),1,1)
                 , 6,decode( esrc.tipo
                              , 'T', decode(moco.tar
                                       ,0,null
                                         ,lpad(decode(trunc(moco.tar)
                                              ,0,decode(sign(moco.tar)
                                                   ,-1,'-'||trunc(moco.tar)
                                                      , trunc(moco.tar)
                                                 )
                                              , trunc(moco.tar)
                                              ),6)||
                                          decode(mod(moco.tar,trunc(moco.tar))
                                            ,0,'.00000'
                                              ,rpad(abs(mod(moco.tar,trunc(moco.tar))),6,'0')
                                          )
                                     )
                              , 'Q', moco.qta *
                                     decode(voec.tipo,'F',sign(moco.qta),1)
                              , 'I', decode(mod(nvl(moco.imp,0),trunc(nvl(moco.imp,0)))
                                                  ,0,lpad(nvl(moco.imp,0)
                                                             * decode(voec.tipo
                                                                      ,'T',-1,1)||',00',9)
                                                    ,lpad(decode(trunc(nvl(moco.imp,0))
                                                         ,0,decode(sign(nvl(moco.imp,0)                                                             * decode(voec.tipo
                                                                      ,'T',-1,1))
                                                              ,-1,'-'||trunc(nvl(moco.imp,0))
                                                                 , trunc(nvl(moco.imp,0))* decode(voec.tipo
                                                                      ,'T',-1,1)
                                                            )
                                                           ,trunc(nvl(moco.imp,0))* decode(voec.tipo
                                                                      ,'T',-1,1)
                                                         ),9)||rpad(abs(mod(moco.imp,trunc(moco.imp))),3,'0')
                                               ),null)),',.','.,')) val_v6
    from estrazione_righe_contabili  esrc
       , estrazione_valori_contabili esvc
       , contabilita_voce            covo
       , voci_economiche             voec
       , movimenti_contabili         moco
 where voec.codice   = moco.voce
   and esrc.estrazione = 'CEDOLINO_VOCI_ORIZZ'
   and esrc.estrazione = esvc.estrazione
   and esrc.colonna    = esvc.colonna
   and moco.voce     = esrc.voce
   and moco.sub      = esrc.sub
   and moco.voce     = covo.voce
   and moco.sub      = covo.sub
   and moco.arr is null
   and nvl(moco.riferimento,last_day(to_date( '01/'||lpad(TO_CHAR(p_mese),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy')))
                    between nvl(covo.dal,to_date('2222222','j'))
                        and nvl(covo.al,to_date('3333333','j'))
   and      'NNN'        != translate(translate( covo.stampa_tar||
                                                 covo.stampa_qta||
                                                 covo.stampa_imp
                                               , 'C'
                                               , 'N')
                                     , 'B'
                                     , 'N')
   and moco.anno = p_anno
   and moco.mese = p_mese
   and moco.mensilita = p_mensilita
   and moco.ci       = p_ci
 group by esrc.colonna
;
CURSOR sel_inec (p_ci  number, p_anno in number,p_mese number, p_mensilita in varchar,p_gr_ling number
                ,p_stampa_fr in varchar) is
  select nvl(decode(p_gr_ling,1,nvl(covo.des_abb,nvl(covo.des_abb_al1,covo.des_abb_al2))
                             ,2,nvl(covo.des_abb_al1,nvl(covo.des_abb,covo.des_abb_al2))
                             ,3,nvl(covo.des_abb_al2,nvl(covo.des_abb,covo.des_abb_al1))
                               ,nvl(covo.des_abb,nvl(covo.des_abb_al1,covo.des_abb_al2))),inec.voce) anz_voce
       , decode(nvl(inec.periodo,0),0,null
                                     ,inec.periodo) anz_numero
       , to_char(decode(least(nvl(inec.prossimo,to_date('2222222','j'))
                     ,to_date('2700000','j'))
               ,to_date('2222222','j'),to_date(null)
               ,to_date('2700000','j'),to_date(null)
                                      ,inec.prossimo),'dd/mm/yyyy') anz_data
       , nvl(decode(p_gr_ling,1,nvl(qual.descrizione,nvl(qual.descrizione_al1,qual.descrizione_al2))
                             ,2,nvl(qual.descrizione_al1,nvl(qual.descrizione,qual.descrizione_al2))
                             ,3,nvl(qual.descrizione_al2,nvl(qual.descrizione,qual.descrizione_al1))
                               ,nvl(qual.descrizione,nvl(qual.descrizione_al1,qual.descrizione_al2)))
                    ,qugi.contratto||' '||qugi.codice)||' '||inec.tipo_rapporto qual_descrizione
    from qualifiche qual, qualifiche_giuridiche qugi
       , contabilita_voce covo, inquadramenti_economici inec
   where inec.ci = p_ci
     and qugi.numero = inec.qualifica
     and qual.numero = inec.qualifica
     and qugi.dal <= last_day(to_date( '01/'||lpad(TO_CHAR(P_MESE),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy'))
     and nvl(qugi.al,to_date('3333333','j'))  >= to_date( '01/'||lpad(TO_CHAR(P_MESE),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy')
     and inec.dal <= last_day(to_date( '01/'||lpad(TO_CHAR(P_MESE),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy'))
     and nvl(inec.al,to_date('3333333','j'))  >= to_date( '01/'||lpad(TO_CHAR(P_MESE),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy')
     and inec.data_agg != to_date('3333333','j')
     and inec.voce = covo.voce
     and inec.dal between nvl(covo.dal,to_date('2222222','j'))
                      and nvl(covo.al,to_date('3333333','j'))
     and covo.sub = 'Q'
     and 'NNN'   != translate( covo.stampa_tar||
                               covo.stampa_qta||
                               covo.stampa_imp
                              , 'C'
                              , 'N')
;
 CURSOR sel_note (p_ci  number, p_anno in number,
                  p_mese number, p_mensilita in varchar,p_gr_ling number,p_stampa_fr in varchar) is
    select 1 sequenza
         , decode(p_gr_ling,1,nvl(noin.note,nvl(noin.note_al1,noin.note_al2))
                               ,2,nvl(noin.note_al1,nvl(noin.note,noin.note_al2))
                               ,3,nvl(noin.note_al2,nvl(noin.note,noin.note_al1))
                                 ,nvl(noin.note,nvl(noin.note_al1,noin.note_al2))) note
         , noin.nota nota
      from note_individuali noin
     where noin.ci = p_ci
       and noin.anno = p_anno
       and noin.mese = p_mese
       and noin.mensilita = p_mensilita
       and decode(p_gr_ling,1,nvl(noin.note,nvl(noin.note_al1,noin.note_al2))
                               ,2,nvl(noin.note_al1,nvl(noin.note,noin.note_al2))
                               ,3,nvl(noin.note_al2,nvl(noin.note,noin.note_al1))
                                 ,nvl(noin.note,nvl(noin.note_al1,noin.note_al2))) is not null
     union
    select 2 sequenza
         , decode(p_gr_ling,1,nvl(mono.note,nvl(mono.note_al1,mono.note_al2))
                               ,2,nvl(mono.note_al1,nvl(mono.note,mono.note_al2))
                               ,3,nvl(mono.note_al2,nvl(mono.note,mono.note_al1))
                                 ,nvl(mono.note,nvl(mono.note_al1,mono.note_al2))) note
         , noin.nota nota
      from note_individuali noin
         , modelli_note     mono
     where noin.ci = p_ci
       and noin.anno = p_anno
       and noin.mese = p_mese
       and noin.mensilita = p_mensilita
       and decode(p_gr_ling,1,nvl(noin.note,nvl(noin.note_al1,noin.note_al2))
                               ,2,nvl(noin.note_al1,nvl(noin.note,noin.note_al2))
                               ,3,nvl(noin.note_al2,nvl(noin.note,noin.note_al1))
                                 ,nvl(noin.note,nvl(noin.note_al1,noin.note_al2))) is null
       and noin.nota = mono.nota
       and last_day(to_date('01/'||lpad(TO_CHAR(p_mese),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy')) between  mono.dal
                        and nvl(mono.al,to_date('3333333','j'))
   order by 1,3
;
 CURSOR sel_imp_m (p_ci  number, p_anno in number,
                 p_mese number, p_mensilita in varchar,p_gr_ling number,p_tipo in varchar) is
 select lpad(trunc((least(scfi2.scaglione,(nvl(mofi.ipn_ord,0) - nvl(mofi.ded_base,0) - nvl(mofi.ded_agg,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   / ente.mesi_irpef
                  ),6
            )||decode(mod(((least(scfi2.scaglione,(nvl(mofi.ipn_ord,0) - nvl(mofi.ded_base,0) - nvl(mofi.ded_agg,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   / ente.mesi_irpef),trunc((least(scfi2.scaglione,(nvl(mofi.ipn_ord,0) - nvl(mofi.ded_base,0) - nvl(mofi.ded_agg,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   / ente.mesi_irpef)),0,'.00'
                   ,rpad(mod(((least(scfi2.scaglione,(nvl(mofi.ipn_ord,0) - nvl(mofi.ded_base,0) - nvl(mofi.ded_agg,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   / ente.mesi_irpef),trunc((least(scfi2.scaglione,(nvl(mofi.ipn_ord,0) - nvl(mofi.ded_base,0) - nvl(mofi.ded_agg,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   / ente.mesi_irpef)),3,'0')) scaglione_ord
      , to_char(scfi1.aliquota) aliquota_ord
      , lpad(trunc((least(scfi2.scaglione,(nvl(mofi.ipn_ord,0) - nvl(mofi.ded_base,0) - nvl(mofi.ded_agg,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                  )
                   * scfi1.aliquota / 100 /ente.mesi_irpef
            ),6)||decode(mod(((least(scfi2.scaglione,(nvl(mofi.ipn_ord,0) - nvl(mofi.ded_base,0) - nvl(mofi.ded_agg,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   * scfi1.aliquota / 100 /ente.mesi_irpef),trunc((least(scfi2.scaglione,(nvl(mofi.ipn_ord,0) - nvl(mofi.ded_base,0) - nvl(mofi.ded_agg,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   * scfi1.aliquota / 100 /ente.mesi_irpef)),0,'.00'
                   ,rpad(mod(((least(scfi2.scaglione,(nvl(mofi.ipn_ord,0) - nvl(mofi.ded_base,0) - nvl(mofi.ded_agg,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   * scfi1.aliquota / 100 /ente.mesi_irpef),trunc((least(scfi2.scaglione,(nvl(mofi.ipn_ord,0) - nvl(mofi.ded_base,0) - nvl(mofi.ded_agg,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   * scfi1.aliquota / 100 /ente.mesi_irpef)),3,'0')) imposta_ord
            , lpad(trunc((least(scfi2.scaglione,(nvl(mofi.ipn_sep,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   / ente.mesi_irpef
                  ),6
            )||decode(mod(((least(scfi2.scaglione,(nvl(mofi.ipn_sep,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   / ente.mesi_irpef),trunc((least(scfi2.scaglione,(nvl(mofi.ipn_sep,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   / ente.mesi_irpef)),0,'.00'
                   ,rpad(mod(((least(scfi2.scaglione,(nvl(mofi.ipn_sep,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   / ente.mesi_irpef),trunc((least(scfi2.scaglione,(nvl(mofi.ipn_sep,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   / ente.mesi_irpef)),3,'0')) scaglione_sep
      , to_char(scfi1.aliquota) aliquota_sep
      , lpad(trunc((least(scfi2.scaglione,(nvl(mofi.ipn_sep,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                  )
                   * scfi1.aliquota / 100 /ente.mesi_irpef
            ),6)||decode(mod(((least(scfi2.scaglione,(nvl(mofi.ipn_sep,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   * scfi1.aliquota / 100 /ente.mesi_irpef),trunc((least(scfi2.scaglione,(nvl(mofi.ipn_sep,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   * scfi1.aliquota / 100 /ente.mesi_irpef)),0,'.00'
                   ,rpad(mod(((least(scfi2.scaglione,(nvl(mofi.ipn_sep,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   * scfi1.aliquota / 100 /ente.mesi_irpef),trunc((least(scfi2.scaglione,(nvl(mofi.ipn_sep,0))
                                           * ente.mesi_irpef
                                          )
                    - scfi1.scaglione
                   )
                   * scfi1.aliquota / 100 /ente.mesi_irpef)),3,'0')) imposta_sep
   from vista_scaglioni_fiscali scfi1
      , vista_scaglioni_fiscali scfi2
      , movimenti_fiscali mofi
      , ente ente
  where mofi.ci = p_ci
    and mofi.anno = p_anno
    and mofi.mese = p_mese
    and mofi.mensilita = p_mensilita
    and ente.ente_id = 'ENTE'
    and scfi1.dal = to_date('0101'||to_char(p_anno),'ddmmyyyy')
    and scfi1.scaglione < decode(p_tipo,1,(mofi.ipn_ord - nvl(mofi.ded_base,0) - nvl(mofi.ded_agg,0))
                                        ,2, nvl(mofi.ipn_sep,0)
                                ) * ente.mesi_irpef
    and scfi2.dal = scfi1.dal
    and scfi2.scaglione = (select min(scaglione)
                             from vista_scaglioni_fiscali
                            where dal = scfi1.dal
                              and scaglione > scfi1.scaglione)
 ;
 CURSOR sel_imp_a (p_ci  number, p_anno in number,
                 p_mese number, p_mensilita in varchar,p_gr_ling number,p_tipo in varchar) is
 select lpad(trunc((least(scfi2.scaglione,(nvl(sum(mofi.ipn_ac),0) - nvl(sum(mofi.ded_base_ac),0) - nvl(sum(mofi.ded_agg_ac),0))
                                          )
                    - scfi1.scaglione
                   )
                  ),6
            )||decode(mod(((least(scfi2.scaglione,(nvl(sum(mofi.ipn_ac),0) - nvl(sum(mofi.ded_base_ac),0) - nvl(sum(mofi.ded_agg_ac),0))
                                          )
                    - scfi1.scaglione
                   )),trunc((least(scfi2.scaglione,(nvl(sum(mofi.ipn_ac),0) - nvl(sum(mofi.ded_base_ac),0) - nvl(sum(mofi.ded_agg_ac),0))
                                          )
                    - scfi1.scaglione
                   ))),0,'.00'
                   ,rpad(mod(((least(scfi2.scaglione,(nvl(sum(mofi.ipn_ac),0) - nvl(sum(mofi.ded_base_ac),0) - nvl(sum(mofi.ded_agg_ac),0))
                                          )
                    - scfi1.scaglione
                   )),trunc((least(scfi2.scaglione,(nvl(sum(mofi.ipn_ac),0) - nvl(sum(mofi.ded_base_ac),0) - nvl(sum(mofi.ded_agg_ac),0))
                                          )
                    - scfi1.scaglione
                   ))),3,'0')) scaglione
      , to_char(scfi1.aliquota) aliquota
      , lpad(trunc((least(scfi2.scaglione,(nvl(sum(mofi.ipn_ac),0) - nvl(sum(mofi.ded_base_ac),0) - nvl(sum(mofi.ded_agg_ac),0))
                                          )
                    - scfi1.scaglione
                  )
                   * scfi1.aliquota / 100
            ),6)||decode(mod(((least(scfi2.scaglione,(nvl(sum(mofi.ipn_ac),0) - nvl(sum(mofi.ded_base_ac),0) - nvl(sum(mofi.ded_agg_ac),0))
                                          )
                    - scfi1.scaglione
                   )
                   * scfi1.aliquota / 100),trunc((least(scfi2.scaglione,(nvl(sum(mofi.ipn_ac),0) - nvl(sum(mofi.ded_base_ac),0) - nvl(sum(mofi.ded_agg_ac),0))
                                          )
                    - scfi1.scaglione
                   )
                   * scfi1.aliquota / 100)),0,'.00'
                   ,rpad(mod(((least(scfi2.scaglione,(nvl(sum(mofi.ipn_ac),0) - nvl(sum(mofi.ded_base_ac),0) - nvl(sum(mofi.ded_agg_ac),0))
                                          )
                    - scfi1.scaglione
                   )
                   * scfi1.aliquota / 100),trunc((least(scfi2.scaglione,(nvl(sum(mofi.ipn_ac),0) - nvl(sum(mofi.ded_base_ac),0) - nvl(sum(mofi.ded_agg_ac),0))
                                          )
                    - scfi1.scaglione
                   )
                   * scfi1.aliquota / 100)),3,'0')) imposta   from vista_scaglioni_fiscali scfi1
      , vista_scaglioni_fiscali scfi2
      , progressivi_fiscali mofi
      , ente ente
  where mofi.ci = p_ci
    and mofi.anno = p_anno
    and mofi.mese = p_mese
    and mofi.mensilita = p_mensilita
    and ente.ente_id = 'ENTE'
    and scfi1.dal = to_date('0101'||to_char(p_anno),'ddmmyyyy')
    and scfi2.dal = scfi1.dal
    and scfi2.scaglione = (select min(scaglione)
                             from vista_scaglioni_fiscali
                            where dal = scfi1.dal
                              and scaglione > scfi1.scaglione)
   group by scfi1.scaglione,scfi2.scaglione,scfi1.aliquota
   having scfi1.scaglione < sum(nvl(mofi.ipn_ac,0) - nvl(mofi.ded_base_ac,0) - nvl(mofi.ded_agg_ac,0))
 ;
 CURSOR sel_mal (p_ci  number, p_anno in number, p_mese number ) is
 select cod_astensione                       cod
      , max(descrizione)                     des
      , to_char(pere.dal,'dd/mm/yyyy')       dal
      , to_char(max(pere.al),'dd/mm/yyyy')   al
      , to_char(sum(gg_per))                 gg
      , to_char(max(per_gg))                 per
   from periodi_retributivi pere
       ,astensioni          aste
  where anno = p_anno
    and mese = p_mese
    and ci   = p_ci
    and competenza in ('a','p','c')
    and cod_astensione = codice
  group by cod_astensione, pere.dal
 ;
CURSOR sel_deli (p_ci number,p_anno number,p_mese number,p_mensilita varchar,p_gr_ling number) is
  select voec.sequenza sequenza
       , decode
         ( max(upper(moco.input))
         ,'R','01/'||lpad(TO_CHAR(p_mese),2,0)||'/'||TO_CHAR(p_anno)
             ,decode
              ( max(moco.arr)
              ,'P',to_char(max(decode( upper(moco.input)
                                     , 'C', nvl(moco.data,nvl(moco.competenza,moco.riferimento))
                                          , moco.riferimento
                                     )
                              ),'dd/mm/yyyy')
              ,'C',to_char(max(decode( upper(moco.input)
                                     , 'C', nvl(moco.data,nvl(moco.competenza,moco.riferimento))
                                          , moco.riferimento
                                     )
                              ),'dd/mm/yyyy')
                  ,decode
                   ( to_char(max(decode( upper(moco.input)
                                       , 'C', decode( moco.data
                                                    , null, nvl(moco.competenza,moco.riferimento)
                                                          , to_date('3333333','j')
                                                    )
                                       , 'A', moco.riferimento
                                            , to_date('3333333','j')
                                       )
                                ),'yyyy')
                   , p_anno
                   , '01/'||lpad(TO_CHAR(P_MESE),2,0)||'/'||TO_CHAR(p_anno)
                   , to_char(max(decode( upper(moco.input)
                                         , 'C', nvl(moco.data,nvl(moco.competenza,moco.riferimento))
                                              , moco.riferimento
                                          )
                                   ),'dd/mm/yyyy')
                   )
              )
        ) riferimento
       , max(moco.voce) voce
       , max(decode(p_gr_ling,1,nvl(covo.descrizione,nvl(covo.descrizione_al1,covo.descrizione_al2))
                              ,2,nvl(covo.descrizione_al1,nvl(covo.descrizione,covo.descrizione_al2))
                              ,3,nvl(covo.descrizione_al2,nvl(covo.descrizione,covo.descrizione_al1))
                                ,nvl(covo.descrizione,nvl(covo.descrizione_al1,covo.descrizione_al2)))) descrizione
       , to_char(sum(nvl(moco.imp,0))) imp
       , to_char(sum(nvl(moco.qta,0))) qta
       , to_char(sum(nvl(moco.tar,0))) tar
       , to_char(moco.anno_del)        anno_del
       , moco.sede_del                 sede_del
       , to_char(moco.numero_del)      numero_del
       , max(nvl(dere.causale,ddre.causale)) causale
    from movimenti_contabili       moco
       , voci_economiche           voec
       , contabilita_voce          covo
       , delibere_retributive      dere
       , def_delibere_retributive  ddre    
    where moco.ci   = p_ci
      and moco.anno = p_anno
      and moco.mese = p_mese
      and moco.delibera  = dere.tipo
      and moco.mensilita = p_mensilita
      and moco.voce = voec.codice
      and moco.voce = covo.voce
      and moco.sub  = covo.sub
      and nvl(moco.riferimento,last_day(to_date('01/'||lpad(TO_CHAR(P_MESE),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy')))
          between nvl(covo.dal,to_date('2222222','j'))
              and nvl(covo.al ,to_date('3333333','j'))
      and moco.voce not in (select codice
                              from voci_economiche
                             where automatismo in ('ARR_PRE','ARR_ATT',
                                                   'ARR_ATT_S','ARR_ATT_N',
                                                   'ARR_ATT_SN',
                                                   'COMP','TRAT','NETTO')
                           )
      and dere.anno       = moco.anno_del
      and dere.sede       = moco.sede_del
      and dere.numero     = moco.numero_del
      and dere.anno_elab  = p_anno
      and dere.mese       = p_mese
      and dere.mensilita  = p_mensilita
      and dere.anno       = ddre.anno (+)
      and dere.sede       = ddre.sede (+)
      and dere.numero     = ddre.numero (+)   
      and moco.anno_del   is not null
      and moco.sede_del   is not null
      and moco.numero_del is not null
      and voec.tipo       = 'C'
  group by voec.sequenza
         , moco.anno_del
         , moco.sede_del
         , moco.numero_del
  having  nvl(sum(moco.tar),0) != 0 or
          nvl(sum(decode(voec.classe,'R',0,moco.qta)),0) != 0 or
          nvl(sum(moco.imp),0) != 0;
   FUNCTION  VERSIONE              RETURN VARCHAR2;          
   FUNCTION  ritorna(p_variabile varchar2) RETURN varchar2;
   PROCEDURE RESET_P_PRENOTAZIONE_OLD;
   PROCEDURE Main(p_prenotazione in number,p_passo in number, p_ci in number, p_anno in number,
                  p_mese in number, p_mensilita in varchar2, p_gr_ling in varchar2, p_modello_stampa in varchar2, p_tipo_desformat in varchar2);
END;
/
CREATE OR REPLACE PACKAGE BODY pecsmor6 IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.25 del 13/09/2007';
END VERSIONE;
PROCEDURE RESET_P_PRENOTAZIONE_OLD IS
BEGIN
  P_PRENOTAZIONE_OLD := 0;
END;
PROCEDURE TRATTA_MOCO (p_ci number, p_anno number, p_mese number, p_mensilita varchar2, p_gr_ling in varchar2, p_tipo_desformat in varchar2) IS
ini_mese    date := to_date( '01/'||lpad(TO_CHAR(p_mese),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy');
fin_mese    date := last_day(to_date( '01/'||lpad(TO_CHAR(p_mese),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy'));
m_prec         date := last_day( add_months (ini_mese,ente_variabili_gepe*-1));
BEGIN
  select decode( sel_moco_arr
              ,null,decode(sel_moco_input||sel_moco_sub
                          ,'RI',sys_esnc3||sel_moco_descrizione
                          ,sel_moco_descrizione)
                   ,decode(sign(decode(sel_moco_imp,0,sel_moco_qta,sel_moco_imp))
                           ,-1,sys_esnc2
                           ,sys_esnc1
                          )||decode(sel_moco_arr
                                    ,'C',sel_moco_descrizione
                                    ,'P',substr(sel_moco_descrizione,1,27)||' '||sys_esnc4
                                   )
             )
    into sel_moco_descrizione
    from dual
  ;
  select lpad(decode(sel_moco_tipo
               ,'D',' '
                   ,sel_moco_sequenza
             ),4)
       , decode(sel_moco_tipo
               ,'D', sel_moco_descrizione
                   ,decode( sign( to_char(to_date(substr(sel_moco_data_rif,4),'mm/yyyy'),'j')
                               - to_char(to_date( decode(sel_moco_input
                                                        , 'R', substr(to_char(fin_mese,'dd/mm/yyyy'),4)
                                                        , 'C', substr(to_char(fin_mese,'dd/mm/yyyy'),4)
                                                        , 'A', substr(to_char(fin_mese,'dd/mm/yyyy'),4)
                                                             , substr(to_char(m_prec,'dd/mm/yyyy'),4)
                                                        ), 'mm/yyyy'), 'j'))
                          , 0, sel_moco_descrizione
                             ,substr(rpad(sel_moco_descrizione,29),1,29)
                              ||decode( to_char(to_date(sel_moco_data_rif,'dd/mm/yyyy'),'mm')
                                       ,'01',' '||substr(sys_esnc5,1,3)||'.'
                                       ,'02',' '||substr(sys_esnc5,4,3)||'.'
                                       ,'03',' '||substr(sys_esnc5,7,3)||'.'
                                       ,'04',' '||substr(sys_esnc5,10,3)||'.'
                                       ,'05',' '||substr(sys_esnc5,13,3)||'.'
                                       ,'06',' '||substr(sys_esnc5,16,3)||'.'
                                       ,'07',' '||substr(sys_esnc5,19,3)||'.'
                                       ,'08',' '||substr(sys_esnc5,22,3)||'.'
                                       ,'09',' '||substr(sys_esnc5,25,3)||'.'
                                       ,'10',' '||substr(sys_esnc5,28,3)||'.'
                                       ,'11',' '||substr(sys_esnc5,31,3)||'.'
                                       ,'12',' '||substr(sys_esnc5,34,3)||'.'
                                      )||to_char(to_date(sel_moco_data_rif,'dd/mm/yyyy'),'yy')))
  into sel_moco_sequenza,sel_moco_descrizione
  from dual
  ;
select translate(decode( sel_moco_tipo
              ,'D',sel_moco_tar_st
                  ,decode(sel_moco_stampa_tar
                         ,'T',decode(sel_moco_tar_st
                                    ,0,null
                                      ,decode(greatest(length(trunc(sel_moco_tar_st)),5)
                                             ,5,lpad(decode(trunc(sel_moco_tar_st)
                                                     ,0,decode(sign(sel_moco_tar_st)
                                                              , -1,'-'||trunc(sel_moco_tar_st)
                                                                  , trunc(sel_moco_tar_st)
                                                              )
                                                       ,trunc(sel_moco_tar_st)
                                                     ),5)
                                                ||decode(mod(sel_moco_tar_st,trunc(sel_moco_tar_st))
                                                        ,0,'.00000'
                                                        ,rpad(abs(mod(sel_moco_tar_st,trunc(sel_moco_tar_st))),6,'0')
                                                         )
                                                  ,lpad(sel_moco_tar_st,11)
                                               )
                                     )
                          ,'P',decode(sel_moco_tar_st
                                      ,0,null
                                        ,lpad(sel_moco_tar_st,11)
                                     )
                              ,decode(sel_moco_stampa_qta
                                      ,'T',decode(sel_moco_qta_st
                                                  ,0,null
                                                    ,decode(greatest(length(trunc(sel_moco_qta_st)),5)
                                                            ,5,lpad(decode(trunc(sel_moco_qta_st)
                                                                          , 0, decode(sign(sel_moco_qta_st)
                                                                                     , -1,'-'||trunc(sel_moco_qta_st)
                                                                                         , trunc(sel_moco_qta_st)
                                                                                     )
                                                                             , trunc(sel_moco_qta_st)
                                                                          ),5)
                                                               ||decode(mod(sel_moco_qta_st,trunc(sel_moco_qta_st))
                                                                       ,0,null
                                                                         ,rpad(abs(mod(sel_moco_qta_st,trunc(sel_moco_qta_st))),6,'0')
                                                                       )
                                                           ,lpad(sel_moco_qta_st,11)
                                                           )
                                                 )
                                      ,'P',decode(sel_moco_qta_st
                                                  ,0,null
                                                    ,lpad(sel_moco_tar_st,11)
                                                 )
                                          ,decode(sel_moco_stampa_imp
                                                 ,'T',decode(sel_moco_imp_st
                                                            ,0,null
                                                              ,decode(greatest(length(trunc(sel_moco_imp_st)),5)
                                                                     ,5,lpad(decode(trunc(sel_moco_imp_st)
                                                                                   , 0,decode(sign(sel_moco_imp_st)
                                                                                             ,-1,'-'||trunc(sel_moco_imp_st)
                                                                                                , trunc(sel_moco_imp_st)
                                                                                             )
                                                                                       , trunc(sel_moco_imp_st)
                                                                                      ),5)
                                                                        ||decode(mod(sel_moco_imp_st,trunc(sel_moco_imp_st))
                                                                                ,0,'.00000'
                                                                                  ,rpad(abs(mod(sel_moco_imp_st,trunc(sel_moco_imp_st))),6,'0')
                                                                                )
                                                                       ,lpad(sel_moco_imp_st,11)
                                                                     )
                                                            )
                                                ,'P',decode(sel_moco_imp_st
                                                           ,0,null
                                                             ,lpad(sel_moco_tar_st,11)
                                                           )
                                                    ,decode(nvl(sel_moco_tipo_rapporto,nvl(pere_tipo_rapporto,' '))
                                                             ,nvl(pere_tipo_rapporto,' '),decode(sel_moco_ore
                                                                                      ,pere_ore,null
                                                                                           ,'(h,'||sel_moco_ore
                                                                               ,sel_moco_tipo_rapporto)))))),',.','.,')
  into sel_moco_tar_st_temp
  from dual
 ;
 select decode( sel_moco_tipo
               ,'D',sel_moco_qta_st
                   ,decode(sel_moco_stampa_qta
                          ,'Q',decode(sel_moco_qta_st
                                     ,0,null
                                     ,decode(greatest(length(trunc(sel_moco_qta_st)),5)
                                            ,5,lpad(decode(nvl(trunc(abs(sel_moco_qta_st)),0)
                         ,0,decode(sign(abs(sel_moco_qta_st)
                                                                                            *decode(sel_moco_tipo,'T',1,sign(sel_moco_qta_st))
                                                                                                   )
                          ,-1,'-'||trunc(sel_moco_qta_st)
                    ,trunc(sel_moco_qta_st)
                 )
                       ,trunc(abs(sel_moco_qta_st)
                                                                                           *decode(sel_moco_tipo,'T',1,sign(sel_moco_qta_st))
                                                                                                   )
                 )                                                        
                                                        ,5)||decode(sel_moco_specie
                                                                    ,'H',':'||lpad(round(mod(abs(sel_moco_qta_st *100),100
                                                                                  )/100*60),2,0)
                                                                        ,','||lpad(abs(round((sel_moco_qta_st - trunc(sel_moco_qta_st)
                                                                                  )*100)),2,'0')
                                                                   )
                                                  ,substr
                                                   (lpad( nvl( trunc(abs(sel_moco_qta_st))
                                                              ,0)*decode(sel_moco_tipo,'T',1,sign(sel_moco_qta_st))
                                                        ,10)
                                                   ,3,8)
                                               )
                                     )
                          ,'O',decode(sel_moco_qta_st
                                      ,0,null
                                        ,substr
                                         (lpad(nvl(trunc(abs(sel_moco_qta_st))
                                                   ,0)*decode(sel_moco_tipo,'T',1,sign(sel_moco_qta_st))
                                              ,10)
                                         ,3,8)
                                     )
                              ,decode(sel_moco_stampa_tar
                                      ,'Q',decode(sel_moco_tar_st
                                                  ,0,null
                                                    ,decode( greatest(length(trunc(sel_moco_tar_st)),5)
                                                            ,5,lpad(decode( trunc(sel_moco_tar_st)
                                                                          , 0, decode( sign(sel_moco_tar_st)
                                                                                     , -1, '-'||trunc(sel_moco_tar_st)
                                                                                         , trunc(sel_moco_tar_st)
                                                                                      )
                                                                             , trunc(sel_moco_tar_st)
                                                                          )
                                                                   ,5)||
                                                               ','||lpad(abs((e_round(sel_moco_tar_st,'I')-trunc(sel_moco_tar_st))*100
                                                                        ),2,'0')
                                                              ,substr
                                                               (lpad(trunc(sel_moco_tar_st)
                                                                    ,10)
                                                               ,3,8)
                                                           )
                                                 )
                                      ,'O',decode(sel_moco_tar_st
                                                  ,0,null
                                                    ,substr
                                                     (lpad(trunc(sel_moco_tar_st)
                                                          ,10)
                                                     ,3,8)
                                                 )
                                          ,decode(sel_moco_stampa_imp
                                                  ,'Q',decode(sel_moco_imp_st
                                                              ,0,null
                                                                ,decode( greatest(length(abs(trunc(sel_moco_imp_st))),5)
                                                                        ,5,lpad(decode( trunc(sel_moco_imp_st)
                                                                                      , 0, decode( sign(sel_moco_imp_st)
                                                                                                 , -1, '-'||trunc(sel_moco_imp_st)
                                                                                                     , trunc(sel_moco_imp_st)
                                                                                                  )
                                                                                         , trunc(sel_moco_imp_st)
                                                                                       )
                                                                               ,5)||
                                                                             ','||lpad(abs((e_round(sel_moco_imp_st,'I')-trunc(sel_moco_imp_st))*100
                                                                                              ),2,'0')
                                                                          ,substr
                                                                           (lpad(trunc(sel_moco_imp_st)
                                                                                ,10)
                                                                           ,3,8)
                                                                       )
                                                             )
                                                  ,'O',decode(sel_moco_imp_st
                                                              ,0,null
                                                                ,substr
                                                                 (lpad(trunc(sel_moco_imp_st)
                                                                      ,10)
                                                                 ,3,8)
                                                             )
                                                      ,null
                                                 )
                                     )
                         ))
 into sel_moco_qta_st_temp
 from dual
 ;
SELECT decode(sel_moco_tipo
             ,'D',sel_moco_imp_st
                 ,decode(sel_moco_stampa_imp
                        ,'I',decode(sel_moco_tipo
                                   ,'T',decode(mod(nvl(sel_moco_imp,0),trunc(nvl(sel_moco_imp,0)))
                                              ,0,lpad((nvl(sel_moco_imp,0)*-1)||',00'
                                                           ,decode(p_tipo_desformat,'PDF',round(8 * 1),8),' ')
                                                          , lpad(rtrim(sign(nvl(sel_moco_imp,0)*-1),'1')||
                         abs(trunc(nvl(sel_moco_imp,0)))||','||
                                                            lpad(abs(nvl(sel_moco_imp,0)-trunc(nvl(sel_moco_imp,0)))*100,2,'0')
                                                           ,decode(p_tipo_desformat,'PDF',round(8 * 1),8),' ')
                                                         )
                  ,'C',decode(mod(NVL(sel_moco_imp,0),TRUNC(NVL(sel_moco_imp,0)))
                                                         ,0, LPAD(NVL(sel_moco_imp,0)||',00'
                                                           ,decode(p_tipo_desformat,'PDF',round(17 * 1),17),' ')
                                                           , LPAD(RTRIM(SIGN(NVL(sel_moco_imp,0)),'1')||
                               ABS(TRUNC(NVL(sel_moco_imp,0)))||','||
                                                             lpad(ABS(NVL(sel_moco_imp,0)-trunc(NVL(sel_moco_imp,0)))*100,2,'0')
                                                                 ,decode(p_tipo_desformat,'PDF',round(17 * 1),17),' ')
                                                         )
                         ,'F',DECODE(SIGN(NVL(sel_moco_imp,0))
                                    ,-1,DECODE(MOD(NVL(sel_moco_imp,0),TRUNC(NVL(sel_moco_imp,0)))
                                              ,0, LPAD((NVL(sel_moco_imp,0)*-1)||',00'
                                                           ,decode(p_tipo_desformat,'PDF',round(8 * 1),8),' ')
                                                , LPAD(RTRIM(SIGN(NVL(sel_moco_imp,0)*-1),'1')||
                     ABS(TRUNC(NVL(sel_moco_imp,0)))||','||
                                                  lpad( ABS(NVL(sel_moco_imp,0)-TRUNC(NVL(sel_moco_imp,0)))*100,2,'0')
                                                           ,decode(p_tipo_desformat,'PDF',round(8 * 1),8),' ')
                                                       )
                                    , 1,DECODE(MOD(NVL(sel_moco_imp,0),TRUNC(NVL(sel_moco_imp,0)))
                                              ,0, LPAD(NVL(sel_moco_imp,0)||',00'
                                                      ,decode(p_tipo_desformat,'PDF',round(17 * 1),17),' ')
                                                , LPAD(RTRIM(SIGN(NVL(sel_moco_imp,0)),'1')||
                     ABS(TRUNC(NVL(sel_moco_imp,0)))||','||
                                                  lpad( ABS(NVL(sel_moco_imp,0)-TRUNC(NVL(sel_moco_imp,0)))*100,2,'0')
                                                           ,decode(p_tipo_desformat,'PDF',round(17 * 1),17),' ')                                                       )
                                     )
                         )
                  ,DECODE(sel_moco_stampa_tar
                          ,'I',DECODE(sel_moco_tipo
                                     ,'T',DECODE(MOD(NVL(sel_moco_tar,0),TRUNC(NVL(sel_moco_tar,0)))
                                                ,0, LPAD(NVL(sel_moco_tar,0)||',00'
                                                           ,decode(p_tipo_desformat,'PDF',round(8 * 1),8),' ')
                                                  , LPAD(RTRIM(SIGN(NVL(sel_moco_tar,0)*-1),'1')||
                ABS(TRUNC(NVL(sel_moco_tar,0)))||','||
                                                    lpad(ABS(e_round(NVL(sel_moco_tar,0),'I')-TRUNC(NVL(sel_moco_tar,0)))*100,2,'0')
                                                           ,decode(p_tipo_desformat,'PDF',round(8 * 1),8),' ')                                                )
                          ,'C',DECODE(MOD(NVL(sel_moco_tar,0),TRUNC(NVL(sel_moco_tar,0)))
                                     ,0, LPAD(NVL(sel_moco_tar,0)||',00'
                                             ,decode(p_tipo_desformat,'PDF',round(17 * 1),17),' ')
                                       , LPAD(RTRIM(SIGN(NVL(sel_moco_tar,0)),'1')||
                ABS(TRUNC(NVL(sel_moco_tar,0)))||','||
                                         lpad(ABS(e_round(NVL(sel_moco_tar,0),'I')-TRUNC(NVL(sel_moco_tar,0)))*100,2,'0')
                                                           ,decode(p_tipo_desformat,'PDF',round(17 * 1),17),' ')                                                )
                          ,'F',DECODE(SIGN(NVL(sel_moco_tar,0))
                                          ,-1,DECODE(MOD(NVL(sel_moco_tar,0),TRUNC(NVL(sel_moco_tar,0)))
                                                    ,0, LPAD((NVL(sel_moco_tar,0)*-1)||',00'
                                                           ,decode(p_tipo_desformat,'PDF',round(8 * 1),8),' ')
                                                      , LPAD(RTRIM(SIGN(NVL(sel_moco_tar,0)*-1),'1')||
                                                ABS(TRUNC(NVL(sel_moco_tar,0)))||','||
                                                        lpad(ABS(e_round(NVL(sel_moco_tar,0),'I')-TRUNC(NVL(sel_moco_tar,0)))*100,2,'0')
                                                           ,decode(p_tipo_desformat,'PDF',round(8 * 1),8),' ')                                                     )
                                          , 1,DECODE(MOD(NVL(sel_moco_tar,0),TRUNC(NVL(sel_moco_tar,0)))
                                                            ,0, LPAD(NVL(sel_moco_tar,0)||',00'
                                                           ,decode(p_tipo_desformat,'PDF',round(17 * 1),17),' ')
                                                              , LPAD(RTRIM(SIGN(NVL(sel_moco_tar,0)),'1')||
                                       ABS(TRUNC(NVL(sel_moco_tar,0)))||','||
                                                                lpad(ABS(e_round(NVL(sel_moco_tar,0),'I')-TRUNC(NVL(sel_moco_tar,0)))*100,2,'0')
                                                           ,decode(p_tipo_desformat,'PDF',round(17 * 1),17),' ')                                                                       )
                                                     ))
                  ,DECODE(sel_moco_stampa_qta
                         ,'I',DECODE(sel_moco_tipo
                             ,'T',DECODE(MOD(NVL(sel_moco_qta,0),TRUNC(NVL(sel_moco_qta,0)))
                                        ,0, LPAD((NVL(sel_moco_qta,0)*-1)||',00'
                                                           ,decode(p_tipo_desformat,'PDF',round(8 * 1),8),' ')
                                          , LPAD(RTRIM(SIGN(NVL(sel_moco_qta,0)*-1),'1')||
             ABS(TRUNC(NVL(sel_moco_qta,0)))||','||
                                            lpad(ABS(e_round(NVL(sel_moco_qta,0),'I')-TRUNC(NVL(sel_moco_qta,0)))*100,2,'0')
                                                           ,decode(p_tipo_desformat,'PDF',round(8 * 1),8),' ')                                        )
                             ,'C',DECODE(MOD(NVL(sel_moco_qta,0),TRUNC(NVL(sel_moco_qta,0)))
                                        ,0, LPAD(NVL(sel_moco_qta,0)||',00'
                                                           ,decode(p_tipo_desformat,'PDF',round(17 * 1),17),' ')
                                          , LPAD(RTRIM(SIGN(NVL(sel_moco_qta,0)),'1')||
                  ABS(TRUNC(NVL(sel_moco_qta,0)))||','||
                                            lpad(ABS(e_round(NVL(sel_moco_qta,0),'I')-TRUNC(NVL(sel_moco_qta,0)))*100,2,'0')
                                                           ,decode(p_tipo_desformat,'PDF',round(17 * 1),17),' ')                                        )
                             ,'F',DECODE(SIGN(NVL(sel_moco_qta,0))
                                        ,-1,DECODE(MOD(NVL(sel_moco_qta,0),TRUNC(NVL(sel_moco_qta,0)))
                                                  ,0, LPAD((NVL(sel_moco_qta,0)*-1)||',00'
                                                           ,decode(p_tipo_desformat,'PDF',round(8 * 1),8),' ')
                                                    , LPAD(RTRIM(SIGN(NVL(sel_moco_qta,0)*-1),'1')||
                                                   ABS(TRUNC(NVL(sel_moco_qta,0)))||','||
                                                      lpad(ABS(e_round(NVL(sel_moco_qta,0),'I')-TRUNC(NVL(sel_moco_qta,0)))*100,2,'0')
                                                           ,decode(p_tipo_desformat,'PDF',round(8 * 1),8),' ')                                                  )
                                        , 1,DECODE(MOD(NVL(sel_moco_qta,0),TRUNC(NVL(sel_moco_qta,0)))
                                                  ,0, LPAD(NVL(sel_moco_qta,0)||',00'
                                                           ,decode(p_tipo_desformat,'PDF',round(17 * 1),17),' ')
                                                    , LPAD(RTRIM(SIGN(NVL(sel_moco_qta,0)),'1')||
                                                          ABS(TRUNC(NVL(sel_moco_qta,0)))||','||
                                                      lpad(ABS(e_round(NVL(sel_moco_qta,0),'I')-TRUNC(NVL(sel_moco_qta,0)))*100,2,'0')
                                                           ,decode(p_tipo_desformat,'PDF',round(17 * 1),17),' ')
                                                  )
                                        )
                          )
                          ,NULL
                                   )
                         )
               ))
  into sel_moco_imp_st_temp
  FROM dual
;
  sel_moco_tar_st := sel_moco_tar_st_temp;
  sel_moco_qta_st := sel_moco_qta_st_temp; 
  sel_moco_imp_st := sel_moco_imp_st_temp; 
END;
PROCEDURE TRATTA_CURSORE (p_nome_cursore in varchar2, p_ci number, p_anno number, p_mese number, p_mensilita varchar2, p_gr_ling in varchar2
                         ,p_stampa_fr in varchar2,p_tipo_desformat in varchar2) is
w_gruppo_ling number;
BEGIN
 BEGIN
   select sequenza
     into w_gruppo_ling
     from gruppi_linguistici
    where gruppo = decode(p_lingua,'*','I',upper(p_lingua))
      and gruppo_al = p_gr_ling
    ;
 EXCEPTION WHEN NO_DATA_FOUND THEN
     w_gruppo_ling := 1;  /* default a Italiano */
 END;
IF w_ultimo_cursore != p_nome_cursore then
   if SEL_INEC %ISOPEN then
     null;
   else
     open sel_inec(p_ci ,p_anno ,p_mese ,p_mensilita ,w_gruppo_ling,p_stampa_fr);
   end if;
   if SEL_MOV_ORIZ %ISOPEN then
     null;
   else
    open sel_mov_oriz(p_ci ,p_anno ,p_mese ,p_mensilita ,w_gruppo_ling,p_stampa_fr);
   end if;
   if SEL_NOTE %ISOPEN then
     null;
   else
    open sel_note(p_ci ,p_anno ,p_mese ,p_mensilita ,w_gruppo_ling,p_stampa_fr);
   end if;
   if SEL_IMP_M %ISOPEN then
     null;
   else
    open sel_imp_m(p_ci ,p_anno ,p_mese ,p_mensilita ,w_gruppo_ling,p_stampa_fr);
   end if;
   if SEL_IMP_A %ISOPEN then
     null;
   else
    open sel_imp_a(p_ci ,p_anno ,p_mese ,p_mensilita ,w_gruppo_ling,p_stampa_fr);
   end if;
   if SEL_MAL %ISOPEN then
     null;
   else
    open sel_mal(p_ci ,p_anno ,p_mese);
   end if;
   if SEL_DELI %ISOPEN then
     null;
   else
    open sel_deli(p_ci ,p_anno ,p_mese ,p_mensilita ,w_gruppo_ling);
   end if;
   w_ultimo_cursore := p_nome_cursore;
 END IF;
 IF w_riga_trattata = 1 THEN
  IF upper(p_nome_cursore) = 'SEL_INEC' THEN
    fetch sel_inec into sel_inec_anz_voce,sel_inec_anz_numero,sel_inec_anz_data,sel_inec_qual_descrizione;
    IF sel_inec%notfound THEN
       sel_inec_anz_voce := ' ';
       sel_inec_anz_numero := ' ';
       sel_inec_anz_data := ' ';
       sel_inec_qual_descrizione := ' ';
       anag_partita_iva := null;
    END IF;
  ELSIF upper(p_nome_cursore) = 'SEL_MOV_ORIZ' THEN
    fetch sel_mov_oriz into sel_mov_oriz_des_v1,sel_mov_oriz_val_v1,sel_mov_oriz_des_v2,sel_mov_oriz_val_v2,sel_mov_oriz_des_v3,sel_mov_oriz_val_v3
         ,sel_mov_oriz_des_v4,sel_mov_oriz_val_v4,sel_mov_oriz_des_v5,sel_mov_oriz_val_v5,sel_mov_oriz_des_v6,sel_mov_oriz_val_v6;
    IF sel_mov_oriz%notfound THEN
       sel_mov_oriz_des_v1 := ' ';
       sel_mov_oriz_val_v1 := ' ';
       sel_mov_oriz_des_v2 := ' ';
       sel_mov_oriz_val_v2 := ' ';
       sel_mov_oriz_des_v3 := ' ';
       sel_mov_oriz_val_v3 := ' ';
       sel_mov_oriz_des_v4 := ' ';
       sel_mov_oriz_val_v4 := ' ';
       sel_mov_oriz_des_v5 := ' ';
       sel_mov_oriz_val_v5 := ' ';
       sel_mov_oriz_des_v6 := ' ';
       sel_mov_oriz_val_v6 := ' ';
    END IF;
    IF sel_mov_oriz_val_v1 is null THEN
       sel_mov_oriz_des_v1 := null;
    END IF;
    IF sel_mov_oriz_val_v2 is null THEN
       sel_mov_oriz_des_v2 := null;
    END IF;
    IF sel_mov_oriz_val_v3 is null THEN
       sel_mov_oriz_des_v3 := null;
    END IF;
    IF sel_mov_oriz_val_v4 is null THEN
       sel_mov_oriz_des_v4 := null;
    END IF;
    IF sel_mov_oriz_val_v5 is null THEN
       sel_mov_oriz_des_v5 := null;
    END IF;
    IF sel_mov_oriz_val_v6 is null THEN
       sel_mov_oriz_des_v6 := null;
    END IF;
  ELSIF upper(p_nome_cursore) = 'SEL_MOCO' THEN
    fetch sel_moco into sel_moco_sequenza,sel_moco_data_rif,sel_moco_voce,sel_moco_sub,sel_moco_input,sel_moco_imp
                      , sel_moco_qta,sel_moco_tar,sel_moco_arr,sel_moco_descrizione,sel_moco_tipo,sel_moco_tar_st
                      , sel_moco_qta_st, sel_moco_imp_st,sel_moco_stampa_tar,sel_moco_stampa_qta
                      , sel_moco_stampa_imp,sel_moco_tipo_rapporto,sel_moco_ore,sel_moco_specie,sel_moco_seq_ord
                      , sel_moco_arr_ord,sel_moco_riferimento;
    IF sel_moco%notfound THEN
       sel_moco_sequenza := ' ';
       sel_moco_data_rif := '';
       sel_moco_voce := '';
       sel_moco_sub := '';
       sel_moco_input := '';
       sel_moco_imp := '';
       sel_moco_qta := '';
       sel_moco_tar := '';
       sel_moco_arr := '';
       sel_moco_descrizione := ' ';
       sel_moco_tipo := ' ';
       sel_moco_tar_st := ' ';
       sel_moco_qta_st := ' ';
       sel_moco_imp_st := ' ';
       sel_moco_stampa_tar := ' ';
       sel_moco_stampa_qta := ' ';
       sel_moco_stampa_imp := ' ';
       sel_moco_tipo_rapporto := ' ';
       sel_moco_ore := '';
       sel_moco_specie := ' ';
       sel_moco_seq_ord := '';
       sel_moco_arr_ord := '';
       sel_moco_riferimento := '';
    ELSE
      TRATTA_MOCO (p_ci ,p_anno ,p_mese ,p_mensilita ,w_gruppo_ling, p_tipo_desformat);
    END IF;
  ELSIF upper(p_nome_cursore) = 'SEL_NOTE' THEN
    fetch sel_note into sel_note_sequenza,sel_note_note,sel_note_nota;
    IF sel_note%notfound THEN
       sel_note_sequenza := '';
       sel_note_note := '';
       sel_note_nota := '';
    END IF;
  ELSIF upper(p_nome_cursore) = 'SEL_IMP_M' THEN
    fetch sel_imp_m into sel_imp_m_scaglione_ord,sel_imp_m_aliquota_ord,sel_imp_m_imposta_ord,
                         sel_imp_m_scaglione_sep,sel_imp_m_aliquota_sep,sel_imp_m_imposta_sep;
    IF sel_imp_m %notfound THEN
       sel_imp_m_scaglione_ord := ' ';
       sel_imp_m_aliquota_ord := ' ';
       sel_imp_m_imposta_ord := ' ';
       sel_imp_m_scaglione_sep := ' ';
       sel_imp_m_aliquota_sep := ' ';
       sel_imp_m_imposta_sep := ' ';
    END IF;
  ELSIF upper(p_nome_cursore) = 'SEL_IMP_A' THEN
    fetch sel_imp_a into sel_imp_a_scaglione,sel_imp_a_aliquota,sel_imp_a_imposta;
    IF sel_imp_a %notfound THEN
       sel_imp_a_scaglione := ' ';
       sel_imp_a_aliquota := ' ';
       sel_imp_a_imposta := ' ';
    END IF;
  ELSIF upper(p_nome_cursore) = 'SEL_MAL' THEN
    fetch sel_mal into    sel_mal_cod,sel_mal_des,sel_mal_dal,sel_mal_al,sel_mal_gg,sel_mal_per;
    IF sel_mal %notfound THEN
       sel_mal_cod := ' ';
       sel_mal_des := ' ';
       sel_mal_dal := ' ';
       sel_mal_al  := ' ';
       sel_mal_gg  := ' ';
       sel_mal_per := ' ';
    END IF;
  ELSIF upper(p_nome_cursore) = 'SEL_DELI' THEN
    fetch sel_deli into sel_deli_sequenza,sel_deli_riferimento,sel_deli_voce,sel_deli_descrizione,sel_deli_imp
                      , sel_deli_qta,sel_deli_tar,sel_deli_anno_del,sel_deli_sede_del,sel_deli_numero_del,sel_deli_causale;
    IF sel_deli %notfound THEN
       sel_deli_sequenza    := ' ';
       sel_deli_riferimento    := ' ';
       sel_deli_voce        := ' ';
       sel_deli_descrizione := ' ';
       sel_deli_imp         := ' ';
       sel_deli_qta         := ' ';
       sel_deli_tar         := ' ';
       sel_deli_anno_del    := ' ';
       sel_deli_sede_del    := ' ';
       sel_deli_numero_del  := ' ';
       sel_deli_causale     := ' ';
    END IF;
  END IF;
 END IF;
END;
PROCEDURE determina_riga (p_struttura_riga in varchar2, p_riga out varchar2, p_ci in number, p_anno in number,
                          p_mese in number, p_mensilita in varchar2,p_gr_ling in varchar2,p_stampa_fr in varchar2,p_tipo_desformat in varchar2) is
  wtemp_riga  varchar2(2000);
  ultima_pos  number;
  wprompt   varchar2(80);
  nome_oggetto  varchar2(50);
BEGIN
  wtemp_riga := ltrim(p_struttura_riga);
  w_riga_trattata := 1;
  p_riga := 'begin pecsmor6.wriga := null ';
  ultima_pos := 1;
  WHILE instr(wtemp_riga,'>') != 0 LOOP
    IF substr(wtemp_riga,1,3) = '<P:' THEN       /* devo trattare un prompt */
  wtemp_riga   := '<'||substr(wtemp_riga,4);
  wprompt   := substr(wtemp_riga,2,instr(wtemp_riga,',')-2);
  wtemp_riga   := substr(wtemp_riga,instr(wtemp_riga,',')+1);
       posizione := to_number(substr(wtemp_riga,1,instr(wtemp_riga,'>')-1));
  lunghezza   := length(wprompt);
       IF p_tipo_desformat = 'PDF' THEN
         posizione := ceil(posizione * 1.2) +1;
         lunghezza := ceil(lunghezza * 1.2);
       END IF;
  wtemp_riga   := ltrim(substr(wtemp_riga,instr(wtemp_riga,'>')+1));
       p_riga    := p_riga||'||rpad('' '','||to_char(posizione-ultima_pos)||')||'''||wprompt||'''';
     ELSIF SUBSTR(wtemp_riga,1,3) = '<V:' THEN    /* devo trattare una variabile */
  wtemp_riga   := '<'||substr(wtemp_riga,4);
   nome_oggetto := substr(wtemp_riga,2,instr(wtemp_riga,',')-2);
  wtemp_riga   := substr(wtemp_riga,instr(wtemp_riga,',')+1);
       posizione := to_number(substr(wtemp_riga,1,instr(wtemp_riga,',')-1));
  wtemp_riga   := substr(wtemp_riga,instr(wtemp_riga,',')+1);
  lunghezza   := to_number(substr(wtemp_riga,1,instr(wtemp_riga,'>')-1));
       IF p_tipo_desformat = 'PDF' THEN
         posizione := ceil(posizione * 1.2) +1;
         lunghezza := ceil(lunghezza * 1.2);
       END IF;
  wtemp_riga   := ltrim(substr(wtemp_riga,instr(wtemp_riga,'>')+1));
       p_riga   := p_riga||'||rpad('' '','||to_char(posizione-ultima_pos)||')||rpad(pecsmor6.ritorna(''pecsmor6.'||replace(nome_oggetto,'.','_')||'''),'||to_char(lunghezza)||','' '')';
     ELSIF SUBSTR(wtemp_riga,1,3) = '<F:' THEN /* devo trattare una funzione esterna */
       wtemp_riga   := '<'||substr(wtemp_riga,4);
  nome_oggetto := substr(wtemp_riga,2,instr(wtemp_riga,',')-2);
  wtemp_riga   := substr(wtemp_riga,instr(wtemp_riga,',')+1);
       posizione := to_number(substr(wtemp_riga,1,instr(wtemp_riga,',')-1));
  wtemp_riga   := substr(wtemp_riga,instr(wtemp_riga,',')+1);
  lunghezza   := to_number(substr(wtemp_riga,1,instr(wtemp_riga,'>')-1));
       IF p_tipo_desformat = 'PDF' THEN
         posizione := ceil(posizione * 1.2) +1;
         lunghezza := ceil(lunghezza * 1.2);
       END IF;
       wtemp_riga   := ltrim(substr(wtemp_riga,instr(wtemp_riga,'>')+1));
  p_riga   := p_riga||'||rpad('' '','||to_char(posizione-ultima_pos)||')||rpad('||nome_oggetto||'('||TO_CHAR(P_CI)||','||TO_CHAR(P_ANNO)||','||TO_CHAR(P_MESE)||','''||P_MENSILITA||''')'||','||to_char(lunghezza)||','' '')';
    ELSIF substr(wtemp_riga,1,3) = '<C:' THEN
       tratta_cursore(substr(wtemp_riga,4,instr(wtemp_riga,'.')-4),p_ci,p_anno,p_mese,p_mensilita,p_gr_ling,p_stampa_fr,p_tipo_desformat);
  w_riga_trattata := 2;
  wtemp_riga   := '<'||substr(wtemp_riga,4);
  nome_oggetto := substr(wtemp_riga,2,instr(wtemp_riga,',')-2);
  wtemp_riga   := substr(wtemp_riga,instr(wtemp_riga,',')+1);
       posizione := to_number(substr(wtemp_riga,1,instr(wtemp_riga,',')-1));
  wtemp_riga   := substr(wtemp_riga,instr(wtemp_riga,',')+1);
  lunghezza   := to_number(substr(wtemp_riga,1,instr(wtemp_riga,'>')-1));
       IF p_tipo_desformat = 'PDF' and upper(nome_oggetto) != 'SEL_NOTE.NOTE' THEN -- se note tengo tutto
         posizione := ceil(posizione * 1.2) +1;
         lunghezza := ceil(lunghezza * 1.2);
       END IF;
  wtemp_riga   := ltrim(substr(wtemp_riga,instr(wtemp_riga,'>')+1));
    if upper(nome_oggetto) != 'SEL_NOTE.NOTE' THEN
    p_riga   := p_riga||'||rpad('' '','||to_char(posizione-ultima_pos)||')||rpad(pecsmor6.ritorna(''pecsmor6.'||replace(nome_oggetto,'.','_')||'''),'||to_char(lunghezza)||','' '')';
   else -- per le note tengo tutto
     p_riga   := p_riga||'|| pecsmor6.ritorna(''pecsmor6.'||replace(nome_oggetto,'.','_')||''')';
   end if;
    ELSE
      exit;
    END IF;
    ultima_pos := posizione+lunghezza;
  END LOOP;
  p_riga := p_riga||'; end;';
END;
FUNCTION ritorna (p_variabile varchar2) RETURN varchar2 is
BEGIN
  si4.sql_execute('begin pecsmor6.v_ritorna := nvl(' || p_variabile ||','' ''); end;');
  return pecsmor6.v_ritorna;
END;
PROCEDURE Main (p_prenotazione in number,p_passo in number, p_ci in number, p_anno in number,
                p_mese in number, p_mensilita in varchar2,p_gr_ling in varchar2,p_modello_stampa in varchar2,p_tipo_desformat in varchar2) is
elenco_campi   varchar2(2000);
werrore    varchar2(200);
ini_mese    date := to_date( '01/'||lpad(TO_CHAR(p_mese),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy');
fin_mese    date := last_day(to_date( '01/'||lpad(TO_CHAR(p_mese),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy'));
m_prec    date;
variabili_gepe number;
undefined_object EXCEPTION;
PRAGMA EXCEPTION_INIT(undefined_object,-06550);
PROCEDURE SCRIVI (P_tipo varchar2,p_contatore number,p_flag_stampa varchar2) is
CURSOR sel_riga is
 select stms.riga,stms.sequenza
   from struttura_modelli_stampa stms
  where stms.codice = nvl(p_modello_stampa,'CEDOLINO')
    and stms.tipo_riga = p_tipo
    and ( stms.flag_stampa = 'T'
        and not exists (select 'x'
                          from struttura_modelli_stampa s
                         where s.codice = nvl(p_modello_stampa,'CEDOLINO')
                           and s.tipo_riga = p_tipo
                           and s.sequenza = stms.sequenza
                           and s.flag_stampa = p_flag_stampa
                        )
        or stms.flag_stampa = p_flag_stampa)
  order by stms.sequenza
  ;
contatore    number := p_contatore;
elenco_campi varchar2(2000);
BEGIN
 -- calcolo la dimensione del'intestazone
 BEGIN
   select max(stms.sequenza)
     into dim_testa
     from struttura_modelli_stampa stms
    where stms.codice = nvl(p_modello_stampa,'CEDOLINO')
      and stms.tipo_riga = 'I'
      and ( stms.flag_stampa = 'T'
          and not exists (select 'x'
                            from struttura_modelli_stampa s
                           where s.codice = nvl(p_modello_stampa,'CEDOLINO')
                             and s.tipo_riga = p_tipo
                             and s.sequenza = stms.sequenza
                             and s.flag_stampa = p_flag_stampa
                          )
          or stms.flag_stampa = p_flag_stampa)
     ;
 END;
 -- calcolo la dimensione del piede
 BEGIN
   select nvl(min(stms.sequenza),0)
     into dim_piede
     from struttura_modelli_stampa stms
    where stms.codice = nvl(p_modello_stampa,'CEDOLINO')
      and stms.tipo_riga = 'P'
      and ( stms.flag_stampa = 'T'
          and not exists (select 'x'
                            from struttura_modelli_stampa s
                           where s.codice = nvl(p_modello_stampa,'CEDOLINO')
                             and s.tipo_riga = 'P'
                             and s.sequenza = stms.sequenza
                             and s.flag_stampa = p_flag_stampa
                          )
          or stms.flag_stampa = p_flag_stampa)
   ;
 END;
 -- incremento i contatori di pagina
 IF p_tipo = 'I' THEN
    sys_num_pag_eff := sys_num_pag_eff +1;
    sys_num_pag_tot := sys_num_pag_tot +1;
    sys_num_pag := to_char(to_number(nvl(sys_num_pag,nvl(sys_num_pag_app - 1,0))) + 1);
 END IF;
 IF p_tipo = 'I' THEN
   sys_tot_pag_dip:= to_char(ceil((w_conta_moco_f + w_conta_des_f) / (dim_piede - w_sequenza_moco)));
   IF w_sequenza_note != 0 THEN
      BEGIN
        select nvl(min(stms.sequenza),0)
          into dim_piede
          from struttura_modelli_stampa stms
         where stms.codice = nvl(p_modello_stampa,'CEDOLINO')
           and stms.tipo_riga = 'P'
           and ( stms.flag_stampa = 'T'
           and not exists (select 'x'
                             from struttura_modelli_stampa s
                            where s.codice = nvl(p_modello_stampa,'CEDOLINO')
                              and s.tipo_riga = 'P'
                              and s.sequenza = stms.sequenza
                              and s.flag_stampa = 'N'
                           )
            or stms.flag_stampa = 'N')
        ;
      END;
      sys_tot_pag_dip := to_char(to_number(sys_tot_pag_dip) + ceil(nvl(v_riga_note,0) / (dim_piede - w_sequenza_note +1)));
   END IF;
 END IF;
 IF p_tipo = 'I' then
   IF nvl(p_fronte_retro,'NO') != 'NO' and nvl(v_riga_note,0) != 0 THEN
     sys_tot_pag_dip := to_char(ceil(to_number(sys_tot_pag_dip)/2));
   END IF;
   sys_tot_pagine_app := sys_tot_pag_dip;
 END IF;
 IF p_tipo in ('I','P') and (nvl(p_fronte_retro,'NO') = 'NO' or (nvl(p_fronte_retro,'NO ') != 'NO' and mod(sys_num_pag_eff,2) != 0)) THEN
   IF p_tipo = 'I' THEN
     sys_num_pag_dip := to_char(to_number(nvl(sys_num_pag_dip,sys_pagina_app)) + 1);
   END IF;
   sys_tot_pag_dip := nvl(sys_tot_pag_dip,sys_tot_pagine_app);
   sys_pagina := 'Pagina';
   sys_separatore_pag := '/';
   -- serie standard
   IF sys_num_pag_dip = sys_tot_pag_dip THEN
      sys_imb1 := sys_esnc13;
      sys_imb2 := sys_esnc13;
      sys_imb3 := ' ';
      -- Nuova serie segni imbustatrice
      IF continua = 1 THEN
        IF p_tipo = 'I' THEN
          sys_imb1m := sys_esnc13;
          sys_imb2m := sys_esnc13;
          sys_imb3m := sys_esnc13;
          sys_imb4m := ' ';
          sys_imb5m := ' ';
          sys_imb6m := sys_esnc13;
        ELSE
          sys_imb1m := sys_esnc13;
          sys_imb2m := ' ';
          sys_imb3m := ' ';
          sys_imb4m := sys_esnc13;
          sys_imb5m := sys_esnc13;
          sys_imb6m := sys_esnc13;
        END IF;
      ELSE
        sys_imb1m := sys_esnc13;
        sys_imb2m := sys_esnc13;
        sys_imb3m := ' ';
        sys_imb4m := ' ';
        sys_imb5m := sys_esnc13;
        sys_imb6m := sys_esnc13;
      END IF;
   ELSE
     continua := 1;
     sys_imb1 := sys_esnc13;
     sys_imb2 := ' ';
     sys_imb3 := sys_esnc13;
     -- Nuova serie segni imbustatrice
     IF sys_num_pag_dip = 1 THEN
       IF p_tipo = 'I' THEN
         sys_imb1m := sys_esnc13;
         sys_imb2m := sys_esnc13;
         sys_imb3m := ' ';
         sys_imb4m := sys_esnc13;
         sys_imb5m := ' ';
         sys_imb6m := sys_esnc13;
       ELSE
         sys_imb1m := sys_esnc13;
         sys_imb2m := ' ';
         sys_imb3m := sys_esnc13;
         sys_imb4m := ' ';
         sys_imb5m := sys_esnc13;
         sys_imb6m := sys_esnc13;
       END IF;
     ELSE
       sys_imb1m := sys_esnc13;
       sys_imb2m := sys_esnc13;
       sys_imb3m := sys_esnc13;
       sys_imb4m := sys_esnc13;
       sys_imb5m := sys_esnc13;
       sys_imb6m := sys_esnc13;
     END IF;
   END IF;
 ELSIF p_tipo = 'I' THEN
   sys_tot_pagine_app := sys_tot_pag_dip;
   sys_pagina_app := sys_num_pag_dip;
   sys_num_pag_app := sys_num_pag;
   sys_num_pag := '';
   sys_pagina := '';
   sys_num_pag_dip := '';
   sys_separatore_pag := '';
   sys_tot_pag_dip := '';
   sys_imb1 := ' ';
   sys_imb2 := ' ';
   sys_imb3 := ' ';
   sys_imb1m := ' ';
   sys_imb2m := ' ';
   sys_imb3m := ' ';
   sys_imb4m := ' ';
   sys_imb5m := ' ';
   sys_imb6m := ' ';
 END IF;
 IF p_tipo = 'P' THEN
    insert into a_appoggio_stampe
       ( NO_PRENOTAZIONE    ,
      NO_PASSO           ,
      PAGINA             ,
      RIGA               ,
      TESTO
         )
    select p_prenotazione
         , p_passo
         , -1
    , sys_num_pag_tot
    , decode(p_flag_stampa,'P','M','U','M','N')
      from dual
    ;
 END IF;
 FOR dati in sel_riga loop
   WHILE contatore < dati.sequenza LOOP
    insert into a_appoggio_stampe
       ( NO_PRENOTAZIONE    ,
      NO_PASSO           ,
      PAGINA             ,
      RIGA               ,
      TESTO
         ) values
     ( p_prenotazione
          , p_passo
     , P_ci
     , contarighe
     , lpad(p_ci,8,0)||null
    );
    contatore  := contatore +1;
    contarighe := contarighe+1;
   END LOOP;
--   if P_tipo != 'N' then -- altrimenti sto gia scrivendo le note...
   determina_riga (dati.riga, elenco_campi,p_ci , p_anno , p_mese, p_mensilita,p_gr_ling,' ',p_tipo_desformat );
   BEGIN
     si4.sql_execute(elenco_campi);
   EXCEPTION
     WHEN UNDEFINED_OBJECT THEN
  werrore := SQLERRM;
       contaerrori := contaerrori +1;
  insert into a_segnalazioni_errore
  ( NO_PRENOTAZIONE,
    PASSO,
    PROGRESSIVO,
    ERRORE,
    PRECISAZIONE
   )
      values ( p_prenotazione,
     p_passo,
     contaerrori,
    'A00037',
     SUBSTR('Componente '||substr(werrore,instr(upper(werrore),'COMPONENT')+10),1,50)
    );
 wriga := null;
   END;
      insert into a_appoggio_stampe
        ( NO_PRENOTAZIONE,
     NO_PASSO,
     PAGINA,
       RIGA,
     TESTO
   ) values
   ( p_prenotazione,
     p_passo,
          p_ci,
       contarighe,
       lpad(p_ci,8,0)||' '||pecsmor6.wriga
   );
   contatore  := contatore +1;
   contarighe := contarighe +1;
--   end if; -- fine controllo se ero nelle note
 END LOOP;
 IF p_tipo = 'P' and SEL_INEC %ISOPEN THEN
   close sel_inec;
   w_ultimo_cursore := ' ';
 END IF;
 IF p_tipo = 'P' and SEL_MOV_ORIZ %ISOPEN THEN
   close sel_mov_oriz;
   w_ultimo_cursore := ' ';
 END IF;
END;
PROCEDURE SCRIVI_RETRO is
dep_carattere number;
d_i           number;
d_descrizione varchar2(4000);--(80); note potrebbero essere lunghe
w_riga       varchar2(2000);
w_sequenza   number;
elenco_campi varchar2(2000);
riga         varchar2(4000);
contatore    number :=dim_testa;
conta        number :=0;
conta_1      number :=0;
v_contanote number:= 0;
BEGIN
 IF v_note_rimaste != 0 THEN
  BEGIN
   select nvl(min(sequenza),0)
     into w_sequenza
     from struttura_modelli_stampa
    where codice = nvl(p_modello_stampa,'CEDOLINO')
      and tipo_riga = 'N'
   ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      w_riga     := null;
      w_sequenza := 0;
  END;
  IF w_sequenza != 0 THEN
  SCRIVI('I',1,'N');
  WHILE contatore < w_sequenza -1 LOOP
    insert into a_appoggio_stampe
       ( NO_PRENOTAZIONE    ,
      NO_PASSO           ,
      PAGINA             ,
      RIGA               ,
      TESTO
         ) values
     ( p_prenotazione
          , p_passo
     , P_ci
     , contarighe
     , lpad(p_ci,8,0)||null
    );
    contatore  := contatore +1;
    contarighe := contarighe+1;
  END LOOP;
  contatore := 0;
  FOR CUR_NOTE IN (
     select apst.testo testo
          , apst.rowid
       from a_appoggio_stampe apst
      where apst.no_prenotazione = p_prenotazione
        and apst.no_passo = p_passo
        and apst.pagina = 0
        and rownum <= dim_piede - w_sequenza
      order by riga
     ) LOOP
        IF contatore = dim_piede - w_sequenza THEN  -- +1
           SCRIVI('P',dim_piede,'N');
           conta := dim_piede - w_sequenza -1;
           contatore := 1;
           conta_1:= 0;
        END IF;
        update a_appoggio_stampe
           set pagina = p_ci
             , riga = contarighe
         where rowid = cur_note.rowid
        ;
        conta_1 := conta_1 +1;
        contatore := contatore +1;
        contarighe := contarighe+1;
        v_note_rimaste := v_note_rimaste -1;
      END LOOP;
      WHILE conta_1 < dim_piede - w_sequenza LOOP
        insert into a_appoggio_stampe
              ( NO_PRENOTAZIONE    ,
            NO_PASSO           ,
            PAGINA             ,
            RIGA               ,
            TESTO
           ) values
              ( p_prenotazione
              , p_passo
          , P_ci
       , contarighe
          , lpad(p_ci,8,0)||null
          );
        conta_1    := conta_1 +1;
        contarighe := contarighe+1;
      END LOOP;
    END IF;
  ELSIF nvl(p_fronte_retro,'NO') != 'NO'  and mod(sys_num_pag_eff,2) != 0 THEN
     select nvl(max(sequenza),0)
     into w_sequenza
     from struttura_modelli_stampa
    where codice = nvl(p_modello_stampa,'CEDOLINO')
      and tipo_riga = 'P'
     ;
  contatore := 0;
  WHILE contatore < w_sequenza LOOP
    insert into a_appoggio_stampe
       ( NO_PRENOTAZIONE    ,
      NO_PASSO           ,
      PAGINA             ,
      RIGA               ,
      TESTO
         ) values
     ( p_prenotazione
          , p_passo
     , P_ci
     , contarighe
     , lpad(p_ci,8,0)||null
    );
    contatore  := contatore +1;
    contarighe := contarighe+1;
  END LOOP;
  sys_num_pag_eff := sys_num_pag_eff +1;
  sys_num_pag_tot := sys_num_pag_tot +1;
   insert into a_appoggio_stampe
       ( NO_PRENOTAZIONE    ,
      NO_PASSO           ,
      PAGINA             ,
      RIGA               ,
      TESTO
         )
    select p_prenotazione
         , p_passo
         , -1
    , sys_num_pag_tot
    , 'V'
      from dual
    ;
  END IF;
END;
PROCEDURE SCRIVI_CORPO (P_tipo in varchar) is
w_riga       varchar2(2000);
w_sequenza   number;
elenco_campi varchar2(2000);
contatore    number :=dim_testa;
conta        number :=0;
pagina       number :=0;
BEGIN
  BEGIN
   select min(riga),nvl(min(sequenza),0)
     into w_riga,w_sequenza
     from struttura_modelli_stampa
    where codice = nvl(p_modello_stampa,'CEDOLINO')
      and ((p_tipo = 'F' and
            flag_stampa = 'T')
          or(p_tipo = 'R'and
             flag_stampa = 'N')
          or(p_tipo = 'R'and
             flag_stampa = 'T'
             and not exists(select 'x'
                              from struttura_modelli_stampa
                             where codice = nvl(p_modello_stampa,'CEDOLINO')
                               and upper(ltrim(substr(riga,4,instr(riga,'.')-4))) = 'SEL_MOCO'
                               and flag_stampa = 'N')
           ))
      and upper(ltrim(substr(riga,4,instr(riga,'.')-4))) = 'SEL_MOCO'
     ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      w_riga     := null;
      w_sequenza := 0;
  END;
  IF p_tipo = 'F' THEN
  WHILE contatore < w_sequenza -1 LOOP
    insert into a_appoggio_stampe
       ( NO_PRENOTAZIONE    ,
      NO_PASSO           ,
      PAGINA             ,
      RIGA               ,
      TESTO
         ) values
     ( p_prenotazione
          , p_passo
     , P_ci
     , contarighe
     , lpad(p_ci,8,0)||null
    );
    contatore  := contatore +1;
    contarighe := contarighe+1;
  END LOOP;
  contatore := 0;
  determina_riga (w_riga, elenco_campi,p_ci , p_anno , p_mese , p_mensilita , p_gr_ling , p_tipo , p_tipo_desformat);
  WHILE SEL_MOCO %FOUND LOOP
--   IF contatore - (dim_piede - w_sequenza) = dim_piede - w_sequenza +1 THEN
     if contatore != 0 THEN
        determina_riga (w_riga, elenco_campi,p_ci , p_anno , p_mese , p_mensilita , p_gr_ling , p_tipo , p_tipo_desformat);
     end if;
     IF sel_moco%found THEN
        IF contatore = dim_piede - w_sequenza THEN
           SCRIVI('P',dim_piede,'P');
           IF nvl(p_fronte_retro,'NO') != 'NO' THEN
              SCRIVI_RETRO;
              IF v_riga_note != 0 THEN
                 SCRIVI('P',dim_piede,'N');
              END IF;
           END IF;
           SCRIVI('I',1,'U');
--             SCRIVI('C',dim_testa+1,'T');
           conta := dim_piede - w_sequenza -1;
           contatore  := 0;
           pagina := pagina +1;
        end if;
        BEGIN
          si4.sql_execute(elenco_campi);
        EXCEPTION
          WHEN UNDEFINED_OBJECT THEN
         werrore := SQLERRM;
            contaerrori := contaerrori +1;
            insert into a_segnalazioni_errore
            ( NO_PRENOTAZIONE,
           PASSO,
           PROGRESSIVO,
           ERRORE,
           PRECISAZIONE
         ) values
         ( p_prenotazione,
           p_passo,
                 contaerrori,
            'A00037',
           SUBSTR('Componente '||substr(werrore,instr(upper(werrore),'COMPONENT')+10),1,50)
         );
       wriga := null;
        END;
        insert into a_appoggio_stampe
           ( NO_PRENOTAZIONE,
          NO_PASSO,
          PAGINA,
          RIGA,
          TESTO
        ) values
        ( p_prenotazione,
          p_passo,
             p_ci,
          contarighe,
          lpad(p_ci,8,0)||' '||pecsmor6.wriga
       );
         contatore  := contatore +1;
         contarighe := contarighe +1;
      end if;
  END LOOP;
   select nvl(min(stms.sequenza),0)
     into dim_piede
     from struttura_modelli_stampa stms
    where stms.codice = nvl(p_modello_stampa,'CEDOLINO')
      and stms.tipo_riga = 'P'
      and ( stms.flag_stampa = 'T'
          and not exists (select 'x'
                            from struttura_modelli_stampa s
                           where s.codice = nvl(p_modello_stampa,'CEDOLINO')
                             and s.tipo_riga = 'P'
                             and s.sequenza = stms.sequenza
                             and s.flag_stampa = 'P'
                          )
          or stms.flag_stampa = 'P')
   ;
  WHILE contatore + w_sequenza < dim_piede LOOP
    insert into a_appoggio_stampe
       ( NO_PRENOTAZIONE    ,
      NO_PASSO           ,
      PAGINA             ,
      RIGA               ,
      TESTO
         ) values
     ( p_prenotazione
          , p_passo
     , P_ci
     , contarighe
     , lpad(p_ci,8,0)||null
    );
    contatore  := contatore+1;
    contarighe := contarighe+1;
  END LOOP;
  ELSE
    contatore := 0;
    determina_riga (w_riga, elenco_campi,p_ci , p_anno , p_mese , p_mensilita , p_gr_ling , p_tipo , p_tipo_desformat);
    WHILE SEL_MOCO %FOUND LOOP
     if contatore != 0 THEN
      determina_riga (w_riga, elenco_campi,p_ci , p_anno , p_mese , p_mensilita , p_gr_ling , p_tipo , p_tipo_desformat);
     end if;
      BEGIN
        si4.sql_execute(elenco_campi);
      EXCEPTION
        WHEN UNDEFINED_OBJECT THEN
     werrore := SQLERRM;
          contaerrori := contaerrori +1;
          insert into a_segnalazioni_errore
       ( NO_PRENOTAZIONE,
    PASSO,
    PROGRESSIVO,
    ERRORE,
    PRECISAZIONE
   ) values
   ( p_prenotazione,
     p_passo,
               contaerrori,
      'A00037',
     SUBSTR('Componente '||substr(werrore,instr(upper(werrore),'COMPONENT')+10),1,50)
   );
      wriga := null;
      END;
      insert into a_appoggio_stampe
        ( NO_PRENOTAZIONE    ,
          NO_PASSO           ,
     PAGINA             ,
          RIGA               ,
          TESTO
        ) values
        ( p_prenotazione
        , p_passo
        , 0
        , contarighe
        , lpad(p_ci,8,0)||' '||pecsmor6.wriga
        );
      contatore := contatore +1 ;
      contarighe := contarighe+1;
      v_riga_note := v_riga_note +1;
      v_note_rimaste := v_note_rimaste +1;
  END LOOP;
  END IF;
END;
PROCEDURE SCRIVI_NOTE is
dep_carattere number;
d_i           number;
d_descrizione varchar2(4000);
w_riga       varchar2(2000);
w_sequenza   number :=dim_testa;
elenco_campi varchar2(2000);
riga         varchar2(4000);
contatore    number;
conta        number :=0;
conta_1      number :=0;
v_car_linea number := 80;
v_contanote number:= 0;
w_appoggio_riga modelli_note.note%TYPE;
a varchar2(4000);
v_posizione number;
BEGIN
 FOR CUR_RIGHE IN(
   select sequenza,riga,ltrim(substr(riga,2,1)) tipo_oggetto
        , ltrim(substr(riga,4,instr(riga,'.')-4)) oggetto
     from struttura_modelli_stampa
    where codice = nvl(p_modello_stampa,'CEDOLINO')
      and (tipo_riga = 'N'
          or tipo_riga = 'C' and
             not exists(select 'x'
                          from struttura_modelli_stampa
                         where codice = nvl(p_modello_stampa,'CEDOLINO')
                           and upper(ltrim(substr(riga,4,instr(riga,'.')-4))) = 'SEL_MOCO'
                           and flag_stampa = 'N')
          and nvl(w_conta_moco_r,0) + nvl(w_conta_des_r,0) != 0
          )
    order by sequenza
  )LOOP
  contatore := 1;
  v_contanote := 1;
  IF w_sequenza + v_riga_note < CUR_RIGHE.sequenza  THEN
    WHILE CUR_RIGHE.sequenza - w_sequenza != 1 LOOP
      insert into a_appoggio_stampe
            ( NO_PRENOTAZIONE    ,
           NO_PASSO           ,
           PAGINA             ,
         RIGA               ,
          TESTO
           ) values
       ( p_prenotazione
            , p_passo
          , 0
       , contarighe
       , lpad(p_ci,8,0)||null
        );
      contarighe := contarighe +1;
      w_sequenza := w_sequenza +1;
      v_riga_note := v_riga_note +1;
      v_note_rimaste := v_note_rimaste +1;
    END LOOP;
  END IF;
 IF CUR_RIGHE.tipo_oggetto != 'C' THEN
   determina_riga (CUR_RIGHE.riga, elenco_campi,p_ci , p_anno , p_mese , p_mensilita , p_gr_ling , ' ' , p_tipo_desformat);
   BEGIN
     si4.sql_execute(elenco_campi);
   EXCEPTION
     WHEN UNDEFINED_OBJECT THEN
  werrore := SQLERRM;
       contaerrori := contaerrori +1;
       insert into a_segnalazioni_errore
       ( NO_PRENOTAZIONE,
    PASSO,
    PROGRESSIVO,
    ERRORE,
    PRECISAZIONE
   ) values
   ( p_prenotazione,
     p_passo,
               contaerrori,
      'A00037',
     SUBSTR('Componente '||substr(werrore,instr(upper(werrore),'COMPONENT')+10),1,50)
   );
  wriga := null;
    END;
      insert into a_appoggio_stampe
        ( NO_PRENOTAZIONE    ,
          NO_PASSO           ,
     PAGINA             ,
          RIGA               ,
          TESTO
        ) values
        ( p_prenotazione
        , p_passo
        , 0
        , contarighe
        , lpad(p_ci,8,0)||' '||pecsmor6.wriga
        );
      a := pecsmor6.wriga;
      contarighe := contarighe+1;
      v_riga_note := v_riga_note +1;
      v_note_rimaste := v_note_rimaste +1;
   ELSE
    IF upper(CUR_RIGHE.oggetto) = 'SEL_NOTE' THEN
      determina_riga (CUR_RIGHE.riga, elenco_campi,p_ci , p_anno , p_mese , p_mensilita , p_gr_ling , ' ' , p_tipo_desformat);
      WHILE sel_note_sequenza is not null LOOP
        if v_contanote != 1 THEN
          determina_riga (CUR_RIGHE.riga, elenco_campi,p_ci , p_anno , p_mese , p_mensilita , p_gr_ling , ' ' , p_tipo_desformat);
        end if;
        v_posizione := posizione;
        if v_contanote = 1 then
          v_car_linea := lunghezza;
          if  p_tipo_desformat = 'PDF' then
            v_car_linea := v_car_linea *1.2; -- riproporzione
          end if;
          v_car_linea := v_car_linea - posizione +1;
        end if;
        w_appoggio_riga := pecsmor6.wriga;
        v_contanote := v_contanote +1; --incremento dopo
        BEGIN
          si4.sql_execute(elenco_campi);
        EXCEPTION
          WHEN UNDEFINED_OBJECT THEN
       werrore := SQLERRM;
            contaerrori := contaerrori +1;
            insert into a_segnalazioni_errore
         ( NO_PRENOTAZIONE,
         PASSO,
        PROGRESSIVO,
        ERRORE,
      PRECISAZIONE
     ) values
    ( p_prenotazione,
      p_passo,
                contaerrori,
         'A00037',
      SUBSTR('Componente '||substr(werrore,instr(upper(werrore),'COMPONENT')+10),1,50)
     );
       wriga := null;
        END;
        BEGIN
          dep_carattere := 1;
          w_appoggio_riga:= ltrim(rtrim(pecsmor6.wriga));
          LOOP
           D_i :=nvl(instr(substr(w_appoggio_riga,dep_carattere,v_car_linea),chr(10)),0);
           IF D_i = 0  THEN
             IF dep_carattere + v_car_linea -1 < nvl(LENGTH(w_appoggio_riga),0) THEN
               FOR i IN REVERSE 1..v_car_linea -1 LOOP
                 IF substr(w_appoggio_riga,dep_carattere+i,1) = ' ' THEN
                   D_i := i+1;
                   EXIT;
                 END IF;
               END LOOP;
             ELSE -- se ci sono ancora caratteri da scrivere ma non occupano una riga
               D_i := nvl(length(w_appoggio_riga),0);
             END IF;
           ELSE
             IF D_i = 1 THEN
               D_i := 0;
             END IF;
           END IF;
           IF D_i > 0 THEN
             D_descrizione := rtrim(replace(substr(w_appoggio_riga,
                                          dep_carattere,D_i),
                                          chr(10),null));
             insert into a_appoggio_stampe
            ( NO_PRENOTAZIONE    ,
             NO_PASSO           ,
            PAGINA             ,
            RIGA               ,
            TESTO
            ) values
           ( p_prenotazione
                , p_passo
           , 0
           , contarighe
           , lpad(p_ci,8,0)||' '||rpad(' ',v_posizione +1)||D_descrizione
           );
             contarighe := contarighe+1;
             v_riga_note := v_riga_note +1;
             v_note_rimaste := v_note_rimaste +1;
             dep_carattere := dep_carattere + D_i;
           ELSE
            dep_carattere := dep_carattere + 1;
           END IF;
           IF dep_carattere >nvl(LENGTH(w_appoggio_riga),0) THEN--= nvl(LENGTH(w_appoggio_riga),0) THEN
             EXIT;
           END IF;
         END LOOP;
       END;
     END LOOP;
  ELSIF upper(CUR_RIGHE.oggetto) = 'SEL_MOCO' THEN
    IF nvl(w_conta_moco_r,0) + nvl(w_conta_des_r,0) != 0 THEN
      if SEL_MOCO %ISOPEN then
        null;
      else
        open sel_moco(p_ci ,p_anno ,p_mese ,p_mensilita ,w_gruppo_ling,'R');
      end if;
      SCRIVI_CORPO('R');
      IF SEL_MOCO %ISOPEN THEN
        close sel_moco;
        w_ultimo_cursore := ' ';
      END IF;
    END IF;
  ELSE
    determina_riga (CUR_RIGHE.riga, elenco_campi,p_ci , p_anno , p_mese , p_mensilita , p_gr_ling , '1' , p_tipo_desformat);
   BEGIN
     si4.sql_execute(elenco_campi);
   EXCEPTION
     WHEN UNDEFINED_OBJECT THEN
  werrore := SQLERRM;
       contaerrori := contaerrori +1;
       insert into a_segnalazioni_errore
       ( NO_PRENOTAZIONE,
    PASSO,
    PROGRESSIVO,
    ERRORE,
    PRECISAZIONE
   ) values
   ( p_prenotazione,
     p_passo,
               contaerrori,
      'A00037',
     SUBSTR('Componente '||substr(werrore,instr(upper(werrore),'COMPONENT')+10),1,50)
   );
  wriga := null;
    END;
   conta := 1;
    WHILE ltrim(pecsmor6.wriga) is not null LOOP
      IF conta != 1 THEN
         determina_riga (CUR_RIGHE.riga, elenco_campi,p_ci , p_anno , p_mese , p_mensilita , p_gr_ling , '1' , p_tipo_desformat);
         BEGIN
           si4.sql_execute(elenco_campi);
         EXCEPTION
           WHEN UNDEFINED_OBJECT THEN
          werrore := SQLERRM;
             contaerrori := contaerrori +1;
             insert into a_segnalazioni_errore
          ( NO_PRENOTAZIONE,
            PASSO,
        PROGRESSIVO,
         ERRORE,
        PRECISAZIONE
          ) values
          ( p_prenotazione,
       p_passo,
                 contaerrori,
          'A00037',
       SUBSTR('Componente '||substr(werrore,instr(upper(werrore),'COMPONENT')+10),1,50)
      )
             ;
           wriga := null;
         END;
      END IF;
      insert into a_appoggio_stampe
      ( NO_PRENOTAZIONE    ,
        NO_PASSO           ,
   PAGINA             ,
        RIGA               ,
        TESTO
      ) values
      ( p_prenotazione
      , p_passo
      , 0
      , contarighe
      , lpad(p_ci,8,0)||' '||pecsmor6.wriga
      )
      ;
      v_riga_note := v_riga_note +1;
      v_note_rimaste := v_note_rimaste +1;
      contarighe := contarighe+1;
      conta := conta + 1;
    END LOOP;
  END IF;
END IF;
w_sequenza := CUR_RIGHE.sequenza;
END LOOP;
END;
BEGIN
/* Azzeramento Variabili Globali */
   sys_data_elab := null;
   sys_prg_cedolino := 0;
   sys_num_pag_dip := 0;
   sys_pagina_app := 0;
   sys_num_pag_eff := 0;
   sys_tot_pag_dip := 0;
   --sys_num_pag := 0;
   sys_imb1 := null;
   sys_imb2 := null;
   sys_imb3 := null;
   sys_imb1m := null;
   sys_imb2m := null;
   sys_imb3m := null;
   sys_imb4m := null;
   sys_imb5m := null;
   sys_imb6m := null;
   w_conta_des_f := null;
   w_conta_moco_f := null;
   w_conta_des_r := null;
   w_conta_moco_r := null;
   w_conta_note := null;
   w_conta_note_1 := null;
   v_riga_note := 0;
   V_note_rimaste := 0;
   w_sequenza_moco := null;
   w_sequenza_note := null;
   p_ci_old  := 0;
   p_lingua := null;
   w_gruppo_ling := null;
   w_nr_ruo  := null;
   ente_descrizione  := null;
   ente_indirizzo := null;
   ente_comune := null;
   ente_codice_fiscale := null;
   ente_variabili_gepe := null;
   ente_prg_cedolino := null;
   ente_mesi_irpef := null;
   sys_esnc0  :=null;
   sys_esnc1  := null;
   sys_esnc2  := null;
   sys_esnc3  := null;
   sys_esnc4  := null;
   sys_esnc5  := null;
   sys_esnc13 := null;
   sys_esnc17 := null;
   sys_esnc26 := null;
   sys_esnc27 := null;
   sys_esnc28 := null;    
   sys_pagina := 'Pagina';
   sys_separatore_pag := '/';
   gest_codice := null;
   gest_descrizione := null;
   gest_codice_fiscale:= null;
   gest_indirizzo:= null;
   gest_comune := null;
   gest_posizione_inps := null;
   gest_posizione_inadel := null;
   gest_codice_inail := null;
   rare_descrizione_banca  := null;
   rare_descrizione_banca2 := null;
   rare_delega             := null;
   rare_matricola := null;
   rare_posizione_inail := null;
   rare_statistico1 := null;
   rare_statistico2 := null;
   rare_statistico3 := null;
   rare_codice_inps := null;
   rare_cod_nazione := null;
   rare_cin_eur := null;
   rare_cin_ita := null;
   rare_conto_corrente := null;
   rare_istituto := null;
   rare_sportello := null;
   anag_cognome_nome := null;
   anag_data_nas := null;
   anag_codice_fiscale := null;
   anag_indirizzo_dom := null;
   anag_comune_dom := null;
   anag_indirizzo_res := null;
   anag_comune_res := null;
   anag_presso := null;
   anag_partita_iva := null;
   pegi_dal := null;
   pegi_al := null;
   w_pegi_dal := null;
   w_pegi_al := null;
   rain_rapporto := null;
   rain_dal := null;
   rain_ci  := null;
   rain_ci_st := null;
   pere_gestione  := null;
   pere_posizione := null;
   pere_ruolo := null;
   pere_tipo_rapporto := null;
   pere_ore  := null;
   pere_ore_coco_td := null;
   pere_ore_coco := null;
   pere_ore_td := null;
   pere_settore := null;
   pere_sede := null;
   pere_figura  := null;
   pere_qualifica := null;
   pere_dal := null;
   pere_al := null;
   rifu_funzionale := null;
   rifu_cdc  := null;
   sedi_codice := null;
   sedi_descrizione := null;
   sett_codice  := null;
   sett_descrizione := null;
   sett_cod_descrizione := null;
   qugi_contratto := null;
   qugi_codice := null;
   qugi_livello := null;
   qugi_dal := null;
   qugi_al := null;
   qual_descrizione := null;
   figi_codice := null;
   figi_descrizione := null;
   prpr_descrizione := null;
   pofu_codice := null;
   pofu_descrizione := null;
   pofu_codice := null;
   pofu_descrizione := null;
   aina_posizione := null;
   mens_descrizione := null;
   mens_periodo_comp  := null;
   mens_periodo_comp1 := null;
   mens_data_val1 := null;
   mens_data_val := null;
   prfi_anni_anz := null;
   prfi_mesi_anz := null;
   prfi_giorni_anz := null;
   qual_qua_inps := null;
   pegi_qual_dal := null;
   pegi_qual_inps_dal := null;
   w_conta_qua := null;
   moco_arr_pre := null;
   moco_arr_att := null;
   moco_totale_comp := null;
   moco_totale_rit := null;
   moco_netto := null;
   sel_moco_sequenza := null;
   sel_moco_descrizione := null;
   sel_moco_data_rif := null;
   sel_moco_voce := null;
   sel_moco_sub := null;
   sel_moco_imp := null;
   sel_moco_tar := null;
   sel_moco_qta := null;
   sel_moco_imp_st := null;
   sel_moco_tar_st := null;
   sel_moco_qta_st := null;
   sel_moco_arr := null;
   sel_moco_input := null;
   sel_moco_tipo_rapporto := null;
   sel_moco_ore := null;
   sel_moco_specie := null;
   sel_moco_stampa_tar := null;
   sel_moco_stampa_qta := null;
   sel_moco_stampa_imp  := null;
   sel_moco_seq_ord  := null;
   sel_moco_arr_ord := null;
   sel_moco_riferimento := null;
   sel_note_sequenza := null;
   sel_note_note := null;
   sel_note_nota := null;
   sel_inec_anz_voce := null;
   sel_inec_qual_descrizione := null;
   sel_inec_anz_data := null;
   sel_inec_anz_numero := null;
   sel_mov_oriz_des_v1 := null;
   sel_mov_oriz_des_v2 := null;
   sel_mov_oriz_des_v3 := null;
   sel_mov_oriz_val_v1 := null;
   sel_mov_oriz_val_v2 := null;
   sel_mov_oriz_val_v3 := null;
   sel_mov_oriz_des_v4 := null;
   sel_mov_oriz_des_v5 := null;
   sel_mov_oriz_des_v6 := null;
   sel_mov_oriz_val_v4 := null;
   sel_mov_oriz_val_v5 := null;
   sel_mov_oriz_val_v6 := null;
   sel_moco_tipo := null;
   sel_imp_m_scaglione_ord := null;
   sel_imp_m_aliquota_ord := null;
   sel_imp_m_imposta_ord := null;
   sel_imp_m_scaglione_sep := null;
   sel_imp_m_aliquota_sep := null;
   sel_imp_m_imposta_sep := null;
   sel_imp_a_scaglione := null;
   sel_imp_a_aliquota := null;
   sel_imp_a_imposta := null;
   dim_piede  := null;
   dim_testa := null;
   contaerrori := 0;
   continua := 0;
   contarighe  := 1;
   wriga := null;
   v_ritorna := null;
   w_ultimo_cursore := null;
   w_riga_trattata := null;
   posizione := null;
   lunghezza := null;
   cafa_cond_fis := null;
   cafa_scaglione_coniuge := null;
   cafa_coniuge := null;
   cafa_scaglione_figli := null;
   cafa_figli := null;
   cafa_figli_dd := null;
   cafa_figli_mn := null;
   cafa_figli_mn_dd := null;
   cafa_figli_hh := null;
   cafa_figli_hh_dd := null;
   cafa_altri := null;
   cafa_cond_fam := null;
   cafa_nucleo_fam := null;
   cafa_figli_fam := null;
   cafa_assegno := null;
   D_ipn_fam    := null;
   D_tabella    := null;
   D_ass_figli  := null;
   D_ass_fam    := null;
   cofi_descrizione := null;
   cofa_descrizione := null;
   sel_mal_cod      := null;
   sel_mal_des      := null;
   sel_mal_dal      := null;
   sel_mal_al       := null;
   sel_mal_gg       := null;
   sel_mal_per      := null;
   sel_deli_sequenza      := null;
   sel_deli_descrizione   := null;
   sel_deli_riferimento      := null;
   sel_deli_voce          := null;
   sel_deli_imp           := null;
   sel_deli_tar           := null;
   sel_deli_qta           := null;
   sel_deli_anno_del      := null;
   sel_deli_numero_del    := null;
   sel_deli_sede_del      := null;
   sel_deli_causale       := null;
  IF SEL_INEC %ISOPEN THEN
    close sel_inec;
    w_ultimo_cursore := ' ';
  END IF;
  IF SEL_MOV_ORIZ %ISOPEN THEN
    close sel_mov_oriz;
    w_ultimo_cursore := ' ';
  END IF;
  IF SEL_MOCO %ISOPEN THEN
    close sel_moco;
    w_ultimo_cursore := ' ';
  END IF;
  IF SEL_NOTE %ISOPEN THEN
    close sel_note;
    w_ultimo_cursore := ' ';
  END IF;
  IF SEL_IMP_M %ISOPEN THEN
    close sel_imp_m;
    w_ultimo_cursore := ' ';
  END IF;
  IF SEL_IMP_A %ISOPEN THEN
    close sel_imp_a;
    w_ultimo_cursore := ' ';
  END IF;
  IF SEL_MAL %ISOPEN THEN
    close sel_mal;
    w_ultimo_cursore := ' ';
  END IF;
  IF SEL_DELI %ISOPEN THEN
    close sel_deli;
    w_ultimo_cursore := ' ';
  END IF;
/* Pulizia A_APPOGGIO_STAMPE */
 BEGIN
   delete a_appoggio_stampe
    where no_prenotazione = p_prenotazione
   ;
 END;
 BEGIN
   select nvl(max(progressivo),0)
     into contaerrori
     from a_segnalazioni_errore
    where no_prenotazione = p_prenotazione
      and passo = P_passo
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     contaerrori := 0;
 END;
 BEGIN
   select valore
     into p_fronte_retro
     from a_parametri
    where no_prenotazione = p_prenotazione
      and parametro = 'P_FRONTE_RETRO'
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     BEGIN
      select 'SI'
   into p_fronte_retro
   from a_stampanti
  where stampante = (select valore
                 from a_parametri
              where no_prenotazione = p_prenotazione
                             and parametro = 'P_STAMPANTE'
           )
         and instr(upper(ubicazione),'[F/R]') > 0
      ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       p_fronte_retro := null;
     END;
 END;
 BEGIN
   select valore
     into sys_prg_cedolino
     from a_parametri
    where no_prenotazione = p_prenotazione
      and parametro = 'P_NUM_STAMPA'
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     sys_prg_cedolino := null ;
 END;
 BEGIN
   select valore
     into p_lingua
     from a_parametri
    where no_prenotazione = p_prenotazione
      and parametro = 'P_LINGUA'
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     p_lingua := 'I';
 END;
 BEGIN
   select sequenza
     into w_gruppo_ling
     from gruppi_linguistici
    where gruppo = decode(p_lingua,'*','I',upper(p_lingua))
      and gruppo_al = p_gr_ling
    ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     w_gruppo_ling := 1;  /* default a Italiano */
 END;
 BEGIN
   select valore_default
     into d_prg_cedolino
     from a_selezioni
 where parametro = 'P_PRG_CEDOLINO'
   and voce_menu = 'PECSCER6'
   and sequenza = 0
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     d_prg_cedolino := to_number(null);
 END;
 BEGIN
   select count(*)
     into w_nr_ruo
     from ruoli
   ;
 END;
     w_ultimo_cursore := ' ';
 BEGIN
   select max(decode(esnc.sub,0,decode(w_gruppo_ling,1,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2))
                                                ,2,nvl(esnc.descrizione_al1,nvl(esnc.descrizione,esnc.descrizione_al2))
                                                ,3,nvl(esnc.descrizione_al2,nvl(esnc.descrizione,esnc.descrizione_al1))
                                                  ,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2)))
                           ,null))
        , max(decode(esnc.sub,1,decode(w_gruppo_ling,1,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2))
                                                ,2,nvl(esnc.descrizione_al1,nvl(esnc.descrizione,esnc.descrizione_al2))
                                                ,3,nvl(esnc.descrizione_al2,nvl(esnc.descrizione,esnc.descrizione_al1))
                                                  ,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2)))
                           ,null))
        , max(decode(esnc.sub,2,decode(w_gruppo_ling,1,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2))
                                                ,2,nvl(esnc.descrizione_al1,nvl(esnc.descrizione,esnc.descrizione_al2))
                                                ,3,nvl(esnc.descrizione_al2,nvl(esnc.descrizione,esnc.descrizione_al1))
                                                  ,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2)))
                           ,null))
        , max(decode(esnc.sub,3,decode(w_gruppo_ling,1,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2))
                                                ,2,nvl(esnc.descrizione_al1,nvl(esnc.descrizione,esnc.descrizione_al2))
                                                ,3,nvl(esnc.descrizione_al2,nvl(esnc.descrizione,esnc.descrizione_al1))
                                                  ,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2)))
                           ,null))
        , max(decode(esnc.sub,4,decode(w_gruppo_ling,1,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2))
                                                ,2,nvl(esnc.descrizione_al1,nvl(esnc.descrizione,esnc.descrizione_al2))
                                                ,3,nvl(esnc.descrizione_al2,nvl(esnc.descrizione,esnc.descrizione_al1))
                                                  ,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2)))
                           ,null))
        , max(decode(esnc.sub,5,decode(w_gruppo_ling,1,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2))
                                                ,2,nvl(esnc.descrizione_al1,nvl(esnc.descrizione,esnc.descrizione_al2))
                                                ,3,nvl(esnc.descrizione_al2,nvl(esnc.descrizione,esnc.descrizione_al1))
                                                  ,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2)))
                           ,null))
        , max(decode(esnc.sub,13,decode(w_gruppo_ling,1,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2))
                                                ,2,nvl(esnc.descrizione_al1,nvl(esnc.descrizione,esnc.descrizione_al2))
                                                ,3,nvl(esnc.descrizione_al2,nvl(esnc.descrizione,esnc.descrizione_al1))
                                                  ,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2)))
                           ,null))
        , max(decode(esnc.sub,17,substr(esnc.descrizione,instr(esnc.descrizione,'ABI:') + 4,5)||
                             substr(esnc.descrizione,instr(esnc.descrizione,'CAB:') + 4,5)||
                             substr(esnc.descrizione,instr(esnc.descrizione,'CC:') +3,12)
                            ,null))
        , max(decode(esnc.sub,26,decode(w_gruppo_ling,1,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2))
                                                ,2,nvl(esnc.descrizione_al1,nvl(esnc.descrizione,esnc.descrizione_al2))
                                                ,3,nvl(esnc.descrizione_al2,nvl(esnc.descrizione,esnc.descrizione_al1))
                                                  ,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2)))
                           ,null))
        , max(decode(esnc.sub,27,decode(w_gruppo_ling,1,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2))
                                                ,2,nvl(esnc.descrizione_al1,nvl(esnc.descrizione,esnc.descrizione_al2))
                                                ,3,nvl(esnc.descrizione_al2,nvl(esnc.descrizione,esnc.descrizione_al1))
                                                  ,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2)))
                           ,null))   
        , max(decode(esnc.sub,28,decode(w_gruppo_ling,1,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2))
                                                ,2,nvl(esnc.descrizione_al1,nvl(esnc.descrizione,esnc.descrizione_al2))
                                                ,3,nvl(esnc.descrizione_al2,nvl(esnc.descrizione,esnc.descrizione_al1))
                                                  ,nvl(esnc.descrizione,nvl(esnc.descrizione_al1,esnc.descrizione_al2)))
                           ,null))                                                                                
    into sys_esnc0,sys_esnc1,sys_esnc2,sys_esnc3
       , sys_esnc4,sys_esnc5,sys_esnc13,sys_esnc17
       , sys_esnc26,sys_esnc27,sys_esnc28
    from estrazione_note_cedolini esnc
   where sequenza = 0
     and sub in (0,1,2,3,4,5,6,13,17,26,27,28)
  ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     sys_esnc1 :=null;
     sys_esnc2 :=null;
     sys_esnc3 :=null;
     sys_esnc4 :=null;
     sys_esnc5 :=null;
     sys_esnc13 :=null;
     sys_esnc17 :=null;
     sys_esnc26 :=null;
     sys_esnc27 :=null; 
     sys_esnc28 :=null;     
 END;
   sys_imb1 := sys_esnc13;
   sys_imb2 := sys_esnc13;
   sys_imb3 := sys_esnc13;
   sys_imb1m := sys_esnc13;
   sys_imb2m := sys_esnc13;
   sys_imb3m := sys_esnc13;
   sys_imb4m := sys_esnc13;
   sys_imb5m := sys_esnc13;
   sys_imb6m := sys_esnc13;
   select to_char(sysdate,'dd/mm/yyyy HH24:MI')
     into sys_data_elab
     from dual
   ;
/* DATI ENTE */
 BEGIN
   select nome,decode(w_gruppo_ling,1,nvl(indirizzo_res,nvl(indirizzo_res_al1,indirizzo_res_al2))
                              ,2,nvl(indirizzo_res_al1,nvl(indirizzo_res,indirizzo_res_al2))
                              ,3,nvl(indirizzo_res_al2,nvl(indirizzo_res,indirizzo_res_al1))
                                ,nvl(indirizzo_res,nvl(indirizzo_res_al1,indirizzo_res_al2)))||' '||numero_civico
        , lpad(ente.cap,5,0)||'  '||
          decode(w_gruppo_ling,1,nvl(comu.descrizione,nvl(comu.descrizione_al1,comu.descrizione_al2))
                              ,2,nvl(comu.descrizione_al1,nvl(comu.descrizione,comu.descrizione_al2))
                              ,3,nvl(comu.descrizione_al2,nvl(comu.descrizione,comu.descrizione_al1))
                                ,nvl(comu.descrizione,nvl(comu.descrizione_al1,comu.descrizione_al2)))
          ||' ('||sigla_provincia||')'
        , 'C.F. '||codice_fiscale, variabili_gepe
        , prg_cedolino,mesi_irpef
     into ente_descrizione,ente_indirizzo,ente_comune
        , ente_codice_fiscale,ente_variabili_gepe
        , ente_prg_cedolino,ente_mesi_irpef
     from ente ente, comuni comu
    where ente.comune_res = comu.cod_comune
 and ente.provincia_res = comu.cod_provincia
 and ente.ente_id = 'ENTE';
 END;
 m_prec :=  last_day( add_months (ini_mese,variabili_gepe*-1));
 IF p_prenotazione_old != p_prenotazione THEN
    sys_num_pag := null;
    sys_num_dip := 1;
    sys_num_pag_tot := 0;
 ELSE
    sys_num_dip := sys_num_dip + 1;
 END IF;
 if p_passo = 4 then 
   sys_prg_cedolino := nvl(d_prg_cedolino,nvl(sys_prg_cedolino,nvl(ente_prg_cedolino,0))) + sys_num_dip;
 else
   sys_prg_cedolino := to_char(nvl(to_number(sys_prg_cedolino),nvl(ente_prg_cedolino,0)) + sys_num_dip);
   update a_selezioni
      set valore_default = sys_prg_cedolino
 where voce_menu = 'PECSCER6'
   and sequenza  = 0
   and parametro = 'P_PRG_CEDOLINO'
   ;
   commit;      
 end if;
 IF p_ci_old != p_ci THEN
    sys_num_pag_dip := 0;
    sys_pagina_app := 0;
    sys_num_pag_eff := 0;
 END IF;
 BEGIN
   select max(stms.sequenza)
     into dim_testa
     from struttura_modelli_stampa stms
    where stms.codice = nvl(p_modello_stampa,'CEDOLINO')
      and stms.tipo_riga = 'I'
      and ( stms.flag_stampa = 'T'
          and not exists (select 'x'
                            from struttura_modelli_stampa s
                           where s.codice = nvl(p_modello_stampa,'CEDOLINO')
                             and s.tipo_riga = 'I'
                             and s.sequenza = stms.sequenza
                             and s.flag_stampa = 'N'
                          )
          or stms.flag_stampa = 'N')
     ;
 END;
 BEGIN
   select nvl(min(sequenza),0)
     into w_sequenza_moco
     from struttura_modelli_stampa
    where codice = nvl(p_modello_stampa,'CEDOLINO')
      and tipo_riga = 'C'
   ;
   select nvl(min(sequenza),0)
     into w_sequenza_note
     from struttura_modelli_stampa
    where codice = nvl(p_modello_stampa,'CEDOLINO')
      and tipo_riga = 'N'
   ;
 END;
 BEGIN
   select count(moco.p)
     into w_conta_moco_f
     from( select 1 p
     from movimenti_contabili moco
        , voci_economiche voec
        , contabilita_voce covo
        , qualifiche_giuridiche qugi
    where moco.ci = p_ci
      and moco.anno = p_anno
      and moco.mese = p_mese
      and moco.mensilita = p_mensilita
      and moco.voce = voec.codice
      and moco.voce = covo.voce
      and moco.sub = covo.sub
      and nvl(moco.riferimento,last_day(to_date('01/'||lpad(TO_CHAR(P_MESE),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy')))
          between nvl(covo.dal,to_date('2222222','j'))
              and nvl(covo.al ,to_date('3333333','j'))
      and covo.stampa_fr = 'F'
      and 'NNN' != translate(translate(covo.stampa_tar||
                                       covo.stampa_qta||
                                       covo.stampa_imp
                                       , 'C', 'N')
                                       , 'B', 'N')
      and moco.qualifica = qugi.numero (+)
      and nvl(moco.riferimento,last_day(to_date('01/'||lpad(TO_CHAR(P_MESE),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy')))
          between nvl(qugi.dal,to_date('2222222','j'))
              and nvl(qugi.al ,to_date('3333333','j'))
      and moco.voce not in (select codice
                              from voci_economiche
                             where automatismo in ('ARR_PRE','ARR_ATT',
                                                   'ARR_ATT_S','ARR_ATT_N',
                                                   'ARR_ATT_SN',
                                                   'COMP','TRAT','NETTO')
                           )
      and not exists
          (select 'x'
             from estrazione_righe_contabili
             where estrazione = 'CEDOLINO_VOCI_ORIZZ'
               and voce = moco.voce
               and sub = moco.sub
               and moco.arr is null)
   group by moco.ci,voec.sequenza,moco.arr,moco.sub,covo.dal,
         decode( upper(moco.input)
               , 'R', to_char(moco.tar)
                    , to_char(qugi.dal,'dd/mm/yyyy')||moco.ore||
                      moco.tipo_rapporto),
         decode( upper(moco.input)
               , 'R', to_date(null)
                    , decode( voec.classe
                            , 'A', to_date(null)
                            , 'R', to_date
                                   (to_char(nvl(moco.competenza,moco.riferimento)
                                           ,'yyyy')
                                   ,'yyyy')
                                 , moco.riferimento)),
         decode( voec.classe
               , 'R', moco.qta
                    , to_number(null))
  having nvl(sum(moco.tar),0) != 0 or
         nvl(sum(decode(voec.classe,'R',0,moco.qta)),0) != 0 or
         nvl(sum(moco.imp),0) != 0) moco
   ;
   select count(*)
     into w_conta_des_f
     from estrazione_note_cedolini
    where sequenza != 0
      and sub < 90
   ;
 END;
 BEGIN
   select count(moco.p)
     into w_conta_moco_r
     from( select 1 p
     from movimenti_contabili moco
        , voci_economiche voec
        , contabilita_voce covo
        , qualifiche_giuridiche qugi
    where moco.ci = p_ci
      and moco.anno = p_anno
      and moco.mese = p_mese
      and moco.mensilita = p_mensilita
      and moco.voce = voec.codice
      and moco.voce = covo.voce
      and moco.sub = covo.sub
      and nvl(moco.riferimento,last_day(to_date('01/'||lpad(TO_CHAR(P_MESE),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy')))
          between nvl(covo.dal,to_date('2222222','j'))
              and nvl(covo.al ,to_date('3333333','j'))
      and covo.stampa_fr = 'R'
      and w_sequenza_note != 0
      and 'NNN' != translate(translate(covo.stampa_tar||
                                       covo.stampa_qta||
                                       covo.stampa_imp
                                       , 'C', 'N')
                                       , 'B', 'N')
      and moco.qualifica = qugi.numero (+)
      and nvl(moco.riferimento,last_day(to_date('01/'||lpad(TO_CHAR(P_MESE),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy')))
          between nvl(qugi.dal,to_date('2222222','j'))
              and nvl(qugi.al ,to_date('3333333','j'))
      and moco.voce not in (select codice
                              from voci_economiche
                             where automatismo in ('ARR_PRE','ARR_ATT',
                                                   'ARR_ATT_S','ARR_ATT_N',
                                                   'ARR_ATT_SN',
                                                   'COMP','TRAT','NETTO')
                           )
      and not exists
          (select 'x'
             from estrazione_righe_contabili
             where estrazione = 'CEDOLINO_VOCI_ORIZZ'
               and voce = moco.voce
               and sub = moco.sub
               and moco.arr is null)
   group by moco.ci,voec.sequenza,moco.arr,moco.sub,covo.dal,
         decode( upper(moco.input)
               , 'R', to_char(moco.tar)
                    , to_char(qugi.dal,'dd/mm/yyyy')||moco.ore||
                      moco.tipo_rapporto),
         decode( upper(moco.input)
               , 'R', to_date(null)
                    , decode( voec.classe
                            , 'A', to_date(null)
                            , 'R', to_date
                                   (to_char(nvl(moco.competenza,moco.riferimento)
                                           ,'yyyy')
                                   ,'yyyy')
                                 , moco.riferimento)),
         decode( voec.classe
               , 'R', moco.qta
                    , to_number(null))
  having nvl(sum(moco.tar),0) != 0 or
         nvl(sum(decode(voec.classe,'R',0,moco.qta)),0) != 0 or
         nvl(sum(moco.imp),0) != 0) moco
   ;
   select count(*)
     into w_conta_des_r
     from estrazione_note_cedolini
    where sequenza != 0
      and w_sequenza_note != 0
      and sub >= 90
   ;
 END;
 BEGIN
   select count(*)
     into w_conta_note
     from note_individuali noin
    where noin.ci = p_ci
      and noin.anno = p_anno
      and noin.mese = p_mese
      and noin.mensilita = p_mensilita
      and decode(w_gruppo_ling,1,nvl(noin.note,nvl(noin.note_al1,noin.note_al2))
                                ,2,nvl(noin.note_al1,nvl(noin.note,noin.note_al2))
                                ,3,nvl(noin.note_al2,nvl(noin.note,noin.note_al1))
                                  ,nvl(noin.note,nvl(noin.note_al1,noin.note_al2))) is not null
      and w_sequenza_note != 0
   ;
   select count(*)
     into w_conta_note_1
     from note_individuali noin
        , modelli_note     mono
    where noin.ci = p_ci
      and noin.anno = p_anno
      and noin.mese = p_mese
      and noin.mensilita = p_mensilita
      and decode(w_gruppo_ling,1,nvl(noin.note,nvl(noin.note_al1,noin.note_al2))
                              ,2,nvl(noin.note_al1,nvl(noin.note,noin.note_al2))
                              ,3,nvl(noin.note_al2,nvl(noin.note,noin.note_al1))
                                ,nvl(noin.note,nvl(noin.note_al1,noin.note_al2))) is null
      and noin.nota = mono.nota
      and last_day(to_date('01/'||lpad(TO_CHAR(p_mese),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy')) between  mono.dal
               and nvl(mono.al,to_date('3333333','j'))
      and w_sequenza_note != 0
  ;
 END;
 /* Dati Anagrafici */
 BEGIN
   select anag.cognome||'  '||anag.nome,to_char(anag.data_nas,'DD/MM/YY')
        , anag.codice_fiscale
        , decode(w_gruppo_ling,1,nvl(anag.indirizzo_dom,nvl(anag.indirizzo_dom_al1,anag.indirizzo_dom_al2))
                              ,2,nvl(anag.indirizzo_dom_al1,nvl(anag.indirizzo_dom,anag.indirizzo_dom_al2))
                              ,3,nvl(anag.indirizzo_dom_al2,nvl(anag.indirizzo_dom,anag.indirizzo_dom_al1))
                                ,nvl(anag.indirizzo_dom,nvl(anag.indirizzo_dom_al1,anag.indirizzo_dom_al2)))
        , anag.cap_dom||'  '||decode(w_gruppo_ling,1,nvl(comu.descrizione,nvl(comu.descrizione_al1,comu.descrizione_al2))
                                                 ,2,nvl(comu.descrizione_al1,nvl(comu.descrizione,comu.descrizione_al2))
                                                 ,3,nvl(comu.descrizione_al2,nvl(comu.descrizione,comu.descrizione_al1))
                                                   ,nvl(comu.descrizione,nvl(comu.descrizione_al1,comu.descrizione_al2)))
          ||' ('||comu.sigla_provincia||')'
        , decode(w_gruppo_ling,1,nvl(anag.indirizzo_res,nvl(anag.indirizzo_res_al1,anag.indirizzo_res_al2))
                              ,2,nvl(anag.indirizzo_res_al1,nvl(anag.indirizzo_res,anag.indirizzo_res_al2))
                              ,3,nvl(anag.indirizzo_res_al2,nvl(anag.indirizzo_res,anag.indirizzo_res_al1))
                                ,nvl(anag.indirizzo_res,nvl(anag.indirizzo_res_al1,anag.indirizzo_res_al2)))
        , anag.cap_res||'  '||decode(w_gruppo_ling,1,nvl(comi.descrizione,nvl(comi.descrizione_al1,comi.descrizione_al2))
                                                 ,2,nvl(comi.descrizione_al1,nvl(comi.descrizione,comi.descrizione_al2))
                                                 ,3,nvl(comi.descrizione_al2,nvl(comi.descrizione,comi.descrizione_al1))
                                                   ,nvl(comi.descrizione,nvl(comi.descrizione_al1,comi.descrizione_al2)))
          ||' ('||comi.sigla_provincia||')'
        , anag.presso
        , rain.rapporto, to_char(rain.dal,'DD/MM/YY')
        , to_char(rain.ci),'(#'||lpad(rain.ci,8,0)||')'
        , anag.partita_iva
     into anag_cognome_nome,anag_data_nas
        , anag_codice_fiscale, anag_indirizzo_dom, anag_comune_dom
        , anag_indirizzo_res, anag_comune_res
        , anag_presso
        , rain_rapporto,rain_dal
        , rain_ci,rain_ci_st
        , anag_partita_iva
     from anagrafici anag, rapporti_individuali rain
        , comuni comu, comuni comi
    where rain.ci = p_ci
      and anag.ni = rain.ni
      and anag.al is null
      and anag.comune_dom = comu.cod_comune
      and anag.provincia_dom = comu.cod_provincia
      and anag.comune_res = comi.cod_comune
      and anag.provincia_res = comi.cod_provincia
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     anag_cognome_nome := null;
     anag_data_nas := null;
     anag_codice_fiscale := null;
     anag_indirizzo_dom := null;
     anag_comune_dom := null;
     anag_indirizzo_res := null;
     anag_comune_res := null;
     anag_presso := null;
     rain_rapporto := null;
     rain_dal := null;
     rain_ci := null;
     rain_ci_st := null;
     contaerrori := contaerrori +1;
     insert into a_segnalazioni_errore
               ( NO_PRENOTAZIONE,
       PASSO,
              PROGRESSIVO,
              ERRORE,
         PRECISAZIONE
       ) values
       ( p_prenotazione,
           p_passo,
       contaerrori,
       'A00037',
         substr('Dati Anagrafici Non Validi per il Ci '||to_char(p_ci),1,50)
       );
 END;
 /* Dati PEGI */
 BEGIN
   select to_char(pegi.dal,'dd/mm/yy'),nvl(to_char(pegi.al,'dd/mm/yy'),' '),pegi.dal,pegi.al
     into pegi_dal,pegi_al,w_pegi_dal,w_pegi_al
     from periodi_giuridici pegi
    where pegi.ci = p_ci
      and pegi.rilevanza = 'P'
      and pegi.dal = (select max(dal)
                        from periodi_giuridici
                       where ci = p_ci
                         and rilevanza = 'P'
                     )
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     pegi_dal   :=null;
     pegi_al    :=null;
     w_pegi_dal :=null;
     w_pegi_al  :=null;
 END;
 /* Dati PERE */
 BEGIN
   select pere.gestione,pere.ruolo,pere.tipo_rapporto,translate(to_char(pere.ore,'990.00'),'.',',')
        , translate(to_char(decode(pere.tipo_rapporto,'COCO',null,'TD',null,pere.ore),'90.00'),'.',',')
        , translate(to_char(decode(pere.tipo_rapporto,'COCO',null,pere.ore),'990.00'),'.',',')
        , translate(to_char(decode(pere.tipo_rapporto,'TD',null,pere.ore),'90.00'),'.',',')
        , to_char(pere.settore),pere.sede,pere.figura,pere.qualifica
        , pere.posizione,pere.dal,pere.al
     into pere_gestione,pere_ruolo,pere_tipo_rapporto,pere_ore
        , pere_ore_coco_td, pere_ore_coco, pere_ore_td
        , pere_settore,pere_sede,pere_figura,pere_qualifica
        , pere_posizione,pere_dal,pere_al
     from periodi_retributivi pere
    where pere.ci = p_ci
      and competenza = 'A'
      and periodo    = fin_mese
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     pere_gestione:= null;
     pere_ruolo:= null;
     pere_tipo_rapporto:= null;
     pere_ore:= null;
     pere_ore_coco_td:= null;
     pere_ore_coco:= null;
     pere_ore_td:= null;
     pere_settore:= null;
     pere_sede:= null;
     pere_figura:= null;
     pere_qualifica:= null;
     pere_posizione:= null;
     contaerrori := contaerrori +1;
     insert into a_segnalazioni_errore
               ( NO_PRENOTAZIONE,
       PASSO,
              PROGRESSIVO,
              ERRORE,
         PRECISAZIONE
       ) values
       ( p_prenotazione,
           p_passo,
       contaerrori,
       'A00037',
         substr('Periodo Retributivo Non Valido per il Ci '||to_char(p_ci),1,50)
       );
 END;
 BEGIN
  select rifu.funzionale,rifu.cdc
    into rifu_funzionale,rifu_cdc
    from ripartizioni_funzionali rifu
   where rifu.sede    = nvl(pere_sede,0)
     and rifu.settore = pere_settore
  ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     rifu_funzionale := null;
     rifu_cdc := null;
 END;
 /* Dati GESTIONI */
IF pere_gestione is not null THEN
 BEGIN
   select gest.codice
        , decode(w_gruppo_ling,1,nvl(gest.nome,nvl(gest.nome_al1,gest.nome_al2))
                              ,2,nvl(gest.nome_al1,nvl(gest.nome,gest.nome_al2))
                              ,3,nvl(gest.nome_al2,nvl(gest.nome,gest.nome_al1))
                                ,nvl(gest.nome,nvl(gest.nome_al1,gest.nome_al2)))
        , gest.posizione_inps, gest.posizione_inadel, gest.codice_inail
        , decode(w_gruppo_ling,1,nvl(gest.indirizzo_res,nvl(gest.indirizzo_res_al1,gest.indirizzo_res_al2))
                              ,2,nvl(gest.indirizzo_res_al1,nvl(gest.indirizzo_res,gest.indirizzo_res_al2))
                              ,3,nvl(gest.indirizzo_res_al2,nvl(gest.indirizzo_res,gest.indirizzo_res_al1))
                                ,nvl(gest.indirizzo_res,nvl(gest.indirizzo_res_al1,gest.indirizzo_res_al2)))
          ||' '||numero_civico
        , lpad(gest.cap,5,0)||'  '||
          decode(w_gruppo_ling,1,nvl(comi.descrizione,nvl(comi.descrizione_al1,comi.descrizione_al2))
                              ,2,nvl(comi.descrizione_al1,nvl(comi.descrizione,comi.descrizione_al2))
                              ,3,nvl(comi.descrizione_al2,nvl(comi.descrizione,comi.descrizione_al1))
                                ,nvl(comi.descrizione,nvl(comi.descrizione_al1,comi.descrizione_al2)))
          ||' ('||comi.sigla_provincia||')','C.F. '||gest.codice_fiscale
     into gest_codice
        , gest_descrizione
        , gest_posizione_inps, gest_posizione_inadel, gest_codice_inail
        , gest_indirizzo
        , gest_comune
        , gest_codice_fiscale
     from gestioni gest
        , comuni comi
    where gest.codice = pere_gestione
      and gest.comune_res = comi.cod_comune
      and gest.provincia_res = comi.cod_provincia
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     gest_codice:= null;
     gest_descrizione:= null;
     gest_posizione_inps:= null;
     gest_posizione_inadel:= null;
     gest_codice_inail:= null;
     gest_indirizzo:= null;
     gest_comune:= null;
     gest_codice_fiscale :=null;
     contaerrori := contaerrori +1;
     insert into a_segnalazioni_errore
               ( NO_PRENOTAZIONE,
       PASSO,
              PROGRESSIVO,
              ERRORE,
         PRECISAZIONE
       ) values
       ( p_prenotazione,
           p_passo,
       contaerrori,
       'A00037',
         substr('Gestione Non Valida per il Ci '||to_char(p_ci),1,50)
       );
 END;
END IF;
 /* Dati SEDI */
IF pere_sede is not null THEN
 BEGIN
   select sedi.codice,
          decode(w_gruppo_ling,1,nvl(sedi.descrizione,nvl(sedi.descrizione_al1,sedi.descrizione_al2))
                              ,2,nvl(sedi.descrizione_al1,nvl(sedi.descrizione,sedi.descrizione_al2))
                              ,3,nvl(sedi.descrizione_al2,nvl(sedi.descrizione,sedi.descrizione_al1))
                                ,nvl(sedi.descrizione,nvl(sedi.descrizione_al1,sedi.descrizione_al2)))
     into sedi_codice
        , sedi_descrizione
     from sedi sedi
    where sedi.numero = pere_sede
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     sedi_codice      := null;
     sedi_descrizione := null;
 END;
END IF;
 /* Dati SETTORI */
IF pere_settore is not null THEN
 BEGIN
   select sett.codice,
          decode(w_gruppo_ling,1,nvl(sett.descrizione,nvl(sett.descrizione_al1,sett.descrizione_al2))
                              ,2,nvl(sett.descrizione_al1,nvl(sett.descrizione,sett.descrizione_al2))
                              ,3,nvl(sett.descrizione_al2,nvl(sett.descrizione,sett.descrizione_al1))
                                ,nvl(sett.descrizione,nvl(sett.descrizione_al1,sett.descrizione_al2))),
          sett.codice||' - '||
          decode(w_gruppo_ling,1,nvl(sett.descrizione,nvl(sett.descrizione_al1,sett.descrizione_al2))
                              ,2,nvl(sett.descrizione_al1,nvl(sett.descrizione,sett.descrizione_al2))
                              ,3,nvl(sett.descrizione_al2,nvl(sett.descrizione,sett.descrizione_al1))
                                ,nvl(sett.descrizione,nvl(sett.descrizione_al1,sett.descrizione_al2)))
     into sett_codice
        , sett_descrizione
        , sett_cod_descrizione
     from settori sett
    where sett.numero = to_number(pere_settore)
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     sett_codice      := null;
     sett_descrizione := null;
     sett_cod_descrizione :=null;
     contaerrori := contaerrori +1;
     insert into a_segnalazioni_errore
               ( NO_PRENOTAZIONE,
       PASSO,
              PROGRESSIVO,
              ERRORE,
         PRECISAZIONE
       ) values
       ( p_prenotazione,
           p_passo,
       contaerrori,
       'A00037',
         substr('Settore Non Valido per il Ci '||to_char(p_ci),1,50)
       );
 END;
END IF;
 /* Dati QUALIFICHE */
IF pere_qualifica is not null THEN
 BEGIN
   select qugi.contratto,qugi.codice,qugi.livello,qugi.dal,qugi.al
        , nvl(decode(w_gruppo_ling,1,nvl(qual.descrizione,nvl(qual.descrizione_al1,qual.descrizione_al2))
                              ,2,nvl(qual.descrizione_al1,nvl(qual.descrizione,qual.descrizione_al2))
                              ,3,nvl(qual.descrizione_al2,nvl(qual.descrizione,qual.descrizione_al1))
                                ,nvl(qual.descrizione,nvl(qual.descrizione_al1,qual.descrizione_al2)))
                                ,qugi.contratto||' '||qugi.codice)
        , qual.qua_inps
     into qugi_contratto,qugi_codice,qugi_livello,qugi_dal,qugi_al
        , qual_descrizione, qual_qua_inps
     from qualifiche qual
        , qualifiche_giuridiche qugi
    where qual.numero = qugi.numero
      and qual.numero = pere_qualifica
      and least(nvl(pere_al,to_date('3333333','j')),fin_mese)
          between nvl(qugi.dal,to_date('2222222','j'))
              and nvl(qugi.al,to_date('3333333','j'))
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     qugi_contratto:= null;
     qugi_codice:= null;
     qugi_livello:= null;
     qugi_dal:= null;
     qugi_al:= null;
     qual_descrizione:= null;
     contaerrori := contaerrori +1;
     insert into a_segnalazioni_errore
               ( NO_PRENOTAZIONE,
       PASSO,
              PROGRESSIVO,
              ERRORE,
         PRECISAZIONE
       ) values
       ( p_prenotazione,
           p_passo,
       contaerrori,
       'A00037',
         substr('Qualifica Non Valida per il Ci '||to_char(p_ci),1,50)
       );
 END;
END IF;
IF pere_ore is null and qugi_contratto is not null THEN
 /* Dati CONTRATTI STORICI */
 BEGIN
   select translate(to_char(cost.ore_lavoro,'90.00'),'.',',')
        , translate(to_char(decode(pere_tipo_rapporto,'COCO',null,'TD',null,cost.ore_lavoro),'90.00'),'.',',')
        , translate(to_char(decode(pere_tipo_rapporto,'COCO',null,cost.ore_lavoro),'90.00'),'.',',')
        , translate(to_char(decode(pere_tipo_rapporto,'TD',null,cost.ore_lavoro),'90.00'),'.',',')
     into pere_ore
        , pere_ore_coco_td, pere_ore_coco, pere_ore_td
     from contratti_storici cost
    where cost.contratto = qugi_contratto
      and least(nvl(qugi_al,to_date('3333333','j')),fin_mese)
          between nvl(cost.dal,to_date('2222222','j'))
              and nvl(cost.al,to_date('3333333','j'))
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     pere_ore:= null;
     pere_ore_coco_td:= null;
     pere_ore_coco:= null;
     pere_ore_td:= null;
     contaerrori := contaerrori +1;
     insert into a_segnalazioni_errore
               ( NO_PRENOTAZIONE,
       PASSO,
              PROGRESSIVO,
              ERRORE,
         PRECISAZIONE
       ) values
       ( p_prenotazione,
           p_passo,
       contaerrori,
       'A00037',
         substr('Contratto Non Valido per il Ci '||to_char(p_ci),1,50)
       );
 END;
END IF;
 /* Dati FIGURE_GIURIDICHE */
IF pere_figura is not null THEN
 BEGIN
   select figi.codice
        , decode(w_gruppo_ling,1,nvl(figi.descrizione,nvl(figi.descrizione_al1,figi.descrizione_al2))
                              ,2,nvl(figi.descrizione_al1,nvl(figi.descrizione,figi.descrizione_al2))
                              ,3,nvl(figi.descrizione_al2,nvl(figi.descrizione,figi.descrizione_al1))
                                ,nvl(figi.descrizione,nvl(figi.descrizione_al1,figi.descrizione_al2)))
        , figi.profilo
        , figi.posizione
     into figi_codice
        , figi_descrizione
        , figi_profilo
        , figi_posizione
     from figure_giuridiche figi
    where figi.numero = pere_figura
      and least(nvl(pere_al,to_date('3333333','j')),fin_mese)
          between nvl(figi.dal,to_date('2222222','j'))
              and nvl(figi.al,to_date('3333333','j'))
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     figi_codice      := null;
     figi_descrizione := null;
     figi_profilo  := null;
     figi_posizione := null;
     contaerrori := contaerrori +1;
     insert into a_segnalazioni_errore
               ( NO_PRENOTAZIONE,
       PASSO,
              PROGRESSIVO,
              ERRORE,
         PRECISAZIONE
       ) values
       ( p_prenotazione,
           p_passo,
       contaerrori,
       'A00037',
         substr('Figura Giuridica Non Valida per il Ci '||to_char(p_ci),1,50)
       );
 END;
END IF;
 /* Dati PROFILI_PROFESSIONALI */
IF figi_profilo is not null THEN
 BEGIN
   select decode(w_gruppo_ling,1,nvl(prpr.descrizione,nvl(prpr.descrizione_al1,prpr.descrizione_al2))
                              ,2,nvl(prpr.descrizione_al1,nvl(prpr.descrizione,prpr.descrizione_al2))
                              ,3,nvl(prpr.descrizione_al2,nvl(prpr.descrizione,prpr.descrizione_al1))
                                ,nvl(prpr.descrizione,nvl(prpr.descrizione_al1,prpr.descrizione_al2)))
     into prpr_descrizione
     from profili_professionali prpr
    where codice = figi_profilo
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     prpr_descrizione := null;
 END;
END IF;
 /* Dati POSIZIONI_FUNZIONALI */
IF figi_profilo is not null THEN
 BEGIN
   select pofu.codice
        , decode(w_gruppo_ling,1,nvl(pofu.descrizione,nvl(pofu.descrizione_al1,pofu.descrizione_al2))
                              ,2,nvl(pofu.descrizione_al1,nvl(pofu.descrizione,pofu.descrizione_al2))
                              ,3,nvl(pofu.descrizione_al2,nvl(pofu.descrizione,pofu.descrizione_al1))
                                ,nvl(pofu.descrizione,nvl(pofu.descrizione_al1,pofu.descrizione_al2)))
     into  pofu_codice
         , pofu_descrizione
     from posizioni_funzionali pofu
    where profilo = figi_profilo
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     pofu_codice := null;
     pofu_descrizione := null;
   WHEN TOO_MANY_ROWS THEN
     pofu_codice := null;
     pofu_descrizione := null;
 END;
END IF;
   /* Dati RARE */
 BEGIN
   select decode(rare.istituto||rare.sportello||rare.conto_corrente,sys_esnc17,
                 decode(rare.delega,null,null
                                        ,'del. '||rare.delega),
                 decode(w_gruppo_ling,1,nvl(iscr.descrizione,nvl(iscr.descrizione_al1,iscr.descrizione_al2))
                                     ,2,nvl(iscr.descrizione_al1,nvl(iscr.descrizione,iscr.descrizione_al2))
                                     ,3,nvl(iscr.descrizione_al2,nvl(iscr.descrizione,iscr.descrizione_al1))
                                       ,nvl(iscr.descrizione,nvl(iscr.descrizione_al1,iscr.descrizione_al2)))||' - '||
                 substr(decode(w_gruppo_ling,1,nvl(spor.descrizione,nvl(spor.descrizione_al1,spor.descrizione_al2))
                                     ,2,nvl(spor.descrizione_al1,nvl(spor.descrizione,spor.descrizione_al2))
                                     ,3,nvl(spor.descrizione_al2,nvl(spor.descrizione,spor.descrizione_al1))
                                       ,nvl(spor.descrizione,nvl(spor.descrizione_al1,spor.descrizione_al2))),1, 60 -
                  length(decode(w_gruppo_ling,1,nvl(iscr.descrizione,nvl(iscr.descrizione_al1,iscr.descrizione_al2))
                                     ,2,nvl(iscr.descrizione_al1,nvl(iscr.descrizione,iscr.descrizione_al2))
                                     ,3,nvl(iscr.descrizione_al2,nvl(iscr.descrizione,iscr.descrizione_al1))
                                       ,nvl(iscr.descrizione,nvl(iscr.descrizione_al1,iscr.descrizione_al2))))
                 - nvl(length(rare.conto_corrente),0))||
                 decode(rare.conto_corrente,null,null,' c/c '||rare.conto_corrente)||
                 decode(rare.cin_ita,null,null,' cin '||rare.cin_ita)||
                 decode(rare.delega,null,null,' del.'||rare.delega))
        , decode(w_gruppo_ling,1,nvl(iscr.descrizione,nvl(iscr.descrizione_al1,iscr.descrizione_al2))
                               ,2,nvl(iscr.descrizione_al1,nvl(iscr.descrizione,iscr.descrizione_al2))
                               ,3,nvl(iscr.descrizione_al2,nvl(iscr.descrizione,iscr.descrizione_al1))
                               ,nvl(iscr.descrizione,nvl(iscr.descrizione_al1,iscr.descrizione_al2)))||' - '||
                 substr(decode(w_gruppo_ling,1,nvl(spor.descrizione,nvl(spor.descrizione_al1,spor.descrizione_al2))
                                            ,2,nvl(spor.descrizione_al1,nvl(spor.descrizione,spor.descrizione_al2))
                                            ,3,nvl(spor.descrizione_al2,nvl(spor.descrizione,spor.descrizione_al1))
                                              ,nvl(spor.descrizione,nvl(spor.descrizione_al1,spor.descrizione_al2))),1, 60 -
                 length(decode(w_gruppo_ling,1,nvl(iscr.descrizione,nvl(iscr.descrizione_al1,iscr.descrizione_al2))
                                            ,2,nvl(iscr.descrizione_al1,nvl(iscr.descrizione,iscr.descrizione_al2))
                                            ,3,nvl(iscr.descrizione_al2,nvl(iscr.descrizione,iscr.descrizione_al1))
                                              ,nvl(iscr.descrizione,nvl(iscr.descrizione_al1,iscr.descrizione_al2))))
                 - nvl(length(rare.conto_corrente),0))||
                 decode(rare.conto_corrente,null,null,' c/c '||rare.conto_corrente)||
                 decode(rare.cin_ita,null,null,' cin '||rare.cin_ita)
        , 'Del. '||rare.delega
        , rare.codice_inps
        , rare.posizione_inail
        , lpad(matricola,8)
        , rare.statistico1, rare.statistico2, rare.statistico3
        , rare.istituto
        , rare.sportello
        , rare.cod_nazione
        , rare.cin_eur
        , rare.cin_ita
        , rare.conto_corrente
        , iscr.codice_abi
        , iscr.codice_cab
     into rare_descrizione_banca
        , rare_descrizione_banca2
        , rare_delega
        , rare_codice_inps
        , rare_posizione_inail
        , rare_matricola
        , rare_statistico1
        , rare_statistico2
        , rare_statistico3
        , rare_istituto
        , rare_sportello
        , rare_cod_nazione
        , rare_cin_eur
        , rare_cin_ita
        , rare_conto_corrente
        , iscr_codice_abi
        , iscr_codice_cab
     from rapporti_retributivi_storici rare
        , istituti_credito iscr
        , sportelli spor
    where rare.ci = p_ci
      and rare.istituto= iscr.codice
      and spor.sportello=rare.sportello
 and spor.istituto=iscr.codice
      and rare.dal = (select max(dal)
                        from rapporti_retributivi_storici r
                       where r.ci = p_ci
                         and r.dal <= fin_mese
                         and nvl(r.al,to_date('3333333','j')) >= ini_mese
                     )
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     rare_descrizione_banca  := null;
     rare_descrizione_banca2 := null;
     rare_delega             := null;
     rare_codice_inps := null;
     rare_posizione_inail:= null;
     rare_matricola := null;
     rare_statistico1 := null;
     rare_statistico2 := null;
     rare_statistico3 := null;
     rare_istituto := null;
     rare_sportello := null;
     rare_cod_nazione := null;
     rare_cin_eur := null;
     rare_cin_ita := null;
     rare_conto_corrente := null;
     contaerrori := contaerrori +1;
     insert into a_segnalazioni_errore
               ( NO_PRENOTAZIONE,
       PASSO,
              PROGRESSIVO,
              ERRORE,
         PRECISAZIONE
       ) values
       ( p_prenotazione,
           p_passo,
       contaerrori,
       'A00037',
         substr('Rapporto Retributivo Non Valido per il Ci '||to_char(p_ci),1,50)
       );
 END;
IF rare_posizione_inail is not null THEN
  /* Dati RARE */
 BEGIN
   select aina.posizione
     into aina_posizione
     from assicurazioni_inail aina
    where aina.codice = rare_posizione_inail
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     aina_posizione := null;
 END;
END IF;
/* Dati MENS */
 BEGIN
   select decode(w_gruppo_ling,1,nvl(mens.descrizione,nvl(mens.descrizione_al1,mens.descrizione_al2))
                              ,2,nvl(mens.descrizione_al1,nvl(mens.descrizione,mens.descrizione_al2))
                              ,3,nvl(mens.descrizione_al2,nvl(mens.descrizione,mens.descrizione_al1))
                                ,nvl(mens.descrizione,nvl(mens.descrizione_al1,mens.descrizione_al2)))||' '||p_anno
        , '(Val.'||lpad(mens.giorno,2,0)||'/'||lpad(mens.mese_liq,2,0)||'/'||
          substr(decode(sign(mens.mese_liq - p_mese),-1,p_anno +1,p_anno),3,2)||')'
        , decode(rare_conto_corrente,null,null,'(Val.'||lpad(mens.giorno,2,0)||'/'||lpad(mens.mese_liq,2,0)||'/'||
          substr(decode(sign(mens.mese_liq - p_mese),-1,p_anno +1,p_anno),3,2)||')')
     into mens_descrizione
        , mens_data_val1
        , mens_data_val
     from mensilita mens
    where mese      = p_mese
      and mensilita = p_mensilita
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     mens_descrizione :=null;
     mens_data_val1   :=null;
     mens_data_val    :=null;
 END;
 mens_periodo_comp := substr(mens_descrizione||' '||mens_data_val,1,40);
 mens_periodo_comp1 := substr(mens_descrizione||' '||mens_data_val1,1,40);
IF pere_qualifica is not null THEN
/* Dati PEGI */
 BEGIN
   select to_char(min(pegi.dal),'dd/mm/yy')
     into pegi_qual_dal
     from periodi_giuridici pegi
    where pegi.ci   = p_ci
      and pegi.rilevanza = 'S'
      and pegi.qualifica = pere_qualifica
   ;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     pegi_qual_dal := null;
 END;
END IF;
IF qual_qua_inps is not null THEN
/* Dati PRFI */
  BEGIN
    select gp4_prfi.anni_tot(P_ci,P_anno,P_mese,p_mensilita)
         , gp4_prfi.mesi_tot(P_ci,P_anno,P_mese,p_mensilita)
         , gp4_prfi.gg_tot(P_ci,P_anno,P_mese,p_mensilita)
      into prfi_anni_anz
         , prfi_mesi_anz
         , prfi_giorni_anz
      from dual
     ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      prfi_anni_anz := TO_CHAR(NULL);
      prfi_mesi_anz := TO_CHAR(NULL);
      prfi_giorni_anz := TO_CHAR(NULL);
    WHEN TOO_MANY_ROWS THEN
      prfi_anni_anz := TO_CHAR(NULL);
      prfi_mesi_anz := TO_CHAR(NULL);
      prfi_giorni_anz := TO_CHAR(NULL);
  END;
  BEGIN
    select count(distinct qua_inps)
      into w_conta_qua
      from qualifiche
     where numero in (select qualifica
                        from periodi_giuridici
                        where ci = p_ci
                          and rilevanza = 'S')
    ;
    IF w_conta_qua > 1 THEN
      BEGIN
        select to_char(min(pegi.dal),'dd/mm/yy')
          into pegi_qual_inps_dal
          from periodi_giuridici pegi
         where pegi.ci   = p_ci
           and pegi.rilevanza = 'S'
           and pegi.qualifica in (select numero
                                    from qualifiche
                                   where nvl(qua_inps,0) = nvl(qual_qua_inps,0)
                                 )
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          pegi_qual_inps_dal := null;
      END;
    END IF;
  END;
END IF;
/* DATI CAFA */
BEGIN
  select cafa.cond_fis
       , cafa.scaglione_coniuge,cafa.coniuge
       , cafa.scaglione_figli,cafa.figli
       , cafa.figli_dd,cafa.figli_mn
       , cafa.figli_mn_dd,cafa.figli_hh
       , cafa.figli_hh_dd,cafa.altri
       , cafa.cond_fam,cafa.nucleo_fam
       , cafa.figli_fam
    into cafa_cond_fis
       , cafa_scaglione_coniuge,cafa_coniuge
       , cafa_scaglione_figli,cafa_figli
       , cafa_figli_dd,cafa_figli_mn
       , cafa_figli_mn_dd,cafa_figli_hh
       , cafa_figli_hh_dd,cafa_altri
       , cafa_cond_fam,cafa_nucleo_fam
       , cafa_figli_fam
    from carichi_familiari cafa
   where cafa.anno = p_anno
     and cafa.mese = p_mese
     and cafa.ci = p_ci
     and ((cafa.giorni is null
         and not exists(select 'x'
                          from carichi_familiari
                         where anno = p_anno
                           and mese = p_mese
                           and ci = p_ci
                           and giorni is not null
                       )
         )
         or cafa.giorni = (select max(giorni) 
                             from carichi_familiari
                            where anno = p_anno
                              and mese = p_mese
                              and ci = p_ci
                              and giorni is not null)
                       )
  ;
EXCEPTION
  WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
    cafa_cond_fis := null;
    cafa_scaglione_coniuge := null;
    cafa_coniuge := null;
    cafa_scaglione_figli := null;
    cafa_figli := null;
    cafa_figli_dd := null;
    cafa_figli_mn := null;
    cafa_figli_mn_dd := null;
    cafa_figli_hh := null;
    cafa_figli_hh_dd := null;
    cafa_altri := null;
    cafa_cond_fam := null;
    cafa_nucleo_fam := null;
    cafa_figli_fam := null;
END;
/* DATI COFI */
BEGIN
  select decode(w_gruppo_ling,1,nvl(cofi.descrizione,nvl(cofi.descrizione_al1,cofi.descrizione_al2))
                             ,2,nvl(cofi.descrizione_al1,nvl(cofi.descrizione,cofi.descrizione_al2))
                             ,3,nvl(cofi.descrizione_al2,nvl(cofi.descrizione,cofi.descrizione_al1))
                               ,nvl(cofi.descrizione,nvl(cofi.descrizione_al1,cofi.descrizione_al2)))
    into cofi_descrizione
    from condizioni_fiscali cofi
   where cofi.codice = cafa_cond_fis
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    cofi_descrizione := null;
END;
/* DATI COFA */
BEGIN
  select decode(w_gruppo_ling,1,nvl(cofa.descrizione,nvl(cofa.descrizione_al1,cofa.descrizione_al2))
                             ,2,nvl(cofa.descrizione_al1,nvl(cofa.descrizione,cofa.descrizione_al2))
                             ,3,nvl(cofa.descrizione_al2,nvl(cofa.descrizione,cofa.descrizione_al1))
                               ,nvl(cofa.descrizione,nvl(cofa.descrizione_al1,cofa.descrizione_al2)))
    into cofa_descrizione
    from condizioni_familiari cofa
   where cofa.codice = cafa_cond_fam
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    cofa_descrizione := null;
END;
BEGIN
   IF CAFA_COND_FAM IS NOT NULL AND CAFA_NUCLEO_FAM IS NOT NULL THEN
      BEGIN
          D_ipn_fam := GP4_INEX.GET_IPN_FAM(P_ci, P_anno, P_mese);
         IF D_ipn_fam is null THEN
            RAISE NO_DATA_FOUND;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
           cafa_assegno := null;
      END;
      /* Lettura CODICE tabella dalla quale ricavare l'importo */
      BEGIN
        select nvl(tabella,1)
          into D_tabella
          from condizioni_familiari
         where codice = cafa_cond_fam
        ;
      EXCEPTION
         WHEN OTHERS THEN
          D_tabella := null;
      END;
      BEGIN
      /*                                   */
      /* Calcolo importo assegni familiari */
      /*                                   */
      select nvl(ASFA.IMPORTO,0)
        into D_ass_fam
        from ASSEGNI_FAMILIARI ASFA
       where to_date( '01/'||to_char(P_MESE)||'/'||
                      to_char(P_ANNO)
                       , 'dd/mm/yyyy'
                    )
             between DAL
                 and nvl(AL ,to_date('3333333','j'))
         and ASFA.TABELLA    = D_tabella
         and ASFA.NUMERO     = CAFA_NUCLEO_FAM
         and ASFA.SCAGLIONE in
             (select min(SCAF.SCAGLIONE)
                from SCAGLIONI_ASSEGNO_FAMILIARE SCAF
                   , AGGIUNTIVI_FAMILIARI AGFA
               where AGFA.CODICE = CAFA_COND_FAM
                 and AGFA.DAL    = SCAF.DAL
                 and to_date( '01/'||to_char(P_MESE)||
                              '/'||to_char(P_ANNO)
                              , 'dd/mm/yyyy'
                             )
                     between SCAF.DAL
                         and nvl(SCAF.AL ,to_date('3333333','j'))
                 and SCAF.SCAGLIONE + nvl(AGFA.AGGIUNTIVO,0)
                     >= D_ipn_fam
               )
         ;
      /*                                   */
      /* Calcolo importo assegno per figli */
      /*                                   */
     IF nvl(CAFA_FIGLI_FAM,0) > 0 AND D_ass_fam              > 0 THEN
         select nvl(ASFA.INTEGRATIVO,0) + nvl(ASFA.AUMENTO,0)
           into D_ass_figli
           from ASSEGNI_FAMILIARI ASFA
          where to_date( '01/'||to_char(P_MESE)||'/'||
                         to_char(P_ANNO)
                       , 'dd/mm/yyyy'
                       )
                          between DAL
                              and nvl(AL ,to_date('3333333','j'))
            and ASFA.TABELLA    = D_tabella
            and ASFA.NUMERO     = cafa_figli_fam
            and ASFA.SCAGLIONE in
               (select min(SCAF.SCAGLIONE)
                  from SCAGLIONI_ASSEGNO_FAMILIARE SCAF
                     , AGGIUNTIVI_FAMILIARI AGFA
                 where AGFA.CODICE = CAFA_COND_FAM
                   and AGFA.DAL    = SCAF.DAL
                   and to_date( '01/'||to_char(P_MESE)||
                                '/'||to_char(P_ANNO)
                              , 'dd/mm/yyyy'
                              )
                             between SCAF.DAL
                                 and nvl(SCAF.AL ,to_date('3333333','j'))
                   and SCAF.SCAGLIONE + nvl(AGFA.AGGIUNTIVO,0)
                                  >= D_ipn_fam
               )
         ;
         ELSE D_ass_figli := 0;
         END IF;
         CAFA_ASSEGNO := D_ass_fam + D_ass_figli;
      EXCEPTION
         WHEN OTHERS THEN
           cafa_assegno := null;
      END;
   END IF;
END;
/* DATI MOCO */
BEGIN
  select lpad(translate(to_char(sum(decode(voec.automatismo
                                          ,'ARR_PRE',moco.imp*-1
                                          ,null)),'999.99'),',.','.,'),7) arr_pre
       ,lpad(translate(to_char(sum(decode(substr(voec.automatismo,1,7)
                                          ,'ARR_ATT',moco.imp
                                          ,null)),'999.99'),',.','.,'),7) arr_att
       ,translate(to_char(sum(decode(voec.automatismo
                                           ,'COMP',moco.imp
                                           ,null)),'999999.99'),',.','.,') totale_competenze
       ,translate(to_char(sum(decode(voec.automatismo
                                          ,'TRAT',moco.imp*-1
                                          ,null)),'999999.99'),',.','.,')  totale_trattenute
       ,translate(to_char(sum(decode(voec.automatismo
                                  ,'NETTO',moco.imp
                                  ,0)),'9,999,999.99'),',.','.,') netto
    into moco_arr_pre,moco_arr_att
       , moco_totale_comp,moco_totale_rit
       , moco_netto
    from voci_economiche voec
       , movimenti_contabili moco
   where moco.ci = p_ci
     and moco.anno = p_anno
     and moco.mese = p_mese
     and moco.mensilita = p_mensilita
     and moco.voce  = voec.codice
     and voec.codice in (select codice
                           from voci_economiche
                          where automatismo in
                                ('ARR_PRE','ARR_ATT','ARR_ATT_N'
                                ,'ARR_ATT_S','ARR_ATT_SN','COMP','TRAT'
                                ,'NETTO')
                          union
                         select codice
                           from voci_economiche
                          where classe = 'A'
                        )
   group by moco.ci
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    moco_arr_pre     :=null;
    moco_arr_att     :=null;
    moco_totale_comp :=null;
    moco_totale_rit  :=null;
    moco_netto       :=null;
END;
SCRIVI_NOTE;
contarighe  := 1;
  SCRIVI('I',1,'P');
   if SEL_MOCO %ISOPEN then
     null;
   else
    open sel_moco(p_ci ,p_anno ,p_mese ,p_mensilita ,w_gruppo_ling,'F');
   end if;
  SCRIVI_CORPO('F');
  SCRIVI('P',dim_piede,'U');
  WHILE v_note_rimaste != 0 LOOP
    SCRIVI_RETRO;
    SCRIVI('P',dim_piede,'N');
  END LOOP;
  IF nvl(p_fronte_retro,'NO') != 'NO' and mod(sys_num_pag_eff,2) != 0 THEN
    SCRIVI_RETRO;
  END IF;
  p_prenotazione_old := p_prenotazione;
  p_ci_old := p_ci;
  IF SEL_INEC %ISOPEN THEN
    close sel_inec;
    w_ultimo_cursore := ' ';
  END IF;
  IF SEL_MOV_ORIZ %ISOPEN THEN
    close sel_mov_oriz;
    w_ultimo_cursore := ' ';
  END IF;
  IF SEL_MOCO %ISOPEN THEN
    close sel_moco;
    w_ultimo_cursore := ' ';
  END IF;
  IF SEL_NOTE %ISOPEN THEN
    close sel_note;
    w_ultimo_cursore := ' ';
  END IF;
  IF SEL_IMP_M %ISOPEN THEN
    close sel_imp_m;
    w_ultimo_cursore := ' ';
  END IF;
  IF SEL_IMP_A %ISOPEN THEN
    close sel_imp_a;
    w_ultimo_cursore := ' ';
  END IF;
  IF SEL_MAL %ISOPEN THEN
    close sel_mal;
    w_ultimo_cursore := ' ';
  END IF;
  IF SEL_DELI %ISOPEN THEN
    close sel_deli;
    w_ultimo_cursore := ' ';
  END IF;
commit;
END;
end;
/
