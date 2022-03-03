CREATE OR REPLACE PACKAGE p_imco IS

/******************************************************************************
 NOME:          crp_p_imco
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

CREATE OR REPLACE PACKAGE BODY p_imco IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE IMPUTAZIONI_CONTABILI',(132-length('VERIFICA INTEGRITA` REFERENZIALE IMPUTAZIONI_CONTABILI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE IMPUTAZIONI_CONTABILI')))
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
	           	, 'Data       Funzionale Sede Anno Numero  Divisione Soggetto  Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ---------- ---- ---- ------- --------- --------- --------------------------'
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
	for cur_riga in (select to_char(data,'dd/mm/yyyy') data, funzionale, null sede_del,
       null anno_del, null numero_del, null divisione, null soggetto,
       'CLASSIFICAZIONI_FUNZIONALI' tabella
from imputazioni_contabili imco
where funzionale is not null
  and not exists
  (select 1 from classificazioni_funzionali clfu
    where clfu.codice = imco.funzionale)
union
select to_char(data,'dd/mm/yyyy') data, null funzionale, sede_del,
       to_char(anno_del), to_char(numero_del), null divisione, null soggetto,
       'DELIBERE' tabella
from imputazioni_contabili imco
where sede_del||anno_del||numero_del is not null
  and not exists
  (select 1 from delibere deli
    where deli.sede = imco.sede_del
      and deli.anno = imco.anno_del
      and deli.numero = imco.numero_del)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select to_char(data,'dd/mm/yyyy') data, null funzionale, null sede_del,
       null anno_del, null numero_del, divisione, null soggetto,
       'GESTIONI' tabella
from imputazioni_contabili imco
where divisione != '*'
  and not exists
  (select 1 from gestioni gest
    where gest.codice = imco.divisione)
union
select to_char(data,'dd/mm/yyyy') data, null funzionale, null sede_del,
       null anno_del, null numero_del, null divisione, to_char(soggetto),
       'SOGGETTI' tabella
from imputazioni_contabili imco
where not exists
  (select 1 from soggetti sogg
    where sogg.soggetto = imco.soggetto)
order by 8,2,3,4,5,6,7,1



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
		       	, rpad(nvl(cur_riga.data,' '),10)||' '||
				  rpad(nvl(cur_riga.funzionale,' '),10)||' '||
				  rpad(nvl(cur_riga.sede_del,' '),4)||' '||
				  rpad(nvl(cur_riga.anno_del,' '),4)||' '||
				  rpad(nvl(cur_riga.numero_del,' '),7)||' '||
				  rpad(nvl(cur_riga.divisione,' '),9)||' '||
				  rpad(nvl(cur_riga.soggetto,' '),9)||' '||
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
END p_imco;
/

