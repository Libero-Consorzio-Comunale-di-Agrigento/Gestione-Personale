alter table  classi_rapporto add vortale VARCHAR(2) default 'SI' NOT NULL
;
update classi_rapporto set vortale = 'NO'
where presenza = 'NO' and retributivo = 'NO' and giuridico = 'NO'
;
