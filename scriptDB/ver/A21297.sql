update a_voci_menu set modulo = 'ACAPARPR'
 where voce_menu = 'PECFAF07'
;

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_TABELLE','T','','Totale');                                                                                                                                                                                           
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_TABELLE','V','','Variazione al 18/05/2007 Circ. INPS n.88');                                                       
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TABELLE','PECFAF07','1','Tipo Elaborazione','1','U','S','V','P_TABELLE','','','');                          

start ver\ins_scaf_200705.sql
start ver\ins_asfa_200705.sql

start crp_pecfaf07.sql
                   