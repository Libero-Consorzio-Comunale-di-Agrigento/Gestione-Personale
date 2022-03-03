REM  Objects being generated in this file are:-
REM TABLE
REM      MOVIMENTI_FISCALI
REM INDEX
REM      MOFI_MENS_FK
REM      MOFI_MESE_FK
REM      MOFI_PK

REM
REM     MOFI - Informazioni fiscali sintetiche riassuntive dei movimenti contab
REM - ili
REM
PROMPT 
PROMPT Creating Table MOVIMENTI_FISCALI
CREATE TABLE movimenti_fiscali(
 ci                              NUMBER(8,0)      NOT NULL,
 anno                            NUMBER(4,0)      NOT NULL,
 mese                            NUMBER(2,0)      NOT NULL,
 mensilita                       VARCHAR(3)       NOT NULL,
 rit_ord                         NUMBER(12,2)     NOT NULL,
 ipn_ord                         NUMBER(12,2)     NOT NULL,
 alq_ord                         NUMBER(4,2)      NOT NULL,
 ipt_ord                         NUMBER(12,2)     NOT NULL,
 rit_sep                         NUMBER(12,2)     NULL,
 ipn_sep                         NUMBER(12,2)     NULL,
 alq_sep                         NUMBER(4,2)      NULL,
 ipt_sep                         NUMBER(12,2)     NULL,
 alq_ac                          NUMBER(4,2)      NOT NULL,
 ipt_ac                          NUMBER(12,2)     NOT NULL,
 det_fis                         NUMBER(12,2)     NOT NULL,
 det_con                         NUMBER(12,2)     NOT NULL,
 det_fig                         NUMBER(12,2)     NOT NULL,
 det_alt                         NUMBER(12,2)     NOT NULL,
 det_spe                         NUMBER(12,2)     NOT NULL,
 det_ult                         NUMBER(12,2)     NOT NULL,
 det_god                         NUMBER(12,2)     NOT NULL,
 con_fis                         NUMBER(12,2)     NOT NULL,
 rit_ap                          NUMBER(12,2)     NOT NULL,
 ipn_ap                          NUMBER(12,2)     NOT NULL,
 alq_ap                          NUMBER(4,2)      NOT NULL,
 ipt_ap                          NUMBER(12,2)     NOT NULL,
 lor_liq                         NUMBER(12,2)     NOT NULL,
 lor_acc                         NUMBER(12,2)     NOT NULL,
 rit_liq                         NUMBER(12,2)     NOT NULL,
 rid_liq                         NUMBER(12,2)     NOT NULL,
 rtp_liq                         NUMBER(12,2)     NOT NULL,
 ipn_liq                         NUMBER(12,2)     NOT NULL,
 alq_liq                         NUMBER(4,2)      NOT NULL,
 ipt_liq                         NUMBER(12,2)     NOT NULL,
 gg_anz_t                        NUMBER(5,0)      NOT NULL,
 gg_anz_i                        NUMBER(5,0)      NOT NULL,
 gg_anz_r                        NUMBER(7,2)      NOT NULL,
 lor_tra                         NUMBER(12,2)     NOT NULL,
 rit_tra                         NUMBER(12,2)     NOT NULL,
 ipn_tra                         NUMBER(12,2)     NOT NULL,
 fdo_tfr_ap_liq                  NUMBER(12,2)     NULL,
 riv_tfr                         NUMBER(12,2)     NULL,
 riv_tfr_liq                     NUMBER(12,2)     NULL,
 ret_tfr                         NUMBER(12,2)     NULL,
 qta_tfr_ac                      NUMBER(12,2)     NULL,
 qta_tfr_ac_liq                  NUMBER(12,2)     NULL,
 ipn_tfr                         NUMBER(12,2)     NULL,
 rit_tfr                         NUMBER(12,2)     NULL,
 somme_0                         NUMBER(12,2)     NULL,
 somme_1                         NUMBER(12,2)     NULL,
 somme_2                         NUMBER(12,2)     NULL,
 somme_3                         NUMBER(12,2)     NULL,
 somme_4                         NUMBER(12,2)     NULL,
 somme_5                         NUMBER(12,2)     NULL,
 somme_6                         NUMBER(12,2)     NULL,
 somme_7                         NUMBER(12,2)     NULL,
 somme_8                         NUMBER(12,2)     NULL,
 somme_9                         NUMBER(12,2)     NULL,
 ipn_ssn                         NUMBER(12,2)     NULL,
 rit_ssn                         NUMBER(12,2)     NULL,
 ipn_ssn_liq                     NUMBER(12,2)     NULL,
 rit_ssn_liq                     NUMBER(12,2)     NULL,
 somme_10                        NUMBER(12,2)     NULL,
 somme_11                        NUMBER(12,2)     NULL,
 somme_12                        NUMBER(12,2)     NULL,
 somme_13                        NUMBER(12,2)     NULL,
 somme_14                        NUMBER(12,2)     NULL,
 somme_15                        NUMBER(12,2)     NULL,
 somme_16                        NUMBER(12,2)     NULL,
 somme_17                        NUMBER(12,2)     NULL,
 somme_18                        NUMBER(12,2)     NULL,
 somme_19                        NUMBER(12,2)     NULL,
 ipn_prev                        NUMBER(12,2)     NULL,
 add_irpef                       NUMBER(12,2)     NULL,
 rit_ass                         NUMBER(12,2)     NULL,
 ipn_ass                         NUMBER(12,2)     NULL,
 ipt_ass                         NUMBER(12,2)     NULL,
 rit_aap                         NUMBER(12,2)     NULL,
 ipn_aap                         NUMBER(12,2)     NULL,
 ipt_aap                         NUMBER(12,2)     NULL,
 add_irpef_comunale              NUMBER(12,2)     NULL,
 add_irpef_provinciale           NUMBER(12,2)     NULL,
 fdo_tfr_2000_liq                NUMBER(12,2)     NULL,
 riv_tfr_ap_liq                  NUMBER(12,2)     NULL,
 rit_riv                         NUMBER(12,2)     NULL,
 lor_acc_2000                    NUMBER(12,2)     NULL,
 det_liq                         NUMBER(12,2)     NULL,
 dtp_liq                         NUMBER(12,2)     NULL,
 data_richiesta_ant              DATE             NULL,
 tfr_liq_rif_ap                  NUMBER(12,2)     NULL,
 somme_od                        NUMBER(12,2)     NULL,
 ded_fis                         NUMBER(12,2)     NULL,
 ded_per                         NUMBER(5,2)      NULL,
 ded_tot                         NUMBER(12,2)     NULL,
 ded_base                        NUMBER(12,2)     NULL,
 ded_agg                         NUMBER(12,2)     NULL,
 ded_base_ac                     NUMBER(12,2)     NULL,
 ded_agg_ac                      NUMBER(12,2)     NULL, 
 ded_per_ac                      NUMBER(5,2)      NULL,
 ded_con                         NUMBER(12,2)     NULL,
 ded_fig                         NUMBER(12,2)     NULL,
 ded_alt                         NUMBER(12,2)     NULL,
 ded_per_fam                     NUMBER(5,2)      NULL,
 ded_con_ac                      NUMBER(12,2)     NULL,
 ded_fig_ac                      NUMBER(12,2)     NULL,
 ded_alt_ac                      NUMBER(12,2)     NULL,
 ded_per_fam_ac                  NUMBER(5,2)      NULL,
 det_con_ac                      NUMBER(12,2)     NULL,
 det_fig_ac                      NUMBER(12,2)     NULL,
 det_alt_ac                      NUMBER(12,2)     NULL,
 det_spe_ac                      NUMBER(12,2)     NULL
)
STORAGE  (
  INITIAL   &1DIMx6000
  NEXT   &1DIMx3000
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  50
  )
;

COMMENT ON TABLE movimenti_fiscali
    IS 'MOFI - Informazioni fiscali sintetiche riassuntive dei movimenti contabili';


REM
REM 
REM
PROMPT
PROMPT Creating Index MOFI_MENS_FK on Table MOVIMENTI_FISCALI
CREATE INDEX MOFI_MENS_FK ON MOVIMENTI_FISCALI
(
      mese ,
      mensilita )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx800      
  NEXT   &1DIMx400      
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  50
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index MOFI_MESE_FK on Table MOVIMENTI_FISCALI
CREATE INDEX MOFI_MESE_FK ON MOVIMENTI_FISCALI
(
      anno ,
      mese )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx1000     
  NEXT   &1DIMx500    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  50
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index MOFI_PK on Table MOVIMENTI_FISCALI
CREATE UNIQUE INDEX MOFI_PK ON MOVIMENTI_FISCALI
(
      ci ,
      anno ,
      mese ,
      mensilita )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx1000      
  NEXT   &1DIMx500    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  50
  )
;

REM
REM  End of command file
REM
