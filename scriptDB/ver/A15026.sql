update a_passi_proc set passo = 55 
where voce_menu = 'PECCADMA'
  and passo = 93
;
update a_passi_proc set passo = 56 
where voce_menu = 'PECCADMA'
  and passo = 94
;
update a_passi_proc set passo = 93 
where voce_menu = 'PECCADMA'
  and passo = 91
;
update a_passi_proc set passo = 94 
where voce_menu = 'PECCADMA'
  and passo = 92
;
update a_passi_proc set passo = 91 
where voce_menu = 'PECCADMA'
  and passo = 55
;
update a_passi_proc set passo = 92
where voce_menu = 'PECCADMA'
  and passo = 56
;

start crp_denunce_inpdap.sql
start crp_peccadma.sql

create table rqmi_15026  
as select * from righe_qualifica_ministeriale
;


update righe_qualifica_ministeriale x
set al = (select al from qualifiche_ministeriali
           where codice = x.codice
             and dal    = x.dal
         )
where al is null
and exists (select 'x' from qualifiche_ministeriali
           where codice = x.codice
             and dal    = x.dal
             and al is not null)
;

delete from righe_qualifica_ministeriale x
where not exists
(select 'x' from qualifiche_ministeriali
where dal = x.dal
and nvl(al,to_date('3333333','j')) = nvl(x.al,to_date('3333333','j')) 
and codice = x.codice)
;
