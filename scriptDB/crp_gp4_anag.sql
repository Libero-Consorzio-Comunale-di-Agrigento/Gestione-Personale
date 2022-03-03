CREATE OR REPLACE PACKAGE gp4_anag IS
/******************************************************************************
 NOME:        GP4_ANAG
 DESCRIZIONE: <Descrizione Package>

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    04/12/2002 __     Prima emissione.
 1    16/01/2006 MM     Modifiche alla get_denominazione
 2    17/05/2007 CB     Gestione caratteri speciali in indirizzo 
 2.1  28/06/2007 CB 
 2.2  11/0772007 CB     A19798.2    
******************************************************************************/
   FUNCTION get_nome_componenti (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_nome_componenti, WNDS, WNPS);

   FUNCTION get_cognome_componenti (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_cognome_componenti, WNDS, WNPS);

   FUNCTION versione
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (versione, WNDS, WNPS);

   FUNCTION get_tipo_soggetto (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_tipo_soggetto, WNDS, WNPS);

   FUNCTION get_partita_iva (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_partita_iva, WNDS, WNPS);

   FUNCTION get_sesso (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_sesso, WNDS, WNPS);

   FUNCTION get_codice_fiscale (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_codice_fiscale, WNDS, WNPS);

   FUNCTION get_denominazione (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_denominazione, WNDS, WNPS);

   FUNCTION get_gruppo_ling (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_gruppo_ling, WNDS, WNPS);

   PROCEDURE controllo_codice_fiscale (
      p_codice_fiscale           IN       VARCHAR2
     ,p_sesso                    IN       VARCHAR2
     ,p_codice_catasto           IN       VARCHAR2
     ,p_errore                   OUT      VARCHAR2
     ,p_segnalazione             OUT      VARCHAR2
   );
   
   procedure CHK_INDIRIZZO(p_indirizzo in varchar2);
END gp4_anag;
/
CREATE OR REPLACE PACKAGE BODY gp4_anag AS
   FUNCTION versione
      RETURN VARCHAR2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
   BEGIN
      RETURN 'V2.2 del 11/07/2007';
   END versione;

--
   FUNCTION get_nome_componenti (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_nome_componente   VARCHAR2 (40);
/******************************************************************************
   NAME:       GET_NOME_COMPONENTE
   PURPOSE:    Restituire il nome del componente dell'U.O.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        24/07/2002          1. Created this function.

   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:  VARCHAR
   CALLED BY:
   CALLS:
   EXAMPLE USE:     VARCHAR := GET_NOME_COMPONENTE();
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:

******************************************************************************/
   BEGIN
      BEGIN
         SELECT anag.nome
           INTO d_nome_componente
           FROM anagrafe anag
          WHERE anag.ni = p_ni;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_nome_componente := 'ANAGRAFE NON PRESENTE';
            RETURN d_nome_componente;
         WHEN TOO_MANY_ROWS THEN
            d_nome_componente := 'ANAGRAFE NON PRESENTE';
            RETURN d_nome_componente;
      END;

      RETURN d_nome_componente;
   END get_nome_componenti;

--
   FUNCTION get_cognome_componenti (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_cognome_componente   VARCHAR2 (40);
/******************************************************************************
   NAME:       GET_COGNOME_COMPONENTI
   PURPOSE:    Restituire il cognome del componente dell'U.O.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        24/07/2002          1. Created this function.

   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:  VARCHAR
   CALLED BY:
   CALLS:
   EXAMPLE USE:     VARCHAR := GET_COGNOME_COMPONENTE();
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:

******************************************************************************/
   BEGIN
      BEGIN
         SELECT anag.cognome
           INTO d_cognome_componente
           FROM anagrafe anag
          WHERE anag.ni = p_ni;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_cognome_componente := 'ANAGRAFE NON PRESENTE';
            RETURN d_cognome_componente;
         WHEN TOO_MANY_ROWS THEN
            d_cognome_componente := 'ANAGRAFE NON PRESENTE';
            RETURN d_cognome_componente;
      END;

      RETURN d_cognome_componente;
   END get_cognome_componenti;

--
   FUNCTION get_tipo_soggetto (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_tipo_soggetto   VARCHAR2 (4);
/******************************************************************************
   NAME:       GET_TIPO_SOGGETTO
   PURPOSE:    Restituire il tipo soggetto(individuo o ente) del componente dell'U.O.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        24/07/2002          1. Created this function.

   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:  VARCHAR
   CALLED BY:
   CALLS:
   EXAMPLE USE:     VARCHAR := GET_TIPO_SOGGETTO();
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:

******************************************************************************/
   BEGIN
      BEGIN
         SELECT anag.tipo_soggetto
           INTO d_tipo_soggetto
           FROM anagrafe anag
          WHERE anag.ni = p_ni;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_tipo_soggetto  := TO_CHAR (NULL);
            RETURN d_tipo_soggetto;
         WHEN TOO_MANY_ROWS THEN
            d_tipo_soggetto  := TO_CHAR (NULL);
            RETURN d_tipo_soggetto;
      END;

      RETURN d_tipo_soggetto;
   END get_tipo_soggetto;

--
   FUNCTION get_partita_iva (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_partita_iva   VARCHAR2 (40);
/******************************************************************************
   NAME:       GET_PARTITA_IVA
   PURPOSE:    Restituire la partita iva dell'ente dell'U.O.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        24/07/2002          1. Created this function.


******************************************************************************/
   BEGIN
      BEGIN
         SELECT anag.partita_iva
           INTO d_partita_iva
           FROM anagrafe anag
          WHERE anag.ni = p_ni;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_partita_iva    := TO_CHAR (NULL);
            RETURN d_partita_iva;
         WHEN TOO_MANY_ROWS THEN
            d_partita_iva    := TO_CHAR (NULL);
            RETURN d_partita_iva;
      END;

      RETURN d_partita_iva;
   END get_partita_iva;

   FUNCTION get_sesso (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_sesso   VARCHAR2 (1);
/******************************************************************************
   NAME:       GET_SESSO
   PURPOSE:    Restituire il sesso dell'individuo

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        19/09/2006                   1. Created this function.


******************************************************************************/
   BEGIN
      BEGIN
         SELECT anag.sesso
           INTO d_sesso
           FROM anagrafe anag
          WHERE anag.ni = p_ni;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_sesso          := TO_CHAR (NULL);
            RETURN d_sesso;
         WHEN TOO_MANY_ROWS THEN
            d_sesso          := TO_CHAR (NULL);
            RETURN d_sesso;
      END;

      RETURN d_sesso;
   END get_sesso;

   FUNCTION get_codice_fiscale (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_codice_fiscale   VARCHAR2 (16);
/******************************************************************************
   NAME:       GET_PARTITA_IVA
   PURPOSE:    Restituire la partita iva dell'ente dell'U.O.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        24/07/2002          1. Created this function.

   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:  VARCHAR
   CALLED BY:
   CALLS:
   EXAMPLE USE:     VARCHAR := GET_PARTITA_IVA);
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:

******************************************************************************/
   BEGIN
      BEGIN
         SELECT anag.codice_fiscale
           INTO d_codice_fiscale
           FROM anagrafe anag
          WHERE anag.ni = p_ni;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_codice_fiscale := TO_CHAR (NULL);
            RETURN d_codice_fiscale;
         WHEN TOO_MANY_ROWS THEN
            d_codice_fiscale := TO_CHAR (NULL);
            RETURN d_codice_fiscale;
      END;

      RETURN d_codice_fiscale;
   END get_codice_fiscale;

--
   FUNCTION get_denominazione (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_denominazione   anagrafici.denominazione%TYPE;
/******************************************************************************
   NAME:       GET_DENOMINAZIONE
   PURPOSE:    Restituire la denominazione del soggetto anagrafico

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03/09/2002                   1. Created this function.
   1.1        16/01/2006                   Aggiunta select sul max(dal)

******************************************************************************/
   BEGIN
      BEGIN
         SELECT anag.denominazione
           INTO d_denominazione
           FROM anagrafici anag
          WHERE anag.ni = p_ni
            AND anag.dal = (SELECT MAX (dal)
                              FROM anagrafici
                             WHERE ni = p_ni);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_denominazione  := 'ANAGRAFE NON PRESENTE';
            RETURN d_denominazione;
         WHEN TOO_MANY_ROWS THEN
            d_denominazione  := 'ANAGRAFE DUPLICATA';
            RETURN d_denominazione;
      END;

      RETURN d_denominazione;
   END get_denominazione;

--
   FUNCTION get_gruppo_ling (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_gruppo_ling   anagrafici.gruppo_ling%TYPE;
/******************************************************************************
   NAME:       GET_DENOMINAZIONE
   PURPOSE:    Restituire il gruppo linguistico del soggetto anagrafico

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        09/02/2004                   1. Created this function.


******************************************************************************/
   BEGIN
      BEGIN
         SELECT anag.gruppo_ling
           INTO d_gruppo_ling
           FROM anagrafe anag
          WHERE anag.ni = p_ni;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_gruppo_ling    := 'X';
            RETURN d_gruppo_ling;
         WHEN TOO_MANY_ROWS THEN
            d_gruppo_ling    := 'X';
            RETURN d_gruppo_ling;
      END;

      RETURN d_gruppo_ling;
   END get_gruppo_ling;

--
   PROCEDURE controllo_codice_fiscale (
      p_codice_fiscale           IN       VARCHAR2
     ,p_sesso                    IN       VARCHAR2
     ,p_codice_catasto           IN       VARCHAR2
     ,p_errore                   OUT      VARCHAR2
     ,p_segnalazione             OUT      VARCHAR2
   ) IS
      stringa_car         VARCHAR2 (36) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      pesi_pari           VARCHAR2 (72)
                      := '000102030405060708091011121314151617181920212223242500010203040506070809';
      pesi_dispari        VARCHAR2 (72)
                      := '010005070913151719210204182011030608121416102225242301000507091315171921';
      codice_fiscale      VARCHAR2 (16) := p_codice_fiscale;
      indice_confronto    NUMBER;
      somma               NUMBER (3);
      quoziente           NUMBER (3);
      differenza          NUMBER (3);
      cod_catasto         VARCHAR2 (4)  := p_codice_catasto;
      giorno              NUMBER (2);
      mese                NUMBER (2);
      anno                NUMBER (2);
      codice_non_valido   EXCEPTION;
/******************************************************************************
   NAME:       CONTROLLO_CODICE_FISCALE
   PURPOSE:    Controlla la correttezza del codice fiscale

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        21/08/2002          1. Created this procedure.

   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:  VARCHAR
   CALLED BY:
   CALLS:
   EXAMPLE USE:     VARCHAR :=
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:

******************************************************************************/
   BEGIN
      p_errore         := NULL;
      p_segnalazione   := NULL;

      IF codice_fiscale != 'XXXXXXXXXXXXXXXX' THEN
         BEGIN
            IF NVL (LENGTH (codice_fiscale), 0) NOT IN (11, 16) THEN
               RAISE codice_non_valido;
            END IF;

            IF NVL (LENGTH (codice_fiscale), 0) = 16 THEN
               BEGIN
                  FOR indice_codice IN 1 .. 16
                  LOOP
                     IF indice_codice IN (7, 8, 10, 11, 13, 14, 15) THEN
                        IF SUBSTR (codice_fiscale, indice_codice, 1) = 'L' THEN
                           codice_fiscale   :=
                                 SUBSTR (codice_fiscale, 1, indice_codice - 1)
                              || '0'
                              || SUBSTR (codice_fiscale, indice_codice + 1, 16 - indice_codice);
                        ELSIF SUBSTR (codice_fiscale, indice_codice, 1) = 'M' THEN
                           codice_fiscale   :=
                                 SUBSTR (codice_fiscale, 1, indice_codice - 1)
                              || '1'
                              || SUBSTR (codice_fiscale, indice_codice + 1, 16 - indice_codice);
                        ELSIF SUBSTR (codice_fiscale, indice_codice, 1) = 'N' THEN
                           codice_fiscale   :=
                                 SUBSTR (codice_fiscale, 1, indice_codice - 1)
                              || '2'
                              || SUBSTR (codice_fiscale, indice_codice + 1, 16 - indice_codice);
                        ELSIF SUBSTR (codice_fiscale, indice_codice, 1) = 'P' THEN
                           codice_fiscale   :=
                                 SUBSTR (codice_fiscale, 1, indice_codice - 1)
                              || '3'
                              || SUBSTR (codice_fiscale, indice_codice + 1, 16 - indice_codice);
                        ELSIF SUBSTR (codice_fiscale, indice_codice, 1) = 'Q' THEN
                           codice_fiscale   :=
                                 SUBSTR (codice_fiscale, 1, indice_codice - 1)
                              || '4'
                              || SUBSTR (codice_fiscale, indice_codice + 1, 16 - indice_codice);
                        ELSIF SUBSTR (codice_fiscale, indice_codice, 1) = 'R' THEN
                           codice_fiscale   :=
                                 SUBSTR (codice_fiscale, 1, indice_codice - 1)
                              || '5'
                              || SUBSTR (codice_fiscale, indice_codice + 1, 16 - indice_codice);
                        ELSIF SUBSTR (codice_fiscale, indice_codice, 1) = 'S' THEN
                           codice_fiscale   :=
                                 SUBSTR (codice_fiscale, 1, indice_codice - 1)
                              || '6'
                              || SUBSTR (codice_fiscale, indice_codice + 1, 16 - indice_codice);
                        ELSIF SUBSTR (codice_fiscale, indice_codice, 1) = 'T' THEN
                           codice_fiscale   :=
                                 SUBSTR (codice_fiscale, 1, indice_codice - 1)
                              || '7'
                              || SUBSTR (codice_fiscale, indice_codice + 1, 16 - indice_codice);
                        ELSIF SUBSTR (codice_fiscale, indice_codice, 1) = 'U' THEN
                           codice_fiscale   :=
                                 SUBSTR (codice_fiscale, 1, indice_codice - 1)
                              || '8'
                              || SUBSTR (codice_fiscale, indice_codice + 1, 16 - indice_codice);
                        ELSIF SUBSTR (codice_fiscale, indice_codice, 1) = 'V' THEN
                           codice_fiscale   :=
                                 SUBSTR (codice_fiscale, 1, indice_codice - 1)
                              || '9'
                              || SUBSTR (codice_fiscale, indice_codice + 1, 16 - indice_codice);
                        END IF;
                     END IF;

                     IF        indice_codice IN (1, 2, 3, 4, 5, 6, 12, 16)
                           AND SUBSTR (codice_fiscale, indice_codice, 1) NOT BETWEEN 'A' AND 'Z'
                        OR     indice_codice IN (7, 8, 10, 11, 13, 14, 15)
                           AND SUBSTR (codice_fiscale, indice_codice, 1) NOT BETWEEN '0' AND '9'
                        OR     indice_codice = 9
                           AND SUBSTR (codice_fiscale, indice_codice, 1) NOT IN
                                       ('A', 'B', 'C', 'D', 'E', 'H', 'L', 'M', 'P', 'R', 'S', 'T') THEN
                        RAISE codice_non_valido;
                     END IF;
                  END LOOP;
               END;

               BEGIN
                  IF cod_catasto != SUBSTR (codice_fiscale, 12, 4) THEN
                     RAISE codice_non_valido;
                  END IF;

                  giorno           := TO_NUMBER (SUBSTR (codice_fiscale, 10, 2) );

                  SELECT DECODE (SUBSTR (codice_fiscale, 9, 1)
                                ,'A', 01
                                ,'B', 02
                                ,'C', 03
                                ,'D', 04
                                ,'E', 05
                                ,'H', 06
                                ,'L', 07
                                ,'M', 08
                                ,'P', 09
                                ,'R', 10
                                ,'S', 11
                                ,'T', 12
                                )
                    INTO mese
                    FROM DUAL;

                  anno             := TO_NUMBER (SUBSTR (codice_fiscale, 7, 2) );

                  IF p_sesso = 'F' THEN
                     giorno           := giorno - 40;
                  END IF;

                  IF giorno NOT BETWEEN 1 AND 31 THEN
                     RAISE codice_non_valido;
                  END IF;

                  IF giorno >
                        TO_NUMBER (TO_CHAR (LAST_DAY (TO_DATE (   '01/'
                                                               || TO_CHAR (mese)
                                                               || '/'
                                                               || TO_CHAR (anno)
                                                              ,'dd/mm/yyyy'
                                                              )
                                                     )
                                           ,'dd'
                                           )
                                  ) THEN
                     RAISE codice_non_valido;
                  END IF;

                  somma            := 0;

                  FOR indice_codice IN 1 .. 15
                  LOOP
                     indice_confronto := 1;

                     WHILE SUBSTR (codice_fiscale, indice_codice, 1) !=
                                                          SUBSTR (stringa_car, indice_confronto, 1)
                     LOOP
                        indice_confronto := indice_confronto + 1;
                     END LOOP;

                     IF TRUNC (indice_codice / 2) * 2 = indice_codice THEN
                        somma            :=
                           somma
                           + TO_NUMBER (SUBSTR (pesi_pari, (indice_confronto - 1) * 2 + 1, 2) );
                     ELSE
                        somma            :=
                             somma
                           + TO_NUMBER (SUBSTR (pesi_dispari, (indice_confronto - 1) * 2 + 1, 2) );
                     END IF;
                  END LOOP;

                  quoziente        := TRUNC (somma / 26);
                  differenza       := somma - quoziente * 26;
                  indice_confronto := 1;

                  WHILE SUBSTR (pesi_pari, (indice_confronto - 1) * 2 + 1, 2) !=
                                                                 LPAD (TO_CHAR (differenza), 2, '0')
                  LOOP
                     indice_confronto := indice_confronto + 1;
                  END LOOP;

                  IF SUBSTR (stringa_car, indice_confronto, 1) != SUBSTR (codice_fiscale, 16, 1) THEN
                     RAISE codice_non_valido;
                  END IF;
               END;
            ELSE
               BEGIN
                  FOR indice_codice IN 1 .. 11
                  LOOP
                     IF SUBSTR (codice_fiscale, indice_codice, 1) NOT BETWEEN '0' AND '9' THEN
                        RAISE codice_non_valido;
                     END IF;
                  END LOOP;

                  somma            := 0;

                  FOR indice_codice IN 1 .. 10
                  LOOP
                     IF indice_codice IN (2, 4, 6, 8, 10) THEN
                        quoziente        :=
                                          TO_NUMBER (SUBSTR (codice_fiscale, indice_codice, 1) )
                                          * 2;
                        /* quoziente utilizzato come dato di deposito */
                        somma            :=
                                  somma + TO_NUMBER (SUBSTR (LPAD (TO_CHAR (quoziente), 3), 3, 1) );

                        IF quoziente >= 10 THEN
                           somma            := somma + 1;
                        END IF;
                     ELSE
                        somma            :=
                                     somma + TO_NUMBER (SUBSTR (codice_fiscale, indice_codice, 1) );
                     END IF;
                  END LOOP;

                  differenza       := 10 - TO_NUMBER (SUBSTR (LPAD (TO_CHAR (somma), 3), 3, 1) );

                  IF differenza = 10 THEN
                     differenza       := 0;
                  END IF;

                  IF differenza != TO_NUMBER (SUBSTR (codice_fiscale, 11, 1) ) THEN
                     RAISE codice_non_valido;
                  END IF;
               END;
            END IF;
         EXCEPTION
            WHEN codice_non_valido THEN
               p_errore         := 'P00520';
               p_segnalazione   := si4.get_error (p_errore);
--    RAISE FORM_TRIGGER_FAILURE;
            WHEN OTHERS THEN
               NULL;
         END;
      END IF;
   END controllo_codice_fiscale;
--
procedure CHK_INDIRIZZO(p_indirizzo in varchar2) is
p_posizione number;
p_trovato   number;
occorrenza_barra  number:=0;
occorrenza_punto  number:=0;
occorrenza_apice  number:=0;
posizione         number;
/******************************************************************************
   NAME:       CHK_INDIRIZZO
   PURPOSE:    Restituisce un msg d'errore se il campo p_indirizzo passato
               contiene dei caratteri non consentiti
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        20/02/2007               CB  Created this procedure
******************************************************************************/
begin
--caratteri non consentiti
begin
  select 1
  into   p_posizione
  from   dual
  where  instr(p_indirizzo,';') !=0
  or     instr(p_indirizzo,'!') !=0
  or     instr(p_indirizzo,'*') !=0
  or     instr(p_indirizzo,'=') !=0
  or     instr(p_indirizzo,'+') !=0
  or     instr(p_indirizzo,'"') !=0
  or     instr(p_indirizzo,'#') !=0
  or     instr(p_indirizzo,'$') !=0
  or     instr(p_indirizzo,'%') !=0
  or     instr(p_indirizzo,'&') !=0
  or     instr(p_indirizzo,':') !=0
  or     instr(p_indirizzo,'?') !=0
  or     instr(p_indirizzo,'\') !=0
  or     instr(p_indirizzo,'_') !=0
  or     instr(p_indirizzo,'^') !=0
  or     instr(p_indirizzo,'|') !=0
  or     instr(p_indirizzo,'°') !=0
  or     instr(p_indirizzo,'º') !=0
  or     instr(p_indirizzo,'(') !=0
  or     instr(p_indirizzo,')') !=0
  or     instr(p_indirizzo,'£') !=0
  or     instr(p_indirizzo,'$') !=0
  or     instr(p_indirizzo,'§') !=0
  or     instr(p_indirizzo,'€') !=0
 ;
  exception
  when no_data_found then null;
  end;
  if    p_posizione !=0 then
       raise_application_error(-20998,'Sono stati introdotti caratteri non consentiti');
  end if;
  
  --la barra è valida se preceduta da nr e seguita da nr o lettera
  for occorrenza_barra in 1..(length(p_indirizzo)-length(replace(p_indirizzo,'/',''))) loop
      posizione := instr(p_indirizzo,'/',1,occorrenza_barra);
      if posizione!=0 then
  	  begin
       select 1
       into   p_trovato
       from   dual
       where  (translate(substr(p_indirizzo,posizione+1,1),'0123456789','0000000000') = '0'
       and     translate(substr(p_indirizzo,posizione-1,1),'0123456789','0000000000') = '0'
       or      translate(substr(p_indirizzo,posizione+1,1),'ABCDEFGHILMNOPQRSTUVZXYWJK','AAAAAAAAAAAAAAAAAAAAAAAAAA') = 'A'
       and     translate(substr(p_indirizzo,posizione-1,1),'0123456789','0000000000') = '0'
  	  	      );
  exception when no_data_found then 
      raise_application_error(-20998,'Sono stati introdotti caratteri non utilizzati in modo corretto');
     end;
     end if;
  end loop;
  
  	-- il punto è valido se preceduto da lettera e seguito da lettera o spazio
	for occorrenza_punto in 1..(length(p_indirizzo)-length(replace(p_indirizzo,'.',''))) loop
      posizione := instr(p_indirizzo,'.',1,occorrenza_punto);
      if posizione!=0 then
  	  begin
       select 1
       into   p_trovato
       from   dual
       where  (translate(substr(p_indirizzo,posizione+1,1),' ','A') = 'A'
       and     translate(substr(p_indirizzo,posizione-1,1),'ABCDEFGHILMNOPQRSTUVZXYWJK','AAAAAAAAAAAAAAAAAAAAAAAAAA') = 'A'
       or      translate(substr(p_indirizzo,posizione+1,1),'ABCDEFGHILMNOPQRSTUVZXYWJK','AAAAAAAAAAAAAAAAAAAAAAAAAA') = 'A'
       and     translate(substr(p_indirizzo,posizione-1,1),'ABCDEFGHILMNOPQRSTUVZXYWJK','AAAAAAAAAAAAAAAAAAAAAAAAAA') = 'A'
          	 );
     exception when no_data_found then 
      raise_application_error(-20998,'Sono stati introdotti caratteri non utilizzati in modo corretto');
     end;
     end if;
  end loop;
  
  -- l'apice è valido se preceduto da lettera e seguito da spazio o lettera
  for occorrenza_apice in 1..(length(p_indirizzo)-length(replace(p_indirizzo,'apice',''))-4) loop
      posizione := instr(p_indirizzo,'apice',1,occorrenza_apice);
      if posizione!=0 then
  	  begin
       select 1
       into   p_trovato
       from   dual
       where  (translate(nvl(substr(p_indirizzo,posizione+5,1),' '),' ','A') = 'A'
     and     translate(substr(p_indirizzo,posizione-1,1),'ABCDEFGHILMNOPQRSTUVZXYWJK','AAAAAAAAAAAAAAAAAAAAAAAAAA') = 'A'
     or      translate(substr(p_indirizzo,posizione+5,1),'ABCDEFGHILMNOPQRSTUVZXYWJK','AAAAAAAAAAAAAAAAAAAAAAAAAA') = 'A'
     and     translate(substr(p_indirizzo,posizione-1,1),'ABCDEFGHILMNOPQRSTUVZXYWJK','AAAAAAAAAAAAAAAAAAAAAAAAAA') = 'A'
   /*  or      translate(substr(p_indirizzo,posizione+1,1),'0123456789','0000000000') = '0'
     and     translate(substr(p_indirizzo,posizione-1,1),'ABCDEFGHILMNOPQRSTUVZXYWJK','AAAAAAAAAAAAAAAAAAAAAAAAAA') = 'A'
     or      translate(substr(p_indirizzo,posizione+1,1),'0123456789','0000000000') = '0'
     and     translate(substr(p_indirizzo,posizione-1,1),'0123456789','0000000000') = '0'
     or      translate(substr(p_indirizzo,posizione+1,1),'ABCDEFGHILMNOPQRSTUVZXYWJK','AAAAAAAAAAAAAAAAAAAAAAAAAA') = 'A'
     and     translate(substr(p_indirizzo,posizione-1,1),'0123456789','0000000000') = '0'*/
  	  	      );
     exception when no_data_found then 
      raise_application_error(-20998,'Sono stati introdotti caratteri non utilizzati in modo corretto');
     end;
     end if;
  end loop;
	
end;
--
END gp4_anag;
/* End Package Body: GP4_ANAG */
/



