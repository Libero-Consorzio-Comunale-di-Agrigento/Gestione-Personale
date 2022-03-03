CREATE OR REPLACE PACKAGE post_handler IS
/******************************************************************************
 NOME:          PECSMT13
 DESCRIZIONE:   

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             
******************************************************************************/

  a_post number(1) :=0;
  function torna_post return number;
  procedure setta_post(valore in number);
  FUNCTION  VERSIONE              RETURN VARCHAR2;
END;
/
CREATE OR REPLACE PACKAGE BODY post_handler IS
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;
 function torna_post return number is
    begin
	return post_handler.a_post;
    end;
  procedure setta_post(valore in number) is
	begin
		post_handler.a_post := valore;
	end;
END;
/

