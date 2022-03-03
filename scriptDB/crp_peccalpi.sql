CREATE OR REPLACE PACKAGE Peccalpi IS

/******************************************************************************
 NOME:          PECCALPI
 DESCRIZIONE:

 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

PROCEDURE MAIN(prenotazione IN NUMBER, passo IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY peccalpi IS
   FUNCTION versione
      RETURN VARCHAR2 IS
   BEGIN
      RETURN 'V1.0 del 20/01/2003';
   END versione;

   PROCEDURE main (
      prenotazione               IN       NUMBER
     ,passo                      IN       NUMBER
   ) IS
   BEGIN
      DECLARE
         p_anno        NUMBER (4);
         d_anno_prec   NUMBER (4);
         flag          NUMBER (1);
         d_prin_id     premi_inail.prin_id%TYPE;
      BEGIN
         IF passo <> 0 THEN
            BEGIN
               SELECT valore
                 INTO p_anno
                 FROM a_parametri
                WHERE no_prenotazione = prenotazione
                  AND parametro = 'P_ANNO';
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  SELECT anno
                    INTO p_anno
                    FROM riferimento_retribuzione
                   WHERE rire_id = 'RIRE';
            END;
         ELSE
            p_anno           := prenotazione;
         END IF;

         d_anno_prec      := p_anno - 1;

         BEGIN
            si4.sql_execute ('TRUNCATE TABLE CONTRIBUTI_INAIL');

            INSERT INTO contributi_inail
               SELECT   moco.anno
                       ,moco.ci
                       ,moco.voce
                       ,moco.sub
                       ,moco.mese
                       ,voin.codice posizione
                       ,pere.ruolo
                       ,SUM (moco.tar * SIGN (moco.qta) ) ipn
                   FROM periodi_retributivi pere
                       ,voci_economiche voec
                       ,movimenti_contabili moco
                       ,voci_inail voin
                  WHERE pere.anno = moco.anno
                    AND pere.mese = moco.mese
                    AND pere.servizio IN (SELECT 'Q'
                                            FROM DUAL
                                          UNION
                                          SELECT 'I'
                                            FROM DUAL)
                    AND pere.competenza = 'A'
                    AND pere.ci = moco.ci
                    AND voec.codice = moco.voce
                    AND voec.tipo = 'F'
                    AND moco.voce = voin.voce
                    AND moco.sub = voin.sub
                    AND moco.anno IN (SELECT p_anno
                                        FROM DUAL
                                      UNION
                                      SELECT d_anno_prec
                                        FROM DUAL)
               GROUP BY moco.anno
                       ,moco.ci
                       ,moco.voce
                       ,moco.sub
                       ,moco.mese
                       ,voin.codice
                       ,pere.ruolo;
         END;

         COMMIT;

         FOR pos_inail IN (SELECT codice posizione
                             FROM voci_inail voin)
         LOOP
            BEGIN
               FOR ruoli_ret IN (SELECT DISTINCT NVL (ruolo, 'X') ruolo
                                            FROM periodi_retributivi pere
                                           WHERE anno = p_anno
                                             AND servizio = 'Q'
                                             AND competenza = 'A')
               LOOP
                  flag             := 0;

                  BEGIN
                     SELECT 1
                       INTO flag
                       FROM premi_inail prin
                      WHERE anno = p_anno
                        AND posizione = pos_inail.posizione
                        AND NVL (ruolo, 'X') = ruoli_ret.ruolo;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        flag             := 0;
                  END;

                  IF flag = 1 THEN
                     UPDATE premi_inail
                        SET ipn_presunto =
                               (SELECT SUM (ipn)
                                  FROM contributi_inail
                                 WHERE anno = d_anno_prec
                                   AND ci > 0
                                   AND posizione = pos_inail.posizione
                                   AND NVL (ruolo, 'X') = ruoli_ret.ruolo)
                      WHERE NVL (ipn_presunto, 0) = 0
                        AND anno = p_anno
                        AND posizione = pos_inail.posizione
                        AND NVL (ruolo, 'X') = ruoli_ret.ruolo;

                     UPDATE premi_inail
                        SET ipn_effettivo =
                               (SELECT SUM (ipn)
                                  FROM contributi_inail
                                 WHERE anno = p_anno
                                   AND ci > 0
                                   AND posizione = pos_inail.posizione
                                   AND NVL (ruolo, 'X') = ruoli_ret.ruolo)
                      WHERE anno = p_anno
                        AND posizione = pos_inail.posizione
                        AND NVL (ruolo, 'X') = ruoli_ret.ruolo;
                  ELSE
                     SELECT prin_sq.NEXTVAL
                       INTO d_prin_id
                       FROM DUAL;

                     INSERT INTO premi_inail
                                 (posizione, ruolo, anno, ipn_presunto, ipn_effettivo, prin_id
                                 )
                     VALUES      (pos_inail.posizione, ruoli_ret.ruolo, p_anno, 0, 0, d_prin_id
                                 );

                     UPDATE premi_inail
                        SET ipn_presunto =
                               (SELECT SUM (ipn)
                                  FROM contributi_inail
                                 WHERE anno = d_anno_prec
                                   AND ci > 0
                                   AND posizione = pos_inail.posizione
                                   AND NVL (ruolo, 'X') = ruoli_ret.ruolo)
                      WHERE NVL (ipn_presunto, 0) = 0
                        AND anno = p_anno
                        AND posizione = pos_inail.posizione
                        AND NVL (ruolo, 'X') = ruoli_ret.ruolo;

                     UPDATE premi_inail
                        SET ipn_effettivo =
                               (SELECT SUM (ipn)
                                  FROM contributi_inail
                                 WHERE anno = p_anno
                                   AND ci > 0
                                   AND posizione = pos_inail.posizione
                                   AND NVL (ruolo, 'X') = ruoli_ret.ruolo)
                      WHERE anno = p_anno
                        AND posizione = pos_inail.posizione
                        AND NVL (ruolo, 'X') = ruoli_ret.ruolo;
                  END IF;
               END LOOP;
            END;
         END LOOP;

         DELETE FROM premi_inail
               WHERE anno = p_anno
                 AND NVL (ipn_presunto, 0) = 0
                 AND NVL (ipn_effettivo, 0) = 0;

         UPDATE premi_inail
            SET premio_presunto = (NVL (ipn_presunto, 0) * NVL (alq_presunta, 0) ) / 100
          WHERE anno = p_anno;

         UPDATE premi_inail
            SET saldo_premio =
                           (NVL (ipn_effettivo, 0) * NVL (alq_effettiva, 0) ) / 100
                           - premio_presunto
          WHERE anno = p_anno;
      END;

      COMMIT;
   END;
END;
/

