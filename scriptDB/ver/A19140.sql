delete from caselle_fiscali 
where anno >= 2006 ;

alter table denuncia_fiscale add 
( C162 NUMBER(20,5) NULL
, C163 NUMBER(20,5) NULL
, C164 NUMBER(20,5) NULL
, C165 NUMBER(20,5) NULL
);

-- reinserisco cafi per 2006

insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 1, 'Casella 1', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 2, 'Casella 2', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 3, 'Casella 3', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 4, 'Casella 4', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 5, 'Casella 5', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 6, 'Casella 6', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 7, 'Casella 7', null, null, 'T', '32');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 8, 'Casella 8', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 9, 'Casella 9', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 10, 'Casella 10', null, null, 'T', '37');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 11, 'Casella 11', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 12, 'Casella 12', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 13, 'Casella 13', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 14, 'Casella 14', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 15, 'Casella 15', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 16, 'Casella 16', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 17, 'Casella 17', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 18, 'Casella 18', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 19, 'Casella 19', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 20, 'Casella 20', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 21, 'Casella 21', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 22, 'Casella 22', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 26, 'Casella 26', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 27, 'Casella 27', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 28, 'Casella 28', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 29, 'Casella 29', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 30, 'Casella 30', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 31, 'Casella 31', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 32, 'Casella 7 Bis', null, null, 'T', '8');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 33, 'Casella 33', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 34, 'Casella 34', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 35, 'Casella 35', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 36, 'Casella 36', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 37, 'Casella 10 Bis', null, null, 'T', '11');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 43, 'Casella 43', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 44, 'Casella 44', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 45, 'Casella 45', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 46, 'Casella 46', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 57, 'Casella 57', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 58, 'Casella 58', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 59, 'Casella 59', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 60, 'Casella 60', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 69, 'Casella 69', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 70, 'Casella 70', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 71, 'Casella 71', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 72, 'Casella 72', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 73, 'Casella 73', null, null, 'T', '103');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 103, 'Cas.8 Prev.Com.', null, null, 'T', '104');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 104, 'Cas.10 Ev. Ecc.', null, null, 'T', '141');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 139, 'App. per Note', null, null, 'T', '160');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 141, 'Prev - Cas.5', null, null, 'T', '139');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 160, 'Prev.Cas.73', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 161, 'Prev.Cas.74', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 162, 'Prev.Cas.75', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 163, 'Prev.Cas.76', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'C', 164, 'Prev.Cas.77', null, null, 'T', null);

-- reinserisco cafi per 2007 come copia del 2006

insert into caselle_fiscali 
( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT )
select 2007, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT
from caselle_fiscali
 where anno = 2006
;

-- reinserimento dei parametri di CARFI

delete from a_selezioni where voce_menu = 'PECCARFI'; 

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_DENUNCIA','PECCARFI','0','Tipo Denuncia','10','U','N','CUD','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCARFI','1','Anno','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECCARFI','2','Gestione ....:','4','U','S','%','','GEST','1','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECCARFI','3','Archiviazione:','1','U','S','T','P_CARCP','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DAL','PECCARFI','4','Cessazione : Dal','10','D','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_AL','PECCARFI','5',' Al','10','D','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECCARFI','6','Singolo Individuo : Codice','8','N','N','','','RAIN','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO_SFASATO','PECCARFI','7','Anno Prev.da Nov.(note gg.det)','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_EVENTO','PECCARFI','8','Codice Eventi Eccezionali','1','U','N','','','','',''); 

-- inserimento intestazione DESRE per colonna ONERI_29
INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE ) 
VALUES (  'DENUNCIA_CUD', 'ONERI_29',  TO_Date( '01/01/2006 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
       , NULL, 'Spese per la frequenza asili nido', 29, 'Spese per la frequenza asili nido', NULL, NULL, NULL)
;

start crp_peccarfi.sql