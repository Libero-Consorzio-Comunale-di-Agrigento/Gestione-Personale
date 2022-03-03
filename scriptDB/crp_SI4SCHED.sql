CREATE OR REPLACE PACKAGE SI4SCHED IS
    PROCEDURE SUBMIT_PREN (pno_prenotazione in number
	   	  		  					,pappserver_name in varchar2
	   	  		  					,palias_db in varchar2
									,p_dislocazione in varchar2
									,p_lingua_istanza in varchar2
									,p_applicazione in varchar2);
	PROCEDURE ELAB_PREN (pno_prenotazione in number
	   	  		  					,pappserver_name in varchar2
	   	  		  					,palias_db in varchar2
									,p_dislocazione in varchar2
									,p_lingua_istanza in varchar2
									,p_applicazione in varchar2);
	function get_appserver_name return varchar2;
END  SI4SCHED; 
/

CREATE OR REPLACE PACKAGE BODY SI4SCHED IS
FUNCTION clear_html (htmlstring in varchar2) return varchar2 is
     retval varchar2(4000) := htmlstring;
     to_replace   varchar2(100);
BEGIN
  while instr(retval,'<') != 0 loop
   to_replace := substr(retval,instr(retval,'<'),instr(retval,'>',instr(retval,'<'))-instr(retval,'<')+1);
   retval := replace(retval,to_replace,null);
  end loop;
  RETURN replace(replace(retval,chr(13),' '),chr(10),' ');
END;
PROCEDURE SUBMIT_PREN (pno_prenotazione in number
                   ,pappserver_name in varchar2
                        ,palias_db in varchar2
                 ,p_dislocazione in varchar2
                 ,p_lingua_istanza in varchar2
                 ,p_applicazione in varchar2) IS
JOBNO NUMBER;
BEGIN
     DBMS_job.submit( jobno ,
                      'begin si4sched.ELAB_PREN('||pno_prenotazione||','''||lower(pappserver_name)||''','''||palias_db||''','''||p_dislocazione||''','''||p_lingua_istanza||''','''||P_APPLICAZIONE||'''); end;',
                       sysdate,
                       null,
                       false,
                       0,
                       true
                      );
     commit;
END;
PROCEDURE ELAB_PREN (pno_prenotazione in number
               ,pappserver_name in varchar2
               ,palias_db in varchar2
               ,p_dislocazione in varchar2
               ,p_lingua_istanza in varchar2
               ,p_applicazione in varchar2) IS
   p_step         number := 1;
   p_sequenza     number := 1;
   v_lancio       varchar2(32767) := null;
   v_parte        varchar2(32767) := null;
   v_a00_prn      varchar2(200) := P_DISLOCAZIONE;
   v_a00_log      varchar2(200) := P_DISLOCAZIONE;
   v_a00_tmp      varchar2(200) := P_DISLOCAZIONE;
   v_a00_dis      varchar2(80);
   v_nome_prn     varchar2(200);
   v_modulo       a_passi_proc.modulo%TYPE;
   tipost         a_passi_proc.tipo%TYPE;
   v_gr_lin       a_passi_proc.gruppo_ling%TYPE;
   v_cod_st       a_passi_proc.stampa%TYPE;
   v_stampa       number;
   v_appoggio     varchar2(1);
   prefix         a_passi_proc.voce_menu%TYPE;
   st_sta         a_catalogo_stampe.stampa_bloccata%TYPE;
   sequen         a_catalogo_stampe.sequenziale%TYPE;
   v_data         date;
   w_valore       varchar2(240);
   sql_errm       varchar2(512);
   taglio_stringa number;
   wambiente      varchar2(10);
   cgi_command    varchar2(50);
   p_progetto     varchar2(8);
   p_ambiente     a_prenotazioni.ambiente%type;
   p_ente         a_prenotazioni.ente%type;
   p_gruppo_ling  a_prenotazioni.gruppo_ling%type;
   p_utente       a_prenotazioni.utente%type;
   p_voce_menu    a_prenotazioni.utente%type;
   unsupported_type    exception;
   oracle_version number;
   program_abort  exception;
   DIR_SEP        VARCHAR2(1);
   repsrv_name    varchar2(2000);
   url_error      varchar2(4000);
   html_text      varchar2(4000);
   w_user_oracle  a_istanze_ambiente.user_oracle%type;
   w_password     a_istanze_ambiente.password%type;
   s_alfabeto     varchar2(32000) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~@#%'||
                                     'abcdefghijklmnopqrstuvwxyz';
   /* chiave per translate */
   s_chiave       varchar2(32000) :=  chr(1)||'THE'||chr(5)||'qui'||chr(2)||'k1y2'||chr(4)||'OX3j~'||chr(3)||'p4@V#R5lazY6D%GS7890'||
                                      chr(11)||'the'||chr(15)||'QUI'||chr(12)||'K'||chr(16)||'d'||chr(17)||chr(14)||'ox'||chr(18)||'J'||chr(20)||chr(13)||'P'||chr(19)||chr(21)||'v'||chr(22)||'r';
BEGIN
-- CICLO MAIN
   begin
         select ambiente, ente,  ambiente, utente, gruppo_ling, voce_menu
        into p_ambiente, p_ente,  wambiente, p_utente, p_gruppo_ling, p_voce_menu
        from a_prenotazioni
       where no_prenotazione = pno_prenotazione
       ;
   end;
   taglio_stringa := length(p_ambiente||p_ente||p_lingua_istanza);
   if taglio_stringa > 10 then
        wambiente := substr(wambiente,1,length(wambiente)-taglio_stringa+10);
   end if;
   begin
     select 'Rep60'||stampante, user_oracle,  rtrim(translate( translate(substr(password,7,3),chr(7),' ')||
                      translate(substr(password,4,3),chr(7),' ')||
                      translate(substr(password,1,3),chr(7),' ')||
                      substr(password,10)
                     ,s_chiave
                     ,s_alfabeto
                    ))
        into repsrv_name, w_user_oracle, w_password
       from a_istanze_ambiente
       where ente = p_ente
         and ambiente = p_ambiente
         and gruppo_ling = p_lingua_istanza
         ;
   exception when others then
          repsrv_name := null;
   end;
   begin
   select progetto
     into p_progetto
     from ad4_istanze
    where istanza = wambiente||p_ente||p_lingua_istanza
   ;
   exception when others then
      p_progetto := null;
   end;
begin
  select substr(dislocazione_client,2)
    into v_a00_dis
    from a_istanze_ambiente
   where ambiente = p_ambiente
     and ente     = p_ente
     and gruppo_ling = p_lingua_istanza
      ;
exception when no_data_found then
   v_a00_dis := null;
end;
IF P_DISLOCAZIONE LIKE '/%' THEN /* INTERFACCIA UNIX */
   DIR_SEP := '/';
   cgi_command := 'rwcgi60';
ELSE
   DIR_SEP := '\';
   cgi_command := 'rwcgi60.exe';
END IF;
if  v_a00_dis is not null then
   v_a00_dis := v_a00_dis ||dir_sep;
end if;
v_a00_prn := P_DISLOCAZIONE||'sta'||DIR_SEP;
v_a00_log := P_DISLOCAZIONE||'log'||DIR_SEP;
v_a00_tmp := P_DISLOCAZIONE||'tmp'||DIR_SEP;
v_a00_prn := replace(replace(v_a00_prn,'sta'||DIR_SEP,'sta'||DIR_SEP||v_a00_dis),':','%3a');
v_a00_log := replace(replace(v_a00_log,'log'||DIR_SEP,'log'||DIR_SEP||v_a00_dis),':','%3a');
v_a00_tmp := replace(replace(v_a00_log,'tmp'||DIR_SEP,'tmp'||DIR_SEP||v_a00_dis),':','%3a');
begin
/*   Creazione righe per log */
   insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
    values (pno_prenotazione,p_sequenza,'Log della prenotazione '||to_char(pno_prenotazione));
   p_sequenza := p_sequenza +1;
   commit;
   if p_gruppo_ling='*' then
      p_gruppo_ling := '@';
   end if;
   select 'X'
      into v_appoggio
      from a_prenotazioni
    where no_prenotazione = pno_prenotazione;
exception when no_data_found then
   sql_errm := substr(sqlerrm,1,512);
   raise program_abort;
end;
begin
si4.SET_ACCESSO_UTENTE (    p_utente
                  ,    null /* Note Utente */
                  ,    p_applicazione
                  ,    null /* Note Modulo */
                  ,    wambiente||p_ente||p_lingua_istanza
                  ,    null /* Note Istanza */
                  ,    'DIFFERITA'    /* Note accesso */
                        ,    p_ente
                        ,    null      /* Note ente */
                  ,    p_progetto
                  ,    null    /* Note progetto */
                  ,    p_ambiente
                  );
exception when others then
   begin
      if sqlerrm like 'ORA-04062%' then      /* nel caso in cui il parametro remote_dependencies_mode sia TIMESTAMP */
         execute immediate 'ALTER SESSION SET remote_dependencies_mode = ''signature'' ';    /* uso questa perchè ovviamente       */
                                                                                                                           /* non posso usare si4.sql_execute   */
      end if;
      si4.SET_ACCESSO_UTENTE (    p_utente
                  ,    null /* Note Utente */
                  ,    p_applicazione
                  ,    null /* Note Modulo */
                  ,    wambiente||p_ente||p_lingua_istanza
                  ,    null /* Note Istanza */
                  ,    'DIFFERITA'    /* Note accesso */
                        ,    p_ente
                        ,    null      /* Note ente */
                  ,    p_progetto
                  ,    null    /* Note progetto */
                  ,    p_ambiente
                  );      exception when others then
         sql_errm := substr(sqlerrm,1,512);
         raise;
   end;
end;
begin
      select to_number(substr(substr(banner, instr(upper(banner), 'RELEASE') +8),1,instr(substr(banner, instr(upper(banner), 'RELEASE') +8),'.')-1))
       into oracle_version
       from v$version
      where upper(banner) like '%ORACLE%'
      ;
   exception when others then
      oracle_version := 8;
   end;      
   if oracle_version > 8 then    /* solo dalla versione 9 c'e' la possibilita' di impostare un timeout */
      si4.sql_execute(' begin utl_http.set_transfer_timeout(86400); end;');
   end if;  
LOOP
 BEGIN
  select nvl(nvl(p.modulo_pers,a.modulo),a.stringa),
         a.tipo,
         nvl(decode(a.gruppo_ling,'Y','I',p_gruppo_ling),p_gruppo_ling), /* uso la lingua della prenotazione */
         decode(nvl(p.stampa_pers,a.stampa),null,'~',nvl(p.stampa_pers,a.stampa)),
--         decode(a.tipo,'R',n_stampa.nextval,null),    /* uso la sequence solo se e una stampa! */
         substr(a.voce_menu,1,3),
         decode(nvl(b.stampa_bloccata,'N'),'Y','B','P'),
         b.sequenziale
    into v_modulo,
         tipost,
         v_gr_lin,
         v_cod_st,
  --       v_stampa,
         prefix,
         st_sta,
         sequen
    from a_personalizzazioni p, a_catalogo_stampe b, a_passi_proc a
   where b.stampa (+) = nvl(a.stampa,'X') and
         a.voce_menu  =  p_voce_menu and
         a.passo     =  p_step and
         p.voce_menu (+) =  p_voce_menu and
         p.modulo_standard (+) = a.modulo and
         rownum=1;
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
        sql_errm := substr(sqlerrm,1,512);
        RAISE NO_DATA_FOUND;
   WHEN OTHERS THEN
     sql_errm := substr(sqlerrm,1,512);
     insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
     values (pno_prenotazione,p_sequenza,'Error Reading A_PASSI_PROC and the sequence A_STAMPA: '||sql_errm);
     p_sequenza := p_sequenza +1;
     commit;
      RAISE PROGRAM_ABORT;
  END;
  if v_modulo = '#' then
   raise unsupported_type;
  end if;
-- modifica lingua
 BEGIN
  update a_parametri
     set valore=decode(v_gr_lin,'@','I',v_gr_lin)
   where no_prenotazione=pno_prenotazione
     and parametro='P_LINGUA'
    ;
  IF SQL%NOTFOUND THEN
   insert into a_parametri (no_prenotazione, parametro, valore, sequenza)
   values (pno_prenotazione,'P_LINGUA',decode(v_gr_lin,'@','I',v_gr_lin),0);
  END IF;
  commit;
  EXCEPTION
   WHEN OTHERS THEN
/* Creazione righe per log */
      sql_errm := substr(sqlerrm,1,512);
     insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
     values (pno_prenotazione,p_sequenza,'Error WRITING A_PARAMETRI: '||sql_errm);
     p_sequenza := p_sequenza +1;
     commit;
      RAISE PROGRAM_ABORT;
   END;
-- aggiornamento passo in esecuzione
 BEGIN
 update a_prenotazioni
    set numero_passo=p_step, prossimo_passo='',stato ='E'
  where no_prenotazione = pno_prenotazione;
 commit;
   EXCEPTION
   WHEN OTHERS THEN
/*    Creazione righe per log */
      sql_errm := substr(sqlerrm,1,512);
     insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
     values (pno_prenotazione,p_sequenza,'Error updating A_PRENOTAZIONI: '||sql_errm);
       p_sequenza := p_sequenza +1;
     commit;
      RAISE PROGRAM_ABORT;
  END;
/* CONTROLLO SUL TIPO DI PROCEDURA */
 IF tipost = 'R' THEN
  -- REPORT
  select sysdate,n_stampa.nextval
   into v_data,v_stampa
   from dual;
  if v_cod_st!= '~' then
      v_nome_prn:= v_a00_prn || prefix ||to_char(v_stampa) || '.lis';
   end if;
     /*   Inserimento righe per log */
     insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
     values (pno_prenotazione,p_sequenza,'Step '||to_char(p_step)||' Report: '||v_modulo);
       p_sequenza := p_sequenza +1;
        insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
     values (pno_prenotazione,p_sequenza,'Start at '||to_char(v_data,'dd/mm/yyyy hh24:mi.ss'));
       p_sequenza := p_sequenza +1;
  FOR par in (select parametro,valore from a_parametri where no_prenotazione = pno_prenotazione)
  LOOP
   if instr(par.valore,' ') > 0 then
         w_valore := ''''||replace(par.valore,'''','''''') ||'''' ;
   else
         w_valore :=  replace(par.valore,'''','''''') ;
   end if;
   v_lancio := v_lancio ||'+'|| par.parametro  ||'='|| w_valore;
  END LOOP;
  v_lancio:=replace(v_lancio,'%','%25');
  BEGIN
-- Modifica per gestire i nuovi Report in formato PDF
   if upper(v_modulo) != 'SI4V3WAS' then
      select classe
       into v_parte
      from a_catalogo_stampe
      where stampa = v_cod_st
      ;
   else
      v_parte := 'WAS';
   end if;
   begin
   select valore
     into v_parte
     from a_parametri para, a_passi_proc proc
    where para.parametro = 'P_TIPO_DESFORMAT'
      and para.no_prenotazione = pno_prenotazione
      and proc.voce_menu = p_voce_menu
      and proc.passo = p_step
      and proc.stringa='P_TIPO_DESFORMAT';
   exception when others then
   null;
   end;
 IF v_parte in ('PDF','HTML','RTF','XLS','CSV','XML') THEN
      v_nome_prn := replace(v_nome_prn,'.lis','.'||LOWER(v_parte));
      if v_parte = 'XLS' then
        v_parte:='DELIMITEDDATA+DELIMITER=tab';
      elsif v_parte = 'CSV' then
         v_parte:='DELIMITEDDATA+DELIMITER=;';
      end if;
    v_parte := '+MODE=Default+DESFORMAT='||v_parte;
 ELSIF v_parte in ('TXT','WAS') THEN         /* uso un prt diverso per eliminare i salti pagina ed i return*/
   v_parte :='+MODE=Character+DESFORMAT=ASCIINEW';
 ELSE
    v_parte :='+MODE=Character+DESFORMAT=ASCII';
 END IF;
 v_lancio := v_lancio || v_parte;
  EXCEPTION
   WHEN OTHERS THEN
   /*  Inserimento righe di log */
     sql_errm := substr(sqlerrm,1,512);
       insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
     values (pno_prenotazione,p_sequenza,'Stampa non codificata: '||sql_errm);
       p_sequenza := p_sequenza +1;
     commit;
      RAISE PROGRAM_ABORT;
  END;
  BEGIN
  /* modifiche per cambiare gli apici con codifica corretta */
   select '+USER='||''''||replace(substr(nominativo,1,35),'''','''''')||''''||'+UTEN='||''''||replace(substr(nominativo,1,35),'''','''''')||''''
     into v_parte
     from a_utenti
    where utente = p_utente;
    v_lancio := v_lancio || v_parte;
  EXCEPTION
   WHEN OTHERS THEN
/*    Inserimento registrazioni per log */
     sql_errm := substr(sqlerrm,1,512);
       insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
     values (pno_prenotazione,p_sequenza,'Utente non presente in A_UTENTI: '||sql_errm);
       p_sequenza := p_sequenza +1;
     commit;
      RAISE PROGRAM_ABORT;
  END;
  BEGIN
   select '+REPORT='||decode(v_modulo,'#',v_a00_tmp|| DIR_SEP||TO_CHAR(pno_prenotazione),
                       replace(P_DISLOCAZIONE,':','%3a')||'report'||DIR_SEP|| v_modulo||'.rep')
     into v_parte
     from a_istanze_ambiente
    where ambiente    = p_ambiente
      and ente        = p_ente
      and translate(gruppo_ling,'*','@') = v_gr_lin
    ;
   v_lancio := v_lancio || v_parte;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
     null;
   END;
   IF v_cod_st != '~' THEN
      v_lancio:=v_lancio || '+P_STAMPA=' || v_cod_st;
   elsif upper(v_modulo) = 'SI4V3WAS' then
      begin
      select v_a00_prn||valore
        into v_nome_prn
        from a_parametri
       where upper(parametro) = 'TXTFILE'
         and no_prenotazione = pno_prenotazione
      ;
      exception when no_data_found then
         begin
            select v_a00_prn||valore_default
              into v_nome_prn
              from a_selezioni
             where sequenza  = 0
               and parametro = 'TXTFILE'
               and voce_menu = p_voce_menu
            ;
         exception when no_data_found then
/*         Inserimento righe per Log   */
            sql_errm := substr(sqlerrm,1,512);
            insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
            values (pno_prenotazione,p_sequenza,'PARAMETRO TXTFILE non presente in A_SELEZIONI: '||sql_errm);
            p_sequenza := p_sequenza +1;
            commit;
            RAISE PROGRAM_ABORT;
         end;
       end;
   end if;
    v_lancio:=v_lancio || '+DESNAME=' || v_nome_prn;
   if instr(upper(v_lancio),'+P_ENTE=') = 0 then
      v_lancio:=v_lancio || '+P_ENTE=' || p_ente;
   end if;
   v_lancio:=v_lancio || '+PRENOTAZIONE=' ||TO_CHAR(pno_prenotazione);
   v_lancio:=v_lancio || '+PASSO=' || to_char(p_step);
   v_lancio:=v_lancio || '+VOCE_MENU=' || p_voce_menu;
   v_lancio:=v_lancio || '+NO_STAMPA='|| to_char(v_stampa);
   v_lancio:=v_lancio || '+ST_STA='|| st_sta;
   if instr(upper(v_lancio),'+P_AMBIENTE=') = 0 then
      v_lancio:=v_lancio || '+P_AMBIENTE='|| p_ambiente;
   end if;
   if instr(upper(v_lancio),'+P_UTENTE=') = 0 then
      v_lancio:=v_lancio || '+P_UTENTE='|| p_utente;
   end if;
     contapag.inizializza(pno_prenotazione,v_nome_prn); -- Inizializza contatore delle pagine
     begin
       begin
               html_text:=  utl_http.request('http://'||pappserver_name||'/dev60cgi/'||cgi_command||'?server='||repsrv_name||'+userid='||w_user_oracle||'/'||w_password||'@'||palias_db||'+paramform=NO+commmode=SYNCHRONOUS+batch=YES+background=no+DESTYPE=File'||replace(replace(v_lancio,'''','%27'),' ','%20'));
       exception when others then
                raise;
       end;
       if instr(html_text,'Error') != 0 then      /* errore in attivazione dell'url */
              URL_ERROR := SUBSTR(html_text,instr(html_text,'</H1>')+5);
              url_error := clear_html (url_error);
          /*  Righe da inserire nel LOG */
         insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
         values (pno_prenotazione,p_sequenza,'Errore eseguendo Report');
         p_sequenza := p_sequenza +1;
         insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
         values (pno_prenotazione,p_sequenza,'Impossibile generare la stampa: '||url_error);
         p_sequenza := p_sequenza +1;
         commit;
         RAISE PROGRAM_ABORT;
       end if;
   END;
  v_lancio := null;
  if v_modulo != 'SI4V3WAS' then
declare
v_num_pag number := contapag.valore(v_nome_prn);
BEGIN
   insert into a_stampe ( PREFISSO   ,
 NO_STAMPA              ,
 DATA_PREPARAZIONE,
 VOCE_MENU         ,
 PASSO              ,
 PAGINE             ,
 STATO               ,
 STAMPA               ,
 GRUPPO                ,
 UTENTE                ,
 NO_PRENOTAZIONE
)
  ( select substr(p_voce_menu,1,3)
         ,v_stampa
         ,sysdate
         ,p_voce_menu
         ,p_step
         ,v_num_pag
         ,st_sta
         ,v_cod_st
         ,u.gruppo
         ,p_utente
         ,pno_prenotazione
      from a_utenti u
     where u.utente = p_utente);
commit;
  EXCEPTION
   WHEN OTHERS THEN
    /* Righe da mettere nel LOG
     */
     sql_errm := substr(sqlerrm,1,512);
     insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
     values (pno_prenotazione,p_sequenza,'Error WRITING A_STAMPE: '||sql_errm);
     p_sequenza := p_sequenza +1;
     commit;
      RAISE PROGRAM_ABORT;
END;
end if;
  ELSIF tipost = 'F' then
   select sysdate into v_data from dual;
        /*Righe da inserire nel LOG */
      insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
        values (pno_prenotazione,p_sequenza,'Step '||to_char(p_step)||' Ex Form in background');
        p_sequenza := p_sequenza +1;
        insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
        values (pno_prenotazione,p_sequenza,'Lancio della procedure di database: '||v_modulo);
        p_sequenza := p_sequenza +1;
      insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
        values (pno_prenotazione,p_sequenza,'Start at '||to_char(v_data,'dd/mm/yyyy hh24:mi.ss'));
        p_sequenza := p_sequenza +1;
      commit;
      begin
          si4.sql_execute('begin '||v_modulo||'.main('||pno_prenotazione||','||p_step||'); end;');
      exception when others then
            sql_errm := substr(sqlerrm,1,512);
         raise program_abort;
      end;
  ELSIF tipost = 'Q' then
   select sysdate into v_data from dual;
--    Righe da mettere nel log
      insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
        values (pno_prenotazione,p_sequenza,'Step '||to_char(p_step)||' Ex Script sql');
        p_sequenza := p_sequenza +1;
        insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
        values (pno_prenotazione,p_sequenza,'Lancio della procedure di database: '||v_modulo);
        p_sequenza := p_sequenza +1;
      insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
        values (pno_prenotazione,p_sequenza,'Start at '||to_char(v_data,'dd/mm/yyyy hh24:mi.ss'));
        p_sequenza := p_sequenza +1;
      commit;
      begin
         si4.sql_execute('begin '||v_modulo||'.main('||pno_prenotazione||','||p_step||'); end;');
      exception when others then
            sql_errm := substr(sqlerrm,1,512);
         raise program_abort;
      end;
   ELSIF tipost = 'C' then
      select sysdate
        into v_data
        from dual;
   /* Da inserire nel file di log */
   insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
     values (pno_prenotazione,p_sequenza,'Step '||to_char(p_step)||' Script di Sistema Operativo versione 3 (ignorato): '||v_modulo);
     p_sequenza := p_sequenza +1;
   insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
     values (pno_prenotazione,p_sequenza,'Start at '||to_char(v_data,'dd/mm/yyyy hh24:mi.ss'));
   commit;
     p_sequenza := p_sequenza +1;
 END IF; -- controllo sul tipo stampa
  select nvl(prossimo_passo,(numero_passo + 1))
    into p_step
    from a_prenotazioni a
   where a.no_prenotazione = pno_prenotazione;
 END LOOP;
EXCEPTION
WHEN NO_DATA_FOUND THEN
    update a_prenotazioni
   set stato ='C'
      ,data_stato=sysdate
  where no_prenotazione= pno_prenotazione;
  update a_prenotazioni
   set errore = 'A00032'
  where no_prenotazione= pno_prenotazione
    and errore is null;
  commit;
  select sysdate into v_data from dual;
 /* ultime righe da mettere nel log */
   insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
  values (pno_prenotazione,p_sequenza,'End at '||to_char(v_data,'dd/mm/yyyy hh24:mi.ss'));
  p_sequenza := p_sequenza +1;
  insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
  values (pno_prenotazione,p_sequenza,'Elaborazione conclusa con successo');
  p_sequenza := p_sequenza +1;
  commit;
   html_text:=  utl_http.request('http://'||pappserver_name||'/dev60cgi/'||cgi_command||'?server='||repsrv_name||'+userid='||w_user_oracle||'/'||w_password||'@'||palias_db||'+paramform=NO+commmode=SYNCHRONOUS+BATCH=YES+BACKGROUND=no+DESTYPE=File+MODE=Character+DESFORMAT=ASCIINEW+DESNAME='||v_a00_log||pno_prenotazione||'.log+REPORT='||replace(P_DISLOCAZIONE,':','%3a')||'report'||DIR_SEP||'SI4V3LOG.rep+PRENOTAZIONE='||pno_prenotazione);
   delete a_prenotazioni_log
   where no_prenotazione = pno_prenotazione;
   commit;
WHEN program_abort THEN
  select sysdate into v_data from dual;
/* Righe da mettere nel log */
  insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
  values (pno_prenotazione,p_sequenza,'Errore in elaborazione '||sql_errm);
  p_sequenza := p_sequenza +1;
  insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
  values (pno_prenotazione,p_sequenza,'End at '||to_char(v_data,'dd/mm/yyyy hh24:mi.ss'));
  p_sequenza := p_sequenza +1;
  commit;
   html_text:=  utl_http.request('http://'||pappserver_name||'/dev60cgi/'||cgi_command||'?server='||repsrv_name||'+userid='||w_user_oracle||'/'||w_password||'@'||palias_db||'+paramform=NO+commmode=SYNCHRONOUS+BATCH=YES+BACKGROUND=no+DESTYPE=File+MODE=Character+DESFORMAT=ASCIINEW+DESNAME='||v_a00_log||pno_prenotazione||'.log+REPORT='||replace(P_DISLOCAZIONE,':','%3a')||'report'||DIR_SEP||'SI4V3LOG.rep+PRENOTAZIONE='||pno_prenotazione);
  delete a_prenotazioni_log
    where no_prenotazione = pno_prenotazione;
   commit;
  update a_prenotazioni
   set stato ='C'
      ,data_stato=sysdate,errore='A00036'
  where no_prenotazione= pno_prenotazione;
  commit;
when unsupported_type then
  Select sysdate into v_data from dual;
--  Righe da mettere nel log
  insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
  values (pno_prenotazione,p_sequenza,'Tipo modulo '||v_modulo||' non supportato');
  p_sequenza := p_sequenza +1;
  insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
  values (pno_prenotazione,p_sequenza,'End at '||to_char(v_data,'dd/mm/yyyy hh24:mi.ss'));
  p_sequenza := p_sequenza +1;
  commit;
     html_text:=  utl_http.request('http://'||pappserver_name||'/dev60cgi/'||cgi_command||'?server='||repsrv_name||'+userid='||w_user_oracle||'/'||w_password||'@'||palias_db||'+paramform=NO+commmode=SYNCHRONOUS+BATCH=YES+BACKGROUND=no+DESTYPE=File+MODE=Character+DESFORMAT=ASCIINEW+DESNAME='||v_a00_log||pno_prenotazione||'.log+REPORT='||replace(P_DISLOCAZIONE,':','%3a')||'report'||DIR_SEP||'SI4V3LOG.rep+PRENOTAZIONE='||pno_prenotazione);
   delete a_prenotazioni_log
   where no_prenotazione = pno_prenotazione;
   commit;
 update a_prenotazioni
   set stato ='C'
      ,data_stato=sysdate,errore='A00036'
  where no_prenotazione= pno_prenotazione;
  commit;
 WHEN OTHERS THEN
  Select sysdate into v_data from dual;
   insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
   values (pno_prenotazione,p_sequenza,'Eccezione non gestita: '||sql_errm);
   p_sequenza := p_sequenza +1;
   insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
   values (pno_prenotazione,p_sequenza,'End at '||to_char(v_data,'dd/mm/yyyy hh24:mi.ss'));
   p_sequenza := p_sequenza +1;
   commit;
   html_text:=  utl_http.request('http://'||pappserver_name||'/dev60cgi/'||cgi_command||'?server='||repsrv_name||'+userid='||w_user_oracle||'/'||w_password||'@'||palias_db||'+paramform=NO+commmode=SYNCHRONOUS+BATCH=YES+BACKGROUND=no+DESTYPE=File+MODE=Character+DESFORMAT=ASCIINEW+DESNAME='||v_a00_log||pno_prenotazione||'.log+REPORT='||replace(P_DISLOCAZIONE,':','%3a')||'report'||DIR_SEP||'SI4V3LOG.rep+PRENOTAZIONE='||pno_prenotazione);
   delete a_prenotazioni_log
   where no_prenotazione = pno_prenotazione;
 commit;
  update a_prenotazioni
    set stato ='C'
       ,data_stato=sysdate,errore='A00036'
   where no_prenotazione= pno_prenotazione;
   commit;
  END;
  function get_appserver_name return varchar2 is
           ret_value      varchar2(1000);
  begin
        select nvl(userenv('terminal'),SYS_CONTEXT('USERENV','IP_ADDRESS'))
        into ret_value
       from dual;
        return ret_value;
  end;
END; 
/

