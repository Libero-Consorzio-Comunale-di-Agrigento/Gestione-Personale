CREATE OR REPLACE PACKAGE CHK_MAIL IS
/******************************************************************************
 NOME:
 DESCRIZIONE:
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/11/2006 GM     Gestisce i passi procedurali per l'elaborazione del CEDOLINO classica o tramite MAIL
 1.1  03/01/2007 GM     Gestione parametro Codice Mensilita
 1.2  31/01/2007 MS     Modifica parametro Codice Mensilita
 1.3  01/03/2007 GM     Nuova gestione Postalizzazione - Notifica Pubblicazione - Allegato alla Mail
 1.4  21/05/2007 GM     Nuova gestione parametro P_INTERNA 
                        (Possibilità di elaborare solo gruppo su carta, solo mail, ecc...)
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN  (prenotazione in number,passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY CHK_MAIL IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.4 del 01/05/2007';
 END VERSIONE;
PROCEDURE MAIN (prenotazione  IN number,passo in number) IS
BEGIN
  DECLARE
    errore            exception;
    p_anno_ela        NUMBER(4);
    p_mese_ela        NUMBER(2); 
    p_mensilita_ela   MENSILITA.CODICE%type;
    p_ente            VARCHAR2(4);
    p_ambiente        VARCHAR2(8);
    p_utente          VARCHAR2(8); 
    p_richiesta       VARCHAR2(1);
    p_ci              NUMBER(8);
    p_gr_ling         VARCHAR2(1);
    p_filtro_1        VARCHAR2(15);
    p_filtro_2        VARCHAR2(15);
    p_filtro_3        VARCHAR2(15);
    p_filtro_4        VARCHAR2(15);
    p_interna         VARCHAR2(1);
    p_ente_elab       ENTE.INVIO_CEDOLINO%type;
    p_ente_tipo_elab  ENTE.PUBBLICAZIONE_CEDOLINO%type;
    ci_richiesti      NUMBER;
    ci_mail           NUMBER;
 errornum          a_errori.errore%type;  
  /* ------------------------------------------- */ 
  /* Inizio estrazione parametri di elaborazione */
  /* ------------------------------------------- */
BEGIN
  BEGIN
    SELECT ENTE     
         , utente   
         , ambiente 
      INTO p_ente,p_utente,p_ambiente
      FROM a_prenotazioni
     WHERE no_prenotazione = prenotazione
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_ente     := NULL;
      p_utente   := NULL;
      p_ambiente := NULL;
  END;  
  BEGIN
    SELECT valore
      INTO p_anno_ela
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro = 'P_ANNO_ELA'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_anno_ela := to_number(null);
  END;
   BEGIN
     SELECT valore
       INTO p_mensilita_ela
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_MENSILITA_ELA'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       p_mensilita_ela := null;
   END;
   BEGIN
     SELECT valore
       INTO p_richiesta
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_RICHIESTA'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       p_richiesta := 'E';
   END;
   BEGIN
     SELECT valore
       INTO p_ci
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_CI'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       p_ci := to_number(null);
   END;
   BEGIN
     SELECT valore
       INTO p_gr_ling
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_GR_LING'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       p_gr_ling := '%';
   END;
   BEGIN
     SELECT valore
       INTO p_filtro_1
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_FILTRO_1'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       p_filtro_1 := '%';
   END;
   BEGIN
     SELECT valore
       INTO p_filtro_2
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_FILTRO_2'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       p_filtro_2 := '%';
   END;
   BEGIN
     SELECT valore
       INTO p_filtro_3
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_FILTRO_3'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       p_filtro_3 := '%';
   END;
   BEGIN
     SELECT valore
       INTO p_filtro_4
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_FILTRO_4'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       p_filtro_4 := '%';
   END;
   BEGIN
     SELECT valore
       INTO p_interna
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_INTERNA'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       p_interna := ' ';
   END;
   BEGIN
     SELECT nvl(invio_cedolino,'P')
       , nvl(pubblicazione_cedolino,0)
       INTO p_ente_elab
       , p_ente_tipo_elab
       FROM ente
      WHERE ente_id = 'ENTE'
     ;   
   EXCEPTION
     when NO_DATA_FOUND then
    p_ente_elab := 'P';
    p_ente_tipo_elab := 0;
   END;
   /* Seleziono Mensilita di riferimento */        
   BEGIN
     SELECT to_number(nvl(p_anno_ela,rire.anno))         
          , to_number(MENS.mese)                                  
          , nvl(p_mensilita_ela,rire.mensilita)
      INTO  p_anno_ela,
            p_mese_ela,
            p_mensilita_ela
      FROM riferimento_retribuzione rire, MENSILITA MENS
     WHERE rire.rire_id                      = 'RIRE'
       AND ( mens.codice  = p_mensilita_ela
             OR mens.mensilita  = rire.mensilita 
       AND mens.mese       = rire.mese
       AND p_mensilita_ela is null
          )            
     ;
   EXCEPTION
     when no_data_found then
    errornum := 'A05721'; 
    raise errore;     
   END;                   
   BEGIN
 select count(rece.ci)        ci_richiesti
      , sum(decode(nvl(p_ente_tipo_elab,0),1,decode(nvl(mail_cedolino,0),1,0,1) -- Invio Tramite MAIL
                   ,decode(nvl(mail_cedolino,0),1,1,0) -- Invio Tramite POSTA
            )
     )                  ci_mail
   into ci_richiesti
      , ci_mail     
   from report_cedolino rece
      , rapporti_individuali  rain
      , anagrafici anag
  where rece.ci           in 
       (select ci from movimenti_fiscali mofi
         where anno      = to_number(p_anno_ela)
           and mese      = p_mese_ela
           and mensilita = p_mensilita_ela
           and (    ci   = p_ci
                or p_ci is null)
           and exists
              (select 'x'
                 from rapporti_giuridici
                where (   flag_elab           = upper(p_richiesta)
                       or upper(p_richiesta) = 'T'
                      )
                  and ci = mofi.ci
              )
       )
    and exists
       (select 'x'
          from rapporti_individuali rain
         where rain.ci = rece.ci
           and (   rain.cc is null
                or exists
                  (select 'x' 
                     from a_competenze 
                     where ente        = p_ente
                       and ambiente    = p_ambiente
                       and utente      = p_utente
                       and competenza  = 'CI'
                       and oggetto     = rain.cc
                  )
               ) 
       )
    and rain.ci      = rece.ci
    and anag.ni      = rain.ni
    and anag.al      is null
    and (  (    anag.gruppo_ling like nvl(upper(p_gr_ling),'%')
            and nvl(instr(upper(rain.note),'LINGUA '),0) = 0)
         or substr(upper(rain.note)
                  ,instr(upper(rain.note),'LINGUA ')+7
                  ,1)           like nvl(upper(p_gr_ling),'%'))
    and rece.anno           = to_number(p_anno_ela)
    and rece.mese           = p_mese_ela
    and nvl(rece.c1,' ') like nvl(upper(p_filtro_1),'%')
    and nvl(rece.c2,' ') like nvl(upper(p_filtro_2),'%')
    and nvl(rece.c3,' ') like nvl(upper(p_filtro_3),'%')
    and nvl(rece.c4,' ') like nvl(upper(p_filtro_4),'%')  
    ;
    IF nvl(ci_richiesti,0) = nvl(ci_mail,0) OR nvl(p_interna,' ') = 'T'  THEN
      update a_prenotazioni 
         set prossimo_passo  = 4
       where no_prenotazione = prenotazione
         and nvl(p_interna,' ') <> 'X'
         and nvl(p_ente_elab,' ') <> 'P'
      ;
      COMMIT;
    END IF;       
   END; 
EXCEPTION
  WHEN errore THEN
    update a_prenotazioni 
    set prossimo_passo = 92
         , errore = errornum
     where no_prenotazione = prenotazione
    ;
 commit;      
END;
END;
END;
/
