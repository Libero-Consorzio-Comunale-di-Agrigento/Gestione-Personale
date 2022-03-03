CREATE OR REPLACE PACKAGE p_rars IS

/******************************************************************************
 NOME:          crp_p_rars
 DESCRIZIONE:   

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    14/02/2006             
******************************************************************************/

FUNCTION  VERSIONE    RETURN VARCHAR2;
  PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO        IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY p_rars IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 14/02/2006';
   END VERSIONE;

PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
	p_pagina	number := 1;
	contarighe  number;
procedure insert_intestazione(contarighe in out number, pagina in number) is
	begin
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, null
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE RAPPORTI_RETRIBUTIVI_STORICI'
                             ,(132-length('VERIFICA INTEGRITA` REFERENZIALE RAPPORTI_RETRIBUTIVI_STORICI'))/2
                                  +(length('VERIFICA INTEGRITA` REFERENZIALE RAPPORTI_RETRIBUTIVI_STORICI')))
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, null
	           )
			   ;
	contarighe:=contarighe+1;
	insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , pagina
	        	, contarighe
	           	, 'Num.Ind. Istituto Sport.   Pos.INAIL Tratt. Dal        Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- -------- -------- --------- ------ ---------- --------------------------'
	           )
			   ;
		commit;
		end;
     BEGIN
	select nvl(max(riga),0)
	  into contarighe
	  from a_appoggio_stampe
	 where no_prenotazione = prenotazione
	 ;
	for cur_riga in 
        (select ci,'     ' istituto,'     ' sportello,'    ' posizione_inail
              , '    ' trattamento, to_char(rars.dal,'dd/mm/yyyy') dal
              , 'RAPPORTI_INDIVIDUALI' tabella
           from rapporti_retributivi_storici rars
          where not exists
               (select 1 from rapporti_individuali rain
                 where rain.ci = rars.ci)
         union
         select ci,'     ' istituto,'     ' sportello,'    ' posizione_inail
              , '    ' trattamento, to_char(rars.dal,'dd/mm/yyyy') dal
              , 'RAPPORTI_GIURIDICI' tabella
           from rapporti_retributivi_storici rars
          where not exists
                (select 1 from rapporti_giuridici ragi
                  where ragi.ci = rars.ci)
         union
         select ci, istituto,'     ' sportello,'    ' posizione_inail
              , '    ' trattamento, to_char(rars.dal,'dd/mm/yyyy') dal
              , 'ISTITUTI_CREDITO' tabella
           from rapporti_retributivi_storici rars
          where not exists
                (select 1 from istituti_credito iscr
                  where iscr.codice = rars.istituto)
         union
         select ci, istituto, sportello,'    ' posizione_inail
              , '    ' trattamento, to_char(rars.dal,'dd/mm/yyyy') dal
              , 'SPORTELLI' tabella
           from rapporti_retributivi_storici rars
          where not exists
                (select 1 from sportelli spor
                  where spor.istituto = rars.istituto
                    and spor.sportello = rars.sportello)
         union
         select ci,'     ' istituto,'     ' sportello, posizione_inail
              , '    ' trattamento, to_char(rars.dal,'dd/mm/yyyy') dal
              , 'ASSICURAZIONI_INAIL' tabella
           from rapporti_retributivi_storici rars
          where posizione_inail is not null
            and not exists
                (select 1 from assicurazioni_inail asin
                  where asin.codice = rars.posizione_inail)
         union
         select ci,'     ' istituto,'     ' sportello,'    ' posizione_inail
              , trattamento, to_char(rars.dal,'dd/mm/yyyy') dal
              , 'TRATTAMENTI_PREVIDENZIALI' tabella
           from rapporti_retributivi_storici rars
          where trattamento is not null
            and not exists
                (select 1 from trattamenti_previdenziali trpr
                  where trpr.codice = rars.trattamento)

         order by 7,2,3,4,5,6,1
         ) loop
		if mod(contarighe,57)= 0 then
			   insert_intestazione(contarighe,p_pagina);
		end if;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
		       	, contarighe
		       	, rpad(nvl(to_char(cur_riga.ci),' '),8)||' '||
				  rpad(nvl(cur_riga.istituto,' '),8)||' '||
  				  rpad(nvl(cur_riga.sportello,' '),8)||' '||
  				  rpad(nvl(cur_riga.posizione_inail,' '),9)||' '||
  				  rpad(nvl(cur_riga.trattamento,' '),6)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  cur_riga.tabella
		        );
	end loop;
	while TRUE loop
		if mod(contarighe,57)= 0 then exit; end if;
		contarighe := contarighe+1;
		insert into a_appoggio_stampe
		values ( prenotazione
        		, passo
		        , P_pagina
		       	, contarighe
		       	, null
		        );
	end loop;
	COMMIT;
END MAIN;
END p_rars;
/
