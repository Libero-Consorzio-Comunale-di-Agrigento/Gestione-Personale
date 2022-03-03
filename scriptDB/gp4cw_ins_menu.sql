REM ============================================================
REM    Progetto:   GP4 - Gestione Integrata Personale
REM    Istanza:    GP4PAL - Gestione del Personale - Parametri PAL
REM    ServerName: svi
REM    DBMS:       O73
REM    DBUser:     PAL
REM 
REM    Extract:    c:\si4\gp4\gipv4\ins\Gp4cw.ext
REM    On File:    c:\si4\gp4\gipv4\ins\gp4cw_ins_menu.sql
REM    Date:       15/11/2007  16.42.48
REM ============================================================

SET TERMOUT OFF 

REM ============================================================
REM    Extract SYNONYM :   A_CATALOGO_STAMPE
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE


REM ============================================================
REM    Extract SYNONYM :   A_PASSI_PROC
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE

INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING) VALUES ('PCWSWLOG',1,'Log Stampa Word',NULL,NULL,'R','PECSAPST',NULL,'PECSAPST','N');

REM ============================================================
REM    Extract SYNONYM :   A_SELEZIONI
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE


REM ============================================================
REM    Extract SYNONYM :   A_VOCI_MENU
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PCWCW','P00','CW',NULL,NULL,'Stampa certificati Word',NULL,NULL,'N','M',NULL,NULL,1,NULL,NULL);
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PCWDSTMW','P00','DSTMW',NULL,NULL,'Struttura Modelli Word',NULL,NULL,'F','F','PCWDSTMW',NULL,1,NULL,NULL);
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PCWSWFAP','P00','SWFAP',NULL,NULL,'Stampe Word Fascicolo Personale',NULL,NULL,'F','F','PCWSWFAP',NULL,1,'P_SWFAP',NULL);
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PCWSWLOG','P00','SWLOG',NULL,NULL,'Log Stampa Word',NULL,NULL,'F','D',NULL,NULL,1,NULL,NULL);

REM ============================================================
REM    Extract SYNONYM :   A_DOMINI_SELEZIONI
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE


REM ============================================================
REM    Extract SYNONYM :   A_GUIDE_O
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE

INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1, TITOLO_ESTESO_AL2) VALUES ('P_SWFAP',1,'RAIN','I',NULL,NULL,'Individui',NULL,NULL,NULL,'P00RINDI',NULL,NULL,NULL,NULL,NULL);

REM ============================================================
REM    Extract SYNONYM :   A_GUIDE_O
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE


REM ============================================================
REM    Extract SYNONYM :   A_GUIDE_V
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE


REM ============================================================
REM    Extract SYNONYM :   A_GUIDE_V
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE


REM ============================================================
REM    End Extract: c:\si4\gp4\gipv4\ins\gp4cw_ins_menu.sql
REM ============================================================
