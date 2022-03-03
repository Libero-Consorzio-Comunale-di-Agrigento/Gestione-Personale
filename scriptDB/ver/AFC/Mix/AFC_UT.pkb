create or replace package body AFC_UT is
/******************************************************************************
 NOME:        AFC_UT.
 DESCRIZIONE: objects definition for ut packages.

 ANNOTAZIONI: .

 REVISIONI: .
 <CODE>
 Rev.  Data        Autore      Descrizione.
 000   11/01/2006  FTASSINARI  Prima emissione.
 001   24/10/2006  FTASSINARI  Aggiunta di throws, eq, isNotNull, isNull e test
 </CODE>
******************************************************************************/

   s_revisione_body constant VARCHAR2(30) := '001';

------------------------------------------------------------------------------------

   function versione return VARCHAR2 is
   /******************************************************************************
    NOME:        versione.
    DESCRIZIONE: Restituisce versione e revisione di distribuzione del package.

    RITORNA:     VARCHAR2 stringa contenente versione e revisione.
    NOTE:        Primo numero  : versione compatibilità del Package.
                 Secondo numero: revisione del Package specification.
                 Terzo numero  : revisione del Package body.
   ******************************************************************************/
   begin
      return s_revisione||'.'||s_revisione_body;
   end versione;

------------------------------------------------------------------------------------

   function ExistsTable
   return boolean
   /******************************************************************************
    NOME:        ExistsTable.
    DESCRIZIONE: controlla se sull'utente su cui si lavora esiste la table ut_save_table.

    PARAMETRI:   -

    RITORNA:     BOOLEAN TRUE se ut_save_table esiste, FALSE altrimenti

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   10/01/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
   is
      d_found number;
      d_result boolean;
   begin

      begin
         select 1
         into d_found
         from user_tables
         where table_name = 'UT_SAVE_TABLE';
      exception
         when no_data_found then
            d_found := 0;
      end;

      if d_found = 1
      then
         d_result := true;
      else
         d_result := false;
      end if;

      DbC.POST( not DbC.PostOn or ( d_result or not d_result ), 'd_result or not d_result on AFC_UT.ExistsTable' );

      return d_result;

   end ExistsTable;

------------------------------------------------------------------------------------

   procedure create_table
   /******************************************************************************
    NOME:        create_table.
    DESCRIZIONE: crea sul DB la table ut_save_table.

    PARAMETRI:   -

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   10/01/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
   is
      d_statement AFC.t_statement;
   begin

      DbC.PRE( not DbC.PreOn or ExistsTable, 'ExistsTable on AFC_UT.create_table' );

      d_statement := 'create table ut_save_table( table_name varchar2(30) not null'
                  || '                          , table_content CLOB'
                  || '                          , constraint UT_SAVE_TABLE_PK primary key (table_name)'
                  || '                          )';

      SI4.SQL_EXECUTE( d_statement );

      DbC.POST( not DbC.PostOn or ExistsTable, 'ExistsTable on AFC_UT.create_table' );

   end create_table;

------------------------------------------------------------------------------------

   function get_save
   ( p_key in varchar2
   ) return CLOB
   /******************************************************************************
    NOME:        get_save.
    DESCRIZIONE: ritorna la table in formato XML relativa alla chiave passata come parametro.

    PARAMETRI:   p_key IN varchar2 chiave utilizzata nella table ut_save_table.

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   10/01/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
   is
      d_result CLOB;
   begin

      DbC.PRE( not DbC.PreOn or ExistsTable , 'ExistsTable on AFC_UT.get_save' );

      select table_content
      into d_result
      from ut_save_table
      where table_name = p_key;

      DbC.POST( not DbC.PostOn or d_result is not null, 'd_result is not null on AFC_UT.get_save' );
      DbC.POST( not DbC.PostOn or ExistsTable , 'ExistsTable on AFC_UT.get_save' );

      return d_result;

   end get_save;

------------------------------------------------------------------------------------

   procedure set_save
   ( p_key in varchar2
   , p_clob in CLOB
   ) is
   /******************************************************************************
    NOME:        set_save.
    DESCRIZIONE: salva in ut_save_table il clob passato come parametro, con la chiave p_key.

    PARAMETRI:   p_key IN varchar2 nome della chiave utilizzata nella table ut_save_table.
                 p_clob IN CLOB query in formato XML da salvare

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   10/01/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
   begin

      if not ExistsTable
      then
         DbC.ASSERTION( not DbC.AssertionOn or not ExistsTable , 'not ExistsTable on AFC_UT.set_save' );

         create_table;

         DbC.ASSERTION( not DbC.AssertionOn or ExistsTable , 'ExistsTable on AFC_UT.set_save' );
      end if;

      DbC.ASSERTION( not DbC.AssertionOn or ExistsTable , 'ExistsTable on AFC_UT.set_save' );

      insert into ut_save_table
      ( table_name
      , table_content
      ) values
      ( p_key
      , p_clob
      );

   end set_save;

------------------------------------------------------------------------------------

   procedure save_query_XML
   ( p_table_name IN varchar2
   , p_where_condition IN varchar2 default null
   , p_key IN varchar2
   ) is
   /******************************************************************************
    NOME:        save_query_XML.
    DESCRIZIONE: salva il contenuto di una table in formato XML nella table ut_save_table.

    PARAMETRI:   p_table_name IN varchar2 nome della tabella da salvare.
                 p_where_condition IN varchar2 condizione di where per la query
                 p_key IN varchar2 nome della chiave utilizzata nella table ut_save_table

    ECCEZIONI:   -

    NOTE:        la condizione di where (che è facoltativa) deve essere passata omettendo
                 la key word 'where'

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   10/01/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
      d_statement AFC.t_statement := 'select * from ';
      d_clob CLOB;
   begin

      d_statement := d_statement || p_table_name;

      if p_where_condition is not null
      then
         d_statement := d_statement || ' where ' || p_where_condition;
      end if;

      d_clob := xmlgen.getXML( query => d_statement );

      DbC.ASSERTION( not DbC.AssertionOn or ExistsTable , 'ExistsTable on AFC_UT.save_query_XML' );

      set_save( p_key
              , d_clob
              );

   end save_query_XML;

------------------------------------------------------------------------------------

   procedure ins_table_XML
   ( p_table_name IN varchar2
   , p_key IN varchar2
   ) is
   /******************************************************************************
    NOME:        ins_table_XML.
    DESCRIZIONE: ripristina il contenuto di una table in formato XML nella table
                 ut_save_table.

    PARAMETRI:   p_table_name IN varchar2 nome della tabella da salvare.
                 p_key IN varchar2 onme della chiave utilizzata nella table ut_save_table

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   10/01/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
      d_clob CLOB;
      rows number;
   begin

      DbC.PRE( not DbC.PreOn or ExistsTable , 'ExistsTable on AFC_UT.ins_table_XML' );

      d_clob := get_save( p_key );

      rows := xmlgen.insertXML( tablename => p_table_name
                              , xmldoc => d_clob
                              );

   end ins_table_XML;

------------------------------------------------------------------------------------

   procedure del_save_table
   ( p_key varchar2
   ) is
   /******************************************************************************
    NOME:        del_save_table.
    DESCRIZIONE: eliminare la registrazione relativa a p_key nella table ut_save_table.

    PARAMETRI:   p_key IN varchar2 nome della chiave utilizzata nella table ut_save_table.

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   10/01/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
   begin

      DbC.PRE( not DbC.PreOn or ExistsTable , 'ExistsTable on AFC_UT.del_save_table' );

      delete from ut_save_table
      where table_name = p_key;

   end del_save_table;

------------------------------------------------------------------------------------

   -- wrapper di utAssert.throws; exception by name
   procedure throws
   ( p_msg_in varchar2
   , p_check_call_in in varchar2
   , p_against_exc_in in varchar2
   ) is
   /******************************************************************************
    NOME:        throws.
    DESCRIZIONE: Versione wrapper di utAssert.throws; visualizza anche il SQLERRM.
                 Controlla Exception name

    PARAMETRI:   p_msg_in varchar2 messaggio da visualizzare.
                 p_check_call_in IN varchar2 istruzione da eseguire
                 p_against_exc_in IN varchar2 exception che mi aspetto

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   24/10/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
      d_statement AFC.t_statement;
      d_SQLCODE AFC_Error.t_error_number;
      d_SQLERRM AFC_Error.t_error_msg;
   begin
      d_statement := ' begin '
                  || '    ' || p_check_call_in
                  || ' exception '
                  || '    when ' || p_against_exc_in || ' then '
                  || '       :d_SQLCODE := AFC_Error.ok; '
                  || '       :d_SQLERRM := SQLERRM; '
                  || '    when others then '
                  || '       :d_SQLCODE := SQLCODE; '
                  || '       :d_SQLERRM := SQLERRM; '
                  || ' end; ';

      execute immediate d_statement using out d_SQLCODE, out d_SQLERRM;

      if d_SQLCODE = AFC_Error.ok
      then
         utAssert.eq( msg_in => p_msg_in || ' ' || d_SQLERRM
                    , check_this_in => p_against_exc_in
                    , against_this_in => p_against_exc_in
                    );
      else
         utAssert.eq( msg_in => p_msg_in || ' ' || d_SQLERRM
                    , check_this_in => d_SQLCODE
                    , against_this_in => p_against_exc_in
                    );
      end if;
   end throws;

------------------------------------------------------------------------------------

   -- wrapper di utAssert.throws; exception by sqlcode
   procedure throws
   ( p_msg_in varchar2
   , p_check_call_in in varchar2
   , p_against_exc_in in number
   ) is
   /******************************************************************************
    NOME:        throws.
    DESCRIZIONE: Versione wrapper di utAssert.throws; visualizza anche il SQLERRM.
                 Controlla error code

    PARAMETRI:   p_msg_in varchar2 messaggio da visualizzare.
                 p_check_call_in IN varchar2 istruzione da eseguire
                 p_against_exc_in IN varchar2 exception che mi aspetto

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   24/10/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
   begin
      AFC.SQL_Execute( p_check_call_in );
      utAssert.eq( msg_in => p_msg_in || ' ' || SQLERRM
                 , check_this_in => 0
                 , against_this_in => p_against_exc_in
                 );
   exception
      when others then
         utAssert.eq( msg_in => p_msg_in || ' ' || SQLERRM
                    , check_this_in => SQLCODE
                    , against_this_in => p_against_exc_in
                    );
   end throws;

------------------------------------------------------------------------------------

   -- wrapper di utAssert.eq; per varchar2 e number
   procedure eq
   ( p_msg_in in varchar2
   , p_check_this_in in varchar2
   , p_against_this_in in varchar2
   ) is
   /******************************************************************************
    NOME:        eq.
    DESCRIZIONE: Versione wrapper di utAssert.eq. Controlla valori varchar2 e number

    PARAMETRI:   p_msg_in varchar2 messaggio da visualizzare.
                 p_check_this_in IN valore da controllare
                 p_against_this_in IN varchar2 valore che mi aspetto di trovare

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   24/10/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
   begin
      utAssert.eq( msg_in => p_msg_in
                 , check_this_in => p_check_this_in
                 , against_this_in => p_against_this_in
                 );
   end eq;

------------------------------------------------------------------------------------

   -- wrapper di utAssert.eq; per date
   procedure eq
   ( p_msg_in in varchar2
   , p_check_this_in in date
   , p_against_this_in in date
   ) is
   /******************************************************************************
    NOME:        eq.
    DESCRIZIONE: Versione wrapper di utAssert.eq. Controlla valori date

    PARAMETRI:   p_msg_in varchar2 messaggio da visualizzare.
                 p_check_this_in IN valore da controllare
                 p_against_this_in IN varchar2 valore che mi aspetto di trovare

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   24/10/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
   begin
      utAssert.eq( msg_in => p_msg_in
                 , check_this_in => p_check_this_in
                 , against_this_in => p_against_this_in
                 );
   end eq;

------------------------------------------------------------------------------------

   -- wrapper di utAssert.eq; per boolean
   procedure eq
   ( p_msg_in in varchar2
   , p_check_this_in in boolean
   , p_against_this_in in boolean
   ) is
   /******************************************************************************
    NOME:        eq.
    DESCRIZIONE: Versione wrapper di utAssert.eq. Controlla valori boolean

    PARAMETRI:   p_msg_in varchar2 messaggio da visualizzare.
                 p_check_this_in IN valore da controllare
                 p_against_this_in IN varchar2 valore che mi aspetto di trovare

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   24/10/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
   begin
      utAssert.eq( msg_in => p_msg_in
                 , check_this_in => p_check_this_in
                 , against_this_in => p_against_this_in
                 );
   end eq;

------------------------------------------------------------------------------------

   -- wrapper di utAssert.isNotNull; per varchar2 e number
   procedure isNotNull
   ( p_msg_in          in   varchar2
   , p_check_this_in   in   varchar2
   ) is
   /******************************************************************************
    NOME:        isNotNull.
    DESCRIZIONE: Versione wrapper di utAssert.isnotnull. Controlla valori varchar2 e number

    PARAMETRI:   p_msg_in varchar2 messaggio da visualizzare.
                 p_check_this_in IN valore da controllare
                 p_against_this_in IN varchar2 valore che mi aspetto di trovare

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   24/10/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
   begin
      utAssert.isnotnull( msg_in => p_msg_in
                        , check_this_in => p_check_this_in
                        );
   end isnotnull;

------------------------------------------------------------------------------------

   -- wrapper di utAssert.isNotNull; per boolean
   procedure isNotNull
   ( p_msg_in          in   varchar2
   , p_check_this_in   in   boolean
   ) is
   /******************************************************************************
    NOME:        isNotNull.
    DESCRIZIONE: Versione wrapper di utAssert.isnotnull. Controlla valori boolean

    PARAMETRI:   p_msg_in varchar2 messaggio da visualizzare.
                 p_check_this_in IN valore da controllare

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   24/10/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
   begin
      utAssert.isnotnull( msg_in => p_msg_in
                        , check_this_in => p_check_this_in
                        );
   end isnotnull;

------------------------------------------------------------------------------------

   -- wrapper di utAssert.isNull; per varchar2 e number
   procedure isnull
   ( p_msg_in          in   varchar2
   , p_check_this_in   in   varchar2
   ) is
   /******************************************************************************
    NOME:        isNull.
    DESCRIZIONE: Versione wrapper di utAssert.isnull. Controlla valori varchar2 e number

    PARAMETRI:   p_msg_in varchar2 messaggio da visualizzare.
                 p_check_this_in IN valore da controllare

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   24/10/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
   begin
      utAssert.isnull( msg_in => p_msg_in
                     , check_this_in => p_check_this_in
                     );
   end isnull;

------------------------------------------------------------------------------------

   -- wrapper di utAssert.isNull; per boolean
   procedure isnull
   ( p_msg_in          in   varchar2
   , p_check_this_in   in   boolean
   ) is
   /******************************************************************************
    NOME:        isNull.
    DESCRIZIONE: Versione wrapper di utAssert.isnull. Controlla valori boolean

    PARAMETRI:   p_msg_in varchar2 messaggio da visualizzare.
                 p_check_this_in IN valore da controllare

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   24/10/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
   begin
      utAssert.isnull( msg_in => p_msg_in
                     , check_this_in => p_check_this_in
                     );
   end isnull;

------------------------------------------------------------------------------------

   -- wrapper di utPlsql.test
   procedure test
   ( p_package_in          in varchar2
   ) is
   /******************************************************************************
    NOME:        test.
    DESCRIZIONE: Versione wrapper di utAssert.test.

    PARAMETRI:   p_package_in varchar2 nome del test da eseguire.

    ECCEZIONI:   -

    REVISIONI:
    Rev. Data         Autore      Descrizione
    ---- -----------  ----------  ------------------------------------------------------
    000   24/10/2006  FTASSINARI  Prima emissione.
   ******************************************************************************/
   begin
      utPlsql.test( package_in => p_package_in
                  , recompile_in => FALSE
                  );
   end test;

------------------------------------------------------------------------------------

end AFC_UT;
/
