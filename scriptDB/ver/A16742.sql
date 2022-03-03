delete from a_passi_proc 
 where voce_menu = 'PECCADMA' 
   and passo    >= 90
/

insert into a_passi_proc (VOCE_MENU,PASSO,TITOLO,TIPO,MODULO ,GRUPPO_LING)
values ('PECCADMA',91,'Lista Segnalazioni Denuncia DMA','R','PECLSDMA','N')
/
insert into a_passi_proc (VOCE_MENU,PASSO,TITOLO,TIPO,MODULO ,GRUPPO_LING)
values ('PECCADMA',92,'Cancellazione errori','Q','ACACANAS','N')
/
insert into a_passi_proc (VOCE_MENU,PASSO,TITOLO,TIPO,MODULO ,GRUPPO_LING)
values ('PECCADMA',93,'Errori di Elaborazione','R','ACARAPPR','N')
/
insert into a_passi_proc (VOCE_MENU,PASSO,TITOLO,TIPO,MODULO ,GRUPPO_LING)
values ('PECCADMA',94,'Cancellazione errori','Q','ACACANRP','N')
/




 
