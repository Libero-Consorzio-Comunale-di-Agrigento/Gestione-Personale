insert into pec_ref_codes (rv_domain,rv_low_value,rv_meaning)
values ('INFORMAZIONI_RETRIBUTIVE.SOSPENSIONE','97','Saldo debito a Cessazione (trattenuta sempre)');

insert into pec_ref_codes (rv_domain,rv_low_value,rv_meaning)
values ('INFORMAZIONI_RETRIBUTIVE.SOSPENSIONE','98','Saldo debito a Cessazione (trattenuta se minimo gg. 1)');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo)
values ('PECCRAAD','3','Stampa Caricamento Rate Addizionali','Q','ACACANAS');

start crp_peccmore4.sql
-- start crp_peccraad.sql inclusa in A20420