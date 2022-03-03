CREATE OR REPLACE VIEW CAAF_RETTIFICATIVI 
      ( ANNO
      , CI
      , CONGUAGLIO_1R
      , CONGUAGLIO_2R
      , NR_RATE
      , DATA_RICEZIONE
      , IRPEF_DB
      , IRPEF_DB_CON
      , IRPEF_CR
      , IRPEF_CR_CON
      , IRPEF_1R
      , IRPEF_2R
      , IRPEF_1R_CON
      , IRPEF_2R_CON
      , IRPEF_ACCONTO_AP
      , IRPEF_ACCONT_AP_CON
      , COD_REG_DIC_DB
      , ADD_REG_DIC_DB
      , COD_REG_CON_DB
      , ADD_REG_CON_DB
      , COD_REG_DIC_CR
      , ADD_REG_DIC_CR
      , COD_REG_CON_CR
      , ADD_REG_CON_CR
      , COD_COM_DIC_DB
      , ADD_COM_DIC_DB
      , COD_COM_CON_DB
      , ADD_COM_CON_DB
      , COD_COM_DIC_CR
      , ADD_COM_DIC_CR
      , COD_COM_CON_CR
      , ADD_COM_CON_CR
      , COD_REG_DIC_RIMB
      , ADD_REG_DIC_RIMB
      , COD_REG_DIC_ADD
      , ADD_REG_DIC_ADD
      , COD_COM_DIC_RIMB
      , ADD_COM_DIC_RIMB
      , COD_COM_DIC_ADD
      , ADD_COM_DIC_ADD
      , COD_COM_ACC_DIC_DB
      , ACC_ADD_COM_DIC_DB
      , COD_COM_ACC_CON_DB
      , ACC_ADD_COM_CON_DB
      , COD_COM_ACC_DIC_RIMB
      , ACC_ADD_COM_DIC_RIMB
      , COD_COM_ACC_CON_RIMB
      , ACC_ADD_COM_CON_RIMB
      , INT_RATE_IRPEF
      , INT_RATE_IRPEF_CON
      , INT_RATE_IRPEF_1R
      , INT_RATE_IRPEF_1R_CON
      , INT_RATE_IRPEF_AP
      , INT_RATE_IRPEF_AP_CON
      , INT_RATE_REG_DIC
      , INT_RATE_REG_CON
      , INT_RATE_COM_DIC
      , INT_RATE_COM_CON
      , INT_RATE_ACC_COM_DIC
      , INT_RATE_ACC_COM_CON
      ) AS	
select caaf.anno             
     , caaf.ci              
     , caaf.conguaglio_1r    
     , caaf.conguaglio_2r  
     , caaf.nr_rate      
     , caaf.data_ricezione          
     , caaf.irpef_db     - nvl(caafm.irpef_db,0)
     , caaf.irpef_db_con - nvl(caafm.irpef_db_con,0)
     , caaf.irpef_cr     - nvl(caafm.irpef_cr,0)       
     , caaf.irpef_cr_con - nvl(caafm.irpef_cr_con,0)
     , caaf.irpef_1r     - nvl(caafm.irpef_1r,0)      
     , caaf.irpef_2r     - nvl(caafm.irpef_2r,0)    
     , caaf.irpef_1r_con - nvl(caafm.irpef_1r_con,0)  
     , caaf.irpef_2r_con - nvl(caafm.irpef_2r_con ,0)  
     , caaf.irpef_acconto_ap                      - nvl(caafm.irpef_acconto_ap,0)
     , caaf.irpef_acconto_ap_con                  - nvl(caafm.irpef_acconto_ap_con,0)
     , to_char(decode( nvl(caaf.add_reg_dic_db,0) - nvl(caafm.add_reg_dic_db,0)
             , 0, 0
                , caaf.cod_reg_dic_db) )                                              COD_REG_DIC_DB
     , decode( nvl(caaf.cod_reg_dic_db,0)
             , nvl(caafm.cod_reg_dic_db,0), nvl(caaf.add_reg_dic_db,0) - nvl(caafm.add_reg_dic_db,0)
                                          , nvl(caaf.add_reg_dic_db,0)           
             )                                                                        ADD_REG_DIC_DB
     , to_char(decode( nvl(caaf.add_reg_con_db,0) - nvl(caafm.add_reg_con_db,0)
             , 0, 0
                , caaf.cod_reg_con_db))                                               COD_REG_CON_DB
     , decode( nvl(caaf.cod_reg_con_db,0)
             , nvl(caafm.cod_reg_con_db,0), nvl(caaf.add_reg_con_db,0) - nvl(caafm.add_reg_con_db,0)
                                          , nvl(caaf.add_reg_con_db,0)
             )                                                                        ADD_REG_CON_DB
     , to_char(decode( nvl(caaf.add_reg_dic_cr,0) - nvl(caafm.add_reg_dic_cr,0)
             , 0, 0
                , caaf.cod_reg_dic_cr) )                                              COD_REG_DIC_CR
     , decode( nvl(caaf.cod_reg_dic_cr,0)
             , nvl(caafm.cod_reg_dic_cr,0), nvl(caaf.add_reg_dic_cr,0) - nvl(caafm.add_reg_dic_cr,0)
                                          , nvl(caaf.add_reg_dic_cr,0)           
             )                                                                        ADD_REG_DIC_CR
     , to_char(decode( nvl(caaf.add_reg_con_cr,0) - nvl(caafm.add_reg_con_cr,0)
             , 0, 0
                , caaf.cod_reg_con_cr))                                               COD_REG_CON_CR
     , decode( nvl(caaf.cod_reg_con_cr,0)
             , nvl(caafm.cod_reg_con_cr,0), nvl(caaf.add_reg_con_cr,0) - nvl(caafm.add_reg_con_cr,0)
                                          , nvl(caaf.add_reg_con_cr,0)
             )                                                                        ADD_REG_CON_CR
     , decode( nvl(caaf.add_com_dic_db,0) - nvl(caafm.add_com_dic_db,0)
             , 0, '0'
                , caaf.cod_com_dic_db)                                                COD_com_DIC_DB
     , decode( nvl(caaf.cod_com_dic_db,0)
             , nvl(caafm.cod_com_dic_db,0), nvl(caaf.add_com_dic_db,0) - nvl(caafm.add_com_dic_db,0)
                                          , nvl(caaf.add_com_dic_db,0)           
             )                                                                        ADD_com_DIC_DB
     , decode( nvl(caaf.add_com_con_db,0) - nvl(caafm.add_com_con_db,0)
             , 0, '0'
                , caaf.cod_com_con_db)                                                COD_com_CON_DB
     , decode( nvl(caaf.cod_com_con_db,0)
             , nvl(caafm.cod_com_con_db,0), nvl(caaf.add_com_con_db,0) - nvl(caafm.add_com_con_db,0)
                                          , nvl(caaf.add_com_con_db,0)
             )                                                                        ADD_com_CON_DB
     , decode( nvl(caaf.add_com_dic_cr,0) - nvl(caafm.add_com_dic_cr,0)
             , 0, '0'
                , caaf.cod_com_dic_cr)                                                COD_com_DIC_CR
     , decode( nvl(caaf.cod_com_dic_cr,0)
             , nvl(caafm.cod_com_dic_cr,0), nvl(caaf.add_com_dic_cr,0) - nvl(caafm.add_com_dic_cr,0)
                                          , nvl(caaf.add_com_dic_cr,0)           
             )                                                                        ADD_com_DIC_CR
     , decode( nvl(caaf.add_com_con_cr,0) - nvl(caafm.add_com_con_cr,0)
             , 0, '0'
                , caaf.cod_com_con_cr)                                                COD_com_CON_CR
     , decode( nvl(caaf.cod_com_con_cr,0)
             , nvl(caafm.cod_com_con_cr,0), nvl(caaf.add_com_con_cr,0) - nvl(caafm.add_com_con_cr,0)
                                          , nvl(caaf.add_com_con_cr,0)
             )                                                                        ADD_com_CON_CR
     , to_char(decode( nvl(caafm.cod_reg_dic_db,0)
                     , nvl(caaf.cod_reg_dic_db,0) , 0
                                                  , nvl(caafm.cod_reg_dic_db,0)
                     ))                                                              COD_REG_DIC_RIMB
     , decode( nvl(caaf.cod_reg_dic_db,0)
             , nvl(caafm.cod_reg_dic_db,0), 0
                                          , nvl(caafm.add_reg_dic_db,0) * -1)        ADD_REG_DIC_RIMB
     , to_char(decode( nvl(caafm.cod_reg_dic_cr,0)
                     , nvl(caaf.cod_reg_dic_cr,0) , 0
                                                  , nvl(caafm.cod_reg_dic_cr,0)
                     ))                                                              COD_REG_DIC_ADD
     , decode( nvl(caaf.cod_reg_dic_cr,0)
             , nvl(caafm.cod_reg_dic_cr,0), 0
                                          , nvl(caafm.add_reg_dic_cr,0)* -1)         ADD_REG_DIC_ADD
     , to_char(decode( nvl(caafm.cod_com_dic_db,'0')
                     , nvl(caaf.cod_com_dic_db,'0') , '0'
                                                  , nvl(caafm.cod_com_dic_db,'0')
                     ))                                                              COD_COM_DIC_RIMB
     , decode( nvl(caaf.cod_com_dic_db,'0')
             , nvl(caafm.cod_com_dic_db,'0'), 0
                                            ,  nvl(caafm.add_com_dic_db,0)* -1)      ADD_com_dic_RIMB
     , to_char(decode( nvl(caafm.cod_com_dic_cr,'0')
                     , nvl(caaf.cod_com_dic_cr,'0') , '0'
                                                  , nvl(caafm.cod_com_dic_cr,'0')
                     ))                                                              COD_REG_DIC_ADD
     , decode( nvl(caaf.cod_com_dic_cr,'0')
             , nvl(caafm.cod_com_dic_cr,'0'), 0
                                            ,  nvl(caafm.add_com_dic_cr,0)* -1)      ADD_com_dic_ADD
     , decode( nvl(caaf.acc_add_com_dic_db,0) - nvl(caafm.acc_add_com_dic_db,0)
             , 0, '0'
                , caaf.cod_com_acc_dic_db)                                            COD_COM_ACC_DIC_DB
     , decode( nvl(caaf.cod_com_acc_dic_db,0)
             , nvl(caafm.cod_com_acc_dic_db,0), nvl(caaf.acc_add_com_dic_db,0) - nvl(caafm.acc_add_com_dic_db,0)
                                          , nvl(caaf.acc_add_com_dic_db,0)           
             )                                                                        ACC_ADD_COM_DIC_DB
     , decode( nvl(caaf.acc_add_com_con_db,0) - nvl(caafm.acc_add_com_con_db,0)
             , 0, '0'
                , caaf.cod_com_acc_con_db)                                            COD_com_ACC_CON_DB
     , decode( nvl(caaf.cod_com_acc_con_db,0)
             , nvl(caafm.cod_com_acc_con_db,0), nvl(caaf.acc_add_com_con_db,0) - nvl(caafm.acc_add_com_con_db,0)
                                              , nvl(caaf.acc_add_com_con_db,0)
             )                                                                        ACC_ADD_COM_CON_DB
     , to_char(decode( nvl(caafm.cod_com_acc_dic_db,'0')
                     , nvl(caaf.cod_com_acc_dic_db,'0') , '0'
                                                  , nvl(caafm.cod_com_acc_dic_db,'0')
                     ))                                                                COD_COM_ACC_DIC_RIMB
     , decode( nvl(caaf.cod_com_acc_dic_db,'0')
             , nvl(caafm.cod_com_acc_dic_db,'0'), 0
                                            ,  nvl(caafm.acc_add_com_dic_db,0)* -1)    ADD_COM_ACC_DIC_RIMB
     , to_char(decode( nvl(caafm.cod_com_acc_con_db,'0')
                     , nvl(caaf.cod_com_acc_con_db,'0') , '0'
                                                  , nvl(caafm.cod_com_acc_con_db,'0')
                     ))                                                                COD_COM_ACC_CON_RIMB
     , decode( nvl(caaf.cod_com_acc_con_db,'0')
             , nvl(caafm.cod_com_acc_con_db,'0'), 0
                                            ,  nvl(caafm.acc_add_com_con_db,0)* -1)    ADD_COM_ACC_CON_RIMB
     , caaf.int_rate_irpef        - nvl(caafm.int_rate_irpef,0)
     , caaf.int_rate_irpef_con    - nvl(caafm.int_rate_irpef_con,0)
     , caaf.int_rate_irpef_1r     - nvl(caafm.int_rate_irpef_1r,0)      
     , caaf.int_rate_irpef_1r_con - nvl(caafm.int_rate_irpef_1r_con,0)   
     , caaf.int_rate_irpef_ap     - nvl(caafm.int_rate_irpef_ap,0)           
     , caaf.int_rate_irpef_ap_con - nvl(caafm.int_rate_irpef_ap_con,0)       
     , caaf.int_rate_reg_dic      - nvl(caafm.int_rate_reg_dic,0)       
     , caaf.int_rate_reg_con      - nvl(caafm.int_rate_reg_con,0)          
     , caaf.int_rate_com_dic      - nvl(caafm.int_rate_com_dic ,0)   
     , caaf.int_rate_com_con      - nvl(caafm.int_rate_com_con,0)   
     , caaf.int_rate_acc_com_dic  - nvl(caafm.int_rate_acc_com_dic ,0)   
     , caaf.int_rate_acc_com_con  - nvl(caafm.int_rate_acc_com_con,0)   
  from denuncia_caaf caafm
     , (select anno             
             , ci              
             , max(nr_rate)                       nr_rate
             , max(data_ricezione)                data_ricezione      
             , nvl(sum(irpef_db),0)               irpef_db
             , nvl(sum(irpef_db_con),0)           irpef_db_con
             , nvl(sum(irpef_cr),0)               irpef_cr
             , nvl(sum(irpef_cr_con),0)           irpef_cr_con
             , nvl(sum(irpef_1r),0)               irpef_1r      
             , nvl(sum(irpef_2r),0)               irpef_2r    
             , max(conguaglio_1r)                 conguaglio_1r
             , max(conguaglio_2r)                 conguaglio_2r
             , nvl(sum(irpef_acconto_ap),0)       irpef_acconto_ap
             , nvl(sum(int_rate_irpef),0)         int_rate_irpef
             , nvl(sum(int_rate_irpef_con),0)     int_rate_irpef_con
             , nvl(sum(irpef_acconto_ap_con),0)   irpef_acconto_ap_con
             , nvl(sum(int_rate_irpef_1r),0)      int_rate_irpef_1r  
             , nvl(sum(int_rate_irpef_ap),0)      int_rate_irpef_ap        
             , nvl(sum(int_rate_irpef_ap_con),0)  int_rate_irpef_ap_con       
             , nvl(sum(int_rate_reg_dic),0)       int_rate_reg_dic       
             , nvl(sum(int_rate_reg_con),0)       int_rate_reg_con             
             , max(cod_reg_dic_db)                cod_reg_dic_db         
             , nvl(sum(add_reg_dic_db),0)         add_reg_dic_db
             , max(cod_reg_con_db)                cod_reg_con_db              
             , nvl(sum(add_reg_con_db),0)         add_reg_con_db         
             , max(cod_reg_dic_cr)                cod_reg_dic_cr       
             , nvl(sum(add_reg_dic_cr),0)         add_reg_dic_cr         
             , max(cod_reg_con_cr)                cod_reg_con_cr      
             , nvl(sum(add_reg_con_cr),0)         add_reg_con_cr         
             , nvl(sum(int_rate_com_dic),0)       int_rate_com_dic
             , nvl(sum(int_rate_com_con),0)       int_rate_com_con        
             , max(cod_com_dic_db)                cod_com_dic_db         
             , nvl(sum(add_com_dic_db),0)         add_com_dic_db     
             , max(cod_com_con_db)                cod_com_con_db      
             , nvl(sum(add_com_con_db),0)         add_com_con_db    
             , max(cod_com_dic_cr)                cod_com_dic_cr       
             , nvl(sum(add_com_dic_cr),0)         add_com_dic_cr               
             , max(cod_com_con_cr)                cod_com_con_cr                
             , nvl(sum(add_com_con_cr),0)         add_com_con_cr
             , max(cod_com_acc_dic_db)            cod_com_acc_dic_db
             , nvl(sum(acc_add_com_dic_db),0)     acc_add_com_dic_db
             , max(cod_com_acc_con_db)            cod_com_acc_con_db
             , nvl(sum(acc_add_com_con_db),0)     acc_add_com_con_db
             , nvl(sum(irpef_1r_con),0)           irpef_1r_con           
             , nvl(sum(irpef_2r_con),0)           irpef_2r_con              
             , nvl(sum(int_rate_irpef_1r_con),0)  int_rate_irpef_1r_con    
             , nvl(sum(int_rate_acc_com_dic),0)   int_rate_acc_com_dic
             , nvl(sum(int_rate_acc_com_con),0)   int_rate_acc_com_con
          from denuncia_caaf 
         where anno  = (select anno from riferimento_fine_anno)
           and rettifica in ('B','D','F','H','T')
         group by anno,ci
       ) caaf
 where caafm.anno      = (select anno from riferimento_fine_anno)
   and caaf.ci         = caafm.ci   
   and caafm.rettifica = 'M'
/
