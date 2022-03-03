-- Crea i diritti di creazione di snapshot all'utente oracle
-- commentare le drop che devono essere inserite eventualmente nel file di Upgrade
-- drop MATERIALIZED view log on retribuzioni_inail;

create MATERIALIZED view log on retribuzioni_inail with rowid
( ANNO, GESTIONE, RUOLO, POSIZIONE_INAIL, ESENZIONE
, CAPITOLO, ARTICOLO, CONTO, FUNZIONALE
, risorsa_intervento, impegno, anno_impegno, sub_impegno, anno_sub_impegno , codice_siope
, CDC, TIPO_IPN, IMPONIBILE, PREMIO
) 
including new values;

-- commentare le drop che devono essere inserite eventualmente nel file di Upgrade
-- drop materialized view TOTALI_RETRIBUZIONI_INAIL;

CREATE MATERIALIZED VIEW TOTALI_RETRIBUZIONI_INAIL
LOGGING
NOCACHE
NOPARALLEL
USING INDEX 
REFRESH FAST
ON COMMIT
WITH ROWID
USING DEFAULT LOCAL ROLLBACK SEGMENT
DISABLE QUERY REWRITE AS
select anno 
     , gestione 
     , ruolo 
     , posizione_inail
     , esenzione
     , capitolo 
     , articolo
     , conto
     , funzionale
     , risorsa_intervento
     , impegno
     , anno_impegno
     , sub_impegno
     , anno_sub_impegno
     , codice_siope
     , cdc
     , tipo_ipn
     , sum (imponibile)   imponibile 
     , sum(premio)        premio 
     , count(*)           num_record 
     , count(imponibile)  tot_imponibile 
     , count(premio)      tot_premio 
  from retribuzioni_inail 
 group by anno
        , gestione
        , ruolo
        , posizione_inail
        , esenzione
        , capitolo 
        , articolo
        , conto
        , funzionale
        , risorsa_intervento
        , impegno
        , anno_impegno
        , sub_impegno
        , anno_sub_impegno
        , codice_siope
        , cdc
        , tipo_ipn
;