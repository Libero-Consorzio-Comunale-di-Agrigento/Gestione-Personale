--  Assegnare le grant dallo user del controllo di gestione ( solitamente CG4 ) allo user delle paghe ( solitamente P00 )
conn cg4/cg4@si4
grant select on centri to p00 with grant option;

-- Creazione tabella di appoggio della centri_costo sullo user delle paghe
-- cancellazione della tabella centri_costo dallo user delle paghe
conn p00/p00@si4
create table ceco_ante_cg4
as select * from centri_costo
/
drop table centri_costo
/
-- creazione della vista sullo user delle paghe
CREATE OR REPLACE VIEW CENTRI_COSTO
 (  CODICE
  , DESCRIZIONE
  , DESCRIZIONE_AL1        
  , DESCRIZIONE_AL2 ) 
AS select 
   CENTRO
 , substr(DESCRIZIONE,1,30)  
 , null
 , null
 from CG4.centri
where se_personale='S'
/
--  Assegnare le grant dallo user delle paghe ( solitamente P00 ) all user del controllo di gestione ( solitamente CG4 )
grant select on imputazioni_centro_costo to cg4;
conn cg4/cg4@si4
-- Creazione del sinonimo sullo user del controllo di gestione
create synonym imputazioni_centro_costo for p00.imputazioni_centro_costo;
conn p00/p00@si4
