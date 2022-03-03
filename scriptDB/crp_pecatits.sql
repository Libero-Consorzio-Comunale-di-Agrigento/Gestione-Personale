CREATE OR REPLACE PACKAGE pecatits IS
/******************************************************************************
 NOME:        PECATITS
 DESCRIZIONE: Aggiornamento tabella INFORMAZIONI_EXTRACONTABILI per attivare i 
              flag della tassazione separata da esporre sui modello 770/SA e CUD.
              Questa fase va in aggionamento sulla tabella INFORMAZIONI_EXTRACONTABILI 
              per l'anno (se non indicato = DRIFA) e per l'individuo richiesto (se
              non indicato tutti gli invidui), per attivare i flag min_anno_ap e
              nr_anno_ap che devono essere riportati sui modello 770/SA e CUD.
              L'ulteriore flag titolo_ap non viene gestito per l'impossibiltà
              di sapere a quale titolo sono stati corrisposti gli arretrati, per i 
              casi particolari, è possibile agire direttamente in AINEX, mentre per 
              casi più comuni viene gestito un default al momento della stampa dei modelli.
              
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY pecatits IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
DECLARE
D_anno number;
D_ci   number;
BEGIN
  BEGIN
    select to_number(substr(valore,1,4))
      into D_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_ANNO'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         select anno
           into D_anno
           from riferimento_fine_anno
          where rifa_id = 'RIFA'
         ;
  END;
  BEGIN
    select to_number(substr(valore,1,8))
      into D_ci
      from a_parametri
     where no_prenotazione = prenotazione
      and parametro        = 'P_CI'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN D_ci := null;
  END;
  BEGIN
    FOR CUR_CI IN
       (select ci
          from rapporti_giuridici
         where ci  between nvl(D_ci,1) and nvl(D_ci,99999999)
       ) LOOP
           update informazioni_extracontabili inex
              set (min_anno_ap, nr_anni_ap) =
                  (select min(to_char(riferimento,'yyyy'))
                        , decode(count(distinct to_char(riferimento,'yyyy'))
                                , 0, null
                                   , count(distinct to_char(riferimento,'yyyy'))
                                )
                     from progressivi_contabili prco
                        , contabilita_voce covo
                    where prco.anno       = D_anno
                      and prco.mese       = 12
                      and prco.mensilita  =
                         (select max(mensilita) from mensilita
                           where mese = 12
                             and tipo in ('A','N','S'))
                      and prco.ci         = CUR_CI.ci
                      and prco.voce       = covo.voce
                      and prco.sub        = covo.sub
                      and (   covo.fiscale = 'P'
                           or covo.fiscale = 'C' and prco.arr = 'P'
                          )
                  )
            where anno = D_anno
              and ci   = CUR_CI.ci
              and exists
                 (select 'x' from movimenti_fiscali
                   where anno = D_anno
                     and ci   = inex.ci
                     and nvl(ipt_ap,0) != 0)
           ;
         END LOOP;
  commit;
  END;
END;
end;
end;
/

