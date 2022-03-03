CREATE OR REPLACE PACKAGE PIECASTV IS
/******************************************************************************
 NOME:          PIECASTV CREAZIONE ARCHIVIO STORICO DATI REPLICA

 DESCRIZIONE:   
	Procedura che storicizza le variazione dei dati già Acquisiti

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    09/10/2003
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY PIECASTV IS

   FUNCTION VERSIONE  RETURN VARCHAR2 IS
   BEGIN
   RETURN 'V1.0 del 09/10/2003';
   END VERSIONE;

PROCEDURE MAIN(PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
  BEGIN
    DECLARE
      w_contatore                    number :=0;
      D_dummy                        VARCHAR2(1);
      D_valore                       VARCHAR2(4000);
      D_valore_precedente            VARCHAR2(4000);
      p_data                         DATE;
      p_user_destinazione            VARCHAR2(30);
      p_user_provenienza             VARCHAR2(30);
    BEGIN
      BEGIN
        select  to_date(valore,decode(nvl(length(translate(valore,'a0123456789/',
                'a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
          into p_data
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'P_DATA'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_data := null;
      END;
      BEGIN
        select valore
          into p_user_destinazione
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'P_USER_DESTINAZIONE'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_user_destinazione := '';
      END;
      BEGIN
        select valore
          into p_user_provenienza
          from a_parametri
         where no_prenotazione = prenotazione
           and parametro = 'P_USER_PROVENIENZA'
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_user_provenienza := '';
      END;
        insert into variazioni_storiche
        select id_variazione
             , progressivo
             , operazione
             , tabella
             , colonna
             , valore
             , valore_precedente
             , causale
             , modificato
             , user_provenienza
             , user_destinazione
             , data_agg
          from variazioni
         where aggiornato = 1
           and user_provenienza like nvl(p_user_provenienza,'%')
           and user_destinazione like nvl(p_user_destinazione,'%')
           and data_agg <= nvl(p_data,sysdate)
        ;
        delete variazioni 
         where aggiornato = 1
           and user_provenienza like nvl(p_user_provenienza,'%')
           and user_destinazione like nvl(p_user_destinazione,'%')
           and data_agg <= nvl(p_data,sysdate)
        ;
    END;
  END;
END;
/