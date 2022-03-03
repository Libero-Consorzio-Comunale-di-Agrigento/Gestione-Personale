-- Alter precauzionale campi note, note_al1 e note_al2
alter table CONTRATTI_STORICI modify note varchar2(4000);
alter table CONTRATTI_STORICI modify note_al1 varchar2(4000);
alter table CONTRATTI_STORICI modify note_al2 varchar2(4000);
alter table FIGURE_GIURIDICHE modify note varchar2(4000);
alter table FIGURE_GIURIDICHE modify note_al1 varchar2(4000);
alter table FIGURE_GIURIDICHE modify note_al2 varchar2(4000);
alter table PERIODI_GIURIDICI modify note varchar2(4000);
alter table PERIODI_GIURIDICI modify note_al1 varchar2(4000);
alter table PERIODI_GIURIDICI modify note_al2 varchar2(4000);
alter table QUALIFICHE_GIURIDICHE modify note varchar2(4000);
alter table QUALIFICHE_GIURIDICHE modify note_al1 varchar2(4000);
alter table QUALIFICHE_GIURIDICHE modify note_al2 varchar2(4000);
alter table ARCHIVIO_DOCUMENTI_GIURIDICI modify note varchar2(4000);
alter table ARCHIVIO_DOCUMENTI_GIURIDICI modify note_al1 varchar2(4000);
alter table ARCHIVIO_DOCUMENTI_GIURIDICI modify note_al2 varchar2(4000);
alter table MODELLI_NOTE modify note varchar2(4000);
alter table MODELLI_NOTE modify note_al1 varchar2(4000);
alter table MODELLI_NOTE modify note_al2 varchar2(4000);
alter table NOTE_INDIVIDUALI modify note varchar2(4000);
alter table NOTE_INDIVIDUALI modify note_al1 varchar2(4000);
alter table NOTE_INDIVIDUALI modify note_al2 varchar2(4000);
alter table ISTITUTI_CREDITO modify note varchar2(4000);
alter table ISTITUTI_CREDITO modify note_al1 varchar2(4000);
alter table ISTITUTI_CREDITO modify note_al2 varchar2(4000);
alter table SPORTELLI modify note varchar2(4000);
alter table SPORTELLI modify note_al1 varchar2(4000);
alter table SPORTELLI modify note_al2 varchar2(4000);
alter table CODICI_BILANCIO modify note varchar2(4000);
alter table CODICI_BILANCIO modify note_al1 varchar2(4000);
alter table CODICI_BILANCIO modify note_al2 varchar2(4000);
alter table ANAGRAFICI modify note varchar2(4000);
alter table ASSEGNAZIONI_CONTABILI modify note varchar2(4000);
alter table CONVOCAZIONI modify note varchar2(4000);
alter table DELIBERE modify note varchar2(4000);
alter table INFORMAZIONI_RETRIBUTIVE modify note varchar2(4000);
alter table INFORMAZIONI_RETRIBUTIVE_BP modify note varchar2(4000);
alter table RAPPORTI_GIURIDICI modify note varchar2(4000);
alter table RAPPORTI_INDIVIDUALI modify note varchar2(4000);
alter table SOSTITUZIONI_GIURIDICHE modify note varchar2(4000);
alter table TIPI_RAPPORTO modify note varchar2(4000);

-- Alter precauzionale campi del modulo IE
alter table REGOLE_CONVERSIONI modify CODIFICA_VALORE varchar2(4000);
alter table REGOLE_CONVERSIONI modify CODIFICA_VALORE_PRECEDENTE varchar2(4000);
alter table VARIAZIONI modify VALORE varchar2(4000);
alter table VARIAZIONI modify VALORE_PRECEDENTE varchar2(4000);
alter table VARIAZIONI_STORICHE modify VALORE varchar2(4000);
alter table VARIAZIONI_STORICHE modify VALORE_PRECEDENTE varchar2(4000);
alter table W_VARIAZIONI modify VALORE varchar2(4000);
alter table W_VARIAZIONI modify VALORE_PRECEDENTE varchar2(4000);

-- Aggiornamento pks standard
start crp_SI4_BASE64.sql
start crp_WEBUTIL_DB.sql

-- Creazione viste SETTORI_VIEW e DOCUMENTI_GIURIDICI
start crv_gp4gm_2.sql
start crv_dogi.sql

-- Abilitazione dei trigger
alter trigger PEGI_PEDO_TMA enable;
alter trigger PEGI_DOES_TMA enable;
alter trigger PEGI_SOGI_TMA enable;

-- Cancellazione e ri-creazione della CALCOLI_DO 
rename CALDOLI_DO to CALCOLI_DO_ANTE_A20637;
drop index CALO_UK1;
start crt_calo.sql

-- cancellazione campi su REVISIONI_STRUTTURA
declare
V_comando   varchar2(500);
V_alter     varchar2(2);
BEGIN
   BEGIN
     select 'SI'
       into V_alter
       from user_tab_columns
      where table_name = 'REVISIONI_STRUTTURA'
        and column_name = 'TIPO_REGISTRO'
     ;
   EXCEPTION WHEN NO_DATA_FOUND THEN  
     V_alter := 'NO';
   END;
   IF V_alter = 'SI' THEN
      v_comando :='ALTER TABLE REVISIONI_STRUTTURA DROP COLUMN TIPO_REGISTRO';
      si4.sql_execute(v_comando);
      v_comando :='ALTER TABLE REVISIONI_STRUTTURA DROP COLUMN ANNO';
      si4.sql_execute(v_comando);
      v_comando :='ALTER TABLE REVISIONI_STRUTTURA DROP COLUMN NUMERO';
      si4.sql_execute(v_comando);
   END IF;
END;
/

-- cancellazione campo su RAPPORTI_CONCORSUALI
declare
V_comando   varchar2(500);
V_alter     varchar2(2);
BEGIN
   BEGIN
     select 'SI'
       into V_alter
       from user_tab_columns
      where table_name = 'RAPPORTI_CONCORSUALI'
        and column_name = 'CODICE_SIOPE'
     ;
   EXCEPTION WHEN NO_DATA_FOUND THEN  
     V_alter := 'NO';
   END;
   IF V_alter = 'SI' THEN
    v_comando := 'alter table rapporti_concorsuali drop column codice_siope';
    si4.sql_execute(V_comando);
   END IF;
END;
/

-- Modifica campo IMAGE di table IMMAGINI
declare
V_comando   varchar2(500);
V_alter     varchar2(2);
BEGIN
   BEGIN
     select 'SI'
       into V_alter
       from user_tab_columns
      where table_name = 'IMMAGINI'
        and column_name = 'IMAGE'
        and data_type   != 'BLOB'
     ;
   EXCEPTION WHEN NO_DATA_FOUND THEN  
     V_alter := 'NO';
   END;
   IF V_alter = 'SI' THEN
    v_comando := 'rename immagini to imma_ante_A20637';
    si4.sql_execute(V_comando);
    v_comando := ' CREATE TABLE IMMAGINI ' 
               ||' ( SEQUENZA            NUMBER,'
               ||'   IMAGE               BLOB,'
               ||'   DISLOCAZIONE_IMAGE  VARCHAR2(200)'
               ||' )';
    si4.sql_execute(V_comando);
    v_comando := 'insert into immagini ( sequenza, image, DISLOCAZIONE_IMAGE ) '
               ||'select sequenza, to_lob(image), DISLOCAZIONE_IMAGE from imma_ante_A20637';
    si4.sql_execute(V_comando);
   END IF;
END;
/