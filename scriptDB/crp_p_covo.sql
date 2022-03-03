CREATE OR REPLACE PACKAGE p_covo IS

/******************************************************************************
 NOME:          CRP_P_COVO.SQL
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

CREATE OR REPLACE PACKAGE BODY p_covo IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE CONTABILITA_VOCE',(132-length('VERIFICA INTEGRITA` REFERENZIALE CONTABILITA_VOCE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE CONTABILITA_VOCE')))
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
	           	, 'Voce       Sub  Dal        Bilancio Cl.Budget Sede Anno Numero Istituto Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ---- ---------- -------- --------- ---- ---- ------ -------- --------------------'
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
	for cur_riga in (select voce, sub, to_char(dal,'dd/mm/yyyy') dal, null budget, null bilancio,
       null sede_del, null anno_del,
       null numero_del, null istituto,
       'VOCI_ECONOMICHE' tabella
from   contabilita_voce covo
where  not exists
  (select 1 from voci_economiche voec
    where voec.codice = covo.voce)
union
select voce, sub, to_char(dal,'dd/mm/yyyy') dal, null budget, null bilancio,
       null sede_del, null anno_del,
       null numero_del, null istituto,
       'VOCI_CONTABILI' tabella
from contabilita_voce covo
where not exists
  (select 1 from voci_contabili voco
    where voco.voce = covo.voce
      and voco.sub  = covo.sub)
union
select voce, sub, to_char(dal,'dd/mm/yyyy') dal, null budget, bilancio ,
       null sede_del, null anno_del,
       null numero_del, null istituto,
       'CODICI_BILANCIO' tabella
from contabilita_voce covo
where bilancio is not null
  and not exists
  (select 1 from codici_bilancio cobi
    where cobi.codice = covo.bilancio)
union
select voce, sub, to_char(dal,'dd/mm/yyyy') dal, budget, null bilancio,
       null sede_del, null anno_del,
       null numero_del, null istituto,
       'CLASSI_BUDGET' tabella
from contabilita_voce covo
where budget is not null
  and not exists
  (select 1 from classi_budget clbu
    where clbu.codice = covo.budget)
union
select voce, sub, to_char(dal,'dd/mm/yyyy') dal, null budget, null bilancio,
       sede_del, to_char(anno_del),
       to_char(numero_del), null istituto,
       'DELIBERE' tabella
from contabilita_voce covo
where sede_del||to_char(anno_del)||to_char(numero_del) is not null
  and not exists
  (select 1 from delibere deli
    where deli.sede = covo.sede_del
      and deli.anno = covo.anno_del
      and deli.numero = covo.numero_del)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select voce, sub, to_char(dal,'dd/mm/yyyy') dal, null budget, null bilancio,
       null sede_del, null anno_del,
       null numero_del, istituto,
       'ISTITUTI_CREDITO' tabella
from contabilita_voce covo
where istituto is not null
  and not exists
  (select 1 from istituti_credito iscr
    where iscr.codice = covo.istituto)
order by 10,4,5,6,7,8,9,1,2,3

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
		       	, rpad(nvl(cur_riga.voce,' '),10)||' '||
				  rpad(nvl(cur_riga.sub,' '),4)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
  				  rpad(nvl(cur_riga.bilancio,' '),8)||' '||
				  rpad(nvl(cur_riga.budget,' '),9)||' '||
				  rpad(nvl(cur_riga.sede_del,' '),4)||' '||
				  rpad(nvl(cur_riga.anno_del,' '),4)||' '||
				  rpad(nvl(cur_riga.numero_del,' '),6)||' '||
				  rpad(nvl(cur_riga.istituto,' '),8)||' '||
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
END p_covo;
/

