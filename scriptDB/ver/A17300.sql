-- cancellazione voce di menu PECLV70D

delete from a_voci_menu where voce_menu = 'PECLV70D';
delete from a_passi_proc where voce_menu = 'PECLV70D';
delete from a_selezioni where voce_menu = 'PECLV70D';
delete from a_menu where voce_menu = 'PECLV70D';

-- inserimento nuovo parametro e passo del report in PECCASFI

delete from a_passi_proc where voce_menu = 'PECCASFI';

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCASFI','1','Verifica Scadenza denuncia','Q','CHK_SCAD','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCASFI','2','Caricamento Archivio Ass. Fiscale','Q','PECCASFI','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCASFI','3','Lista Verifiche 770/SD','R','PECLV70D','','PECLV70D','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCASFI','4','Cancellazione Appoggio Stampe','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCASFI','5','Verifica presenza errori','Q','CHK_ERR','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCASFI','91','Stampa Segnalazioni Anomalie','R','ACARAPPR','','PECCARFI','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCASFI','92','Cancellazione Segnalazioni','Q','ACACANRP','','','N');

delete from a_selezioni where voce_menu = 'PECCASFI';

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_DENUNCIA','PECCASFI','0','Tipo Denuncia','10','U','N','770','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCASFI','1','Anno','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECCASFI','2','Gestione ....:','4','U','S','%','','GEST','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECCASFI','3','Archiviazione:','1','U','S','T','P_TIPO','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECCASFI','4','Singolo Individuo : Codice','8','N','N','','','RAIN','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CONTROLLI','PECCASFI','5','Solo Controlli','1','U','N','X','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_CONTROLLI','PECCASFI','6','Tipo Controlli','1','U','N','T','P_LV70D','','','');

delete from a_domini_selezioni where dominio = 'P_LV70D';

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_LV70D','C','','Conguagli non terminati e/o Differenze ');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_LV70D','M','','Riepilogo Movimenti');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_LV70D','R','','Verifica 730 Rettificati');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_LV70D','T','','Totale');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_LV70D','V','','Elenco Voci/Specifiche');

-- cancellazione e reinserimento a_catalogo_stampe se diverso da PDF

delete from a_catalogo_stampe
where stampa = 'PECLV70D'
  and not exists ( select 'x' 
                     from a_catalogo_stampe 
                    where stampa = 'PECLV70D'
                      and classe = 'PDF'
                 )
;
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
select 'PECLV70D','LISTA VERIFICHE 770/SD','U','U','A_E','N','N','S'
from dual
where not exists ( select 'x' 
                     from a_catalogo_stampe 
                    where stampa = 'PECLV70D'
                      and classe = 'PDF'
                 )
;

start crp_PECCASFI.sql