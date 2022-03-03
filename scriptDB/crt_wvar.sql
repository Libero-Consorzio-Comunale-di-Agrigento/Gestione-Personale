create table w_variazioni (
ID_VARIAZIONE                   NUMBER NOT NULL ,
PROGRESSIVO                     NUMBER NOT NULL ,
SEQUENZA                        NUMBER NOT NULL ,
OPERAZIONE                      VARCHAR2(1)  NOT NULL ,
TABELLA                         VARCHAR2(30) NOT NULL ,
COLONNA                         VARCHAR2(30) NOT NULL ,
TABELLA_DESTINAZIONE            VARCHAR2(30) ,
COLONNA_DESTINAZIONE            VARCHAR2(30) ,
TIPO_DATO                       VARCHAR2(200) NOT NULL ,
VALORE                          VARCHAR2(4000),
VALORE_PRECEDENTE               VARCHAR2(4000),
CAUSALE                         VARCHAR2(1) NOT NULL,
MODIFICATO                      NUMBER(1) NOT NULL,
USER_PROVENIENZA                VARCHAR2(30) NOT NULL,
USER_DESTINAZIONE               VARCHAR2(30),
DATA_AGG                        DATE NOT NULL
)
/