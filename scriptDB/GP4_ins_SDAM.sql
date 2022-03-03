DECLARE
dep_ni 				NUMBER;
dep_dal_revisione   DATE;
BEGIN
dep_dal_revisione := gp4_rest.get_dal_rest_attiva('GP4');
FOR CUR IN (SELECT * FROM SEDI)
LOOP
	 INSERT INTO SEDI_AMMINISTRATIVE
	   (
	   	  NUMERO
		 ,NI
		 ,CODICE
		 ,DENOMINAZIONE
		 ,DENOMINAZIONE_AL1
		 ,DENOMINAZIONE_AL2
		 ,SEQUENZA
		 ,CALENDARIO
		 ,NOTE
		 ,UTENTE
		 ,DATA_AGG
 	   )
	   VALUES
	   (
	   	  CUR.NUMERO
		 ,null           --dep_ni
		 ,CUR.CODICE
		 ,CUR.DESCRIZIONE
		 ,CUR.DESCRIZIONE_AL1
		 ,CUR.DESCRIZIONE_AL2
		 ,CUR.SEQUENZA
		 ,CUR.CALENDARIO
		 ,''
		 ,'Aut.SDAM'
		 ,SYSDATE	 
	   );
 END LOOP;	
 COMMIT;
END;
/
