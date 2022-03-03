CREATE OR REPLACE PACKAGE p_aqip IS

/******************************************************************************
 NOME:          CRP_P_AQIP
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

CREATE OR REPLACE PACKAGE BODY p_aqip IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE ATTRIBUZIONE QUOTE INCENTIVO',(132-length('VERIFICA INTEGRITA` REFERENZIALE ATTRIBUZIONE QUOTE INCENTIVO'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE ATTRIBUZIONE QUOTE INCENTIVO')))
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
	           	, 'Progetto Dal        Equipe Gruppo Cl.Rapp. Ruolo Liv. Contr. Qualif.  TR Mm Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ---------- ------ ------ -------- ----- ---- ------ -------- -- -- -------------------------------'
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
	for cur_riga in (select  aqip.progetto                          progetto
       ,substr(to_char(aqip.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,aqip.equipe                            equipe
       ,gruppo                                 gruppo
       ,rapporto                               rapporto
       ,ruolo                                  ruolo
       ,livello                                livello
       ,contratto                              contratto
       ,qualifica                              qualifica
       ,tipo_rapporto                          tipo_rapporto
       ,mesi                                   mesi
       ,'PROGETTI INCENTIVO'                   tabella
  from  attribuzione_quote_incentivo aqip
 where  not exists
       (select 1 
          from progetti_incentivo prip
         where prip.progetto = aqip.progetto
       )
union
select  aqip.progetto                          progetto
       ,substr(to_char(aqip.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,aqip.equipe                            equipe
       ,gruppo                                 gruppo
       ,rapporto                               rapporto
       ,ruolo                                  ruolo
       ,livello                                livello
       ,contratto                              contratto
       ,qualifica                              qualifica
       ,tipo_rapporto                          tipo_rapporto
       ,mesi                                   mesi
       ,'EQUIPE'                               tabella
  from  attribuzione_quote_incentivo aqip
 where  not exists
       (select 1 
          from equipe eqip
         where eqip.codice like aqip.equipe
       )
union
select  aqip.progetto                          progetto
       ,substr(to_char(aqip.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,aqip.equipe                            equipe
       ,gruppo                                 gruppo
       ,rapporto                               rapporto
       ,ruolo                                  ruolo
       ,livello                                livello
       ,contratto                              contratto
       ,qualifica                              qualifica
       ,tipo_rapporto                          tipo_rapporto
       ,mesi                                   mesi
       ,'GRUPPI INCENTIVO'                     tabella
  from  attribuzione_quote_incentivo aqip
 where  not exists
       (select 1 
          from gruppi_incentivo grip
         where grip.codice like aqip.gruppo
       )
union
select  aqip.progetto                          progetto
       ,substr(to_char(aqip.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,aqip.equipe                            equipe
       ,gruppo                                 gruppo
       ,rapporto                               rapporto
       ,ruolo                                  ruolo
       ,livello                                livello
       ,contratto                              contratto
       ,qualifica                              qualifica
       ,tipo_rapporto                          tipo_rapporto
       ,mesi                                   mesi
       ,'CLASSI RAPPORTO'                      tabella
  from  attribuzione_quote_incentivo aqip
 where  not exists
       (select 1 
          from classi_rapporto clra
         where clra.codice like aqip.rapporto
       )
union
select  aqip.progetto                          progetto
       ,substr(to_char(aqip.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,aqip.equipe                            equipe
       ,gruppo                                 gruppo
       ,rapporto                               rapporto
       ,ruolo                                  ruolo
       ,livello                                livello
       ,contratto                              contratto
       ,qualifica                              qualifica
       ,tipo_rapporto                          tipo_rapporto
       ,mesi                                   mesi
       ,'CONTRATTI'                            tabella
  from  attribuzione_quote_incentivo aqip
 where  not exists
       (select 1 
          from contratti cont
         where cont.codice like aqip.contratto
       )
union
select  aqip.progetto                          progetto
       ,substr(to_char(aqip.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,aqip.equipe                            equipe
       ,gruppo                                 gruppo
       ,rapporto                               rapporto
       ,ruolo                                  ruolo
       ,livello                                livello
       ,contratto                              contratto
       ,qualifica                              qualifica
       ,tipo_rapporto                          tipo_rapporto
       ,mesi                                   mesi
       ,'QUALIFICHE GIURIDICHE'                tabella
  from  attribuzione_quote_incentivo aqip
 where  not exists
       (select 1 
          from qualifiche_giuridiche qugi
         where qugi.codice like aqip.qualifica
       )
 order by 12,1,2,3,4,5,6,7,8,9,10,11

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
		       	, rpad(nvl(cur_riga.progetto,' '),8)||' '||
				  rpad(nvl(cur_riga.dal,' '),10)||' '||
				  rpad(nvl(cur_riga.equipe,' '),6)||' '||
				  rpad(nvl(cur_riga.gruppo,' '),6)||' '||
				  rpad(nvl(cur_riga.rapporto,' '),8)||' '||
				  rpad(nvl(cur_riga.ruolo,' '),5)||' '||
				  rpad(nvl(cur_riga.livello,' '),4)||' '||
				  rpad(nvl(cur_riga.contratto,' '),6)||' '||
				  rpad(nvl(cur_riga.qualifica,' '),8)||' '||
				  rpad(nvl(cur_riga.tipo_rapporto,' '),2)||' '||
				  rpad(nvl(to_char(cur_riga.mesi),' '),2)||' '||
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
END p_aqip;
/

