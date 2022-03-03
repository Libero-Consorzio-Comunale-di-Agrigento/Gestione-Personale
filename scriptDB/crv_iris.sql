-- Viste per integrazione anagrafico/giuridica
CREATE OR REPLACE FORCE VIEW RP_V_ANAGRAFICI
(NI, COGNOME, NOME, SESSO, DATA_NAS, 
 COMUNE_NAS, CODICE_FISCALE, DAL, AL, INDIRIZZO_DOM, 
 COMUNE_DOM, CITTA_DOM, CAP_DOM, TEL_DOM, INDIRIZZO_RES, 
 COMUNE_RES, CITTA_RES, CAP_RES, TEL_RES, STATO_CIVILE)
AS 
SELECT DISTINCT anag.ni 
                  ,anag.cognome 
                  ,anag.nome 
                  ,sesso 
                  ,anag.data_nas 
                  , LPAD (anag.provincia_nas, 3, '0') || LPAD (anag.comune_nas, 3, '0') comune_nas 
                  ,anag.codice_fiscale 
                  ,anag.dal 
                  ,anag.al 
                  ,anag.indirizzo_dom 
                  , LPAD (anag.provincia_dom, 3, '0') || LPAD (anag.comune_dom, 3, '0') comune_dom 
                  ,RTRIM (comuni_dom.descrizione) citta_dom 
                  ,anag.cap_dom 
                  ,anag.tel_dom 
                  ,anag.indirizzo_res 
                  , LPAD (anag.provincia_res, 3, '0') || LPAD (anag.comune_res, 3, '0') comune_res 
                  ,RTRIM (comuni_res.descrizione) citta_res 
                  ,anag.cap_res 
                  ,anag.tel_res 
				  ,anag.stato_civile 
              FROM comuni comuni_dom 
                  ,comuni comuni_res 
                  ,anagrafici anag 
                  ,individui_modificati inmo 
             WHERE provincia_dom = comuni_dom.cod_provincia 
               AND comune_dom = comuni_dom.cod_comune 
               AND provincia_res = comuni_res.cod_provincia 
               AND comune_res = comuni_res.cod_comune 
               AND anag.ni = inmo.ni 
               AND inmo.tabella = 'ANAGRAFICI' 
               AND operazione <> 'D'
;

CREATE OR REPLACE FORCE VIEW rp_v_familiari
(ni, decorrenza, cognome, nome, comnas, datanas, gradopar, matricola)
as
select fami.ni
      ,fami.dal
      ,fami.cognome
      ,fami.nome
      ,gp4am.get_comune_nascita(fami.codice_fiscale)
      ,fami.data_nas
      ,decode(instr(pare.descrizione, '[FG]')
             ,0
             ,decode(instr(pare.descrizione, '[CG]')
                    ,0
                    ,decode(instr(pare.descrizione, '[GE]')
                           ,0
                           ,decode(instr(pare.descrizione, '[FR]'), 0, 'AL', 'FR')
                           ,'GE')
                    ,'CG')
             ,'FG')
      ,pxirisfa.get_matricola_familiare(fami.cognome, fami.nome, fami.codice_fiscale)
  from familiari fami
      ,parentele pare
 where fami.relazione = pare.sequenza
   and fami.ni in (select ni
                     from individui_modificati
                    where tabella = 'FAMILIARI'
                      and operazione in (select 'I'
                                           from dual
                                         union
                                         select 'U' from dual))
;

CREATE OR REPLACE FORCE VIEW RP_V_COMUNI
(CODICE, DESCRIZIONE, CAP, SIGLA_PROVINCIA, CODICE_CATASTO)
AS 
SELECT lpad(cod_provincia, 3, '0') || lpad(cod_comune, 3, '0') codice
      ,descrizione
      ,cap
      ,substr(sigla_provincia, 1, 2)
      ,codice_catasto  
  FROM comuni
;

CREATE OR REPLACE FORCE VIEW RP_V_CODICI_ATTIVITA
(CODICE, DESCRIZIONE)
AS 
SELECT DISTINCT codice
               ,substr(descrizione, 1, 120) descrizione
  FROM attivita
;

CREATE OR REPLACE FORCE VIEW RP_V_CODICI_ASSUNZIONE
(CODICE, DESCRIZIONE)
AS 
SELECT codice 
         ,descrizione 
     FROM eventi_rapporto 
    WHERE rilevanza = 'I'
;


CREATE OR REPLACE FORCE VIEW RP_V_CODICI_DIMISSIONE
(CODICE, DESCRIZIONE)
AS 
SELECT codice 
         ,descrizione 
     FROM eventi_rapporto 
    WHERE rilevanza = 'T'
;


CREATE OR REPLACE FORCE VIEW RP_V_CODICI_MINIST
(NI, CI, DAL, AL, SCADENZA, 
 COD_MIN)
AS 
SELECT DISTINCT inmo.ni 
                  ,pegi.ci 
                  ,pegi.dal 
                  ,pegi.al 
                  ,DECODE (pegi.dal 
                          ,pxirisfa.get_datamax (pegi.ci, 'S'), TO_DATE ('31123999', 'DDMMYYYY') 
                          ,pegi.al 
                          ) scadenza 
                  ,mini.cod_min 
              FROM periodi_giuridici pegi 
                  ,qualifiche_giuridiche qugi 
                  ,figure_giuridiche figi 
                  ,codici_min_individuali mini 
                  ,individui_modificati inmo 
             WHERE pegi.ci = inmo.ci 
               AND pegi.rilevanza = 'S' 
               AND pegi.qualifica = qugi.numero 
               AND NVL (pegi.al, TO_DATE ('31123999', 'DDMMYYYY') ) BETWEEN qugi.dal 
                                                                        AND NVL 
                                                                              (qugi.al 
                                                                              ,TO_DATE ('31123999' 
                                                                                       ,'DDMMYYYY' 
                                                                                       ) 
                                                                              ) 
               AND pegi.figura = figi.numero 
               AND NVL (pegi.al, TO_DATE ('31123999', 'DDMMYYYY') ) BETWEEN figi.dal 
                                                                        AND NVL 
                                                                              (figi.al 
                                                                              ,TO_DATE ('31123999' 
                                                                                       ,'DDMMYYYY' 
                                                                                       ) 
                                                                              ) 
               AND inmo.ni = mini.ni 
               AND pegi.dal = mini.dal 
               AND qugi.codice = mini.qualifica 
               AND figi.codice = mini.figura 
               AND pegi.ci = inmo.ci 
               AND pegi.rilevanza = inmo.rilevanza 
               AND inmo.tabella = 'CODICI_MINIST'
;


CREATE OR REPLACE FORCE VIEW RP_V_FIGURE_GIURIDICHE AS
SELECT codice
         ,descrizione
         ,profilo
         ,gp4_prpr.get_descrizione(profilo) descrizione_profilo
         ,posizione
         ,gp4_pofu.get_descrizione(profilo,posizione) descrizione_posizione
     FROM figure_giuridiche
    WHERE al IS NULL
;


CREATE OR REPLACE FORCE VIEW rp_v_periodi_giuridici
( ni, ci, dal, al, scadenza, tipo_rapporto, posizione, attivita, ore
, qualifica, contratto, livello, ruolo, diruolo, figura, profilo
, posizione_funzionale, profilo_posizione, settore, gestione, zona
, presidio, sett_terzo, sett_quarto, sett_quinto, sett_sesto, sede
, cdc, posizione_inail, tipo_part_time)
as
select distinct rain.ni
               ,rain.ci
               ,pegi.dal
               ,pegi.al
               ,decode(pegi.dal
                      ,pxirisfa.get_datamax(pegi.ci, 'S')
                      ,to_date('31123999', 'DDMMYYYY')
                      ,pegi.al) scadenza
               ,pegi.tipo_rapporto
               ,pegi.posizione
               ,pegi.attivita
               ,pegi.ore
               ,qugi.codice qualifica
               ,qugi.contratto
               ,qugi.livello
               ,qugi.ruolo
               ,posi.ruolo diruolo
               ,figi.codice figura
               ,figi.profilo
               ,figi.posizione
               ,nvl(lpad(figi.profilo, 4, '0'), '0000') ||
                nvl(lpad(figi.posizione, 4, '0'), '0000')
               ,gp4_unor.get_codice_uo(gp4_stam.get_ni_numero(pegi.settore)
                                      ,'GP4'
                                      ,nvl(pegi.al, to_date(3333333, 'j'))) settore
               ,pegi.gestione
               ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 1)
                                      ,'GP4'
                                      ,nvl(pegi.al, to_date(3333333, 'j'))) zona
               ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 2)
                                      ,'GP4'
                                      ,nvl(pegi.al, to_date(3333333, 'j'))) presidio
               ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 3)
                                      ,'GP4'
                                      ,nvl(pegi.al, to_date(3333333, 'j'))) sett_terzo
               ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 4)
                                      ,'GP4'
                                      ,nvl(pegi.al, to_date(3333333, 'j'))) sett_quarto
               ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 5)
                                      ,'GP4'
                                      ,nvl(pegi.al, to_date(3333333, 'j'))) sett_quinto
               ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 6)
                                      ,'GP4'
                                      ,nvl(pegi.al, to_date(3333333, 'j'))) sett_sesto
               ,gp4_sdam.get_codice_numero(pegi.sede) sede
               ,pxirisfa.get_cdc(pegi.settore, nvl(pegi.sede, 0)) cdc
               ,peccrein.get_posizione_inail(pegi.ci
                                            ,nvl(pegi.al, to_date(3333333, 'j'))) posizione_inail
               ,posi.tipo_part_time
  from qualifiche_giuridiche  qugi
      ,posizioni              posi
      ,figure_giuridiche      figi
      ,rapporti_individuali   rain
      ,settori_amministrativi stam
      ,revisioni_struttura    rest
      ,periodi_giuridici      pegi
 where 1 = 1
   and pegi.ci in (select ci
                     from individui_modificati
                    where tabella = 'PERIODI_GIURIDICI'
                      and operazione in (select 'I'
                                           from dual
                                         union
                                         select 'U' from dual)
                      and rilevanza = 'S')
   and pegi.rilevanza = 'S'
   and stam.numero = pegi.settore
   and rest.dal = (select max(dal)
                     from revisioni_struttura
                    where dal <= nvl(pegi.al, to_date('3333333', 'j'))
                      and stato in ('A', 'O'))
   and qugi.numero = pegi.qualifica
   and nvl(pegi.al, to_date(3333333, 'j')) between qugi.dal and
       nvl(qugi.al, to_date(3333333, 'j'))
   and pegi.posizione = posi.codice
   and figi.numero = pegi.figura
   and nvl(pegi.al, to_date(3333333, 'j')) between figi.dal and
       nvl(figi.al, to_date(3333333, 'j'))
   and rain.ci = pegi.ci
union
select distinct rain.ni
               ,rain.ci
               ,pegi.dal
               ,pegi.al
               ,decode(pegi.dal
                      ,pxirisfa.get_datamax(pegi.ci, 'S')
                      ,to_date('31123999', 'DDMMYYYY')
                      ,pegi.al) scadenza
               ,pegi.tipo_rapporto
               ,pegi.posizione
               ,pegi.attivita
               ,pegi.ore
               ,''
               ,''
               ,''
               ,''
               ,posi.ruolo diruolo
               ,figi.codice figura
               ,figi.profilo
               ,figi.posizione
               ,nvl(lpad(figi.profilo, 4, '0'), '0000') ||
                nvl(lpad(figi.posizione, 4, '0'), '0000')
               ,gp4_unor.get_codice_uo(gp4_stam.get_ni_numero(pegi.settore)
                                      ,'GP4'
                                      ,nvl(pegi.al, to_date(3333333, 'j'))) settore
               ,pegi.gestione
               ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 1)
                                      ,'GP4'
                                      ,nvl(pegi.al, to_date(3333333, 'j'))) zona
               ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 2)
                                      ,'GP4'
                                      ,nvl(pegi.al, to_date(3333333, 'j'))) presidio
               ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 3)
                                      ,'GP4'
                                      ,nvl(pegi.al, to_date(3333333, 'j'))) sett_terzo
               ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 4)
                                      ,'GP4'
                                      ,nvl(pegi.al, to_date(3333333, 'j'))) sett_quarto
               ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 5)
                                      ,'GP4'
                                      ,nvl(pegi.al, to_date(3333333, 'j'))) sett_quinto
               ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 6)
                                      ,'GP4'
                                      ,nvl(pegi.al, to_date(3333333, 'j'))) sett_sesto
               ,gp4_sdam.get_codice_numero(pegi.sede) sede
               ,pxirisfa.get_cdc(pegi.settore, nvl(pegi.sede, 0)) cdc
               ,peccrein.get_posizione_inail(pegi.ci
                                            ,nvl(pegi.al, to_date(3333333, 'j'))) posizione_inail
               ,posi.tipo_part_time
  from posizioni              posi
      ,figure_giuridiche      figi
      ,rapporti_individuali   rain
      ,settori_amministrativi stam
      ,revisioni_struttura    rest
      ,periodi_giuridici      pegi
 where 1 = 1
   and pegi.ci in (select ci
                     from individui_modificati
                    where tabella = 'PERIODI_GIURIDICI'
                      and operazione in (select 'I'
                                           from dual
                                         union
                                         select 'U' from dual)
                      and rilevanza = 'Q')
   and pegi.rilevanza = 'Q'
   and stam.numero = pegi.settore
   and rest.dal = (select max(dal)
                     from revisioni_struttura
                    where dal <= nvl(pegi.al, to_date('3333333', 'j'))
                      and stato in ('A', 'O'))
   and pegi.posizione = posi.codice
   and figi.numero = pegi.figura
   and nvl(pegi.al, to_date(3333333, 'j')) between figi.dal and
       nvl(figi.al, to_date(3333333, 'j'))
   and rain.ci = pegi.ci
;


CREATE OR REPLACE FORCE VIEW RP_V_PERIODI_RAPPORTO
(NI, CI, DAL, AL, SCADENZA, 
 COD_ASSUNZIONE, COD_DIMISSIONI)
AS 
SELECT DISTINCT inmo.ni 
                  ,pegi.ci 
                  ,pegi.dal 
                  ,pegi.al 
                  ,DECODE (pegi.dal 
                          ,LEAST (pxirisfa.get_dataaperta (pegi.ci, 'P') 
                                 ,pxirisfa.get_datamax (pegi.ci, 'P') 
                                 ), TO_DATE ('31123999', 'DDMMYYYY') 
                          ,NVL (pegi.al, TO_DATE ('31123999', 'DDMMYYYY') ) 
                          ) scadenza 
                  ,pegi.evento 
                  ,pegi.posizione 
              FROM periodi_giuridici pegi 
                  ,individui_modificati inmo 
             WHERE pegi.rilevanza = 'P' 
               AND pegi.ci = inmo.ci 
               AND NOT EXISTS ( 
                      SELECT 'X' 
                        FROM periodi_giuridici 
                       WHERE ci IN (SELECT ci 
                                      FROM rapporti_individuali 
                                     WHERE ni = inmo.ni) 
                         AND pxirisfa.individuo_presente (inmo.ci) = 'SI' 
                         AND rilevanza = 'P' 
                         AND (   pegi.dal <> dal 
                              OR NVL (pegi.al, TO_DATE ('31123999', 'DDMMYYYY') ) <> 
                                                         NVL (al, TO_DATE ('31123999', 'DDMMYYYY') ) 
                             ) 
                         AND (   pegi.dal BETWEEN dal AND NVL (al, TO_DATE ('31123999', 'DDMMYYYY') ) 
                              OR NVL (pegi.al, TO_DATE ('31123999', 'DDMMYYYY') ) BETWEEN dal 
                                                                                      AND NVL 
                                                                                            (al 
                                                                                            ,TO_DATE 
                                                                                                ('31123999' 
                                                                                                ,'DDMMYYYY' 
                                                                                                ) 
                                                                                            ) 
                             ) 
                         AND pegi.dal BETWEEN dal AND NVL (al, TO_DATE ('31123999', 'DDMMYYYY') ) 
                         AND pegi.al IS NOT NULL 
                         AND al IS NULL) 
               AND pegi.ci = inmo.ci 
               AND pegi.rilevanza = inmo.rilevanza 
               AND inmo.tabella = 'PERIODI_RAPPORTO' 
               AND operazione <> 'D'
;


CREATE OR REPLACE FORCE VIEW RP_V_POSIZIONI_INAIL
(CODICE, DESCRIZIONE, POSIZIONE)
AS 
SELECT codice 
         ,descrizione 
         ,posizione 
     FROM assicurazioni_inail
;


CREATE OR REPLACE FORCE VIEW RP_V_PRESIDIO
(CODICE, DESCRIZIONE)
AS 
SELECT DISTINCT reuo.codice_figlio codice 
               ,gp4_unor.get_descrizione (reuo.figlio) descrizione 
           FROM relazioni_uo reuo 
          WHERE reuo.revisione = gp4gm.get_revisione (SYSDATE) 
            AND reuo.suddivisione_figlio = 2
;


CREATE OR REPLACE FORCE VIEW RP_V_QUALIFICHE_GIURIDICHE
(CODICE, DESCRIZIONE)
AS 
select codice 
         ,descrizione 
     from qualifiche_giuridiche 
    where al is null
;


CREATE OR REPLACE FORCE VIEW rp_v_settori as
select unor.codice_uo codice
      ,unor.descrizione descrizione
      ,sedi.codice sede
      ,rifu.cdc cdc
      ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 1)
                             ,'GP4'
                             ,sysdate) zona
      ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 2)
                             ,'GP4'
                             ,sysdate) presidio
      ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 3)
                             ,'GP4'
                             ,sysdate) sett_terzo
      ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 4)
                             ,'GP4'
                             ,sysdate) sett_quarto
      ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 5)
                             ,'GP4'
                             ,sysdate) sett_quinto
      ,gp4_unor.get_codice_uo(gp4_reuo.get_ni_padre(rest.revisione, stam.ni, 6)
                             ,'GP4'
                             ,sysdate) sett_sesto
  from settori_amministrativi  stam
      ,unita_organizzative     unor
      ,sedi                    sedi
      ,revisioni_struttura     rest
      ,ripartizioni_funzionali rifu
 where stam.numero = rifu.settore
   and sedi.numero(+) = rifu.sede
   and unor.ni = stam.ni
   and unor.revisione = rest.revisione
   and rest.dal = (select max(dal)
                     from revisioni_struttura
                    where dal <= sysdate
                      and stato in ('A', 'O'))
   and sysdate between unor.dal and nvl(unor.al, sysdate)
;

CREATE OR REPLACE FORCE VIEW RP_V_SINDACATI
(CODICE, DESCRIZIONE)
AS 
SELECT DISTINCT covo.des_abb codice 
               ,covo.des_abb descrizione 
           FROM contabilita_voce covo 
          WHERE 1 = 1 
            AND EXISTS (SELECT 'x' 
                          FROM voci_economiche 
                         WHERE codice = covo.voce 
                           AND specifica = 'SIN') 
            AND UPPER (covo.des_abb) <> 'NO'
;


CREATE OR REPLACE FORCE VIEW RP_V_SINDACATO
(NI, DAL, AL, SINDACATO)
AS 
SELECT inmo.ni 
         ,inre.dal 
         ,inre.al 
         ,covo.des_abb sindacato 
     FROM contabilita_voce covo 
         ,informazioni_retributive inre 
         ,individui_modificati inmo 
    WHERE covo.voce = inre.voce 
      AND EXISTS (SELECT 'x' 
                    FROM voci_economiche 
                   WHERE codice = covo.voce 
                     AND specifica = 'SIN') 
      AND UPPER (covo.des_abb) <> 'NO' 
      AND inmo.ci = inre.ci 
      AND inmo.tabella = 'SINDACATO' 
      AND operazione <> 'D'
;


CREATE OR REPLACE FORCE VIEW RP_V_STATI_CIVILI
(CODICE, DESCRIZIONE)
AS 
SELECT codice 
         ,descrizione 
     FROM stati_civili
;


CREATE OR REPLACE FORCE VIEW RP_V_ZONA
(CODICE, DESCRIZIONE)
AS 
select distinct reuo.codice_figlio codice 
        ,gp4_unor.get_descrizione (reuo.figlio) descrizione 
    FROM relazioni_uo reuo 
   WHERE reuo.revisione = gp4gm.get_revisione (SYSDATE) 
     and reuo.suddivisione_figlio=1
;

CREATE OR REPLACE FORCE VIEW RP_V_SETT_TERZO AS
select distinct reuo.codice_figlio codice
               ,gp4_unor.get_descrizione(reuo.figlio) descrizione
  from relazioni_uo reuo
 where reuo.revisione = gp4gm.get_revisione(sysdate)
   and reuo.suddivisione_figlio = 3
;

CREATE OR REPLACE FORCE VIEW RP_V_SETT_QUARTO AS
select distinct reuo.codice_figlio codice
               ,gp4_unor.get_descrizione(reuo.figlio) descrizione
  from relazioni_uo reuo
 where reuo.revisione = gp4gm.get_revisione(sysdate)
   and reuo.suddivisione_figlio = 4
;

CREATE OR REPLACE FORCE VIEW RP_V_SETT_QUINTO AS
select distinct reuo.codice_figlio codice
               ,gp4_unor.get_descrizione(reuo.figlio) descrizione
  from relazioni_uo reuo
 where reuo.revisione = gp4gm.get_revisione(sysdate)
   and reuo.suddivisione_figlio = 5
;

CREATE OR REPLACE FORCE VIEW RP_V_SETT_SESTO AS
select distinct reuo.codice_figlio codice
               ,gp4_unor.get_descrizione(reuo.figlio) descrizione
  from relazioni_uo reuo
 where reuo.revisione = gp4gm.get_revisione(sysdate)
   and reuo.suddivisione_figlio = 6
;

CREATE OR REPLACE FORCE VIEW rp_v_suddivisioni_struttura as
select livello
      ,sequenza ordinamento
      ,denominazione
  from suddivisioni_struttura
union
select 'SEDE'
      ,999999
      ,nota_sede
  from ente
 order by 2
;

-- Vista per acquisizione periodi di assenza di rilevanza giuridica

CREATE OR REPLACE FORCE VIEW assenze_iris as
select rain.ci
      ,iris.matricola     ni
      ,cagi.causale
      ,caev.assenza   
      ,iris.dal
      ,iris.al
      ,iris.operazione
      ,iris.data_agg
      ,iris.id
  from rapporti_individuali     rain
      ,causali_evento           caev
      ,causali_giustificativo   cagi
      ,iris_v042_periodiassenza iris
 where rain.ni = iris.matricola
   and iris.dal between rain.dal and nvl(rain.al,to_date(3333333,'j'))
   and exists
      (select 'x' from classi_rapporto
        where rain.rapporto = codice
          and presenza      = 'SI'
      )
   and iris.tipogiust           = 'I'
   and iris.vocepaghe = cagi.codice        
   and caev.codice    = cagi.causale
;

-- Vista per acquisizione periodi di assenza per gestione part-time verticali

CREATE OR REPLACE FORCE VIEW calendari_iris as
select ca_iris.PROGRESSIVO
      ,ca_iris.data
      ,ca_iris.festivo
      ,ca_iris.lavorativo
      ,ca_iris.numgiorni
  from iris_v010_calendari ca_iris;

-- Vista per acquisizione causali di presenza

CREATE OR REPLACE FORCE VIEW deposito_eventi_rilevazione 
as
select   to_char('')             evento
      ,  matricola               ci
      ,  codpaghe                giustificativo
      ,  to_char(null)           motivo
      ,  dal
      ,  al
      ,  riferimento
      ,  chiuso
      ,  input
      ,  classe
      ,  dalle
      ,  alle
      ,  valore
      ,  cdc
      ,  sede
      ,  note
      ,  utente
      ,  data_agg
  from   iris_pagheads
;

-- Vista per acquisizione variazioni di settore/sede

CREATE OR REPLACE FORCE VIEW periodi_iris as 
select rain.ci
      ,greatest(st_iris.datadecorrenza, st_iris.inizio) dal
      ,decode(to_char(least(st_iris.datafine, nvl(st_iris.fine, st_iris.datafine))
                     ,'DDMMYYYY')
             ,'31123999'
             ,to_date(null)
             ,least(st_iris.datafine, nvl(st_iris.fine, st_iris.datafine))) al
      ,st_iris.settore cod_settore
      ,sett.numero num_settore
      ,st_iris.sede cod_sede
      ,sedi.numero num_sede
  from rapporti_individuali     rain
      ,settori                  sett
      ,sedi                     sedi
      ,iris_t030_anagrafico     an_iris
      ,iris_t430_storico        st_iris
 where rain.ni = an_iris.matricola
   and st_iris.progressivo = an_iris.progressivo
   and st_iris.datadecorrenza <= nvl(rain.al, st_iris.datadecorrenza)
   and rain.dal <= st_iris.datafine
   and exists (select 'x'
          from classi_rapporto
         where rain.rapporto = codice
           and presenza = 'SI')
   and sett.codice(+) = st_iris.settore
   and sedi.codice(+) = st_iris.sede;

-- Vista per acquisire i part time verticali da IRIS

CREATE OR REPLACE FORCE VIEW part_time_verticali_iris as
select rain.ci
      ,st_iris.progressivo
      ,st_iris.datadecorrenza dal
      ,st_iris.datafine al
      ,st_iris.parttime tipo_pt
  from iris_t460_parttime       pt_iris
      ,rapporti_individuali     rain
      ,iris_t030_anagrafico     an_iris
      ,iris_t430_storico        st_iris
 where rain.ni = an_iris.matricola
   and pt_iris.codice = st_iris.parttime
   and pt_iris.tipo = 'V'
   and st_iris.progressivo = an_iris.progressivo
   and exists (select 'x'
          from classi_rapporto
         where rain.rapporto = codice
           and presenza = 'SI')
   and st_iris.datadecorrenza <= nvl(rain.al,to_date(3333333,'j'))
   and st_iris.datafine >= rain.dal
 order by rain.ci;

-- Vista per sindacati

CREATE OR REPLACE FORCE VIEW sindacati_iris as
     select rain.ni
           ,inre.dal
           ,inre.al
           ,covo.des_abb sindacato
           ,inre.ci
       from contabilita_voce     covo
           ,rapporti_individuali rain
           ,informazioni_retributive inre
      where covo.voce = inre.voce
        and exists
           (select 'x' from voci_economiche
             where codice    = covo.voce
               and specifica = 'SIN'
           )
        and upper(covo.des_abb) <> 'NO'
        and rain.ci   = inre.ci
;

-- Qualilfiche MInisteriali individuali

CREATE OR REPLACE FORCE VIEW CODICI_MIN_INDIVIDUALI ( NI, 
CI, DAL, AL, FIGURA, 
QUALIFICA, COD_MIN ) AS select  rain.ni  
       ,rain.ci  
       ,greatest(pegi.dal,rqmi.dal) dal  
       ,least(nvl(pegi.al,to_date('31123999','ddmmyyyy')),nvl(rqmi.al,to_date('31123999','ddmmyyyy'))) al  
       ,figi.codice figura  
       ,qugi.codice qualifica  
       ,rqmi.codice cod_min  
  from righe_qualifica_ministeriale rqmi  
     , posizioni                    posi  
     , figure_giuridiche            figi  
     , qualifiche_giuridiche        qugi  
     , rapporti_individuali         rain  
     , periodi_giuridici            pegi  
 where rain.ci               = pegi.ci  
   and rain.rapporto in  
      (select codice from classi_rapporto  
        where giuridico = 'SI'  
          and presenza  = 'SI'  
          and retributivo = 'SI'  
      )  
   and pegi.dal        between rain.dal and nvl(rain.al,pegi.dal)  
   and pegi.rilevanza        = 'S'  
   and qugi.numero           = pegi.qualifica  
   and figi.numero           = pegi.figura  
   and pegi.dal        between figi.dal and nvl(figi.al,pegi.dal)  
   and pegi.dal        between qugi.dal and nvl(qugi.al,pegi.dal)  
   and pegi.dal                          <= nvl(rqmi.al,to_date(3333333,'j'))  
   and nvl(pegi.al,to_date(3333333,'j')) >= rqmi.dal  
   and posi.codice           = pegi.posizione  
   and (   (    rqmi.qualifica is null  
            and rqmi.figura     = pegi.figura)  
        or (    rqmi.figura    is null  
            and rqmi.qualifica  = pegi.qualifica)  
        or (    rqmi.qualifica is not null  
            and rqmi.figura    is not null  
            and rqmi.qualifica  = pegi.qualifica  
            and rqmi.figura     = pegi.figura)  
        or (    rqmi.qualifica is null  
            and rqmi.figura    is null)  
       )  
   and nvl(rqmi.di_ruolo,posi.di_ruolo)   = posi.di_ruolo  
   and nvl(rqmi.tempo_determinato,posi.tempo_determinato)  
                                          = posi.tempo_determinato  
   and nvl(rqmi.part_time,posi.part_time) = posi.part_time  
   and nvl( rqmi.tipo_rapporto  
          , nvl(pegi.tipo_rapporto,'NULL')) = nvl(pegi.tipo_rapporto,'NULL')
;

CREATE OR REPLACE FORCE VIEW timbrature_giornaliere_iris as
select iris.matricola
      ,rain.ci
      ,iris.data
      ,iris.data_char
      ,iris.ora
      ,iris.ora_char
      ,iris.verso
      ,iris.rilevatore
      ,iris.des_rilevatore
      ,iris.causale
      ,iris.des_causale
  from rapporti_individuali rain
      ,iris_timbrature  iris
 where rain.ni = iris.matricola
   and iris.data between rain.dal and nvl(rain.al, to_date(3333333, 'j'))
   and exists (select 'x'
          from classi_rapporto
         where rain.rapporto = codice
           and presenza = 'SI')
;