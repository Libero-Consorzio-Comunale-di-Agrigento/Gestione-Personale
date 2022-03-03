delete from a_selezioni
 where voce_menu = 'PECCADMA'
   and parametro = 'P_CASSA'
/
insert into a_selezioni
       (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,dominio)
values ('P_ALIQUOTA','PECCADMA',11,'Cassa/Competenza',1,'U','N','P_X')
/

start crp_cursore_dma.sql
-- start crp_peccadma.sql inclusa in A20945