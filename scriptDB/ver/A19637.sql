start crp_pecsmcud.sql
-- start crp_peccarfi.sql inclusa in A19350

update SCADENZE_DENUNCE
   set data_scadenza = decode( codice
                             , 'CUD', to_date('15032007','ddmmyyyy')
                             , '770', to_date('30092007','ddmmyyyy')
                                    , data_scadenza )
 where codice in ('CUD','770');

insert into SCADENZE_DENUNCE ( CODICE, DATA_SCADENZA, DATA_FORZATURA, UTENTE,DATA_AGG ) 
select 'CUD', to_date('15032007','ddmmyyyy'), NULL,NULL,NULL
  from dual
 where not exists (select 'x' from scadenze_denunce where codice = 'CUD');
 
insert into SCADENZE_DENUNCE ( CODICE, DATA_SCADENZA, DATA_FORZATURA, UTENTE,DATA_AGG ) 
select '770',to_date('30092007','ddmmyyyy'), NULL,NULL,NULL
  from dual
 where not exists (select 'x' from scadenze_denunce where codice = '770');

update RIFERIMENTO_FINE_ANNO 
   set tipo_denuncia = 'C'
 where tipo_denuncia = 'S'
;
INSERT INTO CASELLE_FISCALI
( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA, CASELLA_DETT )
VALUES ( 2006, 'C', 62, '770: Casella 67', 'D', NULL);
