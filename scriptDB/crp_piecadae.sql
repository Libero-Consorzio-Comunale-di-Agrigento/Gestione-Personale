CREATE OR REPLACE PACKAGE PIECADAE IS
w_into         varchar2(4000);
contaerrori    number:=0;
w_errore       number :=0;
w_messaggio    varchar2(100) := null;
/******************************************************************************
 NOME:          PIECADAE CREAZIONE DATI REPLICA
 DESCRIZIONE:
	Procedura allinea nelle opportune tabelle i dati registrati nell'ambiente Esterno
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    09/10/2003
 2    25/02/2004 SN     Decodifica del valore precedente SOLO se non e nullo.
                        Controllo di periodo esistente solo con dal e al senza
                        considerare i valori precedenti.
                        Aggiornamento solo se ci sono campi da aggiornare.
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
FUNCTION  RITORNA_VALORE  (p_id_variazione varchar2,p_progressivo varchar2,p_colonna varchar2,p_flag number) RETURN varchar2;
PROCEDURE CODIFICA_VALORE(p_prenotazione number, p_passo number,p_id_variazione IN varchar2,p_progressivo IN varchar2,p_colonna IN varchar2,P_codifica_valore varchar2,P_codifica_valore_precedente varchar2);
PROCEDURE ALLINEA_DATO (p_prenotazione IN NUMBER,p_id_variazione IN NUMBER,p_progressivo IN NUMBER, p_tabella IN VARCHAR2,p_operazione IN VARCHAR2);
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
ERRORE exception;
END;
/
CREATE OR REPLACE PACKAGE BODY PIECADAE IS
/********************************************************************/
/* ATTENZIONE: i commenti sono inseriti a posteriori e potrebbero   */
/* non essere precisissssimi....                                    */
/********************************************************************/
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V2.0 del 25/02/2004';
   END VERSIONE;
   PROCEDURE DUPLICA_VALORE (p_prenotazione IN number, p_passo IN number,p_id_variazione IN varchar2,p_progressivo IN varchar2,p_colonna IN varchar2,P_codifica_valore varchar2) IS
  BEGIN
  DECLARE
  w_frase                             VARCHAR2(32767);
  w_frase1                            VARCHAR2(32767);
  w_frase2                            VARCHAR2(32767);
  w_frase3                            VARCHAR2(32767);
  w_update                            VARCHAR2(32767);
  w_update1                           VARCHAR2(32767);
  w_cursore                           VARCHAR2(32767);
  w_campo                             VARCHAR2(4000);
  w_valore                            VARCHAR2(4000);
  w_for                               VARCHAR2(4000);
  contatore                           NUMBER := 0;
  BEGIN
    w_frase := 'begin for c in(';
    w_update := ' update w_variazioni set valore';
    w_cursore := substr(P_codifica_valore,instr(upper(P_codifica_valore),'SELECT'));
    w_for     := substr(P_codifica_valore,1,instr(upper(P_codifica_valore),'SELECT')-1);
    w_cursore := replace(w_cursore,chr(20),' ');
    WHILE instr(upper(w_cursore),'"P_') != 0 LOOP
      w_frase  := w_frase||substr(w_cursore,1,instr(upper(w_cursore),'P_') -2);
      w_cursore := substr(w_cursore,instr(upper(w_cursore),'P_'));
      w_campo  := rtrim(substr(w_cursore,instr(upper(w_cursore),'P_') +2,instr(upper(w_cursore),'"') -(instr(upper(w_cursore),'P_') +2)));
      IF w_campo = 'ID_VARIAZIONE' THEN
        w_valore := p_id_variazione;
      ELSIF w_campo = 'PROGRESSIVO' THEN
        w_valore := p_progressivo;
      ELSE
        w_valore := RITORNA_VALORE(p_id_variazione,p_progressivo,w_campo,1);
      END IF;
      w_frase  := w_frase||w_valore;
      w_cursore := substr(w_cursore,instr(upper(w_cursore),'"') +1);
    END LOOP;
    w_frase  := w_frase||w_cursore;
    w_frase  := w_frase||') loop';
    WHILE instr(upper(w_for),'"') != 0 LOOP
      contatore := contatore +1;
      w_campo := substr(w_for,instr(upper(w_for),'"')+1,instr(upper(w_for),'"',1,2) - instr(upper(w_for),'"') - 1);
      w_update1 := w_update1||w_update||' = c.'||w_campo||' where id_variazione ='||p_id_variazione
                            ||' and progressivo = piecadae.w_into and colonna_destinazione ='||''''||upper(w_campo)||''''||';' ;
      w_for := substr(w_for,instr(upper(w_for),'"',1,2)+1);
    END LOOP;
    piecadae.w_into := 0;
    w_frase := w_frase||' piecadae.w_into := piecadae.w_into +1; insert into w_variazioni select id_variazione,piecadae.w_into'
                      ||', sequenza,operazione,tabella,colonna,tabella_destinazione,colonna_destinazione,tipo_dato,valore,valore_precedente'
                      ||',causale,modificato,user_provenienza,user_destinazione,data_agg'
                      ||' from w_variazioni w where id_variazione = '||p_id_variazione||' and progressivo = 1'
                      ||' and not exists (select 1 from w_variazioni where id_variazione ='||p_id_variazione
                      ||' and w.tabella = tabella and w.colonna = colonna'
                      ||' and progressivo = piecadae.w_into);';
    w_frase1 := ' '||w_update1;
    w_frase2 := 'end loop; end;';
    BEGIN
      si4.sql_execute(w_frase||w_frase1||w_frase2);
    EXCEPTION
      WHEN OTHERS THEN
       contaerrori := contaerrori +1;
       w_errore := 1;
       piecadae.w_into := 'NON TROVATO';
       insert into a_segnalazioni_errore
	      ( NO_PRENOTAZIONE,
		  PASSO,
		  PROGRESSIVO,
		  ERRORE,
		  PRECISAZIONE
		 ) values
		 ( p_prenotazione,
		   p_passo,
               contaerrori,
 		   'A08517',
		   substr('Nella operazione n. '||p_id_variazione||' sulla colonna '||p_colonna,1,50)
		 );
    END;
  END;
END;

FUNCTION RITORNA_VALORE (p_id_variazione varchar2,p_progressivo varchar2,p_colonna varchar2,p_flag number) RETURN varchar2 is
 d_valore              varchar2(4000);
 d_valore_precedente   varchar2(4000);
 d_tipo_dato           varchar2(200);
BEGIN
  BEGIN
    select ''''||valore||''''
         , ''''||valore_precedente||''''
      into d_valore,d_valore_precedente
      from variazioni
     where id_variazione = p_id_variazione
    --   and progressivo   = p_progressivo ATTENZIONE!!!!!!!!!!!!!!!!!!!!
       and colonna       = upper(p_colonna)
     ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      d_valore := null;
      d_valore_precedente := null;
  END;
  IF p_flag = 1 THEN
    return d_valore;
  ELSE
    return d_valore_precedente;
  END IF;
END;
PROCEDURE CODIFICA_VALORE (p_prenotazione IN number, p_passo IN number,p_id_variazione IN varchar2,p_progressivo IN varchar2,p_colonna IN varchar2,P_codifica_valore varchar2,P_codifica_valore_precedente varchar2) IS
  BEGIN
  DECLARE
  w_frase                             VARCHAR2(4000);
  w_campo                             VARCHAR2(4000);
  w_valore                            VARCHAR2(4000);
  D_flag                              NUMBER;
  D_codifica_valore                   VARCHAR2(4000);
  BEGIN
    w_frase := null;
    w_campo := null;
    w_valore := null;
    w_frase := 'begin ';
    IF P_codifica_valore is not null THEN
       D_codifica_valore := replace(P_codifica_valore,chr(20),' ');
       D_flag := 1;
    ELSE
       D_codifica_valore := replace(P_codifica_valore_precedente,chr(20),' ');
       D_flag := 2;
    END IF;
    WHILE instr(upper(D_codifica_valore),'"P_') != 0 LOOP
      w_frase  := w_frase||substr(D_codifica_valore,1,instr(upper(D_codifica_valore),'P_') -2);
      D_codifica_valore := substr(D_codifica_valore,instr(upper(D_codifica_valore),'P_'));
      w_campo  := rtrim(substr(D_codifica_valore,instr(upper(D_codifica_valore),'P_') +2,instr(upper(D_codifica_valore),'"') -(instr(upper(D_codifica_valore),'P_') +2)));
      IF w_campo = 'ID_VARIAZIONE' THEN
        w_valore := p_id_variazione;
      ELSIF w_campo = 'PROGRESSIVO' THEN
        w_valore := p_progressivo;
      ELSE
        w_valore := RITORNA_VALORE(p_id_variazione,p_progressivo,w_campo,D_flag);
      END IF;
      w_frase  := w_frase||w_valore;
      D_codifica_valore := substr(D_codifica_valore,instr(upper(D_codifica_valore),'"') +1);
    END LOOP;
    w_frase  := w_frase||D_codifica_valore;
    w_frase  := w_frase||'; end;';
    BEGIN
      si4.sql_execute(w_frase);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
      piecadae.w_into := 'NON TROVATO';
      WHEN OTHERS THEN
       contaerrori := contaerrori +1;
       w_errore := 1;
       insert into a_segnalazioni_errore
	      ( NO_PRENOTAZIONE,
		  PASSO,
		  PROGRESSIVO,
		  ERRORE,
		  PRECISAZIONE
		 ) values
		 ( p_prenotazione,
		   p_passo,
               contaerrori,
 		   'A08517',
		   substr('Nella operazione n. '||p_id_variazione||' sulla colonna '||p_colonna,1,50)
		 );
    END;
  END;
END;
PROCEDURE ALLINEA_DATO (p_prenotazione IN NUMBER,p_id_variazione IN NUMBER,p_progressivo IN NUMBER, p_tabella IN VARCHAR2,p_operazione IN VARCHAR2) IS
   BEGIN
   DECLARE
     D_dummy        varchar2(1);
     D_data_type    varchar2(106);
     D_data_length  number;
     D_nullable     varchar2(1);
     D_index_name   varchar2(30);
     D_dal          varchar2(4000);
     D_al           varchar2(4000);
     D_dal_prec     varchar2(4000);
     D_al_prec      varchar2(4000);
     D_dal_uguale   number;
     D_al_uguale    number;
     w_frase_i      varchar2(32767);
     w_frase_i_prec varchar2(32767);
     w_campi_i_prec varchar2(32767);
     w_frase_u      varchar2(32767);
     w_frase_d      varchar2(32767);
     w_campi_i      varchar2(32767);
     w_campi_u      varchar2(32767):='(';
     w_condizioni   varchar2(32767):= 'where ';
     w_stringa      varchar2(32767);
     w_messaggio    varchar2(32767);
     BEGIN
       BEGIN
         /* cerca la chiave primaria della tavola */
         select index_name
           into D_index_name
           from user_indexes
          where table_name = upper(p_tabella)
            and index_name like '%_PK'
            and uniqueness = 'UNIQUE'
         ;
         BEGIN
          /* Controlla se nella tabella w_variazioni ci sono tutte le colonne della PK*/
           select 'x'
             into D_dummy
             from user_ind_columns
            where index_name = D_index_name
              and not exists(select 'x'
                               from w_variazioni
                              where id_variazione  = p_id_variazione
                                and progressivo    = p_progressivo
                                and tabella_destinazione = upper(p_tabella)
                                and upper(colonna_destinazione) = column_name
                            )
           ;
           w_errore := 1;
           w_messaggio := 'P.K. Non Determinata nella tabella '||p_tabella;
           RAISE ERRORE;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             null;
         END;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           null;
       END;
       w_frase_i := 'insert into '||p_tabella||' (';
       w_campi_i := 'values (';
       w_frase_u := 'update '||p_tabella||' ';
       w_frase_d := 'Begin delete '||p_tabella;
       /*trattamento di ogni colonna dalla w_variazioni */
       FOR CUR_VARI_C IN (
         select colonna_destinazione
              , valore,valore_precedente
              , causale,modificato
           from w_variazioni
          where id_variazione = p_id_variazione
            and progressivo   = p_progressivo
            and sequenza = 999 --ATTENZIONE AGGIUNTO!!!!!!!!!!!!!!!
            and tabella_destinazione = p_tabella
       ) LOOP
         BEGIN
           select data_type,data_length
                , nullable
             into D_data_type,D_data_length
                , D_nullable
             from user_tab_columns
            where table_name  = upper(p_tabella)
              and column_name = upper(CUR_VARI_C.colonna_destinazione)
           ;
           /* controllo di dato rispondente al datatype */
           IF D_data_type = 'NUMBER' and p_operazione in ('I','U') THEN
             BEGIN
               select 'x'
                 into D_dummy
                 from dual
                where translate(CUR_VARI_C.valore,'0123456789','9999999999') = lpad('9',length(CUR_VARI_C.valore),'9')
               ;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 w_errore := 1;
                 w_messaggio := 'Op.'||p_id_variazione||' Val.Non numero '||p_tabella||'.'||CUR_VARI_C.colonna_destinazione;
                 RAISE ERRORE;
             END;
           ELSIF D_data_type = 'DATE' and p_operazione in ('I','U') THEN
              null;
           END IF;
           IF D_data_type = 'NUMBER' and p_operazione in ('U','D') and cur_vari_c.valore_precedente is not null THEN
             BEGIN
               select 'x'
                 into D_dummy
                 from dual
                where translate(CUR_VARI_C.valore_precedente,'0123456789','9999999999') = lpad('9',length(CUR_VARI_C.valore_precedente),'9')
               ;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 w_errore := 1;
                 w_messaggio :=  'Op.'||p_id_variazione||' Val.Non numero '||p_tabella||'.'||CUR_VARI_C.colonna_destinazione;
                 RAISE ERRORE;
             END;
           ELSIF D_data_type = 'DATE' and p_operazione in ('I','U') THEN
              null;
           END IF;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             w_errore := 1;
             w_messaggio := 'Col. '||CUR_VARI_C.colonna_destinazione||' non presente nella tab. '||p_tabella;
             RAISE ERRORE;
         END;
         /* controlli sulla lunghezza del campo */
         IF length(CUR_VARI_C.valore) > D_data_length and p_operazione in ('I','U') and D_data_type != 'DATE' THEN
             w_errore := 1;
             w_messaggio :=  'Op.'||p_id_variazione||' Val.GRANDE '||p_tabella||'.'||CUR_VARI_C.colonna_destinazione;
             RAISE ERRORE;
         END IF;
         IF length(CUR_VARI_C.valore_precedente) > D_data_length and p_operazione in ('U','D') and D_data_type != 'DATE' THEN
             w_errore := 1;
             w_messaggio := 'Valore della Col. '||CUR_VARI_C.colonna_destinazione||' '||p_tabella||'troppo Grande';
             RAISE ERRORE;
         END IF;
       END LOOP;
       BEGIN
       /* se per la tavola esiste la colonna DAL */
         select 'x'
           into D_dummy
           from dual
          where exists (select 'x'
                          from user_tab_columns
                         where table_name = upper(p_tabella)
                           and column_name = 'DAL'
                       )
         ;
         BEGIN
         /* cerco i valori della colonna DAL nelle variazioni */
           select ltrim(valore),ltrim(valore_precedente)
             into D_dal,D_dal_prec
             from w_variazioni
            where id_variazione = p_id_variazione
              and progressivo   = p_progressivo
              and sequenza = 999 -- ATTENZIONE AGGIUNTO!!!!!!!!!!
              and tabella_destinazione = upper(p_tabella)
              and upper(colonna_destinazione) = 'DAL'
           ;
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
               w_errore := 1;
               w_messaggio := 'Campo Dal non trovato nella tab. '||P_tabella;
               RAISE ERRORE;
         END;
         BEGIN
         /* cerco i valori per la colonna AL */
           select ltrim(valore),ltrim(valore_precedente)
             into D_al,D_al_prec
             from w_variazioni
            where id_variazione = p_id_variazione
              and progressivo   = p_progressivo
              and sequenza = 999 -- ATTENZIONE AGGIUNTO!!!!!!!!!!
              and tabella_destinazione = upper(p_tabella)
              and upper(colonna_destinazione) = 'AL'
           ;
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
               w_errore := 1;
               w_messaggio := 'Campo Al non trovato nella tab. '||P_tabella;
               RAISE ERRORE;
         END;
         w_campi_i_prec := '(';
         /* Per ogni colonna presente nelle variazioni e prevista per la tavola */
         FOR CUR_W_VARI_C IN (
           select colonna_destinazione
                , valore,valore_precedente
                , causale,modificato
                , data_type
           from w_variazioni
              , user_tab_columns
          where id_variazione = p_id_variazione
            and progressivo   = p_progressivo
            and sequenza = 999 -- ATTENZIONE AGGIUNTO!!!!!!!!!!
            and tabella_destinazione = p_tabella
            and table_name  = upper(p_tabella)
            and column_name = upper(colonna_destinazione)
         ) LOOP
          /* se la colonna e modificata e non e dal o al*/
           IF CUR_W_VARI_C.modificato = 1 and upper(CUR_W_VARI_C.colonna_destinazione) not in ('DAL','AL') THEN
              /* preparo i campi per update */
              w_campi_u := w_campi_u||', '||CUR_W_VARI_C.colonna_destinazione||' = '||''''||rtrim(CUR_W_VARI_C.valore)||'''';
              w_campi_i_prec := w_campi_i_prec||', '||CUR_W_VARI_C.colonna_destinazione;
           END IF;
           /* se e parte della chiave primaria e non e dal o al */
           IF CUR_W_VARI_C.causale = 'P' and upper(CUR_W_VARI_C.colonna_destinazione) not in ('DAL','AL') THEN
              /*aggiungo alle condizioni */
              w_condizioni := w_condizioni||' and '||CUR_W_VARI_C.colonna_destinazione||' = '||''''||rtrim(nvl(CUR_W_VARI_C.valore_precedente,CUR_W_VARI_C.valore))||'''';
           END IF;
         END LOOP;
         w_condizioni := replace(w_condizioni,'where  and','where ');
         BEGIN
          /* prende il dal dalla tabella con le where condition con dal = nuovo dal*/
          /* modificato 25/02/2004 usando solo il dal e non il dal precedente*/
           w_stringa := 'begin select to_char(dal,''ddmmyyyy'') into piecadae.w_into from '||p_tabella||' '||w_condizioni||' and dal = to_date('''||d_dal||''',''ddmmyyyy''); end;';
           si4.sql_execute(w_stringa);
           D_dal_uguale := 1;
           IF p_operazione = 'D' THEN
              /* se cancellazione */
              BEGIN
                /*controllo che non sia il record con il minmo dal per quella PK */
                si4.sql_execute('begin select to_char(dal,''ddmmyyyy'') into piecadae.w_into from '||p_tabella||' '||w_condizioni||' and to_date('||''''||d_dal_prec||''''||',''ddmmyyyy'') = (select min(dal) from '
                               ||p_tabella||' '||w_condizioni||') ; end;');
                w_errore := 1;
                w_messaggio := 'Non e possibile Canc. il primo record della tab. '||p_tabella;
                RAISE ERRORE;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  null;
              WHEN OTHERS THEN
                w_errore := 1;
                w_messaggio := 'Errore in determinazione DAL op.'|| p_id_variazione ||':'|| SQLERRM;
                RAISE ERRORE;
              END;
           END IF; /* se cancellazione */
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             /* non trovato record in tabella con quella PK*/
              D_dal_uguale := 0;
              IF p_operazione = 'D' THEN
                 w_errore := 1;
                 w_messaggio := 'Corrisp. del periodo non trovata '||p_tabella;
                 RAISE ERRORE;
              END IF;
           WHEN OTHERS THEN
             w_errore := 1;
             w_messaggio := w_messaggio || ' ' || SQLERRM||' '||P_tabella;
             RAISE ERRORE;
         END;
         BEGIN
           /* se trovata corrispondenza con dal controlla in tabella se esiste record con lo stesso al nuovo */
           /* modificato 25/02/2004 usando solo al e non al precedente*/
           w_stringa := 'begin select to_char(al,''ddmmyyyy'') into piecadae.w_into from '||p_tabella||' '||w_condizioni||' and nvl(al,to_date(''3333333'',''j'')) = to_date(nvl('''||d_al||''',to_char(to_date(''3333333'',''j''),''ddmmyyyy'')),''ddmmyyyy''); end;';
           si4.sql_execute(w_stringa);
           D_al_uguale := 1;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             /* non esiste record con la PK cercata */
              D_al_uguale := 0;
              IF p_operazione = 'D' THEN
                 w_errore := 1;
                 w_messaggio := 'Corrisp. del periodo non trovata '||p_tabella;
                 RAISE ERRORE;
              END IF;
           WHEN OTHERS THEN
             w_errore := 1;
             w_messaggio := w_messaggio || ' ' || SQLERRM||' '||P_tabella;
             RAISE ERRORE;
         END;
         IF D_dal_uguale = 0 THEN
            /* non trovato record con dal uguale */
            BEGIN
              /* controlla sovrapposizione di periodi */
                 w_stringa := 'begin select to_char(dal,''ddmmyyyy'') into piecadae.w_into from '||p_tabella||' '||w_condizioni||' and to_date(nvl('||''''||d_dal_prec||''''||','||''''||d_dal||''''||'),''ddmmyyyy'') between dal and nvl(al,to_date(''3333333'',''j'')); end;';
                 si4.sql_execute(w_stringa);
              /* prepara le condizioni per l'aggiornamento*/
              IF P_operazione != 'D' THEN /* se non e delete */
                 w_frase_i_prec := '(';
                 w_campi_i_prec := '(';
                 FOR CUR_COL IN (
                   select column_name
                     from user_tab_columns
                    where table_name  = upper(p_tabella)
                 ) LOOP
                   w_frase_i_prec := w_frase_i_prec||','||CUR_COL.column_name;
                   select w_campi_i_prec||','||decode(upper(CUR_COL.column_name),'DAL','to_date('||''''||D_dal||''''||',''ddmmyyyy'')','UTENTE','''CADAE''','DATA_AGG',''''||sysdate||'''',CUR_COL.column_name)
                     into w_campi_i_prec
                     from dual
                   ;
                 END LOOP;
                 w_frase_i_prec := replace(w_frase_i_prec,'(,','(');
                 w_campi_i_prec := replace(w_campi_i_prec,'(,',' ');
                 BEGIN
                   /*Deve sistemare i periodi per congruenza*/
                   w_stringa := 'begin insert into '||p_tabella||' '||w_frase_i_prec||') select '||w_campi_i_prec||' from '||p_tabella||' '||w_condizioni||' and to_date(nvl('||''''||d_dal_prec||''''||','||''''||d_dal||''''||'),''ddmmyyyy'') between dal and nvl(al,to_date(''3333333'',''j'')); end;';
                   si4.sql_execute(w_stringa);
                 EXCEPTION
                   WHEN OTHERS THEN
                     w_errore := 1;
                     w_messaggio := 'Errore in inserimento(!=dal).Op.'|| p_id_variazione ||':'|| SQLERRM;
                     RAISE ERRORE;
                 END;
                 BEGIN
                   /* aggiorna il record per sistemare la chiusura*/
                   w_stringa := 'begin update '||p_tabella||' '||'set al = to_date('||''''||d_dal||''''||',''ddmmyyyy'') -1 '||w_condizioni||' and dal = to_date('||''''||piecadae.w_into||''''||',''ddmmyyyy''); end;';
                   si4.sql_execute(w_stringa);
                 EXCEPTION
                   WHEN OTHERS THEN
                     w_errore := 1;
                     w_messaggio :=  'Errore in aggiornamento(!=dal).Op:'|| p_id_variazione ||':'|| SQLERRM||' '||P_tabella;
                     RAISE ERRORE;
                 END;
              END IF; /* P_operazione !=D */
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                null;
              WHEN ERRORE THEN
                w_errore := 1;
                RAISE ERRORE;
              WHEN OTHERS THEN
                w_errore := 1;
                w_messaggio :=  w_messaggio || ' ' || SQLERRM||' '||P_tabella;
                RAISE ERRORE;
            END;
         END IF;
         IF D_al_uguale = 0 THEN
          /*non trovato il d_al uguale */
            BEGIN
              w_stringa := 'begin select to_char(dal,''ddmmyyyy'') into piecadae.w_into from '||p_tabella||' '||w_condizioni||' and to_date(nvl('||''''||d_al_prec||''''||',nvl('||''''||d_al||''''||',to_char(to_date(''3333333'',''j''),''ddmmyyyy''))),''ddmmyyyy'') between dal and nvl(al,to_date(''3333333'',''j'')); end;';
              si4.sql_execute(w_stringa);
              IF P_operazione != 'D' THEN
                 w_frase_i_prec := '(';
                 w_campi_i_prec := '(';
                 FOR CUR_COL IN (
                   select column_name
                     from user_tab_columns
                    where table_name  = upper(p_tabella)
                 ) LOOP
                   w_frase_i_prec := w_frase_i_prec||','||CUR_COL.column_name;
                   select w_campi_i_prec||','||decode(upper(CUR_COL.column_name),'DAL','to_date('||''''||D_al||''''||',''ddmmyyyy'') +1','UTENTE','''CADAE''','DATA_AGG',''''||sysdate||'''',CUR_COL.column_name)
                     into w_campi_i_prec
                     from dual
                   ;
                 END LOOP;
                 w_frase_i_prec := replace(w_frase_i_prec,'(,','(');
                 w_campi_i_prec := replace(w_campi_i_prec,'(,',' ');
                 BEGIN
                  /* insert*/
                   w_stringa := 'begin insert into '||p_tabella||' '||w_frase_i_prec||') select '||w_campi_i_prec||' from '||p_tabella||' '||w_condizioni||' and to_date(nvl('||''''||d_al_prec||''''||',nvl('||''''||d_al||''''||',to_char(to_date(''3333333'',''j''),''ddmmyyyy''))),''ddmmyyyy'') between dal and nvl(al,to_date(''3333333'',''j'')); end;';
                   si4.sql_execute(w_stringa);
                 EXCEPTION
                   WHEN OTHERS THEN
                     w_errore := 1;
                     w_messaggio :='Errore in inserimento(!=al).Op:'|| p_id_variazione ||':'||  SQLERRM||' '||P_tabella;
                     RAISE ERRORE;
                 END;
                 BEGIN
                   /* update*/
                    w_stringa := 'begin update '||p_tabella||' set al = to_date('||''''||d_al||''''||',''ddmmyyyy'')'||w_condizioni||' and dal = to_date('||''''||piecadae.w_into||''''||',''ddmmyyyy''); end;';
                    si4.sql_execute(w_stringa);
                 EXCEPTION
                   WHEN OTHERS THEN
                     w_errore := 1;
                     w_messaggio := 'Errore in aggiornamento(!=al).Op:'|| p_id_variazione ||':' || SQLERRM||' '||P_tabella;
                     RAISE ERRORE;
                 END;
              END IF;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                null;
              WHEN ERRORE THEN
                w_errore := 1;
                RAISE ERRORE;
              WHEN OTHERS THEN
                w_errore := 1;
                w_messaggio :=  w_messaggio || ' ' || SQLERRM||' '||P_tabella;
                RAISE ERRORE;
            END;
         END IF;
         /* trovato periodo con dal e al uguali */
         w_campi_u := replace(w_campi_u,'(,',' ');
         IF p_operazione != 'D' THEN
            /* se non e delete controllo aggiunto 25/02/2004*/
            if w_campi_u = '(' then
                w_errore := 1;
                w_messaggio := 'Non ci sono campi da aggiornare.Op:'|| p_id_variazione;
                raise ERRORE;
            end if;
            BEGIN /* passa solo se ci sono campi da aggiornare*/
                w_stringa := 'begin update '||p_tabella||' set '||w_campi_u||' '||w_condizioni||' and dal <= to_date(nvl('||''''||d_al_prec||''''||',nvl('||''''||d_al||''''||',to_char(to_date(''3333333'',''j''),''ddmmyyyy''))),''ddmmyyyy'') and nvl(al,to_date(''3333333'',''j'')) >= to_date(nvl('||''''||d_dal_prec||''''||','||''''||d_dal||''''||'),''ddmmyyyy''); end;';
                si4.sql_execute(w_stringa);
            EXCEPTION
              WHEN OTHERS THEN
                w_errore := 1;
                w_messaggio := 'Errore in aggiornamento(!=D).Op:'|| p_id_variazione ||':'|| SQLERRM||' '||P_tabella;
                RAISE ERRORE;
            END;
         ELSE /* e delete */
            w_campi_i_prec := replace(w_campi_i_prec,'(,',' ');
            BEGIN
              w_stringa := 'begin update '||p_tabella||' set ('||w_campi_i_prec||')= (select '||w_campi_i_prec||' from '||p_tabella||' '||w_condizioni||' and dal = (select max(dal) from '||p_tabella||' '||w_condizioni||' and dal < to_date('||''''||D_dal_prec||''''||',''ddmmyyyy''))) '||w_condizioni||'and dal = to_date('||''''||D_dal_prec||''''||',''ddmmyyyy''); end;';
              si4.sql_execute(w_stringa);
            EXCEPTION
              WHEN OTHERS THEN
                w_errore := 1;
                w_messaggio :='Errore in aggiornamento(=D).Op:'|| p_id_variazione ||':' ||  SQLERRM||' '||P_tabella;
                RAISE ERRORE;
            END;
         END IF;/* se non e delete*/
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
         /* se per la tavola NON esiste la colonna DAL */
           w_frase_i := 'insert into '||p_tabella||' (';
           w_campi_i := 'values (';
           w_frase_u := 'update '||p_tabella||' ';
           w_frase_d := 'Begin delete '||p_tabella;
           FOR CUR_W_VARI_C IN (
             select colonna_destinazione
                  , valore,valore_precedente
                  , causale,modificato
                  , data_type
             from w_variazioni
                , user_tab_columns
            where id_variazione = p_id_variazione
              and progressivo   = p_progressivo
              and tabella_destinazione = p_tabella
              and table_name  = upper(p_tabella)
              and column_name = upper(colonna_destinazione)
           ) LOOP
           IF CUR_W_VARI_C.modificato = 1 THEN
             w_frase_i := w_frase_i||','||CUR_W_VARI_C.colonna_destinazione;
             w_campi_i := w_campi_i||','||''''||rtrim(CUR_W_VARI_C.valore)||'''';
             w_campi_u := w_campi_u||','||CUR_W_VARI_C.colonna_destinazione||' = '||''''||rtrim(CUR_W_VARI_C.valore)||'''';
           END IF;
           IF CUR_W_VARI_C.causale = 'P' THEN
              w_condizioni := w_condizioni||' and '||CUR_W_VARI_C.colonna_destinazione||' = '||''''||rtrim(nvl(CUR_W_VARI_C.valore_precedente,CUR_W_VARI_C.valore))||'''';
           END IF;
         END LOOP;
         w_frase_i := replace(w_frase_i,'(,','(')||')';
         w_campi_i := replace(w_campi_i,'(,','(')||');';
         w_campi_u := replace(w_campi_u,'(,',' ');
         w_condizioni := replace(w_condizioni,'where  and','where ')||';';
         IF p_operazione = 'D' THEN
           /*riesegue la cancellazione */
            BEGIN
              si4.sql_execute(w_frase_d||' '||w_condizioni||' end;');
            EXCEPTION
              WHEN OTHERS THEN
                w_errore := 1;
                w_messaggio := 'Errore in cancellazione.Op:'|| p_id_variazione ||':'||  SQLERRM||' '||P_tabella;
                RAISE ERRORE;
            END;
         ELSE /* non Cancellazione */
           BEGIN
            /* esegue UPDATE ma se non aggiorna nessun record esegue INSERT */
             si4.sql_execute('begin '||w_frase_u||'set  '||w_campi_u||' '||w_condizioni||' if SQL%ROWCOUNT = 0 THEN '
                             ||w_frase_i||w_campi_i||'end if; end;');
           EXCEPTION
             WHEN OTHERS THEN
               w_errore := 1;
               w_messaggio :=  'Errore in aggiornamento o inserimento record.Op:'|| p_id_variazione ||':' || SQLERRM||' '||P_tabella;
               RAISE ERRORE;
           END;
         END IF;
       END;
   EXCEPTION
     WHEN ERRORE THEN
      contaerrori := contaerrori +1;
      insert into a_segnalazioni_errore
            ( NO_PRENOTAZIONE,
		  PASSO,
		  PROGRESSIVO,
		  ERRORE,
		  PRECISAZIONE
		 ) values
		 ( p_prenotazione,
		   1,
               contaerrori,
 		   'A08517',
		   substr(w_messaggio,1,50)
		 )
        ;
     END;
   END ALLINEA_DATO;
PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
  BEGIN
    DECLARE
      w_contatore                    number :=0;
      D_dummy                        VARCHAR2(1);
      D_valore                       VARCHAR2(4000);
      D_valore_precedente            VARCHAR2(4000);
      p_codice                       VARCHAR2(8);
      p_user_destinazione            VARCHAR2(30);
      p_user_provenienza             VARCHAR2(30);
    BEGIN
      BEGIN
        select valore
          into p_user_destinazione
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'P_USER_DESTINAZIONE'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_user_destinazione := ' ';
      END;
      BEGIN
        select valore
          into p_user_provenienza
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'P_USER_PROVENIENZA'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_user_provenienza := ' ';
      END;
      delete w_variazioni;
      w_into      := null;
      contaerrori :=0;
      w_errore    :=0;
      w_messaggio := null;
	  FOR CUR_DARE IN (
           select id_variazione,progressivo
             , operazione
             , tabella,colonna
             , valore,valore_precedente
             , variazioni.causale,variazioni.modificato
             , reco.user_provenienza,reco.user_destinazione
             , data_agg,
             reco.tabella_destinazione,reco.colonna_destinazione
          from variazioni
          , regole_conversioni reco
         where aggiornato = 0
           and variazioni.user_provenienza = p_user_provenienza
           and variazioni.user_destinazione = p_user_destinazione
           and reco.tabella_provenienza = variazioni.tabella
           and reco.colonna_provenienza = variazioni.colonna
         order by id_variazione,progressivo
        )LOOP
          insert into W_VARIAZIONI
          select CUR_DARE.id_variazione,1
               , CUR_DARE.progressivo,CUR_DARE.operazione
               , CUR_DARE.tabella,CUR_DARE.colonna
               , cur_dare.tabella_destinazione,cur_dare.colonna_destinazione
               , 'VARCHAR2', translate(CUR_DARE.valore,'''','`')
               , translate(CUR_DARE.valore_precedente,'''','`')
               , CUR_DARE.causale
               , CUR_DARE.modificato,P_USER_PROVENIENZA,null
               , CUR_dare.data_agg
           from dual
          ;
        END LOOP;
	  FOR CUR_W_VARI_F IN (
        select w_vari.id_variazione,w_vari.progressivo
             , w_vari.sequenza,w_vari.operazione
             , w_vari.tabella,w_vari.colonna
             , w_vari.valore,w_vari.valore_precedente,w_vari.causale
             , w_vari.modificato,w_vari.user_provenienza
             , w_vari.data_agg
             , reco.codifica_valore,reco.codifica_valore_precedente
          from w_variazioni w_vari
             , regole_conversioni reco
         where reco.tabella_provenienza = w_vari.tabella
           and reco.colonna_provenienza = w_vari.colonna
           and instr(upper(ltrim(reco.codifica_valore)),'FOR') = 1
         order by w_vari.id_variazione,w_vari.progressivo,w_vari.sequenza
      )LOOP
         DUPLICA_VALORE (prenotazione,passo,CUR_W_VARI_F.id_variazione,CUR_W_VARI_F.progressivo,CUR_W_VARI_F.colonna,ltrim(CUR_W_VARI_F.codifica_valore));
      END LOOP;
      /* trattamento di ogni variazione per gli user interessati */
      FOR CUR_VARI_S IN (
        select id_variazione,progressivo
             , operazione
             , tabella,colonna
             , tabella_destinazione, colonna_destinazione
             , valore,valore_precedente
             , causale,modificato
             , user_provenienza,user_destinazione
             , data_agg
          from W_variazioni
         where sequenza != 999
         order by id_variazione,progressivo
      )LOOP
         --dbms_output.put_line('id_variazione '||CUR_VARI_S.id_variazione);
         --dbms_output.put_line('progressivo   '||CUR_VARI_S.progressivo);
         --dbms_output.put_line('operazione    '||CUR_VARI_S.operazione);
         --dbms_output.put_line('tabella       '||CUR_VARI_S.colonna);
         --dbms_output.put_line('valore        '||CUR_VARI_S.valore);
         --dbms_output.put_line('valore_precedente '||CUR_VARI_S.valore_precedente);
         --dbms_output.put_line('causale       '||CUR_VARI_S.causale);
         --dbms_output.put_line('modificato    '||CUR_VARI_S.modificato);
         --dbms_output.put_line('data_agg      '||CUR_VARI_S.data_agg);
         w_errore := 0;
         /* tratta la tabella e la colonna solo se presente nelle regole conversioni*/
         FOR CUR_RECO IN (
           select reco.codifica_valore
                , reco.codifica_valore_precedente
                , reco.tabella_destinazione
                , reco.colonna_destinazione
                , reco.user_provenienza
                , reco.user_destinazione
             from regole_conversioni reco
            where reco.tabella_provenienza = CUR_VARI_S.tabella
              and reco.colonna_provenienza = CUR_VARI_S.colonna
              and reco.tabella_destinazione = CUR_VARI_S.tabella_destinazione
              and reco.colonna_destinazione = CUR_VARI_S.colonna_destinazione
              and reco.user_provenienza    = p_user_provenienza
              and reco.user_destinazione   = p_user_destinazione
              --and not(nvl(instr(upper(ltrim(reco.codifica_valore)),'FOR'),0) = 1)
             ) LOOP
               D_valore := null;
               D_valore_precedente := null;
               /* se frase di select bisogna attualizzare il valore */
               IF instr(upper(ltrim(CUR_RECO.codifica_valore)),'SELECT') = 1 THEN
                  /* il valore nuovo ha senso solo per insert e Update controllo aggiunto 25/02/2004*/
                  IF CUR_VARI_S.operazione in ('I','U') THEN
                    BEGIN
                      CODIFICA_VALORE (prenotazione,passo,CUR_VARI_S.id_variazione,CUR_VARI_S.progressivo,CUR_VARI_S.colonna,ltrim(CUR_RECO.codifica_valore),null);
                      D_valore := piecadae.w_into;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        null;
                    END;
                  END IF;
               END IF;
               piecadae.w_into := null;
              /*se nel valore precedente ho select (non capisco perche nvl) */
              IF instr(upper(ltrim(nvl(CUR_RECO.codifica_valore_precedente,CUR_RECO.codifica_valore))),'SELECT') = 1 THEN
                 /* il valore vecchio ha senso per Delete o Update */
                 IF CUR_VARI_S.operazione in ('D','U') and
                    CUR_VARI_S.valore_precedente is not null THEN /* controllo aggiunto 25/02/2004*/
                   BEGIN
                     CODIFICA_VALORE (prenotazione,passo,CUR_VARI_S.id_variazione,CUR_VARI_S.progressivo,CUR_VARI_S.colonna,null,ltrim(nvl(CUR_RECO.codifica_valore_precedente,CUR_RECO.codifica_valore)));
                     D_valore_precedente := piecadae.w_into;
                   EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                       null;
                   END;
                 END IF;
              END IF;
          IF (nvl(D_valore,' ') != 'NON TROVATO' and CUR_VARI_S.operazione = 'I')
              or ( CUR_VARI_S.operazione = 'U' and nvl(D_valore,' ') != 'NON TROVATO'
              and nvl(D_valore_precedente,' ') != 'NON TROVATO')
             or (CUR_VARI_S.operazione = 'D' and nvl(D_valore_precedente,' ') != 'NON TROVATO') THEN
             /* inserimento variazioni da trattare con gli statement di SELECT tradotti in valori*/
                 insert into w_variazioni
                 select CUR_VARI_S.id_variazione,CUR_VARI_S.progressivo
                      , 999,CUR_VARI_S.operazione
                      , CUR_VARI_S.tabella,CUR_VARI_S.colonna
                      , nvl(CUR_RECO.tabella_destinazione,CUR_VARI_S.tabella),nvl(CUR_RECO.colonna_destinazione,CUR_VARI_S.colonna)
                      , '*'
                      , nvl(D_valore,CUR_VARI_S.valore),D_valore_precedente --nvl(D_valore_precedente,CUR_VARI_S.valore_precedente) MODIFICATO 25/02/2004
                      , CUR_VARI_S.causale
                      , CUR_VARI_S.modificato,CUR_VARI_S.user_provenienza,CUR_VARI_S.user_destinazione
                      , CUR_VARI_S.data_agg
                   from dual
                 ;
               END IF;
             END LOOP;
           END LOOP;
           FOR CUR_W_VARI IN (
             select distinct id_variazione,progressivo
                  , tabella_destinazione ,operazione,tabella
               from w_variazioni
               where sequenza = 999 -- ATTENZIONE AGGIUNTO!!!!!!!!!!
              order by id_variazione,progressivo
           )LOOP
             w_errore := 0;
             /* trattamento dei record */
             ALLINEA_DATO(prenotazione,CUR_W_VARI.id_variazione,CUR_W_VARI.progressivo,CUR_W_VARI.tabella_destinazione,CUR_W_VARI.operazione);
             IF w_errore = 0 THEN
               update variazioni set aggiornato = 1
                where id_variazione = CUR_W_VARI.id_variazione
                  and progressivo   = CUR_W_VARI.progressivo
                  and tabella = CUR_W_VARI.tabella
               ;
             END IF;
           END LOOP;
/*
           delete w_variazioni
           ;
*/
         END;
       END;
END;
/
