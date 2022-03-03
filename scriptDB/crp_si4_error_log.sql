CREATE OR REPLACE PACKAGE Si4_Error_Log AS
   type key_error_log_rc is record ( data           date,
                              	     Tipo           varchar2(1),
                              		 Oggetto        varchar2(2000),
                              		 Utente         varchar2(8),
                              		 Message       varchar2(8)
                           		   );
   type kelcurtype is REF CURSOR return key_error_log_rc;
   FUNCTION  VERSIONE         RETURN varchar2;
   FUNCTION  Count           ( SessionFilter in number,
                               ObjectFilter in varchar2,
                        	   UserCodeFilter in varchar2,
                        	   TypeFilter in varchar2
                        	 ) RETURN NUMBER;
   FUNCTION  Count           ( SessionFilter in number,
                              ObjectFilter in varchar2
                        	 ) RETURN NUMBER;
   FUNCTION  Count           ( SessionFilter in number
                        	 ) RETURN NUMBER;
   procedure get_message     ( SessionFilter  in NUMBER,
                               ObjectFilter   in VARCHAR2,
                        	   UserCodeFilter in varchar2,
							   TypeFilter	  in varchar2,
							   DataFilter	  in date,
							   MessageFilter  in varchar2,
                        	   Messages       in out kelcurtype
                             ) ;
   FUNCTION set_message      (   MessageText      in VARCHAR2,
                        	 	 UserCode      in varchar2,
                        		 Object         in varchar2
                             ) RETURN NUMBER;
   FUNCTION set_message      (   MessageText      in VARCHAR2,
                        	 	 Object         in varchar2
                             ) RETURN NUMBER;
   FUNCTION set_error        (   ErrorText      in VARCHAR2,
                        	 	 UserCode      in varchar2,
                        		 UserText      in varchar2
                             ) RETURN NUMBER;
   FUNCTION set_error        (   ErrorText      in VARCHAR2
                             ) RETURN NUMBER;
END Si4_Error_Log;
/
CREATE OR REPLACE PACKAGE BODY Si4_Error_Log AS
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 02/10/2002';
END VERSIONE;
FUNCTION Count( SessionFilter in number, ObjectFilter in varchar2, UserCodeFilter in varchar2, TypeFilter in varchar2)
/******************************************************************************
 NOME:        Count
 DESCRIZIONE: Funzione per determinare il numero di errori presenti in tabella per una determinata sessione, per un
            determinato oggetto, per un determinato utente e per un determinato tipo di errore
 PARAMETRI:   SessionFilter         NUMBER   Numero di Sessione
              ObjectFilter         VARCHAR2 Oggetto
           UserCodeFilter      VARCHAR2 Codice Utente
           TypeFilter         VARCHAR2   Tipo errore
 RITORNA:     NUMBER : Numero di segnalazioni presenti in tabella che rispettano i filtri passati
 ECCEZIONI:   nnnnn, <Descrizione eccezione>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    %DATE%     __     Prima emissione.
******************************************************************************/
 RETURN NUMBER
IS
   d_valore NUMBER;
BEGIN
   select count(*)
       into d_valore
    from key_error_log
    where error_session = nvl(SessionFilter,error_session)
     and error_type    like nvl(TypeFilter,'%')
     and error_user    like nvl(UserCodeFilter,'%')
     and Error_UserText like nvl(ObjectFilter,'%')
     ;
   RETURN d_valore;
EXCEPTION
   WHEN OTHERS THEN
        RAISE;
END Count;
FUNCTION Count( SessionFilter in number, ObjectFilter in varchar2)
/******************************************************************************
 NOME:        Count
 DESCRIZIONE: Funzione per determinare il numero di errori presenti in tabella per una determinata sessione e per un
            determinato oggetto
 PARAMETRI:   SessionFilter         NUMBER   Numero di Sessione
              ObjectFilter         VARCHAR2 Oggetto
 RITORNA:     NUMBER : Numero di segnalazioni presenti in tabella che rispettano i filtri passati
 ECCEZIONI:   nnnnn, <Descrizione eccezione>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    %DATE%     __     Prima emissione.
******************************************************************************/
 RETURN NUMBER
IS
   d_valore NUMBER;
BEGIN
   select count(*)
       into d_valore
    from key_error_log
    where error_session = nvl(SessionFilter,error_session)
     and Error_UserText like nvl(ObjectFilter,'%')
     ;
   RETURN d_valore;
EXCEPTION
   WHEN OTHERS THEN
        RAISE;
END Count;
FUNCTION Count( SessionFilter in number)
/******************************************************************************
 NOME:        Count
 DESCRIZIONE: Funzione per determinare il numero di errori presenti in tabella per una determinata sessione e per un
            determinato oggetto
 PARAMETRI:   SessionFilter         NUMBER   Numero di Sessione
              ObjectFilter         VARCHAR2 Oggetto
 RITORNA:     NUMBER : Numero di segnalazioni presenti in tabella che rispettano i filtri passati
 ECCEZIONI:   nnnnn, <Descrizione eccezione>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    %DATE%     __     Prima emissione.
******************************************************************************/
 RETURN NUMBER
IS
   d_valore NUMBER;
BEGIN
   select count(*)
       into d_valore
    from key_error_log
    where error_session = nvl(SessionFilter,error_session)
     ;
   RETURN d_valore;
EXCEPTION
   WHEN OTHERS THEN
        RAISE;
END Count;
procedure Get_message
/******************************************************************************
 NOME:        Get_message
 DESCRIZIONE: <Descrizione procedure>
 ARGOMENTI:   SessionFilter  IN NUMBER        Numero di sessione,
            ObjectFilter   IN VARCHAR2     Filtro sul valore della colonna Error_UserText
           UserCodeFilter IN VARCHAR2     Filtro sul valore della colonna Error_User
           Messages           IN OUT kelciurtype       Cursore contenente i messaggi che
                                           rispettano i criteri specificati
 ECCEZIONI:   nnnnn, <Descrizione eccezione>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    %DATE% __     Prima emissione.
******************************************************************************/
( 	SessionFilter  in NUMBER,
	ObjectFilter   in VARCHAR2,
	UserCodeFilter in varchar2,
	TypeFilter	   in varchar2,
	DataFilter	   in date,
	MessageFilter  in varchar2,
	Messages       in out kelcurtype
) IS
BEGIN
open Messages for
    select Error_date, Error_type, Error_UserText, Error_User, Error_text
      from key_error_log
     where error_session   =  nvl(SessionFilter,error_session)
       and error_usertext  like  nvl(ObjectFilter,'%')
       and Error_user      like  nvl(UserCodeFilter,'%')
	   and error_text	   like  nvl(MessageFilter,'%')
	   and trunc(error_date) =  trunc(nvl(DataFilter,error_date))
   order by error_date
      ;
END get_message;
FUNCTION Set_error_log
/******************************************************************************
 NOME:        Set_error_log
 DESCRIZIONE: Crea una registrazione nella tabella Key_error_log
 ARGOMENTI:   SessionFilter  IN NUMBER        Numero di sessione,
            ObjectFilter   IN VARCHAR2     Filtro sul valore della colonna Error_UserText
           UserCodeFilter IN VARCHAR2     Filtro sul valore della colonna Error_User
           Messages           IN OUT kelciurtype       Cursore contenente i messaggi che
                                           rispettano i criteri specificati
 ECCEZIONI:   nnnnn, <Descrizione eccezione>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    %DATE% __     Prima emissione.
******************************************************************************/
(   Tipo         in VARCHAR2,
   Testo         in varchar2,
   Utente         in varchar2,
   UtenteTesto      in varchar2
) RETURN NUMBER IS
BEGIN
  insert into key_error_log
  (   Error_session,
     Error_date,
   Error_type,
   Error_text,
   Error_user,
   Error_UserText
  ) values
  ( userenv('sessionid'),
     sysdate,
   Tipo,
   Testo,
   Utente,
   UtenteTesto
  )
  ;
--  commit;
  return 0;
exception when others then
        return -1;
END Set_Error_log;
function set_message
/******************************************************************************
 NOME:        Set_error
 DESCRIZIONE: Crea una registrazione di tipo 'I' (Messaggio) nella tabella Key_error_log
 ARGOMENTI:   Object          IN VARCHAR2     Valore della colonna Error_UserText
           UserCode       IN VARCHAR2     Valore della colonna Error_User
           UserMessage      IN VARCHAR2     Valore della colonna Error_Text
 ECCEZIONI:   nnnnn, <Descrizione eccezione>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    %DATE% __     Prima emissione.
******************************************************************************/
(   MessageText      in VARCHAR2,
   UserCode      in varchar2,
   Object         in varchar2
) return number IS
BEGIN
  return set_error_log('I',MessageText,UserCode,Object);
exception when others then
  return -1;
end set_message;
function set_message
/******************************************************************************
 NOME:        Set_error
 DESCRIZIONE: Crea una registrazione di tipo 'I' (Messaggio) nella tabella Key_error_log
 ARGOMENTI:   Object          IN VARCHAR2     Valore della colonna Error_UserText
           UserCode       IN VARCHAR2     Valore della colonna Error_User
           UserMessage      IN VARCHAR2     Valore della colonna Error_Text
 ECCEZIONI:   nnnnn, <Descrizione eccezione>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    %DATE% __     Prima emissione.
******************************************************************************/
(   MessageText      in VARCHAR2,
   Object         in varchar2
) return number IS
BEGIN
  return set_error_log('I',MessageText,si4.utente,Object);
exception when others then
  return -1;
end set_message;
function set_error
/******************************************************************************
 NOME:        Set_error
 DESCRIZIONE: Crea una registrazione di tipo 'S' (errore) nella tabella Key_error_log
 ARGOMENTI:   Object          IN VARCHAR2     Valore della colonna Error_UserText
           UserCode       IN VARCHAR2     Valore della colonna Error_User
           UserMessage      IN VARCHAR2     Valore della colonna Error_Text
 ECCEZIONI:   nnnnn, <Descrizione eccezione>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    %DATE% __     Prima emissione.
******************************************************************************/
(   ErrorText      in VARCHAR2,
   UserCode      in varchar2,
   UserText      in varchar2
) return number IS
BEGIN
  return set_error_log('S',ErrorText,UserCode,UserText);
exception when others then
  return -1;
end set_error;
function set_error
/******************************************************************************
 NOME:        Set_error
 DESCRIZIONE: Crea una registrazione di tipo 'S' (errore) nella tabella Key_error_log
 ARGOMENTI:   Object          IN VARCHAR2     Valore della colonna Error_UserText
           UserCode       IN VARCHAR2     Valore della colonna Error_User
           UserMessage      IN VARCHAR2     Valore della colonna Error_Text
 ECCEZIONI:   nnnnn, <Descrizione eccezione>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    %DATE% __     Prima emissione.
******************************************************************************/
(   ErrorText      in VARCHAR2
) return number IS
BEGIN
  return set_error_log('S',ErrorText,si4.utente,null);
exception when others then
  return -1;
end set_error;
END Si4_Error_log;
/* End Package Body: Si4_error_log */
/


