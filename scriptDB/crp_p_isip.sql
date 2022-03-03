CREATE OR REPLACE PACKAGE p_isip IS

/******************************************************************************
 NOME:          CRP_P_ISIP
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

CREATE OR REPLACE PACKAGE BODY p_isip IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE IPOTESI SPESA INCENTIVO',(132-length('VERIFICA INTEGRITA` REFERENZIALE IPOTESI SPESA INCENTIVO'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE IPOTESI SPESA INCENTIVO')))
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
	           	, 'Ver. Cod.Ind. Progetto Dal        Equipe Ruolo Sede   Settore  Gr. Qualif.  Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---- -------- -------- ---------- ------ ----- ------ -------- -- -------- -------------------------------'
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
	for cur_riga in (select  isip.versione                       versione
       ,isip.ci                             ci
       ,isip.progetto                       progetto
       ,substr(to_char(isip.dal,'dd/mm/yyyy'),1,10)
                                            dal
       ,null                                equipe
       ,null                                ruolo
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,null                                gruppo
       ,to_number(null)                     qualifica
       ,'VERSIONI IPOTESI SPESA'            tabella
  from  ipotesi_spesa_incentivo             isip
 where  not exists
       (select 1
          from versioni_ipotesi_incentivo veip
         where veip.codice = isip.versione
       )
union
select  isip.versione                       versione
       ,isip.ci                             ci
       ,isip.progetto                       progetto
       ,substr(to_char(isip.dal,'dd/mm/yyyy'),1,10)
                                            dal
       ,null                                equipe
       ,isip.ruolo                          ruolo
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,null                                gruppo
       ,to_number(null)                     qualifica
       ,'RUOLI'                             tabella
  from  ipotesi_spesa_incentivo             isip
 where  not exists
       (select 1
          from ruoli ruol
         where ruol.codice = isip.ruolo
       )
union
select  isip.versione                       versione
       ,isip.ci                             ci
       ,isip.progetto                       progetto
       ,substr(to_char(isip.dal,'dd/mm/yyyy'),1,10)
                                            dal
       ,null                                equipe
       ,null                                ruolo
       ,to_number(null)                     sede
       ,isip.settore                        settore
       ,null                                gruppo
       ,to_number(null)                     qualifica
       ,'SETTORI'                           tabella
  from  ipotesi_spesa_incentivo             isip
 where  not exists
       (select 1
          from settori sett
         where sett.numero = isip.settore
       )
union
select  isip.versione                       versione
       ,isip.ci                             ci
       ,isip.progetto                       progetto
       ,substr(to_char(isip.dal,'dd/mm/yyyy'),1,10)
                                            dal
       ,null                                equipe
       ,null                                ruolo
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,null                                gruppo
       ,to_number(null)                     qualifica
       ,'PROGETTI INCENTIVO'                tabella
  from  ipotesi_spesa_incentivo             isip
 where  not exists
       (select 1
          from progetti_incentivo prip
         where prip.progetto = isip.progetto
       )
union
select  isip.versione                       versione
       ,isip.ci                             ci
       ,isip.progetto                       progetto
       ,substr(to_char(isip.dal,'dd/mm/yyyy'),1,10)
                                            dal
       ,isip.equipe                         equipe
       ,null                                ruolo
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,null                                gruppo
       ,to_number(null)                     qualifica
       ,'EQUIPE IPOTESI INCENTIVO'          tabella
  from  ipotesi_spesa_incentivo             isip
 where  not exists
       (select 1
          from equipe_ipotesi_incentivo eiip
         where eiip.codice = isip.equipe
       )
union
select  isip.versione                       versione
       ,isip.ci                             ci
       ,isip.progetto                       progetto
       ,substr(to_char(isip.dal,'dd/mm/yyyy'),1,10)
                                            dal
       ,null                                equipe
       ,null                                ruolo
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,isip.gruppo                         gruppo
       ,to_number(null)                     qualifica
       ,'GRUPPI INCENTIVO'                  tabella
  from  ipotesi_spesa_incentivo             isip
 where  not exists
       (select 1
          from gruppi_incentivo grip
         where grip.codice = isip.gruppo
       )
union
select  isip.versione                       versione
       ,isip.ci                             ci
       ,isip.progetto                       progetto
       ,substr(to_char(isip.dal,'dd/mm/yyyy'),1,10)
                                            dal
       ,null                                equipe
       ,null                                ruolo
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,null                                gruppo
       ,isip.qualifica                      qualifica
       ,'QUALIFICHE'                        tabella
  from  ipotesi_spesa_incentivo             isip
 where  not exists
       (select 1
          from qualifiche qual
         where qual.numero = isip.qualifica
       )
union
select  isip.versione                       versione
       ,isip.ci                             ci
       ,isip.progetto                       progetto
       ,substr(to_char(isip.dal,'dd/mm/yyyy'),1,10)
                                            dal
       ,null                                equipe
       ,null                                ruolo
       ,isip.sede                           sede
       ,to_number(null)                     settore
       ,null                                gruppo
       ,to_number(null)                     qualifica
       ,'SEDI'                              tabella
  from  ipotesi_spesa_incentivo             isip
 where  not exists
       (select 1
          from sedi
         where sedi.numero = isip.sede
       )
   and  nvl(isip.sede,0)  != 0
union
select  isip.versione                       versione
       ,isip.ci                             ci
       ,isip.progetto                       progetto
       ,substr(to_char(isip.dal,'dd/mm/yyyy'),1,10)
                                            dal
       ,null                                equipe
       ,null                                ruolo
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,null                                gruppo
       ,to_number(null)                     qualifica
       ,'RAPPORTI GIURIDICI'                tabella
  from  ipotesi_spesa_incentivo             isip
 where  not exists
       (select 1
          from rapporti_giuridici ragi
         where ragi.ci = isip.ci
       )
   and  isip.ci        < 99980000

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
		       	, rpad(nvl(cur_riga.versione,' '),4)||' '||
				  rpad(nvl(to_char(cur_riga.ci),' '),8)||' '||
				  rpad(nvl(cur_riga.progetto,' '),8)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  rpad(nvl(cur_riga.equipe,' '),6)||' '||
				  rpad(nvl(cur_riga.ruolo,' '),5)||' '||
				  rpad(nvl(to_char(cur_riga.sede),' '),6)||' '||
				  rpad(nvl(to_char(cur_riga.settore),' '),8)||' '||
				  rpad(nvl(cur_riga.gruppo,' '),2)||' '||
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
END p_isip;
/

