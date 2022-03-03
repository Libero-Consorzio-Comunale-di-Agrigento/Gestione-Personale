SET SCAN OFF
REM
REM TABLE
REM      IMPONIBILI_ASSENZA
REM INDEX
REM     IMAS_PK
REM
REM     IMAS - Archivio Voci Imponibili - Codici Astensione

PROMPT 
PROMPT Creating Table imponibili_assenza
CREATE TABLE imponibili_assenza
(  
 voce               VARCHAR2(10)   NOT NULL,
 dal                DATE               NULL,
 al                 DATE               NULL,
 assenza		  VARCHAR2(4)    NOT NULL
);

COMMENT ON TABLE IMPONIBILI_ASSENZA
    IS 'IMAS - Archivio Voci Imponibili - Codici Astensione';

PROMPT
PROMPT Creating Index IMAS_PK on Table IMPONIBILI_ASSENZA
CREATE UNIQUE INDEX IMAS_PK on IMPONIBILI_ASSENZA
(     voce
    , dal
    , assenza
)
PCTFREE  10
;

