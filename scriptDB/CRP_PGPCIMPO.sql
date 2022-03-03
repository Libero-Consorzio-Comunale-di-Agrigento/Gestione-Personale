CREATE OR REPLACE PACKAGE PGPCIMPO IS
/******************************************************************************
 NOME:          crp_pgpcimpo CREAZIONE FILE IMPORTI RETRIBUZIONE
 DESCRIZIONE:   Questa fase produce un file secondo il tracciato INPDAP Importi.txt
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
 2    10/06/2004     AM Revisioni varie a seguito dei test sul Modulo
 3    21/06/2005     CB Aggiunta stampa di controllo   
 3.1  13/07/2005     ML Modifica lettura data di cessazione, per estrarre l'ultima in assoluto
 3.2  08/09/2005     ML Sistemazione passi procedurali
 3.3  03/10/2005     ML esclusione mensilita *AP in lettura dati moco (A12491)
 3.4  05/10/2005     ML aggiunta order by in inre_voci e moco_voci (A12962).
 3.5  11/10/2005  AM-ML sistemata lettura del cod. voce 13ma da DVOS7 e non dalle note di DESRE;
                        filtrate le segnalazioni del voci non definite per like (e non per uguale)
 3.6  19/11/2005     ML Sistemazione determinazione tredicesima (A13678).
 3.7  31/03/2006     ML Gestione colonna Indennita non annualizzabili '02_NA' (A6996).
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number,passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY PGPCIMPO IS
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V3.7 del 31/03/2006';
   END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
begin
DECLARE
  D_primo         number;
  D_dep_cod       varchar2(10);
  D_retribuzione  number;
  D_sum_retrib    number;
  D_intero        number;
  D_gg_lav        number;
  D_anno_cess     number;
  D_ente          varchar2(10);
  P_pagina        number;
  P_riga          number;
  P_ente          varchar2(4);
  P_ambiente      varchar2(8);
  P_utente        varchar2(8);
  P_lingua        varchar2(1);
  P_gestione      varchar2(4);
  P_fisse         varchar2(1);
  P_accessorie    varchar2(1);
  P_tutte         varchar2(1);
  P_dal           date;
  D_voce_13a      varchar2(10);
  D_contratto     varchar2(4);
  D_colonna       varchar2(15);
  conta           number:=0;
  d_app           varchar2(1);
  --
  -- Estrazione Parametri di Selezione della Prenotazione
  --
BEGIN
  BEGIN
    select ente
         , utente
         , ambiente
         , gruppo_ling
      into P_ente,P_utente,P_ambiente,P_lingua
      from a_prenotazioni
     where no_prenotazione = prenotazione
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select substr(valore,1,1)
      into P_fisse
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_FISSE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN P_fisse := 'x';
  END;
  BEGIN
    select substr(valore,1,1)
      into P_tutte
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_TUTTE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN P_tutte := 'x';
  END;
  BEGIN
    select substr(valore,1,1)
      into P_accessorie
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_ACCESSORIE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN P_accessorie := 'x';
  END;
  BEGIN
    select to_date(substr(valore,1,10),'dd/mm/yyyy')
      into P_dal
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_DAL'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN P_dal := to_date('01011940','ddmmyyyy');
  END;
/*
  BEGIN
    select  max(substr(esvc.descrizione,1,2))
      into  P_voce_13a
      from  estrazione_valori_contabili esvc
     where  estrazione = 'PREVIDENZIALE'
       and  colonna    = '03'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN P_voce_13a := '';
  END;
*/
  P_pagina       := 1;
  P_riga         := 1;
  D_retribuzione := 0;
  conta          := 0;
  BEGIN
    FOR DIP IN
       (select i.ci                          ci
             , i.codice_fiscale              cf
             , i.previdenza                  previdenza
          from inpdap i
         order by ci
       ) LOOP
         BEGIN
           select  to_char(al,'yyyy')
                  ,nvl(ceil( months_between( al +1
                                        ,to_date( '0101'||to_char(al,'yyyy')
                                                 ,'ddmmyyyy'
                                                )
                                       )*30
                       ),360)
             into  D_anno_cess
                  ,D_gg_lav
             from  periodi_giuridici       pegi
            where  rilevanza     = 'P'
              and  ci            = DIP.ci
              and  dal           =
                  (select max(dal) from periodi_giuridici
                    where ci         = DIP.ci
                      and rilevanza  = 'P'
                      and dal       <= sysdate
                  )
            ;
--         EXCEPTION WHEN NO_DATA_FOUND THEN D_anno_cess := null;
--                                           D_gg_lav    := 360;
         END;

         BEGIN
           FOR PERIODI IN
           (select  distinct
                    greatest(P_dal,dal)                             inizio
                   ,to_date('0101'||to_char(dal,'yyyy'),'ddmmyyyy') ini_anno
                   ,to_date('3112'||to_char(dal,'yyyy'),'ddmmyyyy') fin_anno
                   ,to_number(to_char(dal,'yyyy'))                  anno
              from  informazioni_retributive        inre
             where  inre.ci                       = DIP.ci
               and  inre.dal                     >= to_date('01011993','ddmmyyyy')
--               and  inre.dal                     >= P_dal
               and  nvl(inre.al,to_date('3333333','j')) >= P_dal
               and  inre.voce in
                   (select voce
                      from estrazione_righe_contabili
                     where estrazione     = 'PREVIDENZIALE'
                       and colonna        = '01'
                       and inre.dal between dal
                                        and nvl(al,to_date('3333333','j'))
                   )
             union
            select  ini_mese                         inizio
                   ,to_date('0101'||anno,'ddmmyyyy') ini_anno
                   ,to_date('3112'||anno,'ddmmyyyy') fin_anno
                   ,anno                             anno
              from  mesi
             where  mese                  = 1
               and  anno                 >= 1993
               and  ini_mese             >= P_dal
               and  ini_mese             >=
                   (select min(dal)
--                      from rapporti_individuali
                      from periodi_giuridici
                     where ci             = DIP.ci
                   )
               and  ini_mese              < to_date('3112'||nvl(D_anno_cess,to_char(sysdate,'yyyy')),'ddmmyyyy')
             order  by 1
           ) LOOP

             BEGIN
               select  decode( DIP.previdenza,'CPDEL',gest.posizione_cpd
                                                     ,gest.posizione_cps
                             )
                 into  D_ente
                 from  gestioni                    gest
                where  codice =
                      (select gestione
                         from periodi_giuridici
                        where ci                 = DIP.ci
                          and rilevanza          = 'Q'
                          and PERIODI.inizio  between dal
                                               and nvl(al,to_date('3333333','j')
                                                      )
                      )
               ;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 BEGIN
                    select  substr(presso,1,8)
                      into  D_ente
                      from  documenti_giuridici    dogi
                     where  ci                   = DIP.ci
                       and  evento               = 'SSON'
                       and  scd                  = '0'
                       and  PERIODI.inizio  between dal
                                             and nvl(al,to_date('3333333','j'))
                    ;
                 exception
                 when no_data_found then null;
                 END;
             END;

-- CONTRATTO DI LAVORO
          BEGIN
          select distinct contratto
          into D_contratto
          from qualifiche_giuridiche qugi, periodi_giuridici pegi
           where qugi.numero  = pegi.qualifica
           and pegi.rilevanza = 'S'
           and ci             = DIP.ci
           and PERIODI.inizio  between qugi.dal and nvl(qugi.al,to_date('3333333','j')
                                                     )
           and PERIODI.inizio  between pegi.dal and nvl(pegi.al,to_date('3333333','j')
                                                     )
          ;
          exception
           when no_data_found then null;
          END;
          D_primo := 0;
          D_sum_retrib := 0;
             BEGIN
               FOR VOCI_INRE IN
              (select distinct
                      voec.codice               voce
                     ,vos7.codice               D_voce
               FROM         voci_economiche           voec,
                            voci_contabili            voco,
                            voci_inpdap               vos7
               WHERE voco.voce                           like vos7.voce_gp4
               and voco.sub                            like vos7.sub_gp4
               and nvl(voco.dal, to_date('2222222','j')) <= nvl(vos7.al, to_date('3333333','j'))
               and nvl(voco.al, to_date('3333333','j'))  >= nvl(vos7.dal, to_date('2222222','j'))
               and PERIODI.inizio                   between nvl(vos7.dal,to_date('2222222','j'))
                                                        and nvl(vos7.al,to_date('3333333','j'))
               and D_contratto                         like vos7.contratto_gp4
               and voec.codice                            = voco.voce
               and (    P_fisse           = 'X'
                    or  P_tutte           = 'X'
                   )
   and exists
      (select 'x' from informazioni_retributive
        where ci    = DIP.ci
          and voce  = voco.voce
          and sub   = voco.sub
          and PERIODI.inizio between nvl(dal,to_date('2222222','j'))
                                                 and nvl(al,to_date('3333333','j'))
      )
  and exists
      (select 'x' from estrazione_righe_contabili
        where estrazione = 'PREVIDENZIALE'
          and colonna    = '01'
          and PERIODI.inizio between nvl(dal,to_date('2222222','j'))
                                                 and nvl(al,to_date('3333333','j'))
          and voce = voco.voce
          and sub = voco.sub)
      order by 2
      )  LOOP
           IF D_primo = 0 THEN
              D_primo:= 1;
              D_dep_cod := VOCI_INRE.D_voce;
           END IF;
           IF D_dep_cod != VOCI_INRE.D_voce THEN
             BEGIN
               insert into a_appoggio_stampe
               (no_prenotazione,no_passo,pagina,riga,testo)
               select prenotazione
                    , 1
                    , P_pagina
                    , P_riga
                    , DIP.cf||
                      RPAD('1',3,' ')||
                      lpad(to_char(PERIODI.inizio,'dd/mm/yyyy'),10,'0')||
                      '1'||
                      rpad(nvl(D_ente,' '),8,' ')||
                      rpad(nvl(D_dep_cod,' '),11,' ')||
                      rpad((translate(D_sum_retrib,'.',',')),21,' ') ||
                      lpad(to_char(DIP.ci),8,'0')
                 from dual
               where D_sum_retrib > 0
               ;
               P_riga := P_riga + 1 ;
             END;
              D_sum_retrib :=0;
              D_dep_cod := VOCI_INRE.D_voce;
          END IF;
           BEGIN
      select sum(
             ( decode( esrc.tipo
                      ,'I', inre.tariffa
                          , 0
                     ) * decode(esrc.segno1,'*',esrc.dato1,'%',esrc.dato1,1)
                       / decode(esrc.segno1,'/',esrc.dato1,'%',100,1)
                       + decode(esrc.segno1,'+',esrc.dato1,'-',esrc.dato1*-1,0)
             ) * decode(esrc.segno2,'*',esrc.dato2,'%',esrc.dato2,1)
               / decode(esrc.segno2,'/',esrc.dato2,'%',100,1)
               + decode(esrc.segno2,'+',esrc.dato2,'-',esrc.dato2*-1,0)
                )                        retribuzione
        into D_retribuzione
        FROM estrazione_righe_contabili  esrc,
             voci_economiche             voec,
             informazioni_retributive    inre
       where inre.ci                   = DIP.ci
         and inre.voce                 = VOCI_INRE.voce
         and inre.voce                 = esrc.voce
         and inre.sub                  = esrc.sub
         and PERIODI.inizio      between nvl(inre.dal,to_date('2222222','j'))
                                     and nvl(inre.al,to_date('3333333','j'))
         and PERIODI.inizio      between nvl(esrc.dal,to_date('2222222','j'))
                                     and nvl(esrc.al,to_date('3333333','j'))
         and esrc.estrazione ||''      = 'PREVIDENZIALE'
         and esrc.colonna              = '01'
         and voec.codice               = inre.voce
      ;
         D_sum_retrib := d_sum_retrib + D_retribuzione;
       END;
           END LOOP; -- VOCI_INRE

             BEGIN
               insert into a_appoggio_stampe
               (no_prenotazione,no_passo,pagina,riga,testo)
               select prenotazione
                    , 1
                    , P_pagina
                    , P_riga
                    , DIP.cf||
                      RPAD('1',3,' ')||
                      lpad(to_char(PERIODI.inizio,'dd/mm/yyyy'),10,'0')||
                      '1'||
                      rpad(nvl(D_ente,' '),8,' ')||
                      rpad(nvl(D_dep_cod,' '),11,' ')||
                      rpad((translate(D_sum_retrib,'.',',')),21,' ') ||
                      lpad(to_char(DIP.ci),8,'0')
                 from dual
                where D_sum_retrib > 0
               ;
               P_riga := P_riga + 1 ;
             END;
--
-- Tredicesima
--
    BEGIN
      select vos7.codice
           , sum(
             ( decode( esrc.tipo
                      ,'I', moco.imp
                          , 0
                     ) * decode(esrc.segno1,'*',esrc.dato1,'%',esrc.dato1,1)
                       / decode(esrc.segno1,'/',esrc.dato1,'%',100,1)
                       + decode(esrc.segno1,'+',esrc.dato1,'-',esrc.dato1*-1,0)
             ) * decode(esrc.segno2,'*',esrc.dato2,'%',esrc.dato2,1)
               / decode(esrc.segno2,'/',esrc.dato2,'%',100,1)
               + decode(esrc.segno2,'+',esrc.dato2,'-',esrc.dato2*-1,0)
                )                        retribuzione
        into D_voce_13a, D_retribuzione
        FROM estrazione_righe_contabili  esrc,
             movimenti_contabili         moco,
             voci_inpdap                 vos7
       where esrc.voce like vos7.voce_gp4
         and esrc.sub like vos7.sub_gp4
         and nvl(esrc.dal, to_date('2222222','j')) <= nvl(vos7.al, to_date('3333333','j'))
         and nvl(esrc.al, to_date('3333333','j')) >= nvl(vos7.dal, to_date('2222222','j'))
         and PERIODI.inizio      between nvl(vos7.dal,to_date('2222222','j'))
                                     and nvl(vos7.al,to_date('3333333','j'))
         and D_contratto            like vos7.contratto_gp4
         and moco.ci                   = DIP.ci
         and moco.mensilita           != '*AP'
         and moco.voce                 = esrc.voce
         and moco.sub                  = esrc.sub
         and moco.riferimento    between PERIODI.ini_anno and PERIODI.fin_anno
         and PERIODI.inizio      between nvl(esrc.dal,to_date('2222222','j'))
                                     and nvl(esrc.al,to_date('3333333','j'))
         and esrc.estrazione           = 'PREVIDENZIALE'
         and esrc.colonna              = '03'
        group by vos7.codice
      ;
    EXCEPTION WHEN NO_DATA_FOUND THEN
                   D_voce_13a     := '';
                   D_retribuzione := 0;
              WHEN TOO_MANY_ROWS THEN
                   conta:=conta+1;   
                   insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo,errore)
                                              values( prenotazione,1,conta,'P04093');
    commit;
        
    END;
             BEGIN
               insert into a_appoggio_stampe
               (no_prenotazione,no_passo,pagina,riga,testo)
               select prenotazione
                    , 1
                    , P_pagina
                    , P_riga
                    , DIP.cf||
                      RPAD('1',3,' ')||
                      lpad(to_char(PERIODI.inizio,'dd/mm/yyyy'),10,'0')||
                      '1'||
                      rpad(nvl(D_ente,' '),8,' ')||
                      rpad(nvl(D_voce_13a,' '),11,' ')||
                      rpad(translate(D_retribuzione,'.',','),21,' ') ||
                      lpad(to_char(DIP.ci),8,'0')
                 from dual
                where D_retribuzione > 0
               ;
               P_riga := P_riga + 1 ;
           END;
          D_primo := 0;
          D_sum_retrib := 0;
               FOR VOCI_MOCO IN
     (select distinct
             voec.codice               voce
            ,vos7.codice               D_voce
        FROM voci_economiche             voec,
             voci_contabili              voco,
             voci_inpdap                 vos7
       where voco.voce like vos7.voce_gp4
         and voco.sub like vos7.sub_gp4
         and nvl(voco.dal, to_date('2222222','j')) <= nvl(vos7.al, to_date('3333333','j'))
         and nvl(voco.al, to_date('3333333','j')) >= nvl(vos7.dal, to_date('2222222','j'))
         and PERIODI.inizio      between nvl(vos7.dal,to_date('2222222','j'))
                                     and nvl(vos7.al,to_date('3333333','j'))
         and D_contratto            like vos7.contratto_gp4
         and voec.codice               = voco.voce
         and exists
            (select 'x' from movimenti_contabili
              where ci     = DIP.ci
                and voce   = voco.voce
                and sub    = voco.sub
                and riferimento    between PERIODI.ini_anno and PERIODI.fin_anno
            )
         and exists
            (select 'x' from estrazione_righe_contabili
              where estrazione = 'PREVIDENZIALE'
                and colonna    like '02%'
                and voce       = voco.voce
                and sub        = voco.sub
                and PERIODI.inizio      between nvl(dal,to_date('2222222','j'))
                                            and nvl(al,to_date('3333333','j'))
             )
         and (    P_accessorie         = 'X'
              or  P_tutte              = 'X'
             )
       order by 2
      )  LOOP
           IF D_primo = 0 THEN
              D_primo:= 1;
              D_dep_cod := VOCI_MOCO.D_voce;
           END IF;
           IF D_dep_cod != VOCI_MOCO.D_voce THEN
             BEGIN
               insert into a_appoggio_stampe
               (no_prenotazione,no_passo,pagina,riga,testo)
               select prenotazione
                    , 1
                    , P_pagina
                    , P_riga
                    , DIP.cf||
                      RPAD('1',3,' ')||
                      lpad(to_char(PERIODI.inizio,'dd/mm/yyyy'),10,'0')||
                      '1'||
                      rpad(nvl(D_ente,' '),8,' ')||
                      rpad(nvl(D_dep_cod,' '),11,' ')||
                      rpad(translate(D_sum_retrib,'.',','),21,' ') ||
                      lpad(to_char(DIP.ci),8,'0')
                 from dual
                where D_sum_retrib > 0
               ;
               P_riga := P_riga + 1 ;
             END;
              D_sum_retrib :=0;
              D_dep_cod := VOCI_MOCO.D_voce;
           END IF;
           BEGIN
      select sum(
             ( decode( esrc.tipo
                      ,'I', moco.imp
                          , 0
                     ) * decode(esrc.segno1,'*',esrc.dato1,'%',esrc.dato1,1)
                       / decode(esrc.segno1,'/',esrc.dato1,'%',100,1)
                       + decode(esrc.segno1,'+',esrc.dato1,'-',esrc.dato1*-1,0)
             ) * decode(esrc.segno2,'*',esrc.dato2,'%',esrc.dato2,1)
               / decode(esrc.segno2,'/',esrc.dato2,'%',100,1)
               + decode(esrc.segno2,'+',esrc.dato2,'-',esrc.dato2*-1,0)
                )                        retribuzione
            ,sum(moco.imp)               intero
            ,max(esrc.colonna)           colonna
        into D_retribuzione
            ,D_intero
            ,D_colonna
        FROM estrazione_righe_contabili  esrc,
             movimenti_contabili         moco
       where moco.ci                   = DIP.ci
         and moco.mensilita           != '*AP'
         and moco.voce                 = VOCI_MOCO.voce
         and moco.voce                 = esrc.voce
         and moco.sub                  = esrc.sub
         and moco.riferimento    between PERIODI.ini_anno and PERIODI.fin_anno
         and PERIODI.inizio      between nvl(esrc.dal,to_date('2222222','j'))
                                     and nvl(esrc.al,to_date('3333333','j'))
         and esrc.estrazione ||''      = 'PREVIDENZIALE'
         and esrc.colonna              like  '02%'
      ;
      END;
       IF D_colonna = '02' THEN 
             BEGIN
             IF  D_gg_lav <> 360 THEN
               IF D_anno_cess = PERIODI.anno THEN
                 D_retribuzione := e_round(D_intero/D_gg_lav*360,'I');
               END IF;
             END IF;
             END;
       END IF;
         D_sum_retrib := d_sum_retrib + D_retribuzione;
         END LOOP; -- VOCI_MOCO

             BEGIN
               insert into a_appoggio_stampe
               (no_prenotazione,no_passo,pagina,riga,testo)
               select prenotazione
                    , 1
                    , P_pagina
                    , P_riga
                    , DIP.cf||
                      RPAD('1',3,' ')||
                      lpad(to_char(PERIODI.inizio,'dd/mm/yyyy'),10,'0')||
                      '1'||
                      rpad(nvl(D_ente,' '),8,' ')||
                      rpad(nvl(D_dep_cod,' '),11,' ')||
                      rpad(translate(D_sum_retrib,'.',','),21,' ') ||
                      lpad(to_char(DIP.ci),8,'0')
                 from dual
                where D_sum_retrib > 0
               ;
               P_riga := P_riga + 1 ;
             END;
         END;
         END LOOP; -- PERIODI

         P_pagina := P_pagina + 1;
         P_riga   := 1           ;
         END;
         END LOOP; -- DIP--

  FOR CUR_ESRC in
   (select esrc.voce,
           esrc.sub,
           esrc.dal,
           esrc.al
    from   estrazione_righe_contabili esrc
    where  esrc.estrazione='PREVIDENZIALE'
    and    not exists (select 'x'
                       from   voci_inpdap vos7
                       where  esrc.voce like vos7.voce_gp4
                       and    esrc.sub like vos7.sub_gp4
                       and    nvl(esrc.dal,to_date('2222222','j')) <= nvl(vos7.al, to_date('3333333', 'j'))
                       and    nvl(vos7.dal, to_date('2222222', 'j')) <= nvl(esrc.al, to_date('3333333', 'j'))
                      )
   )
   LOOP
       conta:=conta+1;   
       insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                       ,errore,precisazione)
      values( prenotazione,1,conta,'P04092',
             'Voce/Sub '||lpad(CUR_ESRC.voce,10,' ')||' / '||lpad(CUR_ESRC.sub,4,' '));
    commit;
  END LOOP;
/*
  begin
     select 'x' 
     into   D_app
     from   a_segnalazioni_errore
     where  no_prenotazione=prenotazione;
     raise  too_many_rows;
     exception
      when no_data_found then 
            update a_prenotazioni
           set prossimo_passo    = 93
           where no_prenotazione = prenotazione  ;
      when too_many_rows then
           update a_prenotazioni
           set prossimo_passo    = 91,
           errore                = 'P05808'
           where no_prenotazione = prenotazione;
    end;
*/  -- gestito attraverso i passi procedurali
    commit;
  END;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
END;
end;
END;
/

