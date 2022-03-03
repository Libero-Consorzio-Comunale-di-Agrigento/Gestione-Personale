REM ============================================================
REM    Progetto:   SI4V3 - Gestione Ambiente di Sistema
REM    Istanza:    A00 - Gestione Ambiente di Sistema
REM    ServerName: svi
REM    DBMS:       O73
REM    DBUser:     A00
REM 
REM    Extract:    c:\si4\si4\si4v3\ins\Gp4eb.ext
REM    On File:    c:\si4\si4\si4v3\ins\gp4eb_ins_menu.sql
REM    Date:       07/08/2007  09.16.38
REM ============================================================

SET TERMOUT OFF 

REM ============================================================
REM    Extract TABLE :   A_CATALOGO_STAMPE
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE


REM ============================================================
REM    Extract TABLE :   A_PASSI_PROC
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE


REM ============================================================
REM    Extract TABLE :   A_SELEZIONI
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE


REM ============================================================
REM    Extract TABLE :   A_VOCI_MENU
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PEBCASBA','P00','CASBA',NULL,NULL,'Assegnazione Badge',NULL,NULL,'F','F','PEBCASBA',NULL,1,'P_CASBA',NULL);
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PEBDMOBA','P00','DMOBA',NULL,NULL,'Definizione Modelli per Badge',NULL,NULL,'F','F','PEBDMOBA',NULL,1,NULL,NULL);
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PEBDPABA','P00','DPABA',NULL,NULL,'Definizione Parametri Badge',NULL,NULL,'F','F','PEBDPABA',NULL,1,NULL,NULL);
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PEBDSTBA','P00','DSTBA',NULL,NULL,'Definizione Stampanti per Badge',NULL,NULL,'F','F','PEBDSTBA',NULL,1,NULL,NULL);
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PEBEB','P00','EB',NULL,NULL,'Emissione Badge',NULL,NULL,'N','M',NULL,NULL,1,NULL,NULL);
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA) VALUES ('PEBSBACO','P00','SBACO',NULL,NULL,'Stampa Badge per collettivita''',NULL,NULL,'F','F','PEBSBACO',NULL,1,NULL,NULL);


REM ============================================================
REM    Extract TABLE :   A_DOMINI_SELEZIONI
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE


REM ============================================================
REM    Extract TABLE :   A_GUIDE_O
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE

INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1, TITOLO_ESTESO_AL2) VALUES ('P_CASBA',1,'RAIN','I',NULL,NULL,'Individui',NULL,NULL,NULL,'P00RANAG',NULL,NULL,NULL,NULL,NULL);


REM ============================================================
REM    Extract TABLE :   A_GUIDE_O
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE


REM ============================================================
REM    Extract TABLE :   A_GUIDE_V
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE


REM ============================================================
REM    Extract TABLE :   A_GUIDE_V
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE


REM ============================================================
REM    End Extract: c:\si4\si4\si4v3\ins\gp4eb_ins_menu.sql
REM ============================================================
