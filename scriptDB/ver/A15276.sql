-- Inserimento nuovi codici di errore per Revisione GP Plus
insert into a_errori ( errore, descrizione)
values ( 'P04099','Esistono insiemi di voci contabili intersecanti');

insert into a_errori ( errore, descrizione ) 
values ('P05473' , 'Individuo non archiviato.'||chr(10)||'Anno incongruente con quello di denuncia.');

insert into a_errori ( errore, descrizione ) 
values ('P00560' , 'La data di abbandono non può essere inferiore alla data dell''infortunio');

insert into a_errori ( errore, descrizione ) 
values ('P00561' , 'La data di rientro non può essere inferiore alla data di abbandono');

insert into a_errori ( errore, descrizione ) 
values ('P00562' , 'La data di comunicazione non può essere inferiore alla data infortunio');

insert into a_errori ( errore, descrizione ) 
values ('P00563' , 'La data ricezione non può essere inferiore alla data dell''infortunio');

insert into a_errori ( errore, descrizione ) 
values ('P00564' , 'La data riconoscimento non può essere inferiore alla data infortunio');

insert into a_errori ( errore, descrizione ) 
values ('P00565' , 'La data ricorso non può essere inferiore alla data dell''infortunio');

insert into a_errori ( errore, descrizione ) 
values ('P00566' , 'La data convalida non può essere inferiore alla data dell''infortunio');

insert into a_errori ( errore, descrizione ) 
values ('P00567' , 'Esistono dettagli per questa causa');

insert into a_errori ( errore, descrizione ) 
values ('P05980', 'Inserire almeno uno tra i seguenti campi:'||chr(10)||'settore,sede,cdc,funzionale');


-- Inserimento nuovi ref_codes per Revisione GP Plus

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'PB', 'PB', 'EVENTI_INFORTUNIO.PROGNOSI', 'Prognosi Buona' , 'CFG');

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'GG', 'GG', 'EVENTI_INFORTUNIO.PROGNOSI', 'Giorni' , 'CFG');

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'RI', 'RI', 'EVENTI_INFORTUNIO.PROGNOSI', 'Ricovero' , 'CFG');

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'T', 'T', 'EVENTI_INFORTUNIO.RISARCIMENTO', 'Totale', 'CFG'); 

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'P', 'P', 'EVENTI_INFORTUNIO.RISARCIMENTO', 'Parziale', 'CFG'); 

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'A', 'A', 'EVENTI_INFORTUNIO.RISARCIMENTO', 'Acconto', 'CFG'); 

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'C', 'C', 'EVENTI_INFORTUNIO.RISARCIMENTO', 'Conguaglio', 'CFG'); 

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'S', 'S', 'EVENTI_INFORTUNIO.RISARCIMENTO', 'Saldo', 'CFG'); 

insert into PEC_REF_CODES 
( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE )
values ( 'R', 'R', 'EVENTI_INFORTUNIO.RISARCIMENTO', 'Ricaduta', 'CFG');