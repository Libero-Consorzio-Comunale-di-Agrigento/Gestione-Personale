/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE PECCALAP IS
/******************************************************************************
 NOME:          PECCALAP  
 DESCRIZIONE:   RICALCOLO ALIQUOTA MEDIA PER TASSAZIONE SEPARATA
 ARGOMENTI:   
      Ricalcola l'aliquota media per la tassazione separata ed aggiorna
      la memorizzazione su INFORMAZIONI_EXTRACONTABILI
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  
 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003  
 2    09/03/2005   NN   Gestiti i nuovi campi per le deduzioni familiari           
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
/*<TOAD_FILE_CHUNK>*/

CREATE OR REPLACE PACKAGE BODY PECCALAP IS
 
  FUNCTION VERSIONE  RETURN VARCHAR2 IS
  BEGIN
  RETURN 'V2.0 del 09/03/2005';
  END VERSIONE;

PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
BEGIN
DECLARE
  P_anno         number(4);
  P_tipo_elab    number(1);
  P_rif_alq_ap   date;
  P_alq_ap       number(5,2);
  riga           number;


SCAGLIONE_ASSENTE EXCEPTION;

BEGIN
    riga := 0;
  BEGIN
    select to_number(substr(valore,1,4))
      into P_anno
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_ANNO'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  BEGIN
    select to_number(substr(valore,1,1))
      into P_tipo_elab
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_TIPO_ELAB'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN 
     P_tipo_elab:=to_number('3');
  END;
  BEGIN  
    select nvl(P_anno,rire.anno)
         , add_months( rire.fin_ela
                     , decode(rire.anno,1998,-12,1999,-24,2003,-12,2004,-24,0)
                     )
      into P_anno,P_rif_alq_ap
      from riferimento_retribuzione rire
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;

--  if P_anno = 2004 and P_tipo_elab = 1 then
-- calcolo al NETTO valido solo per iNEX dal 2005 in poi
  if P_tipo_elab = 1 then
     update informazioni_extracontabili x
     set ipn_1ap = (select greatest(0,sum(prfi.ipn_ac) - sum(nvl(prfi.ded_base_ac,0) +
                                                             nvl(prfi.ded_agg_ac,0)  +
                                                             nvl(prfi.ded_con_ac,0)  +
                                                             nvl(prfi.ded_fig_ac,0)  +
                                                             nvl(prfi.ded_alt_ac,0)))
                    from   progressivi_fiscali prfi
                    where  prfi.ci   = x.ci
                    and    prfi.anno = x.anno-1
                    and    prfi.mese = 12  
                    and    prfi.mensilita = (select max(mensilita) 
                                             from mensilita
                                             where mese=12
                                               and tipo in ('N','A','S')
                                             )            
                   )
     where x.anno = P_anno
     and   P_anno > 2004
     and   exists (select 'x' 
                   from   movimenti_fiscali
                   where  anno = x.anno-1
                   and    ci   = x.ci);
  end if;        

  if P_tipo_elab = 4 then
-- ricalcola anche ipn_2ap al NETTO SOLO se è il 2005: unico anno in cui ipn_2ap è diverso dal ipn_1ap del precedente
     update informazioni_extracontabili x
     set ipn_2ap = (select greatest(0,sum(prfi.ipn_ac) - sum(nvl(prfi.ded_base_ac,0) +
                                                             nvl(prfi.ded_agg_ac,0)  +
                                                             nvl(prfi.ded_con_ac,0)  +
                                                             nvl(prfi.ded_fig_ac,0)  +
                                                             nvl(prfi.ded_alt_ac,0)))

                    from   progressivi_fiscali prfi
                    where  prfi.ci   = x.ci
                    and    prfi.anno = x.anno-2
                    and    prfi.mese = 12  
                    and    prfi.mensilita = (select max(mensilita) 
                                             from mensilita
                                             where mese=12
                                               and tipo in ('N','A','S')
                                             )            
                   )
     where x.anno = P_anno
     and   P_anno = 2005
     and   exists (select 'x' 
                   from   movimenti_fiscali
                   where  anno = x.anno-2
                   and    ci   = x.ci);
  end if;        

--  if P_anno = 2004 and P_tipo_elab = 2 then
-- calcolo al LORDO valido solo per INEX del 2004
  if P_tipo_elab = 2 then
     update informazioni_extracontabili x
     set    ipn_1ap=(select sum(prfi.ipn_ac)
                     from   progressivi_fiscali prfi  
                     where  prfi.ci = x.ci
                     and    prfi.anno = x.anno-1
                     and    prfi.mese = 12
                     and    prfi.mensilita = (select max(mensilita)
                                              from mensilita
                                              where mese=12
                                               and tipo in ('N','A','S')
                                             )
                     )
     where x.anno=P_anno
     and   P_anno = 2004
     and   exists (select 'x' 
                   from movimenti_fiscali
                   where anno=x.anno-1
                   and   ci=x.ci);
  end if;    


  FOR CUR_INEX IN
   (select ci
         , nvl(ipn_1ap,0) ipn_1ap
         , nvl(ipn_2ap,0) ipn_2ap
      from informazioni_extracontabili inex
     where anno = P_anno
   ) LOOP
   BEGIN
     IF CUR_INEX.ipn_1ap = 0 AND CUR_INEX.ipn_2ap = 0 THEN
        BEGIN
        select aliquota 
          into P_ALQ_AP
          from SCAGLIONI_FISCALI
         where scaglione = 0
           and P_rif_alq_ap BETWEEN DAL
                                AND NVL(AL,TO_DATE('3333333','J'));
        EXCEPTION
        WHEN NO_DATA_FOUND THEN RAISE SCAGLIONE_ASSENTE;
        END;
     ELSE
        BEGIN
        select round ( ( ( (nvl(CUR_INEX.IPN_1AP,0)+nvl(CUR_INEX.IPN_2AP,0)) / 2
                          - scaglione
                          ) * aliquota / 100 + imposta
                        ) * 100
                          / ((nvl(CUR_INEX.IPN_1AP,0)+nvl(CUR_INEX.IPN_2AP,0))/2)
                      , 2
                      )
           into P_ALQ_AP
           from SCAGLIONI_FISCALI
          where scaglione = (select max(scaglione)
                               from SCAGLIONI_FISCALI
                              where scaglione <= ( nvl(CUR_INEX.IPN_1AP,0)
                                                 + nvl(CUR_INEX.IPN_2AP,0)
                                                 ) / 2
                                and P_rif_alq_ap
                                    between dal
                                        and nvl(al,to_date('3333333','j'))
                            )
            and P_rif_alq_ap
                    between dal
                        and nvl(al,to_date('3333333','j'))
        ;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN RAISE SCAGLIONE_ASSENTE;
        END;
     END IF;
     BEGIN
     update informazioni_extracontabili
        set alq_ap = P_alq_ap
      where anno = P_anno
        and ci = CUR_INEX.ci
     ;
     END;
EXCEPTION
   WHEN SCAGLIONE_ASSENTE THEN
        update a_prenotazioni set errore = 'P05320'
                                , prossimo_passo = 91
         where no_prenotazione = prenotazione
        ;
        riga := riga + 1;
        insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                         ,errore,precisazione)
        values (prenotazione,1,riga,'P05320',
                'Scaglione Assente #'||to_char(CUR_INEX.ci))
        ;
     END;
END LOOP;
END;
end;
end;
/
