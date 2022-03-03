REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  13-Jan-93 12:40
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM VIEW
REM      VALORI_CONTABILI_MENSILI

REM
REM  VALORI_CONTABILI_MENSILI
REM
REM  Valori contabili estratti dalla mensilita` retributiva
REM
REM  
REM
PROMPT
PROMPT Creating View VALORI_CONTABILI_MENSILI
CREATE OR REPLACE VIEW valori_contabili_mensili
(
     estrazione
    ,ci
    ,anno
    ,mese
    ,mensilita
    ,colonna
    ,sequenza
    ,voce
    ,sub
    ,riferimento
    ,competenza
    ,arr
    ,input
    ,moco_rowid
    ,valore
    ,ipn_p
    ,ipn_eap
)
AS SELECT
       esrc.estrazione                                 
     , mofi.ci                                         
     , mofi.anno                                       
     , mofi.mese                                       
     , mofi.mensilita                                  
     , esrc.colonna                                    
     , esrc.sequenza                                   
     , esrc.voce                                       
     , esrc.sub                                        
     , prco.riferimento                                
     , prco.competenza                                
     , prco.arr
     , prco.input                                
     , prco.moco_rowid
     , ( decode( esrc.tipo                             
               , 'Q', nvl(prco.qta,0)                  
               , 'T', decode
                      ( esrc.anno
                      , 'K', decode( prco.ipn_p
                                   , null, nvl(prco.tar,0)
                                         , nvl(prco.tar,0)
                                         - nvl(prco.ipn_eap,prco.ipn_p)
                                   )
                      , 'S', decode( prco.classe
                                   , 'R' , decode( prco.ipn_p
                                                 , null, nvl(prco.tar,0)
                                                       , nvl(prco.ipn_eap,prco.ipn_p)
                                                 )
                                     , nvl(prco.tar,0)
                                   )
                      , 'M', decode( prco.ipn_p
                                   , null, nvl(prco.tar,0)
                                         , nvl(prco.tar,0)
                                         - nvl(prco.ipn_eap,prco.ipn_p)
                                   )
                      , 'U', decode( to_char(prco.riferimento,'mmyyyy')
                                   , lpad(prco.mese,2,'0')||to_char(prco.anno), nvl(prco.tar,0)
                                                                              , 0
                                   )
                      , 'D', decode( to_char(prco.riferimento,'mmyyyy')
                                   , lpad(prco.mese,2,'0')||to_char(prco.anno), 0
                                                                              , nvl(prco.tar,0)
                                   )
                           , nvl(prco.tar,0)
                      )
               , 'I', decode( esrc.anno
                            , 'K', nvl(prco.imp,0) - nvl(prco.ipn_p,0)
                            , 'S', decode( prco.classe
                                         , 'R' , nvl(prco.ipn_p,0)
                                               , nvl(prco.imp,0)
                                         )
                            , 'M', nvl(prco.imp,0) - nvl(prco.ipn_p,0)
                            , 'U', decode( to_char(prco.riferimento,'mmyyyy')
                                         , lpad(prco.mese,2,'0')||to_char(prco.anno), nvl(prco.imp,0)
                                                                                    , 0
                                         )
                            , 'D', decode( to_char(prco.riferimento,'mmyyyy')
                                         , lpad(prco.mese,2,'0')||to_char(prco.anno), 0
                                                                                    , nvl(prco.imp,0)
                                         )
                                 , nvl(prco.imp,0)
                            )
               , 'M', nvl(prco.p_qta,0)                
               , 'R', decode
                      ( esrc.anno
                      , 'K', decode( prco.ipn_p
                                   , null, nvl(prco.p_tar,0)
                                         , nvl(prco.p_tar,0)
                                         - nvl(prco.p_ipn_eap,prco.p_ipn_p)
                                   )
                      , 'S', decode( prco.classe
                                   , 'R' , decode
                                           ( prco.ipn_p
                                           , null, nvl(prco.p_tar,0)
                                                 , nvl(prco.p_ipn_eap,prco.p_ipn_p)
                                           )
                                     , nvl(prco.p_tar,0)
                                   )
                      , 'M', decode( prco.ipn_p
                                   , null, nvl(prco.p_tar,0)
                                         , nvl(prco.p_tar,0)
                                         - nvl(prco.p_ipn_eap,prco.p_ipn_p)
                                   )
                      , 'U', decode( to_char(prco.riferimento,'mmyyyy')
                                   , lpad(prco.mese,2,'0')||to_char(prco.anno), nvl(prco.p_tar,0)
                                                                              , 0
                                   )
                      , 'D', decode( to_char(prco.riferimento,'mmyyyy')
                                   , lpad(prco.mese,2,'0')||to_char(prco.anno), 0
                                                                              , nvl(prco.p_tar,0)
                                   )
                           , nvl(prco.p_tar,0)
                      )
               , 'P', decode( esrc.anno
                            , 'K', nvl(prco.p_imp,0) - nvl(prco.p_ipn_p,0)
                            , 'S', decode( prco.classe
                                         , 'R' , nvl(prco.p_ipn_p,0)
                                               , nvl(prco.p_imp,0)
                                         )
                            , 'M', nvl(prco.p_imp,0) - nvl(prco.p_ipn_p,0)
                            , 'U', decode( to_char(prco.riferimento,'mmyyyy')
                                         , lpad(prco.mese,2,'0')||to_char(prco.anno), nvl(prco.p_imp,0)
                                                                                    , 0
                                         )
                            , 'D', decode( to_char(prco.riferimento,'mmyyyy')
                                         , lpad(prco.mese,2,'0')||to_char(prco.anno), 0
                                                                                    , nvl(prco.p_imp,0)
                                         )
                                 , nvl(prco.p_imp,0)
                            )
               , 'C', nvl(prco.p_imp,0) - nvl(prco.p_ipn_p,0)
               , 'A', nvl(prco.p_ipn_p,0)              
               , 'E', nvl(prco.p_ipn_eap,0)            
                    , 0                                
               ) * decode(esrc.segno1,'*',esrc.dato1,'%',esrc.dato1,1)
                 / decode(esrc.segno1,'/',esrc.dato1,'%',100,1)
                 + decode(esrc.segno1,'+',esrc.dato1,'-',esrc.dato1*-1,0)
       ) * decode(esrc.segno2,'*',esrc.dato2,'%',esrc.dato2,1)
         / decode(esrc.segno2,'/',esrc.dato2,'%',100,1)
         + decode(esrc.segno2,'+',esrc.dato2,'-',esrc.dato2*-1,0)
     , prco.p_ipn_p    * decode(esrc.segno2,'*',esrc.dato2,'%',esrc.dato2,1)
                       / decode(esrc.segno2,'/',esrc.dato2,'%',100,1)
                       + decode(esrc.segno2,'+',esrc.dato2,'-',esrc.dato2*-1,0)   p_ipn_p
     , prco.p_ipn_eap  * decode(esrc.segno2,'*',esrc.dato2,'%',esrc.dato2,1)
                       / decode(esrc.segno2,'/',esrc.dato2,'%',100,1)
                       + decode(esrc.segno2,'+',esrc.dato2,'-',esrc.dato2*-1,0)   p_ipn_eap
FROM
    estrazione_righe_contabili  esrc,
    progressivi_contabili  prco,
    movimenti_fiscali  mofi
 where prco.ci        = mofi.ci
   and prco.anno      = mofi.anno
   and prco.mese      = mofi.mese
   and prco.mensilita = mofi.mensilita
   and prco.voce  = esrc.voce
   and prco.sub   = esrc.sub
   and last_day(to_date(to_char(prco.moco_mese)||'/'||to_char(prco.anno),'mm/yyyy'))
                   between esrc.dal
                       and nvl(esrc.al,to_date('3333333','j'))
   and nvl(prco.arr,' ') =
                decode
                ( esrc.anno
                , 'C', decode
                       ( to_char(prco.riferimento,'yyyy')
                       , to_char(prco.anno), nvl(prco.arr,' ')
                                           , null
                       )
                , 'P', decode
                       ( to_char(prco.riferimento,'yyyy')
                       , to_char(prco.anno), null
                                           , nvl(prco.arr,' ')
                       )
                , 'M', decode
                       ( prco.classe
                       ,'R',null
                           ,' '
                       )
                , 'S', decode
                       ( prco.classe
                       ,'R',decode
                                 ( nvl(prco.p_ipn_p,0)
                                 , 0, null
                                    , nvl(prco.arr,' ')
                                 )
                           ,'P'
                       )
                , 'K', decode
                       ( prco.classe
                       ,'R',decode
                                 ( nvl(prco.p_ipn_p,0)-nvl(prco.p_imp,0)
                                 , 0, null
                                    , nvl(prco.arr,' ')
                                 )
                           ,'C'
                       )
                , 'A', prco.arr
                     , nvl(prco.arr,' ')
                )
;

COMMENT ON TABLE valori_contabili_mensili
    IS 'Valori contabili estratti dalla mensilita` retributiva';

REM
REM  End of command file
REM