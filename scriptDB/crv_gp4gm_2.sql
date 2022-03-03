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
/* View: INDIVIDUI_IN_SOSPESO                                   */
/*==============================================================*/
create or replace force view individui_in_sospeso as
select ci          ci
      ,rilevanza   rilevanza
      ,pegi.dal    dal
      ,pegi.al     al
      ,gp4_unor.get_codice_uo(stam.ni,'GP4',nvl(pegi.al,to_date(3333333,'j'))) settore
      ,figi.codice figura
  from periodi_giuridici      pegi
      ,settori_amministrativi stam
      ,figure_giuridiche      figi
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
   and nvl(pegi.al, to_date(3333333, 'j')) >=
       nvl(gp4_rest.get_dal_rest_modifica('GP4'), gp4_rest.get_data_rest_modifica('GP4'))
   and not exists
 (select 'x'
          from unita_organizzative unor
         where ni = (select ni from settori_amministrativi where numero = pegi.settore)
           and unor.ottica = 'GP4'
           and unor.revisione = gp4gm.get_revisione_m)
   and exists
 (select 'x'
          from unita_organizzative unor
         where ni = (select ni from settori_amministrativi where numero = pegi.settore)
           and unor.ottica = 'GP4'
           and unor.revisione = gp4gm.get_revisione_a)
   and stam.numero = pegi.settore
   and figi.numero = pegi.figura
   and nvl(pegi.al, to_date(3333333, 'j')) between figi.dal and
       nvl(figi.al, to_date(3333333, 'j'))
/

/*==============================================================*/
/* View: SETTORI_VIEW                                           */
/*==============================================================*/
CREATE OR REPLACE FORCE VIEW settori_view 
 ( codice 
 , descrizione 
 , descrizione_al1 
 , descrizione_al2 
 , numero 
 , sequenza 
 , suddivisione 
 , gestione 
 , settore_g 
 , settore_a 
 , settore_b 
 , settore_c 
 , assegnabile 
 , sede 
 , cod_reg 
 ) AS 
   SELECT gp4_unor.get_codice_uo (gp4_stam.get_ni_numero (stam.numero) ,'GP4' ,gp4_unor.get_dal (stam.ni) ) 
        , SUBSTR (gp4_unor.get_descrizione (stam.ni), 1, 30) 
        , SUBSTR (gp4_unor.get_descrizione_al1 (stam.ni), 1, 30) 
        , SUBSTR (gp4_unor.get_descrizione_al2 (stam.ni), 1, 30) 
        , stam.numero 
        , stam.sequenza 
        , DECODE (gp4_unor.get_livello (stam.ni, 'GP4', gp4_unor.get_dal (stam.ni) ) 
                 ,0, 0 
                 ,1, 1 
                 ,2, 2 
                 ,3, 3 
                 ,4, 4 
                 ,4 
                 ) 
        , stam.gestione 
        , DECODE (gp4_unor.get_livello (stam.ni, 'GP4', gp4_unor.get_dal (stam.ni) ) 
                 ,0, TO_NUMBER (NULL) 
                 ,gp4_stam.get_numero_gestione (stam.ni) 
                 ) settore_g 
        , DECODE (gp4_unor.get_livello (stam.ni, 'GP4', gp4_unor.get_dal (stam.ni) ) 
                  ,0, TO_NUMBER (NULL) 
                  ,1, TO_NUMBER (NULL) 
                  ,NVL (gp4_stam.get_numero (gp4_reuo.get_ni_padre (gp4_unor.get_revisione (stam.ni) 
                                                                   ,stam.ni 
                                                                   ,1 
                                                                   ) 
                                            ) 
                       ,gp4_stam.get_numero_gestione (stam.ni) 
                       ) 
                  ) settore_a 
        , DECODE (gp4_unor.get_livello (stam.ni, 'GP4', gp4_unor.get_dal (stam.ni) ) 
                 ,0, TO_NUMBER (NULL) 
                 ,1, TO_NUMBER (NULL) 
                 ,2, TO_NUMBER (NULL) 
                 ,NVL 
                     (gp4_stam.get_numero (gp4_reuo.get_ni_padre (gp4_unor.get_revisione (stam.ni) 
                                                                 ,stam.ni 
                                                                 ,2 
                                                                 ) 
                                          ) 
                     ,NVL 
                         (gp4_stam.get_numero (gp4_reuo.get_ni_padre (gp4_unor.get_revisione (stam.ni) 
                                                                     ,stam.ni 
                                                                     ,1 
                                                                     ) 
                                              ) 
                         ,gp4_stam.get_numero_gestione (stam.ni) 
                         ) 
                     ) 
                 ) settore_b 
        , DECODE (gp4_unor.get_livello (stam.ni, 'GP4', gp4_unor.get_dal (stam.ni) ) 
                 ,0, TO_NUMBER (NULL) 
                 ,1, TO_NUMBER (NULL) 
                 ,2, TO_NUMBER (NULL) 
                 ,3, TO_NUMBER (NULL) 
                 ,NVL 
                     (gp4_stam.get_numero (gp4_reuo.get_ni_padre (gp4_unor.get_revisione (stam.ni) 
                                                                 ,stam.ni 
                                                                 ,3 
                                                                 ) 
                                          ) 
                     ,NVL 
                         (gp4_stam.get_numero (gp4_reuo.get_ni_padre (gp4_unor.get_revisione (stam.ni) 
                                                                     ,stam.ni 
                                                                     ,2 
                                                                     ) 
                                              ) 
                         ,NVL 
                             (gp4_stam.get_numero 
                                               (gp4_reuo.get_ni_padre (gp4_unor.get_revisione (stam.ni) 
                                                                      ,stam.ni 
                                                                      ,1 
                                                                      ) 
                                               ) 
                             ,gp4_stam.get_numero_gestione (stam.ni) 
                             ) 
                         ) 
                     ) 
                 ) settore_c 
        , stam.assegnabile 
        , stam.sede 
        , TO_CHAR (NULL) 
     FROM settori_amministrativi stam 
    WHERE EXISTS (SELECT 'x'
                    FROM unita_organizzative 
                   WHERE tipo = 'P'
                     AND ottica = 'GP4'
                     AND ni = gp4_stam.get_ni_numero (stam.numero)
                 )
;                    

start crv_visu.sql
start crv_vsog.sql