alter table denuncia_emens add GESTIONE_ALTERNATIVA VARCHAR2(8);

start crt_gete.sql
start crf_denuncia_emens.sql
start crp_cursore_emens.sql
start crp_peccadmi.sql
start crv_emens.sql

insert into ESTRAZIONE_VALORI_CONTABILI 
(ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE)
select 'DENUNCIA_EMENS', 'BASE_CALCOLO_TFR', to_date('01-01-2007', 'dd-mm-yyyy'), null
     , 'Voce per Base Calcolo TFR - L.296/2006', 12, null, null, null, null
  from dual
 where not exists ( select 'x'
                      from ESTRAZIONE_VALORI_CONTABILI 
                     where estrazione = 'DENUNCIA_EMENS'
                       and colonna    = 'BASE_CALCOLO_TFR'
                  )
;

insert into ESTRAZIONE_VALORI_CONTABILI 
(ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE)
select 'DENUNCIA_EMENS', 'BASE_CALCOLO_PREV_COMPL', to_date('01-01-2007', 'dd-mm-yyyy'), null
     , 'Voce per Base Calcolo Previdenza Complementare - L.296/2006', 12
     , 'Caricamento Voci per Tipo Quota QFIS', null, null, null
  from dual
 where not exists ( select 'x'
                      from ESTRAZIONE_VALORI_CONTABILI 
                     where estrazione = 'DENUNCIA_EMENS'
                       and colonna    = 'BASE_CALCOLO_PREV_COMPL'
                  )
;
insert into ESTRAZIONE_VALORI_CONTABILI 
(ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE)
select 'DENUNCIA_EMENS', 'BASE_CALCOLO_QRUT', to_date('01-01-2007', 'dd-mm-yyyy'), null
     , 'Voce per Base Calcolo Previdenza Complementare - L.296/2006', 12
     , 'Caricamento Voci per Tipo Quota QRUT', null, null, null
  from dual
 where not exists ( select 'x'
                      from ESTRAZIONE_VALORI_CONTABILI 
                     where estrazione = 'DENUNCIA_EMENS'
                       and colonna    = 'BASE_CALCOLO_QRUT'
                  )
;
insert into ESTRAZIONE_VALORI_CONTABILI 
(ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE)
select 'DENUNCIA_EMENS', 'BASE_CALCOLO_QTFR', to_date('01-01-2007', 'dd-mm-yyyy'), null
     , 'Voce per Base Calcolo Previdenza Complementare - L.296/2006', 12
     , 'Caricamento Voci per Tipo Quota QTFR', null, null, null
  from dual
 where not exists ( select 'x'
                      from ESTRAZIONE_VALORI_CONTABILI 
                     where estrazione = 'DENUNCIA_EMENS'
                       and colonna    = 'BASE_CALCOLO_QTFR'
                  )
;
delete from a_selezioni where voce_menu = 'PECCADMI'; 

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCADMI','1','Elaborazione: Anno','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MESE','PECCADMI','2','Mese','2','N','N','','','|','',''); 
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
values ('P_GRUPPO','PECCADMI','8','Gruppo :','4','U','N','%','','GRRA','0','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_POSIZIONE','PECCADMI','9','Posizione Giuridica :','4','U','N','%','','POSI','3','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RUOLO','PECCADMI','10','Identificativo Flag Ruolo :','1','U','N','N','P_RUOLO','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_GG','PECCADMI','11','Tipo Giorni :','1','U','S','I','P_TIPO_GG','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SFASATO','PECCADMI','12','Rif. denuncia Anticipato:','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_POSTICIPATO','PECCADMI','13','Rif. denuncia Posticipato:','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_NO_UTILI','PECCADMI','14','Azzeramento Sett. Utili','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TFR','PECCADMI','15','Inserimento TFR Febbraio','1','U','N','','P_01','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_PRIVATI','PECCADMI','16','Accantonamento TFR PRIVATI:','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_GESTIONE_TFR','PECCADMI','17','Gestione TFR L.296/2006:','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MAL_PRIVATI','PECCADMI','18','Malattie Enti PRIVATI','1','U','N','','P_MAL_PRIVATI','','','');

delete from a_guide_o where guida_o = 'P_CADMI';

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_CADMI','1','PREN','P','Prenot.','ACAEPRPA','*');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CADMI','2','RAIN','I','Individui','P00RANAG','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_CADMI','3','GEST','G','Gestioni','PGMEGEST','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_CADMI','4','CLRA','R','Rapporti','PAMDCLRA','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_CADMI','5','GRRA','U','grUppi','PAMDGRRA','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_CADMI','6','POSI','S','poSizioni','PGMDPOSI','');