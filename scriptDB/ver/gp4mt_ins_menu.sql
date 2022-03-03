REM ============================================================
REM    Progetto:   GP4 - Gestione Integrata Personale
REM    Istanza:    GP4PAL - Gestione del Personale - Parametri PAL
REM    ServerName: svi
REM    DBMS:       O73
REM    DBUser:     PAL
REM 
REM    Extract:    c:\si4\gp4\gipv4\ins\Gp4mt.ext
REM    On File:    c:\si4\gp4\gipv4\ins\gp4mt_ins_menu.sql
REM    Date:       29/09/2004  09.01.55
REM ============================================================

SET TERMOUT OFF 

REM ============================================================
REM    Extract SYNONYM :   A_VOCI_MENU
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE

INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PECEVOEC','P00','EVOEC',NULL,NULL,'Elenco Voci Economiche',NULL,NULL,'F','F','PECEVOEC',NULL,1,'P_VOEC_Q',NULL);
INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PMTCAULI','P00','CAULI',NULL,NULL,'Autorizzazione Liquidazione',NULL,NULL,'F','D','PMTCAULI',NULL,1,NULL,NULL);
INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PMTCCOUF','P00','CCOUF',NULL,NULL,'Caricamento Controllo Ufficio',NULL,NULL,'F','D','PMTCCOUF',NULL,1,'P_CRIDI',NULL);
INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PMTCGLUF','P00','CGLUF',NULL,NULL,'Controllo Globale Ufficio',NULL,NULL,'F','D','PMTCGLUF',NULL,1,NULL,NULL);
INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PMTCPAEC','P00','CPAEC',NULL,NULL,'Passaggio all'' Economico',NULL,NULL,'F','D','PMTCPAEC',NULL,1,NULL,NULL);
INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PMTCRIDI','P00','CRIDI',NULL,NULL,'Caricamento Richieste Dipendente',NULL,NULL,'F','D','PMTCRIDI',NULL,1,'P_CRIDI',NULL);
INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PMTCRIST','P00','CRIST',NULL,NULL,'Caricamento Richieste di Storno',NULL,NULL,'F','D','PMTCRIST',NULL,1,'P_CRIDI',NULL);
INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PMTDPARA','P00','DPARA',NULL,NULL,'Dizionario Parametri',NULL,NULL,'F','D','PMTDPARA',NULL,1,'P_DPARA',NULL);
INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PMTDTAVA','P00','DTAVA',NULL,NULL,'Dizionario Tabelle Valori',NULL,NULL,'F','D','PMTDTAVA',NULL,1,NULL,NULL);
INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PMTEACER','P00','EACER',NULL,NULL,'Elenco Acconti Erogati',NULL,NULL,'A','F','PMTEACER',NULL,1,NULL,NULL);
INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PMTIDIST','P00','IDIST',NULL,NULL,'Interrogazione Distinte',NULL,NULL,'F','D','PMTIDIST',NULL,1,NULL,NULL);
INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PMTIRICH','P00','IRICH',NULL,NULL,'Visualizzazione Richieste',NULL,NULL,'F','D','PMTIRICH',NULL,1,NULL,NULL);
INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PMTMT','P00','MT',NULL,NULL,'Missioni-Trasferte',NULL,NULL,'N','M',NULL,NULL,1,NULL,NULL);
INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PMTSDIST','P00','SDIST',NULL,NULL,'Stampa Distinte di Autorizzazione',NULL,NULL,'F','D','ACAPARPR',NULL,1,NULL,NULL);
INSERT INTO a_voci_menu ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PMTSRIRI','P00','SRIRI',NULL,NULL,'Stampa Richieste di Rimborso',NULL,NULL,'F','D','ACAPARPR',NULL,1,NULL,NULL);

REM ============================================================
REM    Extract SYNONYM :   A_PASSI_PROC
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE

INSERT INTO a_passi_proc ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING) VALUES ('PMTSDIST',1,'Stampa Distinte di Autorizzazione',NULL,NULL,'R','PMTSDIST',NULL,'PMTSDIST','N');
INSERT INTO a_passi_proc ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING) VALUES ('PMTSRIRI',1,'Stampa Richieste di Rimborso',NULL,NULL,'R','PMTSRIRI',NULL,'PMTSRIRI','N');

REM ============================================================
REM    Extract SYNONYM :   A_SELEZIONI
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE

INSERT INTO a_selezioni ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK) VALUES ('P_DATA_DISTINTA','PMTSDIST',2,'Data Distinta',NULL,NULL,10,'D','N',NULL,NULL,NULL,NULL,NULL);
INSERT INTO a_selezioni ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK) VALUES ('P_DATA_INIZIO','PMTSDIST',4,'Data Inizio Selezione',NULL,NULL,10,'D','S',NULL,NULL,NULL,NULL,NULL);
INSERT INTO a_selezioni ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK) VALUES ('P_NO_AUTORIZZATE','PMTSDIST',3,'Richieste non Autorizzate',NULL,NULL,1,'N','N',NULL,NULL,NULL,NULL,NULL);
INSERT INTO a_selezioni ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK) VALUES ('P_NR_DISTINTA','PMTSDIST',1,'Numero Distinta',NULL,NULL,8,'N','N',NULL,NULL,NULL,NULL,NULL);
INSERT INTO a_selezioni ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK) VALUES ('P_CI','PMTSRIRI',1,'Cod.Ind.',NULL,NULL,8,'N','N',NULL,NULL,NULL,NULL,NULL);
INSERT INTO a_selezioni ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK) VALUES ('P_DATA_FINE','PMTSRIRI',4,'Data Fine Trasferta',NULL,NULL,10,'D','N',NULL,NULL,NULL,NULL,NULL);
INSERT INTO a_selezioni ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK) VALUES ('P_DATA_FIN_AGG','PMTSRIRI',6,'Data Fine Aggiornamento',NULL,NULL,10,'D','N',NULL,NULL,NULL,NULL,NULL);
INSERT INTO a_selezioni ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK) VALUES ('P_DATA_INIZIO','PMTSRIRI',3,'Data Inizio Trasferta',NULL,NULL,10,'D','N',NULL,NULL,NULL,NULL,NULL);
INSERT INTO a_selezioni ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK) VALUES ('P_DATA_INI_AGG','PMTSRIRI',5,'Data Inizio Aggiornamento',NULL,NULL,10,'D','N',NULL,NULL,NULL,NULL,NULL);
INSERT INTO a_selezioni ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK) VALUES ('P_RICHIESTA','PMTSRIRI',2,'Richiesta',NULL,NULL,1,'N','S',NULL,'PMTSRIRI_RICHIESTA',NULL,NULL,NULL);

REM ============================================================
REM    Extract SYNONYM :   A_DOMINI_SELEZIONI
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE

INSERT INTO a_domini_selezioni ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2) VALUES ('PMTSRIRI_RICHIESTA','1',NULL,'Richiesta caricata dal dipendente',NULL,NULL);
INSERT INTO a_domini_selezioni ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2) VALUES ('PMTSRIRI_RICHIESTA','2',NULL,'Richiesta valutata dall''ufficio',NULL,NULL);
INSERT INTO a_domini_selezioni ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2) VALUES ('PMTSRIRI_RICHIESTA','3',NULL,'Tutte le Richieste',NULL,NULL);

REM ============================================================
REM    Extract SYNONYM :   A_CATALOGO_STAMPE
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE

INSERT INTO a_catalogo_stampe ( STAMPA, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_PROPRIETA, TIPO_VISURA, CLASSE, STAMPA_BLOCCATA, STAMPA_PROTETTA, SEQUENZIALE) VALUES ('PMTSDIST','Stampa Distinte di Autorizzazione',NULL,NULL,'U','U','PDF','N','N','S');
INSERT INTO a_catalogo_stampe ( STAMPA, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_PROPRIETA, TIPO_VISURA, CLASSE, STAMPA_BLOCCATA, STAMPA_PROTETTA, SEQUENZIALE) VALUES ('PMTSRIRI','Stampa Richieste di Rimborso',NULL,NULL,'U','U','PDF','N','N','S');

REM ============================================================
REM    Extract SYNONYM :   A_GUIDE_O
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE

INSERT INTO a_guide_o ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1, TITOLO_ESTESO_AL2) VALUES ('P_CRIDI',1,'ACER','A',NULL,NULL,'Acconti',NULL,NULL,NULL,'PMTEACER',NULL,NULL,NULL,NULL,NULL);
INSERT INTO a_guide_o ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1, TITOLO_ESTESO_AL2) VALUES ('P_DPARA',1,'VOEC','V',NULL,NULL,'Voci Ec.',NULL,NULL,NULL,'PECEVOEC',NULL,NULL,NULL,NULL,NULL);

REM ============================================================
REM    End Extract: c:\si4\gp4\gipv4\ins\gp4mt_ins_menu.sql
REM ============================================================