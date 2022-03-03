CREATE OR REPLACE PACKAGE p_rivo IS

/******************************************************************************
 NOME:          crp_p_rivo
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

CREATE OR REPLACE PACKAGE BODY p_rivo IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE RITENUTE_VOCE',(132-length('VERIFICA INTEGRITA` REFERENZIALE RITENUTE_VOCE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE RITENUTE_VOCE')))
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
	           	, 'Voce       Sub  Dal        Voce Ipn.  Sub Ipn.   Voce Rid.  Sub Rid.   Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ---- ---------- ---------- ---------- ---------- ---------- ---------------------'
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
	for cur_riga in (select voce, sub, to_char(dal,'dd/mm/yyyy') dal, null cod_voce_ipn,
       null sub_voce_ipn, null cod_voce_rid, null sub_voce_rid,
       'VOCI_ECONOMICHE' tabella
from ritenute_voce rivo
where not exists
  (select 1 from voci_economiche voec
    where voec.codice = rivo.voce)
union
select voce, sub, to_char(dal,'dd/mm/yyyy') dal, null cod_voce_ipn,
       null sub_voce_ipn, null cod_voce_rid, null sub_voce_rid,
       'VOCI_CONTABILI' tabella
from ritenute_voce rivo
where not exists
  (select 1 from voci_contabili voco
    where voco.voce = rivo.voce
      and voco.sub  = rivo.sub)
union
select voce, sub, to_char(dal,'dd/mm/yyyy') dal, cod_voce_ipn,
       null sub_voce_ipn, null cod_voce_rid, null sub_voce_rid,
       'VOCI_ECONOMICHE' tabella
from ritenute_voce rivo
where not exists
  (select 1 from voci_economiche voec
    where voec.codice = rivo.cod_voce_ipn)
union
select voce, sub, to_char(dal,'dd/mm/yyyy') dal, cod_voce_ipn,
       sub_voce_ipn, null cod_voce_rid, null sub_voce_rid,
       'VOCI_CONTABILI' tabella
from ritenute_voce rivo
where not exists
  (select 1 from voci_contabili voco
    where voco.voce = rivo.cod_voce_ipn
      and voco.sub  = rivo.sub_voce_ipn)
union
select voce, sub, to_char(dal,'dd/mm/yyyy') dal, null cod_voce_ipn,
       null sub_voce_ipn, cod_voce_rid, null sub_voce_rid,
       'VOCI_ECONOMICHE' tabella
from ritenute_voce rivo
where cod_voce_rid is not null
  and not exists
  (select 1 from voci_economiche voec
    where voec.codice = rivo.cod_voce_rid)
union
select voce, sub, to_char(dal,'dd/mm/yyyy') dal, null cod_voce_ipn,
       null sub_voce_ipn, cod_voce_rid, sub_voce_rid,
       'VOCI_CONTABILI' tabella
from ritenute_voce rivo
where cod_voce_rid||sub_voce_rid is not null
  and not exists
  (select 1 from voci_contabili voco
    where voco.voce = rivo.cod_voce_rid
      and voco.sub  = rivo.sub_voce_rid)
union
select voce, sub, to_char(dal,'dd/mm/yyyy') dal, null cod_voce_ipn,
       null sub_voce_ipn, cod_voce_rid, sub_voce_rid,
       'STORICITA' tabella
from ritenute_voce rivo
where exists
  (select 1 from ritenute_voce
    where voce = rivo.voce
      and sub = rivo.sub
      and rowid != rivo.rowid
      and nvl(dal,to_date('2222222','j')) <=
          nvl(rivo.al,to_date('3333333','j'))
      and nvl(al,to_date('3333333','j')) >=
          nvl(rivo.dal,to_date('2222222','j'))
  )
order by 8,4,5,6,7,1,2,3

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
				  rpad(nvl(cur_riga.cod_voce_ipn,' '),10)||' '||
				  rpad(nvl(cur_riga.sub_voce_ipn,' '),10)||' '||
				  rpad(nvl(cur_riga.cod_voce_rid,' '),10)||' '||
				  rpad(nvl(cur_riga.sub_voce_rid,' '),10)||' '||
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
END p_rivo;
/

