CREATE OR REPLACE PACKAGE p_inrp IS

/******************************************************************************
 NOME:          crp_p_inrp
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

CREATE OR REPLACE PACKAGE BODY p_inrp IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE INFORMAZIONI_RETRIBUTIVE_BP',(132-length('VERIFICA INTEGRITA` REFERENZIALE INFORMAZIONI_RETRIBUTIVE_BP'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE INFORMAZIONI_RETRIBUTIVE_BP')))
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
	           	, 'Cod.Ind. Voce       Sub   Qualifica  Istituto   Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ---------- ----- ---------- ---------- ---------------------'
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
	for cur_riga in (select ci, null voce, null sub, null qualifica, null istituto,
       'RAPPORTI_INDIVIDUALI' tabella
from informazioni_retributive_bp inrp
where not exists
  (select 1 from rapporti_individuali rain
    where rain.ci = inrp.ci )
union
select ci, null voce, null sub, null qualifica, null istituto,
       'RAPPORTI_RETRIBUTIVI' tabella
from informazioni_retributive_bp inrp
where not exists
  (select 1 from rapporti_retributivi rare
    where rare.ci = inrp.ci )
union
select ci, voce, null sub, null qualifica, null istituto,
       'VOCI_ECONOMICHE' tabella
from informazioni_retributive_bp inrp
where not exists
  (select 1 from voci_economiche voec
    where voec.codice = inrp.voce)
union
select ci, voce, sub, null qualifica, null istituto,
       'VOCI_CONTABILI' tabella
from informazioni_retributive_bp inrp
where not exists
  (select 1 from voci_contabili voco
    where voco.voce = inrp.voce
      and voco.sub  = inrp.sub)
union
select ci, null voce, null sub, to_char(qualifica), null istituto,
       'QUALIFICHE' tabella
from informazioni_retributive_bp inrp
where qualifica is not null
  and not exists
  (select 1 from qualifiche qual
    where qual.numero = inrp.qualifica)
union
select ci, null voce, null sub, null qualifica, istituto,
       'ISTITUTI_CREDITO' tabella
from informazioni_retributive_bp inrp
where istituto is not null
  and not exists
  (select 1 from istituti_credito iscr
    where iscr.codice = inrp.istituto)
order by 6,2,3,4,5,1

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
				  rpad(nvl(cur_riga.voce,' '),10)||' '||
				  rpad(nvl(cur_riga.sub,' '),5)||' '||
				  rpad(nvl(cur_riga.qualifica,' '),10)||' '||
				  rpad(nvl(cur_riga.istituto,' '),10)||' '||
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
END p_inrp;
/

