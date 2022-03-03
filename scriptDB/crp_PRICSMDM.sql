/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE PRICSMDM IS
/******************************************************************************
 NOME:          PRICSMDM
 DESCRIZIONE:   Creazione del flusso per la Denuncia Mensile INPS DM10 e DM10/S.
                Questa fase produce un file secondo i tracciati imposti dalla Direzione
                dell' INPS.
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:   La gestione che deve risultare come intestataria della denuncia
                deve essere stata inserita in << DGEST >> in modo tale che la
                ragione sociale (campo nome) risulti essere la minore di tutte
                le altre eventualmente inserite.
                Lo stesso risultato si raggiunge anche inserendo un BLANK prima
                del nome di tutte le gestioni che devono essere escluse.

               Il PARAMETRO D_anno indica l'anno di riferimento della denuncia
               da elaborare.
               Il PARAMETRO D_mensilita indica la mensilita` di riferimento della
               denuncia da elaborare.
               Il PARAMETRO D_consulente indica quale gestione deve risultare come
               C.E.D. che ha elaborato il supporto.
               Il PARAMETRO D_pos_inps indica quale posizione INPS deve essere ela-
               rata (% = tutte).
               Il PARAMETRO D_prog_den indica il progressivo di presentazione del
               supporto.
               Il PARAMETRO D_tipo_pag indica la modalita` di pagamento.

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    22/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/
/*<TOAD_FILE_CHUNK>*/

CREATE OR REPLACE PACKAGE BODY PRICSMDM IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 22/01/2003';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
 BEGIN


DECLARE 
--
--  Variabili di Ordinamento
--
  D_dep_prog  number := 3;
  D_prog_rec  number := 3;
  D_prog_pos  number := 0;
  D_prog_ass  number := 1;

--
--  Variabili di Estrazione 
--
  D_anno         number;
  D_mese         number;
  D_da_mensilita varchar2(4);
  D_a_mensilita  varchar2(4);
  D_fine_mese    date;
  D_pos_inps     varchar2(12);
  D_da_pagare    number;
  D_prog_den     varchar2(2);
  D_tipo_pag     varchar2(1);

--
--  Variabili di Consulente/Azienda 
--
  D_consulente   varchar2(4);
  D_cons_nome    varchar2(30);
  D_nr_az        number := 0;
  D_tot_az_a     number := 0;
  D_tot_az_b     number := 0;
  D_tot_az       number := 0;
  D_cons_cf      varchar2(16);
  D_cons_ca      varchar2(16);
  D_cons_inps    varchar2(10);
  D_cons_abi     varchar2(5);
  D_cons_cab     varchar2(5);
  D_cons_cc      varchar2(13); --  Comprensivo del cin
  D_occupati     number;
  D_occupati_td  number;
  D_num_m        number;
  D_imp_m        number;
  D_num_f        number;
  D_imp_f        number;
  D_sca_max      number := 0;
  D_sca_prec     number := 0;
  D_sca_appo     number := 0;
  D_nucleo_2     number;
  D_nucleo_3     number;
  D_nucleo_4     number;
  D_nucleo_5     number;
  D_nucleo_6     number;
  D_nucleo_n     number;
  D_nucleo_t2    number := 0;
  D_nucleo_t3    number := 0;
  D_nucleo_t4    number := 0;
  D_nucleo_t5    number := 0;
  D_nucleo_t6    number := 0;
  D_nucleo_tn    number := 0;

--
--  Variabili di Consulente/Azienda 
--
  D_imponibile   number := 0;
  D_contributo   number := 0;

--
--  Definizione Exception      
--
  NO_DM10S  EXCEPTION;
  NO_DM10   EXCEPTION;
  USCITA    EXCEPTION;

BEGIN  -- Estrazione Parametri di Selezione della Prenotazione
  BEGIN
    select substr(valore,1,4)
      into D_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_ANNO'         
    ;  
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            select anno
              into D_anno
              from riferimento_retribuzione
             where rire_id = 'RIRE';
  END;                            
  BEGIN
    select substr(valore,1,4)
      into D_mese
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_MESE'         
    ;  
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            select mese
              into D_mese
              from riferimento_retribuzione
             where rire_id = 'RIRE';
  END;                            
  BEGIN
    select last_day(to_date(lpad(to_char(D_mese),2,'0')
                                 ||to_char(D_anno),'mmyyyy'))
      into D_fine_mese
      from dual
    ;
  END;
  BEGIN
    select substr(valore,1,4)
      into D_da_mensilita
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_DA_MENSILITA'          
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            select mensilita
              into D_da_mensilita
              from riferimento_retribuzione
             where rire_id = 'RIRE';
  END;                            
  BEGIN
    select substr(valore,1,4)
      into D_a_mensilita
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_A_MENSILITA'          
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            select mensilita
              into D_a_mensilita
              from riferimento_retribuzione
             where rire_id = 'RIRE';
  END;                            
  BEGIN
    select substr(valore,1,4)
      into D_consulente
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CONSULENTE'          
       and exists 
          (select 'x' from gestioni
            where codice = rtrim(substr(valore,1,4))
          )
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            -- Gestione Consulente non prevista                   
               update a_prenotazioni set errore = 'P01201' 
                                       , prossimo_passo = 99
                where no_prenotazione = prenotazione
               ;
            COMMIT;
            RAISE USCITA;               
  END;                            
  BEGIN
    select substr(valore,1,12)
      into D_pos_inps
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_POS_INPS'     
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            D_pos_inps := '%';
  END;                            
  BEGIN
    select substr(valore,1,12)
      into D_da_pagare
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_DA_PAGARE'     
    ;
    IF D_pos_inps = '%' THEN
       update a_prenotazioni 
          set errore          = 'P01202'
            , prossimo_passo  = 99
        where no_prenotazione = prenotazione;
       COMMIT;
       RAISE USCITA;
    END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN 
           D_da_pagare := '';              
  END;                            
  BEGIN
    select substr(valore,1,2)
      into D_prog_den
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_PROG_DEN'     
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            D_prog_den := '0001';
  END;                            
  BEGIN
    select substr(valore,1,1)
      into D_tipo_pag
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_TIPO_PAG'     
    ;
  EXCEPTION
       WHEN NO_DATA_FOUND THEN
            D_tipo_pag := '1';
  END;                            

  BEGIN

    D_nr_az    := 0;
    D_tot_az   := 0;
    D_tot_az_a := 0;
    D_tot_az_b := 0;

    --
    --  Estrazione Dati Banca CONSULENTE / AZIENDA
    --
    BEGIN
    select nvl(iscr.codice_abi,'0')
         , nvl(spor2.cab,'0')
         , nvl(substr(spor1.descrizione,1,13),' ')
      into D_cons_abi,D_cons_cab,D_cons_cc
      from istituti_credito iscr,sportelli spor1,sportelli spor2
     where spor1.istituto  = '*'
       and spor1.sportello = '*'
       and iscr.codice     = spor1.cab
       and spor2.istituto  = spor1.cab
       and spor2.sportello = spor1.dipendenza
    ;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
            D_cons_abi := '00000';
            D_cons_cab := '00000';
            D_cons_cc  := '0000000000000';
  END;                            
    --
    --  Estrazione Dati CONSULENTE / AZIENDA
    --
    BEGIN
      select rpad(gest.nome,30,' ')
           , nvl(gest.partita_iva,nvl(gest.codice_fiscale,' '))
           , nvl(gest.aut_dm10,' ')
           , rpad(gest.posizione_inps,10,' ')
        into D_cons_nome
           , D_cons_cf
           , D_cons_ca
           , D_cons_inps
        from gestioni gest
       where gest.codice        = D_consulente
      ;
    END;                            


         --
         --  Loop per inserimento records AZIENDALI
         --

    FOR CUR_AZ IN
       (select rpad(gest.nome,20,' ')                           gest_nome
             , rpad(nvl(gest.aut_dm10,' '),10,' ')              gest_ca
             , rpad(nvl(gest.csc_dm10,' '),10,' ')              gest_csc
             , lpad(to_char(nvl(gest.zona_sede_inps,0)),2,'0')  gest_zona
             , rpad(nvl( gest.partita_iva
                       , nvl(gest.codice_fiscale,' ')),16,' ')  gest_cf
             , gest.posizione_inps                              gest_inps 
          from gestioni gest
         where gest.codice in
              (select substr(min(rpad(nome,40)||codice),41,4)
                 from gestioni
                where substr(nome,1,1) !=   ' '
                  and posizione_inps   like D_pos_inps
                group by posizione_inps
              )
       ) LOOP

         D_prog_rec := D_prog_rec + 2;
         D_tot_az_a := 0;
         D_tot_az_b := 0;

         BEGIN  -- estrazione dati DM10/S

         FOR CUR_DM10_S in
            (select decode( valuta
			              , 'L', round(sum(rpdm.col9)/1000)*1000    
						       , round(sum(rpdm.col9))
					      )                                              col_55
                  , decode( valuta
				          , 'L', round(sum(rpdm.col9)/1000)*1000   
						       , round(sum(rpdm.col9))
						  )                                              col_5
                  , decode( instr(upper(rpdm.d2),'PROV.AUTONOMA')
                          , 0, substr( upper(rpdm.d2),1,3)
                             , substr( upper(rpdm.d2),15,3)
                          )                                              prov
                  , decode( valuta
				          , 'L', round(sum(rpdm.col2)/1000)*1000   
						       , round(sum(rpdm.col12))
						  )                                              col_1
                  , decode( valuta
				          , 'L', round(sum(rpdm.col5)/1000)*1000 
						       , round(sum(rpdm.col5))
						  )                                              col_2
                  , sum(nvl(rpdm.col1,0) + nvl(rpdm.col4,0))             col_3
                  , decode( valuta
				          , 'L', round(sum(rpdm.col8)/1000)*1000   
						       , round(sum(rpdm.col8))
						  )                                              col_4
                  , decode( valuta
				          , 'L', round(sum(nvl(rpdm.col10,0) +
                                           nvl(rpdm.col11,0))/1000)*1000 
							   , round(sum(nvl(rpdm.col10,0) +
							               nvl(rpdm.col11,0)))  
						  )                                              col_6
                  , decode( nvl(sum(rpdm.col10),0) +
                            nvl(sum(rpdm.col11),0)
                          , 0, '0'
                             , '1')                                      flag
               from  report_dm10_s rpdm
              where rpdm.anno       = D_anno
                and rpdm.mese       = D_mese
                and rpdm.mensilita  between D_da_mensilita
                                        and D_a_mensilita
                and rpdm.ci        in
                   (select ci 
                      from periodi_retributivi
                     where periodo  = D_fine_mese
                       and competenza = 'A'
                       and gestione  in
                          (select codice from gestioni
                            where posizione_inps = CUR_AZ.gest_inps
                          )
                   )
              group by decode( instr(upper(rpdm.d2),'PROV.AUTONOMA')
                             , 0, substr( upper(rpdm.d2),1,3)
                                , substr( upper(rpdm.d2),15,3)
                             )
            ) LOOP

              BEGIN

                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                values ( prenotazione
                  , 1
                  , D_prog_rec
                  , D_prog_rec
                  , '8'||
                    rpad(CUR_AZ.gest_inps,10,' ')||
                    lpad(to_char(D_mese),2,'0')||
                    substr(to_char(D_anno),3,2)||
                    lpad(to_char(nvl(CUR_DM10_s.col_55,0)),12,'0')||
                    lpad(to_char(nvl(CUR_DM10_s.col_5,0)),12,'0')||
                    lpad(to_char(D_prog_rec),4,'0')||
                    rpad(CUR_DM10_s.prov,3,' ')||
                    lpad(to_char(nvl(CUR_DM10_s.col_1,0)),12,'0')||
                    lpad(to_char(nvl(CUR_DM10_s.col_2,0)),12,'0')||
                    lpad(to_char(nvl(CUR_DM10_s.col_3,0)),6,'0')||
                    lpad(to_char(nvl(CUR_DM10_s.col_4,0)),12,'0')||
                    '000000'||
                    CUR_AZ.gest_zona||
                    lpad(to_char(nvl(CUR_DM10_s.col_6,0)),11,'0')||
                    CUR_DM10_S.flag||
                    lpad(' ',10,' ')||
                    ' '||
                    ' '
                       );

                D_prog_rec := D_prog_rec + 1;
         
              END;
              END LOOP;
              BEGIN
              BEGIN
              select count(distinct ci)
                into D_occupati
                from periodi_retributivi
               where periodo = D_fine_mese  
                 and gestione  in
                    (select codice from gestioni
                      where posizione_inps = CUR_AZ.gest_inps
                    )
                 and exists
                    (select 'x' from rapporti_individuali
                      where ci = periodi_retributivi.ci
                        and rapporto in (select codice from classi_rapporto
                                          where presenza = 'SI')
                    )
              ;
              END;
              BEGIN
              select count(distinct ci)
                into D_occupati_td
                from periodi_retributivi
               where periodo = D_fine_mese  
                 and D_anno >= 1999
                 and gestione  in
                    (select codice from gestioni
                      where posizione_inps = CUR_AZ.gest_inps
                    )
                 and posizione in 
                    (select codice from posizioni
                      where tempo_determinato = 'SI')   
                 and exists
                    (select 'x' from rapporti_individuali
                      where ci = periodi_retributivi.ci
                        and rapporto in (select codice from classi_rapporto
                                          where presenza = 'SI')
                    )
              ;
              END;
              insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
              values ( prenotazione
                     , 1
                     , D_prog_rec
                     , D_prog_rec
                     , '3'||
                       rpad(CUR_AZ.gest_inps,10,' ')||
                       lpad(to_char(D_mese),2,'0')||
                       substr(to_char(D_anno),3,2)||
                       lpad('0',12,'0')||
                       lpad(to_char(D_prog_rec),4,'0')||
                       'A'||
                       '**01'||
                       lpad(to_char(nvl(D_occupati,0)),12,'0')||
                       lpad(to_char(nvl(D_occupati_td,0)),12,'0')||
                       '000000000000'||
                       '000000000000'||
                       '000000000000'||
                       '000000000000'||
                       '            '
                    );
              D_prog_rec := D_prog_rec + 1;
              END;

              FOR CUR_DM10 IN
                 (select esco.quadro                                   quadro
                       , max(esco.arrotondamento)                      tipo_arr
                       , count(distinct(lpad(to_char(moco.mese),2,'0')||
                                             to_char(moco.ci)))        num_ci
                       , round(sum(
                         decode( esco.giorni
                               , 'O',nvl(moco.qta,0)*nvl(moco.ore,1)/6
                               , 'Q',nvl(moco.qta,0)
                               , 'I',decode
                                     ( decode(voec.classe
                                             ,'I','R',voec.classe)
                                     , 'R',decode
                                           (esco.tipo
                                           ,'C',nvl(moco.imp,0)
                                                -nvl(moco.ipn_p,0)
                                           ,'P',decode
                                               (to_char(moco.riferimento,'yyyy')
                                               ,to_char(D_anno),nvl(moco.ipn_p,0)
                                                              , nvl(moco.imp,0)
                                               )
                                               ,nvl(moco.imp,0)
                                           )
                                         ,nvl(moco.imp,0)
	                             )    
                                    ,null
                               )
                            ))                                         giorni
                       , sum(
                         decode( voec.classe
                               , 'R',decode
                                     ( esco.tipo
                                     , 'C',nvl(moco.tar,0)-nvl(moco.ipn_eap,0)
                                     , 'P', decode
                                            ( to_char(moco.riferimento,'yyyy')
                                            , to_char(D_anno),nvl(moco.ipn_eap,0)
                                                            ,nvl(moco.tar,0)
                                            )
                                          , nvl(moco.tar,0)
                                     )
                               , 'I',decode
                                     ( esco.tipo
                                     , 'C',nvl(moco.imp,0)-nvl(moco.ipn_p,0)
                                     , 'P',decode
                                           ( to_char(moco.riferimento,'yyyy')
                                           , to_char(D_anno), nvl(moco.ipn_p,0)
                                                           , nvl(moco.imp,0)
                                           )
                                          ,nvl(moco.imp,0)
                                     )
                                    ,nvl(moco.tar,0)
	                       ) *decode(esco.imponibile,'NO',0,1)  
                         )                                          imponibile
                       , sum(
                         decode( decode(voec.classe,'I','R',voec.classe)
                               , 'R',decode
                                     ( esco.tipo
                                     , 'C',nvl(moco.imp,0)-nvl(moco.ipn_p,0)
                                     , 'P',decode
                                           ( to_char(moco.riferimento,'yyyy')
                                           , to_char(D_anno), nvl(moco.ipn_p,0)
                                                           , nvl(moco.imp,0)
                                           )
                                          ,nvl(moco.imp,0)
                                     )
                                    ,nvl(moco.imp,0)
                  	       ) *decode(voec.tipo,'T',-1,1) 
                                 *decode(esco.contributo,'NO',0,1)  
                         )                                        contributo
                       , decode
                         ( greatest(100,esco.sequenza)
                         , 100, rpad('**'||esco.codice,4,' ')
                              , rpad(esco.codice,4,'0'))           codice
                    from estrazione_contributi esco
                       , movimenti_contabili   moco
                       , ritenute_voce         rivo
                       , voci_economiche       voec
                   where esco.quadro   in ('C','D')
                     and moco.ci in 
                                 (select ci 
                                    from periodi_retributivi
                                   where periodo  = D_fine_mese
                                     and competenza = 'A'
                                     and gestione  in
                                        (select codice from gestioni
                                         where posizione_inps = CUR_AZ.gest_inps
                                        )
                                 )
                     and moco.voce      = esco.voce
                     and moco.sub       = esco.sub
                     and voec.codice    = moco.voce
                     and moco.anno      = D_anno
                     and moco.mese      = D_mese 
                     and moco.mensilita between D_da_mensilita
                                            and D_a_mensilita
                     and rivo.voce (+)  = moco.voce
                     and rivo.sub  (+)  = moco.sub
                     and moco.riferimento
                         between nvl(rivo.dal,to_date('2222222','j'))
                             and nvl(rivo.al,to_date('3333333','j'))
                     and exists
                        (select 'x' from movimenti_contabili   m
                                       , estrazione_contributi ec
                                       , voci_economiche       voec2
                          where m.ci        (+)  = moco.ci
                            and m.anno      (+)  = moco.anno
                            and m.mese      (+)  = moco.mese
                            and m.mensilita (+)  = moco.mensilita
                            and esco.rowid       = ec.rowid
                            and m.voce      (+)  = ec.con_voce
                            and m.sub       (+)  = ec.con_sub
                            and voec2.codice     = ec.con_voce
                            and ((   decode
                                     ( voec2.classe
                                     ,'R',decode
                                          (ec.tipo
                                          ,'C',nvl(m.tar,0)-nvl(m.ipn_eap,0)
                                          ,'P',decode
                                               (to_char(m.riferimento,'yyyy')
                                               ,to_char(D_anno),nvl(m.ipn_eap,0)
                                                               , nvl(m.tar,0)
                                               )
                                              ,nvl(m.tar,0)
                                          )
                                     ,'I',decode
                                          (ec.tipo
                                          ,'C',nvl(m.imp,0)-nvl(m.ipn_p,0)
                                          ,'P',decode
                                               (to_char(m.riferimento,'yyyy')
                                               ,to_char(D_anno),nvl(m.ipn_p,0)
                                                               ,nvl(m.imp,0)
                                               )
                                          ,nvl(m.imp,0)
                                          )
                                         ,nvl(m.tar,0)
	                             ) != 0
                                  or decode
                                     (decode(voec2.classe,'I','R',voec2.classe)
                                     ,'R',decode
                                          (ec.tipo
                                          ,'C',nvl(m.imp,0)-nvl(m.ipn_p,0)
                                          ,'P',decode
                                               (to_char(m.riferimento,'yyyy')
                                               ,to_char(D_anno), nvl(m.ipn_p,0)
                                                               , nvl(m.imp,0)
                                               )
                                              ,nvl(m.imp,0)
                                          )
                                         ,nvl(m.imp,0)
	                             ) != 0)  and nvl(ec.tipo,' ')   != '0'
                         	 or ec.tipo = '0' and nvl(m.imp,0)    = 0
                                 )
                                )
                            and (          esco.tipo          is null 
                                 or        esco.tipo           = '0'
                                 or        esco.tipo           = '>'
                                 or        esco.tipo           = '<'
                                 or        esco.tipo           = 'A'       and
                                           moco.arr           is not null  and 
                                    decode(voec.tipo,'T',-1,1) = sign(moco.imp)
                                 or        esco.tipo          in ('C','P') and 
                                       nvl(moco.arr,' ')       = 
                                       decode
                                       (esco.tipo
                                       ,'C',decode
                                            (to_char(moco.riferimento,'yyyy')
                                            ,to_char(D_anno),nvl(moco.arr,' ')
                                                            ,null
                                            )
                                       ,'P',decode
                                            (to_char(moco.riferimento,'yyyy')
                                            ,to_char(D_anno),decode
                                                             (nvl(moco.ipn_p,0)
                                                             ,0,null
                                                              ,nvl(moco.arr,' ')
                                                             )
                                                            , nvl(moco.arr,' ')
                                            )
                                       )
                                 or        esco.tipo           = 'M'       and
                                           moco.arr           is null
                                 or decode(esco.tipo,'U','M','D','F') =
                                          (select sesso from anagrafici 
                                            where al is null
                                              and ni = 
                                                 (select ni
                                                    from rapporti_individuali
                                                   where ci = moco.ci))
                                 or decode(esco.tipo
                                          ,'1',1,'2',2,'3',3,'4',4,'5',5
                                          ,'6',6,'7',7,'8',8,'9',9,0) =
                                   (select max(qua_inps)
                                      from qualifiche                 
                                     where numero =
                                          (select to_number
                                                  (substr
                                                   (max(decode(pere.servizio
                                                              ,'Q','1','I','2','0')
                                                        ||to_char(pere.qualifica)),2,6))
                                             from periodi_retributivi pere
                                            where pere.ci        = moco.ci
                                              and pere.servizio in ('Q','I')
                                              and moco.riferimento 
                                                  between pere.dal and pere.al
                                              and pere.periodo   = D_fine_mese
                            and (    moco.input       = upper(moco.input)
                                 and pere.competenza in ('D','C','A')
                                  or  moco.input      != upper(moco.input)
                                 and pere.competenza in ('P','D')
                                  or  moco.input      != upper(moco.input)
                                 and pere.competenza in ('C','A')
                                 and not exists 
                                    (select 'x' from periodi_retributivi
                                      where periodo          = pere.periodo
                                        and ci               = pere.ci
                                        and competenza       = 'P'
                                        and moco.riferimento between dal and al)
                               )
                        )
                       )
        or decode(esco.tipo,'X',1,'Y',2,'Z',3) =
          (select max(decode(qua_inps,9,2,qua_inps))
             from qualifiche                 
            where ('SI','NO',numero) =
           (select substr(max(decode(servizio,'Q','1','I','2','0')||posi.part_time),2,2)
                 , substr(max(decode(servizio,'Q','1','I','2','0')||posi.contratto_formazione),2,2)
                 , to_number(substr(max(decode(servizio,'Q','1','I','2','0')||to_char(qualifica)),2,6))
              from posizioni posi,periodi_retributivi pere 
             where pere.ci     = moco.ci
               and pere.servizio in ('Q','I')
               and pere.posizione = posi.codice 
               and moco.riferimento between pere.dal and pere.al
               and pere.periodo  = D_fine_mese
               and (    moco.input       = upper(moco.input)
                    and pere.competenza in ('D','C','A')
                     or  moco.input      != upper(moco.input)
                    and pere.competenza in ('P','D')
                     or  moco.input      != upper(moco.input)
                    and pere.competenza in ('C','A')
                    and not exists 
                       (select 'x' from periodi_retributivi
                         where periodo          = pere.periodo
                           and ci               = pere.ci
                           and competenza       = 'P'
                           and moco.riferimento between dal and al)
                  )
           )
          )
        or decode(esco.tipo,'x',1,'y',2) =
          (select max(decode(qua_inps,9,2,qua_inps))
             from qualifiche                 
            where ('SI','SI',numero) =
           (select substr(max(decode(servizio,'Q','1','I','2','0')||posi.part_time),2,2)
                 , substr(max(decode(servizio,'Q','1','I','2','0')||posi.contratto_formazione),2,2)
                 , to_number(substr(max(decode(servizio,'Q','1','I','2','0')||to_char(qualifica)),2,6))
              from posizioni posi,periodi_retributivi pere 
             where pere.ci     = moco.ci
               and pere.servizio in ('Q','I')
               and (    moco.input       = upper(moco.input)
                    and pere.competenza in ('D','C','A')
                     or  moco.input      != upper(moco.input)
                    and pere.competenza in ('P','D')
                     or  moco.input      != upper(moco.input)
                    and pere.competenza in ('C','A')
                    and not exists 
                       (select 'x' from periodi_retributivi
                         where periodo          = pere.periodo
                           and ci               = pere.ci
                           and competenza       = 'P'
                           and moco.riferimento between dal and al)
                  )
               and pere.posizione = posi.codice 
               and moco.riferimento between dal and al
               and pere.periodo  = D_fine_mese
           )
          )
        or decode(esco.tipo,'o',1,'i',2) =
          (select max(decode(qua_inps,9,2,qua_inps))
             from qualifiche                 
            where ('NO','SI',numero) =
           (select substr(max(decode(servizio,'Q','1','I','2','0')||posi.part_time),2,2)
                 , substr(max(decode(servizio,'Q','1','I','2','0')||posi.contratto_formazione),2,2)
                 , to_number(substr(max(decode(servizio,'Q','1','I','2','0')||to_char(qualifica)),2,6))
              from posizioni posi,periodi_retributivi pere 
             where pere.ci     = moco.ci
               and (    moco.input       = upper(moco.input)
                    and pere.competenza in ('D','C','A')
                     or  moco.input      != upper(moco.input)
                    and pere.competenza in ('P','D')
                     or  moco.input      != upper(moco.input)
                    and pere.competenza in ('C','A')
                    and not exists 
                       (select 'x' from periodi_retributivi
                         where periodo          = pere.periodo
                           and ci               = pere.ci
                           and competenza       = 'P'
                           and moco.riferimento between dal and al)
                  )
               and pere.servizio in ('Q','I')
               and pere.posizione = posi.codice 
               and moco.riferimento between dal and al
               and pere.periodo  = D_fine_mese
           )
          )
        or decode(esco.tipo,'O',1,'I',2,'G',3) =
	  (select max(decode(qua_inps,9,2,qua_inps)) from qualifiche
            where ('NO','NO',numero) =
           (select substr(max(decode(servizio,'Q','1','I','2','0')||posi.part_time),2,2)
                 , substr(max(decode(servizio,'Q','1','I','2','0')||posi.contratto_formazione),2,2)
                 , to_number(substr(max(decode(servizio,'Q','1','I','2','0')||to_char(qualifica)),2,6))
              from posizioni posi,periodi_retributivi pere
             where pere.ci     = moco.ci
               and (    moco.input       = upper(moco.input)
                    and pere.competenza in ('D','C','A')
                     or  moco.input      != upper(moco.input)
                    and pere.competenza in ('P','D')
                     or  moco.input      != upper(moco.input)
                    and pere.competenza in ('C','A')
                    and not exists 
                       (select 'x' from periodi_retributivi
                         where periodo          = pere.periodo
                           and ci               = pere.ci
                           and competenza       = 'P'
                           and moco.riferimento between dal and al)
                  )
               and pere.servizio in ('Q','I')
               and pere.posizione = posi.codice
               and moco.riferimento between dal and al
               and pere.periodo  = D_fine_mese 
           )
      )
        or decode(esco.tipo,'R','SI','N','NO') =
                 (select posi.ruolo from posizioni posi
                   where posi.codice =
                        (select pere.posizione
                           from periodi_retributivi pere 
                          where pere.ci     = moco.ci
                            and (    moco.input       = upper(moco.input)
                                 and pere.competenza in ('D','C','A')
                                 or  moco.input      != upper(moco.input)
                                 and pere.competenza in ('P','D')
                                 or  moco.input      != upper(moco.input)
                                 and pere.competenza in ('C','A')
                                 and not exists 
                                    (select 'x' from periodi_retributivi
                                      where periodo          = pere.periodo
                                        and ci               = pere.ci
                                        and competenza       = 'P'
                                        and moco.riferimento between dal and al)
                               )
                            and pere.servizio = 'Q'
                            and moco.riferimento between dal and al
                            and pere.periodo  = D_fine_mese
                         )
                 )
	or esco.tipo = '+' and sign(moco.imp) =  1
	or esco.tipo = '-' and sign(moco.imp) = -1
       )
group by esco.quadro,esco.sequenza,esco.codice
            ) LOOP

              BEGIN
              BEGIN
                select decode( CUR_DM10.imponibile
                             , 0, 0
                                , decode( valuta
								        , 'L', round( (CUR_DM10.imponibile -1)
                                                     / 1000) * 1000
										     , round( CUR_DM10.imponibile)
									    ) 
                             )
                     , decode( CUR_DM10.contributo
                             , 0, 0
                                , decode( valuta
								        , 'L', round( (CUR_DM10.contributo -1)
                                                     / 1000) * 1000
										     , round( CUR_DM10.contributo)
									    )
                             )
                  into D_imponibile, D_contributo
                  from dual;
              END;

              IF CUR_DM10.quadro = 'C'
              THEN 
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                values ( prenotazione
                       , 1
                       , D_prog_rec
                       , D_prog_rec
                       , '3'||
                         rpad(CUR_AZ.gest_inps,10,' ')||
                         lpad(to_char(D_mese),2,'0')||
                         substr(to_char(D_anno),3,2)||
                         lpad('0',12,'0')||
                         lpad(to_char(D_prog_rec),4,'0')||
                         'B'||
                         CUR_DM10.codice||
                         decode( CUR_DM10.codice
                               , '**23', lpad(to_char(CUR_DM10.num_ci),12,'0')
                               , '**24', lpad(to_char(CUR_DM10.num_ci),12,'0')
                               , '**33', '000000000000'
                               , 'E775', '000000000000'
                                       , lpad(to_char(CUR_DM10.num_ci),12,'0')
                               )||
                         decode( CUR_DM10.codice
                               , '**23', '000000000000'
                               , '**24', lpad(to_char(CUR_DM10.giorni),12,'0')
                               , '**33', '000000000000'
                               , 'E775', '000000000000'
                                       , lpad(to_char(CUR_DM10.giorni),12,'0')
                               )||
                         decode( CUR_DM10.codice
                               , '**23', '000000000000'
                               , '**24', lpad(to_char(
                                           decode(valuta
										         ,'L',trunc(abs(D_imponibile)/1000))
												     ,trunc(abs(D_imponibile))
												 )
                                             ,12,'0')
                               , '**33', '000000000000'
                               , 'E775', '000000000000'
                                       , lpad(to_char(
                                           decode( valuta
										         , 'L', trunc(abs(D_imponibile)/1000))
												      , trunc(abs(D_imponibile))
											     )
                                             ,12,'0')
                               )||
                         decode( CUR_DM10.codice
                               , '**23', lpad(to_char(
                                           decode( valuta
										         , 'L', trunc(abs(D_contributo)/1000))
												      , trunc(abs(D_contributo))
												 )
                                             ,12,'0')
                               , '**24', '000000000000'
                               , '**33', lpad(to_char(
                                           decode( valuta
										         , 'L', trunc(abs(D_contributo)/1000))
												      , trunc(abs(D_contributo))
												 )
                                              ,12,'0')
                               , 'E775', lpad(to_char(
                                           decode( valuta
										         , 'L', trunc(abs(D_contributo)/1000))
												      , trunc(abs(D_contributo))
												 )
                                              ,12,'0')
                                       , lpad(to_char(
                                           decode( valuta
										         , 'L', trunc(abs(D_contributo)/1000))
												      , trunc(abs(D_contributo))
												 )
                                              ,12,'0')
                               )||
                         '000000000000'||
                         '000000000000'||
                         '            '
                       );

              D_tot_az_a := nvl(D_tot_az_a,0) + D_contributo;

              ELSE 
                insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                values ( prenotazione
                       , 1
                       , D_prog_rec
                       , D_prog_rec
                       , '3'||
                         rpad(CUR_AZ.gest_inps,10,' ')||
                         lpad(to_char(D_mese),2,'0')||
                         substr(to_char(D_anno),3,2)||
                         lpad('0',12,'0')||
                         lpad(to_char(D_prog_rec),4,'0')||
                         'D'||
                         CUR_DM10.codice||
                         '000000000000'||
                         '000000000000'||
                         '000000000000'||
                         lpad(to_char(decode(valuta
						                    ,'L',trunc(abs(D_contributo)/1000))
											    ,trunc(abs(D_contributo))
											)
							 ,12,'0')||
                         '000000000000'||
                         '000000000000'||
                         '            '
                       );

              D_tot_az_b := nvl(D_tot_az_b,0) + D_contributo;

              END IF; 

              D_prog_rec := D_prog_rec + 1;
         
              END;
                   END LOOP;
              BEGIN
                IF D_anno < 1999 and D_mese in (3,9) THEN
                   BEGIN
                     select sum(decode(anag.sesso,'M',1,0)) 
                          , decode( valuta
						          , 'L', trunc(sum(decode(anag.sesso,'M',moco.imp,0))/1000)
								       , trunc(sum(decode(anag.sesso,'M',moco.imp,0)))
								  )
                          , sum(decode(anag.sesso,'F',1,0)) 
                          , decode( valuta
						          , 'L', trunc(sum(decode(anag.sesso,'F',moco.imp,0))/1000)
								       , trunc(sum(decode(anag.sesso,'F',moco.imp,0)))
								  )
                       into D_num_m,D_imp_m,D_num_f,D_imp_f
                       from movimenti_contabili moco
                          , anagrafici          anag
                      where moco.anno      = D_anno
                        and moco.mese      = D_mese 
                        and moco.mensilita = D_da_mensilita
                        and moco.voce     in ('INPS','INPSO')
                        and moco.ci in 
                                    (select ci 
                                       from periodi_retributivi
                                      where periodo  = D_fine_mese
                                        and competenza = 'A'
                                        and gestione  in
                                           (select codice from gestioni
                                            where posizione_inps = 
                                                          CUR_AZ.gest_inps
                                           )
                                    )
                        and anag.ni        = 
                           (select ni from rapporti_individuali
                             where ci = moco.ci)
                        and anag.al is null   
                     ;
                   END;
                   insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                   values ( prenotazione
                          , 1
                          , D_prog_rec
                          , D_prog_rec
                          , '3'||
                            rpad(CUR_AZ.gest_inps,10,' ')||
                            lpad(to_char(D_mese),2,'0')||
                            substr(to_char(D_anno),3,2)||
                            lpad('0',12,'0')||
                            lpad(to_char(D_prog_rec),4,'0')||
                            'X'||
                            '**01'||
                            lpad(to_char(nvl(D_num_m,0)),12,'0')||
                            lpad(to_char(nvl(D_imp_m,0)),12,'0')||
                            lpad(to_char(nvl(D_num_f,0)),12,'0')||
                            lpad(to_char(nvl(D_imp_f,0)),12,'0')||
                            lpad('0',12,'0')||
                            lpad('0',12,'0')||
                            lpad(' ',12,' ')
                          );
                D_prog_rec := D_prog_rec + 1;
                BEGIN
                  BEGIN
                    select max(scaglione)
                      into D_sca_max
                        from assegni_familiari
                       where D_fine_mese between dal
                                             and nvl(al,to_date('3333333','j'))
                    ;
                  END; 
                  D_sca_prec := 0;
                  FOR CUR_SCA IN
                     (select distinct scaglione
                                    , dal
                        from assegni_familiari
                       where D_fine_mese between dal
                                             and nvl(al,to_date('3333333','j'))
                     ) LOOP
                       D_prog_ass := D_prog_ass + 1;
                       IF D_prog_ass < 12 THEN
                       BEGIN 
                         select nvl(sum(decode( cafa.nucleo_fam
                                              , 2, 1, 0)),0) 
                              , nvl(sum(decode( cafa.nucleo_fam
                                              , 3, 1, 0)),0)
                              , nvl(sum(decode( cafa.nucleo_fam
                                              , 4, 1, 0)),0)
                              , nvl(sum(decode( cafa.nucleo_fam
                                              , 5, 1, 0)),0)
                              , nvl(sum(decode( cafa.nucleo_fam
                                              , 6, 1, 0)),0)
                              , nvl(sum(decode( greatest(nvl(cafa.nucleo_fam,0)
                                                        ,6)
                                              , cafa.nucleo_fam,1,0)),0)
                           into D_nucleo_2,D_nucleo_3,D_nucleo_4
                              , D_nucleo_5,D_nucleo_6,D_nucleo_n
                           from carichi_familiari cafa
                          where anno = D_anno
                            and mese = D_mese
                            and ci  in 
                               (select ci 
                                  from periodi_retributivi
                                 where periodo  = D_fine_mese
                                   and competenza = 'A'
                                   and gestione  in
                                      (select codice from gestioni
                                       where posizione_inps =
                                             CUR_AZ.gest_inps
                                      )
                               )
                           and exists
                              (select ci from informazioni_extracontabili inex
                                            , aggiuntivi_familiari        agfa
                                where anno        = D_anno 
                                  and agfa.codice = cafa.cond_fam
                                  and agfa.dal    = CUR_SCA.dal
                                  and decode( D_mese
                                            , 3, inex.ipn_fam_2ap
                                               , inex.ipn_fam_1ap) 
                                      between nvl(agfa.aggiuntivo,0)
                                             +D_sca_prec             
                                          and nvl(agfa.aggiuntivo,0)
                                             +CUR_SCA.scaglione
                                  and inex.ci = cafa.ci
                              )
                         ;
                       END;
                       insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                       values ( prenotazione
                              , 1
                              , D_prog_rec
                              , D_prog_rec
                              , '3'||
                                rpad(CUR_AZ.gest_inps,10,' ')||
                                lpad(to_char(D_mese),2,'0')||
                                substr(to_char(D_anno),3,2)||
                                lpad('0',12,'0')||
                                lpad(to_char(D_prog_rec),4,'0')||
                                'X'||
                                '**'||lpad(to_char(D_prog_ass),2,'0')||
                                lpad(to_char(D_nucleo_2),12,'0')||
                                lpad(to_char(D_nucleo_3),12,'0')||
                                lpad(to_char(D_nucleo_4),12,'0')||
                                lpad(to_char(D_nucleo_5),12,'0')||
                                lpad(to_char(D_nucleo_6),12,'0')||
                                lpad(to_char(D_nucleo_n),12,'0')||
                                lpad(' ',12,' ')
                              );
                       D_prog_rec  := D_prog_rec + 1;
                       D_nucleo_t2 := D_nucleo_t2 + nvl(D_nucleo_2,0);
                       D_nucleo_t3 := D_nucleo_t3 + nvl(D_nucleo_3,0);
                       D_nucleo_t4 := D_nucleo_t4 + nvl(D_nucleo_4,0);
                       D_nucleo_t5 := D_nucleo_t5 + nvl(D_nucleo_5,0);
                       D_nucleo_t6 := D_nucleo_t6 + nvl(D_nucleo_6,0);
                       D_nucleo_tn := D_nucleo_tn + nvl(D_nucleo_n,0);
                       D_nucleo_2 := 0;
                       D_nucleo_3 := 0;
                       D_nucleo_4 := 0;
                       D_nucleo_5 := 0;
                       D_nucleo_6 := 0;
                       D_nucleo_n := 0;
                       D_sca_prec := CUR_SCA.scaglione;   
                       END IF;
                       IF D_sca_max  = CUR_SCA.scaglione THEN
                       BEGIN 
                         select nvl(sum(decode( cafa.nucleo_fam
                                              , 2, 1, 0)),0) 
                              , nvl(sum(decode( cafa.nucleo_fam
                                              , 3, 1, 0)),0)
                              , nvl(sum(decode( cafa.nucleo_fam
                                              , 4, 1, 0)),0)
                              , nvl(sum(decode( cafa.nucleo_fam
                                              , 5, 1, 0)),0)
                              , nvl(sum(decode( cafa.nucleo_fam
                                              , 6, 1, 0)),0)
                              , nvl(sum(decode( greatest(nvl(cafa.nucleo_fam,0)
                                                        ,6)
                                              , cafa.nucleo_fam,1,0)),0)
                           into D_nucleo_2,D_nucleo_3,D_nucleo_4
                              , D_nucleo_5,D_nucleo_6,D_nucleo_n
                           from carichi_familiari cafa
                          where anno = D_anno
                            and mese = D_mese
                            and ci  in 
                               (select ci 
                                  from periodi_retributivi
                                 where periodo  = D_fine_mese
                                   and competenza = 'A'
                                   and gestione  in
                                      (select codice from gestioni
                                       where posizione_inps =
                                             CUR_AZ.gest_inps
                                      )
                               )
                            and exists
                               (select 'x' from informazioni_extracontabili inex
                                             , aggiuntivi_familiari        agfa
                                 where anno        = D_anno 
                                   and agfa.codice = cafa.cond_fam
                                   and agfa.dal    = CUR_SCA.dal
                                   and decode( D_mese
                                             , 3, inex.ipn_fam_2ap
                                                , inex.ipn_fam_1ap) 
                                       between nvl(agfa.aggiuntivo,0)
                                              +D_sca_prec 
                                           and nvl(agfa.aggiuntivo,0)
                                              +CUR_SCA.scaglione
                                   and inex.ci = cafa.ci
                               )
                         ;
                       END;
                       insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                       values ( prenotazione
                              , 1
                              , D_prog_rec
                              , D_prog_rec
                              , '3'||
                                rpad(CUR_AZ.gest_inps,10,' ')||
                                lpad(to_char(D_mese),2,'0')||
                                substr(to_char(D_anno),3,2)||
                                lpad('0',12,'0')||
                                lpad(to_char(D_prog_rec),4,'0')||
                                'X'||
                                '**12'||
                                lpad(to_char(D_nucleo_2),12,'0')||
                                lpad(to_char(D_nucleo_3),12,'0')||
                                lpad(to_char(D_nucleo_4),12,'0')||
                                lpad(to_char(D_nucleo_5),12,'0')||
                                lpad(to_char(D_nucleo_6),12,'0')||
                                lpad(to_char(D_nucleo_n),12,'0')||
                                lpad(' ',12,' ')
                              );
                       D_prog_rec  := D_prog_rec + 1;
                       D_nucleo_t2 := D_nucleo_t2 + nvl(D_nucleo_2,0);
                       D_nucleo_t3 := D_nucleo_t3 + nvl(D_nucleo_3,0);
                       D_nucleo_t4 := D_nucleo_t4 + nvl(D_nucleo_4,0);
                       D_nucleo_t5 := D_nucleo_t5 + nvl(D_nucleo_5,0);
                       D_nucleo_t6 := D_nucleo_t6 + nvl(D_nucleo_6,0);
                       D_nucleo_tn := D_nucleo_tn + nvl(D_nucleo_n,0);
                          ELSE null;
                       END IF;
                       END LOOP;
                       D_prog_ass := D_prog_ass + 1;
                       insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                       values ( prenotazione
                              , 1
                              , D_prog_rec
                              , D_prog_rec
                              , '3'||
                                rpad(CUR_AZ.gest_inps,10,' ')||
                                lpad(to_char(D_mese),2,'0')||
                                substr(to_char(D_anno),3,2)||
                                lpad('0',12,'0')||
                                lpad(to_char(D_prog_rec),4,'0')||
                                'X'||
                                '**13'||
                                lpad(to_char(D_nucleo_t2),12,'0')||
                                lpad(to_char(D_nucleo_t3),12,'0')||
                                lpad(to_char(D_nucleo_t4),12,'0')||
                                lpad(to_char(D_nucleo_t5),12,'0')||
                                lpad(to_char(D_nucleo_t6),12,'0')||
                                lpad(to_char(D_nucleo_tn),12,'0')||
                                lpad(' ',12,' ')
                              );
                       D_prog_rec  := D_prog_rec + 1;
                       D_prog_ass  := 1;
                END;
                END IF;
              END;
              D_nucleo_t2 := 0;
              D_nucleo_t3 := 0;
              D_nucleo_t4 := 0;
              D_nucleo_t5 := 0;
              D_nucleo_t6 := 0;
              D_nucleo_tn := 0;

           insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
           values ( prenotazione
                  , 1
                  , D_dep_prog
                  , D_dep_prog
                  , '2'||
                    rpad(CUR_AZ.gest_inps,10,' ')||
                    lpad(to_char(D_mese),2,'0')||
                    substr(to_char(D_anno),3,2)||
                    lpad(to_char(decode( valuta
					                   , 'L', trunc(abs(nvl(D_tot_az_a,0)
                                                       -nvl(D_tot_az_b,0))/1000))
											, trunc(abs(nvl(D_tot_az_a,0)
                                                       -nvl(D_tot_az_b,0)))
									   )
						,12,'0')||
                    lpad(to_char(nvl( D_da_pagare
                                    , decode( sign( abs(nvl(D_tot_az_a,0))
                                                   -abs(nvl(D_tot_az_b,0)))
                                            , 1, decode( valuta
											           , 'L', trunc(abs(nvl(D_tot_az_a,0)
                                                                       -nvl(D_tot_az_b,0))
                                                                   /1000)
															, trunc(abs(nvl(D_tot_az_a,0)
                                                                       -nvl(D_tot_az_b,0))
                                                                   )
													   )
                                               , 0))
                                ),12,'0')||
                    lpad(to_char(D_dep_prog),4,'0')||
                    rpad(CUR_AZ.gest_cf,16,' ')||
                    rpad(CUR_AZ.gest_nome,20,' ')||
                    lpad(nvl(CUR_AZ.gest_csc,' '),5,'0')||
                    rpad(nvl(CUR_AZ.gest_ca,' '),16,' ')||
                    CUR_AZ.gest_zona||
                    '    '||
                    decode( sign(abs(nvl(D_tot_az_a,0))-abs(nvl(D_tot_az_b,0)))
                          , -1, '9','1')||
                    '000000'||
                    ' '||
                    ' '||
                    '0'||
                    ' '||
                    ' '||
                    '  '
                  );
                     

           D_dep_prog := D_dep_prog + 1;

           insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
           values ( prenotazione
                  , 1
                  , D_dep_prog
                  , D_dep_prog
                  , '6'||
                    rpad(CUR_AZ.gest_inps,10,' ')||
                    lpad(to_char(D_mese),2,'0')||
                    substr(to_char(D_anno),3,2)||
                    D_tipo_pag||
                    lpad(' ',11,' ')||
                    lpad(to_char(decode( valuta
					                   , 'L', trunc(abs(nvl(D_tot_az_a,0)
                                                       -nvl(D_tot_az_b,0))/1000)
											, trunc(abs(nvl(D_tot_az_a,0)
                                                       -nvl(D_tot_az_b,0)))
										))
						,12,'0')||
                    lpad(to_char(D_dep_prog),4,'0')||
                    lpad(D_cons_abi,5,'0')||lpad(D_cons_cab,5,'0')||
                    rpad(D_cons_cc,13,' ')||
                    rpad(nvl(D_Cons_cf,' '),16,' ')||
                    CUR_AZ.gest_zona||'00'||D_cons_inps||
                    '0'||
                    lpad(' ',23,' ')
                  );
         
         D_dep_prog := D_prog_rec;
         D_nr_az    := D_nr_az + 1;
         D_tot_az   := nvl(D_tot_az,0) + (nvl(D_tot_az_a,0)-nvl(D_tot_az_b,0));

         END;
         END LOOP;


         BEGIN
           --
           --  Inserimento Dati CONSULENTE / AZIENDA
           --

           insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
           values ( prenotazione
                  , 1
                  , 1
                  , 1
                  , '1'||
                    D_cons_inps||
                    '0001'||
                    lpad(to_char(decode( valuta
					                   , 'L', trunc(nvl(D_da_pagare,D_tot_az)/1000)
									        , trunc(nvl(D_da_pagare,D_tot_az)))
					            ),12,'0')||
                    lpad(to_char(D_nr_az),6,'0')||
                    D_cons_nome||                  
                    lpad(D_prog_den,4,'0')||
                    rpad(nvl(D_cons_cf,' '),16,' ')||
                    rpad(nvl(D_cons_ca,' '),8,' ')||
                    '    '||
                    ' '||
                    lpad(' ',24,' ')
                  )
           ;

           insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
           values ( prenotazione
                  , 1
                  , 2
                  , 2
                  , '5'||
                    lpad(D_cons_inps,10,'0')||
                    '0002'||
                    lpad(D_cons_abi,5,'0')||
                    lpad(D_cons_cab,5,'0')||
                    rpad(D_cons_cc,13,' ')||
                    lpad(' ',10,' ')||
                    lpad(' ',72,' ')
                  )
           ;
         END;

  END;
COMMIT;
EXCEPTION 
WHEN USCITA THEN
 null;
END;
END;
END;
/
