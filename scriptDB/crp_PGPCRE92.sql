CREATE OR REPLACE PACKAGE PGPCRE92 IS

/******************************************************************************
 NOME:          PGPCRE92 TABELLA IMPORTI RETRIBUZIONI PERCEPITE FINO AL 31/12/1992
 DESCRIZIONE:   Questa fase produce un file secondo il tracciato INPDAP Importi9.txt
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  Il PARAMETRO D_gestione      indica la gestione da elaborare
               Il PARAMETRO D_cassa         indica il tipo di cassa previdenziale
               Il PARAMETRO D_cessati       indica la data minima di cessazione
               Il PARAMETRO D_ci            indica il singolo dipendente da elaborare

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    21/01/2003             
 2    10/06/2004     AM Revisioni varie a seguito dei test sul Modulo
 2.1  23/11/2006     MS Mod. gestione inre.dal null ( att.18473 )
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;

PROCEDURE MAIN (prenotazione in number,passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PGPCRE92 IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V2.1 del 23/11/2006';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
begin
DECLARE
  D_retribuzione number;
  P_pagina       number;
  P_riga         number;
  P_ente         varchar2(4);
  P_ambiente     varchar2(8);
  P_utente       varchar2(8);
  P_lingua       varchar2(1);
  P_dal          date;
  P_min_dal      date;
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
  P_pagina := 1;
  P_riga   := 1;
  BEGIN
    FOR DIP IN
       (select i.ci                          ci
             , i.codice_fiscale              cf
             , i.previdenza                  previdenza
          from inpdap i
         order by ci
       ) LOOP
         BEGIN
           select min(dal)
             into P_min_dal
             from periodi_giuridici
            where ci = DIP.ci
              and rilevanza = 'P';
         EXCEPTION WHEN NO_DATA_FOUND THEN
            BEGIN
             select min(dal)
               into P_min_dal
               from periodi_giuridici
              where ci = DIP.ci;
            EXCEPTION WHEN NO_DATA_FOUND THEN
               P_min_dal := to_date(null);
            END;
         END;
         BEGIN
           FOR PERIODI IN
           (select  distinct
                    greatest(P_dal,nvl(inre.dal,P_min_dal))  inizio
              from  informazioni_retributive        inre
             where  inre.ci                       = DIP.ci
               and  nvl(inre.dal,P_min_dal)      <= to_date('31121992','ddmmyyyy')
               and  nvl(inre.al,to_date('3333333','j')) >= P_dal
               and  inre.voce in
                   (select voce
                      from estrazione_righe_contabili
                     where estrazione     = 'PREVIDENZIALE'
                       and colonna        = '01'
                       and nvl(inre.dal,P_min_dal)
                           between dal
                               and nvl(al,to_date('3333333','j'))
                   )
             union
            select  ini_mese                        inizio
              from  mesi
             where  mese                  = 1
               and  anno                 <= 1992
               and  ini_mese             >= P_dal
               and  ini_mese             >= P_min_dal
             order  by 1
           ) LOOP
             BEGIN
      select sum(
             ( decode( esrc.tipo
                      ,'I', inre.tariffa
                          , 0
                     ) * decode(esrc.segno1,'*',esrc.dato1,'%',esrc.dato1,1)
                       / decode(esrc.segno1,'/',esrc.dato1,'%',100,1)
                       + decode(esrc.segno1,'+',esrc.dato1,'-',esrc.dato1*-1,0)
             ) * decode(esrc.segno2,'*',esrc.dato2,'%',esrc.dato2,1)
               / decode(esrc.segno2,'/',esrc.dato2,'%',100,1)
               + decode(esrc.segno2,'+',esrc.dato2,'-',esrc.dato2*-1,0)
                )
        into D_retribuzione
        FROM estrazione_righe_contabili  esrc,
             informazioni_retributive    inre
       where inre.ci                   = DIP.ci
         and inre.voce                 = esrc.voce
         and inre.sub                  = esrc.sub
         and PERIODI.inizio      between nvl(inre.dal,P_min_dal)
                                     and nvl(inre.al,to_date('3333333','j'))
         and PERIODI.inizio      between esrc.dal
                                     and nvl(esrc.al,to_date('3333333','j'))
         and esrc.estrazione           = 'PREVIDENZIALE'
         and esrc.colonna              = '01'
      ;
             END;
             BEGIN
           insert into a_appoggio_stampe
           (no_prenotazione,no_passo,pagina,riga,testo)
           select prenotazione
                , 1
                , P_pagina
                , P_riga
                , DIP.cf||
                  RPAD('1',3,' ')||
                  lpad(to_char(PERIODI.inizio,'dd/mm/yyyy'),10,'0')||
                  rpad(replace(D_retribuzione,'.',','),21,' ')||
                  lpad(to_char(DIP.ci),8,'0')
             from dual
            where D_retribuzione > 0
           ;
           P_riga := P_riga + 1 ;
             END;
             END LOOP;
         P_pagina := P_pagina + 1;
         P_riga   := 1           ;
         END;
         END LOOP;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
END;
end;
end;
/
