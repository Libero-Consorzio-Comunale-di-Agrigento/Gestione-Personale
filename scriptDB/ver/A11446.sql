INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P05946', 'Esiste Imputazione contabile collegata a', NULL, NULL, NULL); 

declare
v_comando   varchar2(32000);
v_conta_tot number(10) := 0;
v_contatore number(10) := 0;

procedure conta
(p_table_name in varchar2, v_contatore out number) is
V_conta   number(10) := 0;
V_esiste  varchar2(2) := '';
source_cursor INTEGER;
ignore INTEGER;

begin
  begin
    select 'SI'
      into V_esiste
      from dual
     where exists ( select 'X' from obj 
                     where OBJECT_NAME = p_table_name
                   );
  exception
    when no_data_found then
         V_esiste := 'NO';
  end;
-- dbms_output.put_line('tabella: '||p_table_name);
  IF V_esiste = 'SI' 
  and p_table_name not in ('RIPARTIZIONI_CONTABILI','IMPUTAZIONI_CONTABILI'
                          ,'PERIODI_RETRIBUTIVI','PERIODI_RETRIBUTIVI_BP'
                          ,'SETTORI', 'SETTORI_AMMINISTRATIVI') 
  THEN
    BEGIN
      source_cursor := dbms_sql.open_cursor;
      dbms_SQL.PARSE(source_cursor,'SELECT count(*) conta FROM '||P_table_name||' where gestione = ''*''',dbms_SQL.V7);
      dbms_SQL.DEFINE_COLUMN(source_cursor, 1, V_conta);
      ignore := dbms_SQL.EXECUTE_AND_FETCH(source_cursor);
      dbms_SQL.COLUMN_VALUE(source_cursor, 1, V_conta);
      dbms_SQL.CLOSE_CURSOR(source_cursor);
      v_contatore := v_conta;
-- dbms_output.put_line('record parziali 1: '||V_conta);
    END;
  END IF;
  IF V_esiste = 'SI' and p_table_name in ('RIPARTIZIONI_CONTABILI','IMPUTAZIONI_CONTABILI') THEN
    BEGIN
      source_cursor := dbms_sql.open_cursor;
      dbms_SQL.PARSE(source_cursor,'SELECT count(*) conta FROM '||P_table_name||' where divisione = ''*'' or sezione = ''*''',dbms_SQL.V7);
      dbms_SQL.DEFINE_COLUMN(source_cursor, 1, V_conta);
      ignore := dbms_SQL.EXECUTE_AND_FETCH(source_cursor);
      dbms_SQL.COLUMN_VALUE(source_cursor, 1, V_conta);
      dbms_SQL.CLOSE_CURSOR(source_cursor);
      v_contatore := v_conta;
-- dbms_output.put_line('record parziali 2: '||V_conta);
    END;
  END IF;
  IF V_esiste = 'SI' 
  and p_table_name in ('PERIODI_RETRIBUTIVI','PERIODI_RETRIBUTIVI_BP') 
  THEN
    BEGIN
      source_cursor := dbms_sql.open_cursor;
      dbms_SQL.PARSE(source_cursor,'SELECT count(*) conta FROM '||P_table_name
                                 ||' where gestione = ''*'' and contratto != ''*'' and trattamento != ''*''',dbms_SQL.V7);
      dbms_SQL.DEFINE_COLUMN(source_cursor, 1, V_conta);
      ignore := dbms_SQL.EXECUTE_AND_FETCH(source_cursor);
      dbms_SQL.COLUMN_VALUE(source_cursor, 1, V_conta);
      dbms_SQL.CLOSE_CURSOR(source_cursor);
      v_contatore := v_conta;
-- dbms_output.put_line('record parziali 3: '||V_conta);
    END;
  END IF;
  IF V_esiste = 'SI' 
  and p_table_name in ('SETTORI_AMMINISTRATIVI','SETTORI') 
  THEN
    BEGIN
      source_cursor := dbms_sql.open_cursor;
      dbms_SQL.PARSE(source_cursor,'SELECT count(*) conta FROM '||P_table_name
                                 ||' where gestione = ''*'' and codice != ''*''',dbms_SQL.V7);
      dbms_SQL.DEFINE_COLUMN(source_cursor, 1, V_conta);
      ignore := dbms_SQL.EXECUTE_AND_FETCH(source_cursor);
      dbms_SQL.COLUMN_VALUE(source_cursor, 1, V_conta);
      dbms_SQL.CLOSE_CURSOR(source_cursor);
      v_contatore := v_conta;
-- dbms_output.put_line('record parziali 4: '||V_conta);
    END;
  END IF;

end conta;

begin
  begin
   conta('AUTOMATISMI_PRESENZA',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('DENUNCIA_CP',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('DENUNCIA_DMA',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('DENUNCIA_DMA_QUOTE',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('DENUNCIA_EMENS',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('DENUNCIA_EVENTI_ONAOSI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('DENUNCIA_GLA',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('DENUNCIA_IMPORTI_GLA',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('DENUNCIA_INADEL',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('DENUNCIA_INAIL',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('DENUNCIA_INPDAP',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('DENUNCIA_O1_INPS',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('DENUNCIA_O3_INPS',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('DENUNCIA_ONAOSI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('DOTAZIONE_ORGANICA',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('ESTRAZIONE_GESTIONI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('ESTRAZIONI_VOCE',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('IMPUTAZIONI_CONTABILI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('LIMITI_IMPORTO_SPESA',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('MOVIMENTI_BILANCIO_PREVISIONE',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('PERIODI_DOTAZIONE',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('PERIODI_GIURIDICI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('PERIODI_RETRIBUTIVI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('PERIODI_RETRIBUTIVI_BP',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('QUALIFICHE_GESTIONI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('RAPPORTI_GIURIDICI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('REGOLE_DIARIA',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('RELAZIONI_UO',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('RETRIBUZIONI_INAIL',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('RIPARTIZIONI_CONTABILI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('SETTORI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('SETTORI_AMMINISTRATIVI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('SMTTR_IMPORTI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('SMTTR_INDIVIDUI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('SMTTR_PERIODI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('SMT_IMPORTI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('SMT_INDIVIDUI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('SMT_PERIODI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('SOSPENSIONI_PROGRESSIONE',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('TARIFFE',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('TOTALIZZAZIONE_CAUSALI',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('TOTALI_RETRIBUZIONI_INAIL',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('VALORI_BASE_VOCE',v_contatore);
   V_conta_tot := nvl(V_conta_tot,0) + nvl(V_contatore,0);
   conta('VALORI_BASE_VOCE_BP',v_contatore);
  end;
-- dbms_output.put_line('record totali: '||V_conta_tot);
  IF V_conta_tot = 0 THEN
-- dbms_output.put_line('cancello');
    delete from gestioni where codice='*';
    commit;
  END IF;
END;
/