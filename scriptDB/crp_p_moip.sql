CREATE OR REPLACE PACKAGE p_moip IS

/******************************************************************************
 NOME:          CRP_P_MOIP
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

CREATE OR REPLACE PACKAGE BODY p_moip IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE MOVIMENTI INCENTIVO',(132-length('VERIFICA INTEGRITA` REFERENZIALE MOVIMENTI INCENTIVO'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE MOVIMENTI INCENTIVO')))
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
	           	, 'Progetto App. Cod.Ind. Periodo    Anno Mm Equipe Gr Ruolo Qualif.  Sede   Settore  Ruolo Seq. Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ---- -------- ---------- ---- -- ------ -- ----- -------- ------ -------- ----- ---- -------------------------------'
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
	for cur_riga in (select  moip.progetto                       progetto
       ,moip.scp                            scp
       ,moip.ci                             ci
       ,substr(to_char(moip.periodo,'dd/mm/yyyy'),1,10)
                                            periodo
       ,to_number(null)                     anno
       ,to_number(null)                     mese
       ,null                                equipe
       ,null                                gruppo
       ,null                                ruolo
       ,to_number(null)                     qualifica
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,null                                ruolo_impegno
       ,to_number(null)                     sequenza_impegno
       ,'RAPPORTI GIURIDICI'                tabella
  from  movimenti_incentivo moip
 where  not exists
       (select 1 
          from rapporti_giuridici ragi
         where ragi.ci = moip.ci
       )
 union
select  moip.progetto                       progetto
       ,moip.scp                            scp
       ,moip.ci                             ci
       ,substr(to_char(moip.periodo,'dd/mm/yyyy'),1,10)
                                            periodo
       ,moip.anno                           anno
       ,moip.mese                           mese
       ,null                                equipe
       ,null                                gruppo
       ,null                                ruolo
       ,to_number(null)                     qualifica
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,null                                ruolo_impegno
       ,to_number(null)                     sequenza_impegno
       ,'MESI'                              tabella
  from  movimenti_incentivo moip
 where  not exists
       (select 1 
          from mesi mese
         where mese.anno = moip.anno
           and mese.mese = moip.mese
       )
 union
select  moip.progetto                       progetto
       ,moip.scp                            scp
       ,moip.ci                             ci
       ,substr(to_char(moip.periodo,'dd/mm/yyyy'),1,10)
                                            periodo
       ,to_number(null)                     anno
       ,to_number(null)                     mese
       ,null                                equipe
       ,null                                gruppo
       ,null                                ruolo
       ,to_number(null)                     qualifica
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,null                                ruolo_impegno
       ,to_number(null)                     sequenza_impegno
       ,'APPLICAZIONI INCENTIVO'            tabella
  from  movimenti_incentivo moip
 where  not exists
       (select 1 
          from applicazioni_incentivo apip
         where apip.progetto = moip.progetto
           and apip.scp      = moip.scp
       )
 union
select  moip.progetto                       progetto
       ,moip.scp                            scp
       ,moip.ci                             ci
       ,substr(to_char(moip.periodo,'dd/mm/yyyy'),1,10)
                                            periodo
       ,to_number(null)                     anno
       ,to_number(null)                     mese
       ,null                                equipe
       ,null                                gruppo
       ,null                                ruolo
       ,to_number(null)                     qualifica
       ,to_number(null)                     sede
       ,moip.settore                        settore
       ,null                                ruolo_impegno
       ,to_number(null)                     sequenza_impegno
       ,'SETTORI'                           tabella
  from  movimenti_incentivo moip
 where  not exists
       (select 1 
          from settori sett
         where sett.numero = moip.settore
       )
 union
select  moip.progetto                       progetto
       ,moip.scp                            scp
       ,moip.ci                             ci
       ,substr(to_char(moip.periodo,'dd/mm/yyyy'),1,10)
                                            periodo
       ,to_number(null)                     anno
       ,to_number(null)                     mese
       ,null                                equipe
       ,null                                gruppo
       ,null                                ruolo
       ,to_number(null)                     qualifica
       ,moip.sede                           sede
       ,to_number(null)                     settore
       ,null                                ruolo_impegno
       ,to_number(null)                     sequenza_impegno
       ,'SEDI'                              tabella
  from  movimenti_incentivo moip
 where  not exists
       (select 1 
          from sedi sede
         where sede.numero = moip.sede
       )
   and  nvl(moip.sede,0) 
                      != 0
 union
select  moip.progetto                       progetto
       ,moip.scp                            scp
       ,moip.ci                             ci
       ,substr(to_char(moip.periodo,'dd/mm/yyyy'),1,10)
                                            periodo
       ,to_number(null)                     anno
       ,to_number(null)                     mese
       ,null                                equipe
       ,null                                gruppo
       ,null                                ruolo
       ,moip.qualifica                      qualifica
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,null                                ruolo_impegno
       ,to_number(null)                     sequenza_impegno
       ,'QUALIFICHE'                        tabella
  from  movimenti_incentivo moip
 where  not exists
       (select 1 
          from qualifiche qual
         where qual.numero = moip.qualifica
       )
 union
select  moip.progetto                       progetto
       ,moip.scp                            scp
       ,moip.ci                             ci
       ,substr(to_char(moip.periodo,'dd/mm/yyyy'),1,10)
                                            periodo
       ,to_number(null)                     anno
       ,to_number(null)                     mese
       ,null                                equipe
       ,null                                gruppo
       ,moip.ruolo                          ruolo
       ,to_number(null)                     qualifica
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,null                                ruolo_impegno
       ,to_number(null)                     sequenza_impegno
       ,'RUOLI'                             tabella
  from  movimenti_incentivo moip
 where  not exists
       (select 1 
          from ruoli ruol
         where ruol.codice = moip.ruolo
       )
 union
select  moip.progetto                       progetto
       ,moip.scp                            scp
       ,moip.ci                             ci
       ,substr(to_char(moip.periodo,'dd/mm/yyyy'),1,10)
                                            periodo
       ,to_number(null)                     anno
       ,to_number(null)                     mese
       ,null                                equipe
       ,moip.gruppo                         gruppo
       ,null                                ruolo
       ,to_number(null)                     qualifica
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,null                                ruolo_impegno
       ,to_number(null)                     sequenza_impegno
       ,'GRUPPI INCENTIVO'                  tabella
  from  movimenti_incentivo moip
 where  not exists
       (select 1 
          from gruppi_incentivo grip
         where grip.codice = moip.gruppo
       )
 union
select  moip.progetto                       progetto
       ,moip.scp                            scp
       ,moip.ci                             ci
       ,substr(to_char(moip.periodo,'dd/mm/yyyy'),1,10)
                                            periodo
       ,to_number(null)                     anno
       ,to_number(null)                     mese
       ,moip.equipe                         equipe
       ,null                                gruppo
       ,null                                ruolo
       ,to_number(null)                     qualifica
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,null                                ruolo_impegno
       ,to_number(null)                     sequenza_impegno
       ,'EQUIPE'                            tabella
  from  movimenti_incentivo moip
 where  not exists
       (select 1 
          from equipe eqip
         where eqip.codice = moip.equipe
       )
 union
select  moip.progetto                       progetto
       ,moip.scp                            scp
       ,moip.ci                             ci
       ,substr(to_char(moip.periodo,'dd/mm/yyyy'),1,10)
                                            periodo
       ,to_number(null)                     anno
       ,to_number(null)                     mese
       ,null                                equipe
       ,null                                gruppo
       ,null                                ruolo
       ,to_number(null)                     qualifica
       ,to_number(null)                     sede
       ,to_number(null)                     settore
       ,moip.ruolo_impegno                  ruolo_impegno
       ,moip.sequenza_impegno               sequenza_impegno
       ,'IMPEGNI PROGETTO INCENTIVO'        tabella
  from  movimenti_incentivo moip
 where  not exists
       (select 1 
          from impegni_progetto_incentivo ipip
         where ipip.sequenza = moip.sequenza_impegno
           and ipip.ruolo    = moip.ruolo_impegno
           and ipip.progetto = moip.progetto
           and ipip.scp      = moip.scp
       )
   and  moip.ruolo_impegno||to_char(moip.sequenza_impegno)
                            is not null
 order by 15,1,2,3,4

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
				  rpad(nvl(cur_riga.scp,' '),4)||' '||
				  rpad(nvl(to_char(cur_riga.ci),' '),8)||' '||
				  rpad(nvl(cur_riga.periodo,' '),10)||' '||
				  rpad(nvl(to_char(cur_riga.anno),' '),4)||' '||
				  rpad(nvl(to_char(cur_riga.mese),' '),2)||' '||
				  rpad(nvl(cur_riga.equipe,' '),6)||' '||
				  rpad(nvl(cur_riga.gruppo,' '),2)||' '||
				  rpad(nvl(cur_riga.ruolo,' '),5)||' '||
				  rpad(nvl(to_char(cur_riga.qualifica),' '),8)||' '||
				  rpad(nvl(to_char(cur_riga.sede),' '),6)||' '||
				  rpad(nvl(to_char(cur_riga.settore),' '),8)||' '||
  				  rpad(nvl(cur_riga.ruolo_impegno,' '),5)||' '||
  				  rpad(nvl(to_char(cur_riga.sequenza_impegno),' '),4)||' '||
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
END p_moip;
/

