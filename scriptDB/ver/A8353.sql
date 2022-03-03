start crv_psep.sql

start crv_vpsm.sql

start crv_vevc.sql

start crt_ddma.sql

ALTER TABLE GESTIONI ADD (PROGRESSIVO_INPDAP NUMBER(5) );

ALTER TABLE GESTIONI ADD (COMPARTO VARCHAR2(2) );

ALTER TABLE GESTIONI ADD (SOTTOCOMPARTO VARCHAR2(2) );

ALTER TABLE GESTIONI ADD (FORMA_GIURIDICA NUMBER(2) );

ALTER TABLE GESTIONI ADD (FIRMATARIO_DMA NUMBER(8) );

ALTER TABLE ENTE ADD (CF_SOFTWARE VARCHAR2(16) );

ALTER TABLE TRATTAMENTI_PREVIDENZIALI ADD (FINE_SERVIZIO NUMBER(1) );

INSERT INTO PGM_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'15', NULL, NULL, 'GESTIONI.FORMA_GIURIDICA', 'Enti Pubblici non Economici', NULL
, NULL, NULL); 
INSERT INTO PGM_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'18', NULL, NULL, 'GESTIONI.FORMA_GIURIDICA', 'Enti Ospedalieri', NULL, NULL, NULL); 
INSERT INTO PGM_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'19', NULL, NULL, 'GESTIONI.FORMA_GIURIDICA', 'Enti ed Istituzioni di Previdenza e Assistenza sociale'
, NULL, NULL, NULL); 
INSERT INTO PGM_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'21', NULL, NULL, 'GESTIONI.FORMA_GIURIDICA', 'Aziende Regionali, Provinciali, Comunali e loro consorzi'
, NULL, NULL, NULL); 
INSERT INTO PGM_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'50', NULL, NULL, 'GESTIONI.FORMA_GIURIDICA', 'Societa per azioni, aziende speciali e consorzi (artt.31, 113, 114, 115 e 166 D.Lgs.18/8/2000)'
, NULL, NULL, NULL); 

INSERT INTO PGM_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'30', NULL, NULL, 'ASTENSIONI.CAT_FISCALE', 'Servizio non utile', NULL, NULL, NULL); 
INSERT INTO PGM_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'31', NULL, NULL, 'ASTENSIONI.CAT_FISCALE', 'Servizio ed aspettativa non retribuita per motivi sindacali (art. 31, L.3000/1970)'
, NULL, NULL, NULL); 

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'1', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.FINE_SERVIZIO', 'TFR', NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'2', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.FINE_SERVIZIO', 'Optante', NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'3', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.FINE_SERVIZIO', 'TFS', NULL, NULL, NULL); 


INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'M', NULL, NULL, 'DENUNCIA_DMA.TIPO_PART_TIME', 'Misto', NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'P', NULL, NULL, 'DENUNCIA_DMA.TIPO_PART_TIME', 'Orizzontale', NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'V', NULL, NULL, 'DENUNCIA_DMA.TIPO_PART_TIME', 'Verticale', NULL, NULL, NULL); 

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'1', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Decesso', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'10', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', '(2000) Infermit` non dipendente da causa di servizio'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'11', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Esubero Portuali L.n. 647 23/12/96'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'12', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Mobilit`', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'13', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Passaggio ad Altra Amministrazione'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'14', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Licenziamento', 'CFG', NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'15', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Fine ferma', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'16', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Altre Cause', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'17', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Dispensa dal servizio per inabilita'' permanente assoluta a proficuo lavoro (minimo 15 anni)'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'18', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Fine incarico', NULL, NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'2', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Dimissioni volontarie', 'CFG'
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'3', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Limiti di eta''', 'CFG', NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'4', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Limiti di servizio', 'CFG', NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'5', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Dispensa del servizio', 'CFG'
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'6', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Invalidita''', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'7', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', '(2000) Esodo legge n.26 del 1987'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'8', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Soppressione di posto', 'CFG'
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'9', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Destituzione', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'001', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Navigazione in volo - L 1092 del 1973,art.20'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'32', NULL, 'SOSPENSIONE', 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Sospensione di periodo lavorativo utile'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'33', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Carica elettiva art.86 L.267/2000 (T.U. Enti Locali)'
, NULL, NULL, NULL); 

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'002', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio di confine', 'CFG', NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'003', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio di confine', 'CFG', NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'004', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio in stabilimenti di pena militari'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'005', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio all estero in sedi particolarmente disagiate'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'006', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio all''estero in sedi disagiate'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'007', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio scolastico all estero'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'008', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio scolastico all estero'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'009', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Lavori insalubri e polverifici'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'010', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio in colonia e in territorio somalo'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'011', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio in colonia e in territorio somalo'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'012', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio in zona di armistizio'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'013', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio in zona di armistizio'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'014', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio in presenza di amianto'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'015', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Lavoro usurante', 'CFG', NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'016', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Lavoro usurante', 'CFG', NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'017', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Esodo portuale', 'CFG', NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'018', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio all''estero', 'CFG'
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'019', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Non vedente', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'020', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Lavoratore precoce', NULL, NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'021', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Combattenti e relativi superstiti'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'022', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio di istituto', NULL, NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'023', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Impiego operativo di campagna'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'024', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Impiego operativo truppe alpine'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'025', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Navigazione mercantile', NULL
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'026', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Imbarco su mezzi di superfice'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'027', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Imbarco su sommergibili', NULL
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'028', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio addetti alle macchine'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'029', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio a bordo di navi militari'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'030', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Controllo spazio aereo I livello'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'031', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Controllo spazio aereo II livello'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'032', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Controllo spazio aereo III livello'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'033', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Servizio apparati R.T.- R.T.F.'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'034', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'L.302 del 1982 art.2', NULL, NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'035', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Cooperazione con paesi in via di sviluppo'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'036', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Sei scatti stipendiali D.Lgs.165 del 1997'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'037', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Personale addetto alla commutazione telefonica'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'038', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Personale ENAV: CTA - piloti - operatori radiomisure - D.Lgs. 149 del 1997'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'039', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Personale ENAV: assistenti EAV e meteo - D.Lgs. 149 del 1997'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'040', NULL, NULL, 'DENUNCIA_DMA.MAGGIORAZIONI', 'Lavori particolarmenti usuranti - D. Lavoro 17/04/2001'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'E0', NULL, 'E0', 'DENUNCIA_DMA.RILEVANZA', 'Dati Mese Corrente', NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'V1', NULL, 'V1', 'DENUNCIA_DMA.RILEVANZA', 'Dati Rettificativi', NULL, NULL, NULL); 
COMMIT;
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'I', NULL, NULL, 'DENUNCIA_DMA.TIPO_AGG', 'Inserimento', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'V', NULL, NULL, 'DENUNCIA_DMA.TIPO_AGG', 'Variazione', 'CFG', NULL, NULL); 

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'1', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Contratto a tempo Indeterminato (Tempo Pieno)'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'10', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Tempo Definito', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'11', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Lavoratori assunti ai sensi L.407 del 1990,art. 8,comma 9,da IMPRESE,ENTI PUBBLICI ECONOMICI E CONSORZI EX L. 142 del 1990 - CENTRO-NORD'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'12', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Lavoratori assunti ai sensi L.407 del 1990,art. 8,comma 9,da IMPRESE,ENTI PUBBLICI ECONOMICI E CONSORZI EX L. 142 del 1990 - MEZZOGIORNO'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'13', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Insegnanti supplenti della Scuola'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'14', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Applicazione D.Lgs. 165 del 19 1997 - art. 4 per personale militare in sistema retributivo'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'17', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Contratto a tempo Determinato (Tempo Pieno)'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'18', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Part-Time (Contratto a Tempo Determinato)'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'2', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'giornaliero', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'3', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Contratto Formazione Lavoro ...rid. aliquota ord. 25%'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'4', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Contratto Formazione Lavoro ...rid. aliquota ord. 50%'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'5', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Contratto Formazione Lavoro ...rid. aliquota ord. 25% max.12 mesi'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'6', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Contratto Formazione Lavoro ...rid. aliquota ord. 25% max.12 mesi'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'7', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Contratto Formazione Lavoro ...rid. aliquota ord. 25% max.12 mesi'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'8', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Part-Time (Contratto a Tempo Indeterminato)'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'9', NULL, '77', 'DENUNCIA_DMA.TIPO_IMPIEGO', 'Orario ridotto', 'CFG', NULL, NULL); 

 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'E0', NULL, 'E0', 'DENUNCIA_DMA.RILEVANZA', 'Dati Mese Corrente', NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'V1', NULL, 'V1', 'DENUNCIA_DMA.RILEVANZA', 'Dati Rettificativi', NULL, NULL, NULL); 

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'1', NULL, '1', 'DENUNCIA_DMA.CASSA_PENSIONE', 'Cassa Trattamenti pensionistici dei dipendenti statali'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'2', NULL, '2', 'DENUNCIA_DMA.CASSA_PENSIONE', 'Cassa Pensioni Dipendenti Enti Locali'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'3', NULL, '3', 'DENUNCIA_DMA.CASSA_PENSIONE', 'Cassa Pensioni Insegnanti', NULL, NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'4', NULL, '4', 'DENUNCIA_DMA.CASSA_PENSIONE', 'Cassa Pensioni Ufficiali Giudiziari'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'5', NULL, '5', 'DENUNCIA_DMA.CASSA_PENSIONE', 'Cassa Pensioni Sanitari', NULL, NULL
, NULL); 

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'6', NULL, '6', 'DENUNCIA_DMA.CASSA_PREVIDENZA', 'I.N.A.D.E.L.', NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'7', NULL, '7', 'DENUNCIA_DMA.CASSA_PREVIDENZA', 'E.N.P.A.S.', NULL, NULL, NULL); 

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'9', NULL, '9', 'DENUNCIA_DMA.CASSA_CREDITO', 'Cassa Unica del Credito', NULL, NULL
, NULL); 

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'8', NULL, '8', 'DENUNCIA_DMA.CASSA_ENPDEDP', 'E.N.P.D.E.D.P.', NULL, NULL, NULL); 

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'1', NULL, '1', 'DENUNCIA_DMA.COMPETENZA', 'Aliquota Contributiva di Competenza', NULL
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'2', NULL, '2', 'DENUNCIA_DMA.COMPETENZA', 'Aliquota Contributiva di Cassa', NULL, NULL
, NULL); 

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'1', NULL, NULL, 'DENUNCIA_DMA.CAUSALE_VARIAZIONE', 'Variazione dati gia comunicati in precedenti denunce mensili'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'2', NULL, NULL, 'DENUNCIA_DMA.CAUSALE_VARIAZIONE', 'Retribuzioni e periodi non denunciati per i quali sono stati effettuati i versamenti'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'3', NULL, NULL, 'DENUNCIA_DMA.CAUSALE_VARIAZIONE', 'Retribuzioni e periodi non denunciati per i quali non sono stati effettuati i versamenti'
, NULL, NULL, NULL); 

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'1', NULL, NULL, 'DENUNCIA_DMA.TIPO_ACCERTAMENTO', 'Accertamento di ufficio', NULL
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'2', NULL, NULL, 'DENUNCIA_DMA.TIPO_ACCERTAMENTO', 'Denuncia presentata spontaneamente'
, NULL, NULL, NULL); 


INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P01082', 'Firmatario gia indicato per la stessa Amministrazione Dichiarante', NULL
, NULL, NULL); 

INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P05185', 'Riferimento esterno ai servizi del mese', NULL, NULL, NULL); 

--
-- INSERIMENTO DEFINIZIONE ESTRAZIONE DENUNCIA_DMA
--

insert into estrazione_report
      (estrazione, descrizione, oggetto, num_ric,note)
values ('DENUNCIA_DMA','Denuncia DMA', 'RAGI',0, 'PECCADMA');

--
-- comp_fisse
--

insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_FISSE', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Competenze Fisse CPDEL',null, 10,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_FISSE', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Competenze Fisse CPDEL',null, 10,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_FISSE', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Competenze Fisse CPDEL',null, 10,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_FISSE', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Competenze Fisse CPDEL',null, 10,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_FISSE', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Competenze Fisse CPDEL',null, 10,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_FISSE', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Competenze Fisse CPDEL',null, 10,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_FISSE', to_date('01011997','ddmmyyyy'), null
       ,'Competenze Fisse CPDEL',null, 10,null ,null,null)
;                                                                                          
   
insert into estrazione_righe_contabili
select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
     , esrc.sequenza, esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
  from estrazione_valori_contabili esvc
     , estrazione_righe_contabili  esrc
 where esvc.estrazione = 'DENUNCIA_DMA'
   and esvc.colonna    = 'COMP_FISSE'
   and esrc.estrazione = 'DENUNCIA_INPDAP'
   and esrc.colonna    = esvc.colonna
   and esrc.dal       <= nvl(esvc.al,to_date('3333333','j'))
   and nvl(esrc.al,to_date('3333333','j')) >= esvc.dal;

--
-- comp_accessorie
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_ACCESSORIE', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Competenze Accessorie CPDEL',null, 15,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_ACCESSORIE', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Competenze Accessorie CPDEL',null, 15,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_ACCESSORIE', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Competenze Accessorie CPDEL',null, 15,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_ACCESSORIE', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Competenze Accessorie CPDEL',null, 15,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_ACCESSORIE', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Competenze Accessorie CPDEL',null, 15,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_ACCESSORIE', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Competenze Accessorie CPDEL',null, 15,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_ACCESSORIE', to_date('01011997','ddmmyyyy'), null
       ,'Competenze Accessorie CPDEL',null, 15,null ,null,null)
;                                                                                          
   
insert into estrazione_righe_contabili
select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
     , esrc.sequenza, esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
  from estrazione_valori_contabili esvc
     , estrazione_righe_contabili  esrc
 where esvc.estrazione = 'DENUNCIA_DMA'
   and esvc.colonna    = 'COMP_ACCESSORIE'
   and esrc.estrazione = 'DENUNCIA_INPDAP'
   and esrc.colonna    = esvc.colonna
   and esrc.dal       <= nvl(esvc.al,to_date('3333333','j'))
   and nvl(esrc.al,to_date('3333333','j')) >= esvc.dal;

--
-- comp_18
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_18', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Retribuzione di Base per il 18%' ,null, 20,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_18', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Retribuzione di Base per il 18%' ,null, 20,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_18', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Retribuzione di Base per il 18%' ,null, 20,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_18', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Retribuzione di Base per il 18%' ,null, 20,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_18', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Retribuzione di Base per il 18%' ,null, 20,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_18', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Retribuzione di Base per il 18%' ,null, 20,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_18', to_date('01011997','ddmmyyyy'), null
       ,'Retribuzione di Base per il 18%' ,null, 20,null ,null,null)
;                                                                                          
   
insert into estrazione_righe_contabili
select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
     , esrc.sequenza, esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
  from estrazione_valori_contabili esvc
     , estrazione_righe_contabili  esrc
 where esvc.estrazione = 'DENUNCIA_DMA'
   and esvc.colonna    = 'COMP_18'
   and esrc.estrazione = 'DENUNCIA_INPDAP'
   and esrc.colonna    = esvc.colonna
   and esrc.dal       <= nvl(esvc.al,to_date('3333333','j'))
   and nvl(esrc.al,to_date('3333333','j')) >= esvc.dal;

--
-- ind_non_a
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IND_NON_A', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Indennita non annualizzabili',null, 25,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IND_NON_A', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Indennita non annualizzabili',null, 25,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IND_NON_A', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Indennita non annualizzabili',null, 25,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IND_NON_A', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Indennita non annualizzabili',null, 25,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IND_NON_A', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Indennita non annualizzabili',null, 25,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IND_NON_A', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Indennita non annualizzabili',null, 25,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IND_NON_A', to_date('01011997','ddmmyyyy'), null
       ,'Indennita non annualizzabili',null, 25,null ,null,null)
;                                                                                          
   
insert into estrazione_righe_contabili
select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
     , decode(esrc.colonna,'FERIE_NON_GODUTE',esrc.sequenza, esrc.sequenza+100), esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
  from estrazione_valori_contabili esvc
     , estrazione_righe_contabili  esrc
 where esvc.estrazione = 'DENUNCIA_DMA'
   and esvc.colonna    = 'IND_NON_A'
   and esrc.estrazione = 'DENUNCIA_INPDAP'
   and esrc.colonna    in ('FERIE_NON_GODUTE','PREAVV_RISARCITORIO')
   and esrc.dal       <= nvl(esvc.al,to_date('3333333','j'))
   and nvl(esrc.al,to_date('3333333','j')) >= esvc.dal;

--
-- iis_conglobata
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IIS_CONGLOBATA', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Iis. Conglobata',null, 30,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IIS_CONGLOBATA', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Iis. Conglobata',null, 30,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IIS_CONGLOBATA', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Iis. Conglobata',null, 30,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IIS_CONGLOBATA', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Iis. Conglobata',null, 30,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IIS_CONGLOBATA', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Iis. Conglobata',null, 30,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IIS_CONGLOBATA', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Iis. Conglobata',null, 30,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IIS_CONGLOBATA', to_date('01011997','ddmmyyyy'), null
       ,'Iis. Conglobata',null, 30,null ,null,null)
;                                                                                          
   
--
-- ipn_pens
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_PENS', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Imponibile Pensionabile del Periodo',null, 35,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_PENS', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Imponibile Pensionabile del Periodo',null, 35,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_PENS', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Imponibile Pensionabile del Periodo',null, 35,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_PENS', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Imponibile Pensionabile del Periodo',null, 35,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_PENS', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Imponibile Pensionabile del Periodo',null, 35,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_PENS', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Imponibile Pensionabile del Periodo',null, 35,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_PENS', to_date('01011997','ddmmyyyy'), null
       ,'Imponibile Pensionabile del Periodo',null, 35,null ,null,null)
;                                                                                          
   
--
-- contr_pens
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PENS', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Contributo Pensionabile del Periodo',null, 40,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PENS', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Contributo Pensionabile del Periodo',null, 40,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PENS', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Contributo Pensionabile del Periodo',null, 40,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PENS', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Contributo Pensionabile del Periodo',null, 40,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PENS', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Contributo Pensionabile del Periodo',null, 40,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PENS', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Contributo Pensionabile del Periodo',null, 40,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PENS', to_date('01011997','ddmmyyyy'), null
       ,'Contributo Pensionabile del Periodo',null, 40,null ,null,null)
;                                                                                          
   
--
-- contr_agg
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_AGG', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Contributo Aggiuntivo 1%',null, 45,null ,null,null);                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_AGG', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Contributo Aggiuntivo 1%',null, 45,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_AGG', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Contributo Aggiuntivo 1%',null, 45,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_AGG', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Contributo Aggiuntivo 1%',null, 45,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_AGG', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Contributo Aggiuntivo 1%',null, 45,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_AGG', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Contributo Aggiuntivo 1%',null, 45,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_AGG', to_date('01011997','ddmmyyyy'), null
       ,'Contributo Aggiuntivo 1%',null, 45,null ,null,null)
;                                                                                          
   
--
-- ipn_tfs
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_TFS', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Competenze INADEL',null, 50,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_TFS', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Competenze INADEL',null, 50,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_TFS', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Competenze INADEL',null, 50,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_TFS', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Competenze INADEL',null, 50,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_TFS', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Competenze INADEL',null, 50,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_TFS', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Competenze INADEL',null, 50,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_TFS', to_date('01011997','ddmmyyyy'), null
       ,'Competenze INADEL',null, 50,null ,null,null)
;                                                                                          
   
insert into estrazione_righe_contabili
select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
     , esrc.sequenza, esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
  from estrazione_valori_contabili esvc
     , estrazione_righe_contabili  esrc
 where esvc.estrazione = 'DENUNCIA_DMA'
   and esvc.colonna    = 'IPN_TFS'
   and esrc.estrazione = 'DENUNCIA_INPDAP'
   and esrc.colonna    = 'COMP_INADEL'
   and esrc.dal       <= nvl(esvc.al,to_date('3333333','j'))
   and nvl(esrc.al,to_date('3333333','j')) >= esvc.dal;

--
-- contr_tfs
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_TFS', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Contributi INADEL',null, 55,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_TFS', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Contributi INADEL',null, 55,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_TFS', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Contributi INADEL',null, 55,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_TFS', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Contributi INADEL',null, 55,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_TFS', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Contributi INADEL',null, 55,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_TFS', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Contributi INADEL',null, 55,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_TFS', to_date('01011997','ddmmyyyy'), null
       ,'Contributi INADEL',null, 55,null ,null,null)
;                                                                                          

--
-- ipn_tfr
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_TFR', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Imponibile TFR',null, 60,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_TFR', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Imponibile TFR',null, 60,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_TFR', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Imponibile TFR',null, 60,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_TFR', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Imponibile TFR',null, 60,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_TFR', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Imponibile TFR',null, 60,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_TFR', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Imponibile TFR',null, 60,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_TFR', to_date('01011997','ddmmyyyy'), null
       ,'Imponibile TFR',null, 60,null ,null,null)
;                                                                                          

--
-- contr_tfr
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_TFR', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Contributi TFR',null, 65,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_TFR', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Contributi TFR',null, 65,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_TFR', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Contributi TFR',null, 65,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_TFR', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Contributi TFR',null, 65,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_TFR', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Contributi TFR',null, 65,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_TFR', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Contributi TFR',null, 65,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_TFR', to_date('01011997','ddmmyyyy'), null
       ,'Contributi TFR',null, 65,null ,null,null)
;             
                                                                             
--
-- ult_ipn_tfr
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'ULT_IPN_TFR', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Ulteriori Elementi TFR',null, 70,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'ULT_IPN_TFR', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Ulteriori Elementi TFR',null, 70,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'ULT_IPN_TFR', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Ulteriori Elementi TFR',null, 70,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'ULT_IPN_TFR', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Ulteriori Elementi TFR',null, 70,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'ULT_IPN_TFR', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Ulteriori Elementi TFR',null, 70,null ,null,null)
;                                                                                         
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'ULT_IPN_TFR', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Ulteriori Elementi TFR',null, 70,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'ULT_IPN_TFR', to_date('01011997','ddmmyyyy'), null
       ,'Ulteriori Elementi TFR',null, 70,null ,null,null)
;                                                                                          

--
-- contr_ult_ipn_tfr
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_ULT_IPN_TFR', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Contributi Ulteriori Elementi TFR',null, 75,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_ULT_IPN_TFR', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Contributi Ulteriori Elementi TFR',null, 75,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_ULT_IPN_TFR', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Contributi Ulteriori Elementi TFR',null, 75,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_ULT_IPN_TFR', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Contributi Ulteriori Elementi TFR',null, 75,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_ULT_IPN_TFR', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Contributi Ulteriori Elementi TFR',null, 75,null ,null,null)
;                                                                                         
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_ULT_IPN_TFR', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Contributi Ulteriori Elementi TFR',null, 75,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_ULT_IPN_TFR', to_date('01011997','ddmmyyyy'), null
       ,'Contributi Ulteriori Elementi TFR',null, 75,null ,null,null)
;                                                                                          

--
-- ipn_cassa_credito
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_CASSA_CREDITO', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Imponibile Fondo Credito / ENPDEDP',null, 80,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_CASSA_CREDITO', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Imponibile Fondo Credito / ENPDEDP',null, 80,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_CASSA_CREDITO', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Imponibile Fondo Credito / ENPDEDP',null, 80,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_CASSA_CREDITO', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Imponibile Fondo Credito / ENPDEDP',null, 80,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_CASSA_CREDITO', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Imponibile Fondo Credito / ENPDEDP',null, 80,null ,null,null)
;                                                                                         
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_CASSA_CREDITO', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Imponibile Fondo Credito / ENPDEDP',null, 80,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'IPN_CASSA_CREDITO', to_date('01011997','ddmmyyyy'), null
       ,'Imponibile Fondo Credito / ENPDEDP',null, 80,null ,null,null)
;                                                                                          

--
-- contr_cassa_credito
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_CASSA_CREDITO', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Contributi Fondo Credito',null, 85,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_CASSA_CREDITO', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Contributi Fondo Credito',null, 85,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_CASSA_CREDITO', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Contributi Fondo Credito',null, 85,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_CASSA_CREDITO', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Contributi Fondo Credito',null, 85,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_CASSA_CREDITO', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Contributi Fondo Credito',null, 85,null ,null,null)
;                                                                                         
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_CASSA_CREDITO', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Contributi Fondo Credito',null, 85,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_CASSA_CREDITO', to_date('01011997','ddmmyyyy'), null
       ,'Contributi Fondo Credito',null, 85,null ,null,null)
;                                                                                          

--
-- contr_enpdedp
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_ENPDEDP', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Contributi ENPDEDP',null, 90,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_ENPDEDP', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Contributi ENPDEDP',null, 90,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_ENPDEDP', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Contributi ENPDEDP',null, 90,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_ENPDEDP', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Contributi ENPDEDP',null, 90,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_ENPDEDP', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Contributi ENPDEDP',null, 90,null ,null,null)
;                                                                                         
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_ENPDEDP', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Contributi ENPDEDP',null, 90,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_ENPDEDP', to_date('01011997','ddmmyyyy'), null
       ,'Contributi ENPDEDP',null, 90,null ,null,null)
;                                                                                          

--
-- Tredicesima
--

insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'TREDICESIMA', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Tredicesima',null, 95,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'TREDICESIMA', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Tredicesima',null, 95,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'TREDICESIMA', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Tredicesima',null, 95,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'TREDICESIMA', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Tredicesima',null, 95,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'TREDICESIMA', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Tredicesima',null, 95,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'TREDICESIMA', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Tredicesima',null, 95,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'TREDICESIMA', to_date('01011997','ddmmyyyy'), null
       ,'Tredicesima',null, 95,null ,null,null)
;                                                                                          
   
insert into estrazione_righe_contabili
select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
     , esrc.sequenza, esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
  from estrazione_valori_contabili esvc
     , estrazione_righe_contabili  esrc
 where esvc.estrazione = 'DENUNCIA_DMA'
   and esvc.colonna    = 'TREDICESIMA'
   and esrc.estrazione = 'DENUNCIA_INPDAP'
   and esrc.colonna    = esvc.colonna
   and esrc.dal       <= nvl(esvc.al,to_date('3333333','j'))
   and nvl(esrc.al,to_date('3333333','j')) >= esvc.dal;

--
-- Teorico_tfr
--

insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'TEORICO_TFR', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Retribuzione Teorica Tabellare TFR',null, 100,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'TEORICO_TFR', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Retribuzione Teorica Tabellare TFR',null, 100,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'TEORICO_TFR', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Retribuzione Teorica Tabellare TFR',null, 100,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'TEORICO_TFR', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Retribuzione Teorica Tabellare TFR',null, 100,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'TEORICO_TFR', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Retribuzione Teorica Tabellare TFR',null, 100,null ,null,null)
;                                                                                        
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'TEORICO_TFR', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Retribuzione Teorica Tabellare TFR',null, 100,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'TEORICO_TFR', to_date('01011997','ddmmyyyy'), null
       ,'Retribuzione Teorica Tabellare TFR',null, 100,null ,null,null)
; 
                                                                                         
--
-- Comp_tfr
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_TFR', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Retribuzione Utile TFR',null, 105,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_TFR', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Retribuzione Utile TFR',null, 105,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_TFR', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Retribuzione Utile TFR',null, 105,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_TFR', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Retribuzione Utile TFR',null, 105,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_TFR', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Retribuzione Utile TFR',null, 105,null ,null,null)
;                                                                                        
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_TFR', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Retribuzione Utile TFR',null, 105,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_TFR', to_date('01011997','ddmmyyyy'), null
       ,'Retribuzione Utile TFR',null, 105,null ,null,null)
;                                                                                          

--
-- quota_l166
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'QUOTA_L166', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Quota Previdenza Integrativa L.166/91',null, 105,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'QUOTA_L166', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Quota Previdenza Integrativa L.166/91',null, 105,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'QUOTA_L166', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Quota Previdenza Integrativa L.166/91',null, 105,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'QUOTA_L166', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Quota Previdenza Integrativa L.166/91',null, 105,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'QUOTA_L166', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Quota Previdenza Integrativa L.166/91',null, 105,null ,null,null)
;                                                                                        
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'QUOTA_L166', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Quota Previdenza Integrativa L.166/91',null, 105,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'QUOTA_L166', to_date('01011997','ddmmyyyy'), null
       ,'Quota Previdenza Integrativa L.166/91',null, 105,null ,null,null)
;                                                                                          

--
-- contr_l166
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_L166', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Contributi Previdenza Integrativa L.166/91',null, 110,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_L166', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Contributi Previdenza Integrativa L.166/91',null, 110,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_L166', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Contributi Previdenza Integrativa L.166/91',null, 110,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_L166', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Contributi Previdenza Integrativa L.166/91',null, 110,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_L166', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Contributi Previdenza Integrativa L.166/91',null, 110,null ,null,null)
;                                                                                        
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_L166', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Contributi Previdenza Integrativa L.166/91',null, 110,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_L166', to_date('01011997','ddmmyyyy'), null
       ,'Contributi Previdenza Integrativa L.166/91',null, 110,null ,null,null)
;                                                                                          

--
-- comp_premio
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_PREMIO', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Retribuzione Decontribuita L.135/97',null, 115,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_PREMIO', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Retribuzione Decontribuita L.135/97',null, 115,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_PREMIO', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Retribuzione Decontribuita L.135/97',null, 115,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_PREMIO', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Retribuzione Decontribuita L.135/97',null, 115,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_PREMIO', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Retribuzione Decontribuita L.135/97',null, 115,null ,null,null)
;                                                                                        
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_PREMIO', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Retribuzione Decontribuita L.135/97',null, 115,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'COMP_PREMIO', to_date('01011997','ddmmyyyy'), null
       ,'Retribuzione Decontribuita L.135/97',null, 115,null ,null,null)
;                                                                                          

insert into estrazione_righe_contabili
select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
     , esrc.sequenza, esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
  from estrazione_valori_contabili esvc
     , estrazione_righe_contabili  esrc
 where esvc.estrazione = 'DENUNCIA_DMA'
   and esvc.colonna    = 'COMP_PREMIO'
   and esrc.estrazione = 'DENUNCIA_INPDAP'
   and esrc.colonna    = esvc.colonna
   and esrc.dal       <= nvl(esvc.al,to_date('3333333','j'))
   and nvl(esrc.al,to_date('3333333','j')) >= esvc.dal;

--
-- contr_l135
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_L135', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Contributi Previdenza Integrativa L.166/91',null, 120,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_L135', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Contributi Previdenza Integrativa L.166/91',null, 120,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_L135', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Contributi Previdenza Integrativa L.166/91',null, 120,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_L135', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Contributi Previdenza Integrativa L.166/91',null, 120,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_L135', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Contributi Previdenza Integrativa L.166/91',null, 120,null ,null,null)
;                                                                                        
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_L135', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Contributi Previdenza Integrativa L.166/91',null, 120,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_L135', to_date('01011997','ddmmyyyy'), null
       ,'Contributi Previdenza Integrativa L.166/91',null, 120,null ,null,null)
; 

--
-- contr_pens_sospesi
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PENS_SOSPESI', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Contributi Pensione Sospesi',null, 125,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PENS_SOSPESI', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Contributi Pensione Sospesi',null, 125,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PENS_SOSPESI', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Contributi Pensione Sospesi',null, 125,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PENS_SOSPESI', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Contributi Pensione Sospesi',null, 125,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PENS_SOSPESI', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Contributi Pensione Sospesi',null, 125,null ,null,null)
;                                                                                        
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PENS_SOSPESI', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Contributi Pensione Sospesi',null, 125,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PENS_SOSPESI', to_date('01011997','ddmmyyyy'), null
       ,'Contributi Pensione Sospesi',null, 125,null ,null,null)
; 

--
-- contr_prev_sospesi
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PREV_SOSPESI', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Contributi Previdenziali Sospesi',null, 130,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PREV_SOSPESI', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Contributi Previdenziali Sospesi',null, 130,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PREV_SOSPESI', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Contributi Previdenziali Sospesi',null, 130,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PREV_SOSPESI', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Contributi Previdenziali Sospesi',null, 130,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PREV_SOSPESI', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Contributi Previdenziali Sospesi',null, 130,null ,null,null)
;                                                                                        
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PREV_SOSPESI', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Contributi Previdenziali Sospesi',null, 130,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'CONTR_PREV_SOSPESI', to_date('01011997','ddmmyyyy'), null
       ,'Contributi Previdenziali Sospesi',null, 130,null ,null,null)
; 

--
-- sanzione_pens
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_PENS', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Sanzione su Contributi Pensionabili',null, 135,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_PENS', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Sanzione su Contributi Pensionabili',null, 135,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_PENS', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Sanzione su Contributi Pensionabili',null, 135,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_PENS', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Sanzione su Contributi Pensionabili',null, 135,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_PENS', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Sanzione su Contributi Pensionabili',null, 135,null ,null,null)
;                                                                                        
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_PENS', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Sanzione su Contributi Pensionabili',null, 135,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_PENS', to_date('01011997','ddmmyyyy'), null
       ,'Sanzione su Contributi Pensionabili',null, 135,null ,null,null)
; 

--
-- sanzione_prev
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_PREV', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Sanzione su Contributi Previdenziali',null, 140,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_PREV', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Sanzione su Contributi Previdenziali',null, 140,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_PREV', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Sanzione su Contributi Previdenziali',null, 140,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_PREV', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Sanzione su Contributi Previdenziali',null, 140,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_PREV', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Sanzione su Contributi Previdenziali',null, 140,null ,null,null)
;                                                                                        
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_PREV', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Sanzione su Contributi Previdenziali',null, 140,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_PREV', to_date('01011997','ddmmyyyy'), null
       ,'Sanzione su Contributi Previdenziali',null, 140,null ,null,null)
; 

--
-- sanzione_cred
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_CRED', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Sanzione su Contributi Fondo Credito',null, 145,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_CRED', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Sanzione su Contributi Fondo Credito',null, 145,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_CRED', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Sanzione su Contributi Fondo Credito',null, 145,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_CRED', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Sanzione su Contributi Fondo Credito',null, 145,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_CRED', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Sanzione su Contributi Fondo Credito',null, 145,null ,null,null)
;                                                                                        
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_CRED', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Sanzione su Contributi Fondo Credito',null, 145,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_CRED', to_date('01011997','ddmmyyyy'), null
       ,'Sanzione su Contributi Fondo Credito',null, 145,null ,null,null)
; 

--
-- sanzione_enpdedp
--
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_ENPDEDP', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
       ,'Sanzione su Contributi ENPDEDP',null, 150,null ,null,null)
;                                                                                       
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_ENPDEDP', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
       ,'Sanzione su Contributi ENPDEDP',null, 150,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_ENPDEDP', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
       ,'Sanzione su Contributi ENPDEDP',null, 150,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_ENPDEDP', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
       ,'Sanzione su Contributi ENPDEDP',null, 150,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_ENPDEDP', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
       ,'Sanzione su Contributi ENPDEDP',null, 150,null ,null,null)
;                                                                                        
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_ENPDEDP', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
       ,'Sanzione su Contributi ENPDEDP',null, 150,null ,null,null)
;                                                                                          
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('DENUNCIA_DMA', 'SANZIONE_ENPDEDP', to_date('01011997','ddmmyyyy'), null
       ,'Sanzione su Contributi ENPDEDP',null, 150,null ,null,null)
; 


--
-- ESECUZIONE PACKAGES
--
start crp_denunce_inpdap.sql
start sia_periodo_crp.sql
start crp_peccadma.sql
start crp_peccfdma.sql

