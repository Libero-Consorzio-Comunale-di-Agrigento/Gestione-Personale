CREATE OR REPLACE PACKAGE PGPCINPD IS

/******************************************************************************
 NOME:          crp_pgpcinpd   ARCHIVIAZIONE TABELLA INPDAP       
 DESCRIZIONE:   Questa fase valorizza la tabelle INPDAP 

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 0    20/01/2003        Prima emissione
 1    24/06/2004 ML	Gestione parametro P_TUTTI_CI      
 1.1  03/08/2004 AM	Eliminato il controlo per trattare solo il personale di ruolo
 2    09/09/2004 MV	A7024  - Trattamenti Previdenziali, gestione del nuovo campo tipo_trattamento
 2.1  30/01/2006 ML     A14647 - Modificata gestione tipo trattamento previdenziale
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

PROCEDURE MAIN (prenotazione in number,passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY PGPCINPD IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V2.1 del 30/01/2006';
   END VERSIONE;

PROCEDURE MAIN (prenotazione in number, passo in number) IS
begin
DECLARE
  P_dummy        varchar2(1);
  P_pagina       number;
  P_riga         number;
  P_ente         varchar2(4);
  P_ambiente     varchar2(8);
  P_utente       varchar2(8);
  P_lingua       varchar2(1);
  P_gestione     varchar2(4);
  P_contratto    varchar2(4);
  P_cassa        varchar2(5);
  P_cessati_dal  date;
  P_cessati_al   date;
  P_ci           number;
  P_tutti_ci     varchar2(1);

  --
  -- Estrazione Parametri di Selezione della Prenotazione
  --
BEGIN
  si4.sql_execute('truncate table inpdap');
  BEGIN
    select ente
         , utente
         , ambiente
         , gruppo_ling
      into P_ente,P_utente,P_ambiente,P_lingua
      from a_prenotazioni
     where no_prenotazione = prenotazione
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select substr(valore,1,4)
      into P_gestione
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_GESTIONE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select substr(valore,1,4)
      into P_contratto
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CONTRATTO'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select substr(valore,1,5)
      into P_cassa
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CASSA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select to_date(substr(valore,1,10),'dd/mm/yyyy')
      into P_cessati_dal
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CESSATI_DAL'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
              P_cessati_dal := to_date('01011900','ddmmyyyy');
  END;
  BEGIN
    select to_date(substr(valore,1,10),'dd/mm/yyyy')
      into P_cessati_al
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CESSATI_AL'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
              P_cessati_al := to_date('31122100','ddmmyyyy');
  END;
  BEGIN
    select substr(valore,1,8)
      into P_ci
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CI'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select substr(valore,1,1)
      into P_tutti_ci
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_TUTTI_CI'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    BEGIN
      insert into  inpdap(CI,CODICE_FISCALE,PREVIDENZA)
      select distinct pegi.ci
                     ,anag.codice_fiscale
                     ,trpr.previdenza
        from periodi_giuridici         pegi
            ,rapporti_individuali      rain
            ,trattamenti_previdenziali trpr
            ,rapporti_retributivi      rare
            ,anagrafici                anag
       where pegi.rilevanza = 'S'
/* mod. del 03/08/2004 eliminato:
         and exists
            (select 'x' from posizioni
              where codice     = pegi.posizione
                and ruolo      = 'SI'
            )
*/
         and (   (    P_cessati_dal = to_date('01011900','ddmmyyyy')
                  and P_cessati_al  = to_date('31122100','ddmmyyyy')
                 )
              or exists
                (select 'x' from periodi_giuridici x
                  where ci        = rain.ci
                    and rilevanza = 'P'
                    and al       >= P_cessati_dal
                    and al       <= P_cessati_al
                    and not exists
                       (select 'x' from periodi_giuridici y
                         where ci         = rain.ci
                           and rilevanza  = 'P'
                           and dal        > x.al
                       )
                )
             )
         and pegi.gestione   like P_gestione
         and exists
            ( select 'x' from qualifiche_giuridiche
               where numero         = pegi.qualifica
                 and pegi.dal between dal and nvl(al,pegi.dal)
                 and contratto like P_contratto
            )
         and pegi.ci         = rain.ci
         and (   P_ci is not null and P_tutti_ci is not null and rain.ni in 
                                                                (select ni from rapporti_individuali where ci = P_ci)
              or P_ci is not null and P_tutti_ci is null and rain.ci = P_ci
              or P_ci is null
             )
         and anag.ni         = rain.ni
         and pegi.dal  between anag.dal and nvl(anag.al,to_date('3333333','j'))
         and rare.ci         = pegi.ci
         and trpr.codice     = rare.trattamento
         and trpr.previdenza like 'CP%'
         and trpr.previdenza like nvl(P_cassa,trpr.previdenza)
         and pegi.dal        = (select max(dal)
                                  from periodi_giuridici
                                 where ci         = pegi.ci
                                   and rilevanza  = 'S'
                               )
      ;
      insert into inpdap(CI,CODICE_FISCALE,PREVIDENZA)
      select distinct pegi.ci
                     ,anag.codice_fiscale
                     ,trpr.previdenza
        from periodi_giuridici         pegi
            ,rapporti_individuali      rain
            ,rapporti_retributivi      rare
            ,trattamenti_previdenziali trpr
            ,trattamenti_contabili     trco
            ,figure_giuridiche         figi
            ,anagrafici                anag
       where pegi.rilevanza = 'S'
       and trco.tipo_trattamento = nvl(rare.tipo_trattamento,'0')
/* mod. del 03/08/2004 eliminato:
         and exists
            (select 'x' from posizioni
              where codice     = pegi.posizione
                and ruolo      = 'SI'
            )
*/
         and (   (    P_cessati_dal = to_date('01011900','ddmmyyyy')
                  and P_cessati_al  = to_date('31122100','ddmmyyyy')
                 )
              or exists
                (select 'x' from periodi_giuridici x
                  where ci        = rain.ci
                    and rilevanza = 'P'
                    and al       >= P_cessati_dal
                    and al       <= P_cessati_al
                    and not exists
                       (select 'x' from periodi_giuridici y
                         where ci         = rain.ci
                           and rilevanza  = 'P'
                           and dal        > x.al
                       )
                )
              )
         and pegi.gestione   like P_gestione
         and exists
            ( select 'x' from qualifiche_giuridiche
               where numero         = pegi.qualifica
                 and pegi.dal between dal and nvl(al,pegi.dal)
                 and contratto like P_contratto
            )
         and pegi.ci         = rare.ci
         and pegi.ci         = rain.ci
         and anag.ni         = rain.ni
         and (   P_ci is not null and P_tutti_ci is not null and rain.ni in 
                                                                (select ni from rapporti_individuali where ci = P_ci)
              or P_ci is not null and P_tutti_ci is null and rain.ci = P_ci
              or P_ci is null
             )
         and pegi.dal  between anag.dal and nvl(anag.al,to_date('3333333','j'))
         and trpr.codice     = trco.trattamento
         and trpr.previdenza like 'CP%'
         and trpr.previdenza like nvl(P_cassa ,trpr.previdenza)
         and pegi.dal        = (select max(dal)
                                  from periodi_giuridici
                                 where ci         = pegi.ci
                                   and rilevanza  = 'S'
                               )
         and trco.posizione  = pegi.posizione
         and trco.profilo_professionale = figi.profilo
         and pegi.dal between nvl(figi.dal,to_date(2222222,'j'))
                          and nvl(figi.al ,to_date(3333333,'j'))
         and figi.numero                = pegi.figura
         and not exists
            (select 'x' from inpdap
              where ci = pegi.ci
            )
      ;
    END;
  END;
END;
end;
end;
/

