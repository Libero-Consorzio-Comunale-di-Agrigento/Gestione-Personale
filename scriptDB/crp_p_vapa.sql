CREATE OR REPLACE PACKAGE p_vapa IS

/******************************************************************************
 NOME:          CRP_P_VAPA
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

CREATE OR REPLACE PACKAGE BODY p_vapa IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE VALORI PRESENZA',(132-length('VERIFICA INTEGRITA` REFERENZIALE VALORI PRESENZA'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE VALORI PRESENZA')))
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
	           	, 'Voce     Sub Data agg.  Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- --- ---------- -------------------------------'
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
	for cur_riga in (select  vapa.voce                              voce       
       ,vapa.sub                               sub
       ,substr(to_char(vapa.data_agg,'dd/mm/yyyy'),1,10)
                                               data_agg
       ,'EVENTI_PRESENZA'                      tabella
  from  valori_presenza vapa
 where  not exists
       (select 1 
          from eventi_presenza evpa
         where evpa.evento = vapa.evento
       )
union
select  vapa.voce                              voce       
       ,vapa.sub                               sub
       ,substr(to_char(vapa.data_agg,'dd/mm/yyyy'),1,10)
                                               data_agg
       ,'VOCI CONTABILI'                       tabella
  from  valori_presenza vapa
 where  not exists
       (select 1 
          from voci_contabili voco
         where voco.voce   = vapa.voce
           and voco.sub    = vapa.sub
       )
 order by 3,1,2

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
		       	, rpad(nvl(cur_riga.voce,' '),8)||' '||
				  rpad(nvl(cur_riga.sub,' '),3)||' '||
				  rpad(nvl(cur_riga.data_agg,' '),3)||' '||
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
END p_vapa;
/

