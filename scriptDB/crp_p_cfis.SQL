CREATE OR REPLACE PACKAGE P_CFIS IS
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER
               ,PASSO        IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY P_CFIS IS
PROCEDURE MAIN(prenotazione IN NUMBER, passo IN NUMBER) IS
PROCEDURE INSERT_INTESTAZIONE( d_riga in out number,d_pagina in number, stringa in varchar, intestazione in varchar ) is
   BEGIN
 		insert into a_appoggio_stampe
            ( no_prenotazione, no_passo,pagina, riga )
		 values ( prenotazione
        		  , passo
		        , d_pagina
	        	  , d_riga
                    );
		d_riga := d_riga+1;
		insert into a_appoggio_stampe
            ( no_prenotazione, no_passo, pagina, riga, testo)
		 values ( prenotazione
        		, passo
		        ,d_pagina
	        	, d_riga
	           	, lpad(stringa,(132-length(stringa))/2+(length(stringa)))
                    );
		d_riga := d_riga+1;
		insert into a_appoggio_stampe
            ( no_prenotazione, no_passo, pagina, riga)
		 values ( prenotazione
        		  , passo
		        , d_pagina
	        	  , d_riga
                     );
		d_riga := d_riga+1;
		insert into a_appoggio_stampe
            ( no_prenotazione, no_passo, pagina, riga, testo)
		 values ( prenotazione
        		  , passo
		        , d_pagina
	        	  , d_riga
	           	  , intestazione
                    );
		d_riga := d_riga+1;
		insert into a_appoggio_stampe
            ( no_prenotazione, no_passo, pagina, riga, testo)
		 values ( prenotazione
                    , passo
                    , d_pagina
                    , d_riga
                    , '-------- ---------------------------------------- -------- --------------------------- ------------------------------------------'
                    );
		commit;
  END;
BEGIN
DECLARE
D_COGNOME anagrafici.cognome%type;
D_NOME anagrafici.nome%type;
D_DATA anagrafici.data_nas%type;
D_COD_CATASTO   varchar2(4);
D_CFIS          varchar2(16);
D_CFIS1         varchar2(16);
D_PAGINA        number := 1;
D_RIGA          number := 0;
STRINGA         varchar2(132);
intestazione    varchar2(132);
d_conta_errore1 number :=0;
d_conta_errore2 number :=0;
BEGIN
BEGIN
	select nvl(max(riga),0)
	  into d_riga
	  from a_appoggio_stampe
	 where no_prenotazione = prenotazione
	 ;
END;
FOR CUR_NI IN 
(select ni, dal, comune_nas, provincia_nas,sesso
      , cognome, nome, codice_fiscale,data_nas
   from anagrafici anag
  where exists (select 'x' 
                 from rapporti_individuali
                where rapporto != '*')
    and tipo_soggetto = 'I'
  order by ni
)
   LOOP
BEGIN
  d_cfis := cur_ni.codice_fiscale;
  d_cod_catasto := to_char(null);
	select nvl(codice_catasto,'XXXX')
	  into D_COD_CATASTO
	 from comuni
	where cod_comune = CUR_NI.comune_nas
	  and cod_provincia  = CUR_NI.provincia_nas;
	EXCEPTION
	   WHEN NO_DATA_FOUND THEN
           d_conta_errore1 := d_conta_errore1+1;
	     d_riga := d_riga+1;
           IF d_conta_errore1 = 1 THEN
             stringa := 'VERIFICA INTEGRITA` REFERENZIALE ANAGRAFICI: COMUNE DI NASCITA';
   	       intestazione := 'Num.Ind. '||rpad('Cognome',40,' ')||' '||rpad('Nome',36,' ')
                             ||' Dal';
             insert_intestazione(d_riga,d_pagina,stringa,intestazione);
  	       d_riga := d_riga+1;
           END IF;
           IF mod(d_riga,57) = 0 THEN
             d_riga := d_riga+1;
             stringa := 'VERIFICA INTEGRITA` REFERENZIALE ANAGRAFICI: COMUNE DI NASCITA';
   	       intestazione := 'Num.Ind. '||rpad('Cognome',40,' ')||' '||rpad('Nome',36,' ')
                             ||' Dal';
             insert_intestazione(d_riga,d_pagina,stringa,intestazione);
  	       d_riga := d_riga+1;
           END IF;
	     INSERT into a_appoggio_stampe
		 VALUES ( prenotazione
      		  , passo
    	              , d_pagina
                    , d_riga
		        , rpad(CUR_NI.ni,8,' ')||' '||rpad(nvl(CUR_NI.cognome,' '),40,' ')||' '||rpad(nvl(CUR_NI.nome,' '),36,' ')||' '||CUR_NI.dal
		        );
  END;
END LOOP;

FOR CUR_NI1 IN 
(select ni, dal, comune_nas, provincia_nas,sesso,cognome, nome, codice_fiscale,data_nas
  from anagrafici
 where tipo_soggetto = 'I'
 order by ni
)LOOP
  BEGIN
  d_cfis := CUR_NI1.codice_fiscale;
  d_cod_catasto := to_char(null);
	select nvl(codice_catasto,'XXXX')
	  into D_COD_CATASTO
	 from comuni
	where cod_comune = CUR_NI1.comune_nas
	  and cod_provincia  = CUR_NI1.provincia_nas;
	EXCEPTION
	   WHEN NO_DATA_FOUND THEN NULL;
  END;
  IF nvl(d_cod_catasto,'XXXX') != 'XXXX' THEN

   CODICE_FISCALE.CREA (CUR_NI1.COGNOME,CUR_NI1.NOME,CUR_NI1.DATA_nas,D_COD_CATASTO,CUR_NI1.sesso,D_CFIS1);

	IF D_CFIS != D_CFIS1 then
           d_conta_errore2 := d_conta_errore2+1;
           d_riga := d_riga+1;
           IF d_conta_errore2 = 1 THEN
              stringa := 'VERIFICA INTEGRITA` REFERENZIALE ANAGRAFICI: CODICE FISCALE';
    	        intestazione := 'Num.Ind. '||rpad('Cognome',40,' ')||' '||rpad('Nome',36,' ')
                              ||' '||rpad('Dal',10,' ')||' '||rpad('C.F. NEL DB',16,' ')||' '||rpad('C.F. RICALCOLATO',16,' ');
              insert_intestazione(d_riga,d_pagina,stringa,intestazione);
	        d_riga := d_riga+1;
           END IF;
           IF mod(d_riga,57) = 0 THEN
	        d_riga := d_riga+1;
              stringa := 'VERIFICA INTEGRITA` REFERENZIALE ANAGRAFICI: CODICE FISCALE';
    	        intestazione := 'Num.Ind. '||rpad('Cognome',40,' ')||' '||rpad('Nome',36,' ')
                              ||' '||rpad('Dal',10,' ')||' '||rpad('C.F. NEL DB',16,' ')||' '||rpad('C.F. RICALCOLATO',16,' ');
              insert_intestazione(d_riga,d_pagina,stringa,intestazione);
	        d_riga := d_riga+1;
           END IF;
	     INSERT into a_appoggio_stampe
		 VALUES ( prenotazione
                    , passo
                    , d_pagina
                    , d_riga
                    , rpad(CUR_NI1.ni,8,' ')||' '||rpad(nvl(CUR_NI1.cognome,' '),40,' ')||' '||rpad(nvl(CUR_NI1.nome,' '),36,' ')
                      ||' '||rpad(to_char(CUR_NI1.dal,'dd/mm/yyyy'),10,' ')||' '||rpad(D_CFIS,16,' ')||' '||rpad(D_CFIS1,16,' ')
		        );
	END IF;
   END IF; 
 END LOOP;
END;
END;
END;
/

