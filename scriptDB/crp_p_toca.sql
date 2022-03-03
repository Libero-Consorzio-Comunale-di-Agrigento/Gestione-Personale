CREATE OR REPLACE PACKAGE p_toca IS

/******************************************************************************
 NOME:          CRP_P_TOCA
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

CREATE OR REPLACE PACKAGE BODY p_toca IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE TOTALIZZAZIONE CAUSALI',(132-length('VERIFICA INTEGRITA` REFERENZIALE TOTALIZZAZIONE CAUSALI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE TOTALIZZAZIONE CAUSALI')))
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
	           	, 'Categor. Causale  Motivo   Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- -------- -------- -------------------------------'
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
	for cur_riga in (select  toca.categoria                         categoria       
       ,toca.causale                           causale
       ,toca.motivo                            motivo
       ,'CATEGORIE EVENTO'                     tabella
  from  totalizzazione_causali toca
 where  not exists
       (select 1 
          from categorie_evento ctev
         where ctev.codice = toca.categoria
       )
union
select  toca.categoria                         categoria       
       ,toca.causale                           causale
       ,toca.motivo                            motivo
       ,'CAUSALI EVENTO'                       tabella
  from  totalizzazione_causali toca
 where  not exists
       (select 1 
          from causali_evento caev
         where caev.codice = toca.causale
       )
union
select  toca.categoria                         categoria       
       ,toca.causale                           causale
       ,toca.motivo                            motivo
       ,'MOTIVI EVENTO'                        tabella
  from  totalizzazione_causali toca
 where  not exists
       (select 1 
          from motivi_evento moev
         where moev.codice = toca.motivo
       )
   and  toca.motivo       != '%'
 order by 1,2,3


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
		       	, rpad(nvl(cur_riga.categoria,' '),8)||' '||
				  rpad(nvl(cur_riga.causale,' '),8)||' '||
 				  rpad(nvl(cur_riga.motivo,' '),8)||' '||
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
END p_toca;
/

