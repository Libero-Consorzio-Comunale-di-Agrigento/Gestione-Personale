REM
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      ARCHIVIO_ASSISTENZA_FISCALE
REM INDEX
REM      ASFI_PK
REM

PROMPT 
PROMPT Creating Table ARCHIVIO_ASSISTENZA_FISCALE

CREATE TABLE archivio_assistenza_fiscale
(  ANNO            NUMBER(4)     NOT NULL,
   CI              NUMBER(8)     NOT NULL,
   MOCO_MESE1      NUMBER(2)         NULL,
   MOCO_MESE2      NUMBER(2)         NULL,
   MOCO_MESE3      NUMBER(2)         NULL,
   MOCO_MESE4      NUMBER(2)         NULL,
   MOCO_N1         NUMBER(12,2)      NULL,
   MOCO_N2         NUMBER(12,2)      NULL,
   MOCO_N3         NUMBER(12,2)      NULL,
   MOCO_N4         NUMBER(12,2)      NULL,
   MOCO_N5         NUMBER(12,2)      NULL,
   MOCO_N6         NUMBER(12,2)      NULL,
   MOCO_N7         NUMBER(12,2)      NULL,
   MOCO_N8         NUMBER(12,2)      NULL,
   MOCO_N9         NUMBER(12,2)      NULL,
   MOCO_N10        NUMBER(12,2)      NULL,
   MOCO_N11        NUMBER(12,2)      NULL,
   MOCO_N12        NUMBER(12,2)      NULL,
   MOCO_N13        NUMBER(12,2)      NULL,
   MOCO_N14        NUMBER(12,2)      NULL,
   MOCO_N15        NUMBER(12,2)      NULL,
   MOCO_N16        NUMBER(12,2)      NULL,
   MOCO_N17        NUMBER(12,2)      NULL,
   MOCO_N18        NUMBER(12,2)      NULL,
   MOCO_N19        NUMBER(12,2)      NULL,
   MOCO_N20        NUMBER(12,2)      NULL,
   MOCO_N21        NUMBER(12,2)      NULL,
   MOCO_N22        NUMBER(12,2)      NULL,
   MOCO_N23        NUMBER(12,2)      NULL,
   MOCO_N24        NUMBER(12,2)      NULL,
   DECA_N1         NUMBER(12,2)      NULL,
   DECA_N2         NUMBER(12,2)      NULL,
   DECA_N3         NUMBER(12,2)      NULL,
   DECA_N4         NUMBER(12,2)      NULL,
   DECA_N5         NUMBER(12,2)      NULL,
   DECA_N6         NUMBER(12,2)      NULL,
   DECA_N7         NUMBER(12,2)      NULL,
   DECA_N8         NUMBER(12,2)      NULL,
   DECA_C1         VARCHAR2(4)       NULL,
   DECA_C2         VARCHAR2(4)       NULL,
   DECA_C3         VARCHAR2(4)       NULL,
   DECA_C4         VARCHAR2(4)       NULL,
   DECA_C5         VARCHAR2(1)       NULL,
   DECA_C6         VARCHAR2(1)       NULL,
   DECA_C7         VARCHAR2(1)       NULL,
   DECA_C8         VARCHAR2(1)       NULL,
   DECA_C9         VARCHAR2(1)       NULL,
   DIFF_N1         NUMBER(12,2)      NULL,
   DIFF_N2         NUMBER(12,2)      NULL,
   DIFF_N3         NUMBER(12,2)      NULL,
   DIFF_N4         NUMBER(12,2)      NULL,
   DIFF_N5         NUMBER(12,2)      NULL,
   DIFF_N6         NUMBER(12,2)      NULL,
   DIFF_N7         NUMBER(12,2)      NULL,
   DIFF_N8         NUMBER(12,2)      NULL,
   DIFF_N9         NUMBER(12,2)      NULL,
   DIFF_N10        NUMBER(12,2)      NULL,
   DIFF_N11        NUMBER(12,2)      NULL,
   DIFF_N12        NUMBER(12,2)      NULL,
   DIFF_N13        NUMBER(12,2)      NULL,
   DIFF_N14        NUMBER(12,2)      NULL,
   DIFF_N15        NUMBER(12,2)      NULL,
   DIFF_N16        NUMBER(12,2)      NULL,
   UTENTE          VARCHAR2(8)       NULL,
   TIPO_AGG        VARCHAR2(1)       NULL,
   DATA_AGG        DATE              NULL
);


COMMENT ON TABLE archivio_assistenza_fiscale
    IS 'ASFI - Archivio Assistenza Fiscale';

REM
REM 
REM
PROMPT
PROMPT Creating Unique Index ASFI_PK on Table ARCHIVIO_ASSISTENZA_FISCALE
CREATE UNIQUE INDEX ASFI_PK ON ARCHIVIO_ASSISTENZA_FISCALE
( anno , ci)
PCTFREE  10
;

REM
REM  End of command file
REM

