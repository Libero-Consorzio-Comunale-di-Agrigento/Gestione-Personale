/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE p_pegi IS

/******************************************************************************
 NOME:          crp_p_pegi
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
/*<TOAD_FILE_CHUNK>*/

CREATE OR REPLACE PACKAGE BODY p_pegi IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;

PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
	p_pagina	number := 1;
	contarighe  number;
    d_min       date;
    d_max       date;
    app         varchar2(1);
procedure insert_intestazione(CONTARIGHE IN OUT NUMBER, pagina in number) is
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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE PERIODI_GIURIDICI',(132-length('VERIFICA INTEGRITA` REFERENZIALE PERIODI_GIURIDICI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE PERIODI_GIURIDICI')))
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
	           	, 'Cod.Ind. R Dal      Ev.    Pos. Del Posto       Posto Qual.  Fig.   Att. Sett.  Sede   Ass. Delibera        Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
                , '-------- - -------- ------ ---- --------------- ----- ------ ------ ---- ------ ------ ---- --------------- ---------------'	           
)
			   ;
		commit;
		end;

procedure insert_intestazione_errore(contarighe in out number, pagina in number) is
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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE PERIODI_GIURIDICI',(132-length('VERIFICA INTEGRITA` REFERENZIALE PERIODI_GIURIDICI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE PERIODI_GIURIDICI')))
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
	           	, 'Cod.Ind. Errore'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
                , '-------- --------------------------------------------------------------'	           
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
	for cur_riga in (select ci
				 			, rilevanza
							, dal
                            , al
							, null assenza
							, null attivita
							, null delibera
							, null evento
							, null figura
							, null posizione
							, null del_posto
							,null posto
							, null qualifica
							, null settore
							, null sede
							, 'RAPPORTI_INDIVIDUALI' tabella
					  from periodi_giuridici pegi
					   where not exists
					     (select 1 from rapporti_individuali rain
						     where rain.ci = pegi.ci)
					union
					select 	 ci
						   , rilevanza
						   , dal
                           , al
						   , null assenza
						   , null attivita
						   , null delibera
						   , null evento
						   , null figura
       					   , null posizione
						   , null del_posto
						   , null posto
						   , null qualifica
						   , null settore
						   , null sede
						   , 'RAPPORTI_GIURIDICI' tabella
					  from periodi_giuridici pegi
					   where not exists
					     (select 1 from rapporti_giuridici ragi
						     where ragi.ci = pegi.ci)
					union
					select 	 ci
						   , rilevanza
						   , dal
                           , al
						   , null assenza
						   , null attivita
						   , null delibera
						   , evento
						   , null figura
						   , null posizione
						   , null del_posto
						   , null posto
						   , null qualifica
						   , null settore
						   , null sede
						   , 'EVENTI_GIURIDICI' tabella
					  from periodi_giuridici pegi
					   where rilevanza != 'P'
					      and not exists
						    (select 1 from eventi_giuridici evgi
							    where evgi.codice = pegi.evento)
					union
					select 	 ci
						   , rilevanza
						   , dal
                           , al
						   , null assenza
						   , null attivita
						   , null delibera
						   , evento
						   , null figura
						   , null posizione
						   , null del_posto
						   , null posto
						   , null qualifica
						   , null settore
						   , null sede
						   , 'EVENTI_RAPPORTO' tabella
				  from periodi_giuridici pegi
				   where rilevanza = 'P'
				      and not exists
					    (select 1 from eventi_rapporto evra
						    where evra.codice = pegi.evento
							      and evra.rilevanza = 'I')
				union
				select 	 ci
					   , rilevanza
					   , dal
                       , al
					   , null assenza
					   , null attivita
					   , null delibera
					   , null evento
					   , null figura
					   , posizione
					   , null del_posto
					   , null posto
					   , null qualifica
					   , null settore
					   , null sede
					   , 'POSIZIONI' tabella
				  from periodi_giuridici pegi
				  where posizione is not null
				     and rilevanza != 'P'
					    and not exists
						  (select 1 from posizioni posi
						      where posi.codice = pegi.posizione)
				union
				select 	 ci
					   , rilevanza
					   , dal
                       , al
					   , null assenza
					   , null attivita
					   , null delibera
					   , null evento
					   , null figura
					   , posizione
					   , null del_posto
					   , null posto
					   , null qualifica
					   , null settore
					   , null sede
					   , 'EVENTI_RAPPORTO' tabella
				  from periodi_giuridici pegi
				 where posizione is not null
				    and rilevanza = 'P'
					and not exists
					  (select 1 from eventi_rapporto evra
					    where evra.codice = pegi.posizione
						  and evra.rilevanza = 'T')
			union
			select 	 ci
				   , rilevanza
				   , dal
                   , al
				   , null assenza
				   , null attivita
				   , null delibera
				   , null evento
				   , null figura
				   , null posizione
				   , rpad(sede_posto,2)||'-'||rpad(to_char(numero_posto),7)||'/'||rpad(to_char(anno_posto),4) del_posto
				   , to_char(posto) posto
				   , null qualifica
				   , null settore
				   , null sede
				   , 'POSTI_ORGANICO' tabella
			from periodi_giuridici pegi
			where (sede_posto,anno_posto,numero_posto,posto) not in
			           (select sede,anno,numero,posto from posti_organico)
					   	  and sede_posto||anno_posto||numero_posto is not null
						    and rilevanza != 'P'
			union
			select 	 ci
				   , rilevanza
				   , dal
                   , al
				   , null assenza
				   , null attivita
				   , null delibera
				   , null evento
				   , null figura
				   , null posizione
				   , null del_posto
				   , null posto
				   , to_char(qualifica)
				   , null settore
				   , null sede
				   , 'QUALIFICHE' tabella
			from periodi_giuridici pegi
			where (   qualifica is not null
			       or rilevanza in ('S','E')
				         )
			  and not exists
			    (select 1 from qualifiche qual
				  where qual.numero = nvl(pegi.qualifica,0))
			union
			select 	 ci
				   , rilevanza
				   , dal
                   , al
				   , null assenza
				   , null attivita
				   , null delibera
				   , null evento
				   , null figura
				   , null posizione
				   , null del_posto
				   , null posto
				   , to_char(qualifica)
				   , null settore
				   , null sede
				   , 'QUALIFICHE_GIURIDICHE' tabella
from periodi_giuridici pegi
where (   qualifica is not null
	   or rilevanza in ('S','E')
	  )
  and (   not exists
         (select 1 from qualifiche_giuridiche qugi
           where qugi.numero = nvl(pegi.qualifica,0)
             and pegi.dal
                 between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
         )
       or not exists
         (select 1 from qualifiche_giuridiche qugi
           where qugi.numero = pegi.qualifica
             and nvl(pegi.al,to_date('3333333','j'))
                 between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
         )
      )
	  	 union
	  	 select   ci
		 		, rilevanza
				, dal
                , al
				, null assenza
				, null attivita
				, null delibera
				, null evento
				, to_char(figura)
				, null posizione
				, null del_posto
				, null posto
				, null qualifica
				, null settore
				, null sede
				, 'FIGURE' tabella
				from periodi_giuridici pegi
		where (figura is not null
		       or rilevanza in ('S','E','I','Q')
			  ) 
			    and not exists
				  (select 1 from figure figu
				      where figu.numero = nvl(pegi.figura,0))
		union
		select	 ci
			   , rilevanza
			   , dal
               , al
			   , null assenza
			   , null attivita
			   , null delibera
			   , null evento
			   , to_char(figura)
			   , null posizione
			   , null del_posto
			   , null posto
			   , null qualifica
			   , null settore
			   , null sede
			   , 'FIGURE_GIURIDICHE' tabella
		from periodi_giuridici pegi
		where (figura is not null
		       or rilevanza in ('S','E','I','Q')
			  )
		  and (   not exists
		           (select 1 from figure_giuridiche figi
				           where figi.numero = nvl(pegi.figura,0)
						                and pegi.dal
				               between figi.dal and nvl(figi.al,to_date('3333333','j'))
	         )
       or not exists
         (select 1 from figure_giuridiche figi
           where figi.numero = nvl(pegi.figura,0)
             and nvl(pegi.al,to_date('3333333','j'))
                 between figi.dal and nvl(figi.al,to_date('3333333','j'))
         )
      )
	  	 union
		 select   ci
		 		, rilevanza
				, dal
                , al
       			, null assenza
				, attivita
				, null delibera
				, null evento
				, null figura
				, null posizione
				, null del_posto
				, null posto
				, null qualifica
				, null settore
				, null sede
				, 'ATTIVITA' tabella
		from periodi_giuridici pegi
		where attivita is not null
		  and not exists
		    (select 1 from attivita atti
			    where atti.codice = pegi.attivita)
		union
		select 	 ci
			   , rilevanza
			   , dal
               , al
			   , null assenza
			   , null attivita
			   , null delibera
			   , null evento
			   , null figura
			   , null posizione
			   , null del_posto
			   , null posto
			   , null qualifica
			   , to_char(settore)
			   , null sede
			   , 'SETTORI' tabella
		from periodi_giuridici pegi
		where settore is not null
		  and not exists
		    (select 1 from settori sett
			    where sett.numero = pegi.settore)
		union
		select 	 ci
			   , rilevanza
			   , dal
               , al
			   , null assenza
			   , null attivita
			   , null delibera
			   , null evento
			   , null figura
			   , null posizione, null del_posto ,null posto
			   , null qualifica
			   , to_char(settore), to_char(sede)
			   , 'RIPARTIZIONI_FUNZIONALI' tabella
		from periodi_giuridici pegi
		where ( rilevanza in ('S','E')
		        or settore is not null)
		  and settore is not null
		    and not exists
			  (select 1 from ripartizioni_funzionali rifu
			      where rifu.settore = nvl(pegi.settore,0)
				        and rifu.sede = nvl(pegi.sede,0))
		union
  select ci
       , rilevanza 
       , dal
       , al
       , null assenza
       , null attivita
       , null delibera
       , null evento
       , null figura
       , null posizione, null del_posto, null posto
       , null qualifica
       , null settore, to_char(sede)
       , 'SEDI' tabella
from periodi_giuridici pegi
where sede is not null
  and not exists
  (select 1 from sedi sede
    where sede.numero = pegi.sede)
union
select ci, rilevanza, dal, al
       , assenza
       , null attivita
       , null delibera
       , null evento
       , null figura
       , null posizione, null del_posto, null posto
       , null qualifica
       , null settore, null sede
       , 'ASTENSIONI' tabella
from periodi_giuridici pegi
where assenza is not null
  and not exists
  (select 1 from astensioni aste
    where aste.codice = pegi.assenza
      and aste.evento = pegi.evento)
union
select ci, rilevanza, dal,  al
       , null assenza
       , null attivita
       , rpad(sede_del,2)||'-'||rpad(to_char(numero_del),7)
                         ||'/'||rpad(to_char(anno_del),4) delibera
       , null evento
       , null figura
       , null posizione, null del_posto, null posto
       , null qualifica
       , null settore, null sede
       , 'DELIBERE' tabella
from periodi_giuridici pegi
where sede_del||anno_del||numero_del is not null
  and not exists
  (select 1 from delibere deli
    where deli.sede = pegi.sede_del
      and deli.anno = pegi.anno_del
      and deli.numero = pegi.numero_del)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
order by 15,4,5,6,7,8,9,10,11,12,13,14,1,2,3

       				) loop

        if mod(contarighe,57)= 0 then
			   insert_intestazione(CONTARIGHE,p_pagina);
		end if;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
		       	, contarighe
		       	, rpad(nvl(to_char(cur_riga.ci),' '),8)||' '||
  				  rpad(nvl(cur_riga.rilevanza,' '),1)||' '||
   				  rpad(nvl(to_char(cur_riga.dal,'dd/mm/yy'),' '),8)||' '||
                --  rpad(nvl(to_char(cur_riga.al,'dd/mm/yy'),' '),8)||' '||
				  rpad(nvl(cur_riga.evento,' '),6)||' '||
				  rpad(nvl(cur_riga.posizione,' '),4)||' '||
				  rpad(nvl(cur_riga.del_posto,' '),15)||' '||
				  rpad(nvl(cur_riga.posto,' '),5)||' '||
				  rpad(nvl(cur_riga.qualifica,' '),6)||' '||
				  rpad(nvl(cur_riga.figura,' '),6)||' '||
				  rpad(nvl(cur_riga.attivita,' '),4)||' '||
				  rpad(nvl(cur_riga.settore,' '),6)||' '||
				  rpad(nvl(cur_riga.sede,' '),6)||' '||
				  rpad(nvl(cur_riga.assenza,' '),4)||' '||
				  rpad(nvl(cur_riga.delibera,' '),15)||' '||
				  cur_riga.tabella
		        );
	end loop;

insert_intestazione_errore(contarighe, P_pagina);

for CUR_CI in (select  ci, min(dal) dal, max(al)  al
                 from  RAPPORTI_INDIVIDUALI RAIN
                 group by ci
              ) loop

--dbms_output.put_line(CUR_CI.ci||' '||CUR_CI.dal||' '||CUR_CI.al);
if mod(contarighe,57)= 0 then
			   insert_intestazione_errore(contarighe,p_pagina);
end if;

begin
select min(pegi.dal) , max(pegi.al) 
  into D_min, D_max
from periodi_giuridici pegi
where ci = CUR_CI.ci
 and nvl(al, to_date('3333333','j')) in (select nvl(al,to_date('3333333','j'))
           	 					 	      from periodi_giuridici 
            						      where ci = CUR_CI.ci
									 	  and dal = (select max(dal)
			           								  from periodi_giuridici
					   								  where ci =CUR_CI.ci
													  )
										 )
 ;

if (CUR_CI.dal  <= d_min and nvl(CUR_CI.al, to_date('3333333','j')) >= nvl(D_max, to_date('3333333', 'j'))) then
   null;
else
     
     contarighe := contarighe+1;
     insert into a_appoggio_stampe
		values ( prenotazione
        		, passo
		        , P_pagina
		       	, contarighe 
		       	, rpad(CUR_CI.ci,8,' ')||' '||'Rapporto Individuale valido in periodo dal'||' '||to_char(CUR_CI.dal,'dd/mm/yy')||' - '||to_char(CUR_CI.al,'dd/mm/yy')
		        );
end if;

exception
  when no_data_found then null;
  when too_many_rows then null;
end;
     
    for CUR_PEGI in (select dal, al, rilevanza
                    from periodi_giuridici
                    where ci = CUR_CI.ci
                    ) loop 

                   

        IF CUR_PEGI.rilevanza = 'Q' THEN
            BEGIN
              select 'x'
                 into app
               from periodi_giuridici pegi
               where pegi.ci = CUR_CI.ci
               and pegi.rilevanza = 'P'
               and pegi.dal <= CUR_PEGI.dal
               and nvl(pegi.al,to_date('3333333','j')) >= nvl(CUR_PEGI.al,to_date('3333333','j'))
              ;
            exception
            when no_data_found then
               begin       
                contarighe := contarighe+1;
                insert into a_appoggio_stampe
		        values ( prenotazione
        		     , passo
		             , P_pagina
		       	     , contarighe 
		       	     , rpad(CUR_CI.ci,8,' ')||' '
                               ||to_char(CUR_PEGI.dal,'dd/mm/yy')||' - '||to_char(CUR_PEGI.al,'dd/mm/yy')||' '
                               ||'Periodo non piu` compreso nel periodo di rapporto di lavoro'
		            );
               end;
            WHEN TOO_MANY_ROWS THEN null;
            END;
         ELSIF CUR_PEGI.rilevanza in ('S', 'I', 'A', 'E') THEN 
                BEGIN
                 select  'x'
                    into    app
                   from    PERIODI_GIURIDICI PEGI
                   where   PEGI.CI        = CUR_CI.ci
                   and     PEGI.RILEVANZA = DECODE(CUR_PEGI.rilevanza,'E','I'
                                                          ,'Q')
                   and     PEGI.DAL      <= CUR_PEGI.dal
                   and     nvl(PEGI.AL,to_date('3333333','j'))
                              >= nvl(CUR_PEGI.al,to_date('3333333','j'))
                    ;
                EXCEPTION
                WHEN TOO_MANY_ROWS THEN null;
                WHEN NO_DATA_FOUND THEN
                 begin
                    contarighe := contarighe+1;
                    insert into a_appoggio_stampe
		                  values ( prenotazione
        		                  , passo
		                          , P_pagina
		       	                  , contarighe 
		       	                  , rpad(CUR_CI.ci,8,' ')||' '
                                            ||to_char(CUR_PEGI.dal,'dd/mm/yy')||' - '||to_char(CUR_PEGI.al,'dd/mm/yy')||' '
                                            ||'Non esiste il Periodo di Inquadramento'
		                          );
                 end;
                END;
          end if;
END LOOP; -- loop cur_pegi
END LOOP; -- loop cur_ci

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
END p_pegi;
/

