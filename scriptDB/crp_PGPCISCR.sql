CREATE OR REPLACE PACKAGE PGPCISCR IS
/******************************************************************************
 NOME:          PGPCISCR
 DESCRIZIONE:   Questa fase produce un file secondo il tracciato INPDAP Iscritti.txt

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:   Il PARAMETRO D_gestione      indica la gestione da elaborare
                Il PARAMETRO D_cassa         indica il tipo di cassa previdenziale
                Il PARAMETRO D_cessati       indica la data minima di cessazione
                Il PARAMETRO D_ci            indica il singolo dipendente da elaborare

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 0    21/01/2003             
 1	23/06/2004	ML	Gestione univoca di dipendenti che hanno un NI e + CI
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number,passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY PGPCISCR IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.1 del 23/06/2004';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
begin
DECLARE
  P_pagina       number;
  P_riga         number;
  P_ente         varchar2(4);
  P_ambiente     varchar2(8);
  P_utente       varchar2(8);
  P_lingua       varchar2(1);
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
    P_riga := 0;
    FOR CUR_NI in 
       (select distinct 
               rpad(anag.codice_fiscale,16,' ')||
               rpad(substr(anag.nome,1,30),30,' ')||
               rpad(substr(anag.cognome,1,30),30,' ')||
               lpad(to_char(anag.data_nas,'dd/mm/yyyy'),10,'0')||
               rpad(substr(comu.descrizione||' '||anag.luogo_nas,1,40),40,' ')||
               rpad(substr(comu.sigla_provincia,1,2),2,' ')||
               rpad(nvl(rare.posizione_cpd,rare.posizione_cps),10,' ') testo
         from  rapporti_retributivi    rare
              ,anagrafici              anag
              ,comuni                  comu
              ,rapporti_individuali    rain
        where anag.ni            = rain.ni
        /* residui della V2 quando rain.ci non era univoco - Annalena
          and rain.dal           = (select max(dal)
                                      from rapporti_individuali
                                     where ni = rain.ni
                                       and rapporto in
                                          (select codice from classi_rapporto
                                            where cat_fiscale = 1
                                              and retributivo = 'SI'
                                              and giuridico   = 'SI'
                                          )
                                    )
       */
          and rain.dal     between anag.dal and nvl(anag.al,to_date('3333333','j'))
          and rain.ci            = rare.ci
          and comu.cod_provincia = anag.provincia_nas
          and comu.cod_comune    = anag.comune_nas
          and exists
             (select 'x' from  inpdap where ci = rain.ci)
      ) LOOP

           P_riga := P_riga + 1;

           insert into a_appoggio_stampe
                  (no_prenotazione,no_passo,pagina,riga,testo)
           values (prenotazione,1,1,P_riga,CUR_NI.testo);
        END LOOP;
  END;
END;
end;
end;
/

