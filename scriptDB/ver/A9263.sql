alter table denuncia_fiscale add( 
 C135                            NUMBER(20,5)     NULL,
 C136                            NUMBER(20,5)     NULL,
 C137                            NUMBER(20,5)     NULL,
 C138                            NUMBER(20,5)     NULL,
 C139                            NUMBER(20,5)     NULL,
 C140                            NUMBER(20,5)     NULL,
 C141                            VARCHAR(20)      NULL,
 C142                            VARCHAR(20)      NULL,
 C143                            VARCHAR(20)      NULL,
 C144                            VARCHAR(20)      NULL,
 C145                            VARCHAR(20)      NULL
);

-- sistemazione dei ref_codes
delete from pec_ref_codes
where rv_domain = 'DENUNCIA_O1_INPS.QUALIFICA'
  and substr(rv_low_value,1,1) = 'A'
/
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING ) 
VALUES ( 'A', 'DENUNCIA_O1_INPS.QUALIFICA', 'Atipica ex INPDAI');
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING ) 
VALUES ( 'E', 'DENUNCIA_O1_INPS.QUALIFICA', 'Pilota ( fondo volo )');
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING ) 
VALUES ( 'F', 'DENUNCIA_O1_INPS.QUALIFICA', 'Pilota in addestramento ( primi 12 mesi )');
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING ) 
VALUES ( 'G', 'DENUNCIA_O1_INPS.QUALIFICA', 'Pilota collaudatore');
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING ) 
VALUES ( 'H', 'DENUNCIA_O1_INPS.QUALIFICA', 'Tecnico di volo');
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING ) 
VALUES ( 'L', 'DENUNCIA_O1_INPS.QUALIFICA', 'Tecnico di volo in addestramento ( primi 12 mesi )');
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING ) 
VALUES ( 'M', 'DENUNCIA_O1_INPS.QUALIFICA', 'Tecnico di volo per i collaudi');
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING ) 
VALUES ( 'N', 'DENUNCIA_O1_INPS.QUALIFICA', 'Assistente di volo');

delete from pec_ref_codes
where rv_domain = 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE';

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'0', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate IVS-DS-FG'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'03', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate DS-FG'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'10', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate FG', NULL
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'52', NULL, '52', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Contratto Solidarieta` Art.2 L.863/1984'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'53', NULL, '53', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Contratto Formazione Lavoro Art.3 L.863/1984'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'54', NULL, '54', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Contratto Formazione Lavoro Art.5 L.291/1988'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'55', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Altre Assicurazioni', NULL, NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'56', NULL, '56', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Contratto Formazione Lavoro Art.9 D.L.337/1990'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'57', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Contratto Formazione Lavoro Art.8 L.407/1990'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'58', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori con riduzione contributi Art.8 L.407/1990'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'59', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori esenti contributi Art.8 L.407/1990'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'61', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate IVS-DS-FG'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'62', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate IVS-FG'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'63', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate IVS', NULL
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'64', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate FG', NULL
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'65', NULL, '65', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori assunti con Contratto di Formazione per i quali compete al datore di lavoro il beneficio generalizzato del 25% (cir. Inps n. 85 del 2001)'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'66', NULL, '66', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoro disabili aventi titolo alla fiscalizzazione totale di cui all''articolo 13,comma 1, lett. A,della legge n. 68 del 1999'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'67', NULL, '67', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoro disabili aventi titolo alla fiscalizzazione nella misura del 50% di cui all'' articolo 13, comma 1,lett.B,della legge 68 del 1999'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'68', NULL, '68', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoro interinali per i quali compete al datore di lavoro la riduzione del 50% ex D.Lgs. n.151/2001 (circ. Inps n.136 del 2001)'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'69', NULL, '69', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori assunti con Contratto di Formazione secondo le regole del "de minimis" (circ. Inps n.85 del 2001)'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'70', NULL, '70', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori esclusi dalla contribuzione IVS ex art.75,legge n. 388/200 (cir. Inps n.118 del 2001)'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'71', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate DS', NULL
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'72', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate DS-FG'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'73', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate IVS-DS'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'76', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori in mobilita` assunti con contratto a termine ex art.8 comma 2 legge 223/91.'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'77', NULL, '77', 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Assicurazioni Barrate IVS-DS-FG'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) 
VALUES ( '79', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 
'Lavoratori ammessi ai benefici ex legge n.193/2000 (circ. Inps n.134 del 2002)', NULL, NULL, NULL);
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'80', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 
'Lavoratori esclusi dalla contribuzione UVS art.1,co.12,Legge 243/2004(bonus per posticipo pensionamento)'
, NULL, NULL, NULL);
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'82', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori tempo det.,assunti in sostituzione di personale in astensione dal lavoro (art. 10 legge n.53 del 2000),per i quali al datore di lavoro compete la riduzione del 50 per cento (circ. 117 del 2000)'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'86', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori ex-cassaintegrati assunti a TP e Indet. art.4 comma 3 legge 20/93'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'95', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori interessati dal contratto di riallineamento o di gradualita'' denunciati per la prima volta all''istituto ai sensi dell''art. 75 legge 23 dicembre 1998,n.448 (circ. INPS n.59 e n.115 del 2000)'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'96', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Lavoratori interessati dal contratto di riallineamento o di gradualita'' gia'' denunciati all''istituto ai sensi dell''art. 75 legge 23 dicembre 1998,n.448 (circ. INPS n.59 e n.115 del 2000)'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'99', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE', 'Dirigente di azienda industriale che ha esercitato l''opzione ai sensi dell''art. 75 della legge 23 dicemvre 2000 n. 388'
, 'CFG', NULL, NULL); 


INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( '80', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, 'Lavoratori esclusi dalla contribuzione UVS art.1,co.12,Legge 243/2004(bonus per posticipo pensionamento)'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'A0', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, 'Lavoratori assunti con contratto di inserimento di età compresa tra i 18 e i 29 anni esclusi dai benefici
economici previsti dal D.Lgs n.276/2003 (cir.INPS n.51 del 2004)'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'B1', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratori assunti con contratto di inserimento disoccupati di lunga durata di età compresa tra i
29 e i 32 anni per i quali al datore di lavoro compete la riduzione del 25% dei contributi prevista
dal D.Lgs n.276/2003 (cir.INPS n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'B2', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratori assunti con contratto di inserimento disoccupati di lunga durata di età compresa tra i
29 e i 32 anni per i quali al datore di lavoro compete la riduzione del 40% dei contributi prevista
dal D.Lgs n.276/2003 (cir.INPS n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'B3', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratori assunti con contratto di inserimento disoccupati di lunga durata di età compresa tra i
29 e i 32 anni per i quali al datore di lavoro compete la riduzione del 50% dei contributi prevista
dal D.Lgs n.276/2003 (cir.INPS n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'B4', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratori assunti con contratto di inserimento disoccupati di lunga durata di età compresa tra i
29 e i 32 anni per i quali al datore di lavoro compete la riduzione del 100% dei contributi prevista
dal D.Lgs n.276/2003 (cir.INPS n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'C1', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, 'Lavoratori assunti con contratto di inserimento con più di 50 anni di età privi del posto di lavoro
per i quali al datore di lavoro compete la riduzione del 25% dei contributi prevista dal D.Lgs
n.276/2003 (cir.INPS n.51 del 2004)'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'C2', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, 'Lavoratori assunti con contratto di inserimento con più di 50 anni di età privi del posto di lavoro
per i quali al datore di lavoro compete la riduzione del 40% dei contributi prevista dal D.Lgs
n.276/2003 (cir.INPS n.51 del 2004)'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'C3', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, 'Lavoratori assunti con contratto di inserimento con più di 50 anni di età privi del posto di lavoro
per i quali al datore di lavoro compete la riduzione del 50% dei contributi prevista dal D.Lgs
n.276/2003 (cir.INPS n.51 del 2004)'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'C4', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, 'Lavoratori assunti con contratto di inserimento con più di 50 anni di età privi del posto di lavoro
per i quali al datore di lavoro compete la riduzione del 100% dei contributi prevista dal D.Lgs
n.276/2003 (cir.INPS n.51 del 2004)'); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'D1', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratori assunti con contratto di inserimento che intendono riprendere una attività lavorativa e
che non abbiano lavorato per almeno due anni per i quali il datore di lavoro beneficia della riduzione
del 25% dei contributi prevista da D.Lgs n.276/2003(cir.INPS n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'D2', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratori assunti con contratto di inserimento che intendono riprendere una attività lavorativa e
che non abbiano lavorato per almeno due anni per i quali il datore di lavoro beneficia della riduzione
del 40% dei contributi prevista da D.Lgs n.276/2003(cir.INPS n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'D3', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratori assunti con contratto di inserimento che intendono riprendere una attività lavorativa e
che non abbiano lavorato per almeno due anni per i quali il datore di lavoro beneficia della riduzione
del 50% dei contributi prevista da D.Lgs n.276/2003(cir.INPS n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'D4', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratori assunti con contratto di inserimento che intendono riprendere una attività lavorativa e
che non abbiano lavorato per almeno due anni per i quali il datore di lavoro beneficia della riduzione
del 100% dei contributi prevista da D.Lgs n.276/2003(cir.INPS n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'E1', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratrici assunte con contratto di inserimento di qualsiasi età residenti in area geografica il cui
tasso di occupazione femminile sia inferiore almeno del 20% di quello maschile o in cui il tasso di
disoccupazione femminile superi del 10% quello maschile per le quali il datore di lavoro beneficia
della riduzione del 25% dei contributi prevista dal D.Lgs n.276/2003(cir.INPS n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'E2', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratrici assunte con contratto di inserimento di qualsiasi età residenti in area geografica il
cui tasso di occupazione femminile sia inferiore almeno del 20% di quello maschile o in cui il
tasso di disoccupazione femminile superi del 10% quello maschile per le quali il datore di lavoro
beneficia della riduzione del 40% dei contributi prevista dal D.Lgs n.276/2003(cir.INPS
n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'E3', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratrici assunte con contratto di inserimento di qualsiasi età residenti in area geografica il cui
tasso di occupazione femminile sia inferiore almeno del 20% di quello maschile o in cui il tasso di
disoccupazione femminile superi del 10% quello maschile per le quali il datore di lavoro beneficia
della riduzione del 50% dei contributi prevista dal D.Lgs n.276/2003(cir.INPS n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'E4', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratrici assunte con contratto di inserimento di qualsiasi età residenti in area geografica il cui tasso
di occupazione femminile sia inferiore almeno del 20% di quello maschile o in cui il tasso di disoccupazione
femminile superi del 10% quello maschile per le quali il datore di lavoro beneficia della
riduzione del 100% dei contributi prevista dal D.Lgs n.276/2003(cir.INPS n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'F1', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratori assunti con contratto di inserimento riconosciuti affetti, ai sensi della normativa vigente,
da un grave handicap fisico, mentale o psichico, per i quali il datore di lavoro beneficia della
riduzione del 25% dei contributi prevista dal D.Lgs n.276/2003 (circ. INPS n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'F2', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratori assunti con contratto di inserimento riconosciuti affetti, ai sensi della normativa vigente,
da un grave handicap fisico, mentale o psichico, per i quali il datore di lavoro beneficia della
riduzione del 40% dei contributi prevista dal D.Lgs n.276/2003 (circ. INPS n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'F3', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratori assunti con contratto di inserimento riconosciuti affetti, ai sensi della normativa vigente,
da un grave handicap fisico, mentale o psichico, per i quali il datore di lavoro beneficia della
riduzione del 50% dei contributi prevista dal D.Lgs n.276/2003 (circ. INPS n.51 del 2004)',1,240)); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_DOMAIN, RV_MEANING )
VALUES ( 'F4', 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
, substr('Lavoratori assunti con contratto di inserimento riconosciuti affetti, ai sensi della normativa vigente,
da un grave handicap fisico, mentale o psichico, per i quali il datore di lavoro beneficia della
riduzione del 100% dei contributi prevista dal D.Lgs n.276/2003 (circ. INPS n.51 del 2004)',1,240)); 

