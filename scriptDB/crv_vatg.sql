CREATE OR REPLACE VIEW VISTA_ATTRIBUTI_GIURIDICI ( ATGI_ID, COAT_ID,
CI, NOMINATIVO, RILEVANZA, DAL_PEGI,AL_PEGI,DAL_COAT,AL_COAT, 
CATEGORIA, DES_CAAT, ATTRIBUTO, DES_COAT, 
SEDE_DEL, ANNO_DEL, NUMERO_DEL, PROVVEDIMENTO, 
NOTE_ATT, NOTE_COD,VARIABILE, DES_VAAT, VALORE, 
VARIABILI ) AS select
       atgi.atgi_id
      ,atgi.coat_id
      ,pegi.ci
      ,gp4_rain.get_nominativo(pegi.ci)           nominativo
      ,pegi.rilevanza
	  ,pegi.dal                                   dal_pegi
      ,pegi.al                                    al_pegi
	  ,coat.dal                                   dal_coat
      ,coat.al                                    al_coat
	  ,coat.categoria
      ,caat.descrizione                           des_caat
	  ,coat.attributo
	  ,coat.descrizione                           des_coat
	  ,atgi.sede_del
	  ,atgi.anno_del
	  ,atgi.numero_del
	  ,rpad(atgi.sede_del,4,' ')||'-'||
	   rpad(atgi.numero_del,4,' ')||'/'||
	   rpad(atgi.anno_del,4,' ')                  provvedimento
	  ,atgi.note                                  note_att
      ,coat.note                                  note_cod
	  ,vaat.variabile
	  ,vaat.descrizione                           des_vaat
	  ,vaag.valore
	  ,'SI'
  from periodi_giuridici              pegi
      ,codici_attributo               coat
	  ,attributi_giuridici            atgi
	  ,variabili_attributo            vaat
	  ,categorie_attributi            caat
	  ,valori_attributi_giuridici     vaag
 where pegi.ci                             = atgi.ci
   and pegi.rilevanza                      = atgi.rilevanza
   and pegi.dal                            = atgi.dal
   and atgi.coat_id                        = coat.coat_id
   and coat.categoria                      = caat.categoria
   and vaat.coat_id                        = coat.coat_id
   and vaag.vaat_id                        = vaat.vaat_id
   and vaag.atgi_id                        = atgi.atgi_id
 union
select
       atgi.atgi_id
      ,atgi.coat_id
      ,pegi.ci
      ,gp4_rain.get_nominativo(pegi.ci)           nominativo
      ,pegi.rilevanza
	  ,pegi.dal                                   dal_pegi
	  ,pegi.al                                    al_pegi
	  ,coat.dal                                   dal_coat
      ,coat.al                                    al_coat
	  ,coat.categoria
      ,caat.descrizione                           des_caat
	  ,coat.attributo
	  ,coat.descrizione                           des_coat
	  ,atgi.sede_del
	  ,atgi.anno_del
	  ,atgi.numero_del
	  ,rpad(atgi.sede_del,4,' ')||'-'||
	   rpad(atgi.numero_del,4,' ')||'/'||
	   rpad(atgi.anno_del,4,' ')                  provvedimento
	  ,atgi.note                                  note_att
      ,coat.note                                  note_cod
	  ,''                                         variabile
	  ,''                                         des_vaat
	  ,''                                         valore
	  ,'SI'
  from periodi_giuridici              pegi
      ,codici_attributo               coat
	  ,attributi_giuridici            atgi
	  ,categorie_attributi            caat
 where pegi.ci                           = atgi.ci
   and pegi.rilevanza                    = atgi.rilevanza
   and pegi.dal                          = atgi.dal
   and atgi.coat_id                      = coat.coat_id
   and coat.categoria                    = caat.categoria
   and not exists
      ( select 'x'
	      from valori_attributi_giuridici     vaag
		 where atgi_id                   = atgi.atgi_id
	  )
 union
select
       atgi.atgi_id
      ,atgi.coat_id
      ,pegi.ci
      ,gp4_rain.get_nominativo(pegi.ci)           nominativo
      ,pegi.rilevanza
	  ,pegi.dal                                   dal_pegi
	  ,pegi.al                                    al_pegi
	  ,coat.dal                                   dal_coat
      ,coat.al                                    al_coat
	  ,coat.categoria
      ,caat.descrizione                           des_caat
	  ,coat.attributo
	  ,coat.descrizione                           des_coat
	  ,atgi.sede_del
	  ,atgi.anno_del
	  ,atgi.numero_del
	  ,rpad(atgi.sede_del,4,' ')||'-'||
	   rpad(atgi.numero_del,4,' ')||'/'||
	   rpad(atgi.anno_del,4,' ')                  provvedimento
	  ,atgi.note                                  note_att
      ,coat.note                                  note_cod
	  ,''                                         variabile
	  ,''                                         des_vaat
	  ,''                                         valore
	  ,'NO'
  from periodi_giuridici              pegi
      ,codici_attributo               coat
	  ,attributi_giuridici            atgi
	  ,categorie_attributi            caat
 where pegi.ci                           = atgi.ci
   and pegi.rilevanza                    = atgi.rilevanza
   and pegi.dal                          = atgi.dal
   and atgi.coat_id                      = coat.coat_id
   and coat.categoria                    = caat.categoria
/




