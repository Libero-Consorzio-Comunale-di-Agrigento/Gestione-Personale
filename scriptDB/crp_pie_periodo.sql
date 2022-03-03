CREATE OR REPLACE PACKAGE Pie_Periodo IS
/******************************************************************************
 NOME:        Periodo
 DESCRIZIONE: Consente di unificare periodi basandosi sui campi da
              controllare passati come parametro.
              Si analizzano i record che hanno nei campi i medesimi valori
              del record in analisi e le date sono contigue ed si puo' ottenere:
              - l'ultima data per i valori indicati
              - il valore 1 se il record analizzato e' il primo con i valori
                indicati.
              Il nome del campo che rappresenta la data di inizio (dal) e il
              nome di quello di fine (al) devono essere passati come parametro.

 ANNOTAZIONI: I campi e i valori da controllare sono passati in una stringa 
              delimitati da '#'
 ESEMPIO:
 SELECT dal
      , Periodo.get_ultimo ('PERIODI_GIURIDICI', -- tavola
	                        'DAL',               -- nome campo inizio
                            'AL',                -- nome campo fine
                            al,                  -- valore al del record
                            '#FIGURA#QUALIFICA#',-- campi da confrontare
                            '#'||figura|| '#' ||qualifica||'#'-- valori record
                            ) al, 						                                        
                            figura,
                            qualifica
   FROM PERIODI_GIURIDICI 
  WHERE ci = 7052 AND rilevanza = 'S'
    AND periodo.is_primo ('PERIODI_GIURIDICI',   -- tavola
                          'AL',                  -- nome campo fine
                          dal,                   -- valore dal del record
                          '#FIGURA#QUALIFICA#',  -- campi da confrontare
                          '#'||figura|| '#' ||qualifica||'#'-- valori record
                          ) = 1  -- se funzione = 1 allora e il primo periodo
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    02/12/2002 SN     Prima emissione.
******************************************************************************/
FUNCTION VERSIONE              
    RETURN varchar2;
	
FUNCTION Get_Ultimo
   (p_tabella            IN VARCHAR2,
    p_nome_dal           IN VARCHAR2,
    p_nome_al            IN VARCHAR2,
    p_al                 IN DATE,
    p_campi_controllare  IN VARCHAR2,
    p_valori_controllare IN VARCHAR2
    )
    RETURN DATE;

FUNCTION Get_primo
   (p_tabella            IN VARCHAR2,
    p_nome_dal           IN VARCHAR2,
    p_nome_al            IN VARCHAR2,
    p_dal                IN DATE,
    p_campi_controllare  IN VARCHAR2,
    p_valori_controllare IN VARCHAR2
    )
    RETURN DATE;
	
FUNCTION Is_Primo
   (p_tabella            IN VARCHAR2,
    p_nome_al            IN VARCHAR2,
    p_dal                IN DATE,
    p_campi_controllare  IN VARCHAR2,
    p_valori_controllare IN VARCHAR2
    )
    RETURN NUMBER;
END Pie_Periodo;
/
CREATE OR REPLACE PACKAGE BODY Pie_Periodo AS
d_statement VARCHAR2(32000);
d_campi     VARCHAR2(32000);
d_dal       VARCHAR2(50);
d_al        VARCHAR2(10);
d_select    VARCHAR2(32000);
v_al        VARCHAR2(10);
v_dal       VARCHAR2(10);
d_codice    VARCHAR2(20);

FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 ECCEZIONI:   --
 ANNOTAZIONI: --
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    02/12/2002 SN     Creazione.
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 02/12/2002';
END;

PROCEDURE estrazione_condizioni
(p_nome_al            IN VARCHAR2,
 p_campi_controllare  IN VARCHAR2,
 p_valori_controllare IN VARCHAR2)
/******************************************************************************
 NOME:        estrazione_condizioni
 DESCRIZIONE: estrazione condizioni da verificare sul record,
              crea le stringhe per lo statement successivo
 ARGOMENTI:   p_nome_al            IN VARCHAR2: nome del campo con data inizio 
              p_campi_controllare  IN VARCHAR2: elenco campi da controllare
              p_valori_controllare IN VARCHAR2: elenco valori da controllare

 ECCEZIONI:

 ANNOTAZIONI: Gli elenchi sono separati dal carattere '#'
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    02/12/2002 SN     Prima emissione.
 1    03/11/2005 MS     Ampliamento variabili d_dato
******************************************************************************/
IS
i NUMBER := 0;
d_dato VARCHAR2(32767);
d_campo VARCHAR2(30) := TO_CHAR(NULL);
BEGIN
i:= 2;
d_dal:= TO_DATE(NULL);
d_al:=  TO_DATE(NULL);
d_campi:= ' where ';
d_select := ' to_char(' || p_nome_al || ',''ddmmyyyy'')';
WHILE INSTR(p_campi_controllare,'#',1,i) != 0 LOOP
     -- fin quando ci sono campi da controllare
   d_dato := SUBSTR(p_valori_controllare,INSTR(p_valori_controllare,'#',1,i-1)+1
            ,INSTR(p_valori_controllare,'#',1,i)-1-INSTR(p_valori_controllare,'#',1,i-1));
   d_campo := SUBSTR(p_campi_controllare,INSTR(p_campi_controllare,'#',1,i-1)+1
             ,INSTR(p_campi_controllare,'#',1,i)-1-INSTR(p_campi_controllare,'#',1,i-1));
   IF d_dato IS NULL
   THEN
      d_campi := d_campi || d_campo ||
               ' is null AND ';
   ELSE -- valore non nullo
      d_campi := d_campi || d_campo ||
               ' = '''|| replace(d_dato,'''','''''') ||''' AND ';
   END IF;
   i := i+1;
END LOOP;
END estrazione_condizioni;

FUNCTION estrazione_dal
( p_stringa IN VARCHAR2) RETURN NUMBER
/******************************************************************************
 NOME:        esecuzione_statement
 DESCRIZIONE: esecuzione sql dinamico con estrazione del valore trovato

 ARGOMENTI:   p_stringa IN VARCHAR2: statement da eseguire

 ECCEZIONI:

 ANNOTAZIONI: In caso di errore ritorna -1 che viene controllato dal chiamante
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    25/06/2001 SN     Prima emissione.
******************************************************************************/
IS
trovato        NUMBER;
cursor_name    INTEGER;
rows_processed INTEGER;
BEGIN
   trovato := 0;
  cursor_name := dbms_sql.open_cursor;
   dbms_sql.parse (cursor_name,  p_stringa , dbms_sql.native);
   dbms_sql.define_column (cursor_name, 1, v_al,10);
   rows_processed := dbms_sql.EXECUTE (cursor_name);
   IF dbms_sql.fetch_rows (cursor_name) > 0 
   THEN
      dbms_sql.column_value (cursor_name, 1, v_al);
	  trovato := 1;
   ELSE
      trovato := 0;
   END IF;
   dbms_sql.close_cursor(cursor_name);
   RETURN trovato;
EXCEPTION
   WHEN OTHERS THEN
      dbms_sql.close_cursor(cursor_name);
      RETURN -1;
      RAISE; 
END estrazione_dal;

FUNCTION Get_Ultimo
   (p_tabella            IN VARCHAR2,
    p_nome_dal           IN VARCHAR2,
    p_nome_al            IN VARCHAR2,
    p_al                 IN DATE,
    p_campi_controllare  IN VARCHAR2,
    p_valori_controllare IN VARCHAR2
    )
    RETURN DATE
IS
PRAGMA AUTONOMOUS_TRANSACTION;
/******************************************************************************
 NOME:        Get_Ultimo
 DESCRIZIONE: Restituisce l'ultima data cercando i record che hanno lo stesso
              valore indicato per i campi elencati e date contigue.
 PARAMETRI: p_tabella            IN VARCHAR2: nome tavola da analizzare
            p_nome_dal           IN VARCHAR2: nome colonna fine periodo
            p_nome_al            IN VARCHAR2: nome colonna inizio periodo
            p_al                 IN DATE    : valore al del record in esame
            p_campi_controllare  IN VARCHAR2: elenco campi da controllare
            p_valori_controllare IN VARCHAR2: elenco valori da controllare
 RITORNA:   DATE ultima data nel campo indicato dal parametro p_nome_al per
                 uguaglianza dei valori nei campi indicati
 ECCEZIONI: -20999: in caso di errato statement sql	  
 ANNOTAZIONI: Gli elenchi sono delimitati dal carattere '#'  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    02/12/2002 SN     Prima emissione.
******************************************************************************/
a_al      VARCHAR2(10):= TO_CHAR(NULL);
v_ritorno NUMBER  := 1;
BEGIN
   estrazione_condizioni(p_nome_al,p_campi_controllare,p_valori_controllare);
   a_al := TO_CHAR(p_al,'ddmmyyyy');
   d_al := a_al;
   v_al := a_al;
   d_statement := 'select ' || d_select ||' from ' || p_tabella || ' '
                  || d_campi || ' ' || p_nome_dal ||
				  '= to_date(''' || d_al  || ''',''ddmmyyyy'') + 1' ;
   WHILE  v_ritorno = 1 LOOP -- trovato successivo
      v_ritorno := estrazione_dal(d_statement);
      IF v_ritorno =  1
	  THEN
         a_al := v_al;
         d_al := v_al;
         d_statement := 'select ' || d_select ||' from ' || p_tabella || ' '||
                        d_campi || ' ' || p_nome_dal ||' = to_date(''' || 
						d_al  || ''',''ddmmyyyy'') + 1' ;
	  ELSIF v_ritorno = - 1 -- generato errore in sql dinamico
	  THEN
	  raise_application_error(-20999,'Get_Ultimo: errore nello statement sql:
'|| d_statement);
         RETURN 'errore';      
      END IF;
   END LOOP;
   RETURN TO_DATE(a_al,'ddmmyyyy');
END Get_Ultimo;


FUNCTION Get_primo
   (p_tabella            IN VARCHAR2,
    p_nome_dal           IN VARCHAR2,
    p_nome_al            IN VARCHAR2,
    p_dal                IN DATE,
    p_campi_controllare  IN VARCHAR2,
    p_valori_controllare IN VARCHAR2
    )
    RETURN DATE
IS
PRAGMA AUTONOMOUS_TRANSACTION;
/******************************************************************************
 NOME:        Get_primo
 DESCRIZIONE: Restituisce la prima data cercando i record che hanno lo stesso
              valore indicato per i campi elencati e date contigue.
 PARAMETRI: p_tabella            IN VARCHAR2: nome tavola da analizzare
            p_nome_dal           IN VARCHAR2: nome colonna fine periodo
            p_nome_al            IN VARCHAR2: nome colonna inizio periodo
            p_al                 IN DATE    : valore al del record in esame
            p_campi_controllare  IN VARCHAR2: elenco campi da controllare
            p_valori_controllare IN VARCHAR2: elenco valori da controllare
 RITORNA:   DATE ultima data nel campo indicato dal parametro p_nome_al per
                 uguaglianza dei valori nei campi indicati
 ECCEZIONI: -20999: in caso di errato statement sql	  
 ANNOTAZIONI: Gli elenchi sono delimitati dal carattere '#'  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    02/12/2002 SN     Prima emissione.
******************************************************************************/
a_dal      VARCHAR2(10):= TO_CHAR(NULL);
v_ritorno NUMBER  := 1;
BEGIN
   estrazione_condizioni(p_nome_al,p_campi_controllare,p_valori_controllare);
   a_dal := TO_CHAR(p_dal,'ddmmyyyy');
   d_dal := a_dal;
   v_dal := a_dal;
   d_statement := 'select ' || d_select ||' from ' || p_tabella || ' '
                  || d_campi || ' ' || p_nome_dal ||
				  '= to_date(''' || d_al  || ''',''ddmmyyyy'') + 1' ;
   WHILE  v_ritorno = 1 LOOP -- trovato successivo
      v_ritorno := estrazione_dal(d_statement);
      IF v_ritorno =  1
	  THEN
         a_dal := v_dal;
         d_dal := v_dal;
         d_statement := 'select ' || d_select ||' from ' || p_tabella || ' '||
                        d_campi || ' ' || p_nome_al ||' = to_date(''' || 
						d_dal  || ''',''ddmmyyyy'') - 1' ;
	  ELSIF v_ritorno = - 1 -- generato errore in sql dinamico
	  THEN
	  raise_application_error(-20999,'Get_primo: errore nello statement sql:
'|| d_statement);
         RETURN 'errore';      
      END IF;
   END LOOP;
   RETURN TO_DATE(a_dal,'ddmmyyyy');
END Get_primo;


FUNCTION Is_Primo 
   (p_tabella            IN VARCHAR2,
    p_nome_al            IN VARCHAR2,
    p_dal                IN DATE,
    p_campi_controllare  IN VARCHAR2,
    p_valori_controllare IN VARCHAR2
    )
    RETURN NUMBER
IS
PRAGMA AUTONOMOUS_TRANSACTION;
/******************************************************************************
 NOME:        Is_Primo
 DESCRIZIONE: Restituisce un intero che indica se e il primo record
              con i valori richiesti nei campi indicati e date contigue.
 PARAMETRI: p_tabella            IN VARCHAR2: nome tavola da analizzare
            p_nome_al            IN VARCHAR2: nome colonna inizio periodo
            p_dal                IN DATE    : valore dal del record in esame
            p_campi_controllare  IN VARCHAR2: elenco campi da controllare
            p_valori_controllare IN VARCHAR2: elenco valori da controllare
 RITORNA:   NUMBER: 1 : se il record e il primo con le caratteristiche date
 
 ECCEZIONI: -20999: in caso di errato statement sql

 ANNOTAZIONI: Gli elenchi sono delimitati dal carattere '#'  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    02/12/2002 SN     Prima emissione.
******************************************************************************/
a_dal VARCHAR2(10) := TO_CHAR(NULL);
ritorno INTEGER;
v_estrazione INTEGER;
BEGIN
   ritorno := 1;
   -- vedere se esiste record con le stesse condizioni e con al = dal - 1
   estrazione_condizioni(p_nome_al,p_campi_controllare,p_valori_controllare);
   a_dal := TO_CHAR(p_dal,'ddmmyyyy');
   d_statement := 'select ' || d_select ||' from ' || p_tabella || ' ' ||
                  d_campi || ' ' || p_nome_al ||' = to_date(''' || a_dal  ||
				  ''',''ddmmyyyy'') - 1' ;
   v_estrazione := estrazione_dal(d_statement);
   IF v_estrazione = 1
   THEN -- trovato precedente
      ritorno :=0;
      a_dal := v_dal;
      d_dal := v_dal;
   ELSIF v_estrazione = -1 -- generato errore in sql dinamico
   THEN
   	  raise_application_error(-20999,'Is_Primo: errore nello statement sql:
'|| d_statement);
      RETURN 'errore'; 
   END IF;
   RETURN ritorno;
END Is_Primo ;

END Pie_Periodo;
/