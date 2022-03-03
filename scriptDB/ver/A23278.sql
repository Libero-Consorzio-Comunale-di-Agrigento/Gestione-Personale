delete from pec_ref_codes
where rv_domain = 'DENUNCIA_O1_INPS.QUALIFICA'
  and substr(rv_low_value,1,1) in ( 'A', 'E','F','G','H','L','M','N')
/

delete from PEC_REF_CODES where rv_domain = 'DENUNCIA_EMENS.QUALIFICA1';

insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('1', null, '1', 'DENUNCIA_EMENS.QUALIFICA1', 'Operaio', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('2', null, '2', 'DENUNCIA_EMENS.QUALIFICA1', 'Impiegato', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('3', null, '3', 'DENUNCIA_EMENS.QUALIFICA1', 'Dirigente ( compresi i dirigenti già iscritti INPDAI al 31/12/2002 )', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('4', null, '20', 'DENUNCIA_EMENS.QUALIFICA1', 'Apprendista non sogg.INAIL (valido fino al 31/12/2006 )', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('5', null, '5', 'DENUNCIA_EMENS.QUALIFICA1', 'Apprendista', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('6', null, '6', 'DENUNCIA_EMENS.QUALIFICA1', 'Lavoratore Domicilio', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('7', null, '7', 'DENUNCIA_EMENS.QUALIFICA1', 'Equiparato Intermedio', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('8', null, '8', 'DENUNCIA_EMENS.QUALIFICA1', 'Viaggiatore Piazzista', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('9', null, '9', 'DENUNCIA_EMENS.QUALIFICA1', 'Dirigenti di aziende ind. assunti dall''01/01/2003 iscritti al F.P.L.D.', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('A', null, '21', 'DENUNCIA_EMENS.QUALIFICA1', 'Atipica ex INPDAI', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('B', null, '22', 'DENUNCIA_EMENS.QUALIFICA1', 'Lavoratore domestico dipendente da agenzia di lavoro interinale (articolo 117, legge 23 dicembre 2000, n. 388)', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('E', null, '23', 'DENUNCIA_EMENS.QUALIFICA1', 'Pilota ( fondo volo )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('F', null, '24', 'DENUNCIA_EMENS.QUALIFICA1', 'Pilota in addestramento ( primi 12 mesi )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('G', null, '25', 'DENUNCIA_EMENS.QUALIFICA1', 'Pilota collaudatore', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('H', null, '26', 'DENUNCIA_EMENS.QUALIFICA1', 'Tecnico di volo', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('L', null, '27', 'DENUNCIA_EMENS.QUALIFICA1', 'Tecnico di volo in addestramento ( primi 12 mesi )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('M', null, '28', 'DENUNCIA_EMENS.QUALIFICA1', 'Tecnico di volo per i collaudi', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('N', null, '29', 'DENUNCIA_EMENS.QUALIFICA1', 'Assistente di volo', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('P', null, '11', 'DENUNCIA_EMENS.QUALIFICA1', 'Giornalista iscritto all''INPGI', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('Q', null, '12', 'DENUNCIA_EMENS.QUALIFICA1', 'Lavoratore con qualifica di Quadro', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('R', null, '13', 'DENUNCIA_EMENS.QUALIFICA1', 'Apprendista qualificato Impiegato', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('W', null, '14', 'DENUNCIA_EMENS.QUALIFICA1', 'Apprendista qualificato Operaio', 'CFG', null, null);