CREATE OR REPLACE PACKAGE chk_scad IS

/******************************************************************************
 NOME:          crp_chk_scad
 DESCRIZIONE:   

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003        prima emissione
 1.1  08/02/2005 MS     modifiche per ccaaf
 1.2  12/01/2006 MS     aggiunto cnocu e fasi mensili
 1.3  29/05/2006 MS     Mod. per 770/2006
 1.4  26/01/2007 MS     Mod. per CUD/2007
 1.5  02/04/2007 MS     Mod. per 770/2007 - CADFA
 1.6  20/09/2007 MS     Mod. gestione variabile D_anno
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY chk_scad IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.6 del 20/09/2007';
   END VERSIONE;

 PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
 BEGIN
DECLARE
D_voce_menu        varchar(8);
D_tipo_denuncia    varchar(10);
D_data_scadenza    varchar(4);
D_anno_denuncia    number;
D_anno             number;
BEGIN
  select voce_menu
    into D_voce_menu
    from a_prenotazioni
   where no_prenotazione = prenotazione
  ;
  BEGIN
    select to_number(valore)
      into D_anno_denuncia
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro = 'P_ANNO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      IF D_voce_menu in ( 'PECCADPM', 'PECCADMI', 'PECCADMA' ,'PECXADMI', 'PECCCAAF')  THEN
         select anno
           into D_anno_denuncia
           from riferimento_retribuzione
          where rire_id = 'RIRE'
         ;
      ELSE
         select anno
           into D_anno_denuncia
           from riferimento_fine_anno
          where rifa_id = 'RIFA'
         ;
      END IF;
  END;
  BEGIN
    select valore_default
      into D_tipo_denuncia
      from a_selezioni
     where voce_menu = d_voce_menu
       and parametro = 'P_TIPO_DENUNCIA'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      IF D_voce_menu in ('PECCARFI','PECCNOCU', 'PECCADFA'
                        ,'PECCARDP','PECCAEDP','PECCAO1M','PECCO1MD'
                        ,'PECCADPM','PECCADMI', 'PECCADMA' ,'PECXADMI','PXXCNPER') THEN
         D_tipo_denuncia := 'CUD';
      ELSIF D_voce_menu in ('PECCADNA','PECCATFR','PECCRCDP','PECXAC40') THEN
         D_tipo_denuncia := '770';  
      ELSIF D_voce_menu in ('PECCCAAF') THEN
         D_tipo_denuncia := '730';  
      ELSE
         D_tipo_denuncia := ' ';  
      END IF;
  END;
  BEGIN
    select anno
      into D_anno
      from riferimento_retribuzione rire
         , mensilita mens
     where rire.mese = mens.mese
       and rire.mensilita = mens.mensilita
       and tipo != 'B'
  ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         select to_char(sysdate,'yyyy')
           into D_anno
           from dual;
  END;
  BEGIN
    select to_char(nvl(data_forzatura,data_scadenza),'ddmm')
      into D_data_scadenza
      from scadenze_denunce
     where codice = D_tipo_denuncia 
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_data_scadenza := to_char(sysdate,'ddmm');
  END;

  IF D_data_scadenza != '3112' and sysdate <= to_date(D_data_scadenza||D_anno,'ddmmyyyy') THEN
     IF D_anno_denuncia = D_anno 
     or ( D_anno_denuncia = D_anno - 1 and D_voce_menu != 'PECCCAAF' ) 
     THEN
        null;
     ELSE
        insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
        values(prenotazione,passo,1,'P00109','Denuncia Scaduta impossibile eseguire la fase');
        COMMIT;
        chk_err.main(prenotazione,passo);
     END IF;
  ELSIF D_data_scadenza != '3112' and sysdate > to_date(D_data_scadenza||D_anno,'ddmmyyyy') THEN
    IF D_anno_denuncia = D_anno THEN
       null;
    ELSE
        insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore,precisazione)
        values(prenotazione,passo,1,'P00109','Denuncia Scaduta impossibile eseguire la fase');
        COMMIT;
        chk_err.main(prenotazione,passo);
    END IF;
  ELSE
    null;
  END IF;
END;
end;
end;
/
