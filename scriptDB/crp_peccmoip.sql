CREATE OR REPLACE PACKAGE peccmoip IS
/******************************************************************************
 NOME:        PECCMOIP
 DESCRIZIONE: Inserimento movimenti di incentivazione, emessi dalla fase di estrazione
              per passaggio a economico, nelle variabili mensili.
              Questa fase consente:
              elenco voci di incentivazione che si vengono a comporre dai movimenti
              integrati in economico, e che non sono definite in dizionario;
              inserimento delle variabili che si vengono a comporre dai movimenti estratti
              da incentivazione del personale in movimenti contabili (previo controllo
              della mensilita)
              elenco degli individui per i quali e' stato emesso liquidato di incenti-
              vazione e che risultano non essere in servizio.
  
 *****ATTENZIONE ..... IL FILE NON DEVE ESSERE STARTATO....NON PIU IN USO....*****
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             
 1.1. 28/06/2005
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY peccmoip IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.1 del 28/06/2005';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
begin
declare
P_progetto   varchar2(8);
P_ini_mes    varchar2(9);
P_fin_mes    varchar2(9);
P_utente     varchar2(8);
P_m_rif      number(2);
P_a_rif      number(4);
P_variabili_gipe number(2);
P_mensilita  varchar2(3);
P_anno       number(4);
P_mese       number(2);
begin
                       -- Operazioni Prelimiari e Controlli
      select nvl(variabili_gipe,0) D_variabili_gipe
	  		 into p_variabili_gipe
        from ente
      ;
      select ini_mes D_ini_mes
           , fin_mes D_fin_mes
           , mese    D_m_rif
           , anno    D_a_rif
		   into p_ini_mes, p_fin_mes, p_m_rif, p_a_rif
        from riferimento_incentivo
       where riip_id = 'RIIP'
      ;
      select mese      D_m_rif
           , anno      D_a_rif
           , mensilita D_mensilita
		   into  p_m_rif, p_a_rif, p_mensilita
        from riferimento_retribuzione
       where rire_id = 'RIRE'
      ;
      select max(valore) D_anno
	    into p_anno
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro = 'P_ANNO'
      ;
      select max(valore) D_mese
	    into p_mese
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro = 'P_MESE'
      ;
      select utente D_utente
	    into p_utente
        from a_prenotazioni
       where no_prenotazione = prenotazione
      ;
--
-- Inizio operazioni di Funzione
--
DECLARE
D_flag                       VARCHAR2(1);
D_vocesi                     VARCHAR2(1);
USCITA                       EXCEPTION;
BEGIN
/*  BEGIN                        -- Controllo mensilita movimenti
    select 'x' into D_flag
      from riferimento_retribuzione
     where to_char(mese)||to_char(anno) = (select distinct to_char(mese)||
                                                           to_char(anno)
                            from deposito_variabili_incentivo)
       and rire_id = 'RIRE'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN  */
       /* Incompatibilita` su riferimento mensilita` movimenti  */
/*       update a_prenotazioni set  errore  = 'P06905',
                                  prossimo_passo = 99
        where no_prenotazione = prenotazione
       ;
       RAISE USCITA;
  END; */
  BEGIN                        -- Controllo situazione di prelievo movimenti
                               -- (tabella deposito_variabili piena per a/m)
    select 'x' into D_flag
      from deposito_variabili_incentivo
     where rownum < 2
       and to_char(anno)||to_char(mese) = to_char(p_anno)||to_char(p_mese)
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       /* Movimenti gia' integrati in economico o non estratti */
       update a_prenotazioni set  errore  = 'P06907',
                                  prossimo_passo = 99
        where no_prenotazione = prenotazione
       ;
       RAISE USCITA;
  END;
  BEGIN                        -- Controllo esistenza voci di incentivazione
                               -- controlla esistenza voce in voci contabili
                               -- con controllo di integrita' storica e referen-
                               -- ziale alla data di rifer. MENSILITA' elab.
                               -- (inizio mese di periodo elab. economico PIP+n)
                               -- controllo integrita` referenziale e storica
                               -- su contabilita voce alla data di riferimento
                               -- VOCE (last day competenza movimento
                               -- incentivazione)
  D_vocesi := 'y';
  select nvl(max('x' ),'y')
    into D_vocesi
    from deposito_variabili_incentivo dep
   where not exists (select 'x'
                       from voci_contabili
                      where voce =
                        'IN'||decode(dep.flag_voce,'Y','.',dep.flag_voce)
                        ||dep.parte||decode(dep.tipo,'S','S','A')
                        ||substr(to_char(dep.c_anno),3,2)
                        and sub = '*'
                        and to_date('01'||lpad(to_char(dep.mese),2,'0')
                                        ||to_char(dep.anno),'ddmmyyyy')
                            between nvl(dal,to_date('2222222','j'))
                                and nvl(al,to_date('3333333','j'))
                    )
  ;
  IF D_vocesi = 'x'
     /* Voce non prevista o non attiva */
     THEN update a_prenotazioni set  errore  = 'P05610',
                                     prossimo_passo = 99
           where no_prenotazione = prenotazione
          ;
           RAISE USCITA;
  END IF;
  END;
  BEGIN                        -- Inserimento movimenti
  insert into movimenti_contabili
         (ci,anno,mese,mensilita,voce,sub,riferimento,arr,input,data,imp_var,
          sede_del,anno_del,numero_del,risorsa_intervento,capitolo,articolo,impegno,anno_impegno,
          sub_impegno,anno_sub_impegno,conto,codice_siope)
  select dep.ci ci,
         max(dep.anno) anno,
         max(dep.mese) mese,
         max(rif.mensilita) mensilita,
         'IN'||decode(dep.flag_voce,'Y','.',dep.flag_voce)
         ||dep.parte||decode(dep.tipo,'S','S','A')
         ||substr(to_char(dep.c_anno),3,2) voce,
         '*',
         least( nvl(ragi.al,to_date('3333333','j')),
         last_day(to_date('01/'||to_char(dep.c_mese)||'/'||to_char(dep.c_anno)
                         ,'dd/mm/yyyy')
                 )) riferimento,
         decode( add_months( to_date(to_char(dep.c_mese)||'/'||
                                     to_char(dep.c_anno),'mm/yyyy')
                            ,p_variabili_gipe
                           )
                ,to_date(to_char(dep.mese)||'/'||to_char(dep.anno),
                                                        'mm/yyyy'),''
                                                         ,'C'
               ) arr,
         'I' input,
         sysdate,
         sum(importo) imp_var,
         dep.sede_del,
         dep.anno_del,
         dep.numero_del,
         dep.risorsa_intervento,
         dep.capitolo,
         dep.articolo,
         dep.impegno,
         dep.anno_impegno,
         dep.sub_impegno,
         dep.anno_sub_impegno,
         substr(dep.anno_bil,1,2),
         dep.codice_siope
    from rapporti_giuridici ragi
       , deposito_variabili_incentivo dep
       , riferimento_retribuzione rif
   where ragi.ci = dep.ci
     and exists ( select 'x' from rapporti_individuali ri
                   where ci = dep.ci
                     and exists ( select 'x' from classi_rapporto
                                   where codice = ri.rapporto
                                     and retributivo = 'SI'
                                )
                )
     and dep.mese = p_mese
     and dep.anno = p_anno
   group by dep.ci,
         decode( add_months( to_date(to_char(dep.c_mese)||'/'||
                                     to_char(dep.c_anno),'mm/yyyy')
                            ,p_variabili_gipe
                           )
                ,to_date(to_char(dep.mese)||'/'||to_char(dep.anno),'mm/yyyy'),''
                                                         ,'C'
               ),
         'IN'||decode(dep.flag_voce,'Y','.',dep.flag_voce)
         ||dep.parte||decode(dep.tipo,'S','S','A')
         ||substr(to_char(dep.c_anno),3,2),
         nvl(ragi.al,to_date('3333333','j')),
         last_day(to_date('01/'||to_char(c_mese)||'/'||to_char(c_anno),
                                                         'dd/mm/yyyy')),
         dep.sede_del,
         dep.numero_del,
         dep.anno_del,
         dep.risorsa_intervento,
         dep.capitolo,
         dep.articolo,
         dep.impegno,
         dep.anno_impegno,
         dep.sub_impegno,
         dep.anno_sub_impegno,
         dep.anno_bil,
         dep.codice_siope
  having abs(sum(importo)) > 0
  ;
  END;
  BEGIN           -- Eliminazione dei movimenti gia' intergrati da deposito
    delete from deposito_variabili_incentivo dep
     where dep.mese = p_mese
       and dep.anno = p_anno
       and exists ( select 'x' from rapporti_individuali ri
                   where ci = dep.ci
                     and exists ( select 'x' from classi_rapporto
                                   where codice = ri.rapporto
                                     and retributivo = 'SI'
                                )
                )
    ;
  END;
/*  BEGIN           -- Elenco nominativo dei cessati liquidati nel mese
  select a.ci,a.cognome||' '||a.nome nome,
         m.voce,m.riferimento,m.imp
    from anagrafici a,movimenti_contabili m
   where a.ci     = m.ci
     and (m.anno,m.mese,m.mensilita)
                  = (select anno,mese,mensilita from riferimento_retribuzione)
     and not exists (select 'x' from periodi_giuridici
                      where ci = m.ci
                        and rilevanza in ('Q','I')
                        and m.riferimento between dal and nvl(al,9999999)
                    )
  ;
  END; */
EXCEPTION
  WHEN USCITA THEN null;
  WHEN OTHERS THEN null;
END;
end;
end;
end;
/

