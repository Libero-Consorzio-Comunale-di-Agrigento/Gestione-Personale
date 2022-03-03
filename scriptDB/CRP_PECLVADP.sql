CREATE OR REPLACE PACKAGE PECLVADP IS
/******************************************************************************
 NOME:         PECLVADP
 DESCRIZIONE:  Ricalcolo giorni utili e assestamenti vari
               Questa funzione aggiorna i giorni utili di tutti i record di rilevanza S
               che NON comprendono assenze con servizio_utile 0.

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  Il PARAMETRO D_anno contiene l'anno di elaborazione
               Il PARAMETRO D_tipo determina il tipo di elaborazione da effettuare,
               T e G eseguono l'aggiornamento in oggetto, gli altri
               valori eseguono solo il passo 2

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY PECLVADP IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
begin
DECLARE
  D_ente          varchar2(4); 
  D_ambiente      varchar2(8);
  D_utente        varchar2(8); 
  D_anno          varchar2(4); 
  D_ini_a         varchar2(8);
  D_fin_a         varchar2(8);
  D_tipo          varchar2(1);
  D_giorni        varchar2(1);
  D_rapporto      varchar2(1);
  D_arretrati     varchar2(1);

--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN
BEGIN
  select valore
    into D_tipo
    from a_parametri 
   where no_prenotazione = prenotazione
     and parametro       = 'P_TIPO';
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_tipo := null;
END;
BEGIN
  select valore
    into D_giorni
    from a_parametri 
   where no_prenotazione = prenotazione
     and parametro       = 'P_GIORNI';
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_giorni := null;
END;
BEGIN
  select valore
    into D_rapporto 
    from a_parametri 
   where no_prenotazione = prenotazione
     and parametro       = 'P_RAPPORTO';
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_rapporto  := null;
END;
BEGIN
  select valore
    into D_arretrati
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_ARRETRATI';
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_arretrati  := null;
END;
BEGIN
  select ente     D_ente
       , utente   D_utente
       , ambiente D_ambiente
    into D_ente,D_utente,D_ambiente
    from a_prenotazioni
   where no_prenotazione = prenotazione;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_ente     := null;
       D_utente   := null;
       D_ambiente := null;
END;
--
-- Estrae Anno di Riferimento per archiviazione
--
BEGIN
  select substr(valore,1,4)
       , '0101'||substr(valore,1,4)
       , '3112'||substr(valore,1,4)
    into D_anno
       , D_ini_a
       , D_fin_a
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_ANNO';
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN
         BEGIN
           select anno 
                , '0101'||to_char(anno)
                , '3112'||to_char(anno)
             into D_anno
                , D_ini_a
                , D_fin_a
             from riferimento_fine_anno
            where rifa_id = 'RIFA';
         END;
END;
IF D_tipo in ('T','G') 
   THEN
   update denuncia_inpdap dedp
      set gg_utili  = 
   (select decode( nvl(D_giorni,' ')
                 , 'X', decode( nvl(cost.gg_assenza,'C')
                         , 'P', nvl(dedp.al,to_date(D_fin_a,'ddmmyyyy'))
                                - dedp.dal + 1
                         , 'E', nvl(dedp.al,to_date(D_fin_a,'ddmmyyyy'))
                                - dedp.dal + 1
                              , trunc(months_between
                               (to_date('01'||to_char(dedp.al,'mmyyyy')
                                       ,'ddmmyyyy')
                               ,last_day(dedp.dal)
                               )
                              )*30 +
                         30 - to_char(dedp.dal,'dd') + 1 +
                         least(30,to_char(dedp.al,'dd')) -
                         decode( to_char(dedp.dal,'mmyyyy')
                               , to_char(dedp.al,'mmyyyy'), 30, 0)+
                         decode(to_char(dedp.dal,'ddmm'),'0102',
                           decode(to_char(dedp.al,'ddmm'),'2802',2,0),0))
                       , trunc(months_between
                               (to_date('01'||to_char(dedp.al,'mmyyyy')
                                       ,'ddmmyyyy')
                               ,last_day(dedp.dal)
                               )
                              )*30 +
                         30 - to_char(dedp.dal,'dd') + 1 +
                         least(30,to_char(dedp.al,'dd')) -
                         decode( to_char(dedp.dal,'mmyyyy')
                               , to_char(dedp.al,'mmyyyy'), 30, 0) +
                         decode(to_char(dedp.dal,'ddmm'),'0102',
                           decode(to_char(dedp.al,'ddmm'),'2802',2,0),0))
      from periodi_giuridici pegi, contratti_storici cost
     where pegi.rilevanza = 'S' 
       and pegi.ci        = dedp.ci
       and dedp.dal  between pegi.dal and nvl(pegi.al,to_date('3333333','j'))
       and cost.contratto     = 
          (select contratto from qualifiche_giuridiche
            where numero = pegi.qualifica
              and pegi.dal between nvl(dal,to_date('2222222','j'))
                               and nvl(al,to_date('3333333','j')))
       and pegi.dal between nvl(cost.dal,to_date('2222222','j'))
                        and nvl(cost.al,to_date('3333333','j')))
    where (rilevanza = 'S' or
           rilevanza = 'A' and D_arretrati = 'X')
      and anno = D_anno
      and not exists
         (select 'x' from periodi_giuridici
           where rilevanza = 'A'
             and ci = dedp.ci
             and nvl(al,to_date('333333','j')) >= dedp.dal
             and dal                           <= dedp.al
             and assenza in 
                (select codice 
                   from astensioni
                  where servizio = 0))
;
 update denuncia_inpdap dedp
   set gg_utili  = 
      (select trunc(dedp.gg_utili / cost.ore_lavoro
                             * nvl(pegi.ore,cost.ore_lavoro))
         from periodi_giuridici pegi
            , contratti_storici cost
        where pegi.rilevanza = 'S'
          and pegi.ci        = dedp.ci 
       and dedp.dal  between pegi.dal and nvl(pegi.al,to_date('3333333','j'))
       and cost.contratto     = 
          (select contratto from qualifiche_giuridiche
            where numero = pegi.qualifica
              and pegi.dal between nvl(dal,to_date('2222222','j'))
                               and nvl(al,to_date('3333333','j')))
       and pegi.dal between nvl(cost.dal,to_date('2222222','j'))
                        and nvl(cost.al,to_date('3333333','j')))
 where anno          = D_anno
   and (rilevanza = 'S' or
        rilevanza = 'A' and D_arretrati = 'X')
   and tipo_impiego = 8
   and D_rapporto    = 'X'
;
commit;
END IF;
IF D_tipo in ('T','S') 
   THEN
   update denuncia_inpdap dedp
      set (tipo_impiego,tipo_servizio) = 
   (select max(decode( posi.contratto_formazione
                 , 'NO', decode
                         ( posi.stagionale
                         , 'GG', '2'
                               , decode
                                 ( posi.part_time
                                 , 'SI', '8'
                                       , decode
                                         ( nvl(psep.ore,cost.ore_lavoro)
                                         , cost.ore_lavoro, '1'
                                                          , '9')
                                 )
                         )
                       , posi.tipo_formazione) )                  impiego
         , max(decode( psep.assenza
                 , null, decode
                         ( nvl(psep.ore,cost.ore_lavoro)
                         , cost.ore_lavoro, '11'
                                          , '12')
                       , aste.cat_fiscale)     )                  servizio
      from riferimento_retribuzione    rire
         , posizioni                   posi
         , astensioni                  aste
         , qualifiche_giuridiche       qugi
         , contratti_storici           cost
         , periodi_servizio_previdenza psep
     where rire.rire_id        = 'RIRE'
       and psep.ci             = dedp.ci
       and psep.gestione       = dedp.gestione
       and dedp.al       between psep.dal
                             and nvl(psep.al,to_date('3333333','j')) 
       and aste.codice    (+)  = psep.assenza
       and aste.servizio  (+) != 0
       and posi.codice    (+)  = psep.posizione
       and qugi.numero         = psep.qualifica
       and nvl(psep.al,to_date(D_fin_a,'ddmmyyyy')) between qugi.dal
                                    and nvl(qugi.al,to_date('3333333','j'))
       and cost.contratto      = qugi.contratto
       and nvl(psep.al,to_date(D_fin_a,'ddmmyyyy')) between cost.dal
                                    and nvl(cost.al,to_date('3333333','j'))
       and psep.dal <= nvl(psep.al,to_date('3333333','j'))
       and psep.segmento      in 
          (select 'i' from dual
            union
           select 'a' from dual
            union 
           select 'c' from dual
            union 
           select 'f' from dual
            union 
           select 'u' from dual 
            where not exists
                 (select 'x' 
                    from periodi_servizio_previdenza
                   where ci      = psep.ci
                     and segmento = 'a'
                     and dal     <= psep.dal
                     and nvl(al,to_date('3333333','j')) >= psep.dal)
          )
   ) 
where anno      = D_anno
--  and rilevanza = 'A'
  and (tipo_impiego is null or 
      tipo_servizio is null)
;
commit;
END IF;
IF D_tipo in ('T','I') THEN
update denuncia_inpdap
   set assicurazioni = substr(assicurazioni,1,instr(assicurazioni,'6')-1)||
                       substr(assicurazioni,instr(assicurazioni,'6')+1)
 where anno = D_anno
   and nvl(comp_inadel,0) = 0
   and instr(assicurazioni,'6') != 0
;
commit;
END IF;
IF D_tipo in ('T','D') THEN
  update denuncia_inpdap set competenza = D_anno  
   where rilevanza = 'A'
     and anno = D_anno
     and competenza < D_anno 
     and nvl(comp_fisse,0) != 0
     and nvl(comp_accessorie,0) = 0
  ; 
  insert into denuncia_inpdap 
         (anno,
          previdenza,assicurazioni,
          ci,
          gestione,codice,
          posizione,rilevanza,
          dal,al,
          tipo_impiego, tipo_servizio,
          gg_utili,
          data_cessazione,
          comp_fisse,comp_accessorie,
          comp_inadel,premio_prod,
          riferimento,competenza,
          utente,
          tipo_agg,data_agg)
   select anno,
          previdenza,assicurazioni,
          ci,
          gestione,codice,
          posizione,rilevanza,
          dal,al,
          tipo_impiego, tipo_servizio,
          gg_utili,
          data_cessazione,
          comp_fisse,0,
          comp_inadel,premio_prod,
          riferimento,D_anno,
          utente,
          tipo_agg,data_agg
     from denuncia_inpdap
    where rilevanza = 'A'
      and anno = D_anno
      and nvl(comp_fisse,0) != 0
      and nvl(comp_accessorie,0) != 0
  ;
  update denuncia_inpdap set comp_fisse = 0,
                             comp_inadel = 0
   where rilevanza = 'A'
     and anno = D_anno
     and competenza < D_anno
     and nvl(comp_fisse,0) != 0
     and nvl(comp_accessorie,0) != 0
  ;
  update denuncia_inpdap set competenza = riferimento
   where rilevanza = 'A'
     and anno = D_anno
     and competenza < D_anno
     and nvl(comp_fisse,0) = 0
     and nvl(comp_accessorie,0) != 0
  ;
END IF;
END;
end;
end;
/
