CREATE OR REPLACE PACKAGE Ppaccapa2 IS
/******************************************************************************
 NOME:          PPACCAPA2
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000             
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
  PROCEDURE CALCOLO_VALORE (
P_CI   IN NUMBER,
P_TIPO IN VARCHAR2,
P_CODICE   IN VARCHAR2,
P_TIPO_RECORD  IN VARCHAR2,
P_STAMPA   IN VARCHAR2,
P_SEDE IN NUMBER,
P_CDC  IN VARCHAR2,
P_GEST IN VARCHAR2,
P_SETTORE  IN NUMBER,
P_DESCRIZIONE  IN OUT VARCHAR2,
P_GESTIONE IN OUT VARCHAR2,
P_VALORE   IN OUT NUMBER,
P_DAL      IN DATE,
P_AL      IN DATE
 );
END;
/

CREATE OR REPLACE PACKAGE BODY Ppaccapa2 IS
  -- Determinazione valore colonne del Prospetto
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
PROCEDURE CALCOLO_VALORE (
P_CI   IN NUMBER,
P_TIPO IN VARCHAR2,
P_CODICE   IN VARCHAR2,
P_TIPO_RECORD  IN VARCHAR2,
P_STAMPA   IN VARCHAR2,
P_SEDE IN NUMBER,
P_CDC  IN VARCHAR2,
P_GEST IN VARCHAR2,
P_SETTORE  IN NUMBER,
P_DESCRIZIONE  IN OUT VARCHAR2,
P_GESTIONE IN OUT VARCHAR2,
P_VALORE   IN OUT NUMBER,
p_dal IN DATE,
p_al IN DATE
 ) IS
d_ci NUMBER(8)   ;
d_tipo VARCHAR2(2)   ;
d_codice   VARCHAR2(8)   ;
d_descrizione  VARCHAR2(8)   ;
d_gestione VARCHAR2(2)   ;
d_valore NUMBER  ;
d_tipo_rec VARCHAR2(2)   ;
d_stampa   VARCHAR2(1)   ;
d_sede   NUMBER(6)   ;
d_cdc  VARCHAR2(8)   ;
d_gest VARCHAR2(4)   ;
d_settore    NUMBER(6)   ;
BEGIN
    d_ci  := P_CI;
    d_tipo    := P_TIPO;
    d_codice  := P_CODICE;
    d_tipo_rec    := P_TIPO_RECORD;
    d_stampa  := P_STAMPA;
    d_sede    := P_SEDE;
    d_cdc := P_CDC;
    d_gest    := P_GEST;
    d_settore := P_SETTORE;
    BEGIN
  IF   d_tipo    = 'CT' THEN
   SELECT  ctev.gestione
  ,d_codice
 INTO  d_gestione
  ,d_descrizione
 FROM  CATEGORIE_EVENTO ctev
    WHERE  ctev.codice  = d_codice
   ;
  ELSIF
   d_tipo    = 'CL' THEN
   SELECT  clev.gestione
  ,d_codice
 INTO  d_gestione
  ,d_descrizione
 FROM  CLASSI_EVENTO clev
    WHERE  clev.codice  = d_codice
   ;
  ELSE
   SELECT  caev.gestione
  ,caev.des_abb
 INTO  d_gestione
  ,d_descrizione
 FROM  CAUSALI_EVENTO caev
    WHERE  caev.codice  = d_codice
   ;
  END IF;
    EXCEPTION
  WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
    d_descrizione := d_codice;
    d_gestione    := 'N';
    END;
    IF   d_tipo_rec    = '01'
    AND  NVL(d_stampa,'N') = 'R'
    OR   d_tipo_rec    = '02'
    AND  NVL(d_stampa,'N') = 'N'   THEN
 d_valore := 0;
    ELSE
    IF   d_tipo    = 'CT' THEN
 SELECT SUM(DECODE(toca.gestione
   ,'G',NVL(evpa.al,TO_DATE('3333333','j'))
    - evpa.dal + 1
   ,evpa.valore
   ) * DECODE(toca.segno,'-',-1,1)
     * DECODE(ctev.gestione||caev.gestione
     ,'HG',NVL(pspa.min_gg,0)
     ,'OG',NVL(pspa.min_gg,0)
  ,1
     )
     / DECODE(ctev.gestione||caev.gestione
     ,'GH',decode(NVL(pspa.min_gg,1),0,1,NVL(pspa.min_gg,1))
     ,'GO',decode(NVL(pspa.min_gg,1),0,1,NVL(pspa.min_gg,1))
  ,1
     )
   )
   INTO d_valore
   FROM
    CATEGORIE_EVENTO  ctev
   ,TOTALIZZAZIONE_CAUSALI    toca
   ,CAUSALI_EVENTO    caev
   ,SEDI  sedr
   ,SEDI  sede
   ,EVENTI_PRESENZA   evpa
   ,MESI  mese
   ,SETTORI   sett
--   ,RIPARTIZIONI_FUNZIONALI   rifu
   ,RAPPORTI_PRESENZA rapa
   ,periodi_servizio_presenza pspa
  WHERE evpa.ci = pspa.ci
    AND rapa.ci = pspa.ci
	AND evpa.al BETWEEN NVL(P_dal,TO_DATE(2222222,'j'))
	                AND P_al
    AND rapa.dal    = pspa.dal_rapporto
	AND  evpa.dal BETWEEN rapa.dal AND NVL(rapa.al,TO_DATE('3333333','j'))
    AND pspa.ci = d_ci
    AND mese.anno    = TO_NUMBER(TO_CHAR(p_al,'yyyy'))
    AND mese.mese    = TO_NUMBER(TO_CHAR(p_al,'mm'))
    AND sett.numero = pspa.SETTORE
    AND toca.categoria  = d_codice
    AND caev.codice = evpa.causale
    AND ctev.codice = toca.categoria
    AND evpa.causale    = toca.causale
    AND NVL(evpa.motivo,' ')
     LIKE toca.motivo
    AND evpa.dal  BETWEEN pspa.dal
  AND NVL(pspa.al ,TO_DATE('3333333','j'))
    AND evpa.riferimento
  BETWEEN NVL(ctev.dal,TO_DATE('2222222','j'))
  AND NVL(ctev.al ,TO_DATE('3333333','j'))
    AND (mese.fin_mese - evpa.dal + 1)
   <= DECODE(TO_CHAR(toca.riferimento_mm)||
     TO_CHAR(toca.riferimento_gg)
    ,NULL,9999
    ,NVL(toca.riferimento_mm,0)
     * 30 +
     NVL(toca.riferimento_gg,0)
    )
    AND evpa.dal   <= mese.fin_mese
	AND evpa.al BETWEEN NVL(P_dal,TO_DATE(2222222,'j'))
	                AND P_al
    AND sedr.numero    (+)  = pspa.sede
    AND sede.numero    (+)  = evpa.sede
    AND NVL(sede.codice,NVL(sedr.codice,' '))
     LIKE ctev.sede
    AND NVL(evpa.CDC,NVL(rapa.CDC,NVL(pspa.CDC,' ')))
     LIKE ctev.CDC
    AND DECODE(ctev.opzione
  ,'M',TO_CHAR(ADD_MONTHS(evpa.dal
     ,DECODE(caev.riferimento
    ,'P',1,0
    )
     ),'yyyymm'
  )
  ,'A',TO_CHAR(ADD_MONTHS(evpa.dal
     ,DECODE(caev.riferimento
    ,'P',1,0
    )
     ),'yyyy'
  )
  ,'T',TO_CHAR(mese.fin_mese,'yyyy')
  ,'P',TO_CHAR(ADD_MONTHS(evpa.dal
     ,DECODE(caev.riferimento
    ,'P',1,0
    )
     ),'yyyy'
  )
  ,NULL
  ) =
    DECODE(ctev.opzione
  ,'M',TO_CHAR(mese.fin_mese,'yyyymm')
  ,'A',TO_CHAR(mese.fin_mese,'yyyy')
  ,'T',TO_CHAR(mese.fin_mese,'yyyy')
  ,'P',TO_CHAR(TO_NUMBER(TO_CHAR(mese.fin_mese,'yyyy'))
   -1)
  ,NULL
  )
    AND  (    NVL(evpa.sede,NVL(rapa.sede,NVL(pspa.sede,0)))
  = NVL(d_sede,0)
  AND  NVL(evpa.CDC,NVL(rapa.CDC,NVL(pspa.CDC,' ')))
  = NVL(d_cdc,' ')
  AND  NVL(sett.gestione,' ')
  = NVL(d_gest,' ')
  AND  NVL(pspa.SETTORE,0)
  = NVL(d_settore,0)
  AND  P_TIPO_RECORD  = '01'
  OR   P_TIPO_RECORD  = '02'
 )
    ;
    ELSIF
 d_tipo    = 'CL' THEN
 SELECT  SUM(valore *
 DECODE(clev.gestione||caev.gestione
   ,'HG',NVL(pspa.min_gg,0)
   ,'OG',NVL(pspa.min_gg,0)
    ,1
   ) /
 DECODE(clev.gestione||caev.gestione
   ,'GH',decode(NVL(pspa.min_gg,1),0,1,NVL(pspa.min_gg,1))
   ,'GO',decode(NVL(pspa.min_gg,1),0,1,NVL(pspa.min_gg,1))
    ,1
   )
    )
   INTO  d_valore
   FROM  CAUSALI_EVENTO    caev
    ,RIPARTIZIONE_CAUSALI  rica
    ,SETTORI   sett
    ,CLASSI_EVENTO clev
    ,RAPPORTI_PRESENZA rapa
    ,EVENTI_PRESENZA   evpa
    ,periodi_servizio_presenza pspa
  WHERE  NVL(evpa.dal  ,TO_DATE('2222222','j'))
     <=
 NVL(p_al ,TO_DATE('3333333','j'))
    AND  NVL(evpa.al   ,TO_DATE('3333333','j'))
     >=
 NVL(p_dal,TO_DATE('2222222','j'))
    AND  NVL(evpa.dal  ,TO_DATE('2222222','j'))
    BETWEEN
 pspa.dal
    AND
 NVL(pspa.al   ,TO_DATE('3333333','j'))
    AND  rica.classe  = d_codice
    AND  rica.causale = evpa.causale
    AND  pspa.ci  = d_ci
    AND  rapa.ci  = d_ci
	AND  evpa.dal BETWEEN rapa.dal AND NVL(rapa.al,TO_DATE('3333333','j'))
    AND  evpa.ci  = d_ci
    AND  clev.codice  = d_codice
    AND  caev.codice  = evpa.causale
    AND  sett.numero  = pspa.SETTORE
    AND  (    NVL(evpa.sede,NVL(rapa.sede,NVL(pspa.sede,0)))
  = NVL(d_sede,0)
  AND  NVL(evpa.CDC,NVL(rapa.CDC,NVL(pspa.CDC,' ')))
  = NVL(d_cdc,' ')
  AND  NVL(sett.gestione,' ')
  = NVL(d_gest,' ')
  AND  NVL(pspa.SETTORE,0)
  = NVL(d_settore,0)
  AND  P_TIPO_RECORD  = '01'
  OR   P_TIPO_RECORD  = '02'
 )
 ;
    ELSE
 SELECT  SUM(evpa.valore)
   INTO  d_valore
   FROM  CAUSALI_EVENTO    caev
    ,SETTORI   sett
    ,RAPPORTI_PRESENZA rapa
    ,EVENTI_PRESENZA   evpa
    ,periodi_servizio_presenza pspa
  WHERE  NVL(evpa.dal  ,TO_DATE('2222222','j'))
     <=
 NVL(p_al ,TO_DATE('3333333','j'))
    AND  NVL(evpa.al   ,TO_DATE('3333333','j'))
     >=
 NVL(p_dal,TO_DATE('2222222','j'))
    AND  NVL(evpa.dal  ,TO_DATE('2222222','j'))
    BETWEEN
 pspa.dal
    AND
 NVL(pspa.al   ,TO_DATE('3333333','j'))
    AND  evpa.causale = d_codice
    AND  pspa.ci  = d_ci
    AND  rapa.ci  = d_ci
	AND  evpa.dal BETWEEN rapa.dal AND NVL(rapa.al,TO_DATE('3333333','j'))
    AND  evpa.ci  = d_ci
    AND  caev.codice  = d_codice
    AND  sett.numero  = pspa.SETTORE
    AND  (    NVL(evpa.sede,NVL(rapa.sede,NVL(pspa.sede,0)))
  = NVL(d_sede,0)
  AND  NVL(evpa.CDC,NVL(rapa.CDC,NVL(pspa.CDC,' ')))
  = NVL(d_cdc,' ')
  AND  NVL(sett.gestione,' ')
  = NVL(d_gest,' ')
  AND  NVL(pspa.SETTORE,0)
  = NVL(d_settore,0)
  AND  P_TIPO_RECORD  = '01'
  OR   P_TIPO_RECORD  = '02'
 )
 ;
    END IF;
    END IF;
    IF  d_valore IS NULL THEN
    d_valore := 0;
    END IF;
  P_GESTIONE := d_gestione;
  P_DESCRIZIONE  := d_descrizione;
  P_VALORE   := d_valore;
END;
END;
/

