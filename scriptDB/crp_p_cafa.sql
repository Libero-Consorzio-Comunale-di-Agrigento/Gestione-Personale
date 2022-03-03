CREATE OR REPLACE PACKAGE p_cafa IS

/******************************************************************************
 NOME:          crp_p_cafa
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

CREATE OR REPLACE PACKAGE BODY p_cafa IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE CARICHI_FAMILIARI',(132-length('VERIFICA INTEGRITA` REFERENZIALE CARICHI_FAMILIARI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE CARICHI_FAMILIARI')))
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
	           	, 'Cod.Ind. Anno M. S. Cond.Fam. Cond.Fis. Mese Att. Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ----- -- -- --------- --------- --------- --------------------'
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
	for cur_riga in (select ci, anno, mese, sequenza, null cond_fam, null cond_fis, null mese_att,
       'MESI' tabella
from carichi_familiari cafa
where not exists
  (select 1 from mesi mese
    where mese.anno = cafa.anno
      and mese.mese = cafa.mese)
union
select ci, anno, mese, sequenza, null cond_fam,
       null cond_fis, to_char(mese_att),
       'MESI' tabella
from carichi_familiari cafa
where not exists
  (select 1 from mesi mese
    where mese.anno = cafa.anno
      and mese.mese = cafa.mese_att)
union
select ci, anno, mese, sequenza, cond_fam, null cond_fis,
        null mese_att,'CONDIZIONI_FAMILIARI' tabella
from carichi_familiari cafa
where cafa.cond_fam is not null
  and not exists
  (select 1 from condizioni_familiari cofa
    where cofa.codice = cafa.cond_fam)
union
select ci, anno, mese, sequenza, null cond_fam, cond_fis,
        null mese_att,'CONDIZIONI_FISCALI' tabella
from carichi_familiari cafa
where cafa.cond_fis is not null
  and not exists
  (select 1 from condizioni_fiscali cofi
    where cofi.codice = cafa.cond_fis)
union
select ci, anno, mese, sequenza, null cond_fam, null cond_fis,
        null mese_att,'RAPPORTI_RETRIBUTIVI' tabella
from carichi_familiari cafa
where not exists
  (select 1 from rapporti_retributivi rare
    where rare.ci = cafa.ci)
order by 8,5,6,7,1,2,3,4


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
				  rpad(nvl(to_char(cur_riga.anno),' '),4)||' '||
				  rpad(nvl(to_char(cur_riga.mese),' '),2)||' '||
				  rpad(nvl(to_char(cur_riga.sequenza),' '),2)||' '||
				  rpad(nvl(cur_riga.cond_fam,' '),9)||' '||
				  rpad(nvl(cur_riga.cond_fis,' '),9)||' '||
				  rpad(nvl(cur_riga.mese_att,' '),9)||' '||
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
END p_cafa;
/

