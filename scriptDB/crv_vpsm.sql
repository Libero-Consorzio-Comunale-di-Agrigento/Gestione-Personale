CREATE OR REPLACE VIEW VISTA_PSEP_MESI 
( CI, 
ANNO, 
MESE, 
DAL, 
AL, 
INI_MESE, 
FIN_MESE, 
ASSENZA,
ATTIVITA,
EVENTO,
FIGURA,
GESTIONE,
INIZIO,
ORE,
POSIZIONE,
QUALIFICA,
RILEVANZA,
SEDE,
SEGMENTO,
SETTORE,
TIPO_RAPPORTO,
NOTE
 ) AS 
select  pspr.ci
       ,mesi.anno
       ,mesi.mese
    ,greatest(mesi.ini_mese,pspr.dal)
    ,least(mesi.fin_mese,nvl(pspr.al,to_date(3333333,'j')))
    ,mesi.ini_mese
    ,mesi.fin_mese
    ,pspr.assenza
    ,pspr.attivita
    ,pspr.evento
    ,pspr.figura
    ,pspr.gestione
    ,pspr.inizio
    ,pspr.ore
    ,pspr.posizione
    ,pspr.qualifica
    ,pspr.rilevanza
    ,pspr.sede
    ,pspr.segmento
    ,pspr.settore
    ,pspr.tipo_rapporto
    ,pspr.note
  from  mesi              mesi
       ,periodi_servizio_previdenza   pspr
 where  pspr.dal                          <= mesi.fin_mese
   and  nvl(pspr.al,to_date(3333333,'j')) >= mesi.ini_mese
/