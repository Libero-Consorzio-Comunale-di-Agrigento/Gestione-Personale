CREATE OR REPLACE PACKAGE PECSSNSM IS
/******************************************************************************
 NOME:        PECSSNSM - CREAZIONE SUPPORTO MAGNETICO SMT Aziende Sanitarie
 DESCRIZIONE: Creazione dei file TXT da importare sulla stazione del ministero
              I file prodotti si troveranno nella cartella STA del report server
              o dell'application server e si chiameranno come indicato nelle
              specifiche tecniche del ministero stesso
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  Passo        File TXT
                 1          TAB1A1
                 3          TAB1A2
                 5          TAB020
                 7          TAB030
                 9          TAB040
                11          TAB200
                13          TAB300
                15          TAB500
                17          TAB080
                19          TAB600
                21          TAB8A0
                23          TAB131
                25          TAB1B1
                27          TAB1E
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  04/05/2005 CB     Prima Emissione
 1.1  11/05/2005 MS     Mod. per difetti da test
 1.2  04/07/2005 MS     Mod. per att. 11876
 2.0  21/04/2006 MS     Adeguamento per SMT/2006 ( Att.15598 )
 2.1  27/04/2006 MS     Sistemazione tabella 7 - TAB500 ( Att.15980 )
 2.2  10/05/2006 MS     Controllo su Negativi ( Att. 15843 )
 2.3  22/03/2007 CB     Gestione di rqmi.posizione (A20251)
 3.0  03/05/2007 MS     Adeguamento per SMT/2007 ( Att.20854 )
 3.1  15/05/2007 MS     Miglioria per gestione Tabelle 12 e 13 ( A20830.3 )
 3.2  29/05/2007 MS     Miglioria tempi di elaborazione ( A21399 )
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECSSNSM IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V3.2 del 29/05/2007';
END VERSIONE;
 PROCEDURE MAIN (prenotazione in number, passo in number) IS
BEGIN
DECLARE
  P_pagina              number;
  P_riga                number := 0;
  P_riga_s              number := 0;
  P_ente                varchar2(4);
  P_ambiente            varchar2(8);
  P_utente              varchar2(8);
  P_lingua              varchar2(1);
  P_anno                number;
  P_gestione            varchar2(4);
  P_cod_reg             varchar2(3);
  P_cod_azienda         varchar2(3);
  P_cod_comparto        varchar2(2);
  P_fin_a               date;
  P_fin_ap              date;
  P_dot_org             number;
  P_anno_ril_m          number;
  P_anno_ril_f          number;
  P_anno_prec_f         number;
  P_anno_prec_m         number;
  P_indenter_m          number;
  P_indenter_f          number;
  P_indet_parz50_m      number;
  P_indet_parz50_f      number;
  P_indet_parz51_m      number;
  P_indet_parz51_f      number;
  P_ini_a               date;
  P_anno_ril            number;
  P_indet_pieno         number;
  P_indet_parz          number;
  P_deter_pieno         number;
  P_deter_parz          number;
  P_com_in              number;
  P_com_out             number;
  P_tempo_determ_m      number;
  P_tempo_determ_f      number;
  P_formaz_lav_m        number;
  P_formaz_lav_f        number;
  P_interinale_m        number;
  P_interinale_f        number;
  P_lsu_m               number;
  P_lsu_f               number;
  P_telelav_m           number;
  P_telelav_f           number;
  P_com_in_m            number;
  P_com_in_f            number;
  P_fr_in_m            number;
  P_fr_in_f            number;
  P_com_out_m           number;
  P_com_out_f           number;
  P_fr_out_m           number;
  P_fr_out_f           number;
  P_n_passaggi          number;
  P_limiti_m            number;
  P_limiti_f            number;
  P_dimissioni_m        number;
  P_dimissioni_f        number;
  P_altre_amm_m         number;
  P_altre_amm_f         number;
  P_altre_amm_59_m      number;
  P_altre_amm_59_f      number;
  P_altre_cause_m       number;
  P_altre_cause_f       number;
  P_totale_m            number;
  P_totale_f            number;
  P_concorso_m          number;
  P_concorso_f          number;
  P_da_0a5_m            number;
  P_da_0a5_f            number;
  P_da_6a10_m           number;
  P_da_6a10_f           number;
  P_da_11a15_m          number;
  P_da_11a15_f          number;
  P_da_16a20_m          number;
  P_da_16a20_f          number;
  P_da_21a25_m          number;
  P_da_21a25_f          number;
  P_da_26a30_m          number;
  P_da_26a30_f          number;
  P_da_31a35_m          number;
  P_da_31a35_f          number;
  P_da_36a40_m          number;
  P_da_36a40_f          number;
  P_oltre_40_m          number;
  P_oltre_40_f          number;
  P_fino_a19_m          number;
  P_fino_a19_f          number;
  P_da_20a24_m          number;
  P_da_20a24_f          number;
  P_da_25a29_m          number;
  P_da_25a29_f          number;
  P_da_30a34_m          number;
  P_da_30a34_f          number;
  P_da_35a39_m          number;
  P_da_35a39_f          number;
  P_da_40a44_m          number;
  P_da_40a44_f          number;
  P_da_45a49_m          number;
  P_da_45a49_f          number;
  P_da_50a54_m          number;
  P_da_50a54_f          number;
  P_da_55a59_m          number;
  P_da_55a59_f          number;
  P_da_60a64_m          number;
  P_da_60a64_f          number;
  P_oltre_64_m          number;
  P_oltre_64_f          number;
  P_obbligo_m           number;
  P_obbligo_f           number;
  P_superiore_m         number;
  P_superiore_f         number;
  P_laurea_m            number;
  P_laurea_f            number;
  P_postlaurea_m        number;
  P_postlaurea_f        number;
  P_nro_mensilita       number;
  P_stipendi            number;
  P_inden_integr        number;
  P_ria                 number;
  P_tredicesima         number;
  P_arretrati_ac        number;
  P_arretrati_ap        number;
  P_filler              number;
  P_recuperi            number;
  P_totale              number;
  P_imp_i202            number;
  P_imp_i204            number;
  P_imp_i207            number;
  P_imp_i212            number;
  P_imp_i216            number;
  P_imp_s212            number;
  P_imp_s204            number;
  P_imp_s630            number;
  P_imp_s998            number;
  P_imp_s806            number;
  P_imp_s820            number;
  P_imp_s999            number;
  P_imp_t101            number;
  P_imp_totale          number;
  P_fascia0_m           number;
  P_fascia0_f           number;
  P_fascia1_m           number;
  P_fascia1_f           number;
  P_fascia2_m           number;
  P_fascia2_f           number;
  P_fascia3_m           number;
  P_fascia3_f           number;
  P_fascia4_m           number;
  P_fascia4_f           number;
  P_fascia5_m           number;
  P_fascia5_f           number;
  P_fascia6_m           number;
  P_fascia6_f           number;
  P_tot_fascia_m        number;
  P_tot_fascia_f        number;
  USCITA                EXCEPTION;
BEGIN
 BEGIN
  --
  -- Estrazione Parametri di Selezione della Prenotazione
  --
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
    select to_number(substr(valore,1,4))
      into P_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_ANNO'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select substr(valore,1,4)
      into P_gestione
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_GESTIONE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN P_gestione := '%';
  END;

  BEGIN
    select lpad(substr(valore,1,3),3,'0')
      into P_cod_reg
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_COD_REG'
    ;
  EXCEPTION WHEN NO_DATA_FOUND 
       THEN P_cod_reg := null;
            RAISE USCITA;
  END;
  BEGIN
    select lpad(substr(valore,1,3),3,'0')
      into P_cod_azienda
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_COD_AZIENDA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND 
       THEN P_cod_azienda := null;
            RAISE USCITA;
  END;
  BEGIN
    select lpad(substr(valore,1,2),2,'0')
      into P_cod_comparto
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_COD_COMPARTO'
    ;
  EXCEPTION WHEN NO_DATA_FOUND 
       THEN P_cod_comparto := '01'; 
  END;
 END; -- fine parametri
  
BEGIN -- Tab1A1 Tabella 1 - Personale per qualifica
<<TAB1A1>>
P_fin_a  := to_date('3112'||to_char(P_anno),'ddmmyyyy');
P_fin_ap := add_months(P_fin_a,-12);
P_pagina := 1;
P_riga   := 1;
FOR CUR IN 
(select distinct sequenza, codice
   from qualifiche_ministeriali
  where P_fin_a between dal and nvl(al,P_fin_a)
 order by sequenza,codice
 ) LOOP
   P_dot_org           :=0;
   P_anno_ril_m        :=0;
   P_anno_ril_f        :=0;
   P_anno_prec_f       :=0;
   P_anno_prec_m       :=0;
   P_indenter_m        :=0;
   P_indenter_f        :=0;
   P_indet_parz50_m    :=0;
   P_indet_parz50_f    :=0;
   P_indet_parz51_m    :=0;
   P_indet_parz51_f    :=0;

  BEGIN
  select sum(dati.dot_org)                   dot_org
    into P_dot_org
    from (  select count(*)                     dot_org
              from righe_qualifica_ministeriale rqmi
                 , periodi_giuridici            pegi
                 , posizioni                    posi
             where pegi.rilevanza        = 'S'
               and P_fin_ap between pegi.dal and nvl(pegi.al,to_date('3333333','j')) 
               and P_fin_a  between rqmi.dal and nvl(rqmi.al,P_fin_a)
               and pegi.gestione      like P_gestione
               and posi.codice           = pegi.posizione 
               and nvl(rqmi.posizione,pegi.posizione)=pegi.posizione
               and rqmi.codice           = CUR.codice
                -- dati per figura 
               and rqmi.qualifica is null
               and rqmi.figura     = pegi.figura              
               and nvl(rqmi.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
               and nvl(rqmi.tempo_determinato,posi.tempo_determinato) = posi.tempo_determinato
               and nvl(rqmi.part_time,posi.part_time) = posi.part_time
               and nvl(rqmi.rapporto_gg,'NO')         = 'NO'
               and nvl( rqmi.tipo_rapporto , nvl(pegi.tipo_rapporto,'TP')) = nvl(pegi.tipo_rapporto,'TP')
               and exists  (select 'x' from rapporti_individuali
                             where ci        = pegi.ci
                               and rapporto in 
                                  (select codice from classi_rapporto
                                    where giuridico = 'SI' and retributivo = 'SI')
                           )
               and not exists (select 'x' from periodi_giuridici
                                where rilevanza='A'
                                  and ci=pegi.ci
                                  and evento in  (select codice from eventi_giuridici
                                                   where rilevanza='A'
                                                     and nvl(conto_annuale,0)=99)
                                  and P_fin_ap between dal and nvl(al,to_date('3333333','j'))
                             )
             union
             select count(*)                     dot_org
              from righe_qualifica_ministeriale rqmi
                 , periodi_giuridici            pegi
                 , posizioni                    posi
             where pegi.rilevanza        = 'S'
               and P_fin_ap between pegi.dal and nvl(pegi.al,to_date('3333333','j')) 
               and P_fin_a  between rqmi.dal and nvl(rqmi.al,P_fin_a)
               and pegi.gestione      like P_gestione
               and posi.codice           = pegi.posizione 
               and nvl(rqmi.posizione,pegi.posizione)=pegi.posizione
               and rqmi.codice           = CUR.codice
                -- dati per qualifica
               and rqmi.figura    is null
               and rqmi.qualifica  = pegi.qualifica      
               and nvl(rqmi.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
               and nvl(rqmi.tempo_determinato,posi.tempo_determinato) = posi.tempo_determinato
               and nvl(rqmi.part_time,posi.part_time) = posi.part_time
               and nvl(rqmi.rapporto_gg,'NO')         = 'NO'
               and nvl( rqmi.tipo_rapporto , nvl(pegi.tipo_rapporto,'TP')) = nvl(pegi.tipo_rapporto,'TP')
               and exists  (select 'x' from rapporti_individuali
                             where ci        = pegi.ci
                               and rapporto in 
                                  (select codice from classi_rapporto
                                    where giuridico = 'SI' and retributivo = 'SI')
                           )
               and not exists (select 'x' from periodi_giuridici
                                where rilevanza='A'
                                  and ci=pegi.ci
                                  and evento in  (select codice from eventi_giuridici
                                                   where rilevanza='A'
                                                     and nvl(conto_annuale,0)=99)
                                  and P_fin_ap between dal and nvl(al,to_date('3333333','j'))
                             )
             union
             select count(*)                     dot_org
              from righe_qualifica_ministeriale rqmi
                 , periodi_giuridici            pegi
                 , posizioni                    posi
             where pegi.rilevanza        = 'S'
               and P_fin_ap between pegi.dal and nvl(pegi.al,to_date('3333333','j')) 
               and P_fin_a  between rqmi.dal and nvl(rqmi.al,P_fin_a)
               and pegi.gestione      like P_gestione
               and posi.codice           = pegi.posizione 
               and nvl(rqmi.posizione,pegi.posizione)=pegi.posizione
               and rqmi.codice           = CUR.codice
               -- dati per qualifica e figura
               and rqmi.qualifica is not null
               and rqmi.figura    is not null
               and rqmi.qualifica  = pegi.qualifica
               and rqmi.figura     = pegi.figura 
               and nvl(rqmi.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
               and nvl(rqmi.tempo_determinato,posi.tempo_determinato) = posi.tempo_determinato
               and nvl(rqmi.part_time,posi.part_time) = posi.part_time
               and nvl(rqmi.rapporto_gg,'NO')         = 'NO'
               and nvl( rqmi.tipo_rapporto , nvl(pegi.tipo_rapporto,'TP')) = nvl(pegi.tipo_rapporto,'TP')
               and exists  (select 'x' from rapporti_individuali
                             where ci        = pegi.ci
                               and rapporto in 
                                  (select codice from classi_rapporto
                                    where giuridico = 'SI' and retributivo = 'SI')
                           )
               and not exists (select 'x' from periodi_giuridici
                                where rilevanza='A'
                                  and ci=pegi.ci
                                  and evento in  (select codice from eventi_giuridici
                                                   where rilevanza='A'
                                                     and nvl(conto_annuale,0)=99)
                                  and P_fin_ap between dal and nvl(al,to_date('3333333','j'))
                             )
             union
             select count(*)                     dot_org
              from righe_qualifica_ministeriale rqmi
                 , periodi_giuridici            pegi
                 , posizioni                    posi
             where pegi.rilevanza        = 'S'
               and P_fin_ap between pegi.dal and nvl(pegi.al,to_date('3333333','j')) 
               and P_fin_a  between rqmi.dal and nvl(rqmi.al,P_fin_a)
               and pegi.gestione      like P_gestione
               and posi.codice           = pegi.posizione 
               and nvl(rqmi.posizione,pegi.posizione)=pegi.posizione
               and rqmi.codice           = CUR.codice
               -- dati per altri parametri
               and rqmi.qualifica is null
               and rqmi.figura    is null
               and nvl(rqmi.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
               and nvl(rqmi.tempo_determinato,posi.tempo_determinato) = posi.tempo_determinato
               and nvl(rqmi.part_time,posi.part_time) = posi.part_time
               and nvl(rqmi.rapporto_gg,'NO')         = 'NO'
               and nvl( rqmi.tipo_rapporto , nvl(pegi.tipo_rapporto,'TP')) = nvl(pegi.tipo_rapporto,'TP')
               and exists  (select 'x' from rapporti_individuali
                             where ci        = pegi.ci
                               and rapporto in 
                                  (select codice from classi_rapporto
                                    where giuridico = 'SI' and retributivo = 'SI')
                           )
               and not exists (select 'x' from periodi_giuridici
                                where rilevanza='A'
                                  and ci=pegi.ci
                                  and evento in  (select codice from eventi_giuridici
                                                   where rilevanza='A'
                                                     and nvl(conto_annuale,0)=99)
                                  and P_fin_ap between dal and nvl(al,to_date('3333333','j'))
                             )
     ) dati;
    EXCEPTION WHEN NO_DATA_FOUND THEN
     P_dot_org := 0;
    END;

   FOR CUR_1 IN
   (select smin.sesso,
           decode(smpe.tempo_pieno,'SI',1,
                                   decode(greatest(smpe.part_time,50),50,2,3))   colonna,
           count(smpe.ci)    num_dip
    from   smt_periodi          smpe,
           smt_individui        smin,
           anagrafici           anag, 
           rapporti_individuali rain
    where smpe.ci = smin.ci 
      and smpe.anno = smin.anno 
      and rain.ci = smin.ci 
      and smpe.gestione like P_gestione
      and smpe.gestione = smin.gestione
      and smpe.dal between rain.dal and nvl(rain.al,smpe.dal) 
      and anag.ni = rain.ni 
      and anag.al is null 
      and nvl(smpe.universitario,'NO') = 'NO' 
      and nvl(smpe.formazione,'NO') = 'NO' 
      and nvl(smpe.telelavoro,'NO') = 'NO' 
      and nvl(smpe.lsu,'NO') = 'NO' 
      and nvl(smpe.interinale,'NO') = 'NO' 
      and (smpe.tempo_determinato = 'NO' or smpe.categoria = 'DIRSAN')  
      and smpe.anno = P_anno
      and smpe.qualifica = CUR.codice
      and P_fin_a between smpe.dal and nvl(smpe.al,P_fin_a)
      and nvl(smin.est_comandato,'NO')='NO'
    group by smin.sesso,
             decode(smpe.tempo_pieno,'SI',1,decode(greatest(smpe.part_time,50),50,2,3))
    )LOOP
     IF CUR_1.sesso ='F' THEN
        IF CUR_1.colonna = 1 THEN
           P_indenter_f := nvl(P_indenter_f,0) + CUR_1.num_dip;
        ELSIF CUR_1.colonna = 2 THEN 
           P_indet_parz50_f:= nvl(P_indet_parz50_f,0) + CUR_1.num_dip;
        ELSE 
           P_indet_parz51_f:= nvl(P_indet_parz51_f,0) + CUR_1.num_dip;
         end if;
        P_anno_ril_f := nvl(P_anno_ril_f,0) + CUR_1.num_dip;
      ELSE
        IF CUR_1.colonna = 1 THEN
          P_indenter_m := nvl(P_indenter_m,0) + CUR_1.num_dip;
        ELSIF CUR_1.colonna = 2 THEN 
          P_indet_parz50_m:= nvl(P_indet_parz50_m,0) + CUR_1.num_dip;
        ELSE 
           P_indet_parz51_m:= nvl(P_indet_parz51_m,0) + CUR_1.num_dip;
        end if;
        P_anno_ril_m := nvl(P_anno_ril_m,0) + CUR_1.num_dip;
       end if;
      END LOOP; --cur_1
   FOR CUR_2 IN
   (select smin.sesso,
           count(smpe.ci)    num_dip
    from   smt_periodi          smpe,
           smt_individui        smin,
           anagrafici           anag, 
           rapporti_individuali rain
    where smpe.ci = smin.ci 
      and smpe.anno = smin.anno 
      and rain.ci = smin.ci 
      and smpe.gestione like P_gestione
      and smpe.gestione = smin.gestione
      and smpe.dal between rain.dal and nvl(rain.al,smpe.dal) 
      and anag.ni = rain.ni 
      and anag.al is null 
      and nvl(smpe.universitario,'NO') = 'NO' 
      and nvl(smpe.formazione,'NO') = 'NO' 
      and nvl(smpe.telelavoro,'NO') = 'NO' 
      and nvl(smpe.lsu,'NO') = 'NO' 
      and nvl(smpe.interinale,'NO') = 'NO' 
      and (smpe.tempo_determinato = 'NO' or smpe.categoria = 'DIRSAN')  
      and smpe.anno = P_anno
      and smpe.qualifica = CUR.codice
      and P_fin_ap between smpe.dal and nvl(smpe.al,P_fin_ap)
      and nvl(smin.est_comandato,'NO')='NO'
    group by smin.sesso
    order by 1,2 
    )LOOP
     IF CUR_2.sesso = 'F' THEN
        P_anno_prec_f := nvl(P_anno_prec_f,0) + CUR_2.num_dip;
     ELSE
        P_anno_prec_m := nvl(P_anno_prec_m,0) + CUR_2.num_dip;
     end if;
    END LOOP; --cur_2
    IF nvl(P_anno_ril_f,0) + nvl(P_anno_ril_m,0) + nvl(P_anno_prec_f,0) + nvl(P_anno_prec_m,0) > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 1
              , P_pagina
              , P_riga
              , P_cod_reg          
              ||P_cod_azienda      
              ||lpad(to_char(P_anno),4,'0') 
              ||P_cod_comparto     
              ||lpad(CUR.codice,6,'0')
              ||lpad(to_char(greatest(nvl(P_dot_org,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_anno_ril_m,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_anno_ril_f,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_anno_prec_m,0),0)),8,'0') 
              ||lpad(to_char(greatest(nvl(P_anno_prec_f,0),0)),8,'0') 
              ||lpad(to_char(greatest(nvl(P_indenter_m,0),0)),8,'0') 
              ||lpad(to_char(greatest(nvl(P_indenter_f,0),0)),8,'0') 
              ||lpad(to_char(greatest(nvl(P_indet_parz50_m,0),0)),8,'0') 
              ||lpad(to_char(greatest(nvl(P_indet_parz50_f,0),0)),8,'0') 
              ||lpad(to_char(greatest(nvl(P_indet_parz51_m,0),0)),8,'0') 
              ||lpad(to_char(greatest(nvl(P_indet_parz51_f,0),0)),8,'0')
              ||lpad(' ',64,' ')
              ||'0' 
              );
     commit;
     P_riga := P_riga + 1;
     END IF;
/* controllo negativi */
    IF  nvl(P_dot_org,0) < 0 
     or nvl(P_anno_ril_f,0) < 0 or nvl(P_anno_ril_m,0) < 0 
     or nvl(P_anno_prec_f,0) < 0 or nvl(P_anno_prec_m,0) < 0 
     or nvl(P_indenter_f,0) < 0 or nvl(P_indenter_m,0) < 0 
     or nvl(P_indet_parz50_f,0) < 0 or nvl(P_indet_parz50_m,0) < 0 
     or nvl(P_indet_parz51_f,0) < 0 or nvl(P_indet_parz51_m,0) < 0 
   THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 29
              , P_pagina
              , P_riga_s
              , 'Verificare Tabella 1A1: Esistono Valori Negativi NON estratti per il Codice: '||lpad(CUR.codice,6,'0')
              );
    END IF; -- se negativi 
    END LOOP; -- cursore CUR --
END TAB1A1;

BEGIN -- Tab1A2 - Tabella 1 - Personale per figura professionale -- 
<<TAB1A2>>
P_ini_a   := to_date('0101'||to_char(P_anno),'ddmmyyyy');
P_fin_a  := to_date('3112'||to_char(P_anno),'ddmmyyyy');
P_pagina := 1;
P_riga   := 1;
FOR CUR IN 
(select distinct codice_ministero figura
   from figure_giuridiche
  where P_fin_a between dal and nvL(al,P_fin_a)
 order by 1
 ) LOOP
   P_anno_ril        :=0;
   P_indet_pieno     :=0;
   P_indet_parz      :=0;
   P_deter_pieno     :=0;
   P_deter_parz      :=0;
   P_com_in          :=0;
   P_com_out         :=0;

   FOR CUR_1 IN
   (select decode(smpe.tempo_pieno,'SI',1,2)   colonna,
           smin.est_comandato,
           smin.int_comandato,
           count(smpe.ci)    num_dip
    from   smt_periodi          smpe,
           smt_individui        smin,
           anagrafici           anag, 
           rapporti_individuali rain
    where smpe.ci = smin.ci 
      and smpe.anno = smin.anno 
      and rain.ci = smin.ci 
      and smpe.gestione like P_gestione
      and smpe.gestione = smin.gestione
      and smpe.dal between rain.dal and nvl(rain.al,smpe.dal) 
      and anag.ni = rain.ni 
      and anag.al is null 
      and nvl(smpe.universitario,'NO') = 'NO' 
      and nvl(smpe.formazione,'NO') = 'NO' 
      and nvl(smpe.telelavoro,'NO') = 'NO' 
      and nvl(smpe.lsu,'NO') = 'NO' 
      and nvl(smpe.interinale,'NO') = 'NO' 
      and (smpe.tempo_determinato = 'NO' or smpe.categoria = 'DIRSAN')  
      and smpe.anno = P_anno
      and smpe.figura = CUR.figura
      and P_fin_a between smpe.dal and nvl(smpe.al,P_fin_a)
    group by decode(smpe.tempo_pieno,'SI',1,2),smin.est_comandato,smin.int_comandato
    )LOOP
        IF CUR_1.colonna = 1 THEN
           P_indet_pieno := nvl(P_indet_pieno,0) + CUR_1.num_dip;
        ELSE 
           P_indet_parz  := nvl(P_indet_parz,0) + CUR_1.num_dip;
        end if;
        IF CUR_1.est_comandato ='SI' THEN
           P_com_in := nvl(P_com_in,0) + CUR_1.num_dip;
        end if;
        IF CUR_1.int_comandato = 'SI' THEN
           P_com_out := nvl(P_com_out,0) + CUR_1.num_dip;
        end if;
      END LOOP; --cur_1
   begin
   select decode( least( 1
                    , sum(decode
                          ( tempo_pieno
                          , 'SI', 1 * months_between
                                      ( least(P_fin_a
                                        , nvl(smpe.al,P_fin_a))
                                      , greatest(smpe.dal,P_ini_a)
                                      ) / 12
                          , 0
                          )
                         ))
             , 0, 0
             , 1, round(
                    sum(decode
                        ( tempo_pieno
                        , 'SI', 1 * months_between
                                    ( least( P_fin_a
                                           , nvl(smpe.al,P_fin_a))
                                           , greatest(smpe.dal,P_ini_a)
                                    ) / 12
                              , 0
                        )
                       )
                      )
                , 1)                          tpd
     , decode( least( 1
                    , sum(decode
                          ( tempo_pieno
                          , 'NO', 1 * months_between
                                      ( least(P_fin_a
                                        , nvl(smpe.al,P_fin_a))
                                      , greatest(smpe.dal,P_ini_a)
                                      ) / 12 / 2
                          , 0
                          )
                         ))
             , 0, 0
             , 1, round(
                    sum(decode
                        ( tempo_pieno
                        , 'NO', 1 * months_between
                                    ( least(P_fin_a
                                           , nvl(smpe.al,P_fin_a))
                                    , greatest(smpe.dal,P_ini_a)
                                    ) / 12 / 2
                              , 0
                        ) 
                       )
                      )
                , 1)                          ptd
  into P_deter_pieno, P_deter_parz
  from  smt_individui     smin
      , smt_periodi       smpe
  where smpe.dal             <= P_fin_a
    and nvl(smpe.al,to_date('3333333','j')) >= P_ini_a
    and smpe.anno = P_anno 
    and nvl(tempo_determinato,'NO')             = 'SI'
    and figura  = CUR.figura
    and exists
        (select 'x' from periodi_giuridici
          where rilevanza      = 'P'
            and ci             = smpe.ci 
            and dal             <= P_fin_a
            and nvl(al,to_date('3333333','j')) >= P_ini_a
        )                
    and smin.ci=smpe.ci
    and smin.anno=smpe.anno
    and smpe.gestione like P_gestione
    and smin.gestione=smpe.gestione
    and nvl(smpe.universitario,'NO') ='NO'
    and nvl(smin.est_comandato,'NO') ='NO'
    and nvl(smin.int_comandato,'NO') ='NO'
  group by 1
  having round(
          sum(decode
               ( tempo_pieno
               , 'SI', 1 * months_between
                           ( least( P_fin_a
                                  , nvl(smpe.al,P_fin_a))
                           , greatest(smpe.dal,P_ini_a)
                           ) / 12
                    , 0
               )
             )
            ) +
       round(
          sum(decode
               ( tempo_pieno
               , 'NO', 1 * months_between
                           ( least( P_fin_a
                                  , nvl(smpe.al,P_fin_a))
                           , greatest(smpe.dal,P_ini_a)
                           ) / 12 / 2
                    , 0
               )
             )
            )   != 0;
  EXCEPTION
    when NO_DATA_FOUND THEN
      P_deter_parz:=0;
      P_deter_pieno:=0;
  end;
   P_anno_ril := nvl(P_indet_pieno,0) + nvl(P_indet_parz,0);
   IF nvl(P_indet_pieno,0) + nvl(P_indet_parz,0) + nvl(P_deter_pieno,0) + nvl(P_deter_parz,0) + nvl(P_com_in,0) + nvl(P_com_out,0) > 0 
    THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 3
              , P_pagina
              , P_riga
              , P_cod_reg          
              ||P_cod_azienda      
              ||lpad(to_char(P_anno),4,'0') 
              ||P_cod_comparto     
              ||lpad(CUR.figura,6,'0')
              ||lpad(to_char(greatest(nvl(P_anno_ril,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_indet_pieno,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_indet_parz,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_deter_pieno,0),0)),8,'0') 
              ||lpad(to_char(greatest(nvl(P_deter_parz,0),0)),8,'0') 
              ||lpad(to_char(greatest(nvl(P_com_in,0),0)),8,'0') 
              ||lpad(to_char(greatest(nvl(P_com_out,0),0)),8,'0') 
              ||'0'
              );
     commit;
     P_riga := P_riga + 1;
     end if;
/* controllo negativi */
    IF  nvl(P_anno_ril,0) < 0 
     or nvl(P_indet_pieno,0) < 0 or nvl(P_indet_parz,0) < 0 
     or nvl(P_deter_pieno,0) < 0 or nvl(P_deter_parz,0) < 0 
     or nvl(P_com_in,0) < 0 or nvl(P_com_out,0) < 0 
   THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 29
              , P_pagina
              , P_riga_s
              , 'Verificare Tabella 1A2: Esistono Valori Negativi NON estratti per il Codice: '||lpad(CUR.figura,6,'0')
              );
    END IF; -- se negativi 
     END LOOP; -- cursore CUR --
END TAB1A2;

BEGIN -- Tab020 - Tabella 2 - Personale flessibile
<<TAB020>>
P_ini_a   := to_date('0101'||to_char(P_anno),'ddmmyyyy');
P_fin_a  := to_date('3112'||to_char(P_anno),'ddmmyyyy');
P_pagina := 1;
P_riga   := 1;
FOR CUR IN 
(select distinct sequenza,codice
   from categorie_ministeriali
  where length(codice)=2
 order by 1,2
 ) LOOP
   P_tempo_determ_m:=0;
   P_tempo_determ_f:=0;
   P_formaz_lav_m:=0;
   P_formaz_lav_f:=0;
   P_interinale_m:=0;
   P_interinale_f:=0;
   P_lsu_m:=0;
   P_lsu_f:=0;
   P_telelav_m:=0;
   P_telelav_f:=0;

  begin
  select sum(decode( least( 1
                    , sum(decode
                          ( smin.sesso
                          , 'M', 1 * months_between
                                     ( least( P_fin_a
                                            , nvl(smpe.al,P_fin_a))
                                     , greatest(smpe.dal,P_ini_a)
                                     ) / 12
                                     / decode( smpe.part_time
                                       , null,1, 2)
                               , 0
                          ))
                    )
             , 0, 0
             , 1, ceil(
                  sum(decode
                      (smin .sesso
                      , 'M', 1 * months_between
                                 ( least( P_fin_a
                                        , nvl(smpe.al,P_fin_a))
                                 , greatest(smpe.dal,P_ini_a)
                                 ) / 12
                                 / decode( smpe.part_time
                                         , null,1, 2)
                           , 0
                      )
                     )
                        )
                , 1))                          ptd_m
     , sum(decode( least( 1
                    , sum(decode
                          (smin.sesso
                          , 'F', 1 * months_between
                                     ( least( P_fin_a
                                            , nvl(smpe.al,P_fin_a))
                                     , greatest(smpe.dal,P_ini_a)
                                     ) / 12
                                     / decode( smpe.part_time
                                       , null,1, 2)
                               , 0
                          ))
                    )
             , 0, 0
             , 1, ceil(
                  sum(decode
                      ( smin.sesso
                      , 'F', 1 * months_between
                                 ( least( P_fin_a
                                        , nvl(smpe.al,P_fin_a))
                                 , greatest(smpe.dal,P_ini_a)
                                 ) / 12
                                 /  decode( smpe.part_time
                                       , null,1, 2)
                           , 0
                      )
                     )
                        )
                , 1) )                         ptd_f
  into P_tempo_determ_m, P_tempo_determ_f
  from smt_periodi             smpe
     , smt_individui           smin
  where nvl(smpe.formazione,'NO') = 'NO'
    and nvl(smpe.lsu,'NO') = 'NO'
    and nvl(smpe.interinale,'NO') = 'NO'
    and nvl(smpe.telelavoro,'NO') = 'NO'
    and (smpe.tempo_determinato = 'SI' and smpe.categoria not in ('DIREL','DIRSAN'))
    and nvl(smpe.universitario,'NO') = 'NO'
    and nvl(smin.est_comandato,'NO') = 'NO'
    and smpe.categoria = CUR.codice 
    and smin.ci=smpe.ci
    and smin.anno=smpe.anno
    and smpe.gestione like P_gestione
    and smin.gestione=smpe.gestione
    and smin.anno = P_anno
  group by smin.sesso
  having round(
          sum(decode
               ( smin.sesso
               , 'M', 1 * months_between
                          ( least( P_fin_a
                                 , nvl(smpe.al,P_fin_a))
                          , greatest(smpe.dal,P_ini_a)
                          ) / 12
                            /  decode( smpe.part_time
                                       , null,1, 2)
                    , 0
               )
             ),2
            )  +
       round(
          sum(decode
               ( smin.sesso
               , 'F', 1 * months_between
                          ( least( P_fin_a
                                 , nvl(smpe.al,P_fin_a))
                          , greatest(smpe.dal,P_ini_a)
                          ) / 12
                            /  decode( smpe.part_time
                                       , null,1, 2)
                    , 0
               )
             ),2
            )   != 0;
  EXCEPTION
    when NO_DATA_FOUND THEN null;
  end;
 IF  nvl(P_tempo_determ_m,0) + nvl(P_tempo_determ_f,0) + nvl(P_formaz_lav_m,0) + nvl(P_formaz_lav_f,0) +
     nvl(P_interinale_m,0) + nvl(P_interinale_f,0) + nvl(P_lsu_m,0)+ nvl(P_lsu_f,0) + nvl(P_telelav_m,0) +
     nvl(P_telelav_f,0)  > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
                ,5
                , P_pagina
                , P_riga
                , P_cod_reg          
                ||P_cod_azienda      
                ||lpad(to_char(P_anno),4,'0') 
                ||P_cod_comparto     
                ||lpad(CUR.codice,2,'0')
                ||lpad(to_char(greatest(nvl(P_tempo_determ_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_tempo_determ_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_formaz_lav_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_formaz_lav_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_interinale_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_interinale_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_lsu_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_lsu_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_telelav_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_telelav_f,0),0)),8,'0') 
                ||'0'
               )
               ;
     commit;
     P_riga := P_riga + 1;
     end if;
/* controllo negativi */
    IF  nvl(P_tempo_determ_m,0) < 0 or nvl(P_tempo_determ_f,0) < 0 
     or nvl(P_formaz_lav_m,0) < 0 or nvl(P_formaz_lav_f,0) < 0 
     or nvl(P_interinale_m,0) < 0 or nvl(P_interinale_f,0) < 0 
     or nvl(P_lsu_m,0) < 0 or nvl(P_lsu_f,0) < 0 
     or nvl(P_telelav_m,0) < 0 or nvl(P_telelav_f,0) < 0   
   THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 29
              , P_pagina
              , P_riga_s
              , 'Verificare Tabella 2: Esistono Valori Negativi NON estratti per il Codice: '||lpad(CUR.codice,2,'0')
              );
    END IF; -- se negativi 
     END LOOP; -- cursore CUR --
END TAB020;

BEGIN -- Tab030 - Tabella 3 - Personale dell''amministrazione ed esterno 
<<TAB030>>
P_fin_a  := to_date('3112'||to_char(P_anno),'ddmmyyyy');
P_pagina := 1;
P_riga   := 1;
FOR CUR IN 
(select distinct sequenza,codice
 from   qualifiche_ministeriali
 where  al is null
 order by 1,2
 ) LOOP
   P_com_in_m:=0;
   P_com_in_f:=0;
   P_com_out_m:=0;
   P_com_out_f:=0;
   P_fr_in_m:=0;
   P_fr_in_f:=0;
   P_fr_out_m:=0;
   P_fr_out_f:=0;

  for CUR_1 in 
    (select smin.sesso,
            smin.est_comandato,
            smin.int_comandato,
            smin.est_fuori_ruolo,
            smin.int_fuori_ruolo,
            count(smpe.ci) num_dip
       from  smt_periodi          smpe,
             smt_individui        smin,
             anagrafici           anag, 
             rapporti_individuali rain
           where smpe.ci = smin.ci 
             and smpe.anno = smin.anno 
             and rain.ci = smin.ci 
             and smpe.gestione like P_gestione
             and smin.gestione=smpe.gestione
             and smpe.dal between rain.dal and nvl(rain.al,smpe.dal) 
             and anag.ni = rain.ni 
             and anag.al is null 
             and nvl(smpe.universitario,'NO') = 'NO' 
             and   smpe.anno = P_anno 
             and smpe.qualifica = CUR.codice 
             and P_fin_a between smpe.dal and nvl(smpe.al,P_fin_a) 
           group by smin.sesso,smin.est_comandato,smin.int_comandato
                  , smin.est_fuori_ruolo, smin.int_fuori_ruolo
   ) loop
    IF CUR_1.est_comandato = 'SI' THEN
      IF CUR_1.sesso = 'F' THEN
        P_com_in_f := nvl(P_com_in_f,0) + CUR_1.num_dip;
      ELSE
        P_com_in_m := nvl(P_com_in_m,0) + CUR_1.num_dip;
      end if;
    end if;
    IF CUR_1.int_comandato = 'SI' THEN
      IF CUR_1.sesso = 'F' THEN
        P_com_out_f := nvl(P_com_out_f,0) + CUR_1.num_dip;
      ELSE
        P_com_out_m := nvl(P_com_out_m,0) + CUR_1.num_dip;
      end if;
    end if;

    IF CUR_1.est_fuori_ruolo = 'SI' THEN
      IF CUR_1.sesso = 'F' THEN
        P_fr_in_f := nvl(P_fr_in_f,0) + CUR_1.num_dip;
      ELSE
        P_fr_in_m := nvl(P_fr_in_m,0) + CUR_1.num_dip;
      end if;
    end if;
    IF CUR_1.int_fuori_ruolo = 'SI' THEN
      IF CUR_1.sesso = 'F' THEN
        P_fr_out_f := nvl(P_fr_out_f,0) + CUR_1.num_dip;
      ELSE
        P_fr_out_m := nvl(P_fr_out_m,0) + CUR_1.num_dip;
      end if;
    end if;


  end loop; --cur_1
 IF  nvl(P_com_in_f,0) + nvl(P_com_in_m,0) + nvl(P_com_out_f,0) + nvl(P_com_out_m,0) 
   + nvl(P_fr_in_f,0) + nvl(P_fr_in_m,0) + nvl(P_fr_out_f,0) + nvl(P_fr_out_m,0) > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
                ,7
                , P_pagina
                , P_riga
                , P_cod_reg          
                ||P_cod_azienda      
                ||lpad(to_char(P_anno),4,'0') 
                ||P_cod_comparto     
                ||lpad(CUR.codice,6,'0')
                ||lpad(to_char(greatest(nvl(P_com_out_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_com_out_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_fr_out_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_fr_out_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_com_in_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_com_in_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_fr_in_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_fr_in_f,0),0)),8,'0') 
                ||'0'
               )
               ;
     commit;
     P_riga := P_riga + 1;
     end if;
/* controllo negativi */
    IF  nvl(P_com_out_m,0) < 0 or nvl(P_com_out_f,0) < 0 
     or nvl(P_com_in_m,0) < 0 or nvl(P_com_in_f,0) < 0 
     or nvl(P_fr_out_m,0) < 0 or nvl(P_fr_out_f,0) < 0 
     or nvl(P_fr_in_m,0) < 0 or nvl(P_fr_in_f,0) < 0 
   THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 29
              , P_pagina
              , P_riga_s
              , 'Verificare Tabella 3 : Esistono Valori Negativi NON estratti per il Codice: '||lpad(CUR.codice,6,'0')
              );
    END IF; -- se negativi 
     END LOOP; -- cursore CUR --
END TAB030;

BEGIN -- Tab040 - Tabella 4 - Passaggi di ruolo / posizione economica / profilo
<<TAB040>>
P_fin_a  := to_date('3112'||to_char(P_anno),'ddmmyyyy');
P_ini_a   := to_date('0101'||to_char(P_anno),'ddmmyyyy');
P_pagina := 1;
P_riga   := 1;
for CUR in (select distinct q1.sequenza  da_sequenza, 
                            q1.codice    da_codice, 
                            q2.sequenza  a_sequenza, 
                            q2.codice    a_codice
           from qualifiche_ministeriali q1, 
                qualifiche_ministeriali q2
           where q1.codice != q2.codice
             and q1.al is null
             and q2.al is null
             and q1.categoria != 'DIRSAN'
             and q2.categoria != 'DIRSAN'
            order by 1,2,3,4) LOOP
           P_n_passaggi:=0;
  FOR CUR_1 in (select count(smpe.ci) num_dip
                  from smt_periodi          smpe
                     , smt_individui        smin
                     , anagrafici           anag 
                     , rapporti_individuali rain
                where smpe.ci = smin.ci 
                  and smpe.anno = smin.anno 
                  and rain.ci = smin.ci 
                  and smpe.gestione like P_gestione
                  and smin.gestione=smpe.gestione
                  and smpe.dal between rain.dal and nvl(rain.al,smpe.dal) 
                  and anag.ni = rain.ni 
                  and anag.al is null 
                  and nvl(smpe.universitario,'NO') = 'NO' 
                  and nvl(smpe.formazione,'NO') = 'NO' 
                  and nvl(smpe.telelavoro,'NO') = 'NO' 
                  and nvl(smpe.lsu,'NO') = 'NO' 
                  and nvl(smpe.interinale,'NO') = 'NO' 
                  and (smpe.tempo_determinato = 'NO' or smpe.categoria = 'DIRSAN') 
                  and smpe.anno = P_anno 
                  and smpe.da_qualifica = CUR.da_codice 
                  and smpe.qualifica = CUR.a_codice 
                  and nvl(smin.est_comandato,'NO') = 'NO' 
                  and smpe.dal between P_ini_a and P_fin_a
             ) LOOP
            P_n_passaggi:= nvl(P_n_passaggi,0) + CUR_1.num_dip;
  end loop; --cur_1
 IF  P_n_passaggi > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
                ,9
                , P_pagina
                , P_riga
                , P_cod_reg          
                ||P_cod_azienda      
                ||lpad(to_char(P_anno),4,'0') 
                ||P_cod_comparto     
                ||lpad(CUR.da_codice,6,'0')
                ||lpad(CUR.a_codice,6,'0')
                ||lpad(to_char(greatest(nvl(P_n_passaggi,0),0)),8,'0')
                ||'0'
               )
               ;
     commit;
     P_riga := P_riga + 1;
     end if;
/* controllo negativi */
    IF  nvl(P_n_passaggi,0) < 0 THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 29
              , P_pagina
              , P_riga_s
              , 'Verificare Tabella 4: Esistono Valori Negativi NON estratti per il Codice: '||lpad(CUR.da_codice,6,'0')
                ||', Codice Entrata : '||lpad(CUR.a_codice,6,'0')
              );
    END IF; -- se negativi 
     END LOOP; -- cursore CUR --
END TAB040;

BEGIN -- Tab200 - Tabella 5 - Personale cessato
<<TAB200>>
P_fin_a  := to_date('3112'||to_char(P_anno),'ddmmyyyy');
P_ini_a   := to_date('0101'||to_char(P_anno),'ddmmyyyy');
P_pagina := 1;
P_riga   := 1;
for CUR in 
    (select distinct sequenza, codice
       from qualifiche_ministeriali
     where P_fin_a between dal and nvl(al,P_fin_a)
       order by 1,2) LOOP
            P_limiti_m       :=0;
            P_limiti_f       :=0;
            P_dimissioni_m   :=0;
            P_dimissioni_f   :=0;
            P_altre_amm_m    :=0;
            P_altre_amm_f    :=0;
            P_altre_amm_59_m :=0;
            P_altre_amm_59_f :=0;
            P_altre_cause_m  :=0;
            P_altre_cause_f  :=0;
            P_totale_m       :=0;
            P_totale_f       :=0;

  FOR CUR_1 in 
       (select smin.sesso
             , decode(smpe.cessazione,'ASP',5,evra.conto_annuale) colonna
             , count(smpe.ci) num_dip
          from  eventi_rapporto evra,
                smt_periodi          smpe,
                smt_individui        smin,
                anagrafici           anag, 
                rapporti_individuali rain
          where smpe.ci = smin.ci 
            and smpe.anno = smin.anno 
            and rain.ci = smin.ci 
            and smpe.gestione like P_gestione
            and smin.gestione=smpe.gestione
            and smpe.dal between rain.dal and nvl(rain.al,smpe.dal) 
            and anag.ni = rain.ni 
            and anag.al is null 
            and nvl(smpe.universitario,'NO') = 'NO' 
            and nvl(smpe.formazione,'NO') = 'NO' 
            and nvl(smpe.telelavoro,'NO') = 'NO' 
            and nvl(smpe.lsu,'NO') = 'NO' 
            and nvl(smpe.interinale,'NO') = 'NO' 
            and smpe.anno = P_anno 
            and smpe.qualifica = CUR.codice              
            and smpe.al between P_ini_a-1 and P_fin_a-1 
            and nvl(smin.est_comandato,'NO') = 'NO' 
            and evra.codice(+) = smpe.cessazione 
            and (smpe.tempo_determinato = 'NO' or smpe.categoria = 'DIRSAN') 
            and smpe.cessazione is not null 
          group by smin.sesso,decode(smpe.cessazione,'ASP',5,evra.conto_annuale) 
      ) LOOP
    IF CUR_1.sesso = 'F' THEN
      IF CUR_1.colonna = 1 THEN
            P_limiti_f := nvl(P_limiti_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.colonna = 2 THEN
                P_dimissioni_f:= nvl(P_dimissioni_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.colonna = 3 THEN
                P_altre_amm_f := nvl(P_altre_amm_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.colonna = 4 THEN
                P_altre_amm_59_f := nvl(P_altre_amm_59_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.colonna = 5 THEN
                P_altre_cause_f := nvl(P_altre_cause_f,0) + CUR_1.num_dip;
      end if;
      IF CUR_1.colonna is not null THEN
         P_totale_f := nvl(P_totale_f,0) + CUR_1.num_dip;
      end if;
    ELSE
      IF CUR_1.colonna = 1 THEN
                P_limiti_m := nvl(P_limiti_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.colonna = 2 THEN
                P_dimissioni_m := nvl(P_dimissioni_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.colonna = 3 THEN
                P_altre_amm_m := nvl(P_altre_amm_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.colonna = 4 THEN
                P_altre_amm_59_m := nvl(P_altre_amm_59_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.colonna = 5 THEN
                P_altre_cause_m := nvl(P_altre_cause_m,0) + CUR_1.num_dip;
      end if;
      IF CUR_1.colonna is not null THEN
        P_totale_m := nvl(P_totale_m,0) + CUR_1.num_dip;
      end if;
    end if;
  END LOOP; --cur_1
 IF  nvl(P_totale_f,0) + nvl(P_totale_m,0) > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
                ,11
                , P_pagina
                , P_riga
                , P_cod_reg          
                ||P_cod_azienda      
                ||lpad(to_char(P_anno),4,'0') 
                ||P_cod_comparto     
                ||lpad(CUR.codice,6,'0')
                ||lpad(to_char(greatest(nvl(P_limiti_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_limiti_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_dimissioni_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_dimissioni_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_altre_amm_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_altre_amm_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_altre_amm_59_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_altre_amm_59_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_altre_cause_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_altre_cause_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_totale_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_totale_f,0),0)),8,'0') 
                ||'0'
               )
               ;
     commit;
     P_riga := P_riga + 1;
     end if;
/* controllo negativi */
    IF nvl(P_limiti_m,0) < 0 or nvl(P_limiti_f,0) < 0
    or nvl(P_dimissioni_m,0) < 0 or nvl(P_dimissioni_f,0) < 0
    or nvl(P_altre_amm_m,0) < 0 or nvl(P_altre_amm_f,0) < 0
    or nvl(P_altre_amm_59_m,0) < 0 or nvl(P_altre_amm_59_f,0) < 0
    or nvl(P_altre_cause_m,0) < 0 or nvl(P_altre_cause_f,0) < 0
    or nvl(P_totale_m,0) < 0 or nvl(P_totale_f,0)  < 0 
    THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 29
              , P_pagina
              , P_riga_s
              , 'Verificare Tabella 5: Esistono Valori Negativi NON estratti per il Codice: '||lpad(CUR.codice,6,'0')
              );
    END IF; -- se negativi 
     END LOOP; -- cursore CUR --
END TAB200;

BEGIN -- Tab300 - Tabella 6 - Personale assunto -- 
<<TAB300>>
P_fin_a  := to_date('3112'||to_char(P_anno),'ddmmyyyy');
P_ini_a   := to_date('0101'||to_char(P_anno),'ddmmyyyy');
P_pagina := 1;
P_riga   := 1;
for CUR in 
     (select distinct sequenza, codice
        from qualifiche_ministeriali
      where al is null
       order by 1,2) LOOP
            P_altre_amm_m    :=0;
            P_altre_amm_f    :=0;
            P_altre_amm_59_m :=0;
            P_altre_amm_59_f :=0;
            P_altre_cause_m  :=0;
            P_altre_cause_f  :=0;
            P_totale_m       :=0;
            P_totale_f       :=0;
            P_concorso_m     :=0;
            P_concorso_f     :=0;

  FOR CUR_1 in 
   (select smin.sesso, 
              decode(smpe.assunzione,'TASP',1,evra.conto_annuale) colonna,
              count(smpe.ci) num_dip
      from  eventi_rapporto evra,
                smt_periodi          smpe,
                smt_individui        smin,
                anagrafici           anag, 
                rapporti_individuali rain
          where smpe.ci = smin.ci 
            and smpe.anno = smin.anno 
            and smpe.gestione like P_gestione
            and smin.gestione=smpe.gestione
            and rain.ci = smin.ci 
            and smpe.dal between rain.dal and nvl(rain.al,smpe.dal) 
            and anag.ni = rain.ni 
            and anag.al is null 
            and smpe.anno = P_anno 
            and smpe.qualifica = CUR.codice              
            and smpe.dal between P_ini_a and P_fin_a 
            and (nvl(smpe.TEMPO_DETERMINATO,'NO')='NO' 
              or smpe.categoria in ('DIREL','DIRSAN'))
            and nvl(smpe.universitario,'NO') = 'NO' 
            and nvl(smin.est_comandato,'NO')='NO'
            and ( exists
                  (select 'x' from periodi_giuridici
                    where ci        = smpe.ci
                      and dal       = smpe.dal
                      and rilevanza = 'P')
                 or smpe.assunzione = 'TASP')
            and evra.codice(+) = smpe.assunzione
            and smpe.assunzione is not null 
          group by smin.sesso,decode(smpe.assunzione,'TASP',1,evra.conto_annuale) 
     ) LOOP
    IF CUR_1.sesso = 'F' THEN
      IF CUR_1.colonna = 1 THEN
                P_altre_amm_f := nvl(P_altre_amm_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.colonna = 2 THEN
                P_altre_amm_59_f := nvl(P_altre_amm_59_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.colonna = 3 THEN
         P_concorso_f:= nvl(P_concorso_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.colonna = 4 THEN
                P_altre_cause_f := nvl(P_altre_cause_f,0) + CUR_1.num_dip;
      end if;
      IF CUR_1.colonna is not null THEN
        P_totale_f := nvl(P_totale_f,0) + CUR_1.num_dip;
      end if;
    ELSE
      IF CUR_1.colonna = 1 THEN
                P_altre_amm_m := nvl(P_altre_amm_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.colonna = 2 THEN
                P_altre_amm_59_m := nvl(P_altre_amm_59_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.colonna = 3 THEN
             P_concorso_m := nvl(P_concorso_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.colonna = 4 THEN
                P_altre_cause_m := nvl(P_altre_cause_m,0) + CUR_1.num_dip;
      end if;
      IF CUR_1.colonna is not null THEN
         P_totale_m := nvl(P_totale_m,0) + CUR_1.num_dip;
      end if;
    end if;
  END LOOP; --cur_1
 IF  nvl(P_totale_f,0) +  nvl(P_totale_m,0) > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
                ,13
                , P_pagina
                , P_riga
                , P_cod_reg          
                ||P_cod_azienda      
                ||lpad(to_char(P_anno),4,'0') 
                ||P_cod_comparto     
                ||lpad(CUR.codice,6,'0')
                ||lpad(to_char(greatest(nvl(P_altre_amm_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_altre_amm_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_altre_amm_59_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_altre_amm_59_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_concorso_m,0),0)),8,'0')
                ||lpad(to_char(greatest(nvl(P_concorso_f,0),0)),8,'0')
                ||lpad(to_char(greatest(nvl(P_altre_cause_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_altre_cause_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_totale_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_totale_f,0),0)),8,'0') 
                ||'0'
               )
               ;
     commit;
     P_riga := P_riga + 1;
     end if;
/* controllo negativi */
    IF nvl(P_altre_amm_m,0) < 0 or nvl(P_altre_amm_f,0) < 0
    or nvl(P_altre_amm_59_m,0) < 0 or nvl(P_altre_amm_59_f,0) < 0
    or nvl(P_concorso_m,0) < 0 or nvl(P_concorso_f,0) < 0 
    or nvl(P_altre_cause_m,0) < 0 or nvl(P_altre_cause_f,0) < 0
    or nvl(P_totale_m,0) < 0 or nvl(P_totale_f,0)  < 0 
    THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 29
              , P_pagina
              , P_riga_s
              , 'Verificare Tabella 6: Esistono Valori Negativi NON estratti per il Codice: '||lpad(CUR.codice,6,'0')
              );
    END IF; -- se negativi 
     END LOOP; -- cursore CUR --
END TAB300;

BEGIN -- Tab500 - Tabella 7 - Personale per anzianita
<<TAB500>>
P_fin_a  := to_date('3112'||to_char(P_anno),'ddmmyyyy');
P_ini_a   := to_date('0101'||to_char(P_anno),'ddmmyyyy');
P_pagina := 1;
P_riga   := 1;
for CUR in 
    (select distinct sequenza, codice
       from qualifiche_ministeriali
     where P_fin_a between dal and nvl(al,P_fin_a)
      order by 1,2) LOOP
            P_da_0a5_m:=0;
            P_da_0a5_f:=0;
            P_da_6a10_m:=0;
            P_da_6a10_f:=0;
            P_da_11a15_m:=0;
            P_da_11a15_f:=0;
            P_da_16a20_m:=0;
            P_da_16a20_f:=0;
            P_da_21a25_m:=0;
            P_da_21a25_f:=0;
            P_da_26a30_m:=0;
            P_da_26a30_f:=0;
            P_da_31a35_m:=0;
            P_da_31a35_f:=0;
            P_da_36a40_m:=0;
            P_da_36a40_f:=0;
            P_oltre_40_m:=0;
            P_oltre_40_f:=0;  
            P_totale_m:=0;
            P_totale_f:=0;

  FOR CUR_1 in 
        (select smin.sesso, 
                ( nvl(smin.anzianita,0) + nvl(smin.anzianita_mm,0)/12 + nvl(smin.anzianita_gg,0)/365
              + nvl(smin.anzianita_prec,0) + nvl(smin.anzianita_prec_mm,0)/12 + nvl(smin.anzianita_prec_gg,0)/365 )  anzianita,
                count(smpe.ci) num_dip
       from  smt_periodi          smpe,
                smt_individui        smin
          where smpe.ci = smin.ci 
            and smpe.anno = smin.anno 
            and smpe.gestione like P_gestione
            and smpe.gestione = smin.gestione
            and nvl(smpe.universitario,'NO') = 'NO' 
            and nvl(smpe.formazione,'NO') = 'NO' 
            and nvl(smpe.telelavoro,'NO') = 'NO' 
            and nvl(smpe.lsu,'NO') = 'NO' 
            and nvl(smpe.interinale,'NO') = 'NO' 
            and smpe.anno = P_anno 
            and smpe.qualifica = CUR.codice              
            and P_fin_a between smpe.dal and nvl(smpe.al,P_fin_a) 
            and nvl(smin.est_comandato,'NO') = 'NO'
            and (smpe.tempo_determinato = 'NO' or smpe.categoria = 'DIRSAN') 
          group by smin.sesso
             , ( nvl(smin.anzianita,0) + nvl(smin.anzianita_mm,0)/12 + nvl(smin.anzianita_gg,0)/365
              + nvl(smin.anzianita_prec,0) + nvl(smin.anzianita_prec_mm,0)/12 + nvl(smin.anzianita_prec_gg,0)/365 )
          order by 1,2
  ) LOOP
    IF CUR_1.sesso = 'F' THEN
      IF ceil(CUR_1.anzianita) between 0 and 5 THEN
        P_da_0a5_f := nvl(P_da_0a5_f,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) between 6 and 10 THEN
        P_da_6a10_f := nvl(P_da_6a10_f,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) between 11 and 15 THEN
        P_da_11a15_f := nvl(P_da_11a15_f,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) between 16 and 20 THEN
        P_da_16a20_f := nvl(P_da_16a20_f,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) between 21 and 25 THEN
        P_da_21a25_f := nvl(P_da_21a25_f,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) between 26 and 30 THEN
        P_da_26a30_f := nvl(P_da_26a30_f,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) between 31 and 35 THEN
        P_da_31a35_f := nvl(P_da_31a35_f,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) between 36 and 40 THEN
        P_da_36a40_f := nvl(P_da_36a40_f,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) > 40 THEN
        P_oltre_40_f := nvl(P_oltre_40_f,0) + CUR_1.num_dip;
      end if;
      P_totale_f := nvl(P_totale_f,0) + CUR_1.num_dip;
    ELSIF CUR_1.sesso ='M' THEN
      IF ceil(CUR_1.anzianita) between 0 and 5 THEN
        P_da_0a5_m := nvl(P_da_0a5_m,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) between 6 and 10 THEN
        P_da_6a10_m := nvl(P_da_6a10_m,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) between 11 and 15 THEN
        P_da_11a15_m := nvl(P_da_11a15_m,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) between 16 and 20 THEN
        P_da_16a20_m := nvl(P_da_16a20_m,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) between 21 and 25 THEN
        P_da_21a25_m := nvl(P_da_21a25_m,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) between 26 and 30 THEN
        P_da_26a30_m := nvl(P_da_26a30_m,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) between 31 and 35 THEN
        P_da_31a35_m := nvl(P_da_31a35_m,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) between 36 and 40 THEN
        P_da_36a40_m := nvl(P_da_36a40_m,0) + CUR_1.num_dip;
      ELSIF ceil(CUR_1.anzianita) > 40 THEN
        P_oltre_40_m := nvl(P_oltre_40_m,0) + CUR_1.num_dip;
      end if;
      P_totale_m := nvl(P_totale_m,0) + CUR_1.num_dip;
    end if;
  END LOOP; --cur_1
 IF  nvl(P_totale_f,0) + P_totale_m > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
                ,15
                , P_pagina
                , P_riga
                , P_cod_reg          
                ||P_cod_azienda      
                ||lpad(to_char(P_anno),4,'0') 
                ||P_cod_comparto     
                ||lpad(CUR.codice,6,'0')
                ||lpad(to_char(greatest(nvl(P_da_0a5_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_0a5_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_6a10_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_6a10_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_11a15_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_11a15_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_16a20_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_16a20_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_21a25_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_21a25_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_26a30_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_26a30_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_31a35_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_31a35_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_36a40_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_36a40_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_oltre_40_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_oltre_40_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_totale_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_totale_f,0),0)),8,'0') 
                ||'0'
               )
               ;
     commit;
     P_riga := P_riga + 1;
     end if;
/* controllo negativi */
    IF nvl(P_da_0a5_m,0) < 0 or nvl(P_da_0a5_f,0) < 0
    or nvl(P_da_6a10_m,0) < 0 or nvl(P_da_6a10_f,0) < 0
    or nvl(P_da_11a15_m,0) < 0 or nvl(P_da_11a15_f,0) < 0
    or nvl(P_da_16a20_m,0) < 0 or nvl(P_da_16a20_f,0) < 0
    or nvl(P_da_21a25_m,0) < 0 or nvl(P_da_21a25_f,0) < 0
    or nvl(P_da_26a30_m,0) < 0 or nvl(P_da_26a30_f,0) < 0
    or nvl(P_da_31a35_m,0) < 0 or nvl(P_da_31a35_f,0) < 0
    or nvl(P_da_36a40_m,0) < 0 or nvl(P_da_36a40_f,0) < 0
    or nvl(P_oltre_40_m,0) < 0 or nvl(P_oltre_40_f,0) < 0
    or nvl(P_totale_m,0) < 0 or nvl(P_totale_f,0) < 0
    THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 29
              , P_pagina
              , P_riga_s
              , 'Verificare Tabella 7: Esistono Valori Negativi NON estratti per il Codice: '||lpad(CUR.codice,6,'0')
              );
    END IF; -- se negativi 
     END LOOP; -- cursore CUR --
END TAB500;

BEGIN -- Tab080 - Tabella 8 - Personale per eta
<<TAB080>>
P_fin_a  := to_date('3112'||to_char(P_anno),'ddmmyyyy');
P_ini_a   := to_date('0101'||to_char(P_anno),'ddmmyyyy');
P_pagina := 1;
P_riga   := 1;
for CUR in 
        ( select distinct sequenza, codice
            from qualifiche_ministeriali
           where al is null
            order by 1,2
           ) LOOP
            P_fino_a19_m:=0;
            P_fino_a19_f:=0;
            P_da_20a24_m:=0;
            P_da_20a24_f:=0;
            P_da_25a29_m:=0;
            P_da_25a29_f:=0;
            P_da_30a34_m:=0;
            P_da_30a34_f:=0;
            P_da_35a39_m:=0;
            P_da_35a39_f:=0;
            P_da_40a44_m:=0;
            P_da_40a44_f:=0;
            P_da_45a49_m:=0;
            P_da_45a49_f:=0;
            P_da_50a54_m:=0;
            P_da_50a54_f:=0;
            P_da_55a59_m:=0;
            P_da_55a59_f:=0;
            P_da_60a64_m:=0;
            P_da_60a64_f:=0;
            P_oltre_64_m:=0;
            P_oltre_64_f:=0;
            P_totale_m:=0;
            P_totale_f:=0;

  FOR CUR_1 in 
      (select smin.sesso, 
                  smin.eta eta,
                  count(smpe.ci) num_dip
        from  smt_periodi          smpe,
                  smt_individui        smin
          where smpe.ci = smin.ci 
            and smpe.anno = smin.anno 
            and smpe.gestione like P_gestione
            and smpe.gestione = smin.gestione
            and nvl(smpe.universitario,'NO') = 'NO' 
            and nvl(smpe.formazione,'NO') = 'NO' 
            and nvl(smpe.telelavoro,'NO') = 'NO' 
            and nvl(smpe.lsu,'NO') = 'NO' 
            and nvl(smpe.interinale,'NO') = 'NO' 
            and smpe.anno = P_anno 
            and smpe.qualifica = CUR.codice              
            and (smpe.tempo_determinato = 'NO' or smpe.categoria = 'DIRSAN') 
            and P_fin_a between smpe.dal and nvl(smpe.al,P_fin_a) 
            and nvl(smin.est_comandato,'NO') = 'NO'
          group by smin.sesso,smin.eta
          order by 1,2
  ) LOOP
   IF CUR_1.sesso = 'F' THEN
      IF CUR_1.eta between 0 and 19 THEN
        P_fino_a19_f := nvl(P_fino_a19_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 20 and 24 THEN
        P_da_20a24_f := nvl(P_da_20a24_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 25 and 29 THEN
        P_da_25a29_f := nvl(P_da_25a29_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 30 and 34 THEN
        P_da_30a34_f := nvl(P_da_30a34_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 35 and 39 THEN
        P_da_35a39_f := nvl(P_da_35a39_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 40 and 44 THEN
        P_da_40a44_f := nvl(P_da_40a44_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 45 and 49 THEN
        P_da_45a49_f := nvl(P_da_45a49_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 50 and 54 THEN
        P_da_50a54_f := nvl(P_da_50a54_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 55 and 59 THEN
        P_da_55a59_f := nvl(P_da_55a59_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 60 and 64 THEN
        P_da_60a64_f := nvl(P_da_60a64_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta > 64 THEN
        P_oltre_64_f := nvl(P_oltre_64_f,0) + CUR_1.num_dip;
      end if;
      IF CUR_1.eta is not null THEN
        P_totale_f := nvl(P_totale_f,0) + CUR_1.num_dip;
      end if;
    ELSIF CUR_1.sesso ='M' THEN
      IF CUR_1.eta between 0 and 19 THEN
        P_fino_a19_m := nvl(P_fino_a19_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 20 and 24 THEN
        P_da_20a24_m := nvl(P_da_20a24_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 25 and 29 THEN
        P_da_25a29_m := nvl(P_da_25a29_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 30 and 34 THEN
        P_da_30a34_m := nvl(P_da_30a34_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 35 and 39 THEN
        P_da_35a39_m := nvl(P_da_35a39_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 40 and 44 THEN
        P_da_40a44_m := nvl(P_da_40a44_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 45 and 49 THEN
        P_da_45a49_m := nvl(P_da_45a49_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 50 and 54 THEN
        P_da_50a54_m := nvl(P_da_50a54_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 55 and 59 THEN
        P_da_55a59_m := nvl(P_da_55a59_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta between 60 and 64 THEN
        P_da_60a64_m := nvl(P_da_60a64_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.eta > 64 THEN
        P_oltre_64_m := nvl(P_oltre_64_m,0) + CUR_1.num_dip;
      end if;
      IF CUR_1.eta is not null THEN
        P_totale_m := nvl(P_totale_m,0) + CUR_1.num_dip;
      end if;
    end if;
  END LOOP; --cur_1
 IF  nvl(P_totale_f,0) + P_totale_m > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
                ,17
                , P_pagina
                , P_riga
                , P_cod_reg          
                ||P_cod_azienda      
                ||lpad(to_char(P_anno),4,'0') 
                ||P_cod_comparto     
                ||lpad(CUR.codice,6,'0')
                ||lpad(to_char(greatest(nvl(P_fino_a19_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_fino_a19_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_20a24_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_20a24_f,0),0)),8,'0')
                ||lpad(to_char(greatest(nvl(P_da_25a29_m,0),0)),8,'0')
                ||lpad(to_char(greatest(nvl(P_da_25a29_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_30a34_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_30a34_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_35a39_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_35a39_f,0),0)),8,'0')
                ||lpad(to_char(greatest(nvl(P_da_40a44_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_40a44_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_45a49_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_45a49_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_50a54_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_50a54_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_55a59_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_55a59_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_60a64_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_da_60a64_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_oltre_64_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_oltre_64_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_totale_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_totale_f,0),0)),8,'0') 
                ||'0'
               )
               ;
     commit;
     P_riga := P_riga + 1;
     end if;
/* controllo negativi */
    IF nvl(P_fino_a19_m,0) < 0 or nvl(P_fino_a19_f,0) < 0 
    or nvl(P_da_20a24_m,0) < 0 or nvl(P_da_20a24_f,0) < 0 
    or nvl(P_da_25a29_m,0) < 0 or nvl(P_da_25a29_f,0) < 0 
    or nvl(P_da_30a34_m,0) < 0 or nvl(P_da_30a34_f,0) < 0 
    or nvl(P_da_35a39_m,0) < 0 or nvl(P_da_35a39_f,0) < 0 
    or nvl(P_da_40a44_m,0) < 0 or nvl(P_da_40a44_f,0) < 0 
    or nvl(P_da_45a49_m,0) < 0 or nvl(P_da_45a49_f,0) < 0 
    or nvl(P_da_50a54_m,0) < 0 or nvl(P_da_50a54_f,0) < 0 
    or nvl(P_da_55a59_m,0) < 0 or nvl(P_da_55a59_f,0) < 0 
    or nvl(P_da_60a64_m,0) < 0 or nvl(P_da_60a64_f,0) < 0 
    or nvl(P_oltre_64_m,0) < 0 or nvl(P_oltre_64_f,0) < 0 
    or nvl(P_totale_m,0) < 0 or nvl(P_totale_f,0) < 0
    THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 29
              , P_pagina
              , P_riga_s
              , 'Verificare Tabella 8: Esistono Valori Negativi NON estratti per il Codice: '||lpad(CUR.codice,6,'0')
              );
    END IF; -- se negativi 
     END LOOP; -- cursore CUR --
END TAB080;

BEGIN -- Tab600 - Tabella 9 - personale per titolo di studio
<<TAB600>>
P_fin_a  := to_date('3112'||to_char(P_anno),'ddmmyyyy');
P_ini_a   := to_date('0101'||to_char(P_anno),'ddmmyyyy');
P_pagina := 1;
P_riga   := 1;
for CUR in 
         (select distinct sequenza, codice
            from qualifiche_ministeriali
          where al is null
           order by 1,2) LOOP
            P_obbligo_m:=0;
            P_obbligo_f:=0;
            P_superiore_m:=0;
            P_superiore_f:=0;
            P_laurea_m:=0;
            P_laurea_f:=0;
            P_postlaurea_m:=0;
            P_postlaurea_f:=0;
            P_totale_m:=0;
            P_totale_f:=0;

  FOR CUR_1 in 
       (select smin.sesso, 
               tist.conto_annuale col_titstu,
               count(smpe.ci) num_dip
       from  smt_periodi          smpe,
                smt_individui        smin,
                anagrafici           anag, 
                titoli_studio        tist,
                rapporti_individuali rain
          where smpe.ci = smin.ci 
            and smpe.anno = smin.anno 
            and rain.ci = smin.ci 
            and smpe.gestione like P_gestione
            and smpe.gestione = smin.gestione
            and smpe.dal between rain.dal and nvl(rain.al,smpe.dal) 
            and anag.ni = rain.ni 
            and anag.al is null 
            and tist.codice = anag.titolo_studio 
            and nvl(smpe.universitario,'NO') = 'NO' 
            and nvl(smpe.formazione,'NO') = 'NO' 
            and nvl(smpe.telelavoro,'NO') = 'NO' 
            and nvl(smpe.lsu,'NO') = 'NO' 
            and nvl(smpe.interinale,'NO') = 'NO' 
            and smpe.anno = P_anno 
            and (smpe.tempo_determinato = 'NO' or smpe.categoria = 'DIRSAN') 
            and smpe.qualifica = CUR.codice              
            and P_fin_a between smpe.dal and nvl(smpe.al,P_fin_a) 
            and nvl(smin.est_comandato,'NO') = 'NO'
          group by smin.sesso,tist.conto_annuale
          order by 1,2
        ) LOOP
   IF CUR_1.sesso = 'F' THEN
      IF CUR_1.col_titstu = '1' THEN
        P_obbligo_f := nvl(P_obbligo_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.col_titstu = '2' THEN
        P_superiore_f := nvl(P_superiore_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.col_titstu = '3' THEN
        P_laurea_f := nvl(P_laurea_f,0) + CUR_1.num_dip;
      ELSIF CUR_1.col_titstu = '4' THEN
        P_postlaurea_f := nvl(P_postlaurea_f,0) + CUR_1.num_dip;
      end if;
      IF CUR_1.col_titstu is not null THEN
        P_totale_f := nvl(P_totale_f,0) + CUR_1.num_dip;
      end if;
    ELSIF CUR_1.sesso ='M' THEN
      IF CUR_1.col_titstu = '1' THEN
        P_obbligo_m := nvl(P_obbligo_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.col_titstu = '2' THEN
        P_superiore_m := nvl(P_superiore_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.col_titstu = '3' THEN
        P_laurea_m := nvl(P_laurea_m,0) + CUR_1.num_dip;
      ELSIF CUR_1.col_titstu = '4' THEN
        P_postlaurea_m := nvl(P_postlaurea_m,0) + CUR_1.num_dip;
      end if;
      IF CUR_1.col_titstu is not null THEN
        P_totale_m := nvl(P_totale_m,0) + CUR_1.num_dip;
      end if;
    end if;
  END LOOP; -- cur_1
 IF  nvl(P_totale_f,0) + P_totale_m > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
                ,19
                , P_pagina
                , P_riga
                , P_cod_reg          
                ||P_cod_azienda      
                ||lpad(to_char(P_anno),4,'0') 
                ||P_cod_comparto     
                ||lpad(CUR.codice,6,'0')
                ||lpad(to_char(greatest(nvl(P_obbligo_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_obbligo_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_superiore_m,0),0)),8,'0')
                ||lpad(to_char(greatest(nvl(P_superiore_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_laurea_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_laurea_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_postlaurea_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_postlaurea_f,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_totale_m,0),0)),8,'0') 
                ||lpad(to_char(greatest(nvl(P_totale_f,0),0)),8,'0') 
                ||'0'
               )
               ;
     commit;
     P_riga := P_riga + 1;
     end if;
/* controllo negativi */
    IF nvl(P_obbligo_m,0) < 0 or nvl(P_obbligo_f,0) < 0 
    or nvl(P_superiore_m,0) < 0 or nvl(P_superiore_f,0) < 0 
    or nvl(P_laurea_m,0) < 0 or nvl(P_laurea_f,0) < 0 
    or nvl(P_postlaurea_m,0) < 0 or nvl(P_postlaurea_f,0) < 0 
    or nvl(P_totale_m,0) < 0 or nvl(P_totale_f,0) < 0 
    THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 29
              , P_pagina
              , P_riga_s
              , 'Verificare Tabella 9: Esistono Valori Negativi NON estratti per il Codice: '||lpad(CUR.codice,6,'0')
              );
    END IF; -- se negativi 
     END LOOP; -- cursore CUR --
END TAB600;

BEGIN -- Tab8A0 - Tabella 12 - Spesa annua di retribuzione
<<TAB8A0>>
P_fin_a  := to_date('3112'||to_char(P_anno),'ddmmyyyy');
P_ini_a   := to_date('0101'||to_char(P_anno),'ddmmyyyy');
P_pagina := 1;
P_riga   := 1;
for CUR in 
          (select distinct sequenza, codice
            from qualifiche_ministeriali
          where al is null
           order by 1,2) LOOP
            P_nro_mensilita:=0;
            P_stipendi:=0;
            P_inden_integr:=0;
            P_ria:=0;
            P_tredicesima:=0;
            P_arretrati_ac:=0;
            P_arretrati_ap:=0;
            P_filler:=0;
            P_recuperi:=0;
            P_totale:=0;

  FOR CUR_1 in (select smin.colonna, 
                       sum(smin.importo) importo
                  from smt_importi smin, smt_periodi smpe
                 where smpe.anno = P_anno
                   and smpe.qualifica = CUR.codice 
                   and smpe.gestione like P_gestione
                   and smpe.gestione = smin.gestione
                   and nvl(smpe.universitario,'NO') = 'NO' 
                   and nvl(smpe.formazione,'NO') = 'NO' 
                   and nvl(smpe.telelavoro,'NO') = 'NO' 
                   and nvl(smpe.lsu,'NO') = 'NO' 
                   and nvl(smpe.interinale,'NO') = 'NO' 
                   and (smpe.tempo_determinato = 'NO' or smpe.categoria = 'DIRSAN') 
                   and smin.anno = smpe.anno 
                   and smin.ci = smpe.ci 
                   and smin.dal = smpe.dal 
                   and smin.tabella = 'T12' 
                 group by smin.colonna
                 order by smin.colonna ) LOOP

  IF CUR_1.colonna = 'GG' THEN
      P_nro_mensilita := nvl(P_nro_mensilita,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = 'STIPENDI' THEN
      P_stipendi := nvl(P_stipendi,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = 'IIS' THEN
      P_inden_integr := nvl(P_inden_integr,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = 'RIA' THEN
      P_ria := nvl(P_ria,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = '13A' THEN
      P_tredicesima := nvl(P_tredicesima,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = 'ARRETRATI' THEN
      P_arretrati_ac := nvl(P_arretrati_ac,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = 'ARRETRATI_AP' THEN
      P_arretrati_ap := nvl(P_arretrati_ap,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = 'RECUPERI' THEN
      P_recuperi := nvl(P_recuperi,0) + CUR_1.importo;
  END IF;
    IF CUR_1.colonna is not null and CUR_1.colonna != 'GG' THEN
      IF CUR_1.colonna = 'RECUPERI' THEN
        P_totale := nvl(P_totale,0) + round(nvl(CUR_1.importo,0));
      ELSE
        P_totale := nvl(P_totale,0) + round(greatest(nvl(CUR_1.importo,0),0));
      END IF;
    END IF; 
  END LOOP; --cur_1
 IF  nvl(P_totale,0) > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
                ,21
                , P_pagina
                , P_riga
                , P_cod_reg          
                ||P_cod_azienda      
                ||lpad(to_char(P_anno),4,'0') 
                ||P_cod_comparto     
                ||lpad(CUR.codice,6,'0')
                ||decode(sign(nvl(P_nro_mensilita,0))
                        ,-1,lpad('0',8,'0')||','||lpad('0',2,'0')
                           ,lpad(to_char(trunc(nvl(P_nro_mensilita,0),0)),8,'0') ||',' 
                          ||rpad(replace(to_char(mod(nvl(P_nro_mensilita,0),1)),'.',''),2,'0') 
                        )
                ||lpad(to_char(round(greatest(nvl(P_stipendi,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_inden_integr,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_ria,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_tredicesima,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_arretrati_ac,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_arretrati_ap,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_filler,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(decode(sign(nvl(P_recuperi,0))
                                                    ,-1,nvl(P_recuperi,0)*-1,nvl(P_recuperi,0)),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_totale,0),0))),12,'0') 
                ||'0'
               )
               ;
     commit;
     P_riga := P_riga + 1;
     end if;
/* controllo negativi */
    IF nvl(P_nro_mensilita,0) < 0
    or nvl(P_stipendi,0) < 0 or nvl(P_inden_integr,0) < 0 
    or nvl(P_ria,0) < 0 or nvl(P_tredicesima,0) < 0 
    or nvl(P_arretrati_ac,0) < 0 or nvl(P_arretrati_ap,0) < 0 
    THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 29
              , P_pagina
              , P_riga_s
              , 'Verificare Tabella 12: Esistono Valori Negativi NON estratti per il Codice: '||lpad(CUR.codice,6,'0')
              );
    END IF; -- se negativi 
     END LOOP; -- cursore CUR --
END TAB8A0;

BEGIN -- Tab131 - Tabella 13 - Indennita'' e compensi accessori SSN
<<TAB131>>
P_fin_a  := to_date('3112'||to_char(P_anno),'ddmmyyyy');
P_ini_a   := to_date('0101'||to_char(P_anno),'ddmmyyyy');
P_pagina := 1;
P_riga   := 1;
for CUR in 
          (select distinct sequenza, codice
            from qualifiche_ministeriali
           where al is null
           order by 1,2) LOOP
              P_imp_i202:=0;
              P_imp_i204:=0;
              P_imp_i207:=0;
              P_imp_i212:=0;
              P_imp_i216:=0;
              P_imp_s212:=0;
              P_imp_s204:=0;
              P_imp_s630:=0;
              P_imp_s998:=0;
              P_imp_s806:=0;
              P_imp_s820:=0;
              P_imp_s999:=0;
              P_imp_t101:=0;
              P_imp_totale:=0;

  FOR CUR_1 in 
         ( select smin.colonna, 
                 sum(smin.importo) importo
            from smt_importi smin, smt_periodi smpe
            where smpe.anno = P_anno 
              and smpe.qualifica = CUR.codice 
              and smpe.gestione like P_gestione
              and smpe.gestione = smin.gestione
              and nvl(smpe.universitario,'NO') = 'NO' 
              and nvl(smpe.formazione,'NO') = 'NO' 
              and nvl(smpe.telelavoro,'NO') = 'NO' 
              and nvl(smpe.lsu,'NO') = 'NO' 
              and nvl(smpe.interinale,'NO') = 'NO' 
              and (smpe.tempo_determinato = 'NO' or smpe.categoria = 'DIRSAN') 
              and smin.anno = smpe.anno 
              and smin.ci = smpe.ci 
              and smin.dal = smpe.dal 
              and smin.tabella = 'T13'  
            group by smin.colonna
            order by smin.colonna ) LOOP
  IF CUR_1.colonna = '01' THEN
      P_imp_i202 := nvl(P_imp_i202,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = '02' THEN
      P_imp_i204 := nvl(P_imp_i204,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = '03' THEN
      P_imp_i207 := nvl(P_imp_i207,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = '04' THEN
      P_imp_i212 := nvl(P_imp_i212,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = '05' THEN
      P_imp_i216 := nvl(P_imp_i216,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = '06' THEN
      P_imp_s212 := nvl(P_imp_s212,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = '07' THEN
      P_imp_s204 := nvl(P_imp_s204,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = '08' THEN
      P_imp_s630 := nvl(P_imp_s630,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = '09' THEN
      P_imp_s806 := nvl(P_imp_s806,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = '10' THEN
      P_imp_s998 := nvl(P_imp_s998,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = '11' THEN
      P_imp_s999 := nvl(P_imp_s999,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = '12' THEN
      P_imp_t101 := nvl(P_imp_t101,0) + CUR_1.importo;
    ELSIF CUR_1.colonna = '13' THEN
      P_imp_s820 := nvl(P_imp_s820,0) + CUR_1.importo;
    end if;
    IF CUR_1.colonna is not null THEN
      P_imp_totale := nvl(P_imp_totale,0) + round(greatest(nvl(CUR_1.importo,0),0));
   end if;
  END LOOP; --cur_1
-- ATTENZIONE RISPETTO AL PROSPETTO EXCEL LA COL.9 E 10  SONO INVERTITE 
 IF  nvl(P_imp_totale,0) > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
                ,23
                , P_pagina
                , P_riga
                , P_cod_reg          
                ||P_cod_azienda      
                ||lpad(to_char(P_anno),4,'0') 
                ||P_cod_comparto     
                ||lpad(CUR.codice,6,'0')
                ||lpad(to_char(round(greatest(nvl(P_imp_i202,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_imp_i204,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_imp_i207,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_imp_i212,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_imp_i216,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_imp_s212,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_imp_s204,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_imp_s630,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_imp_s998,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_imp_s806,0),0))),12,'0')
                ||lpad(to_char(round(greatest(nvl(P_imp_s820,0),0))),12,'0')
                ||lpad(to_char(round(greatest(nvl(P_imp_s999,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_imp_t101,0),0))),12,'0') 
                ||lpad(to_char(round(greatest(nvl(P_imp_totale,0),0))),12,'0') 
                ||'0'
               )
               ;
     commit;
     P_riga := P_riga + 1;
     end if;
/* controllo negativi */
    IF nvl(P_imp_i202,0) < 0 or nvl(P_imp_i204,0) < 0 
    or nvl(P_imp_i207,0) < 0 or nvl(P_imp_i212,0) < 0 
    or nvl(P_imp_i216,0) < 0 or nvl(P_imp_s212,0) < 0 
    or nvl(P_imp_s204,0) < 0 or nvl(P_imp_s630,0) < 0 
    or nvl(P_imp_s998,0) < 0 or nvl(P_imp_s806,0) < 0 or nvl(P_imp_s820,0) < 0 
    or nvl(P_imp_s999,0) < 0 or nvl(P_imp_t101,0) < 0 
    or nvl(P_imp_totale,0) < 0
    THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 29
              , P_pagina
              , P_riga_s
              , 'Verificare Tabella 13: Esistono Valori Negativi NON estratti per il Codice: '||lpad(CUR.codice,6,'0')
              );
    END IF; -- se negativi 
     END LOOP; -- cursore CUR --
  END TAB131;

BEGIN -- Tab1b1 - Tabella 1B Personale Universitario
<<TAB1B1>>
P_ini_a  := to_date('0101'||to_char(P_anno),'ddmmyyyy');
P_fin_a  := to_date('3112'||to_char(P_anno),'ddmmyyyy');
P_pagina := 1;
P_riga   := 1;
FOR CUR IN 
(select distinct codice_ministero figura
   from figure_giuridiche
  where P_fin_a between dal and nvL(al,P_fin_a)
 order by 1
 ) LOOP
   P_anno_ril        :=0;
   P_indet_pieno     :=0;
   P_indet_parz      :=0;
   P_deter_pieno     :=0;
   P_deter_parz      :=0;
   BEGIN
    select count(distinct smpe.ci)
      into P_anno_ril
      from smt_periodi          smpe
    where smpe.anno = P_anno
      and smpe.gestione like P_gestione
      and P_fin_a between smpe.dal and nvl(smpe.al,P_fin_a) 
      and nvl(smpe.universitario,'NO') = 'SI' 
      and nvl(smpe.formazione,'NO') = 'NO' 
      and nvl(smpe.telelavoro,'NO') = 'NO' 
      and nvl(smpe.lsu,'NO') = 'NO' 
      and nvl(smpe.interinale,'NO') = 'NO' 
      and (smpe.tempo_determinato = 'NO' or smpe.categoria = 'DIRSAN')  
      and smpe.figura = CUR.figura;
   EXCEPTION WHEN NO_DATA_FOUND THEN
    P_anno_ril :=0 ;
   END;
   FOR CUR_1 IN
   (select decode(smpe.tempo_pieno,'SI',1,2)   colonna,
           count(smpe.ci)    num_dip
    from   smt_periodi          smpe,
           smt_individui        smin
    where smpe.ci = smin.ci 
      and smpe.anno = smin.anno 
      and smpe.gestione like P_gestione
      and smpe.gestione = smin.gestione
      and P_fin_a between smpe.dal and nvl(smpe.al,P_fin_a)
      and nvl(smpe.universitario,'NO') = 'SI' 
      and nvl(smpe.formazione,'NO') = 'NO' 
      and nvl(smpe.telelavoro,'NO') = 'NO' 
      and nvl(smpe.lsu,'NO') = 'NO' 
      and nvl(smpe.interinale,'NO') = 'NO' 
      and (smpe.tempo_determinato = 'NO' or smpe.categoria = 'DIRSAN')  
      and smpe.anno = P_anno
      and smpe.figura = CUR.figura
    group by decode(smpe.tempo_pieno,'SI',1,2)
    )LOOP
        IF CUR_1.colonna = 1 THEN
           P_indet_pieno := nvl(P_indet_pieno,0) + CUR_1.num_dip;
        ELSE 
           P_indet_parz  := nvl(P_indet_parz,0) + CUR_1.num_dip;
        end if;
      END LOOP; --cur_1
   begin
   select decode( least( 1
                    , sum(decode
                          ( tempo_pieno
                          , 'SI', 1 * months_between
                                      ( least(P_fin_a
                                        , nvl(smpe.al,P_fin_a))
                                      , greatest(smpe.dal,P_ini_a)
                                      ) / 12
                          , 0
                          )
                         ))
             , 0, 0
             , 1, round(
                    sum(decode
                        ( tempo_pieno
                        , 'SI', 1 * months_between
                                    ( least( P_fin_a
                                           , nvl(smpe.al,P_fin_a))
                                           , greatest(smpe.dal,P_ini_a)
                                    ) / 12
                              , 0
                        )
                       )
                      )
                , 1)                          tpd
     , decode( least( 1
                    , sum(decode
                          ( tempo_pieno
                          , 'NO', 1 * months_between
                                      ( least(P_fin_a
                                        , nvl(smpe.al,P_fin_a))
                                      , greatest(smpe.dal,P_ini_a)
                                      ) / 12 / 2
                          , 0
                          )
                         ))
             , 0, 0
             , 1, round(
                    sum(decode
                        ( tempo_pieno
                        , 'NO', 1 * months_between
                                    ( least(P_fin_a
                                           , nvl(smpe.al,P_fin_a))
                                    , greatest(smpe.dal,P_ini_a)
                                    ) / 12 / 2
                              , 0
                        ) 
                       )
                      )
                , 1)                          ptd
  into P_deter_pieno, P_deter_parz
  from  smt_individui     smin
      , smt_periodi       smpe
  where smpe.dal             <= P_fin_a
    and nvl(smpe.al,to_date('3333333','j')) >= P_ini_a
    and smpe.anno = P_anno 
    and nvl(tempo_determinato,'NO')             = 'SI'
    and figura  = CUR.figura
    and exists
        (select 'x' from periodi_giuridici
          where rilevanza      = 'P'
            and ci             = smpe.ci 
            and dal             <= P_fin_a
            and nvl(al,to_date('3333333','j')) >= P_ini_a
        )                
    and smin.ci=smpe.ci
    and smin.anno=smpe.anno
    and smin.gestione=smpe.gestione
    and smpe.gestione like P_gestione
    and nvl(smpe.universitario,'NO') ='SI'
    and nvl(smin.est_comandato,'NO') ='NO'
    and nvl(smin.int_comandato,'NO') ='NO'
  group by 1
  having round(
          sum(decode
               ( tempo_pieno
               , 'SI', 1 * months_between
                           ( least( P_fin_a
                                  , nvl(smpe.al,P_fin_a))
                           , greatest(smpe.dal,P_ini_a)
                           ) / 12
                    , 0
               )
             )
            ) +
       round(
          sum(decode
               ( tempo_pieno
               , 'NO', 1 * months_between
                           ( least( P_fin_a
                                  , nvl(smpe.al,P_fin_a))
                           , greatest(smpe.dal,P_ini_a)
                           ) / 12 / 2
                    , 0
               )
             )
            )   != 0;
  EXCEPTION
    when NO_DATA_FOUND THEN
      P_deter_parz:=0;
      P_deter_pieno:=0;
  end;
   IF P_anno_ril + nvl(P_deter_pieno,0) + nvl(P_deter_parz,0) + nvl(P_indet_pieno,0) + nvl(P_indet_parz,0) > 0 
    THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 25
              , P_pagina
              , P_riga
              , P_cod_reg          
              ||P_cod_azienda      
              ||lpad(to_char(P_anno),4,'0') 
              ||P_cod_comparto     
              ||lpad(CUR.figura,6,'0')
              ||lpad(to_char(greatest(nvl(P_anno_ril,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_indet_pieno,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_indet_parz,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_deter_pieno,0),0)),8,'0') 
              ||lpad(to_char(greatest(nvl(P_deter_parz,0),0)),8,'0') 
              ||'0'
              );
     commit;
     P_riga := P_riga + 1;
     end if;
/* controllo negativi */
    IF nvl(P_anno_ril,0) < 0
    or nvl(P_indet_pieno,0) < 0 or nvl(P_indet_parz,0) < 0 
    or nvl(P_deter_pieno,0) < 0 or nvl(P_deter_parz,0) < 0 
    THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 29
              , P_pagina
              , P_riga_s
              , 'Verificare Tabella 1B1: Esistono Valori Negativi NON estratti per il Codice: '||lpad(CUR.figura,6,'0')
              );
    END IF; -- se negativi 
     END LOOP; -- cursore CUR --
END TAB1B1;

BEGIN -- Tab1E1 Tabella 1E - Personale per fascia retributiva
<<TAB1E1>>
P_fin_a  := to_date('3112'||to_char(P_anno),'ddmmyyyy');
P_pagina := 1;
P_riga   := 1;
FOR CUR IN 
(select distinct sequenza, codice
   from qualifiche_ministeriali
  where P_fin_a between dal and nvl(al,P_fin_a)
 order by sequenza,codice
 ) LOOP
   P_fascia0_m         :=0;
   P_fascia0_f         :=0;
   P_fascia1_m         :=0;
   P_fascia1_f         :=0;
   P_fascia2_m         :=0;
   P_fascia2_f         :=0;
   P_fascia3_m         :=0;
   P_fascia3_f         :=0;
   P_fascia4_m         :=0;
   P_fascia4_f         :=0;
   P_fascia5_m         :=0;
   P_fascia5_f         :=0;
   P_fascia6_m         :=0;
   P_fascia6_f         :=0;
   P_tot_fascia_m      :=0;
   P_tot_fascia_f      :=0;

   FOR CUR_1 IN
   (select smin.sesso
         , smpe.fascia       fascia
         , count(smpe.ci)    num_dip
    from   smt_periodi          smpe,
           smt_individui        smin
    where smpe.ci = smin.ci 
      and smpe.anno = smin.anno 
      and smpe.gestione like P_gestione
      and smpe.gestione = smin.gestione
      and nvl(smpe.universitario,'NO') = 'NO' 
      and nvl(smin.est_comandato,'NO')='NO'
      and nvl(smpe.tempo_determinato,'NO') = 'NO'
      and P_fin_a between smpe.dal and nvl(smpe.al,P_fin_a)
      and smpe.anno = P_anno
      and smpe.qualifica = CUR.codice
      and smpe.fascia is not null
      and exists
         (select 'x' from periodi_giuridici
           where rilevanza      = 'P'
             and ci             = smpe.ci 
             and P_fin_a between dal and nvl(al,to_date('3333333','j')) 
          )  
    group by smin.sesso, smpe.fascia
    )LOOP
     IF CUR_1.sesso ='F' THEN
        IF CUR_1.fascia = 0 THEN
           P_fascia0_f := nvl(P_fascia0_f,0) + CUR_1.num_dip;
        ELSIF CUR_1.fascia = 1 THEN 
           P_fascia1_f := nvl(P_fascia1_f,0) + CUR_1.num_dip;
        ELSIF CUR_1.fascia = 2 THEN 
           P_fascia2_f := nvl(P_fascia2_f,0) + CUR_1.num_dip;
        ELSIF CUR_1.fascia = 3 THEN 
           P_fascia3_f := nvl(P_fascia3_f,0) + CUR_1.num_dip;
        ELSIF CUR_1.fascia = 4 THEN 
           P_fascia4_f := nvl(P_fascia4_f,0) + CUR_1.num_dip;
        ELSIF CUR_1.fascia = 5 THEN 
           P_fascia5_f := nvl(P_fascia5_f,0) + CUR_1.num_dip;
        ELSIF CUR_1.fascia = 6 THEN 
           P_fascia6_f := nvl(P_fascia6_f,0) + CUR_1.num_dip;
        END IF;
        P_tot_fascia_f := nvl(P_tot_fascia_f,0) + CUR_1.num_dip;
      ELSE
        IF CUR_1.fascia = 0 THEN
           P_fascia0_m := nvl(P_fascia0_m,0) + CUR_1.num_dip;
        ELSIF CUR_1.fascia = 1 THEN 
           P_fascia1_m := nvl(P_fascia1_m,0) + CUR_1.num_dip;
        ELSIF CUR_1.fascia = 2 THEN 
           P_fascia2_m := nvl(P_fascia2_m,0) + CUR_1.num_dip;
        ELSIF CUR_1.fascia = 3 THEN 
           P_fascia3_m := nvl(P_fascia3_m,0) + CUR_1.num_dip;
        ELSIF CUR_1.fascia = 4 THEN 
           P_fascia4_m := nvl(P_fascia4_m,0) + CUR_1.num_dip;
        ELSIF CUR_1.fascia = 5 THEN 
           P_fascia5_m := nvl(P_fascia5_m,0) + CUR_1.num_dip;
        ELSIF CUR_1.fascia = 6 THEN 
           P_fascia6_m := nvl(P_fascia6_m,0) + CUR_1.num_dip;
        END IF;
        P_tot_fascia_m := nvl(P_tot_fascia_m,0) + CUR_1.num_dip;
      END IF;
      END LOOP; --cur_1
  
    IF nvl(P_fascia0_m,0) + nvl(P_fascia0_f,0) + nvl(P_fascia1_m,0) + nvl(P_fascia1_f,0) 
     + nvl(P_fascia2_m,0) + nvl(P_fascia2_f,0) + nvl(P_fascia3_m,0) + nvl(P_fascia3_f,0)
     + nvl(P_fascia4_m,0) + nvl(P_fascia4_f,0) + nvl(P_fascia5_m,0) + nvl(P_fascia5_f,0)
     + nvl(P_fascia6_m,0) + nvl(P_fascia6_f,0)  > 0 THEN
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 27
              , P_pagina
              , P_riga
              , P_cod_reg          
              ||P_cod_azienda      
              ||lpad(to_char(P_anno),4,'0') 
              ||P_cod_comparto     
              ||lpad(CUR.codice,6,'0')
              ||lpad(to_char(greatest(nvl(P_fascia0_m,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_fascia0_f,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_fascia1_m,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_fascia1_f,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_fascia2_m,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_fascia2_f,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_fascia3_m,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_fascia3_f,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_fascia4_m,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_fascia4_f,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_fascia5_m,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_fascia5_f,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_fascia6_m,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_fascia6_f,0),0)),8,'0')
              ||lpad(to_char(greatest(nvl(P_tot_fascia_m,0),0)),9,'0')
              ||lpad(to_char(greatest(nvl(P_tot_fascia_f,0),0)),9,'0')
              ||lpad(' ',51,' ')
              ||'0' 
              );
     commit;
     P_riga := P_riga + 1;
     END IF;
/* controllo negativi */
    IF nvl(P_fascia0_m,0) < 0 or nvl(P_fascia0_f,0) < 0 
    or nvl(P_fascia1_m,0) < 0 or nvl(P_fascia1_f,0) < 0 
    or nvl(P_fascia2_m,0) < 0 or nvl(P_fascia2_f,0) < 0 
    or nvl(P_fascia3_m,0) < 0 or nvl(P_fascia3_f,0) < 0 
    or nvl(P_fascia4_m,0) < 0 or nvl(P_fascia4_f,0) < 0 
    or nvl(P_fascia5_m,0) < 0 or nvl(P_fascia5_f,0) < 0 
    or nvl(P_fascia6_m,0) < 0 or nvl(P_fascia6_f,0) < 0 
    or nvl(P_tot_fascia_m,0) < 0 or nvl(P_tot_fascia_f,0) < 0 
    THEN
      P_riga_s := P_riga_s + 1;
      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
       values ( prenotazione
              , 29
              , P_pagina
              , P_riga_s
              , 'Verificare Tabella 1E1: Esistono Valori Negativi NON estratti per il Codice: '||lpad(CUR.codice,6,'0')
              );
    END IF; -- se negativi 
    END LOOP; -- cursore CUR --
END TAB1E1;

EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = 'A05721'
       where no_prenotazione = prenotazione;
      commit;
END;
END;
END;
/
