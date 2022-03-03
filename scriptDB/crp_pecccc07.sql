CREATE OR REPLACE PACKAGE PECCCC07 IS
/******************************************************************************
 NOME:        PECCCC07
 DESCRIZIONE: CONGUAGLIO PER CASSA COMPETENZA ATTIVATA IN RITARDO.
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    12/09/2007   NN   Prima emissione
******************************************************************************/
FUNCTION  VERSIONE                RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCCC07 IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1 del 12/09/2007';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
begin
declare
  D_anno_cong                 number;
  D_mese_cong                 number;
  D_mensilita_cong            varchar2(3);
  D_anno_elab                 number;
  D_mese_elab                 number;
  D_mensilita_elab            varchar2(3);
  D_rapporto                  varchar2(4);
  D_gestione                  varchar2(8);
  D_contratto                 varchar2(4);
  D_qualifica                 varchar2(8);
  D_livello                   varchar2(4);
  D_variabili                 varchar2(1);
  D_fin_ela                   date;
  w_prenotazione              number(10):=0;
  w_passo                     number(5):=0;
  w_utente                    varchar2(10);
  w_ambiente                  varchar2(10);
  w_ente                      varchar2(10);
  D_controllo_mensilita       number;
  D_riga                      number:=0;
  USCITA                      exception;
BEGIN
  BEGIN
    select valore
      into D_anno_cong
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_ANNO_CONG';
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select valore
      into D_mese_cong
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_MESE_CONG';
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select valore
      into D_mensilita_cong
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_MENSILITA_CONG';
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select valore
      into D_anno_elab
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_ANNO_ELAB';
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select valore
      into D_mese_elab
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_MESE_ELAB';
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select valore
      into D_mensilita_elab
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_MENSILITA_ELAB';
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select nvl(valore,'%')
      into D_rapporto
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_RAPPORTO';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
           D_rapporto      := '%';
  END;
  BEGIN
    select nvl(valore,'%')
      into D_gestione
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_GESTIONE';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
           D_gestione      := '%';
  END;
  BEGIN
    select nvl(valore,'%')
      into D_contratto
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_CONTRATTO';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
           D_contratto     := '%';
  END;
  BEGIN
    select nvl(valore,'%')
      into D_qualifica
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_QUALIFICA';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
           D_qualifica     := '%';
  END;
  BEGIN
    select nvl(valore,'%')
      into D_livello
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_LIVELLO';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
           D_livello       := '%';
  END;
  BEGIN
    select valore
      into D_variabili
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro   = 'P_VARIABILI';
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select fin_mese
      into D_fin_ela
      from mesi
     where anno = D_anno_elab
       and mese = D_mese_elab;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;

   BEGIN -- controllo mensilita' elab inesistente
        select 1
          into D_controllo_mensilita
          from MENSILITA
         where mese      = D_mese_elab
           and mensilita = D_mensilita_elab
        ;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  D_riga := D_riga + 1;
                  INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                                   ,errore,precisazione)
                  VALUES (prenotazione,1,D_riga,'P05510',': '||D_mese_elab||' '||D_mensilita_elab);
                  update a_prenotazioni set prossimo_passo  = 91
                                          , errore          = 'P05808'
                   where no_prenotazione = prenotazione
                  ;
                  COMMIT;
        RAISE uscita;
   END;   -- controllo mensilita' elab inesistente

   BEGIN -- controllo mensilita' cong inesistente
        select 1
          into D_controllo_mensilita
          from MENSILITA
         where mese      = D_mese_cong
           and mensilita = D_mensilita_cong
        ;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  D_riga := D_riga + 1;
                  INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                                   ,errore,precisazione)
                  VALUES (prenotazione,1,D_riga,'P05510',': '||D_mese_cong||' '||D_mensilita_cong);
                  update a_prenotazioni set prossimo_passo  = 91
                                          , errore          = 'P05808'
                   where no_prenotazione = prenotazione
                  ;
                  COMMIT;
        RAISE uscita;
   END;   -- controllo mensilita' cong inesistente

   BEGIN -- controllo mensilita' già elaborata (successiva o uguale a quella aperta)
        select 1
          into D_controllo_mensilita
          from RIFERIMENTO_RETRIBUZIONE rire
         where rire.anno     <= D_anno_elab
           and (  rire.anno  > D_anno_elab 
               or rire.mese  <= D_mese_elab)
        ;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  D_riga := D_riga + 1;
                  INSERT INTO a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                                   ,errore,precisazione)
                  VALUES (prenotazione,1,D_riga,'P00107',': '||D_mensilita_elab);
                  update a_prenotazioni set prossimo_passo  = 91
                                          , errore          = 'P05808'
                   where no_prenotazione = prenotazione
                  ;
                  COMMIT;
        RAISE uscita;
   END;   -- controllo mensilita' già elaborata (successiva o uguale a quella aperta)

  IF prenotazione != 0 THEN
    BEGIN  -- Preleva utente da depositare in campi Global
       select utente
            , ambiente
            , ente
         into w_utente
            , w_ambiente
            , w_ente
         from a_prenotazioni
        where no_prenotazione = prenotazione
       ;
    EXCEPTION
       WHEN OTHERS THEN NULL;
    END;
  ELSE -- prenotazione = 0
    w_ente := si4.ente;
    w_ambiente := si4.ambiente;
    w_utente := si4.utente;
  END IF;


BEGIN
  FOR CUR_CI in 
     (select distinct ci
        from MOVIMENTI_FISCALI moco
       where anno = D_anno_cong
         and mese = D_mese_cong
         and mensilita = D_mensilita_cong
         and exists (select 'x'
                       from RAPPORTI_GIURIDICI
                      where ci = moco.ci
                        and nvl(gestione,'%')  like nvl(D_gestione,'%') 
                        and nvl(contratto,'%') like nvl(D_contratto,'%')
                        and nvl(to_char(qualifica),'%') like nvl(D_qualifica,'%')
                        and nvl(livello,'%')   like nvl(D_livello,'%')
                    )
         and exists (select 'x'
                       from RAPPORTI_INDIVIDUALI rain
                      where ci = moco.ci
                        and nvl(rapporto,'%')  like nvl(D_rapporto,'%') 
                        and (cc is null
		                 or exists
			              (select 'x'
			                 from A_COMPETENZE
				          where ente       = w_ente
				            and ambiente   = w_ambiente
				            and utente     = w_utente
				            and competenza = 'CI'
				            and oggetto    = rain.cc
				        )
			          )
                    )
       order by ci
     ) LOOP

    FOR CURR IN
       (select distinct moco.rowid
          from IMPONIBILI_VOCE        imvo
             , TOTALIZZAZIONI_VOCE    tovo
             , VOCI_ECONOMICHE        voec
             , MOVIMENTI_CONTABILI    moco
         where moco.voce                       = tovo.voce
           and moco.sub                        = NVL(tovo.sub, moco.sub)
           and tovo.voce_acc                   = imvo.voce
           and voec.codice                     = moco.voce
           and moco.ci+0                       = cur_ci.ci
           and moco.anno                       = D_anno_cong
           and moco.mese                       = D_mese_cong
           and moco.mensilita                  = D_mensilita_cong
           and NVL(moco.ipn_eap, moco.imp) is not null
           and nvl(imvo.cassa_competenza,'NO') = 'SI'
           and moco.competenza is null
           and moco.riferimento between NVL(tovo.dal,TO_DATE(2222222,'j'))
                                    and NVL(tovo.al ,TO_DATE(3333333,'j'))
           and moco.riferimento between NVL(imvo.dal,TO_DATE(2222222,'j'))
                                    and NVL(imvo.al ,TO_DATE(3333333,'j'))
           and imvo.al is not null                          -- la data competenza non serve x le voci dell'anno
           and (  D_variabili is not null
               or moco.input not in ('I','B','D','P','M'))  -- le variabili comunicate mantengono la competenza indicata
       )
      LOOP
dbms_output.put_line ('CCC07 moco.rowid '||curr.rowid);
-- inserimento in negativo delle voci pagate nella mensilità di conguaglio
       insert into movimenti_contabili
                 ( ci, anno, mese, mensilita, voce, sub
                 , riferimento, competenza, arr
                 , input
                 , data, qualifica, tipo_rapporto, ore
                 , tar, qta, imp
                 , tar_var
                 , qta_var
                 , imp_var
                 , ipn_p, ipn_eap
                 , sede_del, anno_del, numero_del, delibera, capitolo, articolo, conto
                 , impegno, risorsa_intervento, anno_impegno, sub_impegno, anno_sub_impegno, codice_siope)
       select      ci, d_anno_elab, d_mese_elab, d_mensilita_elab, voce, sub
                 , riferimento, competenza, arr
                 , decode( input
                         , 'R', 'B', 'r', 'B'   -- voci rapportate
                         , 'A', 'I', 'a', 'I'   -- voci variabili o individuali non rapp.
                         , 'I'
                         )
                 , sysdate, qualifica, tipo_rapporto, ore
                 , null, null, null
                 , decode( input
                         , 'R', ipn_eap * -1, 'r', ipn_eap * -1  -- voci rapportate, considera teorico al 100%
                         , tar * -1
                         )
                 , decode( input
                         , 'R', '', 'r', ''   -- voci rapportate, non ha senso la qta
                         , qta * -1
                         )
                 , imp * -1
                 , ipn_p, ipn_eap
                 , sede_del, anno_del, numero_del, delibera, capitolo, articolo, conto
                 , impegno, risorsa_intervento, anno_impegno, sub_impegno, anno_sub_impegno, codice_siope
         from MOVIMENTI_CONTABILI
        where rowid = CURR.rowid
       ;


-- inserimento in positivo delle voci pagate nella mensilità di conguaglio, indicazione data di competenza
       insert into movimenti_contabili
                 ( ci, anno, mese, mensilita, voce, sub
                 , riferimento, competenza, arr
                 , input
                 , data, qualifica, tipo_rapporto, ore
                 , tar, qta, imp
                 , tar_var
                 , qta_var
                 , imp_var
                 , ipn_p, ipn_eap
                 , sede_del, anno_del, numero_del, delibera, capitolo, articolo, conto
                 , impegno, risorsa_intervento, anno_impegno, sub_impegno, anno_sub_impegno, codice_siope)
       select      ci, d_anno_elab, d_mese_elab, d_mensilita_elab, voce, sub
                 , riferimento, D_fin_ela, arr
                 , decode( input
                         , 'R', 'B', 'r', 'B'   -- voci rapportate
                         , 'A', 'I', 'a', 'I'   -- voci variabili o individuali non rapp.
                         , 'I'
                         )
                 , sysdate, qualifica, tipo_rapporto, ore
                 , null, null, null
                 , decode( input
                         , 'R', ipn_eap, 'r', ipn_eap   -- voci rapportate, considera teorico al 100%
                         , tar
                         )
                 , decode( input
                         , 'R', '', 'r', ''   -- voci rapportate, non ha senso la qta
                         , qta
                         )
                 , imp
                 , ipn_p, ipn_eap
                 , sede_del, anno_del, numero_del, delibera, capitolo, articolo, conto
                 , impegno, risorsa_intervento, anno_impegno, sub_impegno, anno_sub_impegno, codice_siope
         from MOVIMENTI_CONTABILI
        where rowid = CURR.rowid
       ;

      END LOOP; -- curr

   BEGIN -- controllo variabile già caricata (doppia elaborazione)
      FOR CURV in (select voco.titolo,
                          moco.riferimento
                     from movimenti_contabili moco,
                          voci_contabili voco
                    where moco.ci = cur_ci.ci
                      and moco.anno = D_anno_elab
                      and moco.mese = D_mese_elab
                      and moco.mensilita = D_mensilita_elab
                      and moco.input not in ('R','C','A')
                      and voco.voce = moco.voce
                      and voco.sub  = moco.sub
                    group by moco.voce,moco.sub, voco.titolo,
                          nvl(moco.qta_var,0),nvl(moco.imp_var,0),
                          moco.riferimento
                   having count(*) > 2)  -- 2 record in quanto uno negativo e uno positivo ci sono sempre
      LOOP
          D_riga := D_riga + 1;
          insert into a_segnalazioni_errore
                     (no_prenotazione,passo,progressivo,errore,precisazione)
          values (prenotazione,passo,D_riga,'P00874',to_char(cur_ci.ci)||' / '||curv.titolo
                                                   ||' Rif. '||to_char(curv.riferimento,'dd/mm/yyyy'));
          update a_prenotazioni set prossimo_passo  = 91
                                  , errore          = 'P05808'
           where no_prenotazione = prenotazione
          ;
          COMMIT;
      END LOOP;
   END; -- controllo variabile già caricata (doppia elaborazione)

  END LOOP; -- cur_ci
end;
EXCEPTION
     WHEN uscita THEN
        NULL;
     WHEN OTHERS THEN
        RAISE;
end;
end;
end;
/
