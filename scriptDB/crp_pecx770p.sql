CREATE OR REPLACE PACKAGE PECX770P IS
/******************************************************************************
 NOME:        PECX770P 
 DESCRIZIONE: Inserimento in denuncia inpdap ritenute carico dip.
              spezzati per modello 770/2005 - caselle 97/98/99 parte C

 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  27/05/2005 MS     Prima Emissione
 1.1  06/07/2005 MS     modifica per att. 11764.3
 1.2  16/08/2005 ML     modifica per att. 12359
 1.3  05/09/2005 MS     modifica per att. 12359 - seconda parte
 1.4  15/09/2005 MS     Aggiunti controlli su imp negativi e alq errate att 12623
 1.5  21/09/2005 MS     Mod. dimensione variabile - att 12741
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECX770P IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.5 del 21/09/2005';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
BEGIN
DECLARE
  P_anno          varchar(4);
  P_gestione      varchar(4);
  P_previdenza    varchar(6);
  P_tipo          varchar(1);
  P_ci            number(8);
  D_fin_a         varchar2(8);

  D_ente          varchar(4);
  D_ambiente      varchar(8);
  D_utente        varchar(8);

  P_riga          number;
  P_testo         varchar2(500);
  P_testo1        varchar2(80);
  P_testo1a       varchar2(80);
  P_testo2        varchar2(80);
  P_testo2a       varchar2(80);
  P_testo3        varchar2(80);
  P_testo3a       varchar2(80);

  I_rit_inpdap    number(15,2) := 0;
  I_rit_tfs       number(15,2) := 0;
  I_contr_tfr     number(15,2) := 0;
  Dep_dal         date;
  V_conta_per     number;

  dep_dal_arr     date;
  V_conta_arr     number(3);
  V_ipn_arr_cp    number(15,2) := 0;
  V_rit_arr_cp    number(15,2) := 0;
  V_rit_arr_cp_new number(15,2) := 0;
  V_alq_arr_cp    number(5,2)  := 0;
  V_arrotonda_cp  varchar2(1)  := 'S';
  V_ipn_arr_tfs   number(15,2) := 0;
  V_rit_arr_tfs   number(15,2) := 0;
  V_rit_arr_tfs_new number(15,2) := 0;
  V_alq_arr_tfs    number(5,2)  := 0;
  V_arrotonda_tfs  varchar2(1)  := 'S';
  V_ipn_arr_tfr   number(15,2) := 0;
  V_contr_arr_tfr   number(15,2) := 0;
  V_contr_arr_tfr_new number(15,2) := 0;
  V_alq_arr_tfr    number(5,2)  := 0;
  V_arrotonda_tfr  varchar2(1)  := 'S';

  V_casella97     number(15,2) := 0;
  V_casella98     number(15,2) := 0;
  V_casella99     number(15,2) := 0;
  V_diff_97       number(15,2) := 0;
  V_diff_98       number(15,2) := 0;
  V_diff_99       number(15,2) := 0;
  V_tot_rit_inpdap number(15,2) := 0;
  V_tot_rit_tfs   number(15,2) := 0;
  V_tot_contr_tfr number(15,2) := 0;
  V_tot97a        number(15,2) := 0;
  V_tot98a        number(15,2) := 0;
  V_tot99a        number(15,2) := 0;
  V_tot97b        number(15,2) := 0;
  V_tot98b        number(15,2) := 0;
  V_tot99b        number(15,2) := 0;

  V_totente97a    number(15,2) := 0;
  V_totente98a    number(15,2) := 0;
  V_totente99a    number(15,2) := 0;
  V_totente97b    number(15,2) := 0;
  V_totente98b    number(15,2) := 0;
  V_totente99b    number(15,2) := 0;

  V_errore        VARCHAR2(6);

  USCITA EXCEPTION;
--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN
BEGIN
  select valore, '3112'||valore
    into P_anno, D_fin_a
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_ANNO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       select anno, '3112'||anno
         into P_anno, D_fin_a
         from riferimento_fine_anno;
END;
BEGIN
  select valore
    into P_tipo
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_TIPO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_tipo := null;
END;
BEGIN
  select valore
    into P_ci
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_CI'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    P_ci := 0;
END;
IF nvl(P_ci,0) = 0 and P_tipo = 'S' THEN
     V_errore := 'A05721';
     RAISE USCITA;
ELSIF nvl(P_ci,0) != 0 and P_tipo = 'T' THEN
     V_errore := 'A05721';
     RAISE USCITA; 
END IF;

BEGIN
  select valore
    into P_previdenza
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_PREVIDENZA'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_previdenza := null;
END;
BEGIN
  select valore
    into P_gestione
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_GESTIONE'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_gestione := null;
END;

BEGIN
  select ente     D_ente
       , utente   D_utente
       , ambiente D_ambiente
    into D_ente,D_utente,D_ambiente
    from a_prenotazioni
   where no_prenotazione = prenotazione
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_ente     := null;
       D_utente   := null;
       D_ambiente := null;
END;

   BEGIN
-- inserimento testata per stampa
   P_riga := 1;  
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad('Cod.Ind.',10,' ')
        ||lpad('Nominativo',50,' ')
        ||lpad('Data Nas',15,' ')
     from dual
   ;
   P_riga := 2;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad(' ',20,' ')
        ||lpad('Inpdap',20,' ')
        ||lpad('TFS',20,' ')
        ||lpad('TFR',20,' ')
     from dual
   ;
   P_riga := 3;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad('-',132,'-')
     from dual
   ;
   P_riga := 4;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad(' ',132,' ')
     from dual
   ;
   P_riga := 5;
   END;
-- azzeramento contributi in caso di ri-elaborazione

   update denuncia_inpdap dedp
      set rit_inpdap = 0
        , rit_tfs    = 0
        , contr_tfr  = 0
    where anno          = P_anno
      and gestione   like P_gestione
      and previdenza like P_previdenza
       and  (     P_tipo = 'T'
             or ( P_tipo in ('I','V','P') and not exists
                   (select 'x' from denuncia_inpdap
                     where anno       = P_anno
                       and gestione   = dedp.gestione
                       and previdenza = dedp.previdenza
                       and ci         = dedp.ci
                       and nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg, P_tipo)
                   )
                )
             or ( P_tipo = 'S' and dedp.ci = P_ci )
            )
;
  FOR CUR_CI IN
   (select distinct dedp.ci
         , substr(rain.cognome||' '||rain.nome,1,50) nominativo
         , to_char(anag.data_nas,'dd/mm/yyyy') data_nas
      from denuncia_inpdap dedp
         , trattamenti_previdenziali trpr
         , rapporti_individuali rain
         , anagrafici anag
     where dedp.anno = P_anno
       and dedp.gestione   like P_gestione
       and dedp.previdenza like P_previdenza
       and dedp.ci in   ( select ci
                       from denuncia_fiscale
                      where ci = DEDP.ci
                        and anno = P_anno
                        and rilevanza = 'T'
                        and ( nvl(c81,0) != 0
                         or nvl(c82,0) != 0
                         or nvl(c83,0) != 0 )
                        )
       and exists  ( select 'x' 
                       from denuncia_fiscale
                      where anno = P_anno
                        and ci = DEDP.ci
                        and rilevanza = 'T'
                    )
       and  (     P_tipo = 'T'
             or ( P_tipo in ('I','V','P') and not exists
                   (select 'x' from denuncia_inpdap
                     where anno       = P_anno
                       and gestione   = dedp.gestione
                       and previdenza = dedp.previdenza
                       and ci         = dedp.ci
                       and nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg, P_tipo)
                   )
                )
             or ( P_tipo = 'S' and dedp.ci = P_ci )
            )
       and rain.ci = dedp.ci
       and rain.ni = anag.ni
       and to_date(D_fin_a,'ddmmyyyy') 
           between anag.dal and nvl(anag.al,to_date('3333333','j'))
       and (   rain.cc is null
            or exists
              (select 'x'
                 from a_competenze
                 where ente        = D_ente
                   and ambiente    = D_ambiente
                   and utente      = D_utente
                   and competenza  = 'CI'
                    and oggetto     = rain.cc
               )
            )
    ) LOOP
-- dbms_output.put_line('cursore: '||CUR_CI.ci);
     BEGIN
     V_conta_per := 0;
     P_testo     := null;
     P_testo1     := null;
     P_testo1a    := null;
     P_testo2     := null;
     P_testo2a    := null;
     P_testo3     := null;
     P_testo3a    := null;
     Dep_dal     := to_date(null);
     V_ipn_arr_cp := 0;
     V_rit_arr_cp := 0;
     V_rit_arr_cp_new := 0;
     V_alq_arr_cp := 0;
     V_ipn_arr_tfs := 0;
     V_rit_arr_tfs := 0;
     V_rit_arr_tfs_new := 0;
     V_alq_arr_tfs := 0;
     V_ipn_arr_tfr := 0;
     V_contr_arr_tfr := 0;
     V_contr_arr_tfr_new := 0;
     V_alq_arr_tfr := 0;

     FOR CUR_DEDP IN
         (select dal, nvl(al,to_date(D_fin_a,'ddmmyyyy')) al
               , assicurazioni, gestione, previdenza
               , riferimento, competenza, rilevanza
            from denuncia_inpdap
           where ci        = CUR_CI.ci
             and anno      = P_anno
	     and rilevanza = 'S'
	     and gestione  like P_gestione
	     and previdenza like P_previdenza
          union
          select min(dal), nvl(max(al),to_date(D_fin_a,'ddmmyyyy')) al
               , assicurazioni, gestione, previdenza
               , riferimento, competenza, rilevanza
            from denuncia_inpdap
           where ci        = CUR_CI.ci
             and anno      = P_anno
	     and rilevanza = 'A'
	     and gestione  like P_gestione
	     and previdenza like P_previdenza
        group by assicurazioni, gestione, previdenza
               , riferimento, competenza, rilevanza
           order by 1,2
         ) LOOP
-- dbms_output.put_line('cur dedp '||CUR_DEDP.dal||' '||CUR_DEDP.al);
-- dbms_output.put_line('gest/ril :'||cur_dedp.gestione||' '||CUR_DEDP.rilevanza);
-- dbms_output.put_line('prev/dal: '||cur_dedp.previdenza||' '||cur_dedp.dal);
-- dbms_output.put_line('rif/comp: '||cur_dedp.riferimento||'/'||cur_dedp.competenza);
-- dbms_output.put_line('ass: '||cur_dedp.assicurazioni);

    I_rit_inpdap := 0;
    I_rit_tfs    := 0;
    I_contr_tfr  := 0;

-- dbms_output.put_line('conta prima: '||V_conta_per);
    BEGIN
      select count(*) 
        into V_conta_per
        from denuncia_inpdap
       where ci          = CUR_CI.ci
         and anno        = P_anno
  	   and rilevanza   = CUR_DEDP.rilevanza
	   and gestione    = CUR_DEDP.gestione
	   and previdenza  = CUR_DEDP.previdenza
         and dal         = CUR_DEDP.dal;
     EXCEPTION
          WHEN NO_DATA_FOUND THEN V_conta_per := 0;
     END;
-- dbms_output.put_line('conta dopo: '||V_conta_per);
     IF V_conta_per > 1 and dep_dal != CUR_DEDP.dal THEN
-- dbms_output.put_line('testo prima: '||P_testo);
        P_testo := P_testo||' - '||to_char(CUR_DEDP.dal,'dd/mm/yyyy');
-- dbms_output.put_line('testo dopo: '||P_testo);
     END IF;

-- dbms_output.put_line('V_conta_per: '||V_conta_per);
     BEGIN
        select NVL(round(SUM(DECODE( vaca.colonna
                             , 'PREV_06', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'PREV_06',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'PREV_06',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)
           into I_rit_inpdap
           from valori_contabili_annuali vaca
              , estrazione_valori_contabili esvc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and to_date(D_fin_a,'ddmmyyyy')
                between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
            and vaca.anno              = P_anno
            and vaca.mese              = 12
            and vaca.moco_mese         <= to_char(to_date(D_fin_a,'ddmmyyyy'),'mm')
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_CUD'
            and vaca.colonna           = 'PREV_06'
            and vaca.ci                = CUR_CI.ci
            and vaca.moco_mensilita    != '*AP'
            and vaca.riferimento between CUR_DEDP.dal
                                     and least( nvl(CUR_DEDP.al,to_date(D_fin_a,'ddmmyyyy')),to_date(D_fin_a,'ddmmyyyy'))
            and (        V_conta_per = 1
                 or (    V_conta_per > 1
                     and CUR_DEDP.riferimento = CUR_DEDP.competenza)
--                       and to_char(vaca.competenza,'yyyy') = CUR_DEDP.competenza)
                )
        ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN 
         I_rit_inpdap        := 0;
      END;

     BEGIN
        select NVL(round(SUM(DECODE( vaca.colonna
                             , 'PREV_07', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'PREV_07',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'PREV_07',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)
             , NVL(round(SUM(DECODE( vaca.colonna
                             , 'PREV_08', vaca.valore
                                         , 0))
                         / nvl(max(decode(vaca.colonna
                                         , 'PREV_08',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                        ) * nvl(max(decode(vaca.colonna
                                         , 'PREV_08',NVL(esvc.arrotonda,0.01)
                                                     , '')),1)
                  ,0)

           into I_rit_tfs, I_contr_tfr
           from valori_contabili_annuali vaca
              , estrazione_valori_contabili esvc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and to_date(D_fin_a,'ddmmyyyy')
                between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
            and vaca.anno              = P_anno
            and vaca.mese              = 12
            and vaca.moco_mese         <= to_char(to_date(D_fin_a,'ddmmyyyy'),'mm')
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_CUD'
            and vaca.colonna          in ('PREV_07','PREV_08')
            and vaca.ci                = CUR_CI.ci
            and vaca.moco_mensilita    != '*AP'
            and vaca.riferimento between CUR_DEDP.dal
                                     and least( nvl(CUR_DEDP.al,to_date(D_fin_a,'ddmmyyyy')),to_date(D_fin_a,'ddmmyyyy'))
            and (        V_conta_per = 1
                 or (    V_conta_per > 1
                     and CUR_DEDP.riferimento != CUR_DEDP.competenza)
                )
        ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN 
         I_rit_tfs           := 0;
         I_contr_tfr         := 0;
      END;
-- dbms_output.put_line('Rit: '||I_rit_inpdap);
-- dbms_output.put_line('TFS: '||I_rit_tfs);
-- dbms_output.put_line('TFR: '||I_contr_tfr);
      BEGIN
-- dbms_output.put_line('prima dell update');
      UPDATE DENUNCIA_INPDAP
         SET rit_inpdap      = decode(I_rit_inpdap,0,null,I_rit_inpdap)
           , rit_tfs         = decode(instr(assicurazioni,'6')
                                     , 0, null, decode(I_rit_tfs,0,null,I_rit_tfs) )
           , contr_tfr       = decode(instr(assicurazioni,'6')
                                     , 0, null, decode(I_contr_tfr,0,null,I_contr_tfr) )
       WHERE anno            = P_anno
         AND previdenza      = nvl(CUR_DEDP.previdenza,'CPDEL')
         AND gestione        = CUR_DEDP.gestione
         AND ci              = CUR_CI.ci
         AND rilevanza       = CUR_DEDP.rilevanza
         AND dal             = CUR_DEDP.dal
         and ( CUR_DEDP.rilevanza = 'A' 
           and riferimento = CUR_DEDP.riferimento
           and competenza  = CUR_DEDP.competenza
            or CUR_DEDP.rilevanza = 'S'
             );
      commit;

      END; -- Fine update
-- dbms_output.put_line('fine dell update');

      Dep_dal := CUR_DEDP.dal;
     END LOOP; -- CUR_DEDP

     Dep_dal_arr     := to_date(null);
     V_conta_arr     := 0;

    BEGIN
    <<ARRETRATI>>
     FOR CUR_ARR in 
     ( select distinct dal, gestione, previdenza, riferimento, competenza
        from denuncia_inpdap dedp
       where anno            = P_anno
         and ci              = CUR_CI.ci
         and rilevanza       = 'A'
         AND previdenza      like P_previdenza
         AND gestione        like P_gestione
         AND riferimento    != competenza
         AND exists ( select 'x' 
                        from denuncia_inpdap 
                      where anno            = P_anno
                        and ci              = CUR_CI.ci
                        and rilevanza       = 'A'
                        AND previdenza      = dedp.previdenza
                        AND gestione        = dedp.gestione
                        and riferimento     = dedp.riferimento
                        and competenza     != dedp.competenza
                        AND dal = dedp.dal
                     )
     ) LOOP
-- dbms_output.put_line('cur_arr: '||cur_arr.dal);
     IF dep_dal_arr = CUR_ARR.dal THEN
        V_conta_arr := nvl(V_conta_arr,0) +1;
     ELSE
        dep_dal_arr := CUR_ARR.dal;
        V_conta_arr := 1;
     END IF;

-- dbms_output.put_line('conta: '||V_conta_arr);
     IF V_conta_arr = 1 THEN
        BEGIN
         select sum(nvl(comp_fisse,0) + nvl(comp_accessorie,0))
              , sum(nvl(rit_inpdap,0))
              , sum(nvl(comp_inadel,0)), sum(nvl(rit_tfs,0))
              , sum(nvl(comp_tfr,0)), sum(nvl(contr_tfr,0))
           into V_ipn_arr_cp, V_rit_arr_cp
              , V_ipn_arr_tfs, V_rit_arr_tfs
              , V_ipn_arr_tfr, V_contr_arr_tfr
           from denuncia_inpdap
          where anno            = P_anno
            and ci              = CUR_CI.ci
            and rilevanza       = 'A'
            AND previdenza      = cur_arr.previdenza
            AND gestione        = cur_arr.gestione
            AND dal             = CUR_ARR.dal
        ;
       EXCEPTION WHEN NO_DATA_FOUND THEN 
          V_ipn_arr_cp := 0;
          V_rit_arr_cp := 0;
          V_ipn_arr_tfs := 0;
          V_rit_arr_tfs := 0;
          V_ipn_arr_tfr := 0;
          V_contr_arr_tfr := 0;
       END;

-- dbms_output.put_line('ATTENZIONE!!! ');
-- dbms_output.put_line('prima cp '||V_ipn_arr_cp||' '||V_rit_arr_cp);
-- dbms_output.put_line('prima ipn tfs '||V_ipn_arr_tfs);
-- dbms_output.put_line('prima rit tfs '||V_rit_arr_tfs);
-- dbms_output.put_line('prima ipn tfr '||V_ipn_arr_tfr);
-- dbms_output.put_line('prima contr tfr '||V_contr_arr_tfr);

       V_arrotonda_cp := 'S';
       V_arrotonda_tfs := 'S';
       V_arrotonda_tfr := 'S';

       select decode(nvl(V_ipn_arr_cp,0)+nvl(V_rit_arr_cp,0)- trunc(nvl(V_ipn_arr_cp,0)+nvl(V_rit_arr_cp,0))
                    ,0,'S','N')
         into V_arrotonda_cp
         from dual;

       select decode(nvl(V_ipn_arr_tfs,0)+nvl(V_rit_arr_tfs,0)- trunc(nvl(V_ipn_arr_tfs,0)+nvl(V_rit_arr_tfs,0))
                    ,0,'S','N')
         into V_arrotonda_tfs
         from dual;

       select decode(nvl(V_ipn_arr_tfs,0)+nvl(V_contr_arr_tfr,0)- trunc(nvl(V_ipn_arr_tfs,0)+nvl(V_contr_arr_tfr,0))
                    ,0,'S','N')
         into V_arrotonda_tfr
         from dual;

-- sistemazione Rit. CPDEL
       IF V_ipn_arr_cp != 0 THEN
-- dbms_output.put_line('determino alq cp ');
         IF V_ipn_arr_cp < 0 THEN
           P_testo1 := '***** IMPOSSIBILE RIPARTIRE GLI ARR. per IMP CP NEGATIVO *****';
         ELSIF round(V_rit_arr_cp*100/V_ipn_arr_cp,2) > 100 THEN 
           P_testo1a := '***** IMPOSSIBILE RIPARTIRE GLI ARR. ALIQUOTA ERRATA CPDEL *****';
          ELSE
          select round(V_rit_arr_cp*100/V_ipn_arr_cp,2)
            into V_alq_arr_cp
            from dual;
-- dbms_output.put_line('alq cp'||V_alq_arr_cp);

          select decode(V_arrotonda_cp, 'N', sum(round((nvl(comp_fisse,0)+nvl(comp_accessorie,0))/100*V_alq_arr_cp,2))
                                           , sum(round((nvl(comp_fisse,0)+nvl(comp_accessorie,0))/100*V_alq_arr_cp))
                       )
            into V_rit_arr_cp_new
            from denuncia_inpdap
           where anno            = P_anno
              and ci              = CUR_CI.ci
              and rilevanza       = 'A'
              AND previdenza      = cur_arr.previdenza
              AND gestione        = cur_arr.gestione
              AND dal             = CUR_ARR.dal
              AND riferimento     = CUR_ARR.riferimento
              AND competenza      = CUR_ARR.competenza
         ;

-- dbms_output.put_line('V_rit_arr_cp_new: '||V_rit_arr_cp_new);
-- dbms_output.put_line('V_rit_arr_cp: '||V_rit_arr_cp);
       update denuncia_inpdap
          set rit_inpdap      = V_rit_arr_cp_new
        where anno            = P_anno
          and ci              = CUR_CI.ci
          and rilevanza       = 'A'
          AND previdenza      = CUR_ARR.previdenza
          AND gestione        = CUR_ARR.gestione
          AND dal             = CUR_ARR.dal
          AND riferimento     = CUR_ARR.riferimento
          AND competenza      = CUR_ARR.competenza
         ;
-- dbms_output.put_line('fatta prima update');
       update denuncia_inpdap
          set rit_inpdap = V_rit_arr_cp -  V_rit_arr_cp_new
        where anno            = P_anno
          and ci              = CUR_CI.ci
          and rilevanza       = 'A'
          AND previdenza      = cur_arr.previdenza
          AND gestione        = cur_arr.gestione
          AND dal             = CUR_ARR.dal
          AND riferimento     = CUR_ARR.riferimento
          AND competenza      != CUR_ARR.competenza
         ;
-- dbms_output.put_line('fatta seconda update');
       commit;
         END IF; -- valori negativi
       END IF;

-- sistemazione Rit. TFS-INADEL 
       IF V_ipn_arr_tfs != 0 THEN
-- dbms_output.put_line('determino alq tfs ');
         IF V_ipn_arr_TFS < 0 THEN
           P_testo2 := '***** IMPOSSIBILE RIPARTIRE GLI ARR. per IMP TFS NEGATIVO *****';
         ELSIF round(V_rit_arr_tfs*100/V_ipn_arr_tfs,2) > 100 THEN
           P_testo2a := '***** IMPOSSIBILE RIPARTIRE GLI ARR. ALIQUOTA ERRATA TFS *****';
          ELSE
          select round(V_rit_arr_tfs*100/V_ipn_arr_tfs,2)
            into V_alq_arr_tfs
            from dual;
-- dbms_output.put_line('alq tfs'||V_alq_arr_tfs);

          select decode(V_arrotonda_tfs, 'N', sum(round(nvl(comp_inadel,0)/100*V_alq_arr_tfs,2))
                                            , sum(round(nvl(comp_inadel,0)/100*V_alq_arr_tfs))
                       )
            into V_rit_arr_tfs_new
            from denuncia_inpdap
           where anno            = P_anno
              and ci              = CUR_CI.ci
              and rilevanza       = 'A'
              AND previdenza      = cur_arr.previdenza
              AND gestione        = cur_arr.gestione
              AND dal             = CUR_ARR.dal
              AND riferimento     = CUR_ARR.riferimento
              AND competenza      = CUR_ARR.competenza
              AND nvl(comp_inadel,0) != 0
         ;
-- dbms_output.put_line('new tfs '||V_rit_arr_tfs_new);
       update denuncia_inpdap
          set rit_tfs         = V_rit_arr_tfs_new
        where anno            = P_anno
          and ci              = CUR_CI.ci
          and rilevanza       = 'A'
          AND previdenza      = CUR_ARR.previdenza
          AND gestione        = CUR_ARR.gestione
          AND dal             = CUR_ARR.dal
          AND riferimento     = CUR_ARR.riferimento
          AND competenza      = CUR_ARR.competenza
          AND nvl(comp_inadel,0) != 0
         ;
       update denuncia_inpdap
          set rit_tfs         = V_rit_arr_tfs -  V_rit_arr_tfs_new
        where anno            = P_anno
          and ci              = CUR_CI.ci
          and rilevanza       = 'A'
          AND previdenza      = cur_arr.previdenza
          AND gestione        = cur_arr.gestione
          AND dal             = CUR_ARR.dal
          AND riferimento     = CUR_ARR.riferimento
          AND competenza      != CUR_ARR.competenza
          AND nvl(comp_inadel,0) != 0
         ;
       commit;
         END IF; -- valori negativi
       END IF;

-- sistemazione Contr. TFR
       IF V_ipn_arr_tfr != 0 THEN
-- dbms_output.put_line(' determino aliquota TFR ');
         IF V_ipn_arr_tfr < 0 THEN
            P_testo3 := '***** IMPOSSIBILE RIPARTIRE GLI ARR. per IMP TFR NEGATIVO *****';
         ELSIF round(V_contr_arr_tfr*100/V_ipn_arr_tfr,2) > 100 THEN
            P_testo3a := '***** IMPOSSIBILE RIPARTIRE GLI ARR. ALIQUOTA ERRATA TFR *****';
          ELSE 
          select round(V_contr_arr_tfr*100/V_ipn_arr_tfr,2)
            into V_alq_arr_tfr
            from dual;
-- dbms_output.put_line('alq tfr'||V_alq_arr_tfr);

          select decode(V_arrotonda_tfr, 'N', sum(round(nvl(comp_tfr,0)/100*V_alq_arr_tfr,2))
                                            , sum(round(nvl(comp_tfr,0)/100*V_alq_arr_tfr))
                       )
            into V_contr_arr_tfr_new
            from denuncia_inpdap
           where anno            = P_anno
              and ci              = CUR_CI.ci
              and rilevanza       = 'A'
              AND previdenza      = cur_arr.previdenza
              AND gestione        = cur_arr.gestione
              AND dal             = CUR_ARR.dal
              AND riferimento     = CUR_ARR.riferimento
              AND competenza      = CUR_ARR.competenza
              AND nvl(comp_tfr,0) != 0
         ;
-- dbms_output.put_line('new tfr '||V_contr_arr_tfr_new);
       update denuncia_inpdap
          set contr_tfr         = V_contr_arr_tfr_new
        where anno            = P_anno
          and ci              = CUR_CI.ci
          and rilevanza       = 'A'
          AND previdenza      = CUR_ARR.previdenza
          AND gestione        = CUR_ARR.gestione
          AND dal             = CUR_ARR.dal
          AND riferimento     = CUR_ARR.riferimento
          AND competenza      = CUR_ARR.competenza
          AND nvl(comp_tfr,0) != 0
         ;
       update denuncia_inpdap
          set contr_tfr         = V_contr_arr_tfr -  V_contr_arr_tfr_new
        where anno            = P_anno
          and ci              = CUR_CI.ci
          and rilevanza       = 'A'
          AND previdenza      = cur_arr.previdenza
          AND gestione        = cur_arr.gestione
          AND dal             = CUR_ARR.dal
          AND riferimento     = CUR_ARR.riferimento
          AND competenza      != CUR_ARR.competenza
          AND nvl(comp_tfr,0) != 0
         ;
       commit;
         END IF; -- valori negativi
      END IF;
     END IF; -- V_conta
     END LOOP; -- CUR_ARR
 
    END ARRETRATI;
   BEGIN
   <<CONTROLLI>>
      V_casella97 := 0;
      V_casella98 := 0;
      V_casella99 := 0;
      V_diff_97   := 0;
      V_diff_98   := 0;
      V_diff_99   := 0;
      V_tot_rit_inpdap := 0;
      V_tot_rit_tfs    := 0;
      V_tot_contr_tfr  := 0;
      V_tot97a         := 0;
      V_tot98a         := 0;
      V_tot99a         := 0;
      V_tot97b         := 0;
      V_tot98b         := 0;
      V_tot99b         := 0;

-- controlli sul totale del singolo CI 
      BEGIN
      select C81, C82, c83
        into V_casella97, V_casella98, V_casella99
        from denuncia_fiscale
       where ci = CUR_CI.ci
         and anno = P_anno
         and rilevanza = 'T';
      EXCEPTION WHEN NO_DATA_FOUND THEN
         V_casella97 := 0;
         V_casella98 := 0;
         V_casella99 := 0;
      END;
      BEGIN
      select sum(nvl(rit_inpdap,0))
           , sum(nvl(rit_tfs,0))
           , sum(nvl(contr_tfr,0))
        into V_tot_rit_inpdap, V_tot_rit_tfs, V_tot_contr_tfr
        from denuncia_inpdap
       where ci = CUR_CI.ci
         and anno = P_anno
       ;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         V_casella97 := 0;
         V_casella98 := 0;
         V_casella99 := 0;
      END;
-- dbms_output.put_line('tot aarfi: '||V_casella97||' '||V_casella98||' '||V_casella99);
-- dbms_output.put_line('tot aardp: '||V_tot_rit_inpdap||' '||V_tot_rit_tfs||' '||V_tot_contr_tfr);
      BEGIN
      select nvl(V_casella97,0) - nvl(V_tot_rit_inpdap,0)
           , nvl(V_casella98,0) - nvl(V_tot_rit_tfs,0)
           , nvl(V_casella99,0) - nvl(V_tot_contr_tfr,0)
        into V_diff_97, V_diff_98, V_diff_99
        from denuncia_fiscale
       where ci = CUR_CI.ci
         and anno = P_anno
         and rilevanza = 'T';
      EXCEPTION WHEN NO_DATA_FOUND THEN
         V_diff_97 := 0;
         V_diff_98 := 0;
         V_diff_99 := 0;
      END;
-- dbms_output.put_line('diff. '||V_diff_97||' '||V_diff_98||' '||V_diff_99);
    IF abs(nvl(V_diff_97,0)) > 0 THEN
-- dbms_output.put_line('mod. diff 97');
       update denuncia_inpdap dedp
          set rit_inpdap = nvl(rit_inpdap,0) + V_diff_97
        where anno = P_anno
          and ci = CUR_CI.ci
          and gestione like P_gestione
          and previdenza like P_previdenza
          and dal = ( select max(dal) from denuncia_inpdap
                       where ci = dedp.ci
                         and anno = P_anno
                         and gestione like P_gestione
                         and previdenza like P_previdenza
                         and rilevanza = dedp.rilevanza
                         and nvl(comp_fisse,0) + nvl(comp_accessorie,0) != 0
                    )
          and rownum = 1;
      commit;
    END IF;
    IF abs(nvl(V_diff_98,0)) > 0 THEN
-- dbms_output.put_line('mod. diff 98');
       update denuncia_inpdap dedp
          set rit_tfs = nvl(rit_tfs,0) + V_diff_98
        where anno = P_anno
          and ci = CUR_CI.ci
          and gestione like P_gestione
          and previdenza like P_previdenza
          and instr(assicurazioni,'6') != 0
          and dal = ( select max(dal) from denuncia_inpdap
                       where ci = dedp.ci
                         and anno = P_anno
                         and gestione like P_gestione
                         and previdenza like P_previdenza
                         and rilevanza = dedp.rilevanza
                         and instr(assicurazioni,'6') != 0
                         and nvl(comp_inadel,0) != 0
                    )
          and rownum = 1;
      commit;
    END IF;
    IF abs(nvl(V_diff_99,0)) > 0 THEN
-- dbms_output.put_line('mod. diff 99');
       update denuncia_inpdap dedp
          set contr_tfr = nvl(contr_tfr,0) + V_diff_99
        where anno = P_anno
          and ci = CUR_CI.ci
          and gestione like P_gestione
          and previdenza like P_previdenza
          and instr(assicurazioni,'6') != 0
          and dal = ( select max(dal) from denuncia_inpdap
                       where ci = dedp.ci
                         and anno = P_anno
                         and gestione like P_gestione
                         and previdenza like P_previdenza
                         and rilevanza = dedp.rilevanza
                         and instr(assicurazioni,'6') != 0
                         and nvl(comp_tfr,0) + nvl(ipn_tfr,0) != 0
                    )
          and rownum = 1;
      commit;
    END IF;

-- totali inpdap
   BEGIN
   select nvl(sum(rit_inpdap),0), nvl(sum(rit_tfs),0), nvl(sum(contr_tfr),0)
     into V_tot97a, V_tot98a, V_tot99a
     from denuncia_inpdap
    where anno =  P_anno
      and ci = CUR_CI.ci;
   EXCEPTION WHEN NO_DATA_FOUND THEN
        V_tot97a := 0;
        V_tot98a := 0;
        V_tot99a := 0;
   END; 
-- totali aarfi
   BEGIN
   select nvl(sum(c81),0), nvl(sum(c82),0), nvl(sum(c83),0)
     into V_tot97b, V_tot98b, V_tot99b
     from denuncia_fiscale
    where anno =  P_anno
      and ci = CUR_CI.ci
      and rilevanza = 'T';
   EXCEPTION WHEN NO_DATA_FOUND THEN
        V_tot97b := 0;
        V_tot98b := 0;
        V_tot99b := 0;
   END; 

   IF  nvl(v_tot97a,0) != nvl(V_tot97b,0) 
    or nvl(v_tot98a,0) != nvl(V_tot98b,0) 
    or nvl(v_tot99a,0) != nvl(V_tot99b,0) THEN
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad(CUR_CI.ci,10,' ')
        ||lpad(CUR_CI.nominativo,50,' ')
        ||lpad(CUR_CI.data_nas,15,' ')
        ||lpad(' ',5,' ')||'***** DA VERIFICARE *****'
     from dual
   ;
   ELSE
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad(CUR_CI.ci,10,' ')
        ||lpad(CUR_CI.nominativo,50,' ')
        ||lpad(CUR_CI.data_nas,15,' ')
     from dual
   ;
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , substr('***** DA VERIFICARE SUDDIVISIONE CONTRIBUTI DEI PERIODI:'||P_testo||' *****',1,132)
     from dual
    where P_testo is not null
   ;
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , P_testo1
     from dual
    where P_testo1 is not null
   ;
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , P_testo1a
     from dual
    where P_testo1a is not null
   ;
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , P_testo2
     from dual
    where P_testo2 is not null
   ;
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , P_testo2a
     from dual
    where P_testo2a is not null
   ;
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , P_testo3
     from dual
    where P_testo3 is not null
   ;
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , P_testo3a
     from dual
    where P_testo3a is not null
   ;
   END IF;
  
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad('AARDP: ',20,' ')
        ||lpad(to_char(V_tot97a,'9999999999990.99'),20,' ')
        ||lpad(to_char(V_tot98a,'9999999999990.99'),20,' ')
        ||lpad(to_char(V_tot99a,'9999999999990.99'),20,' ')
     from dual
   ;
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad('AARFI: ',20,' ')
        ||lpad(to_char(V_tot97b,'9999999999990.99'),20,' ')
        ||lpad(to_char(V_tot98b,'9999999999990.99'),20,' ')
        ||lpad(to_char(V_tot99b,'9999999999990.99'),20,' ')
     from dual
   ;
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad(' ',132,' ')
     from dual
   ;
  commit;
        V_totente97a := nvl(V_totente97a,0) + nvl(V_tot97a,0);
        V_totente98a := nvl(V_totente98a,0) + nvl(V_tot98a,0);
        V_totente99a := nvl(V_totente99a,0) + nvl(V_tot99a,0);
        V_totente97b := nvl(V_totente97b,0) + nvl(V_tot97b,0);
        V_totente98b := nvl(V_totente98b,0) + nvl(V_tot98b,0);
        V_totente99b := nvl(V_totente99b,0) + nvl(V_tot99b,0);
    END CONTROLLI;

    END;
  END LOOP;  -- CUR_CI

  BEGIN
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad(' ',132,'')
     from dual
   ;
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad('-',132,'-')
     from dual
   ;
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad(' Totali Ente : ',20,' ')
        ||lpad('Inpdap',20,' ')
        ||lpad('TFS',20,' ')
        ||lpad('TFR',20,' ')
     from dual
   ;
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad('AARDP: ',20,' ')
        ||lpad(to_char(V_totente97a,'9999999999990.99'),20,' ')
        ||lpad(to_char(V_totente98a,'9999999999990.99'),20,' ')
        ||lpad(to_char(V_totente99a,'9999999999990.99'),20,' ')
     from dual
   ;
   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad('AARFI: ',20,' ')
        ||lpad(to_char(V_totente97b,'9999999999990.99'),20,' ')
        ||lpad(to_char(V_totente98b,'9999999999990.99'),20,' ')
        ||lpad(to_char(V_totente99b,'9999999999990.99'),20,' ')
     from dual
   ;
  END;
      update a_prenotazioni
         set errore         = 'P00108'
       where no_prenotazione = prenotazione;
      commit;

EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = V_errore
       where no_prenotazione = prenotazione;
      commit;
end;
end;
end;
/
