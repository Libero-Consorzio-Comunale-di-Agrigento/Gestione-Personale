CREATE OR REPLACE VIEW QUALIFICHE_SENZA_TETTI
(
codice,descrizione,numero,sequenza,contratto,dal,al
)
AS
select qugi.codice,qugi.descrizione,qugi.numero,qual.sequenza,qugi.contratto,
       qugi.dal,quip.dal-1
  from qualifiche_incentivo  quip
      ,qualifiche            qual
      ,qualifiche_giuridiche qugi
 where quip.numero = qugi.numero
   and qugi.dal = (select min(qug2.dal)
                     from qualifiche_giuridiche qug2
                    where qug2.numero = qugi.numero
                  )
   and quip.dal = (select min(qui2.dal)
                     from qualifiche_incentivo qui2
                    where qui2.numero = quip.numero
                  )
   and nvl(quip.al,to_date('3333333','j')) >= qugi.dal
   and quip.dal <= nvl(qugi.al,to_date('3333333','j'))
   and greatest(qugi.dal,quip.dal) > qugi.dal
   and qual.numero = qugi.numero
union
select qugi.codice,qugi.descrizione,qugi.numero,qual.sequenza,qugi.contratto,
       quip.al+1,qugi.al
  from qualifiche_incentivo  quip
      ,qualifiche            qual
      ,qualifiche_giuridiche qugi
 where quip.numero = qugi.numero
   and qugi.dal = (select max(qug2.dal)
                     from qualifiche_giuridiche qug2
                    where qug2.numero = qugi.numero
                  )
   and quip.dal = (select max(qui2.dal)
                     from qualifiche_incentivo qui2
                    where qui2.numero = quip.numero
                  )
   and nvl(quip.al,to_date('3333333','j')) >= qugi.dal
   and quip.dal <= nvl(qugi.al,to_date('3333333','j'))
   and least(nvl(quip.al,nvl(qugi.al,to_date('3333333','j'))),
             nvl(qugi.al,to_date('3333333','j'))
            ) <
       nvl(qugi.al,to_date('3333333','j'))
   and qual.numero = qugi.numero
union
select qugi.codice,qugi.descrizione,qugi.numero,qual.sequenza,qugi.contratto,
       qugi.dal,qugi.al
  from qualifiche            qual
      ,qualifiche_giuridiche qugi
 where qual.numero = qugi.numero
   and not exists (select 1
                     from qualifiche_incentivo quip
                    where nvl(quip.al,to_date('3333333','j')) >= qugi.dal
                      and quip.dal <= nvl(qugi.al,to_date('3333333','j'))
                      and quip.numero = qugi.numero
                  )
;
