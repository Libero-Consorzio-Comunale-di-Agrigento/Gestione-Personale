CREATE OR REPLACE PACKAGE p_ctev IS

/******************************************************************************
 NOME:          CRP_P_CTEV
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

CREATE OR REPLACE PACKAGE BODY p_ctev IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE CATEGORIE EVENTO',(132-length('VERIFICA INTEGRITA` REFERENZIALE CATEGORIE EVENTO'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE CATEGORIE EVENTO')))
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
	           	, 'Categor. Descrizione                     Seq Dal        Al          Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '--------- ------------------------------ --- ---------- ---------- -------------------------------'
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
	for cur_riga in (select  ctev.codice                            categoria
       ,ctev.descrizione                       descrizione
       ,ctev.sequenza                          sequenza
       ,substr(to_char(ctev.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(ctev.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'VOCI CONTABILI'                       tabella
  from  categorie_evento ctev
 where  not exists
       (select 1 
          from voci_contabili voco
         where voco.voce   = ctev.voce
           and voco.sub    = ctev.sub
       )
   and  ctev.voce||ctev.sub
                          is not null
union
select  ctev.codice                            categoria
       ,ctev.descrizione                       descrizione
       ,ctev.sequenza                          sequenza
       ,substr(to_char(ctev.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(ctev.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'CLASSI DELIBERA'                      tabella
  from  categorie_evento ctev
 where  not exists
       (select 1 
          from classi_delibera clde
         where clde.codice = ctev.delibera
       )
   and  ctev.delibera     is not null
union
select  ctev.codice                            categoria
       ,ctev.descrizione                       descrizione
       ,ctev.sequenza                          sequenza
       ,substr(to_char(ctev.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(ctev.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'SEDI'                                 tabella
  from  categorie_evento ctev
 where  not exists
       (select 1 
          from sedi sede
         where sede.codice = ctev.sede
       )
   and  ctev.sede         != '%'
union
select  ctev.codice                            categoria
       ,ctev.descrizione                       descrizione
       ,ctev.sequenza                          sequenza
       ,substr(to_char(ctev.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(ctev.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'CENTRI COSTO'                         tabella
  from  categorie_evento ctev
 where  not exists
       (select 1 
          from centri_costo ceco
         where ceco.codice = ctev.cdc
       )
   and  ctev.cdc          != '%'
 order by 3,1,4,5
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
				  rpad(nvl(cur_riga.descrizione,' '),30)||' '||
				  rpad(nvl(to_char(cur_riga.sequenza),' '),3)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  rpad(nvl(cur_riga.al,' '),10)||' '||
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
END p_ctev;
/

