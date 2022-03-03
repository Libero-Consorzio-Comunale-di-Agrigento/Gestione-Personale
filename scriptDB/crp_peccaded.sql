CREATE OR REPLACE PACKAGE PECCADED IS
/******************************************************************************
 NOME:        PECCADED - CALCOLO ASSESTAMENTO DEDUZIONI
 DESCRIZIONE: Inserisce record *R* su moco per assestare importo delle deduzioni
              e tariffa dell'imposta fiscale (imponibile)
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    08/04/2005   NN   Prima emissione
******************************************************************************/
FUNCTION  VERSIONE RETURN VARCHAR2;
PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCADED IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1 del 08/07/2005';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
BEGIN
DECLARE
D_tot_ipn_ac       PROGRESSIVI_FISCALI.ipn_ac%TYPE;
D_tot_ded_tot      PROGRESSIVI_FISCALI.ded_tot%TYPE;
D_tot_ded_fis      PROGRESSIVI_FISCALI.ded_fis%TYPE;
BEGIN
  FOR CURM IN
     (select ci,anno,mese,mensilita,ded_fis,ded_tot
       from movimenti_fiscali mofi
       where anno = 2005
         and abs(nvl(ded_fis,0)) < abs(nvl(ded_tot,0))
         and exists (select 'x'
                       from periodi_retributivi pere
                      where pere.ci = mofi.ci
                        and pere.periodo =
                            last_day( to_date('01'||lpad(mofi.mese,2,0)||mofi.anno,'ddmmyyyy'))
                        and competenza = 'A'
                        and nvl(conguaglio,0) not in (0,4))
     )
  LOOP
    BEGIN
      select sum(ipn_ac)
           , sum(ded_tot)
           , sum(ded_fis)
        into d_tot_ipn_ac
           , d_tot_ded_tot
           , d_tot_ded_fis
        from progressivi_fiscali prfi
       where ci = curm.ci
         and anno = curm.anno
         and mese = curm.mese
         and mensilita = curm.mensilita
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_tot_ipn_ac  := ' ';
        D_tot_ded_tot := ' ';
        D_tot_ded_fis := ' ';
    END;
    IF nvl(d_tot_ipn_ac,0) > nvl(d_tot_ded_tot,0) THEN
       update movimenti_contabili moco
          set imp =  nvl(imp,0) +
                     nvl(d_tot_ded_tot,0) - nvl(d_tot_ded_fis,0)
        where ci = curm.ci
          and anno = curm.anno
          and mese = curm.mese
          and mensilita = '*R*'
          and voce = (select codice 
                        from voci_economiche
                       where automatismo = 'IRPEF_ORD')
          and sub = '*'
          and exists (select 'x' from movimenti_contabili moco2
                       where moco2.ci = curm.ci
                         and moco2.anno = curm.anno
                         and moco2.mese = curm.mese
                         and moco2.mensilita = '*R*'
                         and moco2.voce = moco.voce
                         and moco2.sub = '*'
                         and moco2.input = 'C'
                         and moco2.riferimento =
                             last_day( to_date('01'||lpad(curm.mese,2,0)||curm.anno,'ddmmyyyy')))
       ;
       insert into movimenti_contabili
                 ( CI, ANNO, MESE, MENSILITA, VOCE, SUB
                 , RIFERIMENTO
                 , INPUT
                 , TAR, QTA, IMP
                 , IPN_P, IPN_EAP)
       select curm.ci, curm.anno, curm.mese, '*R*', codice, '*'
            , last_day( to_date('01'||lpad(curm.mese,2,0)||curm.anno,'ddmmyyyy'))
            , 'C'
            , 0, 0, nvl(d_tot_ded_tot,0) - nvl(d_tot_ded_fis,0)
            , 0, 0
         from voci_economiche voec
        where automatismo = 'IRPEF_ORD'
          and not exists (select 'x' from movimenti_contabili moco2
                           where moco2.ci = curm.ci
                             and moco2.anno = curm.anno
                             and moco2.mese = curm.mese
                             and moco2.mensilita = '*R*'
                             and moco2.voce = voec.codice
                             and moco2.sub = '*'
                             and moco2.input = 'C'
                             and moco2.riferimento =
                                 last_day( to_date('01'||lpad(curm.mese,2,0)||curm.anno,'ddmmyyyy')))
       ;
       update movimenti_contabili moco
          set tar =  nvl(tar,0) +
                     (nvl(d_tot_ded_tot,0) - nvl(d_tot_ded_fis,0)) * -1
        where ci = curm.ci
          and anno = curm.anno
          and mese = curm.mese
          and mensilita = '*R*'
          and voce = (select codice 
                        from voci_economiche
                       where automatismo = 'DED_MEN')
          and sub = '*'
          and exists (select 'x' from movimenti_contabili moco2
                       where moco2.ci = curm.ci
                         and moco2.anno = curm.anno
                         and moco2.mese = curm.mese
                         and moco2.mensilita = '*R*'
                         and moco2.voce = moco.voce
                         and moco2.sub = '*'
                         and moco2.input = 'C'
                         and moco2.riferimento =
                             last_day( to_date('01'||lpad(curm.mese,2,0)||curm.anno,'ddmmyyyy')))
       ;
       insert into movimenti_contabili
                 ( CI, ANNO, MESE, MENSILITA, VOCE, SUB
                 , RIFERIMENTO, INPUT
                 , TAR, QTA, IMP
                 , IPN_P, IPN_EAP)
       select curm.ci, curm.anno, curm.mese, '*R*', codice, '*'
            , last_day( to_date('01'||lpad(curm.mese,2,0)||curm.anno,'ddmmyyyy'))
            , 'C'
            , (nvl(d_tot_ded_tot,0) - nvl(d_tot_ded_fis,0)) * -1, 0, 0
            , 0, 0
         from voci_economiche voec
        where automatismo = 'DED_MEN'
          and not exists (select 'x' from movimenti_contabili moco2
                           where moco2.ci = curm.ci
                             and moco2.anno = curm.anno
                             and moco2.mese = curm.mese
                             and moco2.mensilita = '*R*'
                             and moco2.voce = voec.codice
                             and moco2.sub = '*'
                             and moco2.input = 'C'
                             and moco2.riferimento =
                                 last_day( to_date('01'||lpad(curm.mese,2,0)||curm.anno,'ddmmyyyy')))
       ;
       update movimenti_fiscali
          set ded_fis =  nvl(ded_fis,0) +
                         nvl(d_tot_ded_tot,0) - nvl(d_tot_ded_fis,0)
        where ci = curm.ci
          and anno = curm.anno
          and mese = curm.mese
          and mensilita = '*R*'
          and exists (select 'x' from movimenti_fiscali mofi2
                       where mofi2.ci = curm.ci
                         and mofi2.anno = curm.anno
                         and mofi2.mese = curm.mese
                         and mofi2.mensilita = '*R*')
       ;
       insert into movimenti_fiscali
                 ( CI, ANNO, MESE, MENSILITA
                 , DED_FIS
                 , RIT_ORD, IPN_ORD, ALQ_ORD, IPT_ORD
                 , ALQ_AC ,IPT_AC, DET_FIS, DET_CON ,DET_FIG ,DET_ALT ,DET_SPE ,DET_ULT        
                 , DET_GOD ,CON_FIS ,RIT_AP ,IPN_AP ,ALQ_AP ,IPT_AP ,LOR_LIQ ,LOR_ACC        
                 , RIT_LIQ ,RID_LIQ ,RTP_LIQ ,IPN_LIQ ,ALQ_LIQ ,IPT_LIQ        
                 , GG_ANZ_T, GG_ANZ_I, GG_ANZ_R, LOR_TRA, RIT_TRA ,IPN_TRA)
       select curm.ci, curm.anno, curm.mese, '*R*'
            , nvl(d_tot_ded_tot,0) - nvl(d_tot_ded_fis,0)
            , 0, 0, 0, 0
            , 0, 0, 0, 0, 0, 0, 0, 0
            , 0, 0, 0, 0, 0, 0, 0, 0
            , 0, 0, 0, 0, 0, 0
            , 0, 0, 0, 0, 0, 0
         from dual
        where not exists (select 'x' from movimenti_fiscali mofi2
                           where mofi2.ci = curm.ci
                             and mofi2.anno = curm.anno
                             and mofi2.mese = curm.mese
                             and mofi2.mensilita = '*R*')
       ;
       commit
       ;
    END IF;
  END LOOP;
END;
END;
END PECCADED;
/
