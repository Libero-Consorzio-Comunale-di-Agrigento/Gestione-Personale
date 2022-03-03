-- ricreazione vista_settori_amministrativi per congruenza con mod. a ESTAM 4.8.3
CREATE OR REPLACE VIEW VISTA_SETTORI_AMMINISTRATIVI ( GESTIONE, 
SUDDIVISIONE, CODICE, LIVELLO, DESCRIZIONE, 
REVISIONE, OTTICA, UNITA_PADRE, NI
 ) AS select  substr(gp4_stam.get_gestione(unor.ni) ,1,4)                                               gestione    
       ,substr(lpad(' ',(gp4_unor.get_livello(unor.ni,'GP4',unor.dal)-1) * 2,' ')||    
	    substr(gp4gm.get_des_abb_sust('GP4',suddivisione),1,8),1,30)                 suddivisione    
       ,substr(gp4_stam.get_codice(ni),1,15)                                         codice    
       ,gp4_unor.get_livello(unor.ni,'GP4',gp4_unor.get_dal(unor.ni))                livello    
       ,decode( gp4gm.get_revisione_gest(gp4_stam.get_gestione(unor.ni))    
	           ,gp4gm.get_revisione_a,unor.descrizione    
			                         ,'*** '||unor.descrizione    
			  )                                                                      descrizione    
	   ,revisione    
       ,ottica 
       ,unita_padre 
       ,ni 
  from  unita_organizzative unor    
 where ottica='GP4'
;