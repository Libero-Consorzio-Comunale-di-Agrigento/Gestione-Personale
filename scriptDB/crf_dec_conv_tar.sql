CREATE OR REPLACE FUNCTION decimali_conv_tar RETURN number IS
/******************************************************************************
 NOME:        VALUTA
 DESCRIZIONE: Indica la valuta utilizzata
 PARAMETRI:
 RITORNA:     E = Euro, L = Lire
 ECCEZIONI:   nnnnn, <Descrizione eccezione>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    18/05/2001 __     Prima emissione.
******************************************************************************/
decimali_conv_tar number;
BEGIN
   begin
     select max(decode( ente
	              , 'PENS', 2
				  , 'INPD', 2
				          , 5))
	   into decimali_conv_tar
	   from ad4.enti;
   end;
   RETURN decimali_conv_tar;
END decimali_conv_tar;
/

