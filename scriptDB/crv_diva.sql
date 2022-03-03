CREATE OR REPLACE FORCE VIEW DISPONIBILITA_VAR
(INPUT, VOCE, SUB, ANNO, MESE, 
 MENSILITA, DATA_INSERIMENTO, UTENTE_INSERIMENTO, QTA, IMP)
AS 
select deve.input 
      ,deve.voce 
      ,deve.sub 
      ,deve.anno 
      ,deve.mese 
      ,deve.mensilita 
      ,deve.data_inserimento 
      ,deve.utente_inserimento 
      ,sum(qta) qta 
      ,sum(imp) imp 
  from deposito_variabili_economiche deve 
 where mensilita_liquidazione is null 
 group by input 
         ,voce 
         ,sub 
         ,anno 
         ,mese 
         ,mensilita 
         ,data_inserimento 
         ,utente_inserimento
/