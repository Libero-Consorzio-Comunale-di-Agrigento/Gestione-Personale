CREATE OR REPLACE PACKAGE PECDPREV IS
/******************************************************************************
 NOME:        PECDPREV 
 DESCRIZIONE: Duplica le voci di ritenuta e contributo definite in DISPR per gli 
              istituti previdenziali:
              CPDEL / CPI / CPS / CPFPC / CPFPCI / CPFPCS / CPSTAT 
              INADEL / ENPAM / TFR
                           
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: Deve essere eseguito con APEEL aperto sull'anno nuovo 
              ( legge l'anno da rire )

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  14/12/2005 MS     Prima Emissione
 1.1  14/12/2005 MS     Mod. condizione per estrazione imponibili
 1.2  22/12/2005 MS     Aggiunto controllo di congruenza
******************************************************************************/
FUNCTION  VERSIONE      RETURN VARCHAR2;
PROCEDURE MAIN	(PRENOTAZIONE IN NUMBER, passo IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECDPREV IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.2 del 22/12/2005';
END VERSIONE;
PROCEDURE main (prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
DECLARE   

D_anno     NUMBER(4);
D_ipn      VARCHAR2(10);
D_sub_ipn  VARCHAR2(2);
D_dal      DATE;
D_al       DATE;
D_errore   VARCHAR2(6);
V_errore   VARCHAR2(1);
errore     EXCEPTION;

BEGIN

  BEGIN
    select anno
         , to_date('0101'||anno,'ddmmyyyy')
         , to_date('0101'||anno,'ddmmyyyy')-1
      into D_anno, D_dal, D_al
      from riferimento_retribuzione;
  EXCEPTION WHEN NO_DATA_FOUND THEN
      D_errore := 'A05721';
      RAISE errore;
  END;

  BEGIN
  select 'X'
    into V_errore 
    from dual
   where exists ( select 'x'
                    from def_istituti_previdenziali
                   where istituto in ( 'CPDEL','CPI', 'CPS'
                          , 'CPFPC', 'CPFPCI', 'CPFPCS'
                          , 'CPSTAT'
                          , 'INADEL','ENPAM' )
                     and ( contr_voce is null or contr_sub is null
                        or rit_voce is null or rit_sub is null 
                         )
                );
  EXCEPTION WHEN NO_DATA_FOUND THEN
    V_errore := '';
  END;
  IF V_errore = 'X' THEN
      D_errore := 'P05688';
      RAISE errore;
  END IF;
-- dbms_output.put_line('parametri');
  BEGIN
  <<DUPLICA>>
    FOR CUR_CONTR IN
     ( select distinct contr_voce voce
                     , contr_sub sub
         from def_istituti_previdenziali
        where istituto in ( 'CPDEL','CPI', 'CPS'
                          , 'CPFPC', 'CPFPCI', 'CPFPCS'
                          , 'CPSTAT'
                          , 'INADEL','ENPAM','TFR')
     ) LOOP
-- dbms_output.put_line('voce - sub '||CUR_CONTR.voce||' '||CUR_CONTR.sub);
       D_ipn := '';
       D_sub_ipn := '';
       BEGIN       /* cerco l'imponibile */
         select COD_VOCE_IPN, SUB_VOCE_IPN
           into D_ipn, D_sub_ipn
           from ritenute_voce 
          where voce = CUR_CONTR.voce
            and sub =  CUR_CONTR.sub
            and al is null
            and ( D_al between dal and nvl(al,to_date('3333333','j'))
             or dal = D_dal )
         ;
       EXCEPTION WHEN NO_DATA_FOUND THEN
           D_ipn := '';
           D_sub_ipn := '';
       END;

       BEGIN     /* Storicizzo il contributo */
         insert into ritenute_voce
         ( voce, sub, dal, al, note, val_voce_ipn, cod_voce_ipn, sub_voce_ipn 
         , moltiplica, divide, per_ipn, lim_inf, lim_sup, per_rit_ac, per_rit_ap 
         , arrotonda, val_voce_rid, cod_voce_rid, sub_voce_rid
         )
         select voce, sub, D_dal, null, note, val_voce_ipn, cod_voce_ipn, sub_voce_ipn 
              , moltiplica, divide, per_ipn, lim_inf, lim_sup, per_rit_ac, per_rit_ap 
              , arrotonda, val_voce_rid, cod_voce_rid, sub_voce_rid
           from ritenute_voce
          where voce = CUR_CONTR.voce
            and sub =  CUR_CONTR.sub
            and al is null
            and D_al between dal and nvl(al,to_date('3333333','j'))
            and not exists ( select 'x'
                               from ritenute_voce
                              where voce = CUR_CONTR.voce
                                and sub =  CUR_CONTR.sub
                                and dal = D_dal
                           )
         ;
         IF SQL%ROWCOUNT != 0 THEN
         update ritenute_voce
            set al = D_al
          where voce = CUR_CONTR.voce
            and sub =  CUR_CONTR.sub
            and al is null
            and D_al between dal and nvl(al,to_date('3333333','j'))
         ;
         END IF;
         commit;
       END;

       BEGIN     /* Storicizzo l'imponibile relativo */
         insert into imponibili_voce
         ( voce, dal , al, moltiplica , divide , per_ipn , arr_ipn , max_ipn , min_ipn 
         , min_gg  , min_gg_pt  , min_gg_1, min_gg_1_pt, min_gg_2, min_gg_2_pt, min_gg_3, min_gg_3_pt
         , cassa_competenza
         , note 
         )
         select voce, D_dal, null, moltiplica , divide , per_ipn , arr_ipn , max_ipn , min_ipn 
              , min_gg  , min_gg_pt  , min_gg_1, min_gg_1_pt, min_gg_2, min_gg_2_pt, min_gg_3, min_gg_3_pt
              , cassa_competenza
              , note 
           from imponibili_voce
          where voce = D_ipn
            and al is null
            and D_al between dal and nvl(al,to_date('3333333','j'))
            and not exists ( select 'x'
                               from imponibili_voce
                              where voce = D_ipn
                                and dal = D_dal
                           )
         ;
         IF SQL%ROWCOUNT != 0 THEN
         update imponibili_voce
            set al = D_al
          where voce = D_ipn
            and al is null
            and D_al between dal and nvl(al,to_date('3333333','j'))
         ;
         END IF;
         commit;
       END;
    END LOOP; -- cur_contr

    FOR CUR_RIT IN
     ( select distinct rit_voce voce
                     , rit_sub sub
         from def_istituti_previdenziali
        where istituto in ( 'CPDEL','CPI', 'CPS'
                          , 'CPFPC', 'CPFPCI', 'CPFPCS'
                          , 'CPSTAT'
                          , 'INADEL','ENPAM','TFR')
     ) LOOP
       D_ipn := '';
       D_sub_ipn := '';
       BEGIN       /* cerco l'imponibile */
         select COD_VOCE_IPN, SUB_VOCE_IPN
           into D_ipn, D_sub_ipn
           from ritenute_voce 
          where voce = CUR_RIT.voce
            and sub =  CUR_RIT.sub
            and al is null
            and ( D_al between dal and nvl(al,to_date('3333333','j'))
             or dal = D_dal )
         ;
       EXCEPTION WHEN NO_DATA_FOUND THEN
           D_ipn := '';
           D_sub_ipn := '';
       END;

       BEGIN     /* Storicizzo il contributo */
         insert into ritenute_voce
         ( voce, sub, dal, al, note, val_voce_ipn, cod_voce_ipn, sub_voce_ipn 
         , moltiplica, divide, per_ipn, lim_inf, lim_sup, per_rit_ac, per_rit_ap 
         , arrotonda, val_voce_rid, cod_voce_rid, sub_voce_rid
         )
         select voce, sub, D_dal, null, note, val_voce_ipn, cod_voce_ipn, sub_voce_ipn 
              , moltiplica, divide, per_ipn, lim_inf, lim_sup, per_rit_ac, per_rit_ap 
              , arrotonda, val_voce_rid, cod_voce_rid, sub_voce_rid
           from ritenute_voce
          where voce = CUR_RIT.voce
            and sub =  CUR_RIT.sub
            and al is null
            and D_al between dal and nvl(al,to_date('3333333','j'))
            and not exists ( select 'x'
                               from ritenute_voce
                              where voce = CUR_RIT.voce
                                and sub =  CUR_RIT.sub
                                and dal = D_dal
                           )
         ;
         IF SQL%ROWCOUNT != 0 THEN
         update ritenute_voce
            set al = D_al
          where voce = CUR_RIT.voce
            and sub =  CUR_RIT.sub
            and al is null
            and D_al between dal and nvl(al,to_date('3333333','j'))
         ;
         END IF;
         commit;
       END;

       BEGIN     /* Storicizzo l'imponibile relativo */
         insert into imponibili_voce
         ( voce, dal , al, moltiplica , divide , per_ipn , arr_ipn , max_ipn , min_ipn 
         , min_gg  , min_gg_pt  , min_gg_1, min_gg_1_pt, min_gg_2, min_gg_2_pt, min_gg_3, min_gg_3_pt
         , cassa_competenza
         , note 
         )
         select voce, D_dal, null, moltiplica , divide , per_ipn , arr_ipn , max_ipn , min_ipn 
              , min_gg  , min_gg_pt  , min_gg_1, min_gg_1_pt, min_gg_2, min_gg_2_pt, min_gg_3, min_gg_3_pt
              , cassa_competenza
              , note 
           from imponibili_voce
          where voce = D_ipn
            and al is null
            and D_al between dal and nvl(al,to_date('3333333','j'))
            and not exists ( select 'x'
                               from imponibili_voce
                              where voce = D_ipn
                                and dal = D_dal
                           )
         ;
         IF SQL%ROWCOUNT != 0 THEN
         update imponibili_voce
            set al = D_al
          where voce = D_ipn
            and al is null
            and D_al between dal and nvl(al,to_date('3333333','j'))
         ;
         END IF;
         commit;
       END;
    END LOOP; -- cur_rit

  END DUPLICA;

EXCEPTION
  WHEN errore THEN
    UPDATE a_prenotazioni 
       SET errore         = d_errore
         , prossimo_passo = 92
     WHERE no_prenotazione = prenotazione
    ;
END;
END;
END PECDPREV;
/
