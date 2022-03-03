CREATE OR REPLACE PACKAGE PPOCSIDP3 IS
/******************************************************************************
 NOME:          PPOCSIDP3
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
PROCEDURE RAGGR_POSTI (p_prenotazione in number, p_voce_menu in varchar2);
  PROCEDURE CALCOLO_ETA_ANZIANITA (
P_CI          IN     NUMBER,
P_MM_ETA      IN OUT NUMBER,
P_AA_ETA      IN OUT NUMBER,
P_GG_ANZ      IN OUT NUMBER,
P_MM_ANZ      IN OUT NUMBER,
P_AA_ANZ      IN OUT NUMBER,
P_al		IN date
                                ) ;
END;
/
CREATE OR REPLACE PACKAGE BODY ppocsidp3 IS
FORM_TRIGGER_FAILURE exception;
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
P_AA_ANZ      IN OUT NUMBER,
P_al	      IN DATE
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
                                              ,p_al
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
                                             ,p_al
                                             ) + 1,'dd'
                                         )
                                 ) - 1
                    )
            ) / 360
           ))
      * to_number(decode(pegi.rilevanza,'Q',1,-1))
     )        --  Anni di Anzianita`
 ,sum((trunc((trunc(months_between(last_day(nvl(pegi.al
                                             ,p_al
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
                                            ,p_al
                                            ) + 1,'dd'
                                        )
                                ) - 1
                   )
           - trunc((trunc(months_between(last_day(nvl(pegi.al
                                                 ,p_al
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
                                                ,p_al
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
 trunc(months_between( last_day(nvl(pegi.al,p_al)+1)
                      ,last_day(pegi.dal)
                     )
      )*30
     -least( 30,to_number(to_char(pegi.dal,'dd'))
           )+1
     +least( 30,to_number(to_char( nvl(pegi.al,p_al)+1
                                          ,'dd'))-1)   -
(trunc((trunc(months_between( last_day( nvl(pegi.al,p_al)+1
                                      )
                             ,last_day(pegi.dal)
                            )
             )*30
       -least( 30,to_number(to_char(pegi.dal,'dd'))
             )+1
       +least( 30,to_number( to_char( nvl(pegi.al,p_al)+1
                            ,'dd'))
             -1))  / 360
      )  *360 )                            -
  trunc(
 (trunc(months_between( last_day( nvl(pegi.al,p_al)+1
                                      )
                             ,last_day(pegi.dal)
                            )
             )*30
       -least( 30,to_number(to_char(pegi.dal,'dd'))
             )+1
       +least( 30,to_number( to_char( nvl(pegi.al,p_al)+1
                            ,'dd'))
             -1) -
 trunc((trunc(months_between( last_day( nvl(pegi.al,p_al)+1
                                      )
                             ,last_day(pegi.dal)
                            )
             )*30
       -least( 30,to_number(to_char(pegi.dal,'dd'))
             )+1
       +least( 30,to_number( to_char( nvl(pegi.al,p_al)+1
                            ,'dd'))
             -1))  / 360
      ) * 360) / 30) * 30)
      * to_number(decode(pegi.rilevanza,'Q',1,-1))
 )   -- Giorni di Anzianita`
 ,max(trunc(months_between(p_al,anag.data_nas) / 12))
     -- Anni di Eta`
 ,max(trunc(months_between(p_al,anag.data_nas))
     -trunc(months_between(p_al,anag.data_nas) / 12)
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
   and  p_al               between anag.dal
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
   and  pegi.dal                            <= p_al
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
PROCEDURE RAGGR_POSTI (p_prenotazione in number, p_voce_menu in varchar2) IS
d_errtext VARCHAR2(240);
d_prenotazione number(6);
BEGIN
   insert into calcolo_dotazione
   (cado_prenotazione,cado_rilevanza,cado_lingue,rior_data,
    popi_sede_posto,
    popi_anno_posto,popi_numero_posto,popi_posto,popi_dal,
    popi_ricopribile,popi_gruppo,
    popi_pianta,setp_sequenza,setp_codice,popi_settore,
    sett_sequenza,sett_codice,sett_suddivisione,sett_settore_g,
    setg_sequenza,setg_codice,sett_settore_a,seta_sequenza,
    seta_codice,sett_settore_b,setb_sequenza,setb_codice,
    sett_settore_c,setc_sequenza,setc_codice,
    sett_gestione,gest_prospetto_po,gest_sintetico_po,
    sett_sede,sedi_codice,sedi_sequenza,
    popi_figura,figi_dal,figu_sequenza,figi_codice,figi_qualifica,
    qugi_dal,qual_sequenza,qugi_codice,qugi_contratto,cost_dal,
    cont_sequenza,cost_ore_lavoro,qugi_livello,figi_profilo,
    prpr_sequenza,prpr_suddivisione_po,
    figi_posizione,pofu_sequenza,
    qugi_ruolo,ruol_sequenza,popi_attivita,atti_sequenza,
    pegi_posizione,posi_sequenza,pegi_tipo_rapporto,
    pegi_evento,evgi_sequenza,pegi_sede_del,pegi_anno_del,
    pegi_numero_del,cado_ore_previsti,cado_previsti,
    cado_in_pianta,cado_in_deroga,cado_in_sovrannumero,
    cado_in_rilascio,cado_in_istituzione)
select
    cado_prenotazione,cado_rilevanza+5,max(cado_lingue),max(rior_data),
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
    sett_sede,max(sedi_codice),max(sedi_sequenza),
    popi_figura,max(figi_dal),max(figu_sequenza),
    max(figi_codice),figi_qualifica,
    max(qugi_dal),max(qual_sequenza),
    max(qugi_codice),max(qugi_contratto),max(cost_dal),
    max(cont_sequenza),max(cost_ore_lavoro),
    max(qugi_livello),max(figi_profilo),
    max(prpr_sequenza),max(prpr_suddivisione_po),
    max(figi_posizione),max(pofu_sequenza),
    max(qugi_ruolo),max(ruol_sequenza),
    popi_attivita,max(atti_sequenza),
    pegi_posizione,max(posi_sequenza),pegi_tipo_rapporto,
    pegi_evento,max(evgi_sequenza),pegi_sede_del,pegi_anno_del,
    pegi_numero_del,cado_ore_previsti,sum(cado_previsti),
    sum(cado_in_pianta),sum(cado_in_deroga),
    sum(cado_in_sovrannumero),sum(cado_in_rilascio),
    sum(cado_previsti+cado_in_pianta-cado_in_deroga+
        cado_in_sovrannumero-cado_in_rilascio)
  from calcolo_dotazione
 where cado_prenotazione = P_prenotazione
   and cado_rilevanza    < 6
 group by
    cado_prenotazione,cado_rilevanza,popi_pianta,popi_settore,sett_sede,
    popi_figura,figi_qualifica,popi_attivita,popi_gruppo,pegi_posizione,
    pegi_tipo_rapporto,pegi_evento,pegi_sede_del,pegi_anno_del,
    pegi_numero_del,cado_ore_previsti
;
EXCEPTION
  WHEN OTHERS THEN
    d_errtext := substr(SQLERRM,1,240);
    d_prenotazione := P_prenotazione;
    ROLLBACK;
    insert into errori_pogm (prenotazione,voce_menu,data,errore)
    values (d_prenotazione,p_VOCE_MENU ,sysdate,d_errtext)
    ;
    COMMIT;
    RAISE FORM_TRIGGER_FAILURE;
END;
END;
/

