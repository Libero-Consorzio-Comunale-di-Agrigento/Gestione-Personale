declare 
V_controllo varchar2(1);
V_comando  varchar2(100);
BEGIN
 BEGIN
  select 'Y' 
    into V_controllo
    from dual
   where exists ( select 'x' from obj 
                   where object_name in 
                     ( 'DEMI_PRIMA_DELLA_11038'
                     , 'SEIE_PRIMA_DELLA_11038'
                     , 'DAPE_PRIMA_DELLA_11038'
                     , 'VAIE_PRIMA_DELLA_11038'
                     , 'FOSE_PRIMA_DELLA_11038'
                     )
                 );
 EXCEPTION WHEN NO_DATA_FOUND THEN V_controllo := 'X';
 END;
 IF V_controllo = 'Y' THEN NULL;
 ELSE
   V_comando := 'create table demi_prima_della_11038 as select * from denuncia_emens';
   si4.sql_execute(V_comando);
   V_comando := 'create table seie_prima_della_11038 as select * from settimane_emens';
   si4.sql_execute(V_comando);
   V_comando := 'create table dape_prima_della_11038 as select * from dati_particolari_emens';
   si4.sql_execute(V_comando);
   V_comando := 'create table vaie_prima_della_11038 as select * from variabili_emens';
   si4.sql_execute(V_comando);
   V_comando := 'create table fose_prima_della_11038 as select * from fondi_speciali_emens';
   si4.sql_execute(V_comando);
 END IF;
END;
/
-- inserita nel file A10978
-- start crp_cursore_emens.sql
-- start crp_peccadmi.sql