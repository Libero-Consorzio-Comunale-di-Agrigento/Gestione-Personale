CREATE OR REPLACE PACKAGE PECSMORM IS
/******************************************************************************
 NOME:          PECSMORM INOLTRO MAIL CEDOLINO
 DESCRIZIONE:
      Questa fase si occupa di inoltrare il ceodlino su richiesta dei dipendenti
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI: 
 REVISIONI.
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    29/11/2006 GM     Prima Emissione
 2    06/12/2006 AD     Aggiunto in richiamo URL il parametro P_PORTALE=SI per
                        gestire correttamente il conteggio delle pagine e la
                        inclusione della fincatura (A18720.1) 
 2.1  31/01/2007 MS     Modifica parametro Codice Mensilita
 2.2  01/03/2007 GM     Nuova gestione Postalizzazione - Notifica Pubblicazione - Allegato alla Mail
 2.3  10/05/2007 GM     Aggiunta Function Valida Email
 2.4  21/05/2007 GM     Nuova gestione parametro P_INTERNA 
                        (Possibilità di elaborare solo gruppo su carta, solo mail, ecc...)
      Gestione Errori in fase di elaborazione, Gestione email mittente assente 
 2.5  24/05/2007 GM     Timeout in fase di lancio dell'utl_http
 2.6  26/06/2007 GM     Nuova gestione progressivi errori e commit       
 2.7  26/07/2007 GM     Controllo indirizzi email doppi per NI diversi     
 2.8  08/08/2007 MS     Decodifica del titolo onorifico
 2.9  20/08/2007 GM     Controllo indirizzi email doppi per NI diversi (Riapporto la modifica)
 3.0  07/09/2007 GM     Decodifica Titolo
 3.1  17/10/2007 GM     Gestione Modello Stampe e Controllo Struttura Cedolino Coerente
 3.2  26/10/2007 GM     Modficato il controllo di validità degli indirizzi email
******************************************************************************/
  FUNCTION  VERSIONE                        RETURN VARCHAR2;
  PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
  FUNCTION  clear_html (htmlstring in varchar2) RETURN VARCHAR2;
  FUNCTION  check_email (l_user_name IN VARCHAR2) RETURN NUMBER;
  FUNCTION  check_double_email (p_ni IN NUMBER, p_email IN VARCHAR2) RETURN NUMBER;  
END;
/
CREATE OR REPLACE PACKAGE BODY PECSMORM IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
  BEGIN
    RETURN 'V3.2 del 26/10/2007';
 END VERSIONE;
 
 FUNCTION check_double_email(p_ni IN NUMBER
                           , p_email VARCHAR2
                            ) RETURN NUMBER IS
   d_temp varchar2(1);                            
 BEGIN
   BEGIN
     select 'x'
       into d_temp
       from rapporti_individuali rain            
      where nvl(rain.e_mail,' ') != ' ' 
        and rain.ni != p_ni
        and upper(nvl(rain.e_mail,' ')) = upper(p_email)    
     ;
     raise TOO_MANY_ROWS;    
   EXCEPTION
     when NO_DATA_FOUND then
       RETURN 1;
     when TOO_MANY_ROWS then
       RETURN 0;
   END;
 END;
 
 FUNCTION check_email(l_user_name IN VARCHAR2) RETURN number IS
  l_dot_pos    NUMBER;
  l_at_pos     NUMBER;
  l_str_length NUMBER;
  l_counter    NUMBER(2):=0;
  l_mail_ch    VARCHAR2(1);
  i            NUMBER(2) := 1;
 BEGIN
  if l_user_name is null then
   return 0;
  end if;
  l_dot_pos    := instr(l_user_name
                       ,'.');
  l_at_pos     := instr(l_user_name
                       ,'@');
  l_str_length := length(l_user_name);
  IF ((l_dot_pos = 0) OR         /* non c'e' il . */
      (l_at_pos = 0) OR         /* non c'e' l' @ */
      (l_dot_pos = l_at_pos + 1) OR /* il . è subito dopo l' @ */
      (l_at_pos = 1) OR         /* @ primo carattere */
      (l_at_pos = l_str_length) OR /* @ ultimo carattere */
      (l_dot_pos = l_str_length) or /* . ultimo carattere */
      (l_dot_pos = l_at_pos-1) or   /* . immediatamente prima dell' @ */
      (l_dot_pos=1)              /* . primo carattere */
      )
  THEN
    RETURN 0;
  END IF;
  IF instr(substr(l_user_name
                 ,l_at_pos)
          ,'.') = 0
  THEN
    RETURN 0;
  END IF;  
  -- Controllo che non siano presenti spazi o caratteri speciali
  l_counter := l_str_length;
  WHILE l_counter > 0
    LOOP
   l_mail_ch := substr(l_user_name,i,1);
   i := i+1;
   l_counter := l_counter -1;
   IF l_mail_ch IN (' ','!','#','$','%','^','&','*','(',')','','"','+','|','{','}','[',']',':','>','<','?','/','\','=') THEN
     RETURN 0;
   END IF;
  END LOOP;
  RETURN 1;
 END check_email; 

 FUNCTION decrypt_pwd (pcrypt_pwd in varchar2) return varchar2 is
 BEGIN
 RETURN rtrim(translate( translate(substr(pcrypt_pwd,7,3),chr(7),' ')||
                       translate(substr(pcrypt_pwd,4,3),chr(7),' ')||
                       translate(substr(pcrypt_pwd,1,3),chr(7),' ')||
                       substr(pcrypt_pwd,10)
                      ,chr(1)||'THE'||chr(5)||'qui'||chr(2)||'k1y2'
                      ||chr(4)||'OX3j~'||chr(3)||'p4@V#R5lazY6D%GS7890'
                      ,'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~@#%'
                     ));
 END;
 
 FUNCTION clear_html (htmlstring in varchar2) return varchar2 is
   retval varchar2(4000);
 BEGIN   
   FOR i IN 1..length(htmlstring)-length(REPLACE(htmlstring,'<',''))+1 LOOP
     BEGIN
       SELECT retval||SUBSTR(htmlstring,DECODE(i,1,1,INSTR(htmlstring,'>',1,i-1)+1)
                                                    ,INSTR(htmlstring||'<','<',1,i)-(DECODE(i,1,1,INSTR(htmlstring,'>',1,i-1)+1)))
         INTO retval
         FROM DUAL;
     END;     
   END LOOP;   
   RETURN replace(replace(retval,chr(13),''),chr(10),'');
 END;

 PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
 BEGIN
 DECLARE
   D_ente            VARCHAR2(4);
   D_ambiente        VARCHAR2(8);
   D_utente          VARCHAR2(8);
   D_anno_ela        NUMBER(4);
   D_mensilita_ela   MENSILITA.CODICE%type;
   D_mese_ela        NUMBER(2);
   D_mensilita       VARCHAR2(3); 
   D_desc_mensilita  VARCHAR2(200);
   D_ci              NUMBER(8);
   D_richiesta       VARCHAR2(1);
   D_gr_ling         VARCHAR2(1);
   D_lingua          VARCHAR2(100);
   D_filtro_1        VARCHAR2(15);
   D_filtro_2        VARCHAR2(15);
   D_filtro_3        VARCHAR2(15);
   D_filtro_4        VARCHAR2(15);
   D_fronte_retro    VARCHAR2(100);
   D_interna         VARCHAR2(1);
   D_ente_elab       ENTE.INVIO_CEDOLINO%type; 
   D_vortale         VARCHAR2(2);
   D_modello_stampa  STRUTTURA_MODELLI_STAMPA.CODICE%TYPE;
   D_ret_val         VARCHAR2(1);
   oracle_version    NUMBER;
   W_gruppo_ling     NUMBER;
   /* Parametri inoltro Mail */   
   applserver_name   VARCHAR2(80);
   wdislocazione     VARCHAR2(200);
   reportserver_name VARCHAR2(80) ;
   html_text         VARCHAR2(4000);
   p00_crypt_pwd     VARCHAR2(20);
   p00_decrypt_pwd   VARCHAR2(20);
   cgi_command       VARCHAR2(100);
   p00_user_oracle   VARCHAR2(20);
   nome_report       VARCHAR2(8) := 'PECSMOR6';
   p_dbalias         VARCHAR2(200);
   p_stalias         VARCHAR2(200);
   altri_parametri   VARCHAR2(2000) :=null;
   email_mittente    ENTE.e_mail%type;
   nome_mittente     ENTE.nome%type;
   email_oggetto     ENTE.oggetto_e_mail%type;
   email_corpo       ENTE.corpo_e_mail%type;
   oggetto           ENTE.oggetto_e_mail%type;
   corpo             ENTE.corpo_e_mail%type;
   message_type      varchar2(30);  
   d_err             NUMBER;
   contaerrori       NUMBER := 10000; 
   contasegnalazioni NUMBER := 20000;  
   url_error         VARCHAR2(2000);
   valore            VARCHAR2(200); 
   errore            exception;
   struttura_errata  exception;
   ini_mese          DATE;
   fin_mese          DATE;
   wchiave           VARCHAR2(2000); 
 BEGIN
   BEGIN
     SELECT ENTE     D_ente
          , utente   D_utente
          , ambiente D_ambiente
       INTO D_ente,D_utente,D_ambiente
       FROM a_prenotazioni
      WHERE no_prenotazione = prenotazione
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_ente     := NULL;
       D_utente   := NULL;
       D_ambiente := NULL;
   END;
   BEGIN
     SELECT valore
       INTO D_anno_ela
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_ANNO_ELA'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_anno_ela := to_number(null);
   END;
   BEGIN
     SELECT valore
       INTO D_mensilita_ela
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_MENSILITA_ELA'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_mensilita_ela := to_char(null);
   END;
   BEGIN
     SELECT valore
       INTO D_ci
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_CI'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_ci := to_number(null);
   END;
   BEGIN
     SELECT valore
       INTO D_richiesta
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_RICHIESTA'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_richiesta := 'E';
   END;
   BEGIN
     SELECT valore
       INTO D_gr_ling
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_GR_LING'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_gr_ling := '%';
   END;
   BEGIN
     SELECT valore
       INTO D_filtro_1
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_FILTRO_1'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_filtro_1 := '%';
   END;
   BEGIN
     SELECT valore
       INTO D_filtro_2
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_FILTRO_2'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_filtro_2 := '%';
   END;
   BEGIN
     SELECT valore
       INTO D_filtro_3
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_FILTRO_3'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_filtro_3 := '%';
   END;
   BEGIN
     SELECT valore
       INTO D_filtro_4
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_FILTRO_4'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_filtro_4 := '%';
   END;
   BEGIN
     SELECT valore
       INTO D_interna
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_INTERNA'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_interna := ' ';
   END;  
   BEGIN
     select valore
       into D_lingua
       from a_parametri
      where no_prenotazione = prenotazione
        and parametro = 'P_LINGUA'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_lingua := 'I';
   END;
   BEGIN
     SELECT sequenza
       INTO w_gruppo_ling
       FROM gruppi_linguistici
      WHERE gruppo = decode(D_lingua,'*','I',upper(D_lingua))
        AND gruppo_al = D_gr_ling
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN
       w_gruppo_ling := 1;
   END;
   BEGIN
     select valore
       into D_fronte_retro
       from a_parametri
      where no_prenotazione = prenotazione
        and parametro = 'P_FRONTE_RETRO'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       BEGIN
         select 'SI'
           into D_fronte_retro
           from a_stampanti
          where stampante = (select valore
                               from a_parametri
                              where no_prenotazione = prenotazione
                                and parametro = 'P_STAMPANTE'
                    )
            and instr(upper(ubicazione),'[F/R]') > 0
      ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_fronte_retro := null;
     END;
   END;
   BEGIN
     SELECT valore
       INTO D_modello_stampa
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro = 'P_MODELLO_STAMPA'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_modello_stampa := 'CEDOLINO';
   END;   
   /* Seleziono il tipo di pubblicazione (invio_cedolino), l'indirizzo e-mail del Mittente ed il Nome del Mittente */
   BEGIN
     select nome
          , e_mail 
          , oggetto_e_mail
          , corpo_e_mail  
          , invio_cedolino  
       into nome_mittente
          , email_mittente
          , email_oggetto
          , email_corpo
          , D_ente_elab
       from ente
      where ente_id = 'ENTE'
     ;
   EXCEPTION
     when NO_DATA_FOUND then
       nome_mittente  := 'Modulo P00'; 
       email_mittente := null;
       email_oggetto  := '';
       email_corpo    := '';
       D_ente_elab    := 'P';    
   END;
   /* Seleziono il NOME DELLA MACCHINA */
   BEGIN   
     select nvl(userenv('terminal'),SYS_CONTEXT('USERENV','IP_ADDRESS'))
       into applserver_name 
       from dual
  ;
   EXCEPTION
     when others then
    null;
   END;
   /* Seleziono PASSWORD, REPORTSERVERNAME e USER_ORACLE */
   BEGIN
     select password
          , 'Rep60'||stampante
          , user_ORACLE
      into  p00_crypt_pwd
          , reportserver_name
          , p00_user_oracle
       from a_istanze_ambiente
      where ambiente = D_ambiente
        and ente = D_ente
         ;
   EXCEPTION 
     when others then 
       null;
   END;   
   /* Controllo se è presente il Vortale */
   BEGIN   
     select 'SI'
       into D_vortale
       from user_tab_privs 
      where table_name = 'GP4WEB_SS' 
        and grantor = user
     ;
     raise too_many_rows; 
   EXCEPTION
     when no_data_found then
       D_vortale := 'NO';
     when too_many_rows then
       D_vortale := 'SI';  
   END;   
   /* Estraggo i parametri dalle chiavi di registro */
   BEGIN
     si4_registro_utility.leggi_stringa('DB_USERS/'||p00_user_oracle,'Working Directory',wdislocazione);
     wdislocazione := replace(wdislocazione,':','%3a');
   EXCEPTION when others then
     null;
   END;
   BEGIN
     si4_registro_utility.leggi_stringa('DB_USERS/'||p00_user_oracle,'Stampe Directory',p_stalias);
   EXCEPTION when others then
     p_stalias := 'sta_P00';
   END;
   BEGIN
     si4_registro_utility.leggi_stringa('DB_USERS/'||p00_user_oracle,'Alias Database',p_dbalias);
   EXCEPTION when others then
     p_dbalias := 'SI4';
   END;   
   BEGIN
     si4_registro_utility.leggi_stringa('DB_USERS/'||p00_user_oracle,'Tipo Invio Mail',message_type);
   EXCEPTION when others then
     message_type := 'mail';
   END;     
   /* Seleziono Mensilita di riferimento */        
   BEGIN
     SELECT to_number(nvl(D_anno_ela,rire.anno))         
          , to_number(MENS.mese)                                  
          , nvl(D_mensilita_ela,rire.mensilita) 
          , nvl(mens.mensilita,rire.mensilita)
          , mens.descrizione                                           
      INTO  D_anno_ela,
            D_mese_ela,
            D_mensilita_ela,
            D_mensilita,
            D_desc_mensilita
      FROM riferimento_retribuzione rire, MENSILITA MENS
     WHERE rire.rire_id                      = 'RIRE'
       AND ( MENS.CODICE  = D_mensilita_ela
      or mens.mensilita = rire.mensilita and 
         mens.mese      = rire.mese      and 
           D_mensilita_ela is null
          )            
     ;
   END;
   BEGIN  
     /* Controllo Definzione Struttura Cedolino */
     BEGIN
       select 'x' 
         into D_ret_val
         from dual
        where exists (select riga 
                        from struttura_modelli_stampa 
                       where tipo_riga  = 'I' 
                         and codice = D_MODELLO_STAMPA)
          and exists (select riga 
                        from struttura_modelli_stampa 
                       where tipo_riga  = 'C' 
                         and codice = D_MODELLO_STAMPA)
          and exists (select riga 
                        from struttura_modelli_stampa 
                       where tipo_riga  = 'P' 
                         and codice = D_MODELLO_STAMPA) 
       ;
     EXCEPTION
       when NO_DATA_FOUND then
         raise struttura_errata;                  
     END;
     ini_mese  := to_date( '01/'||lpad(TO_CHAR(D_mese_ela),2,0)||'/'||TO_CHAR(D_anno_ela),'dd/mm/yyyy');
     fin_mese  := last_day(to_date( '01/'||lpad(TO_CHAR(D_mese_ela),2,0)||'/'||TO_CHAR(D_anno_ela),'dd/mm/yyyy'));   
     contaerrori := 10000;
     p00_decrypt_pwd := decrypt_pwd(p00_crypt_pwd);
     IF wdislocazione like '/%' then
       cgi_command := 'rwcgi60';
     ELSE
       cgi_command := 'rwcgi60.exe';
     END IF;
     /* Cursore che estrae gli individui */
     FOR CUR_CI IN 
     (select rece.ci                                              ci
           , rain.ni                                              ni
           , decode(tipe.titolo,NULL,decode(anag.sesso,'M','Sig.','Sig.ra')
                               ,tipe.titolo)                      titolo  
           , anag.nome                                            nome
           , anag.cognome                                         cognome 
           , anag.cognome ||' '||anag.nome                        nominativo 
           , rain.e_mail                                          email
           , decode( nvl(instr(upper(rain.note),'LINGUA '),0)
                                               , 0, anag.gruppo_ling 
                                               , substr( upper(rain.note)
                                               , instr(upper(rain.note),'LINGUA ')+7
                                               , 1)
                                     )                            gr_ling_dip
       from report_cedolino rece
          , rapporti_individuali  rain
          , titoli_personali tipe
          , anagrafici anag
          , ente
      where rece.ci           in 
            (select ci from movimenti_fiscali mofi
              where anno      = to_number(D_anno_ela)
                and mese      = D_mese_ela
                and mensilita = D_mensilita
                and (    ci   = D_ci
                     or D_ci is null)
                and exists
                    (select 'x'
                       from rapporti_giuridici
                      where (   flag_elab           = upper(D_richiesta)
                             or upper(D_richiesta) = 'T'
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
                        where ente        = D_ente
                          and ambiente    = D_ambiente
                          and utente      = D_utente
                          and competenza  = 'CI'
                          and oggetto     = rain.cc
                      )
                   ) 
           )
        and rain.ci      = rece.ci
        and anag.ni      = rain.ni
        and anag.al      is null
        and (  (    anag.gruppo_ling like nvl(upper(D_gr_ling),'%')
                and nvl(instr(upper(rain.note),'LINGUA '),0) = 0)
                 or substr(upper(rain.note)
                    ,instr(upper(rain.note),'LINGUA ')+7
                    ,1)           like nvl(upper(D_gr_ling),'%'))
        and rece.anno            = to_number(D_anno_ela)
        and rece.mese            = D_mese_ela
        and ente_id              = 'ENTE'
        and nvl(rece.c1,' ') like nvl(upper(D_filtro_1),'%')
        and nvl(rece.c2,' ') like nvl(upper(D_filtro_2),'%')
        and nvl(rece.c3,' ') like nvl(upper(D_filtro_3),'%')
        and nvl(rece.c4,' ') like nvl(upper(D_filtro_4),'%')
        and nvl(mail_cedolino,0) = decode(ente.pubblicazione_cedolino,1,0,1)                                              
        and nvl(D_interna,' ')  <> 'P'
        and nvl(D_ente_elab,'P') <> 'P' 
        and anag.titolo   = tipe.sequenza (+)
      order by rece.s1,rece.c1,
               rece.s2,rece.c2,
               rece.s3,rece.c3,
               rece.s4,rece.c4,
               rece.s5,rece.c5,
               rece.s6,rece.c6,rece.ci
     ) LOOP
         BEGIN
           /* Verifico Assunti o Dimessi nell'arco del mese di Elaborazione */
           contasegnalazioni := contasegnalazioni +1; 
           BEGIN
             insert 
               into a_segnalazioni_errore 
                                   ( NO_PRENOTAZIONE,
                                     PASSO,
                                     PROGRESSIVO,
                                     ERRORE,
                                     PRECISAZIONE
                                   )         
             (select prenotazione
                   , passo
                   , contasegnalazioni
                   , 'P00108'
                   , 'Cod.Ind.: '|| CUR_CI.ci || ' Assunto o Dimesso nel mese in stampa'
               from dual
              where exists (select ci 
                              from periodi_giuridici 
                             where ci = CUR_CI.ci
                               and rilevanza = 'P' 
                               and (dal between ini_mese and fin_mese 
                                or nvl(al,to_date('3333333','j')) between ini_mese and fin_mese
                                   )
                           )
             );           
           END;
           contasegnalazioni := contasegnalazioni +1;         
           /* Verifico Assenti per tutto il mese di Elaborazione */
           BEGIN
             insert 
               into a_segnalazioni_errore 
                                   ( NO_PRENOTAZIONE,
                                     PASSO,
                                     PROGRESSIVO,
                                     ERRORE,
                                     PRECISAZIONE
                                   )       
            (select prenotazione
                  , passo
                  , contasegnalazioni
                  , 'P00108'
                  , 'Cod.Ind.: '|| CUR_CI.ci || ' Assente per tutto il mese in stampa' 
               from dual
              where exists (select max(ci)
                              from periodi_giuridici pegi
                             where ci = CUR_CI.ci
                               and rilevanza = 'A'
                               and nvl(pegi.al,to_date('3333333','j')) >= ini_mese
                               and pegi.dal <= fin_mese
                            having sum(least(nvl(pegi.al,to_date('3333333','j')),fin_mese) - greatest(pegi.dal,ini_mese) + 1) = (fin_mese - ini_mese + 1)
                           )
            );       
           END;
           contasegnalazioni := contasegnalazioni +1;
           /* Controllo che non esista un altro individuo NI con lo stesso indirizzo email */
           IF check_double_email(CUR_CI.ni,CUR_CI.email) <> 1 and nvl(D_interna,'X') = 'X' then
             insert 
               into a_segnalazioni_errore
                    ( NO_PRENOTAZIONE,
                      PASSO,
                      PROGRESSIVO,
                      ERRORE,
                      PRECISAZIONE
                    )
             values ( prenotazione,
                      passo,
                      contasegnalazioni,
                      'P00108',
                      'Cod.Ind.: '||CUR_CI.ci ||'  Esiste individuo con lo stesso indirizzo email: '||substr(CUR_CI.email,1,100)||'.'
                    );   
           END IF;
           contasegnalazioni := contasegnalazioni +1;       
           /* L'inoltro effettivo viene effettuato solo nei casi previsti dal parametro (X) */
           IF nvl(D_interna,'X') != 'X' then
             oggetto := email_oggetto;
             corpo   := email_corpo;          
             /* aggiunto parametro P_PORTALE=SI */                 
             altri_parametri := '+P_MODELLO_STAMPA='||D_modello_stampa||'+P_PORTALE=SI+P_TIPO_DESFORMAT=PDF+VOCE_MENU=PECSMOR6+PRENOTAZIONE='||to_char(prenotazione)||'+PASSO='||passo||'+P_FRONTE_RETRO='||D_fronte_retro;
             /* Setto TimeOut per Oracle9 */ 
             BEGIN
               select to_number(substr(substr(banner, instr(upper(banner), 'RELEASE') +8),1,instr(substr(banner, instr(upper(banner), 'RELEASE') +8),'.')-1))
                 into oracle_version
                 from v$version
                where upper(banner) like '%ORACLE%'
               ;
             EXCEPTION 
               when others then
                 oracle_version := 8;
             END;      
             IF oracle_version > 8 then
               si4.sql_execute(' begin utl_http.set_transfer_timeout(300); end;');
             END IF;  
             html_text := utl_http.request('http://'||applserver_name||'/dev60cgi/'||cgi_command||'?server='||reportserver_name||'+report='||wdislocazione||'report/'||nome_report||'.rep+commmode=SYNCHRONOUS+batch=YES+background=no+destype=FILE+desformat=PDF+mode=bitmap+desname='||wdislocazione||'sta/CED'||CUR_CI.ci||D_anno_ela||D_mese_ela||D_mensilita_ela||prenotazione||'.pdf+userid='||p00_user_oracle||'/'||p00_decrypt_pwd ||'@'||p_dbalias||'+P_CI='||CUR_CI.ci||'+P_ANNO_ELA='||D_anno_ela||'+P_MENSILITA_ELA='||D_mensilita_ela||'+P_RICHIESTA=T+P_LINGUA='||D_lingua||'+P_ENTE='||D_ente||'+P_AMBIENTE='||D_ambiente||'+P_UTENTE='||D_utente||altri_parametri);
             /* Controllo che l'elaborazione del cedolino via url non abbia restituto errori */
             IF instr(html_text,'Error') != 0 then      /* errore in attivazione dell'url */
               url_error := SUBSTR(html_text,instr(html_text,'</H1>')+7);
               url_error := clear_html(url_error);
               contaerrori := contaerrori +1;
               insert 
                 into a_segnalazioni_errore
                      ( NO_PRENOTAZIONE,
                        PASSO,
                        PROGRESSIVO,
                        ERRORE,
                        PRECISAZIONE
                      )
               values ( prenotazione,
                        passo,
                        contaerrori,
                        'P05809',
                        'Cod.Ind.: '||CUR_CI.ci ||' '||url_error
                      );
               raise errore;  
             END IF;
             /* controllo che per il CI sia stato indicato in rapporti_individuali un indirizzo email */ 
             IF nvl(CUR_CI.email,' ') = ' ' then 
               contaerrori := contaerrori +1;
               insert 
                 into a_segnalazioni_errore
                      ( NO_PRENOTAZIONE,
                        PASSO,
                        PROGRESSIVO,
                        ERRORE,
                        PRECISAZIONE
                      )
               values ( prenotazione,
                        passo,
                        contaerrori,
                        'P05809',
                        'Cod.Ind.: '||CUR_CI.ci ||' Non è stato indicato alcun indirizzo email. CEDOLINO NON INVIATO!'
                      );   
               raise errore;
             END IF;
             /* Controllo che per il CI sia stato indicato un indirizzo email valido */
             IF check_email(CUR_CI.email) <> 1 then
               contaerrori := contaerrori +1;
               insert 
                 into a_segnalazioni_errore
                      ( NO_PRENOTAZIONE,
                        PASSO,
                        PROGRESSIVO,
                        ERRORE,
                        PRECISAZIONE
                      )
               values ( prenotazione,
                        passo,
                        contaerrori,
                        'P05809',
                        'Cod.Ind.: '||CUR_CI.ci ||' Non è stato indicato un indirizzo email valido. CEDOLINO NON INVIATO!'
                      );   
               raise errore;
             END IF; 
             /* Controllo che non esista un altro individuo NI con lo stesso indirizzo email */
             IF check_double_email(CUR_CI.ni,CUR_CI.email) <> 1 then
               contaerrori := contaerrori +1;
               insert 
                 into a_segnalazioni_errore
                      ( NO_PRENOTAZIONE,
                        PASSO,
                        PROGRESSIVO,
                        ERRORE,
                        PRECISAZIONE
                      )
               values ( prenotazione,
                        passo,
                        contaerrori,
                        'P05809',
                        'Cod.Ind.: '||CUR_CI.ci ||'  Esiste individuo con lo stesso indirizzo email: '||substr(CUR_CI.email,1,100)||'. CEDOLINO NON INVIATO!'
                      );   
               raise errore;
             END IF;          
             IF D_ente_elab = 'N' THEN
               /* PUBBLICAZIONE CEDOLINO SU VORTALE ED INOLTRO NOTIFICA*/  
               BEGIN
                 select chiave   /* CONTROLLO PREVENTIVO ESISTENZA DI UN RECORD PER IL CI IN ELABORAZIONE */
                   into wchiave
                   from repository_documenti
                  where ci = CUR_CI.ci
                    and tipo_documento = 'CEDOLINO'
                 ;
                 update repository_documenti /* SE ESISTE GIA' UNA REGISTRAZIONE PER IL CI AGGIORNO L'INDICAZIONE DI ANNO E MENSILITA */
                    set chiave = 'ANNO='||D_anno_ela||'#MENSILITA='||D_mensilita_ela||'#ORIGINE=GP4'
                      , notificato = decode(wchiave, 'ANNO='||D_anno_ela||'#MENSILITA='||D_mensilita_ela||'#ORIGINE=GP4','Y','N')
                  where CI= Cur_ci.ci
                    and tipo_documento = 'CEDOLINO'
                 ;
                 COMMIT;
               EXCEPTION 
                 when NO_DATA_FOUND then 
                 /* NON ESISTE PER QUEL CI UNA REGISTRAZIONE: LA INSERISCO SENZA CAMPO BLOB */
                 insert 
                   into repository_documenti (CI
                                            , TIPO_DOCUMENTO
                                            , DOCUMENTO
                                            , CHIAVE)
                                      VALUES (CUR_CI.ci
                                            , 'CEDOLINO'
                                            , empty_blob
                                            , 'ANNO='||D_anno_ela||'#MENSILITA='||D_mensilita_ela||'#ORIGINE=GP4')
                 ;
                 COMMIT;
               END;
               BEGIN
                 /* richiamo della java store procedure per scarico sul campo blob di una tabella temporanea*/
                 copy_default('http://'||applserver_name||'/' || p_stalias || '/CED'||CUR_CI.ci||D_anno_ela||D_mese_ela||D_mensilita_ela||prenotazione||'.pdf',
                              'REPOSITORY_DOCUMENTI',
                              'DOCUMENTO',
                              'where ci='||CUR_CI.ci||' and tipo_documento=''CEDOLINO'''
                             );
                 COMMIT;
               EXCEPTION
                 when others then
                   contaerrori := contaerrori +1;
                   insert 
                     into a_segnalazioni_errore
                          ( NO_PRENOTAZIONE,
                            PASSO,
                            PROGRESSIVO,
                            ERRORE,
                            PRECISAZIONE
                          )
                   values ( prenotazione,
                            passo,
                            contaerrori,
                            'P05809',
                            'Cod.Ind.: '||CUR_CI.ci ||' Si sono verificati errori durante la copia sul campo blob. NOTIFICA NON INVIATA!'
                          );    
                   raise errore;
               END;    
             END IF;
             IF NOT (D_ente_elab = 'N' AND D_vortale = 'SI') THEN
               /* INOLTRO CEDOLINO IN ALLEGATO */      
               /* DECODIFICA OGGETTO */  
               BEGIN
                 WHILE instr(oggetto,'<') > 0 LOOP
                     valore := substr(oggetto,instr(oggetto,'<'),instr(oggetto,'>')-instr(oggetto,'<')+1);
                  if    valore = '<anag.cognome>' then
                    oggetto := replace(oggetto,'<anag.cognome>',CUR_CI.cognome);
                  elsif valore = '<anag.nome>' then
                    oggetto := replace(oggetto,'<anag.ome>',CUR_CI.nome);       
                  elsif valore = '<anag.titolo>' then
                    oggetto := replace(oggetto,'<anag.titolo>',CUR_CI.titolo);       
                  elsif valore = '<anno>' then
                    oggetto := replace(oggetto,'<anno>',D_anno_ela);
                  elsif valore = '<mens.descrizione>' then
                    oggetto := replace(oggetto,'<mens.descrizione>',D_desc_mensilita);
                  elsif valore = '<nominativo>' then
                    oggetto := replace(oggetto,'<nominativo>',CUR_CI.nominativo);
                  elsif valore = '<rain.ci>' then 
                    oggetto := replace(oggetto,'<rain.ci>',CUR_CI.ci);
                  end if;        
                  END LOOP;
               END;
               /* DECODIFICA CORPO */
               BEGIN
                  WHILE instr(corpo,'<') > 0 LOOP
                     valore := substr(corpo,instr(corpo,'<'),instr(corpo,'>')-instr(corpo,'<')+1);
                  if    valore = '<anag.cognome>' then
                    corpo := replace(corpo,'<anag.cognome>',CUR_CI.cognome);
                  elsif valore = '<anag.nome>' then
                    corpo := replace(corpo,'<anag.nome>',CUR_CI.nome);       
                  elsif valore = '<anag.titolo>' then
                    corpo := replace(corpo,'<anag.titolo>',CUR_CI.titolo);       
                  elsif valore = '<anno>' then
                    corpo := replace(corpo,'<anno>',D_anno_ela);
                  elsif valore = '<mens.descrizione>' then
                    corpo := replace(corpo,'<mens.descrizione>',D_desc_mensilita);
                  elsif valore = '<nominativo>' then
                    corpo := replace(corpo,'<nominativo>',CUR_CI.nominativo);
                  elsif valore = '<rain.ci>' then 
                    corpo := replace(corpo,'<rain.ci>',CUR_CI.ci);
                  end if;     
                  END LOOP;
               END;  
               BEGIN    
                 /*-----------------------------------------------------
                    Inizio Inoltro MAIL
                    Inizializza il CIM con il tipo di messaggio da
                    inviare.
                 -----------------------------------------------------*/
                 d_err := ad4_si4cim.initializemessage (message_type); 
                 /*-----------------------------------------------------
                            Inizializza il Mittente.
                 -----------------------------------------------------*/
                 ad4_si4cim.setsender ( senderip                      => ''
                                      , sendername                    => '::'||D_UTENTE
                                      , ID                            => ''
                                      , NAME                          => nome_mittente
                                      , company                       => ''
                                      , address                       => ''
                                      , code                          => ''
                                      , city                          => ''
                                      , province                      => ''
                                      , state                         => ''
                                      , email                         => nvl(email_mittente,CUR_CI.email)
                                      , phonenumber                   => ''
                                      , faxnumber                     => ''
                                      );
                 /*-----------------------------------------------------
                            Inizializza il Destinatario.
                 -----------------------------------------------------*/            
                 ad4_si4cim.addrecipient ( ID                            => ''
                                         , NAME                          => D_utente
                                         , company                       => ''
                                         , address                       => ''
                                         , code                          => ''
                                         , city                          => ''
                                         , province                      => ''
                                         , state                         => ''
                                         , email                         => CUR_CI.email
                                         , phonenumber                   => ''
                                         , faxnumber                     => ''
                                         ); 
                 /*-----------------------------------------------------
                          Predispone l'oggetto del messaggio.
                 -----------------------------------------------------*/
                 ad4_si4cim.setsubject (oggetto);
                 /*-----------------------------------------------------
                          Predispone il testo del messaggio.
                 -----------------------------------------------------*/
                 ad4_si4cim.settext (corpo);
                 IF D_ente_elab = 'A' THEN   
                   /*-----------------------------------------------------
                                   Predispone l'allegato.
                    -----------------------------------------------------*/
                    ad4_si4cim.addAttachment( URLSTR     => 'http://'||applserver_name||'/'||p_stalias ||'/CED'||CUR_CI.ci||D_anno_ela||D_mese_ela||D_mensilita_ela||prenotazione||'.pdf'
                                            , FILENAME   => 'CED'||CUR_CI.ci||D_anno_ela||D_mese_ela||D_mensilita_ela||prenotazione||'.pdf'
                                            );
                 END IF;                  
                 d_err := ad4_si4cim.send;
               EXCEPTION
                 when others then
                        contaerrori := contaerrori +1;
                        insert 
                          into a_segnalazioni_errore
                               ( NO_PRENOTAZIONE,
                                 PASSO,
                                 PROGRESSIVO,
                                 ERRORE,
                                 PRECISAZIONE
                               )
                        values ( prenotazione,
                                 passo,
                                 contaerrori,
                                 'P05809',
                                 'Cod.Ind.: '||CUR_CI.ci ||' Si sono verificati errori durante l''inoltro mail. CEDOLINO NON INVIATO!'
                               );    
                        raise errore;
               END;
             END IF;
           END IF;  
         EXCEPTION
           when errore then
             null;  
         END;
       END LOOP CUR_CI;
       /* Resetto il campo Contatore Inail */
       BEGIN
         update a_selezioni
         set valore_default = to_char(null)
                   where parametro = 'P_PRG_CEDOLINO'
                     and voce_menu = 'PECSCER6'
                     and sequenza  = 0
         ;  
       END;        
     END;
 EXCEPTION
   WHEN struttura_errata then
     update a_prenotazioni 
        set prossimo_passo = 92
          , errore = 'P00610'
      where no_prenotazione = prenotazione
     ; 
 END;
 COMMIT;
END;
END;
/
