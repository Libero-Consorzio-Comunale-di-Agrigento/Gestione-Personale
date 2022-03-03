CREATE OR REPLACE PACKAGE p_moco IS

/******************************************************************************
 NOME:          crp_p_moco
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

CREATE OR REPLACE PACKAGE BODY p_moco IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE MOVIMENTI_CONTABILI',(132-length('VERIFICA INTEGRITA` REFERENZIALE MOVIMENTI_CONTABILI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE MOVIMENTI_CONTABILI')))
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
	           	, 'Cod.Ind. Anno Me Mensilita Voce       Sub   Qual.  Sede Del. Anno Numero  Delibera   Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- ---- -- --------- ---------- ----- ------ --------- ---- ------- ---------- ----------------------'
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
	for cur_riga in (select ci, anno, mese,  mensilita,
       null voce, null sub, to_number(null) qualifica, null sede_del,
       to_number(null) anno_del, to_number(null) numero_del,
       null delibera, 'RAPPORTI_INDIVIDUALI' tabella
from movimenti_contabili moco
where not exists
  (select 1 from rapporti_individuali rain
    where rain.ci = moco.ci )
union
select ci, anno, mese, mensilita,
       null voce, null sub, to_number(null) qualifica, null sede_del,
       to_number(null) anno_del, to_number(null) numero_del,
       null delibera, 'RAPPORTI_RETRIBUTIVI' tabella
from movimenti_contabili moco
where not exists
  (select 1 from rapporti_retributivi rare
    where rare.ci = moco.ci )
union
select ci, anno, mese, mensilita,
       null voce, null sub, to_number(null) qualifica, null sede_del,
       to_number(null) anno_del, to_number(null) numero_del,
       null delibera, 'MESE' tabella
from movimenti_contabili moco
where mese is not null
  and not exists
  (select 1 from mesi mese
    where mese.anno = moco.anno
      and mese.mese = moco.mese)
union
select ci, anno, mese,  mensilita,
       null voce, null sub, to_number(null) qualifica, null sede_del,
       to_number(null) anno_del, to_number(null) numero_del,
       null delibera, 'MENSILITA' tabella
from movimenti_contabili moco
where mese is not null
  and mensilita is not null
  and not exists
  (select 1 from mensilita mens
    where mens.mese = moco.mese
      and mens.mensilita = moco.mensilita)
union
select ci, anno, mese, mensilita,
       voce, null sub, to_number(null) qualifica, null sede_del,
       to_number(null) anno_del, to_number(null) numero_del,
       null delibera, 'VOCI_ECONOMICHE' tabella
from movimenti_contabili moco
where not exists
  (select 1 from voci_economiche voec
    where voec.codice = moco.voce)
union
select ci, anno, mese, mensilita,
       voce, sub, to_number(null) qualifica, null sede_del,
       to_number(null) anno_del, to_number(null) numero_del,
       null delibera, 'VOCI_CONTABILI' tabella
from movimenti_contabili moco
where not exists
  (select 1 from voci_contabili voco
    where voco.voce = moco.voce
      and voco.sub  = moco.sub)
union
select ci, anno, mese, mensilita,
       voce, sub, to_number(null) qualifica, null sede_del,
       to_number(null) anno_del, to_number(null) numero_del,
       null delibera, 'CONTABILITA_VOCE' tabella
from movimenti_contabili moco
where not exists
  (select 1 from contabilita_voce covo
    where covo.voce = moco.voce
      and covo.sub  = moco.sub)
union
select ci, anno, mese, mensilita,
       null voce, null sub, qualifica, null sede_del,
       to_number(null) anno_del, to_number(null) numero_del,
       null delibera, 'QUALIFICHE' tabella
from movimenti_contabili moco
where qualifica is not null
  and not exists
  (select 1 from qualifiche qual
    where qual.numero = moco.qualifica)
union
select ci, anno, mese, mensilita,
       null voce, null sub, to_number(null) qualifica, sede_del,
       anno_del, numero_del,
       delibera, 'DELIBERE_RETRIBUTIVE' tabella
from movimenti_contabili moco
where sede_del||anno_del||numero_del is not null
  and not exists
  (select 1 from delibere_retributive dere
    where dere.sede        = moco.sede_del
      and dere.anno        = moco.anno_del
      and dere.numero      = moco.numero_del
      and dere.tipo        = moco.delibera
      and dere.riferimento = moco.riferimento
      and dere.anno_elab   = moco.anno
      and dere.mese        = moco.mese
      and dere.mensilita   = moco.mensilita)
  and exists (select 'x' from ente where delibere = 'SI')
order by 12,2,3,4,5,6,7,8,9,10,11,1

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
				  rpad(nvl(cur_riga.mensilita,' '),9)||' '||
				  rpad(nvl(cur_riga.voce,' '),10)||' '||
				  rpad(nvl(cur_riga.sub,' '),5)||' '||
				  rpad(nvl(to_char(cur_riga.qualifica),' '),6)||' '||
				  rpad(nvl(cur_riga.sede_del,' '),9)||' '||
				  rpad(nvl(to_char(cur_riga.anno_del),' '),4)||' '||
				  rpad(nvl(to_char(cur_riga.numero_del),' '),7)||' '||
				  rpad(nvl(cur_riga.delibera,' '),10)||' '||
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
END p_moco;
/

