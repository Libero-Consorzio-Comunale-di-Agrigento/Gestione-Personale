CREATE OR REPLACE PACKAGE pipceiip IS
/******************************************************************************
 NOME:          PIPCEIIP
 DESCRIZIONE:   Duplicazione Equipe Incentivo in Equipe Ipotesi Incentivo.
                Questa fase si occupa, secondo le opzioni indicate, di :
                1)- Inserire le Equipe non presenti
                2)- Aggiornare le Equipe gia` presenti
                3)- Eliminare le Equipe non piu` valide e senza Ipotesi di
                    spesa.

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

CREATE OR REPLACE PACKAGE BODY pipceiip IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 21/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
declare   d_opzione_1             VARCHAR2(1);
          d_opzione_2             VARCHAR2(1);
          d_opzione_3             VARCHAR2(1);
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
   |  Ricezione parametri di elaborazione dalla relativa tabella. Se assen- |
   |  ti, vengono posti nulli che significa no elaborazione (X = Si`).      |
   |  Il parametro da P_SEL_1 si riferisce agli inserimenti,                |
   |  il parametro da P_SEL_2 si riferisce agli aggiornamenti,              |
   |  il parametro da P_SEL_3 si riferisce alle eliminazioni.               |
   |                                                                        |
   +------------------------------------------------------------------------+
*/
  BEGIN
     select  para.valore
       into  d_opzione_1
       from  a_parametri para
      where  para.no_prenotazione = prenotazione
        and  para.parametro       = 'P_SEL_1'
     ;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
       d_opzione_1 := null;
  END;
  BEGIN
     select  para.valore
       into  d_opzione_2
       from  a_parametri para
      where  para.no_prenotazione = prenotazione
        and  para.parametro       = 'P_SEL_2'
     ;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
       d_opzione_2 := null;
  END;
  BEGIN
     select  para.valore
       into  d_opzione_3
       from  a_parametri para
      where  para.no_prenotazione = prenotazione
        and  para.parametro       = 'P_SEL_3'
     ;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
       d_opzione_3 := null;
  END;
 EXCEPTION
   WHEN TOO_MANY_ROWS THEN
     d_errore := 'A00003';
     RAISE errore;
 END;
 BEGIN
  BEGIN
/*
  +------------------------------------------------------------------+
  |                                                                  |
  |                   I N S E R I M E N T O                          |
  |                                                                  |
  +------------------------------------------------------------------+
*/
     IF d_opzione_1 = 'X' THEN
     insert into equipe_ipotesi_incentivo
           (codice,descrizione,descrizione_al1,descrizione_al2)
     select eqst.equipe
           ,eqst.descrizione
           ,eqst.descrizione_al1
           ,eqst.descrizione_al2
       from equipe_storiche eqst
      where not exists
           (select 'x'
              from equipe_ipotesi_incentivo eiip
             where eiip.codice = eqst.equipe
           )
        and d_data_rif between eqst.dal
                           and nvl(eqst.al,to_date('3333333','j'))
     ;
     END IF;
/*
  +------------------------------------------------------------------+
  |                                                                  |
  |                   A G G I O R N A M E N T O                      |
  |                                                                  |
  +------------------------------------------------------------------+
*/
     IF d_opzione_2 = 'X' THEN
     update equipe_ipotesi_incentivo eiip
        set (eiip.descrizione,eiip.descrizione_al1,eiip.descrizione_al2)
            = (
     select eqst.descrizione,eqst.descrizione_al1,eqst.descrizione_al2
       from equipe_storiche eqst
      where eqst.equipe        = eiip.codice
        and d_data_rif   between eqst.dal
                             and nvl(eqst.al,to_date('3333333','j'))
              )
     ;
     END IF;
/*
  +------------------------------------------------------------------+
  |                                                                  |
  |                   E L I M I N A Z I O N E                        |
  |                                                                  |
  +------------------------------------------------------------------+
*/
     IF d_opzione_3 = 'X' THEN
     delete from equipe_ipotesi_incentivo eiip
      where not exists
           (select 'x'
              from ipotesi_spesa_incentivo isip
             where isip.equipe      = eiip.codice
           )
        and not exists
           (select 'x'
              from equipe_storiche  eqst
             where eqst.equipe      = eiip.codice
               and d_data_rif between eqst.dal
                                  and nvl(eqst.al,to_date('3333333','j'))
           )
     ;
     END IF;
     commit;
  END;
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

