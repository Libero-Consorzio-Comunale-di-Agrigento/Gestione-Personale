CREATE OR REPLACE TRIGGER DDMA_TMA
 AFTER INSERT OR UPDATE OR DELETE ON DENUNCIA_DMA
FOR EACH ROW
/******************************************************************************
   NAME:       DDMA_TMA
   PURPOSE:    Modifica lo stato della tabella INDIVIDUI_DMA in modo che possano
               essere rilevate le modifiche a DENUNCIA_DMA per obbligare a
               ricalcolare i totali
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    18/07/2007 ML     Prima Emissione (A21942)
 1.1  26/09/2007 ML     Gestione anno/mese in delete e update (A23024)
 1.2  31/10/2007 ML     Gestione cf_vers per distacchi funzionali (A23457)
******************************************************************************/
declare
   integrity_error  exception;
   errno            integer;
   d_ci             number(8);
   D_cf_dic         varchar2(16);
   D_cf_app         varchar2(16);
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
   IF deleting THEN
     BEGIN
        a_istruzione := 'update individui_dma set nr_file = null where ci = '||nvl(:NEW.ci,:OLD.ci)||
                        ' and anno = '||nvl(:NEW.anno,:OLD.anno)||' and mese = '||nvl(:NEW.mese,:OLD.mese);
   dbms_output.put_line(substr(a_istruzione,1,250));
      a_messaggio  := 'Errore in cancellazione di IDMA';
        IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);
   dbms_output.put_line('NEW '||:NEW.ci);
   dbms_output.put_line('OLD '||:OLD.ci);
     END;
   ELSE
   BEGIN
     select codice_fiscale
       into D_cf_dic
       from gestioni
      where codice = :new.gestione;
   END;
   BEGIN
     select codice_fiscale
       into D_cf_app
       from gestioni
      where codice = nvl(:new.gestione_app,:new.gestione);
   END;
     BEGIN
        a_istruzione := 'delete from individui_dma'||
                      ' where ci = '||nvl(:NEW.ci,:OLD.ci)||
                      ' and anno = '||nvl(:NEW.anno,:OLD.anno)||
                      ' and mese = '||nvl(:NEW.mese,:OLD.mese);
   dbms_output.put_line(substr(a_istruzione,1,250));
      a_messaggio  := 'Errore in cancellazione di IDMA';
        IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);
   dbms_output.put_line('NEW '||:NEW.ci);
   dbms_output.put_line('OLD '||:OLD.ci);
      a_istruzione := 'insert into individui_dma'||
                    '     (  ANNO, MESE, CF_DIC, CF_APP, CF_VERS, CI) VALUES ( '||
                    :NEW.ANNO||','||:NEW.MESE||','''||D_cf_dic||''','''||D_cf_app||''','
||'nvl('''||:NEW.cf_amm_fisse||''','''||'D_cf_dic'||'''),'||
:new.ci||')';
--||:NEW.cf_amm_fisse,:new.ci||')';

   dbms_output.put_line(substr(a_istruzione,1,250));
          a_messaggio  := 'Errore in inserimento di IDMA';
            IntegrityPackage.Set_PostEvent(a_istruzione, a_messaggio);
     END;
   END IF;
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
