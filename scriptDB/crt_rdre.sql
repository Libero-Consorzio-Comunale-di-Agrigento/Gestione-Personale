CREATE TABLE RIGHE_DELIBERA_RETRIBUTIVA ( 
  SEDE                VARCHAR2 (4)  NOT NULL, 
  ANNO                NUMBER (4)    NOT NULL, 
  NUMERO              NUMBER (7)    NOT NULL, 
  BILANCIO            VARCHAR2 (2)  NOT NULL, 
  TIPO                VARCHAR2 (4)  NOT NULL,
  ANNO_COMPETENZA     NUMBER   (4)  NOT NULL, 
  RISORSA_INTERVENTO  VARCHAR2 (7), 
  CAPITOLO            VARCHAR2 (14), 
  ARTICOLO            VARCHAR2 (14), 
  CONTO               VARCHAR2 (2), 
  IMPEGNO             NUMBER (5), 
  ANNO_IMPEGNO        NUMBER (4), 
  SUB_IMPEGNO         NUMBER (5), 
  ANNO_SUB_IMPEGNO    NUMBER (4),
  codice_siope	      NUMBER (4) ,
  codice_siope_c      NUMBER (4) ,
  codice_siope_s      NUMBER (4) ,
  codice_siope_p      NUMBER (4) 
)
 ; 


CREATE UNIQUE INDEX RDRE_PK ON 
  RIGHE_DELIBERA_RETRIBUTIVA(SEDE, ANNO, NUMERO, TIPO, BILANCIO ) 
;