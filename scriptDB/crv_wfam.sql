CREATE OR REPLACE VIEW WORD_FAMILIARI ( NI, CI, 
PARENTELA, DES_PARENTELA, COGNOME, NOME, 
DATA_NAS, CODICE_FISCALE, DAL, AL, 
CONDIZIONE_PRO, DES_CONDIZIONE_PRO ) AS select fami.ni
        , rain.ci  
        , fami.relazione  
        , pare.descrizione  
        , fami.cognome  
        , fami.nome  
        , to_char(fami.data_nas,'dd/mm/yyyy') 
        , fami.codice_fiscale  
        , fami.dal  
        , fami.al  
        , fami.condizione_pro  
        , cnpr.descrizione  
     from condizioni_non_professionali cnpr  
	    , parentele pare  
		, familiari fami  
		, rapporti_individuali rain
    where nvl(fami.relazione,0)        = pare.sequenza (+)  
	  and nvl(fami.condizione_pro,' ') = cnpr.codice (+)
	  and rain.ni = fami.ni
/
