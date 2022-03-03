CREATE OR REPLACE PACKAGE peclacrd IS
/******************************************************************************
 NOME:        PECLACRD
 DESCRIZIONE:  Creazione del flusso per la Denuncia Fiscale 770 / A su supporto magnetico
               (nastri a bobina o dischetti - ASCII - lung. 900 crt.).
               Questa fase produce un file secondo i tracciati imposti dal Ministero
               delle Finanze.
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  La gestione che deve risultare come intestataria della denuncia
               deve essere stata inserita in << DGEST >> in modo tale che la
               ragione sociale (campo nome) risulti essere la minore di tutte
               le altre eventualmente inserite.
               Lo stesso risultato si raGgiunge anche inserendo un BLANK prima
               del nome di tutte le gestioni che devono essere escluse.

               Il PARAMETRO D_anno indica l'anno di riferimento della denuncia
               da elaborare.
               Il PARAMETRO D_filtro_1 indica i dipendenti da elaborare.

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

CREATE OR REPLACE PACKAGE BODY peclacrd IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
begin
DECLARE
  D_dummy           VARCHAR2(1);
  D_note_prfi       VARCHAR2(1);
  D_note_vaca       VARCHAR2(1);
  D_note_apess      VARCHAR2(1);
  D_pagina          number;
  D_riga            number;
  D_anno            number;
  D_ini_a           date;
  D_fin_a           date;
  D_dal             date;
  D_al              date;
  D_da_ci           number;
  D_a_ci            number;
  D_r1              VARCHAR2(20);
  D_filtro_1        VARCHAR2(15);
  D_filtro_2        VARCHAR2(15);
  D_filtro_3        VARCHAR2(15);
  D_filtro_4        VARCHAR2(15);
  D_tipo            VARCHAR2(1);
  NO_101            EXCEPTION;
   BEGIN  -- Estrazione Parametri di Selezione della Prenotazione
      BEGIN
      select substr(valore,1,4)
           , to_date('01'||substr(valore,1,4),'mmyyyy')
           , to_date('3112'||substr(valore,1,4),'ddmmyyyy')
        into D_anno,D_ini_a,D_fin_a
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_ANNO'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              select anno
                   , to_date('01'||to_char(anno),'mmyyyy')
                   , to_date('3112'||to_char(anno),'ddmmyyyy')
                into D_anno,D_ini_a,D_fin_a
                from riferimento_fine_anno
               where rifa_id = 'RIFA';
      END;
      BEGIN
      select  to_date(valore,decode(nvl(length(translate(valore,'a0123456789/','a
')),0),0,'dd/mm/yyyy','dd-mon-yy'))
        into D_dal
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_DAL'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_dal := null;
      END;
      BEGIN
      select  to_date(valore,decode(nvl(length(translate(valore,'a0123456789/','a
')),0),0,'dd/mm/yyyy','dd-mon-yy'))
        into D_al
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_AL'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_al := null;
      END;
      BEGIN
      select substr(valore,1,15)
        into D_filtro_1
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_FILTRO_1'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_filtro_1 := '%';
      END;
      BEGIN
      select substr(valore,1,15)
        into D_filtro_2
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_FILTRO_2'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_filtro_2 := '%';
      END;
      BEGIN
      select substr(valore,1,15)
        into D_filtro_3
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_FILTRO_3'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_filtro_3 := '%';
      END;
      BEGIN
      select substr(valore,1,15)
        into D_filtro_4
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_FILTRO_4'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_filtro_4 := '%';
      END;
      BEGIN
      select substr(valore,1,1)
        into D_tipo
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_TIPO'
      ;
      END;
      BEGIN
      select to_number(substr(valore,1,8))
           , to_number(substr(valore,1,8))
        into D_da_ci, D_a_ci
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_CI'
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_da_ci := 0;
              D_a_ci  := 99999999;
      END;
      BEGIN
         D_pagina := 0;
         D_riga   := 0;
         FOR CUR_CI IN
            (select distinct
                    rpfa.s1              s1
                  , rpfa.c1              c1
                  , rpfa.s2              s2
                  , rpfa.c2              c2
                  , rpfa.s3              s3
                  , rpfa.c3              c3
                  , rpfa.s4              s4
                  , rpfa.c4              c4
                  , rpfa.s5              s5
                  , rpfa.c5              c5
                  , rpfa.s6              s6
                  , rpfa.c6              c6
                  , rpfa.ci              ci
               from rapporti_retributivi rare
                  , report_fine_anno  rpfa
              where rpfa.anno  = D_anno
                and rare.ci    = rpfa.ci
                and nvl(rpfa.c1,' ') like nvl(D_filtro_1,'%')
                and nvl(rpfa.c2,' ') like nvl(D_filtro_2,'%')
                and nvl(rpfa.c3,' ') like nvl(D_filtro_3,'%')
                and nvl(rpfa.c4,' ') like nvl(D_filtro_4,'%')
                and rpfa.ci       between D_da_ci and D_a_ci
                and exists
                   (select 'x'
                      from movimenti_contabili   moco
                     where moco.anno       = D_anno
                       and moco.mensilita != '*AP'
                       and moco.ci         = rare.ci
                       and (moco.voce,moco.sub) in
                           (select voce,sub
                              from estrazione_righe_contabili
                             where estrazione = 'AGGIUNTIVA_101')
      )
              order by s1,s2,s3,s4,s5,s6
            ) LOOP
               BEGIN
/*
                BEGIN
                  select 'x'
                     into D_dummy
                     from progressivi_fiscali prfi
                    where prfi.anno      = D_anno
                      and prfi.mese      = 12
                      and prfi.mensilita = (select max(mensilita) from mensilita
                                             where mese    = 12
                                               and tipo   in ('S','A','N'))
                      and prfi.ci = CUR_CI.ci
                    group by prfi.ci
                   having nvl(abs(sum(prfi.ipn_ac)),0)  +
                          nvl(abs(sum(prfi.ipn_liq)),0) +
                          nvl(abs(sum(prfi.ipn_ap)),0)  +
                          nvl(abs(sum(prfi.lor_liq)),0) +
                          nvl(abs(sum(prfi.lor_acc)),0) != 0
                   ;
                 EXCEPTION
                   WHEN TOO_MANY_ROWS THEN null;
                   WHEN NO_DATA_FOUND THEN RAISE no_101;
                 END;
*/
                     BEGIN
                      select 'x'
                        into D_dummy
                        from classi_rapporto clra
                           , rapporti_individuali rain
                       where rain.ci  = CUR_CI.ci
                         and codice   = rain.rapporto
                         and cat_fiscale in (1,2,10,15,20,25)
                       ;
                    EXCEPTION
                      WHEN TOO_MANY_ROWS THEN null;
                      WHEN NO_DATA_FOUND THEN RAISE no_101;
                    END;
                IF D_tipo in ('I','T') THEN null;
                 ELSIF D_tipo = 'C' THEN
                    BEGIN
                      select 'x'
                        into D_dummy
                        from riferimento_retribuzione rire
                           , periodi_giuridici pegi
                       where rire.rire_id        = 'RIRE'
                         and pegi.rilevanza = 'P'
                         and pegi.ci        = CUR_CI.ci
                         and pegi.dal        =
                            (select max(dal) from periodi_giuridici
                              where rilevanza = 'P'
                                and ci        = pegi.ci
                                and dal      <= nvl(D_al,rire.fin_ela)
                            )
                         and pegi.al between nvl(D_dal,rire.ini_ela)
                                         and nvl(D_al,rire.fin_ela)
                      ;
                    EXCEPTION
                      WHEN TOO_MANY_ROWS THEN null;
                      WHEN NO_DATA_FOUND THEN
                         BEGIN
                           select 'x'
                             into D_dummy
                             from riferimento_retribuzione  rire
                                , periodi_giuridici pegi
                            where rire.rire_id        = 'RIRE'
                              and pegi.rilevanza = 'P'
                              and pegi.ci        = CUR_CI.ci
                              and pegi.dal        =
                                 (select max(dal) from periodi_giuridici
                                   where rilevanza = 'P'
                                     and ci        = pegi.ci
                                     and dal      <= nvl(D_al,rire.fin_ela)
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
                                         between nvl(D_dal,rire.ini_ela)
                                             and nvl(D_al,rire.fin_ela)
                                     and nvl(ipn_ord,0)  + nvl(ipn_liq,0)
                                        +nvl(ipn_ap,0)   + nvl(lor_liq,0)
                                        +nvl(lor_acc,0) != 0
                                     and mensilita != '*AP'
                                 );
                         EXCEPTION
                           WHEN TOO_MANY_ROWS THEN null;
                           WHEN NO_DATA_FOUND THEN RAISE no_101;
                         END;
                    END;
                 ELSE
                    BEGIN
                      select 'x'
                        into D_dummy
                        from periodi_giuridici pegi
                       where pegi.rilevanza = 'P'
                         and pegi.ci        = CUR_CI.ci
                         and pegi.dal      <= D_fin_a
                         and nvl(pegi.al,to_date('3333333','j')) > D_fin_a;
                    EXCEPTION
                      WHEN TOO_MANY_ROWS THEN null;
                      WHEN NO_DATA_FOUND THEN RAISE no_101;
                    END;
                 END IF;
                 D_pagina := D_pagina + 1;
                 D_riga   := D_riga   + 1;
                 insert into a_appoggio_stampe
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , lpad(to_char(CUR_CI.ci),8,'0')||
                           rpad(CUR_CI.c1,15,' ')
                         );
               EXCEPTION
                 WHEN NO_101 THEN null;
               END;
              END LOOP;
      END;
COMMIT;
END;
end;
end;
/

