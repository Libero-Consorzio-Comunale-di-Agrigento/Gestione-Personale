start crq_digl.sql

alter table denuncia_importi_gla add digl_id NUMBER(10);

update denuncia_importi_gla
set digl_id = digl_sq.NEXTVAL
;
commit
;

alter table denuncia_importi_gla modify digl_id not null
;

drop index digl_pk
;

CREATE UNIQUE INDEX DIGL_PK ON DENUNCIA_IMPORTI_GLA
(DIGL_ID)
;

CREATE INDEX DIGL_UK ON DENUNCIA_IMPORTI_GLA
(ANNO,GESTIONE,CI,MESE)
;

start crp_pecargla.sql


insert into estrazione_valori_contabili
(ESTRAZIONE,COLONNA,dal,al,descrizione,sequenza,note)
select estrazione,'ALIQUOTA_01',dal,al,'Aliquota a scaglioni',sequenza,'<17.80> <18.80>'
  from estrazione_valori_contabili
 where estrazione = 'DENUNCIA_GLA' 
   and colonna = 'ALIQUOTA'
   and al is null
;

insert into estrazione_valori_contabili
(ESTRAZIONE,COLONNA,dal,al,descrizione,sequenza,note)
select estrazione,'CONTRIBUTO_01',dal,al,'Contributo a scaglioni',sequenza,''
  from estrazione_valori_contabili
 where estrazione = 'DENUNCIA_GLA' 
   and colonna = 'CONTRIBUTO'
   and al is null
;

insert into estrazione_valori_contabili
(ESTRAZIONE,COLONNA,dal,al,descrizione,sequenza,note)
select estrazione,'IMPONIBILE_01',dal,al,'Imponibile a scaglioni',sequenza,'<38641>'
  from estrazione_valori_contabili
 where estrazione = 'DENUNCIA_GLA' 
   and colonna = 'IMPONIBILE'
   and al is null
;

