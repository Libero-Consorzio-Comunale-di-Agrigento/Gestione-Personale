-- Inserimento nuovi ref_codes

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'T', 'T', 'EVENTI_INFORTUNIO.INABILITA', 'Temporanea' , 'CFG');
insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'P', 'P', 'EVENTI_INFORTUNIO.INABILITA', 'Permanente' , 'CFG');

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'SI', '1', 'EVENTI_INFORTUNIO.VERO'
       , 'La descrizione dell''infortunio riferita al datore di lavoro risponde a verita''' , 'CFG');
insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'NO', '2', 'EVENTI_INFORTUNIO.VERO'
       ,'La descrizione dell''infortunio riferita al datore di lavoro non risponde a verita''' , 'CFG');

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'SI', '1', 'EVENTI_INFORTUNIO.ESITO_RICORSO', 'Il ricorso e'' stato accolto' , 'CFG');
insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'NO', '2', 'EVENTI_INFORTUNIO.ESITO_RICORSO','Il ricorso e'' stato respinto' , 'CFG');

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'SI', '1', 'EVENTI_INFORTUNIO.RICORSO', 'E'' stato presentato un ricorso' , 'CFG');
insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'NO', '2', 'EVENTI_INFORTUNIO.RICORSO','Non e'' stato presentato un ricorso' , 'CFG');

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'SI', '1', 'EVENTI_INFORTUNIO.RICONOSCIMENTO', 'L''infortunio e'' stato riconosciuto dall''INAIL' , 'CFG');
insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'NO', '2', 'EVENTI_INFORTUNIO.RICONOSCIMENTO' ,'L''infortunio non e'' stato riconosciuto dall''INAIL' , 'CFG');

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'SI', '1', 'EVENTI_INFORTUNIO.LAVORO_CONSUETO', 'L''infortunato stava svolgendo il suo lavoro consueto' , 'CFG');
insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'NO', '2', 'EVENTI_INFORTUNIO.LAVORO_CONSUETO' ,'L''infortunato non stava svolgendo il suo lavoro consueto' , 'CFG');
insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'SS', '3', 'EVENTI_INFORTUNIO.LAVORO_CONSUETO' ,'L''infortunato stava svolgendo un lavoro saltuariamente consueto' , 'CFG');

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'SI', '1', 'EVENTI_INFORTUNIO.ABBANDONO' , 'Si e verificato l''abbandono del posto di lavoro', 'CFG');
insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'NO', '2', 'EVENTI_INFORTUNIO.ABBANDONO' , 'Non si e verificato l''abbandono del posto di lavoro', 'CFG');

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'SI', '1', 'EVENTI_INFORTUNIO.NOTTURNO' , 'L''infortunio e'' avvenuto durante il turno notturno', 'CFG');
insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'NO', '2', 'EVENTI_INFORTUNIO.NOTTURNO' , 'L''infortunio non e'' avvenuto durante il turno notturno', 'CFG');

