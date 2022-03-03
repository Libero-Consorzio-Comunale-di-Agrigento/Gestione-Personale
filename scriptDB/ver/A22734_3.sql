create table pren_ante_a22734_3
as select * from a_prenotazioni ;

create table stam_ante_a22734_3
as select * from a_stampe;

create table menu_ante_a22734_3
as select * from a_menu
    where voce_menu in ( 'PXXSMORE', 'PXXSCERE', 'PXXCALRC', 'PXXSMOR4'
                       , 'PECSMOR4', 'PXXSCER4', 'PXXCALR4', 'PECCALR4', 'PXXSCER4'
                       , 'PECSMCU4', 'PXXSMCU4', 'PECSMCUD', 'PECSICUD', 'PXXSICU4', 'PXXCARDP', 'PXXSMDSI'
                       , 'PGMSCES4', 'PXXSCERT', 'PXXSCES4', 'PXXSPCSE', 'PXXSCEVE'
                       );

update a_prenotazioni
   set voce_menu = decode(voce_menu
                         , 'PXXSMORE', 'PECSMORE'
                         , 'PXXSCERE', 'PECSCERE'
                         , 'PXXCALRC', 'PECCALRC'
                         , 'PXXSMOR4', 'PECSMOR6'
                         , 'PECSMOR4', 'PECSMOR6'
                         , 'PXXSCER4', 'PECSCER6'
                         , 'PXXCALR4', 'PECCALR6'
                         , 'PECCALR4', 'PECCALR6'
                         , 'PXXSCER4', 'PECSCER6'
                         , 'PECSMCU4', 'PECSMCU6'
                         , 'PXXSMCU4', 'PECSMCU6'
                         , 'PECSMCUD', 'PECSMCU6'
                         , 'PXXCARDP', 'PECCARDP'
                         , 'PXXSMDSI', 'PECSMDSI'
                         , 'PGMSCES4', 'PGMSCESE'
                         , 'PXXSCERT', 'PGMSCERT'
                         , 'PXXSCES4', 'PGMSCERT'
                         , 'PXXSPCSE', 'PGMSCERT'
                         , 'PXXSCEVE', 'PXHCTSCE'
                                     , voce_menu
                         )
 where voce_menu in ( 'PXXSMORE', 'PXXSCERE', 'PXXCALRC', 'PXXSMOR4'
                    , 'PECSMOR4', 'PXXSCER4', 'PXXCALR4', 'PECCALR4', 'PXXSCER4'
                    , 'PECSMCU4', 'PXXSMCU4', 'PECSMCUD', 'PXXCARDP', 'PXXSMDSI'
                    , 'PGMSCES4', 'PXXSCERT', 'PXXSCES4', 'PXXSPCSE', 'PXXSCEVE'
                    );

update a_stampe 
   set stampa =   decode ( stampa
                         , 'PECSMOR4', 'PECSMOR6'
                         , 'PECSCER4', 'PECSMOR6'
                         , 'PECSMCU4', 'PECSMCU6'
                         , 'PXXSMCU4', 'PECSMCU6'
                         , 'PECSMCUD', 'PECSMCU6'
                         , 'PXXSMDSI', 'PECSMDSI'
                                     , stampa
                         )
 where stampa in ( 'PECSMOR4', 'PECSCER4', 'PECSMCU4', 'PXXSMCU4', 'PECSMCUD', 'PXXSMDSI');


-- Eliminazione voce di menu PXXSMORE

delete from a_voci_menu where voce_menu = 'PXXSMORE'; 
delete from a_passi_proc where voce_menu = 'PXXSMORE';
delete from a_selezioni where voce_menu = 'PXXSMORE';
delete from a_menu where voce_menu = 'PXXSMORE';

-- Eliminazione voce di menu PXXSCERE

delete from a_voci_menu where voce_menu = 'PXXSCERE';
delete from a_passi_proc where voce_menu = 'PXXSCERE';
delete from a_selezioni where voce_menu = 'PXXSCERE';
delete from a_menu where voce_menu = 'PXXSCERE';

-- Eliminazione voce di menu PXXCALRC

delete from a_voci_menu where voce_menu = 'PXXCALRC'; 
delete from a_passi_proc where voce_menu = 'PXXCALRC';
delete from a_selezioni where voce_menu = 'PXXCALRC'; 
delete from a_menu where voce_menu = 'PXXCALRC'; 

-- Eliminazione voce di menu PXXSMOR4 - PECSMOR4

delete from a_voci_menu where voce_menu = 'PXXSMOR4'; 
delete from a_passi_proc where voce_menu = 'PXXSMOR4';
delete from a_selezioni where voce_menu = 'PXXSMOR4'; 
delete from a_menu where voce_menu = 'PXXSMOR4'; 

delete from a_voci_menu where voce_menu = 'PECSMOR4'; 
delete from a_passi_proc where voce_menu = 'PECSMOR4';
delete from a_selezioni where voce_menu = 'PECSMOR4'; 
delete from a_menu where voce_menu = 'PECSMOR4'; 

-- Eliminazione voce di menu PXXSCER4

delete from a_voci_menu where voce_menu = 'PXXSCER4'; 
delete from a_passi_proc where voce_menu = 'PXXSCER4';
delete from a_selezioni where voce_menu = 'PXXSCER4'; 
delete from a_menu where voce_menu = 'PXXSCER4'; 

-- Eliminazione voci di menu PXXCALR4 - PECCALR4

delete from a_voci_menu where voce_menu = 'PXXCALR4'; 
delete from a_passi_proc where voce_menu = 'PXXCALR4';
delete from a_selezioni where voce_menu = 'PXXCALR4'; 
delete from a_menu where voce_menu = 'PXXCALR4';

delete from a_voci_menu where voce_menu = 'PECCALR4'; 
delete from a_passi_proc where voce_menu = 'PECCALR4';
delete from a_selezioni where voce_menu = 'PECCALR4'; 
delete from a_menu where voce_menu = 'PECCALR4';

-- Eliminazione stampa PECSMOR4 - PECSCER4

delete from a_catalogo_stampe where stampa = 'PECSMOR4';
delete from a_catalogo_stampe where stampa = 'PECSCER4';

-- Ricreazione della voce di menu PECCALRC

delete from a_voci_menu where voce_menu = 'PECCALRC';
delete from a_passi_proc where voce_menu = 'PECCALRC';
delete from a_selezioni where voce_menu = 'PECCALRC';
delete from a_menu where voce_menu = 'PECCALRC' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCALRC','P00','CALRC','Calcolo Retribuzione + Cedolini','F','D','PECRCARE','',1 ,'P_ELAB');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRC','1','Calcolo Periodi Retributivi','F','PECCPERE','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRC','2','Calcolo Movimenti Retributivi','F','PECCMORE','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRC','3','Segnalazioni di Calcolo','R','ACARAPPR','','PECCALSE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRC','4','Cancellazione Segnalazioni','Q','ACACANRP','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRC','5','Stampa Casi Particolari','R','PECSAPST','','PECSAPST','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRC','6','Cancellazione appoggio stampe','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRC','7','Stampa Retribuzioni Elaborate','R','PECSMORE','','PECSMORE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRC','8','Aggiornamento Flag Elaborazione','Q','PECURAGI','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRC','91','Errori di Calcolo','R','ACARAPPR','','PECCALER','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRC','92','Cancellazione Errori','Q','ACACANRP','','','N');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000597','1012982','PECCALRC','0','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000597','1012982','PECCALRC','0','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000597','1012982','PECCALRC','0','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
select 'GP4',app.ruolo,'1000597','1012982','PECCALRC','0',''
  from menu_ante_a22734_3 app
 where voce_menu in ( 'PXXCALRC' )
   and not exists ( select 'x' 
                      from a_menu
                     where voce_menu = 'PECCALRC'
                       and applicazione = 'GP4'
                       and ruolo = app.ruolo
                  );

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale)
values ('PECCALER','ERRORI CALCOLO RETRIBUZIONE','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCALSE','SEGNALAZIONI CALCOLO RETRIBUZIONE','U','U','A_A','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSAPST','Stampa Elenco','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSMORE','MOVIMENTI RETRIBUTIVI','U','U','A_A','N','N','S');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_ELAB','1','RIEL','E','Errori','','PECERIEL','','');

-- Ricreazione della voce di menu PECCALR6

delete from a_voci_menu where voce_menu = 'PECCALR6';
delete from a_passi_proc where voce_menu = 'PECCALR6';
delete from a_selezioni where voce_menu = 'PECCALR6';
delete from a_menu where voce_menu = 'PECCALR6' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PECCALR6','P00','CALR6','Calcolo Retribuzione + Cedolini','F','D','PECRCARE','',1,'P_ELAB');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALR6','1','Calcolo Periodi Retributivi','F','PECCPERE','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALR6','2','Calcolo Movimenti Retributivi','F','PECCMORE','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALR6','3','Segnalazioni di Calcolo','R','ACARAPPR','','PECCALSE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALR6','4','Cancellazione Segnalazioni','Q','ACACANRP','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALR6','5','Stampa Casi Particolari','R','PECSAPST','','PECSAPST','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALR6','6','Cancellazione appoggio stampe','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALR6','7','Stampa Retribuzioni Elaborate','R','PECSMOR6','P_TIPO_DESFORMAT','PECSMOR6','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALR6','8','Pulizia appoggio stampe','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALR6','9','Aggiornamento Flag Elaborazione','Q','PECURAGI','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALR6','91','Errori di Calcolo','R','ACARAPPR','','PECCALER','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALR6','92','Cancellazione Errori','Q','ACACANRP','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_DESFORMAT','PECCALR6','0','Tipo stampa' ,'4','U','S','PDF','P_SCER6','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000597','1013484','PECCALR6','0','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000597','1013484','PECCALR6','0','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000597','1013484','PECCALR6','0','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
select 'GP4',app.ruolo,'1000597','1013484','PECCALR6','0',''
  from menu_ante_a22734_3 app
 where voce_menu in ( 'PXXCALR4' , 'PECCALR4' )
   and not exists ( select 'x' 
                      from a_menu
                     where voce_menu = 'PECCALR6'
                       and applicazione = 'GP4'
                       and ruolo = app.ruolo
                  );

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCALER','ERRORI CALCOLO RETRIBUZIONE','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCALSE','SEGNALAZIONI CALCOLO RETRIBUZIONE','U','U','A_A','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSAPST','Stampa Elenco','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSMOR6','MOVIMENTI RETRIBUTIVI','U','U','A_A','N','N','S');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_ELAB','1','RIEL','E','Errori','','PECERIEL','','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SCER6','A_A','','Produzione Cedolino a Carattere');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SCER6','PDF','','Produzione Cedolino Grafico');

-- Ricreazione della voce di menu PECSMORE

delete from a_voci_menu where voce_menu = 'PECSMORE';
delete from a_passi_proc where voce_menu = 'PECSMORE';
delete from a_selezioni where voce_menu = 'PECSMORE';
delete from a_menu where voce_menu = 'PECSMORE' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECSMORE','P00','SMORE','Stampa Retribuzioni Elaborate','F','D','','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMORE','1','Stampa Retribuzioni','R','PECSMORE','','PECSMORE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMORE','2','Aggiornamento Flag Elaborazione','Q','PECURAGI','','','N');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000549','1012995','PECSMORE','12','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1000549','1012995','PECSMORE','12','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000549','1012995','PECSMORE','12','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
select 'GP4',app.ruolo,'1000549','1012995','PECSMORE','12',''
  from menu_ante_a22734_3 app
 where voce_menu in ( 'PXXSMORE' )
   and not exists ( select 'x' 
                      from a_menu
                     where voce_menu = 'PECSMORE'
                       and applicazione = 'GP4'
                       and ruolo = app.ruolo
                  );

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale)
values ('PECSMORE','MOVIMENTI RETRIBUTIVI','U','U','A_A','N','N','S');

-- Ricreazione della voce di menu PECSMOR6

delete from a_voci_menu where voce_menu = 'PECSMOR6';
delete from a_passi_proc where voce_menu = 'PECSMOR6';
delete from a_selezioni where voce_menu = 'PECSMOR6';
delete from a_menu where voce_menu = 'PECSMOR6' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECSMOR6','P00','SMOR6','Stampa Retribuzioni Elaborate','F','D','ACAPARPR','',1,'P_SMOR6');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMOR6','1','Stampa Retribuzioni','R','PECSMOR6','P_TIPO_DESFORMAT','PECSMOR6','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMOR6','2','Aggiornamento Flag Elaborazione','Q','PECURAGI','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMOR6','3','Pulizia appoggio stampe','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMOR6','4','Verifica presenza errori','Q','CHK_ERR','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMOR6','91','Stampa Segnalazioni di errore','R','ACARAPPR','','PECCALSE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMOR6','92','Pulizia segnalazioni di errore','Q','ACACANRP','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_STALIAS','PECSMOR6','0','Directory Stampe',' 20','U','N','P00SVI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_DESFORMAT','PECSMOR6','1','Tipo stampa','4','U','S','PDF','P_SCER6','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FRONTE_RETRO','PECSMOR6','2','Stampa in Fronte/Retro','2','U','N','','P_SI_NO','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_MODELLO_STAMPA','PECSMOR6','3','Modello Stampa','8','U','N','','','STMS','','1');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000549','1013485','PECSMOR6','12','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000549','1013485','PECSMOR6','12','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000549','1013485','PECSMOR6','12','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
select 'GP4',app.ruolo,'1000549','1013485','PECSMOR6','12',''
  from menu_ante_a22734_3 app
 where voce_menu in ( 'PXXSMOR4' , 'PECSMOR4' )
   and not exists ( select 'x' 
                      from a_menu
                     where voce_menu = 'PECSMOR6'
                       and applicazione = 'GP4'
                       and ruolo = app.ruolo
                  );

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale)
values ('PECCALSE','SEGNALAZIONI CALCOLO RETRIBUZIONE','U','U','A_A','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSMOR6','MOVIMENTI RETRIBUTIVI','U','U','A_A','N','N','S');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_SMOR6','1','STMS','D','moDello','','PECESTMS','','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SCER6','A_A','','Produzione Cedolino a Carattere');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SCER6','PDF','','Produzione Cedolino Grafico');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione)
values ('P_SI_NO','NO','','Negativo');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione)
values ('P_SI_NO','SI','','Affermativo');

-- Ricreazione della voce di menu PECSCERE

delete from a_voci_menu where voce_menu = 'PECSCERE';
delete from a_passi_proc where voce_menu = 'PECSCERE';
delete from a_selezioni where voce_menu = 'PECSCERE';
delete from a_menu where voce_menu = 'PECSCERE' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECSCERE','P00','SCERE','Cedolino di Retribuzione','F','D','ACAPARPR','CEDOLINO',1,'P_CEDO_S');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSCERE','1','Cedolino di Retribuzione','R','PECSMORE','','PECSCERE','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO_ELA','PECSCERE','1','Elaborazione   : Anno','4','N','N','','','RIRE','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MENSILITA_ELA','PECSCERE','2','                 Mensilita`','4','U','N','','','RIRE','1','2');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RICHIESTA','PECSCERE','3','                 Tipo','1','U','S','T','P_CERE_TIPO','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_1','PECSCERE','4','Raggruppamento : 1)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_2','PECSCERE','5','                 2)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_3','PECSCERE','6','                 3)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_4','PECSCERE','7','                 4)','15','U','S','%','','','','');                                                        
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECSCERE','8','Individuale    : Codice','8','N','N','','','RAIN','0','1');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GR_LING','PECSCERE','9','Gr.Linguistico richiesto','1','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_NUM_STAMPA','PECSCERE','10','Numero Stampa :','10','N','N','','','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000552','1012996','PECSCERE','0','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000552','1012996','PECSCERE','0','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000552','1012996','PECSCERE','0','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
select 'GP4',app.ruolo,'1000552','1012996','PECSCERE','0',''
  from menu_ante_a22734_3 app
 where voce_menu in ( 'PXXSCERE' )
   and not exists ( select 'x' 
                      from a_menu
                     where voce_menu = 'PECSCERE'
                       and applicazione = 'GP4'
                       and ruolo = app.ruolo
                  );

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSCERE','CEDOLINO DI RETRIBUZIONE','U','U','A_B','N','N','S');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CEDO_S','1','PREN','P','Prenot.','','ACAEPRPA','*','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CEDO_S','2','RIRE','M','Mese','','PECRMERE','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CEDO_S','3','RAIN','I','Individuo','','P00RANAG','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CEDO_S','4','RECE','G','raGgrupp.','','PECERECE','','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione)
values ('P_CERE_TIPO','E','','Stampa solo cedolini ultima Elaborazione');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione)
values ('P_CERE_TIPO','T','','Stampa Totale cedolini');

-- Ricreazione della voce di menu PECSCER6

delete from a_voci_menu where voce_menu = 'PECSCER6';
delete from a_passi_proc where voce_menu = 'PECSCER6';
delete from a_selezioni where voce_menu = 'PECSCER6';
delete from a_menu where voce_menu = 'PECSCER6' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECSCER6','P00','SCER6','Cedolino di Retribuzione','F','D','ACAPARPR','CEDOLINO',1,'P_CED6');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSCER6','1','Verifica Richiesta Cedolino','Q','CHK_MAIL','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSCER6','2','Produzione cedolino nuovo','R','PECSMOR6','P_TIPO_DESFORMAT','PECSCER6','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSCER6','3','Pulizia appoggio stampe','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSCER6','4','Inoltro Mail','Q','PECSMORM','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSCER6','5','Verifica presenza errori','Q','CHK_ERR','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSCER6','91','Stampa segnalazioni di errore','R','ACARAPPR','','PECCALSE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSCER6','92','Cancellazione Segnalazioni','Q','ACACANRP','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_PRG_CEDOLINO','PECSCER6','0','Progressivo Temporaneo','8','N','N','1','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO_ELA','PECSCER6','1','Elaborazione   : Anno','4','N','N','','','RIRE','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MENSILITA_ELA','PECSCER6','2','                Cod.Mensilita`','4','U','N','','','RIRE','1','2');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RICHIESTA','PECSCER6','3','                 Tipo','1','U','S','T','P_CERE_TIPO','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_1','PECSCER6','4','Raggruppamento : 1)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_2','PECSCER6','5','                 2)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_3','PECSCER6','6','                 3)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_4','PECSCER6','7','                 4)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECSCER6','8','Individuale    : Codice','8','N','N','','','RAIN','0','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GR_LING','PECSCER6','9','Gr.Linguistico richiesto','1','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_NUM_STAMPA','PECSCER6','10','Numero Stampa :','8','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_DESFORMAT','PECSCER6','11','Tipo stampa','4','U','S','PDF','P_SCER6','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FRONTE_RETRO','PECSCER6','12','Stampa in Fronte/Retro','2','U','N','','P_SI_NO','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MODELLO_STAMPA','PECSCER6','13','Modello Stampa','8','U','N','','','STMS','','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_INTERNA','PECSCER6','14','Modalità di Stampa','1','U','S','X','P_D_INTERNA','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000552','1013486','PECSCER6','0','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000552','1013486','PECSCER6','0','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000552','1013486','PECSCER6','0','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
select 'GP4',app.ruolo,'1000552','1013486','PECSCER6','0',''
  from menu_ante_a22734_3 app
 where voce_menu in ( 'PXXSCER4', 'PXXSCER4' )
   and not exists ( select 'x' 
                      from a_menu
                     where voce_menu = 'PECSCER6'
                       and applicazione = 'GP4'
                       and ruolo = app.ruolo
                  );

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCALSE','SEGNALAZIONI CALCOLO RETRIBUZIONE','U','U','A_A','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSCER6','CEDOLINO DI RETRIBUZIONE','U','U','A_A','N','N','S');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CED6','1','PREN','P','Prenot.','','ACAEPRPA','*','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CED6','2','RIRE','M','Mese','','PECRMERE','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CED6','3','RAIN','I','Individuo','','P00RANAG','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CED6','4','RECE','G','raGgrupp.','','PECERECE','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CED6','5','STMS','D','moDello','','PECESTMS','','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CERE_TIPO','E','','Stampa solo cedolini ultima Elaborazione');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CERE_TIPO','T','','Stampa Totale cedolini');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_D_INTERNA','C','','Complessiva');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_D_INTERNA','P','','Per Postalizzazione');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_D_INTERNA','T','','Per Invio Telematico');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_D_INTERNA','X','','Ad uso interno');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SCER6','A_A','','Produzione Cedolino a Carattere');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SCER6','PDF','','Produzione Cedolino Grafico');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SI_NO','NO','','Negativo');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_SI_NO','SI','','Affermativo');

-- Ricreazione della voce di menu PECCALRR

delete from a_voci_menu where voce_menu = 'PECCALRR';                                            
delete from a_passi_proc where voce_menu = 'PECCALRR';                                           
delete from a_selezioni where voce_menu = 'PECCALRR';                                            
delete from a_menu where voce_menu = 'PECCALRR' and ruolo in ('*','AMM','PEC');                  

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCALRR','P00','CALRR','Calcolo Retribuzione + Cedolini e Riep.','F','D','PECRCARE','',1,'P_ELAB');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRR','1','Calcolo Periodi Retributivi','F','PECCPERE','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRR','2','Calcolo Movimenti Retributivi','F','PECCMORE','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRR','3','Segnalazioni di Calcolo','R','ACARAPPR','','PECCALSE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRR','4','Cancellazione Segnalazioni','Q','ACACANRP','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRR','5','Stampa Casi Particolari','R','PECSAPST','','PECSAPST','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRR','6','Cancellazione appoggio stampe','Q','ACACANAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRR','7','Stampa Retribuzioni Elaborate','R','PECSMORE','','PECSMORE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRR','8','Aggiornamento Flag Elaborazione','Q','PECURAGI','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRR','9','Stampa Riepilogo Retribuzioni','R','PECSRIRE','','PECSRIRE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRR','91','Errori di Calcolo','R','ACARAPPR','','PECCALER','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRR','92','Cancellazione Errori','Q','ACACANRP','','','N'); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000597','1000746','PECCALRR','3','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000597','1000746','PECCALRR','3','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000597','1000746','PECCALRR','3','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCALER','ERRORI CALCOLO RETRIBUZIONE','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCALSE','SEGNALAZIONI CALCOLO RETRIBUZIONE','U','U','A_A','N','N','S');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSAPST','Stampa Elenco','U','U','A_C','N','N','S'); 
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSMORE','MOVIMENTI RETRIBUTIVI','U','U','A_A','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSRIRE','RIEPILOGO RETRIBUZIONE','U','U','A_C','N','N','S'); 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_ELAB','1','RIEL','E','Errori','','PECERIEL','','');

-- Ricreazione della voce di menu PECCARR6

delete from a_voci_menu where voce_menu = 'PECCARR6';
delete from a_passi_proc where voce_menu = 'PECCARR6';
delete from a_selezioni where voce_menu = 'PECCARR6';
delete from a_menu where voce_menu = 'PECCARR6' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCARR6','P00','CARR6','Calcolo Retribuzione + Cedolini e Riep.','F','D','PECRCARE','',1,'P_ELAB');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARR6','1','Calcolo Periodi Retributivi','F','PECCPERE','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARR6','2','Calcolo Movimenti Retributivi','F','PECCMORE','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARR6','3','Segnalazioni di Calcolo','R','ACARAPPR','','PECCALSE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARR6','4','Cancellazione Segnalazioni','Q','ACACANRP','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARR6','5','Stampa Casi Particolari','R','PECSAPST','','PECSAPST','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARR6','6','Cancellazione appoggio stampe','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARR6','7','Stampa Retribuzioni Elaborate','R','PECSMOR6','P_TIPO_DESFORMAT','PECSMOR6','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARR6','8','Pulizia appoggio stampe','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARR6','9','Aggiornamento Flag Elaborazione','Q','PECURAGI','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARR6','10','Stampa Riepilogo Retribuzioni','R','PECSRIRE','','PECSRIRE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARR6','91','Errori di Calcolo','R','ACARAPPR','','PECCALER','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARR6','92','Cancellazione Errori','Q','ACACANRP','','','N');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000597','1013734','PECCARR6','3','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000597','1013734','PECCARR6','3','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000597','1013734','PECCARR6','3','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCALER','ERRORI CALCOLO RETRIBUZIONE','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCALSE','SEGNALAZIONI CALCOLO RETRIBUZIONE','U','U','A_A','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSAPST','Stampa Elenco','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSMOR6','MOVIMENTI RETRIBUTIVI','U','U','A_A','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSRIRE','RIEPILOGO RETRIBUZIONE','U','U','A_C','N','N','S');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_ELAB','1','RIEL','E','Errori','','PECERIEL','','');

-- Ricreazione della voce di menu PECCALRP

delete from a_voci_menu where voce_menu = 'PECCALRP';   
delete from a_passi_proc where voce_menu = 'PECCALRP';  
delete from a_selezioni where voce_menu = 'PECCALRP';   
delete from a_menu where voce_menu = 'PECCALRP' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCALRP','P00','CALRP','Calcolo Retribuzione + Post-Paga','F','D','PECRCARE','',1,'P_ELAB');                    

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','1','Calcolo Periodi Retributivi','F','PECCPERE','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','2','Calcolo Movimenti Retributivi','F','PECCMORE','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','3','Segnalazioni di Calcolo','R','ACARAPPR','','PECCALSE','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','4','Cancellazione Segnalazioni','Q','ACACANRP','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','5','Stampa Casi Particolari','R','PECSAPST','','PECSAPST','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','6','Cancellazione appoggio stampe','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','7','Stampa Retribuzioni Elaborate','R','PECSMORE','','PECSMORE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','8','Aggiornamento Flag Elaborazione','Q','PECURAGI','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','9','Stampa Riepilogo Retribuzioni','R','PECSRIRE','','PECSRIRE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','10','Stampa Quietanza Retribuzioni','R','PECSQURE','','PECSQURE','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','11','Stampa Accrediti Retribuzioni','R','PECSACRE','','PECSACRE','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','12','Stampa Riepilogo Contributi','R','PECSRCRE','','PECSRCRE','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','13','Stampa Movimenti di Bilancio','R','PECSMOBI','','PECSMOBI','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','14','Stampa Distinta Ritenute Sindacali','R','PECSDSRE','','PECSDSRE','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','15','Stampa Distinta Situazioni Debitorie','R','PECSDDRE','','PECSDDRE','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','91','Errori di Calcolo','R','ACARAPPR','','PECCALER','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCALRP','92','Cancellazione Errori','Q','ACACANRP','','','N'); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000597','1000747','PECCALRP','4','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000597','1000747','PECCALRP','4','');  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000597','1000747','PECCALRP','4','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCALER','ERRORI CALCOLO RETRIBUZIONE','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCALSE','SEGNALAZIONI CALCOLO RETRIBUZIONE','U','U','A_A','N','N','S');                          
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSACRE','ACCREDITI DI RETRIBUZIONE','U','U','A_A','N','N','S');  
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSAPST','Stampa Elenco','U','U','A_C','N','N','S');   
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSDDRE','SITUAZIONI DEBITORIE','U','U','A_C','N','N','S');   
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSDSRE','RITENUTE SINDACALI','U','U','A_C','N','N','S'); 
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSMOBI','MOVIMENTI DI BILANCIO','U','U','A_C','N','N','S');  
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSMORE','MOVIMENTI RETRIBUTIVI','U','U','A_A','N','N','S');  
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSQURE','QUIETANZE DI RETRIBUZIONE','U','U','A_C','N','N','S');  
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSRCRE','RIEPILOGO CONTRIBUTI','U','U','A_C','N','N','S');   
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSRIRE','RIEPILOGO RETRIBUZIONE','U','U','A_C','N','N','S'); 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_ELAB','1','RIEL','E','Errori','','PECERIEL','','');  

-- Ricreazione della voce di menu PECCARP6

delete from a_voci_menu where voce_menu = 'PECCARP6';
delete from a_passi_proc where voce_menu = 'PECCARP6';
delete from a_selezioni where voce_menu = 'PECCARP6';
delete from a_menu where voce_menu = 'PECCARP6' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCARP6','P00','CARP6','Calcolo Retribuzione + Post-Paga','F','D','PECRCARE','',1,'P_ELAB');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','1','Calcolo Periodi Retributivi','F','PECCPERE','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','2','Calcolo Movimenti Retributivi','F','PECCMORE','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','3','Segnalazioni di Calcolo','R','ACARAPPR','','PECCALSE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','4','Cancellazione Segnalazioni','Q','ACACANRP','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','5','Stampa Casi Particolari','R','PECSAPST','','PECSAPST','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','6','Cancellazione appoggio stampe','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','7','Stampa Retribuzioni Elaborate','R','PECSMOR6','P_TIPO_DESFORMAT','PECSMOR6','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','8','Pulizia appoggio stampe','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','9','Aggiornamento Flag Elaborazione','Q','PECURAGI','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','10','Stampa Riepilogo Retribuzioni','R','PECSRIRE','','PECSRIRE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','11','Stampa Quietanza Retribuzioni','R','PECSQURE','','PECSQURE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','12','Stampa Accrediti Retribuzioni','R','PECSACRE','','PECSACRE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','13','Stampa Riepilogo Contributi','R','PECSRCRE','','PECSRCRE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','14','Stampa Movimenti di Bilancio','R','PECSMOBI','','PECSMOBI','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','15','Stampa Distinta Ritenute Sindacali','R','PECSDSRE','','PECSDSRE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','16','Stampa Distinta Situazioni Debitorie','R','PECSDDRE','','PECSDDRE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','91','Errori di Calcolo','R','ACARAPPR','','PECCALER','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARP6','92','Cancellazione Errori','Q','ACACANRP','','','N');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000597','1013733','PECCARP6','4','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000597','1013733','PECCARP6','4','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000597','1013733','PECCARP6','4','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCALER','ERRORI CALCOLO RETRIBUZIONE','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCALSE','SEGNALAZIONI CALCOLO RETRIBUZIONE','U','U','A_A','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSACRE','ACCREDITI DI RETRIBUZIONE','U','U','A_A','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSAPST','Stampa Elenco','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSDDRE','SITUAZIONI DEBITORIE','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSDSRE','RITENUTE SINDACALI','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSMOBI','MOVIMENTI DI BILANCIO','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSMOR6','MOVIMENTI RETRIBUTIVI','U','U','A_A','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSQURE','QUIETANZE DI RETRIBUZIONE','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSRCRE','RIEPILOGO CONTRIBUTI','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSRIRE','RIEPILOGO RETRIBUZIONE','U','U','A_C','N','N','S');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_ELAB','1','RIEL','E','Errori','','PECERIEL','',''); 

-- Eliminazione voci di menu PECSMCU4 - SICU4
delete from a_voci_menu where voce_menu = 'PECSMCU4';
delete from a_catalogo_stampe where stampa = 'PECSMCU4';
delete from a_passi_proc where voce_menu = 'PECSMCU4';
delete from a_selezioni where voce_menu = 'PECSMCU4';
delete from a_menu where voce_menu = 'PECSMCU4';

delete from a_voci_menu where voce_menu = 'PXXSMCU4';
delete from a_catalogo_stampe where stampa = 'PXXSMCU4';
delete from a_passi_proc where voce_menu = 'PXXSMCU4';
delete from a_selezioni where voce_menu = 'PXXSMCU4';
delete from a_menu where voce_menu = 'PXXSMCU4';

delete from a_voci_menu where voce_menu = 'PECSMCUD';
delete from a_catalogo_stampe where stampa = 'PECSMCUD';
delete from a_passi_proc where voce_menu = 'PECSMCUD';
delete from a_selezioni where voce_menu = 'PECSMCUD';
delete from a_menu where voce_menu = 'PECSMCUD';

-- Eliminazione voci di menu PXXSICU4
delete from a_voci_menu where voce_menu = 'PXXSICU4';
delete from a_catalogo_stampe where stampa = 'PXXSICU4';
delete from a_passi_proc where voce_menu = 'PXXSICU4';
delete from a_selezioni where voce_menu = 'PXXSICU4';
delete from a_menu where voce_menu = 'PXXSICU4';

delete from a_voci_menu where voce_menu = 'PECSICUD';
delete from a_catalogo_stampe where stampa = 'PECSICUD';
delete from a_passi_proc where voce_menu = 'PECSICUD';
delete from a_selezioni where voce_menu = 'PECSICUD';
delete from a_menu where voce_menu = 'PECSICUD';

-- Eliminazione voci di menu PXXCARDP
delete from a_voci_menu where voce_menu = 'PXXCARDP';
delete from a_passi_proc where voce_menu = 'PXXCARDP';
delete from a_selezioni where voce_menu = 'PXXCARDP';
delete from a_menu where voce_menu = 'PXXCARDP';

-- Eliminazione voci di menu PXXSMDSI
delete from a_voci_menu where voce_menu = 'PXXSMDSI'; 
delete from a_catalogo_stampe where stampa = 'PXXSMDSI';
delete from a_passi_proc where voce_menu = 'PXXSMDSI';
delete from a_selezioni where voce_menu = 'PXXSMDSI';
delete from a_menu where voce_menu = 'PXXSMDSI';

-- Eliminazione voci di menu PGMSCES4
delete from a_voci_menu where voce_menu = 'PGMSCES4';
delete from a_passi_proc where voce_menu = 'PGMSCES4';
delete from a_selezioni where voce_menu = 'PGMSCES4'; 
delete from a_menu where voce_menu = 'PGMSCES4';

-- Eliminazione voci di menu PXXSCERT
delete from a_voci_menu where voce_menu = 'PXXSCERT';
delete from a_passi_proc where voce_menu = 'PXXSCERT';
delete from a_selezioni where voce_menu = 'PXXSCERT';
delete from a_menu where voce_menu = 'PXXSCERT'; 

-- Eliminazione voci di menu PXXSCES4
delete from a_voci_menu where voce_menu = 'PXXSCES4';
delete from a_passi_proc where voce_menu = 'PXXSCES4';
delete from a_selezioni where voce_menu = 'PXXSCES4';
delete from a_menu where voce_menu = 'PXXSCES4';

-- Eliminazione voci di menu PXXSCEVE
delete from a_voci_menu where voce_menu = 'PXXSCEVE';
delete from a_passi_proc where voce_menu = 'PXXSCEVE';
delete from a_selezioni where voce_menu = 'PXXSCEVE';
delete from a_menu where voce_menu = 'PXXSCEVE';

-- Eliminazione voci di menu PXXSPCSE
delete from a_voci_menu where voce_menu = 'PXXSPCSE';
delete from a_passi_proc where voce_menu = 'PXXSPCSE';
delete from a_selezioni where voce_menu = 'PXXSPCSE';
delete from a_menu where voce_menu = 'PXXSPCSE';

-- Ricreazione della voce di menu PGMSCERT

delete from a_voci_menu where voce_menu = 'PGMSCERT';
delete from a_passi_proc where voce_menu = 'PGMSCERT';
delete from a_selezioni where voce_menu = 'PGMSCERT';
delete from a_menu where voce_menu = 'PGMSCERT' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PGMSCERT','P00','SCERT','Stampa Certificato di Servizio','F','D','ACAPARPR','',1,'P_CERT_S');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGMSCERT','1','Stampa Certificato di Servizio','Q','PGMSCERT','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGMSCERT','2','Stampa Certificato di Servizio','Q','PGMICELO','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGMSCERT','3','Stampa Certificato di Servizio','R','PGMSCERT','','PGMSCERT','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGMSCERT','4','Stampa Certificato di Servizio','Q','PGMDCERT','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PGMSCERT','1','Codice Individuale ..:','8','N','S','','','RAIN','0','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CERTIFICATO','PGMSCERT','2','Certificato Richiesto:','4','U','S','','','CERT','0','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RIFERIMENTO','PGMSCERT','3','Riferimento al:','10','D','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ST_DATA','PGMSCERT','4','Stampa Data di Riferimento','2','U','S','SI','P_CERT','','','');     
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DATA_CESSAZ','PGMSCERT','5','Stampa Data di Cessazione','1','U','N','','P_X','','','');       
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TUTTI_CI','PGMSCERT','6','Stampa tutti i Rapporti Indiv.','1','U','N','X','P_X','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RESIDENZA','PGMSCERT','7','Non Stampa Indirizzo Residenza','1','U','N','','P_X','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ST_PAGINA','PGMSCERT','8','Non Stampa Numero di Pagina','1','U','N','','P_X','','','');       

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000189','1013615','PGMSCERT','2','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000189','1013615','PGMSCERT','2','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
select 'GP4',app.ruolo,'1000189','1013615','PGMSCERT','2',''
  from menu_ante_a22734_3 app
 where voce_menu in ( 'PGMSCES4', 'PXXSCERT', 'PXXSCES4', 'PXXSPCSE' )
   and not exists ( select 'x' 
                      from a_menu
                     where voce_menu = 'PGMSCERT'
                       and applicazione = 'GP4'
                       and ruolo = app.ruolo
                  );

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PGMSCERT','CERTIFICATO DI SERVIZIO','U','U','C_A','N','N','S');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CERT_S','1','PREN','P','Prenot.','','ACAEPRPA','*','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CERT_S','2','CESE','S','Stampe','','PGMECESE','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CERT_S','3','RAIN','I','Individuo','','P00RANAG','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CERT_S','4','CERT','C','Certific.','','PGMECERT','','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CERT','NO','','Non stampa Data del Giorno');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CERT','SI','','Stampa Data del Giorno');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CERT','X','','Stampa Data del Giorno con Nota');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_X','X','','Conferma della condizione proposta');

-- Inserimento ruoli altre voci dismesse 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
select menu.applicazione, app.ruolo, menu.padre, menu.figlio, menu.voce_menu, menu.sequenza,''
  from menu_ante_a22734_3 app
     , a_menu             menu
 where app.voce_menu = 'PXXSCEVE'
   and not exists ( select 'x' 
                      from a_menu
                     where voce_menu = 'PXHCTSCE'
                       and applicazione = 'GP4'
                       and ruolo = app.ruolo
                  )
   and menu.applicazione = 'GP4'
   and menu.voce_menu = 'PXHCTSCE'
;

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
select menu.applicazione, app.ruolo, menu.padre, menu.figlio, menu.voce_menu, menu.sequenza,''
  from menu_ante_a22734_3 app
     , a_menu             menu
 where app.voce_menu in ( 'PECSMCU4', 'PXXSMCU4' , 'PECSMCUD' )
   and not exists ( select 'x' 
                      from a_menu
                     where voce_menu = 'PECSMCU6'
                       and applicazione = 'GP4'
                       and ruolo = app.ruolo
                  )
   and menu.applicazione = 'GP4'
   and menu.voce_menu = 'PECSMCU6'
;

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
select menu.applicazione, app.ruolo, menu.padre, menu.figlio, menu.voce_menu, menu.sequenza,''
  from menu_ante_a22734_3 app
     , a_menu             menu
 where app.voce_menu in ( 'PXXCARDP' )
   and not exists ( select 'x' 
                      from a_menu
                     where voce_menu = 'PECCARDP'
                       and applicazione = 'GP4'
                       and ruolo = app.ruolo
                  )
   and menu.applicazione = 'GP4'
   and menu.voce_menu = 'PECCARDP'
;

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
select menu.applicazione, app.ruolo, menu.padre, menu.figlio, menu.voce_menu, menu.sequenza,''
  from menu_ante_a22734_3 app
     , a_menu             menu
 where app.voce_menu in ( 'PXXSMDSI' )
   and not exists ( select 'x' 
                      from a_menu
                     where voce_menu = 'PECSMDSI'
                       and applicazione = 'GP4'
                       and ruolo = app.ruolo
                  )
   and menu.applicazione = 'GP4'
   and menu.voce_menu = 'PECSMDSI'
;