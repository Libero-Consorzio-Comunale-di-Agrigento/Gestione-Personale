CREATE OR REPLACE PACKAGE PECCARDP IS
/******************************************************************************
 NOME:          PECCARDP CARICAMENTO ARCHIVIO DENUNCIA INPDAP
 DESCRIZIONE:   
      Questa funzione inserisce nella tavola DENUNCIA_INPDAP le registrazioni 
      relative ad ogni individuo che ha prestato servizio nell'anno richiesto,
      per consentire ad una funzione successiva di fornire un tabulato che
      permetta la compilazione della denuncia annuale di Denuncia INPDAP

      A questo scopo e` necessario gestire diversi tipi di registrazioni,
      distinti dal campo RILEVANZA della tavola DENUNCIA_INPDAP:
      S = Servizio     ---- contiene gli estremi dei periodi di servizio presta-
                            ti dal dipendente nel corso dell'anno, eventualmente
                            spezzati da periodi di assenza non utile con 
                            l'indicazione dei relativi importi.
      A = Arretrati    ---- non sempre presente, contiene l'importo di eventua-
                            li arretrati relativi ad anni precedenti, percepiti
                            dal dipendente e l'indicazione dell'anno cui si
                            riferiscono.
 ARGOMENTI:   
      Creazione delle registrazioni annuali individuali per la fase di stampa
      della denuncia annuale Denuncia INPDAP
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000   
 2    10/09/2004   MV   A7024 - Gestione del tipo_rattamento nel crp_denunce_inpdap.sql 
 2.1  28/09/2004   ML	Modifica alla chiamata della procedure ACCORPA_PERIODI     
 2.2  28/10/2004	 ML	Passaggio parametro D_previdenza in chiamata procedure PREVIDENZA
 2.3  02/11/2004   MS   Modifica per att. 6662
 3.0  01/02/2005   MS   Modifica per att. 9557
 3.1  10/02/2005  MS    Modifica per att. 3670.1
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCARDP IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V3.1 del 10/02/2005';
 END VERSIONE;
 PROCEDURE MAIN (prenotazione in number, passo in number) IS
 BEGIN
DECLARE
  P_denuncia      VARCHAR2(1);
  P_riferimento   DATE;
  P_sfasato       VARCHAR2(1);
  V_controllo     VARCHAR2(1);
  D_errore        varchar2(6);
  P_comparto      varchar2(2);
  P_sottocomparto varchar2(2);
  D_qualifica     varchar2(6);
  P_ultima_cess   VARCHAR2(1);
  D_ente          varchar2(4);
  D_ambiente      varchar2(8);
  D_utente        varchar2(8);
  D_anno          varchar2(4);
  D_ini_a         varchar2(8);
  D_fin_a         varchar2(8);
  D_gestione      varchar2(4);
  D_previdenza    varchar2(6);
  D_tipo          varchar2(1);
  D_tipo_trattamento varchar2(1);
  D_giorni        varchar2(1);
  D_dal           date;
  D_al            date;
  D_ci            number(8);
  D_num_servizi   number := 0;
  D_pr_err_0      number := 0;
  D_pr_err_1      number := 10000;
  D_pr_err_2      number := 20000;
  D_pr_err_3      number := 30000;
  D_pr_err_4      number := 40000;
  D_pr_err_5      number := 150000; -- max fino a 200000
  D_pr_err_7      number := 70000;
  I_previdenza    varchar2(6);
  I_pensione      varchar2(1);
  I_gg_utili      varchar2(3);
  I_inadel        varchar2(1);
  I_codice        varchar2(10);
  I_posizione     varchar2(8);
  I_data_ces      varchar2(8);
  I_causa_ces     varchar2(2);
  I_preav         number;
  I_comp_inadel   NUMBER;
  I_comp_tfr      NUMBER;
  I_ipn_tfr       NUMBER;
  I_contribuzione varchar2(1);
  I_colonna	      varchar2(30);
  I_enpdep        varchar2(1);
--
-- Exceptions
--
  USCITA EXCEPTION;
--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN
BEGIN
 select 'A'
   INTO P_denuncia 
  from dual;
END;
BEGIN
  SELECT valore
    INTO P_ultima_cess
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_ULTIMA_CESS'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_ultima_cess := null;
END;
BEGIN
  select valore
    into D_tipo
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_TIPO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_tipo := null;
END;
BEGIN
  select valore
    into P_comparto
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_COMPARTO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_comparto :='00';
END;
BEGIN
  select valore
    into P_sottocomparto
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_SOTTOCOMPARTO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       P_sottocomparto :='00';
END;

BEGIN
  select valore
    into D_ci
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_CI'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    D_ci := 0;
END;

IF nvl(D_ci,0) = 0 and D_tipo = 'S' THEN
     D_errore := 'A05721';
     RAISE USCITA;
ELSIF nvl(D_ci,0) != 0 and D_tipo = 'T' THEN
     D_errore := 'A05721';
     RAISE USCITA; 
END IF;

BEGIN
  select valore
    into D_previdenza
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_PREVIDENZA'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_previdenza := null;
END;

BEGIN
  select valore
    into D_gestione
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_GESTIONE'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_gestione := null;
END;
BEGIN
  select valore
    into D_giorni
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_GIORNI'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_giorni := ' ';
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
--
-- Estrae Anno di Riferimento per archiviazione
--
BEGIN
  select valore
       , '0101'||valore
       , '3112'||valore
    into D_anno
       , D_ini_a
       , D_fin_a
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_ANNO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    select anno
         , '0101'||to_char(anno)
         , '3112'||to_char(anno)
      into D_anno
         , D_ini_a
         , D_fin_a
      from riferimento_fine_anno
     where rifa_id = 'RIFA'
    ;
END;

BEGIN
  select to_date(valore,decode(nvl(length(translate(valore,'a0123456789/',
         'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
    into D_dal
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_DAL'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_dal := to_date(D_ini_a,'ddmmyyyy');
END;
BEGIN
  select to_date(valore,decode(nvl(length(translate(valore,'a0123456789/',
         'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
    into D_al
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_AL'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_al  := to_date(D_fin_a,'ddmmyyyy');
END;
-- Estrae Parametro per Gestione NDR es: Piacenza
BEGIN
  SELECT valore
    INTO P_sfasato
    FROM a_parametri
   WHERE no_prenotazione = prenotazione
     AND parametro       = 'P_ANNO_SFASATO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      P_sfasato := null;
END;
IF P_sfasato = 'X' THEN
  BEGIN
   select 'X' 
     into V_controllo
     from gestioni
    where codice = D_gestione
      and D_gestione != '%';
  EXCEPTION 
   WHEN NO_DATA_FOUND THEN 
     IF D_tipo = 'S' THEN NULL;
     ELSE D_errore := 'P05130';
          RAISE USCITA;
     END IF;
   WHEN OTHERS THEN NULL;
  END;
  D_ini_a := '0112'||to_number(D_anno-1);
  D_fin_a := '3011'||D_anno;
END IF;

--
-- Cancellazione Archiviazione precedente relativa all'anno richiesto
--
     lock table denuncia_inpdap in exclusive mode nowait
     ;
     delete from denuncia_inpdap dedp
      where dedp.anno             = D_anno
        and dedp.gestione      like D_gestione
        and dedp.previdenza    like D_previdenza
        and (    D_tipo = 'T'
              or ( D_tipo in ('I','V','P') and not exists
                    (select 'x' from denuncia_inpdap
                      where anno       = dedp.anno
                        and gestione   = dedp.gestione
                        and previdenza = dedp.previdenza
                        and ci         = dedp.ci
                        and nvl(tipo_agg,' ') = decode(D_tipo
                                                       ,'P',tipo_agg,
                                                           D_tipo)
                    )
                 )
              or ( D_tipo = 'C' and (exists
                    (select 'x'
                       from periodi_giuridici pegi
                      where pegi.rilevanza = 'P'
                        and pegi.ci         = dedp.ci
                        and pegi.dal        =
                            (select max(dal) from periodi_giuridici
                              where rilevanza = 'P'
                                and ci        = pegi.ci
                                and dal      <= D_al
                            )
                        and pegi.al between D_dal and D_al
                    )
                                 or exists
                    (select 'x'
                       from periodi_giuridici pegi
                      where pegi.rilevanza = 'P'
                        and pegi.ci        = dedp.ci
                        and pegi.dal       =
                            (select max(dal) from periodi_giuridici
                              where rilevanza = 'P'
                                and ci        = pegi.ci
                                and dal      <= D_al
                             )
                        and pegi.al <=
                            (select last_day
                                    (to_date
                                    (max(lpad(to_char(mese),2,'0')||
                                    to_char(anno)),'mmyyyy'))
                               from movimenti_fiscali
                              where ci       = pegi.ci
                                and last_day
                                    (to_date
                                    (lpad(to_char(mese),2,'0')||
                                    to_char(anno),'mmyyyy'))
                                    between D_dal and D_al
                                and nvl(ipn_ord,0)  + nvl(ipn_liq,0)
                                    +nvl(ipn_ap,0)   + nvl(lor_liq,0)
                                    +nvl(lor_acc,0) != 0
                                and mensilita != '*AP'
                            )
                    ))
                 )
              or (D_tipo = 'S' and dedp.ci = D_ci
                 )
             )
        and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = dedp.ci
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
           )
     ;
     commit
     ;
--
-- Creazione delle registrazioni di appoggio per determinazione dei
-- dipendenti da trattare
--
FOR CUR_CI IN
   (select distinct pere.ci, pere.gestione
      from periodi_retributivi pere
         , trattamenti_previdenziali trpr
     where pere.periodo between to_date(D_ini_a,'ddmmyyyy')
                            and to_date(D_fin_a,'ddmmyyyy')
--       and pere.competenza    = 'A'
       and pere.competenza    in ( 'A', 'C' )
       and pere.gestione   like D_gestione
       and pere.trattamento   = trpr.codice
       and trpr.previdenza is not null
       and trpr.previdenza like D_previdenza
       and (    D_tipo = 'T'
             or ( D_tipo in ('I','V','P') and not exists
                   (select 'x' from denuncia_inpdap
                     where anno       = D_anno
                       and gestione   = pere.gestione
                       and previdenza = trpr.previdenza
                       and ci         = pere.ci
                       and nvl(tipo_agg,' ') = decode(D_tipo
                                                      ,'P',tipo_agg,
                                                          D_tipo)
                   )
                )
             or ( D_tipo = 'C' and ( exists
                   (select 'x'
                      from periodi_giuridici pegi
                     where pegi.rilevanza = 'P'
                       and pegi.ci         = pere.ci
                       and pegi.dal        =
                           (select max(dal) from periodi_giuridici
                             where rilevanza = 'P'
                               and ci        = pegi.ci
                               and dal      <= D_al
                           )
                       and pegi.al between D_dal and D_al
                   )
                                or exists
                   (select 'x'
                      from periodi_giuridici pegi
                     where pegi.rilevanza = 'P'
                       and pegi.ci        = pere.ci
                       and pegi.dal       =
                           (select max(dal) from periodi_giuridici
                             where rilevanza = 'P'
                               and ci        = pegi.ci
                               and dal      <= D_al
                            )
                       and pegi.al <=
                           (select last_day
                                   (to_date
                                   (max(lpad(to_char(mese),2,'0')||
                                   to_char(anno)),'mmyyyy'))
                              from movimenti_fiscali
                             where ci       = pegi.ci
                               and last_day
                                   (to_date
                                   (lpad(to_char(mese),2,'0')||
                                   to_char(anno),'mmyyyy'))
                                   between D_dal and D_al
                               and nvl(ipn_ord,0)  + nvl(ipn_liq,0)
                                   +nvl(ipn_ap,0)   + nvl(lor_liq,0)
                                   +nvl(lor_acc,0) != 0
                               and mensilita != '*AP'
                           )
                   ) )
                )
             or (D_tipo = 'S' and pere.ci = D_ci
                )
            )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci + 0 = pere.ci
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
          )
   ) LOOP


-- Determino tipo_trattamento

begin
 select nvl(tipo_trattamento,'0')
  into D_tipo_trattamento
 from rapporti_retributivi
 where ci = CUR_CI.ci;
exception
 when no_data_found then
  D_tipo_trattamento := '0';
end;

     D_num_servizi := 0;
FOR CUR_PSEP IN
   (select greatest(psep.dal,to_date('0101'||D_anno,'ddmmyyyy'),
                   esvc.dal)  dal
         , least(nvl(psep.al,to_date('3333333','j'))
                ,to_date(decode(P_sfasato,'X',D_fin_a,'3112'||D_anno),'ddmmyyyy'),
                 nvl(esvc.al,to_date('3333333','j')))      al
         , psep.segmento                                   segmento
         , psep.assenza                                    assenza
         , decode( posi.contratto_formazione
                 , 'NO', decode
                         ( posi.stagionale
                         , 'GG', '2'
                               , decode
                                 ( posi.part_time
                                 , 'SI', '8'
                                       , decode
                                         ( nvl(psep.ore,cost.ore_lavoro)
                                         , cost.ore_lavoro, '1'
                                                          , '9')
                                 )
                         )
                       , posi.tipo_formazione)                   impiego
         , decode( psep.assenza
                 , null, decode
                         ( nvl(psep.ore,cost.ore_lavoro)
                         , cost.ore_lavoro, decode( least(D_anno,2000)
                                                   ,2000, '4', '11')
                                          , decode
                                            ( posi.part_time
                                            , 'SI', decode( least(D_anno,2000)
                                                             ,2000, '5', '12') 
                                                  , decode( least(D_anno,2000)
                                                   ,2000, '4', '11'))
                         )
                       , decode(aste.cat_fiscale,'32','30',aste.cat_fiscale )
                   )                       servizio
         , decode ( psep.assenza
                  , null, null, decode(aste.cat_fiscale,'32',aste.per_ret, null)
                   )                       perc_l300
         , psep.posizione              posizione
         , figi.profilo                profilo
      from posizioni                   posi
         , astensioni                  aste
         , qualifiche_giuridiche       qugi
         , figure_giuridiche           figi
         , contratti_storici           cost
         , periodi_servizio_previdenza psep
         , estrazione_valori_contabili esvc
     where psep.ci             = CUR_CI.ci
       and psep.gestione       = CUR_CI.gestione
       and aste.codice    (+)  = psep.assenza
       and aste.servizio  (+) != 0
       and posi.codice    (+)  = psep.posizione
       and qugi.numero         = psep.qualifica
       and figi.numero         = psep.figura
       and esvc.estrazione     = 'DENUNCIA_INPDAP'
       and esvc.colonna        = 'COMP_FISSE'
       and esvc.dal < nvl(psep.al,to_date(D_fin_a,'ddmmyyyy'))
       and nvl(esvc.al,to_date(D_fin_a,'ddmmyyyy')) >= psep.dal
       and esvc.dal           <= to_date(D_fin_a,'ddmmyyyy')
       and nvl(esvc.al,to_date('3333333','j'))
                              >= to_date(D_ini_a,'ddmmyyyy')
       and nvl(psep.al,to_date(D_fin_a,'ddmmyyyy')) between qugi.dal
                                    and nvl(qugi.al,to_date('3333333','j'))
       and nvl(psep.al,to_date(D_fin_a,'ddmmyyyy')) between figi.dal
                                    and nvl(figi.al,to_date('3333333','j'))
       and cost.contratto      = qugi.contratto
       and nvl(psep.al,to_date(D_fin_a,'ddmmyyyy')) between cost.dal
                                    and nvl(cost.al,to_date('3333333','j'))
       and psep.dal           <= to_date(D_fin_a,'ddmmyyyy')
       and nvl(psep.al,to_date('3333333','j'))
                              >= to_date('0101'||D_anno,'ddmmyyyy')
       and psep.dal <= nvl(psep.al,to_date('3333333','j'))
       and psep.segmento      in
          (select 'i' from dual
            union
           select 'a' from dual
            where not exists
                  (select 'x'
                     from astensioni
                    where codice = psep.assenza
                      and servizio = 0)
            union
           select 'c' from dual
            union
           select 'f' from dual
            union
           select 'u' from dual
            where not exists
                 (select 'x'
                    from periodi_servizio_previdenza
                   where ci      = psep.ci
                     and segmento = 'a'
                     and dal     <= psep.dal
                     and nvl(al,to_date('3333333','j')) >= psep.dal)
          )
     union -- estrazione periodo AP per non di ruolo
    select greatest(psep.dal,to_date(D_ini_a,'ddmmyyyy'),
                   esvc.dal)  dal
         , least(nvl(psep.al,to_date('3333333','j'))
                ,to_date('3112'||D_anno-1,'ddmmyyyy'),
                 nvl(esvc.al,to_date('3333333','j')))      al
         , psep.segmento                                   segmento
         , psep.assenza                                    assenza
         , decode( posi.contratto_formazione
                 , 'NO', decode
                         ( posi.stagionale
                         , 'GG', '2'
                               , decode
                                 ( posi.part_time
                                 , 'SI', '8'
                                       , decode
                                         ( nvl(psep.ore,cost.ore_lavoro)
                                         , cost.ore_lavoro, '1'
                                                          , '9')
                                 )
                         )
                       , posi.tipo_formazione)                   impiego
         , decode( psep.assenza
                 , null, decode
                         ( nvl(psep.ore,cost.ore_lavoro)
                         , cost.ore_lavoro, decode( least(D_anno,2000)
                                                   ,2000, '4', '11')
                                          , decode
                                            ( posi.part_time
                                            , 'SI', decode( least(D_anno,2000)
                                                             ,2000, '5', '12') 
                                                  , decode( least(D_anno,2000)
                                                   ,2000, '4', '11'))
                         )
                       , decode(aste.cat_fiscale,'32','30',aste.cat_fiscale )
                   )                       servizio
         , decode ( psep.assenza
                  , null, null, decode(aste.cat_fiscale,'32',aste.per_ret, null)
                   )                       perc_l300
         , psep.posizione              posizione
         , figi.profilo                profilo
      from posizioni                   posi
         , astensioni                  aste
         , qualifiche_giuridiche       qugi
         , figure_giuridiche           figi
         , contratti_storici           cost
         , periodi_servizio_previdenza psep
         , estrazione_valori_contabili esvc
     where psep.ci             = CUR_CI.ci
       and psep.gestione       = CUR_CI.gestione
       and P_sfasato           = 'X'
       and aste.codice    (+)  = psep.assenza
       and aste.servizio  (+) != 0
       and posi.codice    (+)  = psep.posizione
       and qugi.numero         = psep.qualifica
       and figi.numero         = psep.figura
       and esvc.estrazione     = 'DENUNCIA_INPDAP'
       and esvc.colonna        = 'COMP_FISSE'
       and esvc.dal < nvl(psep.al,to_date(D_fin_a,'ddmmyyyy'))
       and nvl(esvc.al,to_date(D_fin_a,'ddmmyyyy')) >= psep.dal
       and esvc.dal           <= to_date(D_fin_a,'ddmmyyyy')
       and nvl(esvc.al,to_date('3333333','j'))
                              >= to_date(D_ini_a,'ddmmyyyy')
       and nvl(psep.al,to_date(D_fin_a,'ddmmyyyy')) between qugi.dal
                                    and nvl(qugi.al,to_date('3333333','j'))
       and nvl(psep.al,to_date(D_fin_a,'ddmmyyyy')) between figi.dal
                                    and nvl(figi.al,to_date('3333333','j'))
       and cost.contratto      = qugi.contratto
       and nvl(psep.al,to_date(D_fin_a,'ddmmyyyy')) between cost.dal
                                    and nvl(cost.al,to_date('3333333','j'))
       and psep.dal           < to_date('0101'||D_anno,'ddmmyyyy')
       and nvl(psep.al,to_date('3333333','j'))
                              >= to_date(D_ini_a,'ddmmyyyy')
       and psep.dal <= nvl(psep.al,to_date('3333333','j'))
       and psep.segmento      in
          (select 'i' from dual
            union
           select 'a' from dual
            where not exists
                  (select 'x'
                     from astensioni
                    where codice = psep.assenza
                      and servizio = 0)
            union
           select 'c' from dual
            union
           select 'f' from dual
            union
           select 'u' from dual
            where not exists
                 (select 'x'
                    from periodi_servizio_previdenza
                   where ci      = psep.ci
                     and segmento = 'a'
                     and dal     <= psep.dal
                     and nvl(al,to_date('3333333','j')) >= psep.dal)
          )
     order by 2,3
   ) LOOP
       IF CUR_PSEP.assenza is not null
          THEN  D_pr_err_2 := D_pr_err_2 + 1;
             /* Esiste Periodo di Assenza,verificare i gg utili */
                insert into a_segnalazioni_errore
               (no_prenotazione,passo,progressivo,errore,precisazione)
                select prenotazione
                     , 1
                     , D_pr_err_2
                     , 'P05193'
                     , substr('Cod.Ind.: '||rpad(to_char(CUR_CI.ci),8,' ')||'  '||
                       'Dal '||to_char(CUR_PSEP.dal,'dd/mm/yyyy')||'  '||
                       'Al '||to_char(CUR_PSEP.al,'dd/mm/yyyy'),1,50)
                 from dual
                where exists
                     (select 'x'
                        from periodi_giuridici
                       where rilevanza = 'S'
                         and ci        = CUR_CI.ci
                         and to_char(CUR_PSEP.dal,'mmyyyy')
                                       = to_char(CUR_PSEP.al,'mmyyyy')
                         and dal       < CUR_PSEP.al
                         and nvl(al,to_date('3333333','j')) > CUR_PSEP.dal)
                ;
       END IF;
       D_num_servizi := D_num_servizi + 1;

DENUNCE_INPDAP.PREVIDENZA( CUR_CI.ci, CUR_PSEP.posizione, CUR_PSEP.profilo, D_tipo_trattamento, D_ini_a, D_fin_a
                         , D_previdenza, CUR_PSEP.dal, CUR_PSEP.al, D_pr_err_0,  D_pr_err_1, I_pensione, I_previdenza
                         , prenotazione, P_denuncia);
       BEGIN
         select decode( I_previdenza
                      , 'CPDEL', codice_cpd
                               , codice_cps)
              , decode( I_previdenza
                      , 'CPDEL', posizione_cpd
                               , posizione_cps)
           into I_codice,I_posizione
           from rapporti_retributivi
          where ci = CUR_CI.ci;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN I_codice    := null;
                                 I_posizione := null;
       END;
       BEGIN
         select to_char(pegi.al ,'ddmmyyyy'),
                evra.cat_inpdap
           into I_data_ces,
                I_causa_ces
           from periodi_giuridici pegi,
                eventi_rapporto   evra
          where pegi.rilevanza = 'P'
            and pegi.ci        = CUR_CI.ci
            and pegi.posizione    = evra.codice
            and pegi.al  between CUR_PSEP.dal
                        and CUR_PSEP.al;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN I_data_ces := null;
                                 I_causa_ces := null;
       END;
BEGIN
         select
               round(sum(decode( vaca.colonna
                          , 'COMP_INADEL', vaca.valore
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_INADEL', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                     )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_INADEL', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
              , round(sum(decode( vaca.colonna
                          , 'COMP_TFR', vaca.valore
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                      )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
            , round(sum(decode( vaca.colonna
                          , 'IPN_TFR', vaca.valore
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                    )
                            * nvl(max(decode( vaca.colonna
                                        , 'IPN_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
            into I_comp_inadel,I_comp_tfr,I_ipn_tfr
              from valori_contabili_annuali vaca
              , estrazione_valori_contabili esvc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and esvc.dal              <= CUR_PSEP.al
            and nvl(esvc.al,to_date('3333333','j'))
                                      >= CUR_PSEP.dal
            and vaca.riferimento between esvc.dal
                                     and nvl(esvc.al,to_date('3333333','j'))
            and vaca.anno              = D_anno
            and vaca.mese              = 12
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna          in ('COMP_FISSE','COMP_ACCESSORIE'
                                         ,'COMP_INADEL','COMP_TFR','IPN_TFR'
                                         ,'PREAVV_RISARCITORIO','FERIE_NON_GODUTE','L_165')
            and vaca.ci                = CUR_CI.ci
            and vaca.moco_mensilita    != '*AP'
            AND to_char(vaca.riferimento,'yyyymm') 
                BETWEEN to_char(CUR_PSEP.dal,'yyyymm')
                    AND to_char(NVL(cur_psep.al,to_date(D_fin_a,'ddmmyyyy')),'yyyymm');
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
         I_comp_inadel := to_number(null);
         I_comp_tfr    := to_number(null);
         I_ipn_tfr     := to_number(null);
       END;

I_contribuzione := null;
I_enpdep        := null;

DENUNCE_INPDAP.CONTRIBUZIONE (D_anno, D_fin_a, I_comp_inadel, I_comp_tfr, I_ipn_tfr,CUR_CI.ci, I_contribuzione, I_enpdep);

     lock table denuncia_inpdap in exclusive mode nowait
     ;
     insert into denuncia_inpdap
          ( anno
          , previdenza
          , assicurazioni
          , ci
          , gestione
          , codice
          , posizione
          , rilevanza
          , dal
          , al
          , tipo_impiego
          , tipo_servizio
          , perc_l300
          , data_cessazione
          , causa_cessazione
          , comp_inadel
          , comp_tfr
          , ipn_tfr
          , utente
          , data_agg
          , comparto
          , sottocomparto
          )
     select to_number(D_anno)
          , nvl(I_previdenza,'CPDEL')
          , NVL(I_pensione||I_contribuzione || I_enpdep ||DECODE(I_previdenza, NULL, NULL, '9'),' ')
          , CUR_CI.ci
          , CUR_CI.gestione
          , I_codice
          , I_posizione
          , 'S'
          , CUR_PSEP.dal
          , CUR_PSEP.al
          , CUR_PSEP.impiego
          , CUR_PSEP.servizio
          , CUR_PSEP.perc_l300
          , null
          , null
          , decode(I_comp_inadel,0,null,I_comp_inadel)
          , decode(I_comp_tfr,0,null,I_comp_tfr)
          , decode(I_ipn_tfr,0,null,I_ipn_tfr)
          , D_utente
          , sysdate
          , P_comparto
          , P_sottocomparto
       from dual
      where not exists
           (select 'x' from denuncia_inpdap
             where anno       = to_number(D_anno)
               and gestione   = CUR_CI.gestione
               and previdenza = I_previdenza
               and ci         = CUR_CI.ci
               and dal        = CUR_PSEP.dal
           )
     ;
                  UPDATE DENUNCIA_INPDAP
                     SET data_cessazione  = TO_DATE(I_data_ces,'ddmmyyyy'),
                         causa_cessazione = I_causa_ces
                   WHERE anno = D_anno
                     AND gestione = CUR_CI.gestione
                     AND ci = CUR_CI.ci
                     AND rilevanza = 'S'
                     AND TO_DATE(I_data_ces,'ddmmyyyy') 
                         between dal and nvl(al,TO_DATE(I_data_ces,'ddmmyyyy')) 
                  ;
                 COMMIT;
     END LOOP; -- cur_psep

  IF P_ultima_cess = 'X' THEN
     update denuncia_inpdap dedp
        SET data_cessazione = null
          , causa_cessazione = null
      WHERE anno = D_anno
        AND gestione = CUR_CI.gestione
        AND ci = CUR_CI.ci
        AND rilevanza = 'S'
        AND exists (SELECT 'x'
                     FROM DENUNCIA_INPDAP dein
                    WHERE dein.anno = dedp.anno
                      AND dein.gestione = dedp.gestione
                      AND dein.ci = dedp.ci
                      AND dein.rilevanza = 'S'
                      and data_cessazione > dedp.data_cessazione
                     ) 
     ;
    COMMIT;
  END IF;

DENUNCE_INPDAP.UPDATE_IMPIEGO(D_anno,D_fin_a, P_denuncia,sysdate);
DENUNCE_INPDAP.UPDATE_SERVIZIO(D_anno,D_pr_err_3, prenotazione, P_denuncia);
DENUNCE_INPDAP.ASSICURAZIONI_ASSENZE (D_anno, D_fin_a, CUR_CI.ci);

-- Attribuzione qualifica ministeriale

      BEGIN
      select greatest(nvl(max(progressivo),0),150000)
        into D_pr_err_5
        from a_segnalazioni_errore
       where no_prenotazione = prenotazione
         and passo           = 1
         and progressivo between 150000 and 200000;
      EXCEPTION 
           WHEN NO_DATA_FOUND THEN D_pr_err_5 := 150000;
      END;
      DENUNCE_INPDAP.DETERMINA_QUALIFICA(D_anno,CUR_CI.ci,D_ini_a, D_fin_a,D_qualifica,CUR_CI.gestione
                                        ,D_pr_err_5, prenotazione, P_denuncia);
      DENUNCE_INPDAP.AGGIUNGI_SEGNALAZIONI (D_anno, D_ini_a, D_fin_a, CUR_CI.ci, prenotazione, D_pr_err_4);

/* Controllo su tipo_servizio 30 */
      BEGIN
      select greatest(nvl(max(progressivo),0),70000)
        into D_pr_err_7
        from a_segnalazioni_errore
       where no_prenotazione = prenotazione
         and passo           = 1
         and progressivo between 70000 and 80000;
      EXCEPTION 
           WHEN NO_DATA_FOUND THEN D_pr_err_7 := 70000;
      END;
      V_controllo := null;
      BEGIN
      select 'X'
        into v_controllo
        from dual
       where exists ( select 'x' from denuncia_inpdap
                       where anno = D_anno 
                         and ci = CUR_CI.ci
                         and tipo_servizio = '30'
                    );
     EXCEPTION WHEN NO_DATA_FOUND THEN  
        V_Controllo := null;
     END;
    IF V_controllo = 'X' THEN
       D_pr_err_7 := D_pr_err_7 + 1;
       IF D_pr_err_7 >= 80000 THEN NULL;
       ELSE
 	     INSERT INTO a_segnalazioni_errore
           ( no_prenotazione, passo, progressivo, errore, precisazione )
	     SELECT prenotazione
                 , 1
                 , D_pr_err_7
                 , 'P05184'
                 , ' Per il Cod.Ind.: '||RPAD(TO_CHAR(CUR_CI.ci),8,' ')
             FROM dual;
      END IF;
    END IF;

END LOOP; -- cur_ci
/*
  FOR CUR_DIP IN 
  ( select distinct ci 
      from denuncia_inpdap dedp
     where anno = D_anno
       and (D_tipo != 'S'
        or  D_tipo = 'S' and ci = D_ci)
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci + 0 = dedp.ci
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
          )
  ) LOOP
  BEGIN
     DENUNCE_INPDAP.ACCORPA_PERIODI (D_anno, CUR_DIP.ci, P_sfasato);
  END;
  END LOOP; -- cur_dip
*/
EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = D_errore
       where no_prenotazione = prenotazione;
      commit;
END;
END;
END;
/
