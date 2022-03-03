CREATE OR REPLACE PACKAGE CODICE_FISCALE IS 
/******************************************************************************
 NOME:        CODICE_FISCALE
 DESCRIZIONE: <Descrizione Package>

 ANNOTAZIONI: -  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    14/10/2002 __     Prima emissione.
******************************************************************************/
/******************************************************************************
 NOME:          P
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000             
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE CREA (P_COGNOME        in     varchar,
                P_NOME           in     varchar,
                P_DATA           in     date,
                P_CODICE_CATASTO in     varchar,
                P_SESSO          in     varchar,
                P_CODICE_FISCALE in out varchar);
				
FUNCTION CONTROLLO (P_CODICE_FISCALE  in char,
                    P_SESSO           in char,
                    P_CODICE_CATASTO  in char) 
  RETURN NUMBER;
				
END CODICE_FISCALE;
/

CREATE OR REPLACE PACKAGE BODY CODICE_FISCALE AS

/* Determinazione Codice Fiscale                              */
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
PROCEDURE CREA (P_COGNOME        in     varchar,
                P_NOME           in     varchar,
                P_DATA           in     date,
                P_CODICE_CATASTO in     varchar,
                P_SESSO          in     varchar,
                P_CODICE_FISCALE in out varchar) IS
        stringa_car       varchar(36) :=
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        pesi_pari         varchar(72) :=
'000102030405060708091011121314151617181920212223242500010203040506070809';
        pesi_dispari      varchar(72) :=
'010005070913151719210204182011030608121416102225242301000507091315171921';
        stringa_mesi      varchar(12) := 'ABCDEHLMPRST';
        codice_fiscale    varchar(16) := null;
        ind1              number;
        ind2              number;
        ind3              number;
        somma             number(3);
        quoziente         number(3);
        differenza        number(3);
        cod_catasto       varchar(4)  := P_CODICE_CATASTO;
        data              date     := P_DATA;
        sesso             varchar(1)  := P_SESSO;
        giorno            varchar(2);
        mese              varchar(2);
        anno              varchar(2);
        cognome           varchar(40) := P_COGNOME;
        nome              varchar(36) := P_NOME;
        cognome_cons      varchar(40) := null;
        cognome_voc       varchar(40) := null;
        nome_cons         varchar(36) := null;
        nome_voc          varchar(36) := null;
        char_123          varchar(3);
        char_456          varchar(3);
        char_9            varchar(1);
        char_check        varchar(1);
BEGIN
IF P_NOME           is not null AND
   P_DATA           is not null AND
   P_CODICE_CATASTO is not null AND
   P_SESSO          is not null THEN
BEGIN
/*                                                                */
/*              Ricerca consonanti e vocali nel cognome           */
/*              gli altri caratteri sono ignorati                 */
/*                                                                */
   ind2 := 0;
   ind3 := 0;
   FOR ind1 in 1..40 LOOP
      IF upper(substr(cognome,ind1,1)) in
         ('B','C','D','F','G','H','J','K','L','M','N','P','Q','R','S',
          'T','V','W','X','Y','Z') THEN
         ind2 := ind2 + 1;
         cognome_cons := substr(cognome_cons,1,length(cognome_cons))||
                         upper(substr(cognome,ind1,1));
      ELSIF
         upper(substr(cognome,ind1,1)) in
         ('A','E','I','O','U') THEN
         ind3 := ind3 + 1;
         cognome_voc := substr(cognome_voc,1,length(cognome_voc))||
                        upper(substr(cognome,ind1,1));
      END IF;
   END LOOP;
/*                                                                */
/*              Ricerca consonanti e vocali nel nome              */
/*              gli altri caratteri sono ignorati                 */
/*                                                                */
   ind2 := 0;
   ind3 := 0;
   FOR ind1 in 1..36 LOOP
      IF upper(substr(nome,ind1,1)) in
         ('B','C','D','F','G','H','J','K','L','M','N','P','Q','R','S',
          'T','V','W','X','Y','Z') THEN
         ind2 := ind2 + 1;
         nome_cons := substr(nome_cons,1,length(nome_cons))||
                      upper(substr(nome,ind1,1));
      ELSIF
         upper(substr(nome,ind1,1)) in
         ('A','E','I','O','U') THEN
         ind3 := ind3 + 1;
         nome_voc := substr(nome_voc,1,length(nome_voc))||
                     upper(substr(nome,ind1,1));
      END IF;
   END LOOP;
/*                                                           */
/*               Determinazione Caratteri del Cognome        */
/*                                                           */
   IF length(cognome_cons) > 2 THEN
      char_123 := substr(cognome_cons,1,3);
   ELSIF
      length(cognome_cons) = 2 and
      length(cognome_voc)  > 0 THEN
      char_123 := substr(cognome_cons,1,2)||substr(cognome_voc,1,1);
   ELSIF
      length(cognome_cons) = 1 and
      length(cognome_voc)  > 1 THEN
      char_123 := substr(cognome_cons,1,1)||substr(cognome_voc,1,2);
   ELSIF
      length(cognome_cons) = 1 and
      length(cognome_voc)  = 1 THEN
      char_123 := substr(cognome_cons,1,1)||substr(cognome_voc,1,1)||'X';
   ELSIF
      length(cognome_cons) = 0 and
      length(cognome_voc)  > 1 THEN
      char_123 := substr(cognome_voc,1,2)||'X';
   ELSE
      char_123 := 'XXX';
   END IF;
/*                                                           */
/*               Determinazione Caratteri del Nome           */
/*                                                           */
   IF length(nome_cons) > 3 THEN
      char_456 := substr(nome_cons,1,1)||substr(nome_cons,3,2);
   ELSIF
      length(nome_cons) = 3 THEN
      char_456 := substr(nome_cons,1,3);
   ELSIF
      length(nome_cons) = 2 and
      length(nome_voc)  > 0 THEN
      char_456 := substr(nome_cons,1,2)||substr(nome_voc,1,1);
   ELSIF
      length(nome_cons) = 1 and
      length(nome_voc)  > 1 THEN
      char_456 := substr(nome_cons,1,1)||substr(nome_voc,1,2);
   ELSIF
      length(nome_cons) = 1 and
      length(nome_voc)  = 1 THEN
      char_456 := substr(nome_cons,1,1)||substr(nome_voc,1,1)||'X';
   ELSIF
      length(nome_cons) = 0 and
      length(nome_voc)  > 1 THEN
      char_456 := substr(nome_voc,1,2)||'X';
   ELSE
      char_456 := 'XXX';
   END IF;
/*                                                           */
/*      Determinazione Anno, Carattere del Mese, Giorno      */
/*                                                           */
   giorno := substr(to_char(data,'dd/mm/yyyy'),1,2);
   mese   := substr(to_char(data,'dd/mm/yyyy'),4,2);
   anno   := substr(to_char(data,'dd/mm/yyyy'),9,2);
   char_9 := substr(stringa_mesi,to_number(mese),1);
   IF sesso = 'F' THEN
      giorno := to_char(to_number(giorno) + 40);
   END IF;
/*                                                           */
/*      Costruzione del Codice Fiscale                       */
/*                                                           */
   codice_fiscale := char_123||char_456||anno||char_9||
                     giorno||cod_catasto;
/*                                                           */
/*      Calcolo del Check (ultimo carattere del codice)      */
/*                                                           */
   somma := 0;
   FOR ind1 in 1..15 LOOP
      ind2 := 1;
      WHILE substr(codice_fiscale,ind1,1) !=
            substr(stringa_car,ind2,1) LOOP
         ind2 := ind2+1;
      END LOOP;
      IF trunc(ind1 / 2) * 2 = ind1 THEN
       somma := somma+to_number(substr(pesi_pari,(ind2-1)
                *2+1,2));
      ELSE
       somma := somma+to_number(substr(pesi_dispari,(ind2-1)
                *2+1,2));
      END IF;
   END LOOP;
   quoziente  := trunc(somma / 26);
   differenza := somma-quoziente*26;
   ind2 := 1;
   WHILE to_number(substr(pesi_pari,(ind2-1)*2+1,2)) != differenza
   LOOP
      ind2 := ind2+1;
   END LOOP;
/*                                              */
/*    Assegnazione del Check al Codice Fiscale  */
/*                                              */
   codice_fiscale := substr(codice_fiscale,1,length(codice_fiscale))||
                     substr(stringa_car,ind2,1);
   P_CODICE_FISCALE := codice_fiscale;
END;
END IF;
END;

/* Controllo del Codice Fiscale e della Partita Iva                   */
 FUNCTION CONTROLLO (P_CODICE_FISCALE  in char,
                     P_SESSO           in char,
                     P_CODICE_CATASTO  in char) 
   RETURN NUMBER IS
        stringa_car       varchar(36) :=
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        pesi_pari         varchar(72) :=
'000102030405060708091011121314151617181920212223242500010203040506070809';
        pesi_dispari      varchar(72) :=
'010005070913151719210204182011030608121416102225242301000507091315171921';
        codice_fiscale    varchar(16) := ltrim(rtrim(p_codice_fiscale));
        indice_confronto  number;
        somma             number(3);
        quoziente         number(3);
        differenza        number(3);
        cod_catasto       varchar(4)  := p_codice_catasto;
        giorno            number(2);
        mese              number(2);
        anno              number(2);
        CODICE_NON_VALIDO exception;
BEGIN
IF codice_fiscale != 'XXXXXXXXXXXXXXXX' THEN
 BEGIN
  IF length(codice_fiscale) not in (11,16) THEN
     RAISE CODICE_NON_VALIDO;
  END IF;
  IF length(codice_fiscale) = 16 THEN
   BEGIN
    FOR indice_codice IN 1..16 LOOP
       IF indice_codice in (7,8,10,11,13,14,15) THEN
          IF substr(codice_fiscale,indice_codice,1) = 'L' THEN
             codice_fiscale := substr(codice_fiscale,1,indice_codice-1)
             ||'0'
             ||substr(codice_fiscale,indice_codice+1,16-indice_codice);
          ELSIF
             substr(codice_fiscale,indice_codice,1) = 'M' THEN
             codice_fiscale := substr(codice_fiscale,1,indice_codice-1)
             ||'1'
             ||substr(codice_fiscale,indice_codice+1,16-indice_codice);
          ELSIF
             substr(codice_fiscale,indice_codice,1) = 'N' THEN
             codice_fiscale := substr(codice_fiscale,1,indice_codice-1)
             ||'2'
             ||substr(codice_fiscale,indice_codice+1,16-indice_codice);
          ELSIF
             substr(codice_fiscale,indice_codice,1) = 'P' THEN
             codice_fiscale := substr(codice_fiscale,1,indice_codice-1)
             ||'3'
             ||substr(codice_fiscale,indice_codice+1,16-indice_codice);
          ELSIF
             substr(codice_fiscale,indice_codice,1) = 'Q' THEN
             codice_fiscale := substr(codice_fiscale,1,indice_codice-1)
             ||'4'
             ||substr(codice_fiscale,indice_codice+1,16-indice_codice);
          ELSIF
             substr(codice_fiscale,indice_codice,1) = 'R' THEN
             codice_fiscale := substr(codice_fiscale,1,indice_codice-1)
             ||'5'
             ||substr(codice_fiscale,indice_codice+1,16-indice_codice);
          ELSIF
             substr(codice_fiscale,indice_codice,1) = 'S' THEN
             codice_fiscale := substr(codice_fiscale,1,indice_codice-1)
             ||'6'
             ||substr(codice_fiscale,indice_codice+1,16-indice_codice);
          ELSIF
             substr(codice_fiscale,indice_codice,1) = 'T' THEN
             codice_fiscale := substr(codice_fiscale,1,indice_codice-1)
             ||'7'
             ||substr(codice_fiscale,indice_codice+1,16-indice_codice);
          ELSIF
             substr(codice_fiscale,indice_codice,1) = 'U' THEN
             codice_fiscale := substr(codice_fiscale,1,indice_codice-1)
             ||'8'
             ||substr(codice_fiscale,indice_codice+1,16-indice_codice);
          ELSIF
             substr(codice_fiscale,indice_codice,1) = 'V' THEN
             codice_fiscale := substr(codice_fiscale,1,indice_codice-1)
             ||'9'
             ||substr(codice_fiscale,indice_codice+1,16-indice_codice);
          END IF;
       END IF;
       IF indice_codice in (1,2,3,4,5,6,12,16) and
          substr(codice_fiscale,indice_codice,1) not between 'A' and 'Z'
       or indice_codice in (7,8,10,11,13,14,15) and
          substr(codice_fiscale,indice_codice,1) not between '0' and '9'
       or indice_codice = 9 and substr(codice_fiscale,indice_codice,1)
          not in ('A','B','C','D','E','H','L','M','P','R','S','T')
       THEN
          RAISE CODICE_NON_VALIDO;
       END IF;
    END LOOP;
   END;
   BEGIN
    IF cod_catasto != substr(codice_fiscale,12,4) THEN
       RAISE CODICE_NON_VALIDO;
    END IF;
    giorno := to_number(substr(codice_fiscale,10,2));
    select decode(substr(codice_fiscale,9,1),
           'A',01,'B',02,'C',03,'D',04,'E',05,'H',06,
           'L',07,'M',08,'P',09,'R',10,'S',11,'T',12)
      into mese
      from dual;
    anno   := to_number(substr(codice_fiscale,7,2));
    IF p_sesso = 'F' THEN
       giorno := giorno-40;
    END IF;
    IF giorno not between 1 and 31 THEN
       RAISE CODICE_NON_VALIDO;
    END IF;
    IF giorno >
    to_number(to_char(last_day(to_date('01/'||to_char(mese)||'/'
                                           ||to_char(anno)
                                      ,'dd/mm/yyyy')
                              )
                     ,'dd')
             )
    THEN
       RAISE CODICE_NON_VALIDO;
    END IF;
    somma := 0;
    FOR indice_codice in 1..15 LOOP
       indice_confronto := 1;
       WHILE substr(codice_fiscale,indice_codice,1) !=
             substr(stringa_car,indice_confronto,1) LOOP
          indice_confronto := indice_confronto+1;
       END LOOP;
       IF trunc(indice_codice / 2) * 2 = indice_codice THEN
        somma := somma+to_number(substr(pesi_pari,(indice_confronto-1)
                 *2+1,2));
       ELSE
        somma := somma+to_number(substr(pesi_dispari,(indice_confronto-1)
                 *2+1,2));
       END IF;
    END LOOP;
    quoziente  := trunc(somma / 26);
    differenza := somma-quoziente*26;
    indice_confronto := 1;
    WHILE substr(pesi_pari,(indice_confronto-1)*2+1,2) !=
          lpad(to_char(differenza),2,'0')
    LOOP
       indice_confronto := indice_confronto+1;
    END LOOP;
    IF substr(stringa_car,indice_confronto,1) !=
       substr(codice_fiscale,16,1)               THEN
       RAISE CODICE_NON_VALIDO;
    END IF;
   END;
  ELSE
   BEGIN
    FOR indice_codice in 1..11 LOOP
     IF substr(codice_fiscale,indice_codice,1) not between '0' and '9'
     THEN
        RAISE CODICE_NON_VALIDO;
     END IF;
    END LOOP;
    somma := 0;
    FOR indice_codice in 1..10 LOOP
     IF indice_codice in (2,4,6,8,10) THEN
        quoziente := to_number(substr( codice_fiscale
                                     , indice_codice, 1
                                     )
                              ) * 2;
                    /* quoziente utilizzato come dato di deposito */
        somma     := somma
                   + to_number(substr( lpad(to_char(quoziente),3)
                                     , 3, 1
                                     )
                              );
        IF quoziente >= 10 THEN
           somma  := somma + 1;
        END IF;
     ELSE
        somma     := somma +
                     to_number(substr(codice_fiscale,indice_codice,1));
     END IF;
    END LOOP;
    differenza := 10 - to_number(substr( lpad(to_char(somma),3)
                                       , 3, 1
                                       )
                                );
    IF differenza = 10 THEN
       differenza := 0;
    END IF;
    IF differenza != to_number(substr(codice_fiscale,11,1))  THEN
-- dbms_output.put_line('PASSO');
       RAISE CODICE_NON_VALIDO;
    END IF;
   END;
  END IF;
      return 0;
 EXCEPTION
 WHEN CODICE_NON_VALIDO THEN
      return -1;
--    RAISE FORM_TRIGGER_FAILURE;
 WHEN OTHERS THEN null;
 END;
END IF;
      return 0;
END;

END CODICE_FISCALE;
/* End Package Body: CODICE_FISCALE */
/


 

