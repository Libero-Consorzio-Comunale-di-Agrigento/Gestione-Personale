/*==============================================================*/
/* Database name:  UNITA_ORGANIZZATIVE_FASE_2                   */
/* DBMS name:      ORACLE V7 Version for SI4                    */
/* Created on:     18/12/2002 15.38.16                          */
/*==============================================================*/



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
/* View: INDIVIDUI_RIASSEGNABILI                                */
/*==============================================================*/
create or replace force view individui_riassegnabili as
select pegi.ci ci
      ,rain.cognome || ' ' || rain.nome nominativo
      ,rilevanza rilevanza
      ,pegi.dal dal
      ,pegi.al al
      ,nvl(gp4_unor.get_codice_uo(stam.ni, 'GP4', pegi.al)
          ,gp4_unor.get_codice_uo(stam.ni, 'GP4', gp4_unor.get_dal(stam.ni))) ||
       decode(gp4_sdam.get_codice_numero(pegi.sede)
             ,to_char(null)
             ,to_char(null)
             ,'/' || gp4_sdam.get_codice_numero(pegi.sede)) settore
      ,figi.codice figura
  from periodi_giuridici      pegi
      ,settori_amministrativi stam
      ,revisioni_struttura    rest
      ,figure_giuridiche      figi
      ,rapporti_individuali   rain
 where rilevanza in (select 'Q'
                       from dual
                     union
                     select 'S'
                       from dual
                     union
                     select 'I'
                       from dual
                     union
                     select 'E' from dual)
   and nvl(pegi.al, to_date(3333333, 'j')) >= nvl(rest.dal,rest.data)
   and rest.stato = 'A'
   and rain.ci = pegi.ci
   and not exists
 (select 'x'
          from unita_organizzative unor
         where ni = (select ni from settori_amministrativi where numero = pegi.settore)
           and unor.ottica = 'GP4'
           and unor.revisione = rest.revisione)
   and exists
 (select 'x'
          from unita_organizzative unor
         where ni = (select ni from settori_amministrativi where numero = pegi.settore)
           and unor.ottica = 'GP4'
           and unor.revisione = gp4gm.get_revisione_o)
   and stam.numero = pegi.settore
   and figi.numero = pegi.figura
   and nvl(pegi.al, to_date(3333333, 'j')) between figi.dal and
       nvl(figi.al, to_date(3333333, 'j'))
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


/*===================================================================*/
/* View: SETTORI_VIEW  prima creazione, funzionale al package gp4gm  */
/*===================================================================*/
-- CREATE OR REPLACE FORCE VIEW SETTORI_VIEW  AS 
-- tolta la replace force perchè se esiste già la vista è qualla corretta e non 
-- occorre ricrarla fittizia - Annalena
CREATE VIEW SETTORI_VIEW  AS 
select  * 
  from    settori
/


