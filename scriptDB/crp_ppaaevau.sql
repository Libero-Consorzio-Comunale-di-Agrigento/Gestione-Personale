CREATE OR REPLACE PACKAGE ppaaevau IS
/******************************************************************************
 NOME:          PPAAEVAU
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000 
 2	09/09/2004	MV	A7024            
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
   dep_anno			  number(4);
   dep_mese			  number(2);					  
   dep_ini_mes		  date;
   dep_fin_mes		  date;
   errore_in_elaborazione exception;
   w_errore			  varchar2(50);
   p_giuridica		  varchar2(10);
   a_ambiente		  varchar2(10);
   a_ente			  varchar2(10);
   a_utente			  varchar2(20);
   
PROCEDURE MAIN      (P_PRENOTAZIONE IN NUMBER,
                  passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY ppaaevau IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V2.0 del 09/09/2004';
 END VERSIONE;
PROCEDURE INSERISCE_EVENTI_A (P_CONTA IN OUT NUMBER) IS
cursor aupa is
select  'AUPA'
       ,pspa.ci
       ,greatest(pspa.dal,nvl(aupa.dal,to_date('2222222','j')),
                 to_date('0101'||to_char(dep_ini_mes,'yyyy'),
                 'ddmmyyyy')
                )
       ,least   (nvl(pspa.al,to_date('3333333','j')),
                 nvl(aupa.al,to_date('3333333','j')),
                 to_date('3112'||to_char(dep_fin_mes,'yyyy'),
                 'ddmmyyyy')
                )
       ,aupa.causale
       ,aupa.motivo
       ,nvl(rapa.cdc,rifu.cdc)
       ,aupa.cdc
       ,pspa.sede
       ,aupa.sede
       ,pspa.gg_set
       ,aupa.gg_set
       ,pspa.min_gg
       ,aupa.min_gg
       ,pspa.ore
       ,aupa.ore
       ,aupa.condizione
       ,aupa.stato_condizione
       ,aupa.attribuzione
       ,aupa.specie
       ,aupa.quantita
       ,caev.qualificazione
       ,caev.assenza
       ,nvl(rapa.fattore_produttivo,decode(pegi.tipo_rapporto
                                          ,'TD',qual.fattore_td
                                               ,qual.fattore
                                          )
           )
       ,aupa.fattore_produttivo
       ,sett.gestione
       ,aupa.gestione
       ,pspa.settore
       ,aupa.settore
       ,rifu.funzionale
       ,aupa.funzionale
       ,pegi.posizione
       ,aupa.posizione
       ,qugi.ruolo
       ,aupa.ruolo
       ,pspa.figura
       ,aupa.figura
       ,pegi.attivita
       ,aupa.attivita
       ,pspa.contratto
       ,aupa.contratto
       ,pspa.qualifica
       ,aupa.qualifica
       ,qugi.livello
       ,aupa.livello
       ,pegi.tipo_rapporto
       ,aupa.tipo_rapporto
       ,nvl(rapa.assistenza,trpr.assistenza)
       ,aupa.assistenza
       ,rapa.ufficio
       ,aupa.ufficio
  from  trattamenti_previdenziali  trpr
       ,trattamenti_contabili      trco
       ,rapporti_retributivi       rare
       ,rapporti_individuali       rain
       ,ripartizioni_funzionali    rifu
       ,settori                    sett
       ,qualifiche_giuridiche      qugi
       ,qualifiche                 qual
       ,causali_evento             caev
       ,periodi_giuridici          pegi
       ,rapporti_presenza          rapa
       ,periodi_servizio_presenza  pspa
       ,automatismi_presenza       aupa
 where  dep_fin_mes  between nvl(aupa.dal
                                           ,to_date('2222222','j')
                                           )
                                    and nvl(aupa.al
                                           ,to_date('3333333','j')
                                           )
   and  nvl(pspa.dal,to_date('2222222','j'))
                                     <=
        to_date('3112'||to_char(dep_fin_mes,'yyyy')
               ,'ddmmyyyy')
   and  nvl(pspa.al ,to_date('3333333','j'))
                                     >=
        to_date('0101'||to_char(dep_ini_mes,'yyyy')
               ,'ddmmyyyy')
   and  rapa.ci                       = pspa.ci
   and  rapa.dal                      = pspa.dal_rapporto
   and  (    rapa.automatismo         = aupa.automatismo
         or  aupa.automatismo        is null
        )
   and  aupa.attribuzione             = 'A'
   and  aupa.attivo                   = 'SI'
   and  nvl(aupa.quantita,0)         != 0
   and  pegi.ci                   (+) = pspa.ci
   and  pegi.rilevanza            (+) = pspa.rilevanza
   and  pegi.dal                  (+) = pspa.dal_periodo
   and  qual.numero               (+) = pspa.qualifica
   and  qugi.numero               (+) = pspa.qualifica
   and  qugi.dal                  (+) = pspa.dal_qualifica
   and  sett.numero               (+) = pspa.settore
   and  rifu.settore              (+) = pspa.settore
   and  rifu.sede                 (+) = nvl(pspa.sede_cdc,0)
   and  rare.ci                   (+) = pspa.ci
   and  trco.profilo_professionale
                                  (+) = pspa.profilo_professionale
   and  trco.posizione            (+) = pspa.posizione
   and  trpr.codice               (+) = trco.trattamento
   and  nvl(rare.tipo_trattamento,0)  = trco.tipo_trattamento         
   and  caev.codice                   = aupa.causale
   and  rain.ci                       = pspa.ci
   and  not exists
        (select 'x'
           from eventi_automatici_presenza eapa
          where nvl(eapa.al ,to_date('3333333','j'))
                                     >=
                greatest(pspa.dal,nvl(aupa.dal,to_date('2222222','j'))
                        ,to_date('0101'||to_char(dep_ini_mes,
                         'yyyy'),'ddmmyyyy')
                        )
            and nvl(eapa.dal,to_date('2222222','j'))
                                     <=
                least(nvl(pspa.al,to_date('3333333','j'))
                     ,nvl(aupa.al,to_date('3333333','j'))
                        ,to_date('3112'||to_char(dep_fin_mes,
                         'yyyy'),'ddmmyyyy')
                     )
            and eapa.causale          = aupa.causale
            and nvl(eapa.motivo,' ')  = nvl(aupa.motivo,' ')
            and eapa.ci               = pspa.ci
        )
   and  (    caev.riferimento        != 'G'
         or  caev.riferimento         = 'G'
         and not exists
             (select 'x'
                from eventi_presenza  evpa
               where nvl(evpa.dal,to_date('2222222','j'))
                                     <=
                     nvl(aupa.al ,to_date('3333333','j'))
                 and nvl(evpa.al ,to_date('3333333','j'))
                                     >=
                     nvl(aupa.dal,to_date('2222222','j'))
                 and evpa.causale     = aupa.causale
                 and nvl(evpa.motivo,' ')
                                      = nvl(aupa.motivo,' ')
                 and evpa.ci          = pspa.ci
                 and exists
                     (select 'x'
                        from causali_evento cae2
                       where cae2.codice
                                      = evpa.causale
                         and cae2.riferimento
                                      = 'G'
                     )
             )
        )
   and  (    rain.cc                 is null
         or  rain.cc                 is not null
         and exists
             (select 'x'
                from a_competenze comp
               where comp.competenza  = 'CI'
                 and comp.oggetto     = rain.cc
                 and comp.ambiente    = a_ambiente
                 and comp.utente      = a_utente
                 and comp.ente        = a_ente
             )
        )
   and  exists
        (select 'x'
           from classi_rapporto clra
          where clra.codice           = rain.rapporto
            and clra.presenza         = 'SI'
        )
   and  (    pspa.ufficio            is null
         or  pspa.ufficio            is not null
         and exists
             (select 'x'
                from a_competenze comp
               where comp.oggetto     = 'UFFICIO_PRESENZA'
                 and comp.competenza  = pspa.ufficio
                 and comp.ambiente    = a_ambiente
                 and comp.utente      = a_utente
                 and comp.ente        = a_ente
             )
        )
 order  by
        pspa.ci
       ,aupa.causale
       ,aupa.motivo
       ,pspa.dal
;
cursor  eapa  is
select  'EAPA'
       ,pspa.ci
       ,greatest(pspa.dal,nvl(eapa.dal,to_date('2222222','j')),
                 to_date('0101'||to_char(dep_ini_mes,'yyyy'),
                         'ddmmyyyy')
                )
       ,least   (nvl(pspa.al,to_date('3333333','j')),
                 nvl(eapa.al,to_date('3333333','j')),
                 to_date('3112'||to_char(dep_fin_mes,'yyyy'),
                         'ddmmyyyy')
                )
       ,eapa.causale
       ,eapa.motivo
       ,eapa.cdc
       ,eapa.sede
       ,pspa.gg_set
       ,pspa.min_gg
       ,eapa.condizione
       ,eapa.stato_condizione
       ,eapa.attribuzione
       ,eapa.specie
       ,eapa.quantita
       ,caev.qualificazione
       ,caev.assenza
  from  rapporti_individuali       rain
       ,causali_evento             caev
       ,periodi_servizio_presenza  pspa
       ,eventi_automatici_presenza eapa
 where  dep_fin_mes  between nvl(eapa.dal
                                           ,to_date('2222222','j')
                                           )
                                    and nvl(eapa.al
                                           ,to_date('3333333','j')
                                           )
   and  nvl(pspa.dal,to_date('2222222','j'))
                                     <=
        to_date('3112'||to_char(dep_fin_mes,'yyyy')
               ,'ddmmyyyy')
   and  nvl(pspa.al ,to_date('3333333','j'))
                                     >=
        to_date('0101'||to_char(dep_ini_mes,'yyyy')
               ,'ddmmyyyy')
   and  eapa.attivo                   = 'SI'
   and  eapa.attribuzione             = 'A'
   and  eapa.ci                       = pspa.ci
   and  nvl(eapa.quantita,0)         != 0
   and  caev.codice                   = eapa.causale
   and  rain.ci                       = pspa.ci
   and  (    caev.riferimento        != 'G'
         or  caev.riferimento         = 'G'
         and not exists
             (select 'x'
                from eventi_presenza  evpa
               where nvl(evpa.dal,to_date('2222222','j'))
                                     <=
                     nvl(eapa.al ,to_date('3333333','j'))
                 and nvl(evpa.al ,to_date('3333333','j'))
                                     >=
                     nvl(eapa.dal,to_date('2222222','j'))
                 and evpa.causale     = eapa.causale
                 and nvl(evpa.motivo,' ')
                                      = nvl(eapa.motivo,' ')
                 and evpa.ci          = pspa.ci
                 and exists
                     (select 'x'
                        from causali_evento cae2
                       where cae2.codice
                                      = evpa.causale
                         and cae2.riferimento
                                      = 'G'
                     )
             )
        )
   and  (    rain.cc                 is null
         or  rain.cc                 is not null
         and exists
             (select 'x'
                from a_competenze comp
               where comp.competenza  = 'CI'
                 and comp.oggetto     = rain.cc
                 and comp.ambiente    = a_ambiente
                 and comp.utente      = a_utente
                 and comp.ente        = a_ente
             )
        )
   and  exists
        (select 'x'
           from classi_rapporto clra
          where clra.codice           = rain.rapporto
            and clra.presenza         = 'SI'
        )
   and  (    pspa.ufficio            is null
         or  pspa.ufficio            is not null
         and exists
             (select 'x'
                from a_competenze comp
               where comp.oggetto     = 'UFFICIO_PRESENZA'
                 and comp.competenza  = pspa.ufficio
                 and comp.ambiente    = a_ambiente
                 and comp.utente      = a_utente
                 and comp.ente        = a_ente
             )
        )
 order  by
        pspa.ci
       ,eapa.causale
       ,eapa.motivo
       ,pspa.dal
;
d_alias                     varchar(4) ;
d_ci                      number(8) ;
d_dal                       date    ;
d_al                        date    ;
d_causale                   varchar(8) ;
d_motivo                    varchar(8) ;
d_cdc                       varchar(8) ;
d_cdc_aut                   varchar(8) ;
d_sede                    number(6) ;
d_sede_aut                number(6) ;
d_gg_set                  number(1) ;
d_gg_set_aut              number(1) ;
d_min_gg                  number(4) ;
d_min_gg_aut              number(4) ;
d_ore                     number(5) ;
d_ore_aut                 number(5) ;
d_condizione                varchar(1) ;
d_stato_condizione          varchar(2) ;
d_attribuzione              varchar(1) ;
d_specie                    varchar(1) ;
d_quantita                number(12,2);
d_qualificazione            varchar(1) ;
d_assenza                   varchar(4) ;
d_fattore_produttivo        varchar(6) ;
d_fattore_produttivo_aut    varchar(6) ;
d_gestione                  varchar(4) ;
d_gestione_aut              varchar(4) ;
d_settore                 number(6) ;
d_settore_aut             number(6) ;
d_funzionale                varchar(8) ;
d_funzionale_aut            varchar(8) ;
d_posizione                 varchar(4) ;
d_posizione_aut             varchar(4) ;
d_ruolo                     varchar(4) ;
d_ruolo_aut                 varchar(4) ;
d_figura                  number(6) ;
d_figura_aut              number(6) ;
d_attivita                  varchar(4) ;
d_attivita_aut              varchar(4) ;
d_contratto                 varchar(4) ;
d_contratto_aut             varchar(4) ;
d_qualifica               number(6) ;
d_qualifica_aut           number(6) ;
d_livello                   varchar(4) ;
d_livello_aut               varchar(4) ;
d_tipo_rapporto             varchar(4) ;
d_tipo_rapporto_aut         varchar(4) ;
d_assistenza                varchar(6) ;
d_assistenza_aut            varchar(6) ;
d_ufficio                   varchar(30);
d_ufficio_aut               varchar(30);
d_conta                   number(6) ;
d_automatismi             number(1) ;
d_incide_gipe               varchar(2) ;
d_mat_fer                 number(1) ;
d_dal_evpa                  date    ;
d_al_evpa                   date    ;
d_eof_aupa                  varchar(2) ;
d_eof_eapa                  varchar(2) ;
SCARTA                    exception ;
INSERISCE                 exception ;
d_ci_prec                 number(8) ;
d_causale_prec              varchar(8) ;
d_motivo_prec               varchar(8) ;
d_assenza_prec              varchar(4) ;
d_condizione_prec           varchar(1) ;
d_stato_condizione_prec     varchar(2) ;
d_qualificazione_prec       varchar(1) ;
d_sede_prec               number(6) ;
d_cdc_prec                  varchar(8) ;
d_cdc_ind                   varchar(8) ;
d_quantita_prec           number(12,2);
appoggio				  varchar2(1);
BEGIN
  d_conta        := P_CONTA;
  d_eof_eapa     := 'NO';
  d_eof_aupa     := 'NO';
  d_ci_prec      := null;
  d_causale_prec := null;
  d_motivo_prec  := null;
  open aupa;
  open eapa;
  LOOP
   BEGIN
    IF  d_eof_aupa  = 'NO' THEN
    fetch aupa into  d_alias,d_ci,d_dal,d_al,d_causale,d_motivo,
                     d_cdc,d_cdc_aut,d_sede,d_sede_aut,d_gg_set,
                     d_gg_set_aut,d_min_gg,d_min_gg_aut,d_ore,d_ore_aut,
                     d_condizione,d_stato_condizione,d_attribuzione,
                     d_specie,d_quantita,d_qualificazione,d_assenza,
                     d_fattore_produttivo,d_fattore_produttivo_aut,
                     d_gestione,d_gestione_aut,d_settore,d_settore_aut,
                     d_funzionale,d_funzionale_aut,d_posizione,
                     d_posizione_aut,d_ruolo,d_ruolo_aut,d_figura,
                     d_figura_aut,d_attivita,d_attivita_aut,d_contratto,
                     d_contratto_aut,d_qualifica,d_qualifica_aut,
                     d_livello,d_livello_aut,
                     d_tipo_rapporto,d_tipo_rapporto_aut,d_assistenza,
                     d_assistenza_aut,d_ufficio,d_ufficio_aut
    ;
    END IF;
    IF aupa%NOTFOUND THEN
       d_eof_aupa := 'SI';
    END IF;
    IF  d_eof_aupa = 'SI' AND d_eof_eapa = 'NO' THEN
    fetch eapa into  d_alias,d_ci,d_dal,d_al,d_causale,d_motivo,
                     d_cdc,d_sede,d_gg_set,d_min_gg,
                     d_condizione,d_stato_condizione,d_attribuzione,
                     d_specie,d_quantita,d_qualificazione,d_assenza
    ;
    END IF;
    IF eapa%NOTFOUND THEN
      d_eof_eapa := 'SI';
    END IF;
    IF  d_eof_aupa = 'SI' AND d_eof_eapa = 'SI' THEN
        RAISE INSERISCE;
    END IF;
    IF  d_alias = 'EAPA' THEN
        RAISE INSERISCE;
    ELSE
        IF  (   d_cdc_aut                is null
             OR d_cdc_aut                 = d_cdc
            )
        AND (   d_sede_aut               is null
             OR d_sede_aut                = d_sede
            )
        AND (   d_gg_set_aut             is null
             OR d_gg_set_aut              = d_gg_set
            )
        AND (   d_min_gg_aut             is null
             OR d_min_gg_aut              = d_min_gg
            )
        AND (   d_ore_aut                is null
             OR d_ore_aut                 = d_ore
            )
        AND (   d_fattore_produttivo_aut is null
             OR d_fattore_produttivo_aut  = d_fattore_produttivo
            )
        AND (   d_gestione_aut           is null
             OR d_gestione_aut            = d_gestione
            )
        AND (   d_settore_aut            is null
             OR d_settore_aut             = d_settore
            )
        AND (   d_funzionale_aut         is null
             OR d_funzionale_aut          = d_funzionale
            )
        AND (   d_posizione_aut          is null
             OR d_posizione_aut           = d_posizione
            )
        AND (   d_ruolo_aut              is null
             OR d_ruolo_aut               = d_ruolo
            )
        AND (   d_figura_aut             is null
             OR d_figura_aut              = d_figura
            )
        AND (   d_attivita_aut           is null
             OR d_attivita_aut            = d_attivita
            )
        AND (   d_contratto_aut          is null
             OR d_contratto_aut           = d_contratto
            )
        AND (   d_qualifica_aut          is null
             OR d_qualifica_aut           = d_qualifica
            )
        AND (   d_livello_aut            is null
             OR d_livello_aut             = d_livello
            )
        AND (   d_tipo_rapporto_aut      is null
             OR d_tipo_rapporto_aut       = d_tipo_rapporto
            )
        AND (   d_assistenza_aut         is null
             OR d_assistenza_aut          = d_assistenza
            )
        AND (   d_ufficio_aut            is null
             OR d_ufficio_aut             = d_ufficio
            )
                               THEN
           RAISE INSERISCE;
        ELSE
           RAISE SCARTA;
        END IF;
    END IF;
   EXCEPTION
     WHEN SCARTA THEN null;
     WHEN INSERISCE THEN
       IF d_eof_aupa = 'NO' OR  d_eof_eapa = 'NO' THEN
          IF d_ci_prec  is  null                  THEN
             d_ci_prec               := d_ci;
             d_causale_prec          := d_causale;
             d_motivo_prec           := d_motivo;
             d_dal_evpa              := d_dal;
             d_al_evpa               := d_al;
             d_qualificazione_prec   := d_qualificazione;
             d_assenza_prec          := d_assenza;
             d_condizione_prec       := d_condizione;
             d_stato_condizione_prec := d_stato_condizione;
             d_sede_prec             := d_sede;
             d_cdc_prec              := d_cdc;
             d_quantita_prec         := d_quantita;
          END IF;
       END IF;
       IF d_ci_prec         is null               THEN
          exit;
       ELSE
       IF d_eof_aupa = 'SI' AND d_eof_eapa = 'SI'
       OR d_ci              != d_ci_prec
       OR d_causale         != d_causale_prec
       OR nvl(d_motivo,' ') != nvl(d_motivo_prec,' ')
                                                  THEN
          BEGIN
            BEGIN
              select  aste.automatismi,aste.incide_gipe,aste.mat_fer
                into  d_automatismi,d_incide_gipe,d_mat_fer
                from  astensioni aste
               where  aste.codice   = d_assenza_prec
              ;
            EXCEPTION
              WHEN TOO_MANY_ROWS THEN
/*               a00_messaggio('A00003','ASTENSIONI');*/
				 w_errore:= 'A00003 ASTENSIONI';
               RAISE errore_in_elaborazione;
              WHEN NO_DATA_FOUND THEN
                d_automatismi   := 1;
                d_incide_gipe   := 'SI';
                d_mat_fer       := 1;
            END;
            BEGIN
              IF (    d_condizione_prec = 'S'
                  OR  d_stato_condizione_prec
                                       != 'A'
                  OR  d_condizione_prec = 'R'
                  AND d_mat_fer         = 1
                  OR  d_condizione_prec = 'I'
                  AND d_incide_gipe    != 'NO'
                  OR  d_condizione_prec = 'A'
                  AND d_automatismi     = 1
                  OR  d_qualificazione_prec
                                       != 'A'
                  OR  d_assenza_prec   is null
                 )                              THEN
                 RAISE NO_DATA_FOUND;
              ELSE
                select 'x'
                  into appoggio
                  from eventi_presenza evpa
                 where nvl(evpa.dal,to_date('2222222','j'))
                                           <= d_al_evpa
                   and nvl(evpa.al ,to_date('3333333','j'))
                                           >= d_dal_evpa
                   and evpa.ci              = d_ci_prec
                   and evpa.input     not  in ('P','A')
                   and exists
                       (select  'x'
                          from  causali_evento cae2
                               ,astensioni     aste
                         where  cae2.codice = evpa.causale
                           and  aste.codice = cae2.assenza
                           and (    d_condizione_prec     = 'I'
                                and aste.incide_gipe      = 'NO'
                                or  d_condizione_prec     = 'A'
                                and aste.automatismi      = 0
                                or  d_condizione_prec     = 'R'
                                and aste.mat_fer          = 0
                               )
                       )
                ;
                RAISE TOO_MANY_ROWS;
              END IF;
            EXCEPTION
              WHEN TOO_MANY_ROWS THEN null;
              WHEN NO_DATA_FOUND THEN
             BEGIN
             select nvl(rapa.cdc,rifu.cdc)
               into d_cdc_ind
               from ripartizioni_funzionali rifu
                   ,rapporti_presenza       rapa
              where (rifu.settore,rifu.sede) =
                    (select settore,nvl(sede_cdc,0)
                       from periodi_servizio_presenza
                      where ci = d_ci_prec
                        and d_dal_evpa between dal
                                        and nvl(al,to_date('3333333','j'))
                    )
                and rapa.ci        = d_ci_prec
                and d_dal_evpa between rapa.dal
                                  and nvl(rapa.al,to_date('3333333','j'))
             ;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN d_cdc_ind := '';
             END;
                insert into eventi_presenza
                      (evento,ci,causale,motivo,dal,al,riferimento,
                            chiuso,input,valore,sede,cdc,utente,data_agg)
                select evpa_sq.nextval,d_ci_prec,d_causale_prec,
                       d_motivo_prec,d_dal_evpa,d_al_evpa,d_dal_evpa,
                       'SI','A',d_quantita_prec,d_sede_prec,
                       nvl(d_cdc_prec,d_cdc_ind),
                       a_utente,dep_fin_mes
                  from dual
                ;
                IF  d_qualificazione_prec     = 'A'
                AND d_assenza_prec           is not null
                AND p_giuridica      = 'SI'     THEN
                    insert into deposito_eventi_presenza
                          (rilevanza,ci,assenza,data,operazione,dal,al,
                           utente,data_agg)
                    select 'P',d_ci_prec,d_assenza_prec,
                           d_dal_evpa,'I',d_dal_evpa,
                           d_al_evpa,a_utente,SYSDATE
                      from dual
                    ;
                END IF;
                update rapporti_presenza
                   set flag_ec = 'M'
                 where ci      = d_ci_prec
                   and nvl(dal,to_date('2222222','j'))
                              <= d_dal_evpa
                   and nvl(al ,to_date('3333333','j'))
                              >= d_al_evpa
                ;
                d_conta := d_conta + 1;
            END;
          END;
          IF d_eof_aupa = 'SI' AND d_eof_eapa = 'SI' THEN
             exit;
          ELSE
             d_ci_prec               := d_ci;
             d_causale_prec          := d_causale;
             d_motivo_prec           := d_motivo;
             d_dal_evpa              := d_dal;
             d_al_evpa               := d_al;
             d_qualificazione_prec   := d_qualificazione;
             d_assenza_prec          := d_assenza;
             d_condizione_prec       := d_condizione;
             d_stato_condizione_prec := d_stato_condizione;
             d_sede_prec             := d_sede;
             d_cdc_prec              := d_cdc;
             d_quantita_prec         := d_quantita;
         END IF;
       ELSE
         d_al_evpa:= d_al;
       END IF;
       END IF;
   END;
  END LOOP;
  close eapa;
  close aupa;
  P_CONTA := d_conta;
END;

PROCEDURE INSERISCE_EVENTI_G (P_CONTA IN OUT NUMBER) IS
cursor aupa is
select  'AUPA'
       ,pspa.ci
       ,greatest(pspa.dal,nvl(aupa.dal,to_date('2222222','j')),
                 dep_ini_mes
                )
       ,least   (nvl(pspa.al,to_date('3333333','j')),
                 nvl(aupa.al,to_date('3333333','j')),
                 dep_fin_mes
                )
       ,aupa.causale
       ,aupa.motivo
       ,nvl(rapa.cdc,rifu.cdc)
       ,aupa.cdc
       ,pspa.sede
       ,aupa.sede
       ,pspa.gg_set
       ,aupa.gg_set
       ,pspa.min_gg
       ,aupa.min_gg
       ,pspa.ore
       ,aupa.ore
       ,aupa.condizione
       ,aupa.stato_condizione
       ,aupa.attribuzione
       ,aupa.specie
       ,aupa.quantita
       ,caev.qualificazione
       ,caev.assenza
       ,nvl(rapa.fattore_produttivo,decode(pegi.tipo_rapporto
                                          ,'TD',qual.fattore_td
                                               ,qual.fattore
                                          )
           )
       ,aupa.fattore_produttivo
       ,sett.gestione
       ,aupa.gestione
       ,pspa.settore
       ,aupa.settore
       ,rifu.funzionale
       ,aupa.funzionale
       ,pegi.posizione
       ,aupa.posizione
       ,qugi.ruolo
       ,aupa.ruolo
       ,pspa.figura
       ,aupa.figura
       ,pegi.attivita
       ,aupa.attivita
       ,pspa.contratto
       ,aupa.contratto
       ,pspa.qualifica
       ,aupa.qualifica
       ,qugi.livello
       ,aupa.livello
       ,pegi.tipo_rapporto
       ,aupa.tipo_rapporto
       ,nvl(rapa.assistenza,trpr.assistenza)
       ,aupa.assistenza
       ,rapa.ufficio
       ,aupa.ufficio
  from  trattamenti_previdenziali  trpr
       ,trattamenti_contabili      trco
       ,rapporti_retributivi       rare
       ,rapporti_individuali       rain
       ,ripartizioni_funzionali    rifu
       ,settori                    sett
       ,qualifiche_giuridiche      qugi
       ,qualifiche                 qual
       ,causali_evento             caev
       ,periodi_giuridici          pegi
       ,rapporti_presenza          rapa
       ,periodi_servizio_presenza  pspa
       ,automatismi_presenza       aupa
 where  dep_fin_mes  between nvl(aupa.dal
                                           ,to_date('2222222','j')
                                           )
                                    and nvl(aupa.al
                                           ,to_date('3333333','j')
                                           )
   and  nvl(pspa.dal,to_date('2222222','j'))
                                     <= dep_fin_mes
   and  nvl(pspa.al ,to_date('3333333','j'))
                                     >= dep_ini_mes
   and  rapa.ci                       = pspa.ci
   and  rapa.dal                      = pspa.dal_rapporto
   and  (    rapa.automatismo         = aupa.automatismo
         or  aupa.automatismo        is null
        )
   and  aupa.attribuzione             = 'G'
   and  aupa.attivo                   = 'SI'
   and  nvl(aupa.quantita,0)         != 0
   and  pegi.ci                   (+) = pspa.ci
   and  pegi.rilevanza            (+) = pspa.rilevanza
   and  pegi.dal                  (+) = pspa.dal_periodo
   and  qual.numero               (+) = pspa.qualifica
   and  qugi.numero               (+) = pspa.qualifica
   and  qugi.dal                  (+) = pspa.dal_qualifica
   and  sett.numero               (+) = pspa.settore
   and  rifu.settore              (+) = pspa.settore
   and  rifu.sede                 (+) = nvl(pspa.sede_cdc,0)
   and  rare.ci                   (+) = pspa.ci
   and  trco.profilo_professionale
                                  (+) = pspa.profilo_professionale
   and  trco.posizione            (+) = pspa.posizione
   and  trpr.codice               (+) = trco.trattamento
   and nvl(rare.tipo_trattamento, 0)  = trco.tipo_trattamento
   and  caev.codice                   = aupa.causale
   and  rain.ci                       = pspa.ci
   and  not exists
        (select 'x'
           from eventi_automatici_presenza eapa
          where nvl(eapa.al ,to_date('3333333','j'))
                                     >=
                greatest(pspa.dal,nvl(aupa.dal,to_date('2222222','j'))
                        ,dep_ini_mes
                        )
            and nvl(eapa.dal,to_date('2222222','j'))
                                     <=
                least(nvl(pspa.al,to_date('3333333','j'))
                     ,nvl(aupa.al,to_date('3333333','j'))
                     ,dep_fin_mes
                     )
            and eapa.causale          = aupa.causale
            and nvl(eapa.motivo,' ')  = nvl(aupa.motivo,' ')
            and eapa.ci               = pspa.ci
        )
   and  (    caev.riferimento        != 'G'
         or  caev.riferimento         = 'G'
         and not exists
             (select 'x'
                from eventi_presenza  evpa
               where nvl(evpa.dal,to_date('2222222','j'))
                                     <=
                     nvl(aupa.al ,to_date('3333333','j'))
                 and nvl(evpa.al ,to_date('3333333','j'))
                                     >=
                     nvl(aupa.dal,to_date('2222222','j'))
                 and evpa.causale     = aupa.causale
                 and nvl(evpa.motivo,' ')
                                      = nvl(aupa.motivo,' ')
                 and evpa.ci          = pspa.ci
                 and exists
                     (select 'x'
                        from causali_evento cae2
                       where cae2.codice
                                      = evpa.causale
                         and cae2.riferimento
                                      = 'G'
                     )
             )
        )
   and  (    rain.cc                 is null
         or  rain.cc                 is not null
         and exists
             (select 'x'
                from a_competenze comp
               where comp.competenza  = 'CI'
                 and comp.oggetto     = rain.cc
                 and comp.ambiente    = a_ambiente
                 and comp.utente      = a_utente
                 and comp.ente        = a_ente
             )
        )
   and  exists
        (select 'x'
           from classi_rapporto clra
          where clra.codice           = rain.rapporto
            and clra.presenza         = 'SI'
        )
   and  (    pspa.ufficio            is null
         or  pspa.ufficio            is not null
         and exists
             (select 'x'
                from a_competenze comp
               where comp.oggetto     = 'UFFICIO_PRESENZA'
                 and comp.competenza  = pspa.ufficio
                 and comp.ambiente    = a_ambiente
                 and comp.utente      = a_utente
                 and comp.ente        = a_ente
             )
        )
;
cursor  eapa  is
select  'EAPA'
       ,pspa.ci
       ,greatest(pspa.dal,nvl(eapa.dal,to_date('2222222','j')),
                 dep_ini_mes
                )
       ,least   (nvl(pspa.al,to_date('3333333','j')),
                 nvl(eapa.al,to_date('3333333','j')),
                 dep_fin_mes
                )
       ,eapa.causale
       ,eapa.motivo
       ,eapa.cdc
       ,eapa.sede
       ,pspa.gg_set
       ,pspa.min_gg
       ,eapa.condizione
       ,eapa.stato_condizione
       ,eapa.attribuzione
       ,eapa.specie
       ,eapa.quantita
       ,caev.qualificazione
       ,caev.assenza
  from  rapporti_individuali       rain
       ,causali_evento             caev
       ,periodi_servizio_presenza  pspa
       ,eventi_automatici_presenza eapa
 where  dep_fin_mes  between nvl(eapa.dal
                                           ,to_date('2222222','j')
                                           )
                                    and nvl(eapa.al
                                           ,to_date('3333333','j')
                                           )
   and  nvl(pspa.dal,to_date('2222222','j'))
                                     <= dep_fin_mes
   and  nvl(pspa.al ,to_date('3333333','j'))
                                     >= dep_ini_mes
   and  eapa.attivo                   = 'SI'
   and  eapa.attribuzione             = 'G'
   and  eapa.ci                       = pspa.ci
   and  nvl(eapa.quantita,0)         != 0
   and  caev.codice                   = eapa.causale
   and  rain.ci                       = pspa.ci
   and  (    caev.riferimento        != 'G'
         or  caev.riferimento         = 'G'
         and not exists
             (select 'x'
                from eventi_presenza  evpa
               where nvl(evpa.dal,to_date('2222222','j'))
                                     <=
                     nvl(eapa.al ,to_date('3333333','j'))
                 and nvl(evpa.al ,to_date('3333333','j'))
                                     >=
                     nvl(eapa.dal,to_date('2222222','j'))
                 and evpa.causale     = eapa.causale
                 and nvl(evpa.motivo,' ')
                                      = nvl(eapa.motivo,' ')
                 and evpa.ci          = pspa.ci
                 and exists
                     (select 'x'
                        from causali_evento cae2
                       where cae2.codice
                                      = evpa.causale
                         and cae2.riferimento
                                      = 'G'
                     )
             )
        )
   and  (    rain.cc                 is null
         or  rain.cc                 is not null
         and exists
             (select 'x'
                from a_competenze comp
               where comp.competenza  = 'CI'
                 and comp.oggetto     = rain.cc
                 and comp.ambiente    = a_ambiente
                 and comp.utente      = a_utente
                 and comp.ente        = a_ente
             )
        )
   and  exists
        (select 'x'
           from classi_rapporto clra
          where clra.codice           = rain.rapporto
            and clra.presenza         = 'SI'
        )
   and  (    pspa.ufficio            is null
         or  pspa.ufficio            is not null
         and exists
             (select 'x'
                from a_competenze comp
               where comp.oggetto     = 'UFFICIO_PRESENZA'
                 and comp.competenza  = pspa.ufficio
                 and comp.ambiente    = a_ambiente
                 and comp.utente      = a_utente
                 and comp.ente        = a_ente
             )
        )
;
d_alias                     varchar(4) ;
d_ci                      number(8) ;
d_ci_prec                 number(8) ;
d_dal                       date    ;
d_al                        date    ;
d_causale                   varchar(8) ;
d_motivo                    varchar(8) ;
d_cdc                       varchar(8) ;
d_cdc_aut                   varchar(8) ;
d_cdc_ind                   varchar(8) ;
d_sede                    number(6) ;
d_sede_aut                number(6) ;
d_gg_set                  number(1) ;
d_gg_set_aut              number(1) ;
d_min_gg                  number(4) ;
d_min_gg_aut              number(4) ;
d_ore                     number(5) ;
d_ore_aut                 number(5) ;
d_condizione                varchar(1) ;
d_stato_condizione          varchar(2) ;
d_attribuzione              varchar(1) ;
d_specie                    varchar(1) ;
d_quantita                number(12,2);
d_qualificazione            varchar(1) ;
d_assenza                   varchar(4) ;
d_fattore_produttivo        varchar(6) ;
d_fattore_produttivo_aut    varchar(6) ;
d_gestione                  varchar(4) ;
d_gestione_aut              varchar(4) ;
d_settore                 number(6) ;
d_settore_aut             number(6) ;
d_funzionale                varchar(8) ;
d_funzionale_aut            varchar(8) ;
d_posizione                 varchar(4) ;
d_posizione_aut             varchar(4) ;
d_ruolo                     varchar(4) ;
d_ruolo_aut                 varchar(4) ;
d_figura                  number(6) ;
d_figura_aut              number(6) ;
d_attivita                  varchar(4) ;
d_attivita_aut              varchar(4) ;
d_contratto                 varchar(4) ;
d_contratto_aut             varchar(4) ;
d_qualifica               number(6) ;
d_qualifica_aut           number(6) ;
d_livello                   varchar(4) ;
d_livello_aut               varchar(4) ;
d_tipo_rapporto             varchar(4) ;
d_tipo_rapporto_aut         varchar(4) ;
d_assistenza                varchar(6) ;
d_assistenza_aut            varchar(6) ;
d_ufficio                   varchar(30);
d_ufficio_aut               varchar(30);
d_conta                   number(6) ;
d_automatismi             number(1) ;
d_incide_gipe               varchar(2) ;
d_mat_fer                 number(1) ;
d_dal_evpa                  date    ;
d_al_evpa                   date    ;
d_calendario                varchar(2) ;
d_giorni                    varchar(31);
d_num_gg                  number(2) ;
d_eof_aupa                  varchar(2) ;
d_eof_eapa                  varchar(2) ;
SCARTA                    exception ;
INSERISCE                 exception ;
appoggio				  		varchar2(1);
BEGIN
  d_conta := P_CONTA;
  d_eof_eapa := 'NO';
  d_eof_aupa := 'NO';
  open aupa;
  open eapa;
  LOOP
   BEGIN
    IF  d_eof_aupa  = 'NO' THEN
    fetch aupa into  d_alias,d_ci,d_dal,d_al,d_causale,d_motivo,
                     d_cdc,d_cdc_aut,d_sede,d_sede_aut,d_gg_set,
                     d_gg_set_aut,d_min_gg,d_min_gg_aut,d_ore,d_ore_aut,
                     d_condizione,d_stato_condizione,d_attribuzione,
                     d_specie,d_quantita,d_qualificazione,d_assenza,
                     d_fattore_produttivo,d_fattore_produttivo_aut,
                     d_gestione,d_gestione_aut,d_settore,d_settore_aut,
                     d_funzionale,d_funzionale_aut,d_posizione,
                     d_posizione_aut,d_ruolo,d_ruolo_aut,d_figura,
                     d_figura_aut,d_attivita,d_attivita_aut,d_contratto,
                     d_contratto_aut,d_qualifica,d_qualifica_aut,
                     d_livello,d_livello_aut,
                     d_tipo_rapporto,d_tipo_rapporto_aut,d_assistenza,
                     d_assistenza_aut,d_ufficio,d_ufficio_aut
    ;
    END IF;
    IF aupa%NOTFOUND THEN
       d_eof_aupa := 'SI';
    END IF;
    IF  d_eof_aupa = 'SI' AND d_eof_eapa = 'NO' THEN
    fetch eapa into  d_alias,d_ci,d_dal,d_al,d_causale,d_motivo,
                     d_cdc,d_sede,d_gg_set,d_min_gg,
                     d_condizione,d_stato_condizione,d_attribuzione,
                     d_specie,d_quantita,d_qualificazione,d_assenza
    ;
    END IF;
    IF eapa%NOTFOUND THEN
      d_eof_eapa := 'SI';
    END IF;
    IF  d_eof_aupa = 'SI' AND d_eof_eapa = 'SI' THEN
        exit;
    END IF;
    d_dal_evpa := d_dal;
    d_al_evpa  := d_al;
    IF  d_alias = 'AUPA' THEN
        IF  (   d_cdc_aut                is null
             OR d_cdc_aut                 = d_cdc
            )
        AND (   d_sede_aut               is null
             OR d_sede_aut                = d_sede
            )
        AND (   d_gg_set_aut             is null
             OR d_gg_set_aut              = d_gg_set
            )
        AND (   d_min_gg_aut             is null
             OR d_min_gg_aut              = d_min_gg
            )
        AND (   d_ore_aut                is null
             OR d_ore_aut                 = d_ore
            )
        AND (   d_fattore_produttivo_aut is null
             OR d_fattore_produttivo_aut  = d_fattore_produttivo
            )
        AND (   d_gestione_aut           is null
             OR d_gestione_aut            = d_gestione
            )
        AND (   d_settore_aut            is null
             OR d_settore_aut             = d_settore
            )
        AND (   d_funzionale_aut         is null
             OR d_funzionale_aut          = d_funzionale
            )
        AND (   d_posizione_aut          is null
             OR d_posizione_aut           = d_posizione
            )
        AND (   d_ruolo_aut              is null
             OR d_ruolo_aut               = d_ruolo
            )
        AND (   d_figura_aut             is null
             OR d_figura_aut              = d_figura
            )
        AND (   d_attivita_aut           is null
             OR d_attivita_aut            = d_attivita
            )
        AND (   d_contratto_aut          is null
             OR d_contratto_aut           = d_contratto
            )
        AND (   d_qualifica_aut          is null
             OR d_qualifica_aut           = d_qualifica
            )
        AND (   d_livello_aut            is null
             OR d_livello_aut             = d_livello
            )
        AND (   d_tipo_rapporto_aut      is null
             OR d_tipo_rapporto_aut       = d_tipo_rapporto
            )
        AND (   d_assistenza_aut         is null
             OR d_assistenza_aut          = d_assistenza
            )
        AND (   d_ufficio_aut            is null
             OR d_ufficio_aut             = d_ufficio
            )
                               THEN
           null;
        ELSE
           RAISE SCARTA;
        END IF;
    END IF;
    BEGIN
      select  aste.automatismi,aste.incide_gipe,aste.mat_fer
        into  d_automatismi,d_incide_gipe,d_mat_fer
        from  astensioni aste
       where  aste.codice   = d_assenza
      ;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
/*        a00_messaggio('A00003','ASTENSIONI'); trattamento errore */
w_errore := 'A00003 ASTENSIONI';
        RAISE errore_in_elaborazione;
      WHEN NO_DATA_FOUND THEN
        d_automatismi   := 1;
        d_incide_gipe   := 'SI';
        d_mat_fer       := 1;
    END;
    IF d_specie in ('M','L','I','A') THEN
    BEGIN
      select  nvl(sede.calendario,'*')
        into  d_calendario
        from  sedi sede
       where  sede.numero = d_sede
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        d_calendario := '*';
      WHEN TOO_MANY_ROWS THEN
       /* a00_messaggio('A00003','SEDI'); trattamento errore */
	    w_errore := 'A00003 SEDI';
        RAISE errore_in_elaborazione;
    END;
    BEGIN
      select  cale.giorni
        into  d_giorni
        from  calendari cale
       where  cale.anno = to_number(to_char(dep_ini_mes,'yyyy'
                          ))
         and  cale.mese = to_number(to_char(dep_ini_mes,'mm'
                          ))
         and  cale.calendario
                        = d_calendario
      ;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
/*        a00_messaggio('A00003','CALENDARI');*/
     w_errore := 'A00003 CALENDARI';
        RAISE errore_in_elaborazione;
      WHEN NO_DATA_FOUND THEN
/*        a00_messaggio('P05000',' ');*/
        /* Calendario non previsto */
  w_errore := 'P05000';
        RAISE errore_in_elaborazione;
    END;
    ELSE
      d_giorni := 'fffffffffffffffffffffffffffffff';
    END IF;
    d_num_gg := 0;
    FOR ind IN
        to_number(to_char(d_dal_evpa,'dd'))..
        to_number(to_char(d_al_evpa,'dd'))
    LOOP
      IF  d_specie  = 'M'
      AND substr(d_giorni,ind,1) in ('s','f','d','S','F')
      OR  d_specie  = 'L' AND d_gg_set = 5
      AND substr(d_giorni,ind,1)  = 'f'
      OR  d_specie  = 'L' AND d_gg_set = 6
      AND substr(d_giorni,ind,1) in ('s','f')
      OR  d_specie  = 'I'
      AND substr(d_giorni,ind,1) in ('s','f')
      OR  d_specie  = 'F'
      OR  d_specie  = 'C'
      OR  d_specie  = 'A'
      AND substr(d_giorni,ind,1) in ('s','f','d','F')       THEN
          IF  d_qualificazione   != 'A'
          OR  d_assenza          is null
          OR  d_condizione        = 'S'
          OR  d_condizione        = 'A'
          AND d_automatismi       = 1
          OR  d_condizione        = 'I'
          AND d_incide_gipe      != 'NO'
          OR  d_condizione        = 'R'
          AND d_mat_fer           = 1
          OR  d_stato_condizione  = 'N'                     THEN
              IF  d_specie = 'F'                            THEN
                  IF  ind =
                      to_number(to_char(dep_fin_mes,'dd'))
                                                            THEN
                      IF  ind = 30                          THEN
                          d_num_gg := d_num_gg + 1;
                      ELSIF
                          ind = 29                          THEN
                          d_num_gg := d_num_gg + 2;
                      ELSIF
                          ind = 28                          THEN
                          d_num_gg := d_num_gg + 3;
                      END IF;
                  ELSE
                      d_num_gg := d_num_gg + 1;
                  END IF;
              ELSE
                  d_num_gg := d_num_gg + 1;
              END IF;
          ELSE
          BEGIN
            select 'x'
              into appoggio
              from eventi_presenza evpa
             where to_date(lpad(to_char(ind),2,'0')||
                           to_char(d_dal_evpa,'mmyyyy'),'ddmmyyyy')
                                 between evpa.dal   and
                   nvl(evpa.al ,to_date('3333333','j'))
               and evpa.ci              = d_ci
               and evpa.input     not  in ('P','A')
              and exists
                  (select  'x'
                     from  causali_evento cae2
                          ,astensioni     aste
                    where  cae2.codice = evpa.causale
                      and  aste.codice = cae2.assenza
                      and (    d_condizione     = 'I'
                           and aste.incide_gipe = 'NO'
                           or  d_condizione     = 'A'
                           and aste.automatismi = 0
                           or  d_condizione     = 'R'
                           and aste.mat_fer     = 0
                           )
                  )
            ;
            RAISE TOO_MANY_ROWS;
          EXCEPTION
            WHEN TOO_MANY_ROWS THEN null;
            WHEN NO_DATA_FOUND THEN
              IF  d_specie = 'F'                            THEN
                  IF  ind =
                      to_number(to_char(dep_fin_mes,'dd'))
                                                            THEN
                      IF  ind = 30                          THEN
                          d_num_gg := d_num_gg + 1;
                      ELSIF
                          ind = 29                          THEN
                          d_num_gg := d_num_gg + 2;
                      ELSIF
                          ind = 28                          THEN
                          d_num_gg := d_num_gg + 3;
                      END IF;
                  ELSE
                      d_num_gg := d_num_gg + 1;
                  END IF;
              ELSE
                  d_num_gg := d_num_gg + 1;
              END IF;
          END;
          END IF;
      END IF;
    END LOOP;
    IF  d_num_gg != 0 THEN
        RAISE INSERISCE;
    END IF;
   EXCEPTION
     WHEN SCARTA THEN null;
     WHEN INSERISCE THEN
             BEGIN
             select nvl(rapa.cdc,rifu.cdc)
               into d_cdc_ind
               from ripartizioni_funzionali rifu
                   ,rapporti_presenza       rapa
              where (rifu.settore,rifu.sede) =
                    (select settore,nvl(sede_cdc,0)
                       from periodi_servizio_presenza
                      where ci = d_ci_prec
                        and d_dal_evpa between dal
                                        and nvl(al,to_date('3333333','j'))
                    )
                and rapa.ci        = d_ci_prec
                and d_dal_evpa between rapa.dal
                                  and nvl(rapa.al,to_date('3333333','j'))
             ;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN d_cdc_ind := '';
             END;
       insert into eventi_presenza
             (evento,ci,causale,motivo,dal,al,riferimento,chiuso,
              input,valore,sede,cdc,utente,data_agg)
       select evpa_sq.nextval,d_ci,d_causale,d_motivo,d_dal_evpa,
              d_al_evpa,d_dal_evpa,'SI','A',d_num_gg * d_quantita,
              d_sede,
              nvl(d_cdc,d_cdc_ind),
              a_utente,dep_fin_mes
         from dual
       ;
       IF  d_qualificazione     = 'A'
       AND d_assenza           is not null
       AND P_giuridica = 'SI'     THEN
           insert into deposito_eventi_presenza
                 (rilevanza,ci,assenza,data,operazione,dal,al,
                  utente,data_agg)
           select 'P',d_ci,d_assenza,d_dal_evpa,'I',d_dal_evpa,
                  d_al_evpa,a_utente,SYSDATE
             from dual
           ;
       END IF;
       update rapporti_presenza
          set flag_ec = 'M'
        where ci      = d_ci
          and nvl(dal,to_date('2222222','j'))
                     <= d_dal_evpa
          and nvl(al ,to_date('3333333','j'))
                     >= d_al_evpa
       ;
       d_conta := d_conta + 1;
   END;
  END LOOP;
  close eapa;
  close aupa;
  P_CONTA := d_conta;
END;

PROCEDURE ELIMINA_EVENTI IS
cursor  evpa  is  select  evpa.evento
                         ,evpa.ci
                         ,caev.assenza
                         ,caev.qualificazione
                         ,evpa.dal
                         ,evpa.al
                    from  causali_evento   caev
                         ,eventi_presenza  evpa
                   where  caev.codice   =  evpa.causale
                     and  to_char(evpa.data_agg,'ddmmyyyy')
                                        =
                          to_char(dep_fin_mes,'ddmmyyyy')
                     and  evpa.input    = 'A'
                  ;
d_evento          number(8) ;
d_ci              number(8) ;
d_assenza           varchar(4) ;
d_qualificazione    varchar(1) ;
d_dal               date    ;
d_al                date    ;
d_conta           number(6) ;
BEGIN
  d_conta := 0;
  open evpa;
  LOOP
    fetch evpa into d_evento,d_ci,d_assenza,d_qualificazione,
                    d_dal,d_al;
    exit  when evpa%NOTFOUND;
    d_conta := d_conta + 1;
    IF p_giuridica = 'SI'       AND
       d_qualificazione     = 'A'        AND
       d_assenza           is not null   THEN
       insert  into  deposito_eventi_presenza
              (rilevanza
              ,ci
              ,assenza
              ,data
              ,operazione
              ,dal
              ,al
              ,utente
              ,data_agg
              )
       select  'P'
              ,d_ci
              ,d_assenza
              ,d_dal
              ,'D'
              ,d_dal
              ,d_al
              ,a_utente
              ,SYSDATE
         from  dual
       ;
    END IF;
    update  rapporti_presenza rapa
       set  rapa.flag_ec    = 'M'
     where  rapa.ci         = d_ci
       and  rapa.dal       <= d_al
       and  nvl(rapa.al,to_date('3333333','j'))
                           >= d_dal
    ;
    delete from eventi_presenza evpa
     where evpa.evento = d_evento
    ;
  END LOOP;
  close evpa;
END;
PROCEDURE INSERISCE_EVENTI_M (P_CONTA IN OUT NUMBER)   IS
d_ci                      number(8) ;
d_ci_prec                 number(8) ;
d_causale                   varchar(8) ;
d_motivo                    varchar(8) ;
d_alias                     varchar(4) ;
d_dal                       date    ;
d_al                        date    ;
d_cdc                       varchar(8) ;
d_cdc_aut                   varchar(8) ;
d_cdc_ind                   varchar(8) ;
d_sede                    number(6) ;
d_sede_aut                number(6) ;
d_gg_set                  number(1) ;
d_gg_set_aut              number(1) ;
d_min_gg                  number(4) ;
d_min_gg_aut              number(4) ;
d_ore                     number(5) ;
d_ore_aut                 number(5) ;
d_condizione                varchar(1) ;
d_stato_condizione          varchar(2) ;
d_attribuzione              varchar(1) ;
d_specie                    varchar(1) ;
d_gg_ratei                number(3) ;
d_quantita                number(12,2);
d_qualificazione            varchar(1) ;
d_assenza                   varchar(4) ;
d_fattore_produttivo        varchar(6) ;
d_fattore_produttivo_aut    varchar(6) ;
d_gestione                  varchar(4) ;
d_gestione_aut              varchar(4) ;
d_settore                 number(6) ;
d_settore_aut             number(6) ;
d_funzionale                varchar(8) ;
d_funzionale_aut            varchar(8) ;
d_posizione                 varchar(4) ;
d_posizione_aut             varchar(4) ;
d_ruolo                     varchar(4) ;
d_ruolo_aut                 varchar(4) ;
d_figura                  number(6) ;
d_figura_aut              number(6) ;
d_attivita                  varchar(4) ;
d_attivita_aut              varchar(4) ;
d_contratto                 varchar(4) ;
d_contratto_aut             varchar(4) ;
d_qualifica               number(6) ;
d_qualifica_aut           number(6) ;
d_livello                   varchar(4) ;
d_livello_aut               varchar(4) ;
d_tipo_rapporto             varchar(4) ;
d_tipo_rapporto_aut         varchar(4) ;
d_assistenza                varchar(6) ;
d_assistenza_aut            varchar(6) ;
d_ufficio                   varchar(30);
d_ufficio_aut               varchar(30);
d_conta                   number(6) ;
d_automatismi             number(1) ;
d_incide_gipe               varchar(2) ;
d_mat_fer                 number(1) ;
d_dal_evpa                  date    ;
d_al_evpa                   date    ;
d_num_gg                  number(2) ;
d_valore                  number(12,2);
d_eof_aupa                  varchar(2) ;
d_eof_eapa                  varchar(2) ;
SCARTA                    exception ;
INSERISCE                 exception ;
appoggio				  varchar2(1);
cursor aupa is
select  'AUPA'
       ,pspa.ci
       ,greatest(pspa.dal,nvl(aupa.dal,to_date('2222222','j')),
                 dep_ini_mes
                )
       ,least   (nvl(pspa.al,to_date('3333333','j')),
                 nvl(aupa.al,to_date('3333333','j')),
                 dep_fin_mes
                )
       ,aupa.causale
       ,aupa.motivo
       ,nvl(rapa.cdc,rifu.cdc)
       ,aupa.cdc
       ,pspa.sede
       ,aupa.sede
       ,pspa.gg_set
       ,aupa.gg_set
       ,pspa.min_gg
       ,aupa.min_gg
       ,pspa.ore
       ,aupa.ore
       ,aupa.condizione
       ,aupa.stato_condizione
       ,aupa.attribuzione
       ,aupa.specie
       ,aupa.gg_ratei
       ,aupa.quantita
       ,caev.qualificazione
       ,caev.assenza
       ,nvl(rapa.fattore_produttivo,decode(pegi.tipo_rapporto
                                          ,'TD',qual.fattore_td
                                               ,qual.fattore
                                          )
           )
       ,aupa.fattore_produttivo
       ,sett.gestione
       ,aupa.gestione
       ,pspa.settore
       ,aupa.settore
       ,rifu.funzionale
       ,aupa.funzionale
       ,pegi.posizione
       ,aupa.posizione
       ,qugi.ruolo
       ,aupa.ruolo
       ,pspa.figura
       ,aupa.figura
       ,pegi.attivita
       ,aupa.attivita
       ,pspa.contratto
       ,aupa.contratto
       ,pspa.qualifica
       ,aupa.qualifica
       ,qugi.livello
       ,aupa.livello
       ,pegi.tipo_rapporto
       ,aupa.tipo_rapporto
       ,nvl(rapa.assistenza,trpr.assistenza)
       ,aupa.assistenza
       ,rapa.ufficio
       ,aupa.ufficio
  from  trattamenti_previdenziali  trpr
       ,trattamenti_contabili      trco
       ,rapporti_retributivi       rare
       ,rapporti_individuali       rain
       ,ripartizioni_funzionali    rifu
       ,settori                    sett
       ,qualifiche_giuridiche      qugi
       ,qualifiche                 qual
       ,causali_evento             caev
       ,periodi_giuridici          pegi
       ,rapporti_presenza          rapa
       ,periodi_servizio_presenza  pspa
       ,automatismi_presenza       aupa
 where  dep_fin_mes  between nvl(aupa.dal
                                           ,to_date('2222222','j')
                                           )
                                    and nvl(aupa.al
                                           ,to_date('3333333','j')
                                           )
   and  nvl(pspa.dal,to_date('2222222','j'))
                                     <= dep_fin_mes
   and  nvl(pspa.al ,to_date('3333333','j'))
                                     >= dep_ini_mes
   and  rapa.ci                       = pspa.ci
   and  rapa.dal                      = pspa.dal_rapporto
   and  (    rapa.automatismo         = aupa.automatismo
         or  aupa.automatismo        is null
        )
   and  aupa.attribuzione             = 'M'
   and  aupa.specie                  != 'R'
   and  aupa.attivo                   = 'SI'
   and  nvl(aupa.quantita,0)         != 0
   and  pegi.ci                   (+) = pspa.ci
   and  pegi.rilevanza            (+) = pspa.rilevanza
   and  pegi.dal                  (+) = pspa.dal_periodo
   and  qual.numero               (+) = pspa.qualifica
   and  qugi.numero               (+) = pspa.qualifica
   and  qugi.dal                  (+) = pspa.dal_qualifica
   and  sett.numero               (+) = pspa.settore
   and  rifu.settore              (+) = pspa.settore
   and  rifu.sede                 (+) = nvl(pspa.sede_cdc,0)
   and  rare.ci                   (+) = pspa.ci
   and  trco.profilo_professionale
                                  (+) = pspa.profilo_professionale
   and  trco.posizione            (+) = pspa.posizione
   and  trpr.codice               (+) = trco.trattamento
   and  nvl(rare.tipo_trattamento,0)  = trco.tipo_trattamento
   and  caev.codice                   = aupa.causale
   and  rain.ci                       = pspa.ci
   and  not exists
        (select 'x'
           from eventi_automatici_presenza eapa
          where nvl(eapa.al ,to_date('3333333','j'))
                                     >=
                greatest(pspa.dal,nvl(aupa.dal,to_date('2222222','j'))
                        ,dep_ini_mes
                        )
            and nvl(eapa.dal,to_date('2222222','j'))
                                     <=
                least(nvl(pspa.al,to_date('3333333','j'))
                     ,nvl(aupa.al,to_date('3333333','j'))
                     ,dep_fin_mes
                     )
            and eapa.causale          = aupa.causale
            and nvl(eapa.motivo,' ')  = nvl(aupa.motivo,' ')
            and eapa.ci               = pspa.ci
        )
   and  (    caev.riferimento        != 'G'
         or  caev.riferimento         = 'G'
         and not exists
             (select 'x'
                from eventi_presenza  evpa
               where nvl(evpa.dal,to_date('2222222','j'))
                                     <=
                     nvl(aupa.al ,to_date('3333333','j'))
                 and nvl(evpa.al ,to_date('3333333','j'))
                                     >=
                     nvl(aupa.dal,to_date('2222222','j'))
                 and evpa.causale     = aupa.causale
                 and nvl(evpa.motivo,' ')
                                      = nvl(aupa.motivo,' ')
                 and evpa.ci          = pspa.ci
                 and exists
                     (select 'x'
                        from causali_evento cae2
                       where cae2.codice
                                      = evpa.causale
                         and cae2.riferimento
                                      = 'G'
                     )
             )
        )
   and  (    rain.cc                 is null
         or  rain.cc                 is not null
         and exists
             (select 'x'
                from a_competenze comp
               where comp.competenza  = 'CI'
                 and comp.oggetto     = rain.cc
                 and comp.ambiente    = a_ambiente
                 and comp.utente      = a_utente
                 and comp.ente        = a_ente
             )
        )
   and  exists
        (select 'x'
           from classi_rapporto clra
          where clra.codice           = rain.rapporto
            and clra.presenza         = 'SI'
        )
   and  (    pspa.ufficio            is null
         or  pspa.ufficio            is not null
         and exists
             (select 'x'
                from a_competenze comp
               where comp.oggetto     = 'UFFICIO_PRESENZA'
                 and comp.competenza  = pspa.ufficio
                 and comp.ambiente    = a_ambiente
                 and comp.utente      = a_utente
                 and comp.ente        = a_ente
             )
        )
;
cursor  eapa  is
select  'EAPA'
       ,eapa.ci
       ,greatest(pspa.dal,nvl(eapa.dal,to_date('2222222','j')),
                 dep_ini_mes
                )
       ,least   (nvl(pspa.al,to_date('3333333','j')),
                 nvl(eapa.al,to_date('3333333','j')),
                 dep_fin_mes
                )
       ,eapa.causale
       ,eapa.motivo
       ,eapa.cdc
       ,eapa.sede
       ,pspa.gg_set
       ,pspa.min_gg
       ,eapa.condizione
       ,eapa.stato_condizione
       ,eapa.attribuzione
       ,eapa.specie
       ,eapa.gg_ratei
       ,eapa.quantita
       ,caev.qualificazione
       ,caev.assenza
  from  rapporti_individuali       rain
       ,causali_evento             caev
       ,periodi_servizio_presenza  pspa
       ,eventi_automatici_presenza eapa
 where  dep_fin_mes  between nvl(eapa.dal
                                           ,to_date('2222222','j')
                                           )
                                    and nvl(eapa.al
                                           ,to_date('3333333','j')
                                           )
   and  nvl(pspa.dal,to_date('2222222','j'))
                                     <= dep_fin_mes
   and  nvl(pspa.al ,to_date('3333333','j'))
                                     >= dep_ini_mes
   and  eapa.attivo                   = 'SI'
   and  eapa.attribuzione             = 'M'
   and  eapa.specie                  != 'R'
   and  eapa.ci                       = pspa.ci
   and  nvl(eapa.quantita,0)         != 0
   and  caev.codice                   = eapa.causale
   and  rain.ci                       = pspa.ci
   and  (    caev.riferimento        != 'G'
         or  caev.riferimento         = 'G'
         and not exists
             (select 'x'
                from eventi_presenza  evpa
               where nvl(evpa.dal,to_date('2222222','j'))
                                     <=
                     nvl(eapa.al ,to_date('3333333','j'))
                 and nvl(evpa.al ,to_date('3333333','j'))
                                     >=
                     nvl(eapa.dal,to_date('2222222','j'))
                 and evpa.causale     = eapa.causale
                 and nvl(evpa.motivo,' ')
                                      = nvl(eapa.motivo,' ')
                 and evpa.ci          = pspa.ci
                 and exists
                     (select 'x'
                        from causali_evento cae2
                       where cae2.codice
                                      = evpa.causale
                         and cae2.riferimento
                                      = 'G'
                     )
             )
        )
   and  (    rain.cc                 is null
         or  rain.cc                 is not null
         and exists
             (select 'x'
                from a_competenze comp
               where comp.competenza  = 'CI'
                 and comp.oggetto     = rain.cc
                 and comp.ambiente    = a_ambiente
                 and comp.utente      = a_utente
                 and comp.ente        = a_ente
             )
        )
   and  exists
        (select 'x'
           from classi_rapporto clra
          where clra.codice           = rain.rapporto
            and clra.presenza         = 'SI'
        )
   and  (    pspa.ufficio            is null
         or  pspa.ufficio            is not null
         and exists
             (select 'x'
                from a_competenze comp
               where comp.oggetto     = 'UFFICIO_PRESENZA'
                 and comp.competenza  = pspa.ufficio
                 and comp.ambiente    = a_ambiente
                 and comp.utente      = a_utente
                 and comp.ente        = a_ente
             )
        )
;
BEGIN
  d_conta    := P_CONTA;
  d_eof_eapa := 'NO';
  d_eof_aupa := 'NO';
  open aupa;
  open eapa;
  LOOP
   BEGIN
    IF  d_eof_aupa  = 'NO' THEN
    fetch aupa into  d_alias,d_ci,d_dal,d_al,d_causale,d_motivo,
                     d_cdc,d_cdc_aut,d_sede,d_sede_aut,d_gg_set,
                     d_gg_set_aut,d_min_gg,d_min_gg_aut,d_ore,d_ore_aut,
                     d_condizione,d_stato_condizione,d_attribuzione,
                     d_specie,d_gg_ratei,d_quantita,
                     d_qualificazione,d_assenza,
                     d_fattore_produttivo,d_fattore_produttivo_aut,
                     d_gestione,d_gestione_aut,d_settore,d_settore_aut,
                     d_funzionale,d_funzionale_aut,d_posizione,
                     d_posizione_aut,d_ruolo,d_ruolo_aut,d_figura,
                     d_figura_aut,d_attivita,d_attivita_aut,d_contratto,
                     d_contratto_aut,d_qualifica,d_qualifica_aut,
                     d_livello,d_livello_aut,
                     d_tipo_rapporto,d_tipo_rapporto_aut,d_assistenza,
                     d_assistenza_aut,d_ufficio,d_ufficio_aut
    ;
    END IF;
    IF aupa%NOTFOUND THEN
       d_eof_aupa := 'SI';
    END IF;
    IF  d_eof_aupa = 'SI' AND d_eof_eapa = 'NO' THEN
    fetch eapa into  d_alias,d_ci,d_dal,d_al,d_causale,d_motivo,
                     d_cdc,d_sede,d_gg_set,d_min_gg,
                     d_condizione,d_stato_condizione,d_attribuzione,
                     d_specie,d_gg_ratei,d_quantita,
                     d_qualificazione,d_assenza
    ;
    END IF;
    IF eapa%NOTFOUND THEN
      d_eof_eapa := 'SI';
    END IF;
    IF  d_eof_aupa = 'SI' AND d_eof_eapa = 'SI' THEN
        exit;
    END IF;
    d_dal_evpa := d_dal;
    d_al_evpa  := d_al;
    IF  d_alias = 'AUPA' THEN
        IF  (   d_cdc_aut                is null
             OR d_cdc_aut                 = d_cdc
            )
        AND (   d_sede_aut               is null
             OR d_sede_aut                = d_sede
            )
        AND (   d_gg_set_aut             is null
             OR d_gg_set_aut              = d_gg_set
            )
        AND (   d_min_gg_aut             is null
             OR d_min_gg_aut              = d_min_gg
            )
        AND (   d_ore_aut                is null
             OR d_ore_aut                 = d_ore
            )
        AND (   d_fattore_produttivo_aut is null
             OR d_fattore_produttivo_aut  = d_fattore_produttivo
            )
        AND (   d_gestione_aut           is null
             OR d_gestione_aut            = d_gestione
            )
        AND (   d_settore_aut            is null
             OR d_settore_aut             = d_settore
            )
        AND (   d_funzionale_aut         is null
             OR d_funzionale_aut          = d_funzionale
            )
        AND (   d_posizione_aut          is null
             OR d_posizione_aut           = d_posizione
            )
        AND (   d_ruolo_aut              is null
             OR d_ruolo_aut               = d_ruolo
            )
        AND (   d_figura_aut             is null
             OR d_figura_aut              = d_figura
            )
        AND (   d_attivita_aut           is null
             OR d_attivita_aut            = d_attivita
            )
        AND (   d_contratto_aut          is null
             OR d_contratto_aut           = d_contratto
            )
        AND (   d_qualifica_aut          is null
             OR d_qualifica_aut           = d_qualifica
            )
        AND (   d_livello_aut            is null
             OR d_livello_aut             = d_livello
            )
        AND (   d_tipo_rapporto_aut      is null
             OR d_tipo_rapporto_aut       = d_tipo_rapporto
            )
        AND (   d_assistenza_aut         is null
             OR d_assistenza_aut          = d_assistenza
            )
        AND (   d_ufficio_aut            is null
             OR d_ufficio_aut             = d_ufficio
            )
                               THEN
           null;
        ELSE
           RAISE SCARTA;
        END IF;
    END IF;
    IF (    d_condizione       = 'S'
        OR  d_condizione       = 'A'
        AND d_automatismi      = 1
        OR  d_condizione       = 'I'
        AND d_incide_gipe     != 'NO'
        OR  d_condizione       = 'R'
        AND d_mat_fer          = 1
        OR  d_qualificazione  != 'A'
        OR  d_assenza         is null
       )                                     THEN
       RAISE INSERISCE;
    ELSE
       BEGIN
         select 'x'
           into appoggio
           from eventi_presenza evpa
          where nvl(evpa.dal,to_date('2222222','j'))
                                    <= d_al_evpa
            and nvl(evpa.al ,to_date('3333333','j'))
                                    >= d_dal_evpa
            and evpa.ci              = d_ci
            and evpa.input     not  in ('P','A')
            and exists
                (select  'x'
                   from  causali_evento cae2
                        ,astensioni     aste
                  where  cae2.codice = evpa.causale
                    and  aste.codice = cae2.assenza
                    and (    d_condizione     = 'I'
                         and aste.incide_gipe = 'NO'
                         or  d_condizione     = 'A'
                         and aste.automatismi = 0
                         or  d_condizione     = 'R'
                         and aste.mat_fer     = 0
                        )
                )
         ;
         RAISE TOO_MANY_ROWS;
       EXCEPTION
         WHEN TOO_MANY_ROWS THEN
            RAISE SCARTA;
         WHEN NO_DATA_FOUND THEN
            RAISE INSERISCE;
       END;
    END IF;
    BEGIN
      select  aste.automatismi,aste.incide_gipe,aste.mat_fer
        into  d_automatismi,d_incide_gipe,d_mat_fer
        from  astensioni aste
       where  aste.codice   = d_assenza
      ;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
   /*     a00_messaggio('A00003','ASTENSIONI'); trattamento errore */
        w_errore := 'A00003 ASTENSIONI';
        RAISE errore_in_elaborazione;
      WHEN NO_DATA_FOUND THEN
        d_automatismi   := 1;
        d_incide_gipe   := 'SI';
        d_mat_fer       := 1;
    END;
   EXCEPTION
     WHEN SCARTA THEN null;
     WHEN INSERISCE THEN
             BEGIN
             select nvl(rapa.cdc,rifu.cdc)
               into d_cdc_ind
               from ripartizioni_funzionali rifu
                   ,rapporti_presenza       rapa
              where (rifu.settore,rifu.sede) =
                    (select settore,nvl(sede_cdc,0)
                       from periodi_servizio_presenza
                      where ci = d_ci_prec
                        and d_dal_evpa between dal
                                        and nvl(al,to_date('3333333','j'))
                    )
                and rapa.ci        = d_ci_prec
                and d_dal_evpa between rapa.dal
                                  and nvl(rapa.al,to_date('3333333','j'))
             ;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN d_cdc_ind := '';
             END;
       d_valore := round((d_al_evpa - d_dal_evpa + 1) * d_quantita /
                          to_number(to_char(dep_fin_mes,'dd'))
                        ,2);
       insert into eventi_presenza
             (evento,ci,causale,motivo,dal,al,riferimento,chiuso,
              input,valore,sede,cdc,utente,data_agg)
       select evpa_sq.nextval,d_ci,d_causale,d_motivo,d_dal_evpa,
              d_al_evpa,d_dal_evpa,'SI','A',d_valore,
              d_sede,
              nvl(d_cdc,d_cdc_ind),
              a_utente,dep_fin_mes
         from dual
       ;
       IF  d_qualificazione     = 'A'
       AND d_assenza           is not null
       AND P_giuridica = 'SI'     THEN
           insert into deposito_eventi_presenza
                 (rilevanza,ci,assenza,data,operazione,dal,al,
                  utente,data_agg)
           select 'P',d_ci,d_assenza,d_dal_evpa,'I',d_dal_evpa,
                  d_al_evpa,a_utente,SYSDATE
             from dual
           ;
       END IF;
       update rapporti_presenza
          set flag_ec = 'M'
        where ci      = d_ci
          and nvl(dal,to_date('2222222','j'))
                     <= d_dal_evpa
          and nvl(al ,to_date('3333333','j'))
                     >= d_al_evpa
       ;
       d_conta := d_conta + 1;
   END;
  END LOOP;
  close eapa;
  close aupa;
  P_CONTA := d_conta;
END;

procedure GESTIONE_EVENTI is
d_conta number(6);
begin
   ELIMINA_EVENTI;
   d_conta := 0;
   INSERISCE_EVENTI_M (d_conta);
   INSERISCE_EVENTI_G (d_conta);
   IF to_char(dep_ini_mes,'mm') = '01' THEN
      INSERISCE_EVENTI_A    (d_conta);
   END IF;
END;		  

procedure main (p_prenotazione in number,
                      passo in number) is
begin
w_errore := to_char(null);
begin
   select RIPA.ANNO
         ,RIPA.MESE
         ,RIPA.INI_MES
         ,RIPA.FIN_MES
     into DEP_ANNO
         ,DEP_MESE
         ,DEP_INI_MES
         ,DEP_FIN_MES
     from RIFERIMENTO_PRESENZA RIPA
    where ripa.ripa_id = 'RIPA'
   ;
exception when no_data_found then
		  /* trattamento errore  a00_messaggio('P07000',''); /* Riferimento Presenza non pres.*/    
		  w_errore := 'P07000';
		  raise errore_in_elaborazione;
		  when too_many_rows then		  
		  null;
end;
begin
 select ente.giuridica
     into p_giuridica
     from ente
    where ente_id = 'ENTE';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
     /* trattamento errore     a00_messaggio('P00531',' '); */
       /* Manca integrazione Sottosistemi */
	   w_errore := 'P00531';
	   raise errore_in_elaborazione;
    WHEN TOO_MANY_ROWS THEN
 w_errore := 'A00003 ENTE';
	   raise errore_in_elaborazione;
null;
end;
begin
 select utente,ambiente,ente
     into a_utente,a_ambiente,a_ente
     from a_prenotazioni
    where no_prenotazione = p_prenotazione;
end;	

    GESTIONE_EVENTI;		  

exception when errore_in_elaborazione then
	  update a_prenotazioni
    set errore   = w_errore
    where no_prenotazione = p_prenotazione
   ;
   commit;
end;
end;
/

