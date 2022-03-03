CREATE OR REPLACE PACKAGE peccudep IS
/******************************************************************************
 NOME:          PECCUDEP
 DESCRIZIONE:   Controllo sul numero di pagine del Modello CUD.

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  30/01/2007 GM     Prima Emissione
 1.1  06/02/2007 MS     Migliorie e Correzioni
 1.2  12/02/2007 MS     Migliorie e Correzioni
******************************************************************************/
  FUNCTION VERSIONE return varchar2;
  PROCEDURE MAIN (prenotazione in number, passo in number);
end;
/
CREATE OR REPLACE PACKAGE BODY peccudep IS
  FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
   NOME:        VERSIONE
                Restituisce la versione e la data di distribuzione del package.
   PARAMETRI:   --
   RITORNA:     stringa varchar2 contenente versione e data.
   NOTE:        Il secondo numero della versione corrisponde alla revisione
                del package.
******************************************************************************/
  BEGIN
     RETURN 'V1.2 del 12/02/2007';
  END VERSIONE;
    
  PROCEDURE MAIN (prenotazione in number, passo in number)IS
  BEGIN
  DECLARE
   P_anno              number(4);
   P_tipo_terza_pagina varchar2(1);
   P_ordinamento       varchar2(1);
   D_pag_cud           number := 0;
   D_pag_note          number := 0;
   D_str_cud           varchar2(100) := ' piu Modelli CUD';
   D_str_cud1          varchar2(100) := ' UNA sola Pagina CUD (!!!)';
   D_str_note          varchar2(100) := ' piu Pagine Note';
   D_str_cud_note      varchar2(100) := ' piu Modelli CUD e piu Pagine Note';
   D_str_cud1_note     varchar2(100) := ' UNA sola Pagina CUD (!!!) e piu Pagine Note';
   D_str_cud_note0     varchar2(100) := ' piu Modelli CUD e SENZA Pagine Note (!!!)';
   D_str_note0         varchar2(100) := ' SENZA Pagine Note (!!!)';
   D_str_cud1_note0    varchar2(100) := ' UNA sola Pagina CUD (!!!) e SENZA Pagine Note (!!!)';
   D_commento          varchar2(100);
   D_riga              number;
   D_riga_eccezioni    number;
   D_numero_pagine     number(1);
    BEGIN
 /* INIZIO ESTRAZIONE PARAMETRI */
      BEGIN
        select valore
          into P_anno
          from a_parametri
         where parametro = 'P_ANNO' 
           and no_prenotazione = prenotazione
        ;
      EXCEPTION
        when no_data_found then
          select anno 
            into P_anno
            from riferimento_fine_anno
           where rifa_id = 'RIFA'
        ;
      END;
      BEGIN
        select valore
          into P_tipo_terza_pagina
          from a_parametri
         where parametro = 'P_TERZA_PAGINA' 
           and no_prenotazione = prenotazione
        ;
      EXCEPTION
        when no_data_found then
          P_tipo_terza_pagina := 'P';
      END;
      BEGIN
        select valore
          into P_ordinamento
          from a_parametri
         where parametro = 'P_ORDINAMENTO' 
           and no_prenotazione = prenotazione
        ;
      EXCEPTION
        when no_data_found then
          P_ordinamento := null;
      END;
 /* FINE ESTRAZIONE PARAMETRI */
        d_riga := 0;
        d_riga_eccezioni := 0;
        if P_tipo_terza_pagina = 'S' then
          D_numero_pagine := 3;
        else
          D_numero_pagine := 2;
        end if;
    FOR CUR_ELENCO in 
     (   select distinct rain.ci ci
              , max(rain.cognome || ' ' || rain.nome) nominativo  -- 2
              , to_number(null)  pagina -- 3
              , null s1 -- 4
              , null s2 -- 5
              , null s3 -- 6
              , null s4 -- 7
           from rapporti_individuali rain
              , a_appoggio_stampe apst
          where apst.no_prenotazione = prenotazione
            and rain.ci = to_number(substr(apst.testo,1,8))
            and apst.riga = 1
            and nvl(P_ordinamento,' ')  != 'X'
          group by rain.ci
         union
         select distinct rain.ci
              , max(rain.cognome || ' ' || rain.nome) nominativo
              , max(apst.pagina) pagina
              , max(trfa.s1) s1
              , max(trfa.s2) s2
              , max(trfa.s3) s3
              , max(trfa.s4) s4
           from rapporti_individuali rain
              , a_appoggio_stampe    apst
              , tab_report_fine_anno trfa
          where apst.no_prenotazione = prenotazione
            and rain.ci = to_number(substr(apst.testo,1,8))
            and apst.riga = 1
            and trfa.ci  = rain.ci
            and nvl(trfa.anno,P_anno) = P_anno
            and nvl(P_ordinamento,' ')  = 'X'
          group by rain.ci
         union
         select distinct rain.ci
              , max(rain.cognome || ' ' || rain.nome) nominativo
              , max(apst.pagina) pagina
              , null s1
              , null s2
              , null s3
              , null s4
           from rapporti_individuali rain
              , a_appoggio_stampe    apst
          where apst.no_prenotazione = prenotazione
            and rain.ci = to_number(substr(apst.testo,1,8))
            and apst.riga = 1
            and nvl(P_ordinamento,' ')  = 'X'
            and not exists ( select 'x' 
                               from tab_report_fine_anno 
                              where ci   = rain.ci
                                and nvl(anno,P_anno) = P_anno
                           )
          group by rain.ci
          order by 3, 4, 5, 6, 7, 2
   ) LOOP
 
   D_pag_cud   := 0;
   D_pag_note  := 0;

       BEGIN
         select count(decode(elaborazione,'STAMPA_CUD',no_pagine)) pag_cud
              , count(decode(elaborazione,'NOTE_CUD',no_pagine))   pag_note   
           into D_pag_cud
              , D_pag_note
           from pagine_note          pano
          where pano.no_prenotazione = prenotazione
            and pano.ci              = CUR_ELENCO.ci
           group by pano.ci
        ;
       EXCEPTION WHEN NO_DATA_FOUND THEN
           D_pag_cud := 0;
           D_pag_note := 0;
       END;
           BEGIN         
           D_commento := ' ';
           /* INTESTAZIONE */
           if d_riga_eccezioni = 1 or d_riga_eccezioni mod 57 = 0 then
              d_riga_eccezioni := d_riga_eccezioni + 1;
              insert into a_appoggio_stampe
              ( no_prenotazione, no_passo, pagina, riga, testo) 
              values ( prenotazione
                     , passo + 1
                     , 1
                     , d_riga_eccezioni
                     , rpad('Cod.Ind.',15) || '  ' || lpad('Pagine CUD',10)|| '  ' || lpad('Pagine NOTE',11) || '  ' || rpad('Commmento',50))
                   ;
              d_riga_eccezioni := d_riga_eccezioni + 1;         
              insert into a_appoggio_stampe
              ( no_prenotazione, no_passo, pagina, riga, testo) 
              values ( prenotazione
                     , passo + 1
                     , 1
                     , d_riga_eccezioni
                     , rpad('-',15,'-') || '  ' ||
                       rpad('-',10,'-') || '  ' ||
                       rpad('-',11,'-') || '  ' ||
                       rpad('-',90,'-')
                     );
             end if;                              
             if d_riga = 1 or d_riga mod 57 = 0 then         
                d_riga := d_riga + 1;
                insert into a_appoggio_stampe
                ( no_prenotazione, no_passo, pagina, riga, testo) 
                values ( prenotazione
                       , passo
                       , 1
                       , d_riga
                       , rpad('Cod.Ind.',15) || '  ' ||
                         lpad('Pagine CUD',10)|| '  ' ||
                         lpad('Pagine NOTE',11) || '  ' ||
                         rpad('Commmento',50)
                       ) ;
                d_riga := d_riga + 1;
                insert into a_appoggio_stampe
                ( no_prenotazione, no_passo, pagina, riga, testo) 
                values ( prenotazione
                       , passo
                       , 1
                       , d_riga
                       , rpad('-',15,'-') || '  ' ||
                         rpad('-',10,'-') || '  ' ||
                         rpad('-',11,'-') || '  ' ||
                         rpad('-',90,'-')
                       );
             end if;
             /* CORPO */

             if D_pag_cud > D_numero_pagine and D_pag_note = 1 then
               D_commento := ' : '||D_str_cud;
             elsif D_pag_note > 1 and D_pag_cud = D_numero_pagine then
               D_commento := ' : '||D_str_note;
             elsif D_pag_cud > D_numero_pagine and D_pag_note > 1 then
               D_commento := ' : '||D_str_cud_note;
             elsif D_pag_cud = 1 and D_pag_note = 1 then
               D_commento := ' : '||D_str_cud1;
             elsif D_pag_cud = 1 and D_pag_note > 1 then
               D_commento := ' : '||D_str_cud1_note;
             elsif D_pag_cud = D_numero_pagine and D_pag_note = 0 then
               D_commento := ' : '||D_str_note0;
             elsif D_pag_cud > D_numero_pagine and D_pag_note = 0 then
               D_commento := ' : '||D_str_cud_note0;
             elsif D_pag_cud = 1 and D_pag_note = 0 then
               D_commento := ' : '||D_str_cud1_note0;
             end if; 

             d_riga := d_riga + 1;         
             /* ECCEZIONE */
             if D_commento <> ' ' then
                d_riga_eccezioni := d_riga_eccezioni + 1;
                insert into a_appoggio_stampe
                ( no_prenotazione, no_passo, pagina, riga, testo)
                values ( prenotazione
                       , passo + 1
                       , 1 
                       , d_riga_eccezioni
                       , rpad(CUR_ELENCO.ci,15,' ') ||'  '||
                         lpad(D_pag_cud,10,' ') ||'  '|| 
                         lpad(D_pag_note,11,' ') || '  ' ||
                         rpad(CUR_ELENCO.nominativo,40,' ') ||
                         rpad(D_commento,50,' ')
                       );
             end if; 
             /* FINE ECCEZIONE */
             insert into a_appoggio_stampe
             ( no_prenotazione, no_passo, pagina, riga, testo)
             values ( prenotazione
                    , passo
                    , 1
                    , d_riga
                    , rpad(CUR_ELENCO.ci,15,' ') ||'  '||
                      lpad(D_pag_cud,10,' ') ||'  '||
                      lpad(D_pag_note,11,' ') || '  ' ||
                      rpad(CUR_ELENCO.nominativo,40,' ') ||
                      rpad(D_commento,50,' ')
                    );
       END;
    END LOOP; -- CUR_ELENCO
    delete 
      from pagine_note
     where no_prenotazione = prenotazione
    ;  
    END;
    commit;
  END;
END peccudep;
/
