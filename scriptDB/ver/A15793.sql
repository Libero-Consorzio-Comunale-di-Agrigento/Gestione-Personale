-- Nuovo ref_codes DATI_PARTICOLARI_EMENS.IDENTIFICATORE
delete from pec_ref_codes where rv_domain = 'DATI_PARTICOLARI_EMENS.IDENTIFICATORE';
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'PREAVVISO' , '1', 'DATI_PARTICOLARI_EMENS.IDENTIFICATORE', 'Preavviso' );
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'BONUS' , '2', 'DATI_PARTICOLARI_EMENS.IDENTIFICATORE', 'Bonus' );
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'ATIPICA' , '3', 'DATI_PARTICOLARI_EMENS.IDENTIFICATORE', 'Atipica' );
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'SINDACALI' , '4', 'DATI_PARTICOLARI_EMENS.IDENTIFICATORE', 'Sindacali' );
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'ESTERO' , '5', 'DATI_PARTICOLARI_EMENS.IDENTIFICATORE', 'Estero' );

-- Nuovo ref_codes DENUNCIA_EMENS.RETTIFICA
delete from pec_ref_codes where rv_domain = 'DENUNCIA_EMENS.RETTIFICA';
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'S', '1', 'DENUNCIA_EMENS.RETTIFICA', 'Sostituzione Completa');
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'E', '2', 'DENUNCIA_EMENS.RETTIFICA', 'Eliminazione');
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'I', '3', 'DENUNCIA_EMENS.RETTIFICA', 'Integrazione/Sostituzione dei dati variati');

-- Nuovo ref_codes DENUNCIA_EMENS.TIPO_AGEVOLAZIONE
delete from pec_ref_codes where rv_domain = 'DENUNCIA_EMENS.TIPO_AGEVOLAZIONE';
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( '01', '1','DENUNCIA_EMENS.TIPO_AGEVOLAZIONE'
       , 'Agevolazione contributiva in favore degli ex LSU che collaborano con la PA');

-- Nuovo ref_codes DENUNCIA_EMENS.COD_CERTIFICAZIONE
delete from pec_ref_codes where rv_domain = 'DENUNCIA_EMENS.COD_CERTIFICAZIONE';
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( '001', '1', 'DENUNCIA_EMENS.COD_CERTIFICAZIONE', 'Direzione Provinciale del Lavoro');
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( '002', '2', 'DENUNCIA_EMENS.COD_CERTIFICAZIONE', 'Provincia');
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( '003', '3', 'DENUNCIA_EMENS.COD_CERTIFICAZIONE', 'Universita' );
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( '004', '4', 'DENUNCIA_EMENS.COD_CERTIFICAZIONE', 'Enti Bilaterali');

-- Nuovo ref_codes DENUNCIA_EMENS.COD_CALAMITA
delete from pec_ref_codes where rv_domain = 'DENUNCIA_EMENS.COD_CALAMITA';
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( '01', '1', 'DENUNCIA_EMENS.COD_CALAMITA', 'Sospensione dei versamenti a seguito emergenza BSE (L.n.305/2001)');

-- Nuovo ref_codes FONDI_SPECIALI_EMENS.FONDO
delete from pec_ref_codes where rv_domain = 'FONDI_SPECIALI_EMENS.FONDO';
insert into PEC_REF_CODES  ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'ANTE95', '1', 'FONDI_SPECIALI_EMENS.FONDO' , 'Iscritti ai Fondi Sostitutivi');


