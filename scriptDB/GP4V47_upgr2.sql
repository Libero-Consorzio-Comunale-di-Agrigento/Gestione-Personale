/*==============================================================*/
/* Table: GESTIONI                                              */
/*==============================================================*/


alter table GESTIONI add controlli_do VARCHAR2(1);
alter table GESTIONI add perc_ore_lavorate number(4,2);
alter table GESTIONI modify CODICE VARCHAR2(8);
alter table GESTIONI modify NOTE VARCHAR2(2000);
alter table GESTIONI modify NOTE_AL1 VARCHAR2(2000);
alter table GESTIONI modify NOTE_AL2 VARCHAR2(2000);
alter table GESTIONI modify INDIRIZZO_RES VARCHAR2(40);
alter table GESTIONI modify INDIRIZZO_RES_AL1 VARCHAR2(40);
alter table GESTIONI modify INDIRIZZO_RES_AL2 VARCHAR2(40);


/*==============================================================*/
/* Table: SETTORI                                               */
/*==============================================================*/

alter table SETTORI modify NUMERO number(8);
alter table SETTORI modify SETTORE_G number(8);
alter table SETTORI modify SETTORE_A number(8);
alter table SETTORI modify SETTORE_B number(8);
alter table SETTORI modify SETTORE_C number(8);
alter table SETTORI modify SEDE number(8);

/*==============================================================*/
/* Aggiornamento campi GESTIONE                                 */
/*==============================================================*/

alter table AUTOMATISMI_PRESENZA modify gestione varchar2(8);                                       
alter table CALCOLI_RETRIBUTIVI modify gestione varchar2(8);                                        
alter table DENUNCIA_CP modify gestione varchar2(8);                                                
alter table DENUNCIA_GLA modify gestione varchar2(8);                                               
alter table DENUNCIA_IMPORTI_GLA modify gestione varchar2(8);                                       
alter table DENUNCIA_INADEL modify gestione varchar2(8);                                            
alter table DENUNCIA_INAIL modify gestione varchar2(8);                                             
alter table DENUNCIA_INPDAP modify gestione varchar2(8);                                            
alter table DENUNCIA_O1_INPS modify gestione varchar2(8);                                           
alter table DENUNCIA_O3_INPS modify gestione varchar2(8);                                           
alter table DEPOSITO_PERIODI_PRESENZA modify gestione varchar2(8);                                  
alter table ESTRAZIONI_VOCE modify gestione varchar2(8);                                            
alter table MOVIMENTI_BILANCIO_PREVISIONE modify gestione varchar2(8);                              
alter table PERIODI_GIURIDICI modify gestione varchar2(8);                                          
alter table PERIODI_RETRIBUTIVI modify gestione varchar2(8);                                        
alter table PERIODI_RETRIBUTIVI_BP modify gestione varchar2(8);                                     
alter table QUALIFICHE_GESTIONI modify gestione varchar2(8);                                        
alter table RAPPORTI_GIURIDICI modify gestione varchar2(8);                                         
alter table RIPARTIZIONI_CONTABILI modify gestione varchar2(8);                                     
alter table SETTORI modify gestione varchar2(8);                                                    
alter table SMT_IMPORTI modify gestione varchar2(8);                                                
alter table SMT_INDIVIDUI modify gestione varchar2(8);                                              
alter table SMT_PERIODI modify gestione varchar2(8);                                                
alter table SOSPENSIONI_PROGRESSIONE modify gestione varchar2(8);                                   
alter table VALORI_BASE_VOCE modify gestione varchar2(8);                                           
alter table VALORI_BASE_VOCE_BP modify gestione varchar2(8);                                        
