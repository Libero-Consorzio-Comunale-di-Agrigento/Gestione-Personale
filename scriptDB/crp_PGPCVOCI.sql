CREATE OR REPLACE PACKAGE Pgpcvoci IS
/******************************************************************************
 NOME:          crp_pgpcvoci CREAZIONE FILE VOCI
 DESCRIZIONE:   Questa fase produce un file secondo il tracciato INPDAP voci.txt
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003
 1.1  08/09/2005     ML Sistemazione passi procedurali
 1.2  11/10/2005  AM-ML Sistemate le segnalazioni su a_segnalazioni_errore
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number,passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY Pgpcvoci IS
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.2 del 11/10/2005';
   END VERSIONE;
PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
DECLARE
  P_pagina       NUMBER;
  P_riga         NUMBER :=0;
  P_ente         VARCHAR2(4);
  P_ambiente     VARCHAR2(8);
  P_utente       VARCHAR2(8);
  P_lingua       VARCHAR2(1);
  P_gestione     VARCHAR2(4);
  conta          number:=0;
  d_app          varchar2(1);
  --
  -- Estrazione Parametri di Selezione della Prenotazione
  --
BEGIN
  BEGIN
    SELECT ENTE
         , utente
         , ambiente
         , gruppo_ling
      INTO P_ente,P_utente,P_ambiente,P_lingua
      FROM a_prenotazioni
     WHERE no_prenotazione = prenotazione
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT SUBSTR(valore,1,4)
      INTO P_gestione
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_GESTIONE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN null;
  END;
  P_pagina       := 1;
  FOR CUR_GEST in
     (select posizione_cpd posizione_cp
        from gestioni
       where posizione_cpd IS NOT NULL
     	   AND codice      LIKE P_gestione
      union
      select posizione_cps posizione_cp
        from gestioni
       where posizione_cps IS NOT NULL
     	   AND codice      LIKE P_gestione
     ) LOOP
  P_pagina := P_pagina +1;
FOR CUR_VOS7 IN
    ( SELECT  vos7.codice            Codice,
              max(voec.oggetto)      Oggetto
    FROM  VOCI_ECONOMICHE         voec,
          VOCI_INPDAP             vos7,
          VOCI_CONTABILI          voco
   WHERE voec.codice like vos7.voce_gp4
     and voco.voce like vos7.voce_gp4
     and voco.sub like vos7.sub_gp4
     and nvl(voco.dal, to_date('2222222','j')) <= nvl(vos7.al, to_date('3333333','j'))
     and nvl(voco.al, to_date('3333333','j')) >= nvl(vos7.dal, to_date('2222222','j'))
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voec.codice
		     AND voce_acc LIKE '%CP%'
		 )
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voec.codice
		     AND voce_acc LIKE '%INADEL%'
		 )
     AND  NOT EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voec.codice
		     AND voce_acc LIKE '%STATO%'
		 )
group by vos7.codice
UNION
  SELECT  vos7.codice            Codice,
              max(voec.oggetto)      Oggetto
    FROM  VOCI_ECONOMICHE         voec,
          VOCI_INPDAP             vos7,
          VOCI_CONTABILI          voco
   WHERE voec.codice = voco.voce
     and voco.voce like vos7.voce_gp4
     and voco.sub like vos7.sub_gp4
     and nvl(voco.dal, to_date('2222222','j')) <= nvl(vos7.al, to_date('3333333','j'))
     and nvl(voco.al, to_date('3333333','j')) >= nvl(vos7.dal, to_date('2222222','j'))
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voec.codice
		     AND voce_acc LIKE '%CP%'
		 )
     AND  NOT EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voec.codice
		     AND voce_acc LIKE '%INADEL%'
		 )
     AND  NOT EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voec.codice
		     AND voce_acc LIKE '%STATO%'
		 )
group by vos7.codice
UNION
  SELECT  vos7.codice            Codice,
              max(voec.oggetto)      Oggetto
    FROM  VOCI_ECONOMICHE         voec,
          VOCI_INPDAP             vos7,
          VOCI_CONTABILI          voco
   WHERE voec.codice = voco.voce
     and voco.voce like vos7.voce_gp4
     and voco.sub like vos7.sub_gp4
     and nvl(voco.dal, to_date('2222222','j')) <= nvl(vos7.al, to_date('3333333','j'))
     and nvl(voco.al, to_date('3333333','j')) >= nvl(vos7.dal, to_date('2222222','j'))
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voec.codice
		     AND voce_acc LIKE '%CP%'
		 )
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voec.codice
		     AND voce_acc LIKE '%INADEL%'
		 )
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voec.codice
		     AND voce_acc LIKE '%STATO%'
		 )
group by vos7.codice
UNION
  SELECT  vos7.codice            Codice,
              max(voec.oggetto)      Oggetto
    FROM  VOCI_ECONOMICHE         voec,
          VOCI_INPDAP             vos7,
          VOCI_CONTABILI          voco
   WHERE voec.codice = voco.voce
     and voco.voce like vos7.voce_gp4
     and voco.sub like vos7.sub_gp4
     and nvl(voco.dal, to_date('2222222','j')) <= nvl(vos7.al, to_date('3333333','j'))
     and nvl(voco.al, to_date('3333333','j')) >= nvl(vos7.dal, to_date('2222222','j'))
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voec.codice
		     AND voce_acc LIKE '%CP%'
		 )
     AND  NOT EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voec.codice
		     AND voce_acc LIKE '%INADEL%'
		 )
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voec.codice
		     AND voce_acc LIKE '%STATO%'
		 )
group by vos7.codice
) LOOP
P_riga := P_riga +1;
     INSERT INTO a_appoggio_stampe
         (no_prenotazione,no_passo,pagina,riga,testo) VALUES
         (prenotazione,1,P_pagina, P_riga,
          RPAD(NVL(CUR_GEST.posizione_cp,' '),8  ,' ')||
          LPAD(NVL(CUR_VOS7.CODICE,' '),11,'0')||
          RPAD(' ',32,' ')||
          RPAD(NVL(CUR_VOS7.oggetto,' '),30,' ')||
		  ' '|| -- Voce accessoria
          ' '||
          'NO'||
          RPAD('NO',22,' ')||
          '0'
          );
 END LOOP;
 END LOOP;
FOR CUR in
      (select distinct voco.voce
             ,voco.sub
             ,voco.dal
             ,voco.al
       from   voci_contabili        voco
       where not exists (select 'x' from voci_inpdap vos7
                         where   voco.voce like vos7.voce_gp4
                         and     voco.sub  like vos7.sub_gp4
                         and     nvl(voco.dal,to_date('2222222','j')) <= nvl(vos7.al, to_date('3333333', 'j'))
                         and     nvl(vos7.dal, to_date('2222222', 'j')) <= nvl(voco.al, to_date('3333333', 'j')))
        and  exists  (select 'x' from movimenti_contabili moco
                         where  moco.voce=voco.voce
                         and    moco.sub=voco.sub
                         )
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voco.voce
		     AND voce_acc LIKE '%CP%'
		 )
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voco.voce
		     AND voce_acc LIKE '%INADEL%'
		 )
     AND  NOT EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voco.voce
		     AND voce_acc LIKE '%STATO%'
		 )
     union
     select distinct voco.voce
             ,voco.sub
             ,voco.dal
             ,voco.al
       from   voci_contabili        voco
       where not exists (select 'x' from voci_inpdap vos7
                         where   voco.voce like vos7.voce_gp4
                         and     voco.sub  like vos7.sub_gp4
                         and     nvl(voco.dal,to_date('2222222','j')) <= nvl(vos7.al, to_date('3333333', 'j'))
                         and     nvl(vos7.dal, to_date('2222222', 'j')) <= nvl(voco.al, to_date('3333333', 'j')))
        and  exists  (select 'x' from movimenti_contabili moco
                         where  moco.voce=voco.voce
                         and    moco.sub=voco.sub
                         )
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voco.voce
		     AND voce_acc LIKE '%CP%'
		 )
     AND  NOT EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voco.voce
		     AND voce_acc LIKE '%INADEL%'
		 )
     AND  NOT EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voco.voce
		     AND voce_acc LIKE '%STATO%'
		 )
union
     select distinct voco.voce
             ,voco.sub
             ,voco.dal
             ,voco.al
       from   voci_contabili        voco
       where not exists (select 'x' from voci_inpdap vos7
                         where   voco.voce like vos7.voce_gp4
                         and     voco.sub  like vos7.sub_gp4
                         and     nvl(voco.dal,to_date('2222222','j')) <= nvl(vos7.al, to_date('3333333', 'j'))
                         and     nvl(vos7.dal, to_date('2222222', 'j')) <= nvl(voco.al, to_date('3333333', 'j')))
        and  exists  (select 'x' from movimenti_contabili moco
                         where  moco.voce=voco.voce
                         and    moco.sub=voco.sub
                         )
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voco.voce
		     AND voce_acc LIKE '%CP%'
		 )
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voco.voce
		     AND voce_acc LIKE '%INADEL%'
		 )
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voco.voce
		     AND voce_acc LIKE '%STATO%'
		 )
     union
     select distinct voco.voce
             ,voco.sub
             ,voco.dal
             ,voco.al
       from   voci_contabili        voco
       where not exists (select 'x' from voci_inpdap vos7
                         where   voco.voce like vos7.voce_gp4
                         and     voco.sub  like vos7.sub_gp4
                         and     nvl(voco.dal,to_date('2222222','j')) <= nvl(vos7.al, to_date('3333333', 'j'))
                         and     nvl(vos7.dal, to_date('2222222', 'j')) <= nvl(voco.al, to_date('3333333', 'j')))
        and  exists  (select 'x' from movimenti_contabili moco
                         where  moco.voce=voco.voce
                         and    moco.sub=voco.sub
                         )
    AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voco.voce
		     AND voce_acc LIKE '%CP%'
		 )
     AND  NOT EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voco.voce
		     AND voce_acc LIKE '%INADEL%'
		 )
     AND  EXISTS
	     (SELECT 'x' FROM TOTALIZZAZIONI_VOCE
		   WHERE voce = voco.voce
		     AND voce_acc LIKE '%STATO%'
		 )
        )LOOP
        conta:=conta+1;
       insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                       ,errore,precisazione)
      values( prenotazione,1,conta,'P04092',
--             ' Dal: '||lpad(to_char(CUR.dal,'dd/mm/yyyy'),10,' ')||
--             ' Al: '||nvl(lpad(to_char(CUR.al,'dd/mm/yyyy'),10,' '),lpad(' ',10,' '))||' , '||
             ' Voce/Sub '||rpad(CUR.voce,10,' ')||'/'||rpad(CUR.sub,4,' '));
    commit;
      END LOOP;
/*
begin
     select 'x'
     into   D_app
     from   a_segnalazioni_errore
     where  no_prenotazione=prenotazione;
     raise  too_many_rows;
     exception
      when no_data_found then
            update a_prenotazioni
           set prossimo_passo    = 93
           where no_prenotazione = prenotazione  ;
      when too_many_rows then
           update a_prenotazioni
           set prossimo_passo    = 91,
           errore                = 'P05808'
           where no_prenotazione = prenotazione;
    end;
*/
    commit;

END;
END;
END;
/

