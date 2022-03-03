CREATE OR REPLACE PACKAGE PECCCAFA IS
/******************************************************************************
 NOME:        PECCCAFA
 DESCRIZIONE: Caricamento Automatico Carichi Familiari

 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  
 REVISIONI:
 Rev. Data       Autore   Descrizione
 ---- ---------- ------   --------------------------------------------------------
 1.0  24/08/2006 GM       Prima emissione
 1.1  29/09/2006 MS       Sistemazioni varie per Att. 17826
 1.2  02/10/2006 MS       Gestione differenziata Carichi Fis. e Carichi Fam. ( Att.17266 )
 1.3  03/10/2006 MS       Gestione Figli Minori e portatori di Handicap (Att. 17260 )
 1.4  09/10/2006 MS       Gestione della % di carico fiscale per familiari ( att. 17963 )
 1.5  17/10/2006 MS       Corretta gestione figli minori
 1.6  20/10/2006 MS       Revisione gestione stato civile
 1.7  24/10/2006 MS       Miglioria lettura flag di INEX ( Att.17266.1 )
 1.8  25/10/2006 MS       Aggiunta CC di RAIN e controllo su Codice Fiscale, mod. segnalazioni
 1.9  30/10/2006 MS       Correzione per nucleo_fam = MG ( Att. 17259.1.0 )
 1.10 31/10/2006 MS       Miglioria gestione flag di INEX e lettura % carico fiscale ( Att. 17265.1.0 )
 1.11 31/10/2006 MS       Nuovo controllo su FLAG di ENTE ( Att. 17265_2 )
 1.12 06/11/2006 MS       Modifica Utente Automatismo ( Att. 17265_2 )
 1.13 06/11/2006 MS       Correzioni varie su Assegni Familiari e aggiunta segnalazione bloccante
 1.14 22/11/2006 MS       Correzioni per errore in Oracle 7
 1.15 29/12/2006 MS       Inserimento segnalazioni per Finanziaria 2007
 1.16 29/05/2007 GM       Gestione Errore P05351 (Att. 18876.1) 
 1.17 11/07/2007 MS       Inserimento correzioni per Finanziaria 2007 Figli HH
 1.18 19/09/2007 MS       Inserimento correzioni per Carico familiare
 1.19 09/10/2007 MS       Gestione nuovo codice AF di PARE
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE verifica_nucleo ( prenotazione        number
                          , P_ci                number
                          , P_anno              number
                          , P_anno_car          number
                          , P_mese_car          number
                          , P_cond_fam          VARCHAR2
                          , P_nucleo_fam        number
                          , D_lancio         in varchar2
                          );
PROCEDURE verifica_cfis (  prenotazione         number
                          , P_ci                number
                          , P_anno              number
                          , P_mese              number
                          , P_cond_fis          VARCHAR2
                          , P_tipo              VARCHAR2
                          , P_numero            number
                          , P_precisazione   in varchar2
                          );                          
PROCEDURE insert_segnalazioni
                          ( prenotazione      number
                          , D_ci           in number
                          , D_errore       in varchar2
                          , D_precisazione in varchar2
                          );                             
PROCEDURE aggiorna_cafa(  prenotazione  in number
                        , P_ci             number
                        , P_rowid          VARCHAR2
                        , P_data           date
                        , P_anno           number
                        , P_mese           number
                        , P_anno_car       number
                        , P_mese_car       number
                        , P_AUT_ASS_FAM in VARCHAR2
                        , P_AUT_DED_FAM in VARCHAR2
                        , P_cond_fis       VARCHAR2
                        , P_coniuge        number
                        , P_figli          number
                        , P_figli_dd       number
                        , P_figli_mn       number
                        , P_figli_mn_dd    number
                        , P_figli_hh       number
                        , P_figli_hh_dd    number
                        , P_altri          number
                        , P_cond_fam   IN OUT VARCHAR2
                        , P_nucleo_fam IN OUT number
                        , P_figli_fam  IN OUT number
                        , D_lancio     in varchar2
                        , D_pagina     in OUT number
                        , D_riga       in OUT number
                          );
PROCEDURE calcolo         ( prenotazione in number
                          , passo   in number
                          , D_da_ci in number
                          , D_a_ci  in number
                          , D_gestione in varchar2
                          , D_rapporto in varchar2
                          , D_gruppo   in varchar2
                          , D_lancio   in varchar2  
                          );      
PROCEDURE MAIN   (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCCAFA IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.19 del 09/10/2007';
END VERSIONE;

PROCEDURE verifica_nucleo ( prenotazione        number
                          , P_ci                number
                          , P_anno              number
                          , P_anno_car          number
                          , P_mese_car          number
                          , P_cond_fam          VARCHAR2
                          , P_nucleo_fam        number
                          , D_lancio         in varchar2                          
                          ) IS
    D_imp_ass     number;
    D_errore      varchar2(100);
    D_descrizione varchar2(100);
    D_cond_fam    varchar2(4) := P_cond_fam;
    D_ass_fam     number := 0;
    D_ass_figli_1 number := 0;
    D_ass_figli_2 number := 0;
    D_nucleo_fam  number := P_nucleo_fam;
    D_figli_fam   number;
  BEGIN
    IF P_cond_fam IS NOT NULL
       AND P_nucleo_fam IS NOT NULL
    THEN
      /* Lettura CODICE tabella dalla quale ricavare l'importo */
      GP4_CAFA.CALCOLA_ASSEGNO(P_ci
                              ,P_anno_car
                              ,P_mese_car
                              ,D_cond_fam
                              ,D_nucleo_fam
                              ,D_figli_fam
                              ,D_ass_fam
                              ,D_ass_figli_1
                              ,D_ass_figli_2
                              ,D_imp_ass
                              ,D_errore
                              ,D_descrizione);
    END IF;
    IF D_errore is not null and D_lancio = 'CCAFA' and P_anno_car = P_anno
    THEN
-- dbms_output.put_line('verifica nucleo errore: '||D_cond_fam||' '||D_errore);
/* Inserire segnalazione */
    insert_segnalazioni ( prenotazione
                        , P_ci
                        , D_errore
                        , D_descrizione
                        ) ;
    END IF;
  END VERIFICA_NUCLEO;

PROCEDURE verifica_cfis ( prenotazione          number
                          , P_ci                number
                          , P_anno              number
                          , P_mese              number
                          , P_cond_fis          VARCHAR2
                          , P_tipo              VARCHAR2
                          , P_numero            number
                          , P_precisazione   in varchar2
                          ) IS
  D_errore      varchar2(100);
  BEGIN  
--  dbms_output.put_line('verifica cfis: '||P_COND_FIS||' '||P_TIPO||' '||P_NUMERO||' '||P_anno||' '||P_mese);
      BEGIN
        select decode( count(*), 0, 'P05341','')
          into D_errore
          from DETRAZIONI_FISCALI
         where CODICE = P_COND_FIS
           and TIPO   = P_TIPO
           and NUMERO = P_NUMERO
           and to_date('01/'||to_char(P_MESE)||'/'||to_char(P_ANNO),'dd/mm/yyyy')
               between nvl(DAL,to_date('2222222','j'))
                   and nvl(AL ,to_date('3333333','j'))
        ;
       EXCEPTION WHEN NO_DATA_FOUND THEN
          D_errore := 'P05341'; -- Condizione Fiscale non presente
       END;
       IF D_errore is not null and P_anno = P_anno THEN
          insert_segnalazioni ( prenotazione, P_ci, D_errore, P_precisazione ) ;
       END IF;
  END VERIFICA_CFIS;
                                                
PROCEDURE insert_segnalazioni
                          ( prenotazione   in number
                          , D_ci           in number
                          , D_errore       in varchar2
                          , D_precisazione in varchar2
                          ) IS
P_prn number := prenotazione;
D_passo number := 1;
P_riga number;
BEGIN
  select max(progressivo)
    into P_riga
    from a_segnalazioni_errore
   where no_prenotazione = P_prn
     and passo = 1
  ;
  P_riga := nvl(P_riga,0) + 1;
  INSERT INTO a_segnalazioni_errore
  ( no_prenotazione,passo,progressivo,errore,precisazione )
  select P_prn, D_passo, P_riga, D_errore, SUBSTR(' Dip.: '||TO_CHAR(D_ci)||' '||D_precisazione,1,60)
    from dual
   where not exists ( select 'x' 
                        from a_segnalazioni_errore 
                       where no_prenotazione = P_prn
                         and passo = D_passo
                         and errore = D_errore
                         and precisazione = SUBSTR(' Dip.: '||TO_CHAR(D_ci)||' '||D_precisazione,1,60)
                    );
END INSERT_SEGNALAZIONI;                            

PROCEDURE aggiorna_cafa ( prenotazione  in number
                        , P_ci             number
                        , P_rowid          VARCHAR2
                        , P_data           date
                        , P_anno           number
                        , P_mese           number
                        , P_anno_car       number
                        , P_mese_car       number
                        , P_AUT_ASS_FAM in VARCHAR2
                        , P_AUT_DED_FAM in VARCHAR2
                        , P_cond_fis       VARCHAR2
                        , P_coniuge        number
                        , P_figli          number
                        , P_figli_dd       number
                        , P_figli_mn       number
                        , P_figli_mn_dd    number
                        , P_figli_hh       number
                        , P_figli_hh_dd    number
                        , P_altri          number
                        , P_cond_fam   IN OUT VARCHAR2
                        , P_nucleo_fam IN OUT number
                        , P_figli_fam  IN OUT number
                        , D_lancio     in varchar2
                        , D_pagina     in OUT number
                        , D_riga       in OUT number
                        ) IS
  D_cond_fis     VARCHAR2(4);
  D_coniuge      number;
  D_figli        number;
  D_figli_dd     number;
  D_figli_mn     number;
  D_figli_mn_dd  number;
  D_figli_hh     number;
  D_figli_hh_dd  number;
  D_altri        number;
  D_cond_fam     VARCHAR2(4);
  D_nucleo_fam   number;
  D_figli_fam    number;
  D_anno_st      number(4) := ''; -- per stampa
  D_mese_st      number(2) := ''; -- per stampa
  D_errore       varchar2(6);
  D_conta_rec    number(4) := 0;
  D_minore_26    number(2);
  D_tra_18_e_21  number(2);
 
BEGIN
 BEGIN 
 <<AGGIORNA>>
 --dbms_output.put_line( 'Aggiorna: '||P_anno_car||' '||P_mese_car);
 --dbms_output.put_line( 'Figli: '||P_figli);
 --dbms_output.put_line( 'Figli minori: '||P_figli_mn);
   BEGIN  -- Lettura del Carico Attuale
      select cond_fis
           , coniuge
           , figli
           , figli_dd
           , figli_mn
           , figli_mn_dd
           , figli_hh
           , figli_hh_dd
           , altri
           , cond_fam
           , nucleo_fam
           , figli_fam
           , anno
           , mese
        into D_cond_fis
           , D_coniuge
           , D_figli
           , D_figli_dd
           , D_figli_mn
           , D_figli_mn_dd
           , D_figli_hh
           , D_figli_hh_dd
           , D_altri
           , D_cond_fam
           , D_nucleo_fam
           , D_figli_fam
           , D_anno_st
           , D_mese_st
        from carichi_familiari
       where rowid = P_rowid
         for update of cond_fis, cond_fam
      ;
   END;
   IF P_cond_fam is not null  AND
      (   P_anno_car = P_anno - 1
       OR P_anno_car = P_anno
      ) THEN
      BEGIN  -- Aggiorna Nucleo Familiare
         D_cond_fam := P_cond_fam;
         IF nvl(D_nucleo_fam,0) != P_nucleo_fam THEN
            D_nucleo_fam := P_nucleo_fam;
         END IF;
         IF nvl(D_figli_fam,0) != P_figli_fam THEN
            D_figli_fam := P_figli_fam;
         END IF;
      END;
   END IF;

   IF P_cond_fis is not null AND
      P_anno_car = P_anno    THEN
      BEGIN  -- Aggiorna Detrazioni Fiscali
         D_cond_fis := P_cond_fis;
         IF nvl(D_coniuge,0) != P_coniuge THEN
            IF P_coniuge = 0 THEN
               D_coniuge := null;
            ELSE
               D_coniuge := P_coniuge;
            END IF;
         END IF;
         IF nvl(D_figli,0) != P_figli THEN
            IF P_figli = 0 THEN
               D_figli := null;
            ELSE
               D_figli := P_figli;
            END IF;
         END IF;
         IF nvl(D_figli_dd,0) != P_figli_dd THEN
            IF P_figli_dd = 0 THEN
               D_figli_dd := null;
            ELSE
               D_figli_dd := P_figli_dd;
            END IF;
         END IF;
         IF nvl(D_figli_mn,0) != P_figli_mn THEN
            IF P_figli_mn = 0 THEN
               D_figli_mn := null;
            ELSE
               D_figli_mn := P_figli_mn;
            END IF;
         END IF;
         IF nvl(D_figli_mn_dd,0) != P_figli_mn_dd THEN
            IF P_figli_mn_dd = 0 THEN
               D_figli_mn_dd := null;
            ELSE
               D_figli_mn_dd := P_figli_mn_dd;
            END IF;
         END IF;
         IF nvl(D_figli_hh,0) != P_figli_hh THEN
            IF P_figli_hh = 0 THEN
               D_figli_hh := null;
            ELSE
               D_figli_hh := P_figli_hh;
            END IF;
         END IF;
         IF nvl(D_figli_hh_dd,0) != P_figli_hh_dd THEN
            IF P_figli_hh_dd = 0 THEN
               D_figli_hh_dd := null;
            ELSE
               D_figli_hh_dd := P_figli_hh_dd;
            END IF;
         END IF;         
         IF nvl(D_altri,0) != P_altri THEN
            IF P_altri = 0 THEN
               D_altri := null;
            ELSE
               D_altri := P_altri;
            END IF;
         END IF;
      END;
   END IF;
   BEGIN  -- Update della registrazione presente su carico fiscale
     IF P_anno_car >= P_anno and P_AUT_DED_FAM = 'SI' THEN
      update carichi_familiari
         set cond_fis   = D_cond_fis
           , coniuge    = D_coniuge
           , figli      = D_figli
           , figli_dd   = D_figli_dd
           , figli_mn   = D_figli_mn
           , figli_mn_dd  = D_figli_mn_dd
           , figli_hh   = decode(greatest(P_anno_car,2006)
                                ,2006, decode(nvl(D_figli_hh,0),0,'',nvl(D_figli,0)+nvl(D_figli_dd,0)||D_figli_hh)
                                     , decode(nvl(D_figli_hh,0),0,'',D_figli_hh)
                                )
           , figli_hh_dd   = decode(greatest(P_anno_car,2006)
                                   ,2006, decode(nvl(D_figli_hh_dd,0),0,'',nvl(D_figli,0)+nvl(D_figli_dd,0)||D_figli_hh_dd)
                                        , decode(nvl(D_figli_hh_dd,0),0,'',D_figli_hh_dd)
                                   )
           , altri      = D_altri
           , mese_att   = P_mese
           , utente     = 'CCAFA'
           , data_agg   = sysdate
       where rowid = P_rowid
      ;
      D_conta_rec := nvl(D_conta_rec,0) + SQL%ROWCOUNT;
      IF SQL%ROWCOUNT != 0 and D_lancio = 'CCAFA' THEN
        IF D_cond_fis IS NOT NULL THEN
           BEGIN
            select ''
              into D_errore
              from CONDIZIONI_FISCALI
             where CODICE = D_COND_FIS;
            EXCEPTION WHEN NO_DATA_FOUND THEN
               D_errore := 'P05300'; -- Condizione Fiscale non presente
            END;
            IF D_errore is not null and P_anno_car = P_anno THEN
              insert_segnalazioni ( prenotazione, P_ci, D_errore, '') ;
            END IF;
         END IF;
/* controlli su carico fiscale */         
          IF nvl(D_coniuge,0) != 0 THEN 
            verifica_cfis ( prenotazione, P_ci
                          , P_anno_car, P_mese_car
                          , D_cond_fis, 'CN'
                          , D_coniuge, ' per Coniuge'                          
                          );
           END IF;
           IF nvl(D_figli,0) != 0 THEN
            verifica_cfis ( prenotazione, P_ci
                          , P_anno_car, P_mese_car
                          , D_cond_fis, 'FG'
                          , D_figli, ' per Figli'
                          );
           END IF;
           IF nvl(D_figli_dd,0) != 0 THEN
            verifica_cfis ( prenotazione, P_ci
                          , P_anno_car, P_mese_car
                          , D_cond_fis, 'FD'
                          , D_figli_dd, ' per Figli Doppi'
                          );
           END IF;
           IF nvl(D_figli_mn,0) != 0 THEN
            verifica_cfis ( prenotazione, P_ci
                          , P_anno_car, P_mese_car
                          , D_cond_fis, 'FM'
                          , D_figli_mn, ' per Figli Minori'
                          );
           END IF;
           IF nvl(D_figli_mn_dd,0) != 0 THEN
            verifica_cfis ( prenotazione, P_ci
                          , P_anno_car, P_mese_car
                          , D_cond_fis, 'MD'
                          , D_figli_mn_dd, ' per Figli Minori Doppi'
                          );
           END IF;
           IF nvl(D_figli_hh,0) != 0 THEN
            IF P_anno_car > 2006 THEN
                verifica_cfis ( prenotazione, P_ci
                              , P_anno_car, P_mese_car
                              , D_cond_fis, 'FH'
                              , D_figli_hh, ' per Figli portatori di Handicap'
                              );
            ELSE
                verifica_cfis ( prenotazione, P_ci
                              , P_anno_car, P_mese_car
                              , D_cond_fis, 'FH'
                              , nvl(D_figli,0)+nvl(D_figli_dd,0)||D_figli_hh
                              , ' per Figli portatori di Handicap'
                              );
            END IF;
           END IF;
           IF nvl(D_figli_hh_dd,0) != 0 THEN
            IF P_anno_car > 2006 THEN
              verifica_cfis ( prenotazione, P_ci
                            , P_anno_car, P_mese_car
                            , D_cond_fis, 'HD'
                            , D_figli_hh_dd, ' per Figli Doppi portatori di Handicap '
                            );
            ELSE
              verifica_cfis ( prenotazione, P_ci
                            , P_anno_car, P_mese_car
                            , D_cond_fis, 'HD'
                            , nvl(D_figli,0)+nvl(D_figli_dd,0)||D_figli_hh_dd
                            , ' per Figli Doppi portatori di Handicap '
                            );
            END IF;
           END IF;
           IF nvl(D_altri,0) != 0 THEN
            verifica_cfis ( prenotazione, P_ci
                          , P_anno_car, P_mese_car
                          , D_cond_fis, 'AL'
                          , D_altri, ' per Altri Familiari a Carico '
                          );
           END IF;
       END IF; -- segnalazioni
     ELSIF P_anno_car >= P_anno and P_AUT_DED_FAM = 'NO' THEN
/* azzero eventuali carichi fiscali definiti in precedenza */
      update carichi_familiari
         set cond_fis   = null
           , coniuge    = null
           , figli      = null
           , figli_dd   = null
           , figli_mn   = null
           , figli_mn_dd  = null
           , figli_hh   = null
           , figli_hh_dd   = null
           , altri      = null
           , mese_att   = P_mese
           , utente     = 'CCAFA'
           , data_agg   = sysdate
       where rowid = P_rowid
         and ( cond_fis is not null
            or coniuge is not null
            or figli is not null
            or figli_dd is not null
            or altri is not null
             )
      ;
      D_conta_rec := nvl(D_conta_rec,0) + SQL%ROWCOUNT;
     END IF; -- controllo su anno e automatismo
   END;
   BEGIN  -- Update della registrazione presente su assegni familiari
     IF P_anno_car >= P_anno and P_AUT_ASS_FAM = 'SI' THEN
      update carichi_familiari
         set cond_fam   = D_cond_fam
           , nucleo_fam = D_nucleo_fam
           , figli_fam  = D_figli_fam
           , mese_att   = P_mese
           , utente     = 'CCAFA'
           , data_agg   = sysdate
       where rowid = P_rowid
      ;
      D_conta_rec := nvl(D_conta_rec,0) + SQL%ROWCOUNT; 
      IF SQL%ROWCOUNT != 0 and D_lancio = 'CCAFA' THEN
/* controllo dati inseriti 
P05350 : Condizione familiare non presente già gestita dal GP4_CAFA
P05391 : Carico familiare non presente già gestita dal GP4_CAFA
*/ 
      null;
      END IF; -- inserimento 
/* Aggiunti controlli per Finanziaria 2007 */
      IF P_anno_car >= 2007 and P_anno_car = P_anno THEN
        BEGIN
        /* Estraggo numero di figli con meno di 26 anni */
           select count(*)
             into D_minore_26
             from familiari                    fami
            where fami.ni =  ( select ni
                                 from rapporti_individuali
                                where ci = P_ci
                              )
              and P_data
                  between to_date( to_char(fami.dal,'mmyyyy') , 'mmyyyy' )
                      and nvl(fami.al,to_date('3333333','j'))
              and fami.relazione in ( select sequenza 
                                        from parentele 
                                       where carico_fis in ( 'FG','FD','FH','HD')
                                    )
                  and trunc(months_between(to_date('01'||lpad(P_mese_car,2,'0')||P_anno_car,'ddmmyyyy')
                                       ,data_nas)/12) < 26
           ;
        EXCEPTION WHEN NO_DATA_FOUND THEN
          D_minore_26 := 0;
        END;
        IF nvl(D_minore_26,0) >= 4 THEN
            BEGIN
            /* Estraggo numero di figli tra 18 e 21 anni */
               select count(*)
                 into D_tra_18_e_21
                 from familiari                    fami
                where fami.ni =  ( select ni
                                     from rapporti_individuali
                                    where ci = P_ci
                                  )
                  and P_data
                      between to_date( to_char(fami.dal,'mmyyyy') , 'mmyyyy' )
                          and nvl(fami.al,to_date('3333333','j'))
                  and fami.relazione in ( select sequenza 
                                            from parentele 
                                           where carico_fis in ( 'FG','FD','FH','HD')
                                        )
                  and trunc(months_between(to_date('01'||lpad(P_mese_car,2,'0')||P_anno_car,'ddmmyyyy')
                                       ,data_nas)/12)  between 18 and 21
               ;
            EXCEPTION WHEN NO_DATA_FOUND THEN
              D_tra_18_e_21 := 0;
            END;
            IF nvl(D_tra_18_e_21,0) != 0 THEN
               D_errore := 'P05351';
               IF D_lancio = 'CCAFA' THEN 
               insert_segnalazioni ( prenotazione, P_ci
                                   , D_errore
                                   , 'Presenza di figli compresi tra 18 e 21 anni.'
--                                       , ' Presenza di figli compresi tra 18 e 21 anni. Possibile carico familiare errato'
                                    ) ;
			   ELSIF D_lancio = 'ACAFA' THEN  
			     insert into appoggio_errori_gp4 (ci,fase,errore,bloccante)
				 values	(P_ci, D_lancio, D_errore, 'NO')
				 ;
               END IF;
            END IF;
        END IF; -- minori di 26
      END IF; -- controllo anno
     ELSIF P_anno_car >= P_anno and P_AUT_ASS_FAM = 'NO' THEN
/* azzero eventuali carichi familiari definiti in precedenza */     
      update carichi_familiari
         set cond_fam   = null
           , nucleo_fam = null
           , figli_fam  = null
           , mese_att   = P_mese
           , utente     = 'CCAFA'
           , data_agg   = sysdate
       where rowid = P_rowid
         and ( cond_fam is not null
            or nucleo_fam is not null
            or figli_fam is not null
             )
      ;
      D_conta_rec := nvl(D_conta_rec,0) + SQL%ROWCOUNT;
     END IF; -- controllo su anno e automatismo
   END;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
     IF P_anno_car >= P_anno THEN
        BEGIN  -- Inserimento di una nuova registrazione
           insert into carichi_familiari
                ( ci, anno, mese, mese_att, data_agg, utente
                , cond_fis, coniuge
                , figli, figli_dd
                , figli_mn
                , figli_mn_dd
                , figli_hh
                , figli_hh_dd
                , altri
                , cond_fam, nucleo_fam, figli_fam
                , sequenza
                )
          values( P_ci, P_anno_car, P_mese_car, P_mese, sysdate, 'CCAFA'
                , decode(P_AUT_DED_FAM,'SI',P_cond_fis,null)
                , decode(P_AUT_DED_FAM,'SI',decode(P_coniuge,0,null,P_coniuge),null)
                , decode(P_AUT_DED_FAM,'SI',decode(P_figli,0,null,P_figli),null)
                , decode(P_AUT_DED_FAM,'SI',decode(P_figli_dd,0,null,P_figli_dd),null)
                , decode(P_AUT_DED_FAM,'SI',decode(P_figli_mn,0,null,P_figli_mn),null)
                , decode(P_AUT_DED_FAM,'SI',decode(P_figli_mn_dd,0,null,P_figli_mn_dd),null)
                , decode(P_AUT_DED_FAM
                         ,'SI', decode(greatest(P_anno_car,2006)
                                      ,2006, decode(nvl(P_figli_hh,0),0,'',nvl(P_figli,0)+nvl(P_figli_dd,0)||P_figli_hh)
                                           , decode(nvl(P_figli_hh,0),0,'',P_figli_hh)
                                      )
                        )
                , decode(P_AUT_DED_FAM
                         ,'SI',decode(greatest(P_anno_car,2006)
                                      ,2006, decode(nvl(P_figli_hh_dd,0),0,'',nvl(P_figli,0)+nvl(P_figli_dd,0)||P_figli_hh_dd)
                                           , decode(nvl(P_figli_hh_dd,0),0,'',P_figli_hh_dd)
                                     )
                        )
                , decode(P_AUT_DED_FAM,'SI',decode(P_altri,0,null,P_altri),null)
                , decode(P_AUT_ASS_FAM,'SI',P_cond_fam,null)
                , decode(P_AUT_ASS_FAM,'SI',decode(P_nucleo_fam,0,null,P_nucleo_fam),null)
                , decode(P_AUT_ASS_FAM,'SI',decode(P_figli_fam,0,null,P_figli_fam),null)
                , 0
                )
           ;
      D_conta_rec := nvl(D_conta_rec,0) + SQL%ROWCOUNT;           
      IF SQL%ROWCOUNT != 0 and D_lancio = 'CCAFA' and P_AUT_DED_FAM = 'SI'  THEN
        IF P_cond_fis IS NOT NULL THEN
           BEGIN
            select ''
              into D_errore
              from CONDIZIONI_FISCALI
             where CODICE = P_COND_FIS;
            EXCEPTION WHEN NO_DATA_FOUND THEN
               D_errore := 'P05300'; -- Condizione Fiscale non presente
            END;
            IF D_errore is not null THEN
              insert_segnalazioni ( prenotazione, P_ci, D_errore, '') ;
            END IF;
         END IF;
         BEGIN
/* controlli su carico fiscale */         
          IF nvl(P_coniuge,0) != 0 THEN
            verifica_cfis ( prenotazione, P_ci
                          , P_anno_car, P_mese_car
                          , P_cond_fis, 'CN'
                          , P_coniuge, ' per Coniuge'                          
                          );
           END IF;
           IF nvl(P_figli,0) != 0 THEN
            verifica_cfis ( prenotazione, P_ci
                          , P_anno_car, P_mese_car
                          , P_cond_fis, 'FG'
                          , P_figli, ' per Figli'
                          );
           END IF;
           IF nvl(P_figli_dd,0) != 0 THEN
            verifica_cfis ( prenotazione, P_ci
                          , P_anno_car, P_mese_car
                          , P_cond_fis, 'FD'
                          , P_figli_dd, ' per Figli Doppi'
                          );
           END IF;
           IF nvl(P_figli_mn,0) != 0 THEN
            verifica_cfis ( prenotazione, P_ci
                          , P_anno_car, P_mese_car
                          , P_cond_fis, 'FM'
                          , P_figli_mn, ' per Figli Minori'
                          );
           END IF;
           IF nvl(P_figli_mn_dd,0) != 0 THEN
            verifica_cfis ( prenotazione, P_ci
                          , P_anno_car, P_mese_car
                          , P_cond_fis, 'MD'
                          , P_figli_mn_dd, ' per Figli Minori Doppi'
                          );
           END IF;
           IF nvl(P_figli_hh,0) != 0 THEN
            IF P_anno_car > 2006 THEN
                verifica_cfis ( prenotazione, P_ci
                              , P_anno_car, P_mese_car
                              , P_cond_fis, 'FH'
                              , P_figli_hh
                              , ' per Figli portatori di Handicap'
                              );
            ELSE
                verifica_cfis ( prenotazione, P_ci
                              , P_anno_car, P_mese_car
                              , P_cond_fis, 'FH'
                              , nvl(P_figli,0)+nvl(P_figli_dd,0)||P_figli_hh
                             , ' per Figli portatori di Handicap'
                              );
            END IF;
           END IF;
           IF nvl(P_figli_hh_dd,0) != 0 THEN
            IF P_anno_car >= 2006 THEN
              verifica_cfis ( prenotazione, P_ci
                            , P_anno_car, P_mese_car
                            , P_cond_fis, 'HD'
                            , P_figli_hh_dd
                            , ' per Figli Doppi portatori di Handicap '
                            );
            ELSE
              verifica_cfis ( prenotazione, P_ci
                            , P_anno_car, P_mese_car
                            , P_cond_fis, 'HD'
                            , nvl(P_figli,0)+nvl(P_figli_dd,0)||P_figli_hh_dd
                            , ' per Figli Doppi portatori di Handicap '
                            );
            END IF;
           END IF;
           IF nvl(P_altri,0) != 0 THEN
            verifica_cfis ( prenotazione, P_ci
                          , P_anno_car, P_mese_car
                          , P_cond_fis, 'AL'
                          , P_altri, ' per Altri Familiari a Carico '
                          );
           END IF;
         END;         
         END IF; -- segnalazioni e appoggio stampe
/* Aggiunti controlli per Finanziaria 2007 */
      IF P_AUT_ASS_FAM = 'SI' and P_anno_car >= 2007 and P_anno_car = P_anno THEN
        BEGIN
        /* Estraggo numero di figli con meno di 26 anni */
           select count(*)
             into D_minore_26
             from familiari                    fami
            where fami.ni =  ( select ni
                                 from rapporti_individuali
                                where ci = P_ci
                              )
              and P_data
                  between to_date( to_char(fami.dal,'mmyyyy') , 'mmyyyy' )
                      and nvl(fami.al,to_date('3333333','j'))
              and fami.relazione in ( select sequenza 
                                        from parentele 
                                       where carico_fis in ( 'FG','FD','FH','HD')
                                    )
              and trunc(months_between(to_date('01'||lpad(P_mese_car,2,'0')||P_anno_car,'ddmmyyyy')
                                       ,data_nas)/12) < 26
           ;
        EXCEPTION WHEN NO_DATA_FOUND THEN
          D_minore_26 := 0;
        END;
        IF nvl(D_minore_26,0) >= 4 THEN
            BEGIN
            /* Estraggo numero di figli tra 18 e 21 anni */
               select count(*)
                 into D_tra_18_e_21
                 from familiari                    fami
                where fami.ni =  ( select ni
                                     from rapporti_individuali
                                    where ci = P_ci
                                  )
                  and P_data
                      between to_date( to_char(fami.dal,'mmyyyy') , 'mmyyyy' )
                          and nvl(fami.al,to_date('3333333','j'))
                  and fami.relazione in ( select sequenza 
                                            from parentele 
                                           where carico_fis in ( 'FG','FD','FH','HD')
                                        )
                  and trunc(months_between(to_date('01'||lpad(P_mese_car,2,'0')||P_anno_car,'ddmmyyyy')
                                       ,data_nas)/12)  between 18 and 21
               ;
            EXCEPTION WHEN NO_DATA_FOUND THEN
              D_tra_18_e_21 := 0;
            END;
            IF nvl(D_tra_18_e_21,0) != 0 THEN
               D_errore := 'P05351';
               IF D_lancio = 'CCAFA' THEN
               insert_segnalazioni ( prenotazione, P_ci
                                   , D_errore
                                   , 'Presenza di figli compresi tra 18 e 21 anni.'
--                                       , ' Presenza di figli compresi tra 18 e 21 anni. Possibile carico familiare errato'
                                    ) ;
			   ELSIF D_lancio = 'ACAFA' THEN  
			     insert into appoggio_errori_gp4 (ci,fase,errore,bloccante)
				 values	(P_ci, D_lancio, D_errore, 'NO')
				 ;						
               END IF;
            END IF;
        END IF; -- minori di 26
      END IF; -- controllo anno

        END;
     END IF;
  END AGGIORNA;

    IF  nvl(D_conta_rec,0) != 0 and D_lancio = 'CCAFA' THEN
             D_riga := nvl(D_riga,0) + 1;
             INSERT  INTO a_appoggio_stampe 
             ( no_prenotazione, no_passo, pagina, riga, testo )
             select prenotazione
                    , 0
                    , D_pagina
                    , D_riga
                    , rpad(nvl(to_char(decode(nvl(P_anno_car,0),0,null,P_anno_car)),' '),4,' ')||' '
                    ||rpad(nvl(to_char(decode(nvl(P_mese_car,0),0,null,P_mese_car)),' '),4,' ')||' '
                    ||rpad(decode(P_AUT_DED_FAM,'SI',nvl(P_cond_fis,' '),' '),5,' ')||' '
                    ||lpad(nvl(decode(P_AUT_DED_FAM
                                     ,'SI',to_char(decode(nvl(P_coniuge,0),0,null,P_coniuge))
                                          ,null)
                              ,' '),4,' ')||' '
                    ||lpad(nvl(decode(P_AUT_DED_FAM
                                     ,'SI',to_char(decode(nvl(P_figli,0),0,null,P_figli))
                                          ,null)
                              ,' '),7,' ')||' '
                    ||lpad(nvl(decode(P_AUT_DED_FAM
                                     ,'SI',to_char(decode(nvl(P_figli_dd,0),0,null,P_figli_dd))
                                          ,null)
                              ,' '),7,' ')||' '
                    ||lpad(nvl(decode(P_AUT_DED_FAM
                                     ,'SI',to_char(decode(nvl(P_figli_mn,0),0,null,P_figli_mn))
                                          ,null)
                              ,' '),7,' ')||' '
                    ||lpad(nvl(decode(P_AUT_DED_FAM
                                     ,'SI',to_char(decode(nvl(P_figli_mn_dd,0),0,null,P_figli_mn_dd))
                                          ,null)
                              ,' '),7,' ')||' '
                    ||lpad(nvl(decode(P_AUT_DED_FAM
                                     ,'SI',to_char(decode(nvl(P_figli_hh,0)
                                                          ,0, null
                                                            ,decode(greatest(P_anno_car,2006)
                                                                    , 2006, to_number(nvl(P_figli,0)+nvl(P_figli_dd,0)||P_figli_hh)
                                                                          , to_number(P_figli_hh)
                                                                   )
                                                         ))
                                          ,null)
                              ,' '),7,' ')||' '
                    ||lpad(nvl(decode(P_AUT_DED_FAM
                                     ,'SI',to_char(decode(nvl(P_figli_hh_dd,0)
                                                          ,0, null
                                                            , decode(greatest(P_anno_car,2006)
                                                                    , 2006,to_number(nvl(P_figli,0)+nvl(P_figli_dd,0)||P_figli_hh_dd)
                                                                          , to_number(P_figli_hh_dd)
                                                                   )
                                                          ))
                                          ,null)
                               ,' '),7,' ')||' '
                    ||lpad(nvl(decode(P_AUT_DED_FAM
                                     ,'SI',to_char(decode(nvl(P_altri,0),0,null,P_altri))
                                          ,null)
                              ,' '),5,' ')||' '
                    ||rpad(decode(P_AUT_ASS_FAM,'SI',nvl(P_cond_fam,' '),' '),9,' ')||' '
                    ||lpad(nvl(decode(P_AUT_ASS_FAM
                                     ,'SI',to_char(decode(nvl(P_nucleo_fam,0),0,null,P_nucleo_fam))
                                          ,null)
                               ,' '),11,' ')||' '
                    ||lpad(nvl(decode(P_AUT_ASS_FAM
                                     ,'SI',to_char(decode(P_figli_fam,0,null,P_figli_fam))
                                          ,null)
                               ,' '),10,' ')
               from dual
             ;    
    END IF;
END AGGIORNA_CAFA;

PROCEDURE calcolo (prenotazione in number
                 , passo   in number
                 , D_da_ci in number
                 , D_a_ci  in number
                 , D_gestione in varchar2
                 , D_rapporto in varchar2
                 , D_gruppo   in varchar2
                 , D_lancio   in varchar2 
                 ) IS
  D_anno           riferimento_retribuzione.anno%type;
  D_mese           riferimento_retribuzione.mese%type;
  D_ini_ela        date;
  D_fin_ela        date;       
  D_data_prec      date;
  D_cond_fis       varchar2(4);
  D_coniuge        number;
  D_figli          number;
  D_figli_dd       number;
  D_figli_mn       number;
  D_figli_mn_dd    number;
  D_figli_hh       number;
  D_figli_hh_dd    number;
  D_altri          number;
  D_cond_fam       varchar2(4);
  D_nucleo_fam     number;
  D_figli_fam      number;
  D_dep_cond_fam   varchar2(4);
  D_dep_nucleo_fam number;
  D_dep_figli_fam  number;
  D_presenza_coniuge varchar2(2);
  D_se_figli_min   number;
  D_se_coniuge     number;
  D_se_coniuge_fam number;
  D_se_inabile     number;
  D_se_inabile_cn  number;
  D_se_inabile_fg  number;
  D_se_inabile_al  number;
  D_pagina         number := 0;
  D_riga           number := 0;     
  D_errore         varchar2(6);
  D_precisazione   varchar2(100);
  D_AUT_ASS_FAM    VARCHAR2(2);
  D_AUT_DED_FAM    VARCHAR2(2);
  D_PERC_CAR_FAM   number(2);

  D_ente           varchar2(4);
  D_ambiente       varchar2(8);
  D_utente         varchar2(8);
  
  D_dummy          varchar2(1);
  USCITA           EXCEPTION;

BEGIN
 BEGIN -- Estrazione Parametri di Selezione
  BEGIN
    select to_number(substr(valore,1,4))
         , to_date('01'||substr(valore,1,4),'mmyyyy')
         , to_date('3112'||substr(valore,1,4),'ddmmyyyy')
      into D_anno
         , D_ini_ela
         , D_fin_ela
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_ANNO'
        and D_lancio        = 'CCAFA' -- aggiunto per andare in exception se lanciata da form
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      select anno
        into D_anno
        from riferimento_retribuzione
       where rire_id = 'RIRE';
  END;
  BEGIN
    select to_number(substr(valore,1,2))
      into D_mese
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_MESE'
        and D_lancio        = 'CCAFA'  -- aggiunto per andare in exception se lanciata da form
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
      select mese
        into D_mese
        from riferimento_retribuzione
       where rire_id = 'RIRE';
  END;
   BEGIN
     select ente, utente, ambiente
       into D_ente, D_utente, D_ambiente
       from a_prenotazioni
      where no_prenotazione = prenotazione
     ;
   EXCEPTION WHEN NO_DATA_FOUND THEN null;
   END;
   BEGIN
      select 'X'
        into D_dummy
        from riferimento_retribuzione
       where ( anno < D_anno
           or  anno = D_anno
           and mese <= D_mese
             )
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN 
     RAISE USCITA;
   END;  

     FOR CUR_CI IN
        (select rain.ci
              , cognome ||' '|| nome nominativo
           from rapporti_individuali rain
              , periodi_giuridici    pegi
          where rain.ci between D_da_ci and D_a_ci
            and pegi.ci = rain.ci
            and rain.rapporto like D_rapporto
            and nvl(rain.gruppo,' ') like D_gruppo
            and pegi.rilevanza = 'S'
            and pegi.gestione like D_gestione
            and pegi.dal <= last_day(to_date('01'||lpad(D_mese,2,0)||D_anno,'ddmmyyyy'))
            and nvl(pegi.al,to_date('3333333','j')) >= to_date('01'||lpad(D_mese,2,0)||D_anno,'ddmmyyyy')
            and exists (select 'x'
                          from familiari fami
                         where fami.ni = rain.ni)
           and (   rain.cc is null
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
          order by 2
        ) LOOP 
 --dbms_output.put_line(to_char(CUR_CI.ci));
     IF D_lancio = 'CCAFA' then
/* inserimento CI per stampa */
       D_pagina := D_pagina + 1;
       INSERT INTO a_appoggio_stampe
       ( no_prenotazione, no_passo, pagina, riga, testo )
       VALUES ( prenotazione
              , 0
              , D_pagina
              , 0
              , lpad(CUR_CI.ci,8,'0')||rpad(CUR_CI.nominativo,60,' ')
             ) ;
     END IF; 
     -- Elimina Carichi Familiari successivi a data di Riferimento
    
     BEGIN
        delete from carichi_familiari
         where ci       = CUR_CI.ci
           and (   anno = D_anno and
                   mese > D_mese
                or anno > D_anno
               )
        ;
     END;
     D_data_prec := last_day(add_months(to_date(to_char(D_mese)||'/'||
                                        to_char(D_anno),'mm/yyyy'),1));
     FOR CURF IN  -- Cicla sulle date di modifica situazione Familiare
        (select distinct to_date(to_char(dal,'mmyyyy'),'mmyyyy') data
           from familiari fami
          where fami.ni =
               (select ni
                  from rapporti_individuali
                 where ci = CUR_CI.ci
               )
         UNION
         select distinct add_months( to_date(to_char(al,'mmyyyy'),'mmyyyy')
                                   , 1
                                   ) data
           from familiari fami
          where fami.ni =
               (select ni
                  from rapporti_individuali
                 where ci = CUR_CI.ci
               )
            and al is not null
         UNION
         select distinct add_months( to_date(to_char( add_months( data_nas, 36 ),'mmyyyy'),'mmyyyy'),1) data
           from familiari fami
              , parentele pare
          where fami.ni =
               (select ni
                  from rapporti_individuali
                 where ci = CUR_CI.ci
               )
            and pare.sequenza   = fami.relazione
            and pare.carico_fis in ('FD','FG','FH','HD')
            and add_months( data_nas, 36 ) < nvl(fami.al,to_date('3333333','j'))
          order by 1 desc
        ) LOOP
 --dbms_output.put_line('CURF  '||to_char(curf.data,'dd/mm/yyyy'));
        BEGIN  -- Determina il Carico Familiare alla data

         D_coniuge       := 0;
         D_figli         := 0;
         D_figli_dd      := 0;
         D_figli_mn      := 0;
         D_figli_mn_dd   := 0;
         D_figli_hh      := 0;
         D_figli_hh_dd   := 0;
         D_altri         := 0;
         D_nucleo_fam    := 0;
         D_figli_fam     := 0;
         D_se_figli_min  := 0;
         D_se_coniuge    := 0;
         D_se_inabile    := 0;
         D_se_inabile_cn := 0;
         D_se_inabile_fg := 0;
         D_se_inabile_al := 0;

           BEGIN  -- Preleva la situazione alla data
              select nvl(sum(decode( pare.carico_fis
                                   , 'CN', decode( conp.max_carico_fis
                                                 , null, 0
                                                       , 1
                                                 )
                                         , 0
                                   )),0)  -- D_coniuge
                   , nvl(sum(decode( pare.carico_fis
                                   , 'FG', decode( conp.max_carico_fis
                                                 , null, 0
                                                       , 1
                                                 )
                                         , 0
                                   ))
                        + sum(decode( pare.carico_fis
                                   , 'FH', decode( conp.max_carico_fis
                                                 , null, 0
                                                       , 1
                                                 )
                                         , 0
                                   ))                                   
                          ,0) -- D_figli
                   , nvl(sum(decode( pare.carico_fis
                                   , 'FD', decode( conp.max_carico_fis
                                                 , null, 0
                                                       , 1
                                                 )
                                         , 0
                                   ))
                       + sum(decode( pare.carico_fis
                                   , 'HD', decode( conp.max_carico_fis
                                                 , null, 0
                                                       , 1
                                                 )
                                         , 0
                                   ))
                        ,0) -- D_figli_dd
                   , nvl(sum(decode( pare.carico_fis
                                   , 'FG', decode( conp.max_carico_fis
                                                 , null, 0
                                                       , decode ( sign ( 3 - trunc(months_between (curf.data, fami.data_nas )/12))
                                                                , 1, 1
                                                                   , 0 )
                                                 )
                                         , 0
                                   ))
                      +  sum(decode( pare.carico_fis
                                   , 'FH', decode( conp.max_carico_fis
                                                 , null, 0
                                                       , decode ( sign ( 3 - trunc(months_between (curf.data, fami.data_nas )/12))
                                                                , 1, 1
                                                                   , 0 )
                                                 )
                                         , 0
                                   ))
                          ,0) -- D_figli_mn
                   , nvl(sum(decode( pare.carico_fis
                                   , 'FD', decode( conp.max_carico_fis
                                                 , null, 0
                                                       , decode ( sign ( 3 - trunc(months_between (curf.data, fami.data_nas )/12))
                                                                , 1, 1
                                                                   , 0 )
                                                 )
                                         , 0
                                   ))
                       + sum(decode( pare.carico_fis
                                   , 'HD', decode( conp.max_carico_fis
                                                 , null, 0
                                                       , decode ( sign ( 3 - trunc(months_between (curf.data, fami.data_nas )/12))
                                                                , 1, 1
                                                                   , 0 )
                                                 )
                                         , 0
                                   ))
                        ,0) -- D_figli_md
                   , nvl(sum(decode( pare.carico_fis
                                   , 'FH', decode( conp.max_carico_fis
                                                 , null, 0
                                                       , 1
                                                 )
                                         , 0
                                   ))                                   
                          ,0) -- D_figli_hh
                   , nvl(sum(decode( pare.carico_fis
                                   , 'HD', decode( conp.max_carico_fis
                                                 , null, 0
                                                       , 1
                                                 )
                                         , 0
                                   ))
                        ,0) -- D_figli_hd                        
                   , nvl(sum(decode( pare.carico_fis
                                   , 'AL', decode( conp.max_carico_fis
                                                 , null, 0
                                                       , 1
                                                 )
                                   , 'AF', decode( conp.max_carico_fis
                                                 , null, 0
                                                       , 1
                                                 )
                                         , 0
                                   )),0) -- D_altri
                   , nvl(sum(decode( pare.nucleo_fam
                                   , 'NO', 0
                                   , 'MG', decode( conp.inabile
                                                  ,'SI', decode( conp.max_carico_fam
                                                               , null, 0
                                                                     , 1
                                                               )
                                                       , 0
                                                 )
                                         , decode( conp.max_carico_fam
                                                 , null, 0
                                                       , 1
                                                 )
                                   )),0) -- D_nucleo_fam
                   , nvl(sum(decode( pare.nucleo_fam
                            , 'NO', 0
                            , 'MG', decode( conp.inabile
                                          ,'SI', decode( conp.max_carico_fam
                                                        , null, 0
                                                              , 1
                                                       )
                                               , 0
                                          )
                                   , decode( conp.max_carico_fam
                                           , null, 0
                                                 , decode(pare.carico_fis
                                                          ,'FG',1
                                                          ,'FD',1
                                                          ,'FH',1
                                                          ,'HD',1
                                                               ,0)
                                           )
                                    )),0) -- D_figli_fam
                   , nvl(sum(decode( pare.carico_fis||pare.nucleo_fam
                                   , 'FGMN', 1
                                   , 'FDMN', 1
                                   , 'FHMN', 1
                                   , 'HDMN', 1
                                   , 'AFMN', 1
                                         ,0
                                   )),0) -- D_se_figli_min
                   , nvl(sum(decode(pare.carico_fis,'CN',1,0)),0) -- D_se_coniuge
                   , nvl(sum(decode(pare.carico_fis
                                   ,'CN',decode(pare.nucleo_fam,'SI',1,0)
                                        ,0)),0) -- D_se_coniuge_fam
                   , nvl(sum(decode(conp.inabile,'SI',1,0)),0) -- D_se_inabile
                   , nvl(sum(decode( pare.carico_fis
                                   , 'CN', decode(conp.inabile,'SI',1,0)
                                         , 0)),0) -- D_se_inabile_cn
                   , nvl(sum( decode( pare.carico_fis||pare.nucleo_fam
                                    ,'FGMG', decode(conp.inabile,'SI',1,0)
                                    ,'FDMG', decode(conp.inabile,'SI',1,0)
                                    ,'FHMG', decode(conp.inabile,'SI',1,0)
                                    ,'HDMG', decode(conp.inabile,'SI',1,0)
                                           , 0)),0) -- D_se_inabile_fg
                   , nvl(sum(decode( pare.carico_fis
                                   , 'AL', decode(conp.inabile,'SI',1,0)
                                   , 'AF', decode(conp.inabile,'SI',1,0)
                                         , 0)),0) -- D_se_inabile_al
                into D_coniuge
                   , D_figli
                   , D_figli_dd
                   , D_figli_mn
                   , D_figli_mn_dd
                   , D_figli_hh
                   , D_figli_hh_dd
                   , D_altri
                   , D_nucleo_fam
                   , D_figli_fam
                   , D_se_figli_min
                   , D_se_coniuge
                   , D_se_coniuge_fam
                   , D_se_inabile
                   , D_se_inabile_cn
                   , D_se_inabile_fg
                   , D_se_inabile_al
                from familiari                    fami
                   , parentele                    pare
                   , condizioni_non_professionali conp
               where fami.ni =
                    (select ni
                       from rapporti_individuali
                      where ci = CUR_CI.ci
                    )
                 and curf.data between to_date( to_char(fami.dal,'mmyyyy')
                                              , 'mmyyyy'
                                              )
                                   and nvl(fami.al,to_date('3333333','j'))
/* aggiunta 27/09/2006 per caso di cambio da < 18 a > 18 all'interno del mese */
                 and not exists ( select 'x' from familiari fami1
                                   where fami1.ni = fami.ni
                                     and nvl(fami1.codice_fiscale,' ') = nvl(fami.codice_fiscale,' ')
                                     and fami1.dal < fami.dal
                                     and to_char(fami1.al,'mmyyyy') = to_char(curf.data,'mmyyyy')
                                     and fami1.al is not null                                     
                                     and to_char(fami1.al,'mmyyyy') = to_char(fami.dal,'mmyyyy')
                                     and fami.dal = fami1.al+1
                                 )
/* fine aggiunta 27/09/2006 */
                 and pare.sequenza   = fami.relazione
                 and conp.codice (+) = fami.condizione_pro
              ;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   D_coniuge       := 0;
                   D_figli         := 0;
                   D_figli_dd      := 0;
                   D_figli_mn      := 0;
                   D_figli_mn_dd   := 0;
                   D_figli_hh      := 0;
                   D_figli_hh_dd   := 0;
                   D_altri         := 0;
                   D_nucleo_fam    := 0;
                   D_figli_fam     := 0;
                   D_se_figli_min  := 0;
                   D_se_coniuge    := 0;
                   D_se_coniuge_fam := 0;
                   D_se_inabile    := 0;
                   D_se_inabile_cn := 0;
                   D_se_inabile_fg := 0;
                   D_se_inabile_al := 0;
           END;
           
/* Determino il codice della Condizione Fiscale */
-- dbms_output.put_line('Minori: '||D_figli_mn);
           IF D_coniuge != 0 THEN
              D_cond_fis := 'CC';
           ELSE
              BEGIN  -- Preleva lo Stato Civile di Individuo alla data
                 select stci.presenza_coniuge
                   into D_presenza_coniuge
                   from anagrafici anag
                      , stati_civili stci
                  where anag.ni =
                       (select ni
                          from rapporti_individuali
                         where ci = CUR_CI.ci
                       )
                   and curf.data between anag.dal
                                 and nvl(anag.al,to_date('3333333','j'))
                   and anag.stato_civile = stci.codice (+)
                 ;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      D_presenza_coniuge := null;
                 when TOO_MANY_ROWS then
                      D_presenza_coniuge := null;
-- dbms_output.put_line('ERRORE');
              END;
              IF D_se_coniuge != 0
              OR D_presenza_coniuge in ('SI','NO') THEN
                 D_cond_fis := 'NC';
              ELSE
                 D_cond_fis := 'AC';
              END IF;
              IF D_presenza_coniuge = 'SI' THEN
                 D_se_coniuge := 1;
              END IF;
           END IF;
           
           IF D_coniuge  = 0 AND
              D_figli    = 0 AND
              D_figli_dd = 0 AND
              D_altri    = 0 THEN
              D_cond_fis := 'NC';
           END IF;
           
/* Determino il codice della Condizione Familiare e il numero di componenti del Nucleo */        
           IF D_se_figli_min != 0 THEN
              IF D_se_inabile = 0 THEN
                 IF D_se_coniuge_fam != 0 THEN
                    D_cond_fam := 'CN';
                 ELSE
                    D_cond_fam := 'SC';
                 END IF;
              ELSIF D_se_coniuge_fam != 0 THEN
                 D_cond_fam := 'IN';
              ELSE
                 D_cond_fam := 'SCIN';
              END IF;
           ELSIF D_se_inabile_fg != 0 THEN
              IF D_se_coniuge_fam != 0 THEN
                 D_cond_fam := 'CNFI';
              ELSE
                 D_cond_fam := 'SCFI';
              END IF;
           ELSIF D_se_inabile_al != 0 THEN
              IF D_se_coniuge_fam != 0 THEN
                 D_cond_fam := 'CNAI';
              ELSE
                 D_cond_fam := 'SCAI';
              END IF;
           ELSIF D_se_inabile_cn != 0 THEN
              IF D_se_coniuge_fam != 0 THEN
                 D_cond_fam := 'CNCI';
              ELSE
/* caso impossibile! presenza di coniuge inabile in assenza del coniuge */              
                D_cond_fam := 'SCCI';
                IF D_lancio = 'CCAFA' THEN
                 D_errore := 'P05340';
                 D_precisazione := ' Verificare Anagrafe Familiari ';
                 insert_segnalazioni ( prenotazione
                                     , CUR_CI.ci
                                     , D_errore
                                     , D_precisazione
                                     );
                END IF;
              END IF;
           ELSIF D_se_coniuge_fam != 0 THEN
              D_cond_fam := 'CNSF';
           ELSE
              D_cond_fam := 'SCSF';
           END IF;

           IF D_nucleo_fam = 0 THEN
              D_cond_fam := 'CN';
           ELSE
              D_nucleo_fam := nvl(D_nucleo_fam, 0) + 1;
           END IF;
        END;
        
        BEGIN  -- Deposita dati di Nucleo Familiare
           D_dep_cond_fam   := D_cond_fam;
           D_dep_nucleo_fam := D_nucleo_fam;
           D_dep_figli_fam  := D_figli_fam;
        END;

        BEGIN  -- Aggiornamento Carico Familiare
           FOR CURC IN
              (select cafa.rowid
                    , cafa.cond_fis
                    , cafa.coniuge
                    , cafa.figli
                    , cafa.figli_dd
                    , cafa.figli_mn
                    , cafa.figli_mn_dd
                    , cafa.figli_hh
                    , cafa.figli_hh_dd
                    , cafa.altri
                    , cafa.cond_fam
                    , cafa.nucleo_fam
                    , cafa.figli_fam
                    , mesi.anno
                    , mesi.mese
                 from carichi_familiari cafa
                    , mesi              mesi
                where cafa.giorni  is null
                  and cafa.ci   (+) = CUR_CI.ci
                  and cafa.anno (+) = mesi.anno
                  and cafa.mese (+) = mesi.mese
                  and to_number(to_char(mesi.anno)||
                                lpad(to_char(mesi.mese),2,'0'))
                      >= to_number(to_char(curf.data,'yyyymm'))
                  and to_number(to_char(mesi.anno)||
                                lpad(to_char(mesi.mese),2,'0'))
                      < to_number(to_char(D_data_prec,'yyyymm'))
                  and (   mesi.anno  = D_anno - 1 and
                          mesi.mese  > D_mese     and
                          cafa.ci   is not null
                       or mesi.anno  = D_anno     and
                          mesi.mese <= D_mese
                      )
              ) LOOP
 --dbms_output.put_line('CURC - data: '||curc.anno||' '||curc.mese); 
              BEGIN
               select nvl(inex.AUT_ASS_FAM,'NO')
                    , nvl(inex.AUT_DED_FAM,'SI')
                    , inex.perc_car_fam
                 into D_AUT_ASS_FAM, D_AUT_DED_FAM, D_PERC_CAR_FAM
                 from informazioni_extracontabili inex
                where anno = CURC.anno
                  and ci = CUR_CI.ci;
              EXCEPTION WHEN NO_DATA_FOUND THEN
                 BEGIN
                   select nvl(inex.AUT_ASS_FAM,'NO')
                        , nvl(inex.AUT_DED_FAM,'SI')
                        , inex.perc_car_fam
                     into D_AUT_ASS_FAM, D_AUT_DED_FAM, D_PERC_CAR_FAM
                     from informazioni_extracontabili inex
                    where anno = D_anno
                      and ci = CUR_CI.ci
                    ;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                       D_AUT_ASS_FAM    := 'NO';
                       D_AUT_DED_FAM    := 'SI';
                       D_PERC_CAR_FAM   := null;
                  END;
              END;
-- dbms_output.put_line('perc1: '||D_PERC_CAR_FAM);
              IF nvl(D_PERC_CAR_FAM,0) != 0 and D_cond_fis is not null
                and D_AUT_DED_FAM = 'SI' THEN
                 BEGIN
                    select ''
                      into D_errore
                      from condizioni_fiscali
                     where codice = D_cond_fis||D_PERC_CAR_FAM
                     ;
                 EXCEPTION WHEN NO_DATA_FOUND THEN
                     D_errore := 'P05300'; -- Condizione Fiscale non presente
                 END;
                 IF D_errore is not null THEN
                    D_PERC_CAR_FAM := null;
                    insert_segnalazioni ( prenotazione, CUR_CI.ci, D_errore
                                        , ' Inserita Condizione Base ' ||D_cond_fis||' ( verificare '||D_cond_fis||D_PERC_CAR_FAM||' )'
                                        ) ;
                 END IF;                    
              END IF;

              IF curf.data < D_data_prec THEN
                 D_data_prec := curf.data;
              END IF;
              
              IF nvl(D_AUT_DED_FAM,'SI') = 'NO' THEN
/* Azzero variabili delle deduzioni eventualmente calcolate */
                   D_cond_fis      := null;
                   D_perc_car_fam  := null;
                   D_coniuge       := 0;
                   D_figli         := 0;
                   D_figli_dd      := 0;
                   D_figli_mn      := 0;
                   D_figli_mn_dd   := 0;
                   D_figli_hh      := 0;
                   D_figli_hh_dd   := 0;
                   D_altri         := 0;
                   D_se_coniuge    := 0;
              END IF;
              IF nvl(D_AUT_ASS_FAM,'SI') = 'NO' THEN
/* Azzero variabili degli assegni eventualmente calcolate */
                   D_cond_fam      := null;
                   D_nucleo_fam    := 0;
                   D_figli_fam     := 0;
                   D_se_figli_min  := 0;
                   D_se_coniuge_fam := 0;
                   D_se_inabile    := 0;
                   D_se_inabile_cn := 0;
                   D_se_inabile_fg := 0;
                   D_se_inabile_al := 0;
              END IF;
              IF D_AUT_ASS_FAM = 'SI' THEN
              BEGIN  -- Verifica reddito per diritto Nucleo Familiare
                 D_cond_fam   := D_dep_cond_fam;
                 D_nucleo_fam := D_dep_nucleo_fam;
                 D_figli_fam  := D_dep_figli_fam;
                 VERIFICA_NUCLEO
                    (  prenotazione
                     , CUR_CI.ci
                     , D_anno
                     , curc.anno
                     , curc.mese
                     , D_cond_fam
                     , D_nucleo_fam
                     , D_lancio
                    );
              EXCEPTION
                 WHEN OTHERS THEN  -- FORM_TRIGGER_FAILURE THEN
                      D_cond_fam   := null;
                      D_nucleo_fam := 0;
                      D_figli_fam  := 0;
              END;
              END IF;
              BEGIN  -- Aggiorna Carico Familiare entro data di riferimento
                IF curc.anno                = D_anno AND
                    (   nvl(D_cond_fis||D_PERC_CAR_FAM,' ')  != nvl( curc.cond_fis,' ')
--                    != nvl( curc.cond_fis, nvl(D_cond_fis||D_PERC_CAR_FAM,' '))
                     OR D_coniuge           != nvl(curc.coniuge,0)
                     OR D_figli             != nvl(curc.figli,0)
                     OR D_figli_dd          != nvl(curc.figli_dd,0)
                     OR D_figli_mn          != nvl(curc.figli_mn,0)
                     OR D_figli_mn_dd       != nvl(curc.figli_mn_dd,0)
                     OR ( D_figli_hh != 0
                      and (  ( greatest(D_anno,2006) = 2006
                           and D_figli+D_figli_dd||D_figli_hh != nvl(curc.figli_hh,0)
                             )
                          or ( greatest(D_anno,2006) > 2006
                           and D_figli_hh != nvl(curc.figli_hh,0)
                             )
                          )
                        )
                     OR ( D_figli_hh_dd != 0
                      and (  ( greatest(D_anno,2006) = 2006
                           and D_figli+D_figli_dd||D_figli_hh_dd != nvl(curc.figli_hh_dd,0)
                             )
                          or ( greatest(D_anno,2006) >= 2006
                           and D_figli_hh_dd != nvl(curc.figli_hh_dd,0)
                             )
                          )
                        )
                     OR D_altri             != nvl(curc.altri,0)
                    )
                 OR nvl(D_cond_fam,' ') != nvl( curc.cond_fam,' ')
--                                              , nvl(D_cond_fam,' ')
                 OR D_nucleo_fam        != nvl(curc.nucleo_fam,0)
                 OR D_figli_fam         != nvl(curc.figli_fam,0)
                  THEN
 --dbms_output.put_line('aggiorna 1 - record anno corrente modificati ');
                   AGGIORNA_CAFA ( prenotazione
                                  , CUR_CI.ci, curc.rowid
                                  , curf.data
                                  , D_anno, D_mese
                                  , curc.anno, curc.mese
                                  , D_AUT_ASS_FAM, D_AUT_DED_FAM
                                  , D_cond_fis||D_PERC_CAR_FAM
                                  , D_coniuge
                                  , D_figli
                                  , D_figli_dd
                                  , D_figli_mn
                                  , D_figli_mn_dd
                                  , D_figli_hh
                                  , D_figli_hh_dd
                                  , D_altri
                                  , D_cond_fam
                                  , D_nucleo_fam
                                  , D_figli_fam
                                  , D_lancio, D_pagina, D_riga
                       );
                 END IF;
              END;
           END LOOP; -- CURC

           IF to_number(to_char(curf.data,'yyyy')) = D_anno AND
              to_number(to_char(curf.data,'mm'))   > D_mese
           OR to_number(to_char(curf.data,'yyyy')) > D_anno THEN
           BEGIN  -- Inserisce Carico Familiare oltre data riferimento
              BEGIN
               select nvl(inex.AUT_ASS_FAM,'NO')
                    , nvl(inex.AUT_DED_FAM,'SI')
                    , inex.perc_car_fam
                 into D_AUT_ASS_FAM, D_AUT_DED_FAM, D_PERC_CAR_FAM
                 from informazioni_extracontabili inex
                where anno = to_number(to_char(curf.data,'yyyy'))
                  and ci = CUR_CI.ci;
              EXCEPTION WHEN NO_DATA_FOUND THEN
                 BEGIN
                   select nvl(inex.AUT_ASS_FAM,'NO')
                        , nvl(inex.AUT_DED_FAM,'SI')
                        , inex.perc_car_fam
                     into D_AUT_ASS_FAM, D_AUT_DED_FAM, D_PERC_CAR_FAM
                     from informazioni_extracontabili inex
                    where anno = D_anno
                      and ci = CUR_CI.ci
                    ;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                       D_AUT_ASS_FAM    := 'NO';
                       D_AUT_DED_FAM    := 'SI';
                       D_PERC_CAR_FAM   := null;
                  END;
              END;
-- dbms_output.put_line('perc2: '||D_PERC_CAR_FAM);
            IF D_AUT_ASS_FAM = 'NO' and D_AUT_DED_FAM = 'NO' THEN
-- non proseguo con il caricamento futuro
               null;
            ELSE 
              IF nvl(D_PERC_CAR_FAM,0) != 0 and D_cond_fis is not null
              and D_AUT_DED_FAM = 'SI' THEN
                 BEGIN
                    select ''
                      into D_errore
                      from condizioni_fiscali
                     where codice = D_cond_fis||D_PERC_CAR_FAM
                     ;
                 EXCEPTION WHEN NO_DATA_FOUND THEN
                     D_errore := 'P05300'; -- Condizione Fiscale non presente
                 END;
                 IF D_errore is not null THEN
                    D_PERC_CAR_FAM := null;
                    insert_segnalazioni ( prenotazione, CUR_CI.ci, D_errore
                                        , ' Inserita Condizione Base ' ||D_cond_fis||' ( verificare '||D_cond_fis||D_PERC_CAR_FAM||' )'
                                        ) ;
                 END IF;                    
              END IF;

              IF D_AUT_ASS_FAM = 'SI' THEN           
              BEGIN  -- Verifica reddito per diritto Nucleo Familiare
                 D_cond_fam   := D_dep_cond_fam;
                 D_nucleo_fam := D_dep_nucleo_fam;
                 D_figli_fam  := D_dep_figli_fam;
                 VERIFICA_NUCLEO
                    (  prenotazione
                     , CUR_CI.ci
                     , D_anno
                     , to_number(to_char(curf.data,'yyyy'))
                     , to_number(to_char(curf.data,'mm'))
                     , D_cond_fam
                     , D_nucleo_fam
                     , D_lancio
                    );                 
              EXCEPTION
                 WHEN  OTHERS THEN -- FORM_TRIGGER_FAILURE
                      D_cond_fam   := null;
                      D_nucleo_fam := 0;
                      D_figli_fam  := 0;
              END;
              END IF;

-- dbms_output.put_line('aggiorna 2 - record futuri anno corrente e successivi ');
                 AGGIORNA_CAFA(  prenotazione
                               , CUR_CI.ci, null
                               , curf.data
                               , D_anno, to_number(to_char(curf.data,'mm'))
                              /* mese_attivazione = mese_carico */
                               , to_number(to_char(curf.data,'yyyy'))
                               , to_number(to_char(curf.data,'mm'))
                               , D_AUT_ASS_FAM, D_AUT_DED_FAM                               
                               , D_cond_fis||D_PERC_CAR_FAM
                               , D_coniuge
                               , D_figli
                               , D_figli_dd
                               , D_figli_mn
                               , D_figli_mn_dd
                               , D_figli_hh
                               , D_figli_hh_dd
                               , D_altri
                               , D_cond_fam
                               , D_nucleo_fam
                               , D_figli_fam
                               , D_lancio, D_pagina, D_riga                            
                    );
            END IF; -- controllo flag
            END;          
           END IF; -- controllo anno mese
        END;
     END LOOP; -- CURF
    END LOOP;  -- CUR_CI
EXCEPTION
  WHEN USCITA then
    update a_prenotazioni
       set prossimo_passo = 92
         , errore         = 'P00107'
     where no_prenotazione = prenotazione;
    commit;
 END;
END CALCOLO;

PROCEDURE MAIN (prenotazione in number, passo in number) IS
  D_da_ci          number;
  D_a_ci           number;
  D_gestione       gestioni.codice%type;
  D_rapporto       rapporti_individuali.rapporto%type;
  D_gruppo         rapporti_individuali.gruppo%type;
  D_riga           number := 0;
  D_calcolo_cafa   ente.calcolo_cafa%type := null;
  USCITA           exception;
BEGIN
 BEGIN -- Estrazione Parametri di Selezione
   BEGIN
     select calcolo_cafa
       into D_calcolo_cafa
       from ente;
   EXCEPTION WHEN NO_DATA_FOUND THEN
        D_calcolo_cafa := 'NO';
   END;
   IF D_calcolo_cafa = 'NO' THEN
     raise USCITA;
   END IF;
   BEGIN
     SELECT valore
       INTO D_gestione
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro       = 'P_GESTIONE'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_gestione := '%';
   END;
   BEGIN
   select to_number(substr(valore,1,8))
        , to_number(substr(valore,1,8))
     into D_da_ci, D_a_ci
     from a_parametri
    where no_prenotazione = prenotazione
      and parametro       = 'P_CI'
   ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_da_ci := 0;
       D_a_ci  := 99999999;
   END;
 BEGIN
     SELECT valore
       INTO D_rapporto
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro       = 'P_RAPPORTO'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_rapporto := '%';
   END;
 BEGIN
     SELECT valore
       INTO D_gruppo
       FROM a_parametri
      WHERE no_prenotazione = prenotazione
        AND parametro       = 'P_GRUPPO'
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_gruppo := '%';
   END;
BEGIN
   BEGIN
     calcolo(prenotazione, passo, D_da_ci, D_a_ci,D_gestione, D_rapporto, D_gruppo, 'CCAFA');
   END;
    BEGIN
       FOR CUR_PAGINA in
         ( select pagina
                , to_number(substr(testo,1,8)) ci
                , substr(testo,9,60) nominativo
             from a_appoggio_stampe
            where no_prenotazione = prenotazione
              and no_passo = 0
              and riga = 0
            order by pagina
         ) LOOP
       IF D_riga != 0 THEN
         D_riga := D_riga + 1;
         INSERT INTO a_appoggio_stampe
         ( no_prenotazione, no_passo, pagina, riga, testo )
         VALUES ( prenotazione
                , 1
                , 1
                , D_riga
                , rpad(' ',132,' ')
               ) ;
       END IF;
         D_riga := D_riga + 1;
         INSERT INTO a_appoggio_stampe
         ( no_prenotazione, no_passo, pagina, riga, testo )
         VALUES ( prenotazione
                , 1
                , 1
                , D_riga
                , substr(rpad('Cod.Ind',8,' ')||' '||rpad('Nominativo',60,' '),1,132)
               ) ;
         D_riga := D_riga + 1;
         INSERT INTO a_appoggio_stampe
         ( no_prenotazione, no_passo, pagina, riga, testo )
         VALUES ( prenotazione
                , 1
                , 1
                , D_riga
                , substr(rpad('-',8,'-')||' '||rpad('-',60,'-'),1,132)
                );
         D_riga := D_riga + 1;
         INSERT INTO a_appoggio_stampe
         ( no_prenotazione, no_passo, pagina, riga, testo )
         VALUES ( prenotazione
                , 1
                , 1
                , D_riga
                , substr(rpad(CUR_PAGINA.ci,8,' ')||' '||rpad(CUR_PAGINA.nominativo,60,' '),1,132)
               ) ;
         D_riga := D_riga + 1;
         INSERT INTO a_appoggio_stampe
         ( no_prenotazione, no_passo, pagina, riga, testo )
         VALUES ( prenotazione
                , 1
                , 1
                , D_riga
                , rpad(' ',132,' ')
               ) ;
         D_riga := D_riga + 1;
         INSERT INTO a_appoggio_stampe
         ( no_prenotazione, no_passo, pagina, riga, testo )
         VALUES ( prenotazione
                , 1
                , 1
                , D_riga
                , substr(rpad(' ',9,' ')
                        ||rpad('Anno',4,' ')||' '
                        ||rpad('Mese',4,' ')||' '
                        ||rpad('Cond.',5,' ')||' '
                        ||lpad('Con.',4,' ')||' '
                        ||lpad('Figli',7,' ')||' '
                        ||lpad('Figli DD',7,' ')||' '
                        ||lpad('Fg Min',7,' ')||' '
                        ||lpad('Fg MinDD',7,' ')||' '
                        ||lpad('Fg Han',7,' ')||' '
                        ||lpad('Fg HanDD',7,' ')||' '
                        ||lpad('Altri',5,' ')||' '
                        ||rpad('Cond.Fam.',9,' ')||' '
                        ||lpad('Nucleo Fam.',11,' ')||' '
                        ||lpad('Figli Fam.',10,' ')  
                       ,1,132)
                 );
         D_riga := D_riga + 1;
         INSERT INTO a_appoggio_stampe
         ( no_prenotazione, no_passo, pagina, riga, testo )
         VALUES ( prenotazione
                , 1
                , 1
                , D_riga
                , substr(rpad(' ',9,' ')
                        ||rpad('-',4,'-')||' '
                        ||rpad('-',4,'-')||' '
                        ||rpad('-',5,'-')||' '
                        ||lpad('-',4,'-')||' '
                        ||lpad('-',7,'-')||' '
                        ||lpad('-',7,'-')||' '
                        ||lpad('-',7,'-')||' '
                        ||lpad('-',7,'-')||' '
                        ||lpad('-',7,'-')||' '
                        ||lpad('-',7,'-')||' '
                        ||lpad('-',5,'-')||' '
                        ||rpad('-',9,'-')||' '
                        ||lpad('-',11,'-')||' '
                        ||lpad('-',10,'-') 
                       ,1,132)
                 );
  
         FOR CUR_DATI in
             ( select testo
                 from a_appoggio_stampe
                 where no_prenotazione = prenotazione
                   and no_passo = 0
                   and pagina = CUR_PAGINA.pagina
                   and riga != 0
            order by substr(testo,1,4), to_number(substr(testo,6,2))
             ) LOOP
              D_riga := D_riga + 1;
              INSERT INTO a_appoggio_stampe
              ( no_prenotazione, no_passo, pagina, riga, testo )
              VALUES ( prenotazione
                     , 1
                     , 1
                     , D_riga
                     , substr(rpad(' ',9,' ')||CUR_DATI.testo 
                            ,1,132)
                      );
             END LOOP; -- cur_dati
       END LOOP; -- cur_pagina
  END;
 END;
EXCEPTION
  WHEN USCITA then
    update a_prenotazioni
       set prossimo_passo = 92
         , errore         = 'P05744'
     where no_prenotazione = prenotazione;
    commit;
END;
END;
END;
/
