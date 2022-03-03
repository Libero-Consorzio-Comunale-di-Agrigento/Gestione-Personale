CREATE OR REPLACE PACKAGE PGMICELO IS
PROCEDURE MAIN		(P_PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY PGMICELO IS
	   procedure main (p_prenotazione in number,
	   			 	   passo in number) is
	   begin
	   DECLARE
  P_certificato  VARCHAR2(4);
  P_ci           number;
  P_ni           number;
  D_larg_note    number;
  D_i                   number;
  D_pass                number := 1;
  dep_carattere         number;
  dep_prenotazione      number(6);
  dep_progressivo       number := 0;
  D_descrizione         VARCHAR2(250);
  dep_testo             VARCHAR2(32000);
  BEGIN -- Estrazione Parametri di Selezione della Prenotazione
  BEGIN -- Estrazione Parametri di Selezione della Prenotazione
      select valore , no_prenotazione
        into P_certificato, dep_prenotazione
        from a_parametri
       where no_prenotazione = p_prenotazione
         and parametro       = 'P_CERTIFICATO'
      ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    FOR CURS_CERT IN
       (select ci
             , lung_riga       lung_riga
             , progressivo     progressivo
             , decorrenza      decorrenza
             , dal             dal
             , al              al
             , rientri         rientri
             , testo           testo
          from appoggio_certificati
         where prenotazione = dep_prenotazione
         order by progressivo
       ) LOOP
          BEGIN
          dep_carattere := 1;
          LOOP
            dep_testo := CURS_CERT.testo;
            D_i :=nvl(instr(substr(CURS_CERT.testo
                                  ,dep_carattere,CURS_CERT.lung_riga)
                           ,chr(10)),0);
       IF rpad(nvl(dep_testo,' '),CURS_CERT.lung_riga,' ')
        = rpad(' ',CURS_CERT.lung_riga,' ')
          THEN D_i := 2;
               D_descrizione := dep_testo;
          ELSIF D_i = 0
                THEN D_i := CURS_CERT.lung_riga;
                     IF dep_carattere+CURS_CERT.lung_riga-1
                        < LENGTH(dep_testo)
                        THEN FOR i IN REVERSE 1..CURS_CERT.lung_riga LOOP
                             IF substr(dep_testo,dep_carattere+i,1) = ' '
                                THEN D_i := i+1;
                                     EXIT;
                             END IF;
                             END LOOP;
                     END IF;
                ELSE IF D_i = 1
                        THEN D_i := 0;
                     END IF;
       END IF;
            IF D_i > 0 THEN
               D_descrizione := rtrim(replace(substr(dep_testo,
                                                     dep_carattere,D_i),
                                              chr(10),null));
               dep_progressivo := dep_progressivo + 1;
               insert into cert_long
                     (prenotazione,riga_cert,progressivo,ci,decorrenza
                     ,dal,al,descrizione,terminale)
               values(dep_prenotazione,
                      CURS_CERT.progressivo,
                      dep_progressivo,
                      CURS_CERT.ci,
                      decode(D_pass
                            , 1, CURS_CERT.decorrenza
                               , null),
                      decode(D_pass
                            , 1, CURS_CERT.dal
                               , null),
                      decode(D_pass
                            , 1, CURS_CERT.al
                               , null),
                      decode( CURS_CERT.rientri
                            , null, null
                                  , lpad(' ',CURS_CERT.rientri,' '))||
                      D_descrizione,
                      null);
               D_pass := 0;
               IF CURS_CERT.lung_riga >= nvl(length(dep_testo),1)
                  THEN dep_carattere := CURS_CERT.lung_riga + D_i;
                  ELSE dep_carattere := dep_carattere + D_i;
               END IF;
            ELSE
              dep_carattere := dep_carattere + 1;
            END IF;
            IF dep_carattere >= nvl(LENGTH(dep_testo),1) THEN
              D_pass := 1;
              EXIT;
            END IF;
               dep_progressivo := dep_progressivo+1;
           END LOOP;
          END;
        END LOOP;
  commit;
END;
END;
end;
end;
/

