CREATE OR REPLACE PACKAGE p_aeip IS

/******************************************************************************
 NOME:          CRP_P_AEIP
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

CREATE OR REPLACE PACKAGE BODY p_aeip IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE ATTRIBUZIONE EQUIPE INCENTIVO',(132-length('VERIFICA INTEGRITA` REFERENZIALE ATTRIBUZIONE EQUIPE INCENTIVO'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE ATTRIBUZIONE EQUIPE INCENTIVO')))
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
	           	, 'Gruppo Sett.  Sede   Dal        Equipe Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '------ ------ ------ ---------- ------ -------------------------------'
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
	for cur_riga in (select  aeip.gruppo                            gruppo
       ,aeip.settore                           settore
       ,aeip.sede                              sede
       ,substr(to_char(aeip.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,null                                   equipe
       ,'GRUPPI INCENTIVO'                     tabella
  from  attribuzione_equipe_incentivo aeip
 where  not exists
       (select 1 
          from gruppi_incentivo grip
         where grip.codice = aeip.gruppo
       )
union
select  aeip.gruppo                            gruppo
       ,aeip.settore                           settore
       ,aeip.sede                              sede
       ,substr(to_char(aeip.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,null                                   equipe
       ,'RIPARTIZIONI FUNZIONALI'              tabella
  from  attribuzione_equipe_incentivo aeip
 where  not exists
       (select 1
          from ripartizioni_funzionali rifu
         where rifu.settore    = aeip.settore
           and rifu.sede       = nvl(aeip.sede,0)
       )
   and  aeip.settore          != 0
   and  aeip.equipe           != 0
union
select  aeip.gruppo                            gruppo
       ,aeip.settore                           settore
       ,aeip.sede                              sede
       ,substr(to_char(aeip.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,aeip.equipe                            equipe
       ,'EQUIPE'                               tabella
  from  attribuzione_equipe_incentivo aeip
 where  not exists
       (select 1
          from equipe eqip
         where eqip.codice = aeip.equipe
       )
   and  aeip.settore          != 0
   and  aeip.equipe           != 0
 order by 6,1,2,3,4

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
		       	, rpad(nvl(cur_riga.gruppo,' '),6)||' '||
				  rpad(nvl(to_char(cur_riga.settore),' '),6)||' '||
				  rpad(nvl(to_char(cur_riga.sede),' '),6)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  rpad(nvl(cur_riga.equipe,' '),6)||' '||
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
END p_aeip;
/

