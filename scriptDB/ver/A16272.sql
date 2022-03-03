insert into a_errori ( errore, descrizione ) 
values ('P00567' , 'Verificare data dell''infortunio: e'' maggiore della data odierna');

insert into a_errori ( errore, descrizione ) 
values ('P00568' , 'Qualifica INAIL non presente');

insert into a_errori ( errore, descrizione ) 
values ('P00569' , 'Specificare la qualifica');




delete from pec_ref_codes
 where rv_domain = 'DENUNCIA_INAIL.QUALIFICA';

insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('01', 'DENUNCIA_INAIL.QUALIFICA', 'DIRIGENTE', 'DIRIGENTE', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('02', 'DENUNCIA_INAIL.QUALIFICA', 'DIRETTIVO-QUADRO', 'DIRETTIVO-QUADRO', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('03', 'DENUNCIA_INAIL.QUALIFICA', 'IMPIEGATO O INTERMEDIO', 'IMPIEGATO O INTERM.', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('04', 'DENUNCIA_INAIL.QUALIFICA', 'OPERAIO SPECIALIZZATO', 'OPERAIO SPECIALIZZ.', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('05', 'DENUNCIA_INAIL.QUALIFICA', 'OPERAIO COMUNE', 'OPERAIO COMUNE', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('06', 'DENUNCIA_INAIL.QUALIFICA', 'SOVRINTENDENTE', 'SOVRINTENDENTE', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('07', 'DENUNCIA_INAIL.QUALIFICA', 'LAVORATORE A DOMICILIO', 'LAVORATORE A DOMIC.', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('08', 'DENUNCIA_INAIL.QUALIFICA', 'VIAGGIATORE - PIAZZISTA', 'VIAGG. - PIAZZISTA', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('09', 'DENUNCIA_INAIL.QUALIFICA', 'MEDICO RADIOLOGO', 'MEDICO RADIOLOGO', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('10', 'DENUNCIA_INAIL.QUALIFICA', 'DETENUTO', 'DETENUTO', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('11', 'DENUNCIA_INAIL.QUALIFICA', 'RICOVERATO IN CASA DI CURA', 'RICOV. CASA DI CURA', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('12', 'DENUNCIA_INAIL.QUALIFICA', 'RELIGIOSO/A', 'RELIGIOSO/A', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('13', 'DENUNCIA_INAIL.QUALIFICA', 'ARTIGIANO', 'ARTIGIANO', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('14', 'DENUNCIA_INAIL.QUALIFICA', 'ESERCENTE ATTIVITA'' COMMERCIALE', 'ESERC. ATTIV. COMM.', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('15', 'DENUNCIA_INAIL.QUALIFICA', 'APPRENDISTA ARTIGIANO', 'APPR. ARTIGIANO', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('16', 'DENUNCIA_INAIL.QUALIFICA', 'APPRENDISTA NON ARTIGIANO', 'APPR. NON ARTIG.', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('17', 'DENUNCIA_INAIL.QUALIFICA', 'TIROCINANTE', 'TIROCINANTE', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('18', 'DENUNCIA_INAIL.QUALIFICA', 'CONTRATTO FORMAZIONE LAVORO', 'CONTR. FORM. LAVORO', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('19', 'DENUNCIA_INAIL.QUALIFICA', 'BORSISTA', 'BORSISTA', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('20', 'DENUNCIA_INAIL.QUALIFICA', 'STAGISTA', 'STAGISTA', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('21', 'DENUNCIA_INAIL.QUALIFICA', 'PIANO INSERIMENTO PROFESSIONALE', 'PIANO INSER. PROF.', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('22', 'DENUNCIA_INAIL.QUALIFICA', 'ALLIEVO CORSI QUALIFICAZIONE', 'ALL. CORSI QUALIF.', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('23', 'DENUNCIA_INAIL.QUALIFICA', 'ISTRUTTORE CORSI QUALIFICAZIONE', 'ISTR. CORSI QUALIF.', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('24', 'DENUNCIA_INAIL.QUALIFICA', 'STUDENTE', 'STUDENTE', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('25', 'DENUNCIA_INAIL.QUALIFICA', 'SPORTIVO PROFESSIONISTA', 'SPORTIVO PROFESS.', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('26', 'DENUNCIA_INAIL.QUALIFICA', 'ADDETTO A LAVORO SOCIALMENTE UTILE', 'ADDETTO LSU', 'CFG');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning, rv_abbreviation, rv_type )
values('99', 'DENUNCIA_INAIL.QUALIFICA', 'ALTRO', 'ALTRO', 'CFG');
