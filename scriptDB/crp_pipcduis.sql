CREATE OR REPLACE PACKAGE pipcduis IS
/******************************************************************************
 NOME:          PIPCDUIS
 DESCRIZIONE:   Duplica di una versione in un' altra con eventuale ricoprimento
                se questa era gia` esistente.
                Questa fase  genera nuove versioni  di ipotesi  di spesa  ricopiando-
                le  da altre  presenti. Nel caso che la versione duplicata fosse gia`
                esistente, non si esegue la duplica.
                La nuova versione prende come data  di riferimento quella  della ver-
                sione copiata.
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    21/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY pipcduis IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 21/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
	declare   d_versione          varchar2(4);
          d_versione_prec     varchar2(4);
          d_data_rif              date;
          d_errore            varchar2(6);
          errore                  exception;
BEGIN
 BEGIN
/*
   +------------------------------------------------------------------------+
   |                                                                        |
   | Ricezione dei codici della Versione precedente e della nuova Versione. |
   | Le Versioni devono essere codificate nel dizionario.                   |
   | La nuova versione  non deve essere  gia` stata utilizzata in un' altra |
   | Ipotesi di Spesa.                                                      |
   | La versione da copiare deve esistere in ipotesi di spesa.              |
   |                                                                        |
   +------------------------------------------------------------------------+
*/
  BEGIN
     select  para.valore
       into  d_versione
       from  a_parametri para
      where  para.no_prenotazione = prenotazione
        and  para.parametro       = 'P_VERSIONE'
     ;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
       d_versione  := null;
  END;
  BEGIN
     select para.valore
       into d_versione_prec
       from a_parametri para
      where para.no_prenotazione = prenotazione
        and para.parametro       = 'P_VERSIONE_PREC'
     ;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
       d_versione_prec := null;
  END;
  BEGIN
    select veip.data_estr
      into d_data_rif
      from versioni_ipotesi_incentivo veip
     where veip.codice       = d_versione_prec
    ;
    select 'x'
      into d_errore
      from versioni_ipotesi_incentivo veip
     where veip.codice       = d_versione
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      d_errore := 'P06900';
      RAISE errore;
  END;
  BEGIN
    select 'x'
      into d_errore
      from dual
     where exists (select 'x'
                     from ipotesi_spesa_incentivo isip
                    where isip.versione = d_versione
                  )
    ;
    d_errore := 'P06901';
    RAISE errore;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select 'x'
      into d_errore
      from dual
     where exists (select 'x'
                     from ipotesi_spesa_incentivo isip
                    where isip.versione = d_versione_prec
                  )
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      d_errore := 'P06140';
      RAISE errore;
  END;
 EXCEPTION
   WHEN TOO_MANY_ROWS THEN
     d_errore := 'A00003';
     RAISE errore;
 END;
 BEGIN
/*
  +------------------------------------------------------------------+
  |                                                                  |
  |                   I N S E R I M E N T O                          |
  |                                                                  |
  +------------------------------------------------------------------+
*/
   insert  into  ipotesi_spesa_incentivo
         ( versione
         , ci
         , note
         , gruppo
         , settore
         , sede
         , equipe
         , progetto
         , ruolo
         , qualifica
         , tipo_rapporto
         , dal
         , al
         , tetto
         , ore
         , importo
         )
   select  d_versione
          ,isip.ci
          ,isip.note
          ,isip.gruppo
          ,isip.settore
          ,isip.sede
          ,isip.equipe
          ,isip.progetto
          ,isip.ruolo
          ,isip.qualifica
          ,isip.tipo_rapporto
          ,isip.dal
          ,isip.al
          ,isip.tetto
          ,isip.ore
          ,isip.importo
     from  ipotesi_spesa_incentivo           isip
    where  isip.versione               = d_versione_prec
   ;
/*
  +------------------------------------------------------------------+
  |                                                                  |
  |      A G G I O R N A M E N T O   D A T A   V E R S I O N E       |
  |                                                                  |
  +------------------------------------------------------------------+
*/
   update  versioni_ipotesi_incentivo  veip
      set  veip.data_estr   = d_data_rif
    where  veip.codice      = d_versione
   ;
   commit;
 END;
EXCEPTION
  WHEN errore THEN
    ROLLBACK;
    update a_prenotazioni set errore         = d_errore
                             ,prossimo_passo = 99
     where no_prenotazione = prenotazione
    ;
END;
commit;
end;
end;
/

