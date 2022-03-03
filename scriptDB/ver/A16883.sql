alter table denuncia_eventi_onaosi
modify data date null;

update pec_ref_codes
   set rv_meaning = 'Uscita per aspettativa non retribuita'
 where rv_domain  = 'DENUNCIA_ONAOSI.EVENTO'
   and rv_low_value = '11';

update pec_ref_codes
   set rv_meaning = 'Rientro per aspettativa non retribuita'
 where rv_domain  = 'DENUNCIA_ONAOSI.EVENTO'
   and rv_low_value = '12';

insert into pec_ref_codes
       (rv_domain,rv_low_value,rv_meaning)
values ('DENUNCIA_ONAOSI.EVENTO','21','Adeguamento contrattuale derivante da nuovo C.C.N.L.');

insert into pec_ref_codes
       (rv_domain,rv_low_value,rv_meaning)
values ('DENUNCIA_ONAOSI.EVENTO','22','Adeguamento contrattuale derivante da nuovo C.C.N.L. (dipendenti cessati)');

insert into pec_ref_codes
       (rv_domain,rv_low_value,rv_meaning)
values ('DENUNCIA_ONAOSI.EVENTO','23','Restituzione a seguito delibera n.32/05 (dipendenti cessati)');

insert into a_selezioni
       (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,dominio)
values ('P_CONTRATTO','PECCARDO',6,'Applicazione nuovo contratto',1,'U','N','P_X');

start crp_peccardo.sql
