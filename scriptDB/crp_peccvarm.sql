CREATE OR REPLACE PACKAGE peccvarm IS
/******************************************************************************
 NOME:        PECCVARM
 DESCRIZIONE: Caricamento delle variabili mensili registrate con l'apposita fase
              nell'archivio dei movimenti economici individuali.
              Questa funzione effettua il passaggio delle variabili mensili registrate
              con l'apposita fase, dagli archivi in cui erano state momentaneamente
              registrate, all'archivio dei movimenti economici individuali.
              Il caricamento avviene per le variabili di tutti i moduli ai quali il
              terminalista puo` accedere in funzione del suo codice di competenza.
              Dopo il caricamento i dati vengono cancellati dagli archivi di appoggio.
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003        
 2    28/06/2005 CB     Gestione codice_siope     

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY peccvarm IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V2.0 del 28/06/2005';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
begin
declare
P_ente       varchar2(4);
P_ambiente    varchar2(8);
P_utente      varchar2(8);
P_anno        varchar2(4);
P_mese        varchar2(2);
P_mensilita   varchar2(3);
P_ini_ela     varchar2(10);
begin
--
--  -- Estrazione Parametri di Selezione della Prenotazione
--
      select ente     D_ente
           , utente   D_utente
           , ambiente D_ambiente
		   into p_ente, p_utente, p_ambiente
        from a_prenotazioni
       where no_prenotazione = prenotazione
      ;
--
--  -- Estrae Anno, Mese, Mensilita di Riferimento Retribuzione
--
      select to_char(anno) D_anno,
             to_char(mese) D_mese,
             mensilita     D_mensilita,
             ini_ela       D_ini_ela
			 into p_anno, p_mese,p_mensilita, p_ini_ela
        from riferimento_retribuzione
       where rire_id = 'RIRE'
      ;
DECLARE
  dep_campo      VARCHAR2(1);
  dep_riga       number;
  salta          exception;
  dep_rapporto   VARCHAR2(1);
  dep_input      VARCHAR2(1);
  CURSOR cur_mod IS
     select rava.modulo, rava.ci, voco.alias
          , to_number(p_anno) anno
          , to_number(p_mese) mese
          , p_mensilita       mensilita
          , rarm.voce
          , rarm.sub
          , rava.riferimento
          , rava.competenza
          , voec.classe
          , sysdate                     data
          , decode(voec.classe,'V',to_number('')
                                  ,rava.dato1) qta_var
          , decode(voec.classe,'V',rava.dato1
                                  ,to_number('')) imp_var
          , rava.arr1 arr
          , ramo.risorsa_intervento
          , ramo.capitolo
          , ramo.articolo
          , ramo.impegno
          , ramo.anno_impegno
          , ramo.sub_impegno
          , ramo.anno_sub_impegno
          , ramo.conto
          , ramo.sede_del
          , ramo.anno_del
          , ramo.numero_del
          , ramo.codice_siope
       from voci_economiche             voec
          , voci_contabili              voco
          , raccolta_moduli             ramo
          , raccolta_righe_modulo       rarm
          , raccolta_variabili          rava
      where rava.dato1 is not null
        and rarm.modulo   = rava.modulo
        and rarm.cc       = rava.cc
        and rarm.sequenza = 1
        and ramo.modulo   = rarm.modulo
        and ramo.cc       = rarm.cc
        and exists (select 'x'
                      from a_competenze comp
                     where comp.oggetto    = ramo.cc
                       and comp.ambiente   = p_ambiente
                       and comp.ente       = p_ente
                       and comp.utente     = p_utente
                       and comp.competenza = 'CI'
                   )
        and voec.codice(+) = rarm.voce
        and voco.voce  (+) = rarm.voce
        and voco.sub   (+) = rarm.sub
     union
     select rava.modulo, rava.ci, voco.alias
          , to_number(p_anno) anno
          , to_number(p_mese) mese
          , p_mensilita       mensilita
          , rarm.voce
          , rarm.sub
          , rava.riferimento
          , rava.competenza
          , voec.classe
          , sysdate
          , decode(voec.classe,'V',to_number('')
                                  ,rava.dato2)
          , decode(voec.classe,'V',rava.dato2
                                  ,to_number(''))
          , rava.arr2
          , ramo.risorsa_intervento
          , ramo.capitolo
          , ramo.articolo
          , ramo.impegno
          , ramo.anno_impegno
          , ramo.sub_impegno
          , ramo.anno_sub_impegno
          , ramo.conto
          , ramo.sede_del
          , ramo.anno_del
          , ramo.numero_del
          , ramo.codice_siope
       from voci_economiche             voec
          , voci_contabili              voco
          , raccolta_moduli             ramo
          , raccolta_righe_modulo       rarm
          , raccolta_variabili          rava
      where rava.dato2 is not null
        and rarm.modulo   = rava.modulo
        and rarm.cc       = rava.cc
        and rarm.sequenza = 2
        and ramo.modulo   = rarm.modulo
        and ramo.cc       = rarm.cc
        and exists (select 'x'
                      from a_competenze comp
                     where comp.oggetto    = ramo.cc
                       and comp.ambiente   = p_ambiente
                       and comp.ente       = p_ente
                       and comp.utente     = p_utente
                       and comp.competenza = 'CI'
                   )
        and voec.codice(+) = rarm.voce
        and voco.voce  (+) = rarm.voce
        and voco.sub   (+) = rarm.sub
     union
     select rava.modulo, rava.ci, voco.alias
          , to_number(p_anno) anno
          , to_number(p_mese) mese
          , p_mensilita       mensilita
          , rarm.voce
          , rarm.sub
          , rava.riferimento
          , rava.competenza
          , voec.classe
          , sysdate
          , decode(voec.classe,'V',to_number('')
                                  ,rava.dato3)
          , decode(voec.classe,'V',rava.dato3
                                  ,to_number(''))
          , rava.arr3
          , ramo.risorsa_intervento
          , ramo.capitolo
          , ramo.articolo
          , ramo.impegno
          , ramo.anno_impegno
          , ramo.sub_impegno
          , ramo.anno_sub_impegno
          , ramo.conto
          , ramo.sede_del
          , ramo.anno_del
          , ramo.numero_del
          , ramo.codice_siope
       from voci_economiche             voec
          , voci_contabili              voco
          , raccolta_moduli             ramo
          , raccolta_righe_modulo       rarm
          , raccolta_variabili          rava
      where rava.dato3 is not null
        and rarm.modulo   = rava.modulo
        and rarm.cc       = rava.cc
        and rarm.sequenza = 3
        and ramo.modulo   = rarm.modulo
        and ramo.cc       = rarm.cc
        and exists (select 'x'
                      from a_competenze comp
                     where comp.oggetto    = ramo.cc
                       and comp.ambiente   = p_ambiente
                       and comp.ente       = p_ente
                       and comp.utente     = p_utente
                       and comp.competenza = 'CI'
                   )
        and voec.codice(+) = rarm.voce
        and voco.voce  (+) = rarm.voce
        and voco.sub   (+) = rarm.sub
     union
     select rava.modulo, rava.ci, voco.alias
          , to_number(p_anno) anno
          , to_number(p_mese) mese
          , p_mensilita       mensilita
          , rarm.voce
          , rarm.sub
          , rava.riferimento
          , rava.competenza
          , voec.classe
          , sysdate
          , decode(voec.classe,'V',to_number('')
                                  ,rava.dato4)
          , decode(voec.classe,'V',rava.dato4
                                  ,to_number(''))
          , rava.arr4
          , ramo.risorsa_intervento
          , ramo.capitolo
          , ramo.articolo
          , ramo.impegno
          , ramo.anno_impegno
          , ramo.sub_impegno
          , ramo.anno_sub_impegno
          , ramo.conto
          , ramo.sede_del
          , ramo.anno_del
          , ramo.numero_del
          , ramo.codice_siope
       from voci_economiche             voec
          , voci_contabili              voco
          , raccolta_moduli             ramo
          , raccolta_righe_modulo       rarm
          , raccolta_variabili          rava
      where rava.dato4 is not null
        and rarm.modulo   = rava.modulo
        and rarm.cc       = rava.cc
        and rarm.sequenza = 4
        and ramo.modulo   = rarm.modulo
        and ramo.cc       = rarm.cc
        and exists (select 'x'
                      from a_competenze comp
                     where comp.oggetto    = ramo.cc
                       and comp.ambiente   = p_ambiente
                       and comp.ente       = p_ente
                       and comp.utente     = p_utente
                       and comp.competenza = 'CI'
                   )
        and voec.codice(+) = rarm.voce
        and voco.voce  (+) = rarm.voce
        and voco.sub   (+) = rarm.sub
     union
     select rava.modulo, rava.ci, voco.alias
          , to_number(p_anno) anno
          , to_number(p_mese) mese
          , p_mensilita       mensilita
          , rava.voce
          , rava.sub
          , rava.riferimento
          , rava.competenza
          , voec.classe
          , sysdate
          , decode(rava.tipo,'Q',rava.dato
                                ,to_number(''))
          , decode(rava.tipo,'I',rava.dato
                                ,to_number(''))
          , rava.arr
          , ramo.risorsa_intervento
          , ramo.capitolo
          , ramo.articolo
          , ramo.impegno
          , ramo.anno_impegno
          , ramo.sub_impegno
          , ramo.anno_sub_impegno
          , ramo.conto
          , ramo.sede_del
          , ramo.anno_del
          , ramo.numero_del
          , ramo.codice_siope
       from voci_economiche             voec
          , voci_contabili              voco
          , raccolta_moduli             ramo
          , raccolta_variabili          rava
      where rava.dato is not null
        and ramo.modulo   = rava.modulo
        and ramo.cc       = rava.cc
        and exists (select 'x'
                      from a_competenze comp
                     where comp.oggetto    = ramo.cc
                       and comp.ambiente   = p_ambiente
                       and comp.ente       = p_ente
                       and comp.utente     = p_utente
                       and comp.competenza = 'CI'
                   )
        and voec.codice(+) = rava.voce
        and voco.voce  (+) = rava.voce
        and voco.sub   (+) = rava.sub
     order by 1,2,3;
   sel_mod                CUR_MOD%ROWTYPE;
BEGIN
     lock table raccolta_variabili in exclusive mode nowait ;
     lock table raccolta_righe_modulo in exclusive mode nowait ;
     lock table raccolta_moduli in exclusive mode nowait ;
     dep_riga := 0;
     open cur_mod;
     LOOP
       BEGIN
       FETCH cur_mod INTO sel_mod;
       EXIT WHEN CUR_MOD%NOTFOUND OR CUR_MOD%NOTFOUND IS NULL;
       BEGIN
       -- Controlli correttezza voce
          IF sel_mod.alias is null THEN
             dep_riga := dep_riga + 1;
             insert into a_segnalazioni_errore ( no_prenotazione
                                               , passo
                                               , progressivo
                                               , errore
                                               , precisazione     )
             values (prenotazione, 1, dep_riga, 'P05610',
                     rpad(sel_mod.modulo,4,' ')||
                     lpad(to_char(sel_mod.ci),8,'0')||
                     rpad(nvl(sel_mod.alias,' '),10,' ')||
                     rpad(nvl(sel_mod.voce,' '),10,' ')||
                     rpad(nvl(sel_mod.sub,' '),2,' ')||
                     to_char(nvl(sel_mod.qta_var,nvl(sel_mod.imp_var,0)),
                             '9999999999.99'));
             RAISE SALTA;
          ELSE
             BEGIN
               select rapporto
                 into dep_rapporto
                 from contabilita_voce covo
                where covo.voce  = sel_mod.voce
                  and covo.sub   = sel_mod.sub
                  and sel_mod.riferimento
                      between nvl(covo.dal,to_date('2222222','j'))
                          and nvl(covo.al ,to_date('3333333','j'));
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 dep_riga := dep_riga + 1;
                 insert into a_segnalazioni_errore ( no_prenotazione
                                                   , passo
                                                   , progressivo
                                                   , errore
                                                   , precisazione     )
                 values (prenotazione, 1, dep_riga, 'P05620',
                         rpad(sel_mod.modulo,4,' ')||
                         lpad(to_char(sel_mod.ci),8,'0')||
                         rpad(sel_mod.alias,10,' ')||
                         rpad(sel_mod.voce,10,' ')||
                         rpad(sel_mod.sub,2,' ')||
                         to_char(nvl(sel_mod.qta_var,nvl(sel_mod.imp_var,0)),
                                 '9999999999.99'));
                 RAISE SALTA;
               WHEN TOO_MANY_ROWS THEN dep_rapporto := '';
             END;
          END IF;
       END;
       BEGIN
          select decode(sel_mod.classe,'V',decode(dep_rapporto,null,'I'
                                                                   ,'B')
                                      ,'I')
            into dep_input
            from sys.dual;
       END;
       BEGIN
       -- Caricamento delle Variabili Raccolte relativamente a tutti i Moduli
       -- con Competenza abilitata per l'utente richiedente l'operazione.
          insert into movimenti_contabili
               ( ci , anno    , mese     , mensilita , voce , sub, arr
               , riferimento , competenza
               , input , data , qta_var , imp_var , risorsa_intervento, capitolo
               , articolo , impegno, anno_impegno, sub_impegno, anno_sub_impegno, conto , sede_del , anno_del , numero_del
               , codice_siope
               )
          values
               (sel_mod.ci, sel_mod.anno, sel_mod.mese, sel_mod.mensilita
               ,sel_mod.voce, sel_mod.sub, sel_mod.arr
               ,sel_mod.riferimento, sel_mod.competenza
               ,dep_input ,sel_mod.data, sel_mod.qta_var, sel_mod.imp_var
               ,sel_mod.risorsa_intervento, sel_mod.capitolo, sel_mod.articolo
               , sel_mod.impegno, sel_mod.anno_impegno, sel_mod.sub_impegno, sel_mod.anno_sub_impegno, sel_mod.conto, sel_mod.sede_del, sel_mod.anno_del
               , sel_mod.numero_del,sel_mod.codice_siope)
          ;
   END;
   -- Gestire la modifica al flag_elab di ragi (vedi avari / ivari)
       update rapporti_giuridici
             set flag_elab = 'P'
             where ci = sel_mod.ci
             and flag_elab in ('E','C');
			 
       -- Segnalazione delle voci per le quali non e' definita la Normativa
       -- relativamente alla Qualifica del codice individuale trattato.
       BEGIN
            select 'x'
              into dep_campo
              from voci_economiche voec,
                   normativa_voce novo
             where voec.codice  = sel_mod.voce
               and novo.voce(+) = voec.codice
               and exists
                  (select 'x'
                     from qualifiche_giuridiche qugi,
                          rapporti_giuridici ragi
                    where ragi.ci           = sel_mod.ci
                      and qugi.numero(+)    = ragi.qualifica
                      and nvl(qugi.contratto,' ') like nvl(novo.contratto,'%')
                      and nvl(qugi.codice ,' ')   like nvl(novo.qualifica,'%')
                      and least(
                           nvl(ragi.al,to_date('3333333','j')),
                           greatest(
                            nvl(ragi.dal,to_date('2222222','j')),
                            sel_mod.riferimento))
                          between nvl(qugi.dal,to_date('2222222','j'))
                              and nvl(qugi.al ,to_date('3333333','j'))
                      and least(
                           nvl(ragi.al,to_date('3333333','j')),
                           greatest(
                            nvl(ragi.dal,to_date('2222222','j')),
                            sel_mod.riferimento))
                          between nvl(novo.dal,to_date('2222222','j'))
                              and nvl(novo.al ,to_date('3333333','j'))
                  );
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
          dep_riga := dep_riga + 1;
          insert into a_segnalazioni_errore ( no_prenotazione
                                            , passo
                                            , progressivo
                                            , errore
                                            , precisazione     )
          values (prenotazione, 1, dep_riga, 'P05690',
                  rpad(sel_mod.modulo,4,' ')||
                  lpad(to_char(sel_mod.ci),8,'0')||
                  rpad(sel_mod.alias,10,' ')||
                  rpad(sel_mod.voce,10,' ')||
                  rpad(sel_mod.sub,2,' ')||
                  to_char(nvl(sel_mod.qta_var,nvl(sel_mod.imp_var,0)),
                          '9999999999.99')
                 );
         WHEN TOO_MANY_ROWS THEN null;
       END;
     EXCEPTION
       WHEN SALTA THEN NULL;
     END;
     END LOOP;
     close cur_mod;
--   Svuota le tabelle RACCOLTA_MODULI,RACCOLTA_RIGHE_MODULO,RACCOLTA_VARIABILI
--   relativamente alle informazioni che sono state caricate nei Movimenti
--   Contabili.
     delete from raccolta_variabili rava
      where exists (select 'x'
                      from a_competenze comp
                     where comp.oggetto    = rava.cc
                       and comp.ambiente   = p_ambiente
                       and comp.ente       = p_ente
                       and comp.utente     = p_utente
                       and comp.competenza = 'CI'
                   )
     ;
     delete from raccolta_righe_modulo rarm
      where exists (select 'x'
                      from a_competenze comp
                     where comp.oggetto    = rarm.cc
                       and comp.ambiente   = p_ambiente
                       and comp.ente       = p_ente
                       and comp.utente     = p_utente
                       and comp.competenza = 'CI'
                   )
     ;
     delete from raccolta_moduli ramo
      where exists (select 'x'
                      from a_competenze comp
                     where comp.oggetto    = ramo.cc
                       and comp.ambiente   = p_ambiente
                       and comp.ente       = p_ente
                       and comp.utente     = p_utente
                       and comp.competenza = 'CI'
                   )
     ;
     update a_prenotazioni set prossimo_passo = 91,
                               errore         = 'P00108'
      where no_prenotazione = prenotazione
        and exists (select 'x'
                      from a_segnalazioni_errore
                     where no_prenotazione = prenotazione)
     ;
commit;
END;
end;
end;
end;
/

