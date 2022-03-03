CREATE OR REPLACE PROCEDURE PSAVE_SI4_ACCESSO ( p_utente varchar2, p_note_utente varchar2
                             , p_modulo varchar2, p_note_modulo varchar2
                             , p_istanza varchar2, p_note_istanza varchar2
                             , p_note_accesso varchar2
                             , p_ente varchar2, p_note_ente varchar2
                             , p_progetto varchar2, p_note_progetto varchar2
                             , p_ambiente varchar2) IS
/******************************************************************************
   NAME:       PSAVE_SI4_ACCESSO
   PURPOSE:    To calculate the desired information.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        09/07/01             1. Created this procedure.

   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:
   CALLED BY:
   CALLS:
   EXAMPLE USE:     PSAVE_SI4_ACCESSO;
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:
******************************************************************************/
BEGIN
   si4.SET_ACCESSO_UTENTE ( p_utente , p_note_utente 
                             , p_modulo , p_note_modulo 
                             , p_istanza , p_note_istanza 
                             , p_note_accesso 
                             , p_ente , p_note_ente 
                             , p_progetto , p_note_progetto 
                             , p_ambiente );
   EXCEPTION
     WHEN OTHERS THEN
       Null;
END PSAVE_SI4_ACCESSO;
/ 

