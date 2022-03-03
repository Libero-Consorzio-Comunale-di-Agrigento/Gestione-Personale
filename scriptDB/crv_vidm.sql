REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  13-Jan-93 12:40
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM VIEW
REM      VISTA_DEDP_MESI

REM
REM  VISTA_DEDP_MESI
REM
REM  Periodi della tabella denuncia_inpdap mensilizzati
REM
REM  
REM
PROMPT
PROMPT Creating View VISTA_DEDP_MESI
CREATE OR REPLACE FORCE VIEW VISTA_DEDP_MESI
(CI, ANNO, MESE, DAL, AL, INI_MESE, FIN_MESE,
 PREVIDENZA, ASSICURAZIONI, GESTIONE, TIPO_IMPIEGO, TIPO_SERVIZIO, RAP_ORARIO)
AS 
select  dedp.ci
       ,dedp.anno
       ,mesi.mese
    ,greatest(mesi.ini_mese,dedp.dal)
    ,least(mesi.fin_mese,nvl(dedp.al,to_date(3333333,'j')))
    ,mesi.ini_mese
    ,mesi.fin_mese
    ,dedp.previdenza
    ,dedp.assicurazioni
    ,dedp.gestione
    ,dedp.tipo_impiego
    ,dedp.tipo_servizio
    ,dedp.rap_orario
  from  mesi              mesi
       ,denuncia_inpdap   dedp
 where  dedp.dal                          <= mesi.fin_mese
   and  nvl(dedp.al,to_date(3333333,'j')) >= mesi.ini_mese
   and  dedp.rilevanza                     = 'S'
/

COMMENT ON TABLE VISTA_DEDP_MESI
    IS 'Periodi della tabella denuncia_inpdap mensilizzati';

REM
REM  End of command file
REM