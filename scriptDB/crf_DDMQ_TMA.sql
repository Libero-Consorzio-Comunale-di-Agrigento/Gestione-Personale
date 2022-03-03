CREATE OR REPLACE TRIGGER DDMQ_TMA
 AFTER INSERT OR UPDATE OR DELETE ON DENUNCIA_DMA_QUOTE
FOR EACH ROW
/******************************************************************************
   NAME:       DDMQ_TMA
   PURPOSE:    Modifica lo stato della tabella INDIVIDUI_DMA in modo che possano
               essere rilevate le modifiche a DENUNCIA_DMA_QUOTE per obbligare a
               ricalcolare i totali
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    27/07/2007 ML     Prima Emissione (A21942)
 1.1  26/09/2007 ML     Gestione anno/mese in delete e update (A23024)
 1.2  31/10/2007 ml     Gestione cf_vers per distacchi funzionali (A23457)
******************************************************************************/
   
DECLARE D_cf_dic     varchar2(16);
        D_cf_app     varchar2(16);
   BEGIN
   IF deleting THEN
     BEGIN
        update individui_dma 
           set nr_file = null 
         where ci      = nvl(:NEW.ci,:OLD.ci)
           and anno    = nvl(:NEW.anno,:OLD.anno)
           and mese    = nvl(:NEW.mese,:OLD.mese)
        ;
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
      where codice = :new.gestione;
   END;
     BEGIN
        delete from individui_dma 
         where ci   = nvl(:NEW.ci,:OLD.ci)
           and anno = nvl(:NEW.anno,:OLD.anno)
           and mese = nvl(:NEW.mese,:OLD.mese);
   dbms_output.put_line('NEW '||:NEW.ci);
   dbms_output.put_line('OLD '||:OLD.ci);
        insert into individui_dma
               ( ANNO, MESE, CF_DIC, CF_APP, CF_VERS, CI) 
        VALUES ( :NEW.ANNO,:NEW.MESE,D_cf_dic,D_cf_app,D_cf_dic,:new.ci);
     END;
   END IF;
   END;
/
