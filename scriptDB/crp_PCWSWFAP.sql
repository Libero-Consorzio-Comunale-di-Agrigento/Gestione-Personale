CREATE OR REPLACE PACKAGE PCWSWFAP IS
  w_into         varchar2(4000);
/******************************************************************************
 NOME:        PCWSWFAP
 DESCRIZIONE: <Descrizione Package>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 1    23/02/2003 GM     Prima emissione
 2    04/10/2005 GM     Ulteriori modifiche
 2.1  15/07/2006 GM     Adeguamento Versione dinamica con Foto
 2.2  30/08/2006 GM     Introdotta nuova funzionalita che spezza automaticamente la stringa
 2.3  22/09/2006 GM     Interventi posto verifica MILANO
 2.4  18/04/2007 ML     Gestione tabella word_temp temporary
******************************************************************************/
      FUNCTION  VERSIONE                RETURN VARCHAR2;
      FUNCTION  CREA_INTESTAZIONE(prenotazione in number, passo in number, P_tabella in varchar2, P_documento in varchar2,wote_chiave in varchar2) RETURN varchar2;
      FUNCTION  TRATTA_CONDIZIONI(prenotazione in number, passo in number, P_ci in number, P_al in date, P_condizioni in varchar2,wote_chiave in varchar2) RETURN varchar2;
      PROCEDURE CREA_CORPO(prenotazione in number, passo in number, P_ci in number, P_tabella in varchar2, P_al in date, P_condizioni in varchar2, P_documento in varchar2, errore out number,wote_chiave in varchar2);
END PCWSWFAP;
/
CREATE OR REPLACE PACKAGE BODY PCWSWFAP IS
  D_riga number := 0;
  FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        PCWSWFAP
 DESCRIZIONE: <Descrizione Package>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 1    23/02/2003 GM     Prima emissione
 2    04/10/2005 GM     Ulteriori modifiche
 2.1  15/07/2006 GM     Adeguamento Versione dinamica con Foto
 2.2  30/08/2006 GM     Introdotta nuova funzionalita che spezza automaticamente la stringa
 2.3  22/09/2006 GM     Interventi posto verifica MILANO
 2.4  18/04/2007 ML     Gestione tabella word_temp temporary
******************************************************************************/
  BEGIN
     RETURN 'V2.4 del 18/04/2007';
  END VERSIONE;
  FUNCTION CREA_INTESTAZIONE(prenotazione in number , passo in number, P_tabella in varchar2, P_documento in varchar2,wote_chiave in varchar2)  RETURN varchar2 IS
    componi varchar2(4000);
  BEGIN
    BEGIN
	  /* Log */
	  if prenotazione <> 0 then
		  D_riga := D_riga + 1;
		  insert
		    into a_appoggio_stampe
	      values (prenotazione, passo - 1 , 1, D_riga, 'Crea Intestazione: '||P_tabella);
		  -- commit;
	  end if;
	  /* Fine Log */
      FOR CUR_INT in
        (select column_name from cols
          where table_name = P_tabella
	      order by data_length
        ) LOOP
          componi := componi||CUR_INT.column_name||'~';
          END LOOP;
          -- solo nell'intestazione della parte anagrafica devo incollare anche tutti i paragrafi del documento
          IF p_tabella = 'WORD_ANAGRAFICI' THEN
            FOR CUR_PAR in
              (select paragrafo
                 from struttura_modelli_word
                where documento = p_documento
                order by sequenza
              ) LOOP
                componi := componi|| 'PAR_' ||CUR_PAR.paragrafo ||'~';
                END LOOP;
            componi := componi||'DATA_ELAB'||'~'||'FOTO'||'~';
          END IF;
    END;
    RETURN componi;
  END CREA_INTESTAZIONE;
  FUNCTION TRATTA_CONDIZIONI(prenotazione in number, passo in number, P_ci in number, P_al in date, P_condizioni in varchar2,wote_chiave in varchar2)  RETURN varchar2 IS
    condizioni varchar2(4000);
  BEGIN
    BEGIN
      IF INSTR(UPPER(P_condizioni),'P_CI') > 0 or INSTR(UPPER(P_condizioni),'P_AL') > 0 THEN
        condizioni := replace(upper(P_condizioni),'P_CI',''||p_ci||'');
        condizioni := replace(upper(condizioni),'P_AL',''''||nvl(p_al,sysdate)||'''');
      ELSE
        condizioni := p_condizioni;
      END IF;
    END;
    RETURN condizioni;
  END TRATTA_CONDIZIONI;
  PROCEDURE CREA_CORPO(prenotazione in number, passo in number, P_ci in number, P_tabella in varchar2, P_al in date, P_condizioni in varchar2, P_documento in varchar2, errore out number,wote_chiave in varchar2) IS
    colonna      varchar2(1000);
    compselect   varchar2(4000);
	compseldati  varchar2(4000);
	compselvalue varchar2(4000);
	componi      varchar2(4000);
    istruzione   varchar2(4000);
    temp         varchar2(4000);
	maxlength    number;
	type type_componi is record
		(componi varchar2(4000) := null
		);
    type list_componi  is table of type_componi index by binary_integer;
	wcomponi   list_componi;
	i          integer;
  BEGIN
    BEGIN
      DELETE from WORD_TEMP;
       -- commit;
	  /* Log */
	  if prenotazione <> 0 then
		  D_riga := D_riga + 1;
		  insert
		    into a_appoggio_stampe
	      values (prenotazione, passo - 1 , 1, D_riga, 'Crea Corpo:        '||P_tabella);
		  -- commit;
	  end if;
	  /* Fine Log */
      errore := 0;
	  maxlength := 0;
	  i := 0;
      FOR CUR_COR in
        (select column_name, data_type, data_length from cols
          where table_name = P_tabella
	   order by data_length
        ) LOOP
		      maxlength := maxlength + CUR_COR.data_length;
	          IF CUR_COR.data_type = 'DATE' THEN
	            colonna := 'to_char('||CUR_COR.column_name||',''dd/mm/yyyy'')';
	          ELSIF CUR_COR.data_type = 'NUMBER' THEN
	            colonna := 'to_char('||CUR_COR.column_name||')';
	          ELSE
	            colonna := CUR_COR.column_name;
				IF CUR_COR.data_length = 4000 THEN
				  colonna := 'substr('||CUR_COR.column_name||',0,3999)';
				END IF;
	          END IF;
              if maxlength < 2000 then
	            wcomponi(i).componi := wcomponi(i).componi||'||'||colonna||'||''~''';
		      else
			    i := i + 1;
				wcomponi(i).componi := wcomponi(i).componi||'||'||colonna||'||''~''';
				maxlength := CUR_COR.data_length;
			  end if;
          END LOOP;
          IF p_tabella = 'WORD_ANAGRAFICI' THEN
		  	i := i + 1;
            FOR CUR_PAR in
              (select paragrafo
                 from struttura_modelli_word
                where documento = p_documento
                order by sequenza
              ) LOOP
                wcomponi(i).componi := wcomponi(i).componi||'||''~''';
                END LOOP;
            wcomponi(i).componi := wcomponi(i).componi||'||'''||to_char(nvl(p_al,sysdate),'dd/mm/yyyy')||'''||''';
            wcomponi(i).componi := wcomponi(i).componi||'~~''';
          END IF;
		  for k in 0..wcomponi.count-1 loop
		    compselect   := compselect ||','|| substr(wcomponi(k).componi,3) || ' riga_' ||to_char(k)||' ';
			compseldati  := compseldati||',dati_'||to_char(k);
			compselvalue := compselvalue||',SEL_COR.riga_'||to_char(k);
		  end loop;
          istruzione := 'BEGIN '||
		                'DECLARE '||
		                'contatore number := 0; '||
						'BEGIN '||
                        'FOR SEL_COR IN ('||
                        'SELECT '|| substr(compselect,2) ||
                        'FROM '||p_tabella ||' '||
                        'WHERE ci = '||p_ci||' '||
                        'AND '||nvl(tratta_condizioni(prenotazione, passo, p_ci,p_al,p_condizioni,wote_chiave),'1=1')||' '||
                        ') LOOP '||
						'contatore := contatore + 1; '||
                        'INSERT INTO WORD_TEMP (wote_id,sequenza,'||substr(compseldati,2)||') '||
                        'VALUES ('''||wote_chiave||''',contatore,'||substr(compselvalue,2)||'); '||
                        'END LOOP; '||
--						'  commit; '||
						'END; '||
                        'END;';
          BEGIN
          SI4.SQL_EXECUTE(istruzione);
          EXCEPTION
            when no_data_found then
			  errore := 2;
		      /* Log */
			  if prenotazione <> 0 then
				  D_riga := D_riga + 1;
				  insert
				    into a_appoggio_stampe
			      values (prenotazione, passo - 1 , 1, D_riga, '*/WARNING */ Nessun Dato Estratto!');
				  -- commit;
			  end if;
			  /* Fine Log */
			when others then
			  errore := 1;
          END;
    END;
  END CREA_CORPO;
  END PCWSWFAP;
/
