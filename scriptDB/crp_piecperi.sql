CREATE OR REPLACE PACKAGE PIECPERI IS
/******************************************************************************
 NOME:          PIECADAE CREAZIONE DATI REPLICA

 DESCRIZIONE:   
	Procedura allinea nelle opportune tabelle i dati registrati nell'ambiente Esterno

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    09/10/2003
******************************************************************************/

FUNCTION VERSIONE              
    RETURN varchar2;

PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY PIECPERI IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 10/11/2003';
   END VERSIONE;

PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
  BEGIN
    DECLARE
      w_errore       number :=0;
      w_messaggio    varchar2(100) := null;
      contaerrori    number :=0;
      D_dummy        VARCHAR2(1);
      p_tabella      VARCHAR2(30);
      w_stringa      varchar(32000);
      w_stringa1     varchar(32000):= '(';
      w_stringa2     varchar(32000);
      w_stringa3     varchar(32000);
    BEGIN
      BEGIN
        select valore
          into p_tabella
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'P_TABELLA'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_tabella := ' ';
      END;
      BEGIN
        select 'x'   
          into D_dummy
          from dual
         where exists (select 'x'
                         from user_tab_columns
                        where table_name = upper(p_tabella)
                          and column_name = 'DAL'
                      )
        ;
        FOR CUR_COL IN (
        select column_name
          from user_tab_columns
         where table_name  = upper(p_tabella)
           and column_name not in ('DAL','AL','UTENTE','DATA_AGG')
         order by column_id
        ) LOOP
          w_stringa  := w_stringa||'#'||CUR_COL.column_name;
          w_stringa1 := w_stringa1||'||'||'''#'''||'||'||CUR_COL.column_name;
        END LOOP;
        w_stringa := w_stringa||'#';
        w_stringa1 := replace(w_stringa1,'(||',' ');
        w_stringa1 := w_stringa1||'||'||'''#''';
        BEGIN
          w_stringa2 := 'begin update '||p_tabella||' set al = pie_Periodo.get_ultimo ('||''''||p_tabella||''''||',''DAL'',
                          ''AL'',al,'||''''||w_stringa||''''||','||w_stringa1;
          w_stringa3 := ') where pie_periodo.is_primo ('||''''||p_tabella||''''||',''DAL''
                          ,dal,'||''''||w_stringa||''''||','||w_stringa1||') = 1; end;';
          si4.sql_execute('begin update '||p_tabella||' set al = pie_Periodo.get_ultimo ('||''''||p_tabella||''''||',''DAL'',
                          ''AL'',al,'||''''||w_stringa||''''||','||w_stringa1||') where pie_periodo.is_primo ('||''''||p_tabella||''''||',''DAL''
                          ,dal,'||''''||w_stringa||''''||','||w_stringa1||') = 1; end;');

        EXCEPTION
          WHEN OTHERS THEN
          contaerrori := contaerrori +1;
          w_messaggio := SQLERRM;
          insert into a_segnalazioni_errore
	      ( NO_PRENOTAZIONE,
		  PASSO,
		  PROGRESSIVO,
		  ERRORE,
		  PRECISAZIONE
		 ) values
		 ( prenotazione,
		   passo,
               contaerrori,
 		   'A08517',
		   w_messaggio
 		 );
        END;
        BEGIN
          si4.sql_execute('begin delete '||p_tabella||' where pie_periodo.is_primo ('||''''||p_tabella||''''||',''AL''
                          ,dal,'||''''||w_stringa||''''||','||w_stringa1||') = 0; end;');
        EXCEPTION
          WHEN OTHERS THEN
          contaerrori := contaerrori +1;
          w_messaggio := SQLERRM;
          insert into a_segnalazioni_errore
	      ( NO_PRENOTAZIONE,
		  PASSO,
		  PROGRESSIVO,
		  ERRORE,
		  PRECISAZIONE
		 ) values
		 ( prenotazione,
		   passo,
               contaerrori,
 		   'A08517',
		   w_messaggio
 		 );
        END;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          null;
      END; 
    END;
  END;
END;
/