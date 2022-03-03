start crf_GET_NO_BADGE.sql
start crf_GET_STRINGA_BADGE.sql

CREATE OR REPLACE TRIGGER AGGIORNA_ASBA
 AFTER INSERT or UPDATE ON PERIODI_GIURIDICI
FOR EACH ROW
/******************************************************************************
 NOME:        AGGIORNA_ASBA
 DESCRIZIONE: Aggiorna ASSEGNAZIONI_BADGE in caso di assunzione o cessazione
              di un Individuo
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    19/07/2007     GM Prima emissione.
******************************************************************************/
DECLARE
  d_temp         VARCHAR2(1);
  d_numero_badge NUMBER;
  d_progressivo  NUMBER;
  d_errore       VARCHAR2(8);
  d_segnalazione VARCHAR2(256);
BEGIN
  BEGIN
    select 1 
      into d_temp
      from obj 
     where object_name = 'PARAMETRI_BADGE'
     ;  
     IF UPDATING THEN
       -- Se il campo AL è diverso da NULL Il CI è CESSATO
       IF nvl(:NEW.al,to_date('3333333','j')) != to_date('3333333','j') AND nvl(:OLD.al,to_date('3333333','j')) = to_date('3333333','j')  AND :NEW.rilevanza = 'P' THEN
         --raise_application_error(-20007,'1');       
         update assegnazioni_badge
            set dal              = :NEW.dal
               ,al               = :NEW.al
               ,causale_chiusura = 'CES'
               ,stato            = 'C'
               ,utente           = 'Aut.PEGI'
               ,data_agg         = sysdate
          where ci = :NEW.ci
            and stato in ('A','S')
            and :new.al between dal 
                            and nvl(al,to_date('3333333','j'))            
         ;
       -- Se AL è nuovamente NULL Riattivo anche il numero BADGE  
       ELSIF nvl(:NEW.al,to_date('3333333','j')) = to_date('3333333','j') AND nvl(:OLD.al,to_date('3333333','j')) != to_date('3333333','j')AND :NEW.rilevanza = 'P' THEN
         --raise_application_error(-20007,'2');           
         update assegnazioni_badge
            set dal                  = :NEW.dal
               ,al                   = :NEW.al
               ,causale_attribuzione = 'ASU'
               ,causale_chiusura     = to_char(null)
               ,stato                = 'A'
               ,utente               = 'Aut.PEGI'
               ,data_agg             = sysdate
          where ci = :NEW.ci
            and stato in ('C')
            and :old.al between dal 
                            and nvl(al,to_date('3333333','j'))            
         ;
       -- Se cambiano gli estremi del periodo cambio gli estremi del periodo di ASSEGNAZIONE BADGE           
       ELSIF :NEW.dal != :OLD.dal OR :NEW.al != :OLD.al AND :NEW.rilevanza = 'P' THEN
         --raise_application_error(-20007,'3 ' || to_char(:NEW.dal,'dd/mm/yyyy') || ' ' || to_char(:OLD.dal,'dd/mm/yyyy')); 
         update assegnazioni_badge
            set dal              = :NEW.dal
               ,al               = :NEW.al
               ,utente           = 'Aut.PEGI'
               ,data_agg         = sysdate
          where ci = :NEW.ci
            and stato in ('A','S','C')
            and dal = :old.dal           
         ;           
       END IF; 
     END IF;
  EXCEPTION
    when NO_DATA_FOUND then
      null;
  END;
END AGGIORNA_ASBA;
/

