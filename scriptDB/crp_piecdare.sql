CREATE OR REPLACE PACKAGE PIECDARE IS
w_into         varchar2(4000);
contaerrori    number:=0;
w_errore       number :=0;
/******************************************************************************
 NOME:          PIECDARE CREAZIONE DATI REPLICA
 DESCRIZIONE:
	Procedura che replica i dati registrati nell'ambiente SIA e li registra nel formato richiesto
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    09/10/2003
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
FUNCTION  RITORNA_VALORE  (p_id_variazione varchar2,p_progressivo varchar2,p_colonna varchar2,p_flag number) RETURN varchar2;
PROCEDURE CODIFICA_VALORE(p_prenotazione number, p_passo number,p_id_variazione IN varchar2,p_progressivo IN varchar2,p_colonna IN varchar2,P_codifica_valore varchar2,P_codifica_valore_precedente varchar2);
PROCEDURE DUPLICA_VALORE (p_prenotazione number, p_passo number,p_id_variazione IN varchar2,p_progressivo IN varchar2,p_colonna IN varchar2,P_codifica_valore varchar2);
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PIECDARE IS
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 09/10/2003';
   END VERSIONE;
FUNCTION RITORNA_VALORE (p_id_variazione varchar2,p_progressivo varchar2,p_colonna varchar2,p_flag number) RETURN varchar2 is
 d_valore              varchar2(4000);
 d_valore_precedente   varchar2(4000);
 d_tipo_dato           varchar2(200);
BEGIN
  BEGIN
    select decode(upper(tipo_dato),'NUMBER',valore,''''||valore||'''')
         , decode(upper(tipo_dato),'NUMBER',valore_precedente,''''||valore_precedente||'''')
         , upper(tipo_dato)
      into d_valore,d_valore_precedente,d_tipo_dato
      from w_variazioni
     where id_variazione = p_id_variazione
       and progressivo   = p_progressivo
       and colonna       = upper(p_colonna)
       and sequenza     != 999
     ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      d_valore := '''''';
      d_valore_precedente := '''''';
  END;
  IF p_flag = 1 THEN
    return nvl(d_valore,'''''');
  ELSE
    return nvl(d_valore_precedente,'''''');
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
      piecdare.w_into := 'NON TROVATO';
      WHEN OTHERS THEN
       contaerrori := contaerrori +1;
       w_errore := 1;
       piecdare.w_into := 'NON TROVATO';
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
                            ||' and progressivo = piecdare.w_into and colonna ='||''''||upper(w_campo)||''''||';' ;
      w_for := substr(w_for,instr(upper(w_for),'"',1,2)+1);
    END LOOP;
    piecdare.w_into := 0;
    w_frase := w_frase||' piecdare.w_into := piecdare.w_into +1; insert into w_variazioni select id_variazione,piecdare.w_into'
                      ||', sequenza,operazione,tabella,colonna,tabella_destinazione,colonna_destinazione,tipo_dato,valore,valore_precedente'
                      ||',causale,modificato,user_provenienza,user_destinazione,data_agg'
                      ||' from w_variazioni w where id_variazione = '||p_id_variazione||' and progressivo = 1'
                      ||' and not exists (select 1 from w_variazioni where id_variazione ='||p_id_variazione
                      ||' and w.tabella = tabella and w.colonna = colonna'
                      ||' and progressivo = piecdare.w_into);';
    w_frase1 := ' '||w_update1;
    w_frase2 := 'end loop; end;';
    BEGIN
      si4.sql_execute(w_frase||w_frase1||w_frase2);
    EXCEPTION
      WHEN OTHERS THEN
       contaerrori := contaerrori +1;
       w_errore := 1;
       piecdare.w_into := 'NON TROVATO';
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
PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
  BEGIN
    DECLARE
      w_contatore                    number :=0;
      D_dummy                        VARCHAR2(1);
      D_valore                       VARCHAR2(4000);
      D_valore_precedente            VARCHAR2(4000);
      D_replica_id                   NUMBER;
      p_codice                       VARCHAR2(8);
      p_user_destinazione            VARCHAR2(30);
      p_user_provenienza             VARCHAR2(30);
      p_tipo_lancio                  VARCHAR2(1);
    BEGIN
      BEGIN
        select valore
          into p_codice
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'P_CODICE'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_codice := ' ';
      END;
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
      BEGIN
        select valore
          into p_tipo_lancio
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'P_TIPO_LANCIO'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_tipo_lancio := ' ';
      END;
      BEGIN
        select min(replica_id)
          into D_replica_id
          from vista_operazioni_replica opre
         where opre.allineato = 0
           and opre.codice = p_codice
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          D_replica_id := '';
      END;
      IF p_tipo_lancio = 'I' THEN
         sia_replayset.inizia(D_replica_id);
      ELSIF p_tipo_lancio = 'G' THEN
         sia_replayset.copia(D_replica_id);
      END IF;
      delete w_variazioni;
      contaerrori :=0;
      FOR CUR_OPRE IN (
        select opre_id,owner
             , tabella,operazione
             , data
          from vista_operazioni_replica opre
         where opre.allineato = 0
--           and opre_id = 261223
           and opre.codice = p_codice
        order by opre_id
      )LOOP
        w_errore := 0;
        delete from variazioni
         where id_variazione = CUR_OPRE.opre_id
           and aggiornato != 0
        ;
        IF SQL%ROWCOUNT != 0 THEN
           contaerrori := contaerrori +1;
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
 		   'A00002',
		   substr('e replicata con poss. errori dell''oper. n. '||CUR_OPRE.opre_id,1,50)
		 );
        END IF;
        FOR CUR_DARE IN (
          select progressivo,colonna
               , decode(upper(tipo_dato),'DATE',decode(valore,null,null,to_char(to_date(valore,'yyyymmddhh24miss'),'ddmmyyyy')),valore) valore
               , decode(upper(tipo_dato),'DATE',decode(valore_precedente,null,null,to_char(to_date(valore_precedente,'yyyymmddhh24miss'),'ddmmyyyy')),valore_precedente) valore_precedente
               , causale,modificato,tipo_dato
            from dati_replica dare
           where dare.opre_id = CUR_OPRE.opre_id
          order by progressivo
        )LOOP
          insert into W_VARIAZIONI
          select CUR_OPRE.opre_id,1
               , CUR_DARE.progressivo,CUR_OPRE.operazione
               , CUR_OPRE.tabella,CUR_DARE.colonna
               , null,null
               , CUR_DARE.tipo_dato, translate(CUR_DARE.valore,'''','`')
               , translate(CUR_DARE.valore_precedente,'''','`')
               , CUR_DARE.causale
               , CUR_DARE.modificato,CUR_OPRE.owner,null
               , CUR_OPRE.data
           from dual
          ;
        END LOOP;
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
           and instr(upper(ltrim(nvl(reco.codifica_valore_precedente,reco.codifica_valore))),'FOR') = 1
         order by w_vari.id_variazione,w_vari.progressivo,w_vari.sequenza
      )LOOP
         DUPLICA_VALORE (prenotazione,passo,CUR_W_VARI_F.id_variazione,CUR_W_VARI_F.progressivo,CUR_W_VARI_F.colonna,ltrim(CUR_W_VARI_F.codifica_valore));
      END LOOP;
      FOR CUR_W_VARI_S IN (
        select w_vari.id_variazione,w_vari.progressivo
             , w_vari.sequenza,w_vari.operazione
             , w_vari.tabella,w_vari.colonna
             , w_vari.valore,w_vari.valore_precedente
             , w_vari.tipo_dato, w_vari.causale
             , w_vari.modificato,w_vari.user_provenienza
             , w_vari.data_agg
          from w_variazioni w_vari
         where w_vari.sequenza != 999
         order by w_vari.id_variazione,w_vari.progressivo,w_vari.sequenza
      )LOOP
        w_errore := 0;
        FOR CUR_RECO IN (
          select reco.codifica_valore
               , reco.codifica_valore_precedente
               , reco.tabella_destinazione
               , reco.colonna_destinazione
               , reco.user_provenienza
               , reco.user_destinazione
            from regole_conversioni reco
           where reco.tabella_provenienza = CUR_W_VARI_S.tabella
             and reco.colonna_provenienza = CUR_W_VARI_S.colonna
             and reco.user_provenienza = p_user_provenienza
             and reco.user_destinazione   = p_user_destinazione
        ) LOOP
          D_valore := null;
          D_valore_precedente := null;
          IF instr(upper(ltrim(CUR_RECO.codifica_valore)),'SELECT') = 1 THEN
            IF CUR_W_VARI_S.operazione in ('I','U') THEN
              BEGIN
                CODIFICA_VALORE (prenotazione,passo,CUR_W_VARI_S.id_variazione,CUR_W_VARI_S.progressivo,CUR_W_VARI_S.colonna,ltrim(CUR_RECO.codifica_valore),null);
                D_valore := piecdare.w_into;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    null;
               END;
            END IF;
          END IF;
          IF instr(upper(ltrim(CUR_RECO.codifica_valore)),'FOR') = 1 and instr(upper(ltrim(CUR_RECO.codifica_valore_precedente)),'SELECT') = 1 THEN
            IF CUR_W_VARI_S.operazione in ('I','U') THEN
              BEGIN
                CODIFICA_VALORE (prenotazione,passo,CUR_W_VARI_S.id_variazione,CUR_W_VARI_S.progressivo,CUR_W_VARI_S.colonna,ltrim(CUR_RECO.codifica_valore_precedente),null);
                D_valore := piecdare.w_into;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    null;
               END;
            END IF;
          END IF;
          IF instr(upper(ltrim(nvl(CUR_RECO.codifica_valore_precedente,CUR_RECO.codifica_valore))),'SELECT') = 1 THEN
            IF CUR_W_VARI_S.operazione in ('D','U') THEN
              BEGIN
                CODIFICA_VALORE (prenotazione,passo,CUR_W_VARI_S.id_variazione,CUR_W_VARI_S.progressivo,CUR_W_VARI_S.colonna,null,ltrim(nvl(CUR_RECO.codifica_valore_precedente,CUR_RECO.codifica_valore)));
                D_valore_precedente := piecdare.w_into;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  null;
              END;
            END IF;
          END IF;
          IF (nvl(D_valore,' ') != 'NON TROVATO' and CUR_W_VARI_S.operazione = 'I') or ( CUR_W_VARI_S.operazione = 'U' and nvl(D_valore,' ') != 'NON TROVATO' and nvl(D_valore_precedente,' ') != 'NON TROVATO')
             or (CUR_W_VARI_S.operazione = 'D' and nvl(D_valore_precedente,' ') != 'NON TROVATO') THEN
            insert into w_variazioni
            select CUR_W_VARI_S.id_variazione,CUR_W_VARI_S.progressivo
                 , 999,CUR_W_VARI_S.operazione
                 , CUR_W_VARI_S.tabella,CUR_W_VARI_S.colonna
                 , nvl(CUR_RECO.tabella_destinazione,CUR_W_VARI_S.tabella),nvl(CUR_RECO.colonna_destinazione,CUR_W_VARI_S.colonna)
                 , CUR_W_VARI_S.tipo_dato
                 , nvl(D_valore,CUR_W_VARI_S.valore),nvl(D_valore_precedente,CUR_W_VARI_S.valore_precedente)
                 , CUR_W_VARI_S.causale
                 , CUR_W_VARI_S.modificato,CUR_W_VARI_S.user_provenienza,CUR_RECO.user_destinazione
                 , CUR_W_VARI_S.data_agg
              from dual
             ;
          END IF;
        END LOOP;
        IF w_errore = 0 THEN
          SIA_REPLAYEXEC.Set_Allineato (CUR_W_VARI_S.id_variazione);
        END IF;
      END LOOP;
      insert into variazioni
      select w_vari.id_variazione,w_vari.progressivo
           , w_vari.operazione,w_vari.tabella_destinazione
           , w_vari.colonna_destinazione,w_vari.valore
           , w_vari.valore_precedente
           , w_vari.causale, w_vari.modificato
           , w_vari.user_provenienza,w_vari.user_destinazione
           , data_agg,0
        from w_variazioni w_vari
       where w_vari.tabella_destinazione is not null
         and w_vari.colonna_destinazione is not null
      ;
/*
      IF prenotazione != 0 THEN
         delete w_variazioni;
      END IF;
*/
    END;
  END;
END;
/
