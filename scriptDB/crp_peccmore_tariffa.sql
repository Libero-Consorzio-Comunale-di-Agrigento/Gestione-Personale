CREATE OR REPLACE PACKAGE Peccmore_Tariffa IS
/******************************************************************************
 NOME:        PECCMORE_TARIFFA
 DESCRIZIONE: Determinazione della Tariffa delle Voci a Quantità e a Calcolo.

 ANNOTAZIONI: Il Package contiene le procedure richiamete dda:
              -  Calcolo della retribuzione (PECCMORE7).
              - Inserimento delle Variabili (PECAVARI).
               
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    05/07/2004 MF     Prima emissione.
 1    20/07/2004 AM     Mod. lettura di PERE per applicazione del rapporto orario:
                        cerca il rec. corretto a cui si riferisce la voce da valorizzare
                        prendendo quello relativo all'eventuale ultimo conguaglio; tratta
                        il rec. attuale solo se non trova un rec. specifico che contiene
                        il riferimento della voce 
 2    30/09/2004 AM-NN  sostituito test su gg_fis != 0 con test su pere.tipo diverso da R o F 
 3    13/01/2005 MF     Rettifica errore in calcolo RGA13A e RGA13M con Rapporto = NULL
 4    25/07/2005 NN     Esclude i record di pere da precedente datore di lavoro
                        (gestione='*', contratto='*', trattamento='*')
 4.1  28/11/2005 NN     Corretto calcolo tariffa per 13A in periodo di assenza con gg_fis = 0.
******************************************************************************/

revisione varchar2(30) := '4.1 del 28/11/2005';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

FUNCTION tipo_riferimento
( a_rapporto     varchar2
, a_specie       varchar2
, a_specifica    varchar2
, a_val_voce_qta varchar2
, a_cod_voce_qta varchar2
) RETURN varchar2;

PROCEDURE Calcolo
( P_ci                 number
, P_al                 date  -- Data di Termine o Fine Mese
, P_anno               number
, P_mese               number
, P_mensilita          varchar2
, P_fin_ela            date
, P_voce               varchar2
, P_sub                varchar2
, P_rif                date  -- Data di riferimento della voce
, P_rif_tar     IN OUT date  -- Data Riferimento calcolo Tariffa
, P_tariffa     IN OUT number
, P_is_tar_mov  IN OUT number -- Indicatore Tariffa su movimenti del mese (1=si, 0=no)
, P_ore_mensili        number
, P_div_orario         number
, P_ore_gg             number
, P_gg_lavoro          number
, P_ore_lavoro         number
, P_input              varchar2
, P_stp         IN OUT varchar2  -- Step elaborato
);

FUNCTION somma_dati
( P_tariffa      number
, P_tar_con_voce number -- Tariffa della voce di condizione
, P_s1           varchar2
, P_d1           number
, P_s2           varchar2
, P_d2           number
, P_s3           varchar2
, P_d3           number
, P_s4           varchar2
, P_d4           number
) RETURN number;
pragma restrict_references(SOMMA_DATI, WNDS);

PROCEDURE Rapporto_Ore
( P_ci                 number
, P_fin_ela            date
, P_rif                date  -- Data di riferimento della voce
, P_tariffa     IN OUT number
, P_tar_eff     IN OUT number  -- Tariffa per Imponibili Effettivi
, P_gg_lavoro          number
, P_base_ratei         varchar2
, P_rapporto           varchar2
, P_decimali           number
, P_specifica          varchar2
, P_tipo_riferimento   varchar2
, P_input              varchar2
);

PROCEDURE Rapporto_Periodo
( P_ci                 number
, P_fin_ela            date
, P_rif                date  -- Data di riferimento della voce
, P_tariffa     IN OUT number
, P_tar_eff     IN OUT number  -- Tariffa per Imponibili Effettivi
, P_gg_lavoro          number
, P_base_ratei         varchar2
, P_rapporto           varchar2
, P_decimali           number
, P_specifica          varchar2
, P_tipo_riferimento   varchar2
, P_input              varchar2
);

PROCEDURE RGA13M
( P_ci                 number
, P_fin_ela            date
, P_rif                date  -- Data di riferimento della voce
, P_tariffa     IN OUT number
, P_tar_eff     IN OUT number  -- Tariffa per Imponibili Effettivi
, P_gg_lavoro          number
, P_base_ratei         varchar2
, P_rapporto           varchar2
, P_decimali           number
, P_specifica          varchar2
, P_tipo_riferimento   varchar2
, P_input              varchar2
);


PROCEDURE RGA13A
( P_ci                 number
, P_fin_ela            date
, P_rif                date  -- Data di riferimento della voce
, P_tariffa     IN OUT number
, P_tar_eff     IN OUT number  -- Tariffa per Imponibili Effettivi
, P_gg_lavoro          number
, P_base_ratei         varchar2
, P_rapporto           varchar2
, P_decimali           number
, P_specifica          varchar2
, P_tipo_riferimento   varchar2
, P_input              varchar2
);

END;
/

CREATE OR REPLACE PACKAGE BODY Peccmore_Tariffa IS

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
   RETURN 'V1.'||revisione;
END VERSIONE;

FUNCTION tipo_riferimento
/******************************************************************************
 NOME:        TIPO_RIFERIMENTO
 DESCRIZIONE: Determinazione del tipo di riferimento per la valorizzazione 
              della voce:
              - A    = Annuale
              - M    = Mansile
              - P    = Periodo
              - null = Globale

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    05/07/2004 MF     Prima emissione.
******************************************************************************/
( a_rapporto     varchar2
, a_specie       varchar2
, a_specifica    varchar2
, a_val_voce_qta varchar2
, a_cod_voce_qta varchar2
) RETURN varchar2
IS
R_value varchar2(1);
BEGIN
   IF A_specifica = 'RGA13A' THEN
      R_value := 'A';
   ELSIF A_specifica = 'RGA13M' THEN
      R_value := 'M';
   ELSIF A_specifica like 'RGA%' THEN
      IF nvl(A_specie,'T') = 'T' THEN
         IF nvl(A_rapporto,'O') = 'O' THEN
            IF A_cod_voce_qta is NULL AND A_val_voce_qta != 'V' THEN
               R_value := 'P';
            ELSE 
               R_value := 'M';
            END IF;
         ELSE
            R_value := 'P';
         END IF;
      ELSE
         R_value := 'A';
      END IF;
   ELSE
      IF A_rapporto is null THEN
         R_value := null;
      ELSE
         IF nvl(A_specie,'T') = 'T' THEN
            R_value := 'P';
         ELSE
            R_value := null;
	     END IF;
      END IF;
   END IF;
   RETURN R_value;
END tipo_riferimento;

PROCEDURE CALCOLO
/******************************************************************************
 NOME:        CALCOLO
 DESCRIZIONE: Calcolo della Tariffa delle Voci a Quantita` o a Calcolo.

 ANNOTAZIONI: Richiamata da Paccmore7 e PECAVARI
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    05/07/2004 MF     Prima emissione.
******************************************************************************/
( P_ci                 number
, P_al                 date  -- Data di Termine o Fine Mese
, P_anno               number
, P_mese               number
, P_mensilita          varchar2
, P_fin_ela            date
, P_voce               varchar2
, P_sub                varchar2
, P_rif                date  -- Data di riferimento della voce
, P_rif_tar     IN OUT date  -- Data Riferimento calcolo Tariffa
, P_tariffa     IN OUT number
, P_is_tar_mov  IN OUT number -- Indicatore Tariffa su movimenti del mese (1=si, 0=no)
, P_ore_mensili        number
, P_div_orario         number
, P_ore_gg             number
, P_gg_lavoro          number
, P_ore_lavoro         number
, P_input              varchar2
, P_stp         IN OUT varchar2  -- Step elaborato
) IS
BEGIN
   <<tratta_voce>>
   BEGIN  --Trattamento voce a Tariffa
      P_stp := 'TARIFFA.CALCOLO-01';
      P_tariffa := 0;
      P_is_tar_mov := 0;
      FOR C IN  -- Loop sulle singole righe di composizione tariffa
      (select val_voce
            , cod_voce
            , sub_voce
            , segno1 s1
            , dato1 d1
            , segno2 s2
            , dato2 d2
            , segno3 s3
            , dato3 d3
            , segno4 s4
            , dato4 d4
            , con_voce
            , con_sub
         from righe_tariffa_voce rtvo
        where rtvo.voce = P_voce
          and P_rif between dal and nvl(al ,to_date(3333333,'j'))
      ) LOOP
      <<tratta_riga>>
      DECLARE
      D_classe       varchar2(1);
      D_tipo         varchar2(1);
      D_memorizza    varchar2(1);
      D_tar_con_voce informazioni_retributive.tariffa%type; 
      D_imp          calcoli_contabili.imp%type; 
      D_qta          calcoli_contabili.qta%type;
      D_riferimento  date;
      BEGIN  --Trattamento riga di Tariffa
         IF c.con_voce is null THEN
            D_tar_con_voce:= null;
         ELSE
            BEGIN  --Verifica se riga da trattare
               P_stp := 'TARIFFA.CALCOLO-02';
               select tariffa
                 into D_tar_con_voce
                 from informazioni_retributive
                where ci        = P_ci
                  and voce      = c.con_voce
                  and sub||''   = c.con_sub
                  and P_rif_tar between nvl(dal,to_date(2222222,'j')) and nvl(al ,to_date(3333333,'j'))
               ;
               RAISE TOO_MANY_ROWS;
            EXCEPTION
               WHEN TOO_MANY_ROWS THEN null;
            END;
         END IF;
         IF c.cod_voce is not null THEN
            BEGIN  --preleva classe e tipo voce di composizione
               P_stp := 'TARIFFA.CALCOLO-03';
               select classe
                    , tipo
                    , memorizza
                 into D_classe
                    , D_tipo
                    , D_memorizza
                 from voci_economiche
                where codice like c.cod_voce
               ;
            EXCEPTION  --Evita errore in caso di cod_voce con '%'
               WHEN NO_DATA_FOUND THEN
                  D_classe := 'V';
                  D_tipo := null;
               WHEN TOO_MANY_ROWS THEN
                  D_classe := 'V';
                  D_tipo := null;
            END;
         END IF;
         IF c.cod_voce is null THEN
            BEGIN  --Calcolo Valori Fissi
               P_stp := 'TARIFFA.CALCOLO-04';  
               IF c.val_voce = 'E' THEN -- Estrazione degli anni di anzianità anagrafica
                  select trunc(months_between( to_date('3112'||to_number(to_char(P_rif_tar,'yyyy'))-1,'ddmmyyyy')
                                             , data_nas) / 12)
                    into D_tar_con_voce
                    from rapporti_individuali
                   where ci = P_ci
                  ;
               END IF;
               IF c.val_voce = 'A' THEN -- Estrazione degli anni di anzianità di assunzione
                  select nvl(max(trunc(months_between(P_rif_tar, dal) / 12)),0)
                    into D_tar_con_voce
                    from periodi_giuridici
                   where ci        = P_ci
                     and rilevanza = 'P'
                     and P_rif_tar between dal and nvl(al, to_date('3333333','j'))
                  ;
               END IF;
               P_tariffa := somma_dati(P_tariffa, D_tar_con_voce, c.s1, c.d1, c.s2, c.d2, c.s3, c.d3, c.s4, c.d4); 
            END;
         ELSIF c.val_voce = 'V' THEN  -- Calcolo Tariffe su INFORMAZIONI RETRIBUTIVE
            IF nvl(c.s1,' ') != 'R'
            AND (   D_classe != 'B'
               OR   D_classe  = 'B' AND D_tipo   != 'Q'
                )
            THEN
               BEGIN  -- Periodi a riferimento di Servizio
                  P_stp := 'TARIFFA.CALCOLO-05';
select P_tariffa 
     + nvl
       ( sum( nvl( sum(somma_dati( decode( r.tipo, 'B', decode( r.sub, 'Q', nvl(r.tariffa,0), 0 ), 0 )
                                 , nvl(D_tar_con_voce, r.tariffa)
                                 , c.s1, c.d1, c.s2, c.d2, c.s3, c.d3, c.s4, c.d4
                                 ) 
                      ) * decode( max( decode( r.tipo, 'B', decode( r.sub, 'Q', 1, 2 ), 2 ) ), 1, 1, 0)
                 , 0
                 )
            + nvl( sum(somma_dati( decode( r.tipo
                                         , 'B', decode( r.sub
                                                      , 'I', decode( P_input
                                                                   , 'q', 0
                                                                   , 'n', 0
                                                                        , nvl(r.tariffa,0)
                                                                   )
                                                       , 'Q', decode( P_input
                                                                    , 'q', nvl(r.tariffa,0)
                                                                    , 'n', nvl(r.tariffa,0)
                                                                         , 0
                                                                    )
                                                            , 0
                                                       )
                                              , 0
                                         )
                                 , nvl(D_tar_con_voce, r.tariffa)
                                 , c.s1, c.d1, c.s2, c.d2, c.s3, c.d3, c.s4, c.d4
                                 ) 
                       ) * decode( max( decode( r.tipo, 'B', decode( r.sub, 'Q', 1, 'I', 2 ), 3 ) ), 2, 1, 0 )
                 , 0
                 )
            + nvl( sum(somma_dati( decode( r.tipo, 'B', 0, nvl(r.tariffa,0))
                                 , nvl(D_tar_con_voce, r.tariffa)
                                 , c.s1, c.d1, c.s2, c.d2, c.s3, c.d3, c.s4, c.d4
                                 ) 
                      ) * decode( nvl(max(r.tipo),'I'), 'B', 0, 1 )
                 , 0
                 )
            )
       , 0
       )
  into P_tariffa
  from informazioni_retributive r
 where P_rif_tar between nvl(r.dal,to_date(2222222,'j'))
                     and nvl(r.al ,to_date(3333333,'j'))
   and r.sub = nvl(c.sub_voce,r.sub)
   and r.voce like c.cod_voce
   and r.ci  = P_ci
 group by r.voce
;
               END;
            ELSE
               BEGIN  --per periodi a Riferimento su Tabelle BASE
                  P_stp := 'TARIFFA.CALCOLO-06';
select P_tariffa
     + nvl( sum(somma_dati( round( nvl(b.valore,0)
                                 * nvl(d.moltiplica,1)
                                 / nvl(d.divide,1)
                                 , nvl(d.decimali,0)
                                 )
                          , nvl(D_tar_con_voce, round( nvl(b.valore,0) 
                                                     * nvl(d.moltiplica,1)
                                                     / nvl(d.divide,1)
                                                     , nvl(d.decimali,0) )
                                                     )

                          , c.s1, c.d1, c.s2, c.d2, c.s3, c.d3, c.s4, c.d4
                          ) 
               )
          , 0
          )
  into P_tariffa
  from basi_voce d
     , valori_base_voce b
 where (b.contratto,b.gestione||' '||b.ruolo||' '||b.livello||' '||b.qualifica||' '||b.tipo_rapporto )
 = (select max( b2.contratto)
         , max( b2.gestione||' '||b2.ruolo||' '||b2.livello||' '|| b2.qualifica||' '||b2.tipo_rapporto )
      from qualifiche_giuridiche qua
         , periodi_giuridici eve
         , valori_base_voce b2
     where eve.gestione like b2.gestione
       and qua.ruolo    like b2.ruolo
       and qua.livello  like b2.livello
       and qua.codice   like b2.qualifica
       and nvl(eve.tipo_rapporto,' ')  like b2.tipo_rapporto
       and b2.dal       = d.dal
       and b2.contratto = qua.contratto
       and b2.voce      = d.voce
       and P_rif_tar    between nvl(qua.dal,to_date(2222222,'j'))
                            and nvl(qua.al ,to_date(3333333,'j'))
       and qua.numero   = eve.qualifica
       and P_rif_tar    between eve.dal
                            and nvl(eve.al ,to_date(3333333,'j'))
       and (   eve.rilevanza  = 'E'
           and P_input != 'n'
          or   eve.rilevanza  = 'S'
           and (   P_input  = 'n'
              or   P_input != 'n'
               and not exists
                  (select 'x'
                     from periodi_giuridici z
                    where z.ci        = eve.ci
                      and z.rilevanza = 'E'
                      and P_rif_tar   between z.dal
                                          and nvl(z.al,to_date(3333333,'j'))
                  )
               )
           )
       and eve.ci  = P_ci
   )
  and b.voce      = d.voce
  and b.dal       = d.dal
  and b.contratto = d.contratto
  and decode( c.s1
            , 'R', to_date( to_char( to_number(to_char(P_rif_tar,'yyyy'))
                                   - decode( sign( to_number(to_char(P_rif_tar,'mm')) - nvl(c.d1, 0))
                                           , 1, 0
                                              , 1
                                           )
                                   ) || nvl(to_char(c.d1), to_char(P_rif_tar,'mm'))
                          , 'yyyymm'
                          )
                 , P_rif_tar
            )
      between d.dal and nvl(d.al,to_date(3333333,'j'))
  and d.voce like c.cod_voce
;
               END;
            END IF;
         ELSE   -- Calcolo Tariffe su MOVIMENTI CONTABILI
            IF c.s1 = 'R' THEN
               D_riferimento := P_rif_tar;
               IF c.d1 is not null THEN
                  IF c.d1 >= to_number(to_char(P_rif_tar,'mm')) THEN
                     D_riferimento := add_months(P_rif_tar, -12);
                  END IF;
               END IF;
            END IF;
            IF    (nvl(c.val_voce,'I') = 'I' OR nvl(c.val_voce,'I') = 'Q')
            OR (  (nvl(c.val_voce,'I') = 'P' OR nvl(c.val_voce,'I') = 'M') 
               AND D_memorizza != 'M'
               AND D_memorizza != 'S'
               ) THEN
               D_imp := null;
               D_qta := null;
               IF c.s1 = 'R' THEN
                  BEGIN -- Calcolo sui Movimenti del Mese di Riferimento 
                     P_stp := 'TARIFFA.CALCOLO-07.1';
select P_tariffa
     + nvl( sum(somma_dati( decode( nvl(c.val_voce,'I')
                                  , 'I', nvl(m.imp,0)
                                  , 'P', nvl(m.imp,0)
                                       , nvl(m.qta,0)
                                  )
                          , nvl(D_tar_con_voce, decode( nvl(c.val_voce,'I'), 'I', m.imp, m.qta ) )  
                          , c.s1, c.d1, c.s2, c.d2, c.s3, c.d3, c.s4, c.d4
                          )
               )
          , 0
          )
     , sum(m.imp)
     , sum(m.qta)
  into P_tariffa
     , D_imp
     , D_qta
  from movimenti_contabili m
 where m.sub  = nvl(c.sub_voce,m.sub)
   and m.voce like c.cod_voce
   and m.ci   = P_ci
   and m.anno = to_number(to_char(D_riferimento,'yyyy'))
   and m.mese = to_number(to_char(D_riferimento,'mm'))
;
                  END;
               ELSE
                  -- Attiva Flag per identificare calcolo su Movimenti del Mese
                  P_is_tar_mov := 1;
                  BEGIN  --Calcolo sui Movimenti calcolati nel Mese
                     P_stp := 'TARIFFA.CALCOLO-07.2';
select P_tariffa
     + nvl( sum(somma_dati( decode( nvl(c.val_voce,'I')
                                  , 'I', nvl(m.imp,0)
                                  , 'P', nvl(m.imp,0)
                                       , nvl(m.qta,0)
                                  )
                          , nvl(D_tar_con_voce, decode( nvl(c.val_voce,'I'), 'I', m.imp, m.qta ) )  
                          , c.s1, c.d1, c.s2, c.d2, c.s3, c.d3, c.s4, c.d4
                          )
               )
          , 0
          )
     , sum(m.imp)
     , sum(m.qta)
  into P_tariffa
     , D_imp
     , D_qta
  from calcoli_contabili m
 where m.sub = nvl(c.sub_voce,m.sub)
   and m.voce like c.cod_voce
   and m.ci  = P_ci
;
                  END;
               END IF;
            END IF;
            IF nvl(c.val_voce,'I') = 'P' OR nvl(c.val_voce,'I') = 'M' THEN
               BEGIN  --sui Movimenti Progressivi
                  P_stp := 'TARIFFA.CALCOLO-08';
select P_tariffa
     + nvl( sum(somma_dati( decode( nvl(c.val_voce,'I')
                                  , 'P', nvl(p.p_imp,0)
                                       , nvl(p.p_qta,0)
                                  ) 
                          , nvl(D_tar_con_voce, decode( nvl(c.val_voce,'I')
                                                      , 'P', p.imp + D_imp
                                                           , p.qta + D_qta)
                                                      )
                          , c.s1, c.d1, c.s2, c.d2, c.s3, c.d3, c.s4, c.d4
                          )
               )
          , 0
          )
  into P_tariffa
  from progressivi_contabili p
 where p.ci        = P_ci
   and p.anno      = decode(c.s1, 'R', to_number(to_char(D_riferimento,'yyyy')), P_anno)
   and p.mese      = decode(c.s1, 'R', to_number(to_char(D_riferimento,'mm')), P_mese)
   and p.mensilita = decode(c.s1, 'R', p.mensilita, P_mensilita)
   and p.voce   like c.cod_voce
   and p.sub       = nvl(c.sub_voce,p.sub)
;
               END;
            END IF;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN null;
      END tratta_riga;
      END LOOP;
      -- Se Tariffa diversa da zero esegue operazioni di assestamento
      IF P_tariffa != 0 THEN
         DECLARE
         D_tipo_moltiplica varchar2(2);
         D_moltiplica      number;
         D_tipo_divide     varchar2(2);
         D_divide          number;
         D_arrotonda       number;
         D_decimali        number(1);
         D_precisione      number;
         D_dec_calcolo     number(1);
         BEGIN  --Assestamento tariffa e Rapporto ai periodi dell'anno
            BEGIN  --Preleva dati di Assestamento Tariffa
               P_stp := 'TARIFFA.CALCOLO-09';
   select tavo.tipo_moltiplica, tavo.moltiplica
        , tavo.tipo_divide, tavo.divide
        , tavo.arrotonda
        , decode( nvl(tavo.arrotonda,0)
                , 0, tavo.decimali
                   , decode( tavo.decimali, 0, 0, null )
                )
        , decode( sign(tavo.arrotonda)
                , -1, decode( tavo.decimali, 0, 0, null,  .4999999999, -.4999999999 )
                ,  1, decode( tavo.decimali, 0, 0, null, 0, .4999999999 )
                    , 0
                )
        , decode( nvl(tavo.arrotonda,0), 0, 9, 0 )
     into D_tipo_moltiplica, D_moltiplica
        , D_tipo_divide, D_divide
        , D_arrotonda, D_decimali
        , D_precisione, D_dec_calcolo
     from tariffe_voce tavo
    where tavo.voce = P_voce
      and P_rif     between tavo.dal
                        and nvl(tavo.al ,to_date(3333333,'j'))
   ;
            END;
            BEGIN  --Assestamento Tariffa
               P_stp := 'TARIFFA.CALCOLO-10';
select ( P_tariffa
       * decode( D_tipo_moltiplica
               , 'OM', P_ore_mensili
               , 'OG', P_ore_gg
               , 'GL', sum(r.gg_lav)
               , 'OL', sum(r.gg_lav)*P_ore_gg
               , 'GG', P_gg_lavoro
                     , nvl(D_moltiplica,1)
               )
       / decode( D_tipo_divide
               , 'OM', P_div_orario
               , 'OG', decode(P_ore_gg,0,1,P_ore_gg)
               , 'GL', sum(r.gg_lav)
               , 'OL', decode( sum(r.gg_lav)*P_ore_gg
                             , 0, 1
                                , sum(r.gg_lav)*P_ore_gg
                             )
               , 'GG', P_gg_lavoro
                     , nvl(D_divide,1)
               )
       )
  into P_tariffa
  from periodi_retributivi r
 where r.periodo = P_fin_ela
   and r.anno+0  = P_anno
   and r.ci      = P_ci
/* modifica del 25/07/2005 */
   and r.gestione != '*'
   and r.contratto != '*'
   and r.trattamento != '*'
/* fine modifica del 25/07/2005 */
   and (   r.competenza in ('P','C','A')
       and P_input      != lower(P_input)
      or   r.competenza in ('C','A')
       and P_input       = lower(P_input)
       )
   and exists
      (select 'x'
         from periodi_retributivi
        where periodo     = P_fin_ela
          and ci          = P_ci
          and competenza in ('P','C','A')
          and P_rif between dal and al
          and dal   <= r.al
          and al    >= r.dal
/* modifica del 25/07/2005 */
          and gestione != '*'
          and contratto != '*'
          and trattamento != '*'
/* fine modifica del 25/07/2005 */

      )
;
            END;
            IF  D_decimali = 0
            AND D_arrotonda is not null 
            THEN  
               -- Minimale di Tariffa
               P_tariffa := greatest( D_arrotonda, P_tariffa );
            ELSE  
               -- Riporta la precisione positiva in caso di Tariffa positiva
               IF  D_precisione < 0
               AND P_tariffa > 0 
               THEN
                   D_precisione := D_precisione * -1;
               END IF;
               P_tariffa := round( P_tariffa / nvl(D_arrotonda,1)
                                 + D_precisione
                                 , D_dec_calcolo
                                 ) * nvl(D_arrotonda,1);
            END IF;
         END;
      END IF; -- Tariffa != 0
   END; --Trattamento voce a Tariffa
END CALCOLO;

FUNCTION somma_dati
/******************************************************************************
 NOME:        SOMMA_DATI
 DESCRIZIONE: Somma i dati delle colonne delle Righe di calcolo Tariffa delle Voci.
 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    05/07/2004 MF     Prima emissione.
******************************************************************************/
( P_tariffa      number
, P_tar_con_voce number -- Tariffa della voce di condizione
, P_s1           varchar2
, P_d1           number
, P_s2           varchar2
, P_d2           number
, P_s3           varchar2
, P_d3           number
, P_s4           varchar2
, P_d4           number
) RETURN number IS
R_risultato number;
BEGIN
   R_risultato := P_tariffa;
   IF  P_s1 != '=' AND P_s1 != '#' AND P_s1 != '>' AND P_s1 != '<' 
   OR  P_s1  = '=' AND P_tar_con_voce  = P_d1
   OR  P_s1  = '#' AND P_tar_con_voce != P_d1
   OR  P_s1  = '>' AND P_tar_con_voce  > P_d1
   OR  P_s1  = '<' AND P_tar_con_voce  < P_d1
   THEN
      BEGIN
         -- Calcoli su Colonna 1
         IF    P_s1 = '+' THEN
               R_risultato := R_risultato + P_d1;
         ELSIF P_s1 = '-' THEN
               R_risultato := R_risultato - P_d1;
         ELSIF P_s1 = '*' THEN
               R_risultato := R_risultato * P_d1;
         ELSIF P_s1 = '%' THEN
               R_risultato := R_risultato * P_d1 / 100;
         ELSIF P_s1 = '/' THEN
               R_risultato := R_risultato / P_d1;
         END IF;
         -- Calcoli su Colonna 2
         IF    P_s2 = '+' THEN
               R_risultato := R_risultato + P_d2;
         ELSIF P_s2 = '-' THEN
               R_risultato := R_risultato - P_d2;
         ELSIF P_s2 = '*' THEN
               R_risultato := R_risultato * P_d2;
         ELSIF P_s2 = '%' THEN
               R_risultato := R_risultato * P_d2 / 100;
         ELSIF P_s2 = '/' THEN
               R_risultato := R_risultato / P_d2;
         END IF;
         -- Calcoli su Colonna 3
         IF    P_s3 = '+' THEN
               R_risultato := R_risultato + P_d3;
         ELSIF P_s3 = '-' THEN
               R_risultato := R_risultato - P_d3;
         ELSIF P_s3 = '*' THEN
               R_risultato := R_risultato * P_d3;
         ELSIF P_s3 = '%' THEN
               R_risultato := R_risultato * P_d3 / 100;
         ELSIF P_s3 = '/' THEN
               R_risultato := R_risultato / P_d3;
         END IF;
         -- Calcoli su Colonna 4
         IF    P_s4 = '+' THEN
               R_risultato := R_risultato + P_d4;
         ELSIF P_s4 = '-' THEN
               R_risultato := R_risultato - P_d4;
         ELSIF P_s4 = '*' THEN
               R_risultato := R_risultato * P_d4;
         ELSIF P_s4 = '%' THEN
               R_risultato := R_risultato * P_d4 / 100;
         ELSIF P_s4 = '/' THEN
               R_risultato := R_risultato / P_d4;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN null;
      END;
   END IF;
   RETURN R_risultato;
END somma_dati;

PROCEDURE Rapporto_Ore
/******************************************************************************
 NOME:        RAPPORTO_ORE
 DESCRIZIONE: Rapporto Tariffa ad ORE
              Estratta sempre come unica voce alla max data AL.

 ANNOTAZIONI: Richiamata da Peccmore7
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    05/07/2004 MF     Prima emissione.
******************************************************************************/
( P_ci                 number
, P_fin_ela            date
, P_rif                date  -- Data di riferimento della voce
, P_tariffa     IN OUT number
, P_tar_eff     IN OUT number  -- Tariffa per Imponibili Effettivi
, P_gg_lavoro          number
, P_base_ratei         varchar2
, P_rapporto           varchar2
, P_decimali           number
, P_specifica          varchar2
, P_tipo_riferimento   varchar2
, P_input              varchar2
) IS
BEGIN  -- Rapporto Tariffa ad ORE
select round( P_tariffa
    * decode
      ( sum( sum( abs(r.rap_ore)* r.gg_fis ) )
      , 0, max(max(r.rap_ore))                                 -- 28/11/2005
         , sum( sum( abs(r.rap_ore)
                   * r.gg_fis
                   )
              / decode( sum(r.gg_fis)
                      , 0, 1
                         , abs(sum(r.gg_fis))
                      )
             )
    )
    / nvl( sum( decode( sum(r.gg_fis)
                      , 0, null
                         , 1
                      )
              )
         , 1
         )
    , nvl(P_decimali,0)
    )
    , null
   into P_tariffa
    , P_tar_eff
   from periodi_retributivi r
      , periodi_giuridici p
/* modifica del 16/03/2004 */
  where r.ci = P_ci
    and p.ci(+) = r.ci
    and p.rilevanza(+) = 'P'
    and r.al between nvl(p.dal(+),to_date('2222222','j'))
                 and nvl(p.al(+),to_date('3333333','j'))
    and P_rif between nvl(p.dal,to_date('2222222','j'))
                  and nvl(p.al,to_date('3333333','j'))
    and r.periodo >= to_date('01/01/'||to_char(P_rif,'yyyy'),'dd/mm/yyyy')
    and r.periodo <= P_fin_ela
/* modifica del 25/07/2005 */
    and r.gestione != '*'
    and r.contratto != '*'
    and r.trattamento != '*'
/* fine modifica del 25/07/2005 */
    and (   nvl(P_tipo_riferimento, 'G') = 'G'
	  and r.competenza in ('C','A')
        and r.periodo = P_fin_ela
        and to_number(to_char(r.al,'yyyy')) = to_number(to_char(P_rif,'yyyy'))
       or   r.competenza in ('P','C','A')
/* modifica del 18/05/2004 */
/* modifica del 30/09/2004 */
--        and (  P_specifica like 'RGA%' and r.gg_fis != 0
        and (  P_specifica like 'RGA%' and nvl(r.tipo,' ') not in ('R','F')
/* fine modifica del 30/09/2004 */
            or nvl(P_specifica,' ') not like 'RGA%'
            )
/* fine modifica del 18/05/2004 */
   	  and (  P_tipo_riferimento = 'A'
	      and to_number(to_char(r.al,'yyyy')) = to_number(to_char(P_rif,'yyyy'))
	     or   P_tipo_riferimento = 'M'
	      and to_number(to_char(r.al,'mmyyyy')) = to_number(to_char(P_rif,'mmyyyy'))
	     or   P_tipo_riferimento = 'P'
/* modifica del 18/05/2004 */
            and (   P_specifica like 'RGA%'
                and to_number(to_char(r.al,'yyyymm')) <= to_number(to_char(P_rif,'yyyymm'))
/* modifica del 20/07/2004 */
               or   nvl(P_specifica,' ') not like 'RGA%'
                and r.competenza in ('C','A')
                -- and r.periodo  = P_fin_ela and  -- 19/07/2004
		    and r.periodo = 
		       (select nvl(max(periodo), P_fin_ela)
                      from periodi_retributivi
                     where ci          = P_ci
			     and periodo    >= to_date('01/01/'||to_char(P_rif,'yyyy'),'dd/mm/yyyy')
                       and periodo    <= P_fin_ela
                       and competenza in ('C', 'A')
                       and to_number(to_char(al,'yyyymm')) = to_number(to_char(P_rif,'yyyymm'))
                   )
                )
/* fine modifica del 20/07/2004 */
/* fine modifica del 18/05/2004 */
	      and (   P_rif between r.dal and r.al
               or exists
                 (select 'x'
                    from periodi_retributivi
                   where periodo     = P_fin_ela
                     and ci          = P_ci
                     and competenza  = 'P'
                     and P_rif between dal and al
                     and dal        <= r.al
                     and al         >= r.dal
/* modifica del 25/07/2005 */
                     and gestione != '*'
                     and contratto != '*'
                     and trattamento != '*'
/* fine modifica del 25/07/2005 */

                 )
               )
	      )
        )
   group by to_char(r.al,'yyyy'), to_char(r.al,'mm') -- modifica 16/03/2004
-- Nel caso di conguaglio di conguaglio calcola una unita' del divisore del rapporto
-- per ogni riga determinata dalla group by
--   group by r.anno, r.mese, to_char(r.al,'yyyy'), to_char(r.al,'mm')
   ;
/* fine modifica del 16/03/2004 */
END; -- Rapporto_Ore

PROCEDURE Rapporto_Periodo
/******************************************************************************
 NOME:        RAPPORTO_PERIODO
 DESCRIZIONE: Rapporto Tariffa sul Periodo effettivo
              o sui periodi dell'anno in caso di voce
              a calcolo non di Specie = 'T'.

 ANNOTAZIONI: Richiamata da Peccmore7
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    05/07/2004 MF     Prima emissione.
******************************************************************************/
( P_ci                 number
, P_fin_ela            date
, P_rif                date  -- Data di riferimento della voce
, P_tariffa     IN OUT number
, P_tar_eff     IN OUT number  -- Tariffa per Imponibili Effettivi
, P_gg_lavoro          number
, P_base_ratei         varchar2
, P_rapporto           varchar2
, P_decimali           number
, P_specifica          varchar2
, P_tipo_riferimento   varchar2
, P_input              varchar2
) IS
BEGIN  -- Rapporto Tariffa sul Periodo effettivo
       -- o sui periodi dell'anno in caso di voce
       -- a calcolo non di Specie = 'T'
select
  round( P_tariffa
       * decode
         ( P_rapporto
         , 'A', sum(gg_af) / decode(P_gg_lavoro,30,30,26)
         , 'R', sum(gg_rap)/P_gg_lavoro
         , 'G', sum(gg_rid)/P_gg_lavoro
         , 'L', sum(gg_pre)/max(gg_lav)
              * sum( abs(rap_ore)* gg_fis )
              / decode( sum(gg_fis)
                      , 0, 1
                         , sum(gg_fis)
                      )
         , 'P', sum(gg_pre)/max(gg_lav)
         , 'I', sum(gg_inp)/26
         , 'C', sum(gg_inp * abs(rap_ore))/26
              , sum(gg_fis)/30
         )
       , nvl(P_decimali,0)
       )
, round( P_tariffa
       * decode
         ( P_rapporto
         , 'R', sum(gg_con * abs(rap_ore)) / P_gg_lavoro
         , 'G', sum(gg_con)/P_gg_lavoro
              , null
         )
      , nvl(P_decimali,0)
      )
  into P_tariffa
     , P_tar_eff
  from periodi_retributivi r
/* modifica del 16/03/2004 */
 where ci = P_ci
   and r.periodo >= to_date('01/01/'||to_char(P_rif,'yyyy'),'dd/mm/yyyy')
   and r.periodo <= P_fin_ela
/* modifica del 25/07/2005 */
   and r.gestione != '*'
   and r.contratto != '*'
   and r.trattamento != '*'
/* fine modifica del 25/07/2005 */
   and (   competenza in ('P','C','A')
       and P_input    != lower(P_input)
      or  competenza  in ('C','A')
       and P_input     = lower(P_input)
       )
   and (   nvl(P_tipo_riferimento, 'G') = 'G'
       and competenza  in ('C','A')
  and r.periodo = P_fin_ela
       and to_number(to_char(r.al,'yyyy')) = to_number(to_char(P_rif,'yyyy'))
/* modifica del 18/05/2004 */
/* modifica del 30/09/2004 */
--      or   (  P_specifica like 'RGA%' and r.gg_fis != 0
      or   (  P_specifica like 'RGA%' and nvl(r.tipo,' ') not in ('R','F')
/* fine modifica del 30/09/2004 */
           or nvl(P_specifica,' ') not like 'RGA%'
           )
/* fine modifica del 18/05/2004 */
      and (    P_tipo_riferimento = 'A'
	     and to_number(to_char(r.al,'yyyy')) = to_number(to_char(P_rif,'yyyy'))
	    or   P_tipo_riferimento = 'M'
	     and to_number(to_char(r.al,'mmyyyy')) = to_number(to_char(P_rif,'mmyyyy'))
	    or   P_tipo_riferimento = 'P'
/* modifica del 18/05/2004 */
	     and to_number(to_char(r.al,'yyyymm')) <= to_number(to_char(P_rif,'yyyymm'))
           and (    P_specifica like 'RGA%'
               or   nvl(P_specifica,' ') not like 'RGA%'
                and r.periodo  = P_fin_ela
                and r.competenza in ('C','A')
               )
/* fine modifica del 18/05/2004 */
           and (   P_rif between r.dal and r.al
               or exists
                 (select 'x'
                    from periodi_retributivi
                   where periodo     = P_fin_ela
                     and ci          = P_ci
                     and competenza  = 'P'
                     and P_rif between dal and al
                     and dal        <= r.al
                     and al         >= r.dal
/* modifica del 25/07/2005 */
                     and gestione != '*'
                     and contratto != '*'
                     and trattamento != '*'
/* fine modifica del 25/07/2005 */
                 )
		   )
	     and (   P_input in ('q','i','n')
               and r.servizio = upper(P_input)
              or  P_input not in ('q','i','n')
               )
          )
       )
/* fine modifica del 16/03/2004 */
;
END; -- Rapporto_Periodo


PROCEDURE RGA13M
/******************************************************************************
 NOME:        RGA13M
 DESCRIZIONE: Se Rapporto = 'R' 
                 Rapporto Tariffa sul Periodo effettivo per Specifica 'RGA13M'
                 calcolato sulla Base dei giorni "gg_rat".
              altrimenti
                 Rapporto Tariffa sul Periodo effettivo per Specifica 'RGA13M'
                 calcolato con ricalcolo sui giorni contrattuali.

 ANNOTAZIONI: Richiamata da Paccmore7
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    05/07/2004 MF     Prima emissione.
******************************************************************************/
( P_ci                 number
, P_fin_ela            date
, P_rif                date  -- Data di riferimento della voce
, P_tariffa     IN OUT number
, P_tar_eff     IN OUT number  -- Tariffa per Imponibili Effettivi
, P_gg_lavoro          number
, P_base_ratei         varchar2
, P_rapporto           varchar2
, P_decimali           number
, P_specifica          varchar2
, P_tipo_riferimento   varchar2
, P_input              varchar2
) IS
BEGIN
   IF P_rapporto = 'R' THEN
      BEGIN  -- Rapporto Tariffa sul Periodo effettivo per Specifica 'RGA13M'
             -- con indicazione di Rapporto 'R'
             -- calcolato sulla Base dei giorni "gg_rat"
select
  round( P_tariffa
       * sum( r.gg_rat * abs(r.rap_ore) )
       / decode( sum(r.gg_rat)
               , 0, 1
                  , sum(r.gg_rat)
               )
        * decode
          ( P_base_ratei
          --Attribuzione a Giorni
          , 'G', sum(r.gg_rat) / 30
          --Attribuzione a Rateo su Giorni Fiscali
          , 'M', sum(r.gg_rat) / 30
               * round( sum(r.gg_fis) / 30 )
          --Attribuzione a Rateo su Giorni Rateo eventualmente ridotti
          , 'R', round( sum(r.gg_rat) / 30 )
          , 'N', round( sum(r.gg_rat) / 30 )
          )
      , nvl(P_decimali,0)
      )
  , round( P_tariffa
         * sum( (r.gg_con - r.gg_30) * abs(r.rap_ore) )
         / decode( sum(r.gg_con - r.gg_30)
                 , 0, 1
                    , sum(r.gg_con - r.gg_30)
                 )
         * decode
           ( P_base_ratei
           --Attribuzione a Giorni
           , 'G', ( sum(r.gg_con - r.gg_30) / P_gg_lavoro )
           --Attribuzione a Rateo su Giorni Fiscali
           , 'M', ( sum(r.gg_con - r.gg_30) / P_gg_lavoro )
                  * round( sum(r.gg_fis) / 30 )
           --Attribuzione a Rateo su Giorni Rateo eventualmente ridotti
           , 'R', round( sum(r.gg_rat) / 30 )
           , 'N', round( sum(r.gg_rat) / 30 )
           )
         , nvl(P_decimali,0)
         )
   into P_tariffa
      , P_tar_eff
   from periodi_retributivi r
      , periodi_giuridici p
/* modifica del 16/03/2004 */
--where (   anno = to_number(to_char(P_rif,'yyyy'))
  where (   r.periodo >= to_date('01/'||to_char(P_rif,'mm/yyyy'),'dd/mm/yyyy')
        and r.periodo <= P_fin_ela
        and to_number(to_char(r.al,'mmyyyy')) = to_number(to_char(P_rif,'mmyyyy'))
/* fine modifica del 16/03/2004 */
/* modifica del 30/09/2004 */
--        and r.gg_fis != 0
        and nvl(r.tipo,' ') not in ('R','F')
/* fine modifica del 30/09/2004 */
        )
  and r.ci  = P_ci
  and p.ci(+) = r.ci
  and p.rilevanza(+) = 'P'
  and r.al between nvl(p.dal(+),to_date('2222222','j'))
               and nvl(p.al(+),to_date('3333333','j'))
  and P_rif between nvl(p.dal,to_date('2222222','j'))
                and nvl(p.al,to_date('3333333','j'))
/* modifica del 25/07/2005 */
  and r.gestione != '*'
  and r.contratto != '*'
  and r.trattamento != '*'
/* fine modifica del 25/07/2005 */
  and (   r.competenza in ('P','C','A')
      and P_input != lower(P_input)
      or  r.competenza in ('C','A')
      and P_input  = lower(P_input)
      )
/* modifica del 16/03/2004 */
  --and to_char(P_rif,'yyyy')= to_char(al,'yyyy')
  --and to_char(P_rif,'mm')  = to_char(al,'mm')
/* fine modifica del 16/03/2004 */
   ;
      END;
   ELSE
      BEGIN  -- Rapporto Tariffa sul Periodo effettivo per Specifica 'RGA13M'
             -- senza la espressa indicazione di Rapporto = 'R'
             -- calcolato con ricalcolo sui giorni contrattuali
select
  round
  ( P_tariffa
/* modifica del 13/01/2005 */
            -- Sistemate parentesi di round 
            -- Invertiti moltipl. e divisione causa Round errata per periodici su (,49999995)
  * 
  ( sum( round( sum(gg_100) / P_gg_lavoro )
         * sum(gg_100 * abs(quota) / intero)
         / decode( sum(gg_100), 0, 1, sum(gg_100) )
       + round( sum(gg_per) / P_gg_lavoro )
         * sum(gg_per * abs(quota) / intero) / 100 * per_gg
         / decode( sum(gg_per), 0, 1, sum(gg_per) )
       )
  + round( ( sum( round( (sum(gg_100) + sum(gg_per)) / P_gg_lavoro ) ) * P_gg_lavoro
           - sum( round( sum(gg_100) / P_gg_lavoro ) ) * P_gg_lavoro
           - sum( round( sum(gg_per) / P_gg_lavoro ) ) * P_gg_lavoro
           ) / P_gg_lavoro
         )
/* fine modifica del 13/01/2005 */
  / decode
    ( sum( sum(gg_100) - ( round( sum(gg_100) / P_gg_lavoro ) * P_gg_lavoro )
         + sum(gg_per) - ( round( sum(gg_per) / P_gg_lavoro ) * P_gg_lavoro )
         )
    , 0, 1
       , sum( sum(gg_100) - ( round( sum(gg_100) / P_gg_lavoro ) * P_gg_lavoro )
            + sum(gg_per) - ( round( sum(gg_per) / P_gg_lavoro ) * P_gg_lavoro )
            )
    )
  * sum( ( sum(gg_100) - ( round( sum(gg_100) / P_gg_lavoro ) * P_gg_lavoro )
         ) / decode( sum(gg_100), 0, 1, sum(gg_100) )
           * sum(gg_100 * abs(quota) / intero)
       + ( sum(gg_per) - ( round( sum(gg_per) / P_gg_lavoro ) * P_gg_lavoro )
         ) / decode( sum(gg_per), 0, 1, sum(gg_per) )
           * sum(gg_per * abs(quota) / intero / 100 * per_gg)
       )
/* modifica del 16/03/2004 */
 )
/* fine modifica del 16/03/2004 */
  , nvl(P_decimali,0)
  )
, round
  ( P_tariffa
  * sum( round( sum(gg_con - gg_30) / P_gg_lavoro )
       * sum( (gg_con - gg_30) * abs(rap_ore) )
       / decode( sum(gg_con - gg_30)
               , 0, 1
                  , sum(gg_con - gg_30)
               )
       + round( ( sum(gg_con - gg_30)
                - ( round( sum(gg_con - gg_30) / P_gg_lavoro )
                  ) * P_gg_lavoro
                ) / P_gg_lavoro
              )
       * sum( (gg_con - gg_30) * abs(rap_ore))
       / decode( sum(gg_con - gg_30)
               , 0, 1
                  , sum(gg_con - gg_30)
               )
       )
  , nvl(P_decimali,0)
  )
   into P_tariffa
      , P_tar_eff
   from periodi_retributivi r
      , periodi_giuridici   p
/* modifica del 16/03/2004 */
--where (   anno = to_number(to_char(P_rif,'yyyy'))
  where (   r.periodo >= to_date('01/'||to_char(P_rif,'mm/yyyy'),'dd/mm/yyyy')
        and r.periodo <= P_fin_ela
        and to_number(to_char(r.al,'mmyyyy')) = to_number(to_char(P_rif,'mmyyyy'))
/* fine modifica del 16/03/2004 */
/* modifica del 30/09/2004 */
--        and (   r.gg_fis != 0
        and (   nvl(r.tipo,' ') not in ('R','F')
/* fine modifica del 30/09/2004 */
            or  r.per_gg not in (0, 30, 100)
            )
        )
  and r.ci = P_ci
  and p.ci(+) = r.ci
  and p.rilevanza(+) = 'P'
  and r.al between nvl(p.dal(+),to_date('2222222','j'))
               and nvl(p.al(+),to_date('3333333','j'))
  and P_rif between nvl(p.dal,to_date('2222222','j'))
                and nvl(p.al,to_date('3333333','j'))
/* modifica del 25/07/2005 */
  and r.gestione != '*'
  and r.contratto != '*'
  and r.trattamento != '*'
/* fine modifica del 25/07/2005 */
  and (   upper(r.competenza) in ('P','C','A')
      and P_input != lower(P_input)
      or  upper(r.competenza) in ('C','A')
      and P_input  = lower(P_input)
      )
/* modifica del 16/03/2004 */
  --and to_char(P_rif,'yyyy')= to_char(al,'yyyy')
  --and to_char(P_rif,'mm')  = to_char(al,'mm')
/* fine modifica del 16/03/2004 */
 group by r.per_gg, r.quota, r.intero
;
      END;
   END IF;
END; -- Specifica RGA13M

PROCEDURE RGA13A
/******************************************************************************
 NOME:        RGA13A
 DESCRIZIONE: Rapporto Tariffa sul Periodo effettivo per specifica "RGA13A".

 ANNOTAZIONI: Richiamata da Paccmore7
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    05/07/2004 MF     Prima emissione.
******************************************************************************/
( P_ci                 number
, P_fin_ela            date
, P_rif                date  -- Data di riferimento della voce
, P_tariffa     IN OUT number
, P_tar_eff     IN OUT number  -- Tariffa per Imponibili Effettivi
, P_gg_lavoro          number
, P_base_ratei         varchar2
, P_rapporto           varchar2
, P_decimali           number
, P_specifica          varchar2
, P_tipo_riferimento   varchar2
, P_input              varchar2
) IS
BEGIN
select
  round
  ( P_tariffa
/* modifica del 13/01/2005 */
            -- Sistemate parentesi di round 
            -- Invertiti moltipl. e divisione causa Round errata per periodici su (,49999995)
  *
  ( sum( round( sum(gg_100) / P_gg_lavoro )
         * sum(gg_100 * abs(quota) / intero)
         / decode( sum(gg_100), 0, 1, sum(gg_100) )
       + round( sum(gg_per) / P_gg_lavoro )
         * sum(gg_per * abs(quota) / intero) / 100 * per_gg
         / decode( sum(gg_per), 0, 1, sum(gg_per) )
       )
  + round( ( sum( round( (sum(gg_100) + sum(gg_per)) / P_gg_lavoro ) ) * P_gg_lavoro
           - sum( round( sum(gg_100) / P_gg_lavoro ) ) * P_gg_lavoro
           - sum( round( sum(gg_per) / P_gg_lavoro ) ) * P_gg_lavoro
           ) / P_gg_lavoro
         )
/* fine modifica del 13/01/2005 */
  / decode
    ( sum( sum(gg_100) - ( round( sum(gg_100) / P_gg_lavoro ) * P_gg_lavoro )
         + sum(gg_per) - ( round( sum(gg_per) / P_gg_lavoro ) * P_gg_lavoro )
         )
    , 0, 1
       , sum( sum(gg_100) - ( round( sum(gg_100) / P_gg_lavoro ) * P_gg_lavoro )
            + sum(gg_per) - ( round( sum(gg_per) / P_gg_lavoro ) * P_gg_lavoro )
            )
    )
  * sum( ( sum(gg_100) - ( round( sum(gg_100) / P_gg_lavoro ) * P_gg_lavoro )
         ) / decode( sum(gg_100), 0, 1, sum(gg_100) )
           * sum(gg_100 * abs(quota) / intero)
       + ( sum(gg_per) - ( round( sum(gg_per) / P_gg_lavoro ) * P_gg_lavoro )
         ) / decode( sum(gg_per), 0, 1, sum(gg_per) )
           * sum(gg_per * abs(quota) / intero / 100 * per_gg)
       )
/* modifica del 13/01/2005 */
  )
/* fine modifica del 13/01/2005 */
  , nvl(P_decimali,0)
  )
, round
  ( P_tariffa
  * sum( round( sum(gg_con - gg_30) / P_gg_lavoro )
       * sum( (gg_con - gg_30) * abs(rap_ore) )
       / decode( sum(gg_con - gg_30)
               , 0, 1
                  , sum(gg_con - gg_30)
               )
       + round( ( sum(gg_con - gg_30)
                - ( round( sum(gg_con - gg_30) / P_gg_lavoro )
                  ) * P_gg_lavoro
                ) / P_gg_lavoro
              )
       * sum( (gg_con - gg_30) * abs(rap_ore))
       / decode( sum(gg_con - gg_30)
               , 0, 1
                  , sum(gg_con - gg_30)
               )
       )
  , nvl(P_decimali,0)
  )
   into P_tariffa
      , P_tar_eff
   from periodi_retributivi r
      , periodi_giuridici   p
/* modifica del 16/03/2004 */
--where (   anno = to_number(to_char(P_rif,'yyyy'))
  where (   r.periodo >= to_date('01/01/'||to_char(P_rif,'yyyy'),'dd/mm/yyyy')
        and r.periodo <= P_fin_ela
        and to_number(to_char(r.al,'yyyy')) = to_number(to_char(P_rif,'yyyy'))
/* fine modifica del 16/03/2004 */
/* modifica del 30/09/2004 */
--        and (   r.gg_fis != 0
        and (   nvl(r.tipo,' ') not in ('R','F')
/* fine modifica del 30/09/2004 */
            or  r.per_gg not in (0, 30, 100)
            )
        )
  and r.ci  = P_ci
  and p.ci(+)  = r.ci
  and p.rilevanza(+) = 'P'
  and r.al between nvl(p.dal(+),to_date('2222222','j'))
               and nvl(p.al(+),to_date('3333333','j'))
  and P_rif between nvl(p.dal,to_date('2222222','j'))
                and nvl(p.al,to_date('3333333','j'))
/* modifica del 25/07/2005 */
  and r.gestione != '*'
  and r.contratto != '*'
  and r.trattamento != '*'
/* fine modifica del 25/07/2005 */
  and (   upper(r.competenza) in ('P','C','A')
      and P_input != lower(P_input)
      or  upper(r.competenza) in ('C','A')
      and P_input  = lower(P_input)
      )
 group by r.per_gg, r.quota, r.intero
   ;
END; -- Specifica RGA13A

END;
/