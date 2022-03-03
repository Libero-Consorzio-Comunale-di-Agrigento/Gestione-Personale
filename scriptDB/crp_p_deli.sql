CREATE OR REPLACE PACKAGE p_deli IS

/******************************************************************************
 NOME:          crp_p_deli
 DESCRIZIONE:   

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    04/12/2003 GM            
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

  PROCEDURE MAIN      (PRENOTAZIONE IN NUMBER,
                  PASSO        IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY p_deli IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 04/12/2003';
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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE DELIBERE',(132-length('VERIFICA INTEGRITA` REFERENZIALE DELIBERE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE DELIBERE')))
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
	           	, 'Sede       Anno Numero  Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '---------- ---- ------ --------------------'
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
	for cur_riga in (select sede_del, anno_del, numero_del,
       'CONTABILITA_VOCE' tabella
from contabilita_voce covo
where not exists
  (select 1 from delibere deli
    where covo.sede_del = deli.sede
      and covo.anno_del = deli.anno
      and covo.numero_del = deli.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select sede_del, anno_del, numero_del,
       'CONVOCAZIONI' tabella
from convocazioni conv
where not exists
  (select 1 from delibere deli
    where conv.sede_del = deli.sede
      and conv.anno_del = deli.anno
      and conv.numero_del = deli.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select sede_del, anno_del, numero_del,
       'DEPOSITO_VARIABILI_ECONOMICHE' tabella
from deposito_variabili_economiche deve
where not exists
  (select 1 from delibere deli
    where deve.sede_del = deli.sede
      and deve.anno_del = deli.anno
      and deve.numero_del = deli.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select sede_del, anno_del, numero_del,
       'ARCHIVIO_DOCUMENTI_GIURIDICI' tabella
from archivio_documenti_giuridici ardg
where not exists
  (select 1 from delibere deli
    where ardg.sede_del = deli.sede
      and ardg.anno_del = deli.anno
      and ardg.numero_del = deli.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select sede_del, anno_del, numero_del,
       'IMPUTAZIONI_CONTABILI' tabella
from imputazioni_contabili imco
where not exists
  (select 1 from delibere deli
    where imco.sede_del = deli.sede
      and imco.anno_del = deli.anno
      and imco.numero_del = deli.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select sede_del, anno_del, numero_del,
       'MOVIMENTI_BILANCIO_PREVISIONE' tabella
from movimenti_bilancio_previsione mobp
where not exists
  (select 1 from delibere deli
    where mobp.sede_del = deli.sede
      and mobp.anno_del = deli.anno
      and mobp.numero_del = deli.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select sede_del, anno_del, numero_del,
       'MOVIMENTI_CONTABILI' tabella
from movimenti_contabili moco
where not exists
  (select 1 from delibere deli
    where moco.sede_del = deli.sede
      and moco.anno_del = deli.anno
      and moco.numero_del = deli.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select sede_del, anno_del, numero_del,
       'MOVIMENTI_CONTABILI_PREVISIONE' tabella
from movimenti_contabili_previsione mocp
where not exists
  (select 1 from delibere deli
    where mocp.sede_del = deli.sede
      and mocp.anno_del = deli.anno
      and mocp.numero_del = deli.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select sede_del, anno_del, numero_del,
       'PERIODI_GIURIDICI' tabella
from periodi_giuridici pegi
where not exists
  (select 1 from delibere deli
    where pegi.sede_del = deli.sede
      and pegi.anno_del = deli.anno
      and pegi.numero_del = deli.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select sede_posto, anno_posto, numero_posto,
       'PERIODI_GIURIDICI' tabella
from periodi_giuridici pegi
where not exists
  (select 1 from delibere deli
    where pegi.sede_posto = deli.sede
      and pegi.anno_posto = deli.anno
      and pegi.numero_posto = deli.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
  and rilevanza = 'P'
union
select sede_del, anno_del, numero_del,
       'PERIODI_RETRIBUTIVI' tabella
from periodi_retributivi pere
where not exists
  (select 1 from delibere deli
    where pere.sede_del = deli.sede
      and pere.anno_del = deli.anno
      and pere.numero_del = deli.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select sede_del, anno_del, numero_del,
       'PERIODI_RETRIBUTIVI_BP' tabella
from periodi_retributivi_bp perb
where not exists
  (select 1 from delibere deli
    where perb.sede_del = deli.sede
      and perb.anno_del = deli.anno
      and perb.numero_del = deli.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select sede_del, anno_del, numero_del,
       'RACCOLTA_MODULI' tabella
from raccolta_moduli ramo
where not exists
  (select 1 from delibere deli
    where ramo.sede_del = deli.sede
      and ramo.anno_del = deli.anno
      and ramo.numero_del = deli.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
union
select sede, anno, numero,
       'DELIBERE_RETRIBUTIVE' tabella
from delibere_retributive dere
where not exists
  (select 1 from delibere deli
    where dere.sede = deli.sede
      and dere.anno = deli.anno
      and dere.numero = deli.numero)
  and exists
  (select 1 from ente
    where ente.delibere = 'SI')
order by 4,1,2,3
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
		       	, rpad(nvl(cur_riga.sede_del,' '),10)||' '||
				  rpad(nvl(to_char(cur_riga.anno_del),' '),4)||' '||
				  rpad(nvl(to_char(cur_riga.numero_del),' '),7)||' '||
  				  --rpad(nvl(cur_riga.tipo,' '),4)||' '||
				  --rpad(nvl(cur_riga.mese,' '),4)||' '||
				  --rpad(nvl(cur_riga.mensilita,' '),9)||' '||
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
END p_deli;
/