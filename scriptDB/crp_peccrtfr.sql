CREATE OR REPLACE PACKAGE peccrtfr IS
/******************************************************************************
 NOME:        PECCRTFR
 DESCRIZIONE: CALCOLO RIVALUTAZIONE TFR
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/
CREATE OR REPLACE PACKAGE BODY peccrtfr IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
                      passo in number) is
begin
declare
      D_dep_ci      number;       -- Codice Individuale per Ripristino LOOP
      P_contratto   varchar2(4);
      P_livello     varchar2(4);
      P_qualifica   varchar2(8);
      P_di_ruolo    varchar2(1);
      P_posizione   varchar2(4);
      P_figura      varchar2(8);
      P_attivita    varchar2(4);
      P_gestione    varchar2(4);
      P_settore     varchar2(15);
      P_sede        varchar2(8);
      P_ruolo       varchar2(4);
      P_rapporto    varchar2(4);
      P_gruppo      varchar2(12);
      P_fascia      varchar2(2);
--
      D_ci_start    number;       -- Codice Individuale di partenza LOOP
      D_cc          varchar2(30);  -- Codice di Competenza individuale
      D_ni          number;       -- Numero Individuale Anagrafico
      D_count_ci    number;       -- Contatore ciclico Individui trattati
      progr_riga    number;
      D_utente      varchar2(8);
      D_ambiente    varchar2(8);
      D_ente        varchar2(4);
      D_anno        number;
      D_mese        number;
      D_mensilita   varchar2(3);
      D_anno_rire        number;
      D_mese_rire        number;
      D_mensilita_rire   varchar2(3);
      D_fin_ela     date;
      D_voce_tfr    varchar2(10);
      D_voce_rit    varchar2(10);
      D_al          date;
      D_alq         number;
      D_fdo_tfr_ap  number;
      D_fdo_tfr_ap_liq number;
      D_fdo_tfr_2000  number;
      D_fdo_tfr_2000_liq number;
      D_riv_tfr     number;
      D_riv_tfr_liq number;
      D_riv_tfr_ap     number;
      D_riv_tfr_ap_liq number;
      D_riv_tfr_assenze number;
      D_riv_tfr_liquidato number;
      D_riv_tfr_mese   number;
      D_riv_tfr_anno   number;
      D_rit_riv        number;
      D_rit_riv_mese   number;
--
      non_trovato   number;
      error_number  number;
      error_code    varchar2(50);
      esci_individuo exception;
      CURSOR C_SEL_RAGI
      ( P_ci_start number
      ) IS
        select  rowid, ci, flag_elab, al
          from  rapporti_giuridici ragi
         where ci     > P_ci_start
           and  exists
                (select 'x'
                   from periodi_retributivi
                where ci         = ragi.ci
                    and periodo    = D_fin_ela
                    and competenza = 'A')
           and  exists
                (select 'x'
                   from rapporti_individuali rain
                  where rain.ci     = ragi.ci
                    and nvl(rain.gruppo,' ')
                                 like nvl(p_gruppo,'%')
                    and rain.rapporto
                                 like nvl(p_rapporto,'%')
                )
           and (   p_fascia = '%'
                or exists
                  (select 'x'
                     from gestioni gest
                    where gest.codice = ragi.gestione
                      and nvl(gest.fascia,' ')
                                   like nvl(p_fascia,'%')
                  )
               )
           and  nvl(ragi.gestione,' ')  like nvl(p_gestione,'%')
           and  nvl(ragi.contratto,' ') like nvl(p_contratto,'%')
           and  nvl(ragi.ruolo,' ')     like nvl(p_ruolo,'%')
           and  nvl(ragi.livello,' ')
                            like nvl(p_livello,'%')
           and (   p_qualifica = '%'
                or exists
                  (select 'x'
                     from qualifiche_giuridiche qugi
                    where qugi.numero = ragi.qualifica
                      and qugi.codice
                                   like nvl(p_qualifica,'%')
                      and least(nvl(ragi.al,to_date('3333333','j'))
                               ,D_fin_ela)
                                between qugi.dal
                                    and nvl(qugi.al,to_date('3333333','j'))
                  )
               )
           and (   p_figura = '%'
                or exists
                  (select 'x'
                     from figure_giuridiche figi
                    where figi.numero = ragi.figura
                      and figi.codice
                          like nvl(p_figura,'%')
                      and least(nvl(ragi.al,to_date('3333333','j'))
                               ,D_fin_ela)
                          between figi.dal
                              and nvl(figi.al,to_date('3333333','j'))
                  )
               )
           and  nvl(ragi.attivita,' ')  like nvl(p_attivita,'%')
           and  (   p_di_ruolo
                               = '%'
                 or exists
                   (select 'x'
                      from posizioni posi
                     where posi.di_ruolo
                                  = p_di_ruolo
                       and posi.codice
                                  = ragi.posizione
                   )
                )
           and  nvl(ragi.posizione,' ') like nvl(p_posizione,'%')
           and (   p_sede = '%'
                or exists
                  (select 'x'
                     from sedi sede
                    where sede.numero    = ragi.sede
                      and sede.codice like nvl(p_sede,'%')
                  )
               )
           and (   p_settore = '%'
                or exists
                  (select 'x'
                     from settori sett
                    where sett.numero    = ragi.settore
                      and sett.codice
                          like nvl(p_settore,'%')
                  )
               )
      --
      --        Controlli Globali
      --
            and  exists (select 'x'
                           from rapporti_individuali rain
                          where rain.ci   = ragi.ci
                            and (   rain.cc is null
                                 or exists
                                   (select 'x'
                          from a_competenze comp
                         where comp.oggetto
                                    = rain.cc
                           and comp.ambiente   = D_ambiente
                           and comp.ente       = D_ente
                           and comp.utente     = D_utente
                           and comp.competenza = 'CI'
                                   )
                                )
                        )
						order by ci
        ;
      CURSOR C_UPD_RAGI
      ( p_rowid varchar,
        p_ci    number
      ) IS
      select 'x'
        from rapporti_giuridici
       where rowid     = P_rowid
         and ci        = P_ci
         for update of flag_elab nowait
      ;
      D_ROW_RAGI            C_UPD_RAGI%ROWTYPE;
      --
BEGIN
     BEGIN
       SELECT substr(valore,1,4)
         INTO D_anno
	     FROM a_parametri
        WHERE no_prenotazione = prenotazione
          AND parametro       = 'P_ANNO'
       ;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         SELECT anno
           INTO D_anno
           FROM RIFERIMENTO_RETRIBUZIONE
          WHERE rire_id = 'RIRE'
         ;
     END;
	 BEGIN
       SELECT substr(valore,1,4)
         INTO D_mensilita
         FROM a_parametri
        WHERE no_prenotazione = prenotazione
          AND parametro       = 'P_MENSILITA'
       ;
     EXCEPTION
	   WHEN NO_DATA_FOUND THEN null;
         SELECT mensilita
           INTO D_mensilita
           FROM RIFERIMENTO_RETRIBUZIONE
          WHERE rire_id = 'RIRE'
         ;
	 END;
	 BEGIN
       SELECT mese
		 INTO D_mese
         FROM mensilita
        WHERE mensilita = D_mensilita
	   ;
     EXCEPTION
	   WHEN NO_DATA_FOUND THEN
	     NULL;
	 END;
	 BEGIN
	   SELECT fin_mese
		 INTO D_fin_ela
         FROM mesi
        WHERE anno = D_anno
	      AND mese = D_mese
	   ;
	 EXCEPTION
	   WHEN NO_DATA_FOUND THEN
		 NULL;
	 END;
     progr_riga := 0;
     BEGIN
      BEGIN
        select ente,ambiente,utente
          into D_ente,D_ambiente,D_utente
          from a_prenotazioni
         where no_prenotazione = prenotazione;
      END;
      BEGIN
        select substr(valore,1, 4)
          into P_contratto
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'CONTRATTO';
        select substr(valore,1, 4)
          into P_livello
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'LIVELLO';
        select substr(valore,1, 8)
          into P_qualifica
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'QUALIFICA';
        select substr(valore,1, 1)
          into P_di_ruolo
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'DI_RUOLO';
        select substr(valore,1, 4)
          into P_posizione
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'POSIZIONE';
        select substr(valore,1, 8)
          into P_figura
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'FIGURA';
        select substr(valore,1, 4)
          into P_attivita
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'ATTIVITA';
        select substr(valore,1, 4)
          into P_gestione
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'GESTIONE';
        select substr(valore,1,15)
          into P_settore
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'SETTORE';
        select substr(valore,1, 8)
          into P_sede
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'SEDE';
        select substr(valore,1, 4)
          into P_ruolo
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'RUOLO';
        select substr(valore,1, 4)
          into P_rapporto
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'RAPPORTO';
        select substr(valore,1,12)
          into P_gruppo
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'GRUPPO';
        select substr(valore,1, 2)
          into P_fascia
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'FASCIA';
      END;
/*
      BEGIN
        select rire.anno, rire.mese, rire.mensilita, rire.fin_ela
          into D_anno, D_mese, D_mensilita, D_fin_ela
          from riferimento_retribuzione rire
         where rire_id = 'RIRE'
           and D_anno  is null
       ;
      END;
*/
/*    Prelevo la mensilita  corrente
*/
      BEGIN
          SELECT anno,mese,mensilita
            INTO D_anno_rire,D_mese_rire,D_mensilita_rire
            FROM RIFERIMENTO_RETRIBUZIONE
           WHERE rire_id = 'RIRE'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             null;
      END;
      BEGIN  -- Preleva codice voce RIVALUTAZIONE TFR
        select codice
          into D_voce_tfr
          from voci_economiche
         where automatismo = 'RIV_TFR'
        ;
        select codice
          into D_voce_rit
          from voci_economiche
         where automatismo = 'RIT_RIV'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             progr_riga := progr_riga + 1;
             insert into a_segnalazioni_errore (no_prenotazione,
                    passo,progressivo,errore,precisazione)
             values (prenotazione,1,progr_riga,'P05205','');
             RAISE;
        WHEN TOO_MANY_ROWS THEN
             progr_riga := progr_riga + 1;
             insert into a_segnalazioni_errore (no_prenotazione,
                    passo,progressivo,errore,precisazione)
             values (prenotazione,1,progr_riga,'A00003','VOCI_ECONOMICHE');
             RAISE;
      END;
      BEGIN  -- Ciclo su Individui
            D_dep_ci   := 0;  -- Disattivazione iniziale del Ripristino
            D_ci_start := 0;  -- Attivazione partenza del Ciclo Individui
            D_count_ci := 0;  -- Azzeramento iniziale contatore Individui
LOOP  -- Ripristino Ciclo su Individui:
      -- - in caso di Errore su Individuo
      -- - in caso di LOOP ciclico per rilascio ROLLBACK_SEGMENTS
FOR RAGI IN C_SEL_RAGI (D_ci_start)
LOOP
<<tratta_ci>>
BEGIN
   D_count_ci := D_count_ci + 1;
   BEGIN  -- Allocazione individuo
-- dbms_output.put_line('Tratto il CI : '||ragi.ci);
      non_trovato := 0;
      OPEN C_UPD_RAGI (ragi.rowid, ragi.ci);
      FETCH C_UPD_RAGI INTO D_ROW_RAGI;
      IF C_UPD_RAGI%NOTFOUND THEN
         RAISE TIMEOUT_ON_RESOURCE;
      END IF;
      IF ragi.flag_elab is null OR
         ragi.flag_elab in ('E','C') THEN
         null;
      ELSE
         -- Individuo in fase di elaborazione della retribuzione
         progr_riga := progr_riga + 1;
         insert into a_segnalazioni_errore (no_prenotazione,
                passo,progressivo,errore,precisazione)
         values (prenotazione,1,progr_riga,'P05200',to_char(ragi.ci));
         RAISE ESCI_INDIVIDUO;
      END IF;
   EXCEPTION
      WHEN ESCI_INDIVIDUO THEN
         RAISE;
      WHEN OTHERS THEN
         RAISE TIMEOUT_ON_RESOURCE;
   END;
   BEGIN  --  R I C A L C O L O    T. F. R.
     BEGIN -- Preleva Aliquota rivalutazione ISTAT. Se l'aliquota e nulla o zero,
	       -- utilizzo la massima dei mesi precedenti
       select least(nvl(ragi.al,to_date('3333333','j'))
                   ,D_fin_ela)
         into D_al
         from dual
       ;
       select nvl(alq_tfr,0)
         into D_alq
         from mesi
        where anno = D_anno
          and D_anno = to_char(D_al - 14, 'yyyy')
          and mese   = to_char(D_al - 14, 'mm')
       ;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN D_alq := 0;
     END;
	 if D_alq = 0
	    then
		   begin
		     select max(nvl(alq_tfr,0))
			   into D_alq
			   from mesi
			  where anno = D_anno
			    and mese <= D_mese
			    and mese < to_char(D_al - 14, 'mm')
			 ;
		   exception
		     when no_data_found then D_alq := 0;
		   end;
     end if;
-- dbms_output.put_line('D_alq: '||D_alq);
-- dbms_output.put_line('D_al: '||D_al);
     /* Estrae il progressivo del fondo TFR */
     BEGIN
       select nvl(sum(prfi.fdo_tfr_ap),0)
             ,nvl(sum(prfi.fdo_tfr_ap_liq),0)
             ,nvl(sum(prfi.fdo_tfr_2000),0)
             ,nvl(sum(prfi.fdo_tfr_2000_liq),0)
             , nvl(sum(prfi.riv_tfr_ap)
			  -e_round(sum(prfi.riv_tfr_ap) * .11,'I'),0)
         into D_fdo_tfr_ap
             ,D_fdo_tfr_ap_liq
             ,D_fdo_tfr_2000
             ,D_fdo_tfr_2000_liq
             ,D_riv_tfr_ap
         from progressivi_fiscali prfi
        where prfi.ci             = ragi.ci
          and prfi.anno           = D_anno
          and prfi.mese           = D_mese
          and prfi.mensilita      = D_mensilita;
     END;
--dbms_output.put_line('D_fdo_tfr_ap '||D_fdo_tfr_ap);
--dbms_output.put_line('D_fdo_tfr_ap_liq '||D_fdo_tfr_ap_liq);
--dbms_output.put_line('D_fdo_tfr_2000 '||D_fdo_tfr_2000);
--dbms_output.put_line('D_fdo_tfr_2000_liq '||D_fdo_tfr_2000_liq);
--dbms_output.put_line('D_riv_tfr_ap '||D_riv_tfr_ap);
     /* Estrae il progressivo della rivalutazione gia' calcolata */
     BEGIN
       select nvl(sum(prfi.riv_tfr),0)
             ,nvl(sum(prfi.rit_riv),0)
             ,nvl(sum(prfi.riv_tfr_liq),0)
             ,nvl(sum(prfi.riv_tfr_ap_liq),0)
         into D_riv_tfr
		     ,D_rit_riv
             ,D_riv_tfr_liq
             ,D_riv_tfr_ap_liq
         from movimenti_fiscali prfi
        where prfi.ci             = ragi.ci
          and prfi.anno           = D_anno
          and prfi.mese           <= D_mese
          and prfi.mensilita      <> D_mensilita;
--          and prfi.mofi_mese     != D_mese
--          and prfi.mofi_mensilita!= D_mensilita;
     END;
     /* Calcola la rivalutazione per i mesi con almeno 15 giorni in
        aspettativa senza maturazione della rivalutazione TFR */
     /* 07/01/2003 : abbiamo scoperto che anche in caso di aspettativa che non fa maturare TFR,
	    la rivalutazione va comunque calcolata. Si rimedia attribuendo alla variabile D_riv_tfr_assenze
		il valore 0 in ogni caso */
     BEGIN
     /* Preesistente calcolo della quota di rivalutazione per i periuodi di astensione nei quali non
        si matura quota TFR, con cui veniva ridotto il valore complessivo della rivalutazione. Sospeso
		dal 07/01/2003 *
	 */
	 /*
     select nvl(e_round(sum((nvl(inex.fdo_tfr_ap,0)
                          +nvl(inex.fdo_tfr_2000,0)
                          +nvl(inex.riv_tfr_ap,0)
                          ) * (  mese.alq_tfr - nvl(mesep.alq_tfr,0) )),'I'),0)
       into D_riv_tfr_assenze
       from informazioni_extracontabili inex
          , mesi mese
          , mesi mesep
      where inex.anno            = D_anno
        and ci                   = ragi.ci
        and mese.mese           <= D_mese
        and (mese.anno,mese.mese)  in
           (select distinct anno,mese from periodi_retributivi
             where anno+0      = D_anno
               and ci          = ragi.ci
               and competenza in ('p','c','a')
               and per_gg      = 0
               and cod_astensione in
                  (select codice from astensioni where rivalutazione_tfr = 0)
               and periodo    <= last_day(to_date(lpad(to_char(D_mese),2,'0')
                                                     ||to_char(D_anno)
                                                 ,'mmyyyy'))
             group by anno,mese
            having (   sum(gg_per+gg_nsu) >= 15 and
                       anno||lpad(mese,2,0) != to_char(D_al,'yyyymm')
                    or to_number(to_char(D_al,'dd'))
                     - sum(gg_per+gg_nsu) < 15 and
                       anno||lpad(mese,2,0) = to_char(D_al,'yyyymm')
                   )
           )
        and mesep.anno(+)        = mese.anno
        and mesep.mese(+)        = decode(mese.mese,1,0,mese.mese-1)
      ;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN D_riv_tfr_assenze := 0;
     */
	    D_riv_tfr_assenze := 0;
     END;
     /* Calcola la rivalutazione sul fondo liquidato per ogni mese
        di servizio successivo a quello di liquidazione */
     IF D_mese != 1 THEN
        BEGIN
        select nvl(sum((nvl(mofi.fdo_tfr_ap_liq,0)
                       +nvl(mofi.fdo_tfr_2000_liq,0)
                       +nvl(mofi.riv_tfr_ap_liq,0)
                       ) * (  mese.alq_tfr - mesep.alq_tfr )),0)
          into D_riv_tfr_liquidato
          from movimenti_fiscali mofi
             , mesi mese
             , mesi mesep
         where mofi.anno            = D_anno
           and ci                   = ragi.ci
           and mofi.mese            < to_char(D_al - 14, 'mm')
           and lpad(to_char(mofi.mese),2)||rpad(mofi.mensilita,3) <
               lpad(to_char(D_mese),2)||rpad(D_mensilita,3)
           and (   mofi.fdo_tfr_ap_liq != 0
                or mofi.fdo_tfr_2000_liq != 0
                or mofi.riv_tfr_ap_liq != 0
               )
           and mese.anno            = D_anno
           and D_anno               = to_char(D_al - 14, 'yyyy')
           and mese.mese            = to_char(D_al - 14, 'mm')
           and mesep.anno           = mofi.anno
           and mesep.mese           = mofi.mese
         ;
-- dbms_output.put_line('D_riv_tfr_liquidato 1 :'||D_riv_tfr_liquidato);
        END;
     ELSE
        select nvl(sum((nvl(mofi.fdo_tfr_ap_liq,0)
                       +nvl(mofi.fdo_tfr_2000_liq,0)
                       +nvl(mofi.riv_tfr_ap_liq,0)-e_round(nvl(mofi.riv_tfr_ap_liq,0)*.11,'I')
                       ) *   mese.alq_tfr  ),0)
          into D_riv_tfr_liquidato
          from movimenti_fiscali mofi
             , mesi mese
         where mofi.anno            = D_anno
           and ci                   = ragi.ci
           and mofi.mese            = 1
           and (   mofi.fdo_tfr_ap_liq != 0
                or mofi.fdo_tfr_2000_liq != 0
                or mofi.riv_tfr_ap_liq != 0
               )
           and mese.anno            = D_anno
           and mese.mese            = 1
         ;
-- dbms_output.put_line('D_al :'||D_al);
-- dbms_output.put_line('D_riv_tfr_liquidato 2 :'||D_riv_tfr_liquidato);
--        D_riv_tfr_liquidato := 0;
     END IF;
--dbms_output.put_line('lpad(to_char(D_mese),2)||rpad(D_mensilita,3) '||lpad(to_char(D_mese),2)||rpad(D_mensilita,3));
--dbms_output.put_line('D_AL '||D_al);
--dbms_output.put_line('D_mese '||D_mese);
--dbms_output.put_line('D_mensilita '||D_mensilita);
--dbms_output.put_line('D_riv_tfr_liquidato '||D_riv_tfr_liquidato);
     /* Calcola la rivalutazione spettante come differenza tra:
        - rivalutazione complessiva alla percentuale del mese in corso
        - rivalutazione sui periodi di assenza
        - rivalutazione sul TFR liquidato
        - rivalutazione gia' memorizzata sui progressivi
     */
-- dbms_output.put_line('D_fdo_tfr_ap        :'||D_fdo_tfr_ap);
-- dbms_output.put_line('D_fdo_tfr_2000      :'||D_fdo_tfr_2000);
-- dbms_output.put_line('D_riv_tfr_ap        :'||D_riv_tfr_ap);
-- dbms_output.put_line('D_riv_tfr_assenze   :'||D_riv_tfr_assenze);
-- dbms_output.put_line('D_alq               :'||D_alq);
-- dbms_output.put_line('D_riv_tfr_liquidato :'||D_riv_tfr_liquidato);
-- dbms_output.put_line('D_riv_tfr           :'||D_riv_tfr);
     D_riv_tfr_mese   := ((D_fdo_tfr_ap+D_fdo_tfr_2000+D_riv_tfr_ap
                          ) * D_alq)
                       -  D_riv_tfr_assenze
                       -  D_riv_tfr_liquidato
                       -  D_riv_tfr ;
     D_riv_tfr_anno   := ((D_fdo_tfr_ap+D_fdo_tfr_2000+D_riv_tfr_ap
                          ) * D_alq)
                       -  D_riv_tfr_assenze
                       -  D_riv_tfr_liquidato;
     D_rit_riv_mese   := e_round((e_round(D_riv_tfr_anno,'I') * .11) - D_rit_riv,'I');
     /* Aggiorna o inserisce la rivalutazione nel corrispondente
        movimento contabili */
     BEGIN
        update movimenti_contabili
           set imp         = D_riv_tfr_mese
              ,riferimento = D_al
         where ci        = ragi.ci
           and anno      = D_anno
           and mese      = D_mese
           and mensilita = D_mensilita
           and voce      = D_voce_tfr
           and sub       = '*'
           and exists (select 'x'
                         from contabilita_voce covo
                        where covo.voce = D_voce_tfr
                          and covo.sub  = '*'
                          and D_al between
                              nvl(covo.dal,to_date('2222222','j'))
                                       and
                              nvl(covo.al ,to_date('3333333','j'))
                      )
        ;
        IF SQL%ROWCOUNT = 0 THEN
        insert into movimenti_contabili
        ( ci, anno, mese, mensilita, voce, sub
        , riferimento , input , imp
        )
        select ragi.ci, D_anno, D_mese, D_mensilita
             , D_voce_tfr,'*' ,D_al ,'C' ,D_riv_tfr_mese
          from contabilita_voce covo
         where covo.voce = D_voce_tfr
           and covo.sub  = '*'
           and D_al between nvl(covo.dal,to_date('2222222','j'))
                        and nvl(covo.al ,to_date('3333333','j'))
        ;
        END IF;
     END;
     /* Aggiorna o inserisce la ritenuta sostitutiva sulla
        rivalutazione nel corrispondente movimento contabili */
     BEGIN
        update movimenti_contabili
           set tar         = D_riv_tfr_mese
              ,qta         = 11
              ,imp         = D_rit_riv_mese
              ,riferimento = D_al
         where ci        = ragi.ci
           and anno      = D_anno
           and mese      = D_mese
           and mensilita = D_mensilita
           and voce      = D_voce_rit
           and sub       = '*'
           and exists (select 'x'
                         from contabilita_voce covo
                        where covo.voce = D_voce_rit
                          and covo.sub  = '*'
                          and D_al between
                              nvl(covo.dal,to_date('2222222','j'))
                                       and
                              nvl(covo.al ,to_date('3333333','j'))
                      )
        ;
        IF SQL%ROWCOUNT = 0 THEN
        insert into movimenti_contabili
        ( ci, anno, mese, mensilita, voce, sub
        , riferimento , input , tar, qta, imp
        )
        select ragi.ci, D_anno, D_mese, D_mensilita
             , D_voce_rit,'*' ,D_al ,'C' ,D_riv_tfr_mese, 11
             , D_rit_riv_mese
          from contabilita_voce covo
         where covo.voce = D_voce_rit
           and covo.sub  = '*'
           and D_al between nvl(covo.dal,to_date('2222222','j'))
                        and nvl(covo.al ,to_date('3333333','j'))
        ;
        END IF;
     END;
     /* Aggiorna la rivalutazione nel corrispondente movimento fiscale */
     BEGIN
        update movimenti_fiscali
           set riv_tfr = D_riv_tfr_mese
         where ci        = ragi.ci
           and anno      = D_anno
           and mese      = D_mese
           and mensilita = D_mensilita
           and exists (select 'x'
                         from contabilita_voce covo
                        where covo.voce = D_voce_tfr
                          and covo.sub  = '*'
                          and D_al between
                              nvl(covo.dal,to_date('2222222','j'))
                                       and
                              nvl(covo.al ,to_date('3333333','j'))
                      )
        ;
     END;
     /* Aggiorna la ritenuta su rivalutazione nel corrispondente
        movimento fiscale */
-- dbms_output.put_line('D_riv_tfr_mese '||D_riv_tfr_mese);
-- dbms_output.put_line('D_riv_tfr_anno '||D_riv_tfr_anno);
--dbms_output.put_line('D_rit_riv '||D_rit_riv);
--dbms_output.put_line('D_rit_riv_mese '||D_rit_riv_mese);
     BEGIN
        update movimenti_fiscali
           set rit_riv = D_rit_riv_mese
         where ci        = ragi.ci
           and anno      = D_anno
           and mese      = D_mese
           and mensilita = D_mensilita
           and exists (select 'x'
                         from contabilita_voce covo
                        where covo.voce = D_voce_rit
                          and covo.sub  = '*'
                          and D_al between
                              nvl(covo.dal,to_date('2222222','j'))
                                       and
                              nvl(covo.al ,to_date('3333333','j'))
                      )
        ;
     END;
/*   Se l'elaborazione e riferita ad una mensilita dell'anno precedente quello di RIRE, esegue l'aggiornamento
     della rivalutazione gia registrata su INEX
*/
     IF D_anno = D_anno_rire - 1   THEN
    	   update informazioni_extracontabili inex
		      set riv_tfr_ap =
			     (select max(nvl(inex2.riv_tfr_ap,0)) + nvl(sum(prfi.riv_tfr),0) - nvl(sum(prfi.riv_tfr_liq),0)
				    from progressivi_fiscali         prfi
					    ,informazioni_extracontabili inex2
				   where prfi.ci            = inex.ci
                     and prfi.anno          = D_anno
                     and prfi.mese          = 12
                     and prfi.mensilita     = (select max(mensilita)
                                                 from mensilita
                                                where mese = 12
												  and tipo = 'N'
                                              )
					 and inex2.ci   = prfi.ci
					 and inex2.anno = D_anno
                 )
		    where inex.ci   = ragi.ci
			  and inex.anno = D_anno_rire
           ;
	 END IF;
   EXCEPTION
      WHEN ESCI_INDIVIDUO THEN RAISE;
      WHEN OTHERS THEN
        ROLLBACK;
        progr_riga := progr_riga + 1;
        insert into a_segnalazioni_errore (no_prenotazione,
               passo,progressivo,errore,precisazione)
        values (prenotazione,1,progr_riga,'P05809',to_char(ragi.ci));
        RAISE ESCI_INDIVIDUO;
   END;
   BEGIN  -- Rilascio Individuo Elaborato
      CLOSE C_UPD_RAGI;
   END;
EXCEPTION
   WHEN TIMEOUT_ON_RESOURCE THEN
      progr_riga := progr_riga + 1;
      insert into a_segnalazioni_errore (no_prenotazione,
             passo,progressivo,errore,precisazione)
      values (prenotazione,1,progr_riga,'P05836',to_char(ragi.ci));
      commit;
      CLOSE C_UPD_RAGI;
   WHEN ESCI_INDIVIDUO THEN
      commit;
      CLOSE  C_UPD_RAGI;
   WHEN OTHERS THEN
      ROLLBACK;
      progr_riga := progr_riga + 1;
      error_number := SQLCODE;
      error_code   := SUBSTR(SQLERRM,1,50);
      insert into a_segnalazioni_errore (no_prenotazione,
             passo,progressivo,errore,precisazione)
      values (prenotazione,1,progr_riga,'P05809',to_char(error_number)||
              error_code);
      commit;
      CLOSE C_UPD_RAGI;
END tratta_ci;
BEGIN  -- Uscita dal ciclo ogni 10 Individui
       -- per rilascio ROLLBACK_SEGMENTS di Read_consistency
       -- cursor di select su RAPPORTI_GIURIDICI
   IF D_count_ci = 10 THEN
      D_count_ci := 0;
      D_dep_ci   := ragi.ci;  -- Attivazione Ripristino LOOP
      EXIT;                   -- Uscita dal LOOP
   END IF;
END;
END LOOP;  -- Fine LOOP su Ciclo Individui
IF D_dep_ci = 0 THEN
   EXIT;
ELSE
   D_ci_start := D_dep_ci;
   D_dep_ci   := 0;
END IF;
END LOOP;  -- Fine LOOP per Ripristino Ciclo Individui
         END ciclo_ci;
         commit;
      END;
      update a_prenotazioni
         set prossimo_passo = 91,
                     errore = 'P00108'
       where no_prenotazione = prenotazione
         and exists (select 'x'
           from a_segnalazioni_errore
          where no_prenotazione = prenotazione)
      ;
EXCEPTION
   WHEN OTHERS THEN
      update a_prenotazioni
         set prossimo_passo = 91,
                     errore = 'P00108'
       where no_prenotazione = prenotazione
         and exists (select 'x'
           from a_segnalazioni_errore
          where no_prenotazione = prenotazione)
      ;
END;
end;
end;
/
