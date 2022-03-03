DECLARE
  d_revisione number;
  integrity_error  exception;
  errno            integer;
  errmsg           char(200);
  dummy            integer;
  d_dummy	   integer;
  found            boolean;
BEGIN 
  d_revisione := 0;
  select count(*) into d_dummy from posti_pianta;
  FOR CUR_POPI IN
     ( select  distinct dal from posti_pianta
     ) LOOP
  if d_dummy > 0 then
INSERT INTO REVISIONI_DOTAZIONE
(
 	   REVISIONE
	  ,DESCRIZIONE
	  ,DESCRIZIONE_AL1
	  ,DESCRIZIONE_AL2
	  ,NOTE
	  ,DAL
	  ,DATA
	  ,SEDE_DEL
	  ,NUMERO_DEL
	  ,ANNO_DEL
	  ,STATO
	  ,UTENTE
	  ,DATA_AGG
)
VALUES
(
 	   d_revisione 
	  ,'Revisione Predefinita '||d_revisione
	  ,''
	  ,''
	  ,''
	  ,cur_popi.dal
	  ,cur_popi.dal
	  ,null
	  ,TO_NUMBER(NULL) 
          ,null
	  ,'O'
	  ,'Aut.POPI'
	  ,SYSDATE 
)
      ;
else
INSERT INTO REVISIONI_DOTAZIONE
(
 	   REVISIONE
	  ,DESCRIZIONE
	  ,DESCRIZIONE_AL1
	  ,DESCRIZIONE_AL2
	  ,NOTE
	  ,DAL
	  ,DATA
	  ,SEDE_DEL
	  ,NUMERO_DEL
	  ,ANNO_DEL
	  ,STATO
	  ,UTENTE
	  ,DATA_AGG
)
VALUES
(
 	   d_revisione 
	  ,'Revisione Predefinita '||d_revisione
	  ,''
	  ,''
	  ,''
	  ,SYSDATE
	  ,SYSDATE
	  ,null
	  ,TO_NUMBER(NULL) 
          ,null
	  ,'A'
	  ,'Aut.POPI'
	  ,SYSDATE 
)
      ;
end if;
INSERT INTO DOTAZIONE_ORGANICA
(  REVISIONE      
 , GESTIONE       
 , AREA           
 , SETTORE        
 , RUOLO          
 , PROFILO        
 , POSIZIONE      
 , ATTIVITA       
 , FIGURA         
 , QUALIFICA      
 , LIVELLO        
 , TIPO_RAPPORTO  
 , ORE            
 , NUMERO         
 , NUMERO_ORE     
 , UTENTE         
 , DATA_AGG       
 , TIPO           
)
(SELECT  d_revisione
		,NVL(SETT.GESTIONE,'%')         
		,'%'
		,NVL(sett.codice,'%') 
		,'%'
		,'%'
		,'%'
		,NVL(POPI.ATTIVITA,'%')       
		,NVL(FIGI.codice,'%')
		,'%'
		,'%'
		,'%'
		,POPI.ORE              
		,count(*)
		,TO_NUMBER(NULL)
		,'Aut.POPI'
		,SYSDATE
		,null
   FROM  SETTORI   	     	 SETT	 
        ,FIGURE_GIURIDICHE	 FIGI
        ,POSTI_PIANTA 		 POPI
  WHERE POPI.SETTORE               = SETT.NUMERO
	AND POPI.FIGURA  	   = FIGI.NUMERO 
	and cur_popi.dal      between figi.dal 
                                  and nvl(figi.al,to_date(3333333,'j'))
	and cur_popi.dal      between popi.dal
                                  and nvl(popi.al,to_date(3333333,'j'))
  group by NVL(SETT.GESTIONE,'%'),NVL(sett.codice,'%'),NVL(POPI.ATTIVITA,'%'),NVL(FIGI.codice,'%'),POPI.ORE 
)
;
           d_revisione := d_revisione + 1;
	   END LOOP;
update revisioni_dotazione
set stato='A'
where revisione = (select max(revisione) from revisioni_dotazione)
;
COMMIT;
END;
/