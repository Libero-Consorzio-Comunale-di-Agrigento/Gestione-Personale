REM
REM
REM
SET SCAN OFF

REM  Objects being generated in this file are:
REM VIEW
REM      REPORT_ANAGRAFICI
REM      REPORT_CEDOLINO
REM      REPORT_CEDOLINO_ANNO
REM      REPORT_CONTRIBUTI
REM      REPORT_DEBITORIE
REM      REPORT_DENUNCIA_EMPAM
REM      REPORT_ELENCO
REM      REPORT_ELENCO_DELIBERA
REM      REPORT_ELENCO_VOCI
REM      REPORT_FINE_ANNO
REM      REPORT_FISCALE
REM      REPORT_FISCALE_ANNO
REM      REPORT_LIQUIDAZIONE
REM      REPORT_ONERI
REM      REPORT_RIEPILOGO
REM      REPORT_RIEPILOGO_ANNO
REM      REPORT_SINDACALI
REM      REPORT_TFR
REM      REPORT_TOTALI
REM      REPORT_TOTALI_ANNO
REM      REPORT_VERIFICHE_CEDOLINO
REM
REM creazione delle viste "standard" con prima chiave ENTE 
REM da utilizzare manualmente SOLO in caso di necessita ( cioè se mancano TUTTE le viste )
REM

PROMPT 
PROMPT Creating view REPORT_ANAGRAFICI
CREATE VIEW REPORT_ANAGRAFICI AS 
SELECT RAGI.ci CI
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , RAIN.cognome||' '||RAIN.nome S5
     , RAIN.cognome||'  '||RAIN.nome C5
     , RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , RAPPORTI_GIURIDICI             RAGI
     , RIFERIMENTO_RETRIBUZIONE       RIRE
     , RAPPORTI_INDIVIDUALI           RAIN
 WHERE 1 = 1
   and ENTE.ente_id = 'ENTE'
   and RAIN.ci = RAGI.ci
;
COMMENT ON TABLE REPORT_ANAGRAFICI IS 'Elaborati Anagrafici';

PROMPT 
PROMPT Creating view REPORT_CEDOLINO
CREATE VIEW REPORT_CEDOLINO AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , RAIN.cognome||' '||RAIN.nome S5
     , RAIN.cognome||'  '||RAIN.nome C5
     , RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , RAPPORTI_INDIVIDUALI           RAIN
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
   and PERE.ci = RAIN.ci
;
COMMENT ON TABLE REPORT_CEDOLINO IS 'Cedolino Retribuzione';

PROMPT 
PROMPT Creating view REPORT_CEDOLINO_ANNO
CREATE VIEW REPORT_CEDOLINO_ANNO AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , RAIN.cognome||' '||RAIN.nome S5
     , RAIN.cognome||'  '||RAIN.nome C5
     , RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , RAPPORTI_INDIVIDUALI           RAIN
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
   and PERE.ci = RAIN.ci
;
COMMENT ON TABLE REPORT_CEDOLINO_ANNO IS 'Cedolone Riepilogativo di Fine Anno';

PROMPT 
PROMPT Creating view REPORT_CONTRIBUTI
CREATE VIEW REPORT_CONTRIBUTI AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
  FROM ENTE                           ENTE
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
;
COMMENT ON TABLE REPORT_CONTRIBUTI IS 'Riepilogo Contributi';

PROMPT 
PROMPT Creating view REPORT_DEBITORIE
CREATE VIEW REPORT_DEBITORIE AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(RAIN.cognome||' '||RAIN.nome,15)),0) S3
     , nvl(rtrim(rpad(RAIN.cognome||'  '||RAIN.nome,15)),' ') C3
     , nvl(rtrim(rpad(RAIN.cognome||'  '||RAIN.nome,60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
  FROM ENTE                           ENTE
     , RAPPORTI_INDIVIDUALI           RAIN
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
   and PERE.ci = RAIN.ci
;
COMMENT ON TABLE REPORT_DEBITORIE IS 'Elenco Situazioni Debitorie';

PROMPT 
PROMPT Creating view REPORT_DENUNCIA_ENPAM
CREATE VIEW REPORT_DENUNCIA_ENPAM AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , VACM.mensilita MENSILITA
     , decode(VACM.colonna,'01',VACM.valore,null) COL1
     , decode(VACM.colonna,'02',VACM.valore,null) COL2
     , decode(VACM.colonna,'03',VACM.valore,null) COL3
     , decode(VACM.colonna,'04',VACM.valore,null) COL4
     , decode(VACM.colonna,'05',VACM.valore,null) COL5
     , decode(VACM.colonna,'06',VACM.valore,null) COL6
     , decode(VACM.colonna,'07',VACM.valore,null) COL7
     , decode(VACM.colonna,'08',VACM.valore,null) COL8
     , decode(VACM.colonna,'09',VACM.valore,null) COL9
     , decode(VACM.colonna,'10',VACM.valore,null) COL10
     , decode(VACM.colonna,'11',VACM.valore,null) COL11
     , decode(VACM.colonna,'12',VACM.valore,null) COL12
     , decode(VACM.colonna,'13',VACM.valore,null) COL13
     , decode(VACM.colonna,'14',VACM.valore,null) COL14
     , VACM.riferimento RIFERIMENTO
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , RAIN.cognome||' '||RAIN.nome S5
     , RAIN.cognome||'  '||RAIN.nome C5
     , RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , RAPPORTI_INDIVIDUALI           RAIN
     , VALORI_CONTABILI_MENSILI       VACM
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and pere.competenza = 'A'
   and vacm.estrazione = 'DENUNCIA_ENPAM'
   and ENTE.ente_id = 'ENTE'
   and PERE.ci = RAIN.ci
   and VACM.ci   = PERE.ci
   and VACM.anno = PERE.anno
   and VACM.mese = PERE.mese
;
COMMENT ON TABLE REPORT_DENUNCIA_ENPAM IS 'Denuncia Enpam';

PROMPT 
PROMPT Creating view REPORT_ELENCO 
CREATE VIEW REPORT_ELENCO AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , RAIN.cognome||' '||RAIN.nome S5
     , RAIN.cognome||'  '||RAIN.nome C5
     , RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , RAPPORTI_INDIVIDUALI           RAIN
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
   and PERE.ci = RAIN.ci
;
COMMENT ON TABLE REPORT_ELENCO IS 'Elenco Generico per report mensili';

PROMPT 
PROMPT Creating view REPORT_ELENCO_DELIBERA
CREATE VIEW REPORT_ELENCO_DELIBERA AS 
SELECT VARE.anno ANNO
     , VARE.mese MESE
     , VARE.mensilita MENSILITA
     , VARE.sede_del SEDE_DEL
     , VARE.anno_del ANNO_DEL
     , VARE.numero_del NUMERO_DEL
     , VARE.delibera DELIBERA
     , VARE.capitolo CAPITOLO
     , VARE.articolo ARTICOLO
     , VARE.conto CONTO
     , VARE.ci CI
     , VARE.voce VOCE
     , VARE.sub SUB
     , VARE.riferimento RIFERIMENTO
     , VARE.arr ARR
     , nvl(VARE.tar_var,0) TAR
     , nvl(VARE.qta_var,0) QTA
     , nvl(VARE.imp_var,0) IMP
     , VARE.risorsa_intervento RISORSA_INTERVENTO
     , VARE.impegno IMPEGNO
     , VARE.anno_impegno ANNO_IMPEGNO
     , VARE.sub_impegno SUB_IMPEGNO
     , VARE.anno_sub_impegno ANNO_SUB_IMP
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , RAIN.cognome||' '||RAIN.nome S5
     , RAIN.cognome||'  '||RAIN.nome C5
     , RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , RAPPORTI_GIURIDICI             RAGI
     , RAPPORTI_INDIVIDUALI           RAIN
     , MOVIMENTI_CONTABILI            VARE
 WHERE 1 = 1
   and VARE.input in ('D','B')
   and VARE.delibera is not null
   and ENTE.ente_id = 'ENTE'
   and RAIN.ci = RAGI.ci
   and RAGI.ci = VARE.ci
;
COMMENT ON TABLE REPORT_ELENCO_DELIBERA IS 'Elenco variabili in Delibera';

PROMPT 
PROMPT Creating view REPORT_ELENCO_VOCI 
CREATE VIEW REPORT_ELENCO_VOCI AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , RAIN.cognome||' '||RAIN.nome S5
     , RAIN.cognome||'  '||RAIN.nome C5
     , RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , RAPPORTI_INDIVIDUALI           RAIN
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
   and PERE.ci = RAIN.ci
;
COMMENT ON TABLE REPORT_ELENCO_VOCI IS 'Elenco Voci Retribuite';

PROMPT 
PROMPT Creating view REPORT_FINE_ANNO 
CREATE VIEW REPORT_FINE_ANNO AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , RAIN.cognome||' '||RAIN.nome S5
     , RAIN.cognome||'  '||RAIN.nome C5
     , RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , PERIODI_RETRIBUTIVI            PERE
     , RAPPORTI_INDIVIDUALI           RAIN
     , RIFERIMENTO_FINE_ANNO          RIFA
     , PERIODI_RETRIBUTIVI            PERA
 WHERE 1 = 1
   and ENTE.ente_id = 'ENTE'
   and nvl(PERA.competenza,'A') = 'A'
   and nvl( PERA.periodo
          , to_date( '0101'||to_char(nvl(PERA.anno,RIFA.anno))
                   , 'ddmmyyyy'))
       between to_date( '0101'||
                        to_char(nvl(PERA.anno,RIFA.anno))
                      , 'ddmmyyyy' )
           and to_date( '3112'||
                        to_char(nvl(PERA.anno,RIFA.anno))
                      , 'ddmmyyyy' )
   and nvl(PERA.mese,0) =
      (select nvl(max(mese),0)
         from periodi_retributivi
        where ci      = PERA.ci
          and periodo between to_date( '0101'||
                              to_char(nvl(PERA.anno,RIFA.anno))
                                     , 'ddmmyyyy' )
                          and to_date( '3112'||
                              to_char(nvl(PERA.anno,RIFA.anno))
                                     , 'ddmmyyyy' )
          and anno    = PERA.anno)
   and PERE.rowid = PERA.rowid (+)
   and PERE.ci = RAIN.ci
   and RIFA.rifa_id = 'RIFA'
;
COMMENT ON TABLE REPORT_FINE_ANNO IS 'Situazione di Fine Anno per Elaborati Annuali';

PROMPT 
PROMPT Creating view REPORT_FISCALE
CREATE VIEW REPORT_FISCALE AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , RAIN.cognome||' '||RAIN.nome S5
     , RAIN.cognome||'  '||RAIN.nome C5
     , RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , RAPPORTI_INDIVIDUALI           RAIN
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
   and PERE.ci = RAIN.ci
;
COMMENT ON TABLE REPORT_FISCALE IS 'Riepilogo Fiscale Mensile';

PROMPT 
PROMPT Creating view REPORT_FISCALE_ANNO
CREATE VIEW REPORT_FISCALE_ANNO AS 
SELECT RAGF.ci CI
     , INEX.anno ANNO
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , decode(RAIND.nome,'',1,0)||RAIND.cognome||'  '||RAIND.nome||decode(RAIND.ci,RAIN.ci,1,decode(RAIND.ci,RADI.ci,0,2))||RAIN.cognome||'  '||RAIN.nome S5
     , RAIND.cognome||'  '||RAIND.nome||decode(RAIND.ci,RAIN.ci,1,decode(RAIND.ci,RADI.ci,0,2))||RAIN.cognome||'  '||RAIN.nome C5
     , RAIND.cognome||'  '||RAIND.nome||decode(RAIND.ci,RAIN.ci,1,decode(RAIND.ci,RADI.ci,0,2))||RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , INFORMAZIONI_EXTRACONTABILI    INEX
     , PERIODI_RETRIBUTIVI            PERA
     , PERIODI_RETRIBUTIVI            PERE
     , RAPPORTI_DIVERSI               RADI
     , RAPPORTI_GIURIDICI             RAGID
     , RAPPORTI_INDIVIDUALI           RAIN
     , RAPPORTI_INDIVIDUALI           RAIND
     , RAPPORTI_RETRIBUTIVI           RARE
     , RIFERIMENTO_FINE_ANNO          RIFA
     , RAPPORTI_GIURIDICI             RAGF
 WHERE 1 = 1
   and ENTE.ente_id = 'ENTE'
   and nvl(PERA.competenza,'A') = 'A'
   and nvl( PERA.periodo
          , to_date( '0101'||to_char(nvl(PERA.anno,RIFA.anno))
                   , 'ddmmyyyy'))
       between to_date( '0101'||
                        to_char(nvl(PERA.anno,RIFA.anno))
                      , 'ddmmyyyy' )
           and to_date( '3112'||
                        to_char(nvl(PERA.anno,RIFA.anno))
                      , 'ddmmyyyy' )
   and nvl(PERA.mese,0) =
      (select nvl(max(mese),0)
         from periodi_retributivi
        where ci      = PERA.ci
          and periodo between to_date( '0101'||
                              to_char(nvl(PERA.anno,RIFA.anno))
                                     , 'ddmmyyyy' )
                          and to_date( '3112'||
                              to_char(nvl(PERA.anno,RIFA.anno))
                                     , 'ddmmyyyy' )
          and anno    = PERA.anno)
   and PERE.rowid = PERA.rowid (+)
   and INEX.ci = RAGID.ci
   and PERE.ci   (+) = INEX.ci
   and PERE.anno (+) = INEX.anno
   and (   RARE.ci       = RAGF.ci
   or RADI.ci_erede = RAGF.ci)
   and RAIN.ci=RAGF.ci
   and RARE.ci  = RAIN.ci+0
   and RAIND.ni =
      (select ni from rapporti_individuali
        where ci = nvl(RADI.ci_erede,RARE.ci))
   and RAIND.ci  = decode( RAGF.ci
             , RADI.ci_erede,RARE.ci
                          , nvl(RADI.ci_erede,RAGF.ci))
   and RARE.ci = RADI.ci (+)
   and not exists
     (select 'x' from rapporti_diversi
       where ci    = RADI.ci
         and rowid > RADI.rowid)
   and RAGID.ci =
       decode( RAIN.ci
             , RAIND.ci, RAIN.ci
                       , decode
                         ( RAIN.ni
                         , RAIND.ni, RARE.ci
                                   , nvl(RADI.ci_erede,RARE.ci)
                         ))
   and RIFA.rifa_id = 'RIFA'
;
COMMENT ON TABLE REPORT_FISCALE_ANNO IS 'Situazione di Fine Anno per Riepilogo Fiscale';

PROMPT 
PROMPT Creating view REPORT_LIQUIDAZIONE
CREATE VIEW REPORT_LIQUIDAZIONE AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , RAIN.cognome||' '||RAIN.nome S5
     , RAIN.cognome||'  '||RAIN.nome C5
     , RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , RAPPORTI_INDIVIDUALI           RAIN
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
   and PERE.ci = RAIN.ci
;
COMMENT ON TABLE REPORT_LIQUIDAZIONE IS 'Riepilogo Fiscale Liquidazione';

PROMPT 
PROMPT Creating view REPORT_ONERI 
CREATE VIEW REPORT_ONERI AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , RAIN.cognome||' '||RAIN.nome S5
     , RAIN.cognome||'  '||RAIN.nome C5
     , RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , RAPPORTI_INDIVIDUALI           RAIN
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
   and PERE.ci = RAIN.ci
;
COMMENT ON TABLE REPORT_ONERI IS 'Distinta Oneri';
PROMPT 
PROMPT Creating view REPORT_QUIETANZE 
CREATE VIEW REPORT_QUIETANZE AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(nvl(ISCR.codice,'ZZZZZ'),15)),0) S2
     , nvl(rtrim(rpad(ISCR.codice,15)),' ') C2
     , nvl(rtrim(rpad(rpad(ISCR.descrizione,30,' ')||' ABI '||rpad(ISCR.codice_abi,5)||decode(SOGG.codice_fiscale,null,null,' C.F. '||SOGG.codice_fiscale),60)),' ') D2
     , nvl(rtrim(rpad(nvl(SPOR.istituto||SPOR.sportello,'ZZZZZZZZZZ'),15)),0) S3
     , nvl(rtrim(rpad(SPOR.sportello,15)),' ') C3
     , nvl(rtrim(rpad(rpad(SPOR.descrizione,30,' ')||' CAB '||spor.cab,60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , RAIN.cognome||' '||RAIN.nome S5
     , RAIN.cognome||'  '||RAIN.nome C5
     , RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , ISTITUTI_CREDITO               ISCR
     , RAPPORTI_INDIVIDUALI           RAIN
     , RAPPORTI_RETRIBUTIVI           RARE
     , SOGGETTI                       SOGG
     , SPORTELLI                      SPOR
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   AND ISCR.codice = RARE.istituto
   and PERE.competenza = 'A'
   and SPOR.istituto  = RARE.istituto
   and SPOR.sportello = RARE.sportello
   and ENTE.ente_id = 'ENTE'
   and PERE.ci = RAIN.ci
   and PERE.ci = RARE.ci
   and ISCR.codice = RARE.istituto
   and SOGG.soggetto (+) = ISCR.soggetto
   and SPOR.istituto  = RARE.istituto
   and SPOR.sportello = RARE.sportello
;
COMMENT ON TABLE REPORT_QUIETANZE IS 'Elenco Quietanze';

PROMPT 
PROMPT Creating view REPORT_RIEPILOGO
CREATE VIEW REPORT_RIEPILOGO AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
  FROM ENTE                           ENTE
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
;
COMMENT ON TABLE REPORT_RIEPILOGO IS 'Riepilogo Retribuzione';

PROMPT 
PROMPT Creating view REPORT_RIEPILOGO_ANNO
CREATE VIEW REPORT_RIEPILOGO_ANNO AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
  FROM ENTE                           ENTE
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
;
COMMENT ON TABLE REPORT_RIEPILOGO_ANNO IS 'Riepilogo Annuale Retribuzione';

PROMPT 
PROMPT Creating view REPORT_SINDACALI
CREATE VIEW REPORT_SINDACALI AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(RAIN.cognome||' '||RAIN.nome,15)),0) S3
     , nvl(rtrim(rpad(RAIN.cognome||'  '||RAIN.nome,15)),' ') C3
     , nvl(rtrim(rpad(RAIN.cognome||'  '||RAIN.nome,60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
  FROM ENTE                           ENTE
     , RAPPORTI_INDIVIDUALI           RAIN
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
   and PERE.ci = RAIN.ci
;
COMMENT ON TABLE REPORT_SINDACALI IS 'Elenco Situazioni Sindacali';

PROMPT 
PROMPT Creating view REPORT_TFR
CREATE VIEW REPORT_TFR AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , RAIN.cognome||' '||RAIN.nome S5
     , RAIN.cognome||'  '||RAIN.nome C5
     , RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , RAPPORTI_INDIVIDUALI           RAIN
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
   and PERE.ci = RAIN.ci
;
COMMENT ON TABLE REPORT_TFR IS 'Trattamento di Fine Rapporto';

PROMPT 
PROMPT Creating view REPORT_TOTALI
CREATE VIEW REPORT_TOTALI AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
  FROM ENTE                           ENTE
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
;
COMMENT ON TABLE REPORT_TOTALI IS 'Totali di Retribuzione';

PROMPT 
PROMPT Creating view REPORT_TOTALI_ANNO
CREATE VIEW REPORT_TOTALI_ANNO AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
  FROM ENTE                           ENTE
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
;
COMMENT ON TABLE REPORT_TOTALI_ANNO IS 'Totali di Retribuzione Annuale';


PROMPT 
PROMPT Creating view REPORT_VERIFICHE_CEDOLINO
CREATE VIEW REPORT_VERIFICHE_CEDOLINO AS 
SELECT PERE.ci CI
     , PERE.anno ANNO
     , PERE.mese MESE
     , nvl(rtrim(rpad('0',15)),0) S1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',' ',' '),15)),' ') C1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D1
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D2
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D3
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),0) S4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE','*',' '),15)),' ') C4
     , nvl(rtrim(rpad(decode(ENTE.ente_id,'ENTE',to_char(null),''),60)),' ') D4
     , RAIN.cognome||' '||RAIN.nome S5
     , RAIN.cognome||'  '||RAIN.nome C5
     , RAIN.cognome||'  '||RAIN.nome D5
     , decode(ENTE.ente_id,'ENTE','*',' ') S6
     , decode(ENTE.ente_id,'ENTE','*',' ') C6
     , decode(ENTE.ente_id,'ENTE',to_char(null),'') D6
  FROM ENTE                           ENTE
     , RAPPORTI_INDIVIDUALI           RAIN
     , PERIODI_RETRIBUTIVI            PERE
 WHERE 1 = 1
   and PERE.competenza = 'A'
   and ENTE.ente_id = 'ENTE'
   and PERE.ci = RAIN.ci
;
COMMENT ON TABLE REPORT_VERIFICHE_CEDOLINO IS 'Verifiche Cedolino'
;
