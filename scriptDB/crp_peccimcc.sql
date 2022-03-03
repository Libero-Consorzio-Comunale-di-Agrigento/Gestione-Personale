CREATE OR REPLACE PACKAGE peccimcc IS
/******************************************************************************
 NOME:          PECCIMCC
 DESCRIZIONE:   Controllo dell'esistenza dei codici dei cdc e dei fattori produttivi     
                Questa funzione controlla l'esistenza dei centri di costo e dei   
                fattori produttivi prima di eseguire l'archiviazione. 
                Se il controllo ha un esito positivo il passo seguente e` l'archi-
                viazione, in caso contrario viene elaborata una stampa che segnala
                le registrazioni errate.

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             
 1.1  20/09/2004 MS     Mod. per attività 7274
 1.2  16/08/2006 MS     Sistemazione dei controlli
 1.3  06/02/2007 MS     Mod. controlli su centri costo in caso di vista
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER, passo in number);
end;
/
CREATE OR REPLACE PACKAGE BODY peccimcc IS
   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.3 del 06/02/2007';
   END VERSIONE;
procedure main (prenotazione in number, passo in number) is
begin
DECLARE
  D_anno       number;
  D_da_mese    number;
  D_a_mese     number;
  D_dummy      VARCHAR2(1);
  riga         number;
  NO_REC       EXCEPTION;
  ERRORE1      EXCEPTION;
  ERRORE2      EXCEPTION;
  uscita       exception;
BEGIN
    riga := 0;
   BEGIN                                   -- Preleva Anno di Elaborazione
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
            from riferimento_retribuzione
           where rire_id = 'RIRE'
          ;
   END;

     if length(to_char(D_anno)) =  4 then
        null;
     else
        raise uscita;
     end if;

   BEGIN                              -- Preleva Mese di inizio Elaborazione
      select to_number(substr(valore,1,2))
        into D_da_mese
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_DA_MESE'
      ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
          D_da_mese := 0 ;
   END;
   BEGIN                              -- Preleva Mese di fine Elaborazione
      select to_number(substr(valore,1,2))
        into D_a_mese
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_A_MESE'
      ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
          D_a_mese := 0 ;
   END;
   BEGIN  -- Controllo Movimenti del trimestre
      select 'x'
        into D_dummy
        from dual
       where exists
            (select 'x' from movimenti_contabili
              where anno = D_anno
                and mese between D_da_mese and D_a_mese
            )
      ;
      RAISE TOO_MANY_ROWS;
   EXCEPTION
      WHEN TOO_MANY_ROWS THEN null;
      WHEN NO_DATA_FOUND THEN RAISE NO_REC;
   END;
   BEGIN  -- Controllo CdC sulle registrazioni del trimestre
      insert into a_segnalazioni_errore
      (no_prenotazione,passo,progressivo,errore,precisazione)
      select prenotazione,1,rownum,'P00109'
           , '!!! Error #'||to_char(pere.ci)||
             ' St/Sd '||sett.codice||'/'||sedi.codice
        from periodi_retributivi pere
           , settori sett
           , sedi sedi
       where sett.numero(+) = pere.settore
         and sedi.numero(+) = pere.sede
         and pere.periodo between
             last_day( to_date( to_char(D_anno)||
                                lpad(to_char(nvl(D_da_mese,12)),2,'0')
                               , 'yyyymm'
                              )
                     ) and
             last_day( to_date( to_char(D_anno)||
                                lpad(to_char(nvl(D_a_mese,12)),2,'0')
                               , 'yyyymm'
                              )
                     )
         and pere.competenza in ('D','A','C','P')
         and not exists
/* sostituita la subquery su RIFU mettendo RIFU direttamente in join con CECO
   la modifica so è resa necessaria per ovviare ad un problema ( vedi BO2480 )
   rilevato in caso di centri_costo come vista del CG4
*/
            (select 'x' 
               from centri_costo ceco
                  , ripartizioni_funzionali rifu
              where ceco.codice = rifu.cdc
                and rifu.settore = pere.settore
                and rifu.sede    = nvl(pere.sede,0)
            )
         and exists (select 'x' from rapporti_retributivi
                      where ci = pere.ci)
         and pere.contratto   != '*'
         and pere.gestione    != '*'
         and pere.trattamento != '*'
      ;
   END;
   BEGIN  -- Controllo FP sulle registrazioni del trimestre
      insert into a_segnalazioni_errore
      (no_prenotazione,passo,progressivo,errore,precisazione)
      select prenotazione,1,10000+rownum,'P00109'
           , '!!! Error #'||to_char(pere.ci)||
             ' Ql/TR/Fg '||qugi.codice||'/'||
                           pere.tipo_rapporto||'/'||figi.codice
        from periodi_retributivi pere
           , qualifiche_giuridiche qugi
           , figure_giuridiche figi
       where qugi.numero(+) = pere.qualifica
         and pere.periodo between nvl(qugi.dal(+),to_date('2222222','j'))
                              and nvl(qugi.al(+),to_date('3333333','j'))
         and figi.numero(+) = pere.figura
         and pere.periodo between nvl(figi.dal(+),to_date('2222222','j'))
                              and nvl(figi.al(+),to_date('3333333','j'))
         and pere.periodo between
             last_day( to_date( to_char(D_anno)||
                                lpad(to_char(nvl(D_da_mese,12)),2,'0')
                               , 'yyyymm'
                              )
                     ) and
             last_day( to_date( to_char(D_anno)||
                                lpad(to_char(nvl(D_a_mese,12)),2,'0')
                               , 'yyyymm'
                              )
                     )
         and pere.competenza in ('D','A','C','P')
         and not exists
            (select 'x' from qualifiche qual,figure figu
              where qual.numero = pere.qualifica
                and figu.numero = pere.figura
                and (   (    pere.tipo_rapporto = 'TD'
                         and nvl(rtrim(ltrim(qual.fattore_td)),rtrim(ltrim(figu.fattore_td))) is not null
                        )
                     or      nvl(rtrim(ltrim(qual.fattore)),rtrim(ltrim(figu.fattore))) is not null
                    )
            )
         and exists (select 'x' from rapporti_retributivi
                      where ci = pere.ci)
         and pere.contratto   != '*'
         and pere.gestione    != '*'
         and pere.trattamento != '*'
      ;
   END;
   BEGIN
      select 'x'
        into D_dummy
        from a_segnalazioni_errore
       where no_prenotazione = prenotazione
         and precisazione like '%St/Sd%'
      ;
      RAISE TOO_MANY_ROWS;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN null;
      WHEN TOO_MANY_ROWS THEN
         update a_prenotazioni set errore = 'P00109'
                                 , prossimo_passo = 91
          where no_prenotazione = prenotazione
         ;
        insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                         ,errore,precisazione)
        values (prenotazione,1,0,'P00109',
                ': Settore e Sede senza indicazione del CDC'
               )
        ;
   END;
   BEGIN
      select 'x'
        into D_dummy
        from a_segnalazioni_errore
       where no_prenotazione = prenotazione
         and precisazione like '%Ql/TR/Fg%'
      ;
      RAISE TOO_MANY_ROWS;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN null;
      WHEN TOO_MANY_ROWS THEN
         update a_prenotazioni set errore = 'P00109'
                                 , prossimo_passo = 91
          where no_prenotazione = prenotazione
         ;
        insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                         ,errore,precisazione)
        values (prenotazione,1,10000,'P00109',
                ': Qualifica/Figura senza Fattore Produttivo'
               )
        ;
   END;
COMMIT;
EXCEPTION
   WHEN NO_REC THEN
        update a_prenotazioni set errore = 'P00105'
                                , prossimo_passo = 99
         where no_prenotazione = prenotazione
        ;
        riga := riga + 1;
        insert into a_segnalazioni_errore(no_prenotazione,passo,progressivo
                                         ,errore,precisazione)
        values (prenotazione,1,riga,'P00105',
                'Non esistono Movimenti Contabili per il periodo')
        ;
    when uscita then
        update a_prenotazioni set errore = 'L''anno deve essere nel formato yyyy'
                                  , prossimo_passo = 91
        where no_prenotazione = prenotazione
        ;
END;
end;
end;
/

