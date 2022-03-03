/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE PECCSMFD IS
/******************************************************************************
 NOME:         PECCSMFD
 DESCRIZIONE:  Creazione del flusso per la Denuncia Fiscale 770 / SD su
               supporto magnetico
               (nastri a bobina o dischetti - ASCII - lung. 4000 crt.).
               Questa fase produce un file secondo un tracciato concordato a livello
               aziendale per via dei limiti di ORACLE che permette di creare record
               di max 250 crt. Una ulteriore elaborazione adeguera' questi files al
               tracciato imposto dal Ministero delle Finanze.
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: La gestione che deve risultare come intestataria della denuncia
              deve essere stata inserita in << DGEST >> in modo tale che la
              ragione sociale (campo nome) risulti essere la minore di tutte
              le altre eventualmente inserite.
              Lo stesso risultato si raggiunge anche inserendo un BLANK prima
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
PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
/*<TOAD_FILE_CHUNK>*/

CREATE OR REPLACE PACKAGE BODY PECCSMFD IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
 BEGIN 
DECLARE 
--
-- Depositi e Contatori Vari
--
  D_dummy           varchar2(1);
  D_r1              varchar2(20);
  D_filtro_1        varchar2(15);
  D_pagina          number;
  D_riga            number;
  D_modulo          number;
  D_num_ord         number;
  D_dep_num_ord     number;
  D_dep_mese        number := 0;
  D_conta_mese      number := 0;
  D_dep_pagina      number := 0;
  D_dep_pag_1       number := 0;
  D_dep_pag_2       number := 0;
  D_dep_pag_ret     number := 0;
  D_dep_num_1       number := 0;
  D_dep_num_2       number := 0;
  D_dep_num_ret     number := 0;
  D_non_terminato   varchar2(1);
  D_cur_deca        varchar2(1);
  D_dep_tipo        varchar2(1);
  
--
-- Variabili di Periodo
--
  D_anno            number;
  D_ini_a           date;
  D_fin_a           date;
--
-- Variabili di Ente
--
  D_cod_fis_dic     varchar2(16);
  D_ente_cf         varchar2(16);
--
-- Variabili di Dettaglio
--
  D_cod_fis         varchar2(16);
  D_dep_cod_fis     varchar2(16);
  D_esito_28        varchar2(1);
  D_st_esito_28     varchar2(1);
  D_tipo            varchar2(1);
  D_esito_38        varchar2(1);
  D_esito_2r        varchar2(1);
  D_st_esito_38     varchar2(1);
  D_esito_61        varchar2(1);
  D_tot_rate        varchar2(1);
  D_caaf_nome       varchar2(40);
  D_caaf_cod_fis    varchar2(16);
  D_caaf_nr_albo    varchar2(16);
  D_data_ric        varchar2(16);
  D_data_prima_ric  varchar2(16);
  D_data_ric_int    varchar2(16);
  D_cod_r_dic_db 	varchar2(16);
  D_cod_r_con_db 	varchar2(16);
  D_cod_r_dic_cr 	varchar2(16);
  D_cod_r_con_cr 	varchar2(16);
  D_cod_c_dic_db 	varchar2(16);
  D_cod_c_con_db 	varchar2(16);
  D_cod_c_dic_cr 	varchar2(16);
  D_cod_c_con_cr 	varchar2(16);
  D_c_tipo_cong  	varchar2(16);
  D_c_rett       	varchar2(16);
--
-- Dati per Conguaglio non terminato
--
  D_c_irpef_cr      number;     
  D_c_irpef_db      number;     
  D_c_irpef_1r      number;     
  D_c_irpef_2r      number;     
  D_c_irpef_ap      number;     
  D_c_add_r_cr      number;     
  D_c_add_r_db      number;     
  D_c_add_r_crc     number;     
  D_c_add_r_dbc     number;     
  D_c_add_c_cr      number;     
  D_c_add_c_db      number;     
  D_c_add_c_crc     number;     
  D_c_add_c_dbc     number;     
  D_c_data_ric      varchar2(16);
  D_mese            number;
  D_st_tipo         varchar2(16);
  D_irpef_db        number;
  D_irpef_cr        number;
  D_irpef_int       number;
  D_irpef_ris       number;
  D_irpef_1r        number;
  D_irpef_2r        number;
  D_irpef_1r_int    number;
  D_irpef_2r_int    number;
  D_irpef_ri1r      number;
  D_irpef_ri2r      number;
  D_irpef_ret_1r    number;
  D_irpef_ret_2r    number;
  D_irpef_ap        number;
  D_irpef_ap_int    number;
  D_irpef_riap      number;
  D_irpef_ret_ap    number;
  D_add_r_dbc       number;
  D_add_r_db        number;
  D_add_r_cr        number;
  D_add_r_crc       number;
  D_add_r_ris       number;
  D_add_r_risc      number;
  D_add_r_int       number;
  D_add_r_intc      number;
  D_add_c_dbc       number;
  D_add_c_db        number;
  D_add_c_cr        number;
  D_add_c_crc       number;
  D_add_c_ris       number;
  D_add_c_risc      number;
  D_add_c_int       number;
  D_add_c_intc      number;
  D_r_irpef_db      number;
  D_r_irpef_cr      number;
  D_r_irpef_1r      number;
  D_r_irpef_2r      number;
  D_r_irpef_int     number;
  D_r_irpef_1r_int  number;
  D_r_irpef_2r_int  number;
  D_r_irpef_ris     number;
  D_r_irpef_ap      number;
  D_r_data_ric      number;
  D_r_add_r_db      number;
  D_r_add_r_dbc     number;
  D_r_add_c_db      number;
  D_r_add_c_dbc     number;
  D_r_mese          number;
  D_rt_mese1        number;
  D_rt_mese2        number;
  T_irpef_ap_int    number;
  T_irpef_cr        number;     
  T_irpef_db        number;     
  T_irpef_1r        number;     
  T_irpef_2r        number;     
  T_irpef_ap        number;     
  T_add_r_cr        number;     
  T_add_r_db        number;     
  T_add_r_crc       number;     
  T_add_r_dbc       number;     
  T_add_c_cr        number;     
  T_add_c_db        number;     
  T_add_c_crc       number;     
  T_add_c_dbc       number;     

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
      select rpad(ltrim(substr(valore,1,16)),16,' ')
        into D_cod_fis_dic
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_COD_FIS'      
      ;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              D_cod_fis_dic := null;
      END;
      BEGIN
      select upper(chiave)  
        into D_r1
        from relazione_chiavi_estrazione 
       where estrazione = 'FISCALE_ANNO'
         and sequenza = 1
      ;
        IF D_r1 = 'GESTIONE' THEN 
           null;
        ELSE 
           select ltrim(nvl(ente.codice_fiscale,ente.partita_iva))
             into D_cod_fis
             from ente ente
           ;
        END IF;
      END;
      BEGIN
        D_num_ord       := 0;
        D_modulo        := 1;
        D_pagina        := 0;
        D_riga          := 0;
        FOR CUR_RPFA IN
           (select rpad(nvl( D_cod_fis
                           , ltrim(nvl( gest.codice_fiscale
                                      ,gest.partita_iva))),16)    ente_cf
                 , tbfa.ci                                        ci
                 , upper(anag.cognome)                            cognome
                 , upper(anag.nome)                               nome
                 , anag.codice_fiscale                            cod_fis
                 , substr(to_char(anag.data_nas,'ddmmyyyy'),1,8)  data_nas
                 , anag.sesso                                     sesso
                 , upper(comu_n.descrizione)                      com_nas
                 , substr( decode( sign(199-comu_n.cod_provincia)
                                 , -1, '  '
                                     , comu_n.sigla_provincia)
                         ,1,2)                                    prov_nas
                 , decode(clra.cat_fiscale,'1','A','2','A','10','A'
                                          ,'20','A','3','B','4','B'
                                          ,'15','A','25','A') cat_fisc
              from comuni                comu_n
                 , gestioni              gest
                 , anagrafici            anag
                 , rapporti_individuali  rain
                 , report_770_abis       tbfa
                 , classi_rapporto       clra
             where tbfa.anno                = D_anno
               and gest.codice (+)          = tbfa.c1
               and nvl(tbfa.c1,' ')      like D_filtro_1
               and tbfa.ci                  = rain.ci
               and anag.ni                  = rain.ni
               and rain.rapporto            = clra.codice
               and anag.al                 is null
               and comu_n.cod_comune        = anag.comune_nas
               and comu_n.cod_provincia     = anag.provincia_nas
               and exists
                  (select 'x' from denuncia_caaf
                    where anno (+) = D_anno - 1
                      and ci   (+) = tbfa.ci
                      and tipo (+) = 0
                      and (  nvl(conguaglio_1r,' ') != ' '
                          or nvl(conguaglio_2r,' ') != ' ')
                   union
                   select 'x' from movimenti_contabili
                    where anno     = tbfa.anno
                      and mese    >= 5
                      and ci       = tbfa.ci
                      and voce    in
                         (select codice from voci_economiche
                           where specifica in 
                                      ('IRPEF_DB','IRPEF_CR','IRPEF_1R'
                                      ,'IRPEF_AP','IRPEF_APC','ADD_R_DBC'
                                      ,'ADD_R_DB','ADD_R_CR','ADD_R_CRC'
                                      ,'ADD_R_RAS','ADD_R_RASC','ADD_R_RIS'
                                      ,'ADD_R_RISC','ADD_R_INT','ADD_R_INTC'
                                      ,'IRPEF_SINT','IRPEF_1INT'
                                      ,'IRPEF_AINT','IRPEF_AINC','IRPEF_2R'
                                      ,'IRPEF_2INT'
                                      ,'IRPEF_RAS','IRPEF_RIS','IRPEF_RA1R'
                                      ,'IRPEF_RI1R','IRPEF_RAAP','IRPEF_RIAP'
                                      ,'IRPEF_RAPC','IRPEF_RIAC'
                                      ,'IRP_RET_1R','IRP_RET_2R','IRP_RET_AP'
                                      ,'ADD_C_CR','ADD_C_DB','ADD_C_RAS'
                                      ,'ADD_C_INT','ADD_C_RIS','ADD_C_CRC'
                                      ,'ADD_C_DBC','ADD_C_RASC','ADD_C_INTC'
                                      ,'ADD_C_RISC')))
             order by 1,3,4
           ) LOOP

             BEGIN

             D_ente_cf       := CUR_RPFA.ente_cf;

             --
             --  Estrazione Dati 730 da CAAF           
             --
             BEGIN
             select nvl(max(deca.conguaglio_1r),' ')           esito_28
                  , nvl(max(deca.rettifica),' ')               tipo
                  , max(decode(conguaglio_2r,'F','A',' '))
     			  , max(conguaglio_2r)
                  , nvl(to_char(max(deca.nr_rate)),'0')        tot_rate
                  , max( decode( caaf.codice_fiscale
                               , rtrim(CUR_RPFA.ente_cf), ' '
                                                 , upper(caaf.cognome))
                        )                            caaf_nome
                  , max( decode( caaf.codice_fiscale
                               , rtrim(CUR_RPFA.ente_cf), ' '
                                                 , caaf.codice_fiscale)
                         )                     caaf_cod_fis
                  , max( decode( caaf.codice_fiscale
                               , rtrim(CUR_RPFA.ente_cf), '0'
                                        , substr(rtrim(caaf.numero_doc),1,5))
                        )                     caaf_nr_albo
                  , to_char(max( decode( caaf.codice_fiscale
                                       , rtrim(CUR_RPFA.ente_cf), to_date(null)
                                              , decode( deca.rettifica
                                                      , 'A', to_date(null)
                                                           , data_ricezione))
                                ),'ddmm')                    data_ric
                  , max(nvl(to_char(cod_reg_dic_db),'0'))    cod_r_dic_db 
                  , max(nvl(to_char(cod_reg_con_db),'0'))    cod_r_con_db 
                  , max(nvl(to_char(cod_reg_dic_cr),'0'))    cod_r_dic_cr
                  , max(nvl(to_char(cod_reg_con_cr),'0'))    cod_r_con_cr
                  , max(nvl(cod_com_dic_db,'0'))    cod_c_dic_db 
                  , max(nvl(cod_com_con_db,'0'))    cod_c_con_db 
                  , max(nvl(cod_com_dic_cr,'0'))    cod_c_dic_cr
                  , max(nvl(cod_com_con_cr,'0'))    cod_c_con_cr
                  , sum(irpef_cr) 
                  , sum(irpef_db)
                  , sum(irpef_1r)
                  , sum(irpef_2r)
                  , sum(irpef_acconto_ap) + sum(irpef_acconto_ap_con)
                  , sum(add_reg_dic_cr)
                  , sum(add_reg_dic_db)
                  , sum(add_reg_con_cr)
                  , sum(add_reg_con_db)
                  , sum(add_com_dic_cr)
                  , sum(add_com_dic_db)
                  , sum(add_com_con_cr)
                  , sum(add_com_con_db)
                  , decode(max(rettifica),'C','A'
                                    ,'E','B' 
                                    ,'G','C'
                                    ,' ')
                  , decode(max(rettifica)
                                    ,'B','A'
                                    ,'D','B'
                                    ,'F','C'
                                    ,'H','D'
                                    ,'L','E'
                                    ,' ')
               into D_esito_28
                  , D_tipo
                  , D_esito_2r
				  , D_esito_61
                  , D_tot_rate
                  , D_caaf_nome
                  , D_caaf_cod_fis
                  , D_caaf_nr_albo
                  , D_data_ric
                  , D_cod_r_dic_db
                  , D_cod_r_con_db
                  , D_cod_r_dic_cr
                  , D_cod_r_con_cr
                  , D_cod_c_dic_db
                  , D_cod_c_con_db
                  , D_cod_c_dic_cr
                  , D_cod_c_con_cr
                  , D_c_irpef_cr      
                  , D_c_irpef_db      
                  , D_c_irpef_1r      
                  , D_c_irpef_2r      
                  , D_c_irpef_ap      
                  , D_c_add_r_cr      
                  , D_c_add_r_db      
                  , D_c_add_r_crc     
                  , D_c_add_r_dbc     
                  , D_c_add_c_cr      
                  , D_c_add_c_db      
                  , D_c_add_c_crc     
                  , D_c_add_c_dbc     
                  , D_c_tipo_cong
                  , D_c_rett
               from anagrafici     caaf
                  , denuncia_caaf  deca
              where deca.anno      = D_anno - 1
                and rettifica     != 'M'
                and deca.ci        = CUR_RPFA.ci
                and deca.tipo      = 0
                and caaf.ni        =  
                   (select ni from rapporti_individuali
                     where ci = deca.ci_caaf)
                and caaf.al       is null
             ;
             EXCEPTION 
               WHEN NO_DATA_FOUND THEN D_esito_28      := ' ';
                                       D_tipo          := ' ';
                                       D_esito_38      := ' ';
                                       D_caaf_nome     := ' ';
                                       D_caaf_cod_fis  := ' ';
                                       D_caaf_nr_albo  := ' ';
                                       D_data_ric      := '0';
             END;
             BEGIN
             select to_char(min( decode( caaf.codice_fiscale
                                       , rtrim(CUR_RPFA.ente_cf), to_date(null)
                                              , data_ricezione)
                                ),'ddmm')                    data_prima_ric
               into D_data_prima_ric
               from anagrafici     caaf
                  , denuncia_caaf  deca
              where deca.anno      = D_anno - 1
                and rettifica      = 'M'
                and deca.ci        = CUR_RPFA.ci
                and deca.tipo      = 0
                and caaf.ni        =  
                   (select ni from rapporti_individuali
                     where ci = deca.ci_caaf)
                and caaf.al       is null
             ;
             EXCEPTION 
               WHEN NO_DATA_FOUND THEN D_data_prima_ric:= '';
             END;
             BEGIN
             select to_char(min( decode( caaf.codice_fiscale
                                       , rtrim(CUR_RPFA.ente_cf), to_date(null)
                                              , data_ricezione)
                                ),'ddmm')                    data_ric_int
               into D_data_ric_int
               from anagrafici     caaf
                  , denuncia_caaf  deca
              where deca.anno      = D_anno - 1
                and rettifica      in ('B','F')
                and deca.ci        = CUR_RPFA.ci
                and deca.tipo      = 0
                and caaf.ni        =  
                   (select ni from rapporti_individuali
                     where ci = deca.ci_caaf)
                and caaf.al       is null
             ;
             EXCEPTION 
               WHEN NO_DATA_FOUND THEN D_data_ric_int := '0';
             END;
    --       BEGIN -- Azzera il tipo se restituzione per rettifica
    --         select ' ' 
    --           into D_tipo
    --           from dual
    --          where exists 
    --               (select 'x' from movimenti_contabili
    --                 where anno     = D_anno
    --                   and mese    >= 5
    --                   and ci       = CUR_RPFA.ci
    --                   and voce    in
    --                      (select codice from voci_economiche
    --                        where specifica in   
    --                             ('IRP_RET_1R','IRP_RET_2R','IRP_RET_AP')));
    --       EXCEPTION 
    --         WHEN NO_DATA_FOUND THEN null;
    --       END;
             T_irpef_cr     := D_c_irpef_cr;
             T_irpef_db     := D_c_irpef_db;
             T_irpef_1r     := D_c_irpef_1r;
             T_irpef_2r     := D_c_irpef_2r;
             T_irpef_ap     := D_c_irpef_ap;
             T_add_r_cr     := D_c_add_r_cr;
             T_add_r_db     := D_c_add_r_db;
             T_add_r_crc    := D_c_add_r_crc;
             T_add_r_dbc    := D_c_add_r_dbc;
             T_add_c_cr     := D_c_add_c_cr;
             T_add_c_db     := D_c_add_c_db;
             T_add_c_crc    := D_c_add_c_crc;
             T_add_c_dbc    := D_c_add_c_dbc;

             select min(decode(moco.mese,5,7,6,7,moco.mese))                                    
                  , max(decode( D_tipo,'1', ' ',D_tipo))   st_tipo
                  ,  sum(decode( voec.specifica
                                  , 'IRPEF_DB', nvl(moco.imp,0)
                                  , 'IRPEF_RAS',nvl(moco.imp,0)
                                              , 0)) * -1      irpef_db
                  ,  sum(decode( voec.specifica
                                  , 'IRPEF_CR', nvl(moco.imp,0)
                                              , 0))           irpef_cr
                  ,  sum(decode( voec.specifica
                                  , 'IRPEF_SINT', nvl(moco.imp,0)
                                                , 0)) * -1    irpef_int
                  ,  sum(decode( voec.specifica
                                  , 'IRPEF_RIS' , nvl(moco.imp,0)
                                                , 0)) * -1    irpef_ris
                  ,  sum(decode( voec.specifica
                                  , 'IRPEF_1R', nvl(moco.imp,0)
                                  , 'IRPEF_RA1R', nvl(moco.imp,0)
                                              , 0)) * -1      irpef_1r
                  ,  sum(decode( voec.specifica
                                  , 'IRPEF_1INT', nvl(moco.imp,0)
                                                , 0)) * -1    irpef_1r_int
                  ,  sum(decode( voec.specifica
                                  , 'IRPEF_RI1R', nvl(moco.imp,0)
                                                , 0)) * -1    irpef_ri1r
                  ,  sum(decode( voec.specifica
                                  , 'IRP_RET_1R', nvl(moco.imp,0)
                                                , 0)) * -1    irpef_ret_1r
                  ,  sum(decode( voec.specifica
                                  , 'IRPEF_AP', nvl(moco.imp,0)
                                  , 'IRPEF_RAAP',nvl(moco.imp,0)
                                  , 'IRPEF_APC',nvl(moco.imp,0)
                                  , 'IRPEF_RAPC',nvl(moco.imp,0)
                                              , 0)) * -1      irpef_ap
                  ,  sum(decode( voec.specifica
                                  , 'IRPEF_AINT', nvl(moco.imp,0)
                                  , 'IRPEF_AINC', nvl(moco.imp,0)
                                                , 0)) * -1    irpef_ap_int
                  ,  sum(decode( voec.specifica
                                  , 'IRPEF_RIAP', nvl(moco.imp,0)
                                  , 'IRPEF_RIAC', nvl(moco.imp,0)
                                                , 0)) * -1    irpef_riap
                  ,  sum(decode( voec.specifica
                                  , 'IRP_RET_AP', nvl(moco.imp,0)
                                                , 0)) * -1    irpef_ret_ap
                  ,  sum(decode( voec.specifica
                                  , 'ADD_R_DBC',  nvl(moco.imp,0)
                                  , 'ADD_R_RASC', nvl(moco.imp,0)
                                                , 0)) * -1    add_r_dbc
                  ,  sum(decode( voec.specifica
                                  , 'ADD_R_DB',   nvl(moco.imp,0)
                                  , 'ADD_R_RAS',  nvl(moco.imp,0)
                                                , 0)) * -1    add_r_db
                  ,  sum(decode( voec.specifica
                                  , 'ADD_R_CR',   nvl(moco.imp,0)
                                                , 0))         add_r_cr
                  ,  sum(decode( voec.specifica
                                  , 'ADD_R_CRC',  nvl(moco.imp,0)
                                                , 0))         add_r_crc
                  ,  sum(decode( voec.specifica
                                  , 'ADD_R_RIS',  nvl(moco.imp,0)
                                                , 0)) * -1    add_r_ris
                  ,  sum(decode( voec.specifica
                                  , 'ADD_R_RISC', nvl(moco.imp,0)
                                                , 0)) * -1    add_r_risc
                  ,  sum(decode( voec.specifica
                                  , 'ADD_R_INT',  nvl(moco.imp,0)
                                                , 0)) * -1    add_r_int
                  ,  sum(decode( voec.specifica
                                  , 'ADD_R_INTC', nvl(moco.imp,0)
                                                , 0)) * -1    add_r_intc
                  ,  sum(decode( voec.specifica
                                  , 'ADD_C_DBC',  nvl(moco.imp,0)
                                  , 'ADD_C_RASC', nvl(moco.imp,0)
                                                , 0)) * -1    add_c_dbc
                  ,  sum(decode( voec.specifica
                                  , 'ADD_C_DB',   nvl(moco.imp,0)
                                  , 'ADD_C_RAS',  nvl(moco.imp,0)
                                                , 0)) * -1    add_c_db
                  ,  sum(decode( voec.specifica
                                  , 'ADD_C_CR',   nvl(moco.imp,0)
                                                , 0))         add_c_cr
                  ,  sum(decode( voec.specifica
                                  , 'ADD_C_CRC',  nvl(moco.imp,0)
                                                , 0))         add_c_crc
                  ,  sum(decode( voec.specifica
                                  , 'ADD_C_RIS',  nvl(moco.imp,0)
                                                , 0)) * -1    add_c_ris
                  ,  sum(decode( voec.specifica
                                  , 'ADD_C_RISC', nvl(moco.imp,0)
                                                , 0)) * -1    add_c_risc
                  ,  sum(decode( voec.specifica
                                  , 'ADD_C_INT',  nvl(moco.imp,0)
                                                , 0)) * -1    add_c_int
                  ,  sum(decode( voec.specifica
                                  , 'ADD_C_INTC', nvl(moco.imp,0)
                                                , 0)) * -1    add_c_intc
                  , decode( min(moco.mese)
                          , 7, nvl(D_data_prima_ric,D_data_ric)
                             , decode( D_tipo
                                     ,'B', D_data_ric_int
                                     ,'F', D_data_ric_int
                                         , D_data_ric) )     data_ric
               into D_mese,D_st_tipo,D_irpef_db,D_irpef_cr,
                    D_irpef_int,D_irpef_ris,D_irpef_1r,
                    D_irpef_1r_int,D_irpef_ri1r,D_irpef_ret_1r,
                    D_irpef_ap,D_irpef_ap_int,D_irpef_riap,
                    D_irpef_ret_ap,D_add_r_dbc,D_add_r_db,
                    D_add_r_cr,D_add_r_crc,D_add_r_ris,
                    D_add_r_risc,D_add_r_int,D_add_r_intc,
                    D_add_c_dbc,D_add_c_db,D_add_c_cr,
                    D_add_c_crc,D_add_c_ris,D_add_c_risc,
                    D_add_c_int,D_add_c_intc,D_c_data_ric
               from movimenti_contabili   moco
                  , voci_economiche       voec
              where moco.anno (+)      = D_anno
                and moco.mese         >= 5
                and moco.ci   (+)      = CUR_RPFA.ci
                and moco.voce          = voec.codice
                and voec.specifica in 
                                  ('IRPEF_DB','IRPEF_CR','IRPEF_1R'
                                  ,'IRPEF_AP','IRPEF_APC','ADD_R_DBC'
                                  ,'ADD_R_DB','ADD_R_CR','ADD_R_CRC'
                                  ,'ADD_R_RAS','ADD_R_RASC','ADD_R_RIS'
                                  ,'ADD_R_RISC','ADD_R_INT','ADD_R_INTC'
                                  ,'ADD_C_DBC'
                                  ,'ADD_C_DB','ADD_C_CR','ADD_C_CRC'
                                  ,'ADD_C_RAS','ADD_C_RASC','ADD_C_RIS'
                                  ,'ADD_C_RISC','ADD_C_INT','ADD_C_INTC'
                                  ,'IRPEF_SINT','IRPEF_1INT'
                                  ,'IRPEF_AINT','IRPEF_AINC'
                                  ,'IRPEF_RAS','IRPEF_RIS','IRPEF_RA1R'
                                  ,'IRPEF_RI1R','IRPEF_RAAP','IRPEF_RIAP'
                                  ,'IRPEF_RIAC','IRPEF_RAPC'
                                  ,'IRP_RET_1R','IRP_RET_AP')
              ;
              BEGIN
                select nvl(deca.irpef_db,0)                  irpef_db
                     , nvl(deca.irpef_cr,0)                  irpef_cr
                     , nvl(deca.irpef_1r,0)                  irpef_1r
                     , nvl(deca.irpef_2r,0)                  irpef_2r
                     , nvl(deca.irpef_acconto_ap,0)          irpef_ap
                     , to_char(deca.data_ricezione,'ddmm')   data_ric
                     , nvl(deca.add_reg_dic_db,0)            add_r_db
                     , nvl(deca.add_reg_con_db,0)            add_r_dbc
                     , nvl(deca.add_com_dic_db,0)            add_c_db
                     , nvl(deca.add_com_con_db,0)            add_c_dbc
					 , to_char(data_ricezione,'ddmm')
                  into D_r_irpef_db,D_r_irpef_cr,D_r_irpef_1r,
                       D_r_irpef_2r,D_r_irpef_ap,D_r_data_ric,
                       D_r_add_r_db,D_r_add_r_dbc,D_r_add_c_db,
                       D_r_add_c_dbc,D_data_ric
                  from denuncia_caaf     deca
                 where deca.anno         = D_anno - 1
                   and deca.ci           = CUR_RPFA.ci
                   and deca.rettifica    = 'M'
                   and nvl(deca.irpef_cr,0)   
                       + nvl(deca.irpef_db,0)    
                       + nvl(deca.irpef_1r,0)     
                       + nvl(deca.irpef_2r,0)      
                       + nvl(deca.add_reg_dic_db,0)         
                       + nvl(deca.add_reg_con_db,0)         
                       + nvl(deca.add_reg_dic_cr,0)         
                       + nvl(deca.add_reg_con_cr,0)         
                       + nvl(deca.add_com_dic_db,0)         
                       + nvl(deca.add_com_con_db,0)         
                       + nvl(deca.add_com_dic_cr,0)         
                       + nvl(deca.add_com_con_cr,0)         
                       + nvl(deca.irpef_acconto_ap,0) != 0
                ;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                  D_r_irpef_db := null;
                  D_r_irpef_cr := null;
                  D_r_irpef_int := null;
                  D_r_irpef_ris := null;
                  D_r_irpef_1r_int := null;
                  D_r_data_ric := null;
                  D_r_add_r_db := null;
                  D_r_add_r_dbc := null;
                  D_r_add_c_db := null;
                  D_r_add_c_dbc := null;
              END;
              BEGIN
                select max(decode(moco.mese,10,11,moco.mese))
                  into D_rt_mese1
                  from movimenti_contabili   moco
                    , voci_economiche       voec
                     where moco.anno (+)      = D_anno
                  and moco.mese         >= 7
                  and moco.ci   (+)      = CUR_RPFA.ci
                  and moco.voce          = voec.codice
                  and moco.voce          = voec.codice
                  and voec.specifica in ('IRPEF_DB','IRPEF_CR','IRPEF_AP',
                                         'ADD_R_DB','ADD_R_DBC',
                                         'ADD_C_DB','ADD_C_DBC')
                  and exists(select 'x' 
                               from denuncia_caaf deca
                              where deca.anno= D_anno -1
                                and deca.ci = CUR_RPFA.ci
                                and deca.rettifica = 'M')
                ;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                  D_rt_mese1 := null;
              END;   
              BEGIN
                select max(decode(moco.mese,10,11,moco.mese))
                  into D_rt_mese2
                  from movimenti_contabili   moco
                    , voci_economiche       voec
                     where moco.anno (+)      = D_anno
                  and moco.mese         >= 7
                  and moco.ci   (+)      = CUR_RPFA.ci
                  and moco.voce          = voec.codice
                  and moco.voce          = voec.codice
                  and voec.specifica in ('IRPEF_2R','IRPEF_2INT','IRP_RET_2R')
                  and exists(select 'x' 
                               from denuncia_caaf deca
                              where deca.anno= D_anno -1
                                and deca.ci = CUR_RPFA.ci
                                and deca.rettifica = 'M')
                ;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                  D_rt_mese2 := null;
              END;   
              BEGIN
                select min(decode(moco.mese,10,11,moco.mese))  mese
                      , (sum(decode( voec.specifica
                             , 'IRPEF_2R', (nvl(moco.imp,0))
                                         , 0))) * -1        irpef_2r
                      , (sum(decode( voec.specifica
                             , 'IRPEF_2INT', (nvl(moco.imp,0))
                                           , 0))) * -1      irpef_2r_int
                      , (sum(decode( voec.specifica
                             , 'IRP_RET_2R', (nvl(moco.imp,0))
                                           , 0))) * -1      irpef_ret_2r
                 into D_r_mese,D_irpef_2r,D_irpef_2r_int,D_irpef_ret_2r
                 from movimenti_contabili   moco
                    , voci_economiche       voec
                     where moco.anno (+)      = D_anno
                  and moco.mese         >= 10
                  and moco.ci   (+)      = CUR_RPFA.ci
                  and moco.voce          = voec.codice
                  and moco.voce          = voec.codice
                  and voec.specifica in ('IRPEF_2R','IRPEF_2INT','IRP_RET_2R')
                ;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                  D_r_mese :=null;
                  D_irpef_2r :=null;
                  D_irpef_2r_int :=null;
                  D_irpef_ret_2r :=null;
              END; 
              BEGIN
                IF nvl(D_irpef_cr,0) != 0 OR
                   nvl(D_irpef_db,0) != 0 OR
                   nvl(D_irpef_1r,0) != 0 OR
                   nvl(D_irpef_2r,0) != 0 OR
                   nvl(D_irpef_2r_int,0) != 0 OR
                   nvl(D_irpef_ret_2r,0) != 0 OR
                   nvl(D_irpef_ap,0) != 0 OR
                   nvl(D_add_r_cr,0) != 0 OR
                   nvl(D_add_r_db,0) != 0 OR
                   nvl(D_add_r_crc,0) != 0 OR
                   nvl(D_add_r_dbc,0) != 0 OR
                   nvl(D_add_c_cr,0) != 0 OR
                   nvl(D_add_c_db,0) != 0 OR
                   nvl(D_add_c_crc,0) != 0 OR
                   nvl(D_add_c_dbc,0) != 0 THEN
                  D_num_ord := D_num_ord   + 1;
                  IF D_num_ord = 3 THEN 
                    D_num_ord := 1; 
                    D_modulo  := D_modulo + 1;
                  END IF;
 
                  IF D_num_ord = 1 THEN
                  --
                  --  Inserimento Primo Record             
                  --
                    D_pagina := D_pagina    + 1;
                    D_riga    := 30;
                    D_num_ord := D_num_ord + 1;

                    insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                    values ( prenotazione
                           , 1
                           , D_pagina
                           , D_riga
                           , 'E'||
                             rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                                 , 16, ' ')||
                             lpad(to_char(D_modulo),8,'0')||
                             lpad(' ',3,' ')||
                             lpad(' ',25,' ')||
                             lpad('0',8,'0')||
                             lpad(' ',12,' ')||
                             lpad(' ',16,' ')||
                             'SD001001'||
                             rpad(decode(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                                        ,CUR_RPFA.ente_cf,' '
                                                         ,nvl(CUR_RPFA.ente_cf,' '))
                                 ,16,' ')||
                             '}'
                           )
                    ;
                  END IF;

                  --
                  --  Inserimento Primo Record Dipendente 
                  --

                  D_pagina := D_pagina + 1;
                  D_riga   := 0;
                  D_riga   := D_riga   + 1;
-- riga = 1
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , 0
                         , lpad(to_char(CUR_RPFA.ci),8,'0')||
                           lpad(to_char(D_num_ord),2,'0')||
                           nvl(D_tipo,' ')
                         )
                  ;

                  D_riga   := D_riga   + 1;
-- riga = 2
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'E'||
                           rpad(nvl(D_cod_fis_dic,CUR_RPFA.ente_cf)
                               , 16, ' ')||
                           lpad(to_char(D_modulo),8,'0')||
                           lpad(' ',3,' ')||
                           lpad(' ',25,' ')||
                           lpad('0',8,'0')||
                           lpad(' ',12,' ')||
                           lpad(' ',16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'001'||
                           rpad(CUR_RPFA.cod_fis,16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'002'||
                           rpad(substr(CUR_RPFA.cognome,1,16),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'002'||
                           decode( greatest(16,length(CUR_RPFA.cognome))
                                 , 16, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.cognome,17,15)
                                                ,15,' ')
                                 )||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'002'||
                           decode( greatest(31,length(CUR_RPFA.cognome))
                                 , 31, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.cognome,32)
                                                ,'15',' ')
                                 )||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'003'||
                           rpad(substr(CUR_RPFA.nome,1,16),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'003'||
                           decode( greatest(16,length(CUR_RPFA.nome))
                                 , 16, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.nome,17,15)
                                                ,15,' ')
                                 )||
                           '{'
                         )
                  ;
                  --
                  --  Inserimento Secondo Record Dipendente 
                  --
-- riga = 3
                  D_riga   := D_riga   + 1;
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SD'||lpad(to_char(D_num_ord),3,'0')||'003'||
                           decode( greatest(31,length(CUR_RPFA.nome))
                                 , 31, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.nome,32)
                                                ,'15',' ')
                                 )||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'004'||
                           rpad(CUR_RPFA.sesso,16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'005'||
                           lpad(CUR_RPFA.data_nas,16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'006'||
                           rpad(substr(CUR_RPFA.com_nas,1,16),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'006'||
                           decode( greatest(16,length(CUR_RPFA.com_nas))
                                 , 16, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.com_nas,17,15)
                                                ,15,' ')
                                 )||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'006'||
                           decode( greatest(31,length(CUR_RPFA.com_nas))
                                 , 31, rpad(' ',16,' ')
                                     , '+'||rpad(substr(CUR_RPFA.com_nas,32)
                                                ,'15',' '))||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'007'||
                           rpad(CUR_RPFA.prov_nas,16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'008'||
                           rpad(CUR_RPFA.cat_fisc,16,' ')||
                           '{'
                         )
                  ;
                  --
                  --  Inserimento Terzo Record Dipendente 
                  --
                  D_riga   := D_riga   + 1;
-- riga = 4
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SD'||lpad(to_char(D_num_ord),3,'0')||'009'||
                           decode( D_dep_mese
			                	 , 5, lpad(to_char(D_mese + 1),16,' ')
								    , lpad(to_char(nvl(D_mese,0)),16,' ')
								 )||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'010'||
                           lpad(to_char(nvl(D_irpef_cr,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'011'||
                           lpad(to_char(nvl(D_irpef_db,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'012'||
                           lpad(to_char(nvl(D_irpef_int,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'013'||
                           lpad(to_char(nvl(D_irpef_ris,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'014'||
                           lpad(to_char(nvl(D_irpef_1r,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'015'||
                           lpad(to_char(nvl(D_irpef_1r_int,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'016'||
                           lpad(to_char(nvl(D_irpef_ri1r,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'017'||
                           lpad(to_char(nvl(D_irpef_ret_1r,0)),16,' ')||
                           '{'
                         )
                  ;

                  --
                  --  Inserimento Quarto Quinto Sesto e Settimo Records dip.   
                  --

                  D_riga := D_riga + 1;

-- riga = 5
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SD'||lpad(to_char(D_num_ord),3,'0')||'018'||
                           lpad(to_char(nvl(D_add_r_cr,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'019'||
                           lpad(to_char(nvl(D_add_r_db,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'020'||
                           lpad(to_char(nvl(D_add_r_int,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'021'||
                           lpad(to_char(nvl(D_add_r_ris,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'022'||
                           lpad(
                             decode( nvl(D_add_r_db,0)
                                   , 0 , decode( nvl(D_add_r_cr,0)
                                              , 0, ' '
                                                 , nvl(D_cod_r_dic_cr,'0')
                                              )
                                       , nvl(D_cod_r_dic_db,'0')
                                   ),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'023'||
                           lpad(to_char(nvl(D_add_r_crc,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'024'||
                           lpad(to_char(nvl(D_add_r_dbc,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'025'||
                           lpad(to_char(nvl(D_add_r_intc,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'026'||
                           lpad(to_char(nvl(D_add_r_risc,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'027'||
                           lpad(
                             decode( nvl(D_add_r_dbc,0)
                                   , 0, decode( nvl(D_add_r_crc,0)
                                              ,0, ' '
                                                , nvl(D_cod_r_con_cr,'0')
                                              )
                                      , nvl(D_cod_r_con_db,'0')
                               ),16,' ')||
                           '{'
                         )
                  ;
                  D_riga := D_riga + 1;

-- riga = 6
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SD'||lpad(to_char(D_num_ord),3,'0')||'028'||
                           lpad(to_char(nvl(D_add_c_cr,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'029'||
                           lpad(to_char(nvl(D_add_c_db,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'030'||
                           lpad(to_char(nvl(D_add_c_int,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'031'||
                           lpad(to_char(nvl(D_add_c_ris,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'032'||
                           lpad(
                             decode( nvl(D_add_c_db,0)
                                   , 0 , decode( nvl(D_add_c_cr,0)
                                              , 0, ' '
                                                 , nvl(D_cod_c_dic_cr,'0')
                                              )
                                       , nvl(D_cod_c_dic_db,'0')
                                   ),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'033'||
                           lpad(to_char(nvl(D_add_c_crc,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'034'||
                           lpad(to_char(nvl(D_add_c_dbc,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'035'||
                           lpad(to_char(nvl(D_add_c_intc,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'036'||
                           lpad(to_char(nvl(D_add_c_risc,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'037'||
                           lpad(
                             decode( nvl(D_add_c_dbc,0)
                                   , 0, decode( nvl(D_add_c_crc,0)
                                              ,0, ' '
                                                , nvl(D_cod_c_con_cr,'0')
                                              )
                                      , nvl(D_cod_c_con_db,'0')
                               ),16,' ')||
                           '{'
                         )
                  ;

                  D_riga := D_riga + 1;

-- riga = 7
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SD'||lpad(to_char(D_num_ord),3,'0')||'038'||
                           lpad(to_char(nvl(D_irpef_ap,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'039'||
                           lpad(to_char(nvl(D_irpef_ap_int,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'040'||
                           lpad(to_char(nvl(D_irpef_riap,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'041'||
                           lpad(to_char(nvl(D_irpef_ret_ap,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'042'||
                           rpad(nvl(D_c_tipo_cong,' '),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'043'||
                           rpad(nvl(D_c_rett,' '),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'044'||
                           rpad(decode(D_st_tipo,'A','X',' '),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'045'||
                           lpad('0',16,' ')||
                           '{'
                         )
                  ;
                  
                  D_riga := D_riga + 1;

-- riga = 8
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SD'||lpad(to_char(D_num_ord),3,'0')||'046'||
                           lpad(nvl(to_char(D_r_mese),' '),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'047'||
                           lpad(to_char(nvl(D_irpef_2r,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'048'||
                           lpad(to_char(nvl(D_irpef_2r_int,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'049'||
                           lpad(to_char(nvl(D_irpef_ret_2r,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'050'||
                           lpad(nvl(D_esito_2r,' '),16,' ')||
                           '{'
                         )
                  ;

                  D_riga := D_riga + 1;

-- riga = 9
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , D_riga
                         , 'SD'||lpad(to_char(D_num_ord),3,'0')||'051'||
                           lpad(nvl(to_char(D_rt_mese1),' '),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'052'||
                           lpad(to_char(nvl(D_r_irpef_db,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'053'||
                           lpad(to_char(nvl(D_r_irpef_1r,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'054'||
                           lpad(to_char(nvl(D_r_add_r_db,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'055'||
                           lpad(to_char(nvl(D_r_add_r_dbc,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'056'||
                           lpad(to_char(nvl(D_r_add_c_db,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'057'||
                           lpad(to_char(nvl(D_r_add_c_dbc,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'058'||
                           lpad(to_char(nvl(D_r_irpef_ap,0)),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'059'||
                           lpad(nvl(to_char(D_rt_mese2),' '),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'060'||
                           lpad(to_char(nvl(D_r_irpef_2r,0)),16,' ')||
                           '{'
                         )
                  ;
                  T_irpef_cr  := T_irpef_cr  - D_irpef_cr;
                  T_irpef_db  := T_irpef_db  - D_irpef_db;
                  T_irpef_1r  := T_irpef_1r  - D_irpef_1r;
                  T_irpef_2r  := T_irpef_2r  - D_irpef_2r;
                  T_irpef_ap  := T_irpef_ap  - D_irpef_ap;
                  T_add_r_cr  := T_add_r_cr  - D_add_r_cr;
                  T_add_r_db  := T_add_r_db  - D_add_r_db;
                  T_add_r_crc := T_add_r_crc - D_add_r_crc;
                  T_add_r_dbc := T_add_r_dbc - D_add_r_dbc;
                  T_add_c_cr  := T_add_c_cr  - D_add_c_cr;
                  T_add_c_db  := T_add_c_db  - D_add_c_db;
                  T_add_c_crc := T_add_c_crc - D_add_c_crc;
                  T_add_c_dbc := T_add_c_dbc - D_add_c_dbc;

                  BEGIN
                    select ' ' 
                      into D_non_terminato
                      from denuncia_caaf
                     where anno = D_anno - 1
                       and ci   = CUR_RPFA.ci
                       and rettifica = 'A'
                    ;
                  EXCEPTION WHEN NO_DATA_FOUND THEN 
                    BEGIN
                      select 'x' 
                        into D_non_terminato 
                        from dual
                       where nvl(T_irpef_cr,0) != 0
                          or nvl(T_irpef_db,0) != 0
                          or nvl(T_irpef_1r,0) != 0
                          or nvl(T_irpef_2r,0) != 0
                          or nvl(T_irpef_ap,0) != 0
                          or nvl(T_add_r_cr,0) != 0
                          or nvl(T_add_r_db,0) != 0
                          or nvl(T_add_c_cr,0) != 0
                          or nvl(T_add_c_db,0) != 0
                          or nvl(T_add_r_crc,0) != 0
                          or nvl(T_add_r_dbc,0) != 0
                          or nvl(T_add_c_crc,0) != 0
                          or nvl(T_add_c_dbc,0) != 0
                      ;
                    EXCEPTION 
                      WHEN NO_DATA_FOUND THEN
                        D_non_terminato := null;
                    END;
                  END;
                  IF nvl(D_non_terminato,' ') = 'x' THEN
                    BEGIN
                      D_riga := D_riga + 1;
-- riga = 10
                      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                      values ( prenotazione
                             , 1
                             , D_pagina
                             , D_riga
                             , 'SD'||lpad(to_char(D_num_ord),3,'0')||'061'||
                               rpad(nvl(D_esito_28,nvl(D_esito_61,' ')),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'062'||
                               lpad(to_char(nvl(T_irpef_cr,0)),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'063'||
                               lpad(to_char(nvl(T_irpef_db,0)),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'064'||
                               lpad(to_char(decode(sign(nvl(T_irpef_1r,0)),-1,
                                             nvl(T_irpef_1r,0),0)),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'065'||
                               lpad(to_char(decode(sign(nvl(T_irpef_1r,0)),-1
                                             ,0,nvl(T_irpef_1r,0))),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'066'||
                               lpad(to_char(nvl(T_add_r_cr,0)),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'067'||
                               lpad(to_char(nvl(T_add_r_db,0)),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'068'||
                               lpad(to_char(nvl(T_add_r_crc,0)),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'069'||
                               lpad(to_char(nvl(T_add_r_dbc,0)),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'070'||
                               lpad(to_char(nvl(T_add_c_cr,0)),16,' ')||
                               '{'
                             )
                      ;

                      D_riga := D_riga + 1;

-- riga = 11
                      insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                      values ( prenotazione
                             , 1
                             , D_pagina
                             , D_riga
                             , 'SD'||lpad(to_char(D_num_ord),3,'0')||'071'||
                               lpad(to_char(nvl(T_add_c_db,0)),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'072'||
                               lpad(to_char(nvl(T_add_c_crc,0)),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'073'||
                               lpad(to_char(nvl(T_add_c_dbc,0)),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'074'||
                               lpad(to_char(nvl(T_irpef_ap,0)),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'075'||
                               lpad(to_char(nvl(T_irpef_ap_int,0)),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'076'||
                               lpad(to_char(decode(sign(nvl(T_irpef_2r,0)),-1,
                                             nvl(T_irpef_2r,0),0)),16,' ')||
                               'SD'||lpad(to_char(D_num_ord),3,'0')||'077'||
                               lpad(0,16,' ')||
                               '{'
                             )
                      ;
                    END;
                  END IF;
-- riga = 12
                  insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
                  values ( prenotazione
                         , 1
                         , D_pagina
                         , 12
                         , 'SD'||lpad(to_char(D_num_ord),3,'0')||'078'||
                           rpad(nvl(D_caaf_cod_fis,' '),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'079'||
                           lpad(nvl(D_caaf_nr_albo,'0'),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'080'||
                           lpad(nvl(D_data_ric,'0'),16,' ')||
                           'SD'||lpad(to_char(D_num_ord),3,'0')||'081'||
                           lpad(nvl(D_data_ric_int,'0'),16,' ')||
                           '}'
                         )
                  ; 
                END IF;
              END;
            END;
          END LOOP;
      END;
COMMIT;
END;
end;end;
/
