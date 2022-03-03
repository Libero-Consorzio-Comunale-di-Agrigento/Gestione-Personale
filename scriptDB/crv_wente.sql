create or replace view WORD_ENTE as
select ENTE_ID,NOME,INDIRIZZO_RES,INDIRIZZO_RES_AL1,INDIRIZZO_RES_AL2,NUMERO_CIVICO
     , comu.descrizione comune_res,comu.sigla_provincia provincia_res,ente.CAP
     , CODICE_FISCALE,PARTITA_IVA,TEL_RES,FAX_RES,E_MAIL,ragi.ci
  FROM comuni comu
     , rapporti_giuridici ragi
     , ente ente 
 where comu.cod_comune = comune_res
   and comu.cod_provincia = provincia_res
/