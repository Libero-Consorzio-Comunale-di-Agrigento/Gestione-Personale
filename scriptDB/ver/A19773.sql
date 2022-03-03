delete from a_selezioni where voce_menu = 'PECCSMFA';

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_RTRIM','PECCSMFA','0','Abilita rtrim','2','C','S','SI','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('TXTFILE','PECCSMFA','0','Nome TXT da produrre','80','C','S','PECCSMFA.txt','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANNO','PECCSMFA','1','Elaborazione  : Anno','4','N','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_COD_FIS','PECCSMFA','2','Dichiarante: Codice Fiscale','16','U','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO','PECCSMFA','3','Tipo','1','U','S','T','P_L70SA','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECCSMFA','4','Codice Individuale','8','N','N','','','RAIN','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ESTRAZIONE_I','PECCSMFA','5','Individui da estrarre :','1','N','N','','P_ESTR_I','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DOM_FISCALE','PECCSMFA','6','Stampa Dom.Fiscale per Cessati','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_1','PECCSMFA','7','Raggruppamento: 1)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_2','PECCSMFA','8','Raggruppamento: 2)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_3','PECCSMFA','9','Raggruppamento: 3)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_4','PECCSMFA','10','Raggruppamento: 4)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DECIMALI','PECCSMFA','12','Elabora i dati con i decimali','1','U','N','X','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DMA_ASS','PECCSMFA','13','Suddivisione DMA per Ass.','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FORZA_IMPORTI','PECCSMFA','14','Forzatura Importi DMA','1','U','S','N','P_FORZA_IMPORTI','','','');  

delete from a_selezioni where voce_menu = 'PECL70SA';

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_RTRIM','PECL70SA','0','Abilita rtrim','2','C','S','SI','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('TXTFILE','PECL70SA','0','Nome TXT da produrre','80','C','S','PECCSMFA.txt','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANNO','PECL70SA','1','Elaborazione  : Anno','4','N','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_COD_FIS','PECL70SA','2','Dichiarante: Codice Fiscale','16','U','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO','PECL70SA','3','Tipo','1','U','S','T','P_L70SA','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECL70SA','4','Codice Individuale','8','N','N','','','RAIN','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ESTRAZIONE_I','PECL70SA','5','Individui da estrarre :','1','N','N','','P_ESTR_I','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DOM_FISCALE','PECL70SA','6','Stampa Dom.Fiscale per Cessati','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_1','PECL70SA','7','Raggruppamento: 1)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_2','PECL70SA','8','Raggruppamento: 2)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_3','PECL70SA','9','Raggruppamento: 3)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_4','PECL70SA','10','Raggruppamento: 4)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DECIMALI','PECL70SA','11','Elabora i dati con i decimali','1','U','N','X','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TOTALE','PECL70SA','12','Stampa Totali','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DMA_ASS','PECL70SA','13','Suddivisione DMA per Ass.','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FORZA_IMPORTI','PECL70SA','14','Forzatura Importi DMA','1','U','S','N','P_FORZA_IMPORTI','','',''); 

update a_selezioni
   set valore_default = 'X'
 where voce_menu in ('PECL70SC','PECCSMFC')
   and parametro = 'P_DECIMALI'
;

start crp_PECSMFA1.sql
start crp_PECSMFA2.sql
