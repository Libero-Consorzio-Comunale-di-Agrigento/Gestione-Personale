CREATE OR REPLACE PACKAGE pecupere IS
/******************************************************************************
 NOME:          PECUPERE
 DESCRIZIONE:   Aggiornamento giorni lavorati e giorni fiscali dei periodi retributivi
                relativi al mese di competenza in modo da liquidare solo le giornate dei
                mesi precedenti.
                Questa step viene lanciato come secondo passo dopo la fase PECCPERE.frm
                che elabora il calcolo dei periodi_retributivi. Agisce su tutti gli
                individui con flag_elab='P',cong_ind>0 e di_ruolo='NO'
                su rapporti_giuridici.
                
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  Modifica del 30/09/96 di Annalena Monari
               Aggiunto il controllo su trattamento != 'NR+1' per non eseguire la
               forzatura sui dip. non di ruolo con piu' di 1 anno di anzianita'.

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    21/01/2003   
 1.1  07/10/2005 AM-NN  Azzera anche i campi gg_per, per_gg e gg_nsu x allinearlo
                        all'analogo programma personalizzato per Piacenza.
 1.2  26/03/2007 AM     Azzeramento gg_365
 1.3   10/04/2007 CB    Aggiunto il controllo sul codice di competenza di RAIN
 1.4  15/11/2007  NN    Gestito il nuovo campo pere.gg_df  
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/
CREATE OR REPLACE PACKAGE BODY pecupere IS
  w_utente	        varchar2(10);
  w_ambiente	    varchar2(10);
  w_ente	        varchar2(10);
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.4 del 15/11/2007';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
begin
IF prenotazione != 0 THEN
      BEGIN  --Preleva utente da depositare in campi Global
         select utente
              , ambiente
              , ente
           into w_utente
              , w_ambiente
              , w_ente
           from a_prenotazioni
          where no_prenotazione = prenotazione
         ;
      EXCEPTION
         WHEN OTHERS THEN null;
      END;
END IF;
delete from periodi_retributivi
 where  ci        in (select ci from rapporti_giuridici ragi
                       where flag_elab = 'P'
                         and cong_ind > 0
                         and di_ruolo = 'NO'
                     )
   and  periodo    = (select fin_ela from riferimento_retribuzione)
   and  competenza != 'A'
   and to_char(al,'yyyymm') = to_char(periodo,'yyyymm')
   and  trattamento != 'NR+1'
   and   ci in (select rain.ci 
                     from   rapporti_individuali rain
					 where    rain.cc is null
					 or exists
					    (select 'x'
						 from   a_competenze
						 where  ente = w_ente
						 and    utente = w_utente
						 and    ambiente = w_ambiente
						 and    competenza='CI'
						 and    oggetto  = rain.cc
						 ) 
					 )
;
update periodi_retributivi pere
   set  dal = (select ini_ela from riferimento_retribuzione)
       ,al  = (select fin_ela from riferimento_retribuzione)
       ,gg_con = 0
       ,gg_pre = 0
       ,gg_inp = 0
       ,st_inp = 0
       ,gg_af  = 0
       ,gg_df  = 0
       ,gg_fis = 0
       ,gg_det = 0
       ,gg_rat = 0
       ,gg_100 = 0
       ,gg_80  = 0
       ,gg_66  = 0
       ,gg_50  = 0
       ,gg_30  = 0
       ,gg_sa  = 0
       ,gg_rid = 0
       ,gg_rap = 0
       ,rap_gg = 0
/* modifica del 07/10/2005 */
       ,gg_per = 0
       ,per_gg = 0
       ,gg_nsu = 0
       ,gg_365 = 0
/* fine modifica del 07/10/2005 */
       ,tipo   = 'F'
 where  ci        in (select ci from rapporti_giuridici ragi
                       where flag_elab = 'P'
                         and cong_ind > 0
                         and di_ruolo = 'NO'
                     )
   and  periodo    = (select fin_ela from riferimento_retribuzione)
   and  competenza = 'A'
   and to_char(al,'yyyymm') = to_char(periodo,'yyyymm')
   and  trattamento != 'NR+1'
   and   ci in (select rain.ci 
                     from   rapporti_individuali rain
					 where    rain.cc is null
					 or exists
					    (select 'x'
						 from   a_competenze
						 where  ente = w_ente
						 and    utente = w_utente
						 and    ambiente = w_ambiente
						 and    competenza='CI'
						 and    oggetto  = rain.cc
						 ) 
					 )
;
update periodi_retributivi pere
   set gg_rat = (select nvl(sum(gg_rat),0) from periodi_retributivi
                  where ci = pere.ci
                    and periodo = pere.periodo
                    and trattamento = pere.trattamento
                    and anno = decode(pere.mese,1,pere.anno-1,pere.anno)
                    and mese = decode(pere.mese,1,12,pere.mese-1)
                                        and competenza = 'C'
                )
 where  ci        in (select ci from rapporti_giuridici ragi
                       where flag_elab = 'P'
                         and cong_ind > 0
                         and di_ruolo = 'NO'
                     )
   and  periodo    = (select fin_ela from riferimento_retribuzione)
   and  competenza = 'A'
   and to_char(al,'yyyymm') = to_char(periodo,'yyyymm')
   and  trattamento != 'NR+1'
   and   ci in (select rain.ci 
                     from   rapporti_individuali rain
					 where    rain.cc is null
					 or exists
					    (select 'x'
						 from   a_competenze
						 where  ente = w_ente
						 and    utente = w_utente
						 and    ambiente = w_ambiente
						 and    competenza='CI'
						 and    oggetto  = rain.cc
						 ) 
					 )
;
update periodi_retributivi pere
   set gg_rat = 0
 where  ci        in (select ci from rapporti_giuridici ragi
                       where flag_elab = 'P'
                         and cong_ind > 0
                         and di_ruolo = 'NO'
                     )
   and  periodo    = (select fin_ela from riferimento_retribuzione)
   and  trattamento != 'NR+1'
   and (anno,mese) = (select decode(mese,1,anno-1,anno)
                           , decode(mese,1,12,mese-1)
                        from periodi_retributivi
                       where ci = pere.ci
                         and periodo = pere.periodo
                         and trattamento = pere.trattamento
                         and competenza = 'A'
                         and to_char(al,'yyyymm') = to_char(periodo,'yyyymm')
                     )
					 and   ci in (select rain.ci 
                     from   rapporti_individuali rain
					 where    rain.cc is null
					 or exists
					    (select 'x'
						 from   a_competenze
						 where  ente = w_ente
						 and    utente = w_utente
						 and    ambiente = w_ambiente
						 and    competenza='CI'
						 and    oggetto  = rain.cc
						 ) 
					 )
;
COMMIT;
end;
end;
/

