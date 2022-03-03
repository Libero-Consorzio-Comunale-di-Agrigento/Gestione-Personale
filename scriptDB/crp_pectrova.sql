CREATE OR REPLACE PACKAGE pectrova IS
/******************************************************************************
 NOME:          PECTROVA
 DESCRIZIONE:   

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
 1.3  29/08/2006 DM     
 1.4  29/08/2006 MS     Mod. insert del passo seer er Att. 17360    
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

v_select varchar(32000);
PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER,p_ci number,p_anno number,p_ricerca varchar);
END;
/

CREATE OR REPLACE PACKAGE BODY pectrova IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.4 del 29/08/2006';
   END VERSIONE;

PROCEDURE prepara_select (p_tabella varchar2,p_ci number, p_anno number,p_ricerca varchar)IS
v_colonne varchar2(32767);
v_where varchar2(32767);
cursor c_colonna (p_tab varchar2, p_ow varchar2 )is
select column_name
  from user_tab_columns
 where table_name = upper(p_tab)
   and column_name like 'C%'
   and column_name != 'CI'
   and data_type = 'NUMBER'
   and column_id <= 103
   order by column_id;
begin
v_select := to_char(null);
 for v_colonna in c_colonna (p_tabella,p_anno) loop
     v_colonne := v_colonne ||'rpad(to_char(nvl('||v_colonna.column_name||',0)),17)||';
     v_where := v_where || ' OR ' || v_colonna.column_name || p_ricerca;
 end Loop;
v_select := 'select rowidtochar(rowid), rpad(ci,17) ||rpad(rilevanza,17) || ' || rtrim(v_colonne,'||')
               || ' from '||p_tabella
               || ' where (' || ltrim(v_where ,' OR ')
               || ')and ci = '|| p_ci
               || ' and anno = '|| p_anno;
end prepara_select;
PROCEDURE esegui_righe( P_riga varchar2, prenotazione number,passo number,p_ci number,p_anno number,p_ricerca varchar)
is
source_cursor INTEGER;
ignore INTEGER;
D_riga number;
v_ci number(8);
v_rilevanza varchar2(1);
v_riga varchar2(32767);
v_update varchar2(32000);
v_frase varchar2(32767);
v_pos     integer;
v_casella number;
v_rowid varchar2(2000);
BEGIN
  BEGIN
   select nvl(max(progressivo),0)
     into D_riga
     from a_segnalazioni_errore
    where no_prenotazione = prenotazione
      and passo           = passo
   ;
  END;
  source_cursor := dbms_sql.open_cursor;
  DBMS_SQL.PARSE(source_cursor,p_riga,DBMS_SQL.native);
  DBMS_SQL.DEFINE_COLUMN(source_cursor, 1, v_rowid,2000);
  DBMS_SQL.DEFINE_COLUMN(source_cursor, 2, v_riga,32767);
  ignore := DBMS_SQL.EXECUTE(source_cursor);
  LOOP
    IF DBMS_SQL.FETCH_ROWS(source_cursor)>0 THEN
       DBMS_SQL.COLUMN_VALUE(source_cursor, 1, v_rowid);
       DBMS_SQL.COLUMN_VALUE(source_cursor, 2, v_riga);
       v_ci := to_number(rtrim(substr(v_riga,1,17)));
       v_rilevanza := rtrim(substr(v_riga,18,17));
       v_pos := 1;
       if p_ricerca = '<0' then
       while instr(v_riga,'-',v_pos) > 0 loop
          v_pos := instr(v_riga,'-',v_pos)+1;
          v_casella := (v_pos -2) / 17 -1;
          D_riga := D_riga + 1;
          INSERT INTO a_segnalazioni_errore
          (no_prenotazione,passo,progressivo,errore,precisazione)
          VALUES (prenotazione,passo,D_riga,'P05840','CI: '||v_ci||' Rilevanza '||v_rilevanza||' Casella: C'||v_casella);
          COMMIT;
       end loop;
      elsif p_ricerca = '=0' then
          v_update := to_char(null);
          while instr(v_riga,'0                ',v_pos) > 0 loop
             v_pos := instr(v_riga,'0                ',v_pos)+1;
             v_update := v_update || ', c' || to_char((v_pos-2)/17-1) ||'=to_number(null)';
          end loop;
                   
          v_frase := 'update denuncia_fiscale set ' || ltrim(v_update,',')||' where rowid = ''' || v_rowid ||'''';
           -- uso solo rowid
          --ci = '|| v_ci ||' and rilevanza = '''||v_rilevanza||''' and anno ='||p_anno;
          si4.sql_execute(v_frase);
          commit;
      end if;
    ELSE
      EXIT;
    END IF;
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR(source_cursor);
end;
 PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER,p_ci number,p_anno number,p_ricerca varchar) IS
 BEGIN
  v_select := null;
  prepara_select ('DENUNCIA_FISCALE',p_ci,p_anno,p_ricerca);
  esegui_righe(v_select,prenotazione,passo,p_ci,p_anno,p_ricerca);
EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END ;
END;
/

