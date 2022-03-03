CREATE OR REPLACE PACKAGE ppocdipo2 IS
/******************************************************************************
 NOME:          P
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
  PROCEDURE CC_POSTI(P_DATA IN DATE, P_LINGUE IN VARCHAR2, P_PRENOTAZIONE IN NUMBER, P_VOCE_MENU IN VARCHAR2);
  PROCEDURE RAGGR_POSTI(P_PRENOTAZIONE IN NUMBER, P_VOCE_MENU IN VARCHAR2);
END;
/
CREATE OR REPLACE PACKAGE BODY PPOCDIPO2 IS
FORM_TRIGGER_FAILURE EXCEPTION;
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
PROCEDURE RAGGR_POSTI(P_PRENOTAZIONE IN NUMBER, P_VOCE_MENU IN VARCHAR2) IS
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
  /* Generazione della Tabella di Appoggio per Situazione Posti */
PROCEDURE CC_POSTI (P_DATA IN DATE, P_LINGUE IN VARCHAR2, P_PRENOTAZIONE IN NUMBER, P_VOCE_MENU IN VARCHAR2) IS
d_errtext VARCHAR2(240);
d_prenotazione number(6);
d_rior_data date;
d_popi_sede_posto VARCHAR2(2);
d_popi_anno_posto number(4);
d_popi_numero_posto number(7);
d_popi_posto number(5);
d_popi_dal date;
d_popi_stato     VARCHAR2(1);
d_popi_situazione     VARCHAR2(1);
d_popi_ricopribile    VARCHAR2(1);
d_popi_gruppo    VARCHAR2(12);
d_popi_pianta     number(6);
d_setp_sequenza   number(6);
d_setp_codice    VARCHAR2(15);
d_popi_settore    number(6);
d_sett_sequenza   number(6);
d_sett_codice    VARCHAR2(15);
d_sett_suddivisione    number(1);
d_sett_settore_g  number(6);
d_setg_sequenza   number(6);
d_setg_codice    VARCHAR2(15);
d_sett_settore_a  number(6);
d_seta_sequenza   number(6);
d_seta_codice    VARCHAR2(15);
d_sett_settore_b  number(6);
d_setb_sequenza   number(6);
d_setb_codice    VARCHAR2(15);
d_sett_settore_c  number(6);
d_setc_sequenza   number(6);
d_setc_codice    VARCHAR2(15);
d_sett_gestione  VARCHAR2(4);
d_gest_prospetto_po   VARCHAR2(1);
d_gest_sintetico_po   VARCHAR2(1);
d_popi_figura     number(6);
d_figi_dal     date;
d_figu_sequenza   number(6);
d_figi_codice    VARCHAR2(8);
d_figi_qualifica  number(6);
d_qugi_dal     date;
d_qual_sequenza   number(6);
d_qugi_codice    VARCHAR2(8);
d_qugi_contratto VARCHAR2(4);
d_cost_dal     date;
d_cont_sequenza   number(3);
d_cost_ore_lavoro number(5,2);
d_qugi_livello   VARCHAR2(4);
d_figi_profilo   VARCHAR2(4);
d_prpr_sequenza   number(3);
d_prpr_suddivisione_po     VARCHAR2(1);
d_figi_posizione VARCHAR2(4);
d_pofu_sequenza   number(3);
d_qugi_ruolo     VARCHAR2(4);
d_ruol_sequenza   number(4);
d_popi_attivita  VARCHAR2(4);
d_atti_sequenza   number(6);
d_popi_ore   number(5,2);
d_pegi_posizione VARCHAR2(4);
d_posi_sequenza   number(3);
d_posi_di_ruolo   number(1);
d_pegi_tipo_rapporto  VARCHAR2(2);
d_pegi_ore   number(5,2);
d_capo_previsti   number(5);
d_capo_ore_previsti    number(5,2);
d_capo_in_pianta  number(5);
d_capo_in_deroga  number(5);
d_capo_in_sovrannumero number(5);
d_capo_in_rilascio     number(5);
d_capo_in_istituzione  number(5);
d_capo_in_acquisizione number(5);
d_capo_ass_ruolo_l1    number(5);
d_capo_ore_ass_ruolo_l1     number(5,2);
d_capo_ass_ruolo_l2    number(5);
d_capo_ore_ass_ruolo_l2     number(5,2);
d_capo_ass_ruolo_l3    number(5);
d_capo_ore_ass_ruolo_l3     number(5,2);
d_capo_ass_ruolo  number(5);
d_capo_ore_ass_ruolo   number(5,2);
d_capo_assegnazioni    number(5);
d_capo_ore_assegnazioni     number(5,2);
d_capo_assenze_incarico     number(5);
d_capo_assenze_assenza number(5);
d_capo_disponibili     number(5);
d_capo_ore_disponibili number(5,2);
d_capo_coperti_ruolo_1 number(5);
d_capo_ore_coperti_ruolo_1  number(5,2);
d_capo_coperti_ruolo_2 number(5);
d_capo_ore_coperti_ruolo_2  number(5,2);
d_capo_coperti_ruolo_3 number(5);
d_capo_ore_coperti_ruolo_3  number(5,2);
d_capo_coperti_ruolo   number(5);
d_capo_ore_coperti_ruolo    number(5,2);
d_capo_coperti_no_ruolo     number(5);
d_capo_ore_coperti_no_ruolo number(5,2);
d_capo_vacanti    number(5);
d_capo_ore_vacanti     number(5,2);
d_capo_vacanti_coperti number(5);
d_capo_ore_vacanti_coperti  number(5,2);
d_capo_vacanti_non_coperti  number(5);
d_capo_ore_vacanti_non_coperti   number(5,2);
d_capo_vacanti_non_ricopribili   number(5);
d_capo_sost_titolari   number(5);
d_capo_ore_sost_titolari    number(5,2);
nOre    number(5,2);
nOre_1  number(5,2);
nOre_2  number(5,2);
nOre_3  number(5,2);
cursor posti is
select p.sede_posto,p.anno_posto,p.numero_posto,p.posto,p.dal,p.gruppo,
  p.stato,p.situazione,nvl(p.disponibilita,'N'),p.pianta,p.settore,
  p.figura,p.attivita,p.ore
  from posti_pianta p
 where d_rior_data   between nvl(p.dal,to_date('2222222','j'))
     and nvl(p.al ,to_date('3333333','j'))
   and (    p.stato  in ('T','I','C')
   or  p.stato   = 'A'
   and p.situazione   = 'R'
   or  p.situazione  in ('I','A')
  )
   and exists
(select 1
 from settori s, gestioni g
where s.numero    = p.settore
 and g.codice    = s.gestione
 and g.gestito   = 'SI'
 and nvl(g.prospetto_po,' ')<>'N');
cursor assegnazioni is
select pg.ore,count(*),pg.posizione,nvl(po.sequenza,999),pg.tipo_rapporto
  from posizioni pa,posizioni po,periodi_giuridici pg
 where d_rior_data  between pg.dal
     and nvl(pg.al,to_date('3333333','j'))
   and pg.sede_posto = d_popi_sede_posto
   and pg.anno_posto = d_popi_anno_posto
   and pg.numero_posto    = d_popi_numero_posto
   and pg.posto = d_popi_posto
   and pg.rilevanza in ('Q','I')
   and pa.codice     = pg.posizione
   and po.codice     = pa.posizione
 group by
  pg.ore
 ,pg.posizione
 ,nvl(po.sequenza,999)
 ,pg.tipo_rapporto
;
BEGIN
  BEGIN
     d_rior_data := P_data;
  END;
  open posti;
  LOOP
    fetch posti into d_popi_sede_posto,d_popi_anno_posto,
 d_popi_numero_posto,d_popi_posto,d_popi_dal,
 d_popi_gruppo,
 d_popi_stato,d_popi_situazione,d_popi_ricopribile,
 d_popi_pianta,d_popi_settore,d_popi_figura,
 d_popi_attivita,d_popi_ore;
    exit  when posti%NOTFOUND;
    BEGIN
  select nvl(sequenza,999999),codice
    into d_setp_sequenza,d_setp_codice
    from settori
   where numero = d_popi_pianta
  ;
    END;
    BEGIN
  select nvl(s.sequenza,999999),s.codice,s.suddivisione,s.gestione,
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
  d_setg_codice := d_sett_codice;
  d_sett_settore_a   := d_popi_settore;
  d_seta_sequenza    := 0;
  d_seta_codice := d_sett_codice;
  d_sett_settore_b   := d_popi_settore;
  d_setb_sequenza    := 0;
  d_setb_codice := d_sett_codice;
  d_sett_settore_c   := d_popi_settore;
  d_setc_sequenza    := 0;
  d_setc_codice := d_sett_codice;
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
     d_seta_codice := d_sett_codice;
     d_sett_settore_b   := d_popi_settore;
     d_setb_sequenza    := 0;
     d_setb_codice := d_sett_codice;
     d_sett_settore_c   := d_popi_settore;
     d_setc_sequenza    := 0;
     d_setc_codice := d_sett_codice;
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
   d_setb_codice := d_sett_codice;
   d_sett_settore_c   := d_popi_settore;
   d_setc_sequenza    := 0;
   d_setc_codice := d_sett_codice;
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
     d_setc_codice := d_sett_codice;
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
   d_figi_qualifica,d_qugi_dal,d_qual_sequenza,d_qugi_codice,
   d_qugi_contratto,d_cost_dal,d_cont_sequenza,
   d_cost_ore_lavoro,d_qugi_livello,d_qugi_ruolo,
   d_ruol_sequenza,d_figi_profilo,d_prpr_sequenza,
   d_prpr_suddivisione_po,d_figi_posizione,d_pofu_sequenza
   from posizioni_funzionali     pf,
   profili_professionali    pr,
   ruoli     ru,
   contratti_storici   cs,
   contratti co,
   qualifiche_giuridiche    qg,
   qualifiche     qu,
   figure_giuridiche   fg,
   figure    fi
  where d_rior_data    between fg.dal
   and nvl(fg.al,to_date('3333333','j'))
    and d_rior_data    between qg.dal
   and nvl(qg.al,to_date('3333333','j'))
    and d_rior_data    between cs.dal
   and nvl(cs.al,to_date('3333333','j'))
    and pf.profilo (+) = fg.profilo
    and pf.codice  (+) = fg.posizione
    and pr.codice  (+) = fg.profilo
    and ru.codice = qg.ruolo
    and cs.contratto   = qg.contratto
    and co.codice = qg.contratto
    and qg.numero = fg.qualifica
    and qu.numero = fg.qualifica
    and fg.numero = d_popi_figura
    and fi.numero = d_popi_figura
 ;
    END;
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
--
--  Qualificazione del Posto.
--
    d_capo_previsti     := 0;
    d_capo_in_pianta    := 0;
    d_capo_in_deroga    := 0;
    d_capo_in_sovrannumero   := 0;
    d_capo_in_acquisizione   := 0;
    d_capo_in_rilascio  := 0;
    d_capo_in_istituzione    := 0;
    d_capo_ore_previsti := nvl(d_popi_ore,d_cost_ore_lavoro);
    if    d_popi_situazione = 'I' then
     d_capo_in_istituzione := 1;
    elsif d_popi_situazione = 'A' then
     d_capo_in_acquisizione     := 1;
    elsif d_popi_situazione = 'R' then
     d_capo_in_rilascio    := 1;
     d_capo_previsti  := 1;
    elsif d_popi_situazione = 'S' then
     d_capo_in_sovrannumero     := 1;
     d_capo_previsti  := 1;
    elsif d_popi_situazione = 'D' then
     d_capo_in_deroga := 1;
     d_capo_previsti  := 1;
    else
     d_capo_in_pianta := 1;
     d_capo_previsti  := 1;
    end if;
    d_capo_ass_ruolo_l1    := 0;
    d_capo_ore_ass_ruolo_l1     := 0;
    d_capo_ass_ruolo_l2    := 0;
    d_capo_ore_ass_ruolo_l2     := 0;
    d_capo_ass_ruolo_l3    := 0;
    d_capo_ore_ass_ruolo_l3     := 0;
    d_capo_ass_ruolo  := 0;
    d_capo_ore_ass_ruolo   := 0;
    d_capo_disponibili     := 0;
    d_capo_ore_disponibili := 0;
    d_capo_coperti_ruolo_1 := 0;
    d_capo_ore_coperti_ruolo_1  := 0;
    d_capo_coperti_ruolo_2 := 0;
    d_capo_ore_coperti_ruolo_2  := 0;
    d_capo_coperti_ruolo_3 := 0;
    d_capo_ore_coperti_ruolo_3  := 0;
    d_capo_coperti_ruolo   := 0;
    d_capo_ore_coperti_ruolo    := 0;
    d_capo_coperti_no_ruolo     := 0;
    d_capo_ore_coperti_no_ruolo := 0;
    d_capo_vacanti    := 0;
    d_capo_ore_vacanti     := 0;
    d_capo_vacanti_coperti := 0;
    d_capo_ore_vacanti_coperti  := 0;
    d_capo_vacanti_non_coperti  := 0;
    d_capo_ore_vacanti_non_coperti   := 0;
    d_capo_vacanti_non_ricopribili   := 0;
    d_capo_sost_titolari   := 0;
    d_capo_ore_sost_titolari    := 0;
--
--  Ricopribilita` del Posto.
--
    if d_popi_ricopribile = 'N' then
  if d_popi_situazione    = 'I'
  or d_popi_situazione    = 'A' then
     null;
  else
     d_capo_vacanti_non_ricopribili  := 1;
  end if;
    else
--
--  Copertura di Titolare.
--
 BEGIN
   select nvl(sum(nvl(pg.ore,d_capo_ore_previsti)),0)
    ,nvl(sum(decode(nvl(an.gruppo_ling,'I')
    ,substr(P_lingue,1,1)
    ,nvl(pg.ore,d_capo_ore_previsti)
    ,0
  )),0)
    ,nvl(sum(decode(nvl(an.gruppo_ling,'I')
    ,substr(P_lingue,2,1)
    ,nvl(pg.ore,d_capo_ore_previsti)
    ,0
  )),0)
    ,nvl(sum(decode(nvl(an.gruppo_ling,'I')
    ,substr(P_lingue,3,1)
    ,nvl(pg.ore,d_capo_ore_previsti)
    ,0
  )),0)
     into nOre,nOre_1,nOre_2,nOre_3
     from anagrafici an
    ,rapporti_individuali ri
    ,posizioni  po
    ,periodi_giuridici    pg
    where d_rior_data  between pg.dal
   and nvl(pg.al,to_date('3333333','j'))
 and pg.rilevanza  = 'Q'
 and pg.sede_posto = d_popi_sede_posto
 and pg.anno_posto = d_popi_anno_posto
 and pg.numero_posto    = d_popi_numero_posto
 and pg.posto = d_popi_posto
 and po.codice     = pg.posizione
 and po.ruolo = 'SI'
 and d_rior_data  between nvl(an.dal,to_date('2222222','j'))
  and nvl(an.al ,to_date('3333333','j'))
 and an.ni    = ri.ni
 and ri.ci    = pg.ci
 and not exists
     (select 1
   from periodi_giuridici p2
  where d_rior_data between p2.dal
     and nvl(p2.al,to_date('3333333','j'))
    and p2.ci  = pg.ci
    and (    p2.rilevanza = 'I'
    and p2.rowid    <> pg.rowid
    or  p2.rilevanza = 'A'
    and exists
   (select 1
 from astensioni aa
     where aa.codice  = p2.assenza
  and aa.sostituibile = 1
   )
   )
     )
   ;
 END;
 if nOre_1 <> 0 then
    d_capo_coperti_ruolo_1  := 1;
    d_capo_ore_coperti_ruolo_1   := nOre_1;
 end if;
 if nOre_2 <> 0 then
    d_capo_coperti_ruolo_2  := 1;
    d_capo_ore_coperti_ruolo_2   := nOre_2;
 end if;
 if nOre_3 <> 0 then
    d_capo_coperti_ruolo_3  := 1;
    d_capo_ore_coperti_ruolo_3   := nOre_3;
 end if;
 if nOre <> 0 then
    d_capo_coperti_ruolo    := 1;
    d_capo_ore_coperti_ruolo     := nOre;
 end if;
--
--  Copertura non di Titolare.
--
 BEGIN
   select nvl(sum(nvl(pg.ore,d_capo_ore_previsti)),0)
     into nOre
     from posizioni  po
    ,periodi_giuridici    pg
    where d_rior_data  between pg.dal
   and nvl(pg.al,to_date('3333333','j'))
 and (    pg.rilevanza  = 'Q'
 and nvl(po.ruolo,'NO')
   <> 'SI'
 or  pg.rilevanza  = 'I'
     )
 and pg.sede_posto = d_popi_sede_posto
 and pg.anno_posto = d_popi_anno_posto
 and pg.numero_posto    = d_popi_numero_posto
 and pg.posto = d_popi_posto
 and po.codice     = pg.posizione
 and not exists
     (select 1
   from periodi_giuridici p2
  where d_rior_data between p2.dal
     and nvl(p2.al,to_date('3333333','j'))
    and p2.ci  = pg.ci
    and (    p2.rilevanza = 'I'
    and p2.rowid    <> pg.rowid
    or  p2.rilevanza = 'A'
    and exists
   (select 1
 from astensioni aa
     where aa.codice  = p2.assenza
  and aa.sostituibile = 1
   )
   )
     )
   ;
 END;
 if nOre <> 0 then
    d_capo_coperti_no_ruolo := 1;
    d_capo_ore_coperti_no_ruolo  := nOre;
 end if;
--
-- Ore di Assegnazione di Titolari.
--
 BEGIN
   select nvl(sum(nvl(pg.ore,d_capo_ore_previsti)),0)
    ,nvl(sum(decode(nvl(an.gruppo_ling,'I')
    ,substr(P_lingue,1,1)
    ,nvl(pg.ore,d_capo_ore_previsti)
    ,0
  )),0)
    ,nvl(sum(decode(nvl(an.gruppo_ling,'I')
    ,substr(P_lingue,2,1)
    ,nvl(pg.ore,d_capo_ore_previsti)
    ,0
  )),0)
    ,nvl(sum(decode(nvl(an.gruppo_ling,'I')
    ,substr(P_lingue,3,1)
    ,nvl(pg.ore,d_capo_ore_previsti)
    ,0
  )),0)
     into nOre,nOre_1,nOre_2,nOre_3
     from posizioni   po
    ,rapporti_individuali  ri
    ,anagrafici  an
    ,periodi_giuridici     pg
    where d_rior_data   between pg.dal
   and nvl(pg.al,to_date('3333333','j'))
 and d_rior_data   between an.dal
   and nvl(an.al,to_date('3333333','j'))
 and an.ni     = ri.ni
 and ri.ci     = pg.ci
 and pg.rilevanza   = 'Q'
 and po.codice = pg.posizione
 and po.ruolo  = 'SI'
 and pg.sede_posto  = d_popi_sede_posto
 and pg.anno_posto  = d_popi_anno_posto
 and pg.numero_posto     = d_popi_numero_posto
 and pg.posto  = d_popi_posto
   ;
 END;
 if nOre_1 > 0 then
    d_capo_ore_ass_ruolo_l1  := nOre_1;
    d_capo_ass_ruolo_l1 := 1;
 end if;
 if nOre_2 > 0 then
    d_capo_ore_ass_ruolo_l2  := nOre_2;
    d_capo_ass_ruolo_l2 := 1;
 end if;
 if nOre_3 > 0 then
    d_capo_ore_ass_ruolo_l3  := nOre_3;
    d_capo_ass_ruolo_l3 := 1;
 end if;
 if nOre > 0 then
    d_capo_ore_ass_ruolo     := nOre;
    d_capo_ass_ruolo    := 1;
 end if;
--
--  Ore di Copertura o di Sostituzione di Titolari
--  ovvero con Sostituito Inquadrato in Ruolo.
--
 BEGIN
   select nvl(sum(nvl(pg.ore,d_capo_ore_previsti)),0)
     into nOre_3
     from posizioni    po
    ,periodi_giuridici p2
    ,periodi_giuridici pg
    where d_rior_data  between p2.dal
  and nvl(p2.al,to_date('3333333','j'))
 and d_rior_data  between pg.dal
  and nvl(pg.al,to_date('3333333','j'))
 and po.codice     = p2.posizione
 and po.ruolo = 'SI'
 and p2.rilevanza  = 'Q'
 and pg.rilevanza in ('Q','I')
 and pg.sede_posto = d_popi_sede_posto
 and pg.anno_posto = d_popi_anno_posto
 and pg.numero_posto    = d_popi_numero_posto
 and pg.posto = d_popi_posto
 and p2.sede_posto = pg.sede_posto
 and p2.anno_posto = pg.anno_posto
 and p2.numero_posto    = pg.numero_posto
 and p2.posto = pg.posto
 and p2.ci    = pg.sostituto
 and not exists
     (select 1
   from periodi_giuridici p3
  where d_rior_data between p3.dal
     and nvl(p3.al,to_date('3333333','j'))
    and p3.ci   = pg.ci
    and (    p3.rilevanza = 'I'
    and p3.rowid    <> pg.rowid
    or  p3.rilevanza = 'A'
    and exists
   (select 1
 from astensioni aa
     where aa.sostituibile = 1
  and aa.codice  = p3.assenza
   )
   )
     )
   ;
 END;
 if nOre_3 > 0 then
    d_capo_sost_titolari     := 1;
    d_capo_ore_sost_titolari := nOre_3;
 end if;
--
--  Disponibilita` = Ore Previsti - Ore di Copertura di Ruolo e N/Ruolo.
--
 BEGIN
   if (d_capo_ore_previsti - d_capo_ore_coperti_ruolo
  - d_capo_ore_coperti_no_ruolo) <> 0 then
 d_capo_disponibili  := 1;
 d_capo_ore_disponibili   := d_capo_ore_previsti -
    d_capo_ore_coperti_ruolo -
    d_capo_ore_coperti_no_ruolo;
   end if;
 END;
--
--  Ore Vacanti = Ore Posto - Ore Assegnate a Titolari.
--
 BEGIN
   if (d_capo_ore_previsti - d_capo_ore_ass_ruolo) > 0 then
 d_capo_ore_vacanti     := d_capo_ore_previsti -
  d_capo_ore_ass_ruolo;
 d_capo_vacanti    := 1;
   end if;
 END;
--
--  Vacanti Coperti ovvero Coperture Non di Ruolo che non sono
--  Sostituzioni di Titolari.
--
 BEGIN
   select nvl(sum(nvl(pg.ore,d_capo_ore_previsti)),0)
     into nOre_3
     from posizioni    po
    ,periodi_giuridici pg
    where d_rior_data  between pg.dal
  and nvl(pg.al,to_date('3333333','j'))
 and po.codice     = pg.posizione
 and (    pg.rilevanza  = 'Q'
 and nvl(po.ruolo,'NO')
   <> 'SI'
 or  pg.rilevanza  = 'I'
     )
 and (    nvl(pg.sostituto,pg.ci)
    = pg.ci
 or  not exists
     (select 1
   from periodi_giuridici p3
  where d_rior_data between p3.dal and
     nvl(p3.al,to_date('3333333','j'))
    and p3.posizione   in (select ps.codice
    from posizioni ps
   where ps.ruolo = 'SI'
 )
    and p3.rilevanza    = 'Q'
    and p3.ci = pg.sostituto
    and p3.sede_posto   = d_popi_sede_posto
    and p3.anno_posto   = d_popi_anno_posto
    and p3.numero_posto = d_popi_numero_posto
    and p3.posto   = d_popi_posto
     )
     )
 and pg.sede_posto = d_popi_sede_posto
 and pg.anno_posto = d_popi_anno_posto
 and pg.numero_posto    = d_popi_numero_posto
 and pg.posto = d_popi_posto
 and not exists
     (select 1
   from periodi_giuridici p3
  where d_rior_data between p3.dal
     and nvl(p3.al,to_date('3333333','j'))
    and p3.ci   = pg.ci
    and (    p3.rilevanza = 'I'
    and p3.rowid    <> pg.rowid
    or  p3.rilevanza = 'A'
    and exists
   (select 1
 from astensioni aa
     where aa.sostituibile = 1
  and aa.codice  = p3.assenza
   )
   )
     )
   ;
 END;
 if nOre_3 > 0 then
    d_capo_vacanti_coperti := 1;
    d_capo_ore_vacanti_coperti  := nOre_3;
 end if;
--
--  Se le Ore di Sostituzione di Titolari superano le Ore di Assegnazione
--  dei medesimi, la differenza va ad incrementare i Vacanti Coperti.
--
     if (d_capo_ore_coperti_ruolo + d_capo_ore_sost_titolari) >
   d_capo_ore_ass_ruolo then
   d_capo_ore_vacanti_coperti := d_capo_ore_vacanti_coperti +
   d_capo_ore_coperti_ruolo   +
   d_capo_ore_sost_titolari   -
   d_capo_ore_ass_ruolo;
     end if;
     if d_capo_ore_vacanti_coperti  > 0 then
   d_capo_vacanti_coperti := 1;
     end if;
--
--  Vacanti Non Coperti ovvero Vacanti - Vacanti Coperti.
--  Se i Vacanti Coperti superano i Vacanti, si pongono
--  i Vacanti Coperti = ai Vacanti ed i Vacanti Non Coperti = zero.
--
 BEGIN
   if (d_capo_ore_vacanti - d_capo_ore_vacanti_coperti) < 0 then
 d_capo_ore_vacanti_coperti := d_capo_ore_vacanti;
 if d_capo_ore_vacanti_coperti = 0 then
    d_capo_vacanti_coperti  := 0;
 end if;
   elsif (d_capo_ore_vacanti - d_capo_ore_vacanti_coperti) > 0 then
 d_capo_vacanti_non_coperti := 1;
 d_capo_ore_vacanti_non_coperti  := d_capo_ore_vacanti -
 d_capo_ore_vacanti_coperti;
   end if;
 END;
    end if;
--
--  Inserimento Registrazione Posto.
--
    BEGIN
 insert into calcolo_posti
 (capo_prenotazione,capo_rilevanza,capo_lingue,
  rior_data,popi_sede_posto,
  popi_anno_posto,popi_numero_posto,popi_posto,popi_dal,
  popi_ricopribile,popi_gruppo,
  popi_pianta,setp_sequenza,setp_codice,popi_settore,
  sett_sequenza,sett_codice,sett_suddivisione,sett_settore_g,
  setg_sequenza,setg_codice,sett_settore_a,seta_sequenza,
  seta_codice,sett_settore_b,setb_sequenza,setb_codice,
  sett_settore_c,setc_sequenza,setc_codice,sett_gestione,
  gest_prospetto_po,gest_sintetico_po,
  popi_figura,figi_dal,figu_sequenza,figi_codice,figi_qualifica,
  qugi_dal,qual_sequenza,qugi_codice,qugi_contratto,cost_dal,
  cont_sequenza,cost_ore_lavoro,qugi_livello,figi_profilo,
  prpr_sequenza,prpr_suddivisione_po,figi_posizione,pofu_sequenza,
  qugi_ruolo,ruol_sequenza,popi_attivita,atti_sequenza,
  pegi_posizione,posi_sequenza,pegi_tipo_rapporto,
  capo_previsti,capo_ore_previsti,capo_in_pianta,capo_in_deroga,
  capo_in_sovrannumero,capo_in_rilascio,capo_in_acquisizione,
  capo_in_istituzione,capo_assegnazioni_ruolo_l1,
  capo_ore_assegnazioni_ruolo_l1,capo_assegnazioni_ruolo_l2,
  capo_ore_assegnazioni_ruolo_l2,capo_assegnazioni_ruolo_l3,
  capo_ore_assegnazioni_ruolo_l3,capo_assegnazioni_ruolo,
  capo_ore_assegnazioni_ruolo,
  capo_assegnazioni,capo_ore_assegnazioni,
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
 values
 (P_prenotazione,1,P_lingue,d_rior_data,d_popi_sede_posto,
  d_popi_anno_posto,d_popi_numero_posto,d_popi_posto,d_popi_dal,
  d_popi_ricopribile,d_popi_gruppo,d_popi_pianta,
  d_setp_sequenza,d_setp_codice,d_popi_settore,
  d_sett_sequenza,d_sett_codice,
  d_sett_suddivisione,d_sett_settore_g,
  d_setg_sequenza,d_setg_codice,d_sett_settore_a,d_seta_sequenza,
  d_seta_codice,d_sett_settore_b,d_setb_sequenza,d_setb_codice,
  d_sett_settore_c,d_setc_sequenza,d_setc_codice,
  d_sett_gestione,d_gest_prospetto_po,d_gest_sintetico_po,
  d_popi_figura,d_figi_dal,
  d_figu_sequenza,d_figi_codice,d_figi_qualifica,
  d_qugi_dal,d_qual_sequenza,d_qugi_codice,
  d_qugi_contratto,d_cost_dal,
  d_cont_sequenza,d_cost_ore_lavoro,d_qugi_livello,d_figi_profilo,
  d_prpr_sequenza,d_prpr_suddivisione_po,
  d_figi_posizione,d_pofu_sequenza,
  d_qugi_ruolo,d_ruol_sequenza,d_popi_attivita,d_atti_sequenza,
  null,0,null,
  d_capo_previsti,d_capo_ore_previsti,
  d_capo_in_pianta,d_capo_in_deroga,
  d_capo_in_sovrannumero,d_capo_in_rilascio,d_capo_in_acquisizione,
  d_capo_in_istituzione,
  d_capo_ass_ruolo_l1,d_capo_ore_ass_ruolo_l1,
  d_capo_ass_ruolo_l2,d_capo_ore_ass_ruolo_l2,
  d_capo_ass_ruolo_l3,d_capo_ore_ass_ruolo_l3,
  d_capo_ass_ruolo,d_capo_ore_ass_ruolo,
  0,0,0,0,d_capo_disponibili,
  d_capo_ore_disponibili,d_capo_coperti_ruolo_1,
  d_capo_ore_coperti_ruolo_1,d_capo_coperti_ruolo_2,
  d_capo_ore_coperti_ruolo_2,d_capo_coperti_ruolo_3,
  d_capo_ore_coperti_ruolo_3,d_capo_coperti_ruolo,
  d_capo_ore_coperti_ruolo,d_capo_coperti_no_ruolo,
  d_capo_ore_coperti_no_ruolo,d_capo_vacanti,
  d_capo_ore_vacanti,d_capo_vacanti_coperti,
  d_capo_ore_vacanti_coperti,d_capo_vacanti_non_coperti,
  d_capo_ore_vacanti_non_coperti,d_capo_vacanti_non_ricopribili
  )
 ;
    END;
    open assegnazioni;
    LOOP
--
--  Assegnazioni su Posto per Posizione e Tipo di Rapporto.
--
 fetch assegnazioni into d_capo_ore_assegnazioni,
     d_capo_assegnazioni,
     d_pegi_posizione,d_posi_sequenza,
     d_pegi_tipo_rapporto;
 exit  when assegnazioni%NOTFOUND;
 if d_capo_ore_assegnazioni is null then
    d_capo_ore_assegnazioni := d_capo_ore_previsti;
 end if;
--
--  Assenze su Posto per Posizione e Tipo Rapporto
--  distinte per Rilevanza.
--
 BEGIN
   select nvl(sum(decode(p2.rilevanza,'I',1,0)),0)
    ,nvl(sum(decode(p2.rilevanza,'A',1,0)),0)
     into d_capo_assenze_incarico
    ,d_capo_assenze_assenza
     from posizioni    pa
    ,posizioni    po
    ,periodi_giuridici p2
    ,periodi_giuridici pg
    where d_rior_data  between pg.dal
   and nvl(pg.al,to_date('3333333','j'))
 and d_rior_data  between p2.dal
   and nvl(p2.al,to_date('3333333','j'))
 and pg.sede_posto = d_popi_sede_posto
 and pg.anno_posto = d_popi_anno_posto
 and pg.numero_posto    = d_popi_numero_posto
 and pg.posto = d_popi_posto
 and pg.rilevanza in ('Q','I')
 and pa.codice     = pg.posizione
 and po.codice     = pa.posizione
 and p2.ci    = pg.ci
 and (    p2.rilevanza  = 'I'
 and p2.rowid     <> pg.rowid
 or  p2.rilevanza  = 'A'
 and exists
     (select 1
   from astensioni aa
  where aa.sostituibile = 1
    and aa.codice  = p2.assenza
     )
 and not exists
     (select 1
   from periodi_giuridici p3
  where d_rior_data between p3.dal and
     nvl(p3.al,to_date('3333333','j'))
    and p3.rowid    <> pg.rowid
    and p3.rilevanza = 'I'
    and p3.ci   = pg.ci
     )
     )
 and pg.posizione    = d_pegi_posizione
 and nvl(pg.tipo_rapporto,' ') = nvl(d_pegi_tipo_rapporto,' ')
 and nvl(pg.ore,d_capo_ore_previsti)
 = d_capo_ore_assegnazioni
   ;
 END;
--
--  Inserimento Registrazione Assegnazioni e Assenze.
--
 BEGIN
    insert into calcolo_posti
    (capo_prenotazione,capo_rilevanza,capo_lingue,
     rior_data,popi_sede_posto,
     popi_anno_posto,popi_numero_posto,popi_posto,popi_dal,
     popi_ricopribile,popi_gruppo,
     popi_pianta,setp_sequenza,setp_codice,popi_settore,
     sett_sequenza,sett_codice,sett_suddivisione,sett_settore_g,
     setg_sequenza,setg_codice,sett_settore_a,seta_sequenza,
     seta_codice,sett_settore_b,setb_sequenza,setb_codice,
     sett_settore_c,setc_sequenza,setc_codice,sett_gestione,
     gest_prospetto_po,gest_sintetico_po,
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
     capo_ore_assegnazioni_ruolo,
     capo_assegnazioni,capo_ore_assegnazioni,
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
    values
    (P_prenotazione,2,P_lingue,
     d_rior_data,d_popi_sede_posto,
     d_popi_anno_posto,d_popi_numero_posto,d_popi_posto,d_popi_dal,
     d_popi_ricopribile,d_popi_gruppo,d_popi_pianta,
     d_setp_sequenza,d_setp_codice,d_popi_settore,
     d_sett_sequenza,d_sett_codice,
     d_sett_suddivisione,d_sett_settore_g,
     d_setg_sequenza,d_setg_codice,d_sett_settore_a,d_seta_sequenza,
     d_seta_codice,d_sett_settore_b,d_setb_sequenza,d_setb_codice,
     d_sett_settore_c,d_setc_sequenza,d_setc_codice,
     d_sett_gestione,d_gest_prospetto_po,d_gest_sintetico_po,
     d_popi_figura,d_figi_dal,
     d_figu_sequenza,d_figi_codice,d_figi_qualifica,
     d_qugi_dal,d_qual_sequenza,d_qugi_codice,
     d_qugi_contratto,d_cost_dal,
     d_cont_sequenza,d_cost_ore_lavoro,d_qugi_livello,
     d_figi_profilo,d_prpr_sequenza,d_prpr_suddivisione_po,
     d_figi_posizione,d_pofu_sequenza,
     d_qugi_ruolo,d_ruol_sequenza,d_popi_attivita,d_atti_sequenza,
     d_pegi_posizione,d_posi_sequenza,d_pegi_tipo_rapporto,
     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     d_capo_assegnazioni,d_capo_ore_assegnazioni,
     d_capo_assenze_incarico,d_capo_assenze_assenza,
     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     )
    ;
 END;
    END LOOP;
    close assegnazioni;
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
END;
/

