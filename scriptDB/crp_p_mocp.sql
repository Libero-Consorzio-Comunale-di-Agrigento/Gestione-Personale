CREATE OR REPLACE PACKAGE p_mocp IS

/******************************************************************************
 NOME:          crp_p_mocp
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

CREATE OR REPLACE PACKAGE BODY p_mocp IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE MOVIMENTI_CONTABILI_PREVISIONE',(132-length('VERIFICA INTEGRITA` REFERENZIALE MOVIMENTI_CONTABILI_PREVISIONE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE MOVIMENTI_CONTABILI_PREVISIONE')))
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
	           	, 'Cod.Ind. Anno Me Mensilita Budget   Bilancio Sede Del. Anno Del.  Numero Del. Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ---- -- --------- -------- --------- --------- --------- ----------- ----------------------'
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
	for cur_riga in (select ci, anno, mese, mensilita, null budget, null bilancio,
       null sede_del, null anno_del, null numero_del,
       'RAPPORTI_RETRIBUTIVI' tabella
from movimenti_contabili_previsione mocp
where not exists
  (select 1 from rapporti_retributivi rare
    where rare.ci = mocp.ci )
union
select ci, anno, mese, mensilita, null budget, null bilancio,
       null sede_del, null anno_del, null numero_del,
       'MESI' tabella
from movimenti_contabili_previsione mocp
where not exists
  (select 1 from mesi mese
    where mese.anno = mocp.anno
      and mese.mese = mocp.mese)
union
select ci, anno, mese, mensilita, null budget, null bilancio,
       null sede_del, null anno_del, null numero_del,
       'MENSILITA' tabella
from movimenti_contabili_previsione mocp
where not exists
  (select 1 from mensilita mens
    where mens.mese = mocp.mese
      and mens.mensilita = mocp.mensilita)
union
select ci, anno, mese, mensilita, null budget, bilancio,
       null sede_del, null anno_del, null numero_del,
       'CODICI_BILANCIO' tabella
from movimenti_contabili_previsione mocp
where not exists
  (select 1 from codici_bilancio cobi
    where cobi.codice = mocp.bilancio)
union
select ci, anno, mese, mensilita, budget, null bilancio,
       null sede_del, null anno_del, null numero_del,
       'CLASSI_BUDGET' tabella
from movimenti_contabili_previsione mocp
where not exists
  (select 1 from classi_budget clbu
    where clbu.codice = mocp.budget)
union
select ci, anno, mese, mensilita, null budget, null bilancio,
       sede_del, to_char(anno_del), to_char(numero_del),
       'DELIBERE' tabella
from movimenti_contabili_previsione mocp
where sede_del||anno_del||numero_del is not null
  and not exists
  (select 1 from delibere deli
    where deli.sede = mocp.sede_del
      and deli.anno = mocp.anno_del
      and deli.numero = mocp.numero_del)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
order by 10,5,6,7,8,9,1,2,3,4
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
				  rpad(nvl(cur_riga.mensilita,' '),9)||' '||
				  rpad(nvl(cur_riga.budget,' '),8)||' '||
				  rpad(nvl(cur_riga.bilancio,' '),8)||' '||
				  rpad(nvl(cur_riga.sede_del,' '),9)||' '||
				  rpad(nvl(cur_riga.anno_del,' '),9)||' '||
				  rpad(nvl(cur_riga.numero_del,' '),11)||' '||
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
END p_mocp;
/

