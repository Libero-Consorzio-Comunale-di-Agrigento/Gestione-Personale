REM
REM FILE
REM 
REM PURPOSE
REM   Creazione SYNONYM per table legate ad altri Ambienti.                 
REM 
REM TOP TITLE
REM   
REM 
REM DESCRIPTION
REM   Lancio del file SQL*Plus per creazione SYNONYM su ambiente A00 
REM   e ambiente P00 (principale) e GRANT e SYNONYM su Ambienti Esterni.
REM 
REM NOTES
REM 
REM 
REM MODIFIED
REM 
REM

PROMPT +----------------------------------------------------------------------+
PROMPT |                                                                      |
PROMPT |          Installazione Integrazioni con altri Ambienti               |
PROMPT |                                                                      |
PROMPT +----------------------------------------------------------------------+
PROMPT
PROMPT   Table Ambiente Sistema   Table Ref_codes   Table altri Ambienti
PROMPT
PROMPT   COMUNI                   GIP_REF_CODES     DELIBERE
PROMPT   GRUPPI_LINGUISTICI       PAM_REF_CODES     CORRISPONDENZE
PROMPT                           PGM_REF_CODES     CENTRI_COSTO
PROMPT                           PEC_REF_CODES     IMPUTAZIONI_CENTRO_COSTO
PROMPT                           PPO_REF_CODES     SOGGETTI
PROMPT                           PPA_REF_CODES     BILANCIO
PROMPT                           PIP_REF_CODES

SET VERIFY  OFF
SET FEED    OFF
SET SCAN    ON
SET CONCAT  OFF

SET TERMOUT ON

SET HEADING OFF
SET PAUSE   OFF

column D_user  noprint
column D_table noprint new_value P_table

PROMPT
PROMPT Connessione ad User Oracle da Installare
PROMPT
ACCEPT new_user char PROMPT 'Enter user-name: ';
ACCEPT new_pass char PROMPT 'Enter password: ' HIDE;
connect &new_user/&new_pass

WHENEVER SQLERROR EXIT

select USER D_user from sys.dual;

WHENEVER SQLERROR CONTINUE

PROMPT
PROMPT Creazione Sinonimi su Ambiente di Sistema
PROMPT _________________________________________
PROMPT
PROMPT View COMUNI su Table A_COMUNI ...
SET TERMOUT OFF
drop table   comuni;            
drop view    comuni;       
drop synonym comuni;       
SET TERMOUT ON
start crv_comu.sql
PROMPT
PROMPT Creazione Sinonimo  GRUPPI_LINGUISTICI
SET TERMOUT OFF
drop table   gruppi_linguistici;            
drop view    gruppi_linguistici;       
drop synonym gruppi_linguistici;       
SET TERMOUT ON
create synonym GRUPPI_LINGUISTICI for a_gruppi_linguistici;

PROMPT
PROMPT Creazione Sinonimi per Table di REF_CODES      
PROMPT _________________________________________
PROMPT
PROMPT Connessione a USER proprietario per autorizzazione
PROMPT
ACCEPT gip_user char prompt 'USER Oracle Proprietario: ';
ACCEPT gip_pass char prompt 'Password: ' HIDE;
connect &gip_user/&gip_pass       

WHENEVER SQLERROR EXIT

select USER D_user from sys.dual;

WHENEVER SQLERROR CONTINUE

grant select on GIP_REF_CODES to &new_user with grant option;
grant select on PAM_REF_CODES to &new_user with grant option;
grant select on PGM_REF_CODES to &new_user with grant option;
grant select on PEC_REF_CODES to &new_user with grant option;
grant select on PPO_REF_CODES to &new_user with grant option;
grant select on PPA_REF_CODES to &new_user with grant option;
grant select on PIP_REF_CODES to &new_user with grant option;
connect &new_user/&new_pass
SET TERMOUT OFF
drop synonym GIP_REF_CODES;
drop synonym PAM_REF_CODES;
drop synonym PGM_REF_CODES;
drop synonym PEC_REF_CODES;
drop synonym PPO_REF_CODES;
drop synonym PPA_REF_CODES;
drop synonym PIP_REF_CODES;
SET TERMOUT ON
PROMPT
PROMPT Creazione Sinonimo  GIP_REF_CODES
create synonym GIP_REF_CODES for &gip_user.GIP_REF_CODES;
PROMPT
PROMPT Creazione Sinonimo  PAM_REF_CODES
create synonym PAM_REF_CODES for &gip_user.PAM_REF_CODES;
PROMPT
PROMPT Creazione Sinonimo  PGM_REF_CODES
create synonym PGM_REF_CODES for &gip_user.PGM_REF_CODES;
PROMPT
PROMPT Creazione Sinonimo  PEC_REF_CODES
create synonym PEC_REF_CODES for &gip_user.PEC_REF_CODES;
PROMPT
PROMPT Creazione Sinonimo  PPO_REF_CODES
create synonym PPO_REF_CODES for &gip_user.PPO_REF_CODES;
PROMPT
PROMPT Creazione Sinonimo  PPA_REF_CODES
create synonym PPA_REF_CODES for &gip_user.PPA_REF_CODES;
PROMPT
PROMPT Creazione Sinonimo  PIP_REF_CODES
create synonym PIP_REF_CODES for &gip_user.PIP_REF_CODES;

PROMPT
PROMPT Creazione Sinonimi su altri Ambienti
PROMPT ____________________________________
PROMPT
PROMPT Vista per Table DELIBERE 
PROMPT
PROMPT N.B.: Se l'archivio e` privato dell'User da Installare
PROMPT         NON INTRODURRE I PARAMETRI RICHIESTI                    
PROMPT
PROMPT Connessione a USER proprietario per autorizzazione
PROMPT
ACCEPT gip_user char prompt 'USER Oracle Proprietario: ';
ACCEPT gip_pass char prompt 'Password: ' HIDE;
PROMPT
ACCEPT t_name char prompt 'Nome Tavola DELIBERE di Segreteria: ';     
SET TERMOUT OFF
connect &gip_user/&gip_pass  
grant all on &t_name to &new_user;
DEFINE P_table = ''
select decode('&t_name',null,null,'delibere') D_table from sys.dual;
connect &new_user/&new_pass
drop table   &P_table;            
drop view    &P_table;       
drop synonym &P_table;       
SET TERMOUT ON
create or replace view delibere 
as select  SEDE,  ANNO,  NUMERO ,  DATA  
        , ' ' OGGETTO
        , DESCRIZIONE 
        , ' ' ESECUTIVITA
        , TIPO_ESE 
        , ' ' NUMERO_ESE 
        ,  to_date(null) DATA_ESE  
        , ' ' NOTE
from &gip_user.&t_name;
PROMPT
PROMPT Sinonimo per Table CORRISPONDENZE
PROMPT
PROMPT N.B.: Se l'archivio e` privato dell'User da Installare
PROMPT         NON INTRODURRE I PARAMETRI RICHIESTI                    
PROMPT
PROMPT Connessione a USER proprietario per autorizzazione
PROMPT
ACCEPT gip_user char prompt 'USER Oracle Proprietario: ';
ACCEPT gip_pass char prompt 'Password: ' HIDE;
PROMPT
ACCEPT t_name char prompt 'Nome Tavola CORRISPONDENZE di Segreteria: ';     
SET TERMOUT OFF
connect &gip_user/&gip_pass  
grant all on &t_name to &new_user;
DEFINE P_table = ''
select decode('&t_name',null,null,'corrispondenze') D_table from sys.dual;
connect &new_user/&new_pass
drop table   &P_table;            
drop view    &P_table;       
drop synonym &P_table;       
SET TERMOUT ON
create synonym CORRISPONDENZE for &gip_user.&t_name;

PROMPT
PROMPT Sinonimo per Table CENTRI_COSTO
PROMPT
PROMPT N.B.: Se l'archivio e` privato dell'User da Installare
PROMPT         NON INTRODURRE I PARAMETRI RICHIESTI                    
PROMPT
PROMPT Connessione a USER proprietario per autorizzazione
PROMPT
ACCEPT gip_user char prompt 'USER Oracle Proprietario: ';
ACCEPT gip_pass char prompt 'Password: ' HIDE;
PROMPT
ACCEPT t_name char prompt 'Nome Tavola CENTRI_COSTO di C.d.C.: ';     
SET TERMOUT OFF
connect &gip_user/&gip_pass  
grant all on &t_name to &new_user;
DEFINE P_table = ''
select decode('&t_name',null,null,'centri_costo') D_table from sys.dual;
connect &new_user/&new_pass
drop table   &P_table;            
drop view    &P_table;       
drop synonym &P_table;       
SET TERMOUT ON
create synonym CENTRI_COSTO for &gip_user.&t_name;

PROMPT
PROMPT Sinonimo per Table IMPUTAZIONI_CENTRO_COSTO
PROMPT
PROMPT N.B.: Se l'archivio e` privato dell'User da Installare
PROMPT         NON INTRODURRE I PARAMETRI RICHIESTI                    
PROMPT
PROMPT Connessione a USER proprietario per autorizzazione
PROMPT
ACCEPT gip_user char prompt 'USER Oracle Proprietario: ';
ACCEPT gip_pass char prompt 'Password: ' HIDE;
PROMPT
ACCEPT t_name char prompt 'Nome Tavola MOVIMENTI di C.d.C.: ';     
SET TERMOUT OFF
connect &gip_user/&gip_pass  
grant all on &t_name to &new_user;
DEFINE P_table = ''
select decode('&t_name',null,null,'imputazioni_centro_costo') D_table
  from sys.dual;
connect &new_user/&new_pass
drop table   &P_table;            
drop view    &P_table;       
drop synonym &P_table;       
SET TERMOUT ON
create synonym IMPUTAZIONI_CENTRO_COSTO for &gip_user.&t_name;

PROMPT
PROMPT Sinonimo per Table SOGGETTI     
PROMPT
PROMPT N.B.: Se l'archivio e` privato dell'User da Installare
PROMPT         NON INTRODURRE I PARAMETRI RICHIESTI                    
PROMPT
PROMPT Connessione a USER proprietario per autorizzazione
PROMPT
ACCEPT gip_user char prompt 'USER Oracle Proprietario: ';
ACCEPT gip_pass char prompt 'Password: ' HIDE;
PROMPT
ACCEPT t_name char prompt 'Nome Tavola SOGGETTI di Contabilita`: ';     
SET TERMOUT OFF
connect &gip_user/&gip_pass  
grant all on &t_name to &new_user;
DEFINE P_table = ''
select decode('&t_name',null,null,'soggetti') D_table from sys.dual;
connect &new_user/&new_pass
drop table   &P_table;            
drop view    &P_table;       
drop synonym &P_table;       
SET TERMOUT ON
create synonym SOGGETTI for &gip_user.&t_name;

PROMPT
PROMPT Sinonimo per Table BILANCIO     
PROMPT
PROMPT N.B.: Se l'archivio e` privato dell'User da Installare
PROMPT         NON INTRODURRE I PARAMETRI RICHIESTI                    
PROMPT
PROMPT Connessione a USER proprietario per autorizzazione
PROMPT
ACCEPT gip_user char prompt 'USER Oracle Proprietario: ';
ACCEPT gip_pass char prompt 'Password: ' HIDE;
PROMPT
ACCEPT t_name char prompt 'Nome Tavola BILANCIO di Contabilita`: ';     
SET TERMOUT OFF
connect &gip_user/&gip_pass  
grant all on &t_name to &new_user;
DEFINE P_table = ''
select decode('&t_name',null,null,'bilancio') D_table from sys.dual;
connect &new_user/&new_pass
drop table   &P_table;            
drop view    &P_table;       
drop synonym &P_table;       
SET TERMOUT ON
create synonym BILANCIO for &gip_user.&t_name;

PROMPT +----------------------------------------------------------------------+
PROMPT |                                                                      |
PROMPT |     Fine Installazione Integrazioni con altri Ambienti               |
PROMPT |                                                                      |
PROMPT +----------------------------------------------------------------------+

EXIT     
