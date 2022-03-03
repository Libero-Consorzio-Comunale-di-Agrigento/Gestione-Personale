CREATE OR REPLACE PACKAGE AE_PERSONALE IS
/******************************************************************************
 NOME:          ae_personale
 DESCRIZIONE:   
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  28/03/2006        Prima emissione.
******************************************************************************/
FUNCTION VERSIONE                    RETURN VARCHAR2;
FUNCTION GET_D_PESO (P_ci number)    RETURN NUMBER;

PROCEDURE GET_ROWS
( p_cognome        ae_anagrafe.t_cognome        DEFAULT NULL
, p_nome           ae_anagrafe.t_nome           DEFAULT NULL
, p_codice_fiscale ae_anagrafe.t_codice_fiscale DEFAULT NULL
, p_partita_iva    ae_anagrafe.t_partita_iva    DEFAULT NULL
);
END;
/
CREATE OR REPLACE PACKAGE BODY AE_PERSONALE IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 27/03/2006';
 END VERSIONE;

 FUNCTION GET_D_PESO (P_ci number) RETURN NUMBER IS
 D_valore NUMBER;
 BEGIN
   D_valore := null;
   BEGIN
   select max(pegi.controllo)
     into D_valore
     from ( select 0    controllo
              from dual
             where exists ( select 'x' 
                              from periodi_giuridici
                             where rilevanza = 'P'
                               and ci = P_ci
                               and al < sysdate
                          )
               and not exists ( select 'x' 
                                  from periodi_giuridici
                                 where rilevanza = 'P'
                                   and ci = P_ci
                                   and sysdate between dal and nvl(al,to_date('3333333','j'))
                              )
            union
            select 1    controllo
              from dual 
             where exists ( select 'x' 
                              from periodi_giuridici
                             where rilevanza = 'P'
                               and ci = P_ci
                               and sysdate between dal and nvl(al,to_date('3333333','j'))
                          )
           ) pegi
         ;
     EXCEPTION WHEN NO_DATA_FOUND THEN
        D_valore := null;
     END; 
    return D_valore;
END GET_D_PESO;

PROCEDURE GET_ROWS
( p_cognome        ae_anagrafe.t_cognome        DEFAULT NULL
, p_nome           ae_anagrafe.t_nome           DEFAULT NULL
, p_codice_fiscale ae_anagrafe.t_codice_fiscale DEFAULT NULL
, p_partita_iva    ae_anagrafe.t_partita_iva    DEFAULT NULL
) IS
BEGIN
DECLARE

D_peso                    number(1)    := to_number(null);

BEGIN

-- dbms_output.put_line('dati in input: '||P_cognome||' '||P_nome||' '||P_codice_fiscale);

  FOR CUR_DATI IN 
      ( select anag.cognome
             , anag.nome
             , anag.sesso
             , anag.data_nas                     data_nas
             , comu_n.descrizione                comune_nas
             , anag.codice_fiscale
             , anag.partita_iva
             , comu_r.descrizione                comune_res
             , anag.indirizzo_res
             , comu_d.descrizione                comune_dom
             , anag.indirizzo_dom
             , clra.descrizione                  des_rapporto
             , rain.ci
             , anag.tipo_soggetto                tipo_soggetto
         from rapporti_individuali   rain
            , anagrafici             anag
            , comuni                 comu_n
            , comuni                 comu_r
            , comuni                 comu_d
            , classi_rapporto        clra
        where anag.ni                  = rain.ni
          and anag.al                  is null
          and rain.rapporto            = clra.codice (+)
          and comu_n.cod_comune (+)    = anag.comune_nas
          and comu_n.cod_provincia (+) = anag.provincia_nas
          and comu_r.cod_comune (+)    = anag.comune_res
          and comu_r.cod_provincia (+) = anag.provincia_res
          and comu_d.cod_comune (+)    = anag.comune_dom
          and comu_d.cod_provincia (+) = anag.provincia_dom
          and (  anag.codice_fiscale   =  P_codice_fiscale
             or  P_codice_fiscale is null
             and anag.cognome       like P_cognome
             and anag.nome          like P_nome
              )
          and not exists ( select 'x'
                             from rapporti_diversi
                            where ci_erede = rain.ci
                              and rilevanza = 'L'
                         )         
      ) LOOP

-- dbms_output.put_line('dati in output');
-- dbms_output.put_line(CUR_DATI.cognome||' '||CUR_DATI.nome||' '||CUR_DATI.codice_fiscale||' '||CUR_DATI.DES_rapportO);

      D_peso                  := get_d_peso(CUR_DATI.ci);

      BEGIN
        ae_anagrafe.ins ( CUR_DATI.ci                       -- d_identificativo
                        , CUR_DATI.cognome
                        , CUR_DATI.nome
                        , CUR_DATI.sesso
                        , CUR_DATI.data_nas
                        , CUR_DATI.comune_nas
                        , CUR_DATI.codice_fiscale
                        , CUR_DATI.partita_iva
                        , CUR_DATI.comune_res
                        , CUR_DATI.indirizzo_res
                        , CUR_DATI.comune_dom 
                        , CUR_DATI.indirizzo_dom
                        , 'Ufficio Personale'
                        , CUR_DATI.des_rapporto
                        , D_peso 
                        );
      END;
  END LOOP; -- CUR_DATI
END;
END GET_ROWS;
END AE_PERSONALE;
/