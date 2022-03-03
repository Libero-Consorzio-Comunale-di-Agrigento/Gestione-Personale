CREATE OR REPLACE PACKAGE pecccava IS
/******************************************************************************
 NOME:        PECCCAVA
 DESCRIZIONE: Creazione delle registrazioni precalcolate per la fase di stampa
              delle ESTRAZIONI PARAMETRICHE.
              Questa funzione inserisce nella tavola di lavoro CALCOLO_VALORI le
              registrazioni estratte dalle viste generate in modo parametrico sui
              valori contabili della mensilita` richiesta.
              Il passo successivo produrra` la stampa della Estrazione Parametrica
              richiesta.
              Una fase ancora seguente si occupera` della eliminazione delle registra-
              zioni inserite nella tavola CALCOLO_VALORI.
              
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (P_prenotazione in number, passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY pecccava IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
PROCEDURE MAIN (P_prenotazione in number, passo in number)IS
 BEGIN
DECLARE
P_estrazione   varchar2(30);
P_da_anno      varchar2(4);
P_da_mensilita varchar2(4);
P_da_cod_mens  varchar2(4);
P_da_mese      varchar2(2);
P_a_anno       varchar2(4);
P_a_mensilita  varchar2(4);
P_a_cod_mens   varchar2(4);
P_a_mese       varchar2(2);
P_filtro_1     varchar2(15);
P_filtro_2     varchar2(15);
P_filtro_3     varchar2(15);
P_filtro_4     varchar2(15);
P_prova    varchar2(4);
D_ente     varchar2(8);
D_utente   varchar2(8);
D_ambiente varchar2(8);
BEGIN
  BEGIN
--PROMPT  Estrazione Parametri di Selezione della Prenotazione
      select valore D_estrazione
	    into P_estrazione
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro       = 'P_ESTRAZIONE'
      ;

  BEGIN
    SELECT ENTE     D_ente
         , utente   D_utente
         , ambiente D_ambiente
      INTO D_ente,D_utente,D_ambiente
      FROM a_prenotazioni
     WHERE no_prenotazione = P_prenotazione
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_ente     := NULL;
      D_utente   := NULL;
      D_ambiente := NULL;
  END;

begin
      select valore D_da_anno
	    into P_da_anno
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_DA_ANNO'
      ;
exception
  when no_data_found then
p_da_anno := null;
end;
begin
      select valore D_da_mensilita
	    into P_da_mensilita
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_DA_MENSILITA'
      ;
exception
  when no_data_found then
p_da_mensilita := null;
end;
begin
    select to_char(mese) D_da_mese
           , mensilita     D_da_cod_mens
		into P_da_mese, P_da_cod_mens
        from mensilita
       where codice = P_da_mensilita
      ;
exception -- CODICE NUOVO
  when no_data_found then
     begin
      select nvl(P_da_anno,to_char(anno)) D_da_anno
           , nvl(P_da_mese,to_char(mese)) D_da_mese
           , nvl(P_da_cod_mens,mensilita) D_da_cod_mens
		into P_da_anno, P_da_mese, P_da_cod_mens
        from riferimento_retribuzione
       where rire_id = 'RIRE'
	    AND  P_da_mensilita IS NULL
      ;
     exception
      when no_data_found then
	     P_da_anno := 0;
		 P_da_mese := 0;
		 P_da_cod_mens := '';
   end;
	
end;
begin

      select valore D_a_anno
	    into P_a_anno
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_A_ANNO'
      ;
exception
  when no_data_found then
p_a_anno := null;
end;
begin

      select valore D_a_mensilita
	    into P_a_mensilita
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_A_MENSILITA'
      ;
exception
  when no_data_found then
p_a_mensilita := null;
end;
begin

      select to_char(mese) D_a_mese
           , mensilita     D_a_cod_mens
		into P_a_mese, P_a_cod_mens
        from mensilita
       where codice = P_a_mensilita
      ;
exception
  when no_data_found then
p_a_mese := null;
p_a_mensilita :=null;
end;
begin

      select valore D_filtro_1
	    into P_filtro_1
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_FILTRO_1'
      ;
exception
  when no_data_found then
p_filtro_1 := '%';
end;
begin

      select valore D_filtro_2
	    into P_filtro_2
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_FILTRO_2'
      ;
exception
  when no_data_found then
p_filtro_2 := '%';
end;
begin

      select valore D_filtro_3
	    into P_filtro_3
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_FILTRO_3'
      ;
exception
  when no_data_found then
p_filtro_3 := '%';
end;
begin

      select valore D_filtro_4
	    into P_filtro_4
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_FILTRO_4'
      ;
exception
  when no_data_found then
p_filtro_4 := '%';
end;
end;

--PROMPT  -- Creazione delle registrazioni per Estrazione Parametrica
    si4.sql_execute('
	  insert into CALCOLO_VALORI
           ( prenotazione
           , s1, s2, s3, s4, s5, s6, ci, anno, mese
           , c1, c2, c3, c4, c5, c6
           , d1, d2, d3, d4, d5, d6
           , col1, col2, col3 , col4 , col5 , col6 , col7
           , col8, col9, col10, col11, col12, col13, col14
           )
      select '|| P_prenotazione ||'
           , s1, s2, s3, s4, s5, s6, ci, max(anno), max(mese)
           , c1, c2, c3, c4, c5, c6
           , d1, d2, d3, d4, d5, d6
           , sum(col1)
           , sum(col2)
           , sum(col3)
           , sum(col4)
           , sum(col5)
           , sum(col6)
           , sum(col7)
           , sum(col8)
           , sum(col9)
           , sum(col10)
           , sum(col11)
           , sum(col12)
           , sum(col13)
           , sum(col14)
        from REPORT_'||P_estrazione||' 
       where (anno,mese,mensilita) in
            (select mesi.anno,mesi.mese,mens.mensilita
               from mesi,mensilita mens
              where mesi.anno||lpad(mesi.mese,2,0)||mens.mensilita
                    between '|| P_da_anno||' ||
                            lpad('|| P_da_mese ||',2,0)||
                            '''|| P_da_cod_mens ||'''
                        and nvl('''|| P_a_anno||''','||P_da_anno||')||
                            lpad(nvl('''||P_a_mese||''','||P_da_mese||'),2,0)||
                            nvl('''||P_a_cod_mens||''','''|| P_da_cod_mens||''')
                and mesi.mese = mens.mese
            )
      and exists     
        (select ''x''
         from rapporti_individuali rain
        where rain.ci = REPORT_'||P_estrazione||'.ci 
          and (   rain.cc is null
               or exists
                 (select ''x''
                    from a_competenze 
                    where ente        = '''||D_ente||'''
                      and ambiente    = '''||D_ambiente||'''
                      and utente      = '''||D_utente||'''
                      and competenza  = ''CI''
                      and oggetto     = rain.cc
                 )
              ) 
      )
         and nvl(c1,'' '') like nvl('''|| P_filtro_1||''',''%'')
         and nvl(c2,'' '') like nvl('''|| P_filtro_2||''',''%'')
         and nvl(c3,'' '') like nvl('''|| P_filtro_3||''',''%'')
         and nvl(c4,'' '') like nvl('''|| P_filtro_4||''',''%'')
       group by s1, s2, s3, s4, s5, s6, ci
              , c1, c2, c3, c4, c5, c6
              , d1, d2, d3, d4, d5, d6
      having nvl(abs(sum(col1)),0)
           + nvl(abs(sum(col2)),0)
           + nvl(abs(sum(col3)),0)
           + nvl(abs(sum(col4)),0)
           + nvl(abs(sum(col5)),0)
           + nvl(abs(sum(col6)),0)
           + nvl(abs(sum(col7)),0)
           + nvl(abs(sum(col8)),0)
           + nvl(abs(sum(col9)),0)
           + nvl(abs(sum(col10)),0)
           + nvl(abs(sum(col11)),0)
           + nvl(abs(sum(col12)),0)
           + nvl(abs(sum(col13)),0)
           + nvl(abs(sum(col14)),0) != 0')
		   ;
--PROMPT  --  Aggiorna Colonne per Assestamento
BEGIN
   FOR CURS IN
      (select colonna
            , moltiplica
            , arrotonda
            , divide
         from estrazione_valori_contabili
        where estrazione = P_estrazione
          and (   nvl(moltiplica,1) != 1
               or nvl(arrotonda,0)  != 0
               or nvl(divide,1)     != 1
              )
      )
   LOOP
      BEGIN
         IF curs.colonna = '01' THEN
            update calcolo_valori
               set col1 = round( round( col1 * nvl(curs.moltiplica,1)
                                      / nvl(curs.arrotonda,1)
                                      + decode(sign(curs.arrotonda),-1,.4999,0)
                                      , decode(curs.arrotonda,null,2,0)
                                      )
                               * nvl(curs.arrotonda,1) / nvl(curs.divide,1)
                               , decode(curs.arrotonda,null,2,0)
                               )
             where prenotazione = P_prenotazione
            ;
         END IF;
         IF curs.colonna = '02' THEN
            update calcolo_valori
               set col2 = round( round( col2 * nvl(curs.moltiplica,1)
                                      / nvl(curs.arrotonda,1)
                                      + decode(sign(curs.arrotonda),-1,.4999,0)
                                      , decode(curs.arrotonda,null,2,0)
                                      )
                               * nvl(curs.arrotonda,1) / nvl(curs.divide,1)
                               , decode(curs.arrotonda,null,2,0)
                               )
             where prenotazione = P_prenotazione
            ;
         END IF;
         IF curs.colonna = '03' THEN
            update calcolo_valori
               set col3 = round( round( col3 * nvl(curs.moltiplica,1)
                                      / nvl(curs.arrotonda,1)
                                      + decode(sign(curs.arrotonda),-1,.4999,0)
                                      , decode(curs.arrotonda,null,2,0)
                                      )
                               * nvl(curs.arrotonda,1) / nvl(curs.divide,1)
                               , decode(curs.arrotonda,null,2,0)
                               )
             where prenotazione = P_prenotazione
            ;
         END IF;
         IF curs.colonna = '04' THEN
            update calcolo_valori
               set col4 = round( round( col4 * nvl(curs.moltiplica,1)
                                      / nvl(curs.arrotonda,1)
                                      + decode(sign(curs.arrotonda),-1,.4999,0)
                                      , decode(curs.arrotonda,null,2,0)
                                      )
                               * nvl(curs.arrotonda,1) / nvl(curs.divide,1)
                               , decode(curs.arrotonda,null,2,0)
                               )
             where prenotazione = P_prenotazione
            ;
         END IF;
         IF curs.colonna = '05' THEN
            update calcolo_valori
               set col5 = round( round( col5 * nvl(curs.moltiplica,1)
                                      / nvl(curs.arrotonda,1)
                                      + decode(sign(curs.arrotonda),-1,.4999,0)
                                      , decode(curs.arrotonda,null,2,0)
                                      )
                               * nvl(curs.arrotonda,1) / nvl(curs.divide,1)
                               , decode(curs.arrotonda,null,2,0)
                               )
             where prenotazione = P_prenotazione
            ;
         END IF;
         IF curs.colonna = '06' THEN
            update calcolo_valori
               set col6 = round( round( col6 * nvl(curs.moltiplica,1)
                                      / nvl(curs.arrotonda,1)
                                      + decode(sign(curs.arrotonda),-1,.4999,0)
                                      , decode(curs.arrotonda,null,2,0)
                                      )
                               * nvl(curs.arrotonda,1) / nvl(curs.divide,1)
                               , decode(curs.arrotonda,null,2,0)
                               )
             where prenotazione = P_prenotazione
            ;
         END IF;
         IF curs.colonna = '07' THEN
            update calcolo_valori
               set col7 = round( round( col7 * nvl(curs.moltiplica,1)
                                      / nvl(curs.arrotonda,1)
                                      + decode(sign(curs.arrotonda),-1,.4999,0)
                                      , decode(curs.arrotonda,null,2,0)
                                      )
                               * nvl(curs.arrotonda,1) / nvl(curs.divide,1)
                               , decode(curs.arrotonda,null,2,0)
                               )
             where prenotazione = P_prenotazione
            ;
         END IF;
         IF curs.colonna = '08' THEN
            update calcolo_valori
               set col8 = round( round( col8 * nvl(curs.moltiplica,1)
                                      / nvl(curs.arrotonda,1)
                                      + decode(sign(curs.arrotonda),-1,.4999,0)
                                      , decode(curs.arrotonda,null,2,0)
                                      )
                               * nvl(curs.arrotonda,1) / nvl(curs.divide,1)
                               , decode(curs.arrotonda,null,2,0)
                               )
             where prenotazione = P_prenotazione
            ;
         END IF;
         IF curs.colonna = '09' THEN
            update calcolo_valori
               set col9 = round( round( col9 * nvl(curs.moltiplica,1)
                                      / nvl(curs.arrotonda,1)
                                      + decode(sign(curs.arrotonda),-1,.4999,0)
                                      , decode(curs.arrotonda,null,2,0)
                                      )
                               * nvl(curs.arrotonda,1) / nvl(curs.divide,1)
                               , decode(curs.arrotonda,null,2,0)
                               )
             where prenotazione = P_prenotazione
            ;
         END IF;
         IF curs.colonna = '10' THEN
            update calcolo_valori
               set col10 = round( round( col10 * nvl(curs.moltiplica,1)
                                       / nvl(curs.arrotonda,1)
                                       + decode( sign(curs.arrotonda)
                                               , -1, .4999, 0)
                                       , decode(curs.arrotonda,null,2,0)
                                       )
                                * nvl(curs.arrotonda,1) / nvl(curs.divide,1)
                                , decode(curs.arrotonda,null,2,0)
                                )
             where prenotazione = P_prenotazione
            ;
         END IF;
         IF curs.colonna = '11' THEN
            update calcolo_valori
               set col11 = round( round( col11 * nvl(curs.moltiplica,1)
                                       / nvl(curs.arrotonda,1)
                                       + decode( sign(curs.arrotonda)
                                               , -1, .4999, 0)
                                       , decode(curs.arrotonda,null,2,0)
                                       )
                                * nvl(curs.arrotonda,1) / nvl(curs.divide,1)
                                , decode(curs.arrotonda,null,2,0)
                                )
             where prenotazione = P_prenotazione
            ;
         END IF;
         IF curs.colonna = '12' THEN
            update calcolo_valori
               set col12 = round( round( col12 * nvl(curs.moltiplica,1)
                                       / nvl(curs.arrotonda,1)
                                       + decode( sign(curs.arrotonda)
                                               , -1, .4999, 0)
                                       , decode(curs.arrotonda,null,2,0)
                                       )
                                * nvl(curs.arrotonda,1) / nvl(curs.divide,1)
                                , decode(curs.arrotonda,null,2,0)
                                )
             where prenotazione = P_prenotazione
            ;
         END IF;
         IF curs.colonna = '13' THEN
            update calcolo_valori
               set col13 = round( round( col13 * nvl(curs.moltiplica,1)
                                       / nvl(curs.arrotonda,1)
                                       + decode( sign(curs.arrotonda)
                                               , -1, .4999, 0)
                                       , decode(curs.arrotonda,null,2,0)
                                       )
                                * nvl(curs.arrotonda,1) / nvl(curs.divide,1)
                                , decode(curs.arrotonda,null,2,0)
                                )
             where prenotazione = P_prenotazione
            ;
         END IF;
         IF curs.colonna = '14' THEN
            update calcolo_valori
               set col14 = round( round( col14 * nvl(curs.moltiplica,1)
                                       / nvl(curs.arrotonda,1)
                                       + decode( sign(curs.arrotonda)
                                               , -1, .4999, 0)
                                       , decode(curs.arrotonda,null,2,0)
                                       )
                                * nvl(curs.arrotonda,1) / nvl(curs.divide,1)
                                , decode(curs.arrotonda,null,2,0)
                                )
             where prenotazione = P_prenotazione
            ;
         END IF;
      END;
   END LOOP;
END;
--PROMPT  -- Aggiornamento Passi per Esecuzione PECSEPTO
BEGIN
  update a_prenotazioni set prossimo_passo = 10
   where no_prenotazione = P_prenotazione
     and exists (select 'x' from calcolo_valori
                  where prenotazione = P_prenotazione
                    and s5||s6 = '**'
                )
  ;
END;
COMMIT;
END;
END;
END;
/

