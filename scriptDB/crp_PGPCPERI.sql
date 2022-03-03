CREATE OR REPLACE PACKAGE PGPCPERI IS
/******************************************************************************
 NOME:          PGPCPERI TABELLA PERIODI RETRIBUTIVI
 DESCRIZIONE:   Questa fase produce un file secondo il tracciato INPDAP Periodi.txt
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    21/01/2003
 2    10/06/2004     AM Revisioni varie a seguito dei test sul Modulo
 3    28/06/2004     ML	Gestione CI in coda al record
 4    05/10/2004     AM	mod. lettura 'mesi' per uniformarla con CIMPO
 5    11/10/2004     ML	Modificato il cursore PERIODI e la lettura della data_fine per considerare
                        anche gli incarichi la parte di servizio "normale" tra la fine dell'incarico 
                        e la fine del servizio stesso.
 5.1  26/10/2006     ML Modificato il cursore PERIODI per errata estrazione di periodi in cui il 
                        dipenendente non era in servizio (A18205).
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number,passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PGPCPERI IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V5.1 del 26/10/2006';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
begin
DECLARE
  D_retribuzione number;
  D_fine         date;
  P_dummy        varchar2(1);
  P_pagina       number;
  P_riga         number;
  P_ente         varchar2(4);
  P_ambiente     varchar2(8);
  P_utente       varchar2(8);
  P_lingua       varchar2(1);
  P_dal          date;
  D_dal_prec     date;
  --
  -- Estrazione Parametri di Selezione della Prenotazione
  --
BEGIN
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
    select to_date(substr(valore,1,10),'dd/mm/yyyy')
      into P_dal
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_DAL'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN P_dal := to_date('01011940','ddmmyyyy');
  END;
-- dbms_output.put_line('Dal: '||p_dal);
  P_pagina := 1;
  P_riga   := 999999;
  BEGIN
    FOR DIP IN
       (select i.ci                          ci
             , i.codice_fiscale              cf
             , i.previdenza                  previdenza
          from inpdap i
         order by ci
       ) LOOP
 dbms_output.put_line('CI: '||DIP.ci);
         D_dal_prec :='';
         BEGIN
           FOR PERIODI IN
           (select  distinct
                    greatest(P_dal,dal)             inizio
              from  informazioni_retributive        inre
             where  inre.ci                       = DIP.ci
               and  inre.dal                     >= to_date('01011993','ddmmyyyy')
               and  nvl(inre.al,to_date('3333333','j')) >= P_dal
               and  (inre.voce,inre.sub) in
                   (select voce,sub
                      from estrazione_righe_contabili
                     where estrazione     = 'PREVIDENZIALE'
                       and colonna        = '01'
                       and inre.dal between dal
                                        and nvl(al,to_date('3333333','j'))
                   )
               and inre.dal <=
                   (select max(nvl(al,to_date('3333333','j')))
                      from periodi_giuridici
                     where ci        = DIP.ci
                       and rilevanza = 'P'
                   )
             union
            select  inre.al+1
              from  informazioni_retributive        inre
             where  inre.ci                       = DIP.ci
               and  inre.dal                     >= to_date('01011993','ddmmyyyy')
               and  nvl(inre.al,to_date('3333333','j')) >= P_dal
               and  (inre.voce,inre.sub) in
                   (select voce,sub
                      from estrazione_righe_contabili
                     where estrazione     = 'PREVIDENZIALE'
                       and colonna        = '01'
                       and inre.dal between dal
                                        and nvl(al,to_date('3333333','j'))
                   )
               and inre.al+1 <=
                   (select max(nvl(al,to_date('3333333','j')))
                      from periodi_giuridici
                     where ci        = DIP.ci
                       and rilevanza = 'P'
                   )
             union
            select  ini_mese                        inizio
              from  mesi
             where  mese                  = 1
               and  anno                 >= 1993
               and  ini_mese             >= P_dal
               and  ini_mese             >=
                   (select min(dal)
--                      from rapporti_giuridici   mod. del 05/10/2004
                      from periodi_giuridici
--                      from rapporti_individuali
                     where ci                   = DIP.ci
                       and rilevanza            = 'P'
                       and to_char(nvl(al,sysdate),'yyyy') >= 1993
                   )
               and  ini_mese              <
--                   (select max(nvl(al,to_date('3333333','j')))
                   (select max(nvl(al,to_date('3112'||to_char(sysdate,'yyyy'),'ddmmyyyy')))
                      from periodi_giuridici
                     where ci        = DIP.ci
                       and rilevanza = 'P'
                       and nvl(to_char(al,'yyyy'),to_char(sysdate,'yyyy')) >= 1993
                   )
             order  by 1 desc
           ) LOOP
 dbms_output.put_line('Inizio: '||PERIODI.inizio);
             BEGIN
      select least( nvl(min(inre.al),nvl(max(pegi.al),to_date('3333333','j')))
                   ,to_date('3112'||to_char(PERIODI.inizio,'yyyy'),'ddmmyyyy')
                   ,nvl(D_dal_prec-1,to_date('3333333','j'))
                  )
        into D_fine
        FROM estrazione_righe_contabili  esrc,
             periodi_giuridici           pegi,
             informazioni_retributive    inre
       where inre.ci                   = DIP.ci
         and inre.voce                 = esrc.voce
         and inre.sub                  = esrc.sub
         and PERIODI.inizio      between esrc.dal
                                     and nvl(esrc.al,to_date('3333333','j'))
         and PERIODI.inizio      between inre.dal
                                     and nvl(inre.al,to_date('3333333','j'))
         and esrc.estrazione           = 'PREVIDENZIALE'
         and esrc.colonna              = '01'
         and pegi.ci                   = inre.ci
         and pegi.rilevanza            = 'Q'
         and PERIODI.inizio      between pegi.dal
                                     and nvl(pegi.al,to_date('3333333','j'))
      ;
             END;
 dbms_output.put_line('Fine: '||D_fine);
             BEGIN
           insert into a_appoggio_stampe
           (no_prenotazione,no_passo,pagina,riga,testo)
           select prenotazione
                , 1
                , P_pagina
                , P_riga
                , DIP.cf||
                  '   '||
                  lpad(to_char(PERIODI.inizio,'dd/mm/yyyy'),10,'0')||
                  '1'||
                  lpad(to_char(nvl(D_fine,sysdate),'dd/mm/yyyy'),10,'0')||
                  rpad(' ',30,' ')||
                  lpad(to_char(DIP.ci),8,'0')
             from dual
           ;
          D_dal_prec := PERIODI.inizio;
  dbms_output.put_line('dal_prec: '||periodi.inizio);
           P_riga := P_riga - 1 ;
             END;
             END LOOP;
         P_pagina := P_pagina + 1;
         P_riga   := 999999      ;
         END;
         END LOOP;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
END;
end;
end;
/
