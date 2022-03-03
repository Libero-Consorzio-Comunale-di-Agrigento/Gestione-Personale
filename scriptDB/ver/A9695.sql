start crv_vidm.sql
insert into a_selezioni 
      (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias
      ,numero_fk) 
values ('P_ANNO_SFASATO','PECCAEDP','13','Anno Previdenziale da Novembre','1','U','N','','P_X','','','');        

start crp_peccaedp.sql                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              

create table dedp_2004_rap_orario as select * from denuncia_inpdap where anno = 2004;


 update denuncia_inpdap dedp
    set rap_orario =
( select sum((  least( nvL(dedp.al,to_date('31122004','ddmmyyyy'))
             , nvl(psep.al,to_date('31122004','ddmmyyyy')))
          - greatest(dedp.dal,psep.dal) + 1)
    * psep.ore / cost.ore_lavoro) gg
    from periodi_servizio_previdenza psep
       , contratti_storici cost
       , posizioni posi
   where psep.gestione = dedp.gestione
     and psep.ci       = dedp.ci
     and cost.contratto   = (select contratto from qualifiche_giuridiche
                           where numero = psep.qualifica
                             and nvl(psep.al,to_date('31122004','ddmmyyyy'))
                                 between dal and nvl(al,to_date('3333333','j'))
                         )
     and nvl(psep.al,to_date('31122004','ddmmyyyy'))
         between cost.dal and nvl(cost.al,to_date('3333333','j'))
     and dedp.dal <= nvl(psep.al,to_date('3333333','j'))
     and nvl(dedp.al,to_date('31122004','ddmmyyyy')) >= psep.dal
     and nvl(psep.ore,cost.ore_lavoro) != cost.ore_lavoro
  and psep.posizione = posi.codice
  and posi.part_time = 'SI'
  )
where dedp.anno = 2004 and dedp.rap_orario is null
and dedp.rilevanza = 'S';

commit;
