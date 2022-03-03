/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE peccsmdl IS
/******************************************************************************
 NOME:        PECCSMDL
 DESCRIZIONE: Creazione del flusso per la Denuncia Nominativa Assicuarti INAIL su sup-
              porto magnetico (dischetti a 5',25 o 3',50 - ASCII - lung. 100 crt.).
              Questa fase produce un file secondo i tracciati imposti dalla Direzione
              dell' INAIL.

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  La gestione che deve risultare come intestataria della denuncia
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
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN ( prenotazione in number, passo in number);
END;
/
/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE BODY peccsmdl IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	    P_anno   	 number(4);
		P_nome_file  varchar2(9);
		P_ini_anno   date;
		P_fin_anno   date;
		P_anno_p     number(4);
		P_ini_anno_p date;
		P_fin_anno_p date;
		P_pos_inail  varchar2(12);
		P_supporto   varchar2(1);
	begin
	
	select substr(valore,1,12)  D_pos_inail
	into p_pos_inail
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro    = 'P_POS_INAIL'
  ;
  begin
  select substr(valore,1,4)    D_anno
       , 'DNA'||to_char(substr(valore,3,2)+1)||'.dat'  D_nome_file
	into p_anno, p_nome_file
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro    = 'P_ANNO'
  ;
  exception when no_data_found then
  			P_anno := null;
  			P_nome_file := null;
  end;
/*  
  select substr(valore,1,1)  D_supporto
    into p_supporto
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro    = 'P_SUPPORTO'
  ;
  */
  select to_date('01'||(nvl('',anno)-1),'mmyyyy')     
       , to_date('3112'||(nvl('',anno)-1),'ddmmyyyy') 
       , nvl('',anno) - 1                           
       , to_date('01'||nvl('',anno),'mmyyyy')       
       , to_date('3112'||nvl('',anno),'ddmmyyyy')   
       , nvl(P_anno,anno)                               
	   , nvl(P_nome_file,'DNA'||to_char(substr(to_char(anno),3,2)+1)||'.dat' ) 
	into p_ini_anno_p, p_fin_anno_p, p_anno_p, p_ini_anno, p_fin_anno, p_anno, p_nome_file
    from riferimento_fine_anno
   where rifa_id = 'RIFA'
  ;
DECLARE
  P_pagina number;
  P_riga   number;
  P_tot_01 number;
  P_tot_02 number;
  BEGIN
  P_pagina := 1;
  P_riga   := 1;
  P_tot_01 := 0;
    FOR CUR_POS in
       (select asin.posizione         inail
             , asin.codice            cod_inail
             , max(gest.nome)         gest_nome
             , gest.codice_fiscale    gest_cf
          from assicurazioni_inail    asin
             , gestioni               gest
         where asin.posizione   like ''
           and lpad(nvl(asin.posizione,'0'),12,'0') != '000000000000'
           and (gest.codice,asin.codice)  in
              (select distinct pegi.gestione,rare.posizione_inail
                 from periodi_giuridici    pegi
                    , rapporti_retributivi rare
                where pegi.rilevanza = 'S'
                  and pegi.ci = rare.ci
                  and pegi.dal = (select max(dal) from periodi_giuridici
                                   where rilevanza = pegi.rilevanza
                                     and ci = pegi.ci
                                     and dal <= ''
                                 )
                  and nvl(pegi.al,to_date('3333333','j')) >= ''
                  and nvl(rare.data_inail,'') <= ''
              )
         group by asin.posizione,asin.codice,gest.codice_fiscale
       ) LOOP
           BEGIN
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
             FOR CUR_MOCO1 in
                (select anag.codice_fiscale      anag_cf
                      , '1'                      tipo
                      , to_char(to_date(lpad(to_char(moco.mese),2,'0')||
                                             to_char(moco.anno),'mmyyyy')
                               ,'ddmmyy') data
                   from anagrafici               anag
                      , movimenti_contabili      moco
                  where moco.anno  = P_anno
                    and moco.mese >= 1
                    and (moco.voce,moco.sub) =
                       (select voce,sub from voci_inail
                         where codice = CUR_POS.cod_inail)
                    and anag.ni =
                       (select max(ni) from rapporti_individuali
                         where ci = moco.ci)
                    and anag.al is null
                    and exists
                       (select 'x' from movimenti_contabili
                         where ci     = moco.ci
                           and voce   = moco.voce
                           and sub   != moco.sub
                           and ((    mese = moco.mese - 1
                                 and anno = moco.anno
                                ) or
                                (    mese = 12
                                 and anno = moco.anno - 1
                                 and moco.mese = 1
                                )
                               )
                       )
                    and not exists
                       (select 'x' from periodi_giuridici pegi
                         where pegi.rilevanza       = 'P'
                           and pegi.dal between ''
                                            and ''
                           and pegi.ci        = moco.ci
                           and to_char(pegi.dal,'mm') =
                              (select min(mese)
                                 from movimenti_contabili
                                where anno = P_anno
                                  and voce = moco.voce
                                  and sub  = moco.sub
                                  and ci   = moco.ci
                                  and pegi.dal
                                      between to_date(lpad(to_char(mese),2,'0')
                                                      ||to_char(anno)
                                                     ,'mmyyyy')
                                  and last_day(to_date(lpad(to_char(mese),2,'0')
                                                       ||to_char(anno)
                                                      ,'mmyyyy'))
                              )
                       )
                ) LOOP
                    P_pagina := P_pagina + 1;
                    P_riga   := P_riga   + 1;
                    insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
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
                             rpad(CUR_MOCO1.anag_cf,16,' ')||
                             rpad(' ',5,' ')||
                             CUR_MOCO1.tipo||
                             CUR_MOCO1.data||
                             rpad(' ',37,' ')||
                             decode( ''
                                   , null, 'NASTRO'||
                                           substr(to_char(P_anno+1),3,2)
                                         , 'DISK'||to_char(P_anno+1))||
                             '00000000'
                           )
                    ;
                  END LOOP;
             FOR CUR_MOCO2 in
                (select anag.codice_fiscale      anag_cf
                      , '2'                      tipo
                      , to_char(last_day(to_date
                                         (lpad(to_char(moco.mese),2,'0')||
                                               to_char(moco.anno)
                                         ,'mmyyyy')),'ddmmyy') data
                   from anagrafici               anag
                      , movimenti_contabili      moco
                  where moco.anno  = P_anno
                    and moco.mese >= 1
                    and (moco.voce,moco.sub) =
                       (select voce,sub from voci_inail
                         where codice = CUR_POS.cod_inail)
                    and anag.ni =
                       (select max(ni) from rapporti_individuali
                         where ci = moco.ci)
                    and anag.al is null
                    and exists
                       (select 'x' from movimenti_contabili
                         where ci     = moco.ci
                           and voce   = moco.voce
                           and sub   != moco.sub
                           and ((    mese = moco.mese + 1
                                 and anno = moco.anno
                                ) or
                                (    mese = 12
                                 and anno = moco.anno + 1
                                 and moco.mese = 1
                                )
                               )
                       )
                    and not exists
                       (select 'x' from periodi_giuridici pegi
                         where pegi.rilevanza       = 'P'
                           and pegi.dal between ''
                                            and ''
                           and pegi.ci        = moco.ci
                           and to_char(pegi.al,'mm') =
                              (select max(mese)
                                 from movimenti_contabili
                                where anno = P_anno
                                  and voce = moco.voce
                                  and sub  = moco.sub
                                  and ci   = moco.ci
                                  and pegi.al
                                      between to_date(lpad(to_char(mese),2,'0')
                                                      ||to_char(anno)
                                                     ,'mmyyyy')
                                  and last_day(to_date(lpad(to_char(mese),2,'0')
                                                       ||to_char(anno)
                                                      ,'mmyyyy'))
                              )
                       )
                ) LOOP
                    P_pagina := P_pagina + 1;
                    P_riga   := P_riga   + 1;
                    insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
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
                             rpad(CUR_MOCO2.anag_cf,16,' ')||
                             rpad(' ',5,' ')||
                             CUR_MOCO2.tipo||
                             CUR_MOCO2.data||
                             rpad(' ',37,' ')||
                             decode( ''
                                   , null, 'NASTRO'||
                                           substr(to_char(P_anno+1),3,2)
                                         , 'DISK'||to_char(P_anno+1))||
                             '00000000'
                           )
                    ;
                  END LOOP;
             FOR CUR_PEGI1 in
                (select anag.codice_fiscale        anag_cf
                      , '1'                        tipo
                      , to_char(pegi.dal,'ddmmyy') data
                   from anagrafici                 anag
                      , periodi_giuridici          pegi
                  where anag.ni =
                       (select max(ni) from rapporti_individuali
                         where ci = pegi.ci)
                    and anag.al is null
                    and pegi.ci in (select ci from rapporti_giuridici)
                    and pegi.rilevanza = 'P'
                    and pegi.dal between ''
                                     and ''
                    and exists
                       (select 'x' from movimenti_contabili moco
                         where moco.anno  = P_anno
                           and moco.ci    = pegi.ci
                           and (moco.voce,moco.sub) =
                              (select voce,sub from voci_inail
                                where codice = CUR_POS.cod_inail)
                           and moco.mese  =
                              (select min(mese)
                                 from movimenti_contabili
                                where anno = P_anno
                                  and voce = moco.voce
                                  and ci   = moco.ci
                                  and last_day(to_date(lpad(to_char(mese),2,'0')
                                                       ||to_char(anno)
                                                      ,'mmyyyy')) >= pegi.dal
                              )
                       )
                ) LOOP
                    P_pagina := P_pagina + 1;
                    P_riga   := P_riga   + 1;
                    insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
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
                             rpad(CUR_PEGI1.anag_cf,16,' ')||
                             rpad(' ',5,' ')||
                             CUR_PEGI1.tipo||
                             CUR_PEGI1.data||
                             rpad(' ',37,' ')||
                             decode( ''
                                   , null, 'NASTRO'||
                                           substr(to_char(P_anno+1),3,2)
                                         , 'DISK'||to_char(P_anno+1))||
                             '00000000'
                           )
                    ;
                  END LOOP;
             FOR CUR_PEGI2 in
                (select anag.codice_fiscale        anag_cf
                      , '2'                        tipo
                      , to_char(pegi.al,'ddmmyy')  data
                   from anagrafici                 anag
                      , periodi_giuridici          pegi
                  where anag.ni =
                       (select max(ni) from rapporti_individuali
                         where ci = pegi.ci)
                    and anag.al is null
                    and pegi.ci in (select ci from rapporti_giuridici)
                    and pegi.rilevanza = 'P'
                    and pegi.al between ''
                                    and ''
                    and exists
                       (select 'x' from movimenti_contabili moco
                         where moco.anno  = P_anno
                           and moco.ci    = pegi.ci
                           and (moco.voce,moco.sub) =
                              (select voce,sub from voci_inail
                                where codice = CUR_POS.cod_inail)
                           and moco.mese  =
                              (select max(mese)
                                 from movimenti_contabili
                                where anno = P_anno
                                  and voce = moco.voce
                                  and ci   = moco.ci
                                  and to_date(lpad(to_char(mese),2,'0')
                                                   ||to_char(anno)
                                             ,'mmyyyy') <= pegi.al
                              )
                       )
                ) LOOP
                    P_pagina := P_pagina + 1;
                    P_riga   := P_riga   + 1;
                    insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
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
                             rpad(CUR_PEGI2.anag_cf,16,' ')||
                             rpad(' ',5,' ')||
                             CUR_PEGI2.tipo||
                             CUR_PEGI2.data||
                             rpad(' ',37,' ')||
                             decode( ''
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
         insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
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

  update a_selezioni
     set valore_default = p_nome_file
   where parametro='TXTFILE'
     and voce_menu = (select voce_menu
	 	 		   	    from a_prenotazioni
					   where no_prenotazione = prenotazione
					  );

 COMMIT;
end;
end;
  END;
/

