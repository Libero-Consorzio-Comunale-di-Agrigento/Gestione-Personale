CREATE OR REPLACE FORCE VIEW VISTA_SUBENTRI
(TITOLARE, NOMINATIVO_TITOLARE, DATA_TERMINE, SOSTITUTO, NOMINATIVO_SOSTITUTO, 
 DATA_INIZIO, FIGURA, SETTORE, SOGI_ID)
AS 
select titolare                                          titolare
      ,gp4_rain.get_nominativo(titolare)                 nominativo_titolare
	  ,dal_astensione                                    data_termine
	  ,decode(sostituto,0,to_number(null),sostituto)     sostituto
	  ,gp4_rain.get_nominativo(sostituto)                nominativo_sostituto
	  ,dal                                               data_inizio
      ,gp4_figi.get_codice(gp4_pegi.get_figura(titolare,'S',dal_astensione),dal_astensione)  figura
      ,gp4_unor.get_codice_uo(gp4_stam.get_ni_numero(gp4_pegi.get_settore(titolare,'S',dal_astensione)),'GP4',dal_astensione) settore
      ,sogi_id
from sostituzioni_giuridiche
where rilevanza_astensione = 'S'; 