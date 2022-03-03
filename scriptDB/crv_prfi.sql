CREATE OR REPLACE VIEW PROGRESSIVI_FISCALI ( CI, 
ANNO, MESE, MENSILITA, MOFI_MESE, 
MOFI_MENSILITA, RIT_ORD, IPN_ORD, ALQ_ORD, 
IPT_ORD, RIT_SEP, IPN_SEP, ALQ_SEP, 
IPT_SEP, IPN_TER, IPN_TER_NO_SSN, IPN_TER_ASS, 
IPT_TER, ADD_REG_TER, ADD_PRO_TER, ADD_COM_TER, 
IPN_AC, ALQ_AC, IPT_AC, DET_FIS, 
DET_CON, DET_FIG, DET_ALT, DET_SPE, 
DET_ULT, DET_GOD, CON_FIS, ADD_IRPEF, 
ADD_IRPEF_PAG, ADD_IRPEF_PROVINCIALE, ADD_IRPEF_PROVINCIALE_PAG, ADD_IRPEF_COMUNALE, 
ADD_IRPEF_COMUNALE_PAG, IPT_PAG, RIT_AP, IPN_AP, 
RIT_AAP, IPN_AAP, IPT_AAP, IPN_1AP, 
IPN_2AP, TITOLO_AP, MIN_ANNO_AP, NR_ANNI_AP, 
ALQ_AP, IPT_AP, LOR_LIQ, LOR_ACC, 
LOR_ACC_2000, RIT_LIQ, RID_LIQ, RTP_LIQ, 
IPN_LIQ, ALQ_LIQ, IPT_LIQ, DET_LIQ, 
DTP_LIQ, IPT_LIQ_PAG, ANT_LIQ_AP, ANT_ACC_AP, 
ANT_ACC_2000, IPN_LIQ_AP, IPT_LIQ_AP, GG_ANZ_C, 
GG_ANZ_T, GG_ANZ_I, GG_ANZ_R, GG_ANZ_T_2000, 
GG_ANZ_I_2000, GG_ANZ_R_2000, LOR_TRA, RIT_TRA, 
IPN_TRA, RIT_ASS, IPN_ASS, IPT_ASS, 
FDO_TFR_AP, FDO_TFR_AP_LIQ, FDO_TFR_2000, FDO_TFR_2000_LIQ, 
RIV_TFR_AP, RIV_TFR_AP_LIQ, RIV_TFR, RIV_TFR_LIQ, 
RET_TFR, QTA_TFR_AC, QTA_TFR_AC_LIQ, IPN_TFR, 
RIT_TFR, RIT_RIV, SOMME_0, SOMME_1, 
SOMME_2, SOMME_3, SOMME_4, SOMME_5, 
SOMME_6, SOMME_7, SOMME_8, SOMME_9, 
SOMME_10, SOMME_11, SOMME_12, SOMME_13, 
SOMME_14, SOMME_15, SOMME_16, SOMME_17, 
SOMME_18, SOMME_19, IPN_SSN, RIT_SSN, 
IPN_SSN_LIQ, RIT_SSN_LIQ, IPN_PREV, TFR_LIQ_RIF_AP,
SOMME_OD, DED_FIS, DED_PER ,DED_TOT,ded_base,
ded_agg,ded_base_ac,
ded_agg_ac,ded_per_ac,
det_liq_ap,
ded_con,ded_fig,ded_alt,
ded_per_fam,
ded_con_ac,
ded_fig_ac,
ded_alt_ac,
ded_per_fam_ac,
det_con_ac,
det_fig_ac,
det_alt_ac,
det_spe_ac
 ) AS SELECT  
 mofu.ci  
  , mofu.anno  
  , mens.mese  
  , mens.mensilita  
  , mofi.mese  
  , mofi.mensilita  
  , mofi.rit_ord  
  , mofi.ipn_ord  
  , mofi.alq_ord  
  , mofi.ipt_ord  
  , mofi.rit_sep  
  , mofi.ipn_sep  
  , mofi.alq_sep  
  , mofi.ipt_sep  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.ipn_1,0)  
    + nvl(inex.ipn_2,0)  
    + nvl(inex.ipn_3,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.ipn_no_ssn_1,0)  
    + nvl(inex.ipn_no_ssn_2,0)  
    + nvl(inex.ipn_no_ssn_3,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.ipn_ass_1,0)  
    + nvl(inex.ipn_ass_2,0)  
    + nvl(inex.ipn_ass_3,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.ipt_1,0)  
    + nvl(inex.ipt_2,0)  
    + nvl(inex.ipt_3,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.add_reg_1,0)  
    + nvl(inex.add_reg_2,0)  
    + nvl(inex.add_reg_3,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.add_pro_1,0)  
    + nvl(inex.add_pro_2,0)  
    + nvl(inex.add_pro_3,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.add_com_1,0)  
    + nvl(inex.add_com_2,0)  
    + nvl(inex.add_com_3,0)  
    , 0  
 )  
  , mofi.ipn_ord + nvl(mofi.ipn_sep,0)  
  + decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.ipn_1,0)  
    + nvl(inex.ipn_2,0)  
    + nvl(inex.ipn_3,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.alq_ac  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.ipt_ac  
    , 0  
 )  
  , mofi.det_fis  
  , mofi.det_con  
  , mofi.det_fig  
  , mofi.det_alt  
  , mofi.det_spe  
  , mofi.det_ult  
  , mofi.det_god  
  , mofi.con_fis  
  , mofi.add_irpef  
  , mofi.add_irpef  
  + decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.add_reg_1,0)  
    + nvl(inex.add_reg_2,0)  
    + nvl(inex.add_reg_3,0)  
    , 0  
 )  
  , mofi.add_irpef_provinciale  
  , mofi.add_irpef_provinciale  
  + decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.add_pro_1,0)  
    + nvl(inex.add_pro_2,0)  
    + nvl(inex.add_pro_3,0)  
    , 0  
 )  
  , mofi.add_irpef_comunale  
  , mofi.add_irpef_comunale  
  + decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.add_com_1,0)  
    + nvl(inex.add_com_2,0)  
    + nvl(inex.add_com_3,0)  
    , 0  
 )  
  , mofi.ipt_ord + nvl(mofi.ipt_sep,0)  
  + decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.ipt_1,0)  
    + nvl(inex.ipt_2,0)  
    + nvl(inex.ipt_3,0)  
    , 0  
 )  
  - mofi.det_god - mofi.con_fis  
  , mofi.rit_ap  
  , mofi.ipn_ap  
  , mofi.rit_aap  
  , mofi.ipn_aap  
  , mofi.ipt_aap  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.ipn_1ap,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.ipn_2ap,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, inex.titolo_ap  
    , ''  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.min_anno_ap,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.nr_anni_ap,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.alq_ap  
    , 0    , 0  
 )  
  , mofi.ipt_ap  
  , mofi.lor_liq  
  , mofi.lor_acc  
  , mofi.lor_acc_2000  
  , mofi.rit_liq  
  , mofi.rid_liq  
  , mofi.rtp_liq  
  , mofi.ipn_liq  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.alq_liq  
    , 0  
 )  
  , mofi.ipt_liq  
  , mofi.det_liq  
  , mofi.dtp_liq  
  , mofi.ipt_liq - nvl(mofi.det_liq,0) - nvl(mofi.dtp_liq,0)  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.ant_liq_ap,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.ant_acc_ap,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.ant_acc_2000,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.ipn_liq_ap,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.ipt_liq_ap,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.gg_anz_c,0)  
    , 0  
 )  
  , mofi.gg_anz_t  
  , mofi.gg_anz_i  
  , mofi.gg_anz_r  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.gg_anz_t_2000,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.gg_anz_i_2000,0)  
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.gg_anz_r_2000,0)  
    , 0  
 )  
  , mofi.lor_tra  
  , mofi.rit_tra  
  , mofi.ipn_tra  
  , mofi.rit_ass  
  , mofi.ipn_ass  
  , mofi.ipt_ass  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.fdo_tfr_ap,0)  
    , 0  
 )  
  , mofi.fdo_tfr_ap_liq  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.fdo_tfr_2000,0)  
    , 0  
 )  
  , mofi.fdo_tfr_2000_liq  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, nvl(inex.riv_tfr_ap,0)  
    , 0  
 )  
  , mofi.riv_tfr_ap_liq  
  , mofi.riv_tfr  
  , mofi.riv_tfr_liq  
  , mofi.ret_tfr  
  , mofi.qta_tfr_ac  
  , mofi.qta_tfr_ac_liq  
  , mofi.ipn_tfr  
  , mofi.rit_tfr  
  , mofi.rit_riv  
  , mofi.somme_0  
  , mofi.somme_1  
  , mofi.somme_2  
  , mofi.somme_3  
  , mofi.somme_4  
  , mofi.somme_5  
  , mofi.somme_6  
  , mofi.somme_7  
  , mofi.somme_8  
  , mofi.somme_9  
  , mofi.somme_10  
  , mofi.somme_11  
  , mofi.somme_12  
  , mofi.somme_13  
  , mofi.somme_14  
  , mofi.somme_15  
  , mofi.somme_16  
  , mofi.somme_17  
  , mofi.somme_18  
  , mofi.somme_19  
  , mofi.ipn_ssn  
  , mofi.rit_ssn  
  , mofi.ipn_ssn_liq  
  , mofi.rit_ssn_liq  
  , mofi.ipn_prev  
  , mofi.tfr_liq_rif_ap  
  , mofi.somme_od
  , mofi.ded_fis
  , mofi.ded_per  
  , mofi.ded_tot  
  , mofi.ded_base
  , mofi.ded_agg
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.ded_base_ac
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.ded_agg_ac
    , 0  
 )  
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.ded_per_ac
    , 0  
 )
  , inex.det_liq_ap  
  , mofi.ded_con
  , mofi.ded_fig
  , mofi.ded_alt
  , mofi.ded_per_fam
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.ded_con_ac
    , 0  
 )
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.ded_fig_ac
    , 0  
 )
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.ded_alt_ac
    , 0  
 )
  , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.ded_per_fam_ac
    , 0  
 )
 , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.det_con_ac
    , 0  
 )
 , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.det_fig_ac
    , 0  
 )
 , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.det_alt_ac
    , 0  
 )
 , decode( lpad(mofi.mese,2,'0')||mofi.mensilita  
 , lpad(mofu.mese,2,'0')||mofu.mensilita, mofi.det_spe_ac
    , 0  
 )
FROM  
 movimenti_fiscali  mofi,  
 informazioni_extracontabili  inex,  
 movimenti_fiscali  mofu,  
 mensilita  mens  
 where mofi.ci = mofu.ci  
   and mofi.anno  = mofu.anno  
   and lpad(mofi.mese,2,'0')||mofi.mensilita  
  <= lpad(mens.mese,2,'0')||mens.mensilita  
   and inex.ci   (+) = mofu.ci  
   and inex.anno (+) = mofu.anno  
   and lpad(mofu.mese,2,'0')||mofu.mensilita  
   =  
   (select max(lpad(mese,2,'0')||mensilita)  
   from movimenti_fiscali  
  where ci   = mofu.ci  
 and anno = mofu.anno  
 and lpad(mese,2,'0')||mensilita  
   <= lpad(mens.mese,2,'0')||mens.mensilita  
   )
/
