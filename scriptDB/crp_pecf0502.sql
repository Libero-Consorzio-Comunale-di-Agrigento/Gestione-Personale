CREATE OR REPLACE PACKAGE PECF0502 IS

/******************************************************************************
 NOME:          PECF0502
 DESCRIZIONE:   Assestamenti per applicazione Finanziaria 2005 - sistemaizoni a febbraio

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  31/01/2005 Am     Prima Emissione
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECF0502 IS

FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
  RETURN 'V1.0 del 31/01/2005';
 END VERSIONE;

PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
 DECLARE
  D_voce      VARCHAR(10);
  D_tipo      VARCHAR(1);
  V_comando   varchar2(2000);
  V_controllo varchar2(1) := null;
  P_riga      number := 0; 

  USCITA      EXCEPTION;
 BEGIN

  BEGIN
    SELECT valore
      INTO D_voce
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_VOCE'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
    D_voce := 'ERRORE';
  END;

  BEGIN
    SELECT valore
      INTO D_tipo
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_TIPO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
    RAISE USCITA;
  END;
  
  V_controllo := null;
  BEGIN 
-- controllo apertura validita fiscale
    select 'X' 
      into V_controllo
      from validita_fiscale
     where dal = to_date('01012005','ddmmyyyy')
     ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RAISE USCITA;
  END;

  V_controllo := null;
  BEGIN 
-- Salvataggio CAFA: controllo esistenza tabella
     select 'X'
       into V_controllo
       from dual
     where exists ( select 'x' from obj where object_name = 'CAFA_FINANZIARIA05')
     ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    V_controllo := 'Y';
  END;
  IF V_controllo = 'Y' THEN
   BEGIN
-- salvataggio tabella
     v_comando := 'create table cafa_finanziaria05 as select * from carichi_familiari where anno = 2005';
     si4.sql_execute(V_comando);
   END;
  END IF;

  IF D_tipo = '2' THEN
  V_controllo := null;
  BEGIN 
-- controllo esistenza voce sul dizionario
    select 'X' 
      into V_controllo
      from contabilita_voce   covo
         , voci_economiche    voec
     where voec.codice = covo.voce
       and covo.voce   = D_voce
       and covo.sub    = '*'
       and voec.classe = 'V'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RAISE USCITA;
  END;

  V_controllo := null;
  BEGIN 
-- controllo esistenza voce sui movimenti di gennaio
    select 'X' 
      into V_controllo
      from dual
     where exists (select 'x'
      from movimenti_contabili moco
     where moco.voce   = D_voce
       and moco.anno = 2005
       and moco.mese = 1
       and moco.mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N'))
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RAISE USCITA;
  END;

  V_controllo := null;
  BEGIN 
-- controllo apertura Febbraio 2004
    select 'X' 
      into V_controllo
      from riferimento_retribuzione
     where anno = 2005
       and mese = 2
       and mensilita in ( select mensilita 
                            from mensilita
                           where tipo = 'N'
                             and mese = 2
                         )
     ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RAISE USCITA;
  END;

  V_controllo := null;
  BEGIN 
-- controllo esistenza tabella
     select 'X'
       into V_controllo
       from dual
     where exists ( select 'x' from obj where object_name = 'MOFI_FINANZIARIA05')
     ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    V_controllo := 'Y';
  END;
  IF V_controllo = 'Y' THEN
   BEGIN
-- salvataggio tabella
     v_comando := 'create table mofi_finanziaria05 as select * from movimenti_fiscali where anno = 2005';
     si4.sql_execute(V_comando);
   END;
  END IF;

  V_controllo := null;
  BEGIN 
-- controllo esistenza tabella
     select 'X'
       into V_controllo
       from dual
     where exists ( select 'x' from obj where object_name = 'MOCO_FINANZIARIA05')
     ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    V_controllo := 'Y';
  END;
  IF V_controllo = 'Y' THEN
   BEGIN
-- salvataggio tabella
     v_comando := 'create table moco_finanziaria05 as select * from movimenti_contabili '||
                  'where anno = 2005 and mese = 1 '||
                  '  and (   voce in (select codice from voci_economiche where automatismo like ''DED%'') '||
                  '       or voce in (select codice from voci_economiche where automatismo like ''DET%'') '||
                  '       or voce = '''||D_voce||''')';
     si4.sql_execute(V_comando);
   END;
   
  END IF;
 
 END IF;
  
 BEGIN 
--
-- Attiva il conguaglio su febbraio per i record di CAFA di gennaio con valori significativi sui
-- carichi familiari
--
   update carichi_familiari cafa
      set mese_att = 2
    where anno = 2005 and mese = 1
      and cond_fis is not null
      and mese = mese_att
      and exists (select 'x' from movimenti_fiscali
                   where anno = 2005
                     and mese = 1
                     and mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
                     and ci = cafa.ci)
      and D_tipo in ('1','2')
   ;
   commit;
 END;
 IF D_tipo = '2' THEN
--
-- Verifica che sia il primo lancio, altrimenti blocca:
--
V_controllo := null;
  BEGIN 
-- controllo esistenza tabella 
     select 'X'
       into V_controllo
       from dual
     where exists ( select 'x' from obj where object_name = 'FATTO_F0502')
     ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    V_controllo := 'Y';
  END;
 IF V_controllo = 'X' THEN
    RAISE USCITA;
 ELSE

   BEGIN 
-- esegue la stampa dei dati estratti
   P_riga := 1;  
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad(' ',5,' ')||' '||
          lpad('Mens',4,' ')||' '||
          lpad('R.Lordo',13,' ')||' '||
          lpad('D.B.Auto',13,' ')||' '||
          lpad('D.B.Vari',13,' ')||' '||
          lpad('D.A.Auto',13,' ')||' '||
          lpad('D.A.Vari',13,' ')||' '||
          lpad('Ded.Fam',13,' ')||' '||
          lpad('Tot.Ded',13,' ')||' '||
          lpad('Ipn.Netto',13,' ')
     from dual
   ;
   P_riga := 2;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , lpad('-',132,'-')
     from dual;
 FOR CUR_APST IN
    (select 'Orig.'||' '||
          lpad(moco.mensilita,4,' ')||' '||
          lpad(to_char( sum(decode(voec.automatismo,'IRPEF_ORD',tar,0))
                       + sum(decode(voec.automatismo,'DED_MEN',imp,0))
                       + sum(decode(voec.automatismo,'DED_BASE',decode(sign(imp),-1,imp*-1,0),0))
                       + sum(decode(voec.automatismo,'DED_AGG',decode(sign(imp),-1,imp*-1,0),0))
                       + sum(decode(voec.automatismo,'',imp*-1,0))
                       ,'999999990.99'), 13,' ')||' '|| 
       lpad(to_char( sum(decode(voec.automatismo,'DED_BASE',decode(sign(imp),-1,0,imp),0))
                   ,'999999990.99'), 13,' ')||' '|| 
       lpad(to_char( sum(decode(voec.automatismo,'DED_BASE',decode(sign(imp),-1,imp*-1,0),0)) 
                   ,'999999990.99'), 13,' ')||' '|| 
       lpad(to_char( sum(decode(voec.automatismo,'DED_AGG',decode(sign(imp),-1,0,imp),0)) 
                   ,'999999990.99'), 13,' ')||' '|| 
       lpad(to_char( sum(decode(voec.automatismo,'DED_AGG',decode(sign(imp),-1,imp*-1,0),0)) 
                   ,'999999990.99'), 13,' ')||' '|| 
       lpad(to_char( sum(decode(voec.automatismo,'',imp*-1,0))
                   ,'999999990.99'), 13,' ')||' '|| 
       lpad(to_char( sum(decode(voec.automatismo,'DED_BASE',decode(sign(imp),-1,0,imp),0))
                   + sum(decode(voec.automatismo,'DED_BASE',decode(sign(imp),-1,imp*-1,0),0))
                   + sum(decode(voec.automatismo,'DED_AGG',decode(sign(imp),-1,0,imp),0))
                   + sum(decode(voec.automatismo,'DED_AGG',decode(sign(imp),-1,imp*-1,0),0))
                   + sum(decode(moco.voce,D_voce,imp*-1,0)) 
                   ,'999999990.99'), 13,' ')||' '|| 
       lpad(to_char( sum(decode(voec.automatismo,'IRPEF_ORD',decode(sign(tar),-1,0,tar),0))
                   ,'999999990.99'), 13,' ') testo
    from movimenti_contabili moco
       ,voci_economiche voec
   where moco.voce = voec.codice
     and (   voec.automatismo in ('IRPEF_ORD','DED_BASE','DED_AGG','DED_MEN')
          or moco.voce = D_voce)
     and moco.anno = 2005
     and moco.mese = 1
     and moco.mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
   group by moco.mensilita
   ) LOOP 

   P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , CUR_APST.testo from dual
   ;
   END LOOP;
   END;

 BEGIN
--
-- Aumenta l'imponibile fiscale della voce presuntiva di ded. fam.
--
   update movimenti_fiscali mofi
   set ipn_ord = (select nvl(mofi.ipn_ord,0) - sum(imp)
                    from movimenti_contabili
                   where anno = mofi.anno
                     and mese = mofi.mese
                     and mensilita = mofi.mensilita
                     and voce = D_voce
                     and ci = mofi.ci
                 )
   where anno = 2005
     and mese = 1
     and mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
     and exists (select 'x' from movimenti_contabili
                  where anno = mofi.anno
                    and mese = mofi.mese
                    and mensilita = mofi.mensilita
                    and voce = D_voce
                    and ci = mofi.ci
                )
   ;
   commit;
 END;
 BEGIN
--
-- Carica l'importo della voce presuntiva di ded. fam. sulle deduzioni, facendola figurare
-- anche su MOCO come *R* per poterla leggere poi a conguaglio
--
   insert into movimenti_contabili
   (ci,anno,mese,mensilita,voce,sub,riferimento,input,imp)
   select moco.ci,moco.anno,moco.mese,'*R*',voec.codice,'*',moco.riferimento,'C',moco.imp*-1
     from movimenti_contabili moco
        , voci_economiche voec
    where moco.anno = 2005 
      and moco.mese = 1
      and moco.mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
      and moco.voce = D_voce
      and voec.automatismo = 'DET_CON'
      and exists (select 'x' from carichi_familiari
                  where ci = moco.ci
                    and coniuge is not null
                    and anno = 2005 and mese = 1
                )
   ;
   commit;
   insert into movimenti_contabili
   (ci,anno,mese,mensilita,voce,sub,riferimento,input,imp)
   select moco.ci,moco.anno,moco.mese,'*R*',voec.codice,'*',moco.riferimento,'C',moco.imp*-1
     from movimenti_contabili moco
        , voci_economiche voec
    where moco.anno = 2005 
      and moco.mese = 1
      and moco.mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
      and moco.voce = D_voce
      and voec.automatismo = 'DET_FIG'
      and exists (select 'x' from carichi_familiari
                  where ci = moco.ci
                    and coniuge is null
                    and (figli is not null or
                         figli_dd is not null or
                         figli_mn is not null or
                         figli_mn_dd is not null or
                         figli_hh is not null or
                         figli_hh_dd is not null
                        )
                    and anno = 2005 and mese = 1
                 )
   ;
   commit;
   insert into movimenti_contabili
   (ci,anno,mese,mensilita,voce,sub,riferimento,input,imp)
   select moco.ci,moco.anno,moco.mese,'*R*',voec.codice,'*',moco.riferimento,'C',moco.imp*-1
     from movimenti_contabili moco
        , voci_economiche voec
    where moco.anno = 2005 
      and moco.mese = 1
      and moco.mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
      and moco.voce = D_voce
      and voec.automatismo = 'DET_ALT'
      and exists (select 'x' from carichi_familiari
                  where ci = moco.ci
                    and coniuge is null
                    and figli is null 
                    and figli_dd is null 
                    and figli_mn is null 
                    and figli_mn_dd is null 
                    and figli_hh is null 
                    and figli_hh_dd is null
                    and altri is not null
                    and anno = 2005 and mese = 1
                )
   ;
   commit;
   update movimenti_fiscali mofi
   set ded_con = (select nvl(mofi.ded_con,0) + sum(imp*-1)
                    from movimenti_contabili
                   where anno = mofi.anno
                     and mese = mofi.mese
                     and mensilita = mofi.mensilita
                     and voce = D_voce
                     and ci = mofi.ci
                 )
   where anno = 2005
     and mese = 1
     and mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
     and exists (select 'x' from movimenti_contabili
                  where anno = mofi.anno
                    and mese = mofi.mese
                    and mensilita = mofi.mensilita
                    and voce = D_voce
                    and ci = mofi.ci
                )
     and exists (select 'x' from carichi_familiari
                  where ci = mofi.ci
                    and coniuge is not null
                    and anno = 2005 and mese = 1
                )
   ;
   commit;
   update movimenti_fiscali mofi
   set ded_fig = (select nvl(mofi.ded_fig,0) + sum(imp*-1)
                    from movimenti_contabili
                   where anno = mofi.anno
                     and mese = mofi.mese
                     and mensilita = mofi.mensilita
                     and voce = D_voce
                     and ci = mofi.ci
                 )
   where anno = 2005
     and mese = 1
     and mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
     and exists (select 'x' from movimenti_contabili
                  where anno = mofi.anno
                    and mese = mofi.mese
                    and mensilita = mofi.mensilita
                    and voce = D_voce
                    and ci = mofi.ci
                )
     and exists (select 'x' from carichi_familiari
                  where ci = mofi.ci
                    and coniuge is null
                    and (figli is not null or
                         figli_dd is not null or
                         figli_mn is not null or
                         figli_mn_dd is not null or
                         figli_hh is not null or
                         figli_hh_dd is not null
                        )
                    and anno = 2005 and mese = 1
                 )
   ;
   commit;
   update movimenti_fiscali mofi
   set ded_alt = (select nvl(mofi.ded_alt,0) + sum(imp*-1)
                    from movimenti_contabili
                   where anno = mofi.anno
                     and mese = mofi.mese
                     and mensilita = mofi.mensilita
                     and voce = D_voce
                     and ci = mofi.ci
                 )
   where anno = 2005
     and mese = 1
     and mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
     and exists (select 'x' from movimenti_contabili
                  where anno = mofi.anno
                    and mese = mofi.mese
                    and mensilita = mofi.mensilita
                    and voce = D_voce
                    and ci = mofi.ci
                )
     and exists (select 'x' from carichi_familiari
                  where ci = mofi.ci
                    and coniuge is null
                    and figli is null 
                    and figli_dd is null 
                    and figli_mn is null 
                    and figli_mn_dd is null 
                    and figli_hh is null 
                    and figli_hh_dd is null
                    and altri is not null
                    and anno = 2005 and mese = 1
                )
   ;
   commit;
 END;
 BEGIN
--
-- Carica l'importo delle voci di ded. base e agg. "fissate" nelle variabili in MOFI
-- sia nei campi specifici che nell'imponibile fiscale, dopo averle girate di segno per 
-- renderle omogenee rispetto a quelle calcolate in automatico
--
   update movimenti_contabili moco
      set imp = imp*-1
     where anno = 2005
       and mese = 1
       and mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
       and voce = (select codice from voci_economiche where automatismo = 'DED_BASE')
       and exists (select 'x' from movimenti_fiscali
                    where anno = moco.anno 
                      and mese = moco.mese
                      and mensilita = moco.mensilita
                      and ci = moco.ci
                      and nvl(ded_base,0) = 0
                   )
   ;
   commit;   
   update movimenti_fiscali mofi
      set (ipn_ord,ded_base) = 
          (select nvl(mofi.ipn_ord,0) + sum(imp), sum(imp)
             from movimenti_contabili
            where anno = mofi.anno
              and mese = mofi.mese
              and mensilita = mofi.mensilita
              and voce = (select codice from voci_economiche where automatismo = 'DED_BASE')
              and ci = mofi.ci
          )
      where anno = 2005
        and mese = 1
        and mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
        and nvl(ded_base,0) = 0
        and exists (select 'x' from movimenti_contabili
                     where anno = mofi.anno
                       and mese = mofi.mese
                       and mensilita = mofi.mensilita
                       and voce = (select codice from voci_economiche where automatismo = 'DED_BASE')
                       and ci = mofi.ci
                   )
   ;
   commit;
   update movimenti_contabili moco
      set imp = imp*-1
     where anno = 2005
       and mese = 1
       and mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
       and voce = (select codice from voci_economiche where automatismo = 'DED_AGG')
       and exists (select 'x' from movimenti_fiscali
                    where anno = moco.anno 
                      and mese = moco.mese
                      and mensilita = moco.mensilita
                      and ci = moco.ci
                      and nvl(ded_agg,0) = 0
                   )
   ;
   commit;   
   update movimenti_fiscali mofi
      set (ipn_ord,ded_agg) =
          (select nvl(mofi.ipn_ord,0) + sum(imp), sum(imp)
             from movimenti_contabili
            where anno = mofi.anno
              and mese = mofi.mese
              and mensilita = mofi.mensilita
              and voce = (select codice from voci_economiche where automatismo = 'DED_AGG')
              and ci = mofi.ci
          )
      where anno = 2005
        and mese = 1
        and mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
        and nvl(ded_agg,0) = 0
        and exists (select 'x' from movimenti_contabili
                     where anno = mofi.anno
                       and mese = mofi.mese
                       and mensilita = mofi.mensilita
                       and voce = (select codice from voci_economiche where automatismo = 'DED_AGG')
                       and ci = mofi.ci
                   )
   ;
   commit;
 END;
 BEGIN
--
-- Ricalcola il totale deduzioni e le deduzioni fiscali effettivamente attribuite
--
   update movimenti_fiscali
      set ded_tot = nvl(ded_base,0)+nvl(ded_agg,0)+nvl(ded_con,0)+nvl(ded_fig,0)+nvl(ded_alt,0)
        , ded_fis = least( ipn_ord
                         , nvl(ded_base,0)+nvl(ded_agg,0)+nvl(ded_con,0)+nvl(ded_fig,0)+nvl(ded_alt,0)
                         ) 
    where anno = 2005
      and mese = 1
      and mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
   ;
   commit;
 END;
 
 BEGIN
--
-- crea una tabella di appoggio per indicare che la fase è stata già eseguita e bloccare lanci successivi 
--
     v_comando := 'create table FATTO_F0502 (campo varchar(1))';
     si4.sql_execute(V_comando);
 END;
-- stampa i risultati dopo le update
   P_riga := 40;
   BEGIN
     FOR CUR_APST2 in 
        (select 'Mod. '||' '||
          lpad(mofi.mensilita,4,' ')||' '||
          lpad(to_char( sum(ipn_ord) ,'999999990.99'), 13,' ')||' '|| 
          lpad(to_char( sum(ded_base) ,'999999990.99'), 13,' ')||' '|| 
          lpad(' ',13,' ')||' '||
          lpad(to_char( sum(ded_agg) ,'999999990.99'), 13,' ')||' '|| 
          lpad(' ',13,' ')||' '||
          lpad(to_char( sum(nvl(ded_con,0)+nvl(ded_fig,0)+nvl(ded_alt,0))
                       ,'999999990.99'), 13,' ')||' '|| 
          lpad(to_char( sum(ded_tot) ,'999999990.99'), 13,' ')||' '|| 
          lpad(to_char( sum(ipn_ord-ded_fis) ,'999999990.99'), 13,' ') testo
      from movimenti_fiscali mofi
     where mofi.anno = 2005
       and mofi.mese = 1
       and mofi.mensilita in (select mensilita from mensilita where mese = 1 and tipo = 'N')
     group by mofi.mensilita
     ) LOOP
       P_riga := P_riga + 1;
   insert into a_appoggio_stampe
   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
   select prenotazione, 1, 1, P_riga
        , cur_apst2.testo
     from dual
   ;
END LOOP;
  END;

 END IF; -- se non esiste tab. FATTO_F0502
 END IF; -- se tipo = '2'


  EXCEPTION WHEN USCITA THEN
     update a_prenotazioni
        set prossimo_passo = 91
          , errore = 'P00603'
     where no_prenotazione = prenotazione
    ;
    commit;
  END;
 END;
END;
/
