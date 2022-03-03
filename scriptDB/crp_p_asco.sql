CREATE OR REPLACE PACKAGE p_asco IS

/******************************************************************************
 NOME:          crp_p_asco
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

CREATE OR REPLACE PACKAGE BODY p_asco IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;

PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
	p_pagina	number := 1;
	contarighe	number;
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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE ASSEGNAZIONI_CONTABILI',(132-length('VERIFICA INTEGRITA` REFERENZIALE ASSEGNAZIONI_CONTABILI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE ASSEGNAZIONI_CONTABILI')))
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
	           	, 'Cod.Ind. Settore  Sede     Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- -------- -------- -------------------------'
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
	for cur_riga in (select ci, '      ' settore, '      ' sede,
       'RAPPORTI_INDIVIDUALI' tabella
  from assegnazioni_contabili asco
where not exists
  (select 1 from rapporti_individuali rain
    where rain.ci = asco.ci )
union
select ci, '      ' settore, '      ' sede,
       'RAPPORTI_RETRIBUTIVI' tabella
  from assegnazioni_contabili asco
where not exists
  (select 1 from rapporti_retributivi rare
    where rare.ci = asco.ci )
union
select ci,to_char(settore), '      ' sede,
       'SETTORI' tabella
  from assegnazioni_contabili asco
where not exists
  (select 1 from settori sett
    where sett.numero = asco.settore)
union
select ci, '      ' settore,to_char(sede),
       'SEDI' tabella
  from assegnazioni_contabili asco
where asco.sede != 0
  and not exists
  (select 1 from sedi sede
    where sede.numero = asco.sede)
union
select ci,to_char(settore),to_char(sede),
       'RIPARTIZIONI_FUNZIONALI' tabella
  from assegnazioni_contabili asco
where not exists
  (select 1 from ripartizioni_funzionali rifu
    where rifu.settore = asco.settore
      and rifu.sede    = asco.sede)
order by 4,2,3,1

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
				  rpad(nvl(cur_riga.settore,' '),8)||' '||
				  rpad(nvl(cur_riga.sede,' '),8)||' '||
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
END p_asco;
/

