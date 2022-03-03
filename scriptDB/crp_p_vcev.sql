CREATE OR REPLACE PACKAGE p_vcev IS

/******************************************************************************
 NOME:          CRP_P_VECV
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

CREATE OR REPLACE PACKAGE BODY p_vcev IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;

PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
	p_pagina	number := 1;
	contarighe  number;
procedure insert_intestazione( contarighe in out number, pagina in number) is
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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE VOCI CONTABILI EVENTO',(132-length('VERIFICA INTEGRITA` REFERENZIALE VOCI CONTABILI EVENTO'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE VOCI CONTABILI EVENTO')))
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
	           	, 'Causale  Assist Voce       Sub Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ------ ---------- --- -------------------------------'
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
	for cur_riga in (select  vcev.causale                           causale
       ,vcev.assistenza                        assistenza
       ,vcev.voce                              voce       
       ,vcev.sub                               sub
       ,'CAUSALI_EVENTO'                       tabella
  from  voci_contabili_evento vcev
 where  not exists
       (select 1 
          from causali_evento caev
         where caev.codice = vcev.causale
       )
union
select  vcev.causale                           causale
       ,vcev.assistenza                        assistenza
       ,vcev.voce                              voce       
       ,vcev.sub                               sub
       ,'VOCI CONTABILI'                       tabella
  from  voci_contabili_evento vcev
 where  not exists
       (select 1 
          from voci_contabili voco
         where voco.voce   = vcev.voce
           and voco.sub    = vcev.sub
       )
 order by 1,2,3,4

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
		       	, rpad(nvl(cur_riga.causale,' '),8)||' '||
				  rpad(nvl(cur_riga.assistenza,' '),6)||' '||
				  rpad(nvl(cur_riga.voce,' '),10)||' '||
				  rpad(nvl(cur_riga.sub,' '),3)||' '||
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
END p_vcev;
/

