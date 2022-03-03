CREATE OR REPLACE PACKAGE PECPREDP IS

/******************************************************************************
 NOME:          PECPREDP  PREPARAZIONE ARCHIVIO DENUNCIA INPDAP
 DESCRIZIONE:   

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  Nella revisione del 12/02/2004 sono state eliminate TUTTE le update
               su movimenti contabili

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             
 2    12/02/2004 MS     Revisione denuncia INPDAP 
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
end;
/
CREATE OR REPLACE PACKAGE BODY PECPREDP IS
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V2.0 del 12/02/2004';
   END VERSIONE;

 PROCEDURE MAIN (prenotazione in number, passo in number) IS
 BEGIN
 DECLARE
  D_anno            varchar2(4);
  incrementa_pagina number:= 0;
--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN
  BEGIN
    select valore
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
      ;
  END;
                        
BEGIN
  FOR CUR_IPN in 
  (select voce, sub
     from estrazione_righe_contabili
    where estrazione = 'DENUNCIA_INPDAP'
      AND colonna    = 'Q_IPN'
      and to_date('3112'||D_anno,'ddmmyyyy') between dal and nvl(al,to_date('3333333','j'))
  ) LOOP

incrementa_pagina := incrementa_pagina + 1;
	
     insert into a_appoggio_stampe
     (no_prenotazione,no_passo,pagina,riga,testo)
     select prenotazione
          , 2
          , incrementa_pagina
          , 0
          , 'Voci non indicate in DESRE per imponibile '||CUR_IPN.voce
       from dual
     ;
     insert into a_appoggio_stampe
     (no_prenotazione,no_passo,pagina,riga,testo)
     select prenotazione
          , 2
          , incrementa_pagina
          , 1
          , 'Sequenza  Voce       Sub'
       from dual
     ;
     insert into a_appoggio_stampe
     (no_prenotazione,no_passo,pagina,riga,testo)
     select prenotazione
          , 2
          , incrementa_pagina
          , rownum+1
          , lpad(voec.sequenza,4)||lpad(' ',6,' ')||rpad(covo.voce,10)||'  '||rpad(covo.sub,2)
      from contabilita_voce covo
         , voci_economiche voec
     where covo.voce = voec.codice
       and voec.tipo = 'C'
       and covo.voce in 
          (select voce
             from totalizzazioni_voce
            where voce_acc = CUR_IPN.voce
              and to_date('0101'||D_anno,'ddmmyyyy') 
                  between  nvl(dal,to_date('2222222','j'))
                      and nvl(al,to_date('3333333','j')))
       and not exists
          (select 'x' from estrazione_righe_contabili
            where estrazione = 'DENUNCIA_INPDAP'
              and colonna   in ('COMP_FISSE','COMP_ACCESSORIE')
              and to_date('3112'||D_anno,'ddmmyyyy') 
                  between dal and nvl(al,to_date('3333333','j'))
              and voce = covo.voce
              and sub  = covo.sub)
      and (covo.voce, covo.sub) in 
          (select voce, sub
             from movimenti_contabili
            where anno = D_anno
          );
  END LOOP;
END;
END;
END;
END;
/