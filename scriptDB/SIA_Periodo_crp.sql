CREATE OR REPLACE PACKAGE Periodo IS
/******************************************************************************
 NOME:        Periodo
              Equivale al package SIA_PERIODO
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
 ESEMPIO 1:
 SELECT dal
      , Periodo.get_ultimo ('PERIODI_GIURIDICI', -- tavola
	                        'DAL',               -- nome campo inizio
                            'AL',                -- nome campo fine
                             al,                  -- valore al del record
                            '#FIGURA#QUALIFICA#RILEVANZA#CI#to_date(dal,''mm'')#',-- campi da confrontare
                            '#'||figura||'#'||qualifica||'#'||rilevanza||'#'||ci||'#'||to_date(dal,'mm')||'#'-- valori record
                            ) al, 						                                        
                            figura,
                            qualifica
   FROM PERIODI_GIURIDICI 
  WHERE ci = 7052 AND rilevanza = 'S'
    AND periodo.is_primo ('PERIODI_GIURIDICI',   -- tavola
                          'AL',                  -- nome campo fine
                          dal,                   -- valore dal del record
                          '#FIGURA#QUALIFICA#RILEVANZA#CI#',  -- campi da confrontare
                          '#'||figura|| '#' ||qualifica||'#'||rilevanza||'#'|| ci||'#'-- valori record
                          ) = 1  -- se funzione = 1 allora e il primo periodo
 ESEMPIO 2:
 SELECT  Periodo.get_primo ('PERIODI_GIURIDICI', -- tavola
	                        'DAL',               -- nome campo inizio
                            'AL',                -- nome campo fine
                             dal,                  -- valore dal del record
                            '#FIGURA#QUALIFICA#RILEVANZA#CI#',-- campi da confrontare
                            '#'||figura|| '#' ||qualifica||'#'||rilevanza||'#'|| ci||'#'-- valori record
                            ) dal,		                                        
        figura,
        qualifica,
		ci
   FROM PERIODI_GIURIDICI 
  WHERE ci = 7052 
    AND rilevanza = 'S'
    AND al is null
 ESEMPIO 3 caso in cui voglio unificare i periodi solo se sono dello stesso mese 
 notare l’uso della funzione per l’estrazione del mese come ultima colonna dei controlli :
 SELECT ddma.ci                                  ci 
 ,Periodo.get_ultimo('DENUNCIA_DMA','DAL','AL',ddma.al,
                     '#ANNO#MESE#PREVIDENZA#GESTIONE#RILEVANZA#CI#TO_CHAR(dal,''MM'')#', 
                     '#'||ddma.anno|| '#' ||ddma.mese|| '#' ||ddma.previdenza|| '#' ||ddma.gestione||
                     '#'||ddma.rilevanza||'#'||ddma.ci||'#'|| to_char(ddma.dal,'mm')||'#') al 
  FROM DENUNCIA_DMA DDMA 
 WHERE ddma.anno = 2004 
   AND periodo.is_primo ('DENUNCIA_DMA','AL', 
                         ddma.dal,'#ANNO#MESE#PREVIDENZA#GESTIONE#RILEVANZA#CI#TO_CHAR(dal,''MM'')#', 
                         '#'||ddma.anno|| '#' ||ddma.mese|| '#' ||ddma.previdenza|| '#' ||ddma.gestione||
                         '#'||ddma.rilevanza||'#'||ddma.ci||'#'|| to_char(ddma.dal,'mm')||'#')=1

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    02/12/2002 SN     Prima emissione.
 1    16/06/2003 SN	Introduzione get_primo
 2    16/12/2004 SN     Ampliamento variabile d_campo in modo da consentire anche
                        utilizzo di espressioni nei campi come da esempio  1
                        nella get_ultimo.
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
	
FUNCTION Get_Primo
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
END Periodo;
/
CREATE OR REPLACE PACKAGE BODY Periodo AS
d_statement VARCHAR2(32000);
d_campi     VARCHAR2(32000);
d_dal       VARCHAR2(50);
d_al        VARCHAR2(10);
d_select    VARCHAR2(32000);
v_val        VARCHAR2(10);
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
 1    16/06/2003 SN     Inserita funzione Get_primo
 2    16/12/2004 SN     Ampliamento variabile d_campo
******************************************************************************/
BEGIN
   RETURN 'V1.2 del 16/12/2004';
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
 1    16/12/2004 SN     Ampliamento variabile d_campo
 2    03/11/2005 MS     Ampliamento variabile d_dato
******************************************************************************/
IS
i NUMBER := 0;
d_dato VARCHAR2(32767);
d_campo VARCHAR2(2000) := TO_CHAR(NULL);
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

FUNCTION estrazione_val
( p_stringa IN VARCHAR2) RETURN NUMBER
/******************************************************************************
 NOME:        estrazione_val
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
   dbms_sql.define_column (cursor_name, 1, v_val,10);
   rows_processed := dbms_sql.EXECUTE (cursor_name);
   IF dbms_sql.fetch_rows (cursor_name) > 0 
   THEN
      dbms_sql.column_value (cursor_name, 1, v_val);
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
END estrazione_val;

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
   -- copia di appoggio dei valori di partenza
   a_al := TO_CHAR(p_al,'ddmmyyyy');
   d_al := a_al;
   v_val := a_al;
   d_statement := 'select ' || d_select ||' from ' || p_tabella || ' '
                  || d_campi || ' ' || p_nome_dal ||
				  '= to_date(''' || d_al  || ''',''ddmmyyyy'') + 1' ;
   WHILE  v_ritorno = 1 LOOP -- trovato successivo
      v_ritorno := estrazione_val(d_statement);
      IF v_ritorno =  1
	  THEN
	     -- copia dei valori trovati e ricerca dei successivi
         a_al := v_val;
         d_al := v_val;
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

FUNCTION Get_Primo
   (p_tabella            IN VARCHAR2,
    p_nome_dal           IN VARCHAR2,
    p_nome_al            IN VARCHAR2,
    p_dal                IN DATE,
    p_campi_controllare  IN VARCHAR2,
    p_valori_controllare IN VARCHAR2
    )
    RETURN DATE
IS
/******************************************************************************
 NOME:        Get_Primo
 DESCRIZIONE: Restituisce la prima data cercando i record che hanno lo stesso
              valore indicato per i campi elencati e date contigue.
 PARAMETRI: p_tabella            IN VARCHAR2: nome tavola da analizzare
            p_nome_dal           IN VARCHAR2: nome colonna fine periodo
            p_nome_al            IN VARCHAR2: nome colonna inizio periodo
            p_dal                IN DATE    : valore al del record in esame
            p_campi_controllare  IN VARCHAR2: elenco campi da controllare
            p_valori_controllare IN VARCHAR2: elenco valori da controllare
 RITORNA:   DATE ultima data nel campo indicato dal parametro p_nome_al per
                 uguaglianza dei valori nei campi indicati
 ECCEZIONI: -20999: in caso di errato statement sql	  
 ANNOTAZIONI: Gli elenchi sono delimitati dal carattere '#'  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    16/06/2003 SN     Prima emissione.
******************************************************************************/
a_dal     VARCHAR2(10):= TO_CHAR(NULL);
v_ritorno NUMBER  := 1;
BEGIN
   estrazione_condizioni(p_nome_dal,p_campi_controllare,p_valori_controllare);
   -- impostazione iniziale
   a_dal := TO_CHAR(p_dal,'ddmmyyyy');
   d_dal  := a_dal;
   v_val  := a_dal;
   d_statement := 'select ' || d_select ||' from ' || p_tabella || ' '
                  || d_campi || ' ' || p_nome_al ||
				  '= to_date(''' || d_dal  || ''',''ddmmyyyy'') - 1' ;
   WHILE  v_ritorno = 1 LOOP -- trovato successivo
      v_ritorno := estrazione_val(d_statement);
      IF v_ritorno =  1
	  THEN
	     -- copia del valore trovato in campi di appoggio
         a_dal := v_val;
         d_dal := v_val;
         d_statement := 'select ' || d_select ||' from ' || p_tabella || ' '||
                        d_campi || ' ' || p_nome_al ||' = to_date(''' || 
						d_dal  || ''',''ddmmyyyy'') - 1' ;
	  ELSIF v_ritorno = - 1 -- generato errore in sql dinamico
	  THEN
	  raise_application_error(-20999,'Get_Ultimo: errore nello statement sql:
'|| d_statement);
         RETURN 'errore';      
      END IF;
   END LOOP;
   RETURN TO_DATE(a_dal,'ddmmyyyy');
END Get_Primo;


FUNCTION Is_Primo 
   (p_tabella            IN VARCHAR2,
    p_nome_al            IN VARCHAR2,
    p_dal                IN DATE,
    p_campi_controllare  IN VARCHAR2,
    p_valori_controllare IN VARCHAR2
    )
    RETURN NUMBER
IS
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
   v_estrazione := estrazione_val(d_statement);
   IF v_estrazione = 1
   THEN -- trovato precedente
      ritorno :=0;
   ELSIF v_estrazione = -1 -- generato errore in sql dinamico
   THEN
   	  raise_application_error(-20999,'Is_Primo: errore nello statement sql:
'|| d_statement);
      RETURN 'errore'; 
   END IF;
   RETURN ritorno;
END Is_Primo ;

END Periodo;
/

