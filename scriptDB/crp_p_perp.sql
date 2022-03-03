CREATE OR REPLACE PACKAGE p_perp IS

	
/******************************************************************************
 NOME:          crp_p_perp
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

CREATE OR REPLACE PACKAGE BODY p_perp IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;

PROCEDURE main(prenotazione IN NUMBER, passo IN NUMBER) IS
	p_pagina	number := 1;
	contarighe  number;
procedure insert_intestazione(contarighe in out number, pagina in number) is
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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE PERIODI_RETRIBUTIVI_BP',(132-length('VERIFICA INTEGRITA` REFERENZIALE PERIODI_RETRIBUTIVI_BP'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE PERIODI_RETRIBUTIVI_BP')))
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
	           	, 'Cod.Ind. Anno Me Att. Contr. Sede Numero  Anno Figura Gest. Posiz. Qualif. Ruolo Settore Sede   Tratt. Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ---- -- ---- ------ ---- ------- ---- ------ ----- ------ ------- ----- ------- ------ ------ --------------------------'
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
	for cur_riga in (select ci, anno, mese
       , attivita
       , null contratto
       , null sede_del
       , null anno_del
       , null numero_del
       , null figura
       , null gestione
       , null posizione
       , null qualifica
       , null ruolo
       , null settore
       , null sede
       , null trattamento
       , 'ATTIVITA' tabella
  from periodi_retributivi_bp perp
 where not exists
  (select 1 from attivita atti
    where atti.codice = perp.attivita)
   and perp.attivita is not null
union
select ci, anno, mese
       , null attivita
       , contratto
       , null sede_del
       , null anno_del
       , null numero_del
       , null figura
       , null gestione
       , null posizione
       , null qualifica
       , null ruolo
       , null settore
       , null sede
       , null trattamento
       , 'CONTRATTI' tabella
  from periodi_retributivi_bp perp
 where not exists
  (select 1 from contratti cont
    where cont.codice = perp.contratto)
union
select ci, anno, mese
       , null attivita
       , null contratto
       , sede_del
       , to_char(anno_del)
       , to_char(numero_del)
       , null figura
       , null gestione
       , null posizione
       , null qualifica
       , null ruolo
       , null settore
       , null sede
       , null trattamento
       , 'DELIBERE' tabella
  from periodi_retributivi_bp perp
 where sede_del||to_char(anno_del)||to_char(numero_del) is not null
   and not exists
  (select 1 from delibere deli
    where deli.sede = perp.sede_del
      and deli.anno = perp.anno_del
      and deli.numero = perp.numero_del)
   and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select ci, anno, mese
       , null attivita
       , null contratto
       , null sede_del
       , null anno_del
       , null numero_del
       , to_char(figura )
       , null gestione
       , null posizione
       , null qualifica
       , null ruolo
       , null settore
       , null sede
       , null trattamento
       , 'FIGURE' tabella
  from periodi_retributivi_bp perp
 where figura is not null
   and not exists
  (select 1 from figure figu
    where figu.numero = perp.figura)
union
select ci, anno, mese
       , null attivita
       , null contratto
       , null sede_del
       , null anno_del
       , null numero_del
       , null figura
       , gestione
       , null posizione
       , null qualifica
       , null ruolo
       , null settore
       , null sede
       , null trattamento
       , 'GESTIONI' tabella
  from periodi_retributivi_bp perp
 where not exists
  (select 1 from gestioni gest
    where gest.codice = perp.gestione)
union
select ci, anno, mese
       , null attivita
       , null contratto
       , null sede_del
       , null anno_del
       , null numero_del
       , null figura
       , null gestione
       , posizione
       , null qualifica
       , null ruolo
       , null settore
       , null sede
       , null trattamento
       , 'POSIZIONI' tabella
  from periodi_retributivi_bp perp
 where posizione is not null
   and not exists
  (select 1 from posizioni posi
    where posi.codice = perp.posizione)
union
select ci, anno, mese
       , null attivita
       , null contratto
       , null sede_del
       , null anno_del
       , null numero_del
       , null figura
       , null gestione
       , null posizione
       , to_char(qualifica)
       , null ruolo
       , null settore
       , null sede
       , null trattamento
       , 'QUALIFICHE' tabella
  from periodi_retributivi_bp perp
 where qualifica is not null
   and not exists
  (select 1 from qualifiche qual
    where qual.numero = perp.qualifica)
union
select ci, anno, mese
       , null attivita
       , null contratto
       , null sede_del
       , null anno_del
       , null numero_del
       , null figura
       , null gestione
       , null posizione
       , null qualifica
       , ruolo
       , null settore
       , null sede
       , null trattamento
       , 'RUOLO' tabella
  from periodi_retributivi_bp perp
 where ruolo is not null
   and not exists
  (select 1 from ruoli ruol
    where ruol.codice = perp.ruolo)
union
select ci, anno, mese
       , null attivita
       , null contratto
       , null sede_del
       , null anno_del
       , null numero_del
       , null figura
       , null gestione
       , null posizione
       , null qualifica
       , null ruolo
       , to_char(settore)
       , null sede
       , null trattamento
       , 'SETTORI' tabella
  from periodi_retributivi_bp perp
 where settore is not null
   and not exists
  (select 1 from settori sett
    where sett.numero = perp.settore)
union
select ci, anno, mese
       , null attivita
       , null contratto
       , null sede_del
       , null anno_del
       , null numero_del
       , null figura
       , null gestione
       , null posizione
       , null qualifica
       , null ruolo
       , null settore
       , to_char(sede)
       , null trattamento
       , 'SEDI' tabella
  from periodi_retributivi_bp perp
 where nvl(sede,0) != 0
   and not exists
  (select 1 from sedi sede
    where sede.numero = perp.sede)
union
select ci, anno, mese
       , null attivita
       , null contratto
       , null sede_del
       , null anno_del
       , null numero_del
       , null figura
       , null gestione
       , null posizione
       , null qualifica
       , null ruolo
       , null settore
       , null sede
       , trattamento
       , 'TRATTAMENTI_PREVIDENZIALI' tabella
  from periodi_retributivi_bp perp
 where not exists
  (select 1 from trattamenti_previdenziali trpr
    where trpr.codice = perp.trattamento)
union
select ci, anno, mese
       , null attivita
       , null contratto
       , null sede_del
       , null anno_del
       , null numero_del
       , null figura
       , null gestione
       , null posizione
       , null qualifica
       , null ruolo
       , null settore
       , null sede
       , null trattamento
       , 'RAPPORTI_RETRIBUTIVI' tabella
  from periodi_retributivi_bp perp
 where not exists
  (select 1 from rapporti_retributivi rare
    where rare.ci = perp.ci)
union
select ci, anno, mese
       , null attivita
       , null contratto
       , null sede_del
       , null anno_del
       , null numero_del
       , null figura
       , null gestione
       , null posizione
       , null qualifica
       , null ruolo
       , null settore
       , null sede
       , null trattamento
       , 'MESI' tabella
  from periodi_retributivi_bp perp
 where not exists
  (select 1 from mesi mese
    where mese.anno = perp.anno
      and mese.mese = perp.mese)
order by 17,4,5,6,7,8,9,10,11,12,13,14,15,16,1,2,3

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
				  rpad(nvl(to_char(cur_riga.anno),' '),4)||' '||
				  rpad(nvl(to_char(cur_riga.mese),' '),2)||' '||
				  rpad(nvl(cur_riga.attivita,' '),4)||' '||
				  rpad(nvl(cur_riga.contratto,' '),6)||' '||
				  rpad(nvl(cur_riga.sede_del,' '),4)||' '||
				  rpad(nvl(cur_riga.numero_del,' '),7)||' '||
				  rpad(nvl(cur_riga.anno_del,' '),4)||' '||
				  rpad(nvl(cur_riga.figura,' '),6)||' '||
				  rpad(nvl(cur_riga.gestione,' '),5)||' '||
				  rpad(nvl(cur_riga.posizione,' '),6)||' '||
				  rpad(nvl(cur_riga.qualifica,' '),7)||' '||
				  rpad(nvl(cur_riga.ruolo,' '),5)||' '||
				  rpad(nvl(cur_riga.settore,' '),7)||' '||
				  rpad(nvl(cur_riga.sede,' '),6)||' '||
				  rpad(nvl(cur_riga.trattamento,' '),6)||' '||
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
END p_perp;
/

