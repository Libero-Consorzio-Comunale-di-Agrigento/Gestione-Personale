CREATE OR REPLACE PACKAGE p_pere IS

/******************************************************************************
 NOME:          crp_p_pere
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

CREATE OR REPLACE PACKAGE BODY p_pere IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE PERIODI_RETRIBUTIVI',(132-length('VERIFICA INTEGRITA` REFERENZIALE PERIODI_RETRIBUTIVI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE PERIODI_RETRIBUTIVI')))
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
  from periodi_retributivi pere
 where not exists
  (select 1 from attivita atti
    where atti.codice = pere.attivita)
   and pere.attivita is not null
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
  from periodi_retributivi pere
 where not exists
  (select 1 from contratti cont
    where cont.codice = pere.contratto)
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
  from periodi_retributivi pere
 where sede_del||to_char(anno_del)||to_char(numero_del) is not null
   and not exists
  (select 1 from delibere deli
    where deli.sede = pere.sede_del
      and deli.anno = pere.anno_del
      and deli.numero = pere.numero_del)
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
  from periodi_retributivi pere
 where figura is not null
   and not exists
  (select 1 from figure figu
    where figu.numero = pere.figura)
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
  from periodi_retributivi pere
 where not exists
  (select 1 from gestioni gest
    where gest.codice = pere.gestione)
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
  from periodi_retributivi pere
 where posizione is not null
   and not exists
  (select 1 from posizioni posi
    where posi.codice = pere.posizione)
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
  from periodi_retributivi pere
 where qualifica is not null
   and not exists
  (select 1 from qualifiche qual
    where qual.numero = pere.qualifica)
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
  from periodi_retributivi pere
 where ruolo is not null
   and not exists
  (select 1 from ruoli ruol
    where ruol.codice = pere.ruolo)
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
  from periodi_retributivi pere
 where settore is not null
   and not exists
  (select 1 from settori sett
    where sett.numero = pere.settore)
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
  from periodi_retributivi pere
 where nvl(sede,0) != 0
   and not exists
  (select 1 from sedi sede
    where sede.numero = pere.sede)
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
       , to_char(settore) settore
       , to_char(sede)
       , null trattamento
       , 'RIPARTIZIONI_FUNZIONALI' tabella
  from periodi_retributivi pere
 where not exists
  (select 1 from ripartizioni_funzionali rifu
    where pere.settore = rifu.settore
      and nvl(pere.sede,0) = rifu.sede)
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
  from periodi_retributivi pere
 where not exists
  (select 1 from trattamenti_previdenziali trpr
    where trpr.codice = pere.trattamento)
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
  from periodi_retributivi pere
 where not exists
  (select 1 from rapporti_retributivi rare
    where rare.ci = pere.ci)
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
  from periodi_retributivi pere
 where not exists
  (select 1 from mesi mese
    where mese.anno = pere.anno
      and mese.mese = pere.mese)
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
END p_pere;
/

