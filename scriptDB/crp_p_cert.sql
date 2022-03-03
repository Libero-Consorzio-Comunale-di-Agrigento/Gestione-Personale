CREATE OR REPLACE PACKAGE p_cert IS

/******************************************************************************
 NOME:          crp_p_cert
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

CREATE OR REPLACE PACKAGE BODY p_cert IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE CERTIFICATI',(132-length('VERIFICA INTEGRITA` REFERENZIALE CERTIFICATI'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE CERTIFICATI')))
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
	           	, 'Codice F.Int. F.Pre. F.Ser. F.Dim. F.Note F.Con. F.Fir. Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '------ ------ ------ ------ ------ ------ ------ ------ --------------------'
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
	for cur_riga in (select codice
				 			,f_int
							,'    ' f_pre
							,'    ' f_ser
							,'    ' f_dim
							,'    ' f_not
							,'    ' f_con
							,'    ' f_fir
							,'CERTIFICATI' tabella
						from certificati cert
						where (    f_int is not null
						   and not exists
						              (select 1 from formule_certificato foce
									               where foce.codice = cert.f_int))
					union
						select codice
							   ,'    ' f_int
							   ,f_pre
							   ,'    ' f_ser
							   ,'    ' f_dim
							   ,'    ' f_not
							   ,'    ' f_con
							   ,'    ' f_fir
							   ,'CERTIFICATI' tabella
						from certificati cert
						where (    f_pre is not null
						       and not exists
							              (select 1 from formule_certificato foce
										               where foce.codice = cert.f_pre))
					union
						select codice
							   ,'    ' f_int
							   ,'    ' f_pre
							   ,f_ser
							   ,'    ' f_dim
							   ,'    ' f_not
							   ,'    ' f_con
							   ,'    ' f_fir
							   ,'CERTIFICATI' tabella
						from certificati cert
						where (    f_ser is not null
						      and not exists
							             (select 1 from formule_certificato foce
										              where foce.codice = cert.f_ser))
					union
						select codice
							   ,'    ' f_int
							   ,'    ' f_pre
							   ,'    ' f_ser
							   ,f_dim
							   ,'    ' f_not
							   ,'    ' f_con
							   ,'    ' f_fir
							   ,'CERTIFICATI' tabella
						from certificati cert
						where (    f_dim is not null
						       and not exists
							              (select 1 from formule_certificato foce
										               where foce.codice = cert.f_dim))
					union
						select codice
							   ,'    ' f_int,'    ' f_pre,'    ' f_ser,'    ' f_dim,
       f_not,'    ' f_con,'    ' f_fir,
       'CERTIFICATI' tabella
from certificati cert
where (    f_not is not null
       and not exists
           (select 1 from formule_certificato foce
             where foce.codice = cert.f_not))
union
select codice,'    ' f_int,'    ' f_pre,'    ' f_ser,'    ' f_dim,
       '    ' f_not,f_con,'    ' f_fir,
       'CERTIFICATI' tabella
from certificati cert
where (    f_con is not null
       and not exists
           (select 1 from formule_certificato foce
             where foce.codice = cert.f_con))
union
select codice,'    ' f_int,'    ' f_pre,'    ' f_ser,'    ' f_dim,
       '    ' f_not,'    ' f_con,f_fir,
       'CERTIFICATI' tabella
from certificati cert
where (    f_fir is not null
       and not exists
           (select 1 from formule_certificato foce
             where foce.codice = cert.f_fir))
order by 9,2,3,4,5,6,7,8,1



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
		       	, rpad(nvl(cur_riga.codice,' '),6)||' '||
				  rpad(nvl(cur_riga.f_int,' '),6)||' '||
				  rpad(nvl(cur_riga.f_pre,' '),6)||' '||
				  rpad(nvl(cur_riga.f_ser,' '),6)||' '||
				  rpad(nvl(cur_riga.f_dim,' '),6)||' '||
				  rpad(nvl(cur_riga.f_not,' '),6)||' '||
				  rpad(nvl(cur_riga.f_con,' '),6)||' '||
				  rpad(nvl(cur_riga.f_fir,' '),6)||' '||
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
END p_cert;
/

