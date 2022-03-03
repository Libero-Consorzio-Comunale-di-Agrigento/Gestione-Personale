CREATE OR REPLACE PACKAGE p_rfca IS

/******************************************************************************
 NOME:          CRP_P_RFCA
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

CREATE OR REPLACE PACKAGE BODY p_rfca IS

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
	           	, lpad('VERIFICA INTEGRITA` REFERENZIALE RIGHE FORMULA CAUSALE',(132-length('VERIFICA INTEGRITA` REFERENZIALE RIGHE FORMULA CAUSALE'))/2+(length('VERIFICA INTEGRITA` REFERENZIALE RIGHE FORMULA CAUSALE')))
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
	           	, 'Formula  Seq Voce     Sub Tabella'
	           )
			   ;
		contarighe:=contarighe+1;
		insert into a_appoggio_stampe
		 values ( prenotazione
        		, passo
		        , P_pagina
	        	, contarighe
	           	, '-------- --- -------- --- -------------------------------'
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
	for cur_riga in (select  rfca.formula                           formula       
       ,rfca.sequenza                          sequenza
       ,rfca.voce                              voce
       ,rfca.sub                               sub
       ,'FORMULE CAUSALI'                      tabella
  from  righe_formula_causale rfca
 where  not exists
       (select 1 
          from formula_causali foca
         where foca.codice = rfca.formula
       )
union
select  rfca.formula                           formula       
       ,rfca.sequenza                          sequenza
       ,rfca.voce                              voce
       ,rfca.sub                               sub
       ,'VOCI CONTABILI'                       tabella
  from  righe_formula_causale rfca
 where  not exists
       (select 1 
          from voci_contabili voco
         where voco.voce   = rfca.voce
           and voco.sub    = rfca.sub
       )
   and  rfca.voce||rfca.sub
                          is not null
 order by 2,1

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
		       	, rpad(nvl(cur_riga.formula,' '),8)||' '||
				  rpad(nvl(to_char(cur_riga.sequenza),' '),3)||' '||
				  rpad(nvl(cur_riga.voce,' '),8)||' '||
				  rpad(nvl(cur_riga.sub,' '),3)||' '||
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
END p_rfca;
/

