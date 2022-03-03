CREATE TABLE INCENTIVI
(PROGETTO              VARCHAR2(8)   NOT NULL
,CI                      NUMBER(8)   NOT NULL
,DAL                       DATE      NOT NULL
,AL                        DATE          NULL
,NR_RATE                 NUMBER(3)       NULL
,TOT_DA_LIQ              NUMBER(16,2)  NOT NULL
,PERC_ACC                NUMBER(5,2)     NULL
,GG_RET                  NUMBER(4)       NULL
,GG_RET_MP               NUMBER(4)       NULL
,LIQ_MENS                NUMBER(16,2)      NULL
,TOT_LIQ                 NUMBER(16,2)      NULL
,TOT_SALDO               NUMBER(16,2)      NULL
,RISPARMIO               NUMBER(16,2)      NULL
,RIDISTRIBUZIONE         NUMBER(16,2)      NULL
,UTENTE                VARCHAR2(8)       NULL
,DATA_AGG                  DATE          NULL
)
/
CREATE UNIQUE INDEX INCE_PK ON INCENTIVI (PROGETTO,CI,DAL)
/
