insert into a_domini_selezioni
(dominio,valore_low,descrizione)
values('P_CAAF_ACCODA','E','Elimina Registrazioni')
/
insert into a_domini_selezioni
(dominio,valore_low,descrizione)
values('P_CAAF_ACCODA','NO','Elimina e Inserisce Registrazioni')
/
insert into a_domini_selezioni
(dominio,valore_low,descrizione)
values('P_CAAF_ACCODA','SI','Accoda Registrazioni')
/
update a_selezioni set dominio = 'P_CAAF_ACCODA'
where voce_menu = 'PECCCAAF' and parametro = 'P_INSERISCI'
/
insert into a_errori
(errore,descrizione)
values ('P08070','Cancellazione non consentita: mensilita'' diversa dalla mensilita'' aperta')
/

start crp_pecccaaf.sql