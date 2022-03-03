CREATE OR REPLACE PACKAGE PECCADNA IS
/******************************************************************************
 NOME:        PECCADNA
 DESCRIZIONE: Creazione della tabella intermedia per eventuali variazioni
              da apportare prima della emissione del flusso per la Denuncia
              Nominativa Assicurati Inail su supporto magnatico (dischetti
              a 5', 25 o 3', 50 - ASCII - lung. 100 crt.):
              Questa fase produce movimenti emessi su una tabella di lavoro
              al fine di eseguire eventuali variazioni dei medesimi.
              Successivamente da questa tabella verranno estratti i movimenti e
              composto un file secondo i tracciati imposti dalla Direzione
              dell'Inail.


 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
 2    20/06/2003 CB     Modifica per attivita
 3    08/07/2004 CB     Modifica per attivita
 4    07/10/2004 AM     Correzioni per gestione competenza (rif. attivita)
 4.1  20/06/2005 MS     Modifica per attivita 11584
 4.2  20/06/2005 GM     Modifica per attivita 11735 (Archiviazione individuale e per tipo)
 4.3  14/06/2006 MS     Introdotta sequence per PK
 4.4  19/09/2006 MS     Mod. gestione parametro P_pos_inail ( A17703 )
 4.5  02/04/2007 MS     Mod. gestione cambio posizione da RARS ( A20394 ) e migliorie
/*****************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCADNA IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V4.5 del 02/04/2007';
END VERSIONE;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
  BEGIN

declare
P_ente       varchar2(4);
P_ambiente   varchar2(8);
P_utente     varchar2(8);
P_anno       number(4);
P_ini_anno   varchar2(8);
P_fin_anno   varchar2(8);
P_anno_p     number(4);
P_ini_anno_p varchar2(8);
P_fin_anno_p varchar2(8);
P_pos_inail  varchar2(12);
P_gestione   varchar2(4);
P_ci         number(8);
P_tipo       varchar2(1);
D_al_new     date;
D_riga       number(10) := 0;
D_errore     varchar2(6);
D_precisazione varchar2(200);
ESCI         EXCEPTION;

BEGIN
 BEGIN
  BEGIN
    select substr(valore,1,4)    D_anno
      into P_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_ANNO'
    ;
  EXCEPTION
      when no_data_found then
           P_anno := null
    ;
  END;
  BEGIN
    select substr(valore,1,12)  D_pos_inail
      into P_pos_inail
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_POS_INAIL'
    ;
  EXCEPTION
      when no_data_found then
        P_pos_inail := '%'
    ;
  END;

  BEGIN
     select 'P05470'
       into D_errore
       from dual
      where not exists ( select 'x'
                           from assicurazioni_inail asin
                          where asin.posizione like P_pos_inail
                       )
     ;
     RAISE ESCI;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN D_errore := '';
  END;

  BEGIN
    select substr(valore,1,4)  D_gestione
      into P_gestione
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_GESTIONE'
    ;
  EXCEPTION
      when no_data_found then
           P_gestione := '%'
    ;
  END;

  BEGIN
     select 'P01200'
       into D_errore
       from dual
      where not exists ( select 'x'
                           from gestioni gest
                          where gest.codice like P_gestione
                       )
     ;
     RAISE ESCI;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN D_errore := '';
  END;

  BEGIN
    select valore
      into P_tipo
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_TIPO'
    ;
  EXCEPTION
    when NO_DATA_FOUND then
      P_tipo := 'T';
  END;
  BEGIN
    select to_number(substr(valore,1,8))
      into P_ci
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CI'
    ;
    if P_tipo in ('T','P','I','V') and P_ci is not null THEN
      D_errore := 'A05721';
      raise esci;
    end if;
  EXCEPTION
    when NO_DATA_FOUND then
      if P_tipo = 'S' then
        D_errore := 'A05721';
        raise esci;
      end if;
  END;
  BEGIN
     select ente     D_ente
          , utente   D_utente
          , ambiente D_ambiente
       into P_ente,P_utente,P_ambiente
       from a_prenotazioni
      where no_prenotazione = prenotazione;
  EXCEPTION
       when no_data_found then
            P_ENTE := null;
            P_utente:=NULL;
            P_ambiente:=NULL
      ;
  END;
  select to_char(to_date
                 ('01'||(nvl(P_anno,anno)-1),'mmyyyy')
                ,'ddmmyyyy')                                   D_ini_anno_p
       , to_char(to_date
                 ('3112'||(nvl(P_anno,anno)-1),'ddmmyyyy')
                ,'ddmmyyyy')                                   D_fin_anno_p
       , nvl(P_anno,anno) - 1                                  D_anno_p
       , to_char(to_date
                 ('01'||nvl(P_anno,anno),'mmyyyy')
                ,'ddmmyyyy')                                   D_ini_anno
       , to_char(to_date
                 ('3112'||nvl(P_anno,anno),'ddmmyyyy')
                ,'ddmmyyyy')                                   D_fin_anno
       , nvl(P_anno,anno)                                      D_anno
    into P_ini_anno_p,P_fin_anno_p,P_anno_p,P_ini_anno,P_fin_anno,P_anno
    from riferimento_fine_anno
   where rifa_id = 'RIFA'
  ;
DECLARE
  D_gest                    varchar2(4);
  D_gest_app                varchar2(4);
  D_codice_catasto          varchar2(5);
  D_qual_inail              varchar2(2);
  D_pos_inail               varchar2(12);
  D_qual_inail_app          varchar2(2);
  D_pos_inail_app           varchar2(12);
  D_ci                      number := 0;
  D_ci_app                  number := 0 ;
  D_dal                     date;
  D_al                      date;
  D_dal_app                 date;
  D_al_app                  date;
  D_codice_catasto_app      varchar2(5);

  BEGIN
  delete from denuncia_inail dein
   where anno         = TO_NUMBER(P_anno)
     and pos_inail like P_pos_inail
     and gestione  like P_gestione
     and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = dein.ci
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
          )
     and ( P_tipo = 'T'
           or ( P_tipo in ('I','V','P')
                and ( not exists (select 'x' from denuncia_inail
                                 where anno     = TO_NUMBER(P_anno)
                                   and ci       = dein.ci
                                   and gestione = dein.gestione
                                   and pos_inail = dein.pos_inail
                                   and nvl(tipo_agg,' ') = decode(P_tipo, 'P', tipo_agg, P_tipo)
                                 )
                    )
              )
           or ( P_tipo  = 'S'
                and dein.ci = P_ci )
         )
  ;
  D_gest                         := null;
  D_codice_catasto               := null;
  D_qual_inail                   := null;
  D_ci                           := 0;
  D_dal                          := to_date(null);
  D_al                           := to_date(null);

FOR CUR_PSEC IN
   (select psec.gestione                                      gest
         , psec.ci                                            ci
         , greatest(psec.dal,to_date(P_ini_anno,'ddmmyyyy'))  dal
         , least(nvl(psec.al,to_date('3333333','j'))
                ,to_date(P_fin_anno,'ddmmyyyy'))              al
         , clra.cat_inail                                     qual_inail
         , comu.codice_catasto                                codice_catasto
      from gestioni                    gest
         , classi_rapporto             clra
         , periodi_servizio_contabile  psec
         , comuni                      comu
     where psec.dal           <= to_date(P_fin_anno,'ddmmyyyy')
       and nvl(psec.al,to_date('3333333','j'))
                              >= to_date(P_ini_anno,'ddmmyyyy')
       and psec.segmento      in
          (select 'i' from dual
            union
           select 'e' from dual
            union
           select 'c' from dual
            union
           select 'f' from dual
            union
           select 'u' from dual
            where not exists
                 (select 'x'
                    from periodi_servizio_contabile
                   where ci      = psec.ci
                     and segmento = 'e'
                     and dal     <= psec.dal
                     and nvl(al,to_date('3333333','j')) >= psec.dal)
          )
       and psec.gestione          = gest.codice
       and PSEC.GESTIONE     like P_gestione
       and clra.codice            =
          (select rapporto from rapporti_individuali
            where ci = psec.ci)
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = psec.ci
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
          )
       and exists
          (select 'x' from movimenti_contabili
            where anno = P_anno
              and ci   = psec.ci
              and voce in (select voce from voci_inail))
       and gest.provincia_res = comu.cod_provincia
       and gest.comune_res    = comu.cod_comune
       and ( P_tipo = 'T'
             or ( P_tipo in ('I','V','P')
                  and ( not exists (select 'x' from denuncia_inail
                                   where anno     = P_anno
                                     and ci       = psec.ci
                                     and gestione = psec.gestione
                                     and nvl(tipo_agg,' ') = decode(P_tipo, 'P', tipo_agg, P_tipo)
                                   )
                      )
                )
             or ( P_tipo  = 'S'
                  and psec.ci = P_ci )
           )
     order by 3,4
   ) lOOP --CUR_PSEC--
       IF NVL(CUR_PSEC.ci,0) = nvl(D_ci,0)
          THEN
            IF nvl(D_gest,' ')       = nvl(CUR_PSEC.gest,' ')              and
               nvl(D_qual_inail,' ') = nvl(CUR_PSEC.qual_inail,' ')
            THEN
               IF D_al = CUR_PSEC.dal - 1 
                  THEN D_al := CUR_PSEC.al;
               ELSE
                 insert into denuncia_inail
                ( dein_id
                 , anno, gestione, ci
                 , dal, al
                 , qua_inail
                 , codice_catasto
                 , utente,tipo_agg,data_agg )
                 values
                 ( DEIN_SQ.NEXTVAL
                 , P_anno, D_gest
                 , D_ci
                 , D_dal, D_al
                 , D_qual_inail
                 , D_codice_catasto
                 , P_utente,null,sysdate )
                 ;
                 D_gest                      := CUR_PSEC.gest;
                 D_codice_catasto            := CUR_PSEC.codice_catasto;
                 D_qual_inail                := CUR_PSEC.qual_inail;
                 D_ci                        := CUR_PSEC.ci;
                 D_dal                       := CUR_PSEC.dal;
                 D_al                        := CUR_PSEC.al;
               END IF;
            ELSE
                 insert into denuncia_inail
                ( dein_id
                 , anno, gestione, ci
                 , dal, al
                 , qua_inail
                 , codice_catasto
                 , utente,tipo_agg,data_agg )
                values
                ( DEIN_SQ.NEXTVAL
                , P_anno,D_gest
                , D_ci
                , D_dal,D_al
                , D_qual_inail
                , D_codice_catasto
                , P_utente,null,sysdate
                 )
                 ;
                 D_gest                      := CUR_PSEC.gest;
                 D_codice_catasto            := CUR_PSEC.codice_catasto;
                 D_qual_inail                := CUR_PSEC.qual_inail;
                 D_ci                        := CUR_PSEC.ci;
                 D_dal                       := CUR_PSEC.dal;
                 D_al                        := CUR_PSEC.al;
            END IF;
          ELSIF D_ci = 0
                THEN
                     D_gest                        := CUR_PSEC.gest;
                     D_codice_catasto              := CUR_PSEC.codice_catasto;
                     D_qual_inail                  := CUR_PSEC.qual_inail;
                     D_ci                          := CUR_PSEC.ci;
                     D_dal                         := CUR_PSEC.dal;
                     D_al                          := CUR_PSEC.al;
          ELSE
           insert into denuncia_inail
           ( dein_id
           , anno, gestione, ci
           , dal, al
           , qua_inail
           , codice_catasto
           , utente,tipo_agg,data_agg )
           values
           ( DEIN_SQ.NEXTVAL
           , P_anno,D_gest
           , D_ci,D_dal,D_al
           , D_qual_inail
           , D_codice_catasto
           , P_utente,null,sysdate
           )
           ;
           D_gest                        := CUR_PSEC.gest;
           D_codice_catasto              := CUR_PSEC.codice_catasto;
           D_qual_inail                  := CUR_PSEC.qual_inail;
           D_ci                          := CUR_PSEC.ci;
           D_dal                         := CUR_PSEC.dal;
           D_al                          := CUR_PSEC.al;
          END IF; -- controllo sul ci
       commit;
     END LOOP; -- CUR_PSEC

      IF d_gest is null THEN
         D_errore := 'P05474';
         RAISE ESCI;
      ELSE
           insert into denuncia_inail
           ( dein_id
           , anno, gestione, ci
           , dal, al
           , qua_inail
           , codice_catasto
           , utente,tipo_agg,data_agg )
             values
            ( DEIN_SQ.NEXTVAL
            , P_anno, D_gest, D_ci
            , D_dal, D_al
            , D_qual_inail
            , D_codice_catasto
            , P_utente, null, sysdate )
            ;
      END IF;
      commit;

  D_ci_app                := 0;
  D_gest_app              := null;
  D_qual_inail_app        := null;
  D_pos_inail_app         := null;
  D_dal_app               := to_date(null);
  D_al_app                := to_date(null);
  D_codice_catasto_app    := null;
  D_al_new                := to_date(null);

    FOR MOCO1 in
       (select distinct asin.posizione     inail
             , moco.ci                     moco_ci
             , '1'                         tipo
             , to_date('01/'||to_char(riferimento,'mm/yyyy'),'dd/mm/yyyy')   data
             , dein.gestione               gest
             , dein.qua_inail              qual_inail
             , greatest(dein.dal,to_date('01/'||to_char(riferimento,'mm/yyyy'),'dd/mm/yyyy'))    dal
             , least(nvl(dein.al,to_date('3333333','j')),moco.riferimento)                   al
             , dein.codice_catasto         codice_catasto
             , dein.dal dal_dein
          from movimenti_contabili         moco
             , denuncia_inail              dein
             , voci_inail                  voin
             , assicurazioni_inail         asin
         where dein.anno           = P_anno
           and dein.pos_inail     is null
           and asin.posizione      like P_pos_inail
           and moco.anno           = dein.anno
           and moco.ci             = dein.ci
           and moco.voce           = voin.voce
           and moco.sub            = voin.sub
           and voin.codice         = asin.codice
           and lpad(nvl(asin.posizione,'0'),12,'0') != lpad('0',12,'0')
           and to_date('01'||to_char(moco.riferimento,'mmyyyy'),'ddmmyyyy') <= nvl(dein.al,to_date(P_fin_anno,'ddmmyyyy'))
           and moco.riferimento >= nvl(dein.dal,to_date(P_ini_anno,'ddmmyyyy'))
           and ( P_tipo = 'T'
                 or ( P_tipo in ('I','V','P')
                      and ( not exists (select 'x' from denuncia_inail
                                       where anno     = TO_NUMBER(P_anno)
                                         and ci       = dein.ci
                                         and gestione = dein.gestione
                                         and nvl(tipo_agg,' ') = decode(P_tipo ,'P' , tipo_agg, P_tipo)
                                       )
                          )
                    )
                 or ( P_tipo  = 'S'
                      and dein.ci = P_ci )
               )
          order by moco.ci,dein.dal
          ) LOOP   -- MOCO1
          BEGIN
            IF moco1.moco_ci = nvl(D_ci_app,0) then
            -- secondo record per il ci confronto se sono uguali
               if    nvl(D_ci_app,0)           = nvl(moco1.moco_ci,0)
                 and nvl(D_gest_app,' ')       = nvl(moco1.gest,' ')
                 and nvl(D_qual_inail_app,' ') = nvl(moco1.qual_inail,' ')
                 and nvl(D_pos_inail_app,' ')  = nvl(moco1.inail,' ')
               then
               -- sono uguali quindi sposto al
                    D_al_app  := moco1.al ;
               else
               -- non sono uguali quindi inserisco un record
                 insert into denuncia_inail
                 ( dein_id
                 , anno,gestione,ci
                 , pos_inail
                 , qua_inail
                 , dal, al
                 , codice_catasto
                 , utente,tipo_agg,data_agg )
                 values ( DEIN_SQ.NEXTVAL
                        , P_anno, D_gest_app, D_ci_app
                        , D_pos_inail_app
                        , D_qual_inail_app
                        , D_dal_app,D_al_app
                        , D_codice_catasto_app
                        , P_utente,null,sysdate 
                        );
                 D_ci_app             := moco1.moco_ci;
                 D_codice_catasto_app := moco1.codice_catasto;
                 D_gest_app           := moco1.gest;
                 D_qual_inail_app     := moco1.qual_inail;
                 D_pos_inail_app      := moco1.inail;
                 D_dal_app            := moco1.dal;
                 D_al_app             := moco1.al;
               end if;
            ELSIF D_ci_app = 0 THEN
            -- primo accesso per il CI; memorizzo i dati
                 D_ci_app             := moco1.moco_ci;
                 D_codice_catasto_app := moco1.codice_catasto;
                 D_gest_app           := moco1.gest;
                 D_qual_inail_app     := moco1.qual_inail;
                 D_pos_inail_app      := moco1.inail;
                 D_dal_app            := moco1.dal;
                 D_al_app             := moco1.al;
            ELSE
                insert into denuncia_inail
                ( dein_id
                , anno,gestione, ci
                , pos_inail
                , qua_inail
                , dal,al
                , codice_catasto
                , utente,tipo_agg,data_agg)
                values 
                ( DEIN_SQ.NEXTVAL
                , P_anno,D_gest_app,D_ci_app
                , D_pos_inail_app
                , D_qual_inail_app
                , D_dal_app, D_al_app
                , D_codice_catasto_app
                , P_utente,null,sysdate
                );
                 D_ci_app             := moco1.moco_ci;
                 D_codice_catasto_app := moco1.codice_catasto;
                 D_gest_app           := moco1.gest;
                 D_qual_inail_app     := moco1.qual_inail;
                 D_pos_inail_app      := moco1.inail;
                 D_dal_app            := moco1.dal;
                 D_al_app             := moco1.al;
             END IF;
            END;
          commit;
          END LOOP;-- MOCO1
         if d_gest is null then
            D_errore := 'P05474';
            RAISE ESCI;
         elsif D_ci_app != 0 then
           insert into denuncia_inail
           ( dein_id
           , anno,gestione,ci
           , pos_inail
           , qua_inail
           , dal,al
           , codice_catasto
           , utente,tipo_agg,data_agg )
           values
           ( DEIN_SQ.NEXTVAL
           , P_anno,D_gest_app, D_ci_app
           , D_pos_inail_app
           , D_qual_inail_app
           , D_dal_app,D_al_app
           , D_codice_catasto_app
           , P_utente,null,sysdate
           ) ;
        end if;
     COMMIT;
   END;
   BEGIN -- assestamento dal
-- cancellazione delle registrazioni di appoggio
   delete from denuncia_inail
    where anno = P_anno
      and pos_inail is null;
-- Assestamento dal in caso di pagamento posticipato
   update denuncia_inail dein
      set dal = ( select pegi.dal
                    from periodi_giuridici pegi
                   where rilevanza = 'S'
                     and pegi.ci   = dein.ci
                     and dein.dal between pegi.dal and nvl(pegi.al,to_date(P_fin_anno,'ddmmyyyy'))
                     and to_char(pegi.dal,'mm') = to_char(dein.dal,'mm') - 1
                     and to_char(pegi.dal,'yyyy') = to_char(dein.dal,'yyyy')
                     and to_char(dein.dal,'mm') != 1
                     and not exists ( select 'x'
                                        from denuncia_inail dein1
                                       where anno = dein.anno
                                         and ci   = dein.ci
                                         and nvl(dein1.al,to_date(P_fin_anno,'ddmmyyyy'))
                                             between pegi.dal and nvl(pegi.al,to_date(P_fin_anno,'ddmmyyyy'))
                                         and nvl(dein1.al,to_date(P_fin_anno,'ddmmyyyy')) < dein.dal
                                     )
                union
                  select pegi.dal
                    from periodi_giuridici pegi
                   where rilevanza = 'S'
                     and pegi.ci   = dein.ci
                     and last_day(add_months(dein.dal,-1))
                         between pegi.dal and nvl(pegi.al,to_date(P_fin_anno,'ddmmyyyy'))
                     and to_char(pegi.dal,'mm') = to_char(dein.dal,'mm')-1
                     and to_char(dein.dal,'mm') != 1
                     and to_char(pegi.dal,'yyyy') = to_char(dein.dal,'yyyy')
                     and not exists ( select 'x'
                                        from denuncia_inail dein1
                                       where anno = dein.anno
                                         and ci   = dein.ci
                                         and nvl(dein1.al,to_date(P_fin_anno,'ddmmyyyy'))
                                             between pegi.dal and nvl(pegi.al,to_date(P_fin_anno,'ddmmyyyy'))
                                         and nvl(dein1.al,to_date(P_fin_anno,'ddmmyyyy')) < dein.dal
                                     )
                     and not exists ( select 'x'
                                        from denuncia_inail dein1
                                       where anno = dein.anno
                                         and ci   = dein.ci
                                         and nvl(pegi.al,to_date(P_fin_anno,'ddmmyyyy'))
                                             between dein1.dal and nvl(dein1.al,to_date(P_fin_anno,'ddmmyyyy'))
                                         and nvl(pegi.al,to_date(P_fin_anno,'ddmmyyyy')) < dein1.al
                                     )
                )
    where anno = P_anno
      and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = dein.ci
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
          )
      and exists ( select pegi.dal
                    from periodi_giuridici pegi
                   where rilevanza = 'S'
                     and pegi.ci   = dein.ci
                     and dein.dal between pegi.dal and nvl(pegi.al,to_date(P_fin_anno,'ddmmyyyy'))
                     and to_char(pegi.dal,'mm') = to_char(dein.dal,'mm') - 1
                     and to_char(pegi.dal,'yyyy') = to_char(dein.dal,'yyyy')
                     and to_char(dein.dal,'mm') != 1
                     and not exists ( select 'x'
                                        from denuncia_inail dein1
                                       where anno = dein.anno
                                         and ci   = dein.ci
                                         and nvl(dein1.al,to_date(P_fin_anno,'ddmmyyyy'))
                                             between pegi.dal and nvl(pegi.al,to_date(P_fin_anno,'ddmmyyyy'))
                                         and nvl(dein1.al,to_date(P_fin_anno,'ddmmyyyy')) < dein.dal
                                     )
                   union
                  select pegi.dal
                    from periodi_giuridici pegi
                   where rilevanza = 'S'
                     and pegi.ci   = dein.ci
                     and last_day(add_months(dein.dal,-1))
                         between pegi.dal and nvl(pegi.al,to_date(P_fin_anno,'ddmmyyyy'))
                     and to_char(pegi.dal,'mm') = to_char(dein.dal,'mm')-1
                     and to_char(dein.dal,'mm') != 1
                     and to_char(pegi.dal,'yyyy') = to_char(dein.dal,'yyyy')
                     and not exists ( select 'x'
                                        from denuncia_inail dein1
                                       where anno = dein.anno
                                         and ci   = dein.ci
                                         and nvl(dein1.al,to_date(P_fin_anno,'ddmmyyyy'))
                                             between pegi.dal and nvl(pegi.al,to_date(P_fin_anno,'ddmmyyyy'))
                                         and nvl(dein1.al,to_date(P_fin_anno,'ddmmyyyy')) < dein.dal
                                     )
                     and not exists ( select 'x'
                                        from denuncia_inail dein1
                                       where anno = dein.anno
                                         and ci   = dein.ci
                                         and nvl(pegi.al,to_date(P_fin_anno,'ddmmyyyy'))
                                             between dein1.dal and nvl(dein1.al,to_date(P_fin_anno,'ddmmyyyy'))
                                         and nvl(pegi.al,to_date(P_fin_anno,'ddmmyyyy')) < dein1.al
                                     )
                )
      and ( P_tipo = 'T'
            or ( P_tipo in ('I','V','P')
                 and ( not exists (select 'x' from denuncia_inail
                                  where anno     = TO_NUMBER(P_anno)
                                    and ci       = dein.ci
                                    and gestione = dein.gestione
                                    and nvl(tipo_agg,' ') = decode( P_tipo, 'P', tipo_agg, P_tipo)
                                  )
                     )
               )
            or ( P_tipo  = 'S'
                 and dein.ci = P_ci )
          )
    ;
     commit;
   END; -- fine assestamento dal
   BEGIN -- assestamento date cambio posizione
      FOR CUR_DEIN in
      (  select ci, dal, al, pos_inail
          from denuncia_inail dein
         where anno = P_anno
           and ( P_tipo = 'T'
            or ( P_tipo in ('I','V','P')
                 and not exists ( select 'x' 
                                    from denuncia_inail
                                   where anno     = TO_NUMBER(P_anno)
                                     and ci       = dein.ci
                                     and gestione = dein.gestione
                                     and nvl(tipo_agg,' ') = decode( P_tipo, 'P', tipo_agg, P_tipo)
                                )
               )
            or ( P_tipo  = 'S'
                 and dein.ci = P_ci )
               )
          and exists ( select 'x'
                        from rapporti_retributivi_storici rars
                           , assicurazioni_inail asin
                       where ci = dein.ci 
                         and nvl(al, to_date(P_fin_anno,'ddmmyyyy')) 
                             between nvl(dein.dal,to_date(P_ini_anno,'ddmmyyyy'))+1
                                 and nvl(dein.al,to_date(P_fin_anno,'ddmmyyyy'))-1
                         and rars.posizione_inail = asin.codice
                         and asin.posizione != dein.pos_inail
                    )
          and exists ( select 'x'
                        from denuncia_inail dein1
                       where dein1.ci = dein.ci 
                         and nvl(dein1.al, to_date(P_fin_anno,'ddmmyyyy')) = dein.dal - 1
                         and dein1.pos_inail != dein.pos_inail
                    )
       ) LOOP
         BEGIN
           BEGIN
            select rars.al
              into D_al_new
              from rapporti_retributivi_storici rars
             where rars.ci = CUR_DEIN.CI
               and nvl(al, to_date(P_fin_anno,'ddmmyyyy')) 
                   between nvl(CUR_DEIN.dal,to_date(P_ini_anno,'ddmmyyyy'))+1
                       and nvl(CUR_DEIN.al,to_date(P_fin_anno,'ddmmyyyy'))-1
            ;
           EXCEPTION WHEN NO_DATA_FOUND THEN
              D_al_new := to_date(null);
           END; 
           IF D_al_new is not null THEN -- sistemo date ed emetto segnalazione
            update denuncia_inail
               set al = D_al_new
             where ci = CUR_DEIN.ci
               and anno = P_anno
               and al = CUR_DEIN.dal - 1
            ;
            update denuncia_inail
               set dal = D_al_new+1
             where ci = CUR_DEIN.ci
               and anno = P_anno
               and dal = CUR_DEIN.dal
               and al = CUR_DEIN.al
            ;
            commit;
            D_riga := nvl(D_riga,0) + 1;
            D_precisazione := lpad(to_char(cur_dein.ci),8,'0')||rpad('MODIFICATO',20,' ');
            insert into a_segnalazioni_errore
            ( no_prenotazione, passo, progressivo, errore, precisazione )
            values ( prenotazione, passo, D_riga, ' ', D_precisazione );
            commit;
           ELSE -- non possibile assestamento, emetto segnalazione
              D_riga := nvl(D_riga,0) + 1;
              D_precisazione := lpad(to_char(cur_dein.ci),8,'0')||rpad('NON MODIFICATO',20,' ');
              insert into a_segnalazioni_errore
              ( no_prenotazione, passo, progressivo, errore, precisazione )
              values ( prenotazione, passo, D_riga, ' ', D_precisazione );
              commit;
           END IF;
         END;
       END LOOP; -- cur_dein
   END; -- fine assestamento periodi sovrapposti
END;
EXCEPTION when esci then
        UPDATE a_prenotazioni
           set prossimo_passo = 92
             , errore = D_errore
         where no_prenotazione= prenotazione;
END;
END;
END;
/
