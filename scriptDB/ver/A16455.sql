-- Attività 16455

-- Nuovi indici di RELAZIONI_UO

drop index reuo_uk1;
drop index reuo_uk2;
drop index reuo_uk3;

CREATE INDEX REUO_AK1 ON RELAZIONI_UO
(REVISIONE, PADRE)
STORAGE    (
            INITIAL          3000K
            NEXT             2000K
)
;

CREATE INDEX REUO_AK2 ON RELAZIONI_UO
(REVISIONE, CODICE_PADRE)
STORAGE    (
            INITIAL          3000K
            NEXT             2000K
)
;

CREATE INDEX REUO_AK3 ON RELAZIONI_UO
(REVISIONE, FIGLIO)
STORAGE    (
            INITIAL          3000K
            NEXT             2000K
)
;


