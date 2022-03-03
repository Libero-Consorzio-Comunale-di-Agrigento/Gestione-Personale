
delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECLVACA');

delete from a_voci_menu where voce_menu = 'PECLVACA'; 

delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PECLVACA');

delete from a_passi_proc where voce_menu = 'PECLVACA';

delete from a_selezioni where voce_menu = 'PECLVACA'; 

delete from a_menu where voce_menu = 'PECLVACA' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECLVACA','P00','LVACA','Lista Addizionali da CAAF','F','D','ACAPARPR','',1,'P_VACA_S'); 

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECLVACA','1','Lista Addizionali da CAAF','R','PECLVACA','','PECLVACA','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECLVACA','1','Elaborazione: Anno','4','N','N','','','RIRE','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MENSILITA','PECLVACA','2','Mensilita','3','U','N','','','RIRE','1','2'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ORDINAMENTO','PECLVACA','3','Raggrupamento per Cod. Regione','1','U','N','','P_X','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1006751','1012892','PECLVACA','7',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1006751','1012892','PECLVACA','7',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1006751','1012892','PECLVACA','7',''); 

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECLVACA','Lista Addizionali da CAAF','U','U','A_C','N','N','S');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_VACA_S','1','PREN','P','Prenot.','','ACAEPRPA','*',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_VACA_S','2','RIRE','M','Mese','','PECRMERE','*','');
