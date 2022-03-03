create or replace package AFC_ut is
/******************************************************************************
 NOME:        ut_AFC.
 DESCRIZIONE: objects definition for ut packages.

 ANNOTAZIONI: .

 REVISIONI: .
 <CODE>
 Rev.  Data        Autore      Descrizione.
 00    26/08/2005  FTASSINARI  Prima emissione.
 01    19/01/2006  FTASSINARI  aggiunta metodi ExistsTable, save_query_XML,
                               ins_table_XML, del_save_table
 02    24/10/2006  FTASSINARI  Aggiunta di throws, eq, isNotNull, isNull e test

 </CODE>
******************************************************************************/

   s_revisione constant VARCHAR2(30) := 'V1.02';

   -- Public constant declarations
   s_key_char constant varchar2(1) := '-';
   s_key_1    constant varchar2(2) := s_key_char || '1';
   s_key_2    constant varchar2(2) := s_key_char || '2';
   s_key_3    constant varchar2(2) := s_key_char || '3';
   s_key_4    constant varchar2(2) := s_key_char || '4';
   s_key_5    constant varchar2(2) := s_key_char || '5';

   function ExistsTable
   return boolean;
   pragma restrict_references( ExistsTable, WNDS );

   function get_save
   ( p_key in varchar2
   ) return CLOB;
   pragma restrict_references( get_save, WNDS );

   procedure set_save
   ( p_key in varchar2
   , p_clob in CLOB
   );

   procedure save_query_XML
   ( p_table_name IN varchar2
   , p_where_condition IN varchar2 default null
   , p_key IN varchar2
   );

   procedure ins_table_XML
   ( p_table_name IN varchar2
   , p_key IN varchar2
   );

   procedure del_save_table
   ( p_key IN varchar2
   );

   -- wrapper di utAssert.throws; exception by name
   procedure throws
   ( p_msg_in varchar2
   , p_check_call_in in varchar2
   , p_against_exc_in in varchar2
   );

   -- wrapper di utAssert.throws; exception by sqlcode
   procedure throws
   ( p_msg_in varchar2
   , p_check_call_in in varchar2
   , p_against_exc_in in number
   );

   -- wrapper di utAssert.eq; per varchar2 e number
   procedure eq
   ( p_msg_in in varchar2
   , p_check_this_in in varchar2
   , p_against_this_in in varchar2
   );

   -- wrapper di utAssert.eq; per date
   procedure eq
   ( p_msg_in in varchar2
   , p_check_this_in in date
   , p_against_this_in in date
   );

   -- wrapper di utAssert.eq; per boolean
   procedure eq
   ( p_msg_in in varchar2
   , p_check_this_in in boolean
   , p_against_this_in in boolean
   );

   -- wrapper di utAssert.isNotNull; per varchar2 e number
   procedure isNotNull
   ( p_msg_in in varchar2
   , p_check_this_in in varchar2
   );

   -- wrapper di utAssert.isNotNull; per boolean
   procedure isNotNull
   ( p_msg_in in varchar2
   , p_check_this_in in boolean
   );

   -- wrapper di utAssert.isNull; per varchar2 e number
   procedure isNull
   ( p_msg_in in varchar2
   , p_check_this_in in varchar2
   );

   -- wrapper di utAssert.isNull; per boolean
   procedure isNull
   ( p_msg_in in varchar2
   , p_check_this_in in boolean
   );

   -- wrapper di utPlsql.test
   procedure test
   ( p_package_in in varchar2
   );

end AFC_ut;
/
