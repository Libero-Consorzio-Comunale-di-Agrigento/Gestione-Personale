REM Check situazione Menu su User A00
REM e esecuzione file di inserimento Voci di Menu e Messaggi di Errore

WHENEVER SQLERROR EXIT
-- WHEN ERROR Voci di Menu già presenti
SELECT to_number('X')
  FROM DUAL
 where exists
      (select 'x' from A_AMBIENTI
        where AMBIENTE = 'P00'
      )
/

WHENEVER SQLERROR EXIT 1

REM Inserimento Voci Menu
REM A_AMBIENTI 
REM A_CATALOGO_STAMPE 
REM A_DOMINI_SELEZIONI 
REM A_FUNZIONI_CHIAMATE 
REM A_GUIDE_O 
REM A_GUIDE_V 
REM A_INDICI_AIUTO 
REM A_PASSI_PROC 
REM A_SELEZIONI 
REM A_VOCI_MENU 

start gp4_ins_menu1.sql
start gp4_ins_menu2.sql

REM Inserimento Messaggi di Errore
REM A_AIUTI_ERRORE
REM A_ERRORI 

start Gp4_ins_err.sql
