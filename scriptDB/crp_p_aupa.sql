CREATE OR REPLACE PACKAGE p_aupa IS

/******************************************************************************
 NOME:          CRP_P_AUPA
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

CREATE OR REPLACE PACKAGE BODY p_aupa IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE AUTOMATISMI PRESENZA',(132-length('VERIFICA INTEGRITA` REFERENZIALE AUTOMATISMI PRESENZA'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE AUTOMATISMI PRESENZA')))
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
	           	, 'Causale  Motivo   Seq Dal        Al          Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '--------- -------- --- ---------- ---------- -------------------------------'
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
	for cur_riga in (select  aupa.causale                           causale
       ,aupa.motivo                            motivo
       ,aupa.sequenza                          sequenza
       ,substr(to_char(aupa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(aupa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'CAUSALI EVENTO'                       tabella
  from  automatismi_presenza aupa
 where  not exists
       (select 1 
          from causali_evento caev
         where caev.codice = aupa.causale
       )
union
select  aupa.causale                           causale
       ,aupa.motivo                            motivo
       ,aupa.sequenza                          sequenza
       ,substr(to_char(aupa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(aupa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'MOTIVI EVENTO'                        tabella
  from  automatismi_presenza aupa
 where  not exists
       (select 1 
          from motivi_evento moev
         where moev.codice = aupa.motivo
       )
   and  aupa.motivo       is not null
union
select  aupa.causale                           causale
       ,aupa.motivo                            motivo
       ,aupa.sequenza                          sequenza
       ,substr(to_char(aupa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(aupa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'SEDI'                                 tabella
  from  automatismi_presenza aupa
 where  not exists
       (select 1 
          from sedi sede
         where sede.numero = aupa.sede
       )
   and  aupa.sede         is not null
union
select  aupa.causale                           causale
       ,aupa.motivo                            motivo
       ,aupa.sequenza                          sequenza
       ,substr(to_char(aupa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(aupa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'CENTRI COSTO'                         tabella
  from  automatismi_presenza aupa
 where  not exists
       (select 1 
          from centri_costo ceco
         where ceco.codice = aupa.cdc
       )
   and  aupa.cdc          is not null
union
select  aupa.causale                           causale
       ,aupa.motivo                            motivo
       ,aupa.sequenza                          sequenza
       ,substr(to_char(aupa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(aupa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'GESTIONI'                             tabella
  from  automatismi_presenza aupa
 where  not exists
       (select 1 
          from gestioni gest
         where gest.codice = aupa.gestione
       )
   and  aupa.gestione     is not null
union
select  aupa.causale                           causale
       ,aupa.motivo                            motivo
       ,aupa.sequenza                          sequenza
       ,substr(to_char(aupa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(aupa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'SETTORI'                              tabella
  from  automatismi_presenza aupa
 where  not exists
       (select 1 
          from settori sett
         where sett.numero = aupa.settore
       )
   and  aupa.settore      is not null
union
select  aupa.causale                           causale
       ,aupa.motivo                            motivo
       ,aupa.sequenza                          sequenza
       ,substr(to_char(aupa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(aupa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'CLASSIFICAZIONI FUNZIONALI'           tabella
  from  automatismi_presenza aupa
 where  not exists
       (select 1 
          from classificazioni_funzionali clfu
         where clfu.codice = aupa.funzionale
       )
   and  aupa.funzionale   is not null
union
select  aupa.causale                           causale
       ,aupa.motivo                            motivo
       ,aupa.sequenza                          sequenza
       ,substr(to_char(aupa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(aupa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'POSIZIONI'                            tabella
  from  automatismi_presenza aupa
 where  not exists
       (select 1 
          from posizioni posi
         where posi.codice = aupa.posizione
       )
   and  aupa.posizione    is not null
union
select  aupa.causale                           causale
       ,aupa.motivo                            motivo
       ,aupa.sequenza                          sequenza
       ,substr(to_char(aupa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(aupa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'RUOLI'                                tabella
  from  automatismi_presenza aupa
 where  not exists
       (select 1 
          from ruoli ruol
         where ruol.codice = aupa.ruolo
       )
   and  aupa.ruolo        is not  null
union
select  aupa.causale                           causale
       ,aupa.motivo                            motivo
       ,aupa.sequenza                          sequenza
       ,substr(to_char(aupa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(aupa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'FIGURE GIURIDICHE'                    tabella
  from  automatismi_presenza aupa
 where  not exists
       (select 1 
          from figure_giuridiche figi
         where figi.numero = aupa.figura
           and nvl(figi.dal,to_date('2222222','j'))
                          <= nvl(aupa.al ,to_date('3333333','j'))
           and nvl(figi.al ,to_date('3333333','j'))
                          >= nvl(aupa.dal,to_date('2222222','j'))
       )
   and  aupa.figura       is not null
union
select  aupa.causale                           causale
       ,aupa.motivo                            motivo
       ,aupa.sequenza                          sequenza
       ,substr(to_char(aupa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(aupa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'ATTIVITA'                             tabella
  from  automatismi_presenza aupa
 where  not exists
       (select 1 
          from attivita atti
         where atti.codice = aupa.attivita
       )
   and  aupa.attivita     is not null
union
select  aupa.causale                           causale
       ,aupa.motivo                            motivo
       ,aupa.sequenza                          sequenza
       ,substr(to_char(aupa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(aupa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'CONTRATTI'                            tabella
  from  automatismi_presenza aupa
 where  not exists
       (select 1 
          from contratti cont
         where cont.codice = aupa.contratto
       )
   and  aupa.contratto    is not null
union
select  aupa.causale                           causale
       ,aupa.motivo                            motivo
       ,aupa.sequenza                          sequenza
       ,substr(to_char(aupa.dal,'dd/mm/yyyy'),1,10)
                                               dal
       ,substr(to_char(aupa.al ,'dd/mm/yyyy'),1,10)
                                               al
       ,'QUALIFICHE GIURIDICHE'                tabella
  from  automatismi_presenza aupa
 where  not exists
       (select 1 
          from qualifiche_giuridiche qugi
         where qugi.numero = aupa.qualifica
           and nvl(qugi.dal,to_date('2222222','j'))
                          <= nvl(aupa.al ,to_date('3333333','j'))
           and nvl(qugi.al ,to_date('3333333','j'))
                          >= nvl(aupa.dal,to_date('2222222','j'))
       )
   and  aupa.qualifica    is not null
 order by 3,1,2,4,5

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
				  rpad(nvl(cur_riga.motivo,' '),8)||' '||
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
END p_aupa;
/

