CREATE OR REPLACE TRIGGER RARS_TMA
 AFTER INSERT OR UPDATE OR DELETE ON RAPPORTI_RETRIBUTIVI_STORICI
FOR EACH ROW
/******************************************************************************
   NAME:       RARS_TMA
   PURPOSE:    Mantiene aggiornata la tabella RAPPORTI_RETRIBUTIVI all'ultima
               registrazione di RARS
******************************************************************************/
declare
   integrity_error  exception;
   errno            integer;
   d_ci             number(8);
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin
            /* NONE */ null;
         end;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
      -- Set PostEvent Check REFERENTIAL Integrity on DELETE
   DECLARE a_istruzione  varchar2(2000);
           a_messaggio   varchar2(2000);
   BEGIN
      a_istruzione := 'delete from rapporti_retributivi'|| 
	                  ' where ci = '||nvl(:NEW.ci,:OLD.ci)||
	                  '   and not exists (select ''x'' from rapporti_retributivi_storici'||
					  '                    where ci = '||nvl(:NEW.ci,:OLD.ci)||
					  '                  )';
-- dbms_output.put_line(substr(a_istruzione,1,250));
	  a_messaggio  := 'Errore in cancellazione di RARE';
      IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);
-- dbms_output.put_line('NEW '||:NEW.ci);
-- dbms_output.put_line('OLD '||:OLD.ci);
	  a_istruzione := 'delete from rapporti_retributivi where ci = '||nvl(:NEW.ci,:OLD.ci);
-- dbms_output.put_line(substr(a_istruzione,1,250));				  
	  a_messaggio  := 'Errore in cancellazione di RARE';
      IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);				  
	  a_istruzione := 'insert into rapporti_retributivi'||
            		  '     (  CI,MATRICOLA,ISTITUTO,SPORTELLO,CONTO_CORRENTE,COD_NAZIONE, CIN_EUR , CIN_ITA, DELEGA,SPESE,ULTERIORI'||
                      '       ,POSIZIONE_INAIL,DATA_INAIL,TRATTAMENTO,TIPO_TRATTAMENTO,CODICE_CPD,POSIZIONE_CPD,DATA_CPD'||
                      '       ,CODICE_CPS,POSIZIONE_CPS,DATA_CPS,CODICE_INPS,CODICE_IAD,DATA_IAD,CI_EREDE'||
                      '       ,QUOTA_EREDE,STATISTICO1,STATISTICO2,STATISTICO3,UTENTE,DATA_AGG,TIPO_EREDE'||
                      '       ,TIPO_ULTERIORI,TIPO_SPESE,ATTRIBUZIONE_SPESE)'||
            		  'select  CI,MATRICOLA,ISTITUTO,SPORTELLO,CONTO_CORRENTE,COD_NAZIONE, CIN_EUR , CIN_ITA, DELEGA,SPESE,ULTERIORI'||
                      '       ,POSIZIONE_INAIL,DATA_INAIL,TRATTAMENTO,TIPO_TRATTAMENTO,CODICE_CPD,POSIZIONE_CPD,DATA_CPD'||
                      '       ,CODICE_CPS,POSIZIONE_CPS,DATA_CPS,CODICE_INPS,CODICE_IAD,DATA_IAD,CI_EREDE'||
                      '       ,QUOTA_EREDE,STATISTICO1,STATISTICO2,STATISTICO3,UTENTE,DATA_AGG,TIPO_EREDE'||
                      '       ,TIPO_ULTERIORI,TIPO_SPESE,ATTRIBUZIONE_SPESE'||
            		  '  from rapporti_retributivi_storici'||
            		  ' where ci  = '||nvl(:NEW.ci,:OLD.ci)||
                      '   and dal = (select max(dal) from rapporti_retributivi_storici'||
            		  '  	          where ci = '||nvl(:NEW.ci,:OLD.ci)||
                      '             )';
-- dbms_output.put_line(substr(a_istruzione,1,250));
    	  a_messaggio  := 'Errore in inserimento di RARE';
          IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);
   END;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;

/ 
