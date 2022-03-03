REM  Objects being generated in this file are:-
REM TABLE
REM      PERIODI_GIURIDICI
REM INDEX
REM      PEGI_ASTE_FK
REM      PEGI_ATTI_FK
REM      PEGI_DELI_FK
REM      PEGI_EVGI_FK
REM      PEGI_FIGU_FK
REM      PEGI_PK
REM      PEGI_POOR_FK
REM      PEGI_POSI_FK
REM      PEGI_QUAL_FK
REM      PEGI_SEDE_FK
REM      PEGI_SETT_FK

REM
REM     PEGI - Periodi giuridici di rapporto di lavoro, di servizio e di assenz
REM - a
REM
PROMPT 
PROMPT Creating Table PERIODI_GIURIDICI
CREATE TABLE periodi_giuridici(
 ci                              NUMBER(8,0)      NOT NULL,
 rilevanza                       VARCHAR(1)       NOT NULL,
 dal                             DATE             NOT NULL,
 al                              DATE             NULL,
 evento                          VARCHAR(6)       NOT NULL,
 posizione                       VARCHAR(4)       NULL,
 tipo_rapporto                   VARCHAR(4)       NULL,
 sede_posto                      VARCHAR(4)       NULL,
 anno_posto                      NUMBER(4,0)      NULL,
 numero_posto                    NUMBER(7,0)      NULL,
 posto                           NUMBER(4,0)      NULL,
 sostituto                       NUMBER(8,0)      NULL,
 qualifica                       NUMBER(6,0)      NULL,
 ore                             NUMBER(5,2)      NULL,
 figura                          NUMBER(6,0)      NULL,
 attivita                        VARCHAR(4)       NULL,
 gestione                        VARCHAR(8)       NULL,
 settore                         NUMBER(6,0)      NULL,
 sede                            NUMBER(6,0)      NULL,
 gruppo                          VARCHAR(2)       NULL,
 assenza                         VARCHAR(4)       NULL,
 confermato                      NUMBER(1,0)      NULL,
 note                            VARCHAR(4000)    NULL,
 note_al1                        VARCHAR(4000)    NULL,
 note_al2                        VARCHAR(4000)    NULL,
 sede_del                        VARCHAR(4)       NULL,
 anno_del                        NUMBER(4,0)      NULL,
 numero_del                      NUMBER(7,0)      NULL,
 utente                          VARCHAR(8)       NULL,
 data_agg                        DATE             NULL,
 delibera                        VARCHAR(4)       NULL
)
STORAGE  (
  INITIAL   &1DIMx3000
  NEXT   &1DIMx1500
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

COMMENT ON TABLE periodi_giuridici
    IS 'PEGI - Periodi giuridici di rapporto di lavoro, di servizio e di assenza';


REM
REM 
REM
PROMPT
PROMPT Creating Index PEGI_ASTE_FK on Table PERIODI_GIURIDICI
CREATE INDEX PEGI_ASTE_FK ON PERIODI_GIURIDICI
(
      assenza )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx250      
  NEXT   &1DIMx125    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index PEGI_ATTI_FK on Table PERIODI_GIURIDICI
CREATE INDEX PEGI_ATTI_FK ON PERIODI_GIURIDICI
(
      attivita )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx250       
  NEXT   &1DIMx125    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index PEGI_DELI_FK on Table PERIODI_GIURIDICI
CREATE INDEX PEGI_DELI_FK ON PERIODI_GIURIDICI
(
      sede_del ,
      anno_del ,
      numero_del )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx400      
  NEXT   &1DIMx200    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index PEGI_EVGI_FK on Table PERIODI_GIURIDICI
CREATE INDEX PEGI_EVGI_FK ON PERIODI_GIURIDICI
(
      evento )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx250      
  NEXT   &1DIMx125    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index PEGI_FIGU_FK on Table PERIODI_GIURIDICI
CREATE INDEX PEGI_FIGU_FK ON PERIODI_GIURIDICI
(
      figura )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx250        
  NEXT   &1DIMx125    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index PEGI_PK on Table PERIODI_GIURIDICI
CREATE UNIQUE INDEX PEGI_PK ON PERIODI_GIURIDICI
(
      ci ,
      rilevanza ,
      dal )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx400      
  NEXT   &1DIMx200    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index PEGI_POOR_FK on Table PERIODI_GIURIDICI
CREATE INDEX PEGI_POOR_FK ON PERIODI_GIURIDICI
(
      sede_posto ,
      anno_posto ,
      numero_posto ,
      posto )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx400       
  NEXT   &1DIMx200    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index PEGI_POSI_FK on Table PERIODI_GIURIDICI
CREATE INDEX PEGI_POSI_FK ON PERIODI_GIURIDICI
(
      posizione )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx250      
  NEXT   &1DIMx125    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index PEGI_QUAL_FK on Table PERIODI_GIURIDICI
CREATE INDEX PEGI_QUAL_FK ON PERIODI_GIURIDICI
(
      qualifica )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx250      
  NEXT   &1DIMx125    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index PEGI_SEDE_FK on Table PERIODI_GIURIDICI
CREATE INDEX PEGI_SEDE_FK ON PERIODI_GIURIDICI
(
      sede )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx250      
  NEXT   &1DIMx125    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index PEGI_SETT_FK on Table PERIODI_GIURIDICI
CREATE INDEX PEGI_SETT_FK ON PERIODI_GIURIDICI
(
      settore )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx250      
  NEXT   &1DIMx125    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index PEGI_IK ON PERIODI_GIURIDICI
CREATE INDEX PEGI_IK ON PERIODI_GIURIDICI
(
      sostituto )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx200      
  NEXT   &1DIMx200    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM  End of command file
REM
