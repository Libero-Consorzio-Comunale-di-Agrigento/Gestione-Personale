CREATE OR REPLACE VIEW SIA_DIFFERENZA_INDICI
( UTENTE, TABLE_NAME,INDEX_NAME ) AS 
(select substr(user,1,20) utente,table_name, index_name  
from user_indexes  
minus  
select  substr(user,1,20),table_name, index_name 
from sia_default_indici  
)  
UNION ALL  
(select 'DEFAULT', table_name, index_name
from sia_default_indici  
minus  
select 'DEFAULT', table_name, index_name
from user_indexes )
/

CREATE OR REPLACE VIEW SIA_DIFF_INDICI_UNIQUE
( UTENTE, TABLE_NAME, INDEX_NAME, UNIQUENESS ) 
AS 
select substr(user,1,20) utente
     , table_name
     , index_name
     , uniqueness
  from user_indexes x
 where exists ( select 'x'
                  from sia_default_indici
                 where index_name = x.index_name
                   and table_name = x.table_name
                   and nvl(uniqueness,'X') != nvl(x.uniqueness,'Y')
              )
UNION ALL  
select 'DEFAULT'
     , table_name
     , index_name
     , uniqueness
 from sia_default_indici x
 where exists ( select 'x'
                  from user_indexes
                 where index_name = x.index_name
                   and table_name = x.table_name
                   and nvl(uniqueness,'X') != nvl(x.uniqueness,'Y')
              )
/

CREATE OR REPLACE VIEW SIA_DIFFERENZA_COL_INDICI
( UTENTE, TABLE_NAME,INDEX_NAME, COLUMN_NAME, COLUMN_POSITION ) 
AS 
(select substr(user,1,20) utente
      , table_name
      , index_name
      , column_name
      , column_position
from user_ind_columns
minus  
select  substr(user,1,20)
      , table_name
      , index_name name
      , column_name
      , column_position
from sia_default_indici_col
)  
UNION ALL  
(select  'DEFAULT' 
      , table_name
      , index_name name
      , column_name
      , column_position
from sia_default_indici_col
minus  
select 'DEFAULT'
      , table_name
      , index_name
      , column_name
      , column_position
from user_ind_columns
)
/
