CREATE OR REPLACE PACKAGE PECSSNRF IS
/******************************************************************************
 NOME:        PECSSNRF 
 DESCRIZIONE: Rinomina File TXT per Supporto Magnetico SMT Aziende Sanitarie
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  04/05/2005 CB     Prima Emissione
 2.0  21/04/2006 MS     Adeguamento per SMT/2006 ( Att.15823 )
 2.1  05/05/2006 MS     Modifica nome file ( Att.15823.1 )
 2.2  10/05/2006 MS     Controllo su Negativi ( Att. 15843 )
 3.0  15/05/2006 MS     Modifica lunghezza tracciato tabella 13 ( Att. 20830.3 )
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY PECSSNRF IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V3.0 del 15/05/2006';
END VERSIONE;
PROCEDURE MAIN ( prenotazione in number, passo in number) is
   P_nome_file  varchar2(50);
   P_lunghezza  varchar2(20);
   P_voce_menu  varchar2(8);
 BEGIN
    select voce_menu
      into P_voce_menu
      from a_prenotazioni
     where no_prenotazione = prenotazione
     ;
       IF passo = 3 
        THEN -- Tabella 1A - Personale per figura professionale
           P_nome_file := 'tab1A2.txt';
           P_lunghezza  := 75;
        ELSIF passo = 5 
         THEN -- Tabella 2 - Personale flessibile
           P_nome_file := 'tab020.txt';
           P_lunghezza := 95;
        ELSIF passo = 7 
         THEN -- Tabella 3 - Personale dell''amministrazione ed esterno
           P_nome_file := 'tab030.txt';
           P_lunghezza := 83;
        ELSIF passo = 9
         THEN -- Tabella 4 - Passaggi di ruolo / posizione economica / profilo
           P_nome_file := 'tab040.txt';
           P_lunghezza := 33;
        ELSIF passo = 11
         THEN -- Tabella 5 - Personale cessato
           P_nome_file := 'tab200.txt';
           P_lunghezza := 115;
        ELSIF passo = 13
         THEN -- Tabella 6 - Personale assunto'
           P_nome_file := 'tab300.txt';
           P_lunghezza := 99;
        ELSIF passo = 15
         THEN -- Tabella 7 - Personale per anzianita
           P_nome_file := 'tab500.txt';
           P_lunghezza := 179;
        ELSIF passo = 17
         THEN -- Tabella 8 - Personale per eta
           P_nome_file := 'tab080.txt';
           P_lunghezza := 211;
        ELSIF passo = 19
         THEN -- Tabella 9 - personale per titolo di studio
           P_nome_file := 'tab600.txt';
           P_lunghezza := 99;
        ELSIF passo = 21
         THEN -- Tabella 12 - Spesa annua di retribuzione
           P_nome_file := 'tab8A0.txt';
           P_lunghezza := 138;
        ELSIF passo = 23
         THEN -- Tabella 13 - Indennita'' e compensi accessori SSN
           P_nome_file := 'tab131.txt';
           P_lunghezza := 187;
        ELSIF passo = 25
         THEN -- Tabella 1B - Personale Universitario
           P_nome_file := 'tab1B1.txt';
           P_lunghezza := 59;
        ELSIF passo = 27
         THEN -- Tabella 1E - Personale Per Fasce Retributive
           P_nome_file := 'tab1E1.txt';
           P_lunghezza := 200;
        ELSE -- Tabella 1 - Personale per qualifica - ripristino valori iniziali
           P_nome_file := 'tab1A1.txt';
           P_lunghezza := 171;
      END IF;
 BEGIN
  update a_selezioni
     set valore_default = p_nome_file
   where parametro      ='TXTFILE'
     and voce_menu      = p_voce_menu
  ;
  update a_selezioni
     set valore_default = p_lunghezza
   where parametro      ='NUM_CARATTERI'
     and voce_menu      = p_voce_menu
  ;
  update a_prenotazioni 
     set errore          = 'P05808'
  where no_prenotazione = prenotazione
    and exists
       (select 'x' 
          from a_appoggio_stampe
         where no_prenotazione = prenotazione
           and no_passo = 29
       )
  ;
  commit;
  END;
COMMIT;
end;
END;
/



