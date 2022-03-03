CREATE OR REPLACE PACKAGE PECCRCDP IS
/******************************************************************************
 NOME:          PECCRCDP
 DESCRIZIONE:   

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             
 2.0  08/02/2005 MS     Modifiche per att. 7307
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY PECCRCDP IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V2.0 del 08/02/2005';
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
P_previdenza varchar2(6);
P_gestione   varchar2(4);
P_tipo		 varchar2(1);
P_ci		 number(8);
P_dal		 date;
P_al		 date;
i_comp_tfr   NUMBER; 
D_ci		 number(8);

begin
 begin
  -- Estrazione Parametri di Selezione della Prenotazione --
  begin
    select substr(valore,1,6)  D_previdenza
      into P_previdenza
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_PREVIDENZA'
    ;
	 exception
      when no_data_found then
	       P_previdenza := '%'
    ;
  end;
  
  begin
    select substr(valore,1,1)  D_tipo
      into P_tipo
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_TIPO'
    ;
  end;
  
  begin
    select to_number(substr(valore,1,8))  D_ci
      into P_ci
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_CI'
    ;
	 exception
      when no_data_found then
	       P_ci := 0
    ;
  end;
  
  begin
    select substr(valore,1,4)  D_gestione
      into P_gestione
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_GESTIONE'
    ;
	 exception
      when no_data_found then
	       P_gestione := '%'
    ;
  end;

  begin
    select substr(valore,1,4)    D_anno
      into P_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro    = 'P_ANNO'
    ;
	 exception
      when no_data_found then
	       P_anno := null
    ;
  end;

  begin
  select ente     D_ente
           , utente   D_utente
           , ambiente D_ambiente
		into P_ente,P_utente,P_ambiente
        from a_prenotazioni
       where no_prenotazione = prenotazione
      ;
	  exception
      when no_data_found then
	       P_ente := null;
		   P_utente:= null;
		   P_ambiente := null;
   end;		
   
   begin
    select to_date(valore,decode(nvl(length(translate(valore,'a0123456789/',
         'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
    into P_dal
    from a_parametri
    where no_prenotazione = prenotazione
    and parametro       = 'P_DAL'
    ;


    select to_date(valore,decode(nvl(length(translate(valore,'a0123456789/',
         'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
    into P_al
    from a_parametri
    where no_prenotazione = prenotazione
    and parametro       = 'P_AL'
    ;

   exception
    when no_data_found then
    select ini_ela,fin_ela
      into P_dal,P_al
      from riferimento_retribuzione
     where rire_id = 'RIRE'
    ;
   end;   

  select to_char(to_date
                 ('01'||nvl(P_anno,anno),'mmyyyy')
                ,'ddmmyyyy')                                   D_ini_anno
       , to_char(to_date
                 ('3112'||nvl(P_anno,anno),'ddmmyyyy')
                ,'ddmmyyyy')                                   D_fin_anno
       , nvl(P_anno,anno)                                      D_anno
	into P_ini_anno,P_fin_anno,P_anno
    from riferimento_fine_anno
   where rifa_id = 'RIFA'
  ;
  

D_ci :=0;
  
FOR CUR_CI IN
(select ci,
  	  dal,
	  al,
	  rilevanza
 from denuncia_inpdap dedp  
 where dedp.anno=P_anno
 and dedp.gestione like P_gestione
 and dedp.previdenza like P_previdenza
 and (    P_tipo = 'T'
      or ( P_tipo in ('I','V','P') and not exists
          (select 'x' from denuncia_inpdap
            where anno       = P_anno
              and gestione   = dedp.gestione
              and previdenza = dedp.previdenza
              and ci         = dedp.ci
              and nvl(tipo_agg,' ') = decode(P_tipo
                                            ,'P',tipo_agg,
                                                 P_tipo)
           )
          )
       or ( P_tipo = 'C' and ( exists
           (select 'x'
              from riferimento_retribuzione rire
                 , periodi_giuridici pegi
             where rire.rire_id        = 'RIRE'
               and pegi.rilevanza = 'P'
               and pegi.ci         = dedp.ci
               and pegi.dal        =
                  (select max(dal) from periodi_giuridici
                    where rilevanza = 'P'
                      and ci        = pegi.ci
                      and dal      <= nvl(P_al,rire.fin_ela)
                   )
               and pegi.al between nvl(P_dal,rire.ini_ela)
                               and nvl(P_al,rire.fin_ela)
           )
        or exists
          (select 'x'
             from riferimento_retribuzione  rire
                , periodi_giuridici pegi
            where rire.rire_id        = 'RIRE'
              and pegi.rilevanza = 'P'
              and pegi.ci        = dedp.ci
              and pegi.dal       =
                  (select max(dal) from periodi_giuridici
                    where rilevanza = 'P'
                      and ci        = pegi.ci
                      and dal      <= nvl(P_al,rire.fin_ela)
                   )
              and pegi.al <=
                  (select last_day
                          (to_date
                           (max(lpad(to_char(mese),2,'0')||
                            to_char(anno)),'mmyyyy'))
                              from movimenti_fiscali
                             where ci       = pegi.ci
                               and last_day
                                   (to_date
                                   (lpad(to_char(mese),2,'0')||
                                   to_char(anno),'mmyyyy'))
                                   between nvl(P_dal,rire.ini_ela)
                                      and nvl(P_al,rire.fin_ela)
                               and nvl(ipn_ord,0)  + nvl(ipn_liq,0)
                                   +nvl(ipn_ap,0)   + nvl(lor_liq,0)
                                   +nvl(lor_acc,0) != 0
                               and mensilita != '*AP'
                           )
                   ) )
                )
             or (P_tipo = 'S' and dedp.ci = P_ci
                )
            )
       and exists
          (select 'x'
             from rapporti_individuali rain
            where rain.ci = dedp.ci
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
)LOOP
      -- Estrazione i_comp_tfr --
         select round(sum(decode( vaca.colonna
                          , 'COMP_TFR', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                       )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
           into i_comp_tfr
          from valori_contabili_annuali vaca
              , estrazione_valori_contabili esvc
              , estrazione_righe_contabili  esrc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and esrc.estrazione        = vaca.estrazione
            and esrc.colonna           = vaca.colonna
            and esvc.dal              <= nvl(CUR_CI.al,to_date('3333333','j'))
            and nvl(esvc.al,to_date('3333333','j'))
                                      >= CUR_CI.dal
            and vaca.riferimento between esvc.dal
                                     and nvl(esvc.al,to_date('3333333','j'))
            and vaca.anno              = P_anno
            and vaca.voce              = esrc.voce
            and nvl(vaca.sub,' ')      = nvl(esrc.sub,' ')
            and esrc.dal               = esvc.dal
            and nvl(esrc.al,to_date('3333333','j'))
                                       = nvl(esvc.al,to_date('3333333','j'))
            and vaca.mese              = 12
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna          = 'COMP_TFR'
            and vaca.ci                = CUR_CI.ci
            and vaca.moco_mensilita    != '*AP'
            and vaca.riferimento between CUR_CI.dal
                                     and nvl(CUR_CI.al,to_date('3333333','j'));
      
	  		--update di deuncia_inpdap del record che si sta trattando per ci,dal, al ,rilevanza ,ano,gestione e previdenza
			--settando il valore del campo comp_tfr con la variabile i_comp_tfr. 
			
			 update denuncia_inpdap set comp_tfr=i_comp_tfr
			 where ci=cur_ci.ci 
			 and rilevanza=cur_ci.rilevanza 
			 and dal=cur_ci.dal
			 and al=cur_ci.al
			 and anno=P_anno
			 and gestione like P_gestione
			 and previdenza like P_previdenza;
			 
			if D_ci!= 0 then 
				if CUR_CI.ci=nvl(D_ci,0) then
				   D_ci:=CUR_CI.ci;
				else
-- DBMS_OUTPUT.PUT_LINE('D_CI '||to_char(d_ci)||'---2 update sul D_ci');
update denuncia_inpdap dedp
				set (comp_tfr)=
				(select nvl(dedp.comp_tfr,0)+nvl(round(sum(decode( vaca.colonna
                          , 'COMP_TFR', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                       )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1),0)
           from valori_contabili_annuali vaca
              , estrazione_valori_contabili esvc
              , estrazione_righe_contabili  esrc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and esrc.estrazione        = vaca.estrazione
            and esrc.colonna           = vaca.colonna
            and vaca.riferimento between to_date(P_ini_anno,'ddmmyyyy')   -- AGGIUNTO PER TESTARE CHE LE SOMME CHE VADO AD 
  				   	       and to_date(P_fin_anno,'ddmmyyyy')   		   -- NON SIANO ARRETRATI
            and esvc.dal              <= nvl(dedp.al,to_date(P_fin_anno,'ddmmyyyy') )
            and nvl(esvc.al,to_date('3333333','j'))
                                      >= dedp.dal
            and vaca.riferimento between esvc.dal
                                     and nvl(esvc.al,to_date('3333333','j'))
            and vaca.anno              = dedp.anno
            and vaca.voce              = esrc.voce
            and nvl(vaca.sub,' ')      = nvl(esrc.sub,' ')
            and esrc.dal               = esvc.dal
            and nvl(esrc.al,to_date('3333333','j'))
                                       = nvl(esvc.al,to_date('3333333','j'))
            and vaca.mese              = 12
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna          in ('COMP_TFR')
            and vaca.ci                = dedp.ci
            and vaca.moco_mensilita    != '*AP'
            and not exists (select 'x' from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento between dal
                                             and nvl(al,to_date(P_fin_anno,'ddmmyyyy') ))
            and nvl(dedp.al,to_date(P_fin_anno,'ddmmyyyy') )=
               (select max(nvl(al,to_date(P_fin_anno,'ddmmyyyy') ))
                              from denuncia_inpdap
                              where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento > nvl(al,to_date(P_fin_anno,'ddmmyyyy') ))
)
where anno = P_anno
and gestione like P_gestione
and previdenza like P_previdenza
and rilevanza = 'S'
and ci = D_ci
and exists
(select 'x' from
valori_contabili_annuali vaca
  where vaca.anno              = dedp.anno
            and vaca.mese              = 12
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna          in ('COMP_TFR')
            and vaca.ci                = dedp.ci
            and vaca.moco_mensilita    != '*AP'
            and not exists (select 'x' from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento between dal and nvl(al,to_date(P_fin_anno,'ddmmyyyy')))
            and nvl(dedp.al,to_date(P_fin_anno,'ddmmyyyy') )=
               (select max(nvl(al,to_date(P_fin_anno,'ddmmyyyy')))
                              from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento > nvl(al,to_date(P_fin_anno,'ddmmyyyy')))
							   )
;
							   
update denuncia_inpdap dedp
					set (comp_tfr)=
					(select nvl(dedp.comp_tfr,0)+nvl(round(sum(decode( vaca.colonna
                         , 'COMP_TFR', nvl(vaca.valore,0),0)) 
                                     / nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                       )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1),0)
           from valori_contabili_annuali vaca
              , estrazione_valori_contabili esvc
              , estrazione_righe_contabili  esrc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and esrc.estrazione        = vaca.estrazione
            and esrc.colonna           = vaca.colonna
            and esvc.dal              <= nvl(dedp.al,to_date(P_fin_anno,'ddmmyyyy') )
            and nvl(esvc.al,to_date('3333333','j'))
                                      >= dedp.dal
            and vaca.riferimento between esvc.dal
                                     and nvl(esvc.al,to_date('3333333','j'))
            and vaca.riferimento between to_datE(P_ini_anno,'ddmmyyyy')   -- AGGIUNTO PER TESTARE CHE LE SOMME CHE VADO AD 
  				   	       and to_date(P_fin_anno,'ddmmyyyy')   		  -- NON SIANO ARRETRATI
            and vaca.anno              = dedp.anno
            and vaca.voce              = esrc.voce
            and nvl(vaca.sub,' ')      = nvl(esrc.sub,' ')
            and esrc.dal               = esvc.dal
            and nvl(esrc.al,to_date('3333333','j'))
                                       = nvl(esvc.al,to_date('3333333','j'))
            and vaca.mese              = 12
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna          in ('COMP_TFR')
            and vaca.ci                = dedp.ci
            and vaca.moco_mensilita    != '*AP'
            and not exists (select 'x' from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento between dal
                                             and nvl(al,to_date(P_fin_anno,'ddmmyyyy') ))
            and nvl(dedp.dal,to_date(P_ini_anno,'ddmmyyyy') )=
               (select min(nvl(dal,to_date(P_ini_anno,'ddmmyyyy')))
                              from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento < nvl(dal,to_date(P_ini_anno,'ddmmyyyy'))
)
)
where anno = P_anno
and gestione like P_gestione
and previdenza like P_previdenza
and rilevanza = 'S'
and ci = D_ci
and exists
(select 'x' from
valori_contabili_annuali vaca
  where vaca.anno              = dedp.anno
            and vaca.mese              = 12
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna          in ('COMP_TFR')
            and vaca.ci                = dedp.ci
            and vaca.moco_mensilita    != '*AP'
            and not exists (select 'x' from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento between dal and nvl(al,to_date(P_fin_anno,'ddmmyyyy')))
            and nvl(dedp.dal,to_date(P_ini_anno,'ddmmyyyy') )=
               (select min(nvl(dal,to_date(P_ini_anno,'ddmmyyyy')))
                              from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento < nvl(dal,to_date(P_ini_anno,'ddmmyyyy')))
)
and dal = (select min(dal) from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
           )
;


					D_ci:=CUR_CI.ci;
			    end if;
			else
			 D_ci:=CUR_CI.ci;
			end if;	 

END LOOP; -- CUR_CI --
-- DBMS_OUTPUT.PUT_LINE('D_CI '||to_char(d_ci)||'---2 update sul d_ci ultimo record');
update denuncia_inpdap dedp
				set (comp_tfr)=
				(select nvl(dedp.comp_tfr,0)+nvl(round(sum(decode( vaca.colonna
                          , 'COMP_TFR', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                       )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1),0)
           from valori_contabili_annuali vaca
              , estrazione_valori_contabili esvc
              , estrazione_righe_contabili  esrc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and esrc.estrazione        = vaca.estrazione
            and esrc.colonna           = vaca.colonna
            and vaca.riferimento between to_date(P_ini_anno,'ddmmyyyy')   -- AGGIUNTO PER TESTARE CHE LE SOMME CHE VADO AD 
  				   	       and to_date(P_fin_anno,'ddmmyyyy')   		   -- NON SIANO ARRETRATI
            and esvc.dal              <= nvl(dedp.al,to_date(P_fin_anno,'ddmmyyyy') )
            and nvl(esvc.al,to_date('3333333','j'))
                                      >= dedp.dal
            and vaca.riferimento between esvc.dal
                                     and nvl(esvc.al,to_date('3333333','j'))
            and vaca.anno              = dedp.anno
            and vaca.voce              = esrc.voce
            and nvl(vaca.sub,' ')      = nvl(esrc.sub,' ')
            and esrc.dal               = esvc.dal
            and nvl(esrc.al,to_date('3333333','j'))
                                       = nvl(esvc.al,to_date('3333333','j'))
            and vaca.mese              = 12
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna          in ('COMP_TFR')
            and vaca.ci                = dedp.ci
            and vaca.moco_mensilita    != '*AP'
            and not exists (select 'x' from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento between dal
                                             and nvl(al,to_date(P_fin_anno,'ddmmyyyy') ))
            and nvl(dedp.al,to_date(P_fin_anno,'ddmmyyyy') )=
               (select max(nvl(al,to_date(P_fin_anno,'ddmmyyyy') ))
                              from denuncia_inpdap
                              where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento > nvl(al,to_date(P_fin_anno,'ddmmyyyy') ))
)
where anno = P_anno
and gestione like P_gestione
and previdenza like P_previdenza
and rilevanza = 'S'
and ci = D_ci
and exists
(select 'x' from
valori_contabili_annuali vaca
  where vaca.anno              = dedp.anno
            and vaca.mese              = 12
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna          in ('COMP_TFR')
            and vaca.ci                = dedp.ci
            and vaca.moco_mensilita    != '*AP'
            and not exists (select 'x' from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento between dal and nvl(al,to_date(P_fin_anno,'ddmmyyyy')))
            and nvl(dedp.al,to_date(P_fin_anno,'ddmmyyyy') )=
               (select max(nvl(al,to_date(P_fin_anno,'ddmmyyyy')))
                              from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento > nvl(al,to_date(P_fin_anno,'ddmmyyyy')))
							   )
;
							   
update denuncia_inpdap dedp
set (comp_tfr)=
(select nvl(dedp.comp_tfr,0)+nvl(round(sum(decode( vaca.colonna
                          , 'COMP_TFR', nvl(vaca.valore,0)
                                         , 0))
                            / nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1)
                       )
                            * nvl(max(decode( vaca.colonna
                                        , 'COMP_TFR', nvl(esvc.arrotonda,0.01)
                                                      , '')),1),0)
           from valori_contabili_annuali vaca
              , estrazione_valori_contabili esvc
              , estrazione_righe_contabili  esrc
          where esvc.estrazione        = vaca.estrazione
            and esvc.colonna           = vaca.colonna
            and esrc.estrazione        = vaca.estrazione
            and esrc.colonna           = vaca.colonna
            and esvc.dal              <= nvl(dedp.al,to_date(P_fin_anno,'ddmmyyyy') )
            and nvl(esvc.al,to_date('3333333','j'))
                                      >= dedp.dal
            and vaca.riferimento between esvc.dal
                                     and nvl(esvc.al,to_date('3333333','j'))
            and vaca.riferimento between to_datE(P_ini_anno,'ddmmyyyy')   -- AGGIUNTO PER TESTARE CHE LE SOMME CHE VADO AD 
  				   	       and to_date(P_fin_anno,'ddmmyyyy')   -- NON SIANO ARRETRATI
            and vaca.anno              = dedp.anno
            and vaca.voce              = esrc.voce
            and nvl(vaca.sub,' ')      = nvl(esrc.sub,' ')
            and esrc.dal               = esvc.dal
            and nvl(esrc.al,to_date('3333333','j'))
                                       = nvl(esvc.al,to_date('3333333','j'))
            and vaca.mese              = 12
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna          in ('COMP_TFR')
            and vaca.ci                = dedp.ci
            and vaca.moco_mensilita    != '*AP'
            and not exists (select 'x' from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento between dal
                                             and nvl(al,to_date(P_fin_anno,'ddmmyyyy') ))
            and nvl(dedp.dal,to_date(P_ini_anno,'ddmmyyyy') )=
               (select min(nvl(dal,to_date(P_ini_anno,'ddmmyyyy')))
                              from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento < nvl(dal,to_date(P_ini_anno,'ddmmyyyy'))
)
)
where anno = P_anno
and gestione like P_gestione
and previdenza like P_previdenza
and rilevanza = 'S'
and ci = D_ci
and exists
(select 'x' from
valori_contabili_annuali vaca
  where vaca.anno              = dedp.anno
            and vaca.mese              = 12
            and vaca.mensilita         = (select max(mensilita)
                                            from mensilita
                                           where mese  = 12
                                             and tipo in ('A','N','S'))
            and vaca.estrazione        = 'DENUNCIA_INPDAP'
            and vaca.colonna          in ('COMP_TFR')
            and vaca.ci                = dedp.ci
            and vaca.moco_mensilita    != '*AP'
            and not exists (select 'x' from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento between dal and nvl(al,to_date(P_fin_anno,'ddmmyyyy')))
            and nvl(dedp.dal,to_date(P_ini_anno,'ddmmyyyy') )=
               (select min(nvl(dal,to_date(P_ini_anno,'ddmmyyyy')))
                              from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
                               and vaca.riferimento < nvl(dal,to_date(P_ini_anno,'ddmmyyyy')))
)
and dal = (select min(dal) from denuncia_inpdap
                             where anno = dedp.anno
                               and ci = dedp.ci
                               and rilevanza = dedp.rilevanza
           )
;

commit;
end;
end;
end;
end;
/

