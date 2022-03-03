CREATE OR REPLACE PACKAGE p_vbvp IS
/******************************************************************************
 NOME:          CRP_P_VBVP
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

CREATE OR REPLACE PACKAGE BODY p_vbvp IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE VALORI_BASE_VOCE_BP',(132-length('VERIFICA INTEGRITA` REFERENZIALE VALORI_BASE_VOCE_BP'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE VALORI_BASE_VOCE_BP')))
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
	           	, 'Voce       Contratto  Dal        Gestione   Qualifica  Ruolo      Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ---------- ---------- ---------- ---------- ---------- ----------------------'
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
	for cur_riga in (select voce, contratto, to_char(dal,'dd/mm/yyyy') dal,
       null gestione, null qualifica, null ruolo,
       'BASI_VOCE_BP' tabella
from valori_base_voce_bp vbvp
where not exists
  (select 1 from basi_voce_bp bavp
    where bavp.voce = vbvp.voce
      and bavp.contratto = vbvp.contratto
      and bavp.dal = vbvp.dal)
union
select voce, null contratto, null dal,
       gestione, null qualifica, null ruolo,
       'GESTIONI' tabella
from valori_base_voce_bp vbvp
where not exists
  (select 1 from gestioni gest
    where gest.codice like vbvp.gestione)
union
select voce, null contratto, null dal,
       null gestione, qualifica, null ruolo,
       'QUALIFICHE_GIURIDICHE' tabella
from valori_base_voce_bp vbvp
where not exists
  (select 1 from qualifiche_giuridiche qugi
    where qugi.codice like vbvp.qualifica)
  and vbvp.qualifica is not null
union
select voce, null contratto, null dal,
       null gestione, null qualifica, ruolo,
       'RUOLI' tabella
from valori_base_voce_bp vbvp
where not exists
  (select 1 from ruoli ruol
    where ruol.codice like vbvp.ruolo)
union
select voce, contratto, null dal,
       null gestione, null qualifica, null ruolo,
       'CONTRATTI' tabella
from valori_base_voce_bp vbvp
where not exists
  (select 1 from contratti cont
    where cont.codice = vbvp.contratto)
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
		       	, rpad(nvl(cur_riga.voce,' '),10)||' '||
				  rpad(nvl(cur_riga.contratto,' '),10)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  rpad(nvl(cur_riga.gestione,' '),10)||' '||
				  rpad(nvl(cur_riga.qualifica,' '),10)||' '||
				  rpad(nvl(cur_riga.ruolo,' '),10)||' '||
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
END p_vbvp;
/

