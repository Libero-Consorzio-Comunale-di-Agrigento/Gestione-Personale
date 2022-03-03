CREATE OR REPLACE PACKAGE PECCSMDP IS
/******************************************************************************
 NOME:        PECCSMDP
 DESCRIZIONE: Creazione del flusso per la Denuncia Contributiva Annuale INPDAP su
              supporto magnetico: dischetti 5"1/4 o 3"1/2, lunghezza record 100 crt
              secondo il tracciato imposto dalla Direzione Generale INPDAP.
              Questa fase produce un file secondo i tracciati imposti dalla
              circolare I.N.P.D.A.P., leggendo i dati archiviati con le fasi
              << CARCP>> e << CARDD >>.
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: La gestione che deve risultare come intestataria della denuncia
              deve essere stata inserita in << DGEST >> in modo tale che la
              ragione sociale (campo nome) risulti essere la minore di tutte
              le altre eventualmente inserite con la stessa posizione CPD o CPS.
              Lo stesso risultato si raggiunge anche inserendo un BLANK prima
              del nome di tutte le gestioni che devono essere escluse.

              Il PARAMETRO D_anno indica l'anno di riferimento della denuncia
              da elaborare.
              Il PARAMETRO D_previdenza specifica la posizione INADEL (quindi l'ente)
              che presenta la denuncia.
              Il PARAMETRO D_pos_cpdel specifica la posizione INADEL (quindi l'ente)
              che presenta la denuncia.
              Il PARAMETRO D_pos_cps specifica la posizione INADEL (quindi l'ente)
              che presenta la denuncia.
              Il PARAMETRO D_negativi specifica se devono essere esclusi i valori
              negativi.

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY PECCSMDP IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
 BEGIN

DECLARE 
--
-- Variabili di Ordinamento
--
  P_pagina       number;
  P_riga         number;
--
-- Variabili di Deposito    
--
  P_dummy        varchar2(1);
  P_num_ser      number;
  P_dep_cod_ces  varchar2(1);
--
-- Parametri di Selezione per l'Elaborazione
--
  P_ente         varchar2(4);
  P_ambiente     varchar2(8);
  P_utente       varchar2(8);
  P_anno         varchar2(4);
  P_ini_a        date;
  P_fin_a        date;
  P_previdenza   varchar2(6);
  P_par_cpdel    varchar2(12);
  P_par_cps      varchar2(12);
  P_pos_cpdel    varchar2(12);
  P_pos_cps      varchar2(12);
  P_negativi     varchar2(1);
-- 
-- Variabili di Retribuzione
--
  P_imp_r1       number;
  P_imp_cp       number;
  P_imp_inadel   number;
  P_gest         varchar2(1);
--
-- Variabili di Totalizzazione
--
  P_conta_ap     number;
  P_conta_ass    number;
  P_conta_cess   number;
  P_conta_ac     number;
  P_tot_cp       number;
  P_tot_inadel   number;
  P_tot_arr      number;
--
-- Exceptions
--
  USCITA EXCEPTION;

BEGIN
  BEGIN -- Estrazione Ente Utente Ambiente
    select ente,utente,ambiente
      into P_ente,P_utente,P_ambiente
      from a_prenotazioni
     where no_prenotazione = prenotazione
    ;
  END;
  BEGIN -- Estrazione Anno
    select substr(valore,1,4)
         , to_date('01'||substr(valore,1,4),'mmyyyy')
         , to_date('3112'||substr(valore,1,4),'ddmmyyyy')
      into P_anno,P_ini_a,P_fin_a
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_ANNO'         
    ; 
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
       select anno 
            , to_date('01'||to_char(anno),'mmyyyy')
            , to_date('3112'||to_char(anno),'ddmmyyyy')
         into P_anno,P_ini_a,P_fin_a
         from riferimento_fine_anno
        where rifa_id = 'RIFA'
       ;
  END;
  BEGIN -- Estrazione Negativi   
    select max(substr(valore,1,1))
      into P_negativi   
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_NEGATIVI'   
    ;
  END;
  BEGIN -- Estrazione Previdenza
    select substr(valore,1,6)
      into P_previdenza
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_PREVIDENZA'   
    ;
  END;
  BEGIN -- Estrazione Posizione CPDEL
    select substr(valore,1,12)
      into P_par_cpdel
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_P_CPD'   
    ;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
       IF P_previdenza = 'CPDEL' THEN 
          P_par_cpdel := '%';
       ELSE
          P_par_cpdel := null;
       END IF;     
  END;
  BEGIN -- Estrazione Posizione CPS
    select substr(valore,1,12)
      into P_par_cps
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_P_CPS'   
    ;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
       IF P_previdenza = 'CPDEL' THEN 
          P_par_cps := null;
       ELSE
          P_par_cps := '%';
       END IF;     
  END;
BEGIN
  BEGIN
    select 'x'
      into P_dummy
      from dual
     where exists
          (select 'x'
             from denuncia_cp
            where anno       = P_anno                   
              and gestione  in 
                 (select codice from gestioni
                   where decode( P_previdenza    
                               , 'CPDEL', nvl(posizione_cpd,' ')
                                        , nvl(posizione_cps,' ')
                               ) like  decode( P_previdenza    
                                             , 'CPDEL', nvl(P_par_cpdel,'%')
                                                      , nvl(P_par_cps,'%')
                                             )
                 )
              and previdenza = P_previdenza
              and exists
                 (select 'x'
                    from rapporti_individuali rain
                   where rain.ci = denuncia_cp.ci
                     and (   rain.cc is null
                          or exists
                            (select 'x' 
                               from a_competenze 
                              where ente        = P_ente
                                and ambiente    = P_ambiente
                                and utente      = P_utente
                                and competenza  = 'CI'
                                and oggetto     = rain.cc
                            )
                         )
                 )
          )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN RAISE USCITA;
  END;

  P_pagina := 0;
  P_riga   := 0;

  FOR CUR_GEST IN
     (select distinct
             decode( P_previdenza   
                   , 'CPDEL', 2
                   , 'CPI'  , 3
                            , 5)                    cassa       
           , decode( P_previdenza   
                   , 'CPDEL', gest.posizione_cpd 
                            , gest.posizione_cps)   pos_cp_gest
           , gest.codice                            cod_gest
        from gestioni                   gest
       where gest.nome = 
            (select min(nome)
               from gestioni
              where decode( P_previdenza    
                          , 'CPDEL', nvl(posizione_cpd,' ')
                                   , nvl(posizione_cps,' ')
                          ) like  decode( P_previdenza    
                                        , 'CPDEL', nvl(P_par_cpdel,'%')
                                                 , nvl(P_par_cps,'%')
                                        )
                and substr(nome,1,1) != ' '
            ) 
         and exists 
            (select 'x'
               from denuncia_cp
              where anno       = P_anno                   
                and gestione  in 
                   (select codice from gestioni
                     where decode( P_previdenza
                                 , 'CPDEL', nvl(posizione_cpd,' ')
                                          , nvl(posizione_cps,' ')
                                 ) = decode(P_previdenza
                                           ,'CPDEL',nvl(gest.posizione_cpd,' ')
                                                   ,nvl(gest.posizione_cps,' ')
                                           )
                   )
                and previdenza = P_previdenza
                and exists
                   (select 'x'
                      from rapporti_individuali rain
                     where rain.ci = denuncia_cp.ci
                       and (   rain.cc is null
                            or exists
                              (select 'x' 
                                 from a_competenze 
                                where ente        = P_ente
                                  and ambiente    = P_ambiente
                                  and utente      = P_utente
                                  and competenza  = 'CI'
                                  and oggetto     = rain.cc
                              )
                           )
                   )
            )
     ) LOOP

       P_conta_ap   := 0;
       P_conta_ass  := 0;
       P_conta_cess := 0;
       P_conta_ac   := 0;
       P_tot_cp     := 0;
       P_tot_inadel := 0;
       P_tot_arr    := 0;

       FOR CUR_ANA IN
          (select distinct
                  decode( decp.codice,null,2,1)             ord_iscritti
                , max(decode
                  ( instr( substr( rtrim(anag.cognome)||' '||
                                   rtrim(anag.nome)
                                 , instr(rtrim(anag.cognome)||' '||
                                         rtrim(anag.nome),' ')+1
                                 , 41
                                 )
                         , ' ')
                  , 0, anag.cognome
                     ,substr( rtrim(anag.cognome)||' '||rtrim(anag.nome)
                            , 1
                            , instr(rtrim(anag.cognome)||' '||
                                    rtrim(anag.nome),' ')-1
                            )||
                      substr( rtrim(anag.cognome)||' '||rtrim(anag.nome)
                            , instr(rtrim(anag.cognome)||' '||
                                    rtrim(anag.nome),' ')+1
                            , instr( substr( rtrim(anag.cognome)||' '||
                                             rtrim(anag.nome)
                                           , instr(rtrim(anag.cognome)||' '||
                                                   rtrim(anag.nome),' ')+1
                                           , 41
                                           )
                                   , ' ')-1
                            )
                  ))                                              ord_cognome
                , max(decode
                  ( instr( substr( rtrim(anag.cognome)||' '||
                                   rtrim(anag.nome)
                                 , instr(rtrim(anag.cognome)||' '||
                                         rtrim(anag.nome),' ')+1
                                 , 41
                                 )
                         , ' ')
                  , 0, anag.nome
                     , substr( rtrim(anag.cognome)||' '||rtrim(anag.nome)
                             , instr( substr( rtrim(anag.cognome)||' '||
                                              rtrim(anag.nome)
                                            , instr(rtrim(anag.cognome)||' '||
                                                    rtrim(anag.nome)
                                                   ,' ')+1
                                            , 41
                                            )
                                    , ' ')+1
                                      +instr( rtrim(anag.cognome)||' '||
                                              rtrim(anag.nome)
                                            , ' '
                                            )
                             , 41)
                  ))                                             ord_nome
                , lpad(decp.codice,8,'0')                        codice
                , max(rpad(substr(rtrim(anag.cognome)||'*'||
                                  anag.nome,1,27),27,' '))       nome
                , max(to_char(anag.data_nas,'ddmmyy'))           data_nas
                , max(anag.sesso)                                sesso
                , max(anag.codice_fiscale)                       cod_fis
                , anag.ni                                   ni
                , max(decode(posi.di_ruolo,'R',1,2))             ruolo
                , max(lpad(qual.qua_inadel,2,'0'))               livello
             from posizioni                         posi
                , qualifiche                        qual
                , anagrafici                        anag
                , periodi_giuridici                 pegi
                , denuncia_inadel                   deid
                , denuncia_cp                       decp
            where decp.anno         = P_anno
              and decp.gestione  in 
                 (select codice from gestioni
                   where decode( P_previdenza 
                               , 'CPDEL',nvl(posizione_cpd,' ')
                                        ,nvl(posizione_cps,' '))
                       = nvl(CUR_GEST.pos_cp_gest,' '))
              and decp.previdenza   = P_previdenza
              and anag.ni           = (select max(ni) 
                                         from rapporti_individuali
                                        where ci = decp.ci)
              and anag.al          is null
              and pegi.ci           = decp.ci
              and pegi.rilevanza    = 'S'
              and pegi.dal          =
                 (select max(dal) from periodi_giuridici
                   where rilevanza = 'S'
                     and ci        = decp.ci
                     and dal      <= P_fin_a
                 )
              and decp.anno         = deid.anno (+)
              and decp.ci           = deid.ci (+)
              and decp.gestione     = deid.gestione  (+)
              and qual.numero       = nvl(deid.qualifica,pegi.qualifica)
              and posi.codice       = nvl(deid.posizione,pegi.posizione)
              and exists
                 (select 'x'
                    from rapporti_individuali rain
                   where rain.ci = decp.ci
                     and (   rain.cc is null
                          or exists
                            (select 'x' 
                               from a_competenze 
                              where ente        = P_ente
                                and ambiente    = P_ambiente
                                and utente      = P_utente
                                and competenza  = 'CI'
                                and oggetto     = rain.cc
                             )
                         )
                 )
              and (     P_negativi is null
                   or (    P_negativi is not null
                       and not exists
                          (select 'x' from denuncia_cp 
                            where anno       = decp.anno
                              and gestione   = decp.gestione
                              and previdenza = decp.previdenza
                              and ci         = decp.ci
                              and (   sign(importo)    = -1
                                   or sign(contributi) = -1
                                  )
                          )  
                       and not exists
                          (select 'x' from denuncia_importi_inadel
                            where anno       = decp.anno
                              and ci         = decp.ci
                              and (   sign(importo)    = -1
                                   or sign(contributi) = -1
                                  )
                          )
                      )  
                 )
            group by decp.codice,anag.ni
            order by 1,2,3
          ) LOOP
            BEGIN
              select nvl(round(importo / 1000),0)
                into P_imp_r1
                from denuncia_cp
               where anno         = P_anno
                 and gestione    in 
                    (select codice from gestioni
                      where decode( P_previdenza 
                                  , 'CPDEL',nvl(posizione_cpd,' ')
                                           ,nvl(posizione_cps,' '))
                                  = nvl(CUR_GEST.pos_cp_gest,' ')
                    )
                 and previdenza   = P_previdenza
                 and rilevanza    = 'R'
                 and ci          in
                    (select ci from rapporti_individuali
                      where ni = CUR_ANA.ni)
              ;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN

                   P_imp_r1 := 0;

            END;
            BEGIN
              select decode( P_imp_r1
                           , 0, round(sum(diid.importo) / 1000)
                              , P_imp_r1)                     imp_retr_cp
                   , round(sum(diid.importo) / 1000)          imp_retr_inadel
                   , decode( nvl(P_imp_r1,0) + nvl(sum(diid.importo),0)
                           , 0, null
                           , P_imp_r1, 'D'
                           , sum(diid.importo), 'B'
                                              , 'M')          gest 
                into P_imp_cp,P_imp_inadel,P_gest
                from denuncia_importi_inadel diid
               where diid.anno         = P_anno
                 and diid.ci          in 
                    (select ci from rapporti_individuali
                      where ni = CUR_ANA.ni)
                 and diid.codice      != 'CONTRIBUTI'
                 and diid.riferimento is null
              ;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN

                   P_imp_cp     := P_imp_r1;
                   P_imp_inadel := 0;
                   P_gest       := 'D';
            END;

            P_pagina  := P_pagina  + 1;
            P_riga    := 0;
            P_num_ser := 0;

            FOR CUR_SER IN
               (select decode
                       ( decp.tipo_contratto
                       , 'F', decp.dal
                       , 'L', decp.dal
                              , decode
                                (nvl(decp.al,P_fin_a)
                                ,P_fin_a,decode
                                         (decp.tipo_cessazione
                                         ,null,decode
                                               (decp.codice
                                               ,null,decp.dal
                                                    ,decode
                                                     (decp.dal 
                                                     ,P_ini_a,to_date(null)
                                                             ,decp.dal
                                                     )
                                               )            
                                              ,decp.dal
                                              )
                                         ,decp.dal
                                )
                       )                                              dal_s
                     , decode
                       ( decp.tipo_contratto
                       , 'F', nvl(decp.al,P_fin_a)
                       , 'L', nvl(decp.al,P_fin_a)
                            , decode( decp.al
                                    , P_fin_a, decode
                                               ( decp.tipo_cessazione
                                               , null, to_date(null)
                                                     , decp.al)
                                             , decp.al))              al_s
                     , nvl( decp.tipo_contratto
                           ,decode( decp.al
                                   , P_fin_a, decp.tipo_cessazione
                                            , decp.tipo_cessazione)
                          )                                           codice
                     , decode( decp.ore
                             , null, ' '
                                   , '*')                             tp
                  from denuncia_cp decp
                 where decp.anno             = P_anno
                   and decp.gestione  in 
                      (select codice from gestioni
                        where decode( P_previdenza
                                    , 'CPDEL',nvl(posizione_cpd,' ')
                                             ,nvl(posizione_cps,' '))
                            = nvl(CUR_GEST.pos_cp_gest,' ')
                      )
                   and decp.previdenza       = P_previdenza
                   and decp.ci              in
                      (select ci from rapporti_individuali
                        where ni = CUR_ANA.ni)
                   and decp.rilevanza        = 'S'
                 order by dal,al
               ) LOOP 
                 BEGIN

                   P_dep_cod_ces := CUR_SER.codice;
                   P_num_ser     := P_num_ser + 1;
                   P_riga        := P_riga    + 1;
                   P_tot_cp      := P_tot_cp  + P_imp_cp;

                   IF P_num_ser = 1 THEN

                      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                      values ( prenotazione
                             , 1
                             , P_pagina
                             , P_riga
                             , to_char(CUR_GEST.cassa)||
                               substr
                               (rpad(CUR_GEST.pos_cp_gest,12,' ')
                               ,1,8)||
                               ' '||
                               nvl(CUR_ANA.codice,'        ')||
                               to_char(CUR_ANA.ord_iscritti)||
                               'A1'||
                               CUR_ANA.nome||  
                               CUR_ANA.data_nas||
                               CUR_ANA.sesso||
                               substr(P_anno,3,2)||
                               lpad(nvl(to_char(P_imp_cp),'0'),6,'0')||
                               nvl(to_char(CUR_SER.dal_s,'ddmm'),'0000')||
                               nvl(to_char(CUR_SER.al_s,'ddmm'),'0000')||
                               nvl(CUR_SER.codice,' ')||
                               CUR_ANA.cod_fis||
                               ' '||
                               decode( to_char(nvl(P_imp_cp,0))
                                     , '0', ' '
                                          , P_gest)||
                               nvl(to_char(CUR_ANA.ruolo),'0')||
                               CUR_SER.tp||
                               nvl(CUR_ANA.livello,'00')||
                               '      '
                             )
                      ;
                   ELSE

                      P_num_ser := P_num_ser + 1;
                      P_riga    := P_riga    + 1;

                      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                      values ( prenotazione
                             , 1
                             , P_pagina
                             , P_riga
                             , to_char(CUR_GEST.cassa)||
                               substr
                               (rpad(CUR_GEST.pos_cp_gest,12,' ')
                               ,1,8)||
                               ' '||
                               nvl(CUR_ANA.codice,'        ')||
                               to_char(CUR_ANA.ord_iscritti)||
                               'A1'||
                               CUR_ANA.nome||  
                               CUR_ANA.data_nas||
                               CUR_ANA.sesso||
                               substr(P_anno,3,2)||
                               lpad('0',6,'0')||
                               nvl(to_char(CUR_SER.dal_s,'ddmm'),'0000')||
                               nvl(to_char(CUR_SER.al_s,'ddmm'),'0000')||
                               nvl(CUR_SER.codice,' ')||
                               CUR_ANA.cod_fis||
                               ' '||
                               ' '||
                               nvl(to_char(CUR_ANA.ruolo),'0')||
                               CUR_SER.tp||
                               nvl(CUR_ANA.livello,'00')||
                               '      '
                             )
                      ;
                   END IF;
                 END;
                 END LOOP;

            IF nvl(P_imp_cp,0) = nvl(P_imp_inadel,0) THEN

               null;

            ELSIF nvl(P_imp_inadel,0) = 0 THEN

                  null;

               ELSE

                  P_tot_inadel := P_tot_inadel + P_imp_inadel;
                  P_riga    := P_riga    + 1;

                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , P_pagina
                         , P_riga
                         , to_char(CUR_GEST.cassa)||
                           substr
                           (rpad(CUR_GEST.pos_cp_gest,12,' ')
                           ,1,8)||
                           ' '||
                           nvl(CUR_ANA.codice,'        ')||
                           to_char(CUR_ANA.ord_iscritti)||
                           'A2'||
                           CUR_ANA.nome||  
                           CUR_ANA.data_nas||
                           CUR_ANA.sesso||
                           substr(P_anno,3,2)||
                           lpad(to_char(P_imp_inadel),6,'0')||
                           '        '||
                           ' '||
                           CUR_ANA.cod_fis||
                           lpad(' ',12,' ')
                         )
                  ;
            END IF;
            FOR CUR_AA_ARR IN
               (select decp.riferimento                         arr_rif
                     , decode( nvl(sum(diid.importo),0)  
                             , nvl(sum(decp.importo),0), 'M'
                                                       , 'D')   arr_gest
                  from denuncia_importi_inadel diid
                     , denuncia_cp decp
                 where decp.anno             = P_anno
                   and decp.gestione  in 
                      (select codice from gestioni
                        where decode( P_previdenza
                                    , 'CPDEL',nvl(posizione_cpd,' ')
                                             ,nvl(posizione_cps,' '))
                            = nvl(CUR_GEST.pos_cp_gest,' '))
                   and decp.previdenza       = P_previdenza
                   and decp.ci              in 
                      (select ci from rapporti_individuali
                        where ni = CUR_ANA.ni)
                   and decp.rilevanza        = 'A'
                   and diid.anno        (+)  = decp.anno
                   and diid.ci          (+)  = decp.ci
                   and nvl(diid.codice,' ') != 'CONTRIBUTI'
                   and diid.riferimento (+)  = decp.riferimento
                group by decp.riferimento
                union
                select diid.riferimento                         arr_rif
                     , decode( nvl(sum(diid.importo),0)  
                             , nvl(sum(decp.importo),0), 'M'
                                                       , 'B')   arr_gest
                  from denuncia_importi_inadel diid
                     , denuncia_cp decp
                 where diid.anno             = P_anno
                   and diid.ci              in
                      (select ci from rapporti_individuali
                        where ni = CUR_ANA.ni)
                   and decp.anno     (+)     = diid.anno        
                   and decp.ci       (+)     = diid.ci           
                   and decp.rilevanza (+)    = 'A'
                   and diid.riferimento     = decp.riferimento (+)
                   and diid.riferimento is not null
                 group by diid.riferimento
                ) LOOP
                  BEGIN
                    FOR CUR_ARR IN
(select decode
        ( decp.tipo_contratto
        , null, decode
                ( nvl(decp.dal,to_date('2222222','j'))
                , to_date('2222222','j'), to_date(null)
                , to_date( '01'||to_char(decp.riferimento)
                         , 'mmyyyy'), decode
                                      ( nvl(decp.al,to_date('3333333','j'))
                                      , to_date('3333333','j'), to_date(null)
                                      ,to_date('3112'||to_char(decp.riferimento)
                                              , 'ddmmyyyy'), to_date(null)
                                                           , decp.dal
                                      )
                                    , decp.dal
                         ) 
                , decp.dal)           dal_1
      , decode
        ( decp.tipo_contratto
        , null, decode
                ( nvl(decp.al,to_date('3333333','j'))
                , to_date('3333333','j'), to_date(null)
                , to_date( '3112'||to_char(decp.riferimento)
                         , 'ddmmyyyy'), decode
                                        ( nvl(decp.dal,to_date('2222222','j'))
                                        , to_date('2222222','j'), to_date(null)
                                        ,to_date('01'||to_char(decp.riferimento)
                                                , 'mmyyyy'), to_date(null)
                                                           , decp.al
                                        )
                                      , decp.al
                ) 
             , decp.al)                                         al_1
      , decp.tipo_contratto                                     tc_1
      , substr(to_char(decp.riferimento),3,2)                   r_1
      , round(decp.importo / 1000)                              imp_1
      , decode( posi.di_ruolo
               ,'R',' ' 
                   ,decode( CUR_AA_ARR.arr_gest
                           ,'M','2',' ' ) )                     ruolo_1
   from posizioni   posi
      , denuncia_cp decp
  where CUR_AA_ARR.arr_gest  in ('M','D')
    and decp.anno             = P_anno
    and decp.gestione  in (select codice from gestioni
                             where decode( P_previdenza
                                         , 'CPDEL',nvl(posizione_cpd,' ')
                                                   ,nvl(posizione_cps,' '))
                                    = nvl(CUR_GEST.pos_cp_gest,' '))
    and decp.previdenza       = P_previdenza
    and decp.ci              in
        (select ci from rapporti_individuali
          where ni = CUR_ANA.ni)
    and decp.rilevanza        = 'A'
    and decp.riferimento      = CUR_AA_ARR.arr_rif
    and posi.codice           = 
       (select posizione from periodi_giuridici pegi
         where pegi.rilevanza = 'S'
           and pegi.ci        = decp.ci
           and pegi.dal = 
              (select max(dal) from periodi_giuridici
                where rilevanza = 'S'
                  and ci        = pegi.ci
                  and dal      <= nvl(decp.al,to_date('3333333','j'))
                  and nvl(al,to_date('3333333','j')) >= decp.dal
              )
       )
 union
 select to_date(null)
      , to_date(null)
      , null                         tc_1
      , substr(to_char(diid.riferimento),3,2) r_1
      , round(sum(diid.importo) / 1000)   imp_1
      , decode(max(posi.di_ruolo),'R',' ' ,'2')               ruolo_1
   from posizioni   posi
      , denuncia_importi_inadel diid
  where CUR_AA_ARR.arr_gest  in ('M','B')
    and diid.anno             = P_anno
    and diid.ci              in
       (select ci from rapporti_individuali
         where ni = CUR_ANA.ni)
    and diid.codice          != 'CONTRIBUTI'
    and diid.riferimento      = CUR_AA_ARR.arr_rif
    and diid.riferimento     is not null
    and posi.codice           = 
       (select posizione from periodi_giuridici pegi
         where rilevanza = 'S'
           and ci        = diid.ci
           and pegi.dal = 
              (select max(dal) from periodi_giuridici 
                where rilevanza = 'S'
                  and ci        = pegi.ci
                  and dal      <= P_fin_a
                  and nvl(al,to_date('3333333','j')) >= P_ini_a
              )
       )
  group by diid.riferimento
  having nvl(sum(diid.importo),0) != 
        (select nvl(sum(importo),0) from denuncia_cp
          where anno        = P_anno
            and ci         in
               (select ci from rapporti_individuali
                 where ni = CUR_ANA.ni)
            and rilevanza   = 'A'
            and riferimento = diid.riferimento)
  order by 1,2,3
                       ) LOOP

                         P_tot_arr := P_tot_arr + CUR_ARR.imp_1;
                         P_riga    := P_riga    + 1;

                         insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                         values ( prenotazione
                                , 1
                                , P_pagina
                                , P_riga
                                , to_char(CUR_GEST.cassa)||
                                  substr
                                  (rpad(CUR_GEST.pos_cp_gest,12,' ')
                                  ,1,8)||
                                  ' '||
                                  nvl(CUR_ANA.codice,'        ')||
                                  to_char(CUR_ANA.ord_iscritti)||
                                  'B1'||
                                  CUR_ANA.nome||  
                                  CUR_ANA.data_nas||
                                  CUR_ANA.sesso||
                                  CUR_ARR.r_1||                       
                                  lpad(to_char(CUR_ARR.imp_1),6,'0')||
                                  nvl(to_char(CUR_ARR.dal_1,'ddmm'),'0000')||
                                  nvl(to_char(CUR_ARR.al_1,'ddmm'),'0000')||
                                  nvl(CUR_ARR.tc_1,' ')||
                                  CUR_ANA.cod_fis||
                                  ' '||
                                  CUR_AA_ARR.arr_gest||
                                  CUR_ARR.ruolo_1||
                                  '         '
                                )
                         ;
                         END LOOP;
                  END;
                  END LOOP;
            END LOOP;

            select sum(decode(max(codice),null,0,1))                    vig_ap
                 , sum(decode(max(codice),null,1,0))                    ass
                 , sum(decode( least( max(nvl(al,to_date('3333333','j')))
                                    , P_fin_a+1)
                             , P_fin_a+1, 0
                                                , 1
                             )
                      ) ces
                 , sum(decode(max(codice),null,0,1)) +
                   sum(decode(max(codice),null,1,0)) -
                   sum(decode( least( max(nvl(al,to_date('3333333','j')))
                                    , P_fin_a+1)
                             , P_fin_a+1, 0
                                                , 1
                             )
                      ) vig_ac
              into P_conta_ap,P_conta_ass,P_conta_cess,P_conta_ac
              from denuncia_cp
             where anno       = P_anno  
               and previdenza = P_previdenza
               and gestione  in (select codice from gestioni
                                  where decode( P_previdenza
                                              , 'CPDEL',nvl(posizione_cpd,' ')
                                                       ,nvl(posizione_cps,' '))
                                        = nvl(CUR_GEST.pos_cp_gest,' '))
               and rilevanza  = 'S'
             group by ci
            ;

            P_pagina  := P_pagina  + 1;
            P_riga    := P_riga    + 1;

            insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
            values ( prenotazione
                   , 1
                   , P_pagina
                   , P_riga
                   , to_char(CUR_GEST.cassa)||
                     substr
                     (rpad(CUR_GEST.pos_cp_gest,12,' ')
                     ,1,8)||
                     '         '||
                     '3'||
                     '  '||
                     lpad(to_char(nvl(P_conta_ap,0)),6,'0')||
                     lpad(to_char(nvl(P_conta_ass,0)),6,'0')||
                     lpad(to_char(nvl(P_conta_cess,0)),6,'0')||
                     lpad(to_char(nvl(P_conta_ac,0)),6,'0')||
                     '          '||
                     substr(P_anno,3,2)||
                     lpad(to_char(nvl(P_tot_cp,0)),10,'0')||
                     lpad(to_char(nvl(P_tot_arr,0)),10,'0')||
                     lpad(to_char(nvl(P_tot_inadel,0)),10,'0')
                   )
            ;
       END LOOP;
update a_prenotazioni 
   set errore = 
(select nvl(max('P05840'),'P05841')
   from dual    
  where exists 
       (select 'x' from denuncia_cp
         where anno                 = P_anno
           and gestione  in 
              (select codice from gestioni
                where decode( P_previdenza    
                            , 'CPDEL', nvl(posizione_cpd,' ')
                                     , nvl(posizione_cps,' ')
                            ) like  decode( P_previdenza    
                                          , 'CPDEL', nvl(P_par_cpdel,'%')
                                                   , nvl(P_par_cps,'%')
                                          )
              )
           and previdenza           = P_previdenza
           and (   sign(importo)    = -1
                or sign(contributi) = -1
               ) 
       )
     or exists 
       (select 'x' from denuncia_importi_inadel
         where anno       = P_anno
           and ci in 
              (select ci from denuncia_inadel
                where anno     = P_anno
                  and gestione  in 
                     (select codice from gestioni
                       where decode( P_previdenza    
                                   , 'CPDEL',nvl(posizione_cpd,' ')
                                            ,nvl(posizione_cps,' ')
                                   ) like  decode( P_previdenza    
                                                 , 'CPDEL', nvl(P_par_cpdel,'%')
                                                          , nvl(P_par_cps,'%')
                                                 )
                     )
              )
           and (   sign(importo)      = -1
                or sign(contributi)   = -1
               ) 
       )
)
where no_prenotazione = prenotazione
;
END;
EXCEPTION WHEN USCITA THEN
    update a_prenotazioni set errore = 'P05805'
                            , prossimo_passo = 99
     where no_prenotazione = prenotazione
    ;
END;
END;
END;
/
