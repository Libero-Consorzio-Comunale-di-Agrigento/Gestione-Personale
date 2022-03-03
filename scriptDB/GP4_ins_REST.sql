insert into REVISIONI_STRUTTURA
(REVISIONE
, OTTICA
, SEDE_DEL
, ANNO_DEL
, NUMERO_DEL
, DESCRIZIONE
, DESCRIZIONE_AL1
, DESCRIZIONE_AL2
, DATA
, DAL
, NOTE
, STATO
, UTENTE
, DATA_AGG
)
values ( 0
		,'GP4'
		,to_char(null)
		,to_number(null)
		,to_number(null)
		,'Revisione 0'
		,to_char(null)
		,to_char(null)
		,to_date('01011900','ddmmyyyy')
		,to_date('01011900','ddmmyyyy')
		,to_char(null)
		,'A'
		,'Aut.REST'
		,sysdate
)
/
commit
/
