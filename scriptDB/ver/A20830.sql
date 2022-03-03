start crp_pecsmt12.sql
start crp_pecsmt13.sql
start crp_pecssnsm.sql
start crp_pecssnrf.sql

DECLARE
V_esiste   varchar2(1);
v_comando  varchar2(100);
BEGIN
BEGIN
  select 'X' 
    into V_esiste 
    from dual
   where exists ( select 'x' from obj 
                   where object_name like 'SMIM_T13_ANTE_A20830'
                );
EXCEPTION WHEN NO_DATA_FOUND THEN V_esiste := '';
END;
IF V_esiste = 'X' THEN NULL;
ELSE
  V_comando := 'create table SMIM_T13_ANTE_A20830 as select * from smt_importi';
  si4.sql_execute(V_comando);
END IF;
END;
/

update smt_importi 
   Set colonna = decode( colonna,'COL1' ,'01' ,
				 'COL2' ,'02' ,
				 'COL3' ,'03' ,
				 'COL4' ,'04' ,
				 'COL5' ,'05' ,
				 'COL6' ,'06' ,
				 'COL7' ,'07' ,
				 'COL8' ,'08' ,
				 'COL9' ,'09' ,
				 'COL10','10' ,
         			 'COL11','11' ,
				 'COL12','12' ,
				 'COL13','13'
				        , colonna
                      )
where tabella in ( 'T13', 'T13S' );

DECLARE
V_esiste   varchar2(1);
v_comando  varchar2(100);
BEGIN
BEGIN
  select 'X' 
    into V_esiste 
    from dual
   where exists ( select 'x' from obj 
                   where object_name like 'SMIM_T12_ANTE_A20830'
                );
EXCEPTION WHEN NO_DATA_FOUND THEN V_esiste := '';
END;
IF V_esiste = 'X' THEN NULL;
ELSE
  V_comando := 'create table SMIM_T12_ANTE_A20830 as select * from smt_importi';
  si4.sql_execute(V_comando);
END IF;
END;   
/       

update smt_importi 
   Set colonna = decode( colonna,'COL1' ,'GG' ,
				 'COL2' ,'STIPENDI' ,
				 'COL3' ,'IIS' ,
				 'COL4' ,'RIA' ,
				 'COL5' ,'13A' ,
				 'COL6' ,'ARRETRATI' ,
				 'COL7' ,'ARRETRATI_AP' ,
				 'COL8' ,'INDENNITA' ,
				 'COL9' ,'RECUPERI' 
				        , colonna
                       )
where tabella in ( 'T12' );

update estrazione_valori_contabili 
   set descrizione = colonna||' '||descrizione
 where estrazione  = 'SMT_TAB8A'
   and descrizione is null;

update estrazione_valori_contabili 
   set sequenza = decode( colonna
                        , 'STIPENDI', 2
                        , 'IIS', 3
                        , 'RIA', 4
                        , '13A', 5
                        , 'ARRETRATI' , 6
                        , 'ARRETRATI_AP', 7
                        , 'INDENNITA', 8
                        , 'RECUPERI', 9
                                    , sequenza
                        )
 where estrazione  = 'SMT_TAB8A';

insert into estrazione_valori_contabili
(ESTRAZIONE,COLONNA,dal,al,descrizione,sequenza,note)
select estrazione,'GG',dal,null,'Mensilita',1,''
  from estrazione_valori_contabili esvc
 where estrazione = 'SMT_TAB8A' 
   and colonna = 'STIPENDI'
   and dal in ( select min(dal) 
                  from estrazione_valori_contabili
                 where estrazione = 'SMT_TAB8A' 
                   and colonna = 'STIPENDI'
              )
   and not exists ( select 'x'
                      from estrazione_valori_contabili
                     where estrazione = 'SMT_TAB8A' 
                       and colonna = 'GG'
                       and dal = esvc.dal
                  )
/
