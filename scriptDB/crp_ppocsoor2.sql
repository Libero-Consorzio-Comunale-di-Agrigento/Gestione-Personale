CREATE OR REPLACE PACKAGE ppocsoor2 IS
/******************************************************************************
 NOME:          PPOCSOOR2
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
  PROCEDURE DEL_DETT_POSTI (w_PRENOTAZIONE IN NUMBER, W_VOCE_MENU IN VARCHAR2);
  PROCEDURE DELETE_TAB (w_PRENOTAZIONE IN NUMBER, W_VOCE_MENU IN VARCHAR2);
  PROCEDURE CC_DOTAZIONE (P_D_F in varchar2, P_USO_INTERNO in varchar2,
				P_PRENOTAZIONE in number, p_lingue in varchar2, p_voce_menu in varchar2);
END;
/
CREATE OR REPLACE PACKAGE BODY ppocsoor2 IS
form_trigger_failure	exception;
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
      PROCEDURE DEL_DETT_POSTI (w_PRENOTAZIONE IN NUMBER, W_VOCE_MENU IN VARCHAR2)IS
      D_ERRTEXT VARCHAR2(240);
      D_PRENOTAZIONE NUMBER(6);
      BEGIN
         DELETE FROM CALCOLO_DOTAZIONE
          WHERE CADO_PRENOTAZIONE    = w_PRENOTAZIONE
            AND CADO_RILEVANZA       < 6
         ;
      EXCEPTION
        WHEN OTHERS THEN
          D_ERRTEXT := SUBSTR(SQLERRM,1,240);
          D_PRENOTAZIONE := w_PRENOTAZIONE;
          ROLLBACK;
          INSERT INTO ERRORI_POGM (PRENOTAZIONE,VOCE_MENU,DATA,ERRORE)
          VALUES (D_PRENOTAZIONE,w_VOCE_MENU ,SYSDATE,D_ERRTEXT)
          ;
          COMMIT;
          RAISE FORM_TRIGGER_FAILURE;
      END;
      PROCEDURE DELETE_TAB (w_PRENOTAZIONE IN NUMBER, W_VOCE_MENU IN VARCHAR2) IS
      D_ERRTEXT VARCHAR2(240);
      D_PRENOTAZIONE NUMBER(6);
      BEGIN
        DELETE FROM CALCOLO_DOTAZIONE
         WHERE CADO_PRENOTAZIONE = W_PRENOTAZIONE;
        DELETE FROM CALCOLO_NOMINATIVO_DOTAZIONE
         WHERE CNDO_PRENOTAZIONE = W_PRENOTAZIONE;
      EXCEPTION
        WHEN OTHERS THEN
          D_ERRTEXT := SUBSTR(SQLERRM,1,240);
          D_PRENOTAZIONE := W_PRENOTAZIONE;
          ROLLBACK;
          INSERT INTO ERRORI_POGM (PRENOTAZIONE,VOCE_MENU,DATA,ERRORE)
          VALUES (D_PRENOTAZIONE,w_VOCE_MENU ,SYSDATE,D_ERRTEXT)
          ;
          COMMIT;
          RAISE FORM_TRIGGER_FAILURE;
      END;
  PROCEDURE CC_DOTAZIONE (P_D_F in varchar2, P_USO_INTERNO in varchar2,
		P_PRENOTAZIONE in number, p_lingue in varchar2, p_voce_menu in varchar2 )is
	d_errtext                       VARCHAR2(240);
d_prenotazione                   number(6);
d_rior_data                        date;
d_popi_sede_posto               VARCHAR2(2);
d_popi_anno_posto                number(4);
d_popi_numero_posto              number(7);
d_popi_posto                     number(5);
d_popi_dal                         date;
d_popi_stato                    VARCHAR2(1);
d_popi_situazione               VARCHAR2(1);
d_popi_ricopribile              VARCHAR2(1);
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
d_ruol_sequenza                  number(4);
d_popi_attivita                 VARCHAR2(4);
d_atti_sequenza                  number(6);
d_popi_ore                       number(5,2);
d_pegi_posizione                VARCHAR2(4);
d_posi_sequenza                  number(3);
d_posi_di_ruolo                  number(1);
d_pegi_tipo_rapporto            VARCHAR2(2);
d_pegi_ore                       number(5,2);
d_cado_previsti                  number(5);
d_cado_ore_previsti              number(5,2);
d_cado_in_pianta                 number(5);
d_cado_in_deroga                 number(5);
d_cado_in_sovrannumero           number(5);
d_cado_in_rilascio               number(5);
d_cado_in_istituzione            number(5);
d_cado_in_acquisizione           number(5);
d_cado_ass_ruolo_l1              number(5);
d_cado_ore_ass_ruolo_l1          number(5,2);
d_cado_ass_ruolo_l2              number(5);
d_cado_ore_ass_ruolo_l2          number(5,2);
d_cado_ass_ruolo_l3              number(5);
d_cado_ore_ass_ruolo_l3          number(5,2);
d_cado_ass_ruolo                 number(5);
d_cado_ore_ass_ruolo             number(5,2);
d_cado_assegnazioni              number(5);
d_cado_ore_assegnazioni          number(5,2);
d_cado_assenze_incarico          number(5);
d_cado_assenze_assenza           number(5);
d_cado_disponibili               number(5);
d_cado_ore_disponibili           number(5,2);
d_cado_coperti_ruolo_1           number(5);
d_cado_ore_coperti_ruolo_1       number(5,2);
d_cado_coperti_ruolo_2           number(5);
d_cado_ore_coperti_ruolo_2       number(5,2);
d_cado_coperti_ruolo_3           number(5);
d_cado_ore_coperti_ruolo_3       number(5,2);
d_cado_coperti_ruolo             number(5);
d_cado_ore_coperti_ruolo         number(5,2);
d_cado_coperti_no_ruolo          number(5);
d_cado_ore_coperti_no_ruolo      number(5,2);
d_cado_vacanti                   number(5);
d_cado_ore_vacanti               number(5,2);
d_cado_vacanti_coperti           number(5);
d_cado_ore_vacanti_coperti       number(5,2);
d_cado_vacanti_non_coperti       number(5);
d_cado_ore_vacanti_non_coperti   number(5,2);
d_cado_vacanti_non_ricopribili   number(5);
d_cado_dotazioni_ruolo           number(5);
d_cado_ore_dotazioni_ruolo       number(5,2);
d_cado_dotazioni_no_ruolo        number(5);
d_cado_ore_dotazioni_no_ruolo    number(5,2);
nOre                             number(5,2);
nOre_1                           number(5,2);
nOre_2                           number(5,2);
nOre_3                           number(5,2);
cursor dotazioni is
select pg.ore
      ,decode(po.ruolo
             ,'SI',decode(pg.rilevanza
                         ,'Q',1
                         ,'S',1
                             ,0
                         )
                  ,0
             )
      ,decode(po.ruolo
             ,'SI',decode(pg.rilevanza
                         ,'Q',0
                         ,'S',0
                             ,1
                         )
                  ,1
             )
      ,pg.posizione
      ,nvl(po.sequenza,999)
      ,pg.tipo_rapporto
      ,pg.figura
      ,pg.qualifica
      ,pg.attivita
      ,pg.settore
      ,pg.sede_posto
      ,pg.anno_posto
      ,pg.numero_posto
      ,pg.posto
  from posizioni         pa
      ,posizioni         po
      ,periodi_giuridici pg
 where d_rior_data       between pg.dal
                         and nvl(pg.al,to_date('3333333','j'))
   and (    pg.rilevanza      in ('Q','I')
        and P_d_f           = 'D'
        and P_uso_interno   = 'X'
        or  pg.rilevanza      in ('S','E')
        and P_d_f           = 'F'
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
   and pa.codice               = pg.posizione
   and po.codice               = pa.posizione
;
BEGIN
  BEGIN
     select data
       into d_rior_data
       from riferimento_organico
     ;
  END;
  open dotazioni;
  LOOP
    fetch dotazioni into d_pegi_ore,
                    d_cado_dotazioni_ruolo,d_cado_dotazioni_no_ruolo,
                    d_pegi_posizione,d_posi_sequenza,
                    d_pegi_tipo_rapporto,
                    d_popi_figura,d_figi_qualifica,
                    d_popi_attivita,d_popi_settore,
                    d_popi_sede_posto,d_popi_anno_posto,
                    d_popi_numero_posto,d_popi_posto;
    exit  when dotazioni%NOTFOUND;
    d_popi_dal             := null;
    d_popi_stato           := null;
    d_popi_situazione      := null;
    d_popi_ricopribile     := null;
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
                ,stato
                ,situazione
                ,disponibilita
                ,gruppo
                ,pianta
                ,ore
            into d_popi_dal
                ,d_popi_stato
                ,d_popi_situazione
                ,d_popi_ricopribile
                ,d_popi_gruppo
                ,d_popi_pianta
                ,d_popi_ore
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
    if P_d_f = 'D' then
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
   if P_d_f = 'F' then
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
--
    d_cado_ore_previsti :=
    nvl(d_pegi_ore,nvl(d_popi_ore,d_cost_ore_lavoro));
    if d_cado_dotazioni_ruolo > 0 then
       d_cado_ore_dotazioni_ruolo := d_cado_ore_previsti;
    end if;
    if d_cado_dotazioni_no_ruolo > 0 then
       d_cado_ore_dotazioni_no_ruolo := d_cado_ore_previsti;
    end if;
--
--  Inserimento Registrazione Dotazione.
--
    BEGIN
       if d_cado_dotazioni_ruolo + d_cado_dotazioni_no_ruolo > 0 then
         insert into calcolo_dotazione
         (cado_prenotazione,cado_rilevanza,cado_lingue,
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
          cado_previsti,cado_ore_previsti,cado_in_pianta,cado_in_deroga,
          cado_in_sovrannumero,cado_in_rilascio,cado_in_acquisizione,
          cado_in_istituzione,
          cado_assegnazioni_ruolo,cado_ore_assegnazioni_ruolo,
          cado_vacanti,cado_ore_vacanti,cado_vacanti_coperti,
          cado_ore_vacanti_coperti,cado_coperti_ruolo,
          cado_ore_coperti_ruolo,cado_coperti_no_ruolo,
          cado_ore_coperti_no_ruolo)
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
          d_cont_sequenza,d_cost_ore_lavoro,
          d_qugi_livello,d_figi_profilo,
          d_prpr_sequenza,d_prpr_suddivisione_po,
          d_figi_posizione,d_pofu_sequenza,
          d_qugi_ruolo,d_ruol_sequenza,d_popi_attivita,d_atti_sequenza,
          null,0,null,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,
          d_cado_dotazioni_ruolo,d_cado_ore_dotazioni_ruolo,
          d_cado_dotazioni_no_ruolo,d_cado_ore_dotazioni_no_ruolo)
         ;
      end if;
    END;
  END LOOP;
  close dotazioni;
EXCEPTION
  WHEN OTHERS THEN
    d_errtext := substr(SQLERRM,1,240);
    d_prenotazione := P_prenotazione;
    ROLLBACK;
    insert into errori_pogm (prenotazione,voce_menu,data,errore)
    values (d_prenotazione,P_VOCE_MENU,sysdate,d_errtext)
    ;
    COMMIT;
    RAISE;
END;
END;
/

