INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE,
DESCRIZIONE_AL1, DESCRIZIONE_AL2, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA,
DIVIDE ) VALUES ( 
'DENUNCIA_EMENS', 'MALATTIE',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Voci malattie per privati', NULL, NULL, 11, NULL, NULL, NULL, NULL); 

-- Parametri di selezione 
delete from a_selezioni where voce_menu = 'PECCADMI';
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCADMI','1','Elaborazione: Anno','4','N','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MESE','PECCADMI','2','  Mese','2','N','N','','','|','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECCADMI','3','Tipo Elaborazione :','1','U','S','T','P_CADMI','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECCADMI','4','Singolo Individuo: Codice','8','N','N','','','RAIN','0','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECCADMI','5','Gestione :','4','U','N','%','','GEST','1','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FASCIA','PECCADMI','6','Fascia :','2','U','N','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RAPPORTO','PECCADMI','7','Rapporto :','4','U','N','%','','CLRA','0','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RUOLO','PECCADMI','8','Identificativo Flag Ruolo :','1','U','N','N','P_RUOLO','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_GG','PECCADMI','9','Tipo Giorni :','1','U','S','I','P_TIPO_GG','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SFASATO','PECCADMI','10','Rif. denuncia Anticipato:','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_POSTICIPATO','PECCADMI','11','Rif. denuncia Posticipato:','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_PRIVATI','PECCADMI','12','Accantonamento TFR PRIVATI:','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MAL_PRIVATI','PECCADMI','13','Malattie Enti PRIVATI','1','U','N','','P_X','','','');

-- Modifica indice
drop index seie_pk;
CREATE INDEX SEIE_PK on SETTIMANE_EMENS
(     ci
    , anno
    , mese
    , id_settimana
    , dal
);

start crv_vaev.sql
start crv_dade.sql
-- inserita nel file A10978
-- start crp_peccadmi.sql