CREATE OR REPLACE PACKAGE p_rtvo IS

/******************************************************************************
 NOME:          crp_p_rtvo
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

CREATE OR REPLACE PACKAGE BODY p_rtvo IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE RIGHE_TARIFFA_VOCE',(132-length('VERIFICA INTEGRITA` REFERENZIALE RIGHE_TARIFFA_VOCE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE RIGHE_TARIFFA_VOCE')))
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
	           	, 'Voce       Dal        Sequenza Cod. Voce  Sub Voce   Voce Cond. Sub Cond.  Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ---------- -------- ---------- ---------- ---------- ---------- ---------------------'
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
	for cur_riga in (select voce, to_char(dal,'dd/mm/yyyy') dal, to_char(sequenza) sequenza,
       null cod_voce, null sub_voce, null con_voce, null con_sub,
       'TARIFFE_VOCE' tabella
from righe_tariffa_voce rtvo
where not exists
  (select 1 from tariffe_voce tavo
    where tavo.voce = rtvo.voce
      and tavo.dal  = rtvo.dal)
union
select voce, to_char(dal,'dd/mm/yyyy') dal, to_char(sequenza) sequenza,
       cod_voce, null sub_voce, null con_voce, null con_sub,
       'VOCI_ECONOMICHE' tabella
from righe_tariffa_voce rtvo
where cod_voce is not null
  and not exists
  (select 1 from voci_economiche voec
    where voec.codice like rtvo.cod_voce)
union
select voce, to_char(dal,'dd/mm/yyyy') dal, to_char(sequenza) sequenza,
       cod_voce, sub_voce, null con_voce, null con_sub,
       'VOCI_CONTABILI' tabella
from righe_tariffa_voce rtvo
where cod_voce||sub_voce is not null
  and not exists
  (select 1 from voci_contabili voco
    where voco.voce like rtvo.cod_voce
       or (    voco.voce = rtvo.cod_voce
           and voco.sub  = rtvo.sub_voce))
union
select voce, to_char(dal,'dd/mm/yyyy') dal, to_char(sequenza) sequenza,
       null cod_voce, null sub_voce, con_voce, null con_sub,
       'VOCI_ECONOMICHE' tabella
from righe_tariffa_voce rtvo
where con_voce is not null
  and not exists
  (select 1 from voci_economiche voec
    where voec.codice like rtvo.con_voce)
union
select voce, to_char(dal,'dd/mm/yyyy') dal, to_char(sequenza) sequenza,
       null cod_voce, null sub_voce, con_voce, con_sub,
       'VOCI_CONTABILI' tabella
from righe_tariffa_voce rtvo
where con_voce||con_sub is not null
  and not exists
  (select 1 from voci_contabili voco
    where voco.voce = rtvo.con_voce
      and voco.sub  = rtvo.con_sub)
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
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  rpad(nvl(cur_riga.sequenza,' '),8)||' '||
				  rpad(nvl(cur_riga.cod_voce,' '),10)||' '||
				  rpad(nvl(cur_riga.sub_voce,' '),10)||' '||
				  rpad(nvl(cur_riga.con_voce,' '),10)||' '||
				  rpad(nvl(cur_riga.con_sub,' '),10)||' '||
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
END p_rtvo;
/

