CREATE OR REPLACE PACKAGE p_cagi IS

/******************************************************************************
 NOME:          CRP_P_CAGI	
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

CREATE OR REPLACE PACKAGE BODY p_cagi IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE CAUSALI GIUSTIFICATIVO',(132-length('VERIFICA INTEGRITA` REFERENZIALE CAUSALI GIUSTIFICATIVO'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE CAUSALI GIUSTIFICATIVO')))
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
	           	, 'Giustic. Da/A Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ---- -------------------------------'
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
	for cur_riga in (select  cagi.codice                            giustificativo
       ,cagi.da_a                              da_a
       ,'GIUSTIFICATIVI'                       tabella
  from  causali_giustificativo cagi
 where  not exists
       (select 1 
          from giustificativi gius
         where gius.codice = cagi.codice
       )
union
select  cagi.codice                            giustificativo
       ,cagi.da_a                              da_a
       ,'CAUSALI_EVENTO'                       tabella
  from  causali_giustificativo cagi
 where  not exists
       (select 1 
          from causali_evento caev
         where caev.codice = cagi.causale
       )
union
select  cagi.codice                            giustificativo
       ,cagi.da_a                              da_a
       ,'MOTIVI_EVENTO'                        tabella
  from  causali_giustificativo cagi
 where  not exists
       (select 1 
          from motivi_evento moev 
         where moev.codice = cagi.motivo
       )
   and  cagi.motivo       != '%'
 order by 1

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
		       	, rpad(nvl(cur_riga.giustificativo,' '),8)||' '||
				  rpad(nvl(cur_riga.da_a,' '),4)||' '||
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
END p_cagi;
/

