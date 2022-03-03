CREATE OR REPLACE PACKAGE PECCSMGM IS

/******************************************************************************
 NOME:        PECCSMGM 
 DESCRIZIONE: Emissione file per ENPAM
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI: Il file è stato generato partendo dalle esigenze del cliente
              Pertanto alcune informazioni vengono decodificate in modo diverso
              a seconda del codice cliente identificabile su AD4 ENTI
              
              ER09    : ASL Reggio Emilia ( User PMI - Ente PLMI  diverso )
              UCHI    : ASL Chiavari
              TO13    : ASL Livorno
              LO11    : ASL Como
              SI03    : ASL Catania ( Giarre si36 )
              HGSM    : Ospedale San Martino di Genova
              SI08    : ASL Siracusa
              ER32    : ASL Ferarra e Guardie Mediche Gestione Interna AU09GM
              SI06    : ASL Palermo
              CONSBZ  : Consorzio Bolzano 
              INTERNA : ASL Ferarra Gestione Interna AU09
              ENTE    : Default 

 REVISIONI:
 Rev. Data       Autore   Descrizione
 ---- ---------- ------   --------------------------------------------------------
 1.0  19/06/2007 MS       Prima emissione
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number,passo in number);
end;
/
CREATE OR REPLACE PACKAGE BODY PECCSMGM IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 19/06/2007';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number,passo in number) is
BEGIN
DECLARE
  D_ente            VARCHAR(4);
  D_ambiente        VARCHAR(8);
  D_utente          VARCHAR(8);
  D_note_ente       VARCHAR(100);
  D_cliente         VARCHAR(20);

  D_pagina          number;
  D_riga            number;

  P_da_anno         number;
  P_da_mese         number;
  P_da_mensilita    varchar2(4);
  P_a_anno          number;
  P_a_mese          number;
  P_a_mensilita     varchar2(4);
  P_filtro_1        varchar2(15);
  P_filtro_2        varchar2(15);
  P_filtro_3        varchar2(15);
  P_filtro_4        varchar2(15);

  D_fondo           varchar2(1);
  D_categoria       varchar2(1);
  
  D_nome_file       VARCHAR2(50);

   BEGIN  -- Estrazione Parametri di Selezione della Prenotazione
   
    BEGIN
    select substr(valore,1,4)
      into P_da_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_DA_ANNO'         
    ;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN 
            select anno
              into P_da_anno
              from riferimento_retribuzione
             where rire_id = 'RIRE';
    END;                            
    BEGIN
        select mens.mese
             , substr(valore,1,4)
          into P_da_mese
             , P_da_mensilita
          from mensilita mens,a_parametri
         where no_prenotazione = prenotazione
           and parametro       = 'P_DA_MENSILITA'         
           and mens.mensilita (+) = substr(valore,1,4)  
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN 
              select mese,mensilita
                into P_da_mese
                   , P_da_mensilita
                from riferimento_retribuzione
               where rire_id = 'RIRE';
      END;                            
    BEGIN
    select substr(valore,1,4)
      into P_a_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_A_ANNO'         
    ;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN 
            select anno
              into P_a_anno
              from riferimento_retribuzione
             where rire_id = 'RIRE';
    END;                            
    BEGIN
      select mens.mese
           , substr(valore,1,4)
        into P_a_mese
           , P_a_mensilita
        from mensilita mens,a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_A_MENSILITA'         
         and mens.mensilita (+) = substr(valore,1,4)  
    ;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN 
            select mese,mensilita
              into P_a_mese, P_a_mensilita
              from riferimento_retribuzione
             where rire_id = 'RIRE';
    END;                            
    BEGIN
    select substr(valore,1,15)
      into P_filtro_1               
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_FILTRO_1'     
    ;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
            P_filtro_1 := '%';
    END;
    BEGIN
    select substr(valore,1,15)
      into P_filtro_2               
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_FILTRO_2'     
    ;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
            P_filtro_2 := '%';
    END;
    BEGIN
    select substr(valore,1,15)
      into P_filtro_3               
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_FILTRO_3'     
    ;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
            P_filtro_3 := '%';
    END;
    BEGIN
    select substr(valore,1,15)
      into P_filtro_4               
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_FILTRO_4'     
    ;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
            P_filtro_4 := '%';
    END;
      
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
--      SELECT max(rtrim(ltrim(substr(ad4e.note,instr(ad4e.note,'Cliente=')+8,4))))
      select upper(substr(note,instr(note, 'Cliente=')+8,100))
        into D_note_ente
        from ad4_enti ad4e
       where ente = D_ente
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           D_note_ente  := NULL;
    END;

    BEGIN
      IF instr( D_note_ente, 'ER09') != 0 THEN
         D_Cliente := 'ER09'; -- Asl Reggio
      ELSIF instr( D_note_ente, 'UCHI') != 0 THEN
         D_Cliente := 'UCHI'; -- Asl Chiavari
      ELSIF instr( D_note_ente, 'TO13') != 0 THEN
         D_Cliente := 'TO13'; -- Asl Livorno      
      ELSIF instr( D_note_ente, 'LO11')  != 0 THEN
         D_Cliente := 'LO11'; -- Asl Como      
      ELSIF instr( D_note_ente, 'SI03')  != 0 THEN
         D_Cliente := 'SI03'; -- Asl Catania Giarre 
      ELSIF instr( D_note_ente, 'HGE_S.MART')  != 0 THEN
          D_Cliente := 'HGSM'; -- Ospedale San Martino Genova
      ELSIF instr( D_note_ente, 'SI08')  != 0 THEN
         D_Cliente := 'SI08'; -- Asl Siracusa
      ELSIF instr( D_note_ente, 'ER32')  != 0 THEN
         D_Cliente := 'ER32';  -- Asl Ferrara e Guardie Mediche Gestione Interna
      ELSIF instr( D_note_ente, 'SI06')  != 0 THEN
         D_Cliente := 'SI06';  -- Asl Palermo
      ELSIF instr( D_note_ente, 'CONSBZ')  != 0 THEN
         D_cliente := 'CONSBZ'; -- Asl Bolzano 
      ELSIF instr( D_note_ente, 'INTERNA')  != 0 THEN
         D_Cliente := 'INTERNA';  -- Asl Ferrara Gestione Interna
      ELSE 
         D_cliente := 'ENTE'; -- Default 
      END IF;
    END;
    BEGIN
     IF D_cliente = 'INTERNA' THEN
        select min('ENPAM'||substr(lpad(ci,8,0),1,2)||'.txt')
          into D_nome_file
          from rapporti_giuridici
        ;
        update a_selezioni
           set valore_default = D_nome_file
         where parametro ='TXTFILE'
           and voce_menu = (select voce_menu
                              from a_prenotazioni
                             where no_prenotazione=prenotazione
                           )
         ;
     ELSIF  D_cliente = 'ER32' THEN
        D_nome_file := 'ENPAM.txt';
        update a_selezioni
           set valore_default = D_nome_file
         where parametro ='TXTFILE'
           and voce_menu = (select voce_menu
                              from a_prenotazioni
                             where no_prenotazione=prenotazione
                           )
         ;
     END IF;
    END;    
      D_pagina := 0;
      D_riga   := 0;
    BEGIN
      FOR CUR_MENS IN
         (select mese.anno
               , mens.mese
               , max(mens.mensilita) mensilita
            from mensilita mens
               , mesi mese
           where mese.anno between P_da_anno and P_a_anno
             and mese.mese  = mens.mese
             and mens.tipo in ('N','S','A')
             and lpad(mens.mese,2,0)||rpad(mens.mensilita,4,' ')
                 between lpad(P_da_mese,2,0)||rpad(P_da_mensilita,4,' ')
                     and lpad(P_a_mese,2,0)||rpad(P_a_mensilita,4,' ')
             and exists
                (select 'x' from movimenti_contabili
                  where anno = mese.anno
                    and mese = mens.mese
                    and mensilita = mens.mensilita
                    and (voce,sub) in 
                       (select voce,sub from estrazione_righe_contabili
                         where estrazione = 'DENUNCIA_ENPAM'))
           group by mese.anno,mens.mese
          ) LOOP
         BEGIN
         FOR CUR IN
            (select max(substr(anag.cognome||' '||anag.nome,1,30))        nome
                  , max(to_char(anag.data_nas,'mmyy')) data_nas
                  , anag.codice_fiscale                codice_fiscale
                  , to_char(rden.riferimento,'yyyy')   anno_rif
                  , decode( D_cliente
                          , 'CONSBZ', decode( to_char(rden.riferimento,'yyyymm')
                                            , CUR_MENS.anno||lpad(CUR_MENS.mese,2,0), to_char(add_months(rden.riferimento,-1),'mmyy')
                                                                                    , to_char(rden.riferimento,'mmyy')
                                            )
                                    , decode( to_char(rden.riferimento,'yyyy')
                                            , CUR_MENS.anno, lpad(CUR_MENS.mese,2,0)
                                                           , 12
                                            )||
                                       to_char(rden.riferimento,'yy')
                           ) riferimento
                  , rare.codice_inps                   cod_enpam
                  , sum(rden.col1)                     importo
                  , decode(sign(sum(rden.col1))
                          , 1 ,'+'
                              ,'-')                    segno
                  , rare.ci                            ci
                  , rare.statistico1                   statistico1
                  , rare.statistico2                   statistico2
                  , rare.statistico3                   statistico3
                  , ragi.gestione                      gestione
                  , substr(rain.gruppo,1,1)            gruppo_1
                  , substr(rain.gruppo,2,1)            gruppo_2
               from report_denuncia_enpam  rden
                  , rapporti_retributivi   rare
                  , anagrafici             anag
                  , rapporti_giuridici     ragi
                  , rapporti_individuali   rain
              where anag.ni = rain.ni
                and ( nvl(D_cliente,' ') != 'SI08'
                   or (     nvl(D_cliente,' ') = 'SI08'
                        and rapporto!='CHIM'
                      )
                    ) 
                and anag.al is null
                and rden.anno       = CUR_MENS.anno
                and rden.mese       = CUR_MENS.mese
                and rden.mensilita  = CUR_MENS.mensilita  
                and rain.ci         = rare.ci
                and rden.ci         = rare.ci
                and ragi.ci         = rare.ci
                and nvl(rden.c1,' ') like nvl(P_filtro_1,'%')
                and nvl(rden.c2,' ') like nvl(P_filtro_2,'%')
                and nvl(rden.c3,' ') like nvl(P_filtro_3,'%')
                and nvl(rden.c4,' ') like nvl(P_filtro_4,'%')
                and (   rain.CC IS NULL
                     or exists ( select 'x'
                                   from a_competenze
                                  where ente        = D_ente
                                    and ambiente    = D_ambiente
                                    and utente      = D_utente
                                    and competenza  = 'CI'
                                    and oggetto     = rain.cc
                                )
                   )
              group by rare.ci
                     , anag.codice_fiscale
                     , rare.codice_inps
                     , to_char(rden.riferimento,'yyyy')
                     , decode( D_cliente
                          , 'CONSBZ', decode( to_char(rden.riferimento,'yyyymm')
                                            , CUR_MENS.anno||lpad(CUR_MENS.mese,2,0), to_char(add_months(rden.riferimento,-1),'mmyy')
                                                                                    , to_char(rden.riferimento,'mmyy')
                                            )
                                    , decode( to_char(rden.riferimento,'yyyy')
                                            , CUR_MENS.anno, lpad(CUR_MENS.mese,2,0)
                                                           , 12
                                            )||
                                       to_char(rden.riferimento,'yy')
                           )
                     , rare.statistico1
                     , rare.statistico2
            	 	     , rare.statistico3
                     , ragi.gestione
                     , substr(rain.gruppo,1,1)
                     , substr(rain.gruppo,2,1)
              having sum(rden.col1) != 0
              order by 1
            ) LOOP
              D_fondo  := '';
              D_categoria  := '';
              IF D_cliente = 'SI08' THEN -- determino fondo e categoria per SI08
                BEGIN
                  select max( decode( moco1.sub
                                     ,'2',1
                                     ,'3',1
                                         ,2
                                     )
                              ) fondo,
                          max( decode( moco1.sub
                                     ,'2','D'
                                     ,'3','D'
                                         ,'E'
                                     )
                              ) categoria
                    into D_fondo,D_categoria
                    from movimenti_contabili moco1
                   where moco1.anno = CUR_MENS.anno
                     and moco1.mese = CUR_MENS.mese
                     and moco1.mensilita = CUR_MENS.mensilita
                     and moco1.ci in ( select ci 
                                         from rapporti_retributivi
                                        where codice_inps = CUR.cod_enpam
                                     )
                     and moco1.voce = 'C.ENPAM'     
                  ;
                END;
              ELSIF D_cliente = 'SI06' THEN -- determino fondo e categoria per SI06
                BEGIN
                  select max(decode(moco1.sub
                                   ,'1','1'
                                   ,'4','1' 
                                       ,'2')
                            ) fondo
                       , max(decode(moco1.sub
                                   ,'1','G'
                                   ,'4','G'
                                   ,'3','M'
                                   ,'6','M'
                                       ,'A')
                            ) categoria
                     into D_fondo, D_categoria
                     from movimenti_contabili moco1
                    where moco1.anno = CUR_MENS.anno
                      and moco1.mese = CUR_MENS.mese
                      and moco1.mensilita = CUR_MENS.mensilita
                      and moco1.ci = CUR.ci
                      and moco1.voce = 'C.ENPAM'
                  ;
                END;
              ELSIF D_cliente = 'CONSBZ' THEN -- determino fondo e categoria per CONSBZ
                BEGIN
                 select livello
                      , decode( livello
                              , 'P', '5'
                              , 'G', '1'
                              , 'B', '1'
                              , 'A', '2'
                              , 'O', '2'
                              , 'M', '2'
                              , 'V', '3'
                              , 'S', '3'
                                   , '4'
                              )
                   into D_categoria, D_fondo
                   from qualifiche_giuridiche
                  where numero = (select qualifica from periodi_retributivi
                                   where ci = CUR.ci
                                     and periodo = last_day( to_date(lpad(CUR_MENS.mese,2,0)||
                                                             to_char(CUR_MENS.anno),'mmyyyy'))
                                     and competenza = 'A'
                                 )
                    and last_day( to_date(lpad(CUR_MENS.mese,2,0)||to_char(CUR_MENS.anno),'mmyyyy'))
                        between dal and nvl(al,to_date('3333333','j'))
                 ;
               END;
              ELSIF D_cliente = 'INTERNA' THEN -- determino categoria
               BEGIN
                 select max(decode( figi.codice
                                  , 'DPR409', 'O'
                                  , 'ODOBUD', 'O'
                                  , 'ODOSGIOR', 'O'
                                  , 'ODOSGIOV', 'O'
                                              , decode( sedi.codice
                                                      , '24', 'M'
                                                      , '39', 'M'
                                                      , '40', 'M'
                                                      , '41', 'M'
                                                      , '42', 'M'
                                                      , '44', 'M'
                                                      , '47', 'M'
                                                      , '53', 'M'
                                                      , '54', 'M'
                                                      , '55', 'M'
                                                            , 'A'
                                                       )
                           ) )
                    into D_categoria
                    from ente
                       , rapporti_giuridici ragi
                       , sedi           
                       , figure_giuridiche      figi
                   where ragi.ci = CUR.ci
                     and sedi.numero (+) = ragi.sede
                     and figi.numero (+) = ragi.figura
                  ;
               END;
              ELSIF D_cliente = 'ER09' and D_ente = 'PLMI' THEN -- determino categoria per PMI Reggio
               BEGIN
                 select max(decode( figi.codice
                                  , 'DPR409', 'O'
                                  , 'ODOBUD', 'O'
                                  , 'ODOSGIOR', 'O'
                                  , 'ODOSGIOV', 'O'
                                              , decode( sedi.codice
                                                      , '24', 'M'
                                                      , '39', 'M'
                                                      , '40', 'M'
                                                      , '41', 'M'
                                                      , '42', 'M'
                                                      , '44', 'M'
                                                      , '47', 'M'
                                                      , '53', 'M'
                                                      , '54', 'M'
                                                      , '55', 'M'
                                                            , 'A'
                                                       )
                           ) )
                    into D_categoria
                    from ente
                       , rapporti_giuridici ragi
                       , sedi           
                       , figure_giuridiche      figi
                   where ragi.ci = CUR.ci
                     and sedi.numero (+) = ragi.sede
                     and figi.numero (+) = ragi.figura
                  ;
               END;
              ELSE
                D_fondo  := '';
                D_categoria  := '';
              END IF;

              BEGIN
               D_pagina := D_pagina + 1;
               D_riga   := D_riga   + 1;
                 insert into a_appoggio_stampe
                  values ( prenotazione
                         , passo 
                         , D_pagina
                         , D_riga
                         , decode( D_cliente
                                 , 'ER09', decode(D_ente, 'PLMI', nvl(D_categoria,'G'), 'G')
                                 , 'UCHI', nvl(substr(ltrim(rtrim(CUR.statistico3)),1,1),'G')
                                 , 'TO13', decode(CUR.gestione
                                                 ,'GMED', 'G'
                                                 ,'GMD1', 'G'
                                                 ,'GMD2', 'G'
                                                 ,'GMD3', 'G'
                                                 ,'MSER', 'M'
                                                 ,'AZL' , 'D'
                                                 ,'AZ6' , 'D'
                                                 ,'AZP' , 'D'
                                                        , 'X')
                                 , 'LO11', nvl(substr(ltrim(rtrim(CUR.statistico1)),1,1),'G')
                                 , 'SI03', lpad(nvl(CUR.gruppo_1,' '),1,' ')
                                 , 'HGSM', nvl(substr(ltrim(rtrim(CUR.statistico1)),1,1),'G')
                                 , 'SI08', nvl(D_categoria,'G')
                                 , 'ER32', 'G'
                                 , 'SI06', nvl(D_categoria,'G')
                                 , 'CONSBZ', nvl(D_categoria,'G')
                                 , 'INTERNA', nvl(D_categoria,'G')
                                 , 'ENTE', nvl(D_categoria,'G')
                                         , 'G'
                                 )|| -- categoria
                           decode( D_cliente
                                 , 'ER32','99999'
                                         ,'00000'
                                 )||
                           decode( D_cliente
                                 , 'ER09', decode(D_ente, 'PLMI', '2', '1' )
                                 , 'UCHI', nvl(substr(ltrim(rtrim(CUR.statistico2)),1,1),'1')
                                 , 'TO13', decode(CUR.gestione
                                                 ,'GMED', '1'
                                                 ,'GMD1', '1'
                                                 ,'GMD2', '1'
                                                 ,'GMD3', '1'
                                                 ,'MSER', '2'
                                                 ,'AZL' , '1'
                                                 ,'AZ6' , '1'
                                                 ,'AZP' , '1'
                                                        , '0')
                                 , 'LO11', '1'
                                 , 'SI03', lpad(nvl(CUR.gruppo_2,' '),1,' ')
                                 , 'HGSM', nvl(substr(ltrim(rtrim(CUR.statistico2)),1,1),'1')
                                 , 'SI08', nvl(D_fondo,1)
                                 , 'ER32', '1'
                                 , 'SI06', nvl(D_fondo,1)
                                 , 'CONSBZ', nvl(D_fondo,'G')
                                 , 'INTERNA' , '2'
                                 , 'ENTE' , '2'
                                         , '1'
                                 )|| -- fondo
                           decode( D_cliente
                                 , 'ER09', decode(D_ente
                                                 ,'EPAO', '475' -- Ospedale
                                                 ,'ER09', '440' -- Asl
                                                 ,'PGMU', '440' -- Guardie Mediche Asl
                                                 ,'PLMI', decode(P_filtro_1
                                                                ,'US','440' -- Medici Interni Asl 
                                                                ,'OS','475' -- Medici Interni Ospedale
                                                                     ,'440'
                                                                )
                                                        , '440'
                                                 )
                                 , 'UCHI', '365'
                                 , 'TO13', '399'
                                 , 'LO11', '201'
                                 , 'SI03', '831' -- 003
                                 , 'HGSM', '385'
                                 , 'SI08', '822'
                                 , 'ER32', '462'
                                 , 'SI06', '854'
                                 , 'CONSBZ', decode(sign(to_number(CUR.anno_rif)-2007)
                                                   , -1 ,'277'
                                                        ,'281')
                                 , 'INTERNA', '462'
                                 , 'ENTE', '999'
                                         , '999'
                                 )|| -- ente
                           decode( D_cliente
                                 , 'ER09', 'RE'
                                 , 'UCHI', 'GE'
                                 , 'TO13', 'LI'
                                 , 'LO11', 'CO'
                                 , 'SI03', 'CT'
                                 , 'HGSM', 'GE'
                                 , 'SI08', 'SR'
                                 , 'ER32', 'FE'
                                 , 'SI06', 'PA'
                                 , 'CONSBZ', 'BZ'
                                 , 'INTERNA', 'FE'
                                 , 'ENTE', 'BO'
                                         , 'BO'
                                 )|| -- provincia di versamento
                           CUR.riferimento||
                           rpad(' ',5,' ')||
                           rpad(CUR.nome,30,' ')||
                           CUR.data_nas||
                           rpad(' ',9,' ')||
                           rpad(nvl(CUR.cod_enpam,' '),10,' ')||
                           ' '||
                           decode(valuta
                                 ,'E',substr(translate(to_char(abs(CUR.importo),'99990.00'),'.',','),2,8)
                                     ,lpad(to_char(abs(CUR.importo)),8,'0')
                                 )||
                           CUR.segno||
                           lpad(CUR.codice_fiscale,16,' ')||
                           lpad(to_char(CUR.ci),8,'0')
                     );
                COMMIT;
               END;
           END LOOP; -- cur_ci
         END;
      END LOOP; -- cur_mens
    END;
END;
end;
end PECCSMGM;
/
