CREATE OR REPLACE PACKAGE PPOCCSPO2 IS

/******************************************************************************
 NOME:          PPOCCSPO2
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000             
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE CC_NOMINATIVO(P_PRENOTAZIONE IN NUMBER, P_VOCE_MENU IN VARCHAR2);
PROCEDURE RAGGR_POSTI(P_PRENOTAZIONE IN NUMBER, P_VOCE_MENU IN VARCHAR2);
END;
/
CREATE OR REPLACE PACKAGE BODY PPOCCSPO2 IS
FORM_TRIGGER_FAILURE EXCEPTION;
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
PROCEDURE CALCOLO_ETA_ANZIANITA (
P_CI          IN     NUMBER,
P_MM_ETA      IN OUT NUMBER,
P_AA_ETA      IN OUT NUMBER,
P_GG_ANZ      IN OUT NUMBER,
P_MM_ANZ      IN OUT NUMBER,
P_AA_ANZ      IN OUT NUMBER
                                ) IS
d_cnpo_mm_eta    number(4);
d_cnpo_aa_eta    number(4);
d_gg_anz         number(4);
d_mm_anz         number(4);
d_aa_anz         number(4);
d_cnpo_gg_anz    number(4);
d_cnpo_mm_anz    number(4);
d_cnpo_aa_anz    number(4);
d_ci             number(8);
d_conta          number(6);
BEGIN
d_ci := P_CI;
select  sum((trunc((trunc(months_between(last_day(nvl(pegi.al
                                              ,rior.data
                                              ) + 1
                                          )
                                 ,last_day(pegi.dal)
                                 )
                  ) * 30
             - least(30,to_number(to_char(pegi.dal,'dd'
                                         )
                                  )
                    ) + 1
             + least(30,to_number(to_char(nvl(pegi.al
                                             ,rior.data
                                             ) + 1,'dd'
                                         )
                                 ) - 1
                    )
            ) / 360
           ))
      * to_number(decode(pegi.rilevanza,'Q',1,-1))
     )        --  Anni di Anzianita`
 ,sum((trunc((trunc(months_between(last_day(nvl(pegi.al
                                             ,rior.data
                                             ) + 1
                                         )
                                ,last_day(pegi.dal)
                                )
                 ) * 30
            - least(30,to_number(to_char(pegi.dal,'dd'
                                        )
                                )
                   ) + 1
            + least(30,to_number(to_char(nvl(pegi.al
                                            ,rior.data
                                            ) + 1,'dd'
                                        )
                                ) - 1
                   )
           - trunc((trunc(months_between(last_day(nvl(pegi.al
                                                 ,rior.data
                                                     ) + 1
                                                 )
                                        ,last_day(pegi.dal)
                                        )
                         ) * 30
                    - least(30,to_number(to_char(pegi.dal,'dd'
                                                )
                                        )
                           ) + 1
                    + least(30,to_number(to_char(nvl(pegi.al
                                                ,rior.data
                                                    ) + 1,'dd'
                                                )
                                        ) - 1
                           )
                   ) / 360
                  ) * 360
           ) / 30))
      * to_number(decode(pegi.rilevanza,'Q',1,-1))
     )   -- Mesi di Anzianita`
 ,sum((
 trunc(months_between( last_day(nvl(pegi.al,rior.data)+1)
                      ,last_day(pegi.dal)
                     )
      )*30
     -least( 30,to_number(to_char(pegi.dal,'dd'))
           )+1
     +least( 30,to_number(to_char( nvl(pegi.al,rior.data)+1
                                          ,'dd'))-1)   -
(trunc((trunc(months_between( last_day( nvl(pegi.al,rior.data)+1
                                      )
                             ,last_day(pegi.dal)
                            )
             )*30
       -least( 30,to_number(to_char(pegi.dal,'dd'))
             )+1
       +least( 30,to_number( to_char( nvl(pegi.al,rior.data)+1
                            ,'dd'))
             -1))  / 360
      )  *360 )                            -
  trunc(
 (trunc(months_between( last_day( nvl(pegi.al,rior.data)+1
                                      )
                             ,last_day(pegi.dal)
                            )
             )*30
       -least( 30,to_number(to_char(pegi.dal,'dd'))
             )+1
       +least( 30,to_number( to_char( nvl(pegi.al,rior.data)+1
                            ,'dd'))
             -1) -
 trunc((trunc(months_between( last_day( nvl(pegi.al,rior.data)+1
                                      )
                             ,last_day(pegi.dal)
                            )
             )*30
       -least( 30,to_number(to_char(pegi.dal,'dd'))
             )+1
       +least( 30,to_number( to_char( nvl(pegi.al,rior.data)+1
                            ,'dd'))
             -1))  / 360
      ) * 360) / 30) * 30)
      * to_number(decode(pegi.rilevanza,'Q',1,-1))
 )   -- Giorni di Anzianita`
 ,max(trunc(months_between(rior.data,anag.data_nas) / 12))
     -- Anni di Eta`
 ,max(trunc(months_between(rior.data,anag.data_nas))
     -trunc(months_between(rior.data,anag.data_nas) / 12)
     * 12)  -- Mesi di Eta`
,count(*)
  into  d_aa_anz
       ,d_mm_anz
       ,d_gg_anz
       ,d_cnpo_aa_eta
       ,d_cnpo_mm_eta
       ,d_conta
  from  rapporti_individuali               rain
       ,anagrafici                         anag
       ,periodi_giuridici                  pegi
       ,riferimento_organico               rior
 where  rain.ci                               = pegi.ci
   and  anag.ni                               = rain.ni
   and  rior.data               between anag.dal
                                      and nvl(anag.al,
                                             to_date('3333333','j'))
   and  (    pegi.rilevanza                  = 'Q'
   or  pegi.rilevanza                  = 'A'
   and exists
       (select 'x'
          from astensioni aste
         where aste.codice              = pegi.assenza
           and aste.servizio            = 0
       )
  )
   and  pegi.dal                            <= rior.data
   and  pegi.ci                         = d_ci
;
    d_cnpo_gg_anz := mod((d_gg_anz       +
                          d_mm_anz * 30  +
                          d_aa_anz * 360
                         ),30
                        );
    d_cnpo_mm_anz := trunc(mod((d_gg_anz       +
                                d_mm_anz * 30  +
                                d_aa_anz * 360
                               ),360
                              ) / 30
                          );
    d_cnpo_aa_anz := trunc((d_gg_anz       +
                            d_mm_anz * 30  +
                            d_aa_anz * 360
                           ) / 360
                          );
IF d_conta = 0 THEN           -- No data found
   d_cnpo_mm_eta := 0;
   d_cnpo_aa_eta := 0;
   d_cnpo_gg_anz := 0;
   d_cnpo_mm_anz := 0;
   d_cnpo_aa_anz := 0;
END IF;
P_MM_ETA := d_cnpo_mm_eta;
P_AA_ETA := d_cnpo_aa_eta;
P_GG_ANZ := d_cnpo_gg_anz;
P_MM_ANZ := d_cnpo_mm_anz;
P_AA_ANZ := d_cnpo_aa_anz;
END;
PROCEDURE CC_NOMINATIVO (P_PRENOTAZIONE IN NUMBER, P_VOCE_MENU IN VARCHAR2) IS
d_errtext                       VARCHAR2(240);
d_prenotazione                   number(6);
d_capo_prenotazione              number(6);
d_rilevanza                      number(2);
d_rior_data                        date;
d_popi_sede_posto               VARCHAR2(2);
d_popi_anno_posto                number(4);
d_popi_numero_posto              number(7);
d_popi_posto                     number(5);
d_popi_dal                         date;
d_popi_ricopribile              VARCHAR2(1);
d_popi_ore                       number(5,2);
d_popi_gruppo                   VARCHAR2(12);
d_popi_pianta                    number(6);
d_setp_sequenza                  number(6);
d_setp_codice                   VARCHAR2(15);
d_popi_settore                   number(6);
d_sett_sequenza                  number(6);
d_sett_codice                   VARCHAR2(15);
d_sett_suddivisione              number(1);
d_sett_settore_g                 number(6);
d_setg_sequenza                  number(6);
d_setg_codice                   VARCHAR2(15);
d_sett_settore_a                 number(6);
d_seta_sequenza                  number(6);
d_seta_codice                   VARCHAR2(15);
d_sett_settore_b                 number(6);
d_setb_sequenza                  number(6);
d_setb_codice                   VARCHAR2(15);
d_sett_settore_c                 number(6);
d_setc_sequenza                  number(6);
d_setc_codice                   VARCHAR2(15);
d_sett_gestione                 VARCHAR2(4);
d_gest_prospetto_po             VARCHAR2(1);
d_gest_sintetico_po             VARCHAR2(1);
d_popi_figura                    number(6);
d_figi_dal                         date;
d_figu_sequenza                  number(6);
d_figi_codice                   VARCHAR2(8);
d_figi_qualifica                 number(6);
d_qugi_dal                         date;
d_qual_sequenza                  number(6);
d_qugi_codice                   VARCHAR2(8);
d_qugi_contratto                VARCHAR2(4);
d_cost_dal                         date;
d_cont_sequenza                  number(3);
d_cost_ore_lavoro                number(5,2);
d_qugi_livello                  VARCHAR2(4);
d_figi_profilo                  VARCHAR2(4);
d_prpr_sequenza                  number(3);
d_prpr_suddivisione_po          VARCHAR2(1);
d_figi_posizione                VARCHAR2(4);
d_pofu_sequenza                  number(3);
d_qugi_ruolo                    VARCHAR2(4);
d_ruol_sequenza                  number(3);
d_popi_attivita                 VARCHAR2(4);
d_atti_sequenza                  number(6);
d_pegi_posizione                VARCHAR2(4);
d_posi_sequenza                  number(3);
d_posi_ruolo                    VARCHAR2(2);
d_pegi_tipo_rapporto            VARCHAR2(2);
d_pegi_ore                       number(5,2);
d_pegi_ci                        number(8);
d_pegi_sostituto                 number(8);
d_anag_gruppo_ling              VARCHAR2(4);
d_pegi_rilevanza                VARCHAR2(1);
d_pegi_assenza                  VARCHAR2(4);
d_pegi_dal                         date;
d_pegi_al                          date;
d_cnpo_mm_eta                    number(2);
d_cnpo_aa_eta                    number(2);
d_cnpo_gg_anz                    number(2);
d_cnpo_mm_anz                    number(2);
d_cnpo_aa_anz                    number(2);
d_popi_sede_posto_inc           VARCHAR2(2);
d_popi_anno_posto_inc            number(4);
d_popi_numero_posto_inc          number(7);
d_popi_posto_inc                 number(5);
cursor posti is
select
    capo_prenotazione,rior_data,
    popi_sede_posto,popi_anno_posto,popi_numero_posto,
    popi_posto,popi_dal,popi_ricopribile,capo_ore_previsti,
    popi_gruppo,popi_pianta,
    setp_sequenza,setp_codice,popi_settore,
    sett_sequenza,sett_codice,
    sett_suddivisione,sett_settore_g,
    setg_sequenza,setg_codice,
    sett_settore_a,seta_sequenza,
    seta_codice,sett_settore_b,
    setb_sequenza,setb_codice,
    sett_settore_c,setc_sequenza,
    setc_codice,sett_gestione,
    gest_prospetto_po,gest_sintetico_po,
    popi_figura,figi_dal,figu_sequenza,
    figi_codice,figi_qualifica,
    qugi_dal,qual_sequenza,
    qugi_codice,qugi_contratto,cost_dal,
    cont_sequenza,cost_ore_lavoro,
    qugi_livello,figi_profilo,
    prpr_sequenza,prpr_suddivisione_po,
    figi_posizione,pofu_sequenza,
    qugi_ruolo,ruol_sequenza,
    popi_attivita,atti_sequenza
  from calcolo_posti
 where capo_prenotazione = P_prenotazione
   and capo_rilevanza    = 1
;
cursor periodi is
select 1,pg.posizione,pg.tipo_rapporto,
       nvl(pg.ore,nvl(d_popi_ore,d_cost_ore_lavoro)),
       pg.ci,nvl(pg.sostituto,pg.ci),
       pg.rilevanza,pg.assenza,pg.dal,pg.al,
       nvl(po.sequenza,999),po.ruolo,an.gruppo_ling,
       pg.sede_posto,pg.anno_posto,pg.numero_posto,pg.posto
  from posizioni            p2
      ,posizioni            po
      ,anagrafici           an
      ,rapporti_individuali ri
      ,periodi_giuridici    pg
 where d_rior_data between pg.dal and nvl(pg.al,to_date('3333333','j'))
   and d_rior_data between an.dal and nvl(an.al,to_date('3333333','j'))
   and an.ni               = ri.ni
   and ri.ci               = pg.ci
   and pg.sede_posto       = d_popi_sede_posto
   and pg.anno_posto       = d_popi_anno_posto
   and pg.numero_posto     = d_popi_numero_posto
   and pg.posto            = d_popi_posto
   and pg.rilevanza       in ('Q','I')
   and po.codice           = p2.posizione
   and p2.codice           = po.posizione
 union
select 2,pg.posizione,pg.tipo_rapporto,pg.ore,
       pg.ci,nvl(pg.sostituto,pg.ci),
       pg.rilevanza,pg.assenza,pg.dal,pg.al,
       nvl(po.sequenza,999),po.ruolo,an.gruppo_ling,
       pg.sede_posto,pg.anno_posto,pg.numero_posto,pg.posto
  from posizioni            p2
      ,posizioni            po
      ,anagrafici           an
      ,rapporti_individuali ri
      ,periodi_giuridici    pg
 where d_rior_data between pg.dal and nvl(pg.al,to_date('3333333','j'))
   and d_rior_data between an.dal and nvl(an.al,to_date('3333333','j'))
   and an.ni               = ri.ni
   and ri.ci               = pg.ci
   and po.codice      (+)  = p2.posizione
   and p2.codice      (+)  = pg.posizione
   and (    pg.rilevanza   = 'I'
        or  pg.rilevanza   = 'A'
        and pg.assenza    in
            (select aa.codice
               from astensioni aa
              where aa.sostituibile = 1
            )
       )
   and exists
       (select 1
          from periodi_giuridici p2
         where d_rior_data between p2.dal
                               and nvl(p2.al,to_date('3333333','j'))
           and p2.rilevanza     in ('Q','I')
           and p2.rowid         <> pg.rowid
           and p2.ci             = pg.ci
           and p2.sede_posto     = d_popi_sede_posto
           and p2.anno_posto     = d_popi_anno_posto
           and p2.numero_posto   = d_popi_numero_posto
           and p2.posto          = d_popi_posto
       )
;
cursor vacanti is
select pp.dal,pp.al
  from posti_pianta pp
 where d_rior_data between pp.dal and nvl(pp.al,to_date('3333333','j'))
   and pp.sede_posto             = d_popi_sede_posto
   and pp.anno_posto             = d_popi_anno_posto
   and pp.numero_posto           = d_popi_numero_posto
   and pp.posto                  = d_popi_posto
   and (    pp.stato             = 'A'
        and pp.situazione        = 'R'
        or  pp.stato            in ('T','I','C')
       )
   and not exists
       (select 1
          from periodi_giuridici pg
         where d_rior_data between pg.dal
                               and nvl(pg.al,to_date('3333333','j'))
           and pg.rilevanza     in ('Q','I')
           and pg.sede_posto     = d_popi_sede_posto
           and pg.anno_posto     = d_popi_anno_posto
           and pg.numero_posto   = d_popi_numero_posto
           and pg.posto          = d_popi_posto
       )
;
BEGIN
  open posti;
  LOOP
    fetch posti into d_capo_prenotazione,
    d_rior_data,d_popi_sede_posto,d_popi_anno_posto,d_popi_numero_posto,
    d_popi_posto,d_popi_dal,d_popi_ricopribile,d_popi_ore,d_popi_gruppo,
    d_popi_pianta,d_setp_sequenza,
    d_setp_codice,d_popi_settore,d_sett_sequenza,d_sett_codice,
    d_sett_suddivisione,d_sett_settore_g,d_setg_sequenza,d_setg_codice,
    d_sett_settore_a,d_seta_sequenza,d_seta_codice,d_sett_settore_b,
    d_setb_sequenza,d_setb_codice,d_sett_settore_c,d_setc_sequenza,
    d_setc_codice,d_sett_gestione,d_gest_prospetto_po,
    d_gest_sintetico_po,d_popi_figura,d_figi_dal,
    d_figu_sequenza,d_figi_codice,d_figi_qualifica,d_qugi_dal,
    d_qual_sequenza,d_qugi_codice,d_qugi_contratto,d_cost_dal,
    d_cont_sequenza,d_cost_ore_lavoro,d_qugi_livello,d_figi_profilo,
    d_prpr_sequenza,d_prpr_suddivisione_po,d_figi_posizione,
    d_pofu_sequenza,d_qugi_ruolo,d_ruol_sequenza,d_popi_attivita,
    d_atti_sequenza;
    exit when posti%NOTFOUND;
    open periodi;
    LOOP
      fetch periodi into d_rilevanza,
      d_pegi_posizione,d_pegi_tipo_rapporto,d_pegi_ore,
      d_pegi_ci,d_pegi_sostituto,d_pegi_rilevanza,
      d_pegi_assenza,d_pegi_dal,d_pegi_al,
      d_posi_sequenza,d_posi_ruolo,d_anag_gruppo_ling,
      d_popi_sede_posto_inc,d_popi_anno_posto_inc,
      d_popi_numero_posto_inc,d_popi_posto_inc;
      exit when periodi%NOTFOUND;
      CALCOLO_ETA_ANZIANITA(d_pegi_ci,d_cnpo_mm_eta,d_cnpo_aa_eta,
                            d_cnpo_gg_anz,d_cnpo_mm_anz,d_cnpo_aa_anz
                           );
      if d_rilevanza = 1 or d_pegi_rilevanza = 'A' then
         d_popi_sede_posto_inc    := null;
         d_popi_anno_posto_inc    := null;
         d_popi_numero_posto_inc  := null;
         d_popi_posto_inc         := null;
      end if;
      insert into calcolo_nominativo_posti
      (cnpo_prenotazione,cnpo_rilevanza,rior_data,
       popi_sede_posto,popi_anno_posto,popi_numero_posto,popi_posto,
       popi_gruppo,popi_dal,popi_ricopribile,popi_pianta,
       setp_sequenza,setp_codice,popi_settore,sett_sequenza,
       sett_codice,sett_suddivisione,sett_settore_g,setg_sequenza,
       setg_codice,sett_settore_a,seta_sequenza,seta_codice,
       sett_settore_b,setb_sequenza,setb_codice,sett_settore_c,
       setc_sequenza,setc_codice,sett_gestione,gest_prospetto_po,
       gest_sintetico_po,popi_figura,figi_dal,figu_sequenza,
       figi_codice,figi_qualifica,qugi_dal,qual_sequenza,qugi_codice,
       qugi_contratto,cost_dal,cont_sequenza,cost_ore_lavoro,
       qugi_livello,figi_profilo,prpr_sequenza,prpr_suddivisione_po,
       figi_posizione,pofu_sequenza,qugi_ruolo,ruol_sequenza,
       popi_attivita,atti_sequenza,pegi_posizione,posi_sequenza,
       pegi_tipo_rapporto,pegi_ci,pegi_sostituto,pegi_rilevanza,pegi_ore,
       pegi_assenza,pegi_gruppo_ling,cnpo_mm_eta,cnpo_aa_eta,
       cnpo_gg_anz,cnpo_mm_anz,cnpo_aa_anz,cnpo_dal,cnpo_al,
       popi_sede_posto_inc,popi_anno_posto_inc,popi_numero_posto_inc,
       popi_posto_inc)
      values
      (d_capo_prenotazione,d_rilevanza,d_rior_data,
       d_popi_sede_posto,d_popi_anno_posto,
       d_popi_numero_posto,d_popi_posto,
       d_popi_gruppo,d_popi_dal,d_popi_ricopribile,d_popi_pianta,
       d_setp_sequenza,d_setp_codice,d_popi_settore,d_sett_sequenza,
       d_sett_codice,d_sett_suddivisione,
       d_sett_settore_g,d_setg_sequenza,
       d_setg_codice,d_sett_settore_a,d_seta_sequenza,d_seta_codice,
       d_sett_settore_b,d_setb_sequenza,d_setb_codice,d_sett_settore_c,
       d_setc_sequenza,d_setc_codice,d_sett_gestione,d_gest_prospetto_po,
       d_gest_sintetico_po,d_popi_figura,d_figi_dal,d_figu_sequenza,
       d_figi_codice,d_figi_qualifica,d_qugi_dal,
       d_qual_sequenza,d_qugi_codice,
       d_qugi_contratto,d_cost_dal,d_cont_sequenza,d_cost_ore_lavoro,
       d_qugi_livello,d_figi_profilo,
       d_prpr_sequenza,d_prpr_suddivisione_po,
       d_figi_posizione,d_pofu_sequenza,d_qugi_ruolo,d_ruol_sequenza,
       d_popi_attivita,d_atti_sequenza,d_pegi_posizione,d_posi_sequenza,
       d_pegi_tipo_rapporto,d_pegi_ci,d_pegi_sostituto,d_pegi_rilevanza,
       d_pegi_ore,
       d_pegi_assenza,d_anag_gruppo_ling,d_cnpo_mm_eta,d_cnpo_aa_eta,
       d_cnpo_gg_anz,d_cnpo_mm_anz,d_cnpo_aa_anz,d_pegi_dal,d_pegi_al,
       d_popi_sede_posto_inc,d_popi_anno_posto_inc,
       d_popi_numero_posto_inc,d_popi_posto_inc)
      ;
    END LOOP;
    close periodi;
    open vacanti;
    LOOP
      fetch vacanti into
      d_pegi_dal,d_pegi_al;
      exit when vacanti%NOTFOUND;
      insert into calcolo_nominativo_posti
      (cnpo_prenotazione,cnpo_rilevanza,rior_data,
       popi_sede_posto,popi_anno_posto,popi_numero_posto,popi_posto,
       popi_gruppo,popi_dal,popi_ricopribile,popi_pianta,
       setp_sequenza,setp_codice,popi_settore,sett_sequenza,
       sett_codice,sett_suddivisione,sett_settore_g,setg_sequenza,
       setg_codice,sett_settore_a,seta_sequenza,seta_codice,
       sett_settore_b,setb_sequenza,setb_codice,sett_settore_c,
       setc_sequenza,setc_codice,sett_gestione,gest_prospetto_po,
       gest_sintetico_po,popi_figura,figi_dal,figu_sequenza,
       figi_codice,figi_qualifica,qugi_dal,qual_sequenza,qugi_codice,
       qugi_contratto,cost_dal,cont_sequenza,cost_ore_lavoro,
       qugi_livello,figi_profilo,prpr_sequenza,prpr_suddivisione_po,
       figi_posizione,pofu_sequenza,qugi_ruolo,ruol_sequenza,
       popi_attivita,atti_sequenza,pegi_posizione,posi_sequenza,
       pegi_tipo_rapporto,pegi_ci,pegi_sostituto,pegi_rilevanza,
       pegi_assenza,pegi_gruppo_ling,cnpo_mm_eta,cnpo_aa_eta,
       cnpo_gg_anz,cnpo_mm_anz,cnpo_aa_anz,cnpo_dal,cnpo_al)
      values
      (d_capo_prenotazione,1,d_rior_data,
       d_popi_sede_posto,d_popi_anno_posto,
       d_popi_numero_posto,d_popi_posto,
       d_popi_gruppo,d_popi_dal,d_popi_ricopribile,d_popi_pianta,
       d_setp_sequenza,d_setp_codice,d_popi_settore,d_sett_sequenza,
       d_sett_codice,d_sett_suddivisione,
       d_sett_settore_g,d_setg_sequenza,
       d_setg_codice,d_sett_settore_a,d_seta_sequenza,d_seta_codice,
       d_sett_settore_b,d_setb_sequenza,d_setb_codice,d_sett_settore_c,
       d_setc_sequenza,d_setc_codice,d_sett_gestione,d_gest_prospetto_po,
       d_gest_sintetico_po,d_popi_figura,d_figi_dal,d_figu_sequenza,
       d_figi_codice,d_figi_qualifica,d_qugi_dal,
       d_qual_sequenza,d_qugi_codice,
       d_qugi_contratto,d_cost_dal,d_cont_sequenza,d_cost_ore_lavoro,
       d_qugi_livello,d_figi_profilo,
       d_prpr_sequenza,d_prpr_suddivisione_po,
       d_figi_posizione,d_pofu_sequenza,d_qugi_ruolo,d_ruol_sequenza,
       d_popi_attivita,d_atti_sequenza,null,0,
       null,null,0,null,
       null,null,null,null,
       null,null,null,d_pegi_dal,d_pegi_al)
      ;
    END LOOP;
    close vacanti;
  END LOOP;
  close posti;
EXCEPTION
  WHEN OTHERS THEN
    d_errtext := substr(SQLERRM,1,240);
    d_prenotazione := P_prenotazione;
    ROLLBACK;
    insert into errori_pogm (prenotazione,voce_menu,data,errore)
    values (d_prenotazione,P_VOCE_MENU ,sysdate,d_errtext)
    ;
    COMMIT;
    RAISE FORM_TRIGGER_FAILURE;
END;
  PROCEDURE RAGGR_POSTI (P_PRENOTAZIONE IN NUMBER, P_VOCE_MENU IN VARCHAR2)IS
d_errtext VARCHAR2(240);
d_prenotazione number(6);
BEGIN
   insert into calcolo_posti
   (capo_prenotazione,capo_rilevanza,capo_lingue,rior_data,popi_sede_posto,
    popi_anno_posto,popi_numero_posto,popi_posto,popi_dal,
    popi_ricopribile,popi_gruppo,
    popi_pianta,setp_sequenza,setp_codice,popi_settore,
    sett_sequenza,sett_codice,sett_suddivisione,sett_settore_g,
    setg_sequenza,setg_codice,sett_settore_a,seta_sequenza,
    seta_codice,sett_settore_b,setb_sequenza,setb_codice,
    sett_settore_c,setc_sequenza,setc_codice,
    sett_gestione,gest_prospetto_po,gest_sintetico_po,
    popi_figura,figi_dal,figu_sequenza,figi_codice,figi_qualifica,
    qugi_dal,qual_sequenza,qugi_codice,qugi_contratto,cost_dal,
    cont_sequenza,cost_ore_lavoro,qugi_livello,figi_profilo,
    prpr_sequenza,prpr_suddivisione_po,
    figi_posizione,pofu_sequenza,
    qugi_ruolo,ruol_sequenza,popi_attivita,atti_sequenza,
    pegi_posizione,posi_sequenza,pegi_tipo_rapporto,
    capo_previsti,capo_ore_previsti,capo_in_pianta,capo_in_deroga,
    capo_in_sovrannumero,capo_in_rilascio,capo_in_acquisizione,
    capo_in_istituzione,capo_assegnazioni_ruolo_l1,
    capo_ore_assegnazioni_ruolo_l1,capo_assegnazioni_ruolo_l2,
    capo_ore_assegnazioni_ruolo_l2,capo_assegnazioni_ruolo_l3,
    capo_ore_assegnazioni_ruolo_l3,capo_assegnazioni_ruolo,
    capo_ore_assegnazioni_ruolo,capo_assegnazioni,capo_ore_assegnazioni,
    capo_assenze_incarico,capo_assenze_assenza,capo_disponibili,
    capo_ore_disponibili,capo_coperti_ruolo_1,
    capo_ore_coperti_ruolo_1,capo_coperti_ruolo_2,
    capo_ore_coperti_ruolo_2,capo_coperti_ruolo_3,
    capo_ore_coperti_ruolo_3,capo_coperti_ruolo,
    capo_ore_coperti_ruolo,capo_coperti_no_ruolo,
    capo_ore_coperti_no_ruolo,capo_vacanti,
    capo_ore_vacanti,capo_vacanti_coperti,
    capo_ore_vacanti_coperti,capo_vacanti_non_coperti,
    capo_ore_vacanti_non_coperti,capo_vacanti_non_ricopribili)
select
    capo_prenotazione,capo_rilevanza+5,max(capo_lingue),max(rior_data),
    null,null,null,null,null,null,
    popi_gruppo,popi_pianta,
    max(setp_sequenza),max(setp_codice),popi_settore,
    max(sett_sequenza),max(sett_codice),
    max(sett_suddivisione),max(sett_settore_g),
    max(setg_sequenza),max(setg_codice),
    max(sett_settore_a),max(seta_sequenza),
    max(seta_codice),max(sett_settore_b),
    max(setb_sequenza),max(setb_codice),
    max(sett_settore_c),max(setc_sequenza),
    max(setc_codice),max(sett_gestione),
    max(gest_prospetto_po),max(gest_sintetico_po),
    popi_figura,max(figi_dal),max(figu_sequenza),
    max(figi_codice),max(figi_qualifica),
    max(qugi_dal),max(qual_sequenza),
    max(qugi_codice),max(qugi_contratto),max(cost_dal),
    max(cont_sequenza),max(cost_ore_lavoro),
    max(qugi_livello),max(figi_profilo),
    max(prpr_sequenza),max(prpr_suddivisione_po),
    max(figi_posizione),max(pofu_sequenza),
    max(qugi_ruolo),max(ruol_sequenza),
    popi_attivita,max(atti_sequenza),
    pegi_posizione,max(posi_sequenza),pegi_tipo_rapporto,
    sum(capo_previsti),capo_ore_previsti,
    sum(capo_in_pianta),sum(capo_in_deroga),
    sum(capo_in_sovrannumero),sum(capo_in_rilascio),
    sum(capo_in_acquisizione),sum(capo_in_istituzione),
    sum(capo_assegnazioni_ruolo_l1),capo_ore_assegnazioni_ruolo_l1,
    sum(capo_assegnazioni_ruolo_l2),capo_ore_assegnazioni_ruolo_l2,
    sum(capo_assegnazioni_ruolo_l3),capo_ore_assegnazioni_ruolo_l3,
    sum(capo_assegnazioni_ruolo),capo_ore_assegnazioni_ruolo,
    sum(capo_assegnazioni),capo_ore_assegnazioni,
    sum(capo_assenze_incarico),sum(capo_assenze_assenza),
    sum(capo_disponibili),
    capo_ore_disponibili,sum(capo_coperti_ruolo_1),
    capo_ore_coperti_ruolo_1,sum(capo_coperti_ruolo_2),
    capo_ore_coperti_ruolo_2,sum(capo_coperti_ruolo_3),
    capo_ore_coperti_ruolo_3,sum(capo_coperti_ruolo),
    capo_ore_coperti_ruolo,sum(capo_coperti_no_ruolo),
    capo_ore_coperti_no_ruolo,sum(capo_vacanti),
    capo_ore_vacanti,sum(capo_vacanti_coperti),
    capo_ore_vacanti_coperti,sum(capo_vacanti_non_coperti),
    capo_ore_vacanti_non_coperti,sum(capo_vacanti_non_ricopribili)
  from calcolo_posti
 where capo_prenotazione = P_prenotazione
   and capo_rilevanza    < 6
 group by
    capo_prenotazione,capo_rilevanza,popi_pianta,popi_settore,
    popi_figura,popi_attivita,popi_gruppo,pegi_posizione,
    pegi_tipo_rapporto,capo_ore_previsti,
    capo_ore_assegnazioni_ruolo_l1,capo_ore_assegnazioni_ruolo_l2,
    capo_ore_assegnazioni_ruolo_l3,capo_ore_assegnazioni_ruolo,
    capo_ore_assegnazioni,
    capo_ore_disponibili,capo_ore_coperti_ruolo_1,
    capo_ore_coperti_ruolo_2,capo_ore_coperti_ruolo_3,
    capo_ore_coperti_ruolo,capo_ore_coperti_no_ruolo,capo_ore_vacanti,
    capo_ore_vacanti_coperti,capo_ore_vacanti_non_coperti
;
EXCEPTION
  WHEN OTHERS THEN
    d_errtext := substr(SQLERRM,1,240);
    d_prenotazione := P_prenotazione;
    ROLLBACK;
    insert into errori_pogm (prenotazione,voce_menu,data,errore)
    values (d_prenotazione,P_VOCE_MENU ,sysdate,d_errtext)
    ;
    COMMIT;
    RAISE FORM_TRIGGER_FAILURE;
END;
END;
/

