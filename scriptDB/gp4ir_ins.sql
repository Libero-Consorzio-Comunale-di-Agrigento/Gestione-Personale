REM ============================================================
REM    Progetto:   GP4 - Gestione Integrata Personale
REM    Istanza:    GP4PAL - Gestione del Personale - Parametri PAL
REM    ServerName: svi
REM    DBMS:       O73
REM    DBUser:     PAL
REM 
REM    Extract:    c:\si4\gp4\gipv4\ins\Gp4ir.ext
REM    On File:    c:\si4\gp4\gipv4\ins\gp4ir_ins.sql
REM    Date:       23/11/2007  15.04.47
REM ============================================================

SET TERMOUT OFF 

REM ============================================================
REM    Extract SYNONYM :   A_MENU
REM ============================================================

WHENEVER SQLERROR EXIT

WHENEVER SQLERROR CONTINUE

INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE) VALUES ('GP4','*',1004572,13223,'PXIRISCV',90,NULL);
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE) VALUES ('GP4','AMM',1004572,13223,'PXIRISCV',90,NULL);

WHENEVER SQLERROR CONTINUE

REM ============================================================
REM    End Extract: c:\si4\gp4\gipv4\ins\gp4ir_ins.sql
REM ============================================================
