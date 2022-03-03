CREATE OR REPLACE PACKAGE PGPCPRAT IS
/******************************************************************************
 NOME:          crp_pgpcprat TRATTAMENTO TABELLA PRATICHE
 DESCRIZIONE:   Questa fase produce un file secondo il tracciato INPDAP Pratich2.txt
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 2    10/06/2004     AM Revisioni varie a seguito dei test sul Modulo
 3    23/06/2004     ML	Gestione del SOLO ultimo periodo di ogni NI / CI
 4    26/06/2005     CB Aggiunta stampa di controllo 
 4.1  08/09/2005     ML Sistemazione passi procedurali
 4.2  11/10/2005  AM-ML Sistemate le segnalazioni su a_segnalazioni_errore
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number,passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY Pgpcprat IS
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V4.2 del 11/10/2005';
   END VERSIONE;
PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
DECLARE
  P_pagina       NUMBER:=0;
  P_riga         NUMBER;
  P_ente         VARCHAR2(4);
  P_ambiente     VARCHAR2(8);
  P_utente       VARCHAR2(8);
  P_lingua       VARCHAR2(1);
  D_app          varchar2(1);
  conta          number:=0;
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
    P_riga := 0;
    FOR CUR_NI IN
       (select rain.ni
             , i.ci
             , i.codice_fiscale
             , i.previdenza
             , pegi_p.dal
             , pegi_p.al data_c
             , decode(pegi_p.posizione, null,'2', NVL(evra.cod_previdenza,'2')) motivo_c
          from PERIODI_GIURIDICI    pegi_p
             , EVENTI_RAPPORTO      evra
             , INPDAP               i
             , rapporti_individuali rain
         where i.ci                 = rain.ci
           AND evra.codice (+)      = pegi_p.posizione
           AND pegi_p.ci            = i.ci
           AND pegi_p.rilevanza     = 'P'
           AND pegi_p.dal           = (SELECT MAX(dal)
                                         FROM PERIODI_GIURIDICI
                                        WHERE ci        in
                                             (select ci
                                                from rapporti_individuali
                                               where ni = rain.ni)
                                          AND rilevanza  = 'P'
                                      )
   	 ) LOOP
            P_riga := P_riga + 1;
            INSERT INTO a_appoggio_stampe
                  (no_prenotazione,no_passo,pagina,riga,testo)
            SELECT  prenotazione,1,1,P_riga,
                    RPAD(CUR_NI.codice_fiscale,16,' ')||
                    RPAD('1',3,' ')||
                    RPAD(DECODE(CUR_NI.previdenza,'CPDEL',NVL(gest.posizione_cpd,' ')
                                                    ,NVL(gest.posizione_cps,' ')
                        ),8,' ')||
                    RPAD(NVL(SUBSTR(qus7.codice,1,11),' '),11,' ')||
                    RPAD(nvl(CUR_NI.motivo_c,' '),6,' ')||
                    LPAD(NVL(TO_CHAR(CUR_NI.data_c,'dd/mm/yyyy'),'          '),10,'0')||
                    RPAD('31/12/1999',10,' ')||
                    RPAD(' ',10,' ')||
                    RPAD(' ',6,' ')||
                    RPAD(' ',10,' ')||
                    DECODE(CUR_NI.previdenza,'CPDEL','2','CPI','3','CPS','5','CPSTAT','6')||
                    LPAD(' ',15,' ')||
                    RPAD(SUBSTR(
                       TRANSLATE(
                            SUBSTR(anag.indirizzo_res,1,LEAST(
                            DECODE(INSTR(anag.indirizzo_res,'0'),'0',100,INSTR(anag.indirizzo_res,'0')),
                            DECODE(INSTR(anag.indirizzo_res,'1'),'0',100,INSTR(anag.indirizzo_res,'1')),
                            DECODE(INSTR(anag.indirizzo_res,'2'),'0',100,INSTR(anag.indirizzo_res,'2')),
                            DECODE(INSTR(anag.indirizzo_res,'3'),'0',100,INSTR(anag.indirizzo_res,'3')),
                            DECODE(INSTR(anag.indirizzo_res,'4'),'0',100,INSTR(anag.indirizzo_res,'4')),
                            DECODE(INSTR(anag.indirizzo_res,'5'),'0',100,INSTR(anag.indirizzo_res,'5')),
                            DECODE(INSTR(anag.indirizzo_res,'6'),'0',100,INSTR(anag.indirizzo_res,'6')),
                            DECODE(INSTR(anag.indirizzo_res,'7'),'0',100,INSTR(anag.indirizzo_res,'7')),
                            DECODE(INSTR(anag.indirizzo_res,'8'),'0',100,INSTR(anag.indirizzo_res,'8')),
                            DECODE(INSTR(anag.indirizzo_res,'9'),'0',100,INSTR(anag.indirizzo_res,'9'))
                          )-1),',',' '),1,30),30,' ')||
                    NVL(RPAD(SUBSTR(
                       SUBSTR(anag.indirizzo_res,LEAST(
                         DECODE(INSTR(anag.indirizzo_res,'0'),'0',100,INSTR(anag.indirizzo_res,'0')),
                         DECODE(INSTR(anag.indirizzo_res,'1'),'0',100,INSTR(anag.indirizzo_res,'1')),
                         DECODE(INSTR(anag.indirizzo_res,'2'),'0',100,INSTR(anag.indirizzo_res,'2')),
                         DECODE(INSTR(anag.indirizzo_res,'3'),'0',100,INSTR(anag.indirizzo_res,'3')),
                         DECODE(INSTR(anag.indirizzo_res,'4'),'0',100,INSTR(anag.indirizzo_res,'4')),
                         DECODE(INSTR(anag.indirizzo_res,'5'),'0',100,INSTR(anag.indirizzo_res,'5')),
                         DECODE(INSTR(anag.indirizzo_res,'6'),'0',100,INSTR(anag.indirizzo_res,'6')),
                         DECODE(INSTR(anag.indirizzo_res,'7'),'0',100,INSTR(anag.indirizzo_res,'7')),
                         DECODE(INSTR(anag.indirizzo_res,'8'),'0',100,INSTR(anag.indirizzo_res,'8')),
                         DECODE(INSTR(anag.indirizzo_res,'9'),'0',100,INSTR(anag.indirizzo_res,'9'))
                                   ),6),1,6),6,' '),'S.N.C.')||
                    RPAD(comu.descrizione,40,' ')||
                    RPAD(SUBSTR(comu.sigla_provincia,1,2),2,' ')||
                    '   '||
                    RPAD(anag.cap_res,5,' ')||
                    RPAD(NVL(anag.tel_res,' '),14,' ')||
                    ' '||
                    RPAD(' ',21,' ')||
                    lpad(to_char(CUR_NI.ci),8,'0')
              FROM  comuni               comu
                   ,GESTIONI             gest
                   ,QUALIFICHE_GIURIDICHE qugi
                   ,QUALIFICHE_INPDAP    qus7
                   ,PERIODI_GIURIDICI    pegi_s
                   ,ANAGRAFICI           anag
            WHERE  anag.ni              = CUR_NI.ni
              AND  comu.cod_comune (+)     = anag.comune_res
              AND  comu.cod_provincia (+)  = anag.provincia_res
              AND  nvl(CUR_NI.data_c,sysdate) BETWEEN anag.dal AND nvl(anag.al,to_date('3333333','j'))
              AND  gest.codice          = pegi_s.gestione
              AND  qugi.numero          = pegi_s.qualifica
              and  qugi.codice          like qus7.qualifica_gp4
              and  nvl(pegi_s.al,to_date('3333333','j')) between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
              and  qugi.contratto       like qus7.contratto_gp4
              and  nvl(pegi_s.al,to_date('3333333','j')) between nvl(qus7.dal, to_date('2222222', 'j'))
                                                             and nvl(qus7.al,to_date('3333333','j'))
            and  qugi.dal             <= nvl(qus7.al, to_date('3333333', 'j'))
            and  nvl(qus7.dal, to_date('2222222', 'j')) <= nvl(qugi.al, to_date('3333333', 'j'))
              AND  pegi_s.ci            = CUR_NI.ci
              AND  pegi_s.rilevanza     = 'S'
              AND  pegi_s.dal           = (SELECT MAX(dal)
                                             FROM PERIODI_GIURIDICI
                                            WHERE ci         = CUR_NI.ci
                                              AND rilevanza  = 'S'
                                          )
   ; 
      FOR CUR in
      (select qugi.contratto
             ,qugi.codice
             ,pegi.dal
             ,pegi.al
       from  periodi_giuridici     pegi,
             qualifiche_giuridiche qugi
       where pegi.rilevanza   = 'S'
       and   pegi.qualifica   = qugi.numero
       and   pegi.ci          = CUR_NI.ci
       and   nvl(pegi.al,to_date('3333333','j')) between nvl(qugi.dal,to_date('2222222','j')) and nvl(qugi.al,to_date('3333333','j')) 
       AND   pegi.dal           = (SELECT MAX(dal)
                                             FROM PERIODI_GIURIDICI
                                            WHERE ci         = CUR_NI.ci
                                              AND rilevanza  = 'S'
                                          )
       and   not exists (select 'x' from qualifiche_inpdap qus7
                         where   qugi.codice like qus7.qualifica_gp4
                         and   qugi.contratto like qus7.contratto_gp4
                         and   qugi.dal <= nvl(qus7.al, to_date('3333333', 'j'))
                         and   nvl(qus7.dal, to_date('2222222', 'j')) <= nvl(qugi.al, to_date('3333333', 'j')))
       )LOOP
        conta:=conta+1;   
       insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                       ,errore,precisazione)
      values( prenotazione,1,conta,'P04091','CI '||lpad(to_char(CUR_NI.ci),8,' ')
              ||' Dal: '||lpad(to_char(CUR.dal,'dd/mm/yyyy'),10,' ')
--              ||' Al: '||nvl(lpad(to_char(CUR.al,'dd/mm/yyyy'),10,' '),lpad(' ',10,' '))
              ||' Qual. '||rpad(CUR.contratto,4,' ')||'/'||rpad(CUR.codice,8,' '));
    commit;
      END LOOP;
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
*/  -- gestito attraverso i passi procedurali

    commit;
  END;
END;
END;
END;
/

