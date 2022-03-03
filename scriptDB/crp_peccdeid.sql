CREATE OR REPLACE PACKAGE peccdeid IS
/******************************************************************************
 NOME:        PECCDEID
 DESCRIZIONE: Controllo delle astensioni codificate con sequenza > 9.
              Questa funzione emette una segnalazione di errore nel caso in cui
              riscontri sull'archivio DENUCIA_INADEL l'esistenza di astensioni
              codificate con sequenza > 9.
              Il controllo viene eseguito in due momenti distinti:
              1) dopo la fase di archiviazione, in questo caso la segnalazione
              non e` bloccante, ma evidenzia la necessita` di apportare delle
              correzioni
              2) prima dell'esecuzione della stampa sul modulo INADEL, in questo
              caso la segnalazione e` bloccante e la stampa non potra` essere
              elaborata finche` sussistono le anomalie.
              
              
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
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY peccdeid IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
begin
DECLARE
 D_anno      number;
 D_assenza   VARCHAR2(30);
BEGIN
   BEGIN  -- Preleva Anno di Riferimento Fine Anno per archiviazione
      select anno
        into D_anno
        from riferimento_fine_anno
       where rifa_id = 'RIFA'
      ;
   END;
   BEGIN  -- Controllo registrazioni con astensioni codificate con sequenza > 9
      select substr(aste.descrizione,1,30)
        into D_assenza
        from astensioni aste
       where exists
            ( select 'x'
                from denuncia_inadel deid
               where deid.anno = D_anno
                 and aste.codice in (deid.cod_asp1,deid.cod_asp2,deid.cod_asp3)
            )
         and aste.sequenza > 9
         and aste.mat_anz  = 0
      ;
      RAISE TOO_MANY_ROWS;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN null;
      WHEN TOO_MANY_ROWS THEN
            update a_prenotazioni set errore = 'P04193 ('||
                                               nvl(D_assenza,'...')||')'
                                     ,prossimo_passo = 99
             where no_prenotazione = prenotazione
            ;
   END;
COMMIT;
END;
end;
end;
/

