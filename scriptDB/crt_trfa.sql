REM  Objects being generated in this file are:-
REM TABLE
REM      TAB_REPORT_FINE_ANNO
REM INDEX
REM      TRPFA_IK

REM
REM    TRPFA - Tabella report fine anno
REM
PROMPT 
PROMPT Creating Table TAB_REPORT_FINE_ANNO
CREATE TABLE tab_report_fine_anno
(
CI                                       NUMBER(8) NOT NULL,
ANNO                                     NUMBER(4) NOT NULL,
S1                                       VARCHAR2(15),
C1                                       VARCHAR2(15),
D1                                       VARCHAR2(60),
S2                                       VARCHAR2(15),
C2                                       VARCHAR2(15),
D2                                       VARCHAR2(60),
S3                                       VARCHAR2(15),
C3                                       VARCHAR2(15),
D3                                       VARCHAR2(60),
S4                                       VARCHAR2(15),
C4                                       VARCHAR2(15),
D4                                       VARCHAR2(60),
S5                                       VARCHAR2(100),
C5                                       VARCHAR2(100),
D5                                       VARCHAR2(100),
S6                                       VARCHAR2(100),
C6                                       VARCHAR2(100),
D6                                       VARCHAR2(100)
)
STORAGE  (
  INITIAL   &1DIMx800
  NEXT   &1DIMx400
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

COMMENT ON TABLE tab_report_fine_anno
    IS 'TRPFA - Tabella report fine anno';


REM
REM 
REM
REM GENERATED CANDIDATE INDEX
REM
PROMPT
PROMPT Creating Index TRPFA_IK on Table TAB_REPORT_FINE_ANNO
create index trpfa_ik on tab_report_fine_anno (ci)
;

REM
REM  End of command file
REM