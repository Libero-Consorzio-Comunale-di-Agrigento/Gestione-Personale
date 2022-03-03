CREATE OR REPLACE PACKAGE PECCCSTO IS
/******************************************************************************
 NOME:        PECCCSTO - CALCOLO CONTRIBUTI STORICI
 DESCRIZIONE: Cambia voce e sub dei contributi 1% aggiuntivo AP per ricondurli alle voci
              starndard trattate dal calcolo a "cumulo".
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    26/11/2004 AM/MS  Prima emissione
 1.1  28/12/2004 MS     Modifica per att. 8530.1
 1.2  28/12/2004 MS     Modifica per att. 8530.2
******************************************************************************/
FUNCTION  VERSIONE RETURN VARCHAR2;
PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCCSTO IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.2 del 28/12/2004';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
BEGIN
DECLARE
  V_comando       varchar2(2000);
  D_errore        varchar2(6);
  V_conta         number := 0;
  D_nominativo    varchar2(100);
  V_controllo     varchar2(1) := null;
  P_voce1_da      varchar2(10);
  P_sub1_da       varchar2(4);
  P_voce2_da      varchar2(10);
  P_sub2_da       varchar2(4);
  P_voce1_a       varchar2(10);
  P_sub1_a        varchar2(4);
  P_voce2_a       varchar2(10);
  P_sub2_a        varchar2(4);
  USCITA         EXCEPTION;
  --
  -- Estrazione Parametri di Selezione della Prenotazione
  --
BEGIN
  BEGIN
    <<PARAMETRI>>
    select max(decode(parametro,'P_VOCE1_DA',substr(valore,1,10),null))
         , max(decode(parametro,'P_SUB1_DA',substr(valore,1,10),null))
         , max(decode(parametro,'P_VOCE2_DA',substr(valore,1,10),null))
         , max(decode(parametro,'P_SUB2_DA',substr(valore,1,10),null))
         , max(decode(parametro,'P_VOCE1_A',substr(valore,1,10),null))
         , max(decode(parametro,'P_SUB1_A',substr(valore,1,10),null))
         , max(decode(parametro,'P_VOCE2_A',substr(valore,1,10),null))
         , max(decode(parametro,'P_SUB2_A',substr(valore,1,10),null))
      into P_voce1_da
         , P_sub1_da
         , P_voce2_da
         , P_sub2_da
         , P_voce1_a
         , P_sub1_a
         , P_voce2_a
         , P_sub2_a
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro in ( 'P_VOCE1_DA', 'P_SUB1_DA'
                        , 'P_VOCE2_DA', 'P_SUB2_DA'
                        , 'P_VOCE1_A', 'P_SUB1_A'
                        , 'P_VOCE2_A', 'P_SUB2_A'
                        )
      ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
     P_voce1_da := null;
     P_sub1_da := null;
     P_voce2_da := null;
     P_sub2_da := null;
     P_voce1_a := null;
     P_sub1_a := null;
     P_voce2_a := null;
     P_sub2_a := null;
  END PARAMETRI;
-- controllo sui parametri
  IF ( P_voce1_da is null and P_sub1_da is not null
   or  P_voce2_da is null and P_sub2_da is not null
   or  P_voce1_da is not null and P_sub1_da is null
   or  P_voce2_da is not null and P_sub2_da is null
   or  P_voce1_a is null and P_sub1_a is not null
   or  P_voce2_a is null and P_sub2_a is not null
   or  P_voce1_a is not null and P_sub1_a is null
   or  P_voce2_a is not null and P_sub2_a is null
   or  ( ( P_voce1_da is not null or P_sub1_da is not null )
     and ( P_voce1_a is null or P_sub1_a is null )
       )
   or  ( ( P_voce2_da is not null or P_sub2_da is not null )
     and  ( P_voce2_a is null or P_sub2_a is null )
       )
      )
   THEN
      D_errore := 'A05721';
      RAISE USCITA;
   END IF;
-- controllo sulle voci
   IF P_voce1_da is not null and P_sub1_da is not null THEN
      BEGIN
      select 'X' 
        into V_controllo
        from dual
       where not exists ( select 'x' 
                            from contabilita_voce
                           where voce = P_voce1_da and sub = P_sub1_da
                         );
      EXCEPTION WHEN NO_DATA_FOUND THEN 
            V_controllo := 'Y';
      END;
    END IF;
    IF P_voce1_a is not null and P_sub1_a is not null THEN
      BEGIN
      select 'X' 
        into V_controllo
        from dual
       where not exists ( select 'x' 
                            from contabilita_voce
                           where voce =  P_voce1_a and sub = P_sub1_a
                         );
      EXCEPTION WHEN NO_DATA_FOUND THEN 
            V_controllo := 'Y';
      END;
    END IF;
    IF P_voce2_da is not null and P_sub2_da is not null THEN
      BEGIN
      select 'X' 
        into V_controllo
        from dual
       where not exists ( select 'x' 
                            from contabilita_voce
                           where voce =  P_voce2_da and sub = P_sub2_da
                         );
      EXCEPTION WHEN NO_DATA_FOUND THEN 
            V_controllo := 'Y';
      END;
    END IF;
    IF P_voce2_a is not null and P_sub2_a is not null THEN
      BEGIN
      select 'X' 
        into V_controllo
        from dual
       where not exists ( select 'x' 
                            from contabilita_voce
                           where voce = P_voce2_a and sub = P_sub2_a
                         );
      EXCEPTION WHEN NO_DATA_FOUND THEN 
            V_controllo := 'Y';
      END;
    END IF;
   IF V_controllo = 'X'
   THEN
      D_errore := 'P05610';
      RAISE USCITA;
   END IF;

   BEGIN 
   v_comando := 'create table moco_prima_della_'||prenotazione
                 ||' as select * from movimenti_contabili where 1 = 0';
   si4.sql_execute(V_comando);
   END;
-- dbms_output.put_line('Testata report 1');
   BEGIN
   -- riga 0
	   insert into a_appoggio_stampe
         ( NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO )
          values ( prenotazione, 1, 1, 0
		         , rpad('Cod.Ind',8,' ')
                     ||' - '
 		         ||lpad('ANNO',4,' ')
                     ||' - '
			   ||rpad('NOMINATIVO',100,' ')
	            );
   -- riga 1
	   insert into a_appoggio_stampe
         ( NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO )
          values ( prenotazione, 1, 1, 1, lpad('_',118,'_'));
   -- riga 2
	   insert into a_appoggio_stampe
         ( NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO )
          values ( prenotazione, 1, 1, 2, null );
     v_conta := 2;
         commit;
   END;

FOR CUR_CI IN (select ci from rapporti_giuridici order by ci
              ) LOOP
     D_nominativo := null;
  BEGIN
  FOR CUR_ANNO IN (select distinct anno from movimenti_fiscali
                    where ci = CUR_CI.ci
                      and mensilita != '*AP'
                  ) LOOP

    BEGIN
      BEGIN
      select substr(cognome||' '||nome,1,100)
        into D_nominativo
       from rapporti_individuali rain
      where ci = CUR_CI.ci
        and exists ( select 'x' 
                      from movimenti_contabili
                     where ci   = CUR_CI.ci
                       and anno = CUR_ANNO.anno
                       and voce = P_voce1_da
                       and sub  = P_sub1_da
                     union
                      select 'x'
                      from movimenti_contabili
                     where ci   = CUR_CI.ci
                       and anno = CUR_ANNO.anno
                       and voce = P_voce2_da
                       and sub  = P_sub2_da
                    );
      EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
      END;
      IF D_nominativo is not null THEN
       V_conta := nvl(V_conta,0) + 1;
      BEGIN
-- salvataggio dati 
       BEGIN
       v_comando := 'insert into moco_prima_della_'||prenotazione||' 
                     select * from movimenti_contabili 
                     where ci = '||CUR_CI.ci||' and anno = '||CUR_ANNO.anno||'
                       and ( voce = '''||P_voce1_da||''' and sub  = '''||P_sub1_da||''' 
                        or   voce = '''||P_voce2_da||''' and sub  = '''||P_sub2_da||'''
                        or   voce = '''||P_voce1_a||''' and sub  = '''||P_sub1_a||'''
                        or   voce = '''||P_voce2_a||''' and sub  = '''||P_sub2_a||''')';
         si4.sql_execute(V_comando);
       END;
        insert into a_appoggio_stampe
        ( NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO )
        values
        ( prenotazione,1, 1, V_conta
        , lpad(CUR_CI.ci,8,' ')||' - '||lpad(CUR_ANNO.anno,4,'0')||' - '||rpad(D_nominativo,100,' ')
		);
      update movimenti_contabili moco
         set voce = P_voce1_a
           , sub  = P_sub1_a
       where ci   = CUR_CI.ci
         and anno = CUR_ANNO.anno
         and voce = P_voce1_da
         and sub  = P_sub1_da
      ;
      update movimenti_contabili moco
         set voce = P_voce2_a
           , sub  = P_sub2_a
       where ci   = CUR_CI.ci
         and anno = CUR_ANNO.anno
         and voce = P_voce2_da
         and sub  = P_sub2_da
      ;
	  END;
      END IF;
    END;
  END LOOP; -- cursore CUR_ANNO
  END;
 END LOOP; -- cursore CUR_CI
EXCEPTION WHEN USCITA THEN
      update a_prenotazioni
         set prossimo_passo = 92
           , errore         = D_errore
       where no_prenotazione = prenotazione;
END;
END;
END PECCCSTO;
/
