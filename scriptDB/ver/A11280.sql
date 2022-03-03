alter table denuncia_inpdap add
(  rit_inpdap number(12,2)  NULL
 , rit_tfs NUMBER(12,2)  NULL
 , contr_tfr  NUMBER(12,2)  NULL
);

delete from a_voci_menu where voce_menu = 'PECX770P';
delete from a_passi_proc where voce_menu = 'PECX770P';  
delete from a_selezioni where voce_menu = 'PECX770P';
delete from a_menu where voce_menu = 'PECX770P' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECX770P','P00','X770P','Agg. Rit. Previdenziali per 770','F','D','ACAPARPR','',1,'A_PARA'); 

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECX770P','1','Aggiornamento denuncia inpdap','Q','PECX770P','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECX770P','2','Stampa Dipendenti Trattati','R','PECSAPST','','PECSAPST','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECX770P','3','Pulizia appoggio stampe','Q','ACACANAS','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECX770P','1','Anno ....:','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECX770P','2','Gestione ....:','4','U','S','%','','GEST','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_PREVIDENZA','PECX770P','3','Previdenza ..:','6','U','S','CP%','P_CP_PREV','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECX770P','4','Archiviazione:','1','U','S','T','P_TIPO','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECX770P','5','Singolo Individuo : Codice','8','N','N','','','RAIN','0','1'); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1005912','1013780','PECX770P','12','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1005912','1013780','PECX770P','12','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1005912','1013780','PECX770P','12','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_TIPO','I','','Non altera Individui Inseriti'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_TIPO','P','','Parziale (non altera Inseriti/Variati)'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_TIPO','S','','Singolo Individuo'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_TIPO','T','','Totale');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_TIPO','V','','Non altera Individui Variati');

delete from a_selezioni where voce_menu = 'PECL70SA';
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_RTRIM','PECL70SA','0','Abilita rtrim','2','C','S','SI','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('TXTFILE','PECL70SA','0','Nome TXT da produrre','80','C','S','PECCSMFA.txt','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANNO','PECL70SA','1','Elaborazione  : Anno','4','N','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CONTRATTO','PECL70SA','2','Contratto INPS: Tipo','1','U','S','X','P_CONTRATTO','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_COD_FIS','PECL70SA','3','Dichiarante: Codice Fiscale','16','U','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_1','PECL70SA','4','Raggruppamento: 1)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_2','PECL70SA','5','Raggruppamento: 2)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_3','PECL70SA','6','Raggruppamento: 3)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_4','PECL70SA','7','Raggruppamento: 4)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DECIMALI','PECL70SA','8','Elabora i dati con i decimali','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ESTRAZIONI_I','PECL70SA','9','Individui da estrarre :','1','N','N','','P_ESTR_I','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_STAMPA_INQ','PECL70SA','10','Stampa inq. solo per CP Stato','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO','PECL70SA','11','Tipo','1','U','S','T','P_L70SA','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECL70SA','12','Codice Individuale','8','N','N','','','RAIN','1','1');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TOTALE','PECL70SA','13','Stampa Totali','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SUD_INPDAP','PECL70SA','14','Rit. INPDAP Suddivise','1','U','N','','P_X','','','');

delete from a_selezioni where voce_menu = 'PECCSMFA';
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_RTRIM','PECCSMFA','0','Abilita rtrim','2','C','S','SI','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('TXTFILE','PECCSMFA','0','Nome TXT da produrre','80','C','S','PECCSMFA.txt','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANNO','PECCSMFA','1','Elaborazione  : Anno','4','N','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CONTRATTO','PECCSMFA','2','Contratto INPS: Tipo','1','U','S','X','P_CONTRATTO','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_COD_FIS','PECCSMFA','3','Dichiarante: Codice Fiscale','16','U','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_1','PECCSMFA','4','Raggruppamento: 1)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_2','PECCSMFA','5','Raggruppamento: 2)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_3','PECCSMFA','6','Raggruppamento: 3)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_4','PECCSMFA','7','Raggruppamento: 4)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DECIMALI','PECCSMFA','8','Elabora i dati con i decimali','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ESTRAZIONI_I','PECCSMFA','9','Individui da estrarre :','1','N','N','','P_ESTR_I','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_STAMPA_INQ','PECCSMFA','10','Inquadram. solo per CP Stato','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO','PECCSMFA','11','Tipo','1','U','S','T','P_L70SA','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECCSMFA','12','Codice Individuale','8','N','N','','','RAIN','1','1');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SUD_INPDAP','PECCSMFA','13','Rit. INPDAP Suddivise','1','U','N','','P_X','','','');


start crp_pecx770p.sql
start crp_cursore_fiscale.sql
start crp_pecsmfa1.sql