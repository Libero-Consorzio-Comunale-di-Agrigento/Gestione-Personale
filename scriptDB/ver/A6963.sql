-- A6963
column C1 noprint new_value P1

select count(*) C1   from anagrafici  where al is null;

start crt_pedo.sql &P1
start crt_calo.sql
start crf_PEGI_PEDO_TMA.sql
start crf_PEGI_DOES_TMA.sql
start crf_COST_PEDO_TMA.sql
start crf_FIGI_PEDO_TMA.sql
start crf_POSI_PEDO_TMA.sql
start crf_QUGI_PEDO_TMA.sql
start crf_UNOR_PEDO_TMA.sql
start crf_UNOR_REUO_TMA.sql
start crp_GP4_SUST.sql           --pulizia commenti
start crp_GP4_REDO.sql           
start crp_GP4_POSI.sql
start crp_GP4_QUGI.sql
start crp_GP4_STAM.SQL           --pulizia commenti
start crp_GP4_UNOR.SQL           --pulizia commenti
start crp_GP4_PEGI.SQL           --pulizia commenti
start crp_GP4_PEDO.SQL           -- nuovo
-- incluso nel file A6944
-- start crp_GP4GM.sql

-- per poter eseguire le modifiche successive gli oggetti di DB devono 
-- essere tutti correttamente compilati
--
BEGIN
    utilitypackage.compile_all;
END;
/

-- Elimina le revisioni Obsolete create sulla base della vecchia Pianta Organica
-- lasciando solo la revisione attiva e la max delle obsolete
-- al fine di evitare troppe registrazioni inutili in PEDO

create table redo_revisione_DO05 as
select * from revisioni_dotazione
;
create table door_revisione_DO05 as
select * from dotazione_organica
;
alter table dotazione_organica disable all triggers;
alter table revisioni_dotazione disable all triggers;

-- Il test sull'utente e sulla data di aggiornamento evita di toccare revisioni
-- inserite a mano o modificate dopo la migrazione del DB
BEGIN
FOR CUR_REV IN (select revisione
                 from revisioni_dotazione
                where utente = 'Aut.POPI'
                  and data_Agg <= to_date('31012004','ddmmyyyy')
                  and stato = 'O'
                  and (dal,data) != (select max(dal),max(dal) from revisioni_dotazione
                                      where utente = 'Aut.POPI'
                                        and data_Agg <= to_date('31012004','ddmmyyyy')
                                        and stato = 'O')
              )
LOOP
BEGIN

delete from dotazione_organica
where revisione = CUR_REV.revisione
;
commit;
delete from revisioni_dotazione
where revisione = CUR_REV.revisione
and not exists (select 'x' from dotazione_organica 
                 where revisione = CUR_REV.revisione
               )
;
END;

commit;

END LOOP;
END;
/

alter table dotazione_organica enable all triggers;
alter table revisioni_dotazione enable all triggers;

declare
v_versione varchar2(1);
v_comando  varchar2(500);
v_conta    number;
BEGIN
  BEGIN
-- estrazione della versione
  select '7'
    into v_versione
    from v$version
   where instr(upper(banner),'RELEASE')>0
     and substr(banner,7,1) = '7'
     and substr(banner,instr(upper(banner),'RELEASE ')+8,1)= '7'
      ;
   exception
   when no_data_found then
        v_versione := '8';
   END;
 IF v_versione = '7' THEN NULL;
 ELSE
   si4.sql_execute('alter trigger PEGI_PEDO_TMA enable');
   si4.sql_execute('alter trigger PEGI_DOES_TMA enable');
   si4.sql_execute('alter trigger PEGI_SOGI_TMA enable');
   BEGIN
   select counT(*) 
     into V_conta
     from periodi_dotazione
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN V_conta := 0;
   END;
   IF V_conta = 0 THEN
/* 
 popolamento tabella PERIODI_DOTAZIONE tramite l'attivazione del trigger PEGI_PEDO_TMA;
 l'insert e' stata modificata in quanto serve nel primo loop del trigger di calcolo di PEDO
*/
   v_comando := 'truncate table periodi_dotazione';
   si4.sql_execute(v_comando);
   v_comando := 'insert into periodi_dotazione
                (ci,rilevanza,dal,revisione)
                select pegi.ci,pegi.rilevanza,pegi.dal,redo.revisione
                  from periodi_giuridici pegi
                     , revisioni_dotazione redo
                 where pegi.rilevanza in (''Q'',''S'',''I'',''E'') ';
   si4.sql_execute(v_comando);
   v_comando := ' update periodi_giuridici set ci = ci
                   where rilevanza in (''Q'',''S'',''I'',''E'') ';
   si4.sql_execute(v_comando);
   END IF;
 END IF;
END;
/
