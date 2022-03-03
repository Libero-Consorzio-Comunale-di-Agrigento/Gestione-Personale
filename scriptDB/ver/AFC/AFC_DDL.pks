create or replace package AFC_DDL
is

/******************************************************************************
 NOME:        AFC_DDL
 DESCRIZIONE: handling of Definition Schema and Data Definition Manipulation
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore     Descrizione
 ---- ---------- ---------- ------------------------------------------------------
 00   19/04/2005 CZecca     Prima emissione.
 01   14/10/2005 FTassinari aggiunta metodi is_trigger, is_trigger_enabled, is_object_valid
                            is_constraint, is_constraint_enabled
 02   21/10/2005 FTassinari modifica in is_trigger_enabled e is_constraint_enabled (possibile
                            lancio di eccezione 'NO_DATA_FOUND')
 03   25/11/2005 FTassinari aggiunta di is_package
 04   01/02/2006 FTassinari aggiunta di if_procedure e is_function
******************************************************************************/
   
   s_revisione AFC.t_revision := 'V1.04';
   
   function versione
   return varchar2;
   pragma restrict_references( versione, WNDS, WNPS );

   function normalize
   ( p_name in varchar2
   ) return AFC.t_object_name;
   pragma restrict_references( normalize, WNDS );

   function can_handle
   ( p_name in AFC.t_object_name
   ) return number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( can_handle, WNDS );
   
   function CanHandle
   ( p_name in AFC.t_object_name
   ) return boolean;
   pragma restrict_references( CanHandle, WNDS );

   function is_quoted
   ( p_name in AFC.t_object_name
   ) return number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( is_quoted, WNDS );
   
   function IsQuoted
   ( p_name in AFC.t_object_name
   ) return  boolean;
   pragma restrict_references( IsQuoted, WNDS );
   
   function is_user
   ( p_name in AFC.t_object_name
   ) return  number;
   pragma restrict_references( is_user, WNDS );
   
   function IsUser
   ( p_name in AFC.t_object_name
   ) return  boolean;
   pragma restrict_references( IsUser, WNDS ); 
   
   function is_table
   ( p_table_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null   
   ) return  number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( is_table, WNDS );
   
   function IsTable
   ( p_table_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null   
   ) return  boolean;
   pragma restrict_references( IsTable, WNDS );
   
   function is_view
   ( p_view_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null   
   ) return  number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( is_view, WNDS );
   
   function IsView
   ( p_view_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null   
   ) return  boolean;
   pragma restrict_references( IsView, WNDS );
   
   s_PUBLIC constant AFC.t_object_name := 'PUBLIC';   -- pseudo user PUBLIC for synonyms
   
   function is_synonym
   ( p_synonym_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( is_synonym, WNDS );
   
   function IsSynonym
   ( p_synonym_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  boolean;
   pragma restrict_references( IsSynonym, WNDS );
   
   function is_trigger
   ( p_trigger_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( is_trigger, WNDS );

   function IsTrigger
   ( p_trigger_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  boolean;
   pragma restrict_references( IsTrigger, WNDS );

   function is_constraint
   ( p_constraint_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( is_constraint, WNDS );

   function IsConstraint
   ( p_constraint_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  boolean;
   pragma restrict_references( IsConstraint, WNDS );

   function is_package
   ( p_package_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( is_package, WNDS );

   function IsPackage
   ( p_package_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  boolean;
   pragma restrict_references( IsPackage, WNDS );

   function is_procedure
   ( p_procedure_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( is_procedure, WNDS );

   function IsProcedure
   ( p_procedure_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  boolean;
   pragma restrict_references( IsProcedure, WNDS );

   function is_function
   ( p_function_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( is_function, WNDS );

   function IsFunction
   ( p_function_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  boolean;
   pragma restrict_references( IsFunction, WNDS );

   function is_trigger_enabled
   ( p_trigger_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( is_trigger_enabled, WNDS );

   function IsTriggerEnabled
   ( p_trigger_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  boolean;
   pragma restrict_references( IsTriggerEnabled, WNDS );

   function is_constraint_enabled
   ( p_constraint_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( is_constraint_enabled, WNDS );

   function IsConstraintEnabled
   ( p_constraint_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  boolean;
   pragma restrict_references( IsConstraintEnabled, WNDS );

   function is_object_valid
   ( p_object_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( is_object_valid, WNDS );

   function IsObjectValid
   ( p_object_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  boolean;
   pragma restrict_references( is_object_valid, WNDS );

   function has_attribute
   ( p_object_name in AFC.t_object_name
   , p_attribute_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null   
   ) return  number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( has_attribute, WNDS );
   
   function HasAttribute
   ( p_object_name in AFC.t_object_name
   , p_attribute_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null   
   ) return  boolean;
   pragma restrict_references( HasAttribute, WNDS );
   
   function is_nullable
   ( p_object_name in AFC.t_object_name
   , p_attribute_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null
   ) return  number;        -- cannot return boolean due to compatibility with other languages
   pragma restrict_references( is_nullable, WNDS );
   
   function IsNullable
   ( p_object_name in AFC.t_object_name
   , p_attribute_name in AFC.t_object_name
   , p_owner_name in AFC.t_object_name default null   
   ) return  boolean;
   pragma restrict_references( IsNullable, WNDS );

end AFC_DDL;
/
