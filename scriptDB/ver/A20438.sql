-- 
-- DEFINIZIONE NUOVA VOCE SADIR
--
delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECSADIR');
delete from a_guide_v where guida_v in (select guida_v from a_guide_o 
                                         where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECSADIR'));
delete from a_voci_menu where voce_menu = 'PECSADIR';
delete from a_passi_proc where voce_menu = 'PECSADIR';
delete from a_selezioni where voce_menu = 'PECSADIR';
delete from a_menu where voce_menu = 'PECSADIR' and ruolo in ('*','AMM','PEC');
delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc
                                                where substr(stampa,1,1) = 'P' and voce_menu = 'PECSADIR');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) values ('PECSADIR','P00','SADIR','Stampa Addizionali IRPEF','F','D','ACAPARPR','ADD_IRPEF_2007',1,'P_RIRE_S');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSADIR','1','Stampa Addizionali IRPEF','R','PECSADIC','','PECSADIC','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSADIR','2','Stampa Addizionali IRPEF','R','PECSADIR','','PECSADIR','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECSADIR','1','Elaborazione   : da Anno','4','N','N','','','RIRE','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_MENSILITA','PECSADIR','2','                Cod.Mensilita`','4','U','N','','','RIRE','1','2');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_A_ANNO','PECSADIR','3','                 a  Anno','4','N','N','','','RIRE','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_A_MENSILITA','PECSADIR','4','                Cod.Mensilita`','4','U','N','','','RIRE','1','2');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_FILTRO_1','PECSADIR','5','Raggruppamento : 1)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_FILTRO_2','PECSADIR','6','                 2)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_FILTRO_3','PECSADIR','7','                 3)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_FILTRO_4','PECSADIR','8','                 4)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DETTAGLIO','PECSADIR','9','Tipo Dettaglio :','1','U','S','N','P_SADIR','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','PEC','1000553','1013884','PECSADIR','23','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','*','1000553','1013884','PECSADIR','23','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','AMM','1000553','1013884','PECSADIR','23','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) values ('PECSADIC','Stampa Addizionali Comunali','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) values ('PECSADIR','Stampa Addizionali Regionali','U','U','A_C','N','N','S');                                                

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) values ('P_RIRE_S','1','PREN','P','Prenot.','','ACAEPRPA','*','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) values ('P_RIRE_S','2','RIRE','M','Mese','','PECRMERE','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) values ('P_RIRE_S','3','RECE','G','raGgrupp.','','PECERECE','','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SADIR','C','','Totali per Comune');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SADIR','N','','Dettaglio Nominativo');


--
-- DEFINIZIONE NUOVA ESTRAZIONE IN DESRE
--

insert into ESTRAZIONE_REPORT (ESTRAZIONE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, SEQUENZA, OGGETTO, NUM_RIC, NOTE)
values ('ADD_IRPEF_2007', 'Elenco Addizionali IRPEF', null, null, 75, 'PERE', 6, 'per stampa utilizzare SADCO');

insert into RELAZIONE_CHIAVI_ESTRAZIONE (ESTRAZIONE, SEQUENZA, CHIAVE)
values ('ADD_IRPEF_2007', 1, 'ENTE');
insert into RELAZIONE_CHIAVI_ESTRAZIONE (ESTRAZIONE, SEQUENZA, CHIAVE)
values ('ADD_IRPEF_2007', 2, 'GESTIONE');
insert into RELAZIONE_CHIAVI_ESTRAZIONE (ESTRAZIONE, SEQUENZA, CHIAVE)
values ('ADD_IRPEF_2007', 3, 'NULLA');
insert into RELAZIONE_CHIAVI_ESTRAZIONE (ESTRAZIONE, SEQUENZA, CHIAVE)
values ('ADD_IRPEF_2007', 4, 'NULLA');
insert into RELAZIONE_CHIAVI_ESTRAZIONE (ESTRAZIONE, SEQUENZA, CHIAVE)
values ('ADD_IRPEF_2007', 5, 'ALFABETICO');
insert into RELAZIONE_CHIAVI_ESTRAZIONE (ESTRAZIONE, SEQUENZA, CHIAVE)
values ('ADD_IRPEF_2007', 6, 'NULLA');

insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('ADD_IRPEF_2007', 1, 'CI.PERE', 'CI', null, null, null);
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('ADD_IRPEF_2007', 2, 'ANNO', 'ANNO', null, null, null);
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('ADD_IRPEF_2007', 3, 'MESE', 'MESE', null, null, null);

insert into RELAZIONE_OGGETTI_ESTRAZIONE (ESTRAZIONE, OGGETTO)
values ('ADD_IRPEF_2007', 'PERE');

insert into RELAZIONE_COND_ESTRAZIONE (ESTRAZIONE, OGGETTO, SEQUENZA, CONDIZIONE)
values ('ADD_IRPEF_2007', 'PERE', 1, 'and PERE.competenza = ''A''');

commit;

start crp_gp4_crea_viste.sql

begin
Gp4_crea_viste.peclesre('ADD_IRPEF_2007');
end;
/