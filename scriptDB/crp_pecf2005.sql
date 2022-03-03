CREATE OR REPLACE PACKAGE PECF2005 IS

/******************************************************************************
 NOME:          PECF2005
 DESCRIZIONE:   Assestamenti per applicazione Finanziaria 2005

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/01/2005 Am     Prima Emissione
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECF2005 IS

FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
  RETURN 'V1.0 del 05/01/2005';
 END VERSIONE;

PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
 DECLARE
  D_voce      VARCHAR(10);
  V_comando   varchar2(2000);
  V_controllo varchar2(1) := null;
  V_neg       varchar2(1) := null;
  V_att       varchar2(25) := null;
  P_riga      number := 0; 

  USCITA      EXCEPTION;
 BEGIN

  BEGIN
    SELECT valore
      INTO D_voce
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_VOCE'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
    D_voce := 'ERRORE';
  END;

  V_controllo := null;
  BEGIN 
-- controllo esistenza voce
    select 'X' 
      into V_controllo
      from contabilita_voce   covo
         , voci_economiche    voec
     where voec.codice = covo.voce
       and covo.voce   = D_voce
       and covo.sub    = '*'
       and voec.classe = 'V'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RAISE USCITA;
  END;

  V_controllo := null;
  BEGIN 
-- controllo apertura Gennaio 2004
    select 'X' 
      into V_controllo
      from riferimento_retribuzione
     where anno = 2005
       and mese = 1
       and mensilita in ( select mensilita 
                            from mensilita
                           where tipo = 'N'
                             and mese = 1
                         )
     ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RAISE USCITA;
  END;

  V_controllo := null;
  BEGIN 
-- controllo apertura validita fiscale
    select 'X' 
      into V_controllo
      from validita_fiscale
     where dal = to_date('01012005','ddmmyyyy')
     ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RAISE USCITA;
  END;

  V_controllo := null;
  BEGIN 
-- controllo cedolini elaborati
    select 'X' 
      into V_controllo
      from dual
     where exists ( select 'x' 
                      from movimenti_fiscali
                     where ( anno, mese, mensilita ) in ( select anno , mese, mensilita from riferimento_retribuzione )
                   )
     ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RAISE USCITA;
  END;

  V_controllo := null;
  BEGIN 
-- controllo esistenza tabella
     select 'X'
       into V_controllo
       from dual
     where exists ( select 'x' from obj where object_name = 'DEFI_FINANZIARIA05')
     ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    V_controllo := 'Y';
  END;
  IF V_controllo = 'Y' THEN
   BEGIN
-- salvataggio tabella
     v_comando := 'create table defi_finanziaria05 as select * from detrazioni_fiscali';
     si4.sql_execute(V_comando);
   END;
   
   BEGIN 
-- elimina i dizionari detrazioni per il 2005
   delete from detrazioni_fiscali
    where dal = to_date('01012005','ddmmyyyy')
      and tipo in ('AD','AL','AP','CN','FD','FG','FH','FM','HD','MD');
   END;
  END IF;
   
 BEGIN 
    delete from w_finanziaria05;
 END;

 BEGIN 
-- calcola e memorizza i valori delle deduzioni
   insert into w_finanziaria05
   (ci,cond_fis,cn,imp_cn,fg,imp_fg,fd,imp_fd,fm,imp_fm,md,imp_md,al,imp_al)
   select cafa.ci
     , COND_FIS
     , nvl(coniuge,0) cn
     , nvl(decode( cond_fis,'AC',0,'CC',3200/12,'NC',0)*nvl(coniuge,0),0) imp_cn
     , nvl(FIGLI,0) fg
     , nvl(decode( cond_fis,'AC',3200/12,'CC',2900/12,'NC',2900/2/12)*decode(figli,'',0,1) +
       ( decode( cond_fis,'AC',2900/12,'CC',2900/12,'NC',2900/2/12)
        *decode( figli,'',0,figli-1-nvl(figli_mn,0) ) 
       ),0) imp_fg
     , nvl(FIGLI_DD,0) fd
     , nvl(decode( cond_fis,'AC',0,'CC',0,'NC',2900/12)*( nvl(figli_dd,0) - nvl(figli_mn_dd,0) )
          ,0) imp_fd
     , nvl(FIGLI_MN,0) fm
     , nvl(decode( cond_fis,'AC',3450/12,'CC',3450/12,'NC',3450/2/12)*nvl(figli_mn,0),0) imp_fm
     , nvl(FIGLI_MN_DD,0) md
     , nvl(decode( cond_fis,'AC',0,'CC',0,'NC',3450/12)*nvl(figli_mn_dd,0),0) imp_md
     , nvl(ALTRI,0) al
     , nvl(decode( cond_fis,'AC',2900/12,'CC',2900/12,'NC',2900/2/12)*nvl(altri,0),0) imp_al
     from carichi_familiari cafa
    where cafa.anno = 2005 and cafa.mese = 1
      and cafa.cond_fis is not null
      and ci in (select ci from rapporti_giuridici where flag_elab is not null)
   ;
   commit;
 END;
 BEGIN
   update w_finanziaria05 x
   set (gg,cong) =
--   (select sum(pere.gg_det)
   (select ceil( sum( pere.gg_af
                              * decode(pere.competenza,'P',0,1)
                              )
                              / decode(max(cost.gg_lavoro),30,30,26)
                          )
--                          * decode(max(cost.gg_lavoro),30,30,26)
                     + floor( sum( pere.gg_af
                               * decode(pere.competenza,'P',1,0)
                               )
                              / decode(max(cost.gg_lavoro),30,30,26)
                           )
--                           * decode(max(cost.gg_lavoro),30,30,26)
         , nvl(max(conguaglio),0)
      from periodi_retributivi pere
         , contratti_storici cost
     where cost.contratto = pere.contratto
       and pere.al between cost.dal and nvl(cost.al,to_date('3333333','j'))
       and pere.periodo     = to_date('31012005','ddmmyyyy')
       and pere.competenza in ('P','C','A')
       and pere.servizio     = 'Q'
       and pere.ci = x.ci
       and (   TO_CHAR(pere.al,'yyyy') = 2005 
            OR exists (select 'x' from ente where detrazioni_ap = 'SI')
           )
       and pere.anno +0    = 2005
   )
   ;
   commit;
 END;
 BEGIN
   update w_finanziaria05 x
   set reddito = 
   (select ipn_ord from movimenti_fiscali
     where anno = 2005 and mese = 1 and mensilita = 'GEN'
       and ci = x.ci
   )
   ;
   commit;
 END;
 BEGIN
   update w_finanziaria05
   set percentuale =
   greatest(least(
   trunc( ( 78000
          + ((imp_cn+imp_fg+imp_fd+imp_fm+imp_md+imp_al)*decode(cong,0,12,gg))
          - (reddito*decode(cong,0,12,1))
          ) / 78000 * 100
        , 2)
                  ,100),0)
   ;
   commit;
 END;
 BEGIN
   update w_finanziaria05
   set spettante =
   round( (imp_cn+imp_fg+imp_fd+imp_fm+imp_md+imp_al) * gg * percentuale / 100
        ,2)
   ;
   commit;
 END;

   BEGIN 
-- esegue la stampa dei dati estratti
   P_riga := 1;  
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad('Cod.Ind',8,' ')||' '||
          lpad('Nominativo',25,' ')||' '||
          lpad('CN',8,' ')||' '||
          lpad('FG',8,' ')||' '||
          lpad('FD',8,' ')||' '||
          lpad('FM',8,' ')||' '||
          lpad('MD',8,' ')||' '||
          lpad('AL',8,' ')||
          lpad(' ',5,' ')||
          lpad('COND.',5,' ')
     from dual
   ;
   P_riga := 2;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad(' ',8,' ')||' '||
          rpad(' ',25,' ')||' '||
          lpad('IMP.CN', 8,' ')||' '|| 
          lpad('IMP.FG', 8,' ')||' '|| 
          lpad('IMP.FD', 8,' ')||' '|| 
          lpad('IMP.FM', 8,' ')||' '|| 
          lpad('IMP.MD', 8,' ')||' '|| 
          lpad('IMP.AL', 8,' ')||' '|| 
          lpad('TOTALE', 8,' ')||' '||
          lpad('GG', 2,' ')||' '||
          lpad('REDDITO', 9,' ')||
          lpad('PERC.', 7,' ')||' '||
          lpad('SPETTANTE', 9,' ')
     from dual
   ;
   P_riga := 3;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad('-',132,'-')
     from dual;
   P_riga := 4;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad(' ',132,' ')
     from dual;
   P_riga := 5;
   
   FOR CUR_DATI IN 
   ( select rain.cognome||' '||rain.nome nominativo
          , rain.ci
       from w_finanziaria05 cafa
          , rapporti_individuali rain
    where rain.ci = cafa.ci
    order by cafa.cond_fis, rain.cognome, rain.nome
   ) LOOP
   V_neg := null;
   V_att := null;
   P_riga := nvl(P_riga,0) + 1;  
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad(cafa.ci,8,' ')||' '||
          rpad(CUR_DATI.nominativo,25,' ')||' '||
          lpad(cafa.cn,8,' ')||' '||
          lpad(cafa.fg,8,' ')||' '||
          lpad(cafa.fd,8,' ')||' '||
          lpad(cafa.fm,8,' ')||' '||
          lpad(cafa.md,8,' ')||' '||
          lpad(cafa.al,8,' ')||
          lpad(' ',5,' ')||
          lpad(cafa.COND_FIS,5,' ')
     from w_finanziaria05 cafa
    where cafa.ci = CUR_DATI.ci
   ;
   BEGIN
   select '*'
     into V_neg
     from dual
    where exists ( select 'x' 
                    from w_finanziaria05 cafa
                   where cafa.ci = CUR_DATI.ci
                     and ( cafa.imp_cn < 0
                        or cafa.imp_fg < 0
                        or cafa.imp_fd < 0
                        or cafa.imp_fm < 0
                        or cafa.imp_md < 0
                        or cafa.imp_al < 0
                        or cafa.imp_cn+cafa.imp_fg+cafa.imp_fd+cafa.imp_fm+cafa.imp_md+cafa.imp_al < 0
                        or cafa.reddito < 0
                        or cafa.percentuale < 0
                        or cafa.spettante < 0
                         )
                   );
   EXCEPTION WHEN NO_DATA_FOUND THEN V_neg := null;
   END;   BEGIN
   select decode( cong,0,' ','** CESS **')||
          decode( sign(cafa.reddito-cafa.spettante),-1,'** IPN<DED **',' ')
     into V_att
     from  w_finanziaria05 cafa
    where cafa.ci = CUR_DATI.ci
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN V_att := null;
   END;
   P_riga := nvl(P_riga,0) + 1;  
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad(' ',8,' ')||' '||
          rpad(v_att,25,' ')||' '||
          lpad(to_char(cafa.imp_cn,'9990.99'), 8,' ')||' '|| 
          lpad(to_char(cafa.imp_fg,'9990.99'), 8,' ')||' '|| 
          lpad(to_char(cafa.imp_fd,'9990.99'), 8,' ')||' '|| 
          lpad(to_char(cafa.imp_fm,'9990.99'), 8,' ')||' '|| 
          lpad(to_char(cafa.imp_md,'9990.99'), 8,' ')||' '|| 
          lpad(to_char(cafa.imp_al,'9990.99'), 8,' ')||' '|| 
          lpad(to_char(cafa.imp_cn+cafa.imp_fg+cafa.imp_fd+cafa.imp_fm+cafa.imp_md+cafa.imp_al,'9990.99'), 8,' ')||
          lpad(cafa.gg, 2,' ')||' '|| 
          lpad(to_char(cafa.reddito,'99990.99'), 9,' ')||
          lpad(to_char(cafa.percentuale,'990.99'), 7,' ')||' '|| 
          lpad(to_char(cafa.spettante,'99990.99'), 9,' ')||' '|| 
          lpad(V_neg,2,' ')
     from w_finanziaria05 cafa
    where cafa.ci = CUR_DATI.ci
   ;
   P_riga := P_riga +1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad(' ',132,' ')
     from dual;

   END LOOP;
   END;
-- inserisce le variabili
   IF D_voce != 'ERRORE' THEN
     BEGIN
     delete from movimenti_contabili
      where ( anno, mese, mensilita ) in ( select anno , mese, mensilita from riferimento_retribuzione )
        and voce = D_voce
        and sub  = '*'
        and ci in (select ci from rapporti_giuridici where flag_elab is not null)
     ;
     END;

     BEGIN
       insert into movimenti_contabili
        (ci,anno,mese,mensilita,voce,sub
        ,riferimento,input,data
        ,imp_var)
        select ragi.ci,rire.anno,rire.mese,rire.mensilita,D_voce,'*'
        ,least(rire.fin_ela,nvl(ragi.al,rire.fin_ela)),'I',sysdate
        ,cafa.spettante*-1
        from w_finanziaria05 cafa
           , rapporti_giuridici ragi
           , riferimento_retribuzione rire
        where cafa.ci = ragi.ci
        and cafa.spettante != 0
     ;
     update rapporti_giuridici set flag_elab = 'P'
      where flag_elab in ('C','E')
        and ci in (select ci from w_finanziaria05 where spettante != 0)
     ;
     END;
   END IF;
  EXCEPTION WHEN USCITA THEN
     update a_prenotazioni
        set prossimo_passo = 91
          , errore = 'P00603'
     where no_prenotazione = prenotazione
    ;
    commit;
  END;
 END;
END;
/
