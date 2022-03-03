CREATE OR REPLACE PACKAGE PPOCSOOR3 IS
/******************************************************************************
 NOME:          PECCSOOR3
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
  PROCEDURE CALCOLO_ETA_ANZIANITA (
P_CI          IN     NUMBER,
P_MM_ETA      IN OUT NUMBER,
P_AA_ETA      IN OUT NUMBER,
P_GG_ANZ      IN OUT NUMBER,
P_MM_ANZ      IN OUT NUMBER,
P_AA_ANZ      IN OUT NUMBER
                                );
  PROCEDURE CC_NOMINATIVO(P_D_F in varchar2, P_USO_INTERNO in varchar2,
				P_PRENOTAZIONE in number, p_lingue in varchar2, p_voce_menu in varchar2);
END;
/
CREATE OR REPLACE PACKAGE BODY PPOCSOOR3 IS
form_trigger_failure	exception;
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
d_cndo_mm_eta    number(4);
d_cndo_aa_eta    number(4);
d_gg_anz         number(4);
d_mm_anz         number(4);
d_aa_anz         number(4);
d_cndo_gg_anz    number(4);
d_cndo_mm_anz    number(4);
d_cndo_aa_anz    number(4);
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
       ,d_cndo_aa_eta
       ,d_cndo_mm_eta
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
    d_cndo_gg_anz := mod((d_gg_anz       +
                          d_mm_anz * 30  +
                          d_aa_anz * 360
                         ),30
                        );
    d_cndo_mm_anz := trunc(mod((d_gg_anz       +
                                d_mm_anz * 30  +
                                d_aa_anz * 360
                               ),360
                              ) / 30
                          );
    d_cndo_aa_anz := trunc((d_gg_anz       +
                            d_mm_anz * 30  +
                            d_aa_anz * 360
                           ) / 360
                          );
IF d_conta = 0 THEN           -- No data found
   d_cndo_mm_eta := 0;
   d_cndo_aa_eta := 0;
   d_cndo_gg_anz := 0;
   d_cndo_mm_anz := 0;
   d_cndo_aa_anz := 0;
END IF;
P_MM_ETA := d_cndo_mm_eta;
P_AA_ETA := d_cndo_aa_eta;
P_GG_ANZ := d_cndo_gg_anz;
P_MM_ANZ := d_cndo_mm_anz;
P_AA_ANZ := d_cndo_aa_anz;
END;
  PROCEDURE CC_NOMINATIVO (P_D_F in varchar2, P_USO_INTERNO in varchar2,
				P_PRENOTAZIONE in number, p_lingue in varchar2, p_voce_menu in varchar2) IS
d_errtext                       VARCHAR2(240);
d_prenotazione                   number(6);
d_conta_cursori                  number(2);
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
d_cndo_mm_eta                    number(2);
d_cndo_aa_eta                    number(2);
d_cndo_gg_anz                    number(2);
d_cndo_mm_anz                    number(2);
d_cndo_aa_anz                    number(2);
d_popi_sede_posto_inc           VARCHAR2(2);
d_popi_anno_posto_inc            number(4);
d_popi_numero_posto_inc          number(7);
d_popi_posto_inc                 number(5);
cursor periodi is
select 1
      ,pg.ore
      ,pg.posizione
      ,nvl(po.sequenza,999)
      ,pg.tipo_rapporto
      ,pg.figura
      ,nvl(pg.qualifica,fg.qualifica)
      ,pg.attivita
      ,pg.settore
      ,pg.sede_posto
      ,pg.anno_posto
      ,pg.numero_posto
      ,pg.posto
      ,pg.ci,nvl(pg.sostituto,pg.ci)
      ,pg.rilevanza,pg.assenza,pg.dal,pg.al
      ,po.ruolo,an.gruppo_ling
  from posizioni             p2
      ,posizioni             po
      ,figure_giuridiche     fg
      ,anagrafici            an
      ,rapporti_individuali  ri
      ,periodi_giuridici     pg
 where d_rior_data       between pg.dal
                         and nvl(pg.al,to_date('3333333','j'))
   and d_rior_data       between fg.dal
                         and nvl(fg.al,to_date('3333333','j'))
   and fg.numero               = pg.figura
   and (    pg.rilevanza      in ('Q','I')
        and P_d_f           = 'D'
        and p_uso_interno   = 'X'
        or  pg.rilevanza      in ('S','E')
        and p_d_f           = 'F'
        and P_uso_interno   = 'X'
        or  pg.rilevanza       = 'Q'
        and po.ruolo           = 'SI'
        and P_d_f           = 'D'
        and P_uso_interno  is null
        or  pg.rilevanza       = 'S'
        and po.ruolo           = 'SI'
        and P_d_f           = 'F'
        and P_uso_interno  is null
       )
   and d_rior_data between an.dal and nvl(an.al,to_date('3333333','j'))
   and an.ni               = ri.ni
   and ri.ci               = pg.ci
   and po.codice           = p2.posizione
   and p2.codice           = pg.posizione
;
cursor assenze is
select 2
      ,p2.ore
      ,p2.posizione
      ,999
      ,p2.tipo_rapporto
      ,p2.figura
      ,p2.qualifica
      ,p2.attivita
      ,p2.settore
      ,p2.sede_posto
      ,p2.anno_posto
      ,p2.numero_posto
      ,p2.posto
      ,pg.ci,nvl(p2.sostituto,pg.ci)
      ,pg.rilevanza,pg.assenza,pg.dal,pg.al
      ,null,an.gruppo_ling
  from anagrafici            an
      ,rapporti_individuali  ri
      ,periodi_giuridici     p2
      ,periodi_giuridici     pg
 where d_rior_data       between pg.dal
                         and nvl(pg.al,to_date('3333333','j'))
   and d_rior_data       between p2.dal
                         and nvl(p2.al,to_date('3333333','j'))
   and d_rior_data between an.dal and nvl(an.al,to_date('3333333','j'))
   and an.ni               = ri.ni
   and ri.ci               = pg.ci
   and p2.ci               = pg.ci
   and pg.rilevanza        = 'A'
   and (    p2.rilevanza   = 'Q'
        and P_d_f       = 'D'
        and not exists
                (select 1
                   from periodi_giuridici p3
                  where d_rior_data between p3.dal
                                    and nvl(p3.al,to_date('3333333','j'))
                    and p3.rilevanza      = 'I'
                    and p3.ci             = p2.ci
                )
        or  p2.rilevanza   = 'S'
        and P_d_f       = 'F'
        and not exists
                (select 1
                   from periodi_giuridici p3
                  where d_rior_data between p3.dal
                                    and nvl(p3.al,to_date('3333333','j'))
                    and p3.rilevanza      = 'E'
                    and p3.ci             = p2.ci
                )
        or  p2.rilevanza   = 'I'
        and P_d_f       = 'D'
        or  p2.rilevanza   = 'E'
        and P_d_f       = 'F'
       )
   and P_uso_interno    = 'X'
   and pg.assenza    in
       (select aa.codice
          from astensioni aa
         where aa.sostituibile = 1
       )
;
cursor vacanti is
select 3
      ,pp.ore
      ,null
      ,999
      ,null
      ,pp.figura
      ,fg.qualifica
      ,pp.attivita
      ,pp.settore
      ,pp.sede_posto
      ,pp.anno_posto
      ,pp.numero_posto
      ,pp.posto
      ,0,0
      ,null,null,pp.dal,pp.al
      ,null,null
  from figure_giuridiche   fg
      ,posti_pianta        pp
 where d_rior_data between pp.dal and nvl(pp.al,to_date('3333333','j'))
   and d_rior_data between fg.dal and nvl(fg.al,to_date('3333333','j'))
   and pp.figura                 = fg.numero
   and (    pp.stato             = 'A'
        and pp.situazione        = 'R'
        or  pp.stato            in ('T','I','C')
       )
   and not exists
       (select 1
          from periodi_giuridici pg
         where d_rior_data between pg.dal
                               and nvl(pg.al,to_date('3333333','j'))
           and pg.rilevanza      = 'Q'
           and pg.sede_posto     = pp.sede_posto
           and pg.anno_posto     = pp.anno_posto
           and pg.numero_posto   = pp.numero_posto
           and pg.posto          = pp.posto
           and pg.posizione     in (select posi.codice
                                      from posizioni posi
                                     where posi.ruolo = 'SI'
                                   )
       )
;
BEGIN
  BEGIN
     select data
       into d_rior_data
       from riferimento_organico
     ;
  END;
  d_conta_cursori := 0;
  LOOP
  d_conta_cursori := d_conta_cursori + 1;
  if d_conta_cursori > 3 then
     exit;
  end if;
  if d_conta_cursori = 1 then
  open periodi;
  end if;
  if d_conta_cursori = 2 then
  open assenze;
  end if;
  if d_conta_cursori = 3 then
  open vacanti;
  end if;
  LOOP
    if d_conta_cursori = 1 then
    fetch periodi into d_rilevanza,d_pegi_ore,
    d_pegi_posizione,d_posi_sequenza,d_pegi_tipo_rapporto,
    d_popi_figura,d_figi_qualifica,d_popi_attivita,d_popi_settore,
    d_popi_sede_posto,d_popi_anno_posto,
    d_popi_numero_posto,d_popi_posto,
    d_pegi_ci,d_pegi_sostituto,d_pegi_rilevanza,
    d_pegi_assenza,d_pegi_dal,d_pegi_al,
    d_posi_ruolo,d_anag_gruppo_ling;
    exit when periodi%NOTFOUND;
    end if;
    if d_conta_cursori = 2 then
    fetch assenze into d_rilevanza,d_pegi_ore,
    d_pegi_posizione,d_posi_sequenza,d_pegi_tipo_rapporto,
    d_popi_figura,d_figi_qualifica,d_popi_attivita,d_popi_settore,
    d_popi_sede_posto,d_popi_anno_posto,
    d_popi_numero_posto,d_popi_posto,
    d_pegi_ci,d_pegi_sostituto,d_pegi_rilevanza,
    d_pegi_assenza,d_pegi_dal,d_pegi_al,
    d_posi_ruolo,d_anag_gruppo_ling;
    exit when assenze%NOTFOUND;
    end if;
    if d_conta_cursori = 3 then
    fetch vacanti into d_rilevanza,d_pegi_ore,
    d_pegi_posizione,d_posi_sequenza,d_pegi_tipo_rapporto,
    d_popi_figura,d_figi_qualifica,d_popi_attivita,d_popi_settore,
    d_popi_sede_posto,d_popi_anno_posto,
    d_popi_numero_posto,d_popi_posto,
    d_pegi_ci,d_pegi_sostituto,d_pegi_rilevanza,
    d_pegi_assenza,d_pegi_dal,d_pegi_al,
    d_posi_ruolo,d_anag_gruppo_ling;
    exit when vacanti%NOTFOUND;
    end if;
    d_cndo_mm_eta          := null;
    d_cndo_aa_eta          := null;
    d_cndo_gg_anz          := null;
    d_cndo_mm_anz          := null;
    d_cndo_aa_anz          := null;
    d_sett_sequenza        := null;
    d_sett_codice          := null;
    d_sett_suddivisione    := null;
    d_sett_settore_g       := null;
    d_setg_sequenza        := null;
    d_setg_codice          := null;
    d_sett_settore_a       := null;
    d_seta_sequenza        := null;
    d_seta_codice          := null;
    d_sett_settore_b       := null;
    d_setb_sequenza        := null;
    d_setb_codice          := null;
    d_sett_settore_c       := null;
    d_setc_sequenza        := null;
    d_setc_codice          := null;
    d_sett_gestione        := null;
    d_gest_prospetto_po    := null;
    d_gest_sintetico_po    := null;
    d_figi_dal             := null;
    d_figu_sequenza        := null;
    d_figi_codice          := null;
    d_qugi_dal             := null;
    d_qual_sequenza        := null;
    d_qugi_codice          := null;
    d_qugi_contratto       := null;
    d_cost_dal             := null;
    d_cont_sequenza        := null;
    d_cost_ore_lavoro      := null;
    d_qugi_livello         := null;
    d_figi_profilo         := null;
    d_prpr_sequenza        := null;
    d_prpr_suddivisione_po := null;
    d_figi_posizione       := null;
    d_pofu_sequenza        := null;
    d_qugi_ruolo           := null;
    d_ruol_sequenza        := null;
    d_popi_dal             := null;
    d_popi_gruppo          := null;
    d_popi_ore             := null;
    d_popi_pianta          := null;
    d_setp_codice          := null;
    d_setp_sequenza        := null;
    if  d_popi_sede_posto     is not null
    and d_popi_anno_posto     is not null
    and d_popi_numero_posto   is not null
    and d_popi_posto          is not null then
       BEGIN
          select dal
                ,gruppo
                ,pianta
                ,ore
                ,disponibilita
            into d_popi_dal
                ,d_popi_gruppo
                ,d_popi_pianta
                ,d_popi_ore
                ,d_popi_ricopribile
            from posti_pianta
           where sede_posto        = d_popi_sede_posto
             and anno_posto        = d_popi_anno_posto
             and numero_posto      = d_popi_numero_posto
             and posto             = d_popi_posto
             and d_rior_data between dal
                             and nvl(al,to_date('3333333','j'))
          ;
       END;
       BEGIN
          select nvl(sequenza,999999),codice
            into d_setp_sequenza,d_setp_codice
            from settori
           where numero = d_popi_pianta
          ;
       END;
    end if;
    BEGIN
       select nvl(s.sequenza,999999),s.codice
             ,s.suddivisione,s.gestione,
              g.prospetto_po,nvl(g.sintetico_po,g.prospetto_po),
              s.settore_g,s.settore_a,
              s.settore_b,s.settore_c,g.sintetico_po
         into d_sett_sequenza,d_sett_codice,d_sett_suddivisione,
              d_sett_gestione,d_gest_prospetto_po,d_gest_sintetico_po,
              d_sett_settore_g,d_sett_settore_a,
              d_sett_settore_b,d_sett_settore_c,d_gest_sintetico_po
         from gestioni g,settori s
        where s.numero    = d_popi_settore
          and g.codice    = s.gestione
       ;
    END;
    if d_sett_suddivisione = 0 then
       d_sett_settore_g   := d_popi_settore;
       d_setg_sequenza    := d_sett_sequenza;
       d_setg_codice      := d_sett_codice;
       d_sett_settore_a   := d_popi_settore;
       d_seta_sequenza    := 0;
       d_seta_codice      := d_sett_codice;
       d_sett_settore_b   := d_popi_settore;
       d_setb_sequenza    := 0;
       d_setb_codice      := d_sett_codice;
       d_sett_settore_c   := d_popi_settore;
       d_setc_sequenza    := 0;
       d_setc_codice      := d_sett_codice;
    else
       BEGIN
         select nvl(sequenza,999999),codice
           into d_setg_sequenza,d_setg_codice
           from settori
          where numero = d_sett_settore_g
         ;
       END;
       if d_sett_suddivisione = 1 then
          d_sett_settore_a   := d_popi_settore;
          d_seta_sequenza    := d_sett_sequenza;
          d_seta_codice      := d_sett_codice;
          d_sett_settore_b   := d_popi_settore;
          d_setb_sequenza    := 0;
          d_setb_codice      := d_sett_codice;
          d_sett_settore_c   := d_popi_settore;
          d_setc_sequenza    := 0;
          d_setc_codice      := d_sett_codice;
       else
          BEGIN
            select nvl(sequenza,999999),codice
              into d_seta_sequenza,d_seta_codice
              from settori
             where numero = d_sett_settore_a
            ;
          END;
          if d_sett_suddivisione = 2 then
             d_sett_settore_b   := d_popi_settore;
             d_setb_sequenza    := d_sett_sequenza;
             d_setb_codice      := d_sett_codice;
             d_sett_settore_c   := d_popi_settore;
             d_setc_sequenza    := 0;
             d_setc_codice      := d_sett_codice;
          else
            BEGIN
              select nvl(sequenza,999999),codice
                into d_setb_sequenza,d_setb_codice
                from settori
               where numero = d_sett_settore_b
              ;
            END;
            if d_sett_suddivisione = 3 then
               d_sett_settore_c   := d_popi_settore;
               d_setc_sequenza     := d_sett_sequenza;
               d_setc_codice      := d_sett_codice;
            else
               BEGIN
                  select nvl(sequenza,999999),codice
                    into d_setc_sequenza,d_setc_codice
                    from settori
                   where numero = d_sett_settore_c
                  ;
               END;
            end if;
          end if;
       end if;
    end if;
    if P_d_f = 'D' or d_pegi_rilevanza is null then
       BEGIN
         select fg.dal,nvl(fi.sequenza,999999),fg.codice,
                fg.qualifica,qg.dal,nvl(qu.sequenza,999999),qg.codice,
                qg.contratto,cs.dal,nvl(co.sequenza,999),cs.ore_lavoro,
                qg.livello,qg.ruolo,nvl(ru.sequenza,999),
                fg.profilo,nvl(pr.sequenza,999),
                decode(fg.profilo,null,'F',
                       decode(d_gest_sintetico_po,null,'F'
                                                 ,'Q' ,'F'
                                                 ,'L' ,'F'
                                                 ,pr.suddivisione_po
                             )
                      ),
                fg.posizione,nvl(pf.sequenza,999)
           into d_figi_dal,d_figu_sequenza,d_figi_codice,
                d_figi_qualifica,d_qugi_dal,
                d_qual_sequenza,d_qugi_codice,
                d_qugi_contratto,d_cost_dal,d_cont_sequenza,
                d_cost_ore_lavoro,d_qugi_livello,d_qugi_ruolo,
                d_ruol_sequenza,d_figi_profilo,d_prpr_sequenza,
                d_prpr_suddivisione_po,d_figi_posizione,d_pofu_sequenza
           from posizioni_funzionali     pf,
                profili_professionali    pr,
                ruoli                    ru,
                contratti_storici        cs,
                contratti                co,
                qualifiche_giuridiche    qg,
                qualifiche               qu,
                figure_giuridiche        fg,
                figure                   fi
          where d_rior_data         between fg.dal
                                and nvl(fg.al,to_date('3333333','j'))
            and d_rior_data         between qg.dal
                                and nvl(qg.al,to_date('3333333','j'))
            and d_rior_data         between cs.dal
                                and nvl(cs.al,to_date('3333333','j'))
            and pf.profilo      (+) = fg.profilo
            and pf.codice       (+) = fg.posizione
            and pr.codice       (+) = fg.profilo
            and ru.codice           = qg.ruolo
            and cs.contratto        = qg.contratto
            and co.codice           = qg.contratto
            and qg.numero           = fg.qualifica
            and qu.numero           = fg.qualifica
            and fg.numero           = d_popi_figura
            and fi.numero           = d_popi_figura
         ;
       END;
   end if;
   if P_d_f = 'F' and d_pegi_rilevanza is not null then
       BEGIN
         select fg.dal,nvl(fi.sequenza,999999),fg.codice,
                qg.dal,nvl(qu.sequenza,999999),qg.codice,
                qg.contratto,cs.dal,nvl(co.sequenza,999),cs.ore_lavoro,
                qg.livello,qg.ruolo,nvl(ru.sequenza,999),
                fg.profilo,nvl(pr.sequenza,999),
                decode(fg.profilo,null,'F',
                       decode(d_gest_sintetico_po,null,'F'
                                                 ,'Q' ,'F'
                                                 ,'L' ,'F'
                                                 ,pr.suddivisione_po
                             )
                      ),
                fg.posizione,nvl(pf.sequenza,999)
           into d_figi_dal,d_figu_sequenza,d_figi_codice,
                d_qugi_dal,d_qual_sequenza,d_qugi_codice,
                d_qugi_contratto,d_cost_dal,d_cont_sequenza,
                d_cost_ore_lavoro,d_qugi_livello,d_qugi_ruolo,
                d_ruol_sequenza,d_figi_profilo,d_prpr_sequenza,
                d_prpr_suddivisione_po,d_figi_posizione,d_pofu_sequenza
           from posizioni_funzionali     pf,
                profili_professionali    pr,
                ruoli                    ru,
                contratti_storici        cs,
                contratti                co,
                qualifiche_giuridiche    qg,
                qualifiche               qu,
                figure_giuridiche        fg,
                figure                   fi
          where d_rior_data         between fg.dal
                                and nvl(fg.al,to_date('3333333','j'))
            and d_rior_data         between qg.dal
                                and nvl(qg.al,to_date('3333333','j'))
            and d_rior_data         between cs.dal
                                and nvl(cs.al,to_date('3333333','j'))
            and pf.profilo      (+) = fg.profilo
            and pf.codice       (+) = fg.posizione
            and pr.codice       (+) = fg.profilo
            and ru.codice           = qg.ruolo
            and cs.contratto        = qg.contratto
            and co.codice           = qg.contratto
            and qg.numero           = d_figi_qualifica
            and qu.numero           = qg.numero
            and fg.numero           = d_popi_figura
            and fi.numero           = d_popi_figura
         ;
       END;
    end if;
    BEGIN
      select nvl(sequenza,999999)
        into d_atti_sequenza
        from attivita
       where codice    = d_popi_attivita
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        d_atti_sequenza := 999999;
    END;
    if nvl(d_pegi_rilevanza,' ') <> 'A' then
       CALCOLO_ETA_ANZIANITA(d_pegi_ci,d_cndo_mm_eta,d_cndo_aa_eta,
                             d_cndo_gg_anz,d_cndo_mm_anz,d_cndo_aa_anz
                            );
    end if;
    insert into calcolo_nominativo_dotazione
    (cndo_prenotazione,cndo_rilevanza,rior_data,
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
     pegi_assenza,pegi_gruppo_ling,cndo_mm_eta,cndo_aa_eta,
     cndo_gg_anz,cndo_mm_anz,cndo_aa_anz,cndo_dal,cndo_al,
     popi_sede_posto_inc,popi_anno_posto_inc,popi_numero_posto_inc,
     popi_posto_inc)
    values
    (P_prenotazione,d_rilevanza,d_rior_data,
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
     nvl(d_pegi_ore,nvl(d_popi_ore,d_cost_ore_lavoro)),
     d_pegi_assenza,d_anag_gruppo_ling,d_cndo_mm_eta,d_cndo_aa_eta,
     d_cndo_gg_anz,d_cndo_mm_anz,d_cndo_aa_anz,d_pegi_dal,d_pegi_al,
     d_popi_sede_posto_inc,d_popi_anno_posto_inc,
     d_popi_numero_posto_inc,d_popi_posto_inc)
    ;
  END LOOP;
  if d_conta_cursori = 1 then
  close periodi;
  end if;
  if d_conta_cursori = 2 then
  close assenze;
  end if;
  if d_conta_cursori = 3 then
  close vacanti;
  end if;
  END LOOP;
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

