CREATE OR REPLACE PACKAGE p_tovo IS

/******************************************************************************
 NOME:          CRP_P_TOVO   INSERIMENTO VOCI DI TOTALIZZAZIONE 
 DESCRIZIONE:   
      Questa fase ricalcola e inserisce nei movimenti contabili della mensili-
      ta` richiesta la voce di totalizzazione digitata.
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  
      Inserimento della voce di totalizzazione richiesta, per la mensilita`
      richiesta.

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

CREATE OR REPLACE PACKAGE BODY p_tovo IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE TOTALIZZAZIONI_VOCE',(132-length('VERIFICA INTEGRITA` REFERENZIALE TOTALIZZAZIONI_VOCE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE TOTALIZZAZIONI_VOCE')))
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
	           	, 'Voce       Sub  Voce Acc.  (Sub Acc.) Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ---- ---------- ---------- ---------------------'
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
	for cur_riga in (select voce, null sub, null voce_acc, null ast,
       'VOCI_ECONOMICHE' tabella
from totalizzazioni_voce tovo
where not exists
  (select 1 from voci_economiche voec
    where voec.codice = tovo.voce)
union
select voce, sub, null voce_acc, null ast,
       'VOCI_CONTABILI' tabella
from totalizzazioni_voce tovo
where sub is not null
  and not exists
  (select 1 from voci_contabili voco
    where voco.voce = tovo.voce
      and voco.sub  = tovo.sub)
union
select voce, null sub, voce_acc, null ast,
       'VOCI_ECONOMICHE' tabella
from totalizzazioni_voce tovo
where not exists
  (select 1 from voci_economiche voec
    where voec.codice = tovo.voce_acc)
union
select voce, null sub, voce_acc, '(*)' ast,
       'VOCI_CONTABILI' tabella
from totalizzazioni_voce tovo
where not exists
  (select 1 from voci_contabili voco
    where voco.voce = tovo.voce_acc
      and voco.sub  = '*')
order by 5,3,4,1,2

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
				  rpad(nvl(cur_riga.voce_acc,' '),10)||' '||
				  rpad(nvl(cur_riga.ast,' '),10)||' '||
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
END p_tovo;
/

