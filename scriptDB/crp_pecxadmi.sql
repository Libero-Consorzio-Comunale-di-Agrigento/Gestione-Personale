CREATE OR REPLACE PACKAGE PECXADMI IS
/******************************************************************************
 NOME:        PECCADMI 
 DESCRIZIONE: Creazione delle registrazioni mensilita individuali per la 
              produzione della denuncia EMENS
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  Il PARAMETRO P_tipo     determina il tipo di elaborazione da effettuare.
               Il PARAMETRO P_gestione determina quale gestione elaborare, valore di default %.
               Il PARAMETRO P_specie   elaborazione DIP o COCO oppure tutti se nullo

 REVISIONI:
 Rev. Data       Autore   Descrizione
 ---- ---------- ------   --------------------------------------------------------
 1.0  19/12/2005 MS       Prima Emissione: aggiornamento ritenuta e contributo
 1.1  08/03/2006 MS       Mod. update per coco con scaglione (Att.15230 )
 1.2  14/03/2006 MS       Mog. gestione contributi coco a scaglione (Att.15230)
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN   (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECXADMI IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.2 del 14/03/2006';
END VERSIONE;

PROCEDURE MAIN (prenotazione in number, passo in number) IS
P_ente            varchar2(4);
P_ambiente        varchar2(8);
P_utente          varchar2(8);
P_anno            varchar2(4);
P_mese            number(2);
P_gestione        varchar2(4);
P_specie          varchar2(4);
P_tipo            varchar2(1);
P_ci              number(8);

D_limite          number(12,2);
D_aliquota        number(5,2);
D_aliquota1       number(5,2);
D_aliquota2       number(5,2);
D_perc            number(5,2);
D_ritenuta        number(12,2);
D_contributo_coco_01 number(12,2);
D_contributo_coco_02 number(12,2);
D_ritenuta_coco_01 number(12,2);
D_ritenuta_coco_02 number(12,2);

D_errore          varchar2(6);
USCITA            EXCEPTION;
BEGIN

-- Estrazione Parametri di Selezione
   BEGIN
      select valore
        into P_anno
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_ANNO'
      ;
   EXCEPTION
	  WHEN NO_DATA_FOUND THEN
       select to_char(anno)
	      into P_anno
         from riferimento_retribuzione
        where rire_id = 'RIRE'
       ;
   END;
   BEGIN
      select valore
        into P_mese
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_MESE'
      ;
   EXCEPTION
	  WHEN NO_DATA_FOUND THEN
       select mese
         into P_mese
         from riferimento_retribuzione
        where rire_id = 'RIRE'
       ;
   END;
   BEGIN
      select valore
        into P_tipo
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_TIPO'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_tipo := to_char(null);
   END;
   BEGIN
 	select to_number(valore) D_ci
        into P_ci
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_CI'
      ;
   EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	P_ci := to_number(null);
   END;
   IF nvl(P_ci,0) = 0 and nvl(P_tipo,'X') = 'S' 
       THEN D_errore := 'A05721';
            RAISE USCITA;
   ELSIF nvl(P_ci,0) != 0 and nvl(P_tipo,'X') = 'T' 
       THEN D_errore := 'A05721';
            RAISE USCITA;
   END IF;
   BEGIN
      select valore
        into P_gestione
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_GESTIONE'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_gestione := '%';
   END;
   BEGIN
      select valore
        into P_specie
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_SPECIE'
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_specie := '%';
   END;
   BEGIN
      select ente     D_ente
           , utente   D_utente
           , ambiente D_ambiente
        into P_ente, P_utente, P_ambiente
        from a_prenotazioni
       where no_prenotazione = prenotazione
      ;
   END;

   BEGIN
-- Azzeramento importi 
      update denuncia_emens deie
         set ritenuta = null
           , contributo = null
       where anno = P_anno
         and mese = P_mese
         and gestione like P_gestione
         and specie_rapporto like P_specie
         and ( P_tipo = 'T' 
          or ( P_tipo = 'S' and deie.ci = P_ci )
          or ( P_tipo in ('P','V','I')
                 and not exists
                    ( select 'x' from denuncia_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from settimane_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from variabili_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from dati_particolari_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from fondi_speciali_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                    )
                )
               )
         and nvl(imponibile,0) != 0;
    commit;
   END;

   FOR CUR_CI IN 
       ( select ci , dal, al , specie_rapporto
           from denuncia_emens deie
          where anno = P_anno
            and mese = P_mese
            and gestione like P_gestione
            and specie_rapporto like P_specie
            and ( P_tipo = 'T' 
             or ( P_tipo = 'S' and deie.ci = P_ci )
             or ( P_tipo in ('P','V','I')
                 and not exists
                    ( select 'x' from denuncia_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from settimane_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from variabili_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from dati_particolari_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                       union
                      select 'x' from fondi_speciali_emens 
                       where anno = P_anno and  mese = P_mese 
                         and ci       = deie.ci
                         and ( nvl(tipo_agg,' ') = decode(P_tipo,'P',tipo_agg,P_tipo)
                          or (P_tipo     = 'P' and tipo_agg is not null) )
                    )
                )
               )
            and nvl(imponibile,0) != 0
          order by ci
         )  LOOP
-- dbms_output.put_line('CUR_CI/GG: '||CUR_CI.ci||' '||CUR_CI.dal||' '||CUR_CI.al);

   D_ritenuta       := null;
   D_contributo_coco_01 := null;
   D_contributo_coco_02 := null;
   D_ritenuta_coco_01 := null;
   D_ritenuta_coco_02 := null;
   D_aliquota       := null;
   D_aliquota1      := null;
   D_aliquota2      := null;
   D_perc           := null;
    IF CUR_CI.specie_rapporto = 'DIP' THEN
-- dbms_output.put_line('dip');
    BEGIN
    select round( sum(vacm.valore*decode( vacm.colonna
                                        , 'RITENUTA', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'RITENUTA', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'RITENUTA', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
      into D_ritenuta
      from valori_contabili_mensili    vacm
         , estrazione_valori_contabili esvc
     where vacm.estrazione      = 'DENUNCIA_EMENS'
       and vacm.colonna        in ('RITENUTA')
       and vacm.anno            = P_anno
       and vacm.mese            = P_mese
       and vacm.ci              = CUR_CI.ci
       and vacm.riferimento between CUR_CI.dal and CUR_CI.al
       and vacm.riferimento between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
       and nvl(vacm.valore,0) != 0
       and esvc.estrazione     = vacm.estrazione
       and esvc.colonna        = vacm.colonna
    having round( sum(vacm.valore*decode( vacm.colonna
                                        , 'RITENUTA', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'RITENUTA', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'RITENUTA', nvl(esvc.arrotonda,0.01)
                                          , '')),1) != 0
      ;
    EXCEPTION WHEN NO_DATA_FOUND THEN
              D_ritenuta        := null;
    END;
    update denuncia_emens
       set ritenuta = D_ritenuta
     where ci = CUR_CI.ci
       and anno = P_anno
       and mese = P_mese
       and dal = CUR_CI.dal
       and specie_rapporto = CUR_CI.specie_rapporto
       and nvl(imponibile,0) != 0
     ;
   commit;
   END IF; -- imponibile dipendenti
   IF CUR_CI.specie_rapporto = 'COCO' THEN 
-- dbms_output.put_line('coco');
    BEGIN
    <<IMP_COCO>>
-- Estrazione dati dei collaboratori 
    select  round( sum(vacm.valore*decode( vacm.colonna
                                        , 'CONTRIBUTO_COCO_01', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         , round( sum(vacm.valore*decode( vacm.colonna
                                        , 'CONTRIBUTO_COCO_02', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         , round( sum(vacm.valore*decode( vacm.colonna
                                        , 'RITENUTA_COCO_01', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         , round( sum(vacm.valore*decode( vacm.colonna
                                        , 'RITENUTA_COCO_02', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         , nvl(max(decode(vacm.colonna
                     , 'CONTRIBUTO_COCO_02', substr(esvc.note, instr(esvc.note,'<')+1, instr(esvc.note,'>')-2)
                                      , NULL)),38641)
         , round( max(vacm.valore*decode( vacm.colonna
                                        , 'ALIQUOTA', 1
                                                      , 0))
                )
         , max(decode(vacm.colonna
                     ,'ALIQUOTA_01' , substr(esvc.note, instr(esvc.note,'<',1,1)+1
                                                     , (instr(esvc.note, '>',1,1 ) - instr(esvc.note,'<',1,1)-1 )
                                           )
                                    , null))
         , max(decode(vacm.colonna
                    ,'ALIQUOTA_01' , substr(esvc.note, instr(esvc.note,'<',1,2)+1
                                                     , (instr(esvc.note, '>',1,2 ) - instr(esvc.note,'<',1,2)-1 )
                                           )
                                   , null))
         , max(decode(vacm.colonna
                    ,'ALIQUOTA_01' , substr(esvc.note, instr(esvc.note,'<',1,3)+1
                                                     , (instr(esvc.note, '>',1,3 ) - instr(esvc.note,'<',1,3)-1 )
                                           )
                                   , null))
      into D_contributo_coco_01, D_contributo_coco_02
         , D_ritenuta_coco_01, D_ritenuta_coco_02, D_limite
         , D_aliquota, D_aliquota1, D_aliquota2, D_perc
      from valori_contabili_mensili    vacm
         , estrazione_valori_contabili esvc
     where vacm.estrazione      = 'DENUNCIA_EMENS'
       and vacm.colonna        in ('IMPONIBILE','ALIQUOTA','AGEVOLAZIONE'
                                  ,'IMPONIBILE_01', 'ALIQUOTA_01'
                                  , 'CONTRIBUTO_COCO_01', 'CONTRIBUTO_COCO_02'
                                  , 'RITENUTA_COCO_01', 'RITENUTA_COCO_02')
       and vacm.anno            = P_anno
       and vacm.mese            = P_mese
       and vacm.ci              = CUR_CI.ci
       and last_day(to_date(lpad(P_mese,2,'0')||P_anno,'mmyyyy')) between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
       and nvl(vacm.valore,0) != 0
       and esvc.estrazione     = vacm.estrazione
       and esvc.colonna        = vacm.colonna
    having  round( sum(vacm.valore*decode( vacm.colonna
                                        , 'CONTRIBUTO_COCO_01', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         + round( sum(vacm.valore*decode( vacm.colonna
                                        , 'CONTRIBUTO_COCO_02', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'CONTRIBUTO_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         + round( sum(vacm.valore*decode( vacm.colonna
                                        , 'RITENUTA_COCO_01', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_01', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
         + round( sum(vacm.valore*decode( vacm.colonna
                                        , 'RITENUTA_COCO_02', 1
                                                      , 0))
                / nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)
                )
                * nvl(max(decode( vacm.colonna
                            , 'RITENUTA_COCO_02', nvl(esvc.arrotonda,0.01)
                                          , '')),1)  != 0
      ;
    EXCEPTION WHEN NO_DATA_FOUND THEN
              D_contributo_coco_01 := null;
              D_contributo_coco_02 := null;
              D_ritenuta_coco_01 := null;
              D_ritenuta_coco_02 := null;
    END IMP_COCO;

-- dbms_output.put_line('contr: '||D_contributo_coco_01||' '||D_contributo_coco_02);
-- dbms_output.put_line('rit: '||D_ritenuta_coco_01||' '||D_ritenuta_coco_02);
-- dbms_output.put_line('limite : '||D_limite);
-- dbms_output.put_line('alq: '||D_aliquota||' '||D_aliquota1||' ' ||D_aliquota2);
-- dbms_output.put_line('perc: '||D_perc);

    IF ( nvl(D_contributo_coco_01,0) != 0 and nvl(D_contributo_coco_02,0) != 0 
      or  nvl(D_ritenuta_coco_01,0) != 0 and nvl(D_ritenuta_coco_02,0) != 0 
       ) THEN
      IF D_perc = 1 THEN
    update denuncia_emens
       set ritenuta = D_ritenuta_coco_01
         , contributo = D_contributo_coco_01
     where ci = CUR_CI.ci
       and anno = P_anno
       and mese = P_mese
       and dal = CUR_CI.dal
       and nvl(imponibile,0) != 0
       and nvl(aliquota,0) = D_aliquota1
       and specie_rapporto = CUR_CI.specie_rapporto
     ;
    update denuncia_emens
       set ritenuta = D_ritenuta_coco_02 + D_ritenuta_coco_01
         , contributo = D_contributo_coco_02 + D_contributo_coco_01
     where ci = CUR_CI.ci
       and anno = P_anno
       and mese = P_mese
       and dal = CUR_CI.dal
       and nvl(imponibile,0) != 0
       and nvl(aliquota,0) = D_aliquota2
       and not exists ( select 'x' 
                          from denuncia_emens
                         where ci = CUR_CI.ci
                           and anno = P_anno
                           and mese = P_mese
                           and specie_rapporto = CUR_CI.specie_rapporto
                           and nvl(aliquota,0) = D_aliquota1
                      )
       and specie_rapporto = CUR_CI.specie_rapporto
     ;
    update denuncia_emens
       set ritenuta = D_ritenuta_coco_02
         , contributo = D_contributo_coco_02
     where ci = CUR_CI.ci
       and anno = P_anno
       and mese = P_mese
       and dal = CUR_CI.dal
       and nvl(imponibile,0) != 0
       and nvl(aliquota,0) = D_aliquota2
       and exists ( select 'x' 
                          from denuncia_emens
                         where ci = CUR_CI.ci
                           and anno = P_anno
                           and mese = P_mese
                           and specie_rapporto = CUR_CI.specie_rapporto
                           and nvl(aliquota,0) = D_aliquota1
                   )
       and specie_rapporto = CUR_CI.specie_rapporto
     ;
      ELSE 
/* mese di cambio dello scaglione */
    update denuncia_emens
       set ritenuta = D_ritenuta_coco_01
         , contributo = D_contributo_coco_01
     where ci = CUR_CI.ci
       and anno = P_anno
       and mese = P_mese
       and dal = CUR_CI.dal
       and nvl(imponibile,0) != 0
       and nvl(aliquota,0) = D_aliquota1
       and specie_rapporto = CUR_CI.specie_rapporto
     ;
    update denuncia_emens
       set ritenuta = D_ritenuta_coco_02
         , contributo = D_contributo_coco_02 
     where ci = CUR_CI.ci
       and anno = P_anno
       and mese = P_mese
       and dal = CUR_CI.dal
       and nvl(imponibile,0) != 0
       and nvl(aliquota,0) = D_aliquota2
       and specie_rapporto = CUR_CI.specie_rapporto
     ;
    END IF; -- D_perc
   ELSE     
    update denuncia_emens
       set ritenuta = nvl(D_ritenuta_coco_01,0) + nvl(D_ritenuta_coco_02,0)
         , contributo = nvl(D_contributo_coco_01,0) + nvl(D_contributo_coco_02,0)
     where ci = CUR_CI.ci
       and anno = P_anno
       and mese = P_mese
       and dal = CUR_CI.dal
       and nvl(imponibile,0) != 0
       and specie_rapporto = CUR_CI.specie_rapporto
     ;
   commit;
   END IF; -- fine update
  END IF; -- estrazione dati collaboratori
  END LOOP; -- cur_ci
   BEGIN
   <<FINALE>>
/* annullamento importi a 0 */
     update denuncia_emens
        set ritenuta = decode(ritenuta, 0, null, ritenuta )
          , contributo = decode(contributo, 0, null, contributo )
      where anno = P_anno
        and mese = P_mese;
     commit;
   END FINALE;
   
EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = D_errore
       where no_prenotazione = prenotazione;
      commit;
 END;
END;
/

