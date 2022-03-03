CREATE OR REPLACE FORCE VIEW VISTA_SETTORI_AMMINISTRATIVI
(GESTIONE, NUMERO, SUDDIVISIONE, CODICE, LIVELLO, 
 DESCRIZIONE, REVISIONE, OTTICA, DAL, UNITA_PADRE, 
 UNITA_PADRE_OTTICA, UNITA_PADRE_DAL, NI)
AS 
select substr(gp4_stam.get_gestione(unor.ni) ,1,4)                                gestione 
      ,gp4_stam.get_numero(ni)                                                    numero 
      ,substr(lpad(' ',(gp4_unor.get_livello(unor.ni,'GP4',unor.dal)-1) * 2,' ')|| 
	   substr(gp4gm.get_des_abb_sust('GP4',suddivisione),1,8),1,30)               suddivisione 
	  ,substr(codice_uo,1,15)                                                     codice 
	  ,suddivisione                                                               livello 
      ,descrizione 
	  ,revisione 
      ,ottica 
	  ,dal 
      ,unita_padre 
	  ,unita_padre_ottica 
	  ,unita_padre_dal 
      ,ni 
  from unita_organizzative unor 
 where unor.dal = (decode (gp4_rest.get_stato('GP4',revisione),'M',gp4_unor.GET_DAL_M(ni) 
                                                            ,'O',gp4_unor.GET_DAL_O(ni,REVISIONE) 
                                                                ,gp4_unor.GET_DAL(ni))) 
   and ottica||' '='GP4'||' '
/


