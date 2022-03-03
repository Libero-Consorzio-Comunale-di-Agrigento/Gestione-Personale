CREATE OR REPLACE PACKAGE p_anag IS

/******************************************************************************
 NOME:          crp_p_anag
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

CREATE OR REPLACE PACKAGE BODY p_anag IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;

PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
	p_pagina	number := 1;
	contarighe  number := 0;
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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE ANAGRAFICI',(132-length('VERIFICA INTEGRITA` REFERENZIALE ANAGRAFICI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE ANAGRAFICI')))
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
	           	, 'Num.Ind. Dal        Cat.Pr. Pr.Nas Com.Nas Pr.Res Com.Res Pr.Dom Com.Dom Pr.Doc Com.Doc St.Civ Tit.St. Ling. Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ---------- ------- ------ ------- ------ ------- ------ ------- ------ ------- ------ ------- ----- ------------------'
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
	for cur_riga in (select ni,to_char(dal,'dd/mm/yyyy') dal,
       '    ' categoria_protetta,
       to_char(provincia_nas) provincia_nas,to_char(comune_nas) comune_nas,
       '   ' provincia_res,'   ' comune_res,
       '   ' provincia_dom,'   ' comune_dom,
       '   ' provincia_doc,'   ' comune_doc,
       '    ' gruppo_ling,
       '    ' stato_civile,
       '    ' titolo_studio,
       'COMUNI' tabella
from anagrafici
where (comune_nas is not null
   or  provincia_nas is not null)
  and not exists
  (select 1 from comuni
    where cod_comune = comune_nas
      and cod_provincia = provincia_nas)
  and exists (select 'x' from rapporti_individuali where ni = anagrafici.ni)
union
select ni,to_char(dal,'dd/mm/yyyy') dal,
       '    ' categoria_protetta,
       '   ' provincia_nas,'   ' comune_nas,
       to_char(provincia_res) provincia_res,to_char(comune_res) comune_res,
       '   ' provincia_dom,'   ' comune_dom,
       '   ' provincia_doc,'   ' comune_doc,
       '    ' gruppo_ling,
       '    ' stato_civile,
       '    ' titolo_studio,
       'COMUNI' tabella
from anagrafici
where not exists
  (select 1 from comuni
    where cod_comune = comune_res
      and cod_provincia = provincia_res)
  and exists (select 'x' from rapporti_individuali where ni = anagrafici.ni)
union
select ni,to_char(dal,'dd/mm/yyyy') dal,
       '    ' categoria_protetta,
       '   ' provincia_nas,'   ' comune_nas,
       '   ' provincia_res,'   ' comune_res,
       to_char(provincia_dom) provincia_dom,to_char(comune_dom) comune_dom,
       '   ' provincia_doc,'   ' comune_doc,
       '    ' gruppo_ling,
       '    ' stato_civile,
       '    ' titolo_studio,
       'COMUNI' tabella
from anagrafici
where not exists
  (select 1 from comuni
    where cod_comune = comune_dom
      and cod_provincia = provincia_dom)
  and exists (select 'x' from rapporti_individuali where ni = anagrafici.ni)
union
select ni,to_char(dal,'dd/mm/yyyy') dal,
       '    ' categoria_protetta,
       '   ' provincia_nas,'   ' comune_nas,
       '   ' provincia_res,'   ' comune_res,
       '   ' provincia_dom,'   ' comune_dom,
       to_char(provincia_doc) provincia_doc,to_char(comune_doc) comune_doc,
       '    ' gruppo_ling,
       '    ' stato_civile,
       '    ' titolo_studio,
       'COMUNI' tabella
from anagrafici
where (comune_doc is not null
   or  provincia_doc is not null)
  and not exists
  (select 1 from comuni
    where cod_comune = comune_doc
      and cod_provincia = provincia_doc)
  and exists (select 'x' from rapporti_individuali where ni = anagrafici.ni)
union
select ni,to_char(dal,'dd/mm/yyyy') dal,
       '    ' categoria_protetta,
       '   ' provincia_nas,'   ' comune_nas,
       '   ' provincia_res,'   ' comune_res,
       '   ' provincia_dom,'   ' comune_dom,
       '   ' provincia_doc,'   ' comune_doc,
       '    ' gruppo_ling,
       stato_civile,
       '    ' titolo_studio,
       'STATI_CIVILI' tabella
from anagrafici
where stato_civile not in
  (select codice from stati_civili)
  and stato_civile is not null
  and exists (select 'x' from rapporti_individuali where ni = anagrafici.ni)
union
select ni,to_char(dal,'dd/mm/yyyy') dal,
       '    ' categoria_protetta,
       '   ' provincia_nas,'   ' comune_nas,
       '   ' provincia_res,'   ' comune_res,
       '   ' provincia_dom,'   ' comune_dom,
       '   ' provincia_doc,'   ' comune_doc,
       '    ' gruppo_ling,
       '    ' stato_civile,
       titolo_studio,
       'TITOLI_STUDIO' tabella
from anagrafici
where titolo_studio not in
  (select codice from titoli_studio)
  and titolo_studio is not null
  and exists (select 'x' from rapporti_individuali where ni = anagrafici.ni)
union
select ni,to_char(dal,'dd/mm/yyyy') dal,
       categoria_protetta,
       '   ' provincia_nas,'   ' comune_nas,
       '   ' provincia_res,'   ' comune_res,
       '   ' provincia_dom,'   ' comune_dom,
       '   ' provincia_doc,'   ' comune_doc,
       '    ' gruppo_ling,
       '    ' stato_civile,
       '    ' titolo_studio,
       'CATEGORIE_PROTETTE' tabella
from anagrafici
where categoria_protetta not in
  (select codice from categorie_protette)
  and categoria_protetta is not null
  and exists (select 'x' from rapporti_individuali where ni = anagrafici.ni)
union
select ni,to_char(dal,'dd/mm/yyyy') dal,
       '    ' categoria_protetta,
       '   ' provincia_nas,'   ' comune_nas,
       '   ' provincia_res,'   ' comune_res,
       '   ' provincia_dom,'   ' comune_dom,
       '   ' provincia_doc,'   ' comune_doc,
       gruppo_ling,
       '    ' stato_civile,
       '    ' titolo_studio,
       'GRUPPI_LINGUISTICI' tabella
from anagrafici
where gruppo_ling not in
  (select gruppo from gruppi_linguistici)
  and gruppo_ling is not null
  and exists (select 'x' from rapporti_individuali where ni = anagrafici.ni)
order by 15,3,4,5,6,7,8,9,10,11,12,13,14,1,2
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
		       	, rpad(nvl(to_char(cur_riga.ni),' '),8)||' '||rpad(nvl(cur_riga.dal,' '),10)||' '||rpad(nvl(cur_riga.categoria_protetta,' '),7)||' '
				||rpad(nvl(cur_riga.provincia_nas,' '),6)||' '||rpad(nvl(cur_riga.comune_nas,' '),7)||' '||rpad(nvl(cur_riga.provincia_res,' '),6)||' '
				||rpad(nvl(cur_riga.comune_res,' '),7)||' '||rpad(nvl(cur_riga.provincia_dom,' '),6)||' '||rpad(nvl(cur_riga.comune_dom,' '),7)||' '
				||rpad(nvl(cur_riga.provincia_doc,' '),6)||' '||rpad(nvl(cur_riga.comune_doc,' '),7)||' '||rpad(nvl(cur_riga.stato_civile,' '),6)||' '
				||rpad(nvl(cur_riga.titolo_studio,' '),7)||' '||' '||rpad(nvl(cur_riga.gruppo_ling,' '),5)||' '||cur_riga.tabella
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
END p_anag;
/

