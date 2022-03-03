update RIFERIMENTO_FINE_ANNO 
   set tipo_denuncia = 'S'
 where tipo_denuncia = 'C'
;

prompt Deleting CASELLE_FISCALI...
delete from CASELLE_FISCALI where anno = 2006 and tipo_dichiarazione = 'S';
prompt Loading CASELLE_FISCALI...
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 1, 'Casella 1', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 2, 'Casella 2', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 3, 'Casella 3', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 4, 'Casella 4', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 5, 'Casella 5', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 6, 'Casella 6', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 7, 'Casella 7', null, null, 'T', '32');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 8, 'Casella 8', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 9, 'Casella 9', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 10, 'Casella 10', null, null, 'T', '37');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 11, 'Casella 11', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 12, 'Casella 12', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 13, 'Casella 13', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 14, 'Casella 14', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 15, 'Casella 15', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 16, 'Casella 16', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 17, 'Casella 17', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 18, 'Casella 18', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 19, 'Casella 19', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 20, 'Casella 20', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 21, 'Casella 21', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 22, 'Casella 22', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 23, '770: Casella 23', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 24, '770: Casella 24', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 25, '770: Casella 25', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 26, 'Casella 26', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 27, 'Casella 27', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 28, 'Casella 28', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 29, 'Casella 29', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 30, 'Casella 30', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 31, 'Casella 31', null, null, 'T', '101');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 32, 'Casella 7 Bis', null, null, 'T', '8');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 33, 'Casella 33', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 34, 'Casella 34', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 35, 'Casella 35', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 36, 'Casella 36', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 37, 'Casella 10 Bis', null, null, 'T', '11');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 38, '770: Casella 38', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 39, '770: Casella 39', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 40, '770: Casella 40', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 41, '770: Casella 41', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 42, '770: Casella 42', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 43, 'Casella 43', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 44, 'Casella 44', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 45, 'Casella 45', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 46, 'Casella 46', null, null, 'T', '102');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 48, '770: Casella 48', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 49, '770: Casella 49', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 50, '770: Casella 50', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 51, '770: Casella 51', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 52, '770: Casella 52', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 53, '770: Casella 53', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 54, '770: Casella 54', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 55, '770: Casella 55', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 56, '770: Casella 56', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 57, 'Casella 57 / 62', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 58, 'Casella 58 / 63', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 59, 'Casella 59 / 64', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 60, 'Casella 60 / 65', null, null, 'D', '145');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 61, '770: casella 66', null, null, 'D', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 62, '770: Casella 67', null, null, 'D', '105');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 69, 'Casella 69', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 70, 'Casella 70', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 71, 'Casella 71', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 72, 'Casella 72', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 73, 'Casella 73', null, null, 'T', '103');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 74, 'TFR: Casella 76', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 75, 'TFR: Casella 77', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 76, 'TFR: Casella 78', null, null, 'T', '142');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 77, 'TFR: Casella 80', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 78, 'TFR: Casella 81', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 79, 'TFR: Casella 82', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 80, 'TFR: Casella 83', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 81, 'TFR: Casella 84', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 82, 'TFR: Casella 85', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 83, 'TFR: Casella 86', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 84, 'TFR: Casella 87', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 85, 'TFR: Casella 89', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 86, 'TFR: Casella 90', null, null, 'T', '143');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 87, 'TFR: Casella 92', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 88, 'TFR: Casella 93', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 89, 'TFR: Casella 94', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 90, 'TFR: Casella 95', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 91, 'TFR: Casella 96', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 92, 'TFR: Casella 97', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 93, 'TFR: Casella 99', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 94, 'TFR: Cas. 100', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 95, 'TFR: Cas. 101', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 96, 'TFR: Cas. 102', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 97, 'TFR: Cas. 103', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 98, 'TFR: Cas. 104', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 99, 'TFR: Cas. 106', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 100, 'TFR: Cas. 107', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 101, '770: Casella 32', null, null, 'T', '33');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 102, '770: Casella 47', null, null, 'D', '48');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 103, 'Cas.8 Prev.Com.', null, null, 'T', '104');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 104, 'Cas.10 Ev. Ecc.', null, null, 'T', '139');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 105, '770: Casella 68', null, null, 'D', '69');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 108, 'TFR: Casella 74', null, null, 'T', '109');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 109, 'TFR: Casella 75', null, null, 'T', '74');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 111, 'TFR: Cas. 108', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 112, 'TFR: Cas. 110', null, null, 'T', '144');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 113, 'TFR: Cas. 112', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 114, 'TFR: Cas. 113', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 115, 'TFR: Cas. 114', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 116, 'TFR: Cas. 115', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 117, 'TFR: Cas. 116', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 118, 'TFR: Cas. 117', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 119, 'TFR: Cas. 119', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 120, 'TFR: Cas. 120', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 121, 'TFR: Cas. 121', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 122, 'TFR: Cas. 122', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 123, 'TFR: Cas. 124', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 124, 'TFR: Cas. 125', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 125, 'TFR: Cas. 126', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 126, 'TFR: Cas. 128', null, null, 'T', '146');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 127, 'TFR: Cas. 150', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 128, 'TFR: Cas. 151', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 129, 'TFR: Cas. 152', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 130, 'TFR: Cas. 153', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 131, 'TFR: Cas. 154', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 132, 'TFR: Cas. 155', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 133, 'TFR: Cas. 156', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 134, 'TFR: Cas. 157', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 135, 'TFR: Cas. 158', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 136, 'TFR: Cas. 159', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 137, 'TFR: Cas. 160', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 138, 'TFR: Cas. 161', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 139, 'App. per Note', null, null, 'T', '108');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 140, 'TFR: Cas. 162', null, null, 'T', '141');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 141, 'Prev - Cas.5', null, null, 'T', '160');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 142, 'TFR: Casella 79', null, null, 'T', '77');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 143, 'TFR: Casella 91', null, null, 'T', '87');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 144, 'TFR: Cas. 111', null, null, 'T', '113');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 145, '770: Casella 61', null, null, 'T', '61');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 146, 'TFR: Cas. 129', null, null, 'T', '127');
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 160, 'Prev.Cas.73', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 161, 'Prev.Cas.74', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 162, 'Prev.Cas.75', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 163, 'Prev.Cas.76', null, null, 'T', null);
insert into CASELLE_FISCALI (ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, TIPO_CASELLA, CASELLA_DETT)
values (2006, 'S', 164, 'Prev.Cas.77', null, null, 'T', null);
prompt Done.
