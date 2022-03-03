CREATE OR REPLACE PACKAGE ppocdipo IS
/******************************************************************************
 NOME:          PPOCDIPO
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
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY ppocdipo IS
FORM_TRIGGER_FAILURE EXCEPTION;
	W_UTENTE	VARCHAR2(10);
	W_AMBIENTE	VARCHAR2(10);
	W_ENTE		VARCHAR2(10);
	W_LINGUA	VARCHAR2(1);
	W_PRENOTAZIONE	NUMBER(10);
	w_voce_menu	varchar2(8);
	p_voce_menu	varchar2(8);
	p_lingue	varchar2(3);
	p_data		date;
	p_livello	number(1);
	errore		varchar2(6);
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
PROCEDURE DEL_DETT_POSTI IS
d_errtext VARCHAR2(240);
d_prenotazione number(6);
BEGIN
   delete from calcolo_posti
    where capo_prenotazione    = w_prenotazione
      and capo_rilevanza       < 6
   ;
EXCEPTION
  WHEN OTHERS THEN
    d_errtext := substr(SQLERRM,1,240);
    d_prenotazione := w_prenotazione;
    ROLLBACK;
    insert into errori_pogm (prenotazione,voce_menu,data,errore)
    values (d_prenotazione,w_VOCE_MENU ,sysdate,d_errtext)
    ;
    COMMIT;
    RAISE FORM_TRIGGER_FAILURE;
END;
-- Determina la sequenza dei gruppi linguistici
PROCEDURE SEQ_LINGUA IS
d_lingua_1     VARCHAR2(1);
d_lingua_2     VARCHAR2(1);
d_lingua_3     VARCHAR2(1);
d_lingua       VARCHAR2(1);
d_conta        number(2);
cursor  GRUPPI_LING is
        select gruppo_al
          from a_gruppi_linguistici
         where gruppo  = w_lingua
           and rownum  < 4
         order by sequenza,gruppo_al;
BEGIN
 IF w_lingua != '*' THEN
  open GRUPPI_LING;
  d_conta     := 1;
  d_lingua_1  := '?';
  d_lingua_2  := '?';
  d_lingua_3  := '?';
  LOOP
    fetch GRUPPI_LING into d_lingua;
    exit when GRUPPI_LING%NOTFOUND;
    IF d_conta = 1 THEN
       d_lingua_1 := d_lingua;
    ELSIF
       d_conta = 2 THEN
       d_lingua_2 := d_lingua;
    ELSE
       d_lingua_3 := d_lingua;
    END IF;
    IF d_conta = 3 THEN
       exit;
    END IF;
    d_conta := d_conta + 1;
  END LOOP;
  close GRUPPI_LING;
 ELSE
  d_lingua_1 := 'I';
  d_lingua_2 := '?';
  d_lingua_3 := '?';
 END IF;
 p_lingue := d_lingua_1||d_lingua_2||d_lingua_3;
END;
PROCEDURE CALCOLO_ETA_ANZIANITA (
      P_CI          IN     NUMBER,
      P_MM_ETA      IN OUT NUMBER,
      P_AA_ETA      IN OUT NUMBER,
      P_GG_ANZ      IN OUT NUMBER,
      P_MM_ANZ      IN OUT NUMBER,
      P_AA_ANZ      IN OUT NUMBER
                                      ) IS
      D_CNPO_MM_ETA    NUMBER(4);
      D_CNPO_AA_ETA    NUMBER(4);
      D_GG_ANZ         NUMBER(4);
      D_MM_ANZ         NUMBER(4);
      D_AA_ANZ         NUMBER(4);
      D_CNPO_GG_ANZ    NUMBER(4);
      D_CNPO_MM_ANZ    NUMBER(4);
      D_CNPO_AA_ANZ    NUMBER(4);
      D_CI             NUMBER(8);
      D_CONTA          NUMBER(6);
      BEGIN
      D_CI := P_CI;
      SELECT  SUM((TRUNC((TRUNC(MONTHS_BETWEEN(LAST_DAY(NVL(PEGI.AL
                                                    ,P_DATA
                                                    ) + 1
                                                )
                                       ,LAST_DAY(PEGI.DAL)
                                       )
                        ) * 30
                   - LEAST(30,TO_NUMBER(TO_CHAR(PEGI.DAL,'DD'
                                               )
                                        )
                          ) + 1
                   + LEAST(30,TO_NUMBER(TO_CHAR(NVL(PEGI.AL
                                                   ,P_DATA
                                                   ) + 1,'DD'
                                               )
                                       ) - 1
                          )
                  ) / 360
                 ))
            * TO_NUMBER(DECODE(PEGI.RILEVANZA,'Q',1,-1))
           )        --  ANNI DI ANZIANITA`
       ,SUM((TRUNC((TRUNC(MONTHS_BETWEEN(LAST_DAY(NVL(PEGI.AL
                                                   ,P_DATA
                                                   ) + 1
                                               )
                                      ,LAST_DAY(PEGI.DAL)
                                      )
                       ) * 30
                  - LEAST(30,TO_NUMBER(TO_CHAR(PEGI.DAL,'DD'
                                              )
                                      )
                         ) + 1
                  + LEAST(30,TO_NUMBER(TO_CHAR(NVL(PEGI.AL
                                                  ,P_DATA
                                                  ) + 1,'DD'
                                              )
                                      ) - 1
                         )
                 - TRUNC((TRUNC(MONTHS_BETWEEN(LAST_DAY(NVL(PEGI.AL
                                                       ,P_DATA
                                                           ) + 1
                                                       )
                                              ,LAST_DAY(PEGI.DAL)
                                              )
                               ) * 30
                          - LEAST(30,TO_NUMBER(TO_CHAR(PEGI.DAL,'DD'
                                                      )
                                              )
                                 ) + 1
                          + LEAST(30,TO_NUMBER(TO_CHAR(NVL(PEGI.AL
                                                      ,P_DATA
                                                          ) + 1,'DD'
                                                      )
                                              ) - 1
                                 )
                         ) / 360
                        ) * 360
                 ) / 30))
            * TO_NUMBER(DECODE(PEGI.RILEVANZA,'Q',1,-1))
           )   -- MESI DI ANZIANITA`
       ,SUM((
       TRUNC(MONTHS_BETWEEN( LAST_DAY(NVL(PEGI.AL,P_DATA)+1)
                            ,LAST_DAY(PEGI.DAL)
                           )
            )*30
           -LEAST( 30,TO_NUMBER(TO_CHAR(PEGI.DAL,'DD'))
                 )+1
           +LEAST( 30,TO_NUMBER(TO_CHAR( NVL(PEGI.AL,P_DATA)+1
                                                ,'DD'))-1)   -
      (TRUNC((TRUNC(MONTHS_BETWEEN( LAST_DAY( NVL(PEGI.AL,P_DATA)+1
                                            )
                                   ,LAST_DAY(PEGI.DAL)
                                  )
                   )*30
             -LEAST( 30,TO_NUMBER(TO_CHAR(PEGI.DAL,'DD'))
                   )+1
             +LEAST( 30,TO_NUMBER( TO_CHAR( NVL(PEGI.AL,P_DATA)+1
                                  ,'DD'))
                   -1))  / 360
            )  *360 )                            -
        TRUNC(
       (TRUNC(MONTHS_BETWEEN( LAST_DAY( NVL(PEGI.AL,P_DATA)+1
                                            )
                                   ,LAST_DAY(PEGI.DAL)
                                  )
                   )*30
             -LEAST( 30,TO_NUMBER(TO_CHAR(PEGI.DAL,'DD'))
                   )+1
             +LEAST( 30,TO_NUMBER( TO_CHAR( NVL(PEGI.AL,P_DATA)+1
                                  ,'DD'))
                   -1) -
       TRUNC((TRUNC(MONTHS_BETWEEN( LAST_DAY( NVL(PEGI.AL,P_DATA)+1
                                            )
                                   ,LAST_DAY(PEGI.DAL)
                                  )
                   )*30
             -LEAST( 30,TO_NUMBER(TO_CHAR(PEGI.DAL,'DD'))
                   )+1
             +LEAST( 30,TO_NUMBER( TO_CHAR( NVL(PEGI.AL,P_DATA)+1
                                  ,'DD'))
                   -1))  / 360
            ) * 360) / 30) * 30)
            * TO_NUMBER(DECODE(PEGI.RILEVANZA,'Q',1,-1))
       )   -- GIORNI DI ANZIANITA`
       ,MAX(TRUNC(MONTHS_BETWEEN(P_DATA,ANAG.DATA_NAS) / 12))
           -- ANNI DI ETA`
       ,MAX(TRUNC(MONTHS_BETWEEN(P_DATA,ANAG.DATA_NAS))
           -TRUNC(MONTHS_BETWEEN(P_DATA,ANAG.DATA_NAS) / 12)
           * 12)  -- MESI DI ETA`
      ,COUNT(*)
        INTO  D_AA_ANZ
             ,D_MM_ANZ
             ,D_GG_ANZ
             ,D_CNPO_AA_ETA
             ,D_CNPO_MM_ETA
             ,D_CONTA
        FROM  RAPPORTI_INDIVIDUALI               RAIN
             ,ANAGRAFICI                         ANAG
             ,PERIODI_GIURIDICI                  PEGI
      --     ,RIFERIMENTO_ORGANICO               RIOR
       WHERE  RAIN.CI                               = PEGI.CI
         AND  ANAG.NI                               = RAIN.NI
         AND  P_DATA               BETWEEN ANAG.DAL
                                            AND NVL(ANAG.AL,
                                                   TO_DATE('3333333','J'))
         AND  (    PEGI.RILEVANZA                  = 'Q'
         OR  PEGI.RILEVANZA                  = 'A'
         AND EXISTS
             (SELECT 'X'
                FROM ASTENSIONI ASTE
               WHERE ASTE.CODICE              = PEGI.ASSENZA
                 AND ASTE.SERVIZIO            = 0
             )
        )
         AND  PEGI.DAL                            <= P_DATA
         AND  PEGI.CI                         = D_CI
      ;
          D_CNPO_GG_ANZ := MOD((D_GG_ANZ       +
                                D_MM_ANZ * 30  +
                                D_AA_ANZ * 360
                               ),30
                              );
          D_CNPO_MM_ANZ := TRUNC(MOD((D_GG_ANZ       +
                                      D_MM_ANZ * 30  +
                                      D_AA_ANZ * 360
                                     ),360
                                    ) / 30
                                );
          D_CNPO_AA_ANZ := TRUNC((D_GG_ANZ       +
                                  D_MM_ANZ * 30  +
                                  D_AA_ANZ * 360
                                 ) / 360
                                );
      IF D_CONTA = 0 THEN           -- NO DATA FOUND
         D_CNPO_MM_ETA := 0;
         D_CNPO_AA_ETA := 0;
         D_CNPO_GG_ANZ := 0;
         D_CNPO_MM_ANZ := 0;
         D_CNPO_AA_ANZ := 0;
      END IF;
      P_MM_ETA := D_CNPO_MM_ETA;
      P_AA_ETA := D_CNPO_AA_ETA;
      P_GG_ANZ := D_CNPO_GG_ANZ;
      P_MM_ANZ := D_CNPO_MM_ANZ;
      P_AA_ANZ := D_CNPO_AA_ANZ;
      END;
PROCEDURE CC_NOMINATIVO IS
      D_ERRTEXT                       VARCHAR2(240);
      D_PRENOTAZIONE                   NUMBER(6);
      D_CAPO_PRENOTAZIONE              NUMBER(6);
      D_RILEVANZA                      NUMBER(2);
      D_RIOR_DATA                        DATE;
      D_POPI_SEDE_POSTO               VARCHAR2(2);
      D_POPI_ANNO_POSTO                NUMBER(4);
      D_POPI_NUMERO_POSTO              NUMBER(7);
      D_POPI_POSTO                     NUMBER(5);
      D_POPI_DAL                         DATE;
      D_POPI_RICOPRIBILE              VARCHAR2(1);
      D_POPI_ORE                       NUMBER(5,2);
      D_POPI_GRUPPO                   VARCHAR2(12);
      D_POPI_PIANTA                    NUMBER(6);
      D_SETP_SEQUENZA                  NUMBER(6);
      D_SETP_CODICE                   VARCHAR2(15);
      D_POPI_SETTORE                   NUMBER(6);
      D_SETT_SEQUENZA                  NUMBER(6);
      D_SETT_CODICE                   VARCHAR2(15);
      D_SETT_SUDDIVISIONE              NUMBER(1);
      D_SETT_SETTORE_G                 NUMBER(6);
      D_SETG_SEQUENZA                  NUMBER(6);
      D_SETG_CODICE                   VARCHAR2(15);
      D_SETT_SETTORE_A                 NUMBER(6);
      D_SETA_SEQUENZA                  NUMBER(6);
      D_SETA_CODICE                   VARCHAR2(15);
      D_SETT_SETTORE_B                 NUMBER(6);
      D_SETB_SEQUENZA                  NUMBER(6);
      D_SETB_CODICE                   VARCHAR2(15);
      D_SETT_SETTORE_C                 NUMBER(6);
      D_SETC_SEQUENZA                  NUMBER(6);
      D_SETC_CODICE                   VARCHAR2(15);
      D_SETT_GESTIONE                 VARCHAR2(4);
      D_GEST_PROSPETTO_PO             VARCHAR2(1);
      D_GEST_SINTETICO_PO             VARCHAR2(1);
      D_POPI_FIGURA                    NUMBER(6);
      D_FIGI_DAL                         DATE;
      D_FIGU_SEQUENZA                  NUMBER(6);
      D_FIGI_CODICE                   VARCHAR2(8);
      D_FIGI_QUALIFICA                 NUMBER(6);
      D_QUGI_DAL                         DATE;
      D_QUAL_SEQUENZA                  NUMBER(6);
      D_QUGI_CODICE                   VARCHAR2(8);
      D_QUGI_CONTRATTO                VARCHAR2(4);
      D_COST_DAL                         DATE;
      D_CONT_SEQUENZA                  NUMBER(3);
      D_COST_ORE_LAVORO                NUMBER(5,2);
      D_QUGI_LIVELLO                  VARCHAR2(4);
      D_FIGI_PROFILO                  VARCHAR2(4);
      D_PRPR_SEQUENZA                  NUMBER(3);
      D_PRPR_SUDDIVISIONE_PO          VARCHAR2(1);
      D_FIGI_POSIZIONE                VARCHAR2(4);
      D_POFU_SEQUENZA                  NUMBER(3);
      D_QUGI_RUOLO                    VARCHAR2(4);
      D_RUOL_SEQUENZA                  NUMBER(3);
      D_POPI_ATTIVITA                 VARCHAR2(4);
      D_ATTI_SEQUENZA                  NUMBER(6);
      D_PEGI_POSIZIONE                VARCHAR2(4);
      D_POSI_SEQUENZA                  NUMBER(3);
      D_POSI_RUOLO                    VARCHAR2(2);
      D_PEGI_TIPO_RAPPORTO            VARCHAR2(2);
      D_PEGI_ORE                       NUMBER(5,2);
      D_PEGI_CI                        NUMBER(8);
      D_PEGI_SOSTITUTO                 NUMBER(8);
      D_ANAG_GRUPPO_LING              VARCHAR2(4);
      D_PEGI_RILEVANZA                VARCHAR2(1);
      D_PEGI_ASSENZA                  VARCHAR2(4);
      D_PEGI_DAL                         DATE;
      D_PEGI_AL                          DATE;
      D_CNPO_MM_ETA                    NUMBER(2);
      D_CNPO_AA_ETA                    NUMBER(2);
      D_CNPO_GG_ANZ                    NUMBER(2);
      D_CNPO_MM_ANZ                    NUMBER(2);
      D_CNPO_AA_ANZ                    NUMBER(2);
      D_POPI_SEDE_POSTO_INC           VARCHAR2(2);
      D_POPI_ANNO_POSTO_INC            NUMBER(4);
      D_POPI_NUMERO_POSTO_INC          NUMBER(7);
      D_POPI_POSTO_INC                 NUMBER(5);
      CURSOR POSTI IS
      SELECT
          CAPO_PRENOTAZIONE,RIOR_DATA,
          POPI_SEDE_POSTO,POPI_ANNO_POSTO,POPI_NUMERO_POSTO,
          POPI_POSTO,POPI_DAL,POPI_RICOPRIBILE,CAPO_ORE_PREVISTI,
          POPI_GRUPPO,POPI_PIANTA,
          SETP_SEQUENZA,SETP_CODICE,POPI_SETTORE,
          SETT_SEQUENZA,SETT_CODICE,
          SETT_SUDDIVISIONE,SETT_SETTORE_G,
          SETG_SEQUENZA,SETG_CODICE,
          SETT_SETTORE_A,SETA_SEQUENZA,
          SETA_CODICE,SETT_SETTORE_B,
          SETB_SEQUENZA,SETB_CODICE,
          SETT_SETTORE_C,SETC_SEQUENZA,
          SETC_CODICE,SETT_GESTIONE,
          GEST_PROSPETTO_PO,GEST_SINTETICO_PO,
          POPI_FIGURA,FIGI_DAL,FIGU_SEQUENZA,
          FIGI_CODICE,FIGI_QUALIFICA,
          QUGI_DAL,QUAL_SEQUENZA,
          QUGI_CODICE,QUGI_CONTRATTO,COST_DAL,
          CONT_SEQUENZA,COST_ORE_LAVORO,
          QUGI_LIVELLO,FIGI_PROFILO,
          PRPR_SEQUENZA,PRPR_SUDDIVISIONE_PO,
          FIGI_POSIZIONE,POFU_SEQUENZA,
          QUGI_RUOLO,RUOL_SEQUENZA,
          POPI_ATTIVITA,ATTI_SEQUENZA
        FROM CALCOLO_POSTI
       WHERE CAPO_PRENOTAZIONE = W_PRENOTAZIONE
         AND CAPO_RILEVANZA    = 1
      ;
      CURSOR PERIODI IS
      SELECT 1,PG.POSIZIONE,PG.TIPO_RAPPORTO,
             NVL(PG.ORE,NVL(D_POPI_ORE,D_COST_ORE_LAVORO)),
             PG.CI,NVL(PG.SOSTITUTO,PG.CI),
             PG.RILEVANZA,PG.ASSENZA,PG.DAL,PG.AL,
             NVL(PO.SEQUENZA,999),PO.RUOLO,AN.GRUPPO_LING,
             PG.SEDE_POSTO,PG.ANNO_POSTO,PG.NUMERO_POSTO,PG.POSTO
        FROM POSIZIONI            P2
            ,POSIZIONI            PO
            ,ANAGRAFICI           AN
            ,RAPPORTI_INDIVIDUALI RI
            ,PERIODI_GIURIDICI    PG
       WHERE D_RIOR_DATA BETWEEN PG.DAL AND NVL(PG.AL,TO_DATE('3333333','J'))
         AND D_RIOR_DATA BETWEEN AN.DAL AND NVL(AN.AL,TO_DATE('3333333','J'))
         AND AN.NI               = RI.NI
         AND RI.CI               = PG.CI
         AND PG.SEDE_POSTO       = D_POPI_SEDE_POSTO
         AND PG.ANNO_POSTO       = D_POPI_ANNO_POSTO
         AND PG.NUMERO_POSTO     = D_POPI_NUMERO_POSTO
         AND PG.POSTO            = D_POPI_POSTO
         AND PG.RILEVANZA       IN ('Q','I')
         AND PO.CODICE           = P2.POSIZIONE
         AND P2.CODICE           = PG.POSIZIONE
       UNION
      SELECT 2,PG.POSIZIONE,PG.TIPO_RAPPORTO,PG.ORE,
             PG.CI,NVL(PG.SOSTITUTO,PG.CI),
             PG.RILEVANZA,PG.ASSENZA,PG.DAL,PG.AL,
             NVL(PO.SEQUENZA,999),PO.RUOLO,AN.GRUPPO_LING,
             PG.SEDE_POSTO,PG.ANNO_POSTO,PG.NUMERO_POSTO,PG.POSTO
        FROM POSIZIONI            P2
            ,POSIZIONI            PO
            ,ANAGRAFICI           AN
            ,RAPPORTI_INDIVIDUALI RI
            ,PERIODI_GIURIDICI    PG
       WHERE D_RIOR_DATA BETWEEN PG.DAL AND NVL(PG.AL,TO_DATE('3333333','J'))
         AND D_RIOR_DATA BETWEEN AN.DAL AND NVL(AN.AL,TO_DATE('3333333','J'))
         AND AN.NI               = RI.NI
         AND RI.CI               = PG.CI
         AND PO.CODICE      (+)  = PG.POSIZIONE
         AND P2.CODICE      (+)  = PO.POSIZIONE
         AND (    PG.RILEVANZA   = 'I'
              OR  PG.RILEVANZA   = 'A'
              AND PG.ASSENZA    IN
                  (SELECT AA.CODICE
                     FROM ASTENSIONI AA
                    WHERE AA.SOSTITUIBILE = 1
                  )
             )
         AND EXISTS
             (SELECT 1
                FROM PERIODI_GIURIDICI P2
               WHERE D_RIOR_DATA BETWEEN P2.DAL
                                     AND NVL(P2.AL,TO_DATE('3333333','J'))
                 AND P2.RILEVANZA     IN ('Q','I')
                 AND P2.ROWID         <> PG.ROWID
                 AND P2.CI             = PG.CI
                 AND P2.SEDE_POSTO     = D_POPI_SEDE_POSTO
                 AND P2.ANNO_POSTO     = D_POPI_ANNO_POSTO
                 AND P2.NUMERO_POSTO   = D_POPI_NUMERO_POSTO
                 AND P2.POSTO          = D_POPI_POSTO
             )
      ;
      CURSOR VACANTI IS
      SELECT PP.DAL,PP.AL
        FROM POSTI_PIANTA PP
       WHERE D_RIOR_DATA BETWEEN PP.DAL AND NVL(PP.AL,TO_DATE('3333333','J'))
         AND PP.SEDE_POSTO             = D_POPI_SEDE_POSTO
         AND PP.ANNO_POSTO             = D_POPI_ANNO_POSTO
         AND PP.NUMERO_POSTO           = D_POPI_NUMERO_POSTO
         AND PP.POSTO                  = D_POPI_POSTO
         AND (    PP.STATO             = 'A'
              AND PP.SITUAZIONE        = 'R'
              OR  PP.STATO            IN ('T','I','C')
             )
         AND NOT EXISTS
             (SELECT 1
                FROM PERIODI_GIURIDICI PG
               WHERE D_RIOR_DATA BETWEEN PG.DAL
                                     AND NVL(PG.AL,TO_DATE('3333333','J'))
                 AND PG.RILEVANZA     IN ('Q','I')
                 AND PG.SEDE_POSTO     = D_POPI_SEDE_POSTO
                 AND PG.ANNO_POSTO     = D_POPI_ANNO_POSTO
                 AND PG.NUMERO_POSTO   = D_POPI_NUMERO_POSTO
                 AND PG.POSTO          = D_POPI_POSTO
             )
      ;
      BEGIN
        OPEN POSTI;
        LOOP
          FETCH POSTI INTO D_CAPO_PRENOTAZIONE,
          D_RIOR_DATA,D_POPI_SEDE_POSTO,D_POPI_ANNO_POSTO,D_POPI_NUMERO_POSTO,
          D_POPI_POSTO,D_POPI_DAL,D_POPI_RICOPRIBILE,D_POPI_ORE,D_POPI_GRUPPO,
          D_POPI_PIANTA,D_SETP_SEQUENZA,
          D_SETP_CODICE,D_POPI_SETTORE,D_SETT_SEQUENZA,D_SETT_CODICE,
          D_SETT_SUDDIVISIONE,D_SETT_SETTORE_G,D_SETG_SEQUENZA,D_SETG_CODICE,
          D_SETT_SETTORE_A,D_SETA_SEQUENZA,D_SETA_CODICE,D_SETT_SETTORE_B,
          D_SETB_SEQUENZA,D_SETB_CODICE,D_SETT_SETTORE_C,D_SETC_SEQUENZA,
          D_SETC_CODICE,D_SETT_GESTIONE,D_GEST_PROSPETTO_PO,
          D_GEST_SINTETICO_PO,D_POPI_FIGURA,D_FIGI_DAL,
          D_FIGU_SEQUENZA,D_FIGI_CODICE,D_FIGI_QUALIFICA,D_QUGI_DAL,
          D_QUAL_SEQUENZA,D_QUGI_CODICE,D_QUGI_CONTRATTO,D_COST_DAL,
          D_CONT_SEQUENZA,D_COST_ORE_LAVORO,D_QUGI_LIVELLO,D_FIGI_PROFILO,
          D_PRPR_SEQUENZA,D_PRPR_SUDDIVISIONE_PO,D_FIGI_POSIZIONE,
          D_POFU_SEQUENZA,D_QUGI_RUOLO,D_RUOL_SEQUENZA,D_POPI_ATTIVITA,
          D_ATTI_SEQUENZA;
          EXIT WHEN POSTI%NOTFOUND;
          OPEN PERIODI;
          LOOP
            FETCH PERIODI INTO D_RILEVANZA,
            D_PEGI_POSIZIONE,D_PEGI_TIPO_RAPPORTO,D_PEGI_ORE,
            D_PEGI_CI,D_PEGI_SOSTITUTO,D_PEGI_RILEVANZA,
            D_PEGI_ASSENZA,D_PEGI_DAL,D_PEGI_AL,
            D_POSI_SEQUENZA,D_POSI_RUOLO,D_ANAG_GRUPPO_LING,
            D_POPI_SEDE_POSTO_INC,D_POPI_ANNO_POSTO_INC,
            D_POPI_NUMERO_POSTO_INC,D_POPI_POSTO_INC;
            EXIT WHEN PERIODI%NOTFOUND;
            CALCOLO_ETA_ANZIANITA(D_PEGI_CI,D_CNPO_MM_ETA,D_CNPO_AA_ETA,
                                  D_CNPO_GG_ANZ,D_CNPO_MM_ANZ,D_CNPO_AA_ANZ
                                 );
            IF D_RILEVANZA = 1 OR D_PEGI_RILEVANZA = 'A' THEN
               D_POPI_SEDE_POSTO_INC    := NULL;
               D_POPI_ANNO_POSTO_INC    := NULL;
               D_POPI_NUMERO_POSTO_INC  := NULL;
               D_POPI_POSTO_INC         := NULL;
            END IF;
            INSERT INTO CALCOLO_NOMINATIVO_POSTI
            (CNPO_PRENOTAZIONE,CNPO_RILEVANZA,RIOR_DATA,
             POPI_SEDE_POSTO,POPI_ANNO_POSTO,POPI_NUMERO_POSTO,POPI_POSTO,
             POPI_GRUPPO,POPI_DAL,POPI_RICOPRIBILE,POPI_PIANTA,
             SETP_SEQUENZA,SETP_CODICE,POPI_SETTORE,SETT_SEQUENZA,
             SETT_CODICE,SETT_SUDDIVISIONE,SETT_SETTORE_G,SETG_SEQUENZA,
             SETG_CODICE,SETT_SETTORE_A,SETA_SEQUENZA,SETA_CODICE,
             SETT_SETTORE_B,SETB_SEQUENZA,SETB_CODICE,SETT_SETTORE_C,
             SETC_SEQUENZA,SETC_CODICE,SETT_GESTIONE,GEST_PROSPETTO_PO,
             GEST_SINTETICO_PO,POPI_FIGURA,FIGI_DAL,FIGU_SEQUENZA,
             FIGI_CODICE,FIGI_QUALIFICA,QUGI_DAL,QUAL_SEQUENZA,QUGI_CODICE,
             QUGI_CONTRATTO,COST_DAL,CONT_SEQUENZA,COST_ORE_LAVORO,
             QUGI_LIVELLO,FIGI_PROFILO,PRPR_SEQUENZA,PRPR_SUDDIVISIONE_PO,
             FIGI_POSIZIONE,POFU_SEQUENZA,QUGI_RUOLO,RUOL_SEQUENZA,
             POPI_ATTIVITA,ATTI_SEQUENZA,PEGI_POSIZIONE,POSI_SEQUENZA,
             PEGI_TIPO_RAPPORTO,PEGI_CI,PEGI_SOSTITUTO,PEGI_RILEVANZA,PEGI_ORE,
             PEGI_ASSENZA,PEGI_GRUPPO_LING,CNPO_MM_ETA,CNPO_AA_ETA,
             CNPO_GG_ANZ,CNPO_MM_ANZ,CNPO_AA_ANZ,CNPO_DAL,CNPO_AL,
             POPI_SEDE_POSTO_INC,POPI_ANNO_POSTO_INC,POPI_NUMERO_POSTO_INC,
             POPI_POSTO_INC)
            VALUES
            (D_CAPO_PRENOTAZIONE,D_RILEVANZA,D_RIOR_DATA,
             D_POPI_SEDE_POSTO,D_POPI_ANNO_POSTO,
             D_POPI_NUMERO_POSTO,D_POPI_POSTO,
             D_POPI_GRUPPO,D_POPI_DAL,D_POPI_RICOPRIBILE,D_POPI_PIANTA,
             D_SETP_SEQUENZA,D_SETP_CODICE,D_POPI_SETTORE,D_SETT_SEQUENZA,
             D_SETT_CODICE,D_SETT_SUDDIVISIONE,
             D_SETT_SETTORE_G,D_SETG_SEQUENZA,
             D_SETG_CODICE,D_SETT_SETTORE_A,D_SETA_SEQUENZA,D_SETA_CODICE,
             D_SETT_SETTORE_B,D_SETB_SEQUENZA,D_SETB_CODICE,D_SETT_SETTORE_C,
             D_SETC_SEQUENZA,D_SETC_CODICE,D_SETT_GESTIONE,D_GEST_PROSPETTO_PO,
             D_GEST_SINTETICO_PO,D_POPI_FIGURA,D_FIGI_DAL,D_FIGU_SEQUENZA,
             D_FIGI_CODICE,D_FIGI_QUALIFICA,D_QUGI_DAL,
             D_QUAL_SEQUENZA,D_QUGI_CODICE,
             D_QUGI_CONTRATTO,D_COST_DAL,D_CONT_SEQUENZA,D_COST_ORE_LAVORO,
             D_QUGI_LIVELLO,D_FIGI_PROFILO,
             D_PRPR_SEQUENZA,D_PRPR_SUDDIVISIONE_PO,
             D_FIGI_POSIZIONE,D_POFU_SEQUENZA,D_QUGI_RUOLO,D_RUOL_SEQUENZA,
             D_POPI_ATTIVITA,D_ATTI_SEQUENZA,D_PEGI_POSIZIONE,D_POSI_SEQUENZA,
             D_PEGI_TIPO_RAPPORTO,D_PEGI_CI,D_PEGI_SOSTITUTO,D_PEGI_RILEVANZA,
             D_PEGI_ORE,
             D_PEGI_ASSENZA,D_ANAG_GRUPPO_LING,D_CNPO_MM_ETA,D_CNPO_AA_ETA,
             D_CNPO_GG_ANZ,D_CNPO_MM_ANZ,D_CNPO_AA_ANZ,D_PEGI_DAL,D_PEGI_AL,
             D_POPI_SEDE_POSTO_INC,D_POPI_ANNO_POSTO_INC,
             D_POPI_NUMERO_POSTO_INC,D_POPI_POSTO_INC)
            ;
          END LOOP;
          CLOSE PERIODI;
          OPEN VACANTI;
          LOOP
            FETCH VACANTI INTO
            D_PEGI_DAL,D_PEGI_AL;
            EXIT WHEN VACANTI%NOTFOUND;
            INSERT INTO CALCOLO_NOMINATIVO_POSTI
            (CNPO_PRENOTAZIONE,CNPO_RILEVANZA,RIOR_DATA,
             POPI_SEDE_POSTO,POPI_ANNO_POSTO,POPI_NUMERO_POSTO,POPI_POSTO,
             POPI_GRUPPO,POPI_DAL,POPI_RICOPRIBILE,POPI_PIANTA,
             SETP_SEQUENZA,SETP_CODICE,POPI_SETTORE,SETT_SEQUENZA,
             SETT_CODICE,SETT_SUDDIVISIONE,SETT_SETTORE_G,SETG_SEQUENZA,
             SETG_CODICE,SETT_SETTORE_A,SETA_SEQUENZA,SETA_CODICE,
             SETT_SETTORE_B,SETB_SEQUENZA,SETB_CODICE,SETT_SETTORE_C,
             SETC_SEQUENZA,SETC_CODICE,SETT_GESTIONE,GEST_PROSPETTO_PO,
             GEST_SINTETICO_PO,POPI_FIGURA,FIGI_DAL,FIGU_SEQUENZA,
             FIGI_CODICE,FIGI_QUALIFICA,QUGI_DAL,QUAL_SEQUENZA,QUGI_CODICE,
             QUGI_CONTRATTO,COST_DAL,CONT_SEQUENZA,COST_ORE_LAVORO,
             QUGI_LIVELLO,FIGI_PROFILO,PRPR_SEQUENZA,PRPR_SUDDIVISIONE_PO,
             FIGI_POSIZIONE,POFU_SEQUENZA,QUGI_RUOLO,RUOL_SEQUENZA,
             POPI_ATTIVITA,ATTI_SEQUENZA,PEGI_POSIZIONE,POSI_SEQUENZA,
             PEGI_TIPO_RAPPORTO,PEGI_CI,PEGI_SOSTITUTO,PEGI_RILEVANZA,
             PEGI_ASSENZA,PEGI_GRUPPO_LING,CNPO_MM_ETA,CNPO_AA_ETA,
             CNPO_GG_ANZ,CNPO_MM_ANZ,CNPO_AA_ANZ,CNPO_DAL,CNPO_AL)
            VALUES
            (D_CAPO_PRENOTAZIONE,1,D_RIOR_DATA,
             D_POPI_SEDE_POSTO,D_POPI_ANNO_POSTO,
             D_POPI_NUMERO_POSTO,D_POPI_POSTO,
             D_POPI_GRUPPO,D_POPI_DAL,D_POPI_RICOPRIBILE,D_POPI_PIANTA,
             D_SETP_SEQUENZA,D_SETP_CODICE,D_POPI_SETTORE,D_SETT_SEQUENZA,
             D_SETT_CODICE,D_SETT_SUDDIVISIONE,
             D_SETT_SETTORE_G,D_SETG_SEQUENZA,
             D_SETG_CODICE,D_SETT_SETTORE_A,D_SETA_SEQUENZA,D_SETA_CODICE,
             D_SETT_SETTORE_B,D_SETB_SEQUENZA,D_SETB_CODICE,D_SETT_SETTORE_C,
             D_SETC_SEQUENZA,D_SETC_CODICE,D_SETT_GESTIONE,D_GEST_PROSPETTO_PO,
             D_GEST_SINTETICO_PO,D_POPI_FIGURA,D_FIGI_DAL,D_FIGU_SEQUENZA,
             D_FIGI_CODICE,D_FIGI_QUALIFICA,D_QUGI_DAL,
             D_QUAL_SEQUENZA,D_QUGI_CODICE,
             D_QUGI_CONTRATTO,D_COST_DAL,D_CONT_SEQUENZA,D_COST_ORE_LAVORO,
             D_QUGI_LIVELLO,D_FIGI_PROFILO,
             D_PRPR_SEQUENZA,D_PRPR_SUDDIVISIONE_PO,
             D_FIGI_POSIZIONE,D_POFU_SEQUENZA,D_QUGI_RUOLO,D_RUOL_SEQUENZA,
             D_POPI_ATTIVITA,D_ATTI_SEQUENZA,NULL,0,
             NULL,NULL,0,NULL,
             NULL,NULL,NULL,NULL,
             NULL,NULL,NULL,D_PEGI_DAL,D_PEGI_AL)
            ;
          END LOOP;
          CLOSE VACANTI;
        END LOOP;
        CLOSE POSTI;
      EXCEPTION
        WHEN OTHERS THEN
          D_ERRTEXT := SUBSTR(SQLERRM,1,240);
          D_PRENOTAZIONE := W_PRENOTAZIONE;
          ROLLBACK;
          INSERT INTO ERRORI_POGM (PRENOTAZIONE,VOCE_MENU,DATA,ERRORE)
          VALUES (D_PRENOTAZIONE,W_VOCE_MENU ,SYSDATE,D_ERRTEXT)
          ;
          COMMIT;
          RAISE FORM_TRIGGER_FAILURE;
      END;
-- PULIZIA TABELLA DI LAVORO
      PROCEDURE DELETE_TAB IS
      D_ERRTEXT VARCHAR2(240);
      D_PRENOTAZIONE NUMBER(6);
      BEGIN
        DELETE FROM CALCOLO_POSTI
         WHERE CAPO_PRENOTAZIONE = W_PRENOTAZIONE;
        DELETE FROM CALCOLO_NOMINATIVO_POSTI
         WHERE CNPO_PRENOTAZIONE = W_PRENOTAZIONE;
      EXCEPTION
        WHEN OTHERS THEN
          D_ERRTEXT := SUBSTR(SQLERRM,1,240);
          D_PRENOTAZIONE := W_PRENOTAZIONE;
          ROLLBACK;
          INSERT INTO ERRORI_POGM (PRENOTAZIONE,VOCE_MENU,DATA,ERRORE)
          VALUES (D_PRENOTAZIONE,W_VOCE_MENU ,SYSDATE,D_ERRTEXT)
          ;
          COMMIT;
          RAISE FORM_TRIGGER_FAILURE;
      END;
      -- CALCOLO
      PROCEDURE CALCOLO
      IS
      BEGIN
         BEGIN
            DELETE_TAB;
            SEQ_LINGUA;
            PPOCDIPO2.CC_POSTI(P_DATA,P_LINGUE,W_PRENOTAZIONE,W_VOCE_MENU);
            CC_NOMINATIVO;
            PPOCDIPO2.RAGGR_POSTI(W_PRENOTAZIONE,W_VOCE_MENU);
            DEL_DETT_POSTI;
            COMMIT;
         END;
      END;
  PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO        IN NUMBER) is
	begin
	IF PRENOTAZIONE != 0 THEN
                  BEGIN  -- PRELEVA UTENTE DA DEPOSITARE IN CAMPI GLOBAL
                     SELECT UTENTE
                          , AMBIENTE
                          , ENTE
                          , GRUPPO_LING
                          , VOCE_MENU
                       INTO W_UTENTE
                          , W_AMBIENTE
                          , W_ENTE
                          , W_LINGUA
                          , w_VOCE_MENU
                       FROM A_PRENOTAZIONI
                      WHERE NO_PRENOTAZIONE = PRENOTAZIONE
                     ;
                  EXCEPTION
                     WHEN OTHERS THEN NULL;
                  END;
               END IF;
               BEGIN
                 SELECT SUBSTR(PARA.VALORE,1,8)
                   INTO P_VOCE_MENU
                   FROM A_PARAMETRI PARA
                  WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
                    AND PARA.PARAMETRO       = 'P_VOCE_MENU'
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                   P_VOCE_MENU := ' ';
               END;
               BEGIN
                 SELECT to_number(SUBSTR(PARA.VALORE,1,1))
                   INTO P_LIVELLO
                   FROM A_PARAMETRI PARA
                  WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
                    AND PARA.PARAMETRO       = 'P_APPR_LIVELLO'
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                   P_LIVELLO := 1;
               END;
               BEGIN
                 SELECT TO_DATE(PARA.VALORE,'DD/MM/YYYY')
                   INTO P_DATA
                   FROM A_PARAMETRI PARA
                  WHERE PARA.NO_PRENOTAZIONE = PRENOTAZIONE
                    AND PARA.PARAMETRO       = 'P_RIFERIMENTO'
                 ;
               EXCEPTION
                 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                   BEGIN
                      SELECT RIOR.DATA
                        INTO P_DATA
                        FROM RIFERIMENTO_ORGANICO RIOR
                      ;
                   EXCEPTION
                      WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                         P_DATA := SYSDATE;
                   END;
               END;
               W_PRENOTAZIONE := PRENOTAZIONE;
               ERRORE := to_char(null);
               -- MEMORIZZATO IN CASO DI AZZERAMENTO PER ROLLBACK
               -- VIENE RIAZZERATO IN FORM CHIAMANTE PER EVITARE TRASACTION COMPLETED
               CALCOLO;  -- ESECUZIONE DEL CALCOLO POSTI
               IF W_PRENOTAZIONE != 0 THEN
                  IF SUBSTR(errore,6,1) = '8' THEN
                     UPDATE A_PRENOTAZIONI
                        SET ERRORE = 'P05808'
                      WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
                     ;
                     COMMIT;
                  ELSIF
                     SUBSTR(errore,6,1) = '9' THEN
                     UPDATE A_PRENOTAZIONI
                        SET ERRORE       = 'P05809'
                          , PROSSIMO_PASSO = 91
                      WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
                     ;
                     COMMIT;
                  END IF;
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  BEGIN
                     ROLLBACK;
                     IF W_PRENOTAZIONE != 0 THEN
                        UPDATE A_PRENOTAZIONI
                           SET ERRORE       = '*ABORT*'
                             , PROSSIMO_PASSO = 99
                        WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
                        ;
                        COMMIT;
                     END IF;
                  EXCEPTION
                     WHEN OTHERS THEN
NULL;
                  END;
            END;
END;
/

