alter table movimenti_fiscali
add ( ded_con         number(12,2),
      ded_fig         number(12,2),
      ded_alt         number(12,2),
      ded_per_fam     number(5,2),
      ded_con_ac      number(12,2),
      ded_fig_ac      number(12,2),
      ded_alt_ac      number(12,2),
      ded_per_fam_ac  number(5,2))
;

alter table validita_fiscale
add ( val_conv_ded_fam   number(12,2))
;
start crp_Gp4_ente.sql

start crp_Gp4_defi.sql
start crp_Gp4_inex.sql
start crp_Gp4_rare.sql
start crp_Gp4_caco.sql

start crp_peccmore_autofam.sql
start crp_peccmore1.sql
start crp_peccmore3.sql
start crp_peccmore10.sql
start crp_peccmore11.sql
start crp_peccmore12.sql

-- Assestamento dizionari

update validita_fiscale set val_conv_ded_fam = 78000 where dal = to_date('01012005','ddmmyyyy')
;
delete from detrazioni_fiscali
where dal = to_date('01012005','ddmmyyyy')
and codice = '*' 
and tipo in ('SP','AD','AP','P1','P2','RP','UD')
;
-- ATTENZIONE: non sono gestiti correttamente i casi di assenza del coniuge
-- con 1 solo figlio minore (attribuisce 3200 + incremento di 3450-2900 anzichè 3450-3200)
insert into detrazioni_fiscali
(codice,dal,al,tipo,numero,scaglione
,importo)
select distinct defi.codice,vafi.dal,vafi.al,defi.tipo,defi.numero,1
,decode( defi.codice
        , 'AC',decode( defi.tipo
                     , 'CN', 0
                     , 'FG', 3200 + (2900 * (numero-1) )
                     , 'FD', 3200 + (2900 * (numero-1) )
                     , 'FM', (3450-2900) * numero
                     , 'MD', (3450-2900) * numero
                     , 'FH', 3700 * numero
                     , 'HD', 3700 * numero
                     , 'AL', 2900 * numero
                           , 0
                     )
        , 'CC',decode( defi.tipo
                     , 'CN', 3200
                     , 'FG', 2900 * numero
                     , 'FD', 2900 * numero
                     , 'FM', (3450-2900) * numero
                     , 'MD', (3450-2900) * numero
                     , 'FH', 3700 * numero
                     , 'HD', 3700 * numero
                     , 'AL', 2900 * numero
                           , 0
                     )
        , 'NC',decode( defi.tipo
                     , 'CN', 0
                     , 'FG', 1450 * numero
                     , 'FD', 2900 * numero
                     , 'FM', (1725-1450) * numero
                     , 'MD', (3450-2900) * numero
                     , 'FH', 1850 * numero
                     , 'HD', 3700 * numero
                     , 'AL', 1450 * numero
                           , 0
                     )
              , 0
        )
from detrazioni_fiscali defi
   , validita_fiscale vafi
where defi.al = vafi.dal-1
and vafi.dal = to_date('01012005','ddmmyyyy')
and defi.codice != '*'
;
update detrazioni_fiscali
set importo = 0
where dal = to_date('01012005','ddmmyyyy')
and codice != '*'
and numero > 10
;
-- sistema valori per figli con handicap (considerati come "di cui" rispetto al 
-- numero dei figli espresso nei campi FG
update detrazioni_fiscali defi
set importo = 
decode( defi.codice
        , 'NC',decode( defi.tipo
                     , 'FH', 400
                           , 800
                     )
              , 800
      ) * substr(lpad(numero,2,0),2,1)
where dal = to_date('01012005','ddmmyyyy')
and codice in ('AC','CC','NC')
and tipo in ('FH','HD')
and numero > 10
and importo = 0
;
update carichi_familiari
set SCAGLIONE_CONIUGE = decode(SCAGLIONE_CONIUGE,'','',1)
  , SCAGLIONE_FIGLI = decode(SCAGLIONE_FIGLI,'','',1)
where anno = 2005
and (SCAGLIONE_CONIUGE is not null or SCAGLIONE_FIGLI is not null)
;
commit;