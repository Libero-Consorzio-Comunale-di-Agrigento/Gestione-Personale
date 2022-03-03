CREATE OR REPLACE PACKAGE PECDCODA IS
/******************************************************************************
 NOME:        PECDCODA
 DESCRIZIONE: DISATTIVA CONGUAGLIO DETRAZIONI ARRETRATE.
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    25/09/2007   NN   Prima emissione
******************************************************************************/
FUNCTION  VERSIONE                RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECDCODA IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1 del 25/09/2007';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
begin
declare
  D_rapporto                  varchar2(4);
  D_gestione                  varchar2(8);
  D_contratto                 varchar2(4);
  D_anno                      number;
  D_mese                      number;
BEGIN
  BEGIN
    select nvl(valore,'%')
      into D_rapporto
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_RAPPORTO';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
           D_rapporto      := '%';
  END;
  BEGIN
    select nvl(valore,'%')
      into D_gestione
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_GESTIONE';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
           D_gestione      := '%';
  END;
  BEGIN
    select nvl(valore,'%')
      into D_contratto
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_CONTRATTO';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
           D_contratto     := '%';
  END;

  BEGIN    -- Memorizza mese in corso
    select anno
         , mese
      into d_anno
         , d_mese
      from RIFERIMENTO_RETRIBUZIONE
    ;
  END;

  BEGIN    -- Disattiva Conguaglio Detrazioni Arretrate
    update CARICHI_FAMILIARI cafa
       set mese_att     = mese
         , mese_att_ass = mese_att
     where anno         = D_anno
       and mese_att     = D_mese
       and mese_att     > mese
       and exists (select 'x' 
                     from RAPPORTI_GIURIDICI
                    where ci = cafa.ci
                      and nvl(gestione,'%')  like nvl(D_gestione,'%') 
                      and nvl(contratto,'%') like nvl(D_contratto,'%')
                  )
       and exists (select 'x'
                    from RAPPORTI_INDIVIDUALI rain
                   where ci = cafa.ci
                     and nvl(rapporto,'%')  like nvl(D_rapporto,'%')
                  )
    ;
  END;

END;
END;
END;
/
