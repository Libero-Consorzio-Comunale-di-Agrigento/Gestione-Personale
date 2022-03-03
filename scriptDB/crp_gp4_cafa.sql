CREATE OR REPLACE PACKAGE GP4_CAFA IS
/******************************************************************************

 NOME:        GP4_CAFA

 DESCRIZIONE: Sostituisce la program unit CALCOLA_ASSEGNO utilizzata nella form Acafa, Einre, ...

 ANNOTAZIONI:

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 1    28/09/2004 MV     Prima emissione.
 1.1  17/02/2005 MS     Mod. per attivita 9740
 1.2  24/03/2006 GM     Creazione della function GET_ASSEGNO ( A15058 )
 1.3  10/10/2006 MS     Invertito controllo P05350 con P05741 ( A17251 )
 1.4  17/10/2006 MS     Modificata lettura dell'IPN_FAM ( A17262 )
******************************************************************************/
FUNCTION  VERSIONE              RETURN varchar2;
FUNCTION GET_ASSEGNO
       ( P_ci          in number
       , P_anno        in number
       , P_mese        in number
       , P_cond_fam    in varchar2
       , P_nucleo_fam  in number
       , P_figli_fam   in number 
       ) RETURN number;
PROCEDURE CALCOLA_ASSEGNO 
       ( P_ci           in number
       , P_anno         in number
       , P_mese         in number
       , P_cond_fam     in out varchar2
       , P_nucleo_fam   in out number
       , P_figli_fam    in out number
       , P_ass_fam      out number
       , P_ass_figli_1  out number
       , P_ass_figli_2  out number
       , P_assegno      out number
       , P_errore       out varchar2
       , P_descrizione  out varchar2
       );
END GP4_CAFA;
/
CREATE OR REPLACE PACKAGE BODY GP4_CAFA IS
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************

 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.4 del 17/10/2006';
END VERSIONE;

FUNCTION GET_ASSEGNO
       ( P_ci          in number
       , P_anno        in number
       , P_mese        in number
       , P_cond_fam    in varchar2
       , P_nucleo_fam  in number
       , P_figli_fam   in number  
       ) RETURN number IS
D_cond_fam    varchar2(4) := P_cond_fam;
D_nucleo_fam  number := P_nucleo_fam;
D_figli_fam   number := P_figli_fam;
D_ass_fam     number := 0;
D_ass_figli_1 number := 0;
D_ass_figli_2 number := 0;
D_assegno     number;
D_errore      varchar2(100);
D_descrizione varchar2(100);
BEGIN
  IF P_COND_FAM IS NOT NULL OR P_NUCLEO_FAM IS NOT NULL THEN
      GP4_CAFA.CALCOLA_ASSEGNO( P_ci , P_anno, P_mese, D_cond_fam, D_nucleo_fam, D_figli_fam
                              , D_ass_fam , D_ass_figli_1, D_ass_figli_2 , D_assegno , D_errore ,D_descrizione
                              );
  ELSE
    D_assegno := 0;
  END IF;
    RETURN (D_assegno);
  EXCEPTION
     WHEN OTHERS THEN
          RETURN null;
END GET_ASSEGNO;

PROCEDURE CALCOLA_ASSEGNO
       ( P_ci           in number
       , P_anno         in number
       , P_mese         in number
       , P_cond_fam     in out varchar2
       , P_nucleo_fam   in out number
       , P_figli_fam    in out number
       , P_ass_fam      out number
       , P_ass_figli_1  out number
       , P_ass_figli_2  out number
       , P_assegno      out number
       , P_errore       out varchar2
       , P_descrizione  out varchar2
       ) IS
D_ipn_fam     number;
D_tabella     varchar2(3);
D_cod_scaglione varchar2(2);
D_ass_fam     number;
D_ass_figli   number;
D_mese        number;
D_cond_fam    varchar2(4);
D_nucleo_fam  number;
D_figli_fam   number;
D_ass_figli_1 number;
D_ass_figli_2 number;
uscita        exception;
BEGIN
P_errore      := null;
P_descrizione := null;
begin

  if ( P_cond_fam is not null or P_nucleo_fam is not null or P_figli_fam is not null ) then -- Caso Acafa
     D_mese       := P_mese;
     D_cond_fam   := P_cond_fam;
     D_nucleo_fam := P_nucleo_fam;
     D_figli_fam  := P_figli_fam;
  else   -- Caso Einre - Einrp
    select cafa.mese
         , cafa.cond_fam
         , cafa.nucleo_fam
         , cafa.figli_fam
     into D_mese
        , D_cond_fam
        , D_nucleo_fam
        , D_figli_fam
     from carichi_familiari cafa
    where cafa.ci      = P_ci
      and cafa.anno    = P_anno
      and cafa.mese    = P_mese
      and cafa.giorni is null
    ;
  end if;
   IF D_cond_fam IS NOT NULL AND D_nucleo_fam IS NOT NULL THEN
      /* Lettura CODICE tabella dalla quale ricavare l'importo */
      BEGIN
        select nvl(tabella,1), cod_scaglione
          into D_tabella, D_cod_scaglione
          from condizioni_familiari
         where codice = D_cond_fam;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             P_errore := 'P05350';
             RAISE USCITA;
        WHEN TOO_MANY_ROWS THEN
             P_errore      := 'A00003';
             P_descrizione := 'CONDIZIONI_FAMILIARI';
             RAISE USCITA;
      END;
      /* Lettura dell'imponibile */
      BEGIN
         D_ipn_fam := GP4_INEX.GET_IPN_FAM ( P_ci, P_anno, P_mese );
         IF D_ipn_fam is null THEN
            RAISE NO_DATA_FOUND;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              P_assegno := null;
              P_errore := 'P05741';
              /* Manca reddito familiare */
              RAISE USCITA;
         WHEN TOO_MANY_ROWS THEN
              P_errore      := 'A00003';
              P_descrizione := 'INFORMAZIONI_EXTRACONTABILI';
              RAISE USCITA;
      END;
      /*                                   */
      /* Calcolo importo assegni familiari */
      /*                                   */
      BEGIN
      <<CALCOLO>>
      declare
      v_sca       number;
      v_cod_sca   varchar2(2);
      v_sca1      number;
      v_cod_sca1  varchar2(2);
         BEGIN
         select nvl(min(scaglione),'999999')  scaglione
              , decode( nvl(min(scaglione),'999999') ,'999999',D_cod_scaglione,D_cod_scaglione) codice
           into v_sca, v_cod_sca
           from SCAGLIONI_ASSEGNO_FAMILIARE SCAF1
              , AGGIUNTIVI_FAMILIARI AGFA
          where AGFA.CODICE  = D_cond_fam
            and AGFA.DAL     = SCAF1.DAL
            and to_date( lpad(P_mese,2,0)||to_char(P_anno), 'mmyyyy')
                between SCAF1.DAL and nvl(SCAF1.AL ,to_date('3333333','j'))
            and SCAF1.SCAGLIONE + nvl(AGFA.AGGIUNTIVO,0) >= D_ipn_fam
            and decode(SCAF1.cod_scaglione,'99',D_cod_scaglione, SCAF1.cod_scaglione) = D_cod_scaglione
          ;
-- dbms_output.put_line('sca ' || v_sca || 'cod_sca ' || v_cod_sca);
           IF nvl(V_sca, 999999 ) = 999999 THEN
              select min(least(scaglione, v_sca))   scaglione
                   , decode(SCAF2.cod_scaglione,'99',D_cod_scaglione, SCAF2.cod_scaglione) codice
                into v_sca1
                   , v_cod_sca1
                from SCAGLIONI_ASSEGNO_FAMILIARE SCAF2
               where to_date( lpad(P_mese,2,0)||to_char(P_anno), 'mmyyyy')
                      between SCAF2.DAL and nvl(SCAF2.AL ,to_date('3333333','j'))
                 and SCAF2.SCAGLIONE  >= D_ipn_fam
                 and v_cod_sca = decode(SCAF2.cod_scaglione,'99',D_cod_scaglione, SCAF2.cod_scaglione)
                group by SCAF2.cod_scaglione
               ;
           ELSE
               v_sca1 := v_sca;
               v_cod_sca1 := v_cod_sca;
          END IF;
-- dbms_output.put_line('sca ' || v_sca1 || 'cod_sca ' || v_cod_sca1);
         select nvl(ASFA.IMPORTO,0)
           into D_ass_fam
           from ASSEGNI_FAMILIARI           ASFA
              , SCAGLIONI_ASSEGNO_FAMILIARE SCAF
           where to_date( lpad(P_mese,2,0)||to_char(P_anno), 'mmyyyy')
                 between ASFA.DAL and nvl(ASFA.AL ,to_date('3333333','j'))
            and ASFA.TABELLA          = D_tabella
            and ASFA.NUMERO           = D_nucleo_fam
            and decode(SCAF.cod_scaglione
                      ,'99', D_cod_scaglione
                           , SCAF.cod_scaglione)
                                      = D_cod_scaglione
            and SCAF.dal              = ASFA.dal
            and SCAF.numero_fascia    = ASFA.numero_fascia
            and SCAF.SCAGLIONE = v_sca1;
-- dbms_output.put_line('xxx ' || d_ass_fam);
         end;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              /* Carico familiare non previsto */
              P_errore  := 'P05391';
              RAISE USCITA;
         WHEN TOO_MANY_ROWS THEN
              P_errore      := 'A00003';
              P_descrizione := 'ASSEGNI_FAMILIARI';
              RAISE USCITA;
         WHEN OTHERS THEN
-- dbms_output.put_line('Errore '||sqlerrm);
         raise;
      END CALCOLO;
      /*                                   */
      /* Calcolo importo assegno per figli */
      /*                                   */
      IF D_ass_fam          > 0 THEN
         BEGIN
         select nvl(ASFA.INTEGRATIVO,0), nvl(ASFA.AUMENTO,0), nvl(ASFA.INTEGRATIVO,0) + nvl(ASFA.AUMENTO,0)
           into D_ass_figli_1, D_ass_figli_2, D_ass_figli
           from ASSEGNI_FAMILIARI ASFA
          where to_date( '01/'||to_char(D_mese)||'/'||
                         to_char(P_anno)
                       , 'dd/mm/yyyy'
                       )
                          between DAL
                              and nvl(AL ,to_date('3333333','j'))
            and ASFA.TABELLA    = D_tabella
            and ASFA.NUMERO     = D_figli_fam
            and ASFA.SCAGLIONE in
               (select min(SCAF.SCAGLIONE)
                  from SCAGLIONI_ASSEGNO_FAMILIARE SCAF
                     , AGGIUNTIVI_FAMILIARI AGFA
                 where AGFA.CODICE = D_cond_fam
                   and AGFA.DAL    = SCAF.DAL
                   and to_date( '01/'||to_char(D_mese)||
                                '/'||to_char(P_anno)
                              , 'dd/mm/yyyy'
                              )
                             between SCAF.DAL
                                 and nvl(SCAF.AL ,to_date('3333333','j'))
                   and SCAF.SCAGLIONE + nvl(AGFA.AGGIUNTIVO,0)
                                  >= D_ipn_fam
               )
         ;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 D_ass_figli   := 0;
                 D_ass_figli_1 := 0;
                 D_ass_figli_2 := 0;
            WHEN TOO_MANY_ROWS THEN
                 P_errore       := 'A00003';
                 P_descrizione  := 'ASSEGNI_FAMILIARI';
                 RAISE USCITA;
         END;
     ELSE
                 D_ass_figli   := 0;
                 D_ass_figli_1 := 0;
                 D_ass_figli_2 := 0;
     END IF; -- D_ass_fam          > 0 
         P_assegno     := D_ass_fam + D_ass_figli;
         P_cond_fam    := D_cond_fam;
         P_nucleo_fam  := D_nucleo_fam;
         P_figli_fam   := D_figli_fam;
         P_ass_fam     := D_ass_fam;
         P_ass_figli_1 := D_ass_figli_1;
         P_ass_figli_2 := D_ass_figli_2;
 END IF; -- D_cond_fam IS NOT NULL AND D_nucleo_fam IS NOT NULL 
EXCEPTION
 WHEN USCITA THEN
       P_ass_fam     := null;
       P_ass_figli_1 := null;
       P_ass_figli_2 := null;
       P_assegno     := null;
 WHEN OTHERS THEN   null;
END;
END;
END GP4_CAFA;
/
