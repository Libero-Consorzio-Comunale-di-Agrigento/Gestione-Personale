CREATE OR REPLACE PACKAGE peccepda IS
/******************************************************************************
 NOME:        PECCEPDA
 DESCRIZIONE: Controllo della elaborabilita` del report richiesto, con la fase SEPDA
              (solo dati alfabetici).
              Questa funzione emette una segnalazione di errore nel caso in cui
              il report richiesto preveda dati numerici.
              
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(estrazione in varchar2);
end;
/

CREATE OR REPLACE PACKAGE BODY peccepda IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
procedure main (estrazione in varchar2) is
begin
DECLARE
  D_estrazione VARCHAR2(20);
  D_x          VARCHAR2(1);
BEGIN
  BEGIN  -- Estrazione richiesta
    select rtrim(substr(estrazione,1,20),' ')
      into D_estrazione
      from dual
    ;
  END;
  BEGIN  -- Controllo di Esistenza dell'Estrazione richiesta
    select 'x'
      into D_x
      from estrazione_report
     where nvl(sequenza,999) != 999
       and estrazione = D_estrazione
    ;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN RAISE NO_DATA_FOUND;
  END;
  BEGIN  -- Controllo di Compatibilita` dell'Estrazione richiesta
    select 'x'
      into D_x
      from relazione_attr_estrazione
     where estrazione = D_estrazione
       and alias not in ( 'CI', 'ANNO', 'MESE','MENSILITA'
                        , 'COL1', 'COL2', 'COL3', 'COL4', 'COL5'
                        , 'COL6', 'COL7', 'COL8', 'COL9', 'COL10'
                        , 'COL11', 'COL12', 'COL13', 'COL14'
                        )
    ;
  EXCEPTION
  WHEN TOO_MANY_ROWS THEN NULL;
  WHEN NO_DATA_FOUND THEN RAISE NO_DATA_FOUND;
  END;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
/*
    update a_prenotazioni set errore = 'P05870 ('||
                                        nvl(D_estrazione,'...')||')'
                                     ,prossimo_passo = 99
             where no_prenotazione = prenotazione
    ;
    COMMIT;
*/
		raise no_data_found;
END;
end;
end;
/

