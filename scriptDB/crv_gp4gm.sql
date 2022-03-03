/*==============================================================*/
/* Database name:  UNITA_ORGANIZZATIVE_FASE_2                   */
/* DBMS name:      ORACLE V7 Version for SI4                    */
/* Created on:     18/12/2002 15.38.16                          */
/*==============================================================*/


/*==============================================================*/
/* View: COMPONENTI_UO                                          */
/*==============================================================*/
CREATE OR REPLACE FORCE VIEW COMPONENTI_UO ( REVISIONE, 
UNITA, DAL_UNITA, UNITA_PADRE, UNITA_PADRE_DAL, 
SUDDIVISIONE, LIVELLO, GESTIONE, NUMERO_SETTORE, 
CODICE_SETTORE, COMPONENTE, COGNOME, NOME, 
DENOMINAZIONE, NI_COMPONENTE, DAL_COMPONENTE, AL_COMPONENTE, 
RESPONSABILE ) AS select  unor.revisione  
       ,unor.ni  
	   ,unor.dal  
	   ,unor.unita_padre  
	   ,unor.unita_padre_dal  
	   ,unor.suddivisione  
	   ,gp4_unor.get_livello(unor.ni,'GP4',gp4_unor.get_dal(unor.ni))  
	   ,stam.gestione  
	   ,stam.numero  
	   ,stam.codice  
	   ,comp.componente  
	   ,anag.cognome  
	   ,anag.nome  
	   ,anag.denominazione  
	   ,comp.ni  
	   ,comp.dal  
	   ,comp.al  
	   ,tiin.responsabile  
  from  unita_organizzative    unor  
       ,settori_amministrativi stam  
	   ,tipi_incarico          tiin  
	   ,anagrafe               anag  
	   ,componenti             comp  
 where  unor.ottica            = 'GP4'  
   and  unor.tipo              = 'P'  
   and  stam.ni                = unor.ni  
   and  anag.ni                = comp.ni  
   and  comp.unita_ni          = unor.ni  
   and  comp.unita_dal         = unor.dal  
   and  comp.unita_ottica      = unor.ottica  
--   and  comp.dal               = gp4_comp.get_dal(comp.componente)  
   and  tiin.incarico          = comp.incarico
/


/*==============================================================*/
/* View: INCARICHI_SOSTITUIBILI                                 */
/*==============================================================*/
create or replace FORCE view INCARICHI_SOSTITUIBILI (ci_incaricato, nominativo_incaricato, evento, posizione, dal, al, ci_sostituto, nominativo_sostituto, dal_sostituto, al_sostituto) as
select  pegi.ci  
       ,gp4_rain.get_nominativo(pegi.ci)||'  ['||pegi.ci||']'  
	   ,pegi.evento  
	   ,pegi.posizione  
	   ,pegi.dal  
	   ,pegi.al  
	   ,gp4do.get_ultimo_sostituto(pegi.ci,pegi.dal,nvl(pegi.al,to_date(3333333,'j')))  
	   ,gp4_rain.get_nominativo(gp4do.get_ultimo_sostituto(pegi.ci,pegi.dal,nvl(pegi.al,to_date(3333333,'j'))))  
	   ,gp4do.get_dal_ultimo_sostituto(pegi.ci,pegi.dal,nvl(pegi.al,to_date(3333333,'j')))  
	   ,gp4do.get_al_ultimo_sostituto(pegi.ci,pegi.dal,nvl(pegi.al,to_date(3333333,'j')))  
  from  periodi_giuridici pegi  
 where  rilevanza            = 'I'  
   and  exists  
       (select 'x'  
	      from periodi_giuridici  pegi1  
	     where pegi1.dal                          <= nvl(pegi.al,to_date(3333333,'j'))  
		   and nvl(pegi1.al,to_date(3333333,'j')) >= pegi.dal  
		   and pegi1.rilevanza                     = 'Q'  
		   and pegi1.ci                            = pegi.ci  
		   and exists  
		      (select 'x'  
			     from posizioni  
				where codice     = pegi1.posizione  
				  and ruolo      = 'SI'  
			  )  
       )
/


/*==============================================================*/
/* View: INDIVIDUI_DA_RIASSEGNARE                               */
/*==============================================================*/
create or replace FORCE view INDIVIDUI_DA_RIASSEGNARE  as
select  ci                     ci  
       ,rilevanza              rilevanza  
	   ,pegi.dal               dal  
	   ,pegi.al                al  
	   ,stam.codice            settore  
	   ,figi.codice            figura  
  from  periodi_giuridici      pegi  
       ,settori_amministrativi stam  
	   ,figure_giuridiche      figi  
 where  rilevanza in  
                 ( select 'Q' from dual  
				    union  
				   select 'S' from dual  
				    union  
				   select 'I' from dual  
				    union  
				   select 'E' from dual  
                 )  
   and  nvl(pegi.al,to_date(3333333,'j')) >= gp4_rest.get_dal_rest_attiva('GP4')  
   and  not exists  
       (select 'x'  
	      from unita_organizzative unor  
		 where ni = (select ni  
		               from settori_amministrativi  
					  where numero = pegi.settore  
					)  
		   and unor.ottica                             = 'GP4'  
		   and unor.revisione                          = gp4do.get_revisione_a  
		)  
    and exists  
       (select 'x'  
	      from unita_organizzative unor  
		 where ni = (select ni  
		               from settori_amministrativi  
					  where numero = pegi.settore  
					)  
		   and unor.ottica                             = 'GP4'  
		   and unor.revisione                          = gp4do.get_revisione_o  
		)  
    and  stam.numero                                   = pegi.settore  
	and  figi.numero                                   = pegi.figura  
	and  nvl(pegi.al,to_date(3333333,'j'))       between figi.dal  
	                                                 and nvl(figi.al,to_date(3333333,'j'))
/


/*==============================================================*/
/* View: INDIVIDUI_IN_SOSPESO                                   */
/*==============================================================*/
create or replace FORCE view INDIVIDUI_IN_SOSPESO  as
select  ci                     ci  
       ,rilevanza              rilevanza  
	   ,pegi.dal               dal  
	   ,pegi.al                al  
	   ,stam.codice            settore  
	   ,figi.codice            figura  
  from  periodi_giuridici      pegi  
       ,settori_amministrativi stam  
	   ,figure_giuridiche      figi  
 where  rilevanza in  
                 ( select 'Q' from dual  
				    union  
				   select 'S' from dual  
				    union  
				   select 'I' from dual  
				    union  
				   select 'E' from dual  
                 )  
   and  nvl(pegi.al,to_date(3333333,'j')) >= nvl(gp4_rest.get_dal_rest_modifica('GP4'),gp4_rest.get_data_rest_modifica('GP4'))   
   and  not exists  
       (select 'x'  
	      from unita_organizzative unor  
		 where ni = (select ni  
		               from settori_amministrativi  
					  where numero = pegi.settore  
					)  
		   and unor.ottica                             = 'GP4'  
		   and unor.revisione                          = gp4gm.get_revisione_m  
		)  
    and exists  
       (select 'x'  
	      from unita_organizzative unor  
		 where ni = (select ni  
		               from settori_amministrativi  
					  where numero = pegi.settore  
					)  
		   and unor.ottica                             = 'GP4'  
		   and unor.revisione                          = gp4gm.get_revisione_a  
		)  
    and  stam.numero                                   = pegi.settore  
	and  figi.numero                                   = pegi.figura  
	and  nvl(pegi.al,to_date(3333333,'j'))       between figi.dal  
	                                                 and nvl(figi.al,to_date(3333333,'j'))
/


/*==============================================================*/
/* View: INDIVIDUI_RIASSEGNABILI                                */
/*==============================================================*/
CREATE OR REPLACE FORCE VIEW INDIVIDUI_RIASSEGNABILI
(CI, NOMINATIVO, RILEVANZA, DAL, AL, 
 SETTORE, FIGURA)
AS 
select  pegi.ci                     ci
       ,rain.cognome||' '||rain.nome nominativo
       ,rilevanza              rilevanza
	   ,pegi.dal               dal
	   ,pegi.al                al
	   ,  gp4_unor.get_codice_uo(stam.ni,'GP4',pegi.al)
	    ||decode( gp4_sdam.get_codice_numero(pegi.sede)
	             ,to_char(null),to_char(null)
			     ,'/'||gp4_sdam.get_codice_numero(pegi.sede)
	            )   settore
	   ,figi.codice            figura
  from  periodi_giuridici      pegi
       ,settori_amministrativi stam
	   ,revisioni_struttura    rest
	   ,figure_giuridiche      figi
       ,rapporti_individuali   rain
 where  rilevanza in
                 ( select 'Q' from dual
				    union
				   select 'S' from dual
				    union
				   select 'I' from dual
				    union
				   select 'E' from dual
                 )
   and  nvl(pegi.al,to_date(3333333,'j')) >= rest.dal
   and  rest.stato                         = 'A'
   and  rain.ci=pegi.ci
   and  not exists
       (select 'x'
	      from unita_organizzative unor
		 where ni = (select ni
		               from settori_amministrativi
					  where numero = pegi.settore
					)
		   and unor.ottica                             = 'GP4'
		   and unor.revisione                          = rest.revisione
		)
    and exists
       (select 'x'
	      from unita_organizzative unor
		 where ni = (select ni
		               from settori_amministrativi
					  where numero = pegi.settore
					)
		   and unor.ottica                             = 'GP4'
		   and unor.revisione                          = gp4gm.get_revisione_o
		)
    and  stam.numero                                   = pegi.settore
	and  figi.numero                                   = pegi.figura
    and  nvl(pegi.al,to_date(3333333,'j'))       between figi.dal
	                                                 and nvl(figi.al,to_date(3333333,'j'))
/


/*==============================================================*/
/* View: VISTA_SETTORI_AMMINISTRATIVI                           */
/*==============================================================*/
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

/*==============================================================*/
/* View: ANAGRAFE                                               */
/*==============================================================*/
CREATE OR REPLACE FORCE VIEW ANAGRAFE ( NI, 
COGNOME, NOME, SESSO, DATA_NAS, 
PROVINCIA_NAS, COMUNE_NAS, LUOGO_NAS, DAL, 
AL, CODICE_FISCALE, CITTADINANZA, INDIRIZZO_RES, 
INDIRIZZO_RES_AL1, INDIRIZZO_RES_AL2, PROVINCIA_RES, COMUNE_RES, 
CAP_RES, TEL_RES, PRESSO, INDIRIZZO_DOM, 
INDIRIZZO_DOM_AL1, INDIRIZZO_DOM_AL2, PROVINCIA_DOM, COMUNE_DOM, 
CAP_DOM, TEL_DOM, STATO_CIVILE, COGNOME_CONIUGE, 
TITOLO_STUDIO, TITOLO, CATEGORIA_PROTETTA, GRUPPO_LING, 
PARTITA_IVA, TESSERA_SAN, NUMERO_USL, PROVINCIA_USL, 
TIPO_DOC, NUMERO_DOC, PROVINCIA_DOC, COMUNE_DOC, 
NOTE, UTENTE, DATA_AGG, CODICE_FISCALE_ESTERO, 
FAX_RES, FAX_DOM, AMBIENTE_PROP, TELEFONO_UFFICIO, 
FAX_UFFICIO, E_MAIL, DENOMINAZIONE, DENOMINAZIONE_AL1, 
DENOMINAZIONE_AL2, COMPETENZA_ESCLUSIVA, FLAG_TRG, STATO_CEE, 
TIPO_SOGGETTO, FINE_VALIDITA ) AS select "NI","COGNOME","NOME","SESSO","DATA_NAS","PROVINCIA_NAS","COMUNE_NAS","LUOGO_NAS","DAL","AL","CODICE_FISCALE","CITTADINANZA","INDIRIZZO_RES","INDIRIZZO_RES_AL1","INDIRIZZO_RES_AL2","PROVINCIA_RES","COMUNE_RES","CAP_RES","TEL_RES","PRESSO","INDIRIZZO_DOM","INDIRIZZO_DOM_AL1","INDIRIZZO_DOM_AL2","PROVINCIA_DOM","COMUNE_DOM","CAP_DOM","TEL_DOM","STATO_CIVILE","COGNOME_CONIUGE","TITOLO_STUDIO","TITOLO","CATEGORIA_PROTETTA","GRUPPO_LING","PARTITA_IVA","TESSERA_SAN","NUMERO_USL","PROVINCIA_USL","TIPO_DOC","NUMERO_DOC","PROVINCIA_DOC","COMUNE_DOC","NOTE","UTENTE","DATA_AGG","CODICE_FISCALE_ESTERO","FAX_RES","FAX_DOM","AMBIENTE_PROP","TELEFONO_UFFICIO","FAX_UFFICIO","E_MAIL","DENOMINAZIONE","DENOMINAZIONE_AL1","DENOMINAZIONE_AL2","COMPETENZA_ESCLUSIVA","FLAG_TRG","STATO_CEE","TIPO_SOGGETTO","FINE_VALIDITA" from anagrafici where al is null
/


/*==============================================================*/
/* View: SETTORI_VIEW                                           */
/*==============================================================*/
CREATE OR REPLACE FORCE VIEW SETTORI_VIEW ( CODICE, 
DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NUMERO, 
SEQUENZA, SUDDIVISIONE, GESTIONE, SETTORE_G, 
SETTORE_A, SETTORE_B, SETTORE_C, ASSEGNABILE, 
SEDE, COD_REG ) AS select  stam.codice  
         ,substr(gp4_unor.get_descrizione(stam.ni),1,30)  
		 ,substr(gp4_unor.get_descrizione_al1(stam.ni),1,30)  
		 ,substr(gp4_unor.get_descrizione_al2(stam.ni),1,30)  
		 ,stam.numero  
		 ,stam.sequenza  
		 ,decode(gp4_unor.get_livello(stam.ni,'GP4',gp4_unor.get_dal(stam.ni)),0,0,1,1,2,2,3,3,4,4,4)  
		 ,stam.gestione  
		 ,decode( gp4_unor.get_livello(stam.ni,'GP4',gp4_unor.get_dal(stam.ni))  
		         ,0,to_number(null)  
				 ,gp4_stam.GET_NUMERO_GESTIONE(stam.ni)  
				)  
		 ,decode( gp4_unor.get_livello(stam.ni,'GP4',gp4_unor.get_dal(stam.ni))  
		         ,0,to_number(null)  
		         ,1,to_number(null)  
				   ,gp4_stam.get_settore_a(stam.ni)  
				)  
		 ,decode( gp4_unor.get_livello(stam.ni,'GP4',gp4_unor.get_dal(stam.ni))  
		         ,0,to_number(null)  
		         ,1,to_number(null)  
		         ,2,to_number(null)  
				 ,gp4_stam.get_settore_b(stam.ni)  
				)  
		 ,decode( gp4_unor.get_livello(stam.ni,'GP4',gp4_unor.get_dal(stam.ni))  
		         ,0,to_number(null)  
		         ,1,to_number(null)  
		         ,2,to_number(null)  
		         ,3,to_number(null)  
				   ,gp4_stam.get_settore_c(stam.ni)  
				)  
		 ,stam.assegnabile  
		 ,stam.sede  
		 ,to_char(null)  
  from    settori_amministrativi stam  
 where    exists  
        ( select 'x'  
		    from unita_organizzative  
		   where tipo   = 'P'  
		     and ottica = 'GP4'  
			 and ni     = gp4_stam.get_ni_numero(stam.numero)  
		)

/


