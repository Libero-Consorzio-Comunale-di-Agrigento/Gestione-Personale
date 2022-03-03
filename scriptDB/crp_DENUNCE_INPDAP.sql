CREATE OR REPLACE PACKAGE DENUNCE_INPDAP IS
/******************************************************************************
 NOME:        DENUNCIA_INPDAP
 DESCRIZIONE: Raggruppa tutte le funzioni uguali richiamate dalle denunce inpdap
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    17/11/2003 MS     Prima emissione.
 1    27/08/2004 ML     Revisione procedure GIORNI_UTILI
                        Modificata anche procedure ACCORPA_PERIODI per gestione campo RAP_ORARIO
                        e eliminato test sulla data di cessazione che determinava la mancata unificazioni di periodi
                        identici e contigui se su uno dei due era presente la data di cessazione.
 2    10/09/2004 MV     A7024 - Gestione di tipo_trattamento
 2.1  15/10/2004 ML     Aggiunti i tipi servizio 2,3,8 alla procedure ASSICURAZIONI_ASSENZE
 2.2  28/10/2004 ML	    Gestione del parametro D_previdenza nella procedure PREVIDENZA
 2.3  12/03/2005 MS/ML  Modifica per att. 9644/10165/10142
 2.4  24/02/2006 ML     Aggiunto dal per segnalazione in DETERMINA_QUALIFICA_DMA (A15026).
 2.5  22/03/2007 CB     Aggiunto controllo su rqmi.posizione e pegi.posizione (A20251)
 2.6  20/07/2007 ML     Qualifica_dma in caso di no_data_found per anno||mese elaborazione
                        cerca per dal / al del periodo prima di segnalare (A18361)
 2.7  24/09/2007 ML     Eliminazione procedure DETERMINA_QUALIFICA_DMA (A22835)                        
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE PREVIDENZA
 ( P_ci            in number,
   P_posizione     in varchar2,
   P_profilo       in varchar2,
   P_tipo_trattamento in varchar2,
   D_INI_A         in varchar2,
   D_FIN_A         in varchar2,
   D_PREVIDENZA    in varchar2,
   D_DAL           in date,
   D_AL            in date,
   D_pr_err_0      in out number,
   D_pr_err_1      in out number,
   I_pensione      in out varchar,
   I_previdenza    in out varchar,
   P_prenotazione  in number,
   P_DENUNCIA      in varchar2
 );
PROCEDURE PREVIDENZA_DMA
 ( P_ci            in number,
   P_posizione     in varchar2,
   P_profilo       in varchar2,
   P_tipo_trattamento in varchar2,
   D_INI_A         in varchar2,
   D_FIN_A         in varchar2,
   D_PREVIDENZA    in varchar2,
   D_DAL           in date,
   D_AL            in date,
   D_pr_err_0      in out number,
   D_pr_err_1      in out number,
   I_pensione      in out varchar,
   I_previdenza    in out varchar,
   I_fine_servizio in out number,
   P_prenotazione  in number,
   P_DENUNCIA      in varchar2
 );
PROCEDURE CONTRIBUZIONE
 ( D_ANNO          in varchar2,
   D_fin_a         in varchar2,
   I_COMP_INADEL   in number,
   I_COMP_TFR      in number,
   I_IPN_TFR       in number,
   P_ci            in number,
   I_contribuzione in out number,
   I_enpdep        in out number
 );
PROCEDURE CONTRIBUZIONE_DMA
 ( D_ANNO          in varchar2,
   D_MESE          in varchar2,
   D_DAL           in date,
   D_AL            in date,
   P_ci            in number,
   I_contribuzione in out varchar2,
   I_enpdep        in out varchar2
 );
PROCEDURE UPDATE_IMPIEGO_SERVIZIO
 ( D_ANNO        in varchar2,
   D_FIN_A       in varchar2,
   P_DENUNCIA    in varchar2,
   P_RIFERIMENTO in date
  );
PROCEDURE UPDATE_IMPIEGO
 ( D_ANNO        in varchar2,
   D_FIN_A       in varchar2,
   P_DENUNCIA    in varchar2,
   P_RIFERIMENTO in date
  );
PROCEDURE UPDATE_SERVIZIO
 ( D_ANNO          in varchar2,
   D_pr_err_3      in out number,
   P_prenotazione  in number,
   P_DENUNCIA      in varchar2
  );
PROCEDURE ASSICURAZIONI_ASSENZE
 ( D_ANNO     in varchar2,
   D_FIN_A    in varchar2,
   P_CI       in number
 );
PROCEDURE GIORNI_UTILI
  ( D_ANNO     in varchar2,
    P_CI       in number,
    D_DAL      in date,
    D_AL       in date,
    P_sfasato  in varchar2,
    P_riferimento in date,
    I_gg_utili in out number
);
PROCEDURE GG_TFR
( D_ANNO     in varchar2,
  D_fin_a    in varchar2,
  P_CI       in number
);
PROCEDURE GG_UTILI
( P_DATA     in date,
  D_ANNO     in varchar2,
  P_CI       in number,
  D_GIORNI   in varchar2
);
PROCEDURE DETERMINA_QUALIFICA
( D_ANNO          in varchar2,
  P_CI            in number,
  D_dal           in varchar2,
  D_al            in varchar2,
  D_qualifica     in out varchar2,
  V_gestione      in varchar,
  D_pr_err_5      in out number,
  P_prenotazione  in number,
  P_DENUNCIA      in varchar2
);
PROCEDURE ACCORPA_PERIODI
( D_ANNO        IN varchar2,
  P_CI          IN number,
  P_SFASATO     IN varchar2
);
PROCEDURE AGGIUNGI_SEGNALAZIONI
( D_anno          in varchar2,
  D_ini_a         in varchar2,
  D_fin_a         in varchar2,
  P_CI            in number,
  P_prenotazione  in number,
  D_pr_err_4      in out number
);
PROCEDURE NON_ARCHIVIATI
( D_ANNO          in varchar2,
  P_ci            in number,
  P_prenotazione  in number,
  D_gestione      in varchar,
  D_pr_err_8      in out number
);
END DENUNCE_INPDAP;
/
CREATE OR REPLACE PACKAGE BODY DENUNCE_INPDAP AS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V2.7 del 24/09/2007';
 END VERSIONE;
PROCEDURE PREVIDENZA
 ( P_ci            in number,
   P_posizione     in varchar2,
   P_profilo       in varchar2,
   P_tipo_trattamento in varchar2,
   D_INI_A         in varchar2,
   D_FIN_A         in varchar2,
   D_previdenza    in varchar2,
   D_DAL           in date,
   D_AL            in date,
   D_pr_err_0      in out number,
   D_pr_err_1      in out number,
   I_pensione      in out varchar,
   I_previdenza    in out varchar,
   P_prenotazione  in number,
   P_DENUNCIA      in varchar2
 ) IS
BEGIN
     <<PREVIDENZA_PERE>>
     BEGIN
   -- cerco la previdenza da periodi_retributivi
         select substr(reco.rv_low_value,1,1)
              , trpr.previdenza
           into I_pensione,I_previdenza
           from periodi_retributivi       pere
              , pec_ref_codes             reco
              , trattamenti_previdenziali trpr
          where pere.periodo between decode( P_denuncia
                                            , 'A', to_date(D_ini_a,'ddmmyyyy')
                                            , 'M', D_dal
                                           )
                                 and decode( P_denuncia
                                            , 'A', to_date(D_fin_a,'ddmmyyyy')
                                            , 'M', nvl(D_al,last_day(trunc(sysdate)))
                                           )
            and pere.competenza   in ('C','P','A')
            and pere.ci            = P_ci
            and greatest( pere.dal
                        , to_date('01'||lpad(pere.mese,2,0)
                                      ||pere.anno,'ddmmyyyy')) <= decode ( P_denuncia
                                                                          ,'A', D_al
                                                                          ,'M', nvl(D_al,last_day(trunc(sysdate)))
                                                                         )
            and pere.al                   >= D_dal
            and pere.trattamento          = trpr.codice
            and reco.rv_domain    (+)     = 'DENUNCIA_INPDAP.ASSICURAZIONI'
            and reco.rv_abbreviation (+)  = trpr.previdenza
            and trpr.previdenza        like D_previdenza
          group by reco.rv_low_value,trpr.previdenza;
      EXCEPTION WHEN NO_DATA_FOUND THEN -- Cerca la previdenza su RARE
          <<PREVIDENZA_RARE>>
          BEGIN
		SELECT SUBSTR(reco.rv_low_value,1,1)
		     , trpr.previdenza
              INTO I_pensione,I_previdenza
              FROM RAPPORTI_RETRIBUTIVI       RARE
                 , PEC_REF_CODES             reco
                 , TRATTAMENTI_PREVIDENZIALI trpr
             WHERE rare.ci                   = P_ci
               AND rare.trattamento          = trpr.codice
               AND reco.rv_domain    (+)     = 'DENUNCIA_INPDAP.ASSICURAZIONI'
               AND reco.rv_abbreviation (+)  = trpr.previdenza
            and trpr.previdenza           like D_previdenza;
          EXCEPTION WHEN NO_DATA_FOUND THEN -- Cerca la previdenza su TRCO
              <<PREVIDENZA_TRCO>>
		  BEGIN
                SELECT SUBSTR(reco.rv_low_value,1,1)
                     , trpr.previdenza
                  INTO I_pensione,I_previdenza
                  FROM TRATTAMENTI_CONTABILI     trco
                     , PEC_REF_CODES             reco
                     , TRATTAMENTI_PREVIDENZIALI trpr
                 WHERE posizione                = P_posizione
                   AND profilo_professionale    = P_profilo
                   and tipo_trattamento         = P_tipo_trattamento
 			 AND trco.trattamento         = trpr.codice
                   AND reco.rv_domain    (+)    = 'DENUNCIA_INPDAP.ASSICURAZIONI'
                   AND reco.rv_abbreviation (+) = trpr.previdenza
                   AND trpr.previdenza       like D_previdenza;
              EXCEPTION WHEN NO_DATA_FOUND THEN
-- Segnala periodi senza previdenza
	                  D_pr_err_0 := D_pr_err_0 + 1;
 	                  INSERT INTO a_segnalazioni_errore
                        ( no_prenotazione, passo, progressivo, errore, precisazione )
	                  SELECT P_prenotazione
                             , 1
                             , D_pr_err_0
                             , 'P05191'
                             , 'Cod.Ind.: '||RPAD(TO_CHAR(P_ci),8,' ')||'  '||
                               'Dal '||TO_CHAR(D_dal,'dd/mm/yyyy')||'  '||
                               'Al '||TO_CHAR(decode( P_denuncia
                                                    , 'A', D_al
                                                    , 'M', NVL(D_al,LAST_DAY(TRUNC(SYSDATE)))),'dd/mm/yyyy')
                          FROM dual;
              END PREVIDENZA_TRCO;
		END PREVIDENZA_RARE;
     WHEN TOO_MANY_ROWS THEN
        select substr(max(to_char(pere.al,'j')||reco.rv_low_value),8,1)
             , substr(max(to_char(pere.al,'j')||trpr.previdenza),8)
          into I_pensione,I_previdenza
          from periodi_retributivi pere
             , pec_ref_codes       reco
             , trattamenti_previdenziali trpr
         where pere.periodo between to_date(D_ini_a,'ddmmyyyy')
                                and to_date(D_fin_a,'ddmmyyyy')
           and pere.competenza   in ('C','P','A')
           and pere.ci            = P_ci
           and greatest(pere.dal,to_date('01'||lpad(pere.mese,2,0)||pere.anno,'ddmmyyyy')
                        ) <= decode( P_denuncia
                                    , 'A', D_al
                                    , 'M', NVL(D_al,LAST_DAY(TRUNC(SYSDATE)))
                                   )
           and pere.al                  >= D_dal
           and pere.trattamento          = trpr.codice
           and reco.rv_domain     (+)    = 'DENUNCIA_INPDAP.ASSICURAZIONI'
           and reco.rv_abbreviation (+)  = trpr.previdenza
           and trpr.previdenza        like D_previdenza;
-- Segnala Periodi associabili a piu di una previdenza
        D_pr_err_1 := D_pr_err_1 + 1;
        INSERT into a_segnalazioni_errore
        ( no_prenotazione,passo,progressivo,errore,precisazione)
        select P_prenotazione
             , 1
             , D_pr_err_1
             , 'P05192'
             , 'Cod.Ind.: '||rpad(to_char(P_ci),8,' ')||'  '||
               'Dal '||to_char(D_dal,'dd/mm/yyyy')||'  '||
               'Al '||TO_CHAR(decode( P_denuncia
                                     , 'A', D_al
                                     , 'M', NVL(D_al,LAST_DAY(TRUNC(SYSDATE)))),'dd/mm/yyyy')
          from dual;
  END PREVIDENZA_PERE;
END PREVIDENZA;
PROCEDURE CONTRIBUZIONE
 ( D_ANNO          in varchar2,
   D_fin_a         in varchar2,
   I_COMP_INADEL   in number,
   I_COMP_TFR      in number,
   I_IPN_TFR       in number,
   P_ci            in number,
   I_contribuzione in out number,
   I_enpdep        in out number
 ) IS
BEGIN
I_contribuzione := null;
IF nvl(I_comp_inadel,0) + nvl(I_ipn_tfr,0)    != 0
THEN
  BEGIN
    select '7'
     into I_contribuzione
     from dual
     where exists (select 'x'
                     from estrazione_righe_contabili esrc
                    where estrazione = 'DENUNCIA_INPDAP'
                      and colonna    = 'ENPAS'
                      and to_date(D_fin_a,'ddmmyyyy')
                          between esrc.dal and nvl(esrc.al,to_date('3333333','j'))
                      and exists ( select 'x'
                                     from movimenti_contabili
                                     where ci     = P_ci
                                       and anno   = D_anno
                                       and voce   = esrc.voce
                                       and sub    = esrc.sub
                                 )
                   );
  EXCEPTION
   when no_data_found then
      I_contribuzione := 6;
  END;
END IF;
BEGIN
     select '8'
       into I_enpdep
       from dual
      where exists (select 'x'
                     from estrazione_righe_contabili esrc
                    where estrazione = 'DENUNCIA_INPDAP'
                      and colonna    = 'ENPDEP'
                      and to_date(D_fin_a,'ddmmyyyy')
                          between esrc.dal and nvl(esrc.al,to_date('3333333','j'))
                      and exists ( select 'x'
                                     from movimenti_contabili
                                     where ci     = P_ci
                                       and anno   = D_anno
                                       and voce   = esrc.voce
                                       and sub    = esrc.sub
                                 )
                   );
EXCEPTION
   when no_data_found then
      I_enpdep := null;
END;
END; -- CONTRIBUZIONE
PROCEDURE PREVIDENZA_DMA
 ( P_ci            in number,
   P_posizione     in varchar2,
   P_profilo       in varchar2,
   P_tipo_trattamento in varchar2,
   D_INI_A         in varchar2,
   D_FIN_A         in varchar2,
   D_previdenza    in varchar2,
   D_DAL           in date,
   D_AL            in date,
   D_pr_err_0      in out number,
   D_pr_err_1      in out number,
   I_pensione      in out varchar,
   I_previdenza    in out varchar,
   I_fine_servizio in out number,
   P_prenotazione  in number,
   P_DENUNCIA      in varchar2
 ) IS
BEGIN
     <<PREVIDENZA_PERE>>
     BEGIN
   -- cerco la previdenza da periodi_retributivi
         select substr(reco.rv_low_value,1,1)
              , trpr.previdenza
              , trpr.fine_servizio
           into I_pensione,I_previdenza,I_fine_servizio
           from periodi_retributivi       pere
              , pec_ref_codes             reco
              , trattamenti_previdenziali trpr
          where pere.periodo between decode( P_denuncia
                                            , 'A', to_date(D_ini_a,'ddmmyyyy')
                                            , 'M', D_dal
                                           )
                                 and decode( P_denuncia
                                            , 'A', to_date(D_fin_a,'ddmmyyyy')
                                            , 'M', nvl(D_al,last_day(trunc(sysdate)))
                                           )
            and pere.competenza   in ('C','P','A')
            and pere.ci            = P_ci
            and greatest( pere.dal
                        , to_date('01'||lpad(pere.mese,2,0)
                                      ||pere.anno,'ddmmyyyy')) <= decode ( P_denuncia
                                                                          ,'A', D_al
                                                                          ,'M', nvl(D_al,last_day(trunc(sysdate)))
                                                                         )
            and pere.al                   >= D_dal
            and pere.trattamento          = trpr.codice
            and reco.rv_domain    (+)     = 'DENUNCIA_INPDAP.ASSICURAZIONI'
            and reco.rv_abbreviation (+)  = trpr.previdenza
            and trpr.previdenza        like D_previdenza
          group by reco.rv_low_value,trpr.previdenza,trpr.fine_servizio;
      EXCEPTION WHEN NO_DATA_FOUND THEN -- Cerca la previdenza su RARE
          <<PREVIDENZA_RARE>>
          BEGIN
		SELECT SUBSTR(reco.rv_low_value,1,1)
		     , trpr.previdenza
                 , trpr.fine_servizio
              INTO I_pensione,I_previdenza,I_fine_servizio
              FROM RAPPORTI_RETRIBUTIVI       RARE
                 , PEC_REF_CODES             reco
                 , TRATTAMENTI_PREVIDENZIALI trpr
             WHERE rare.ci                   = P_ci
               AND rare.trattamento          = trpr.codice
               AND reco.rv_domain    (+)     = 'DENUNCIA_INPDAP.ASSICURAZIONI'
               AND reco.rv_abbreviation (+)  = trpr.previdenza
            and trpr.previdenza           like D_previdenza;
          EXCEPTION WHEN NO_DATA_FOUND THEN -- Cerca la previdenza su TRCO
              <<PREVIDENZA_TRCO>>
		  BEGIN
                SELECT SUBSTR(reco.rv_low_value,1,1)
                     , trpr.previdenza
                     , trpr.fine_servizio
                  INTO I_pensione,I_previdenza,I_fine_servizio
                  FROM TRATTAMENTI_CONTABILI     trco
                     , PEC_REF_CODES             reco
                     , TRATTAMENTI_PREVIDENZIALI trpr
                 WHERE posizione                = P_posizione
                   AND profilo_professionale    = P_profilo
                   and tipo_trattamento         = P_tipo_trattamento
 			 AND trco.trattamento         = trpr.codice
                   AND reco.rv_domain    (+)    = 'DENUNCIA_INPDAP.ASSICURAZIONI'
                   AND reco.rv_abbreviation (+) = trpr.previdenza
                   AND trpr.previdenza       like D_previdenza;
              EXCEPTION WHEN NO_DATA_FOUND THEN
-- Segnala periodi senza previdenza
	                  D_pr_err_0 := D_pr_err_0 + 1;
 	                  INSERT INTO a_segnalazioni_errore
                        ( no_prenotazione, passo, progressivo, errore, precisazione )
	                  SELECT P_prenotazione
                             , 1
                             , D_pr_err_0
                             , 'P05191'
                             , 'Cod.Ind.: '||RPAD(TO_CHAR(P_ci),8,' ')||'  '||
                               'Dal '||TO_CHAR(D_dal,'dd/mm/yyyy')||'  '||
                               'Al '||TO_CHAR(decode( P_denuncia
                                                    , 'A', D_al
                                                    , 'M', NVL(D_al,LAST_DAY(TRUNC(SYSDATE)))),'dd/mm/yyyy')
                          FROM dual;
              END PREVIDENZA_TRCO;
		END PREVIDENZA_RARE;
     WHEN TOO_MANY_ROWS THEN
        select substr(max(to_char(pere.al,'j')||reco.rv_low_value),8,1)
             , substr(max(to_char(pere.al,'j')||trpr.previdenza),8)
          into I_pensione,I_previdenza
          from periodi_retributivi pere
             , pec_ref_codes       reco
             , trattamenti_previdenziali trpr
         where pere.periodo between to_date(D_ini_a,'ddmmyyyy')
                                and to_date(D_fin_a,'ddmmyyyy')
           and pere.competenza   in ('C','P','A')
           and pere.ci            = P_ci
           and greatest(pere.dal,to_date('01'||lpad(pere.mese,2,0)||pere.anno,'ddmmyyyy')
                        ) <= decode( P_denuncia
                                    , 'A', D_al
                                    , 'M', NVL(D_al,LAST_DAY(TRUNC(SYSDATE)))
                                   )
           and pere.al                  >= D_dal
           and pere.trattamento          = trpr.codice
           and reco.rv_domain     (+)    = 'DENUNCIA_INPDAP.ASSICURAZIONI'
           and reco.rv_abbreviation (+)  = trpr.previdenza
           and trpr.previdenza        like D_previdenza;
-- Segnala Periodi associabili a piu di una previdenza
        D_pr_err_1 := D_pr_err_1 + 1;
        INSERT into a_segnalazioni_errore
        ( no_prenotazione,passo,progressivo,errore,precisazione)
        select P_prenotazione
             , 1
             , D_pr_err_1
             , 'P05192'
             , 'Cod.Ind.: '||rpad(to_char(P_ci),8,' ')||'  '||
               'Dal '||to_char(D_dal,'dd/mm/yyyy')||'  '||
               'Al '||TO_CHAR(decode( P_denuncia
                                     , 'A', D_al
                                     , 'M', NVL(D_al,LAST_DAY(TRUNC(SYSDATE)))),'dd/mm/yyyy')
          from dual;
  END PREVIDENZA_PERE;
END PREVIDENZA_DMA;
PROCEDURE CONTRIBUZIONE_DMA
 ( D_ANNO          in varchar2,
   D_MESE		 in varchar2,
   D_DAL           in date,
   D_AL            in date,
   P_ci            in number,
   I_contribuzione in out varchar2,
   I_enpdep        in out varchar2
 ) IS
begin
DECLARE
ctr_comp	NUMBER := null;
BEGIN
I_contribuzione := null;
  BEGIN
    SELECT SUM(nvl(vaca.valore,0))
           INTO ctr_comp
           FROM valori_contabili_annuali vaca
          WHERE vaca.anno              = D_anno
            AND vaca.mese              = D_mese
            AND vaca.estrazione        = 'DENUNCIA_DMA'
            AND vaca.colonna          IN ('IPN_TFS','IPN_TFR','TEORICO_TFR','COMP_TFR')
            AND vaca.ci                = P_ci
            AND vaca.moco_mensilita    != '*AP'
            AND to_char(vaca.riferimento,'yyyymm') BETWEEN to_char(D_dal,'yyyymm')
                                     AND to_char(D_al,'yyyymm');
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
              ctr_comp := TO_NUMBER(NULL);
       END;
IF nvl(ctr_comp,0) != 0
THEN
  BEGIN
    select '7'
     into I_contribuzione
     from dual
     where exists (select 'x'
                     from estrazione_righe_contabili esrc
                    where estrazione = 'DENUNCIA_DMA'
                      and colonna    = 'ENPAS'
                      and D_al between esrc.dal and nvl(esrc.al,to_date('3333333','j'))
                      and exists ( select 'x'
                                     from movimenti_contabili
                                     where ci     = P_ci
                                       and anno   = D_anno
                                       and mese   = D_mese
                                       and voce   = esrc.voce
                                       and sub    = esrc.sub
                                 )
                   );
  EXCEPTION
   when no_data_found then
      I_contribuzione := '6';
  END;
END IF;
BEGIN
     select '8'
       into I_enpdep
       from dual
      where exists (select 'x'
                     from estrazione_righe_contabili esrc
                    where estrazione = 'DENUNCIA_DMA'
                      and colonna    = 'ENPDEP'
                      and D_al between esrc.dal and nvl(esrc.al,to_date('3333333','j'))
                      and exists ( select 'x'
                                     from movimenti_contabili
                                     where ci     = P_ci
                                       and anno   = D_anno
                                       and mese   = D_mese
                                       and voce   = esrc.voce
                                       and sub    = esrc.sub
                                 )
                   );
EXCEPTION
   when no_data_found then
      I_enpdep := null;
END;
END;
END; -- CONTRIBUZIONE DMA
PROCEDURE UPDATE_IMPIEGO_SERVIZIO
 ( D_ANNO        in varchar2,
   D_FIN_A       in varchar2,
   P_DENUNCIA    in varchar2,
   P_RIFERIMENTO in date
 ) IS
   BEGIN
     UPDATE DENUNCIA_INPDAP dedp
        SET (tipo_impiego,tipo_servizio,perc_l300) =
     (SELECT nvl(MAX(DECODE( posi.contratto_formazione
                       , 'NO', DECODE ( posi.stagionale
                                      , 'GG', '2', DECODE( posi.part_time
                                                         , 'SI', '8'
                                                               , DECODE( NVL(psep.ore,cost.ore_lavoro)
                                                                       , cost.ore_lavoro, '1'
                                                                                        , '9')
                                                          )
                                      )
                             , posi.tipo_formazione) ), dedp.tipo_impiego)                  impiego
           , nvl(MAX(DECODE( psep.assenza
		            , NULL, DECODE( posi.part_time
                                       , 'SI', DECODE( LEAST(D_anno,2000)
                                                     , 2000, '5'
                                                           , '12'
                                                      )
                                             , decode( NVL(psep.ore,cost.ore_lavoro)
			                                   , cost.ore_lavoro, DECODE( LEAST(D_anno,2000)
			                                                             ,2000, '4', '11')
			                                                    , DECODE( LEAST(D_anno,2000)
			                                                             ,2000, '5', '12')
                                                     )
                                        )
			             , decode(aste.cat_fiscale,'32','30',aste.cat_fiscale )) ) , dedp.tipo_servizio)
                                        servizio
          , nvl(MAX(DECODE( psep.assenza
		            , NULL, null
                              , decode(aste.cat_fiscale,'32',aste.per_ret)
                          )), dedp.perc_l300) perc_l300
      FROM POSIZIONI                   posi
         , ASTENSIONI                  aste
         , QUALIFICHE_GIURIDICHE       qugi
         , CONTRATTI_STORICI           cost
         , periodi_servizio_previdenza psep
     WHERE psep.ci             = dedp.ci
       AND psep.gestione       = dedp.gestione
       AND nvl(dedp.al,to_date(D_fin_a,'ddmmyyyy')) BETWEEN psep.dal
                             AND NVL(psep.al,TO_DATE('3333333','j'))
       AND aste.codice    (+)  = psep.assenza
       AND aste.servizio  (+) != 0
       AND posi.codice    (+)  = psep.posizione
       AND qugi.numero         = psep.qualifica
       AND NVL(psep.al,TO_DATE(D_fin_a,'ddmmyyyy')) BETWEEN qugi.dal
                                    AND NVL(qugi.al,TO_DATE('3333333','j'))
       AND cost.contratto      = qugi.contratto
       AND NVL(psep.al,TO_DATE(D_fin_a,'ddmmyyyy')) BETWEEN cost.dal
                                    AND NVL(cost.al,TO_DATE('3333333','j'))
       AND psep.dal <= NVL(psep.al,TO_DATE('3333333','j'))
       AND psep.segmento      IN
          (SELECT 'i' FROM dual
            UNION
           SELECT 'a' FROM dual
            UNION
           SELECT 'c' FROM dual
            UNION
           SELECT 'f' FROM dual
            UNION
           SELECT 'u' FROM dual
            WHERE NOT EXISTS
                 (SELECT 'x'
                    FROM periodi_servizio_previdenza
                   WHERE ci      = psep.ci
                     AND segmento = 'a'
                     AND dal     <= psep.dal
                     AND NVL(al,TO_DATE('3333333','j')) >= psep.dal)
          )
   )
WHERE anno      = D_anno
  AND rilevanza = 'S'
  AND (tipo_servizio IS NULL OR
      tipo_impiego IS NULL)
  and ( P_denuncia = 'M' and data_agg = P_riferimento
     or P_denuncia = 'A'
     or P_denuncia = 'E');
END; -- UPDATE_IMPIEGO_SERVIZIO
 PROCEDURE UPDATE_IMPIEGO
  ( D_ANNO        in varchar2,
    D_FIN_A       in varchar2,
    P_DENUNCIA    in varchar2,
    P_RIFERIMENTO in date
   ) IS
 BEGIN
   UPDATE DENUNCIA_INPDAP dedp
      SET tipo_impiego = (SELECT MAX(DECODE( posi.part_time
                                            , 'SI', '8'
                                                  , DECODE( NVL(psep.ore,cost.ore_lavoro)
                                                          , cost.ore_lavoro, '1'
                                                                           , '9')
                                           )
                          )                  impiego
      FROM POSIZIONI                   posi
         , ASTENSIONI                  aste
         , QUALIFICHE_GIURIDICHE       qugi
         , CONTRATTI_STORICI           cost
         , periodi_servizio_previdenza psep
     WHERE psep.ci             = dedp.ci
       AND psep.gestione       = dedp.gestione
	   AND psep.dal            =
	      (SELECT MIN(dal)
		     FROM periodi_servizio_previdenza
			WHERE ci = dedp.ci
			  AND dal >=
			     (SELECT MAX(dal)
				    FROM periodi_giuridici
				   WHERE ci = dedp.ci
				     AND rilevanza = 'P'
					 AND NVL(dedp.al,TO_DATE(D_fin_a,'ddmmyyyy')) >= dal
					 AND dedp.dal <= NVL(al,TO_DATE('3333333','j'))
				  ))
       AND aste.codice    (+)  = psep.assenza
       AND aste.servizio  (+) != 0
       AND posi.codice    (+)  = psep.posizione
       AND qugi.numero         = psep.qualifica
       AND NVL(psep.al,TO_DATE(D_fin_a,'ddmmyyyy')) BETWEEN qugi.dal
                                    AND NVL(qugi.al,TO_DATE('3333333','j'))
       AND cost.contratto      = qugi.contratto
       AND NVL(psep.al,TO_DATE(D_fin_a,'ddmmyyyy')) BETWEEN cost.dal
                                    AND NVL(cost.al,TO_DATE('3333333','j'))
       AND psep.dal <= NVL(psep.al,TO_DATE('3333333','j'))
       AND psep.segmento      IN
          (SELECT 'i' FROM dual
            UNION
           SELECT 'a' FROM dual
            UNION
           SELECT 'c' FROM dual
            UNION
           SELECT 'f' FROM dual
            UNION
           SELECT 'u' FROM dual
            WHERE NOT EXISTS
                 (SELECT 'x'
                    FROM periodi_servizio_previdenza
                   WHERE ci      = psep.ci
                     AND segmento = 'a'
                     AND dal     <= psep.dal
                     AND NVL(al,TO_DATE('3333333','j')) >= psep.dal)
                  )
          )
   WHERE anno      = D_anno
     AND rilevanza = 'S'
     AND tipo_impiego = '8'
     AND (P_denuncia = 'M' and data_agg = P_riferimento
       or P_denuncia = 'A'
       or P_denuncia = 'E')
  ;
 END; -- UPDATE_IMPIEGO
PROCEDURE UPDATE_SERVIZIO
  ( D_ANNO     in varchar2,
    D_pr_err_3 in out number,
    P_prenotazione  in number,
    P_DENUNCIA in varchar2
   ) IS
 BEGIN
  FOR CUR_ERRORE IN
  ( select distinct ci, dal, al
      from denuncia_inpdap
    where anno  = D_anno
      and tipo_impiego  = '8'
      and tipo_servizio = '4'
   ) LOOP
     update denuncia_inpdap
        set tipo_servizio = '5'
      where anno  = D_anno
        and ci    = CUR_ERRORE.ci
        and dal   = CUR_ERRORE.dal
        and nvl(al,to_date('3333333','j'))
                  = nvl(CUR_ERRORE.al,to_date('3333333','j'))
        and tipo_impiego  = '8'
        and tipo_servizio = '4'
      ;
     D_pr_err_3 := D_pr_err_3 + 1;
       insert into a_segnalazioni_errore
       (no_prenotazione,passo,progressivo,errore,precisazione)
       select P_prenotazione
            , 1
            , D_pr_err_3
            , 'P05194'
            , 'Cod.Ind.: '||rpad(to_char(CUR_ERRORE.ci),8,' ')
              ||' '||'Dal '||to_char(CUR_ERRORE.dal,'dd/mm/yyyy')
              ||' '||'Al '||to_char(CUR_ERRORE.al,'dd/mm/yyyy')
        from dual;
  END LOOP;
 END; -- UPDATE_SERVIZIO
 PROCEDURE ASSICURAZIONI_ASSENZE
  ( D_ANNO     in varchar2,
    D_FIN_A    in varchar2,
    P_CI       in number
  ) IS
 BEGIN -- 1
 DECLARE
  V_periodo           VARCHAR2(1);
  I_comp_inadel       NUMBER := 0;
  I_comp_tfr          NUMBER := 0;
  I_ipn_tfr           NUMBER := 0;
 BEGIN -- 2
   FOR CUR_ASSENZE IN
   ( select ci, dal, al, comp_inadel, comp_tfr, ipn_tfr,tipo_servizio
       from denuncia_inpdap dedp
      where dedp.anno = D_anno
        and ci = P_ci
        and rilevanza = 'S'
        and tipo_servizio in ('2','3','8','10','14')
        and ( nvl(comp_inadel,0) != 0
           or nvl(comp_tfr,0) != 0 or nvl(ipn_tfr,0) != 0
            )
    ) LOOP
    BEGIN -- 3
    V_periodo     := null;
    I_comp_inadel := nvl(CUR_ASSENZE.comp_inadel,0);
    I_comp_tfr    := nvl(CUR_ASSENZE.comp_tfr,0);
    I_ipn_tfr     := nvl(CUR_ASSENZE.ipn_tfr,0);
     BEGIN
     select 'X'
       into V_periodo
       from dual
      where exists ( select 'x'
                       from denuncia_inpdap
                      where ci = P_ci
                        and dal < CUR_ASSENZE.dal
                        and anno = D_anno
                        and rilevanza = 'S'
                        and tipo_impiego not in ('2','3','8','10','14')
                   );
      EXCEPTION WHEN NO_DATA_FOUND THEN
      V_periodo := null;
      END;
     IF V_periodo = 'X' THEN
        BEGIN -- 4
         update denuncia_inpdap dedp
            set comp_inadel   = null
              , comp_tfr      = null
              , ipn_tfr       = null
              , assicurazioni = nvl(replace(assicurazioni,'6',''),'X')
          where anno = D_anno
            and ci   = P_ci
            and dal  = CUR_ASSENZE.dal
         ;
         update denuncia_inpdap dedp
            set comp_inadel = nvl(comp_inadel,0) + nvl(I_comp_inadel,0)
              , comp_tfr    = nvl(comp_tfr,0) + nvl(I_comp_tfr,0)
              , ipn_tfr     = nvl(ipn_tfr,0) + nvl(I_ipn_tfr,0)
          where anno =  D_anno
            and ci   =  P_ci
            and rilevanza = 'S'
            and dal  = (select max(dal) from denuncia_inpdap
                         where ci   = dedp.ci
                           and dal  < CUR_ASSENZE.dal
                           and anno      = dedp.anno
                           and rilevanza = dedp.rilevanza
                           and tipo_impiego not in ('2','3','8','10','14')
                       )
          ;
        END; -- 4
      ELSE
        BEGIN -- 5
         BEGIN
         select 'X'
           into V_periodo
           from dual
          where exists ( select 'x'
                           from denuncia_inpdap
                          where ci   = P_ci
                            and dal  > CUR_ASSENZE.dal
                            and anno = D_anno
                            and rilevanza = 'S'
                            and tipo_impiego not in ('2','3','8','10','14')
                        );
         EXCEPTION WHEN NO_DATA_FOUND THEN
         V_periodo := null;
         END;
         IF V_periodo = 'X' THEN
          BEGIN -- 6
           update denuncia_inpdap dedp
              set comp_inadel   = null
                , comp_tfr      = null
                , ipn_tfr       = null
                , assicurazioni = nvl(replace(assicurazioni,'6',''),'X')
            where anno = D_anno
              and ci   =  P_ci
              and dal  = CUR_ASSENZE.dal
           ;
           update denuncia_inpdap dedp
              set comp_inadel = nvl(comp_inadel,0) + nvl(I_comp_inadel,0)
                , comp_tfr    = nvl(comp_tfr,0) + nvl(I_comp_tfr,0)
                , ipn_tfr     = nvl(ipn_tfr,0) + nvl(I_ipn_tfr,0)
            where anno = D_anno
              and ci   =  P_ci
              and rilevanza = 'S'
              and dal  = (select min(dal) from denuncia_inpdap
                           where ci   = dedp.ci
                             and dal > CUR_ASSENZE.dal
                             and anno = dedp.anno
                             and rilevanza = dedp.rilevanza
                            and tipo_impiego not in ('2','3','8','10','14')
                         )
             ;
         END; -- 6
       END IF; -- controllo su periodo successivo
      END; -- 5
    END IF; -- controllo su periodi precedente
    END; -- 3
   END LOOP; -- cur_assenze
  END; -- 2
  END ASSICURAZIONI_ASSENZE;
 PROCEDURE GIORNI_UTILI
  ( D_ANNO     in varchar2,
    P_CI       in number,
    D_DAL      in date,
    D_AL       in date,
    P_sfasato  in varchar2,
    P_riferimento in date,
    I_gg_utili in out number
  ) IS
 BEGIN
   DECLARE
     Dep_mese           number;
     Dep_gg_mese        number;
     Dep_gg_eff         number;
     Dep_rap_orario     number;
 BEGIN
   I_gg_utili      := 0;
   Dep_mese        := to_number(null);
   Dep_gg_mese     := 0;
   Dep_gg_eff      := 0;
   Dep_rap_orario  := 1;
   FOR CUR_GG in
      (select dal
            , decode( dal
                    , ini_mese, decode( nvl(al,decode(P_sfasato,'X',add_months(P_riferimento,-1),P_riferimento))
                                      , fin_mese, 30
                                                , nvl(al,decode(P_sfasato,'X',add_months(P_riferimento,-1),P_riferimento))
                                                  -dal + 1
                                      )
                              , decode( nvl(al,decode(P_sfasato,'X',add_months(P_riferimento,-1),P_riferimento))
                                      , fin_mese,30-to_char(dal,'dd')+1
                                                , nvl(al,decode(P_sfasato,'X',add_months(P_riferimento,-1),P_riferimento))
                                                 -dal + 1
                                      )
                     ) gg_mese
            , nvl(al,decode(P_sfasato,'X',add_months(P_riferimento,-1),P_riferimento))- dal + 1 gg_eff
            , mese, rap_orario
         from vista_dedp_mesi
        where anno = D_anno
          and ci   = P_ci
          and dal  between D_dal and nvl(D_al,to_date('3333333','j'))
        union
       select to_date('3333333','j'), 0, 0, 99, 0
         from dual
        order by 1
      ) LOOP
       IF CUR_GG.mese != 99
           THEN Dep_rap_orario := CUR_GG.rap_orario;
                Dep_gg_eff     := nvl(Dep_gg_eff,0) + CUR_GG.gg_eff;
                IF nvl(Dep_mese,CUR_GG.mese) = CUR_GG.mese
                   THEN Dep_gg_mese := nvl(Dep_gg_mese,0) + CUR_GG.gg_mese;
                        Dep_mese    := CUR_GG.mese;
                   ELSE I_gg_utili  := nvl(I_gg_utili,0) + least(30,Dep_gg_mese) ;
                        Dep_gg_mese := CUR_gg.gg_mese;
                        Dep_mese    := CUR_GG.mese;
                END IF;
           ELSE I_gg_utili  := nvl(I_gg_utili,0) + least(30,Dep_gg_mese) ;
                IF Dep_rap_orario is not null
                   THEN I_gg_utili := greatest( 1
                                              ,ceil(round( I_gg_utili * ( nvl(Dep_rap_orario,1) / nvl(Dep_gg_eff,1) )
                                                         ,3)));
                END IF;
        END IF;
        END LOOP;
     END;
     END GIORNI_UTILI;
     PROCEDURE GG_TFR
     ( D_ANNO     in varchar2,
       D_fin_a    in varchar2,
       P_CI       in number ) IS
     BEGIN
      update denuncia_inpdap dedp
         set gg_tfr = trunc(months_between( nvl(to_date('01'||to_char(
                      least(to_date(D_fin_a,'ddmmyyyy'),nvl(dedp.al,to_date(D_fin_a,'ddmmyyyy')))                                                    ,'mmyyyy')
                                                                                   ,'ddmmyyyy')
                           ,to_date(D_fin_a,'ddmmyyyy')),last_day(dedp.dal)))*30
                    + decode(sign(to_char(
                    least(to_date(D_fin_a,'ddmmyyyy'),nvl(dedp.al,to_date(D_fin_a,'ddmmyyyy'))),'dd')
                    - decode(to_char(dedp.dal,'mm'),to_char(
                    least(to_date(D_fin_a,'ddmmyyyy'),nvl(dedp.al,to_date(D_fin_a,'ddmmyyyy'))),'mm')
                                  ,to_char(dedp.dal,'dd'),0 )- 15),-1,0,30)
                    + decode( to_char(dedp.dal,'mm'),to_char(
                    least(to_date(D_fin_a,'ddmmyyyy'),nvl(dedp.al,to_date(D_fin_a,'ddmmyyyy'))),'mm'),0
                    , decode(sign(to_char(least(least(to_date(D_fin_a,'ddmmyyyy'),nvl(dedp.al,to_date(D_fin_a,'ddmmyyyy')))
                                   ,last_day(dedp.dal)),'dd') - to_char(dedp.dal,'dd') + 1 -15
                    + decode(to_char(last_day(dedp.dal),'ddmm'),'2802',2,'2902',1,0)),-1,0,30))
       where rilevanza        = 'S'
	   and dedp.ci          = P_ci
         and anno             = D_anno
         and nvl(ipn_tfr,0) != 0
         and not exists
         (select 'x' from periodi_giuridici
           where rilevanza = 'A'
             and ci = P_ci
             and nvl(al,to_date('3333333','j')) >= dedp.dal
             and dal                           <= nvl(dedp.al,to_date(D_fin_a,'ddmmyyyy'))
             and assenza in
                (select codice
                   from astensioni
                  where servizio = 0))
      ;
     END GG_TFR;
     PROCEDURE GG_UTILI
    ( P_DATA     in date,
      D_ANNO     in varchar2,
      P_CI       in number,
      D_GIORNI   in varchar2
     ) IS
     BEGIN
      update denuncia_inpdap dedp
          set gg_utili  =
       (select decode( nvl(D_giorni,' ')
                     , 'X', decode( nvl(cost.gg_assenza,'C')
                             , 'P', least( last_day(P_data)
                                         , nvl(dedp.al,last_day(P_data)) )
                                    - dedp.dal + 1
                             , 'E', least( last_day(P_data)
                                         , nvl(dedp.al,last_day(P_data)) )
                                    - dedp.dal + 1
                                  , trunc(months_between
                                   (nvl(to_date('01'||to_char(
                                    least( last_day(P_data)
                                         , nvl(dedp.al,last_day(P_data)) )
                                                              ,'mmyyyy')
                                           ,'ddmmyyyy'),last_day(P_data))
                                   ,last_day(dedp.dal)
                                   )
                                     )*30 +
                             30 - to_char(dedp.dal,'dd') + 1 +
                             least(30,to_char(least( last_day(P_data)
                                         , nvl(dedp.al,last_day(P_data)) )
                                             ,'dd')) -
                             decode( to_char(dedp.dal,'mmyyyy')
                                   , to_char(least( last_day(P_data)
                                         , nvl(dedp.al,last_day(P_data)) )
                                            ,'mmyyyy'), 30, 0)+
                               decode(to_char(least( last_day(P_data)
                                     , nvl(dedp.al,last_day(P_data)) )
                                         ,'ddmm'),'2802',2,'2902',1,0))
                       , trunc(months_between
                               (nvl(to_date('01'||to_char(least( last_day(P_data)
                                     , nvl(dedp.al,last_day(P_data)) )
                                                          ,'mmyyyy')
                                       ,'ddmmyyyy'),last_day(P_data))
                               ,last_day(dedp.dal)
                               )
                              )*30 +
                         30 - to_char(dedp.dal,'dd') + 1 +
                         least(30,to_char(least( last_day(P_data)
                                     , nvl(dedp.al,last_day(P_data)) )
                                               ,'dd')) -
                         decode( to_char(dedp.dal,'mmyyyy')
                               , to_char(least( last_day(P_data)
                                     , nvl(dedp.al,last_day(P_data)) )
                                        ,'mmyyyy'), 30, 0) +
                           decode(to_char(least( last_day(P_data)
                                     , nvl(dedp.al,last_day(P_data)) )
                                         ,'ddmm'),'2802',2,'2902',1,0))
          from periodi_giuridici pegi
             , contratti_storici cost
         where pegi.rilevanza = 'S'
           and pegi.ci        = dedp.ci
           and dedp.dal  between pegi.dal and nvl(pegi.al,to_date('3333333','j'))
           and cost.contratto     =
              (select contratto from qualifiche_giuridiche
                where numero = pegi.qualifica
                  and pegi.dal between nvl(dal,to_date('2222222','j'))
                                   and nvl(al,to_date('3333333','j')))
           and pegi.dal between nvl(cost.dal,to_date('2222222','j'))
                            and nvl(cost.al,to_date('3333333','j'))
            )
        where rilevanza = 'S'
          and dedp.ci = P_ci
          and anno    = D_anno
          and not exists
             (select 'x' from periodi_giuridici
               where rilevanza = 'A'
                 and ci = P_ci
                 and nvl(al,to_date('3333333','j')) >= dedp.dal
                 and dal <= nvl(dedp.al,last_day(P_data))
                 and assenza in
                    (select codice
                       from astensioni
                      where servizio = 0));
-- ATTENZIONE: la "ceil(round(" NON e un errore, si e visto che in sql la ceil dal sola usa una tale quantita di decimali
--             che in alcuni casi puo determinare un ulteriore arrotondamento di una unita (es: 91/36*36 = 92)
--             quindi la round e utilizzata solo per limintare i decimali da considerare.
     update denuncia_inpdap dedp
       set gg_utili  =
          (select ceil(round(dedp.gg_utili / cost.ore_lavoro
                                 * nvl(pegi.ore,cost.ore_lavoro),3))
             from periodi_giuridici pegi
                , contratti_storici cost
            where pegi.rilevanza = 'S'
              and pegi.ci        = P_ci
           and dedp.dal  between pegi.dal and nvl(pegi.al,to_date('3333333','j'))
           and cost.contratto     =
              (select contratto from qualifiche_giuridiche
                where numero = pegi.qualifica
                  and pegi.dal between nvl(dal,to_date('2222222','j'))
                                   and nvl(al,to_date('3333333','j')))
           and pegi.dal between nvl(cost.dal,to_date('2222222','j'))
                            and nvl(cost.al,to_date('3333333','j')))
     where anno          = D_anno
       and dedp.ci       = P_ci
       and rilevanza     = 'S'
       and tipo_servizio = '5';
     END GG_UTILI;
PROCEDURE DETERMINA_QUALIFICA
( D_ANNO          in varchar2,
  P_CI            in number,
  D_dal           in varchar2,
  D_al            in varchar2,
  D_qualifica     in out varchar2,
  V_gestione      in varchar,
  D_pr_err_5      in out number,
  P_prenotazione  in number,
  P_DENUNCIA      in varchar2
) IS
BEGIN
   FOR CUR_QUALIFICA IN
    (select  nvl(dal,to_date(D_dal,'ddmmyyyy')) dal
          ,  nvl(al,to_date(D_al,'ddmmyyyy'))  al
     from  denuncia_inpdap
     where anno   = D_anno
       and ci     = P_ci
       and gestione like V_gestione
       and (   P_denuncia in ('A','M')
           and rilevanza = 'S'
        or     P_denuncia = 'E'
           and rilevanza  = 'A'
        or nvl(qualifica,'XXXXXX') = 'XXXXXX'
              )
     order by dal,al
   )
   LOOP
   D_qualifica := null;
     BEGIN
      SELECT rqmi.codice          qua_min
      into D_qualifica
      FROM periodi_giuridici pegi
         , posizioni posi
         , righe_qualifica_ministeriale rqmi
      WHERE pegi.ci               = P_ci
        AND pegi.rilevanza        = 'S'
		AND nvl(rqmi.posizione,pegi.posizione) = pegi.posizione
        AND CUR_QUALIFICA.al between pegi.dal
                             AND nvl(pegi.al,to_date(D_al,'ddmmyyyy'))
        AND pegi.gestione        like V_gestione
        AND posi.codice      = pegi.posizione
        AND to_date(D_dal,'ddmmyyyy')
            between rqmi.dal and nvl(rqmi.al,to_date('3333333','j'))
        AND (   (    rqmi.qualifica is null
                 and rqmi.figura     = pegi.figura)
             or (    rqmi.figura    is null
                 and rqmi.qualifica  = pegi.qualifica)
             or (    rqmi.qualifica is not null
                 and rqmi.figura    is not null
                 and rqmi.qualifica  = pegi.qualifica
                 and rqmi.figura     = pegi.figura)
             or (    rqmi.qualifica is null
                 and rqmi.figura    is null)
                             )
        AND nvl(rqmi.di_ruolo,posi.di_ruolo)   = posi.di_ruolo
        AND nvl(rqmi.tempo_determinato,posi.tempo_determinato)
                                     = posi.tempo_determinato
        AND nvl(rqmi.formazione_lavoro,posi.contratto_formazione)
                                     = posi.contratto_formazione
        AND nvl(rqmi.part_time,posi.part_time) = posi.part_time
        AND nvl(pegi.tipo_rapporto,'NULL')     = nvl(rqmi.tipo_rapporto, nvl(pegi.tipo_rapporto,'NULL'))
        ;
     EXCEPTION
       when no_data_found then
       BEGIN
        D_pr_err_5 := D_pr_err_5 + 1;
        INSERT INTO a_segnalazioni_errore
        ( no_prenotazione, passo, progressivo, errore, precisazione )
        SELECT P_prenotazione
             , 1
             , D_pr_err_5
             , 'P05986'
             , 'Cod.Ind.: '||RPAD(TO_CHAR(P_ci),8,' ')||' '||
               'Dal '||TO_CHAR(CUR_QUALIFICA.dal,'dd/mm/yyyy')||'  '||
                'Al '||TO_CHAR(CUR_QUALIFICA.al, 'dd/mm/yyyy')
       from dual
       where not exists (select 'x' from a_segnalazioni_errore
                          where no_prenotazione = P_prenotazione
                            and passo           = 1
                            and errore          = 'P05986'
                            and precisazione    = 'Cod.Ind.: '||RPAD(TO_CHAR(P_ci),8,' ')||' '||
                                                  'Dal '||TO_CHAR(CUR_QUALIFICA.dal,'dd/mm/yyyy')||'  '||
                                                  'Al '||TO_CHAR(CUR_QUALIFICA.al, 'dd/mm/yyyy')
                         );
       END;
      when too_many_rows then
       BEGIN
        D_pr_err_5 := D_pr_err_5 + 1;
        INSERT INTO a_segnalazioni_errore
        ( no_prenotazione, passo, progressivo, errore, precisazione )
        SELECT P_prenotazione
             , 1
             , D_pr_err_5
             , 'P05985'
             , 'Cod.Ind.: '||RPAD(TO_CHAR(P_ci),8,' ')||' '||
               'Dal '||TO_CHAR(CUR_QUALIFICA.dal,'dd/mm/yyyy')||'  '||
                'Al '||TO_CHAR(CUR_QUALIFICA.al, 'dd/mm/yyyy')
       from dual
       where not exists (select 'x' from a_segnalazioni_errore
                          where no_prenotazione = P_prenotazione
                            and passo          = 1
                            and errore         = 'P05985'
                            and precisazione   = 'Cod.Ind.: '||RPAD(TO_CHAR(P_ci),8,' ')||' '||
                                                 'Dal '||TO_CHAR(CUR_QUALIFICA.dal,'dd/mm/yyyy')||'  '||
                                                 'Al '||TO_CHAR(CUR_QUALIFICA.al, 'dd/mm/yyyy')
                         );
       END;
     END;
     update denuncia_inpdap
        set  qualifica = D_qualifica
      where  ci        = P_ci
        and  nvl(dal,to_date(D_dal,'ddmmyyyy')) = cur_qualifica.dal
        and  nvl(al,to_date(D_al,'ddmmyyyy'))  = cur_qualifica.al
     ;
   END LOOP;  --CUR_QUALIFICA
END DETERMINA_QUALIFICA;
PROCEDURE ACCORPA_PERIODI
( D_ANNO        IN varchar2,
  P_CI          IN number,
  P_SFASATO     IN varchar2
) IS
BEGIN
DECLARE
D_CONTA               number := 0;
P_rap_orario          number := 0;
P_PREVIDENZA          VARCHAR2(6);
P_ASSICURAZIONI       VARCHAR2(6);
P_GESTIONE            VARCHAR2(8);
P_CODICE              VARCHAR2(10);
P_POSIZIONE           VARCHAR2(8);
P_QUALIFICA           VARCHAR2(6);
P_RILEVANZA           VARCHAR2(1);
P_DAL                 DATE;
P_AL                  DATE;
P_TIPO_IMPIEGO        VARCHAR2(2);
P_TIPO_SERVIZIO       VARCHAR2(2);
P_PERC_L300           NUMBER(5,2);
P_RIFERIMENTO         NUMBER(4);
P_COMPETENZA          NUMBER(4);
P_MAGGIORAZIONI       VARCHAR2(12);
P_DATA_DECORRENZA     DATE;
P_DATA_CESSAZIONE     DATE;
P_CAUSA_CESSAZIONE    VARCHAR2(2);
P_DATA_OPZ_TFR        DATE;
P_CF_AMM_FISSE        VARCHAR2(16);
P_CF_AMM_ACC          VARCHAR2(16);
P_GG_UTILI            NUMBER(3);
P_GG_TFR              NUMBER(3);
P_COMP_FISSE          NUMBER(12,2);
P_COMP_ACCESSORIE     NUMBER(12,2);
P_COMP_INADEL         NUMBER(12,2);
P_PREMIO_PROD         NUMBER(12,2);
P_COMP_TFR            NUMBER(12,2);
P_IPN_TFR             NUMBER(12,2);
P_IND_NON_A           NUMBER(12,2);
P_L_165               NUMBER(12,2);
P_COMP_18             NUMBER(12,2);
P_TREDICESIMA         NUMBER(12,2);
P_GG_MAG_1            NUMBER(3);
P_GG_MAG_2            NUMBER(3);
P_GG_MAG_3            NUMBER(3);
P_GG_MAG_4            NUMBER(3);
BEGIN
FOR CUR_PERIODI IN (
SELECT DAL, AL , PREVIDENZA, ASSICURAZIONI, GESTIONE, CODICE, POSIZIONE, QUALIFICA
     , TIPO_IMPIEGO, TIPO_SERVIZIO, PERC_L300, RIFERIMENTO, COMPETENZA, MAGGIORAZIONI
     , DATA_DECORRENZA, DATA_CESSAZIONE, CAUSA_CESSAZIONE, DATA_OPZ_TFR, CF_AMM_FISSE
     , CF_AMM_ACC, GG_UTILI, COMP_FISSE, GG_TFR, COMP_ACCESSORIE, COMP_INADEL, PREMIO_PROD
     , COMP_TFR, IPN_TFR,IND_NON_A, L_165, COMP_18, TREDICESIMA, GG_MAG_1, GG_MAG_2, GG_MAG_3
     , GG_MAG_4, RAP_ORARIO
  FROM DENUNCIA_INPDAP
 WHERE ANNO       = D_ANNO
   AND CI         = P_CI
   AND RILEVANZA  = 'S'
 order by dal,al
 ) LOOP
-- dbms_output.put_line(' CI: '||to_char(P_ci)||' - '||to_char(cur_periodi.dal,'dd/mm/yyyy')||' - '||to_char(cur_periodi.al,'dd/mm/yyyy'));
 d_conta := d_conta + 1;
 BEGIN
   IF d_conta = 1
   THEN
   -- memorizzo i dati per confronto
      P_PREVIDENZA       := CUR_PERIODI.previdenza;
      P_ASSICURAZIONI    := CUR_PERIODI.assicurazioni;
      P_GESTIONE         := CUR_PERIODI.gestione;
      P_CODICE           := CUR_PERIODI.codice;
      P_POSIZIONE        := CUR_PERIODI.posizione;
      P_QUALIFICA        := CUR_PERIODI.qualifica;
      P_TIPO_IMPIEGO     := CUR_PERIODI.tipo_impiego;
      P_TIPO_SERVIZIO    := CUR_PERIODI.tipo_servizio;
      P_PERC_L300        := CUR_PERIODI.perc_l300;
      P_RIFERIMENTO      := CUR_PERIODI.riferimento;
      P_COMPETENZA       := CUR_PERIODI.competenza;
      P_MAGGIORAZIONI    := CUR_PERIODI.maggiorazioni;
      P_DATA_CESSAZIONE  := CUR_PERIODI.data_CESSAZIONE;
      P_CAUSA_CESSAZIONE := CUR_PERIODI.causa_CESSAZIONE;
      P_DATA_DECORRENZA  := CUR_PERIODI.data_decorrenza;
      P_DATA_OPZ_TFR     := CUR_PERIODI.data_opz_tfr;
      P_CF_AMM_FISSE     := CUR_PERIODI.cf_amm_fisse;
      P_CF_AMM_ACC       := CUR_PERIODI.cf_amm_acc;
      P_DAL              := CUR_PERIODI.dal;
      P_AL               := CUR_PERIODI.al;
      P_GG_UTILI         := CUR_PERIODI.gg_utili;
      P_GG_TFR           := CUR_PERIODI.gg_tfr;
      P_COMP_FISSE       := CUR_PERIODI.comp_fisse;
      P_COMP_ACCESSORIE  := CUR_PERIODI.comp_accessorie;
      P_COMP_INADEL      := CUR_PERIODI.comp_inadel;
      P_PREMIO_PROD      := CUR_PERIODI.premio_prod;
      P_COMP_TFR         := CUR_PERIODI.comp_tfr;
      P_IPN_TFR          := CUR_PERIODI.ipn_tfr;
      P_IND_NON_A        := CUR_PERIODI.ind_non_a;
      P_L_165            := CUR_periodi.l_165;
      P_COMP_18          := CUR_PERIODI.comp_18;
      P_TREDICESIMA      := CUR_PERIODI.tredicesima;
      P_GG_MAG_1         := CUR_PERIODI.gg_mag_1;
      P_GG_MAG_2         := CUR_PERIODI.gg_mag_2;
      P_GG_MAG_3         := CUR_PERIODI.gg_mag_3;
      P_GG_MAG_4         := CUR_PERIODI.gg_mag_4;
      P_RAP_ORARIO       := CUR_PERIODI.rap_orario;
    ELSIF
            P_PREVIDENZA                = CUR_PERIODI.previdenza
       AND  P_ASSICURAZIONI             = CUR_PERIODI.assicurazioni
       AND  nvl(P_GESTIONE,' ')         = nvl(CUR_PERIODI.gestione,' ')
       AND  nvl(P_CODICE,' ')           = nvl(CUR_PERIODI.codice,' ')
       AND  nvl(P_POSIZIONE,' ')        = nvl(CUR_PERIODI.posizione,' ')
       AND  nvl(P_QUALIFICA,' ')        = nvl(CUR_PERIODI.qualifica,' ')
       AND  nvl(P_TIPO_IMPIEGO,' ')     = nvl(CUR_PERIODI.tipo_impiego,' ')
       AND  nvl(P_TIPO_SERVIZIO,' ')    = nvl(CUR_PERIODI.tipo_servizio,' ')
       AND  nvl(P_PERC_L300,0)        = nvl(CUR_PERIODI.perc_l300,0)
       AND  nvl(P_RIFERIMENTO,0)        = nvl(CUR_PERIODI.riferimento,0)
       AND  nvl(P_COMPETENZA,0)         = nvl(CUR_PERIODI.competenza,0)
       AND  nvl(P_MAGGIORAZIONI,' ')    = nvl(CUR_PERIODI.maggiorazioni,' ')
--       AND  nvl(P_DATA_CESSAZIONE,to_date('3333333','j'))
--                                        = nvl(CUR_PERIODI.data_CESSAZIONE,to_date('3333333','j'))
       AND  nvl(P_DATA_DECORRENZA,to_date('3333333','j'))
                                        = nvl(CUR_PERIODI.data_decorrenza,to_date('3333333','j'))
       AND  nvl(P_DATA_OPZ_TFR,to_date('3333333','j'))
                                        = nvl(CUR_PERIODI.data_opz_tfr,to_date('3333333','j'))
       AND  nvl(P_CF_AMM_FISSE,' ')     = nvl(CUR_PERIODI.cf_amm_fisse,' ')
       AND  nvl(P_CF_AMM_ACC,' ')       = nvl(CUR_PERIODI.cf_amm_acc,' ')
       AND  to_char(P_DAL,'yyyy')       = D_anno
       AND  CUR_PERIODI.dal             = P_AL + 1
       THEN -- se sono uguali e sono consecutivi memorizzo i dati per accorpamento
              P_GG_UTILI         := nvl(P_GG_UTILI,0) + nvl(CUR_PERIODI.gg_utili,0);
              P_GG_TFR           := nvl(P_GG_TFR,0)+nvl(cur_periodi.GG_TFR,0);
              P_COMP_FISSE       := nvl(P_COMP_FISSE,0) + nvl(CUR_PERIODI.comp_fisse,0);
              P_COMP_ACCESSORIE  := nvl(P_COMP_ACCESSORIE,0)+nvl(cur_periodi.COMP_ACCESSORIE,0);
              P_COMP_INADEL      := nvl(P_COMP_INADEL    ,0)+nvl(cur_periodi.COMP_INADEL    ,0);
              P_COMP_TFR         := nvl(P_COMP_TFR       ,0)+nvl(cur_periodi.COMP_TFR       ,0);
              P_IPN_TFR          := nvl(P_IPN_TFR        ,0)+nvl(cur_periodi.IPN_TFR        ,0);
              P_PREMIO_PROD      := nvl(P_PREMIO_PROD    ,0)+nvl(cur_periodi.PREMIO_PROD    ,0);
              P_IND_NON_A        := nvl(P_IND_NON_A      ,0)+nvl(cur_periodi.IND_NON_A      ,0);
              P_L_165            := nvl(P_L_165          ,0)+nvl(cur_periodi.L_165          ,0);
              P_COMP_18          := nvl(P_COMP_18        ,0)+nvl(cur_periodi.COMP_18        ,0);
              P_TREDICESIMA      := nvl(P_TREDICESIMA    ,0)+nvl(cur_periodi.TREDICESIMA    ,0);
              P_GG_MAG_1         := nvl(P_GG_MAG_1,0)+nvl(cur_periodi.GG_MAG_1,0);
              P_GG_MAG_2         := nvl(P_GG_MAG_2,0)+nvl(cur_periodi.GG_MAG_2,0);
              P_GG_MAG_3         := nvl(P_GG_MAG_3,0)+nvl(cur_periodi.GG_MAG_3,0);
              P_GG_MAG_4         := nvl(P_GG_MAG_4,0)+nvl(cur_periodi.GG_MAG_4,0);
              P_RAP_ORARIO       := nvl(P_RAP_ORARIO,0) + nvl(cur_periodi.RAP_ORARIO,0);
              P_DATA_CESSAZIONE  := CUR_PERIODI.data_CESSAZIONE;
              P_CAUSA_CESSAZIONE := CUR_PERIODI.causa_CESSAZIONE;
              update denuncia_inpdap
                 set al               = CUR_PERIODI.al
                   , gg_utili         = decode(P_gg_utili,0,null,P_gg_utili)
                   , gg_tfr           = decode(P_gg_tfr,0,null,P_gg_tfr)
                   , comp_fisse       = decode(P_comp_fisse,0,null,P_comp_fisse)
                   , comp_accessorie  = decode(P_comp_accessorie ,0,null,P_comp_accessorie)
                   , comp_inadel      = decode(P_comp_inadel,0,null,P_comp_inadel)
                   , comp_tfr         = decode(P_comp_tfr ,0,null,P_comp_tfr )
                   , ipn_tfr          = decode(P_ipn_tfr ,0,null,P_ipn_tfr )
                   , premio_prod      = decode(P_premio_prod ,0,null,P_premio_prod)
                   , ind_non_a        = decode(P_ind_non_a,0,null,P_ind_non_a)
                   , L_165            = decode(P_l_165,0,null,P_l_165)
                   , comp_18          = decode(P_comp_18,0,null,P_comp_18)
                   , tredicesima      = decode(P_tredicesima,0,null,P_tredicesima)
                   , gg_mag_1         = decode(P_gg_mag_1,0,null,P_gg_mag_1)
                   , gg_mag_2         = decode(P_gg_mag_2,0,null,P_gg_mag_2)
                   , gg_mag_3         = decode(P_gg_mag_3,0,null,P_gg_mag_3)
                   , gg_mag_4         = decode(P_gg_mag_4,0,null,P_gg_mag_4)
                   , rap_orario       = decode(P_rap_orario,0,null,P_rap_orario)
                   , data_cessazione  = P_DATA_CESSAZIONE
                   , causa_cessazione = P_CAUSA_CESSAZIONE
              where anno      = D_anno
                and ci        = P_CI
                and rilevanza = 'S'
                and dal       = P_DAL;
              delete from denuncia_inpdap
               where anno     = D_anno
                and ci        = P_CI
                and rilevanza = 'S'
                and dal       = CUR_PERIODI.DAL
                and nvl(al,to_date('3333333','j'))
                              = nvl(CUR_PERIODI.AL,to_date('3333333','j'));
             P_al := CUR_PERIODI.AL;
-- dbms_output.put_line('UPDATE CI: '||to_char(P_ci)||' - '||to_char(p_dal,'dd/mm/yyyy')||' - '||to_char(P_al,'dd/mm/yyyy'));
        ELSE -- memorizzo i dati per un successivo confronto
          P_PREVIDENZA       := CUR_PERIODI.previdenza;
          P_ASSICURAZIONI    := CUR_PERIODI.assicurazioni;
          P_GESTIONE         := CUR_PERIODI.gestione;
          P_CODICE           := CUR_PERIODI.codice;
          P_POSIZIONE        := CUR_PERIODI.posizione;
          P_QUALIFICA        := CUR_PERIODI.qualifica;
          P_TIPO_IMPIEGO     := CUR_PERIODI.tipo_impiego;
          P_TIPO_SERVIZIO    := CUR_PERIODI.tipo_servizio;
          P_PERC_L300        := CUR_PERIODI.perc_l300;
          P_RIFERIMENTO      := CUR_PERIODI.riferimento;
          P_COMPETENZA       := CUR_PERIODI.competenza;
          P_MAGGIORAZIONI    := CUR_PERIODI.maggiorazioni;
          P_DATA_CESSAZIONE  := CUR_PERIODI.data_CESSAZIONE;
          P_CAUSA_CESSAZIONE := CUR_PERIODI.causa_CESSAZIONE;
          P_DATA_DECORRENZA  := CUR_PERIODI.data_decorrenza;
          P_DATA_OPZ_TFR     := CUR_PERIODI.data_opz_tfr;
          P_CF_AMM_FISSE     := CUR_PERIODI.cf_amm_fisse;
          P_CF_AMM_ACC       := CUR_PERIODI.cf_amm_acc;
          P_DAL              := CUR_PERIODI.dal;
          P_AL               := CUR_PERIODI.al;
          P_GG_UTILI         := CUR_PERIODI.gg_utili;
          P_GG_TFR           := CUR_PERIODI.gg_tfr;
          P_COMP_FISSE       := CUR_PERIODI.comp_fisse;
          P_COMP_ACCESSORIE  := CUR_PERIODI.comp_accessorie;
          P_COMP_INADEL      := CUR_PERIODI.comp_inadel;
          P_PREMIO_PROD      := CUR_PERIODI.premio_prod;
          P_COMP_TFR         := CUR_PERIODI.comp_tfr;
          P_IPN_TFR          := CUR_PERIODI.ipn_tfr;
          P_IND_NON_A        := CUR_PERIODI.ind_non_a;
          P_L_165            := CUR_periodi.l_165;
          P_COMP_18          := CUR_PERIODI.comp_18;
          P_TREDICESIMA      := CUR_PERIODI.tredicesima;
          P_GG_MAG_1         := CUR_PERIODI.gg_mag_1;
          P_GG_MAG_2         := CUR_PERIODI.gg_mag_2;
          P_GG_MAG_3         := CUR_PERIODI.gg_mag_3;
          P_GG_MAG_4         := CUR_PERIODI.gg_mag_4;
          P_RAP_ORARIO       := CUR_PERIODI.rap_orario;
        END IF;
 END;
END LOOP; -- CUR_PERIODI
END;
END ACCORPA_PERIODI;
PROCEDURE AGGIUNGI_SEGNALAZIONI
( D_anno          in varchar2,
  D_ini_a         in varchar2,
  D_fin_a         in varchar2,
  P_CI            in number,
  P_prenotazione  in number,
  D_pr_err_4      in out number
) IS
BEGIN
 DECLARE
 V_controllo    varchar2(1);
 BEGIN
  BEGIN
    select 'X'
      into V_controllo
      from dual
     where exists (select 'x'
                    from periodi_retributivi pere
                   where ci = P_ci
                      and periodo between to_date(D_ini_a,'ddmmyyyy')
                                      and to_date(D_fin_a,'ddmmyyyy')
                      and competenza = 'A'
                      and exists (select 'x'
                                    from periodi_retributivi pere1
                                   where periodo = pere.periodo
                                     and ci         = pere.ci
                                     and competenza = 'C'
                                     and gestione  != pere.gestione
                                     and not exists (select 'x'
                                                       from periodi_retributivi
                                                      where ci         = pere1.ci
                                                        and gestione   = pere1.gestione
                                                        and competenza = 'A'
                                                        and periodo between to_date(D_ini_a,'ddmmyyyy')
                                                                        and to_date(D_fin_a,'ddmmyyyy')
                                                    )
                                )
               );
    EXCEPTION WHEN NO_DATA_FOUND THEN
       V_controllo := null;
    END;
     IF V_controllo = 'X' THEN
-- Segnala periodi da verificare per cambio gestione nel primo mese retributo o dell'anno
        D_pr_err_4 := D_pr_err_4 + 1;
        INSERT INTO a_segnalazioni_errore
        ( no_prenotazione, passo, progressivo, errore, precisazione )
        SELECT P_prenotazione
              , 1
              , D_pr_err_4
              , 'P05195'
              , ' Cod.Ind.: '||RPAD(TO_CHAR(P_ci),8,' ')
          FROM dual;
     END IF;
V_controllo := null;
 END;
END AGGIUNGI_SEGNALAZIONI;
PROCEDURE NON_ARCHIVIATI
( D_ANNO          in varchar2,
  P_ci            in number,
  P_prenotazione  in number,
  D_gestione      in varchar,
  D_pr_err_8      in out number
) IS
  v_controllo varchar2(1) := null;
 BEGIN
    BEGIN
      select 'X'
        into V_controllo
        from dual
       where exists ( select 'x'
                       from valori_contabili_annuali vaca
                      where vaca.ci                = P_ci
                        and vaca.anno              = D_anno
                        and vaca.mese              = 12
                        and vaca.mensilita         = (select max(mensilita)
                                                        from mensilita
                                                       where mese  = 12
                                                         and tipo in ('A','N','S'))
                        and vaca.estrazione        = 'DENUNCIA_INPDAP'
                        and vaca.colonna          in ('COMP_FISSE','COMP_ACCESSORIE'
                                                     ,'COMP_INADEL','COMP_TFR','IPN_TFR'
                                                     ,'PREAVV_RISARCITORIO','FERIE_NON_GODUTE','L_165','COMP_18'
                                                     ,'TREDICESIMA')
                        and to_char(riferimento,'yyyy') = D_anno
                        and not exists (select 'x' from denuncia_inpdap
                                         where ci = vaca.ci
                                           and anno= vaca.anno
                                           and rilevanza = 'S')
                        and vaca.valore != 0
                    ) ;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;
      IF V_controllo = 'X' THEN
         D_pr_err_8 := D_pr_err_8 + 1;
         INSERT INTO a_segnalazioni_errore
         ( no_prenotazione, passo, progressivo, errore, precisazione )
          SELECT P_prenotazione
                , 1
                , D_pr_err_8
                , 'P05199'
                , 'Cod.Ind.: '||RPAD(TO_CHAR(P_ci),8,' ')||'  '||
                  'Gest: '||RPAD(D_gestione,5,' ')
             FROM dual;
      END IF;
END NON_ARCHIVIATI;
END DENUNCE_INPDAP;
/
