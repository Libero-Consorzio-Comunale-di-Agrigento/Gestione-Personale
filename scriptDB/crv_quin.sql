CREATE OR REPLACE VIEW QUALIFICHE_INAIL_INDIVIDUALI 
( CI,DATA, QUALIFICA_INAIL ) AS 
SELECT evin.ci
      ,evin.data
      ,quin.qualifica_inail
  FROM EVENTI_INFORTUNIO     evin
      ,QUALIFICHE_INAIL      quin
      ,PERIODI_GIURIDICI     PEGI
      ,FIGURE_GIURIDICHE     figi
      ,QUALIFICHE_GIURIDICHE qugi
 WHERE PEGI.rilevanza            = 'S'
   AND PEGI.ci                   = evin.ci
   AND evin.data           BETWEEN PEGI.dal
                               AND NVL(PEGI.al,TO_DATE(3333333,'j'))
   AND figi.numero               = PEGI.figura
   AND evin.data           BETWEEN figi.dal
                               AND NVL(figi.al,TO_DATE(3333333,'j'))
   AND qugi.numero               = PEGI.qualifica
   AND evin.data           BETWEEN qugi.dal
                               AND NVL(qugi.al,TO_DATE(3333333,'j'))
   AND        quin.figura
       ||' '||quin.qualifica
       ||' '||quin.ATTIVITA      =
      (SELECT MAX(       quin2.figura
                  ||' '||quin2.qualifica
                  ||' '||quin2.ATTIVITA
                 )
         FROM QUALIFICHE_INAIL quin2
        WHERE qugi.codice            LIKE quin2.qualifica
          AND figi.codice            LIKE quin2.figura
          AND NVL(PEGI.ATTIVITA,' ') LIKE quin2.ATTIVITA
      )
/

