declare
D_comando   varchar2(32000);
D_contatore number(10) := 0;
D_esiste  varchar2(2) := '';

procedure conta
(p_table_name in varchar2, v_contatore out number) is
D_conta   number(10) := 0;
source_cursor INTEGER;
ignore INTEGER;
begin
    BEGIN
      source_cursor := dbms_sql.open_cursor;
      dbms_SQL.PARSE(source_cursor,'SELECT count(*) conta FROM '||P_table_name,dbms_SQL.V7);
      dbms_SQL.DEFINE_COLUMN(source_cursor, 1, D_conta);
      ignore := dbms_SQL.EXECUTE_AND_FETCH(source_cursor);
      dbms_SQL.COLUMN_VALUE(source_cursor, 1, D_conta);
      dbms_SQL.CLOSE_CURSOR(source_cursor);
      D_contatore := D_conta;
-- dbms_output.put_line('record parziali 1: '||V_conta);
    END;
end conta;

begin
  begin
    select 'SI'
      into D_esiste
      from dual
     where exists ( select 'X' from obj 
                     where OBJECT_NAME = 'TIPI_REGISTRO'
                       and object_type = 'TABLE'
                   );
  exception
    when no_data_found then
         D_esiste := 'NO';
  end;

    IF D_esiste = 'SI' then
      begin
       conta('TIPI_REGISTRO',D_contatore);
      end;
      IF D_contatore > 0 THEN 
    -- salvataggio dei dati se presenti per sicurezza
         D_comando := 'create table TIRE_PRIMA_18753 as select * from TIPI_REGISTRO';
         si4.sql_execute ( D_comando );
      END IF;
    -- cancellazione della tabella
         D_comando := 'drop table TIPI_REGISTRO';
         si4.sql_execute ( D_comando );
    END IF; -- tipi_registro

  begin
    select 'SI'
      into D_esiste
      from dual
     where exists ( select 'X' from obj 
                     where OBJECT_NAME = 'TIPI_DOCUMENTO'
                       and object_type = 'TABLE'
                   );
  exception
    when no_data_found then
         D_esiste := 'NO';
  end;

    IF D_esiste = 'SI' then
      begin
       conta('TIPI_DOCUMENTO',D_contatore);
      end;
      IF D_contatore > 0 THEN 
    -- salvataggio dei dati se presenti per sicurezza
         D_comando := 'create table TIDO_PRIMA_18753 as select * from TIPI_DOCUMENTO';
         si4.sql_execute ( D_comando );
      END IF;
    -- cancellazione della tabella
         D_comando := 'drop table TIPI_DOCUMENTO';
         si4.sql_execute ( D_comando );
    END IF; -- tipi_documento

  begin
    select 'SI'
      into D_esiste
      from dual
     where exists ( select 'X' from obj 
                     where OBJECT_NAME = 'DOCUMENTI'
                       and object_type = 'TABLE'
                   );
  exception
    when no_data_found then
         D_esiste := 'NO';
  end;

    IF D_esiste = 'SI' then
      begin
       conta('DOCUMENTI',D_contatore);
      end;
      IF D_contatore > 0 THEN 
    -- salvataggio dei dati se presenti per sicurezza
         D_comando := 'create table TIRE_PRIMA_18753 as select * from DOCUMENTI';
         si4.sql_execute ( D_comando );
      END IF;
  -- cancellazione della tabella
       D_comando := 'drop table DOCUMENTI';
       si4.sql_execute ( D_comando );
    END IF; -- documenti
END;
/

-- eliminazione dei trigger e delle procedure
drop TRIGGER   DELIBERE_TMA;
drop PROCEDURE DOCUMENTI_PI;
drop PROCEDURE DOCUMENTI_PU;
drop TRIGGER   DOCUMENTI_TMB;
drop procedure DOCUMENTI_PD;
drop TRIGGER   DOCUMENTI_TDB;
drop TRIGGER   SEDI_PROVVEDIMENTO_TMA;
drop PROCEDURE TIPI_REGISTRO_PU;
drop TRIGGER   TIPI_REGISTRO_TMB;
drop PROCEDURE TIPI_REGISTRO_PD;
drop TRIGGER   TIPI_REGISTRO_TDB;
drop PROCEDURE TIPI_DOCUMENTO_PU;
drop trigger TIPI_DOCUMENTO_TMB;
drop procedure TIPI_DOCUMENTO_PD;
drop trigger TIPI_DOCUMENTO_TDB;

-- eseguo start degli altri trigger per modifica a programmi su REVISIONI_STRUTTURA
start crf_gp4gm.sql 