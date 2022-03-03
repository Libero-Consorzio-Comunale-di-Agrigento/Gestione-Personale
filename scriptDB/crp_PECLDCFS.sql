CREATE OR REPLACE PACKAGE PECLDCFS IS

/******************************************************************************
 NOME:          crp_pecldcfs LISTA PER ATTRIBUZIONE DETRAZIONI CONIUGE A SCAGLIONI
 
 DESCRIZIONE:   
      Questa funzione emette un elenco dei dip. con coniuge a carico o
      in assenza del coniuge evidenziando la fasciaa di detrazione a cui
      il dip. appartiene ai fini delle detrazioni per coniuge a scaglioni

 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   
      Emette un'elenco dei dip. con l'indicazione della fasci di detrazione

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;

 PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY PECLDCFS IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 20/01/2003';
   END VERSIONE;

 PROCEDURE MAIN (prenotazione in number, passo in number) IS
 BEGIN 
 
DECLARE 

--
-- Parametri
--
  D_sc1 number;
  D_sc2 number;
  D_sc3 number;
  D_nc1 number;
  D_nc2 number;
  D_nc3 number;
  D_nc4 number;
  D_ac1 number;
  D_ac2 number;
  D_ac3 number;
  D_ac4 number;
  D_ac5 number;
  D_ac6 number;
  D_agg_auto   varchar2(1);
--
-- Periodo di elaborazione
--
  D_anno       number;
  D_mese       number;
  P_pagina     number;
  P_riga       number;
--
-- Variabili individuali
--
  P_ipn_ord        number;
  P_tipo_coniuge   number;
  P_tipo_figli     number;
  P_tipo_figli_ac  number;
  P_segno          varchar2(1);
BEGIN

   P_pagina := 0;
   P_riga   := 0;

   BEGIN                          -- Preleva Anno e Mese di Elaborazione
      select anno 
           , mese
        into D_anno
           , D_mese
        from riferimento_retribuzione
       where rire_id = 'RIRE'
      ;
   END;
   BEGIN                          
      select max(decode(parametro,'P_SC1',to_number(substr(valore_default,1,9)),null))
           , max(decode(parametro,'P_SC2',to_number(substr(valore_default,1,9)),null))
           , max(decode(parametro,'P_SC3',to_number(substr(valore_default,1,9)),null))
           , max(decode(parametro,'P_NC1',to_number(substr(valore_default,1,9)),null))
           , max(decode(parametro,'P_NC2',to_number(substr(valore_default,1,9)),null))
           , max(decode(parametro,'P_NC3',to_number(substr(valore_default,1,9)),null))
           , max(decode(parametro,'P_NC4',to_number(substr(valore_default,1,9)),null))
           , max(decode(parametro,'P_AC1',to_number(substr(valore_default,1,9)),null))
           , max(decode(parametro,'P_AC2',to_number(substr(valore_default,1,9)),null))
           , max(decode(parametro,'P_AC3',to_number(substr(valore_default,1,9)),null))
           , max(decode(parametro,'P_AC4',to_number(substr(valore_default,1,9)),null))
           , max(decode(parametro,'P_AC5',to_number(substr(valore_default,1,9)),null))
           , max(decode(parametro,'P_AC6',to_number(substr(valore_default,1,9)),null))
        into D_sc1,D_sc2,D_sc3
           , D_nc1,D_nc2,D_nc3,D_nc4
           , D_ac1,D_ac2,D_ac3,D_ac4
           , D_ac5,D_ac6
        from a_selezioni
       where voce_menu = 'PECLDCFS'
         and parametro  in ('P_SC1','P_SC2','P_SC3',
                            'P_NC1','P_NC2','P_NC3','P_NC4',
                            'P_AC1','P_AC2','P_AC3','P_AC4',
                            'P_AC5','P_AC6')
      ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       D_sc1 :=null;
       D_sc2 :=null;
       D_sc3 :=null;
       D_nc1 :=null;
       D_nc2 :=null;
       D_nc3 :=null;
       D_nc4 :=null;
       D_ac1 :=null;
       D_ac2 :=null;
       D_ac3 :=null;
       D_ac4 :=null;
       D_ac5 :=null;
       D_ac6 :=null;
   END;
      BEGIN                          -- Preleva il falg per l'agg. di AUTO
      select substr(valore,1,1)
        into D_agg_auto
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_AGG_AUTO'
      ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
          select ' '
            into D_agg_auto
            from dual
          ;
   END;
   FOR CUR_RAIN IN
      (select rain.cognome
            , rain.nome
            , rain.ci
         from rapporti_individuali rain
        where ci in (select ci
                       from carichi_familiari
                      where anno = D_anno
                        and (   nvl(scaglione_coniuge,0) != 0
                             or nvl(scaglione_figli,0) != 0 
                            )
                    )
        order by rain.cognome
               , rain.nome
               , rain.ci
      ) LOOP
        P_ipn_ord  := 0;
        BEGIN
          select nvl(sum(prfi.ipn_ord + prfi.ipn_sep),0)
            into P_ipn_ord
            from progressivi_fiscali prfi
           where prfi.ci        = CUR_RAIN.ci
             and prfi.anno      = D_anno
             and prfi.mese      = 12
             and prfi.mensilita = (select max(mensilita) 
                                     from mensilita
                                    where mese = 12
                                      and tipo in ('N','S','A'))
          ;
        END;      
        IF P_ipn_ord < D_sc1 THEN
           P_tipo_coniuge := 1;
        ELSIF P_ipn_ord < D_sc2 THEN
           P_tipo_coniuge := 2;
        ELSIF P_ipn_ord < D_sc3 THEN
           P_tipo_coniuge := 3;
        ELSE
           P_tipo_coniuge := 4;
        END IF;
        IF P_ipn_ord < D_nc1 THEN
           P_tipo_figli := 1;
        ELSIF P_ipn_ord < D_nc2 THEN
           P_tipo_figli := 2;
        ELSIF P_ipn_ord < D_nc3 THEN
           P_tipo_figli := 3;
        ELSIF P_ipn_ord < D_nc4 THEN
           P_tipo_figli := 4;
        ELSE
           P_tipo_figli := 5;
        END IF;
        IF P_ipn_ord < D_ac1 THEN
           P_tipo_figli_ac := 1;
        ELSIF P_ipn_ord < D_ac2 THEN
           P_tipo_figli_ac := 2;
        ELSIF P_ipn_ord < D_ac3 THEN
           P_tipo_figli_ac := 3;
        ELSIF P_ipn_ord < D_ac4 THEN
           P_tipo_figli_ac := 4;
        ELSIF P_ipn_ord < D_ac5 THEN
           P_tipo_figli_ac := 5;
        ELSIF P_ipn_ord < D_ac6 THEN
           P_tipo_figli_ac := 6;
        ELSE
           P_tipo_figli_ac := 7;
        END IF;
        FOR CUR_CAFA IN
          (select cafa.sequenza
                , cafa.cond_fis cond_fis
                , decode( cafa.cond_fis
      	             ,'CC', P_tipo_coniuge 	
               	    	      , null
                         ) scaglione_coniuge
                 , decode(cafa.cond_fis
  			       ,'AC', P_tipo_figli_ac
		        	 ,'NC', P_tipo_figli
           			 ,'CC', decode(figli + figli_dd + altri
              		      ,0, null
            			  ,P_tipo_figli
 				        )
			    ) scaglione_figli
                , nvl(cafa.giorni,0) giorni_s
                , abs(nvl(cafa.giorni,0)) giorni
                , cafa.mese
                , cafa.mese_att
   	          , cafa.coniuge		coniuge
		    , cafa.figli  		figli
		    , cafa.figli_dd		figli_dd
		    , cafa.altri		      altri
		    , cafa.figli_mn		figli_mn
		    , cafa.figli_mn_dd	      figli_mn_dd
		    , cafa.figli_hh		figli_hh
		    , cafa.figli_hh_dd	      figli_hh_dd
             from carichi_familiari cafa
            where cafa.anno = D_anno
              and cafa.ci   = CUR_RAIN.ci
              and (   nvl(scaglione_coniuge,0) != 0
                      or nvl(scaglione_figli,0) != 0 
                  )
            order by cafa.mese
                   , cafa.mese_att
              ) LOOP
              P_pagina   := P_pagina + 1;
              P_riga     := P_riga  + 1;
              IF to_char(sign(cur_cafa.giorni_s)) = '1' THEN
                 P_segno := '+';
              ELSIF to_char(sign(cur_cafa.giorni_s)) = '0' THEN
                 P_segno := ' ';
              ELSE
                 P_segno := '-';
              END IF;
              insert into a_appoggio_stampe(no_prenotazione,no_passo,pagina,riga,testo)
              values ( prenotazione
                     , 1
                     , P_pagina
                     , P_riga
                     , lpad(to_char(nvl(cur_rain.ci,0)),8,'0')||
                       lpad(to_char(nvl(P_ipn_ord,0)),10,' ')||
                       lpad(to_char(nvl(cur_cafa.mese,0)),2,'0')||
                       rpad(nvl(cur_cafa.cond_fis,' '),4,' ')||
                       lpad(to_char(nvl(cur_cafa.scaglione_coniuge,0)),1,'0')||
                       lpad(to_char(nvl(cur_cafa.coniuge,0)),2,'0')||
                       lpad(to_char(nvl(cur_cafa.scaglione_figli,0)),1,'0')||
                       lpad(to_char(nvl(cur_cafa.figli,0)),2,'0')||
                       lpad(to_char(nvl(cur_cafa.figli_dd,0)),2,'0')||
                       lpad(to_char(nvl(cur_cafa.figli_mn,0)),2,'0')||
                       lpad(to_char(nvl(cur_cafa.figli_mn_dd,0)),2,'0')||
                       lpad(to_char(nvl(cur_cafa.figli_hh,0)),2,'0')||
                       lpad(to_char(nvl(cur_cafa.figli_hh_dd,0)),2,'0')||
                       lpad(to_char(nvl(cur_cafa.altri,0)),2,'0')||
                       P_segno||
                       lpad(to_char(nvl(cur_cafa.giorni,0)),2,'0')||
                       lpad(to_char(nvl(cur_cafa.mese_att,0)),2,'0')
                     )
              ;

              IF D_agg_auto = 'X' THEN
                 update carichi_familiari
                    set scaglione_coniuge  = decode(nvl(to_number(cur_cafa.scaglione_coniuge),0)
                                                    , 0, null
                                                       , to_number(cur_cafa.scaglione_coniuge)
                                                   )
  	    	          , scaglione_figli    = decode(nvl(to_number(cur_cafa.scaglione_figli),0)
                                                   , 0, null
                                                      , to_number(cur_cafa.scaglione_figli)
                                                   )
                      , mese_att           = D_mese
                where ci       = cur_rain.ci
                  and anno     = D_anno
                  and mese     = cur_cafa.mese
                  and sequenza = cur_cafa.sequenza
		      and cur_cafa.cond_fis = 'CC'
                 ;
                 update carichi_familiari
                    set scaglione_figli    = decode(nvl(to_number(cur_cafa.scaglione_figli),0)
                                                   , 0, scaglione_figli
                                                      , to_number(cur_cafa.scaglione_figli)
                                                  )
       		    , mese_att = D_mese
                  where ci       = cur_rain.ci
                    and anno     = D_anno
                    and mese     = cur_cafa.mese
                    and sequenza = cur_cafa.sequenza
	  	        and cur_cafa.cond_fis = 'NC'
                 ;
                 update carichi_familiari
                    set scaglione_figli    = decode(nvl(to_number(cur_cafa.scaglione_figli),0)
                                                       , 0, scaglione_figli
                                                          , to_number(cur_cafa.scaglione_figli)
                                                   )
      		    , mese_att = D_mese
                  where ci       = cur_rain.ci
                    and anno     = D_anno
                    and mese     = cur_cafa.mese
                    and sequenza = cur_cafa.sequenza
   	    	        and cur_cafa.cond_fis = 'AC'
                 ;
                 commit;
               END IF;
             END LOOP;
          END LOOP;
END;
END;
END;
/