ALTER TABLE CALCOLO_DOTAZIONE
MODIFY(PEGI_EVENTO VARCHAR2(6));

ALTER TABLE CALCOLO_NOMINATIVO_DOTAZIONE
MODIFY(PEGI_EVENTO VARCHAR2(6));

ALTER TABLE PERIODI_DOTAZIONE
MODIFY(INCARICO VARCHAR2(6));