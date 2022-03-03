CREATE OR REPLACE PACKAGE peccao1m IS
/******************************************************************************
 NOME:        PECCAO1M
 DESCRIZIONE: Creazione delle registrazioni annuali individuali per la fase di
              stampa della denuncia annuale 01/M INPS.
              Questa funzione inserisce nella tavola DENUNCIA_01_INPS le registrazioni
              realtive ad ogni individuo che ha prestato servizio nell'anno richiesto
              per consentire ad una funzione successiva di fornire un tabulato
              che permetta la compilazione dei modelli 01/M INPS.
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  Il PARAMETRO D_gestione determina quale gestione elaborare.
               Il PARAMETRO D_tipo     determina il tipo di elaborazione da effettuare.
               Il PARAMETRO D_ruolo    indica se elaborare solo il personale non di
               ruolo
 REVISIONI:
 Rev. Data       Autore   Descrizione
 ---- ---------- ------   --------------------------------------------------------
 0                        Prima emissione
 1    20/01/2003
 1    17/06/2004 Gianluca Estrazione del parametro P_ANNO da a_prenotazioni
 1    05/07/2004 Gianluca Trattamento del paramentro P_RUOLO
 1    03/09/2004 Gianluca Sistemata la Delete, adesso tiene conto del parametro P_RUOLO
 1.5  07/10/2004 AM       gestito il valore % (=tutti) per il parametro P_RUOLO
 1.6  02/11/2004 MS       Modifica per att. 6662
 1.7  21/12/2004 MS       Modifica per att. 8885
 1.8  21/12/2004 MS       Modifica per att. 8892
 1.9  28/12/2004 MS       Modifica per att. 8884
 2.0  01/02/2005 MS       Modifica per att. 9557
 2.1  18/02/2005 MS       Modifica per att. 8884.1
 2.2  07/03/2005 MS       Modifica per att. 10041
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN   (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY peccao1m IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V2.2 del 07/03/2005';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
  BEGIN
DECLARE
P_ente       varchar2(4);
P_ambiente   varchar2(8);
P_utente     varchar2(8);
D_errore     varchar2(6);
P_anno       varchar2(4);
P_gestione   varchar2(4);
P_tipo       varchar2(1);
P_incarico   varchar2(1);
P_dal        date;
P_al         date;
P_ruolo      varchar2(1);
P_gennaio    varchar2(1);
P_tipo_gg    varchar2(1);
P_tfr_privati varchar2(1);
P_ci         number(8);
USCITA       EXCEPTION;
BEGIN
	BEGIN
      select valore D_incarico
	    into P_incarico
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_INCARICO'
      ;
	  EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	P_incarico := to_char(null);
	END;
	BEGIN
      select valore D_tipo
	    into P_tipo
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_TIPO'
      ;
	  EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	P_tipo := to_char(null);
	END;
      BEGIN
	select to_number(valore) D_ci
        into P_ci
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_CI'
      ;
	  EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	P_ci := to_number(null);
	  END;
      IF nvl(P_ci,0) = 0 and nvl(P_tipo,'X') = 'S' 
       THEN D_errore := 'A05721';
            RAISE USCITA;
      ELSIF nvl(P_ci,0) != 0 and nvl(P_tipo,'X') = 'T' 
       THEN D_errore := 'A05721';
            RAISE USCITA;
      END IF;
	BEGIN
      select valore D_tipo_gg
        into P_tipo_gg
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_TIPO_GG'
      ;
	  EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	P_tipo_gg := to_char(null);
	END;

      BEGIN
	select to_date(valore,decode(nvl(length(translate(valore,'a0123456789/','a')),0),0,'dd/mm/yyyy','dd-mon-yy')) D_dal
        into P_dal
		from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_DAL'
      ;
	  EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	P_dal := to_date(null);
	END;
	BEGIN
      select to_date(valore,decode(nvl(length(translate(valore,'a0123456789/','a')),0),0,'dd/mm/yyyy','dd-mon-yy')) D_al
        into P_al
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_AL'
      ;
	  EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	P_al := to_date(null);
	END;
	BEGIN
      select valore D_ruolo
	     into P_ruolo
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_RUOLO'
      ;
	  EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	P_ruolo := '%';
	END;
	BEGIN
      select valore D_gennaio
	    into P_gennaio
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_GENNAIO'
      ;
	  EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	P_gennaio := to_char(null);
	END;
	BEGIN
      select valore D_gestione
	    into P_gestione
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_GESTIONE'
      ;
	  EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	P_gestione := to_char(null);
	END;
      select ente     D_ente
           , utente   D_utente
           , ambiente D_ambiente
        into P_ente, P_utente, P_ambiente
        from a_prenotazioni
       where no_prenotazione = prenotazione
      ;
   BEGIN
      select valore D_anno
        into P_anno
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_ANNO'
      ;
   EXCEPTION
	  WHEN NO_DATA_FOUND THEN
       select to_char(anno)  D_anno
	      into P_anno
         from riferimento_fine_anno
        where rifa_id = 'RIFA'
       ;
   END;
   BEGIN
      select valore
        into P_tfr_privati
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_PRIVATI'
      ;
   EXCEPTION
	  WHEN NO_DATA_FOUND THEN
         P_tfr_privati := null;
   END;
     lock table denuncia_o1_inps in exclusive mode nowait
     ;
     delete from denuncia_o1_inps d1is
      where d1is.anno             = to_number(P_anno)
        and d1is.istituto         = 'INPS'
        and d1is.ci      = nvl(P_ci,d1is.ci)
        and d1is.gestione      like P_gestione
        and (        P_tipo = 'T'
             or (P_tipo = 'S' and d1is.ci = P_ci
                )
             or (    P_tipo = 'C'
                 and exists (select 'x' from periodi_giuridici
                                           , riferimento_retribuzione
                              where rire_id   = 'RIRE'
                                and rilevanza = 'P'
                                and ci        = d1is.ci
                                and al  between nvl(P_dal,ini_ela)
                                            and nvl(P_al,fin_ela)
                             )
                )
             or not exists
               (select 'x' from denuncia_o1_inps
                 where anno     = d1is.anno
                   and ci       = d1is.ci
                   and gestione = d1is.gestione
                   and (   nvl(tipo_agg,' ')   = decode(P_tipo
                                                       ,'C',nvl(tipo_agg,' ')
                                                           ,P_tipo)
                        or (P_tipo     = 'P' and
                            tipo_agg is not null
                           )
                       )
               )
            )
        and (    P_ruolo = '%'
             or  exists (select 'x' from periodi_retributivi
                          where periodo
                               between to_date('01'||P_anno,'mmyyyy')
                                   and last_day(to_date('12'||to_number(P_anno),'mmyyyy'))
                            and competenza in ('P','C','A')
                            and servizio   in ('Q','I','N')
                            and gestione like nvl('','%')
                            and ci          = d1is.ci
                            and posizione  in
                               (select codice from posizioni
                                 where di_ruolo = p_ruolo
                               )
                        )
            )
        and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = ci
               and (   rain.cc is null
                    or exists
                      (select 'x'
                         from a_competenze
                        where ente        = P_ente
                          and ambiente    = P_ambiente
                          and utente      = P_utente
                          and competenza  = 'CI'
                          and oggetto     = rain.cc
                      )
                   )
           )
     ;
     commit
     ;
     lock table denuncia_o1_inps in exclusive mode nowait
     ;
     insert into denuncia_o1_inps
          ( anno
          , ci
          , gestione
          , provincia
          , codice
          , qualifica
          , tempo_pieno
          , tempo_determinato
          , assicurazioni
          , settimane
          , giorni
          , mesi
          , dal
          , al
          , contratto
          , livello
          , data_cessazione
          , tipo_rapporto
          , sett_utili
          , rd_148
          , utente
          , tipo_agg
          , istituto
          )
     select to_number(P_anno)
          , pere.ci
          , substr(max(to_char(pere.al,'j')||pere.gestione),8,4)          gest
          , decode
            ( substr(max(  to_char(pere.al,'j')
                         ||gest.provincia_inps),8)
            , substr(max(  to_char(pere.al,'j')
                         ||prov.sigla),8), null
              , substr(max(to_char(pere.al,'j')||gest.provincia_inps),8)) prov
          , max(rare.codice_inps )                                cod_inps
          , decode( to_char(qual.qua_inps)
                  , '0', 'Q'
                       , to_char(qual.qua_inps)
                  )                                               qual
          , decode(nvl(pere.ore,cost.ore_lavoro)
                  ,cost.ore_lavoro,'SI'
                                  ,'NO')                          tempo_pieno
          , posi.tempo_determinato                                tempo_det
          , substr(reco_a.rv_low_value,1,1)                       ass
          , least
            ( 52
            , sum(decode( to_char(pere.al,'yyyy')
                        , P_anno, pere.st_inp
                                   , 0
                        )
                 )
            )                                                     st
          , sum( decode( to_char(pere.al,'yyyy')
                       , P_anno, decode(P_tipo_gg,'I',pere.gg_inp
                                                          ,pere.gg_con
                                          )
                                  , 0
                       )
               )                                                  gg
          , decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'01',
                                         decode(P_tipo_gg,'I',pere.gg_inp
                                                               ,pere.gg_con)
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'02',
                                         decode(P_tipo_gg,'I',pere.gg_inp
                                                               ,pere.gg_con)
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'03',
                                         decode(P_tipo_gg,'I',pere.gg_inp
                                                               ,pere.gg_con)
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'04',
                                         decode(P_tipo_gg,'I',pere.gg_inp
                                                               ,pere.gg_con)
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'05',
                                         decode(P_tipo_gg,'I',pere.gg_inp
                                                               ,pere.gg_con)
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'06',
                                         decode(P_tipo_gg,'I',pere.gg_inp
                                                               ,pere.gg_con)
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'07',
                                         decode(P_tipo_gg,'I',pere.gg_inp
                                                               ,pere.gg_con)
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'08',
                                         decode(P_tipo_gg,'I',pere.gg_inp
                                                               ,pere.gg_con)
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'09',
                                         decode(P_tipo_gg,'I',pere.gg_inp
                                                               ,pere.gg_con)
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'10',
                                         decode(P_tipo_gg,'I',pere.gg_inp
                                                               ,pere.gg_con)
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'11',
                                         decode(P_tipo_gg,'I',pere.gg_inp
                                                               ,pere.gg_con)
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'12',
                                         decode(P_tipo_gg,'I',pere.gg_inp
                                                               ,pere.gg_con)
                                                         , 0))
                  , 0, ' ', 'X')                                  mesi
          , min(decode( least( greatest( pere.dal
                                       , to_date(lpad(pere.mese,2,0)||
                                                 pere.anno,'mmyyyy')
                                       )
                         , nvl(pere.al,to_date('3333333','j')))
                  , nvl(pere.al,to_date('3333333','j')), pere.dal
                       , greatest( pere.dal
                                 , to_date(lpad(pere.mese,2,0)||
                                           pere.anno,'mmyyyy')
                                 ))
                  )                                               dal
          , max(pere.al)                                          al
          , max(cost.con_inps)                                    cont
          , substr(max(to_char(pere.dal,'j')||
                       to_char(pere.al,'j')||qual.inq_inps),15,4) liv
          , decode
            (to_char
             (decode
              ( least( max(nvl(pegi.al,to_date('3333333','j')))
                     , to_date('3112'||P_anno,'ddmmyyyy')+1
                     , max(pere.al)
                     )
              , to_date('3112'||P_anno,'ddmmyyyy')+1, to_date(null)
              , max(pegi.al)                       , max(pegi.al)
                                                   , to_date(null)
              )
             ,'yyyy')
            , P_anno, decode
                         ( least( max(nvl(pegi.al,to_date('3333333','j')))
                                , to_date('3112'||P_anno,'ddmmyyyy')+1
                                , max(pere.al)
                                )
                         , to_date('3112'||P_anno,'ddmmyyyy')+1, to_date(null)
                         , max(pegi.al)                       , max(pegi.al)
                                                              , to_date(null)
                         )
            )                                                     cess
          , substr(reco_t.rv_abbreviation,1,2)                       tipo
          , decode
            ( substr(reco_a.rv_low_value,1,1)
            , '0', to_number(null)
            , '2', to_number(null)
            , '3', to_number(null)
            , '4', to_number(null)
            , '8', to_number(null)
                 , least( 52
                        , decode
                          (nvl(max(pere.ore),max(cost.ore_lavoro))
                          ,max(cost.ore_lavoro),to_number(null)
                                               ,round( sum(pere.st_inp)
                                                      * ( max(pere.ore)
                                                         / max(cost.ore_lavoro)
                                                        )
                                                     )
                          )
                        )
            )                                                st_u
          , decode( max(gest.codice_attivita)
                  , '60210', decode
                              ( max(posi.di_ruolo)
                              , 'R', decode
                                      ( max(to_char(pegi.dal,'yyyy'))
                                      , P_anno, max(to_char(pegi.dal,'mm'))
                                               , 'SI')
                                   , 'NO')
                           , null)                                rd_148
          , 'X'                                                   utente
          , decode(P_tipo,'C','I',null)                        tipo_agg
          , 'INPS'                                                istituto
       from riferimento_retribuzione    rire
          , gestioni                    gest
          , posizioni                   posi
          , qualifiche                  qual
          , trattamenti_previdenziali   trpr
          , pec_ref_codes               reco_t
          , pec_ref_codes               reco_a
          , contratti_storici           cost
          , rapporti_retributivi        rare
          , periodi_giuridici           pegi
          , periodi_retributivi         pere
          , a_provincie                 prov
      where rire.rire_id        = 'RIRE'
        and pere.periodo  between to_date('01'||P_anno,'mmyyyy')
                              and last_day(to_date('01'||(P_anno+1),'mmyyyy'))
        and to_char(pere.al,'yyyy') <= P_anno
        and pere.competenza in ('P','C','A')
        and (   (    nvl(P_incarico,' ') = 'X'
                 and pere.servizio         in ('Q','I','N'))
             or (    nvl(P_incarico,' ') != 'X'
                 and pere.servizio = 'Q')
            )
        and pere.gestione       like P_gestione
        and gest.codice        (+) = pere.gestione
        and prov.provincia     (+) = gest.provincia_res
        and posi.codice        (+) = pere.posizione
        and nvl(posi.collaboratore,'NO') = 'NO'
        and (   posi.di_ruolo      = p_ruolo
             or p_ruolo            = '%')
        and trpr.codice    (+) = pere.trattamento
        and trpr.contribuzione != 99
        and qual.numero    (+) = pere.qualifica
        and cost.contratto (+) = pere.contratto
        and pere.periodo between cost.dal
                             and nvl(cost.al,to_date('3333333','j'))
        and reco_a.rv_domain (+) = 'DENUNCIA_O1_INPS.ASSICURAZIONI'
        and instr(reco_a.rv_abbreviation,lpad(trpr.contribuzione,2,0)) != 0
        and reco_t.rv_domain (+) = 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
        and reco_t.rv_low_value (+) = to_char(trpr.contribuzione)
        and rare.ci (+) = pere.ci
        and pegi.ci     = pere.ci
        and pegi.rilevanza = 'P'
        and pegi.dal =
           (select decode( nvl(max(p1.dal),to_date('2222222','j'))
                         , to_date('2222222','j'), max(p2.dal)
                                                 , max(p1.dal))
              from periodi_giuridici p1
                 , periodi_giuridici p2
                 , dual       dual
             where p1.ci (+)             = pegi.ci
               and p1.rilevanza (+)      = substr(dual.dummy||'P',2)
               and p1.dal (+) <= nvl(pere.al,to_date('3333333','j'))
               and nvl(p1.al(+),to_date('3333333','j')) >= pere.dal
               and p2.ci                 = pegi.ci
               and p2.rilevanza          = 'P'
               and p2.dal               <= to_date('3112'||P_anno,'ddmmyyyy')
           )
        and pere.ci      = nvl(P_ci,pere.ci)
        and (   P_tipo != 'C'
             or (P_tipo = 'S' and pere.ci = P_ci
                )
             or pegi.al between nvl(P_dal,rire.ini_ela)
                            and nvl(P_al,rire.fin_ela))
        and exists
           (select 'x' from movimenti_contabili
             where anno = to_char(pere.periodo,'yyyy')
               and mese = to_char(pere.periodo,'mm')
               and ci   = pere.ci
               and (voce,nvl(sub,'*')) in
                  (select voce,nvl(sub,'*')
                     from estrazione_righe_contabili
                    where estrazione = 'DENUNCIA_O1_INPS'
                      and colonna   in ('IMPORTO_CC','IMPORTO_AC')
                      and to_date('3112'||P_anno,'ddmmyyyy')
                          between dal
                              and nvl(al,to_date('3333333','j'))
                  )
            )
        and exists
           (select 'x'
              from rapporti_individuali rain
             where rain.ci = pere.ci
               and (   rain.cc is null
                    or exists
                      (select 'x'
                         from a_competenze
                        where ente        = P_ente
                          and ambiente    = P_ambiente
                          and utente      = P_utente
                          and competenza  = 'CI'
                          and oggetto     = rain.cc
                      )
                   )
           )
       and not exists (select 'x' from denuncia_o1_inps
                        where anno     = to_number(P_anno)
                          and istituto = 'INPS'
                          and ci       = pere.ci
                          and gestione = pere.gestione)
      group by pere.ci,gest.posizione_inps
             , qual.qua_inps
             , decode(nvl(pere.ore,cost.ore_lavoro)
                     ,cost.ore_lavoro,'SI'
                                     ,'NO')
             , posi.tempo_determinato
             , substr(reco_a.rv_low_value,1,1)
             , substr(reco_t.rv_abbreviation,1,2)
     ;
     commit;
    update denuncia_o1_inps x
       set al = (select min(dal) -1
                   from denuncia_o1_inps
                  where anno   = x.anno
                    and istituto = x.istituto
                    and ci     = x.ci
                    and al     > x.al
                    and dal   != x.dal
                    and dal   <= x.al
                    and dal    between x.dal
                                   and nvl(x.al,to_date('3333333','j'))
                )
     where anno = P_anno
       and istituto = 'INPS'
       and exists
          (select 'x'
             from denuncia_o1_inps
            where anno   = x.anno
              and istituto = x.istituto
              and ci     = x.ci
              and al     > x.al
              and dal   != x.dal
              and dal   <= x.al
              and dal    between x.dal
                             and nvl(x.al,to_date('3333333','j'))
          )
    ;
    commit;
     lock table denuncia_o1_inps in exclusive mode nowait
     ;
     update denuncia_o1_inps d1is set d1is.trasf_rapporto = 'SI'
      where d1is.anno        = to_number(P_anno)
        and d1is.istituto    = 'INPS'
        and d1is.gestione like P_gestione
        and 2               <= (select count(*) from denuncia_o1_inps
                                 where anno = d1is.anno
                                   and ci   = d1is.ci
                               )
        and exists             (select 'x' from denuncia_o1_inps
                                 where anno = d1is.anno
                                   and istituto = d1is.istituto
                                   and ci   = d1is.ci
                                   and tempo_pieno != d1is.tempo_pieno
                               )
        and d1is.utente      = 'X'
     ;
     commit;
     lock table denuncia_o1_inps in exclusive mode nowait
     ;
     update denuncia_o1_inps d1is
        set importo_ap =
           (select greatest(0, decode( valuta
		                             , 'L', round( ( d1is.importo_ap
                                                    -nvl(sum(prfi.fdo_tfr_ap_liq),0)
                                                    -nvl(sum(prfi.riv_tfr_liq),0)
                                                    -nvl(sum(prfi.qta_tfr_ac_liq),0)
                                                   )
                                                  / 1000
                                                 )* 1000
                                          , round( ( d1is.importo_ap
                                                    -nvl(sum(prfi.fdo_tfr_ap_liq),0)
                                                    -nvl(sum(prfi.riv_tfr_liq),0)
                                                    -nvl(sum(prfi.qta_tfr_ac_liq),0)
                                                   ))
							         )
					       )
     	      from progressivi_fiscali      prfi
             where prfi.anno       = d1is.anno
               and prfi.mese       = 12
               and prfi.mensilita  =
                  (select max(mensilita) from mensilita
                    where mese  = 12
                      and tipo in ('S','N','A'))
               and prfi.ci         = d1is.ci)
      where d1is.anno        = to_number(P_anno)
        and d1is.istituto    = 'INPS'
        and d1is.gestione like P_gestione
        and d1is.dal         =
           (select max(dal) from denuncia_o1_inps
             where anno      = d1is.anno
               and istituto  = d1is.istituto
               and gestione  = d1is.gestione
               and ci        = d1is.ci)
        and d1is.utente     = 'X'
     ;
     commit;
     update denuncia_o1_inps d1is
        set importo_ap =
           (select greatest(0, round( ( d1is.importo_ap
                                       -nvl(sum(prfi.fdo_tfr_ap_liq),0)
                                       -nvl(sum(prfi.riv_tfr_liq),0)
                                       -nvl(sum(prfi.qta_tfr_ac_liq),0)
                                      )
                                     / 1000
                                    )* 1000)
              from progressivi_fiscali      prfi
             where prfi.anno       = d1is.anno
               and prfi.mese       = 12
               and prfi.mensilita  =
                  (select max(mensilita) from mensilita
                    where mese  = 12
                      and tipo in ('S','N','A'))
               and prfi.ci         = d1is.ci)
      where d1is.anno        = to_number(P_anno)
        and d1is.istituto    = 'INPS'
        and d1is.gestione like P_gestione
        and d1is.dal         =
           (select max(dal) from denuncia_o1_inps
             where anno      = d1is.anno
               and istituto  = d1is.istituto
               and gestione  = d1is.gestione
               and ci        = d1is.ci)
        and (   d1is.qualifica != '3'
             or d1is.qualifica  = '3' and
                d1is.contratto in ('042','043','044','045','046')
            )
        and d1is.utente     = 'X'
     ;
     commit;
DECLARE
 D_importo_cc       number;
 D_importo_ac       number;
 D_af               varchar2(1);
 D_max_af           date;
 D_nucleo_af        number;
 D_cond_af          varchar2(4);
 D_nr_sca_af        varchar2(3);
 D_tabella_af       varchar2(3);
 D_tipo_c1          varchar2(3);
 D_dal_c1           date;
 D_al_c1            date;
 D_importo_c1       number;
 D_importo_pen_c1   number;
 D_tipo_c2          varchar2(3);
 D_dal_c2           date;
 D_al_c2            date;
 D_importo_c2       number;
 D_importo_pen_c2   number;
 D_tipo_c3          varchar2(3);
 D_dal_c3           date;
 D_al_c3            date;
 D_importo_c3       number;
 D_importo_pen_c3   number;
 D_tipo_c4          varchar2(3);
 D_dal_c4           date;
 D_al_c4            date;
 D_importo_c4       number;
 D_importo_pen_c4   number;
 D_sett_d           number;
 D_importo_rid_d    number;
 D_importo_cig_d    number;
 D_sett1_mal_d      number;
 D_sett2_mal_d      number;
 D_sett1_mat_d      number;
 D_sett2_mat_d      number;
 D_sett1_m88_d      number;
 D_sett2_m88_d      number;
 D_sett1_m53_d      number;
 D_sett2_m53_d      number;
 D_sett1_cig_d      number;
 D_sett2_cig_d      number;
 D_sett2_dds_d      number;
 BEGIN
 BEGIN
    select nvl(max('x'),' ')
      into D_af
      from estrazione_righe_contabili
     where estrazione = 'DENUNCIA_O1_INPS'
       and colonna    = 'IMPORTO_AF'
       and voce      is not null
    ;
    RAISE TOO_MANY_ROWS;
    EXCEPTION WHEN NO_DATA_FOUND THEN D_af := ' ';
              WHEN TOO_MANY_ROWS  THEN D_af := 'x';
  END;
     FOR CURS_CI IN
        (select rowid,anno,ci,dal,al,mesi,data_cessazione data_cess
           from denuncia_o1_inps d1is
          where anno = to_number(P_anno)
            and istituto = 'INPS'
            and utente = 'X'
            and exists
                (select 'x'
                   from rapporti_individuali rain
                  where rain.ci = d1is.ci
                    and (   rain.cc is null
                         or exists
                           (select 'x'
                              from a_competenze
                             where ente        = p_ente
                               and ambiente    = p_ambiente
                               and utente      = p_utente
                               and competenza  = 'CI'
                               and oggetto     = rain.cc
                           )
                        )
                  )
        ) LOOP
   BEGIN
     select max(dal)
       into D_max_af
       from denuncia_o1_inps
      where anno = CURS_CI.anno
        and istituto = 'INPS'
        and ci   = CURS_CI.ci
     ;
   END;
   BEGIN
    select round( sum(vaca.valore*decode( vaca.colonna
                                        , 'IMPORTO_CC', 1
                                                      , 0))
                / nvl(max(decode( vaca.colonna
                            , 'IMPORTO_CC', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vaca.colonna
                            , 'IMPORTO_CC', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         , round( sum(vaca.valore*decode( vaca.colonna
                                        , 'IMPORTO_AC', 1
                                                      , 0))
                / nvl(max(decode( vaca.colonna
                            , 'IMPORTO_AC', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vaca.colonna
                            , 'IMPORTO_AC', nvl(esvc.arrotonda,0.01)
                                           , '')),1)
      into D_importo_cc,D_importo_ac
      from valori_contabili_annuali    vaca
         , estrazione_valori_contabili esvc
     where vaca.estrazione      = 'DENUNCIA_O1_INPS'
       and vaca.colonna        in ('IMPORTO_CC','IMPORTO_AC')
       and vaca.anno            = CURS_CI.anno
       and vaca.mese            = 12
       and vaca.mensilita       = (select max(mensilita) from mensilita
                                    where mese = 12
                                      and tipo in ('A','N','S'))
       and vaca.ci              = CURS_CI.ci
       and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                   , least( to_date('01'||to_char(CURS_CI.anno),'mmyyyy')
                          , nvl(CURS_CI.al,to_date('3333333','j'))
                          )
                   ) between CURS_CI.dal
                         and nvl(CURS_CI.al,to_date('3333333','j'))
       and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                   , least( to_date('01'||to_char(CURS_CI.anno),'mmyyyy')
                          , nvl(CURS_CI.al,to_date('3333333','j'))
                          )
                   ) between esvc.dal
                         and nvl(esvc.al,to_date('3333333','j'))
       and nvl(vaca.valore,0) != 0
       and esvc.estrazione     = vaca.estrazione
       and esvc.colonna        = vaca.colonna
       and not exists
          (select 'x' from denuncia_o1_inps
            where anno = CURS_CI.anno
              and istituto = 'INPS'
              and ci   = CURS_CI.ci
              and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                          , least( to_date('01'||to_char(anno),'mmyyyy')
                                 , nvl(al,to_date('3333333','j'))
                                 )
                          ) between dal
                                and nvl(al,to_date('3333333','j'))
              and dal >= CURS_CI.dal
              and al  <= CURS_CI.al
              and nvl(giorni,0) != 0
              and rowid         != CURS_CI.rowid)
     ;
IF P_gennaio is not null
   THEN
     BEGIN
      select nvl(D_importo_cc,0) -
             nvl(round( sum(nvl(vaca.valore,0)*decode( vaca.colonna
                                          , 'IMPORTO_CC', 1
                                                        , 0))
                       / nvl(max(decode( vaca.colonna
                                     , 'IMPORTO_CC', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                       )
                       * nvl(max(decode( vaca.colonna
                                   , 'IMPORTO_CC', nvl(esvc.arrotonda,0.01)
                                                 , '')),1)
                 ,0)
           , nvl(D_importo_ac,0) -
             nvl(round( sum(nvl(vaca.valore,0)*decode( vaca.colonna
                                          , 'IMPORTO_AC', 1
                                                        , 0))
                       / nvl(max(decode( vaca.colonna
                                     , 'IMPORTO_AC', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                      )
                         * nvl(max(decode( vaca.colonna
                                     , 'IMPORTO_AC', nvl(esvc.arrotonda,0.01)
                                                   , '')),1)
                , 0)
        into D_importo_cc,D_importo_ac
        from valori_contabili_annuali    vaca
           , estrazione_valori_contabili esvc
       where vaca.estrazione      = 'DENUNCIA_O1_INPS'
         and vaca.colonna        in ('IMPORTO_CC','IMPORTO_AC')
         and vaca.anno            = CURS_CI.anno
         and vaca.mese            = 1
         and vaca.mensilita       = (select max(mensilita) from mensilita
                                      where mese = 1
                                        and tipo in ('A','N','S'))
         and vaca.ci              = CURS_CI.ci
         and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                     , least( to_date('01'||to_char(CURS_CI.anno),'mmyyyy')
                            , nvl(CURS_CI.al,to_date('3333333','j'))
                            )
                     ) between CURS_CI.dal
                           and nvl(CURS_CI.al,to_date('3333333','j'))
         and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                     , least( to_date('01'||to_char(CURS_CI.anno),'mmyyyy')
                            , nvl(CURS_CI.al,to_date('3333333','j'))
                            )
                     ) between esvc.dal
                           and nvl(esvc.al,to_date('3333333','j'))
         and to_char(vaca.riferimento,'yyyy') = CURS_CI.anno - 1
         and nvl(vaca.valore,0) != 0
         and esvc.estrazione     = vaca.estrazione
         and esvc.colonna        = vaca.colonna
         and not exists
            (select 'x' from denuncia_o1_inps
              where anno = CURS_CI.anno
                and istituto = 'INPS'
                and ci   = CURS_CI.ci
                and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                            , least( to_date('01'||to_char(anno),'mmyyyy')
                                   , nvl(al,to_date('3333333','j'))
                                   )
                            ) between dal
                                  and nvl(al,to_date('3333333','j'))
                and dal >= CURS_CI.dal
                and al  <= CURS_CI.al
                and nvl(giorni,0) != 0
                and rowid         != CURS_CI.rowid)
       ;
     END;
     BEGIN
      select nvl(D_importo_cc,0) +
             nvl(round( sum(nvl(vaca.valore,0)*decode( vaca.colonna
                                          , 'IMPORTO_CC_GEN', 1
                                                        , 0))
                      / nvl(max(decode( vaca.colonna
                                    , 'IMPORTO_CC_GEN', nvl(esvc.arrotonda,0.01)
                                                  , '')),1)
                      )
                        * nvl(max(decode( vaca.colonna
                                    , 'IMPORTO_CC_GEN', nvl(esvc.arrotonda,0.01)
                                                  , '')),1)
                 ,0)
           , nvl(D_importo_ac,0) +
             nvl(round( sum(nvl(vaca.valore,0)*decode( vaca.colonna
                                          , 'IMPORTO_AC_GEN', 1
                                                        , 0))
                       / nvl(max(decode( vaca.colonna
                                   , 'IMPORTO_AC_GEN', nvl(esvc.arrotonda,0.01)
                                                     , '')),1)
                      )
                      * nvl(max(decode( vaca.colonna
                              , 'IMPORTO_AC_GEN', nvl(esvc.arrotonda,0.01)
                                            , '')),1)
                 ,0)
        into D_importo_cc,D_importo_ac
        from valori_contabili_annuali    vaca
           , estrazione_valori_contabili esvc
       where vaca.estrazione      = 'DENUNCIA_O1_INPS'
         and vaca.colonna        in ('IMPORTO_CC_GEN','IMPORTO_AC_GEN')
         and vaca.anno            = CURS_CI.anno + 1
         and vaca.mese            = 1
         and vaca.mensilita       = (select max(mensilita) from mensilita
                                      where mese = 1
                                        and tipo in ('A','N','S'))
         and vaca.ci              = CURS_CI.ci
         and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                     , least( to_date('01'||to_char(CURS_CI.anno),'mmyyyy')
                            , nvl(CURS_CI.al,to_date('3333333','j'))
                            )
                     ) between CURS_CI.dal
                           and nvl(CURS_CI.al,to_date('3333333','j'))
         and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                     , least( to_date('01'||to_char(CURS_CI.anno),'mmyyyy')
                            , nvl(CURS_CI.al,to_date('3333333','j'))
                            )
                     ) between esvc.dal
                           and nvl(esvc.al,to_date('3333333','j'))
         and to_char(vaca.riferimento,'yyyy') = CURS_CI.anno
         and nvl(vaca.valore,0) != 0
         and esvc.estrazione     = vaca.estrazione
         and esvc.colonna        = vaca.colonna
         and not exists
            (select 'x' from denuncia_o1_inps
              where anno = CURS_CI.anno
                and istituto = 'INPS'
                and ci   = CURS_CI.ci
                and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                            , least( to_date('01'||to_char(anno),'mmyyyy')
                                   , nvl(al,to_date('3333333','j'))
                                   )
                            ) between dal
                                  and nvl(al,to_date('3333333','j'))
                and dal >= CURS_CI.dal
                and al  <= CURS_CI.al
                and nvl(giorni,0) != 0
                and rowid         != CURS_CI.rowid)
       ;
     END;
END IF;
     IF D_af = 'x' THEN
        IF CURS_CI.dal = D_max_af THEN
           BEGIN
           select substr(max(lpad(to_char(cafa.mese_att),2,'0')||
                             lpad(to_char(cafa.nucleo_fam),2,'0')),3)
                , substr(max(lpad(to_char(cafa.mese_att),2,'0')||
                             cafa.cond_fam),3)
             into D_nucleo_af,D_cond_af
             from carichi_familiari         cafa
            where cafa.anno       = CURS_CI.anno
              and cafa.mese       = nvl(to_char(CURS_CI.data_cess,'mm'),12)
              and cafa.ci         = CURS_CI.ci
              and cafa.cond_fam  is not null
              and D_af            = 'x'
           ;
           EXCEPTION WHEN NO_DATA_FOUND THEN D_nucleo_af := null;
                                             D_cond_af   := null;
           END;
           BEGIN
           select count(distinct scaglione) + 1      nr_sca_af
                 ,max(tabella_inps) tabella_af
             into D_nr_sca_af
                , D_tabella_af
             from condizioni_familiari          cofa
                , assegni_familiari             asfa
                , aggiuntivi_familiari          agfa
                , informazioni_extracontabili   inex
            where inex.anno       = CURS_CI.anno
              and inex.ci         = CURS_CI.ci
              and cofa.codice     = D_cond_af
              and agfa.codice     = D_cond_af
              and agfa.dal        = asfa.dal
              and asfa.tabella    = cofa.tabella
              and nvl(CURS_CI.data_cess,to_date('3112'||
                                        to_char(CURS_CI.anno),'ddmmyyyy'))
                                        between asfa.dal
                                         and nvl(asfa.al,to_date('3333333','j'))
              and nvl(agfa.aggiuntivo,0) +
                  nvl(asfa.scaglione,0) <=
                     decode( least(to_char(CURS_CI.data_cess,'mm')
                                  ,6)
                           , 6, nvl(inex.ipn_fam_2ap,0)
                              , nvl(inex.ipn_fam_1ap,0))
              and exists (select 'x' from movimenti_contabili
                           where anno = CURS_CI.anno
                             and ci   = CURS_CI.ci
                             and (voce,sub) in
                                (select voce,sub
                                   from estrazione_righe_contabili
                                  where estrazione = 'DENUNCIA_O1_INPS'
                                    and colonna    = 'IMPORTO_AF'))
              and D_af  = 'x'
            group by inex.ci
           ;
           EXCEPTION WHEN NO_DATA_FOUND THEN D_nr_sca_af := null;
                                             D_tabella_af := null;
           END;
        ELSE
          D_nr_sca_af  := null;
          D_tabella_af := null;
        END IF;
     END IF;
 select max(decode( substr(vaca.colonna,3,1)
                  , '1', substr(vaca.colonna,5,2)
                       , null))                  tipo_1
      , max(decode( substr(vaca.colonna,3,1)
                  , '1', greatest( pegi.dal
                                 , to_date('01'||to_char(CURS_CI.anno),'mmyyyy')
                                 )
                       , null))                  dal_1
      , max(decode( substr(vaca.colonna,3,1)
                  , '1', nvl(pegi.al,to_date( '3112'||to_char(CURS_CI.anno)
                                            , 'ddmmyyyy'))
                       , null))                  al_1
      , round( sum( vaca.valore
                 *decode( substr(vaca.colonna,3,1)||
                          substr(vaca.colonna,9,1)
                         , '11', 1 
                               , 0))
                / max(nvl(esvc.arrotonda,0.01))
              ) * max(nvl(esvc.arrotonda,0.01))                       retr_1
      , round( sum( vaca.valore
                   * decode( substr(vaca.colonna,3,1)||
                             substr(vaca.colonna,9,1)
                           , '12', 1
                                 , 0))
                   / nvl(max(decode( substr(vaca.colonna,3,1)||
                                 substr(vaca.colonna,9,1)
                                , '12', nvl(esvc.arrotonda,0.01) 
                                      , '' )),1)
               )  * nvl(max(decode( substr(vaca.colonna,3,1)||
                                substr(vaca.colonna,9,1)
                              , '12', nvl(esvc.arrotonda,0.01)
                                    , '' )),1)                       pens_1
      , max(decode( substr(vaca.colonna,3,1)
                  , '2', substr(vaca.colonna,5,2)
                       , null))                  tipo_2
      , max(decode( substr(vaca.colonna,3,1)
                  , '2', greatest( pegi.dal
                                 , to_date('01'||to_char(CURS_CI.anno),'mmyyyy')
                                 )
                       , null))                  dal_2
      , max(decode( substr(vaca.colonna,3,1)
                  , '2', nvl(pegi.al,to_date( '3112'||to_char(CURS_CI.anno)
                                            , 'ddmmyyyy'))
                       , null))                  al_2
      , round ( sum( vaca.valore
                   *decode( substr(vaca.colonna,3,1)||
                            substr(vaca.colonna,9,1)
                          , '21', 1
                               , 0))
                / max(nvl(esvc.arrotonda,0.01))
              ) * max(nvl(esvc.arrotonda,0.01))                       retr_2
      , round ( sum( vaca.valore
                   * decode( substr(vaca.colonna,3,1)||
                             substr(vaca.colonna,9,1)
                            , '22', 1
                                  , 0 ))
                   / nvl(max(decode( substr(vaca.colonna,3,1)||
                                 substr(vaca.colonna,9,1)
                                , '22', nvl(esvc.arrotonda,0.01) 
                                      , '' )),1)
               )  * nvl(max(decode( substr(vaca.colonna,3,1)||
                                substr(vaca.colonna,9,1)
                              , '22', nvl(esvc.arrotonda,0.01)
                                    , '' )),1)                       pens_2
      , max(decode( substr(vaca.colonna,3,1)
                  , '3', substr(vaca.colonna,5,2)
                       , null))                  tipo_3
      , max(decode( substr(vaca.colonna,3,1)
                  , '3', greatest( pegi.dal
                                 , to_date('01'||to_char(CURS_CI.anno),'mmyyyy')
                                 )
                       , null))                  dal_3
      , max(decode( substr(vaca.colonna,3,1)
                  , '3', nvl(pegi.al,to_date( '3112'||to_char(CURS_CI.anno)
                                            , 'ddmmyyyy'))
                       , null))                  al_3
      , round ( sum( vaca.valore
                   *decode( substr(vaca.colonna,3,1)||
                            substr(vaca.colonna,9,1)
                          , '31', 1
                               , 0))
                / max(nvl(esvc.arrotonda,0.01))
              ) * max(nvl(esvc.arrotonda,0.01))                       retr_3
      , round ( sum( vaca.valore
                   * decode( substr(vaca.colonna,3,1)||
                             substr(vaca.colonna,9,1)
                            , '32', 1
                                  , 0))
                   / nvl(max(decode( substr(vaca.colonna,3,1)||
                                 substr(vaca.colonna,9,1)
                                , '32', nvl(esvc.arrotonda,0.01) 
                                      , '' )),1)
               )  * nvl(max(decode( substr(vaca.colonna,3,1)||
                                substr(vaca.colonna,9,1)
                              , '32', nvl(esvc.arrotonda,0.01)
                                    , '' )),1)                       pens_3
      , max(decode( substr(vaca.colonna,3,1)
                  , '4', substr(vaca.colonna,5,2)
                       , null))                  tipo_4
      , max(decode( substr(vaca.colonna,3,1)
                  , '4', greatest( pegi.dal
                                 , to_date('01'||to_char(CURS_CI.anno),'mmyyyy')
                                 )
                       , null))                  dal_4
      , max(decode( substr(vaca.colonna,3,1)
                  , '4', nvl(pegi.al,to_date( '3112'||to_char(CURS_CI.anno)
                                            , 'ddmmyyyy'))
                       , null))                  al_4
      , round ( sum( vaca.valore
                   *decode( substr(vaca.colonna,3,1)||
                            substr(vaca.colonna,9,1)
                          , '41', 1
                               , 0))
                / max(nvl(esvc.arrotonda,0.01))
              ) * max(nvl(esvc.arrotonda,0.01))                       retr_4
      , round( sum( vaca.valore
                   * decode( substr(vaca.colonna,3,1)||
                             substr(vaca.colonna,9,1)
                            , '42', 1
                                  , 0))
                   / nvl(max(decode( substr(vaca.colonna,3,1)||
                                 substr(vaca.colonna,9,1)
                                , '42', nvl(esvc.arrotonda,0.01) 
                                      , '' )),1)
               )  * nvl(max(decode( substr(vaca.colonna,3,1)||
                                substr(vaca.colonna,9,1)
                              , '42', nvl(esvc.arrotonda,0.01)
                                    , '' )),1)                       pens_4
  into D_tipo_c1
     , D_dal_c1
     , D_al_c1
     , D_importo_c1
     , D_importo_pen_c1
     , D_tipo_c2
     , D_dal_c2
     , D_al_c2
     , D_importo_c2
     , D_importo_pen_c2
     , D_tipo_c3
     , D_dal_c3
     , D_al_c3
     , D_importo_c3
     , D_importo_pen_c3
     , D_tipo_c4
     , D_dal_c4
     , D_al_c4
     , D_importo_c4
     , D_importo_pen_c4
   from periodi_giuridici        pegi
      , valori_contabili_annuali vaca
      , estrazione_valori_contabili esvc
  where vaca.estrazione = 'DENUNCIA_O1_INPS'
    and vaca.colonna  like 'QC%'
    and vaca.anno       = CURS_CI.anno
    and vaca.mese       = 12
    and vaca.mensilita  = (select max(mensilita) from mensilita
                            where mese = 12
                              and tipo in ('S','N','A'))
    and vaca.ci         = CURS_CI.ci
    and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                , least( to_date('01'||to_char(CURS_CI.anno),'mmyyyy')
                       , nvl(CURS_CI.al,to_date('3333333','j'))
                       )
                ) between CURS_CI.dal
                      and nvl(CURS_CI.al,to_date('3333333','j'))
    and nvl(vaca.valore,0) != 0
    and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                , least( to_date('01'||to_char(CURS_CI.anno),'mmyyyy')
                       , nvl(CURS_CI.al,to_date('3333333','j'))
                       )
                ) between esvc.dal
                      and nvl(esvc.al,to_date('3333333','j'))
    and esvc.estrazione     = vaca.estrazione
    and esvc.colonna        = vaca.colonna
    and pegi.ci         = vaca.ci
    and pegi.rilevanza  = substr(vaca.colonna,8,1)
    and pegi.dal       <= to_date('3112'||to_char(CURS_CI.anno),'ddmmyyyy')
 ;
select least( 52
            , sum(decode( instr(vaca.colonna,'SETT')
                        , 0, 0
                           , vaca.valore ))
            )                                    settimane
     , round( sum(decode( vaca.colonna
                        , 'QD_IMPORTO_RID', vaca.valore
                                          , 0))
            / nvl(max(decode( vaca.colonna
                        , 'QD_IMPORTO_RID', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
            )
            * nvl(max(decode( vaca.colonna
                        , 'QD_IMPORTO_RID', nvl(esvc.arrotonda,0.01)
                                          , '')),1)         importo_rid
     , round( sum(decode( vaca.colonna
                        , 'QD_IMPORTO_CIG', vaca.valore
                                          , 0))
            / nvl(max(decode( vaca.colonna
                        , 'QD_IMPORTO_CIG', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
            )
            * nvl(max(decode( vaca.colonna
                        , 'QD_IMPORTO_CIG', nvl(esvc.arrotonda,0.01)
                                          , '')),1)         importo_cig
     , least( 52
            , sum(decode( vaca.colonna
                        , 'QD_SETT1_MAL', vaca.valore
                                        , 0))
           )                                    sett1_mal
      , least( 52
            , sum(decode( vaca.colonna
                        , 'QD_SETT2_MAL', vaca.valore
                                        , 0))
            )                                    sett2_mal
     , least( 52
            , sum(decode( vaca.colonna
                       , 'QD_SETT1_MAT', vaca.valore
                                        , 0))
            )                                    sett1_mat
     , least( 52
            , sum(decode( vaca.colonna
                        , 'QD_SETT2_MAT', vaca.valore
                                       , 0))
            )                                    sett2_mat
     , least( 52
            , sum(decode( vaca.colonna
                        , 'QD_SETT1_M88', vaca.valore
                                        , 0))
            )                                    sett1_m88
     , least( 52
            , sum(decode( vaca.colonna
                        , 'QD_SETT2_M88', vaca.valore
                                        , 0))
            )                                    sett2_m88
     , least( 52
            , sum(decode( vaca.colonna
                        , 'QD_SETT1_M53', vaca.valore
                                        , 0))
            )                                    sett1_m53
     , least( 52
            , sum(decode( vaca.colonna
                        , 'QD_SETT2_M53', vaca.valore
                                        , 0))
            )                                    sett2_m53
    , least( 52
            , sum(decode( vaca.colonna
                        , 'QD_SETT1_CIG', vaca.valore
                                        , 0))
            )                                    sett1_cig
     , least( 52
            , sum(decode( vaca.colonna
                       , 'QD_SETT2_CIG', vaca.valore
                                        , 0))
            )                                    sett2_cig
     , least( 52
            , sum(decode( vaca.colonna
                        , 'QD_SETT2_DDS', vaca.valore
                                        , 0))
            )                                    sett2_dds
  into D_sett_d
     , D_importo_rid_d
     , D_importo_cig_d
     , D_sett1_mal_d
     , D_sett2_mal_d
     , D_sett1_mat_d
     , D_sett2_mat_d
     , D_sett1_m88_d
     , D_sett2_m88_d
     , D_sett1_m53_d
     , D_sett2_m53_d
     , D_sett1_cig_d
     , D_sett2_cig_d
     , D_sett2_dds_d
  from valori_contabili_annuali    vaca
     , estrazione_valori_contabili esvc
 where vaca.estrazione = 'DENUNCIA_O1_INPS'
   and vaca.colonna  like 'QD%'
   and vaca.anno       = CURS_CI.anno
   and vaca.mese       = 12
   and vaca.mensilita  = (select max(mensilita) from mensilita
                           where mese = 12
                             and tipo in ('S','A','N'))
   and vaca.ci         = CURS_CI.ci
   and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
               , least( to_date('01'||to_char(CURS_CI.anno),'mmyyyy')
                      , nvl(CURS_CI.al,to_date('3333333','j'))
                      )
               ) between CURS_CI.dal
                     and nvl(CURS_CI.al,to_date('3333333','j'))
   and nvl(vaca.valore,0) != 0
   and esvc.estrazione     = vaca.estrazione
   and esvc.colonna        = vaca.colonna
 ;
update denuncia_o1_inps x
   set x.importo_cc     = D_importo_cc
     , x.importo_ac     = D_importo_ac
     , x.nucleo_af      = D_nucleo_af
     , x.classe_af      = D_nr_sca_af
     , x.tabella_af     = D_tabella_af
     , x.importo_af     = null
     , x.tipo_c1        = D_tipo_c1
     , x.dal_c1         = D_dal_c1
     , x.al_c1          = D_al_c1
     , x.importo_c1     = D_importo_c1
     , x.importo_pen_c1 = D_importo_pen_c1
     , x.tipo_c2        = D_tipo_c2
     , x.dal_c2         = D_dal_c2
     , x.al_c2          = D_al_c2
     , x.importo_c2     = D_importo_c2
     , x.importo_pen_c2 = D_importo_pen_c2
     , x.tipo_c3        = D_tipo_c3
     , x.dal_c3         = D_dal_c3
     , x.al_c3          = D_al_c3
     , x.importo_c3     = D_importo_c3
     , x.importo_pen_c3 = D_importo_pen_c3
     , x.tipo_c4        = D_tipo_c4
     , x.dal_c4         = D_dal_c4
     , x.al_c4          = D_al_c4
     , x.importo_c4     = D_importo_c4
     , x.importo_pen_c4 = D_importo_pen_c4
     , x.sett_d         = D_sett_d
     , x.importo_rid_d  = D_importo_rid_d
     , x.importo_cig_d  = D_importo_cig_d
     , x.sett1_mal_d    = D_sett1_mal_d
     , x.sett2_mal_d    = D_sett2_mal_d
     , x.sett1_mat_d    = D_sett1_mat_d
     , x.sett2_mat_d    = D_sett2_mat_d
     , x.sett1_m88_d    = D_sett1_m88_d
     , x.sett2_m88_d    = D_sett2_m88_d
     , x.sett1_m53_d    = D_sett1_m53_d
     , x.sett2_m53_d    = D_sett2_m53_d
     , x.sett1_cig_d    = D_sett1_cig_d
     , x.sett2_cig_d    = D_sett2_cig_d
     , x.sett2_dds_d    = D_sett2_dds_d
     , x.utente         = ''
 where rowid  = CURS_CI.rowid
   and istituto = 'INPS'
   and not exists
          (select 'x' from denuncia_o1_inps
            where anno = CURS_CI.anno
              and istituto = x.istituto
              and ci   = CURS_CI.ci
              and dal  = CURS_CI.dal
              and al   = CURS_CI.al
              and nvl(giorni,0) != 0
              and rowid         != CURS_CI.rowid)
;
update denuncia_o1_inps x 
   set data_cessazione = 
    (select max(nvl(data_cessazione,to_date('2222222','j')))
       from denuncia_o1_inps
      where ci = x.ci
        and anno = x.anno)
      where anno = P_anno
        and ci in (select ci from rapporti_individuali where ci = CURS_CI.ci)
        and exists (select 'x' from denuncia_o1_inps
                     where anno = x.anno
                       and ci = x.ci
                       and data_cessazione is not null
                       and rowid != x.rowid)
;
update denuncia_o1_inps
   set importo_ac = nvl(importo_cc,0)+nvl(importo_ac,0)
      ,importo_cc = 0
 where anno = P_anno
   and importo_cc != 0
   and nvl(giorni,0) = 0
   and ci in (select ci from rapporti_individuali where ci = CURS_CI.ci)
;
commit;
END;
END LOOP; --CURS_CI
END;
BEGIN -- cancellazione record nulli
delete from denuncia_o1_inps
 where anno = P_anno
   and istituto = 'INPS'
   and nvl(importo_cc,0)+nvl(importo_ac,0) = 0
   and nvl(settimane,0) +nvl(giorni,0)     = 0
   and nvl(utente,'X')                     = 'X'
   and tipo_agg                           is null;
END;
 IF P_tfr_privati = 'X' THEN
    BEGIN -- assestamento dati privati ex upd_tfr_privati
       update denuncia_o1_inps d1is
          set importo_ap = ( select  round(  ( sum(nvl(prfi.fdo_tfr_ap,0))
                                             + sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0)))
                                           + sum(nvl(prfi.fdo_tfr_2000,0)) 
                                           - sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0)) 
                                           - e_round(sum(distinct nvl(prfi.riv_tfr_ap,0)) * .11,'I') 
                                           + sum(nvl(prfi.qta_tfr_ac,0)) 
                                           - sum(nvl(prfi.rit_tfr,0)) 
                                           + sum(nvl(prfi.riv_tfr,0)) 
                                           + sum(nvl(prfi.riv_tfr_ap,0)) 
                                           - e_round(sum(nvl(prfi.riv_tfr,0)) * 11/100,'I')
                                           - least (    ( sum(nvl(prfi.fdo_tfr_ap,0)) 
                                                         + sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0)))
                                                      + sum(nvl(prfi.fdo_tfr_2000,0))
                                                      - least( ( sum(nvl(prfi.fdo_tfr_ap,0)) 
                                                                + sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0)))
                                                      + sum(nvl(prfi.fdo_tfr_2000,0))
                                                      , sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0))
                                                              )
                                                    ,   greatest( sum(nvl(prfi.fdo_tfr_ap_liq,0)) 
                                                        + sum(nvl(prfi.fdo_tfr_2000_liq,0))
                                                        - decode(  (sum(nvl(prfi.lor_acc_2000,0)) + sum(nvl(prfi.lor_acc,0)))
                                                                 , 0 ,sum(distinct nvl(fondi_tfr_ac(prfi.ci,P_anno,12),0)) 
                                                                     , 0 )
                                                                 , 0
                                                                 )
                                                    )    
                                            -  sum(nvl(riv_tfr_ap_liq,0))  
                                            -  sum(nvl(prfi.riv_tfr_liq,0))
                                            -  sum(nvl(prfi.qta_tfr_ac_liq,0))
                                            )
                            	from progressivi_fiscali   prfi
                             where prfi.anno       = d1is.anno
                               and d1is.anno       = P_anno
                               and prfi.mese       = 12
                               and prfi.mensilita  =   (select max(mensilita) from mensilita
                                                         where mese  = 12 
                                                           and tipo in ('S','N','A')
                                                        )
                               and prfi.ci         = d1is.ci)
       where anno = P_anno
         and dal = ( select max(dal) 
                       from denuncia_o1_inps
                      where anno = d1is.anno
                        and ci = d1is.ci
                   )
      ;
       update denuncia_o1_inps d1is
          set importo_ap = null
        where trunc(nvl(importo_ap,0 ))
                                 = ( select trunc(sum(nvl(lor_liq,0)))
                                       from progressivi_fiscali   prfi
                                      where prfi.anno       = d1is.anno
                                        and d1is.anno       = P_anno
                                        and prfi.mese       = 12
                                        and prfi.mensilita  =   ( select max(mensilita) from mensilita
                                                                   where mese  = 12 
                                                                     and tipo in ('S','N','A')
                                                                 )
                                        and prfi.ci         = d1is.ci)
          and anno = P_anno
      ;
    END;
 END IF;
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
