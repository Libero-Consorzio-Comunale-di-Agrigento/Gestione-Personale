/****************************************
*Alter table ANAGRAFICI
*
*****************************************/

ALTER TABLE ANAGRAFICI ADD ( 
   DENOMINAZIONE 	   	   VARCHAR2(120)
  ,DENOMINAZIONE_AL1 	   VARCHAR2(120)
  ,DENOMINAZIONE_AL2 	   VARCHAR2(120)
  ,COMPETENZA_ESCLUSIVA    VARCHAR2(1)
  ,FLAG_TRG 			   VARCHAR2(1)
  ,STATO_CEE 			   VARCHAR2(2)
  ,TIPO_SOGGETTO 		   VARCHAR2(4)
  ,FINE_VALIDITA 		   DATE
   )
/
/****************************************
*Aggiornamento dei camp tipo_soggetto e denominazione su ANAGRAFICI
* Cognome nullo = ente (es.CAAF)
* Cognome non nullo = individuo (persona fisica)
*
*****************************************/
update anagrafici
   set tipo_soggetto = 'I'
 where nome is not null
/
update anagrafici
   set denominazione = cognome
      ,tipo_soggetto = 'E'
 where nome is null
/  
