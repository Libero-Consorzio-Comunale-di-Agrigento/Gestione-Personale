DECLARE
-- indici su rapporti_retributivi
V_table varchar2(100);
BEGIN
-- indice RARE_ASIN_FK
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RARE_ASIN_FK'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_RETRIBUTIVI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RARE_ASIN_FK');
      si4.sql_execute ( 'CREATE INDEX RARE_ASIN_FK ON RAPPORTI_RETRIBUTIVI( posizione_inail)');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE INDEX RARE_ASIN_FK ON RAPPORTI_RETRIBUTIVI( posizione_inail)');
   END IF;

-- indice RARE_IK
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RARE_IK'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_RETRIBUTIVI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RARE_IK');
      si4.sql_execute ( 'CREATE INDEX RARE_IK ON RAPPORTI_RETRIBUTIVI ( matricola )');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE INDEX RARE_IK ON RAPPORTI_RETRIBUTIVI ( matricola )');
   END IF;

-- indice RARE_ISCR_FK
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RARE_ISCR_FK'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_RETRIBUTIVI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RARE_ISCR_FK');
      si4.sql_execute ( 'CREATE INDEX RARE_ISCR_FK ON RAPPORTI_RETRIBUTIVI( istituto )');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE INDEX RARE_ISCR_FK ON RAPPORTI_RETRIBUTIVI( istituto )');
   END IF;

-- indice RARE_PK
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RARE_PK'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_RETRIBUTIVI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RARE_PK');
      si4.sql_execute ( 'CREATE UNIQUE INDEX RARE_PK ON RAPPORTI_RETRIBUTIVI( ci )');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE UNIQUE INDEX RARE_PK ON RAPPORTI_RETRIBUTIVI( ci )');
   END IF;

-- indice RARE_RARE_FK
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RARE_RARE_FK'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_RETRIBUTIVI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RARE_RARE_FK');
      si4.sql_execute ( 'CREATE INDEX RARE_RARE_FK ON RAPPORTI_RETRIBUTIVI( ci_erede )');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE INDEX RARE_RARE_FK ON RAPPORTI_RETRIBUTIVI( ci_erede )');
   END IF;

-- indice RARE_SPOR_FK
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RARE_SPOR_FK'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_RETRIBUTIVI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RARE_SPOR_FK');
      si4.sql_execute ( 'CREATE INDEX RARE_SPOR_FK ON RAPPORTI_RETRIBUTIVI( istituto , sportello )');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE INDEX RARE_SPOR_FK ON RAPPORTI_RETRIBUTIVI( istituto , sportello )');
   END IF;

-- indice RARE_TRPR_FK
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RARE_TRPR_FK'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_RETRIBUTIVI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RARE_TRPR_FK');
      si4.sql_execute ( 'CREATE INDEX RARE_TRPR_FK ON RAPPORTI_RETRIBUTIVI( trattamento )');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE INDEX RARE_TRPR_FK ON RAPPORTI_RETRIBUTIVI( trattamento )');
   END IF;

END;
/


DECLARE
-- indici su rapporti_retributivi_storici
V_table varchar2(100);
BEGIN
-- indice RARS_ASIN_FK
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RARS_ASIN_FK'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_RETRIBUTIVI_STORICI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RARS_ASIN_FK');
      si4.sql_execute ( 'CREATE INDEX RARS_ASIN_FK ON RAPPORTI_RETRIBUTIVI_STORICI( posizione_inail )');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE INDEX RARS_ASIN_FK ON RAPPORTI_RETRIBUTIVI_STORICI( posizione_inail )');
   END IF;

-- indice RARS_IK
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RARS_IK'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_RETRIBUTIVI_STORICI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RARS_IK');
      si4.sql_execute ( 'CREATE INDEX RARS_IK ON RAPPORTI_RETRIBUTIVI_STORICI ( matricola )');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE INDEX RARS_IK ON RAPPORTI_RETRIBUTIVI_STORICI ( matricola )');
   END IF;

-- indice RARS_ISCR_FK
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RARS_ISCR_FK'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_RETRIBUTIVI_STORICI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RARS_ISCR_FK');
      si4.sql_execute ( 'CREATE INDEX RARS_ISCR_FK ON RAPPORTI_RETRIBUTIVI_STORICI ( istituto )');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE INDEX RARS_ISCR_FK ON RAPPORTI_RETRIBUTIVI_STORICI ( istituto )');
   END IF;

-- indice RARS_PK
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RARS_PK'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_RETRIBUTIVI_STORICI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RARS_PK');
      si4.sql_execute ( 'CREATE UNIQUE INDEX RARS_PK ON RAPPORTI_RETRIBUTIVI_STORICI ( ci, dal )');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE UNIQUE INDEX RARS_PK ON RAPPORTI_RETRIBUTIVI_STORICI ( ci, dal )');
   END IF;

-- indice RARS_RARS_FK
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RARS_RARS_FK'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_RETRIBUTIVI_STORICI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RARS_RARS_FK');
      si4.sql_execute ( 'CREATE INDEX RARS_RARS_FK ON RAPPORTI_RETRIBUTIVI_STORICI ( ci_erede )');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE INDEX RARS_RARS_FK ON RAPPORTI_RETRIBUTIVI_STORICI ( ci_erede )');
   END IF;

-- indice RARS_SPOR_FK
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RARS_SPOR_FK'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_RETRIBUTIVI_STORICI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RARS_SPOR_FK');
      si4.sql_execute ( 'CREATE INDEX RARS_SPOR_FK ON RAPPORTI_RETRIBUTIVI_STORICI ( istituto ,sportello )');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE INDEX RARS_SPOR_FK ON RAPPORTI_RETRIBUTIVI_STORICI ( istituto ,sportello )');
   END IF;

-- indice RARS_TRPR_FK
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RARS_TRPR_FK'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_RETRIBUTIVI_STORICI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RARS_TRPR_FK');
      si4.sql_execute ( 'CREATE INDEX RARS_TRPR_FK ON RAPPORTI_RETRIBUTIVI_STORICI ( trattamento )');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE INDEX RARS_TRPR_FK ON RAPPORTI_RETRIBUTIVI_STORICI ( trattamento )');
   END IF;
END;
/

DECLARE
V_table varchar2(100);
BEGIN
-- indice RAIN_IK2
   BEGIN
    select table_name
      into V_table
      from user_indexes
     where index_name = 'RAIN_IK2'
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
      V_table := 'NO_INDICE';
   END;
   IF V_table not in ( 'RAPPORTI_INDIVIDUALI','NO_INDICE')
   THEN
      si4.sql_execute ( 'drop index RAIN_IK2');
      si4.sql_execute ( 'CREATE INDEX RAIN_IK2 ON RAPPORTI_INDIVIDUALI(FASCICOLO) ');
   ELSIF V_table = 'NO_INDICE'
   THEN
      si4.sql_execute ( 'CREATE INDEX RAIN_IK2 ON RAPPORTI_INDIVIDUALI(FASCICOLO) ');
   END IF;
END;
/
