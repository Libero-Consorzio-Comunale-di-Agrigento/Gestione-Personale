REM ============================================================
REM  Alter Table  KEY_CONSTRAINT_ERROR
REM ============================================================
-- WHEN ERROR IGNORE 1430
alter table KEY_CONSTRAINT_ERROR
add precisazione varchar2(2000)
/
/*==============================================================*/
/* Aggiunge colonna error_id a table KEY_ERROR_LOG se non       */
/* esistente.                                                   */
/*==============================================================*/
-- WHEN ERROR IGNORE 1430
alter table KEY_ERROR_LOG add (error_id number)
/
/*==============================================================*/
/* Valorizza colonna error_id di KEY_ERROR_LOG se nulla.        */
/*==============================================================*/
declare
   d_id number := 0;
begin
   select count(1)
     into d_id
     from KEY_ERROR_LOG
    where error_id is null
   ;
   if d_id > 0 then
      d_id := 0;
      for c_keel in (select rowid
                       from KEY_ERROR_LOG)
      loop
         d_id := d_id + 1;
         update KEY_ERROR_LOG
            set error_id = d_id
          where rowid = c_keel.rowid
         ;
      end loop;
      commit;
   end if;
end;
/
/*==============================================================*/
/* Aggiunge NOT NULL a colonna error_id di KEY_ERROR_LOG.       */
/*==============================================================*/
-- WHEN ERROR IGNORE 1442
alter table KEY_ERROR_LOG modify (error_id number not null)
/
/*==============================================================*/
/* CREA sequence KEEL_SQ se non esistente                       */
/*==============================================================*/
column c1 NOPRINT new_value P1
select nvl(max(nvl(error_id, 0)),0) + 1 c1
  from key_error_log
;
-- WHEN ERROR IGNORE 955   
CREATE SEQUENCE keel_sq
     START WITH &P1
       MINVALUE 1
        NOCYCLE
          CACHE 20
        NOORDER
/
/*==============================================================*/
/* Aggiunge indice KEEL_PK table KEY_ERROR_LOG se non esistente.*/
/*==============================================================*/
-- WHEN ERROR IGNORE 2260
alter table KEY_ERROR_LOG add constraint KEEL_PK primary key (ERROR_ID)
/
/*==============================================================*/
/* Aggiunge colonna error_session a table KEY_ERROR_LOG         */
/* se non esistente, la riempie con i valori della colonna      */
/* session_error e droppa quest'ultima.                         */
/*==============================================================*/
-- WHEN ERROR IGNORE 1430
alter table KEY_ERROR_LOG add (error_session number)
/
-- WHEN ERROR IGNORE 904
update KEY_ERROR_LOG
   set error_session = session_error
/
commit;
-- WHEN ERROR IGNORE 904,905
alter table KEY_ERROR_LOG drop column session_error
/
-- WHEN ERROR IGNORE 24344
start ver\AFC\KC\key_error_log_tiu.trg