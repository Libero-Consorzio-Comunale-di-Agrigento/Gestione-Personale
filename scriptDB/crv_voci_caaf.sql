CREATE OR REPLACE VIEW CAAF_VOCI_RETTIFICA
      ( ANNO
      , CI
      , VOCE
      , SUB
      , IMP
      , CODICE_COM
      , CODICE_REG
) AS
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.irpef_cr*decode(voec.tipo,'T',-1,1)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'IRPEF_CR'
   and nvl(caaf.irpef_cr,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.irpef_cr_con*decode(voec.tipo,'T',-1,1)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'IRPEF_CRC'
   and nvl(caaf.irpef_cr_con,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.add_reg_dic_cr*decode(voec.tipo,'T',-1,1)
     , to_char(null)
     , to_char(caaf.cod_reg_dic_cr)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'ADD_R_CR'
   and nvl(caaf.add_reg_dic_cr,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.add_reg_con_cr*decode(voec.tipo,'T',-1,1)
     , to_char(null)
     , to_char(caaf.cod_reg_con_cr)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'ADD_R_CRC'
   and nvl(caaf.add_reg_con_cr,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.add_com_dic_cr*decode(voec.tipo,'T',-1,1)
     , caaf.cod_com_dic_cr
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'ADD_C_CR'
   and nvl(caaf.add_com_dic_cr,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.add_com_con_cr*decode(voec.tipo,'T',-1,1)
     , caaf.cod_com_con_cr
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'ADD_C_CRC'
   and nvl(caaf.add_com_con_cr,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.irpef_db*decode(voec.tipo,'C',-1,1)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'IRPEF_DB'
   and nvl(caaf.irpef_db,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.irpef_db_con*decode(voec.tipo,'C',-1,1)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'IRPEF_DBC'
   and nvl(caaf.irpef_db_con,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , round(caaf.irpef_db*decode(voec.tipo,'C',-1,1) * 0.40 / 100,2)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'IRPEF_SINT'
   and nvl(caaf.irpef_db,0) > 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , round(caaf.irpef_db_con*decode(voec.tipo,'C',-1,1) * 0.40 / 100,2)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'IRPEF_SINC'
   and nvl(caaf.irpef_db_con,0) > 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.add_reg_dic_db*decode(voec.tipo,'C',-1,1)
     , to_char(null)
     , to_char(caaf.cod_reg_dic_db)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'ADD_R_DB'
   and nvl(caaf.add_reg_dic_db,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.add_reg_dic_rimb*decode(voec.tipo,'C',-1,1)
     , to_char(null)
     , caaf.cod_reg_dic_rimb
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'ADD_R_DB'
   and nvl(caaf.add_reg_dic_rimb,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.add_reg_dic_add*decode(voec.tipo,'T',-1,1)
     , to_char(null)
     , caaf.cod_reg_dic_add
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'ADD_R_CR'
   and nvl(caaf.add_reg_dic_add,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.add_com_dic_rimb*decode(voec.tipo,'C',-1,1)
     , caaf.cod_com_dic_rimb
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'ADD_C_DB'
   and nvl(caaf.add_com_dic_rimb,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.add_com_dic_add*decode(voec.tipo,'T',-1,1)
     , caaf.cod_com_dic_add
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'ADD_C_CR'
   and nvl(caaf.add_com_dic_add,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.add_reg_con_db*decode(voec.tipo,'C',-1,1)
     , to_char(null)
     , to_char(caaf.cod_reg_con_db)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'ADD_R_DBC'
   and nvl(caaf.add_reg_con_db,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.add_com_dic_db*decode(voec.tipo,'C',-1,1)
     , caaf.cod_com_dic_db
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'ADD_C_DB'
   and nvl(caaf.add_com_dic_db,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.add_com_con_db*decode(voec.tipo,'C',-1,1)
     , caaf.cod_com_con_db
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'ADD_C_DBC'
   and nvl(caaf.add_com_con_db,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.acc_add_com_dic_rimb*decode(voec.tipo,'C',-1,1)
     , caaf.cod_com_acc_dic_rimb
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'ADD_C_AC'
   and nvl(caaf.acc_add_com_dic_rimb,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.acc_add_com_con_rimb*decode(voec.tipo,'C',-1,1)
     , caaf.cod_com_acc_con_rimb
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'ADD_C_ACC'
   and nvl(caaf.acc_add_com_con_rimb,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.irpef_1r*decode(voec.tipo,'C',-1,1)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = decode( sign(caaf.irpef_1r),-1,'IRP_RET_1R','IRPEF_1R')
   and nvl(caaf.irpef_1r,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.irpef_1r_con*decode(voec.tipo,'C',-1,1)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = decode( sign(caaf.irpef_1r_con),-1,'IRP_RET_1C','IRPEF_1RC')
   and nvl(caaf.irpef_1r_con,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , round(caaf.irpef_1r*decode(voec.tipo,'C',-1,1) * 0.40 / 100,2)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'IRPEF_1INT'
   and nvl(caaf.irpef_1r,0) > 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , round(caaf.irpef_1r_con*decode(voec.tipo,'C',-1,1) * 0.40 / 100,2)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'IRPEF_1INC'
   and nvl(caaf.irpef_1r_con,0) > 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.irpef_2r*decode(voec.tipo,'C',-1,1)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = decode( sign(caaf.irpef_2r),-1,'IRP_RET_2R','IRPEF_2R')
   and nvl(caaf.irpef_2r,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.irpef_2r_con*decode(voec.tipo,'C',-1,1)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = decode( sign(caaf.irpef_2r_con),-1,'IRP_RET_2C','IRPEF_2RC')
   and nvl(caaf.irpef_2r_con,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , round(caaf.irpef_2r*decode(voec.tipo,'C',-1,1) * 0.40 / 100 ,2)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'IRPEF_2INT'
   and nvl(caaf.irpef_2r,0) > 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , round(caaf.irpef_2r_con*decode(voec.tipo,'C',-1,1) * 0.40 / 100 ,2)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'IRPEF_2INC'
   and nvl(caaf.irpef_2r_con,0) > 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , caaf.irpef_acconto_ap*decode(voec.tipo,'C',-1,1)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = decode( sign(caaf.irpef_acconto_ap),-1,'IRP_RET_AP','IRPEF_AP')
   and nvl(caaf.irpef_acconto_ap,0) != 0
union
select caaf.anno             
     , caaf.ci           
     , voec.codice 
     , '*'   
     , round(caaf.irpef_acconto_ap*decode(voec.tipo,'C',-1,1) * 0.40 / 100 ,2)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
     , voci_economiche    voec
 where voec.specifica = 'IRPEF_AINT'
   and nvl(caaf.irpef_acconto_ap,0) > 0
union
select caaf.anno             
     , caaf.ci           
     , 'ATTENZIONE: situazione con rateizzazione attiva'
     , '*'   
     , to_number(null)
     , to_char(null)
     , to_char(null)
  from CAAF_RETTIFICATIVI CAAF
 where exists
      (select 'x' from denuncia_caaf
        where anno = caaf.anno
          and ci   = caaf.ci
          and nvl(nr_rate,0) != 0)
/






