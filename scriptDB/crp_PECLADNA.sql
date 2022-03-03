CREATE OR REPLACE PACKAGE PECLADNA IS
/******************************************************************************
 NOME:         PECLADNA
 DESCRIZIONE:  Creazione della tabella intermedia per eventuali variazioni da
               apportare prima della emissione del flusso per la
               Denuncia Nominativa Assicurati INAIL su supporto magnetico
               (dischetti a 5',25 o 3',50 - ASCII - lung. 100 crt.).
               Questa fase produce movimenti emessi su una tabella di lavoro
               al fine di eseguire eventuali variazioni dei medesimi.
               Successivamente da questa tabella verranno estratti i movimenti
               e composto un file secondo i tracciati imposti dalla Direzione
               dell' INAIL.

 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI: La gestione che deve risultare come intestataria della denuncia
              deve essere stata inserita in << DGEST >> in modo tale che la
              ragione sociale (campo nome) risulti essere la maggiore di tutte
              le altre eventualmente inserite.
              Lo stesso risultato si raggiunge anche inserendo un BLANK prima
              del nome di tutte le gestioni che devono essere escluse.

               Il PARAMETRO D_anno indica l'anno di riferimento della denuncia.
               Il PARAMETRO D_pos_inail indica quale posizione INAIL deve essere ela-
               rata (% = tutte).

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.1  20/01/2003
 1.2  24/06/2004 MS     Modifiche per 770/2004
 1.3  24/06/2005 GM     Modifiche per Attivita 11375
 1.4  02/04/2007 MS     Aggiunte segnalazioni per A20394
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECLADNA IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.4 del  02/04/2007';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
 BEGIN

DECLARE

 P_ente       varchar2(4);
 P_ambiente   varchar2(8);
 P_utente     varchar2(8);
 P_anno       number(4);
 P_ini_anno   varchar2(8);
 P_fin_anno   varchar2(8);
 P_pos_inail  varchar2(12);
 P_gestione   varchar2(4);
 P_ci         number(8);

BEGIN

  select substr(valore,1,12)  D_pos_inail
    into P_pos_inail
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro    = 'P_POS_INAIL'
  ;
  select substr(valore,1,4)  D_gestione
    into P_gestione
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro    = 'P_GESTIONE'
  ;
  begin
  select substr(valore,1,4)    D_anno
    into P_anno
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro    = 'P_ANNO'
  ;
  exception
   when no_data_found then
           P_anno := null;
  end;
  begin
    select to_number(substr(valore,1,8))
      into P_ci
      from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_CI'
    ;
  exception
    when NO_DATA_FOUND then
      P_ci := to_number(null);
  end;
      select ente     D_ente
           , utente   D_utente
           , ambiente D_ambiente
        into P_ente, P_utente, P_ambiente
        from a_prenotazioni
       where no_prenotazione = prenotazione
      ;

  select to_char(to_date
                 ('01'||nvl(P_anno,anno),'mmyyyy')
                ,'ddmmyyyy')                                   D_ini_anno
       , to_char(to_date
                 ('3112'||nvl(P_anno,anno),'ddmmyyyy')
                ,'ddmmyyyy')                                 D_fin_anno
       , nvl(P_anno,anno)                                    D_anno
    into P_ini_anno, P_fin_anno, P_anno
    from riferimento_fine_anno
   where rifa_id = 'RIFA'
  ;

DECLARE

  D_pagina        number := 0;
  D_riga          number := 0;

BEGIN

    FOR CUR_DNA IN
  ( select dein.gestione           gest
         , dein.ci                 ci
         , dein.pos_inail          pos_inail
         , dein.dal                dal
         , dein.al                 al
         , 'Registrazioni con periodi Sovrapposti'  testo
      from riferimento_fine_anno       rifa
         , denuncia_inail              dein
     where rifa.rifa_id        = 'RIFA'
       and dein.anno           = nvl(P_anno,rifa.anno)
       and exists ( select 'x'
                      from denuncia_inail    dein1
                      where dein1.anno   = dein.anno
                        and dein1.ci     = dein.ci
                        and NVL(dein1.dal,to_date(P_ini_anno,'ddmmyyyy')) < NVL(dein.al,to_date(P_fin_anno,'ddmmyyyy'))
                        and nvl(dein1.al,to_date(P_fin_anno,'ddmmyyyy'))  > NVL(dein.dal,to_date(P_ini_anno,'ddmmyyyy'))
                        and rowid != dein.rowid
                   )
       and dein.ci = nvl(P_ci,dein.ci)
   union
    select dein.gestione           gest
         , dein.ci                 ci
         , dein.pos_inail          pos_inail
         , dein.dal                dal
         , dein.al                 al
         , 'Periodi con DAL > AL ' testo
      from riferimento_fine_anno       rifa
         , denuncia_inail              dein
     where rifa.rifa_id        = 'RIFA'
       and dein.anno           = nvl(P_anno,rifa.anno)
       and dein.dal           > NVL(dein.al,TO_DATE('3333333','j'))
       and dein.ci             = nvl(P_ci,dein.ci)
   union
    select dein.gestione           gest
         , dein.ci                 ci
         , dein.pos_inail          pos_inail
         , dein.dal                dal
         , dein.al                 al
         , 'Periodi Modificati per Cambio Posizione ' testo
      from riferimento_fine_anno       rifa
         , denuncia_inail              dein
         , a_segnalazioni_errore       seer
     where rifa.rifa_id        = 'RIFA'
       and dein.anno           = nvl(P_anno,rifa.anno)
       and dein.ci             = nvl(P_ci,dein.ci)
       and dein.ci             = to_number(substr(seer.precisazione,1,8))
       and seer.no_prenotazione = prenotazione
       and seer.passo          = 2
       and rtrim(ltrim(substr(seer.precisazione,9,20))) = 'MODIFICATO'
   union
    select dein.gestione           gest
         , dein.ci                 ci
         , dein.pos_inail          pos_inail
         , dein.dal                dal
         , dein.al                 al
         , 'Periodi NON Modificati per Cambio Posizione ' testo
      from riferimento_fine_anno       rifa
         , denuncia_inail              dein
         , a_segnalazioni_errore       seer
     where rifa.rifa_id        = 'RIFA'
       and dein.anno           = nvl(P_anno,rifa.anno)
       and dein.ci             = nvl(P_ci,dein.ci)
       and dein.ci             = to_number(substr(seer.precisazione,1,8))
       and seer.no_prenotazione = prenotazione
       and seer.passo         = 2
       and rtrim(ltrim(substr(seer.precisazione,9,20))) = 'NON MODIFICATO'
     order by 2,4,5
   ) LOOP
     BEGIN -- inserimento segnalazione
         D_riga   := D_riga   + 1;
         insert into a_appoggio_stampe( no_prenotazione,no_passo,pagina,riga,testo)
         values ( prenotazione
                 , 2
                 , D_pagina
                 , D_riga
                 , lpad(to_char(CUR_DNA.ci),8,'0')||
                   rpad(CUR_DNA.pos_inail,12,' ')||
                   to_char(CUR_DNA.dal,'dd/mm/yyyy')||
                   to_char(CUR_DNA.al,'dd/mm/yyyy')||
                   nvl(CUR_DNA.testo,'Segnalazione CADNA')
                 );
       END;
    END LOOP;
  COMMIT;
  END;
END;
END;
END;
/
