CREATE OR REPLACE PACKAGE peccperp3 IS
/******************************************************************************
 NOME:        Peccperp3
 DESCRIZIONE: Calcolo Periodi del Bilancio di Previsione
              
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1    27/07/2004 NN     Gestito campo tipo : assume valore R per i record fittizi
                        per ripresi per arretrati, valore F per individui che
                        non hanno registrazioni nel mese.
 2    28/07/2004 NN     L'inserimento (con segno negativo) dei periodi retributivi
                        non piu'retribuiti in Conguaglio, tratta solo i record
                        con competenza A o C e per ciscun mese/anno di al solo
                        i record generati dall'ultimo periodo.
 3    09/09/2004 NN     Nuovo campo tipo_trattamento in TRCO e RARE.
 4    23/09/2004 AM     Spostato l'indicatore di conguaglio dal record 'A' all'ultimo
                        dei record reali per la corretta estrazione della 13ma EP (CCNL 2004)
 5    07/12/2004 NN     Gestione percentuale di assenza indicata nel campo Ore
                        del record di assenza.
 6    14/12/2004 NN     Non riporta più il valore del campo ore dei record con 
                        competenza maiuscola al corrispondente con competenza
                        minuscola
 6.1  14/11/2007 NN     Gestito il nuovo campo CARE.GG_DF, per il momento valorizzato con zero.
******************************************************************************/

revisione varchar2(30) := '6.1 del 14/11/2007';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

PROCEDURE PERE_INSERT
( P_ci number
, P_dal date
, P_al date
, P_cong_ind number
, P_d_cong date
, P_d_cong_al date
, P_settore number
, P_sede number
, P_figura number
, P_attivita VARCHAR2
, P_gestione VARCHAR2
, P_contratto VARCHAR2
, P_ruolo VARCHAR2
, P_posizione VARCHAR2
, P_qualifica number
, P_tipo_rapporto VARCHAR2
, P_ore number
, P_anno number
, P_mese number
, P_mensilita VARCHAR2
, P_ini_ela date
, P_fin_ela date
, P_ini_per date
, P_fin_per date -- Fine periodo di Calcolo *PREVISIONE*
-- Parametri per Trace
, p_trc IN number -- Tipo di Trace
, p_prn IN number -- Numero di Prenotazione elaborazione
, p_pas IN number -- Numero di Passo procedurale
, p_prs IN OUT number -- Numero progressivo di Segnalazione
, p_stp IN OUT VARCHAR2 -- Step elaborato
, p_tim IN OUT VARCHAR2 -- Time impiegato in secondi
);
  PROCEDURE pere_check
( P_ci          number
, P_fin_ela     date
, P_fin_per     date    -- Fine periodo di Calcolo *PREVISIONE*
-- Parametri per Trace
, p_trc    IN     number     -- Tipo di Trace
, p_prn    IN     number     -- Numero di Prenotazione elaborazione
, p_pas    IN     number     -- Numero di Passo procedurale
, p_prs    IN OUT number     -- Numero progressivo di Segnalazione
, p_stp    IN OUT VARCHAR2       -- Step elaborato
, p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCPERP3 IS
form_trigger_failure exception;

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

-- Inserimento Periodi Retributivi da Tavola di Lavoro
PROCEDURE PERE_INSERT
          ( P_ci number
          , P_dal date
          , P_al date
          , P_cong_ind number
          , P_d_cong date
          , P_d_cong_al date
          , P_settore number
          , P_sede number
          , P_figura number
          , P_attivita VARCHAR2
          , P_gestione VARCHAR2
          , P_contratto VARCHAR2
          , P_ruolo VARCHAR2
          , P_posizione VARCHAR2
          , P_qualifica number
          , P_tipo_rapporto VARCHAR2
          , P_ore number
          , P_anno number
          , P_mese number
          , P_mensilita VARCHAR2
          , P_ini_ela date
          , P_fin_ela date
          , P_ini_per date
          , P_fin_per date -- Fine periodo di Calcolo *PREVISIONE*
          -- Parametri per Trace
          , p_trc IN number -- Tipo di Trace
          , p_prn IN number -- Numero di Prenotazione elaborazione
          , p_pas IN number -- Numero di Passo procedurale
          , p_prs IN OUT number -- Numero progressivo di Segnalazione
          , p_stp IN OUT VARCHAR2 -- Step elaborato
          , p_tim IN OUT VARCHAR2 -- Time impiegato in secondi
          ) IS
          D_conguaglio number(1); -- Flag di conguaglio PERIODI_RETRIBUTIVI
          D_trattamento_fisso rapporti_retributivi.trattamento%type;
          D_tipo_trattamento rapporti_retributivi.tipo_trattamento%type;
          D_trattamento rapporti_retributivi.trattamento%type;
          D_dal date; -- Data di inizio rapporto
          D_attuale VARCHAR2(9); -- Stringa identificativa periodo Attuale
          D_sede_del periodi_giuridici.sede_del%type;
          D_anno_del periodi_giuridici.anno_del%type;
          D_num_del periodi_giuridici.numero_del%type;
BEGIN
 BEGIN -- Estrazione del CONGUAGLIO FISCALE per Cessati nel mese
 -- periodo di *PREVISIONE*
 P_stp := 'PERE_INSERT-01';
 select null
   into D_conguaglio
   from periodi_giuridici
  where ci = P_ci
    and rilevanza = 'P'
    and P_fin_ela + 1 between dal + 1
                          and nvl(al,to_date('3333333','j'))
 ;
 peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
      D_conguaglio := '2';
 END;
 BEGIN -- Svuotamento di PERIODI_RETRIBUTIVI del dipendente trattato
 P_stp := 'PERE_INSERT-02';
 delete from periodi_retributivi_bp
       where ci = P_ci
         and periodo = P_fin_ela
 ;
 peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END;
 BEGIN -- Estrazione del Trattamento Previdenziale di Default
 P_stp := 'PERE_INSERT-03';
 BEGIN
 select rare.trattamento, rare.tipo_trattamento
   into D_trattamento_fisso, D_tipo_trattamento
   from rapporti_retributivi rare
  where rare.ci = P_ci
 ;
 EXCEPTION
-- Aggiunto rispetto al calcolo standard per posti vacanti
-- senza rapporto retributivo
 WHEN NO_DATA_FOUND THEN
      D_trattamento_fisso :=     null;
 END;
 IF D_trattamento_fisso is null THEN
 BEGIN
 select trco.trattamento
   into D_trattamento
   from trattamenti_contabili trco
  where trco.posizione = P_posizione
    and trco.tipo_trattamento = nvl(D_tipo_trattamento,0)
    and trco.profilo_professionale
        =
        (select profilo
           from figure_giuridiche
          where numero = P_figura
            and least(nvl(P_al,P_fin_ela),P_fin_ela)
                between nvl(dal,to_date(2222222,'j'))
                    and nvl(al ,to_date(3333333,'j'))
        )
 ;
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
      D_trattamento := null;
 END;
 END IF;
 peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END;
 BEGIN -- Estrazione della data di Inizio Rapporto
 P_stp := 'PERE_INSERT-04.1';
 select dal
   into D_dal
   from rapporti_individuali
  where ci = P_ci
 ;
 peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
      IF P_ci < 99980000 THEN
         RAISE NO_DATA_FOUND;
      ELSE
      -- Posti Vacanti per i quali non esiste rapporti individuale
         D_dal :=     P_dal;
      END IF;
 END;
 BEGIN -- Estrazione del periodo Attuale
 P_stp :=     'PERE_INSERT-04.2';
 select max( to_char(al,'yyyymmdd')||
             decode(servizio,'I','2','Q','1','0')
           )
   into D_attuale
   from calcoli_retributivi
  where ci = P_ci
 ;
 peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END;
 BEGIN -- Inserimento in Periodi Retributivi dei dipendenti
 -- selezionati RAGGRUPPATI per :
 -- Anno, Mese, Dal, Servizio, Competenza
 -- che distingue ogni singolo periodo per
 -- Settore, Sede, Figura, Attivita
 -- Contratto, Gestione, Ruolo, Posizione
 -- Qualifica, Tipo Rapporto, Ore, Trattamento Previdenziale
 -- con calcolo dei (gg.effettivi) - (gg.assenza)
 P_stp :=     'PERE_INSERT-05';
 insert into periodi_retributivi_bp
           ( ci, periodo
           , anno
           , mese
           , flag_reve
           , dal, al
           , servizio
           , competenza
           , conguaglio
           , gg_con, gg_lav, gg_pre, gg_inp, st_inp, gg_af, gg_df, gg_fis
           , gg_rat
           , gg_100, gg_80, gg_66, gg_50, gg_30, gg_sa
           , gg_rid, rap_ore, gg_rap, rap_gg
           , gg_per, per_gg, cod_astensione, gg_nsu
           , quota
           , intero
           , settore, sede, figura, attivita
           , contratto, gestione, ruolo, posizione
           , qualifica, tipo_rapporto, ore, trattamento
           , sede_del, anno_del, numero_del
           , gg_det
           , gg_365
           )
 select P_ci  						    --ci
      , P_fin_ela					   	--periodo
      , care.anno						  --anno
      , decode( care.mese
              , 0, 1
                 , care.mese
              ) 					  	--mese
      , decode( care.mese
              , 0, null
                 , decode( to_char(nvl(min(g_dal),1))||
                           to_char(nvl(max(g_al),31))||
                           to_char(abs(sum(gg_fis)))
                         , '31311', '*'
                                  , null
                         )
              )		    				    --flag_reve
      , min(nvl(care.dal, D_dal))	--dal
      , max(care.al)  				    --al
      , care.servizio			  	    --servizio
      , decode( nvl(aste.rilevanza,1)
/* modifica del 19/06/96 */ -- MIN invece di MAX per PREVISIONE
              , 1, decode( to_char(MIN(care.al),'yyyymmdd')||
/* fine modifica del 19/06/96 */
                           decode(care.servizio,'I','2','Q','1','0')||
                           decode(care.anno,0,'1',to_char(care.anno))||
                           decode(care.mese,0,'1',to_char(care.mese))
                         , D_attuale||to_char(P_anno)||to_char(P_mese)
                         , 'A'
                         , 'C'
                         )
              , 2, lower( decode( to_char(max(care.al),'yyyymmdd')||
                                  decode(care.servizio,'I','2','Q','1','0')||
                                  decode(care.anno,0,'1',to_char(care.anno))||
                                  decode(care.mese,0,'1',to_char(care.mese))
                                , D_attuale||to_char(P_anno)||to_char(P_mese)
                                , 'A'
                                , 'C'
                                )
                        )
              )							--competenza
      , decode( nvl(D_conguaglio,0)
              , 0, decode(max(g_al)
                         ,null, nvl(max(aste.conguaglio),0)
			   	               ,to_char(P_fin_ela,'dd'), nvl(max(aste.conguaglio),0)
                         , 0
                         )
/* modifica del 16/03/2004 */
           -- , D_conguaglio
              , decode( to_char(max(care.al),'yyyymmdd')||
                           decode(care.servizio,'I','2','Q','1','0')||
                           decode(care.anno,0,'1',to_char(care.anno))||
                           decode(care.mese,0,'1',to_char(care.mese))
                         , D_attuale||to_char(P_anno)||to_char(P_mese) , D_conguaglio
/* modifica del 23/09/2004 */
                         , decode( to_char(max(care.al),'yyyymmdd')||
                                   decode(care.servizio,'I','2','Q','1','0')
                                 , D_attuale, D_conguaglio
                                            , 0
                                 )
/* fine modifica del 23/09/2004 */
                         )
/* fine modifica del 16/03/2004 */
              )
      + decode( P_cong_ind, 3, 4, 4, 4, 0)		--conguaglio
      , decode(nvl(aste.rilevanza,1),
               2,0,
                 greatest( 0, sum( care.gg_con
                                 * decode( aste.codice
                                         , '', 1
                                         , decode( aste.servizio
                                                 , 0, -1
                                                 , 0
                                                 )
                                         )
                                 )
                         ) * decode( care.servizio, 'N', -1, 1 )
              )						--gg_con
      , decode(nvl(aste.rilevanza,1),2,0,max(care.gg_lav)) -- gg_lav
      , decode(nvl(aste.rilevanza,1),2,0,
                   greatest( 0, sum( care.gg_pre
                                   * decode( aste.codice, '', 1, -1 )
                                   )
                           )
                   * decode( care.servizio, 'N', -1, 1 )
              )						--gg_pre
      , decode(nvl(aste.rilevanza,1),2,0,
                   greatest( 0, sum( care.gg_inp
                                   * decode( aste.mat_inps
                                           , null, 1
                                           , 1 , 0
                                               , -1
                                           )
                                   )
                           )
                   * decode( care.servizio, 'N', -1, 1 )
              )           --gg_inp
      , decode(nvl(aste.rilevanza,1),2,0,
                   greatest( 0, sum( care.st_inp
                                   * decode( aste.mat_inps
                                           , null, 1
                                           , 1 , 0
                                               , -1
                                           )
                                   )
                           )
                   * decode( care.servizio, 'N', -1, 1 )
              )           --st_inp
      , decode(nvl(aste.rilevanza,1),2,0,
                   greatest( 0, sum( care.gg_af
                                   * decode( aste.mat_assfam
                                           , null, 1
                                           , 1 , 0
                                           , 0 , -1
                                               , ( 100 - nvl(aste.per_ret, 0) ) / 100 * -1
                                           )
                                   )
                           )
                   * decode( care.servizio, 'N', -1, 1 )
              )  --gg_af
      , 0 --gg_df
      , decode(nvl(aste.rilevanza,1),2,0,
                   greatest( 0, sum( care.gg_fis
                                   * decode( aste.detrazioni
                                           , null, 1
                                           , 1 , 0
                                               , -1
                                           )
                                   )
                           )
                   * decode( care.servizio, 'N', -1, 1 )
              )   --gg_fis
      , decode(nvl(aste.rilevanza,1),2,0,
                   greatest( 0, sum( care.gg_fis
                                   * decode( aste.mat_fer
                                           , null, 1
                                           , 1 , 0
                                           , 0 , -1
                                               , ( 100 - nvl(aste.per_ret, 0) ) / 100 * -1
                                           )
                                   )
                           )
                   * decode( care.servizio, 'N', -1, 1 )
              )  		-- gg_rat
      , decode(nvl(aste.rilevanza,1),2,0,
                   greatest( 0, sum( care.gg_con
                                   * decode( aste.per_ret
                                           , null, 1
                                           , 100 , 0
                                                 , -1
                                           )
                                   )
                           )
                   * decode( care.servizio, 'N', -1, 1 )
              ) 									-- gg_100
      , decode(nvl(aste.rilevanza,1),2,0,
                   greatest( 0, sum( care.gg_con
                                   * decode( aste.per_ret, 80, 1, 0 )
                                   )
                           )
                   * decode( care.servizio, 'N', -1, 1 )
              )    								-- gg_80
      , decode(nvl(aste.rilevanza,1),2,0,
                   greatest( 0, sum( care.gg_con
                                   * decode( aste.per_ret
                                           , 66.66, 1
                                           , 66 , 1
                                           , 67 , 1
                                                , 0
                                           )
                                   )
                           )
                   * decode( care.servizio, 'N', -1, 1 )
              ) 									-- gg_66
      , decode(nvl(aste.rilevanza,1),2,0,
                   greatest( 0, sum( care.gg_con
                                   * decode( aste.per_ret, 50, 1, 0 )
                                   )
                           )
                   * decode( care.servizio, 'N', -1, 1 )
              )										-- gg_50
      , decode(nvl(aste.rilevanza,1),2,0,
                   greatest( 0, sum( care.gg_con
                                   * decode( aste.per_ret, 30, 1, 0 )
                                   )
                           )
                   * decode( care.servizio, 'N', -1, 1 )
              ) 									-- gg_30
      , decode(nvl(aste.rilevanza,1),2,0,
                   greatest( 0, sum( care.gg_con
                                   * decode( aste.per_ret
                                           , null , 0
                                           , 100 , 0
                                           , 80 , 0
                                           , 66 , 0
                                           , 66.66, 0
                                           , 67 , 0
                                           , 50 , 0
                                           , 30 , 0
                                                , decode( aste.servizio
                                                        , 0, 0
                                                           , 1
                                                        )
                                           )
                                   )
                           )
                   * decode( care.servizio, 'N', -1, 1 )
              ) 									--gg_sa
      , decode(nvl(aste.rilevanza,1),2,0,
                  ( greatest( 0, sum( care.gg_con
                                    * decode( aste.codice, '', 1, -1 )
                                    )
                            )
                  + greatest( 0, sum( care.gg_con
                                    * nvl( aste.per_ret, 0 ) / 100
                                    )
                            )
                  ) * decode( care.servizio, 'N', -1, 1 )
              )										-- gg_rid
      , decode(nvl(aste.rilevanza,1),2,0,
                   max( care.ore
                      / decode(care.ore_lavoro,0,1,care.ore_lavoro)
                      ) * decode( care.servizio, 'N', -1, 1 )
              )										-- rap_ore
/* modifica del 07/12/2004 */
      , decode(nvl(aste.rilevanza,1),2,0,
                  ( greatest( 0, sum( care.gg_con
                                    * decode( aste.codice, '', 1, -1 )
                                    )
                            ) * max( care.ore
                                   / decode(care.ore_lavoro,0,1,care.ore_lavoro)
                                   * care.rap_mese
                                   * decode( aste.codice, '', 1, 0 )
                                   )                    
                  + greatest( 0, sum( care.gg_con
                                    * nvl( aste.per_ret, 0 ) / 100
                                    * care.ore
                                    / decode(care.ore_lavoro,0,1,care.ore_lavoro)
                                    * care.rap_mese
                                    )
                            )
                  ) * decode( care.servizio, 'N', -1, 1 )
              )	 			--gg_rap
/* eliminato il 07/12/2004
      , decode(nvl(aste.rilevanza,1),2,0,
                  ( greatest( 0, sum( care.gg_con
                                    * decode( aste.codice, '', 1, -1 )
                                    )
                            )
                  + greatest( 0, sum( care.gg_con
                                    * nvl( aste.per_ret, 0 ) / 100
                                    )
                            )
                  ) * max( care.ore
                         / decode(care.ore_lavoro,0,1,care.ore_lavoro)
                         * care.rap_mese
                         )
                    * decode( care.servizio, 'N', -1, 1 )
              )	 			--gg_rap
*/
      ,  decode(nvl(aste.rilevanza,1),2,0,
                  ( greatest( 0, sum( care.gg_con
                                    * decode( aste.codice, '', 1, -1 )
                                    )
                            ) * max( care.ore
                                   / decode(care.ore_lavoro,0,1,care.ore_lavoro)
                                   * care.rap_mese
                                   * decode( aste.codice, '', 1, 0 )
                                   )                    
                  + greatest( 0, sum( care.gg_con
                                    * nvl( aste.per_ret, 0 ) / 100
                                    * care.ore
                                    / decode(care.ore_lavoro,0,1,care.ore_lavoro)
                                    * care.rap_mese
                                    )
                            )
                  ) / max( decode(care.giorni,0,1,care.giorni) )
                    * decode( care.servizio, 'N', -1, 1 )
              ) 							-- rap_gg
/* eliminato il 07/12/2004
      ,  decode(nvl(aste.rilevanza,1),2,0,
                  ( greatest( 0, sum( care.gg_con
                                    * decode( aste.codice, '', 1, -1 )
                                    )
                            )
                  + greatest( 0, sum( care.gg_con
                                    * nvl( aste.per_ret, 0 ) / 100
                                    )
                            )
                  ) * max( care.ore
                         / decode(care.ore_lavoro,0,1,care.ore_lavoro)
                         * care.rap_mese
                         )
                    / max( decode(care.giorni,0,1,care.giorni) )
                    * decode( care.servizio, 'N', -1, 1 )
              ) 							-- rap_gg
*/
/* fine modifica del 07/12/2004 */
      , decode( nvl(aste.rilevanza,1)
                , 1 , 0
                     , least( nvl(max(cost.gg_lavoro),0)
                             , greatest( 0 , sum( care.gg_con
                                                * decode( aste.servizio, 0, 0, 1 )
                                                )
                                        )
                             )
                             * decode( care.servizio, 'N', -1, 1 )
               ) 							-- gg_per
      , decode(nvl(aste.rilevanza,1),1,0,aste.per_ret)			-- per_gg
      , decode(nvl(aste.rilevanza,1),1,'',aste.codice)			-- cod_astensione
      , decode( nvl(aste.rilevanza,1)
                   , 1 , 0
                       , least( nvl(max(cost.gg_lavoro),0)
                                   , greatest( 0
                                             , sum( care.gg_con
                                                  * decode( aste.servizio, 0, 1, 0 )
                                                  )
                                             )
                              )
                              * decode( care.servizio, 'N', -1, 1 )
              )									-- gg_nsu
      , nvl(decode(max(care.ore),0,100,max(care.ore)),0) 		-- quota
      , nvl(decode(max(care.ore),0,100,max(care.ore)),0)			-- intero
      , max(care.settore)							-- settore
      , max(care.sede)									-- sede
      , max(care.figura)								-- figura
      , max(care.attivita)							-- attivita
      , nvl(max(care.contratto),' ')		-- contratto
      , nvl(max(care.gestione),' ')		-- gestione
      , max(care.ruolo) 								-- ruolo
      , max(care.posizione)						-- posizione
      , max(care.qualifica)						-- qualifica
      , max(care.tipo_rapporto)				-- tipo_rapporto
      , nvl(max(care.ore),0)						-- ore
      , nvl( D_trattamento_fisso
           , nvl( max(trco.trattamento), D_trattamento )
           ) 										      -- trattamento
      , max(care.sede_del)							-- sede_del
      , max(care.anno_del)							-- anno_del
      , max(care.numero_del)						-- numero_del
      , decode(nvl(aste.rilevanza,1),2,0,
               greatest( 0, sum( care.gg_det
                               * decode( aste.detrazioni
                                       , null, 1
                                       , 1 , 0
                                       , -1
                                       )
                               )
                       ) * decode( care.servizio, 'N', -1, 1 )
              )									-- gg_det
      , decode( nvl(aste.rilevanza,1)
              , 1, sum(care.gg_365 * decode( aste.codice, '', 1, 0 ))
                 , sum(care.gg_365 * decode( aste.codice, '', 0, 1 ))
              ) * decode( care.servizio, 'N', -1, 1 )             -- gg_365
   from astensioni2 aste
      , contratti_storici cost
      , trattamenti_contabili trco
      , calcoli_retributivi care
  where aste.codice (+) = care.assenza
    and cost.contratto                 =
        (select nvl(care.contratto,qugi.contratto)
           from qualifiche_giuridiche qugi
          where qugi.numero = (select qualifica from periodi_giuridici pegi
                                where pegi.ci = care.ci
                                  and pegi.rilevanza = decode(care.servizio,'I','E','S')
                                  and nvl(care.dal, D_dal)
                                      between nvl(pegi.dal,to_date('2222222','j'))
                                          and nvl(pegi.al,to_date('3333333','j'))
                              )
            and nvl(care.dal, D_dal)
                between nvl(qugi.dal,to_date('2222222','j'))
                    and nvl(qugi.al,to_date('3333333','j'))
        )
    and nvl(care.dal, D_dal)
        between nvl(cost.dal,to_date('2222222','j'))
            and nvl(cost.al,to_date('3333333','j'))
    and trco.profilo_professionale (+) = care.profilo
    and trco.posizione (+) = care.posizione
    and trco.tipo_trattamento (+) = nvl(D_tipo_trattamento,0)
    and care.ci = P_ci
  group by care.anno,care.mese,
           care.dal,
           care.servizio,
           nvl(aste.rilevanza,1),
           decode(nvl(aste.rilevanza,1),1,0,aste.per_ret),
           decode(nvl(aste.rilevanza,1),1,'',aste.codice)
 ;
 peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END;
 BEGIN -- Copia di alcuni dati dal record con competenza maiuscola a
       -- quelli con competenza minuscola
 update periodi_retributivi_bp pere
    set (quota,intero,settore,sede,figura,attivita,contratto,
         gestione,ruolo,posizione,qualifica,tipo_rapporto,
/* eliminazione del 14/12/2004         
         ore,
*/
         trattamento,sede_del,anno_del,numero_del) =
        (select quota,intero,settore,sede,figura,attivita,
                contratto,gestione,ruolo,posizione,qualifica,tipo_rapporto,
/* eliminazione del 14/12/2004         
                ore,
*/
                trattamento,sede_del,anno_del,numero_del
           from periodi_retributivi_bp
          where ci = pere.ci
            and anno = pere.anno
            and mese = pere.mese
            and periodo = pere.periodo
--            and al = last_day(pere.al)
            and dal = pere.dal
            and servizio = pere.servizio
            and (   competenza = upper(pere.competenza)
                 or competenza = 'A' and
                    upper(pere.competenza) = 'C'
                )
     )
  where ci = P_ci
    and periodo = P_fin_ela
    and competenza = lower(competenza)
 ;
 END;
 DECLARE D_anno_pere number(4);
         D_mese_pere number(2);
         D_ini_mes date;
         D_fin_mes date;
 BEGIN -- Inserisce Periodi Retributivi per Posti Vacanti
   IF P_ci >=     99980000 THEN
      D_ini_mes :=     to_date(to_char(greatest(P_dal,P_ini_per),'mmyyyy'),'mmyyyy');
      WHILE to_char(D_ini_mes ,'yyyymm') <=
            to_char(least(nvl(P_al ,to_date('3333333','j')), P_fin_per), 'yyyymm')
      LOOP
      P_stp :=     'PERE_INSERT-05A';
      D_anno_pere :=     to_number(to_char(D_ini_mes ,'yyyy'));
      D_mese_pere :=     to_number(to_char(D_ini_mes ,'mm'));
      D_fin_mes :=     add_months(D_ini_mes,1)-1;
 insert into periodi_retributivi_bp
           ( ci, periodo
           , anno
           , mese
           , dal, al
           , servizio
           , competenza
           , conguaglio
           , gg_con, gg_lav, gg_pre, gg_inp, st_inp, gg_af, gg_df, gg_fis
           , gg_rat
           , gg_100, gg_80, gg_66, gg_50, gg_30, gg_sa
           , gg_rid, rap_ore, gg_rap, rap_gg
           , quota
           , intero
           , settore, sede, figura, attivita
           , contratto, gestione, ruolo, posizione
           , qualifica, tipo_rapporto, ore, trattamento
           , gg_det
           , gg_365
           )
 select P_ci  						--ci
      , P_fin_ela					   	--periodo
      , D_anno_pere					      	--anno
      , D_mese_pere					            --anno
      , greatest(P_dal,D_ini_mes)                           --dal
      , least(nvl(P_al,to_date('3333333','j')),D_fin_mes)   --al
      , 'Q'                                     --servizio
      , 'A'                                     --competenza
      , 0                                       --conguaglio
      , cost.gg_lavoro                          --gg_con
      , decode(cost.gg_lavoro,30,26,1)          --gg_lav
      , decode(cost.gg_lavoro,30,26,0)          --gg_pre
      , 26                                      --gg_inp
      , 0                                       --st_imp
      , decode(cost.gg_lavoro,30,30,26)         --gg_af
      , 0                                       --gg_df
      , 30                                      --gg_fis
      , 30                                      --gg_rat
      , 30, 0, 0, 0, 0, 0                       --gg_100 fino a gg_sa
      , 30                                      --gg_rid 
      , nvl(P_ore,nvl(cost.ore_lavoro,0))
           / decode(nvl(cost.ore_lavoro,0),0,1,cost.ore_lavoro)   --rap_ore
      , nvl(P_ore,nvl(cost.ore_lavoro,0))
           / decode(nvl(cost.ore_lavoro,0),0,1,cost.ore_lavoro)* 30   --gg_rap
      , nvl(P_ore,nvl(cost.ore_lavoro,0))
           / decode(nvl(cost.ore_lavoro,0),0,1,cost.ore_lavoro)* 30   --rap_gg
      , nvl(P_ore,decode( nvl(cost.ore_lavoro,0),0,100,cost.ore_lavoro))   --quota
      , nvl(P_ore,decode( nvl(cost.ore_lavoro,0),0,100,cost.ore_lavoro))   --intero
      , P_settore ,P_sede, P_figura, P_attivita
      , nvl(P_contratto,'%'), nvl(P_gestione,'%')
      , P_ruolo, P_posizione
      , P_qualifica, P_tipo_rapporto
      , nvl(P_ore,nvl(cost.ore_lavoro,0))
      , nvl(D_trattamento_fisso,D_trattamento)
      , to_char(D_fin_mes,'dd')                 --gg_det
      , to_char(D_fin_mes,'dd')                 --gg_365
   from contratti_storici cost
      , rapporti_giuridici ragi
  where cost.contratto (+)=     nvl(ragi.contratto,P_contratto)
    and least(nvl(P_al,P_fin_ela),P_fin_ela)
        between nvl(cost.dal,to_date(2222222,'j'))
            and nvl(cost.al ,to_date(3333333,'j'))
    and ragi.ci=     P_ci
 ;
    D_ini_mes :=     add_months(D_ini_mes,1);
 peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END LOOP;
 END IF;
 END;
 BEGIN -- Ricalcolo settimane INPS
 P_stp := 'PERE_INSERT-05b';
 declare domenica      date;
         sabato        date;
         d_settimane   number(2);
 BEGIN
 FOR CUR_PERE IN
     (select rowid,dal,al,servizio,competenza
        from periodi_retributivi_bp
       where ci = P_ci
         and periodo = P_fin_ela
         and last_day(al) = P_fin_ela
         and servizio = 'Q'
         and competenza in ('A','C')
         and gg_inp != 0
       order by al
     ) LOOP
    BEGIN
    domenica := next_day(last_day(add_months(CUR_PERE.al,-1))-7,'sunday');
    sabato := next_day(last_day(add_months(CUR_PERE.al,-1))-1,'saturday');
    d_settimane := 0;
    WHILE domenica <=  P_fin_ela and to_char(sabato,'yyyy') = P_anno LOOP
     BEGIN
      select d_settimane + 1
        into d_settimane
        from dual x
       where exists
            (select 'x' from periodi_giuridici pegi
              where greatest(pegi.dal,P_ini_ela) <= least(sabato,P_fin_ela)
                and CUR_PERE.al >= domenica
                and pegi.ci = P_ci
                and pegi.rilevanza = 'S'
                and CUR_PERE.al between pegi.dal
                                    and least(nvl(pegi.al,P_fin_ela),P_fin_ela)
            )
         and not exists
            (select 'x' from periodi_retributivi_bp p,
                             periodi_giuridici   g
              where greatest(g.dal,to_date(to_char(p.periodo,'yyyymm'),'yyyymm'))
                 <= least(sabato,P_fin_ela)
                and p.al >= domenica
                and least(p.al,P_fin_ela) < CUR_PERE.al
                and p.periodo in (P_fin_ela, add_months(P_fin_ela,-1))
                and p.servizio= 'Q'
                and p.competenza in ('C','A')
                and p.ci = P_ci
                and g.ci = p.ci
                and g.rilevanza = 'S'
                and p.al between g.dal
                             and least(nvl(g.al,P_fin_ela),P_fin_ela)
                and to_char(sabato,'yyyy') = to_char(domenica,'yyyy')
            )
      ;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN null;
     END;
     domenica := (sabato + 1);
     sabato   := (sabato + 7);
    END LOOP;
    update periodi_retributivi_bp
       set st_inp     = d_settimane
       where ci = P_ci
         and periodo = P_fin_ela
         and al = CUR_PERE.al
         and servizio = 'Q'
         and competenza in ('A','C')
         and rowid      = CUR_PERE.rowid
     ;
   END;
  END LOOP;
 END;
 END;
 BEGIN -- Annulla la prima data di inizio riferimento
 P_stp := 'PERE_INSERT-06';
 update periodi_retributivi_bp x
    set dal = D_dal
  where periodo = P_fin_ela
    and ci = P_ci
    and dal =
        (select min(nvl(dal,to_date(2222222,'j')))
           from periodi_retributivi_bp
          where periodo = P_fin_ela
            and ci = P_ci
        )
 ;
 peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END;
 IF nvl(P_cong_ind,0) != 0 THEN
 BEGIN -- Inserimento (con segno negativo) dei periodi retributivi
 -- non piu'retribuiti in Conguaglio
 P_stp := 'PERE_INSERT-07';
 insert into periodi_retributivi_bp
           ( ci, periodo
           , anno
           , mese
           , flag_reve
           , dal
           , al
           , servizio, competenza
           , conguaglio
           , gg_con, gg_lav, gg_pre, gg_inp, st_inp, gg_af, gg_df, gg_fis, gg_det, gg_365
           , gg_rat
           , gg_100, gg_80, gg_66, gg_50, gg_30, gg_sa
           , gg_rid, rap_ore, gg_rap, rap_gg
           , gg_per, per_gg, cod_astensione, gg_nsu
           , quota, intero
           , gestione, settore, sede
           , figura, attivita
           , contratto, ruolo, posizione
           , qualifica, tipo_rapporto, ore, trattamento
           , rateo_continuativo
           , sede_del,anno_del, numero_del)
 select P_ci
      , P_fin_ela
      , decode ( to_char(al,'yyyy')
               , P_anno, to_char(al,'yyyy')
                       , decode( decode(P_cong_ind,2,'AC',4,'AC','AP')
                               , 'AC', P_anno
                                     , to_char(al,'yyyy')
                               )
               )
      , decode ( to_char(al,'yyyy')
               , P_anno, to_char(al,'mm')
                       , decode( decode(P_cong_ind,2,'AC',4,'AC','AP')
                               , 'AC', 1
                                     , to_char(al,'mm')
                               )
               )
      , max(flag_reve)
      , greatest( dal
                , add_months(last_day(al),-1) + 1
                )
      , max(al)
      , servizio
      , decode(competenza,lower(competenza),'p','P')
      , null
      , sum( gg_con * -1 )
      , to_number(substr(max(to_char(periodo,'yyyymm')||to_char(gg_lav)),7))
      , sum( gg_pre * -1 )
      , sum( gg_inp * -1 )
      , sum( st_inp * -1 )
      , sum( gg_af * -1 )
      , 0
      , sum( gg_fis * -1 )
      , sum( gg_det * -1 )
      , sum( gg_365 * -1 )
      , sum( gg_rat * -1 )
      , sum( gg_100 * -1 )
      , sum( gg_80 * -1 )
      , sum( gg_66 * -1 )
      , sum( gg_50 * -1 )
      , sum( gg_30 * -1 )
      , sum( gg_sa * -1 )
      , sum( gg_rid * -1 )
      , sum( rap_ore * -1 )
      , sum( gg_rap * -1 )
      , sum( rap_gg * -1 )
      , sum( gg_per * -1 )
      , max( per_gg)
      , max( cod_astensione)
      , sum( gg_nsu * -1 )
      , sum( quota * decode(sign(rap_ore),-1,-1,1) ) * -1
           * decode(sign(sum( rap_ore * -1 )),-1,-1,1)
      , intero
      , gestione, settore, sede
      , to_number(substr(max(to_char(periodo,'yyyymm')||to_char(figura)),7))
      ,substr(max(to_char(periodo,'yyyymm')||attivita),7)
      ,substr(max(to_char(periodo,'yyyymm')||contratto),7)
      ,substr(max(to_char(periodo,'yyyymm')||ruolo),7)
      ,substr(max(to_char(periodo,'yyyymm')||posizione),7)
      , to_number(substr(max(to_char(periodo,'yyyymm')||to_char(qualifica)),7))
      ,substr(max(to_char(periodo,'yyyymm')||tipo_rapporto),7)
      , to_number(substr(max(to_char(periodo,'yyyymm')||to_char(ore)),7))
      ,substr(max(to_char(periodo,'yyyymm')||trattamento),7)
      ,max(rateo_continuativo)
      , sede_del,anno_del, numero_del
   from periodi_retributivi_bp  pere /* Da PERE effettivo *PREVISIONE*/
  where ci = P_ci
    and periodo < P_fin_ela
 /* Tratta anche mese corrente *PREVISIONE*/
/* modifica del 28/07/2004 */
--    and competenza != 'D'
/* fine modifica del 28/07/2004 */
    and upper(competenza) in ('A','C')
    and contratto != '*'
    and gestione != '*'
    and trattamento != '*'
    and al >= nvl(P_d_cong, to_date(3333333,'j'))
    and al <= nvl(P_d_cong_al, to_date(3333333,'j'))
/* modifica del 28/07/2004 */
--    and periodo > nvl(P_d_cong, to_date(3333333,'j'))
--    and periodo < nvl(P_d_cong_al, to_date(3333333,'j'))
    and periodo = (select max(periodo)
	               from periodi_retributivi_bp pere2
	 	        where pere2.ci = P_ci
			    and pere2.periodo < P_fin_ela
                      and upper(pere2.competenza) in ('A','C')
			    and to_char(pere2.al,'mmyyyy') = to_char(pere.al,'mmyyyy')
                      and pere2.periodo > nvl(P_d_cong, to_date(3333333,'j'))
                      and pere2.periodo < nvl(P_d_cong_al, to_date(3333333,'j'))
                      and (  gg_con != 0
                          or gg_lav != 1
                          or gg_pre != 0
                          or gg_inp != 0
                          or st_inp != 0
                          or gg_af != 0
                          or gg_fis != 0
                          or gg_det != 0
                          or gg_rat != 0
                          or gg_sa != 0
                          or gg_rid != 0
                          or nvl(gg_per,0) != 0
                          or nvl(gg_nsu,0) != 0
                          ))
/* fine modifica del 28/07/2004 */
    and (  gg_con != 0
        or gg_lav != 1
        or gg_pre != 0
        or gg_inp != 0
        or st_inp != 0
        or gg_af != 0
        or gg_fis != 0
        or gg_det != 0
-- 5/2004 - Avendo attivato il contatore a posteriori anche sui rec. dei ripresi per arretrati
-- non è possibile testarlo per determinare se il record è significativo oppure no - Annalena
--        or gg_365 != 0
        or gg_rat != 0
        or gg_sa != 0
        or gg_rid != 0
        or nvl(gg_per,0) != 0
        or nvl(gg_nsu,0) != 0
        )
  group by to_char(al,'yyyy'), to_char(al,'mm')
         , greatest( dal
                   , add_months(last_day(al),-1) + 1
                   )
         , servizio
         , intero, gestione, settore, sede
         , decode(competenza,lower(competenza),'p','P')
         , per_gg
         , cod_astensione
         , sede_del,anno_del, numero_del
 ;
 peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END;
 BEGIN -- Eliminazione dei rec. di conguaglio non significatvi
 P_stp := 'PERE_INSERT-08b';
 delete from periodi_retributivi_bp
       where ci = P_ci
         and periodo = P_fin_ela
         and upper(competenza) = 'P'
         and gg_lav = 1
         and gg_con = 0
         and gg_pre = 0
         and gg_inp = 0
         and st_inp = 0
         and gg_af = 0
         and gg_fis = 0
         and gg_det = 0
         and gg_365 = 0
         and gg_rat = 0
         and gg_sa = 0
         and gg_rid = 0
         and nvl(gg_per,0) = 0
         and nvl(gg_nsu,0) = 0
 ;
 delete from periodi_retributivi_bp
       where ci = P_ci
         and periodo = P_fin_ela
         and upper(competenza) = 'P'
         and gg_lav > 1
         and gg_con = 0
         and gg_pre = 0
         and gg_inp = 0
         and st_inp = 0
         and gg_af = 0
         and gg_fis = 0
         and gg_det = 0
         and gg_365 = 0
         and gg_rat = 0
         and gg_sa = 0
         and gg_rid = 0
         and nvl(gg_per,0) = 0
         and nvl(gg_nsu,0) = 0
         and gg_100 = 0
         and gg_80 = 0
         and gg_66 = 0
         and gg_50 = 0
         and gg_30 = 0
         and gg_rap = 0
         and rap_ore= 0
         and rap_gg = 0
         and quota = 0
 ;
 peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END;
 BEGIN -- Eliminazione dei rec. di conguaglio non significatvi
 -- elimina i rec. prodotti in caso di cong. di cong. AP
 -- con fiscale corrente
 P_stp := 'PERE_INSERT-08c';
 delete from periodi_retributivi_bp x
       where ci = P_ci
         and periodo = P_fin_ela
         and upper(competenza) = 'P'
         and gg_con = 0
         and gg_pre = 0
         and gg_inp = 0
         and st_inp = 0
         and gg_af = 0
         and gg_fis = 0
         and gg_det = 0
         and gg_365 = 0
         and gg_rat = 0
         and gg_sa = 0
         and gg_rid = 0
         and nvl(gg_per,0) = 0
         and nvl(gg_nsu,0) = 0
         and exists (select 'x' from periodi_retributivi_bp
                               where ci = x.ci
                                 and periodo = x.periodo
                                 and competenza = x.competenza
                                 and dal <= x.al
                                 and al >= x.dal
                                 and rowid != x.rowid
                    )
 ;
 peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END;
 BEGIN -- Riporto delle forzature manuali sui periodi ricalcolati
 -- per conguaglio
 -- Se Flag_reve di competenza attuale contiene '*'
 -- sono periodi a conguaglio Anno Corrente
 P_stp := 'PERE_INSERT-08';
 update periodi_retributivi_bp pere
    set ( anno
        , mese
        , flag_reve
        , gg_con, gg_lav, gg_pre, gg_inp, st_inp, gg_af, gg_df, gg_fis, gg_det, gg_365
        , gg_rat
        , gg_100, gg_80, gg_66, gg_50, gg_30, gg_sa
        , gg_rid, rap_ore, gg_rap, rap_gg
        , trattamento
        ) =
          (select decode( pere.flag_reve
                        , '*', pere.anno
                             , max(anno)
                        )
                , decode( pere.flag_reve
                        , '*', pere.mese
                             , max(mese)
                        )
                , '*'
                , sum( gg_con * -1 )
                , max( gg_lav )
                , sum( gg_pre * -1 )
                , sum( gg_inp * -1 )
                , sum( st_inp * -1 )
                , sum( gg_af * -1 )
                , 0
                , sum( gg_fis * -1 )
                , sum( gg_det * -1)
                , sum( gg_365 * -1)
                , sum( gg_rat * -1 )
                , sum( gg_100 * -1 )
                , sum( gg_80 * -1 )
                , sum( gg_66 * -1 )
                , sum( gg_50 * -1 )
                , sum( gg_30 * -1 )
                , sum( gg_sa * -1 )
                , sum( gg_rid * -1 )
                , sum( rap_ore * -1 )
                , sum( gg_rap * -1 )
                , sum( rap_gg * -1 )
                , max(trattamento)
             from periodi_retributivi_bp
            where ci = P_ci
              and periodo = P_fin_ela
              and al = pere.al
               -- and ( dal = pere.dal -- 20/10/95
               -- or dal = D_dal
               -- )
              and servizio = pere.servizio
              and competenza = 'P'
              and flag_reve = '*'
          )
  where ci = P_ci
    and periodo = P_fin_ela
    and competenza in ('C','A')
    and exists
        (select 'x'
           from periodi_retributivi_bp
          where ci = P_ci
            and periodo = P_fin_ela
            and al = pere.al
             -- and ( dal = pere.dal -- 20/10/95
             -- or dal = D_dal
             -- )
            and servizio = pere.servizio
            and competenza = 'P'
            and flag_reve = '*'
        )
 ;
 END;
 END IF;
 BEGIN -- Lettura dell'ultima presenza rispetto alla data elab.
 P_stp := 'PERE_INSERT-09.0';
 select max(decode(confermato,1,sede_del,null))
      , max(decode(confermato,1,anno_del,null))
      , max(decode(confermato,1,numero_del,null))
   into D_sede_del
      , D_anno_del
      , D_num_del
   from periodi_giuridici
  where ci = P_ci
    and rilevanza = 'P'
    and dal =
        (select max(dal) from periodi_giuridici
                        where ci = P_ci
                          and rilevanza = 'P'
                          and dal <= P_fin_ela
        )
 ;
 END;
 BEGIN -- Inserimento Periodo Fittizio per Ripresi per arretrati
 -- e per individui senza periodi
 P_stp := 'PERE_INSERT-09';
 insert into periodi_retributivi_bp
             ( ci, periodo
             , anno, mese
             , dal, al
             , servizio, competenza
             , conguaglio
             , gg_con, gg_lav, gg_pre, gg_inp, st_inp, gg_af, gg_df, gg_fis
             , gg_rat
             , gg_100, gg_80, gg_66, gg_50, gg_30, gg_sa
             , gg_rid
             , rap_ore
             , gg_rap, rap_gg
             , quota
             , intero
             , settore, sede, figura, attivita
             , contratto, gestione, ruolo, posizione
             , qualifica, tipo_rapporto
             , ore
             , trattamento
             , sede_del
             , anno_del
             , numero_del
             , gg_det
             , gg_365
             , tipo
             )
 select P_ci, P_fin_ela
      , P_anno, P_mese
      , D_dal, nvl(P_al, P_fin_ela)
      , 'Q', 'A'
      , decode( P_cong_ind, 3, 7, 4, 7, 3)
      , 0, 1, 0, 0, 0, 0, 0, 0
      , 0
      , 0, 0, 0, 0, 0, 0
      , 0
      , nvl(P_ore,nvl(cost.ore_lavoro,0))
        / decode(nvl(cost.ore_lavoro,0),0,1,cost.ore_lavoro)
      , 0, 0
      , nvl( decode( P_ore
                   , 0, ''
                      , P_ore)
      ,decode( nvl(cost.ore_lavoro,0)
             , 0, 100
                , cost.ore_lavoro))
      , nvl( decode( P_ore
                   , 0, ''
                      , P_ore)
           ,decode( nvl(cost.ore_lavoro,0)
                   , 0, 100
                      , cost.ore_lavoro))
      , P_settore, P_sede, P_figura, P_attivita
      , nvl(P_contratto,'%'), nvl(P_gestione,'%')
      , P_ruolo, P_posizione
      , P_qualifica, P_tipo_rapporto
      , nvl(P_ore,nvl(cost.ore_lavoro,0))
      , nvl(D_trattamento_fisso,D_trattamento)
      , D_sede_del
      , D_anno_del
      , D_num_del
      , 0
      , 0
      , 'R'
   from contratti_storici cost
      , rapporti_giuridici ragi
  where cost.contratto (+) = nvl(ragi.contratto,P_contratto)
    and least(nvl(P_al,P_fin_ela),P_fin_ela)
        between nvl(cost.dal,to_date(2222222,'j'))
            and nvl(cost.al ,to_date(3333333,'j'))
    and ragi.ci = P_ci
    and not exists
           (select 'x'
              from periodi_retributivi_bp
             where ci = P_ci
               and periodo = P_fin_ela
               and competenza in('C','A')
           )
 ;
 peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END;
 BEGIN -- Inserimento Periodo Fittizio per chi non ha giornate
 -- del mese di RIFERIMENTO_RETRIBUZIONE
 -- pur avendo registrazioni dei mesi precedenti
 P_stp := 'PERE_INSERT-10';
 insert into periodi_retributivi_bp
             ( ci, periodo
             , anno, mese
             , dal, al
             , servizio, competenza
             , conguaglio
             , gg_con, gg_lav, gg_pre, gg_inp, st_inp, gg_af, gg_df, gg_fis
             , gg_rat
             , gg_100, gg_80, gg_66, gg_50, gg_30, gg_sa
             , gg_rid
             , rap_ore
             , gg_rap, rap_gg
             , quota
             , intero
             , settore, sede, figura, attivita
             , contratto, gestione, ruolo, posizione
             , qualifica, tipo_rapporto
             , ore
             , trattamento
             , gg_det
             , gg_365
             , tipo
             )
 select P_ci, P_fin_ela
      , P_anno, P_mese
      , P_ini_ela, P_fin_ela
      , 'Q', 'A'
/* modifica del 23/09/2004 */
      , 0
-- l'indicatore di conguaglio è spostato in CARE_INSERT-05
--      , decode( D_conguaglio
--              , 2, decode( P_cong_ind, 3, 6, 4, 6, 2)
--                 , decode( P_cong_ind, 3, 7, 4, 7, 3)
--              )
/* fine modifica del 23/09/2004 */
      , 0, 1, 0, 0, 0, 0, 0, 0
      , 0
      , 0, 0, 0, 0, 0, 0
      , 0
      , nvl(P_ore,nvl(cost.ore_lavoro,0))
        / decode(nvl(cost.ore_lavoro,0),0,1,cost.ore_lavoro)
      , 0, 0
      , nvl( decode( P_ore
                   , 0, ''
                      , P_ore)
      ,decode( nvl(cost.ore_lavoro,0)
                  , 0, 100
                     , cost.ore_lavoro))
      , nvl( decode( P_ore
                   , 0, ''
                      , P_ore)
      ,decode( nvl(cost.ore_lavoro,0)
                  , 0, 100
                     , cost.ore_lavoro))
      , P_settore, P_sede, P_figura, P_attivita
      , nvl(P_contratto,'%'), nvl(P_gestione,'%')
      , P_ruolo, P_posizione
      , P_qualifica, P_tipo_rapporto
      , nvl(P_ore,nvl(cost.ore_lavoro,0))
      , nvl(D_trattamento_fisso,D_trattamento)
      , 0
      , 0
      , 'F'
   from contratti_storici cost
      , rapporti_giuridici ragi
  where cost.contratto (+) = nvl(ragi.contratto,P_contratto)
    and least(nvl(P_al,P_fin_ela),P_fin_ela)
        between nvl(cost.dal,to_date(2222222,'j'))
            and nvl(cost.al ,to_date(3333333,'j'))
    and ragi.ci = P_ci
    and not exists
        (select 'x'
           from periodi_retributivi_bp
          where ci = P_ci
            and periodo = P_fin_ela
            and anno = P_anno
            and mese = P_mese
        )
 ;
 peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END;
 BEGIN -- Inserimento Diversa attribuzione Contabile
 P_stp := 'PERE_INSERT-11';
 FOR CURP IN
 (select pere.anno
       , pere.mese
       , decode( pere.dal
               , D_dal, decode
                        ( greatest
                          ( nvl(asco.dal,to_date('2222222','j'))
                          , to_date( to_char(pere.anno)||
                            to_char(pere.mese),'yyyymm')
                          )
                        , asco.dal, asco.dal
                                  , D_dal
                        )
                        , greatest
                          ( pere.dal
                          , nvl(asco.dal,to_date('2222222','j'))
                          )
               ) dal
       , least( pere.al
              , nvl(asco.al, to_date('3333333','j'))
              ) al
       , pere.servizio
       , pere.rap_ore
       , asco.quota, asco.intero
       , asco.settore asco_settore, asco.sede asco_sede
       , pere.settore pere_settore, pere.sede pere_sede
       , pere.figura, pere.attivita
       , pere.contratto
       , pere.gestione pere_gestione, sett.gestione asco_gestione
       , pere.ruolo, pere.posizione
       , pere.qualifica, pere.tipo_rapporto, pere.ore
       , pere.trattamento
       , pere.sede_del, pere.anno_del, pere.numero_del
    from periodi_retributivi_bp pere
       , assegnazioni_contabili asco
       , settori sett
   where sett.numero(+) = asco.settore
     and nvl(asco.dal,to_date('2222222','j'))
         <= pere.al
     and nvl(asco.al,to_date('3333333','j'))
         >= decode( pere.dal
                  , D_dal, to_date( to_char(pere.anno)||
                                    to_char(pere.mese), 'yyyymm')
                         , pere.dal
                  )
     and asco.ci = pere.ci
     and pere.ci = P_ci
     and pere.periodo = P_fin_ela
     and pere.competenza in ('C','A')
 )
 LOOP
 BEGIN -- Registrazione in positivo su nuova Attribuzione
 insert into periodi_retributivi_bp
           ( ci, periodo
           , anno, mese
           , dal, al
           , servizio, competenza
           , gg_con, gg_lav, gg_pre, gg_inp, st_inp, gg_af, gg_df, gg_fis
           , gg_rat
           , gg_100, gg_80, gg_66, gg_50, gg_30, gg_sa
           , gg_rid, rap_ore, gg_rap, rap_gg
           , quota, intero
           , settore, sede
           , figura, attivita
           , contratto, gestione
           , ruolo, posizione
           , qualifica, tipo_rapporto, ore
           , trattamento
           , sede_del, anno_del, numero_del
           , gg_det
           , gg_365
           )
 values
           ( P_ci, P_fin_ela
           , curp.anno, curp.mese
           , curp.dal, curp.al
           , curp.servizio, 'D'
           , 0, 0, 0, 0, 0, 0, 0, 0
           , 0, 0, 0, 0, 0, 0, 0
           , 0, sign(curp.rap_ore), 0, 0
           , curp.quota, curp.intero
           , curp.asco_settore, curp.asco_sede
           , curp.figura, curp.attivita
           , curp.contratto, curp.asco_gestione
           , curp.ruolo, curp.posizione
           , curp.qualifica, curp.tipo_rapporto, curp.ore
           , curp.trattamento
           , curp.sede_del, curp.anno_del, curp.numero_del
           , 0
           , 0
           )
 ;
 END;
 BEGIN -- Registrazione in negativo su Attribuzione di servizio
 insert into periodi_retributivi_bp
             ( ci, periodo
             , anno, mese
             , dal, al
             , servizio, competenza
             , gg_con, gg_lav, gg_pre, gg_inp, st_inp, gg_af, gg_df, gg_fis
             , gg_rat
             , gg_100, gg_80, gg_66, gg_50, gg_30, gg_sa
             , gg_rid, rap_ore, gg_rap, rap_gg
             , quota, intero
             , settore, sede
             , figura, attivita
             , contratto, gestione
             , ruolo, posizione
             , qualifica, tipo_rapporto, ore
             , trattamento
             , sede_del, anno_del, numero_del
             , gg_det
             , gg_365
             )
 values
             ( P_ci, P_fin_ela
             , curp.anno, curp.mese
             , curp.dal, curp.al
             , curp.servizio, 'D'
             , 0, 0, 0, 0, 0, 0, 0, 0
             , 0, 0, 0, 0, 0, 0, 0
             , 0, sign(curp.rap_ore), 0, 0
             , curp.quota * -1, curp.intero
             , curp.pere_settore, curp.pere_sede
             , curp.figura, curp.attivita
             , curp.contratto, curp.pere_gestione
             , curp.ruolo, curp.posizione
             , curp.qualifica, curp.tipo_rapporto, curp.ore
             , curp.trattamento
             , curp.sede_del, curp.anno_del, curp.numero_del
             , 0
             , 0
             )
 ;
 END;
 END LOOP;
 peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
 END;
EXCEPTION
 WHEN FORM_TRIGGER_FAILURE THEN
 RAISE;
 WHEN OTHERS THEN
 peccperp.err_trace( P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim );
 RAISE FORM_TRIGGER_FAILURE;
END;
-- Verifica Calcolo giornate retributive
PROCEDURE pere_check
        ( P_ci          number
        , P_fin_ela     date
        , P_fin_per date -- Fine periodo di Calcolo *PREVISIONE*
        -- Parametri per Trace
        , p_trc    IN     number     -- Tipo di Trace
        , p_prn    IN     number     -- Numero di Prenotazione elaborazione
        , p_pas    IN     number     -- Numero di Passo procedurale
        , p_prs    IN OUT number     -- Numero progressivo di Segnalazione
        , p_stp    IN OUT VARCHAR2       -- Step elaborato
        , p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
        ) IS
        D_gg_100     periodi_retributivi.gg_100%type;
        D_gg_80      periodi_retributivi.gg_80%type;
        D_gg_66      periodi_retributivi.gg_66%type;
        D_gg_50      periodi_retributivi.gg_50%type;
        D_gg_30      periodi_retributivi.gg_30%type;
        D_gg_sa      periodi_retributivi.gg_sa%type;
        D_gg_con     periodi_retributivi.gg_con%type;
        D_gg_rid     periodi_retributivi.gg_rid%type;
        D_gg_rap     periodi_retributivi.gg_rap%type;
        D_rap_gg     periodi_retributivi.rap_gg%type;
        D_gg_per     periodi_retributivi.gg_rap%type;
        D_tot_gg_con periodi_retributivi.gg_con%type;
        D_se_update  number(1);
BEGIN
   BEGIN
        update periodi_retributivi_bp pere
           set rateo_continuativo = 1
        where periodo = P_fin_ela
          and ci = P_ci
          and exists (select 'x' from periodi_giuridici
                       where ci = pere.ci
                         and rilevanza = 'P'
                         and greatest( pere.dal
                                     , to_date(to_char(pere.al,'yyyymm'),'yyyymm')
                                     )
                          <= nvl(al,to_date('3333333','j'))
                         and pere.al >= dal
                         and least( nvl(al,to_date('3333333','j'))
                                  , last_day(to_date(to_char(pere.al,'yyyymm'),'yyyymm')
                                            )
                                  )
                             -
                             greatest( dal
                                     , to_date(to_char(pere.al,'yyyymm'),'yyyymm')
                                     )
                             + 1 >= 15
                     )
                ;
   END;
   BEGIN  -- Verifica se giorni alle diverse % sono maggiori
          -- dei giorni contrattuali previsti per ogni singolo mese
      P_stp := 'PERE_CHECK-01';
      FOR CURR IN
         (select pere.gg_100
               , pere.gg_80
               , pere.gg_66
               , pere.gg_50
               , pere.gg_30
               , pere.gg_sa
               , pere.gg_rid
               , pere.gg_con
               , pere.rap_ore
               , cost.gg_lavoro
               , pere.rowid
               , pere.al
            from contratti_storici cost
               , periodi_retributivi_bp pere
           where cost.contratto = pere.contratto
             and pere.al between nvl(cost.dal,to_date('2222222','j'))
                             and nvl(cost.al ,to_date('3333333','j'))
             and pere.ci          = P_ci
             and pere.periodo     = P_fin_ela
             and pere.al          = last_day(to_date(to_char(pere.anno)||to_char(pere.mese),'yyyymm'))
             and pere.competenza in ('C','A')
             and exists (select 'x'
                           from contratti_storici cost2
                              , periodi_retributivi_bp pere2
                          where cost2.contratto = pere2.contratto
                            and pere2.al between nvl(cost2.dal,to_date('2222222','j'))
                                             and nvl(cost2.al ,to_date('3333333','j'))
                            and pere2.ci          = P_ci
--                            and pere2.anno        = pere.anno
--                            and pere2.mese        = pere.mese
                            and to_char(pere2.al,'yyyy') = pere.anno
                            and to_char(pere2.al,'mm')   = pere.mese
                            and pere2.periodo     = P_fin_ela
                            and pere2.competenza in ('C','A')
                         having sum(nvl(pere2.gg_100,0) + nvl(pere2.gg_80,0) +
                                    nvl(pere2.gg_66,0) + nvl(pere2.gg_50,0)  +
                                    nvl(pere2.gg_30,0) + nvl(pere2.gg_sa,0)) >
                                sum(pere2.gg_con)
                             or sum(decode(pere2.servizio,'N',0,pere2.gg_rid)) >
                                sum(decode(pere2.servizio,'N',0,pere2.gg_con))
/* Eliminato per il calcolo in 31esimi dei NDR
                             or sum(nvl(pere2.gg_100,0) + nvl(pere2.gg_80,0) +
                                    nvl(pere2.gg_66,0) + nvl(pere2.gg_50,0)  +
                                    nvl(pere2.gg_30,0) + nvl(pere2.gg_sa,0)) >
                                max(cost2.gg_lavoro)
*/
                            )
--             and (   pere.gg_100 + pere.gg_80 + pere.gg_66 +
--                     pere.gg_50  + pere.gg_30 + pere.gg_sa > gg_con
--                  or pere.gg_rid > pere.gg_con and pere.servizio != 'N'
--                 )
         ) LOOP
         P_stp := '!!! gg. #'||to_char(P_ci);
         peccperp.log_trace(7,P_prn,P_pas,P_prs,P_stp,0,P_tim);
         peccperp.errore := 'P05828';  -- Giornate da Verificare
         BEGIN  -- Rettifica Giornate assegnando preferenza a quelle a
                -- percentuale piu` bassa, evitando, se possibile, di
                -- portare a zero il contatore.
                -- Rettifica anche di gg_con se > cost.gg_lavoro
            P_stp := 'PERE_CHECK-02';
            D_gg_100 := curr.gg_100;
            D_gg_80  := curr.gg_80;
            D_gg_66  := curr.gg_66;
            D_gg_50  := curr.gg_50;
            D_gg_30  := curr.gg_30;
            D_gg_sa  := curr.gg_sa;
            D_gg_con := curr.gg_con;
            D_gg_rid := curr.gg_rid;
            BEGIN
            select sum(pere.gg_con)
              into d_tot_gg_con
              from contratti_storici cost
                 , periodi_retributivi_bp pere
             where cost.contratto = pere.contratto
               and pere.al between nvl(cost.dal,to_date('2222222','j'))
                               and nvl(cost.al ,to_date('3333333','j'))
               and pere.ci          = P_ci
               and pere.periodo     = P_fin_ela
               and pere.competenza in ('C','A')
               and to_char(curr.al,'yyyy') = pere.anno
               and to_char(curr.al,'mm')   = pere.mese
            ;
            END;
            IF    D_tot_gg_con > curr.gg_lavoro THEN D_gg_con := D_gg_con - 1;
            END IF; 
          IF    D_gg_100+D_gg_80+D_gg_66+D_gg_50+D_gg_30+D_gg_sa > curr.gg_con THEN
            IF    D_gg_sa  > 1 THEN D_gg_sa  := D_gg_sa  - 1;
            ELSIF D_gg_30  > 1 THEN D_gg_30  := D_gg_30  - 1;
                                    D_gg_rid := D_gg_rid - ( 1*30/100);
            ELSIF D_gg_50  > 1 THEN D_gg_50  := D_gg_50  - 1;
                                    D_gg_rid := D_gg_rid - ( 1*50/100);
            ELSIF D_gg_66  > 1 THEN D_gg_66  := D_gg_66  - 1;
                                    D_gg_rid := D_gg_rid - ( 1*66.66/100);
            ELSIF D_gg_80  > 1 THEN D_gg_80  := D_gg_80  - 1;
                                    D_gg_rid := D_gg_rid - ( 1*80/100);
            ELSIF D_gg_100 > 1 THEN D_gg_100 := D_gg_100 - 1;
                                    D_gg_rid := D_gg_rid - 1;
            ELSIF D_gg_sa  > 0 THEN D_gg_sa  := D_gg_sa  - 1;
            ELSIF D_gg_30  > 0 THEN D_gg_30  := D_gg_30  - 1;
                                    D_gg_rid := D_gg_rid - ( 1*30/100);
            ELSIF D_gg_50  > 0 THEN D_gg_50  := D_gg_50  - 1;
                                    D_gg_rid := D_gg_rid - ( 1*50/100);
            ELSIF D_gg_66  > 0 THEN D_gg_66  := D_gg_66  - 1;
                                    D_gg_rid := D_gg_rid - ( 1*66.66/100);
            ELSIF D_gg_80  > 0 THEN D_gg_80  := D_gg_80  - 1;
                                    D_gg_rid := D_gg_rid - ( 1*80/100);
            ELSIF D_gg_100 > 0 THEN D_gg_100 := D_gg_100 - 1;
                                    D_gg_rid := D_gg_rid - 1;
            END IF;
          END IF;
            IF    D_gg_rid > curr.gg_con THEN D_gg_rid := curr.gg_con;
            END IF;
            D_gg_rap := round(D_gg_rid * abs(curr.rap_ore), 6);
            IF curr.gg_lavoro = 0 THEN
               D_rap_gg := D_gg_rap;
            ELSE
               D_rap_gg := round(D_gg_rap / curr.gg_lavoro, 6);
            END IF;
            peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;
         BEGIN  -- Aggiorna Registrazione Giornate
            P_stp := 'PERE_CHECK-03';
            update periodi_retributivi_bp
               set gg_100 = D_gg_100
                 , gg_80  = D_gg_80
                 , gg_66  = D_gg_66
                 , gg_50  = D_gg_50
                 , gg_30  = D_gg_30
                 , gg_sa  = D_gg_sa
                 , gg_rid = D_gg_rid
                 , gg_rap = D_gg_rap
                 , rap_gg = D_rap_gg
                 , gg_con = D_gg_con
             where rowid = curr.rowid
            ;
            peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;
      END LOOP;
   END;
   BEGIN  -- Verifica se i giorni di eventuali record di assenza sono
          -- diversi dai corrispondenti giorni alla medesima percentuale
          -- del mese
            P_stp := 'PERE_CHECK-04';
      FOR CURRA IN
         (select pere.anno
               , pere.mese
               , pere.dal
               , sum(pere.gg_per) gg_per
               , decode(pere.per_gg,100,100,80,80,66,66,66.66,66,67,66,50,50,30,30,0) per_gg
               , min(pere.rowid) pere_rowid
               , max(sel_pere2.gg_100) gg_100
               , max(sel_pere2.gg_80) gg_80
               , max(sel_pere2.gg_66) gg_66
               , max(sel_pere2.gg_50) gg_50
               , max(sel_pere2.gg_30) gg_30
               , max(sel_pere2.gg_sa) gg_sa
            from periodi_retributivi_bp pere
               , (select anno,mese,dal,competenza,
                         sum(gg_100) gg_100,
                         sum(gg_80) gg_80,
                         sum(gg_66) gg_66,
                         sum(gg_50) gg_50,
                         sum(gg_30) gg_30,
                         sum(gg_sa) gg_sa
                    from periodi_retributivi_bp pere2
                   where pere2.ci = P_ci
                     and pere2.periodo = P_fin_ela
                     and pere2.competenza in ('A','C')
                   group by pere2.anno,pere2.mese,pere2.dal,pere2.competenza) sel_pere2 
           where pere.ci          = P_ci
             and pere.periodo     = P_fin_ela
             and pere.competenza in ('c','a')
             and pere.anno = sel_pere2.anno
             and pere.mese = sel_pere2.mese
             and pere.dal  = sel_pere2.dal
             and pere.competenza = lower(sel_pere2.competenza)
           group by pere.anno,pere.mese,pere.dal,
                    decode(pere.per_gg,100,100,80,80,66,66,66.66,66,67,66,50,50,30,30,0)
         ) LOOP
         BEGIN  -- Rettifica Giornate delle assenze se diverse dai relativi
                -- gg del record a competenza maiuscola per la medesima percentuale
            P_stp := 'PERE_CHECK-05';
            D_se_update := 0;
            IF    curra.per_gg = 100 and
                  curra.gg_per > curra.gg_100 THEN D_se_update := 1;
            ELSIF curra.per_gg = 80 and
                  curra.gg_per != curra.gg_80 THEN D_se_update := 1;
            ELSIF curra.per_gg = 66 and
                  curra.gg_per != curra.gg_66 THEN D_se_update := 1;
            ELSIF curra.per_gg = 50 and
                  curra.gg_per != curra.gg_50 THEN D_se_update := 1;
            ELSIF curra.per_gg = 30 and
                  curra.gg_per != curra.gg_30 THEN D_se_update := 1; 
            ELSIF curra.per_gg = 0 and
                  curra.gg_per != curra.gg_sa THEN D_se_update := 1;         
            END IF;
            peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
         END;
         BEGIN  -- Aggiorna Registrazione Giornate
            P_stp := 'PERE_CHECK-06';
            IF D_se_update = 1 THEN
            update periodi_retributivi_bp
               set gg_per = gg_per - 1
             where rowid = curra.pere_rowid
            ;
            P_stp := '!!! gg. #'||to_char(P_ci);
            peccperp.log_trace(7,P_prn,P_pas,P_prs,P_stp,0,P_tim);
            peccperp.errore := 'P05828';  -- Giornate da Verificare
            END IF;
            peccperp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
         END;
      END LOOP;
   END;
EXCEPTION
   WHEN FORM_TRIGGER_FAILURE THEN
      RAISE;
   WHEN OTHERS THEN
      peccperp.err_trace( P_trc, P_prn, P_pas, P_prs, P_stp, 0, P_tim );
      RAISE FORM_TRIGGER_FAILURE;
END;
END;
/
