-- CREATE OR REPLACE PACKAGE CHK_CFIS IS
-- PROCEDURE MAIN (PRENOTAZIONE IN NUMBER
--                ,PASSO        IN NUMBER);
-- END;
-- /
-- 
-- CREATE OR REPLACE PACKAGE BODY CHK_CFIS IS
-- PROCEDURE MAIN(prenotazione IN NUMBER, passo IN NUMBER) IS
-- FUNCTION CODICE_FISCALE (P_COGNOME        in     anagrafici.cognome%type,
--                          P_NOME           in     anagrafici.nome%type,
--                          P_DATA           in     date,
--                          P_CODICE_CATASTO in     comuni.codice_catasto%type,
--                          P_SESSO          in     anagrafici.sesso%type,
--                          P_CODICE_FISCALE out    varchar2)
-- RETURN varchar2 IS
-- BEGIN
-- 	    DECLARE
--         stringa_car       varchar2(36) :=
--         'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
--         pesi_pari         varchar2(72) :=
-- '000102030405060708091011121314151617181920212223242500010203040506070809';
--         pesi_dispari      varchar2(72) :=
-- '010005070913151719210204182011030608121416102225242301000507091315171921';
--         stringa_mesi      varchar2(12) := 'ABCDEHLMPRST';
--         codice_fiscale    varchar2(16) := null;
--         ind1              number;
--         ind2              number;
--         ind3              number;
--         somma             number(3);
--         quoziente         number(3);
--         differenza        number(3);
--         cod_catasto       varchar2(4)  := P_CODICE_CATASTO;
--         data              date     := P_DATA;
--         sesso             varchar2(1)  := P_SESSO;
--         giorno            varchar2(2);
--         mese              varchar2(2);
--         anno              varchar2(2);
--         cognome           varchar2(40) := P_COGNOME;
--         nome              varchar2(36) := P_NOME;
--         cognome_cons      varchar2(40) := null;
--         cognome_voc       varchar2(40) := null;
--         nome_cons         varchar2(36) := null;
--         nome_voc          varchar2(36) := null;
--         char_123          varchar2(3);
--         char_456          varchar2(3);
--         char_9            varchar2(1);
--         char_check        varchar2(1);
-- BEGIN
-- IF P_NOME           is not null AND
--    P_DATA           is not null AND
--    P_CODICE_CATASTO is not null AND
--    P_SESSO          is not null THEN
-- BEGIN
--    ind2 := 0;
--    ind3 := 0;
--    FOR ind1 in 1..40 LOOP
--       IF upper(substr(cognome,ind1,1)) in
--          ('B','C','D','F','G','H','J','K','L','M','N','P','Q','R','S',
--           'T','V','W','X','Y','Z') THEN
--          ind2 := ind2 + 1;
--          cognome_cons := substr(cognome_cons,1,length(cognome_cons))||
--                          upper(substr(cognome,ind1,1));
--       ELSIF
--          upper(substr(cognome,ind1,1)) in
--          ('A','E','I','O','U') THEN
--          ind3 := ind3 + 1;
--          cognome_voc := substr(cognome_voc,1,length(cognome_voc))||
--                         upper(substr(cognome,ind1,1));
--       END IF;
--    END LOOP;
--    ind2 := 0;
--    ind3 := 0;
--    FOR ind1 in 1..36 LOOP
--       IF upper(substr(nome,ind1,1)) in
--          ('B','C','D','F','G','H','J','K','L','M','N','P','Q','R','S',
--           'T','V','W','X','Y','Z') THEN
--          ind2 := ind2 + 1;
--          nome_cons := substr(nome_cons,1,length(nome_cons))||
--                       upper(substr(nome,ind1,1));
--       ELSIF
--          upper(substr(nome,ind1,1)) in
--          ('A','E','I','O','U') THEN
--          ind3 := ind3 + 1;
--          nome_voc := substr(nome_voc,1,length(nome_voc))||
--                      upper(substr(nome,ind1,1));
--       END IF;
--    END LOOP;
--    IF length(cognome_cons) > 2 THEN
--       char_123 := substr(cognome_cons,1,3);
--    ELSIF
--       length(cognome_cons) = 2 and
--       length(cognome_voc)  > 0 THEN
--       char_123 := substr(cognome_cons,1,2)||substr(cognome_voc,1,1);
--    ELSIF
--       length(cognome_cons) = 1 and
--       length(cognome_voc)  > 1 THEN
--       char_123 := substr(cognome_cons,1,1)||substr(cognome_voc,1,2);
--    ELSIF
--       length(cognome_cons) = 1 and
--       length(cognome_voc)  = 1 THEN
--       char_123 := substr(cognome_cons,1,1)||substr(cognome_voc,1,1)||'X';
--    ELSIF
--       length(cognome_cons) = 0 and
--       length(cognome_voc)  > 1 THEN
--       char_123 := substr(cognome_voc,1,2)||'X';
--    ELSE
--       char_123 := 'XXX';
--    END IF;
--    IF length(nome_cons) > 3 THEN
--       char_456 := substr(nome_cons,1,1)||substr(nome_cons,3,2);
--    ELSIF
--       length(nome_cons) = 3 THEN
--       char_456 := substr(nome_cons,1,3);
--    ELSIF
--       length(nome_cons) = 2 and
--       length(nome_voc)  > 0 THEN
--       char_456 := substr(nome_cons,1,2)||substr(nome_voc,1,1);
--    ELSIF
--       length(nome_cons) = 1 and
--       length(nome_voc)  > 1 THEN
--       char_456 := substr(nome_cons,1,1)||substr(nome_voc,1,2);
--    ELSIF
--       length(nome_cons) = 1 and
--       length(nome_voc)  = 1 THEN
--       char_456 := substr(nome_cons,1,1)||substr(nome_voc,1,1)||'X';
--    ELSIF
--       length(nome_cons) = 0 and
--       length(nome_voc)  > 1 THEN
--       char_456 := substr(nome_voc,1,2)||'X';
--    ELSE
--       char_456 := 'XXX';
--    END IF;
--    giorno := substr(to_char(data,'dd/mm/yyyy'),1,2);
--    mese   := substr(to_char(data,'dd/mm/yyyy'),4,2);
--    anno   := substr(to_char(data,'dd/mm/yyyy'),9,2);
--    char_9 := substr(stringa_mesi,to_number(mese),1);
--    IF sesso = 'F' THEN
--       giorno := to_char(to_number(giorno) + 40);
--    END IF;
--    codice_fiscale := char_123||char_456||anno||char_9||
--                      giorno||cod_catasto;
--    somma := 0;
--    FOR ind1 in 1..15 LOOP
--       ind2 := 1;
--       WHILE substr(codice_fiscale,ind1,1) !=
--             substr(stringa_car,ind2,1) LOOP
--          ind2 := ind2+1;
--       END LOOP;
--       IF trunc(ind1 / 2) * 2 = ind1 THEN
--        somma := somma+to_number(substr(pesi_pari,(ind2-1)
--                 *2+1,2));
--       ELSE
--        somma := somma+to_number(substr(pesi_dispari,(ind2-1)
--                 *2+1,2));
--       END IF;
--    END LOOP;
--    quoziente  := trunc(somma / 26);
--    differenza := somma-quoziente*26;
--    ind2 := 1;
--    WHILE to_number(substr(pesi_pari,(ind2-1)*2+1,2)) != differenza
--    LOOP
--       ind2 := ind2+1;
--    END LOOP;
--    codice_fiscale := substr(codice_fiscale,1,length(codice_fiscale))||
--                      substr(stringa_car,ind2,1);
--    P_CODICE_FISCALE := codice_fiscale;
-- END;
-- END IF;
-- END;
-- 	RETURN P_codice_fiscale;
-- END CODICE_FISCALE;
-- BEGIN
-- DECLARE
-- D_COGNOME anagrafici.cognome%type;
-- D_NOME anagrafici.nome%type;
-- D_DATA anagrafici.data_nas%type;
-- D_COD_CATASTO varchar2(4);
-- D_CFIS        varchar2(16);
-- D_CFIS1       varchar2(16);
-- D_PAGINA      number := 1; 
-- D_RIGA        number := 0;
-- BEGIN
-- FOR CUR_NI IN (select ni, dal, comune_nas, provincia_nas,sesso,
--             cognome, nome, codice_fiscale,data_nas
-- 		    from anagrafici
-- 		   order by ni
-- 		   )
--    LOOP
-- 	BEGIN
--   d_cfis := cur_ni.codice_fiscale;
--   d_cod_catasto := to_char(null);
-- 	select nvl(codice_catasto,'XXXX')
-- 	  into D_COD_CATASTO
-- 	 from comuni
-- 	where cod_comune = CUR_NI.comune_nas
-- 	  and cod_provincia  = CUR_NI.provincia_nas;
-- 	EXCEPTION
-- 	   WHEN NO_DATA_FOUND THEN
-- 	     d_riga := d_riga+1;
-- 	     INSERT into a_appoggio_stampe
-- 		 VALUES ( prenotazione
--         		, passo
-- 		        , d_pagina
-- 		       	, d_riga
-- 		       	, 'VERIFICARE COMUNE NASCITA: '||CUR_NI.cognome||' '||CUR_NI.nome||' '||CUR_NI.ni||'  DAL: '||CUR_NI.dal
-- 		        );
-- 	            --dbms_output.put_line('VERIFICARE COMUNE NASCITA: '||CUR_NI.cognome||' '||CUR_NI.nome||' '||CUR_NI.ni||'  DAL: '||CUR_NI.dal);
-- 	END;
--   if d_cod_catasto is not null then
-- 	D_CFIS1 := codice_fiscale(cur_ni.COGNOME,cur_ni.NOME,cur_ni.DATA_nas,
--   D_COD_CATASTO,cur_ni.sesso,cur_ni.codice_fiscale);
-- 	IF D_CFIS != D_CFIS1 then
-- 	  d_riga := d_riga+1;
-- 	     INSERT into a_appoggio_stampe
-- 		 VALUES ( prenotazione
--         		, passo
-- 		        , d_pagina
-- 		       	, d_riga
-- 		       	, 'CODICE FISCALE ERRATO: '||CUR_NI.cognome||' '||CUR_NI.nome||' '||CUR_NI.ni||'  DAL: '||CUR_NI.dal||' cf: nel db ' || D_CFIS|| ' -  calcolato ' || D_CFIS1
-- 		        );
-- 	            --dbms_output.put_line('CODICE FISCALE ERRATO: '||CUR_NI.cognome||' '||CUR_NI.nome||' '||CUR_NI.ni||'  DAL: '||CUR_NI.dal);
--                 --dbms_output.put_line(' cf: nel db ' || D_CFIS|| ' -  calcolato ' || D_CFIS1);
-- 	END IF;
--   end if;
--    END LOOP;
-- END;
-- END;
-- END;
-- /
-- 