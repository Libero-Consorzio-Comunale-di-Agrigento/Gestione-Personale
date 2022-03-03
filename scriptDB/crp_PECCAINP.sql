CREATE OR REPLACE PACKAGE peccainp IS

/******************************************************************************
 NOME:          PECCAINP  CARICAMENTO ARCHIVIO O1M I.N.P.S.   
 
 DESCRIZIONE:   
      Questa funzione inserisce nella tavola DENUNCIA_INPDAI le registrazioni 
      relative ad ogni individuo che ha prestato servizio nell'anno richiesto,
      per consentire ad una funzione successiva di fornire un tabulato che
      permetta la compilazione dei modelli O1/M INPS.      

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  
      Creazione delle registrazioni annuali individuali per la fase di stampa
      della denuncia annuale O1/M INPS. 

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003         
 2.0  08/02/2005 MS     Modifiche per att. 7307
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

 PROCEDURE MAIN     (prenotazione in number, passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY peccainp IS
 
    FUNCTION VERSIONE  RETURN VARCHAR2 IS
    BEGIN
    RETURN 'V2.0 del 08/02/2005';
    END VERSIONE;
 
 PROCEDURE MAIN     (prenotazione in number, passo in number) IS

BEGIN

declare

P_ente       varchar2(4);
P_ambiente   varchar2(8);
P_utente     varchar2(8);
P_anno       varchar2(4);
P_gestione   varchar2(4);
P_tipo       varchar2(1);
P_incarico   varchar2(1);
P_dal        date;
P_al         date;
P_ruolo      varchar2(1);
P_gennaio    varchar2(1);
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
	  	P_ruolo := to_char(null);
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
      select to_char(anno)  D_anno
	    into P_anno
        from riferimento_fine_anno   
       where rifa_id = 'RIFA'
      ;

     lock table denuncia_o1_inps in exclusive mode nowait
     ;
     delete from denuncia_o1_inps d1is
      where d1is.anno             = to_number(P_anno)
        and d1is.gestione      like P_gestione
        and d1is.istituto         = 'INPDAI'
        and (        P_tipo = 'T'
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
        and (    nvl(P_ruolo,'%') = '%'
             or  exists (select 'x' from periodi_retributivi
                          where periodo
                               between to_date('01'||P_anno,'mmyyyy')
                                   and last_day(to_date('12'||P_anno,'mmyyyy'))
                            and competenza in ('P','C','A')
                            and servizio   in ('Q','I','N')
                            and gestione like nvl('','%')
                            and ci          = d1is.ci
                            and posizione  in
                               (select codice from posizioni
                                 where di_ruolo != 'R')
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
          , qualifica
          , tempo_pieno
          , tempo_determinato
          , assicurazioni
          , mesi
          , dal
          , al
          , data_cessazione
          , utente
          , tipo_agg
          , istituto
          )
     select to_number(P_anno)
          , pere.ci
          , substr(max(to_char(pere.al,'j')||pere.gestione),8,4)          gest
          , decode( to_char(qual.qua_inps)
                  , '9', 'Q'
                       , to_char(qual.qua_inps)
                  )                                               qual
          , decode( nvl(pere.ore,cost.ore_lavoro)
                  , cost.ore_lavoro,'SI'
                                   ,'NO')                         tempo_pieno
          , posi.tempo_determinato                                tempo_det
          , substr(reco_a.rv_low_value,1,1)                       ass
          , decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'01', pere.gg_inp
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'02', pere.gg_inp
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'03', pere.gg_inp
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'04', pere.gg_inp
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'05', pere.gg_inp
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'06', pere.gg_inp
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'07', pere.gg_inp
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'08', pere.gg_inp
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'09', pere.gg_inp
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'10', pere.gg_inp
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'11', pere.gg_inp
                                                         , 0))
                  , 0, ' ', 'X')||
            decode( sum(decode(to_char(pere.al,'yyyymm')
                              ,to_number(P_anno)||'12', pere.gg_inp
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
          , decode
            (to_char
             (decode
              ( least( nvl(max(pegi.al),to_date('3333333','j'))
                     , to_date('3112'||P_anno,'ddmmyyyy')+1
                     , max(pere.al)
                     )
              , to_date('3112'||P_anno,'ddmmyyyy')+1, to_date(null)
              , max(pegi.al)                       , max(pegi.al)
                                                   , to_date(null)
              )
             ,'yyyy')
            , P_anno, decode
                         ( least( nvl(max(pegi.al),to_date('3333333','j'))
                                , to_date('3112'||P_anno,'ddmmyyyy')+1
                                , max(pere.al)
                                )
                         , to_date('3112'||P_anno,'ddmmyyyy')+1, to_date(null)
                         , max(pegi.al)                       , max(pegi.al)
                                                              , to_date(null)
                         )
            )                                                     cess
          , 'Y'                                                   utente
          , decode(P_tipo,'C','I',null)                        tipo_agg
          , 'INPDAI'                                              istituto
       from riferimento_retribuzione    rire
          , gestioni                    gest
          , posizioni                   posi
          , qualifiche                  qual
          , trattamenti_previdenziali   trpr
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
        and (   nvl(P_ruolo,' ') != 'X'
             or posi.di_ruolo != 'R')
        and trpr.codice    (+) = pere.trattamento
        and qual.numero    (+) = pere.qualifica
        and cost.contratto (+) = pere.contratto
        and pere.periodo between cost.dal
                             and nvl(cost.al,to_date('3333333','j'))
        and reco_a.rv_domain (+) = 'DENUNCIA_O1_INPS.ASSICURAZIONI'
        and instr(reco_a.rv_abbreviation,lpad(trpr.contribuzione,2,0)) != 0
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
        and (   P_tipo != 'C'
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
                    where estrazione = 'DENUNCIA_INPDAI'
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
                          and istituto = 'INPDAI'
                          and ci       = pere.ci
                          and gestione = pere.gestione)
      group by pere.ci,qual.qua_inps
             , decode( nvl(pere.ore,cost.ore_lavoro)
                     , cost.ore_lavoro,'SI'
                                      ,'NO')
             , posi.tempo_determinato
             , substr(reco_a.rv_low_value,1,1)
     ;
     commit;

    update denuncia_o1_inps x
       set al = (select min(dal) -1
                   from denuncia_o1_inps
                  where anno   = x.anno
                    and ci     = x.ci
                    and al     > x.al
                    and dal   != x.dal
                    and dal   <= x.al
                    and dal    between x.dal
                                   and nvl(x.al,to_date('3333333','j'))
                )
     where anno     = P_anno
       and istituto = 'INPDAI'
       and exists
          (select 'x'
             from denuncia_o1_inps
            where anno     = x.anno
              and istituto = x.istituto
              and ci       = x.ci
              and al       > x.al
              and dal     != x.dal
              and dal     <= x.al
              and dal      between x.dal
                               and nvl(x.al,to_date('3333333','j'))
          )
    ;
    commit;

     lock table denuncia_o1_inps in exclusive mode nowait
     ;
     update denuncia_o1_inps d1is set d1is.trasf_rapporto = 'SI'
      where d1is.anno        = to_number(P_anno)
        and d1is.istituto    = 'INPDAI'
        and d1is.gestione like P_gestione
        and 2               <= (select count(*) from denuncia_o1_inps
                                 where anno     = d1is.anno
                                   and istituto = d1is.istituto
                                   and ci       = d1is.ci
                               )
        and exists             (select 'x' from denuncia_o1_inps
                                 where anno     = d1is.anno
                                   and istituto = d1is.istituto
                                   and ci       = d1is.ci
                                   and qualifica in ('Y','O','D')
                               )
        and d1is.utente      = 'Y'
     ;
     commit;

     lock table denuncia_o1_inps in exclusive mode nowait
     ;
     update denuncia_o1_inps d1is
        set importo_ap =
           (select  nvl(sum(prfi.fdo_tfr_ap),0)
                   +nvl(sum(prfi.riv_tfr),0)
                   +nvl(sum(prfi.qta_tfr_ac),0)
                   -nvl(sum(prfi.rit_tfr),0)
              from progressivi_fiscali      prfi
             where prfi.anno       = d1is.anno
               and prfi.mese       = 12
               and prfi.mensilita  =
                  (select max(mensilita) from mensilita
                    where mese  = 12
                      and tipo in ('S','N','A'))
               and prfi.ci         = d1is.ci)
      where d1is.anno        = to_number(P_anno)
        and d1is.istituto    = 'INPDAI'
        and d1is.gestione like P_gestione
        and d1is.dal         =
           (select max(dal) from denuncia_o1_inps
             where anno      = d1is.anno
               and istituto  = d1is.istituto
               and gestione  = d1is.gestione
               and ci        = d1is.ci)
        and d1is.utente     = 'Y'
     ;
     commit;
     update denuncia_o1_inps d1is
        set importo_ap =
           (select decode( valuta
		                 , 'L', round( ( d1is.importo_ap
                                        -nvl(sum(prfi.fdo_tfr_ap_liq),0)
                                        -nvl(sum(prfi.riv_tfr_liq),0)
                                        -nvl(sum(prfi.qta_tfr_ac_liq),0)
                                       )
                                      / 1000
                                     ) * 1000
                              , round( ( d1is.importo_ap
                                        -nvl(sum(prfi.fdo_tfr_ap_liq),0)
                                        -nvl(sum(prfi.riv_tfr_liq),0)
                                        -nvl(sum(prfi.qta_tfr_ac_liq),0)
                                       ))
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
        and d1is.istituto    = 'INPDAI'
        and d1is.gestione like P_gestione
        and d1is.dal         =
           (select max(dal) from denuncia_o1_inps
             where anno      = d1is.anno
               and istituto  = d1is.istituto
               and gestione  = d1is.gestione
               and ci        = d1is.ci)
        and d1is.utente     = 'Y'
     ;
--      and (   d1is.qualifica != '3'
--           or d1is.qualifica  = '3' and
--              d1is.contratto in ('042','043','044','045','046')
--          )
     commit;
DECLARE
 D_importo_cc       number;
 D_importo_ac       number;
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

 BEGIN
     FOR CURS_CI IN
        (select rowid,anno,ci,dal,al,mesi,data_cessazione data_cess
           from denuncia_o1_inps
          where anno     = to_number(P_anno)
            and istituto = 'INPDAI'
            and utente   = 'Y'
        ) LOOP
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
     where vaca.estrazione      = 'DENUNCIA_INPDAI'
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
              and istituto = 'INPDAI'
              and ci   = CURS_CI.ci
              and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                          , least( to_date('01'||to_char(anno),'mmyyyy')
                                 , nvl(al,to_date('3333333','j'))
                                 )
                          ) between dal
                                and nvl(al,to_date('3333333','j'))
              and dal >= CURS_CI.dal
              and al  <= CURS_CI.al
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
                                          , '')),1),0)
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
                                          , '')),1),0)
        into D_importo_cc,D_importo_ac
        from valori_contabili_annuali    vaca
           , estrazione_valori_contabili esvc
       where vaca.estrazione      = 'DENUNCIA_INPDAI'
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
                and istituto = 'INPDAI'
                and ci   = CURS_CI.ci
                and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                            , least( to_date('01'||to_char(anno),'mmyyyy')
                                   , nvl(al,to_date('3333333','j'))
                                   )
                            ) between dal
                                  and nvl(al,to_date('3333333','j'))
                and dal >= CURS_CI.dal
                and al  <= CURS_CI.al
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
                                          , '')),1),0)
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
                                          , '')),1),0)
        into D_importo_cc,D_importo_ac
        from valori_contabili_annuali    vaca
           , estrazione_valori_contabili esvc
       where vaca.estrazione      = 'DENUNCIA_INPDAI'
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
                and istituto = 'INPDAI'
                and ci   = CURS_CI.ci
                and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                            , least( to_date('01'||to_char(anno),'mmyyyy')
                                   , nvl(al,to_date('3333333','j'))
                                   )
                            ) between dal
                                  and nvl(al,to_date('3333333','j'))
                and dal >= CURS_CI.dal
                and al  <= CURS_CI.al
                and rowid         != CURS_CI.rowid)
       ;
     END;
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
      , sum( vaca.valore
            *decode( substr(vaca.colonna,3,1)||
                     substr(vaca.colonna,9,1)
                   , '11', 1
                        , 0)
           )                                     retr_1
      , sum( vaca.valore
            *decode( substr(vaca.colonna,3,1)||
                     substr(vaca.colonna,9,1)
                   , '12', 1
                        , 0)
           )                                     pens_1
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
      , sum( vaca.valore
            *decode( substr(vaca.colonna,3,1)||
                     substr(vaca.colonna,9,1)
                   , '21', 1
                        , 0)
           )                                     retr_2
      , sum( vaca.valore
            *decode( substr(vaca.colonna,3,1)||
                     substr(vaca.colonna,9,1)
                   , '22', 1
                        , 0)
           )                                     pens_2
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
      , sum( vaca.valore
            *decode( substr(vaca.colonna,3,1)||
                     substr(vaca.colonna,9,1)
                   , '31', 1
                        , 0)
           )                                     retr_3
      , sum( vaca.valore
            *decode( substr(vaca.colonna,3,1)||
                     substr(vaca.colonna,9,1)
                   , '32', 1
                        , 0)
           )                                     pens_3
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
      , sum( vaca.valore
            *decode( substr(vaca.colonna,3,1)||
                     substr(vaca.colonna,9,1)
                   , '41', 1
                        , 0)
           )                                     retr_4
      , sum( vaca.valore
            *decode( substr(vaca.colonna,3,1)||
                     substr(vaca.colonna,9,1)
                   , '42', 1
                        , 0)
           )                                     pens_4
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
   from astensioni               aste
      , periodi_giuridici        pegi_a
      , periodi_giuridici        pegi
      , valori_contabili_annuali vaca
  where vaca.estrazione = 'DENUNCIA_INPDAI'
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
    and pegi.ci         = vaca.ci
    and pegi.rilevanza  = substr(vaca.colonna,8,1)
    and pegi.dal       <= to_date('3112'||to_char(CURS_CI.anno),'ddmmyyyy')
    and pegi_a.ci (+)   = CURS_CI.ci
    and pegi_a.rilevanza (+) = 'A'
    and pegi_a.dal  (+)  <= to_date('3112'||to_char(CURS_CI.anno),'ddmmyyyy')
    and aste.codice (+)   = pegi_a.assenza
    and aste.per_ret (+)  = 0
 ;
update denuncia_o1_inps x
   set x.importo_cc     = D_importo_cc
     , x.importo_ac     = D_importo_ac
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
     , x.utente         = ''
 where rowid  = CURS_CI.rowid
   and not exists
          (select 'x' from denuncia_o1_inps
            where anno = CURS_CI.anno
              and istituto = 'INPDAI'
              and ci   = CURS_CI.ci
              and dal  = CURS_CI.dal
              and al   = CURS_CI.al
              and rowid         != CURS_CI.rowid)
;
commit;
END;
END LOOP;
END;
end;
end;
end;
/

