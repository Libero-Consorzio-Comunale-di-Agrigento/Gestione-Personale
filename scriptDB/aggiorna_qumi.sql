-- set serveroutput on size 1000000
DECLARE

V_dal date;

BEGIN
select max(dal) 
  into V_dal
from validita_qualifica_ministero;

  IF V_dal < to_date('01012002','ddmmyyyy') THEN
     INSERT INTO VALIDITA_QUALIFICA_MINISTERO ( DAL, AL, NOTE )
     select to_date('01012002','ddmmyyyy'), null, null
       from dual;
    update validita_qualifica_ministero
       set al = to_date('31122001','ddmmyyyy')
     where dal = V_dal;
    commit;
    INSERT INTO QUALIFICHE_MINISTERIALI ( CODICE, DESCRIZIONE, SEQUENZA, DAL, AL,CATEGORIA )
    select CODICE
         , DESCRIZIONE
         , SEQUENZA
         , to_date('01012002','ddmmyyyy')
         , null
         , CATEGORIA
      from qualifiche_ministeriali
     where dal = V_dal
       and codice not in ('0TPTLN','0PALSU','0PCFLA');
    update qualifiche_ministeriali
       set al = to_date('31122001','ddmmyyyy')
     where dal = V_dal;
    INSERT INTO RIGHE_QUALIFICA_MINISTERIALE ( CODICE, SEQUENZA, QUALIFICA, TIPO_RAPPORTO, FIGURA,
    DI_RUOLO, TEMPO_DETERMINATO, PART_TIME, RAPPORTO_GG, FORMAZIONE_LAVORO, DAL, AL )
    select CODICE
         , SEQUENZA
         , QUALIFICA
         , TIPO_RAPPORTO
         , FIGURA
         , DI_RUOLO
         , TEMPO_DETERMINATO
         , PART_TIME
         , RAPPORTO_GG
         , FORMAZIONE_LAVORO
         , to_date('01012002','ddmmyyyy')
         , null
      from righe_qualifica_ministeriale
     where dal = V_dal
       and codice not in ('0TPTLN','0PALSU','0PCFLA');
    update righe_qualifica_ministeriale
       set al = to_date('31122001','ddmmyyyy')
     where dal = V_dal;
commit;
-- ELSE
-- dbms_output.put_line('Qualifiche Ministeriali NON aggiornabili - DAL: '||V_dal);
END IF;
END;
/