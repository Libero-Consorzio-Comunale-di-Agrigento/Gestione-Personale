REM ============================================================
REM    Progetto:   GP4 - Gestione Integrata Personale
REM    Istanza:    GP4PAL - Gestione del Personale - Parametri PAL
REM    ServerName: svi
REM    DBMS:       O73
REM    DBUser:     PAL
REM 
REM    Extract:    c:\si4\gp4\gipv4\ins\Gp4ie.ext
REM    On File:    c:\si4\gp4\gipv4\ins\gp4ie_ins.sql
REM    Date:       23/11/2007  15.04.46
REM ============================================================

SET TERMOUT OFF

REM ============================================================
REM    Extract SYNONYM :   A_MENU
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE

INSERT INTO a_menu ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE) VALUES ('GP4','AMM',1013609,1013613,'PIEADARE',4,NULL);
INSERT INTO a_menu ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE) VALUES ('GP4','AMM',1013609,1013616,'PIECADAE',5,NULL);
INSERT INTO a_menu ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE) VALUES ('GP4','AMM',1013609,1013623,'PIECASTV',6,NULL);
INSERT INTO a_menu ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE) VALUES ('GP4','AMM',1013609,1013611,'PIECDARE',2,NULL);
INSERT INTO a_menu ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE) VALUES ('GP4','AMM',1013609,17661,'PIECPERI',6,NULL);
INSERT INTO a_menu ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE) VALUES ('GP4','AMM',1013609,1013610,'PIEDRECO',1,NULL);
INSERT INTO a_menu ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE) VALUES ('GP4','AMM',1013609,1013612,'PIEEDARE',3,NULL);
INSERT INTO a_menu ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE) VALUES ('GP4','AMM',0,1013609,'PIEIE',40,NULL);
WHENEVER SQLERROR CONTINUE

REM ============================================================
REM    End Extract: c:\si4\gp4\gipv4\ins\gp4ie_ins.sql
REM ============================================================
