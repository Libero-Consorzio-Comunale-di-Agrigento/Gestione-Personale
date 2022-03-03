CREATE OR REPLACE PACKAGE p_trip IS

/******************************************************************************
 NOME:          CRP_P_TRIP
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

CREATE OR REPLACE PACKAGE BODY p_trip IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE TETTI RETRIBUTIVI INCENTIVO',(132-length('VERIFICA INTEGRITA` REFERENZIALE TETTI RETRIBUTIVI INCENTIVO'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE TETTI RETRIBUTIVI INCENTIVO')))
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
	           	, 'Cod.Ind. Dal        Ril. Decorrenza Qualif.  Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ---------- ---- ---------- -------- -------------------------------'
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
	for cur_riga in (select  trip.ci                                ci
       ,substr(to_char(trip.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,trip.rilevanza                         rilevanza
       ,substr(to_char(trip.dal,'dd/mm/yyyy'),1,10)
                                               decorrenza
       ,to_number(null)                        qualifica
       ,'PERIODI GIURIDICI'                    tabella
  from  tetti_retributivi_incentivo trip
 where  not exists
       (select 1 
          from periodi_giuridici pegi
         where pegi.ci           = trip.ci
           and pegi.rilevanza    = trip.rilevanza
           and pegi.dal          = trip.decorrenza
       )
union
select  trip.ci                                ci
       ,substr(to_char(trip.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,trip.rilevanza                         rilevanza
       ,substr(to_char(trip.dal,'dd/mm/yyyy'),1,10)
                                               decorrenza
       ,to_number(null)                        qualifica
       ,'RAPPORTI GIURIDICI'                   tabella
  from  tetti_retributivi_incentivo trip
 where  not exists
       (select 1 
          from rapporti_giuridici ragi
         where ragi.ci           = trip.ci
       )
union
select  trip.ci                                ci
       ,substr(to_char(trip.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,trip.rilevanza                         rilevanza
       ,substr(to_char(trip.dal,'dd/mm/yyyy'),1,10)
                                               decorrenza
       ,trip.qualifica                         qualifica
       ,'QUALIFICHE'                           tabella
  from  tetti_retributivi_incentivo trip
 where  not exists
       (select 1 
          from qualifiche qual
         where qual.numero       = trip.qualifica
       )
 order by 6,1,2,3

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
		       	, rpad(nvl(to_char(cur_riga.ci),' '),8)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  rpad(nvl(cur_riga.rilevanza,' '),4)||' '||
				  rpad(nvl(cur_riga.decorrenza,' '),10)||' '||
				  rpad(nvl(to_char(cur_riga.qualifica),' '),8)||' '||
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
END p_trip;
/

