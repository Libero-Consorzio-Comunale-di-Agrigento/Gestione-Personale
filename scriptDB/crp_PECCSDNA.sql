/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE PECCSDNA IS
/******************************************************************************
 NOME:        PECCSDNA 
 DESCRIZIONE: Creazione del flusso per la Denuncia Nominativa Assicuarti INAIL su sup-
              porto magnetico (dischetti a 5',25 o 3',50 - ASCII - lung. 100 crt.).
              La creazione avviene da tabella di lavoro creata dai movimenti al fine
              di potere permettere eventuali variazioni ai  movimenti stessi.
              Questa fase produce un file secondo i tracciati imposti dalla Direzione
              dell' INAIL.  La movimentazione e` presa da tabella di lavoro.
              
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/
/*<TOAD_FILE_CHUNK>*/

CREATE OR REPLACE PACKAGE BODY PECCSDNA IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
 BEGIN
 
DECLARE
 
 P_anno       number(4);
 P_nome_file  varchar2(9);
 P_ini_anno   date;
 P_fin_anno   date;
 P_anno_p     number(4);
 P_ini_anno_p date;
 P_fin_anno_p date;
 P_pos_inail  varchar2(12);
 P_supporto   varchar2(1);

BEGIN

  select substr(valore,1,12)  D_pos_inail
    into P_pos_inail
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro    = 'P_POS_INAIL'
  ;

  select nvl(to_number(substr(valore,1,4)),r.anno)    D_anno
       , 'DNA'||to_char(substr(nvl(valore,to_char(r.anno)),3,2)+1)||'.dat'
                                           D_nome_file
    into P_anno, P_nome_file
	from a_parametri,riferimento_fine_anno r
   where no_prenotazione = prenotazione
     and parametro    = 'P_ANNO'
     and r.rifa_id    = 'RIFA'
  
  union
  
  select r.anno     D_anno
       , 'DNA'||to_char(substr(to_char(r.anno),3,2)+1)||'.dat'
                                           D_nome_file
	from riferimento_fine_anno r
   where r.rifa_id    = 'RIFA'
     and not exists
         (select 'x'
            from a_parametri
           where no_prenotazione = prenotazione
             and parametro    = 'P_ANNO'
         )
  ;

  select substr(valore,1,1)  D_supporto
    into P_supporto
	from a_parametri
   where no_prenotazione = prenotazione
     and parametro    = 'P_SUPPORTO'
  ;

  select to_date('01'||(nvl(P_anno,anno)-1),'mmyyyy')     D_ini_anno_p
       , to_date('3112'||(nvl(P_anno,anno)-1),'ddmmyyyy') D_fin_anno_p
       , nvl(P_anno,anno) - 1                           D_anno_p
       , to_date('01'||nvl(P_anno,anno),'mmyyyy')       D_ini_anno
       , to_date('3112'||nvl(P_anno,anno),'ddmmyyyy')   D_fin_anno
       , nvl(P_anno,anno)                               D_anno
    into p_ini_anno_p, P_fin_anno_p, P_anno_p, P_ini_anno, P_fin_anno, P_anno
	from riferimento_fine_anno
   where rifa_id = 'RIFA'
  ;


DECLARE 
  
  P_pagina number;
  P_riga   number;
  P_tot_01 number;
  P_tot_02 number;
  esiste   varchar2(1);
 
  BEGIN

  P_pagina := 1;
  P_riga   := 1;
  P_tot_01 := 0;
 

    FOR CUR_POS in
       (select dein.pos_inail         inail
             , max(gest.nome)         gest_nome
             , gest.codice_fiscale    gest_cf
          from denuncia_inail         dein
             , gestioni               gest
         where dein.pos_inail   like P_pos_inail
           and gest.codice         = dein.gestione
           and dein.anno           = P_anno
         group by dein.pos_inail,gest.codice_fiscale
       ) LOOP
           BEGIN
             BEGIN
               select 'x'
                 into esiste
                 from a_appoggio_stampe
                where no_prenotazione = prenotazione
                  and no_passo        = 1
                  and testo =
                lpad(' ',7)||
                lpad(nvl(substr(ltrim(CUR_POS.inail)
                               ,1
                               ,least(8
                                     ,decode(instr(CUR_POS.inail,'/')
                                            ,0,8
                                              ,instr(CUR_POS.inail,'/')-1
                                            )
                                     )
                               )
                        ,'0')
                    ,8,'0')||
                lpad (nvl( substr( CUR_POS.inail
                                 ,decode( instr(CUR_POS.inail,'/')
                                          ,0,9
                                            ,instr(CUR_POS.inail,'/')+1
                                        )
                              ,2)
                        ,'0')
                   ,2,'0')||
                '01'||
                rpad(CUR_POS.gest_nome,54,' ')||
                rpad(CUR_POS.gest_cf,16,' ')||
                '00000000000'
               ;
               RAISE TOO_MANY_ROWS;
             EXCEPTION
               WHEN TOO_MANY_ROWS THEN null;
               WHEN NO_DATA_FOUND THEN

                 P_pagina := P_pagina + 1;
                 P_riga   := P_riga   + 1;
                 P_tot_01 := P_tot_01 + 1;
 
                 insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo) 
                 values ( prenotazione
                        , 1
                        , P_pagina
                        , P_riga  
                        , lpad(' ',7)||
                          lpad(nvl(substr(ltrim(CUR_POS.inail)
                                         ,1
                                         ,least(8
                                               ,decode(instr(CUR_POS.inail,'/')
                                                      ,0,8
                                                        ,instr(CUR_POS.inail,'/')-1
                                                      )
                                               )
                                         )
                                  ,'0')
                              ,8,'0')||
                          lpad (nvl( substr( CUR_POS.inail
                                           ,decode( instr(CUR_POS.inail,'/')
                                                    ,0,9
                                                      ,instr(CUR_POS.inail,'/')+1
                                                  )
                                        ,2)
                                  ,'0')
                             ,2,'0')||
                          '01'||
                          rpad(CUR_POS.gest_nome,54,' ')||
                          rpad(CUR_POS.gest_cf,16,' ')||
                          '00000000000'
                        )
                 ;
               END;
             FOR CUR_DEIN in
                (select anag.codice_fiscale      anag_cf
                      , dein.tipo_variazione     tipo
                      , dein.data_variazione     data
                   from anagrafici               anag
                      , denuncia_inail           dein
                  where dein.anno      = P_anno
                    and dein.pos_inail = CUR_POS.inail
                    and anag.ni        = 
                       (select max(ni) from rapporti_individuali
                         where ci      = dein.ci
                       )
                    and anag.al is null
                ) LOOP
                    
                    P_pagina := P_pagina + 1;
                    P_riga   := P_riga   + 1;

                    insert into a_appoggio_stampe (no_prenotazione,no_passo,pagina,riga,testo) 
                    values ( prenotazione
                           , 1
                           , P_pagina
                           , P_riga  
                           , lpad(' ',7)||
                             lpad(nvl(substr
                                      (ltrim(CUR_POS.inail)
                                      ,1
                                      ,least(8
                                            ,decode(instr(CUR_POS.inail,'/')
                                                   ,0,8
                                                     ,instr(CUR_POS.inail,'/')-1
                                                   )
                                            )
                                      )
                                     ,'0')
                                 ,8,'0')||
                             lpad(nvl(substr(CUR_POS.inail
                                            ,decode(instr(CUR_POS.inail,'/')
                                                   ,0,9
                                                     ,instr(CUR_POS.inail,'/')+1
                                                   )
                                            ,2)
                                     ,'0')
                                 ,2,'0')||
                             '02'||
                             rpad(CUR_DEIN.anag_cf,16,' ')||
                             rpad(' ',5,' ')||
                             CUR_DEIN.tipo||
                             to_char(CUR_DEIN.data,'ddmmyy')||
                             rpad(' ',37,' ')||
                             decode( P_supporto
                                   , null, 'NASTRO'||
                                           substr(to_char(P_anno+1),3,2)
                                         , 'DISK'||to_char(P_anno+1))||
                             '00000000'
                           )
                    ;
                  END LOOP;
           END;
         END LOOP;
    
         select count(distinct testo)
           into P_tot_02
           from a_appoggio_stampe
          where no_prenotazione = prenotazione
            and substr(testo,18,2) = '02'
          ;

         insert into a_appoggio_stampe (no_prenotazione,no_passo,pagina,riga,testo) 
         values ( prenotazione
                , 1
                , 1
                , 1
                , lpad(' ',17)||
                  '00'||
                  lpad(to_char(P_tot_01),4,'0')||
                  lpad(to_char(P_tot_02),5,'0')||
                  lpad('0',72,'0')
                )
         ; 
  COMMIT;
  END;
END;
end;
END;
/
