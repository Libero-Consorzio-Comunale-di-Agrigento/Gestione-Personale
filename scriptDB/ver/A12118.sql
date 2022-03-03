delete from pec_ref_codes
where rv_domain = 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
and rv_low_value in ('F5','F6','F7','G0','H0','P5','P6','P7')
/

delete from pec_ref_codes where rv_domain = 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE';

insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('0', null, '0', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Senza particolarita contributive ( Assicurazioni Barrate IVS-DS-FG )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('15', null, '15', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Lavoratori CFL tipo B trasformato a tempo indeterminato ( contribuzione in misura fissa legge 451/1994 )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('32', null, '32', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Lavoratori avventizi non iscritti al fondo di previdenza addetti ai pubblici servizi di trasporto', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('37', null, '37', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Lavoratori richiamati alle armi', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('38', null, '38', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Lavoratori CFL tipo B trasformato a tempo indeterminato ( riduzione del 50% legge 451/1994 )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('39', null, '39', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Lavoratori CFL tipo B trasformato a tempo indeterminato ( riduzione del 25% legge 451/1994 )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('40', null, '40', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Lavoratori CFL tipo B trasformato a tempo indeterminato ( riduzione del 40% legge 451/1994 )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('48', null, '48', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Personale religioso escluso DS e Maternita con contributo GESCAL in misura ridotta', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('49', null, '49', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Personale religioso escluso DS/CUAF/GESCAL e Maternita', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('54', null, '54', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Contratto Formazione Lavoro Art.5 L.291/1988 ( Rid. 50% )', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('56', null, '56', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Contratto Formazione Lavoro Art.9 D.L.337/1990 ( Rid.25% )', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('57', null, '57', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Contratto Formazione Lavoro Art.8 L.407/1990 ( Rid.40% )', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('61', null, '61', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Dipendenti EP soggetti a IVS e d.p.r. INPS 79/1999', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('62', null, '62', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Dipendenti EP soggetti a IVS INPS 79/1999', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('65', null, '65', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Lavoratori assunti con CFL con beneficio generalizzato del 25% (cir. Inps n. 85 del 2001)', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('70', null, '70', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Lavoratori esclusi dalla contribuzione IVS ex art.75,legge n. 388/200 (cir. Inps n.118 del 2001)', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('71', null, '71', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Dipendenti EP solo contribuzione DS', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('72', null, '72', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Optanti INPDAP soggetti a DS e TFR', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('80', null, '80', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Bonus per Posticipo Pensionamento ( Lavoratori esclusi dalla contribuzione IVS art.1,co.12,Legge 243/2004 )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('99', null, '99', 'DENUNCIA_EMENS.TIPO_CONTRIBUZIONE', 'Personale Religioso ( clero ) non soggetto a GESCAL e maternità', 'CFG', null, null);


delete from PEC_REF_CODES where rv_domain = 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE';

insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('0', null, '0', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Senza particolarita contributive ( Assicurazioni Barrate IVS-DS-FG )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('03', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate DS-FG', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('10', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate FG', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('15', null, '15', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori CFL tipo B trasformato a tempo indeterminato ( contribuzione in misura fissa legge 451/1994 )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('32', null, '32', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori avventizi non iscritti al fondo di previdenza addetti ai pubblici servizi di trasporto', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('37', null, '37', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori richiamati alle armi', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('38', null, '38', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori CFL tipo B trasformato a tempo indeterminato ( riduzione del 50% legge 451/1994 )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('39', null, '39', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori CFL tipo B trasformato a tempo indeterminato ( riduzione del 25% legge 451/1994 )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('40', null, '40', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori CFL tipo B trasformato a tempo indeterminato ( riduzione del 40% legge 451/1994 )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('48', null, '48', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Personale religioso escluso DS e Maternita con contributo GESCAL in misura ridotta', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('49', null, '49', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Personale religioso escluso DS/CUAF/GESCAL e Maternita', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('52', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Contratto Solidarieta` Art.2 L.863/1984', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('53', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Contratto Formazione Lavoro Art.3 L.863/1984', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('54', null, '54', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Contratto Formazione Lavoro Art.5 L.291/1988 ( Rid. 50% )', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('55', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Altre Assicurazioni', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('56', null, '56', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Contratto Formazione Lavoro Art.9 D.L.337/1990 ( Rid.25% )', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('57', null, '57', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Contratto Formazione Lavoro Art.8 L.407/1990 ( Rid.40% )', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('58', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori con riduzione contributi Art.8 L.407/1990', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('59', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori esenti contributi Art.8 L.407/1990', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('61', null, '61', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Dipendenti EP soggetti a IVS e d.p.r. INPS 79/1999 ( Assicurazioni Barrate IVS-DS-FG )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('62', null, '62', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Dipendenti EP soggetti a IVS INPS 79/1999 ( Assicurazioni Barrate IVS-FG )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('63', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate IVS', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('64', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate FG', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('65', null, '65', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori assunti con CFL con beneficio generalizzato del 25% (cir. Inps n. 85 del 2001) ( Lavoratori assunti con Contratto di Formazione per i quali compete al datore di lavoro il beneficio generalizzato del 25% (cir. Inps n. 85 del 2001)', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('66', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoro disabili aventi titolo alla fiscalizzazione totale di cui all''articolo 13,comma 1, lett. A,della legge n. 68 del 1999', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('67', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoro disabili aventi titolo alla fiscalizzazione nella misura del 50% di cui all'' articolo 13, comma 1,lett.B,della legge 68 del 1999', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('68', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoro interinali per i quali compete al datore di lavoro la riduzione del 50% ex D.Lgs. n.151/2001 (circ. Inps n.136 del 2001)', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('69', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori assunti con Contratto di Formazione secondo le regole del "de minimis" (circ. Inps n.85 del 2001)', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('70', null, '70', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori esclusi dalla contribuzione IVS ex art.75,legge n. 388/200 (cir. Inps n.118 del 2001) ( Lavoratori esclusi dalla contribuzione IVS ex art.75,legge n. 388/200 (cir. Inps n.118 del 2001)', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('71', null, '71', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Dipendenti EP solo contribuzione DS ( Assicurazioni Barrate DS )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('72', null, '72', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Optanti INPDAP soggetti a DS e TFR ( Assicurazioni Barrate DS-FG )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('73', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate IVS-DS', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('76', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori in mobilita` assunti con contratto a termine ex art.8 comma 2 legge 223/91.', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('77', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate IVS-DS-FG', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('79', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori ammessi ai benefici ex legge n.193/2000 (circ. Inps n.134 del 2002)', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('80', null, '80', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Bonus per Posticipo Pensionamento ( Lavoratori esclusi dalla contribuzione IVS art.1,co.12,Legge 243/2004 )', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('82', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori tempo det.,assunti in sostituzione di personale in astensione dal lavoro (art. 10 legge n.53 del 2000),per i quali al datore di lavoro compete la riduzione del 50 per cento (circ. 117 del 2000)', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('86', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori ex-cassaintegrati assunti a TP e Indet. art.4 comma 3 legge 20/93', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('95', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori interessati dal contratto di riallineamento o di gradualita'' denunciati per la prima volta all''istituto ai sensi dell''art. 75 legge 23 dicembre 1998,n.448 (circ. INPS n.59 e n.115 del 2000)', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('96', null, null, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori interessati dal contratto di riallineamento o di gradualita'' gia'' denunciati all''istituto ai sensi dell''art. 75 legge 23 dicembre 1998,n.448 (circ. INPS n.59 e n.115 del 2000)', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('99', null, '99', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Personale Religioso ( clero ) non soggetto a GESCAL e maternità', 'CFG', null, null);
