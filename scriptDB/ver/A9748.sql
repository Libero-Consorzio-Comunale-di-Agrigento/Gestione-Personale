
--select ci,anno,mese,mensilita,
--DED_BASE               
--,DED_AGG                
--,DED_CON                
--,DED_FIG                
--,DED_ALT                
--,DED_TOT
--,DED_FIS                
--,IPN_ORD
--from movimenti_fiscali
--where anno = 2005
--and ded_tot < 0
--and ded_fis = 0
--and ipn_ord > 0
--;

create table salva_moco20050216 as
select * from movimenti_contabili moco
where anno = 2005
and voce = (select codice from voci_economiche 
where automatismo = 'IRPEF_ORD')
and exists (select 'x' from movimenti_fiscali
where anno = moco.anno 
and mese = moco.mese
and mensilita = moco.mensilita
and ci = moco.ci
and ded_tot < 0
and ded_fis = 0
and ipn_ord > 0
)
;
update movimenti_contabili moco
set tar = (select moco.tar - ded_tot from movimenti_fiscali
where anno = moco.anno 
and mese = moco.mese
and mensilita = moco.mensilita
and ci = moco.ci)
where anno = 2005
and voce = (select codice from voci_economiche 
where automatismo = 'IRPEF_ORD')
and exists (select 'x' from movimenti_fiscali
where anno = moco.anno 
and mese = moco.mese
and mensilita = moco.mensilita
and ci = moco.ci
and ded_tot < 0
and ded_fis = 0
and ipn_ord > 0
)
;
create table salva_mofi20050216 as
select * from movimenti_fiscali
where anno = 2005
and ded_tot < 0
and ded_fis = 0
and ipn_ord > 0
;
update movimenti_fiscali 
set ded_fis = ded_tot
where anno = 2005
and ded_tot < 0
and ded_fis = 0
and ipn_ord > 0
;
start crp_peccmore11.sql