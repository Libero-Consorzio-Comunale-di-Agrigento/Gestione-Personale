CREATE OR REPLACE PACKAGE PECARGLA IS
/******************************************************************************
 NOME:        PECARGLA
 DESCRIZIONE: Archiviazione Denuncia Gla
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  Il package cancella quanto gia eventualmente registrato sulle tabelle Denuncia_gla e Denuncia_importi_gla.
               Il personale da archiviare e estratto  da CUR_CI, Individuato il personale
               soggetto alla denuncia, per ogni record del cursore si accede ad un secondo cursore (CUR_VACA) che
			   estrae i dettagli mensili.

 		   II PARAMETRO D_anno determina quale anno elaborare.
               Il PARAMETRO D_gestione determina quale gestione elaborare, valore di dafault %.
               Il PARAMETRO D_tipo     determina il tipo di elaborazione da effettuare, valori possibili T (Tutti)
			   ed S (Singolo individuo), di default T .
               Il PARAMETRO D_fascia    indica la fascia di gestione (campo fascia della tabella gestioni), valore di
			   defaul %.
	 	   Il codice D_ci indica il codice individuale da elabotare.
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  03/04/2003 MV
 2.0  08/02/2005 MS     Modifiche per att. 7307
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY PECARGLA IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V2.0 del 01/02/2005';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
 BEGIN
DECLARE
  D_ente          varchar(4);
  D_ambiente      varchar(8);
  D_utente        varchar(8);
  D_anno          number(4);
  D_fascia        varchar(2);
  D_ini_a         varchar(8);
  D_fin_a         varchar(8);
  D_gestione      varchar(4);
  D_tipo          varchar(1);
  D_ci            number(8);
  D_assicurazione varchar(9);
  D_dal           date;
  D_al            date;
  D_dal_pegi      varchar(10);
  D_dal_riferimento      varchar(10);
  D_max_riferimento      date;
  D_min_riferimento      date;
  D_conta                number;
  D_progressivo          number;
  D_compenso             varchar(1);

  D_prg_tar             number;
  D_imp1                number;
  D_imp2                number;
  D_prg_importo1        number;
  D_inserito            number;

--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN
BEGIN
  select valore
    into D_tipo
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_TIPO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_tipo := 'T';
END;
--dbms_output.put_line('tipo'||D_tipo);

BEGIN
  select to_number(valore)
    into D_ci
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_CI'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    D_ci := 0;
END;
-- dbms_output.put_line('ci'||D_ci);

BEGIN
  select valore
    into D_gestione
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_GESTIONE'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_gestione := '%';
END;


BEGIN
  select to_number(valore)
       , '0101'||valore
       , '3112'||valore
    into D_anno
       , D_ini_a
       , D_fin_a
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_ANNO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    select anno
         , '0101'||to_char(anno)
         , '3112'||to_char(anno)
      into D_anno
         , D_ini_a
         , D_fin_a
      from riferimento_fine_anno
     where rifa_id = 'RIFA'
  ;
END;
-- dbms_output.put_line('Anno'||D_anno);
begin
      select valore
       into D_fascia
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_FASCIA'
      ;
exception when no_data_found then
    D_fascia := '%';
end;

BEGIN
  select ente     D_ente
       , utente   D_utente
       , ambiente D_ambiente
    into D_ente,D_utente,D_ambiente
    from a_prenotazioni
   where no_prenotazione = prenotazione
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_ente     := null;
       D_utente   := null;
       D_ambiente := null;
END;

BEGIN
  select 'x'
    into D_compenso
    from estrazione_valori_contabili
   where estrazione = 'DENUNCIA_GLA'
     and colonna = 'COMPENSO'
     and to_date(D_fin_a,'ddmmyyyy') between dal and nvl(al,to_date('3333333','j'))
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_compenso := '';
END;

D_Progressivo := 0;

-- Cancellazione Archiviazione precedente relativa all'anno richiesto

     delete from denuncia_gla degl
      where degl.anno             = D_anno
        and degl.gestione      like D_gestione
	  and gestione   in (select codice
                             from gestioni
				    where nvl(fascia,' ') like D_fascia)
        and (    D_tipo = 'T'
                 or (D_tipo = 'S' and degl.ci = D_ci)
             )
		and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = degl.ci
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = D_ente
                         and ambiente    = D_ambiente
                         and utente      = D_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                     )
                  )
          )
     ;
	 delete from denuncia_importi_gla digl
      where digl.anno             = D_anno
        and digl.gestione      like D_gestione
	  and gestione   in (select codice
                             from gestioni
				    where nvl(fascia,' ') like D_fascia)
        and (    D_tipo = 'T'
                 or (D_tipo = 'S' and digl.ci = D_ci)
             )
		and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = digl.ci
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = D_ente
                         and ambiente    = D_ambiente
                         and utente      = D_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                     )
                  )
          )
     ;
commit;

-- Personale da archiviare

FOR CUR_CI IN
   (select pegi.ci
          ,pegi.gestione
	       ,min(pegi.dal )                                  dal
	     --  max(nvl(al,to_date('3333333','j')))        al,
		    ,decode( max(nvl(pegi.al,to_date('3333333','j'))), nvl(pegi1.al,to_date('3333333','j')), to_date('3333333','j')
                                                            , max(pegi.al)
                   )   al
	       , substr(max(to_char(pegi.dal,'yyyymmdd')||pegi.attivita),9) attivita
		    , pegi1.al   pegi1_al
	  from    periodi_giuridici pegi
	        ,  periodi_giuridici pegi1
     where pegi.rilevanza = 'S'
	  and pegi.rilevanza = pegi1.rilevanza
	  and pegi.gestione = pegi1.gestione
	  and pegi.ci = pegi1.ci
	  and pegi.gestione like D_gestione
	  and pegi.gestione   in (select codice
                             from gestioni
				    where nvl(fascia,' ') like D_fascia)
	  and (    D_tipo = 'T'
                 or (D_tipo = 'S' and pegi.ci = D_ci)
             )
	  and pegi.dal <= to_date(D_fin_a,'ddmmyyyy')
--      and nvl(pegi.al,to_date('3333333','j')) >= to_date(D_ini_a,'ddmmyyyy')
	  and exists (select 'x'
	               from  periodi_retributivi pere
                      , trattamenti_previdenziali trpr
                  where pere.periodo between to_date(D_ini_a,'ddmmyyyy')
                            and to_date(D_fin_a,'ddmmyyyy')
                   and ci                 = pegi.ci
                   and anno               = D_anno
                   and pere.competenza    = 'A'
                   and pere.gestione      like D_gestione
                   and pere.trattamento   = trpr.codice
                   and trpr.previdenza    is not null
                   and trpr.previdenza    = 'INPS'
                 )
	  and pegi1.dal      =
                         (select max(dal) from periodi_giuridici
                           where ci        =  pegi1.ci
						     and rilevanza = 'S'
                             and dal       <= to_date(D_fin_a,'ddmmyyyy')
--                             and nvl(al,to_date('3333333','j')) >= to_date(D_ini_a,'ddmmyyyy') 
                         )
	  and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = pegi.ci
              and (   rain.cc is null
                   or exists
                     (select 'x'
                        from a_competenze
                       where ente        = D_ente
                         and ambiente    = D_ambiente
                         and utente      = D_utente
                         and competenza  = 'CI'
                         and oggetto     = rain.cc
                     )
                  )
          )
      GROUP BY pegi.ci, pegi.gestione, pegi1.al
   ) LOOP
-- dbms_output.put_line('ci'||CUR_CI.ci);
-- dbms_output.put_line('dal'||CUR_CI.dal);
-- dbms_output.put_line('al'||CUR_CI.al);

   insert into denuncia_gla
          ( anno
          , ci
          , gestione
          , attivita
	       , utente
	       , data_agg
          )
   select   D_anno
        , CUR_CI.ci
        , CUR_CI.gestione
	     , CUR_CI.attivita
	     , D_utente
	     , sysdate
	 from dual
     ;

-- Estrarre il dato Assicurazione
begin
select substr(rtrim(ltrim(codice_iad)),1,3)
into   D_assicurazione
from   rapporti_retributivi
where  ci = CUR_CI.ci;
exception
  when no_data_found then
     null;
end;
-- Dettagli mensili

    D_prg_tar := 0;
    D_imp1    := 0;
    D_imp2    := 0;
    D_Prg_importo1 := 0;
    D_inserito := 0;

FOR CUR_VACA IN
   (select moco_mese,
           nvl(max(decode(vaca.colonna
                     , 'IMPONIBILE_01', substr(esvc.note, instr(esvc.note,'<')+1, instr(esvc.note,'>')-2)
                                      , NULL)),38641)                     limite, 
--           nvl(max(decode(vaca.colonna
--                    ,'IMPONIBILE_01' , substr(esvc.note, instr(esvc.note,'<',instr(esvc.note,'>'))+1
--                                                     , (instr(esvc.note, '>',instr(esvc.note,'>')+1 )-1
--                                                                            -instr(esvc.note,'<',instr(esvc.note,'>'))
--                                           ) 
--                       ), null)),84049)                                   limite_max,
           max(decode(vaca.colonna
                     ,'ALIQUOTA_01' ,substr(esvc.note,instr(esvc.note,'<')+1, instr(esvc.note,'>')-2) 
                                    , null))                              aliquota1,
           max(decode(vaca.colonna
                    ,'ALIQUOTA_01' , substr(esvc.note, instr(esvc.note,'<',instr(esvc.note,'>'))+1
                                                     , (instr(esvc.note, '>',instr(esvc.note,'>')+1 )-1
                                                                            -instr(esvc.note,'<',instr(esvc.note,'>'))
                                           ) 
                       ), null))                                          aliquota2,
           round(sum(decode( vaca.colonna
                          , 'IMPONIBILE_01', vaca.valore
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'IMPONIBILE_01', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                 )
                            * nvl(max(decode( vaca.colonna
                                        , 'IMPONIBILE_01', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)          Tariffa1,
           round(sum(decode( vaca.colonna
                          , 'IMPONIBILE', vaca.valore
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'IMPONIBILE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                 )
                            * nvl(max(decode( vaca.colonna
                                        , 'IMPONIBILE', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)          Tariffa,
	   nvl(max(decode(vaca.colonna
                     ,'ALIQUOTA' ,substr(esvc.note,instr(esvc.note,'<')+1, instr(esvc.note,'>')-2) 
                                    , null))    
              ,round(max(decode( vaca.colonna
                          , 'ALIQUOTA', vaca.valore
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'ALIQUOTA', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                        ,2)
                            * nvl(max(decode( vaca.colonna
                                        , 'ALIQUOTA', nvl(esvc.arrotonda,0.01)
                                                      , '')),1) )           Qta,
	   round(sum(decode( vaca.colonna
                          , 'CONTRIBUTO_01', vaca.valore
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'CONTRIBUTO_01', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                       )
                            * nvl(max(decode( vaca.colonna
                                        , 'CONTRIBUTO_01', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)            Importo1,
	   round(sum(decode( vaca.colonna
                          , 'CONTRIBUTO', vaca.valore
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'CONTRIBUTO', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                       )
                            * nvl(max(decode( vaca.colonna
                                        , 'CONTRIBUTO', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)            Importo,
	   round(sum(decode( vaca.colonna
                          , 'ECCEDENZA_01', vaca.valore
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'ECCEDENZA_01', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                        )
                            * nvl(max(decode( vaca.colonna
                                        , 'ECCEDENZA_01', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)            Eccedenza_01,
	   round(sum(decode( vaca.colonna
                          , 'ECCEDENZA_02', vaca.valore
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'ECCEDENZA_02', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                         )
                            * nvl(max(decode( vaca.colonna
                                        , 'ECCEDENZA_02', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)            Eccedenza_02,
	   round(sum(decode( vaca.colonna
                          , 'ECCEDENZA_03', vaca.valore
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'ECCEDENZA_03', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                        )
                            * nvl(max(decode( vaca.colonna
                                        , 'ECCEDENZA_03', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)            Eccedenza_03
      from  valori_contabili_annuali vaca,
	        estrazione_valori_contabili esvc
     where esvc.estrazione        = vaca.estrazione
       and esvc.colonna           = vaca.colonna
	 and ci = CUR_CI.ci
       and anno = D_anno
       and mese   = 12
	 and mensilita = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
	  and vaca.estrazione = 'DENUNCIA_GLA'
	  and vaca.colonna           in ('IMPONIBILE','ALIQUOTA','CONTRIBUTO'
                                         ,'IMPONIBILE_01','ALIQUOTA_01','CONTRIBUTO_01'
                                         ,'ECCEDENZA_01','ECCEDENZA_02','ECCEDENZA_03')
	  and riferimento between CUR_CI.dal and nvl(CUR_CI.al,to_date('3333333','j'))
	  and esvc.dal              <= nvl(CUR_CI.al, to_date('3333333','j'))
	  and nvl(esvc.al,to_date('3333333','j'))
                                      >= CUR_CI.dal
        and vaca.riferimento between   esvc.dal
                                     and nvl(esvc.al,to_date('3333333','j'))
	  group by ci, moco_mese
   ) LOOP

-- dbms_output.put_line('CUR_VACA.limite '||CUR_VACA.limite);
-- dbms_output.put_line('CUR_VACA.aliquota1 '||to_number(CUR_VACA.aliquota1));
-- dbms_output.put_line('CUR_VACA.aliquota2 '||CUR_VACA.aliquota2);
-- dbms_output.put_line('CUR_VACA.importo '||CUR_VACA.importo);
-- dbms_output.put_line('CUR_VACA.importo1 '||CUR_VACA.importo1);
   
   D_prg_tar := D_prg_tar + nvl(CUR_VACA.tariffa1,0);
   D_prg_importo1 := D_prg_importo1 + nvl(CUR_VACA.importo1,0);

-- Calcolo di dal e al di denuncia_importi_gla
   
begin
select nvl( max(riferimento), last_day(to_date(lpad(CUR_VACA.moco_mese,2,0)||D_anno,'mmyyyy')) )
     , nvl( min(riferimento), to_date(lpad(CUR_VACA.moco_mese,2,0)||D_anno,'mmyyyy') )
  into D_max_riferimento, D_min_riferimento
   from  valori_contabili_annuali vaca
   where moco_mese = CUR_VACA.moco_mese
   and anno = D_anno
   and riferimento between CUR_CI.dal and CUR_CI.al
   and ci = CUR_CI.ci
   and vaca.estrazione = 'DENUNCIA_GLA'
   and vaca.colonna    = decode(D_compenso,'x','COMPENSO','CONTRIBUTO')
   and mese   = 12
   and mensilita = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
   ;

end;

-- Calcolo del Dal e Al
begin
select decode( to_char(pegi.dal,'yyyymm')
             , to_char(D_min_riferimento,'yyyymm'), least(pegi.dal,D_min_riferimento)
                                                  , to_date('01'||to_char(D_min_riferimento,'mmyyyy'),'ddmmyyyy')
              )
	 into D_dal
      from periodi_giuridici pegi
      where rilevanza = 'S'
	  and ci = CUR_CI.ci
	  and D_max_riferimento between pegi.dal and nvl(pegi.al,to_date('3333333','j'))
	  ;
 
 D_al:= D_max_riferimento;
 
exception
  when no_data_found then

-- dbms_output.put_line('exc no data found');
	
	select decode( to_char(max(pegi.dal),'yyyymm')
                   , to_char(D_min_riferimento,'yyyymm'), least(max(pegi.dal),D_min_riferimento)
                                                        ,to_date('01'||to_char(D_min_riferimento,'mmyyyy'),'ddmmyyyy')
                   )
           , max(al)
	 into D_dal, D_al
      from periodi_giuridici pegi
      where rilevanza = 'S'
	  and ci = CUR_CI.ci
	  and pegi.al  <= D_max_riferimento
	  ;

end;

-- dbms_output.put_line('D_dal'||D_dal);
-- dbms_output.put_line('D_al'||D_al);

IF nvl(CUR_VACA.tariffa,0) != 0 or nvl(CUR_VACA.importo,0) != 0 THEN
   BEGIN
   insert into denuncia_importi_gla
          ( digl_id
          , anno
          , ci
          , gestione
          , mese
		  , dal
		  , al
		  , assicurazione
		  , tariffa
		  , qta
		  , importo
		  , eccedenza_01
		  , eccedenza_02
		  , eccedenza_03
		  , utente
		  , data_agg
          )
   select digl_sq.nextval
          , D_anno
          , CUR_CI.ci
          , CUR_CI.gestione
		  , CUR_VACA.moco_mese
		  , D_dal
		  , D_al
		  , D_assicurazione
		  , CUR_VACA.tariffa
		  , CUR_VACA.qta
		  , CUR_VACA.importo
		  , CUR_VACA.eccedenza_01
		  , CUR_VACA.eccedenza_02
		  , CUR_VACA.eccedenza_03
		  , D_utente
		  , sysdate
	 from dual
    ;
    END;
END IF; -- fine trattamento IMPONIBILE e ALIQUOTA senza scaglioni

IF nvl(CUR_VACA.tariffa1,0) != 0 or nvl(CUR_VACA.importo1,0) != 0 THEN

-- Si calcola l'importo del contributo sul 1^ scaglione nel mese di supero
   IF D_prg_tar - CUR_VACA.tariffa1 < to_number(CUR_VACA.limite) THEN
      D_imp1 := round( ( CUR_VACA.tariffa1 - greatest(0,D_prg_tar-to_number(CUR_VACA.limite)) ) 
                      * to_number(CUR_VACA.aliquota1) / 100);
--      D_imp2 := CUR_VACA.importo1 - nvl(D_imp1,0);
      D_imp2 := round( ( least(CUR_VACA.tariffa1,D_prg_tar-to_number(CUR_VACA.limite)) ) 
                      * to_number(CUR_VACA.aliquota2) / 100);
   ELSE
-- anche se non è mese di supero, memorizza l'importo del cursore in entrambi 
-- i campi di appoggio per facilitare l'insert successiva
      D_imp1 := CUR_VACA.importo1;
      D_imp2 := CUR_VACA.importo1;
   END IF;

-- inserimento del 1^ scaglione
   IF D_prg_tar < to_number(CUR_VACA.limite) 
   OR D_prg_tar > to_number(CUR_VACA.limite) AND
      D_prg_tar - CUR_VACA.tariffa1 < to_number(CUR_VACA.limite) 
   THEN
   insert into denuncia_importi_gla
          ( digl_id
          , anno
          , ci
          , gestione
          , mese
		  , dal
		  , al
		  , assicurazione
		  , tariffa
		  , qta
		  , importo
		  , eccedenza_01
		  , eccedenza_02
		  , eccedenza_03
		  , utente
		  , data_agg
          )
   select digl_sq.nextval
          , D_anno
          , CUR_CI.ci
          , CUR_CI.gestione
		  , CUR_VACA.moco_mese
		  , D_dal
		  , D_al
		  , D_assicurazione
		  , CUR_VACA.tariffa1 - greatest(0,D_prg_tar-to_number(CUR_VACA.limite))
		  , to_number(CUR_VACA.aliquota1)
		  , D_imp1
		  , CUR_VACA.eccedenza_01
		  , CUR_VACA.eccedenza_02
		  , CUR_VACA.eccedenza_03
		  , D_utente
		  , sysdate
	 from dual
    ;
   END IF;

-- inserimento del 1^ scaglione
   IF D_prg_tar > to_number(CUR_VACA.limite) 
   THEN
   insert into denuncia_importi_gla
          ( digl_id
          , anno
          , ci
          , gestione
          , mese
		  , dal
		  , al
		  , assicurazione
		  , tariffa
		  , qta
		  , importo
		  , eccedenza_01
		  , eccedenza_02
		  , eccedenza_03
		  , utente
		  , data_agg
          )
   select digl_sq.nextval
          , D_anno
          , CUR_CI.ci
          , CUR_CI.gestione
		  , CUR_VACA.moco_mese
		  , D_dal
		  , D_al
		  , D_assicurazione
		  , least(CUR_VACA.tariffa1,D_prg_tar-to_number(CUR_VACA.limite))
		  , to_number(CUR_VACA.aliquota2)
                  , D_imp2
		  , CUR_VACA.eccedenza_01
		  , CUR_VACA.eccedenza_02
		  , CUR_VACA.eccedenza_03
		  , D_utente
		  , sysdate
	 from dual
    ;
   END IF;
END IF; -- fine trattamento IMPONIBILE e ALIQUOTA con scaglioni

   END LOOP;  -- CUR_VACA
begin
select sum(importo) 
into d_inserito
from denuncia_importi_gla deig
where deig.ci     = CUR_CI.ci
and deig.gestione = CUR_CI.gestione
and deig.anno     = D_anno
;
if abs(D_inserito - D_prg_importo1) > 2 and d_prg_importo1 != 0 then
D_progressivo := D_progressivo + 1;
   insert into a_segnalazioni_errore (no_prenotazione, passo, progressivo, errore, precisazione)
   values (prenotazione, passo, D_progressivo, 'P06716','per CI: '||to_char(CUR_CI.ci)||
                                            ', Importo da cedolini '||D_prg_importo1 );
end if;
end;

begin
select count(*) 
into   D_conta
from denuncia_importi_gla deig,
     denuncia_importi_gla deig2
where deig.ci     = CUR_CI.ci
and deig.gestione = CUR_CI.gestione
and deig.anno     = D_anno
and deig.ci       = deig2.ci
and deig.anno     = deig2.anno
and deig.gestione = deig2.gestione
and deig.dal      = deig2.dal
and deig.mese    != deig2.mese
;
if D_conta > 1 then
D_progressivo := D_progressivo + 1;
   insert into a_segnalazioni_errore (no_prenotazione, passo, progressivo, errore, precisazione)
   values (prenotazione, passo, D_progressivo, 'P05186',', s. date per CI: '||to_char(CUR_CI.ci)||
                                            ', Dal: '||to_char(D_dal,'dd/mm/yyyy')   );
else
   null;
end if;
end;



   END LOOP; -- CUR_CI
commit;

END;
end;
end;
/
