CREATE OR REPLACE PACKAGE PECCSTVB IS
/******************************************************************************
 NOME:        PECCSMVB - CREAZIONE SUPPORTO MAGNETICO VERSAMENTI BANCA
 DESCRIZIONE: Creazione del flusso per la comunicazione dei versamenti delle retribuzioni alla Banca.
              Questa fase produce un file secondo il tracciato standard S.E.T.I.F.
              della Societa' interbancaria per l'automazione,per la trasmissione in 
              via telematica degli accrediti bancari per gli stipendi.
              Il file prodotto si trovera' nella directory \\dislocazione\sta del report server con il nome  
              PECCSTVB.txt .

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  20/01/2003
 1.1  02/07/2003 MS     Impostazione delle gestioni
 1.2  01/12/2004 MS     Modifica per attivita 8518
 1.3  14/12/2004 CB     Modifica per attività 7759
 1.4  13/01/2005 ML	    Nuovo valore a p_accrediti per elaborare SOLO assegni
 1.5  22/06/2005 CB     Introduzione del parametro P_gestione
 1.6  25/01/2007 AM     Introdotti i parametri P_rapporto e P_gruppo 
 1.7  31/01/2007 CB     Storicizzazione di RARE
 1.8  17/05/2007 CB     Gestione tipo_compenso 
 1.9  10/09/2007 CB     " 
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCSTVB IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.9 del 10/09/2007';
END VERSIONE;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
 BEGIN
DECLARE
  P_dummy             varchar2(1);
  P_passo             number;
  P_pagina            number;
  P_riga              number;
  P_ente              varchar2(4);
  P_ambiente          varchar2(8);
  P_utente            varchar2(8);
  P_fin_ela           date;
  P_anno              number;
  P_mese              number;
  P_mensilita         varchar2(4);
  P_des_mens          varchar2(30);
  P_des_mens_al1      varchar2(30);
  P_des_mens_al2      varchar2(30);
  P_giorno            number;
  P_mese_liq          number;
  P_data_esecuzione   date;
  P_banche_estere     varchar2(1);
  P_gruppo            VARCHAR2(12);
  P_rapporto          VARCHAR2(4);
  P_fascia            varchar2(2);
  P_IBAN              varchar2(1);
  P_dep_sia           varchar2(5);
  P_p_accrediti       varchar2(1);
  P_conta_sia         number(1);
  P_nome_file         varchar2(20);
  disposiz            number;
  totale              number;
  P_gestione          varchar(4);
  USCITA              EXCEPTION;
  SPORTELLO           EXCEPTION;
  TESORERIA           EXCEPTION;

  --
  -- Estrazione Parametri di Selezione della Prenotazione
  --
BEGIN
  BEGIN
    select ente
         , utente
         , ambiente
      into P_ente,P_utente,P_ambiente
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
      into P_mensilita
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_MENSILITA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    SELECT valore
      INTO P_gruppo
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_GRUPPO'
  ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         P_gruppo := '%';
  END;
  BEGIN
    SELECT valore
      INTO P_rapporto
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_RAPPORTO'
  ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         P_rapporto := '%';
  END;
  BEGIN  
    select substr(valore,1,2)
      into P_fascia
        from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_FASCIA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN 
            P_fascia := '%';
  END;
  BEGIN  
    select substr(valore,1,4)
      into P_p_accrediti
         from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_ACCREDITI'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
         P_p_accrediti := null;
  END;
  BEGIN  
    select substr(valore,1,4)
      into P_gestione
        from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_GESTIONE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN 
            P_gestione := '%';
  END;
  BEGIN
    select to_char(to_date(valore,'dd/mm/yyyy'),'dd-mon-yy')
      into P_data_esecuzione
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_DATA_ESECUZIONE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN  
    select substr(valore,1,1)
      into P_banche_estere
         from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_BANCHE_ESTERE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
         P_banche_estere := null;
  END;
  BEGIN  
    select valore
      into P_IBAN
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_IBAN'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN P_IBAN := null;
  END;
  BEGIN
    select nvl(P_anno,rire.anno) 
         , rire.fin_ela         
         , mens.mese           
         , mens.mensilita
         , mens.descrizione        
         , mens.descrizione_al1
         , mens.descrizione_al2       
         , mens.giorno            
         , mens.mese_liq         
      into P_anno,P_fin_ela,P_mese,P_mensilita,
           P_des_mens,P_des_mens_al1,P_des_mens_al2,
           P_giorno,P_mese_liq
      from riferimento_retribuzione rire
         , mensilita                mens
     where rire.rire_id    = 'RIRE'
       and (   mens.codice  = P_mensilita
	      or mens.mensilita = rire.mensilita and 
	         mens.mese      = rire.mese      and 
               P_mensilita is null
           )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select 'x'
      into P_dummy
      from dual
     where exists
          (select 'x'
             from istituti_credito     iscr
                , sportelli            spor
                , rapporti_individuali rain
                , anagrafici           anag
                , rapporti_retributivi_storici rare
                , movimenti_contabili  moco
            where moco.anno      = P_anno
              and moco.mese      = P_mese
              and moco.mensilita = P_mensilita
              and moco.voce      =
                 (select codice
                    from voci_economiche
                   where automatismo = 'NETTO'
                 )
              and sign(moco.imp) = 1
              and moco.ci        = rare.ci
              and rare.ci        = rain.ci
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
              and rain.ni        = anag.ni
              and nvl(rain.gruppo,' ') like P_gruppo
              and rain.rapporto  like P_rapporto
              and anag.al       is null
              and iscr.codice    = rare.istituto
              and spor.istituto  = rare.istituto
              and spor.sportello = rare.sportello
              and (   nvl(spor.provincia,0) < 200
                   or nvl(P_banche_estere,' ') = 'X')
			  and rare.dal = (select max(dal)
                        from rapporti_retributivi_storici r
                       where r.ci = rare.ci
                         and r.dal <= last_day(to_date( '01/'||lpad(TO_CHAR(p_mese),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy'))
                         and nvl(r.al,to_date('3333333','j')) >= to_date( '01/'||lpad(TO_CHAR(p_mese),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy')
                     )
          )
  ;
  EXCEPTION WHEN NO_DATA_FOUND THEN RAISE USCITA;
  END;
  P_passo  := passo;
  P_conta_sia  := 0;
  P_pagina := 0;
  P_riga   := 0;
  BEGIN
   BEGIN
   select 'x'
       into P_dummy
       from dual
      where exists 
           (select 'x' 
              from istituti_credito iscr
                 , sportelli spor1
                 , sportelli spor2
             where spor1.istituto  = '*'
               and substr(spor1.sportello,1,1) = '*'
               and iscr.codice     = spor1.cab
               and spor2.istituto  = spor1.cab
               and spor2.sportello = spor1.dipendenza);
    EXCEPTION WHEN NO_DATA_FOUND THEN RAISE SPORTELLO;
   END;

    FOR CUR_SIA IN
       (select distinct
               nvl(iscr.codice_abi,'0')                   mitt_abi
             , nvl(spor2.cab,'0')                         mitt_cab
             , nvl(substr(spor1.descrizione,1,12),' ')    mitt_cc
             , nvl(substr(spor1.descrizione,13,2),'IT')   mitt_cod_naz
             , nvl(substr(spor1.descrizione,15,2),'  ')   mitt_cin_eur
             , nvl(substr(spor1.descrizione,17,1),' ')    mitt_cin_ita
             , substr(spor1.indirizzo,1,5)                codice_sia
             , substr(spor1.indirizzo,6,1)                tipo_cod_sia
          from istituti_credito iscr,sportelli spor1,sportelli spor2
         where spor1.istituto              = '*'
           and substr(spor1.sportello,1,1) = '*'
           and iscr.codice                 = spor1.cab
           and spor2.istituto              = spor1.cab
           and spor2.sportello             = spor1.dipendenza
       ) LOOP

  P_conta_sia := P_conta_sia + 1;
  IF P_conta_sia > 5 THEN RAISE TESORERIA;
  END IF;
  BEGIN 
    select decode(P_conta_sia
                 , 1 ,'PEC'||avme.acronimo||decode(p_p_accrediti,'A','A_1.txt','_1.txt')
                 , 2 ,'PEC'||avme.acronimo||decode(p_p_accrediti,'A','A_2.txt','_2.txt')
                 , 3 ,'PEC'||avme.acronimo||decode(p_p_accrediti,'A','A_3.txt','_3.txt')
                 , 4 ,'PEC'||avme.acronimo||decode(p_p_accrediti,'A','A_4.txt','_4.txt')
                 , 5 ,'PEC'||avme.acronimo||decode(p_p_accrediti,'A','A_5.txt','_5.txt')
                     ,'PEC'||avme.acronimo||decode(p_p_accrediti,'A','A.txt','.txt'))
      into P_nome_file
      from a_prenotazioni apre
         , a_voci_menu    avme
     where apre.no_prenotazione = prenotazione
       and apre.voce_menu       = avme.voce_menu
       and nvl(P_conta_sia,0)   > 1;  

 EXCEPTION WHEN NO_DATA_FOUND THEN 
                select 'PECCSTVB'||decode(P_P_ACCREDITI,'A','A.txt','.txt')
                  into p_nome_file
                  from dual;
  END;

         disposiz := 0;
         totale   := 0;
         P_riga   := P_riga   + 1;
         insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo) 
         values ( prenotazione
                , decode(P_conta_sia,1,1,2,3,3,5,4,7,5,9)
                , P_pagina
                , P_riga
                , ' PC'||
                  lpad(nvl(CUR_SIA.codice_sia,'0'),5,'0')||
                  lpad(nvl(CUR_SIA.mitt_abi,'0'),5,'0')||
                  to_char(sysdate,'ddmmyy')||
                  rpad(nvl(P_nome_file,' '),20,' ')||
                  lpad(' ',74,' ')||
                  DECODE(VALUTA,'L','I',VALUTA)||
                  ' '||
                  '     '
                )
         ;
    FOR CUR_GESTIONI IN 
   (select nvl(substr(spor1.sportello,2),'%')       gestione
      from istituti_credito iscr
         , sportelli spor1
         , sportelli spor2
     where spor1.istituto  = '*'
       and substr(spor1.sportello,1,1) = '*'
       and nvl(iscr.codice_abi,0)      = CUR_SIA.mitt_abi
       and nvl(spor2.cab,'0')          = CUR_SIA.mitt_cab
       and nvl(substr(spor1.descrizione,1,12),' ') 
                                       = nvl(CUR_SIA.mitt_cc,' ')
       and nvl(substr(spor1.indirizzo,1,5),' ') = nvl(CUR_SIA.codice_sia,' ')
       and nvl(substr(spor1.indirizzo,6,1),' ')
                                       = nvl(CUR_SIA.tipo_cod_sia,' ')
       and iscr.codice                 = spor1.cab
       and spor2.istituto              = spor1.cab
       and spor2.sportello             = spor1.dipendenza
   )LOOP
    BEGIN
       FOR CUR_DIP IN
       (select decode (valuta,'E',moco.imp*100,moco.imp)   imp
	              , decode(CUR_GESTIONI.gestione,'%',ente.partita_iva,gest.partita_iva) partita_iva
                  , nvl(iscr.codice_abi,'0')      dest_abi
                  , nvl(spor.cab,'0')             dest_cab
                  , spor.descrizione              des_spor
                  , nvl(rare.conto_corrente,' ')  dest_cc
                  , anag.codice_fiscale           cod_fis
                  , rare.cin_ita                              cin_ita
                  , rare.cin_eur                              cin_eur
                  , nvl(rare.cod_nazione,'IT')                cod_nazione
                  , decode( CUR_SIA.tipo_cod_sia
                          , '2', lpad(to_char(rare.matricola),8,'0')
                          , '3', anag.codice_fiscale
                               , ' ')    cod_sia
                  , decode( iscr.pronta_cassa
                          , 'SI', TO_CHAR(spor.modalita_pagamento )
                                , ' ')    mod_pag
                  , rare.ci              ci
                  , rain.ni              ni
                  , rain.cognome||'  '||
                    rain.nome            nome
                  , decode( rain.rapporto
                          , 'DIP', nvl(clra.tipo_compenso,'STIPENDIO')
                                 , nvl(clra.tipo_compenso,'COMPENSI')
                          )||
                    ' '||P_des_mens||' '||to_char(P_anno)       periodo_competenza
               from istituti_credito     iscr
                  , sportelli            spor
                  , rapporti_individuali rain
                  , anagrafici           anag
                  , movimenti_contabili  moco
                  , rapporti_retributivi_storici rare
                  , rapporti_giuridici   ragi
				  , classi_rapporto		 clra
		  , gestioni             gest
		  , ente                 ente
              where moco.anno      = P_anno
		    and ente_id        = 'ENTE' 
		    and ragi.gestione  = gest.codice
                and moco.mese      = P_mese
                and moco.mensilita = P_mensilita
                and moco.voce      =
                   (select codice
                      from voci_economiche
                     where automatismo = 'NETTO'
                   )
                and sign(moco.imp) = 1
                and moco.ci        = rare.ci
                and rare.ci        = ragi.ci
				and rain.rapporto  = clra.codice
                and ragi.gestione  like CUR_GESTIONI.gestione
                and ragi.gestione  like P_gestione
                and nvl(gest.fascia,' ')    like P_fascia
                AND (      p_p_accrediti is null 
                     OR (  P_p_accrediti = 'X' and rare.conto_corrente is not null)
                     OR (  P_p_accrediti = 'A' and rare.conto_corrente is null)
                    )
                and rare.ci        = rain.ci
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
                and nvl(rain.gruppo,' ') like P_gruppo
                and rain.rapporto like P_rapporto
                and rain.ni        = anag.ni
                and anag.al       is null
                and iscr.codice    = rare.istituto
                and spor.istituto  = rare.istituto
                and spor.sportello = rare.sportello
                and (   nvl(spor.provincia,0) < 200
                     or nvl(P_banche_estere,' ') = 'X')
				and rare.dal = (select max(dal)
                        from rapporti_retributivi_storici r
                       where r.ci = rare.ci
                         and r.dal <= last_day(to_date( '01/'||lpad(TO_CHAR(p_mese),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy'))
                         and nvl(r.al,to_date('3333333','j')) >= to_date( '01/'||lpad(TO_CHAR(p_mese),2,0)||'/'||TO_CHAR(p_anno),'dd/mm/yyyy')
                     )
            ) LOOP
              BEGIN
                totale   := totale   + CUR_DIP.imp;
                disposiz := disposiz + 1;
                P_riga   := P_riga   + 1;
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo) 
                values ( prenotazione
                       , decode(P_conta_sia,1,1,2,3,3,5,4,7,5,9)
                       , P_pagina
                       , P_riga
                       , ' 10'||
                         lpad(to_char(nvl(disposiz,0)),7,'0')||
                         lpad(' ',6,' ')||
                         nvl(to_char(P_data_esecuzione,'ddmmyy'),
                             to_char(sysdate,'ddmmyy'))||
                         lpad(to_char(P_giorno),2,'0')||
                         lpad(to_char(P_mese_liq),2,'0')||
                         substr(to_char(decode(sign(P_mese_liq -
                                                    P_mese)
                                              ,-1,P_anno + 1
                                                 , P_anno
                                              )
                                       )
                               ,3,2)||
                         '27020'||
                         lpad(to_char(nvl(CUR_DIP.imp,0)),13,'0')||
                         '+'||
                         lpad(nvl(CUR_SIA.mitt_abi,0),5,'0')||
                         lpad(nvl(CUR_SIA.mitt_cab,0),5,'0')||
                         lpad(nvl(rtrim(ltrim(substr(CUR_SIA.mitt_cc,1,instr(CUR_SIA.mitt_cc,'.'))))||
                              rtrim(ltrim(substr(CUR_SIA.mitt_cc,instr(CUR_SIA.mitt_cc,'.')+1)))
                             ,'0'),12,'0')||
                         lpad(nvl(CUR_DIP.dest_abi,0),5,'0')||
                         lpad(nvl(CUR_DIP.dest_cab,0),5,'0')||
                         lpad(nvl(rtrim(ltrim(substr(CUR_DIP.dest_cc,1,instr(CUR_DIP.dest_cc,'.'))))||
                              rtrim(ltrim(substr(CUR_DIP.dest_cc,instr(CUR_DIP.dest_cc,'.')+1)))
                             ,'0'),12,'0')||
                         lpad(nvl(CUR_SIA.codice_sia,' '),5,' ')||
                         nvl(CUR_SIA.tipo_cod_sia,' ')||
                         rpad(nvl(CUR_DIP.cod_sia,' '),16,' ')||
                         CUR_DIP.mod_pag||
                         rpad(' ',5,' ')||
                         DECODE(VALUTA,'L','I',VALUTA)
                       )
                ;
           IF P_IBAN = 'X' THEN
           P_riga   := P_riga   + 1;
           insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo) 
           select prenotazione
                , decode(P_conta_sia,1,1,2,3,3,5,4,7,5,9)
                , P_pagina
                , P_riga
                , ' 16'||
                  lpad(to_char(nvl(disposiz,0)),7,'0')||
                  lpad(nvl(CUR_SIA.mitt_cod_naz,' '),2,' ')||
                  lpad(nvl(CUR_SIA.mitt_cin_eur,'0'),2,'0')||
                  nvl(CUR_SIA.mitt_cin_ita,' ')||
                  lpad(nvl(CUR_SIA.mitt_abi,0),5,'0')||
                  lpad(nvl(CUR_SIA.mitt_cab,0),5,'0')||
                  lpad(nvl(rtrim(ltrim(substr(CUR_SIA.mitt_cc,1,instr(CUR_SIA.mitt_cc,'.'))))||
                       rtrim(ltrim(substr(CUR_SIA.mitt_cc,instr(CUR_SIA.mitt_cc,'.')+1)))
                      ,'0'),12,'0')||
                  rpad(' ',7,' ')||
                  rpad(' ',76,' ')
             from dual
           ;
           P_riga   := P_riga   + 1;
           insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo) 
           select prenotazione
                , decode(P_conta_sia,1,1,2,3,3,5,4,7,5,9)
                , P_pagina
                , P_riga
                , ' 17'||
                  lpad(to_char(nvl(disposiz,0)),7,'0')||
                  lpad(nvl(CUR_DIP.cod_nazione,' '),2,' ')||
                  lpad(nvl(to_char(CUR_DIP.cin_eur),'0'),2,'0')||
                  nvl(CUR_DIP.cin_ita,' ')||
                  lpad(nvl(CUR_DIP.dest_abi,0),5,'0')||
                  lpad(nvl(CUR_DIP.dest_cab,0),5,'0')||
                  lpad(nvl(rtrim(ltrim(substr(CUR_DIP.dest_cc,1,instr(CUR_DIP.dest_cc,'.'))))||
                       rtrim(ltrim(substr(CUR_DIP.dest_cc,instr(CUR_DIP.dest_cc,'.')+1)))
                      ,'0'),12,'0')||
                  rpad(' ',7,' ')||
                  rpad(' ',76,' ')
             from dual
           ;
           END IF;
                P_riga   := P_riga   + 1;
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo) 
                select prenotazione
                     , decode(P_conta_sia,1,1,2,3,3,5,4,7,5,9)
                     , P_pagina
                     , P_riga
                     , ' 20'||
                       lpad(to_char(nvl(disposiz,0)),7,'0')||
                       rpad(nvl(upper(nome),' '),90,' ')||
			     rpad(nvl(CUR_DIP.partita_iva,' '),16,' ')||
		           rpad(' ',4,' ')
                  from ente
                 where ente_id = 'ENTE'
                ;
                P_riga   := P_riga   + 1;
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo) 
                values ( prenotazione
                       , decode(P_conta_sia,1,1,2,3,3,5,4,7,5,9)
                       , P_pagina
                       , P_riga
                       , ' 30'||
                         lpad(to_char(nvl(disposiz,0)),7,'0')||
                         rpad(nvl(upper(CUR_DIP.nome),' '),90,' ')||
                         rpad(nvl(upper(CUR_DIP.cod_fis),' '),16,' ')||
                         lpad(' ',4,' ')
                       )
                ;
                P_riga   := P_riga   + 1;
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo) 
                select prenotazione
                     , decode(P_conta_sia,1,1,2,3,3,5,4,7,5,9)
                     , P_pagina
                     , P_riga
                     , ' 40'||
                       lpad(to_char(nvl(disposiz,0)),7,'0')||
                       rpad(nvl(upper(anag.indirizzo_res),' '),30,' ')||
                       rpad(nvl(anag.cap_res,' '),5,' ')||
                       rpad(nvl(upper(comu.descrizione),' '),25,' ')||
                       rpad(nvl(upper(CUR_DIP.des_spor),' '),50,' ')
                  from comuni     comu
                     , anagrafici anag
                 where anag.ni = CUR_DIP.ni
                   and anag.al       is null
                   and anag.provincia_res = comu.cod_provincia
                   and anag.comune_res    = comu.cod_comune
                ;
                P_riga   := P_riga   + 1;
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo) 
                values ( prenotazione
                       , decode(P_conta_sia,1,1,2,3,3,5,4,7,5,9)
                       , P_pagina
                       , P_riga
                       , ' 50'||
                         lpad(to_char(nvl(disposiz,0)),7,'0')||
                         rpad(nvl(CUR_DIP.periodo_competenza,' '),110,' ')
                       )
                ;
                P_riga   := P_riga   + 1;
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo) 
                values ( prenotazione
                       , decode(P_conta_sia,1,1,2,3,3,5,4,7,5,9)
                       , P_pagina
                       , P_riga
                       , ' 70'||
                         lpad(to_char(nvl(disposiz,0)),7,'0')||
                         lpad(' ',100,' ')||
                         nvl(CUR_DIP.cin_ita,' ')||
                         lpad(' ',9,' ')
                       )
                ;
              END;
              END LOOP; -- cur_dip
        END;
       END LOOP; -- cur_gestioni
              P_riga   := P_riga   + 1;
              insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo) 
              values ( prenotazione
                     , decode(P_conta_sia,1,1,2,3,3,5,4,7,5,9)
                     , P_pagina
                     , P_riga
                     , ' EF'||
                       lpad(nvl(CUR_SIA.codice_sia,0),5,'0')||
                       lpad(nvl(CUR_SIA.mitt_abi,0),5,'0')||
                       to_char(sysdate,'ddmmyy')||
                       rpad(nvl(P_nome_file,' '),20,' ')||
                       lpad(' ',6,' ')||
                       lpad(to_char(nvl(disposiz,0)),7,'0')||
                       lpad('0',15,'0')||
                       lpad(to_char(nvl(totale,0)),15,'0')||
                       lpad(to_char(nvl((disposiz*6)+2,0)),7,'0')||
                       lpad(' ',24,' ')||
                       DECODE(VALUTA,'L','I',VALUTA)||
                       '000000'
                     )
              ;
       END LOOP; -- cur_sia


       update a_selezioni
          set valore_default = p_nome_file
        where parametro='TXTFILE'
          and voce_menu = (select voce_menu
	        	     from a_prenotazioni
		            where no_prenotazione = prenotazione
                          );
COMMIT;

       END;
       EXCEPTION WHEN SPORTELLO THEN
         update a_prenotazioni set errore = 'P05410'
                                 , prossimo_passo = 99
                  where no_prenotazione = prenotazione
         ;
       COMMIT;
                 WHEN TESORERIA THEN
        update a_prenotazioni set errore = 'P05411'
                            , prossimo_passo = 99
               where no_prenotazione = prenotazione
         ;
       COMMIT;
                 WHEN USCITA THEN
        update a_prenotazioni set errore = 'P05805'
                            , prossimo_passo = 99
             where no_prenotazione = prenotazione
         ;
       COMMIT;

END;
end;
end;
/

