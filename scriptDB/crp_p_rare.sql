CREATE OR REPLACE PACKAGE p_rare IS

/******************************************************************************
 NOME:          crp_p_rare
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

FUNCTION  VERSIONE              RETURN VARCHAR2;

  PROCEDURE MAIN      (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY p_rare IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE RAPPORTI_RETRIBUTIVI',(132-length('VERIFICA INTEGRITA` REFERENZIALE RAPPORTI_RETRIBUTIVI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE RAPPORTI_RETRIBUTIVI')))
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
	           	, 'Num.Ind. Istituto Sport.   Pos.INAIL Tratt. Ci Erede Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- -------- -------- --------- ------ -------- --------------------------'
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
	for cur_riga in (select ci,'     ' istituto,'     ' sportello,'    ' posizione_inail,
       '    ' trattamento,'        ' ci_erede,
       'RAPPORTI_INDIVIDUALI' tabella
  from rapporti_retributivi rare
 where not exists
       (select 1 from rapporti_individuali rain
         where rain.ci = rare.ci)
union
select ci,'     ' istituto,'     ' sportello,'    ' posizione_inail,
       '    ' trattamento,'        ' ci_erede,
       'RAPPORTI_GIURIDICI' tabella
  from rapporti_retributivi rare
 where not exists
       (select 1 from rapporti_giuridici ragi
         where ragi.ci = rare.ci)
union
select ci, istituto,'     ' sportello,'    ' posizione_inail,
       '    ' trattamento,'        ' ci_erede,
       'ISTITUTI_CREDITO' tabella
  from rapporti_retributivi rare
 where not exists
       (select 1 from istituti_credito iscr
         where iscr.codice = rare.istituto)
union
select ci, istituto, sportello,'    ' posizione_inail,
       '    ' trattamento,'        ' ci_erede,
       'SPORTELLI' tabella
  from rapporti_retributivi rare
 where not exists
       (select 1 from sportelli spor
         where spor.istituto = rare.istituto
           and spor.sportello = rare.sportello)
union
select ci,'     ' istituto,'     ' sportello, posizione_inail,
       '    ' trattamento,'        ' ci_erede,
       'ASSICURAZIONI_INAIL' tabella
  from rapporti_retributivi rare
 where posizione_inail is not null
   and not exists
       (select 1 from assicurazioni_inail asin
         where asin.codice = rare.posizione_inail)
union
select ci,'     ' istituto,'     ' sportello,'    ' posizione_inail,
       trattamento,'        ' ci_erede,
       'TRATTAMENTI_PREVIDENZIALI' tabella
  from rapporti_retributivi rare
 where trattamento is not null
   and not exists
       (select 1 from trattamenti_previdenziali trpr
         where trpr.codice = rare.trattamento)
union
select ci,'     ' istituto,'     ' sportello,'    ' posizione_inail,
       '    ' trattamento,to_char(ci_erede),
       'RAPPORTI_RETRIBUTIVI' tabella
  from rapporti_retributivi rare
 where ci_erede is not null
   and not exists
       (select 1 from rapporti_retributivi rare2
         where rare2.ci = rare.ci_erede)
   and not exists
       (select 'x' from rapporti_individuali rarea
                      , rapporti_individuali rareb
         where rarea.ci = rare.ci
           and rareb.ci = rare.ci_erede
           and rarea.ni = rareb.ni
       )
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
				  rpad(nvl(cur_riga.ci_erede,' '),8)||' '||
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
END p_rare;
/

