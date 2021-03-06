INSERT INTO SUDDIVISIONI_STRUTTURA
(
OTTICA
,LIVELLO
,SEQUENZA
,DENOMINAZIONE
, DENOMINAZIONE_AL1
, DENOMINAZIONE_AL2
, DES_ABB
, DES_ABB_AL1
, DES_ABB_AL2
, ICONA
, NOTE
, UTENTE
, DATA_AGG
)
(SELECT 'GP4'
		,0
		,0
		,nvl(nota_gestione,'livello 1')
		,nota_gestione
		,nota_gestione
		,SUBSTR(nvl(nota_gestione,'liv 1'),0,8)
		,SUBSTR(nota_gestione_al1,0,8)
		,SUBSTR(nota_gestione_al2,0,8)
		,'gestione'
		,TO_CHAR(NULL)
		,'AUTO'		
		,SYSDATE
   FROM ENTE
  WHERE ENTE_ID='ENTE'
)
/
INSERT INTO SUDDIVISIONI_STRUTTURA
(
OTTICA
,LIVELLO
,SEQUENZA
,DENOMINAZIONE
, DENOMINAZIONE_AL1
, DENOMINAZIONE_AL2
, DES_ABB
, DES_ABB_AL1
, DES_ABB_AL2
, ICONA
, NOTE
, UTENTE
, DATA_AGG
)
(SELECT 'GP4'
		,1
		,10
		,nvl(NOTA_SETTORE_A,'livello 2')
		,NOTA_SETTORE_A
		,NOTA_SETTORE_A
		,SUBSTR(nvl(NOTA_SETTORE_A,'liv 2'),0,8)
		,SUBSTR(nota_settore_a_al1,0,8)
		,SUBSTR(nota_settore_a_al2,0,8)
		,'set1'
		,TO_CHAR(NULL)
		,'AUTO'
		,SYSDATE
   FROM ENTE
  WHERE ENTE_ID='ENTE'
)
/
INSERT INTO SUDDIVISIONI_STRUTTURA
(
OTTICA
,LIVELLO
,SEQUENZA
,DENOMINAZIONE
, DENOMINAZIONE_AL1
, DENOMINAZIONE_AL2
, DES_ABB
, DES_ABB_AL1
, DES_ABB_AL2
, ICONA
, NOTE
, UTENTE
, DATA_AGG
)
(SELECT 'GP4'
		,2
		,20
		,nvl(NOTA_SETTORE_B,'livello 3')
		,NOTA_SETTORE_B
		,NOTA_SETTORE_B
		,SUBSTR(nvl(NOTA_SETTORE_B,'liv 3'),0,8)
		,SUBSTR(nota_settore_b_al1,0,8)
		,SUBSTR(nota_settore_b_al2,0,8)
		,'set2'
		,TO_CHAR(NULL)
		,'AUTO'
		,SYSDATE
   FROM ENTE
  WHERE ENTE_ID='ENTE'
)
/
INSERT INTO SUDDIVISIONI_STRUTTURA
(
OTTICA
,LIVELLO
,SEQUENZA
,DENOMINAZIONE
, DENOMINAZIONE_AL1
, DENOMINAZIONE_AL2
, DES_ABB
, DES_ABB_AL1
, DES_ABB_AL2
, ICONA
, NOTE
, UTENTE
, DATA_AGG
)
(SELECT 'GP4'
		,3
		,30
		,nvl(NOTA_SETTORE_C,'livello 4')
		,NOTA_SETTORE_C
		,NOTA_SETTORE_C
		,SUBSTR(nvl(NOTA_SETTORE_C,'liv 4'),0,8)
		,SUBSTR(nota_settore_c_al1,0,8)
		,SUBSTR(nota_settore_c_al2,0,8)
		,'set3'
		,TO_CHAR(NULL)
		,'AUTO'
		,SYSDATE
   FROM ENTE
  WHERE ENTE_ID='ENTE'
)
/
INSERT INTO SUDDIVISIONI_STRUTTURA
(
OTTICA
,LIVELLO
,SEQUENZA
,DENOMINAZIONE
, DENOMINAZIONE_AL1
, DENOMINAZIONE_AL2
, DES_ABB
, DES_ABB_AL1
, DES_ABB_AL2
, ICONA
, NOTE
, UTENTE
, DATA_AGG
)
(SELECT 'GP4'
		,4
		,40
		,nvl(NOTA_SETTORE,'livello 5')
		,NOTA_SETTORE
		,NOTA_SETTORE
		,SUBSTR(nvl(NOTA_SETTORE,'liv 5'),0,8)
		,SUBSTR(nota_settore_al1,0,8)
		,SUBSTR(nota_settore_al2,0,8)
		,'set4'
		,TO_CHAR(NULL)
		,'AUTO'
		,SYSDATE
   FROM ENTE
  WHERE ENTE_ID='ENTE'
)
/
INSERT INTO SUDDIVISIONI_STRUTTURA
(
OTTICA
,LIVELLO
,SEQUENZA
,DENOMINAZIONE
, DENOMINAZIONE_AL1
, DENOMINAZIONE_AL2
, DES_ABB
, DES_ABB_AL1
, DES_ABB_AL2
, ICONA
, NOTE
, UTENTE
, DATA_AGG
)
(SELECT 'GP4'
		,5
		,50
		,'livello 6'
		,TO_CHAR(NULL)
		,TO_CHAR(NULL)
		,'liv 6'
		,TO_CHAR(NULL)
		,TO_CHAR(NULL)
		,TO_CHAR(NULL)
		,TO_CHAR(NULL)
		,'AUTO'
		,SYSDATE
   FROM ENTE
  WHERE ENTE_ID='ENTE'
)
/
COMMIT
/


		