start crv_ast2.sql
start crp_peccpere2.sql
start crp_peccpere3.sql

update periodi_retributivi pere
   set pere.cod_astensione =
       (select pere2.cod_astensione
	      from periodi_retributivi pere2
		 where pere2.periodo = pere.periodo
		   and pere2.ci = pere.ci
		   and pere2.competenza = lower(pere.competenza)
		   and pere2.servizio = pere.servizio
		   and pere2.dal = pere.dal
		   and pere2.al = pere.al
		   and pere2.cod_astensione in
		       (select codice
			      from astensioni
				 where servizio_inpdap = 'S')
	   )
 where pere.periodo >= to_date('31012005','ddmmyyyy')
   and pere.competenza = upper(pere.competenza)
   and pere.cod_astensione is null
   and exists
       (select 'x'
	      from periodi_retributivi pere3
		 where pere3.periodo = pere.periodo
		   and pere3.ci = pere.ci
		   and pere3.competenza = lower(pere.competenza)
		   and pere3.servizio = pere.servizio
		   and pere3.dal = pere.dal
		   and pere3.al = pere.al
		   and pere3.cod_astensione in
		       (select codice
			      from astensioni
				 where servizio_inpdap = 'S'));