CREATE OR REPLACE TRIGGER aggiorna_delibere  
AFTER UPDATE ON def_delibere_retributive  
FOR EACH ROW WHEN (old.numero != new.numero or  
                   old.sede   != new.sede   or  
                   old.anno   != new.anno)
/******************************************************************************
 NOME:        AGGIORNA_DELIBERE
 DESCRIZIONE: Riporta le modifiche ai campi sede, numero ed anno
              alle tabelle
              righe_delibera_retributiva
              delibere retributive
              moviomenti_contabili
 ANNOTAZIONI: Richiama Procedure AMMINISTRAZIONI_TD
 REVISIONI:
 Rev. Data       Autore   Descrizione
 ---- ---------- ------   ------------------------------------------------------
 0    25/06/2004 Gianluca Prima emissione
******************************************************************************/
BEGIN  
  BEGIN  
    update righe_delibera_retributiva  
       set sede   = :new.sede  
          ,numero = :new.numero  
          ,anno   = :new.anno  
     where sede   = :old.sede  
       and numero = :old.numero  
       and anno   = :old.anno  
     ;  
  END;  
  BEGIN  
    update delibere_retributive  
       set sede   = :new.sede  
          ,numero = :new.numero  
          ,anno   = :new.anno  
     where sede   = :old.sede  
       and numero = :old.numero  
       and anno   = :old.anno  
    ;  
  END;  
  BEGIN  
    update movimenti_contabili  
       set sede_del   = :new.sede  
          ,numero_del = :new.numero  
          ,anno_del   = :new.anno  
     where sede_del   = :old.sede  
       and numero_del = :old.numero  
       and anno_del   = :old.anno  
    ;  
  END;  
END;
/