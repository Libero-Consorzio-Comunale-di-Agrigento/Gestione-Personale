CREATE OR REPLACE PACKAGE PECCSR18 IS
/******************************************************************************
 NOME:        PECCADMI
 DESCRIZIONE: Creazione delle registrazioni individuali per la
              produzione della dichiarazione di Disoccupazione
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  Il PARAMETRO P_tipo     determina il tipo di elaborazione da effettuare.
 REVISIONI:
 Rev. Data       Autore   Descrizione
 ---- ---------- ------   --------------------------------------------------------
 1.0  17/10/2006 GM       Prima emissione
 1.1  23/10/2006 GM       Aggiunta Campo DATA_RICHIESTA
 1.2  08/03/2006 GM       Revisione per richieste di Milano
 1.3  25/05/2007 GM       Suddivisione personale appartenente ad un'unica gestione su più gestioni "figurative"
 1.4  13/06/2007 GM       Assestamenti per Firenze
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN   (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCSR18 IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.4 del 13/06/2007';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
D_ente            varchar2(4);
D_ambiente        varchar2(8);
D_utente          varchar2(8);
D_tipo            varchar2(1);
D_tipo_giorno     varchar2(1);
D_temp            varchar2(1);
D_ci              rapporti_individuali.ci%type;
D_sede            periodi_giuridici.sede%type;
D_gestione_alternativa gestioni.codice%type;
TOT_assenze       number;
D_richiesta       date;
D_ini_rich        date;
D_fin_rich        date;
D_venpre          date;
D_lunpre          date;
D_tempdata        date;
D_anno            number(4);
D_gg_lav          number(3);
D_gg_nlav         number(3);
D_rap_orario      number;
D_retr_mens_gio   number;
D_tredicesima_gio number;
D_lavorati        number;
D_gg_incidenza    number;
D_gg_assenza      number;
D_esiste_fest     number;
D_retribuzione    number(12,2) :=0;
D_retribuzione_spe number(12,2) :=0;
D_ass_fam         number(12,2) :=0;
D_gg_lavoro        periodi_retributivi.gg_con%type;
D_gg_con           periodi_retributivi.gg_con%type;
D_gg_af            periodi_retributivi.gg_af%type;
D_gg_ret           periodi_retributivi.gg_inp%type;
istruzione        varchar2(2000);
D_componi         varchar2(100);
/* Crea Griglia */
type type_giorno is record
 (giorno varchar2(2) := null);
type list_giorni  is table of type_giorno index by binary_integer;
wgiorni   list_giorni;
i         integer;
giorno    number(2);
BEGIN
-- Estrazione Parametri di Selezione
   BEGIN
     select ente     D_ente
          , utente   D_utente
          , ambiente D_ambiente
       into D_ente, D_utente, D_ambiente
       from a_prenotazioni
      where no_prenotazione = prenotazione
     ;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
       D_ente     := null;
       D_ambiente := null;
       D_utente   := null;
   END;
   BEGIN
    select to_number(valore)
       into D_ci
       from a_parametri
      where no_prenotazione = prenotazione
        and parametro    = 'P_CI'
     ;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
    D_ci := to_number(null);
   END;
   BEGIN
     SELECT valore
       INTO D_tipo
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro       = 'P_TIPO'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_tipo := 'T';
   END;
   BEGIN
    select to_date(valore,'dd/mm/yyyy')
          ,to_date('0101'||(to_char(to_date(valore,'dd/mm/yyyy'),'yyyy')-1),'ddmmyyyy')
          ,to_date('3112'||(to_char(to_date(valore,'dd/mm/yyyy'),'yyyy')-1),'ddmmyyyy')  
          ,to_number(to_char(to_date(valore,'dd/mm/yyyy'),'yyyy')-1) 
      into D_richiesta
          ,D_ini_rich
          ,D_fin_rich
          ,D_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_RICHIESTA'
     ;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
     D_richiesta := sysdate;
     D_ini_rich  := to_date('0101'||(to_char(sysdate,'yyyy')-1),'ddmmyyyy');
     D_fin_rich  := to_date('3112'||(to_char(sysdate,'yyyy')-1),'ddmmyyyy');
     D_anno      := to_number(to_char(sysdate,'yyyy')-1);
   END;
   --dbms_output.put_line('Richiesta '||D_richiesta||' inizio '||D_ini_rich||' fine '||D_fin_rich);
   BEGIN
     FOR CUR_CI IN (
       select distinct pegi.ci      ci
                      ,'SR18'       modello
         from periodi_giuridici pegi
             ,rapporti_individuali rain
       where rilevanza = 'P' 
         and rain.ci = pegi.ci
         and pegi.dal      <= D_fin_rich
         and pegi.al       >= D_ini_rich
         and nvl(pegi.al,to_date('3333333','J')) != to_date('3333333','J')
          and (rain.cc is null
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
          and ( D_tipo = 'T'
                   or ( D_tipo in ('I','V','P')
                        and ( not exists (select 'x' from dichiarazione_dis
                                         where ci       = pegi.ci
                                           and nvl(tipo_agg,' ') = decode(D_tipo
                                                                         ,'P',tipo_agg
                                                                         ,D_tipo)
                                          union
                                           select 'x' from dichiarazione_dis_assenze
                                         where ci   = pegi.ci
                                           and nvl(tipo_agg,' ') = decode(D_tipo
                                                                         ,'P',tipo_agg
                                                                         ,D_tipo)
                                          union
                                          select 'x' from dichiarazione_dis_importi
                                         where ci   = pegi.ci

                                           and nvl(tipo_agg,' ') = decode(D_tipo
                                                                         ,'P',tipo_agg
                                                                         ,D_tipo)
                                       )
                            )
                      )
                   or ( D_tipo  = 'S'
                        and pegi.ci = D_ci )
                 )    
     ) LOOP
   BEGIN               
     --dbms_output.put_line('Cursore dei CI '||CUR_CI.ci||' modello '||CUR_CI.modello);
        -- fase di cancellazione
        BEGIN
         LOCK TABLE dichiarazione_dis_importi IN EXCLUSIVE MODE NOWAIT;
         DELETE
           FROM dichiarazione_dis_importi
          WHERE ci = CUR_CI.ci
      AND modello = 'SR18'
         ;
         LOCK TABLE dichiarazione_dis IN EXCLUSIVE MODE NOWAIT;
         DELETE
           FROM dichiarazione_dis
          WHERE ci = CUR_CI.ci
      AND modello = 'SR18'
         ;
         COMMIT;
        END;   
   END;                     
   BEGIN   
     FOR CUR_PEGI IN (
       select pegi_p.ci              ci
             ,pegi_s.gestione        gestione
             ,greatest(pegi_p.dal,D_ini_rich) data_assunzione
             ,pegi_p.al              data_interruzione
             ,pegi_s.qualifica       qualifica
             ,pegi_s.posizione       posizione
             ,qugi.descrizione       des_qualifica
             ,qugi.contratto         cod_contratto
             ,qual.qua_inps          qual_inps
             ,posi.tempo_determinato tempo_determinato
             ,posi.part_time         part_time
             ,posi.tipo_part_time    tipo_part_time
             ,posi.stagionale        stagionale
             ,cost.ore_lavoro        cont_ore
             ,pegi_p.posizione       evento_interruzione
             ,decode(nvl(pegi_p.posizione,' '),' ','In costanza di rapporto al 31/12/'||to_char(D_anno)
                                         , decode(sign(D_fin_rich - pegi_p.al),'-1','In costanza di rapporto al 31/12/'||to_char(D_anno)          
                                                  ,evra.descrizione)) motivo_interruzione
             ,evra.inps              int_inps
             ,pegi_s.sede            sede
         from periodi_giuridici      pegi_s
            , periodi_giuridici      pegi_p
            , qualifiche_giuridiche  qugi
            , qualifiche             qual
            , posizioni              posi
            , contratti_storici      cost
            , eventi_rapporto        evra
        where pegi_p.rilevanza = 'P'
          and pegi_s.rilevanza = 'S'
          and pegi_s.ci        = pegi_p.ci
          and pegi_p.ci        = CUR_CI.ci
          and pegi_p.dal      <= D_fin_rich
          and nvl(pegi_p.al,to_date('3333333','J')) >= D_ini_rich
          and nvl(pegi_p.al,to_date('3333333','J')) between pegi_s.dal
                               and nvl(pegi_s.al,to_date('3333333','J'))
          and qual.numero      = qugi.numero
          and pegi_s.qualifica = qual.numero
          and pegi_s.dal       between nvl(qugi.dal,to_date('2222222','j'))
                               and nvl(qugi.al,to_date('3333333','j'))
          and posi.codice      = pegi_s.posizione
          and qugi.contratto   = cost.contratto
          and pegi_s.dal       between cost.dal
                               and nvl(cost.al,to_date('3333333','j'))
          and pegi_p.posizione = evra.codice (+)
          and evra.rilevanza (+) = 'T'
  union
       select pegi_s.ci              ci
             ,pegi_s.gestione        gestione
             ,greatest(pegi_s.dal,D_ini_rich) data_assunzione
             ,pegi_s.al              data_interruzione
             ,pegi_s.qualifica       qualifica
             ,pegi_s.posizione       posizione
             ,qugi.descrizione       des_qualifica
             ,qugi.contratto         cod_contratto
             ,qual.qua_inps          qual_inps
             ,posi.tempo_determinato tempo_determinato
             ,posi.part_time         part_time
             ,posi.tipo_part_time    tipo_part_time
             ,posi.stagionale        stagionale
             ,cost.ore_lavoro        cont_ore    
             ,evra.codice            evento_interruzione
             ,decode(nvl(evra.codice,' '),' ','In costanza di rapporto al 31/12/'||to_char(D_anno)
                                         , decode(sign(D_fin_rich - pegi_s.al),'-1','In costanza di rapporto al 31/12/'||to_char(D_anno)          
                                                  ,evra.descrizione)) motivo_interruzione
             ,evra.inps              int_inps
             ,pegi_s.sede            sede 
      from periodi_giuridici pegi_s
         , periodi_giuridici pegi_p
         , eventi_rapporto   evra 
         , contratti_storici cost
         , qualifiche_giuridiche qugi
         , posizioni             posi
         , qualifiche            qual
        where pegi_s.rilevanza = 'S'
    and pegi_p.rilevanza = 'P'
          and pegi_p.dal       = (select max(dal) 
                              from periodi_giuridici
           where ci = CUR_CI.ci 
             and rilevanza = 'P' 
                               and pegi_p.dal                            <= D_fin_rich
                                     and nvl(pegi_p.al,to_date('3333333','J')) >= D_ini_rich)  
    and pegi_p.ci        = CUR_CI.ci
          and pegi_s.ci        = CUR_CI.ci
          and pegi_s.dal      <= D_fin_rich
          and nvl(pegi_s.al,to_date('3333333','J')) >= D_ini_rich
          and qual.numero      = qugi.numero
          and pegi_s.qualifica = qual.numero
          and pegi_s.dal       between nvl(qugi.dal,to_date('2222222','j'))
                               and nvl(qugi.al,to_date('3333333','j'))
          and posi.codice      = pegi_s.posizione
          and qugi.contratto   = cost.contratto
          and pegi_s.dal       between cost.dal
                               and nvl(cost.al,to_date('3333333','j'))
          and pegi_p.posizione = evra.codice (+)
          and evra.rilevanza (+) = 'T'
    and not exists (select 'x' 
                      from periodi_giuridici 
                     where ci = pegi_s.ci 
           and rilevanza = 'P'
        and dal <= pegi_s.dal
        and nvl(al,to_date('3333333','j')) >= nvl(pegi_s.al,to_date('3333333','j'))
          )

      ) LOOP
        --dbms_output.put_line('Periodo '||CUR_PEGI.data_assunzione||' al '||CUR_PEGI.data_interruzione ||' int_inps ' ||CUR_PEGI.int_inps);
        D_sede := CUR_PEGI.sede;
  /* Decodifico Gestione Alternativa */
  BEGIN
    select gestione
      into D_gestione_alternativa
      from def_gestione_denunce gede
     where gede.contratto = CUR_PEGI.cod_contratto
       and gede.posizione = CUR_PEGI.posizione
    ;   
  EXCEPTION
    when no_data_found then
      D_gestione_alternativa := to_char(null);
  END;
        BEGIN
          INSERT INTO DICHIARAZIONE_DIS
             ( ddis_id, gestione, ci, qua_inps
             , tempo_determinato, stagionale
             , part_time, tipo_part_time
             , cont_ore, data_ass, data_int
             , int_inps, mot_int, imp_compl, gg_lav
             , imp_gior, gg_mot1, gg_mot2, gg_mot3
             , gg_mot4, gg_mot5, gg_mot6, gg_mot7
             , utente, tipo_agg, data_agg, modello, data_richiesta, gestione_alternativa)
          SELECT DDIS_SQ.nextval, CUR_PEGI.gestione, CUR_CI.CI, CUR_PEGI.qual_inps
               , CUR_PEGI.tempo_determinato, CUR_PEGI.stagionale
               , CUR_PEGI.part_time, CUR_PEGI.tipo_part_time
               , CUR_PEGI.cont_ore, CUR_PEGI.data_assunzione, CUR_PEGI.data_interruzione
               , CUR_PEGI.int_inps, CUR_PEGI.motivo_interruzione, to_number(null), to_number(null)
               , to_number(null) , to_number(null), to_number(null), to_number(null)
               , to_number(null) , to_number(null), to_number(null), to_number(null)
               , D_utente, null, sysdate, CUR_CI.modello, D_richiesta, D_gestione_alternativa
            FROM DUAL;
          commit;
        END;
      END LOOP CUR_PEGI;
   END;
     -- Elaboro Calendario
  BEGIN
      --dbms_output.put_line('inizio gestione mesi '||CUR_PEGI.sede ||' '||D_anno);
      BEGIN
        FOR CUR_MESI in
       (select mese
          , giorni
             , to_date('01'||lpad(to_char(mese),2,'0')||to_char(anno),'ddmmyyyy') dal
             , last_day(to_date('01'||lpad(to_char(mese),2,'0')||to_char(anno),'ddmmyyyy')) al
       , anno
       from calendari cale        
      where cale.anno = D_anno
  and (cale.calendario  = (select calendario from sedi where sedi.numero = D_sede)
       or cale.calendario = '*')
      order by mese
    ) LOOP
        D_retribuzione := 0;
        D_retribuzione_spe := 0;
        D_ass_fam := 0;
        D_gg_lav := 0;
        D_gg_nlav := 0;
  D_gg_lavoro    := 0;
  D_gg_con  := 0;
  D_gg_af   := 0;
        BEGIN
        --dbms_output.put_line('Dentro CUR_MESI '||to_char(CUR_MESI.anno) ||' '||to_char(CUR_MESI.mese));
       -- Resetto per cambio mese
       for i in 1..31 loop
         wgiorni(i).giorno := '--';
       end loop; 
       D_gg_lav := 0;
       -- Segno i giorni lavorati  
       BEGIN
         FOR CUR_GIORNI in
         (select pegi.dal PEGI_DAL
                ,pegi.al  PEGI_AL
                ,greatest(pegi.dal,CUR_MESI.dal) dal
                ,least(nvl(pegi.al,to_date('3333333','J')),nvl(CUR_MESI.al,to_date('3333333','J')),D_fin_rich) al
            from periodi_giuridici pegi
           where rilevanza = 'S'
             and pegi.dal <= nvl(CUR_MESI.al,to_date('3333333','J'))
             and nvl(pegi.al,to_date('3333333','J'))  >= CUR_MESI.dal
             and ci = CUR_CI.ci
           order by dal  
      ) LOOP
          --dbms_output.put_line('CI '||CUR_CI.ci ||' Dentro CUR_GIONI '||to_char(CUR_GIORNI.dal) ||' '||to_char(CUR_GIORNI.al));
          for giorno in to_number(to_char(CUR_GIORNI.dal,'dd'))..to_number(to_char(CUR_GIORNI.al,'dd')) Loop
            wgiorni(giorno).giorno := rpad('X',2,' ');         
          end loop;
        END LOOP CUR_GIORNI;
       END; 
       -- Segno le assenze
       BEGIN
         FOR CUR_ASSENZE in
         (select pegi.dal PEGI_DAL
                ,pegi.al  PEGI_AL
                ,greatest(pegi.dal,CUR_MESI.dal) dal
                ,least(pegi.al,CUR_MESI.al) al
                ,disoccupazione_inps
            from periodi_giuridici pegi
                ,astensioni        aste
           where rilevanza    = 'A'
             and pegi.dal    <= CUR_MESI.al
             and pegi.al     >= CUR_MESI.dal
             and pegi.assenza = aste.codice
             and ci = CUR_CI.ci
         union
-- aggiunte le assenze a ore presenti su AVARI e identificate tra le voci con la nota
-- [ASSENZA DS INPS nn]  dove nn è il codice per la disoccupazione INPS (se < 10 indicare n+spazio)
          select asso.dal asso_DAL
                ,asso.al  asso_AL
                ,greatest(asso.dal,CUR_MESI.dal) dal
                ,least(asso.al,CUR_MESI.al) al
                ,to_number(disoccupazione_inps) disoccupazione_inps
            from assenze_a_ore asso
           where asso.dal    <= CUR_MESI.al
             and asso.al     >= CUR_MESI.dal
             and ci = CUR_CI.ci
             and asso.giorni >= 1
           order by 1
      ) LOOP
          for giorno in to_number(to_char(CUR_ASSENZE.dal,'dd'))..to_number(to_char(CUR_ASSENZE.al,'dd')) Loop
         if    nvl(CUR_ASSENZE.disoccupazione_inps,7) = 1 then
           wgiorni(giorno).giorno := rpad('ML',2,' ');
         elsif nvl(CUR_ASSENZE.disoccupazione_inps,7) = 2 then
           wgiorni(giorno).giorno := rpad('MT',2,' ');
         elsif nvl(CUR_ASSENZE.disoccupazione_inps,7) = 3 then
           wgiorni(giorno).giorno := rpad('I',2,' '); 
         elsif nvl(CUR_ASSENZE.disoccupazione_inps,7) = 4 then
           wgiorni(giorno).giorno := rpad('V',2,' ');        
         elsif nvl(CUR_ASSENZE.disoccupazione_inps,7) = 5 then
           wgiorni(giorno).giorno := rpad('S',2,' ');  
         elsif nvl(CUR_ASSENZE.disoccupazione_inps,7) = 6 then
           wgiorni(giorno).giorno := rpad('P',2,' ');
         elsif nvl(CUR_ASSENZE.disoccupazione_inps,7) = 7 then
           wgiorni(giorno).giorno := rpad('V',2,' ');
         elsif nvl(CUR_ASSENZE.disoccupazione_inps,7) = 8 then
           wgiorni(giorno).giorno := rpad('F',2,' ');
         elsif nvl(CUR_ASSENZE.disoccupazione_inps,7) = 9 then
           wgiorni(giorno).giorno := rpad('P',2,' ');
         elsif nvl(CUR_ASSENZE.disoccupazione_inps,7) = 10 then
           wgiorni(giorno).giorno := rpad('C',2,' ');
         elsif nvl(CUR_ASSENZE.disoccupazione_inps,7) = 11 then
           wgiorni(giorno).giorno := rpad('D',2,' ');  
         elsif nvl(CUR_ASSENZE.disoccupazione_inps,7) = 12 then
           wgiorni(giorno).giorno := rpad('CM',2,' '); 		                                                                 
         end if;
       end loop;
        END LOOP CUR_ASSENZE;
       END;
       -- Setto domeniche e festivi
       D_componi := to_char(null);
       --dbms_output.put_line('Data Inizio Perido Lavorato '||to_char(CUR_MESI.dal,'dd/mm/yyyy') || ' fine ');
       for i in 1..31 loop
         if substr(CUR_MESI.giorni,i,1) in ('d','D','S','F','*') then
           wgiorni(i).giorno := rpad('*',2,' ');
         elsif substr(CUR_MESI.giorni,i,1) = 's' then
        --dbms_output.put_line('Mese '|| cur_mesi.mese || ' giorno ' || to_char(i) || ' sabato feriale');
        -- Si tratta di un sabato feriale devo determinare se è lavorato o meno
     -- Prima di tutto controllo se il sabato coincide con l'inizio di un periodo lavorato
     BEGIN
       select 'X'
      into D_temp
      from dual
     where exists ( select dal 
                      from periodi_giuridici 
         where rilevanza = 'P'
                       and ci = CUR_CI.ci
                    and dal = to_date(lpad(to_char(i),2,'0')||lpad(to_char(CUR_MESI.mese),2,'0')||to_char(CUR_MESI.anno),'ddmmyyyy'))
    ; 
     EXCEPTION
       WHEN no_data_found then
            BEGIN
      -- il sabato non corrisponde all'inizio di un periodo lavorato
      IF i >= 6 then
        -- la settimana del mese che contiene il sabato ricade tutta nello stesso mese
        D_lavorati := 1;  
              -- controllo che i cinque giorni precedenti siano tutti contrassegnati con delle X
              for  j in i-5..i-1 loop
          if wgiorni(j).giorno != 'X ' then
            D_lavorati := 0;
          end if; 
        end loop;
        if D_lavorati = 0 then
          wgiorni(i).giorno := '--';
        end if;
      ELSE
        -- la settimana che contiene il sabato è spezzata tra questo mese ed il mese precedente 
     --dbms_output.put_line('Sabato '||to_char(i)||' settimana spezzata');
     d_venpre := to_date(lpad(to_char(i),2,'0')||lpad(to_char(CUR_MESI.mese),2,'0')||to_char(CUR_MESI.anno),'ddmmyyyy') - 1;
     d_lunpre := to_date(lpad(to_char(i),2,'0')||lpad(to_char(CUR_MESI.mese),2,'0')||to_char(CUR_MESI.anno),'ddmmyyyy') - 5;
     -- controllo se esista un periodo di servizio che comprende i cinque giorni precedenti    
        select sum(least(nvl(al,to_date('3333333','j')),nvl(d_venpre,to_date('3333333','j'))) - greatest(dal,d_lunpre)+1)
       into D_gg_incidenza
          from periodi_giuridici
         where rilevanza = 'Q'
           and ci = CUR_CI.ci
           and nvl(d_venpre,to_date('3333333','j')) >= dal
           and d_lunpre <= nvl(al,to_date('3333333','j'))
              ;
     -- controllo se esistono assenze nei cinque giorni precedenti      
     --dbms_output.put_line('Giorni Incidenza '||to_char(D_gg_incidenza)); 
        select sum(least(nvl(al,to_date('3333333','j')),nvl(d_venpre,to_date('3333333','j'))) - greatest(dal,d_lunpre)+1)
       into D_gg_assenza
    -- le assenze le leggiamo sia da PEGI che dalla vista delle assenze a ore
          from assenze_totali 
         where ci = CUR_CI.ci
--           and rilevanza = 'A'
           and nvl(d_venpre,to_date('3333333','j')) >= dal
           and d_lunpre <= nvl(al,to_date('3333333','j'))
              ;       
     --dbms_output.put_line('Giorni Assenza '||to_char(D_gg_assenza)); 
     -- controllo se esistono festivi nei cinque giorni precedenti
     D_esiste_fest := 0;
     for k in 0..4 loop
                d_tempdata := d_lunpre + k;
       select substr(giorni,to_number(to_char(d_tempdata,'DD')),1)
         into D_tipo_giorno 
        from calendari      
       where anno = to_number(to_char(d_tempdata,'YYYY'))
         and mese = to_number(to_char(d_tempdata,'MM'))
                  and (calendario  = (select calendario from sedi where sedi.numero = D_sede)
                                           or calendario = '*')     
       ;
       if d_tipo_giorno <> 'f' then
         D_esiste_fest := 1;
       end if;
       --dbms_output.put_line('Giorno '||to_char(d_tempdata,'DD') || ' ' || D_tipo_giorno);
     end loop;
     --dbms_output.put_line('Esiste Festivita '||to_char(D_esiste_fest));
     -- controllo se è da sbiancare da lasciare barrato ovvero se è lavorato o meno
     if not (nvl(D_gg_incidenza,0) = 5 and nvl(D_gg_assenza,0) = 0 and D_esiste_fest = 0) then
       wgiorni(i).giorno := '--';
       --dbms_output.put_line('NON LAVORATO');
     end if;            
      END IF;
      END;
     END;     
         end if;
         if wgiorni(i).giorno = 'X ' then 
           D_gg_lav := D_gg_lav + 1;
         end if;   
       end loop;
       -- scrivo il tutto nella variabile         
       for i in 1..wgiorni.count loop
         D_componi := D_componi || wgiorni(i).giorno;
       end loop; 
     END;
     -- calcolo la retribuzione mensile
     BEGIN     
       select sum(valore)              retribuzione
         into D_retribuzione
         from valori_contabili_mensili vacm
        where estrazione = 'DISOCCUPAZIONE_INPS'
          and colonna    = 'DS22'
          and vacm.ci    = CUR_CI.CI
          and vacm.anno  = CUR_MESI.anno
          and vacm.mese  = CUR_MESI.mese
       ;
       --dbms_output.put_line(CUR_MESI.anno || ' ' ||CUR_MESI.mese || ' D_retribuzione ' || D_retribuzione);
     END;
     -- estrae gli ass.fam
     BEGIN     
       select sum(valore)              retribuzione
         into D_ass_fam
         from valori_contabili_mensili vacm
        where estrazione = 'DISOCCUPAZIONE_INPS'
          and colonna    = 'ASS_FAM'
          and vacm.ci    = CUR_CI.CI
          and vacm.anno  = CUR_MESI.anno
          and vacm.mese  >= CUR_MESI.mese
          and to_char(vacm.riferimento,'yyyymm') = CUR_MESI.anno||lpad(CUR_MESI.mese,2,0)
       ;
       --dbms_output.put_line(CUR_MESI.anno || ' ' ||CUR_MESI.mese || ' D_ass_fam ' || D_ass_fam);
     END;
     -- calcolo PERE.GG_CON PERE.GG_AF
     BEGIN
  select sum(least( pere.al
                                , last_day(to_date(lpad(to_char(nvl(CUR_MESI.mese,12)),2,'0')||'/'||to_char(CUR_MESI.anno),'mm/yyyy'))
                                ) 
             - greatest( pere.dal
                                     , nvl(pegi.dal,to_date('2222222','j'))
                                     , to_date('01'||lpad(to_char(nvl(CUR_MESI.mese,12)),2,'0')||to_char(CUR_MESI.anno),'ddmmyyyy')
                                     ) 
                           + 1
      )
       , decode(nvl(D_ass_fam,0),0,0,sum(gg_af))
          , sum(gg_inp)
   -- se lavora tutto il mese la retribuzione la dividuamo per i gg_lavoro contrattuali, altrimenti per i gg effettivamente lavorati
                     , decode( sum(least( pere.al
                                , last_day(to_date(lpad(to_char(nvl(CUR_MESI.mese,12)),2,'0')||'/'||to_char(CUR_MESI.anno),'mm/yyyy'))
                                ) 
             - greatest( pere.dal
                                     , nvl(pegi.dal,to_date('2222222','j'))
                                     , to_date('01'||lpad(to_char(nvl(CUR_MESI.mese,12)),2,'0')||to_char(CUR_MESI.anno),'ddmmyyyy')
                                     ) 
                           + 1
      )
                             , max(to_char(last_day(to_date(to_char(nvl(CUR_MESI.mese,12))||'/'||to_char(CUR_MESI.anno), 'mm/yyyy')),'dd') )
                                      , max(cost.gg_lavoro)
                             , sum(least( pere.al
                                , last_day(to_date(lpad(to_char(nvl(CUR_MESI.mese,12)),2,'0')||'/'||to_char(CUR_MESI.anno),'mm/yyyy'))
                                ) 
             - greatest( pere.dal
                                     , nvl(pegi.dal,to_date('2222222','j'))
                                     , to_date('01'||lpad(to_char(nvl(CUR_MESI.mese,12)),2,'0')||to_char(CUR_MESI.anno),'ddmmyyyy')
                                     ) 
                           + 1
      )
                             ) 
       into D_gg_con
          , D_gg_af 
    , D_gg_ret
                 , D_gg_lavoro
    from periodi_retributivi pere
       , periodi_giuridici   pegi
                     , contratti_storici cost
   where cost.contratto = pere.contratto
                   and pere.al between cost.dal and nvl(cost.al,to_date('3333333','j'))
                   and pere.ci = CUR_CI.CI
     and pegi.rilevanza(+) = 'P'
     and pegi.ci(+)        = pere.ci  
-- leggiamo solo l'ultima volta che il mese è statao retribuito
                   and pere.competenza in ('A','C')
                   and pere.periodo = (select max(periodo) from periodi_retributivi
                           where tipo is null
                           and to_char(al,'mmyyyy') = lpad(to_char(CUR_MESI.mese),2,'0')||to_char(CUR_MESI.anno) 
                           and ci = pere.ci
                           and periodo >= last_day(to_date(to_char(nvl(CUR_MESI.mese,12))||'/'||to_char(CUR_MESI.anno), 'mm/yyyy'))  )
--     and pere.periodo = last_day(to_date(to_char(nvl(CUR_MESI.mese,12))||'/'||to_char(CUR_MESI.anno), 'mm/yyyy')) 
     and to_char(pere.al,'mmyyyy') = lpad(to_char(CUR_MESI.mese),2,'0')||to_char(CUR_MESI.anno) 
     and pere.al     between nvl(pegi.dal(+), to_date('2222222','j'))
                     and nvl(pegi.al(+), to_date('3333333','j')) 
        ;
       --dbms_output.put_line(CUR_MESI.anno || ' ' ||CUR_MESI.mese || ' ' || D_gg_con);
       if D_retribuzione <> 0 and D_gg_con  <> 0 then
         D_retribuzione_spe := D_retribuzione / D_gg_lavoro * D_gg_lav;
         D_gg_nlav := D_gg_con - D_gg_lav;
       end if;
     END;    
     insert into dichiarazione_dis_importi
      ( ddis_id
       ,ci
       ,anno
       ,mese
       ,giorni
       ,gg_lav
       ,gg_nlav
    ,gg_af
    ,gg_ret    
       ,retribuzione
       ,retribuzione_spe
       ,modello
       ,utente
       ,tipo_agg       
       ,data_agg            
      ) values (DDIS_SQ.currval
               ,CUR_CI.ci
               ,CUR_MESI.anno
               ,CUR_MESI.mese
               ,D_componi
               ,D_gg_lav
               ,D_gg_nlav
      ,D_gg_af
      ,D_gg_ret
               ,D_retribuzione
               ,D_retribuzione_spe
               ,CUR_CI.modello
               ,D_utente
               ,null
               ,sysdate                
         );
        commit;
      END LOOP CUR_MESI;  
    END;  
  END;
  END LOOP CUR_CI;
 END;
END;
END;
/
