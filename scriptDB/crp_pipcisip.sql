CREATE OR REPLACE PACKAGE pipcisip IS
/******************************************************************************
 NOME:          PIPCISIP
 DESCRIZIONE:   Creazione Nuove Versioni di Ipotesi di Spesa con riferimento
                alla situazione reale di incentivazione.
                Questa fase  genera nuove versioni  di ipotesi  di spesa, se non gia`
                presenti, esaminando i periodi di servizio effettivo  per la incenti-
                vazione  e calcola, secondo  quanto  definito  nei  tetti retributivi,
                l'importo relativo  ad ogni singolo individuo.  A fine calcolo vengono
                riportate  in equipe ipotesi di spesa le equipe relative ad ipotesi di
                spesa generate  non previste in precedenza. La elaborazione viene ese-
                guita alla data di riferimento indicata; se questa non e` specificata,
                si fa riferimento a quella definita nei parametri in fase RIIP.
                Se la versione indicata nei parametri di input e` gia` stata utilizza-
                ta, non viene eseguita la elaborazione e si termina la fase.
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:   

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    21/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;

PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY pipcisip IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 21/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
	declare   d_versione          varchar2(4);
          d_data_rif              date;
          d_errore            varchar2(6);
          errore                  exception;
BEGIN
 BEGIN
/*
  +------------------------------------------------------------------+
  |                                                                  |
  |  Ricezione della data di riferimento dalla tavola dei parametri. |
  |  Se data assente o nulla, si fa riferimento  alla data  di rife- |
  |  rimento incentivazione.                                         |
  |                                                                  |
  +------------------------------------------------------------------+
*/
  BEGIN
    select  para.valore
      into  d_data_rif
      from  a_parametri para
     where  para.no_prenotazione = prenotazione
       and  para.parametro       = 'P_DATA_RIF'
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      d_data_rif       := null;
  END;
  IF  d_data_rif       is null THEN
      BEGIN
        select  riip.fin_mes
          into  d_data_rif
          from  riferimento_incentivo riip
         where  riip.riip_id = 'RIIP'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          d_errore := 'P06000';
          RAISE errore;
      END;
   END IF;
/*
   +------------------------------------------------------------------------+
   |                                                                        |
   |  Ricezione parametri della Versione per l' Ipotesi di Spesa. Se nulla  |
   |  o gia` utilizzata, non si esegue la elaborazione.                     |
   |                                                                        |
   +------------------------------------------------------------------------+
*/
  BEGIN
     select  para.valore
       into  d_versione
       from  a_parametri para
      where  para.no_prenotazione = prenotazione
        and  para.parametro       = 'P_VERSIONE'
     ;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
       d_versione  := null;
  END;
  BEGIN
    select 'x'
      into d_errore
      from versioni_ipotesi_incentivo veip
     where veip.codice       = d_versione
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      d_errore := 'P06900';
      RAISE errore;
  END;
  BEGIN
    select 'x'
      into d_errore
      from dual
     where exists (select 'x'
                     from ipotesi_spesa_incentivo isip
                    where isip.versione = d_versione
                  )
    ;
    d_errore := 'P06901';
    RAISE errore;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
  END;
 EXCEPTION
   WHEN TOO_MANY_ROWS THEN
     d_errore := 'A00003';
     RAISE errore;
 END;
 BEGIN
/*
  +------------------------------------------------------------------+
  |                                                                  |
  |                   I N S E R I M E N T O                          |
  |                                                                  |
  +------------------------------------------------------------------+
*/
   insert  into  ipotesi_spesa_incentivo
         ( versione
         , ci
         , note
         , gruppo
         , settore
         , sede
         , equipe
         , progetto
         , ruolo
         , qualifica
         , tipo_rapporto
         , dal
         , al
         , tetto
         , ore
         , importo
         )
   select  d_versione
          ,psip.ci
          ,null
          ,psip.gruppo
          ,psip.settore
          ,nvl(psip.sede,0)
          ,psip.equipe
          ,psip.progetto
          ,psip.ruolo
          ,psip.qualifica
          ,psip.tipo_rapporto
          ,to_date('01'||to_char(
           decode(sign(d_data_rif - veip.dal)
                 ,-1,veip.dal
                    ,decode(sign(d_data_rif - veip.al)
                           ,1,veip.dal
                             ,greatest(apip.dal,veip.dal)
                           )
                 ),'mmyyyy'),'ddmmyyyy')
          ,last_day(
           decode(sign(d_data_rif - veip.al)
                 ,1,veip.al
                   ,decode(sign(d_data_rif - veip.dal)
                          ,-1,veip.al
                             ,least(nvl(apip.al,to_date('3333333','j')),veip.al)
                          )
                 ))
          ,trip.tetto
          ,nvl(psip.ore_ind,psip.ore)
          ,nvl(psip.imp_ind,psip.importo)
     from  periodi_servizio_incentivo        psip
          ,tetti_retributivi_incentivo       trip
          ,versioni_ipotesi_incentivo        veip
          ,applicazioni_incentivo            apip
    where  d_data_rif            between psip.dal
                                     and nvl(psip.al,to_date('3333333','j'))
      and  d_data_rif            between apip.dal
                                     and nvl(apip.al,to_date('3333333','j'))
      and  d_data_rif            between trip.dal
                                     and nvl(trip.al,to_date('3333333','j'))
      and  veip.codice                 = d_versione
      and  trip.rilevanza              = psip.rilevanza
      and  psip.progetto               = apip.progetto
      and  trip.ci                     = psip.ci
   ;
/*
  +------------------------------------------------------------------+
  |                                                                  |
  |     I N S E R I M E N T O   E Q U I P E   M A N C A N T I        |
  |                                                                  |
  +------------------------------------------------------------------+
*/
   insert  into  equipe_ipotesi_incentivo
         ( codice
         , descrizione
         , descrizione_al1
         , descrizione_al2
         )
   select  eqst.equipe
          ,eqst.descrizione
          ,eqst.descrizione_al1
          ,eqst.descrizione_al2
     from  equipe_storiche   eqst
    where  not exists
          (select 'x'
             from equipe_ipotesi_incentivo eiip
            where eiip.codice   = eqst.equipe
          )
      and  exists
          (select 'x'
             from ipotesi_spesa_incentivo  isip
            where isip.equipe   = eqst.equipe
          )
   ;
/*
  +------------------------------------------------------------------+
  |                                                                  |
  |      A G G I O R N A M E N T O   D A T A   V E R S I O N E       |
  |                                                                  |
  +------------------------------------------------------------------+
*/
   update  versioni_ipotesi_incentivo  veip
      set  veip.data_estr   = d_data_rif
    where  veip.codice      = d_versione
   ;
   commit;
 END;
EXCEPTION
  WHEN errore THEN
    ROLLBACK;
    update a_prenotazioni set errore         = d_errore
                             ,prossimo_passo = 99
     where no_prenotazione = prenotazione
    ;
END;
commit;
end;
end;
/

