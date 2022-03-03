CREATE OR REPLACE FUNCTION GET_DIFF_ACCREDITO_EMENS
(p_ci number, p_dal date, p_al date , p_codice varchar2 ) RETURN NUMBER IS
/******************************************************************************
 NOME:        Function GET_DIFF_ACCREDITO_EMENS
 DESCRIZIONE: La funzione permette di calcolare le differenze di accredito 
              per la denuncia emens dei privati 

 REVISIONI:
 Rev. Data        Autore  Descrizione
 ---- ----------  ------  -----------------------------------------------------
 1.0  20/03/2006  MS      Creazione Function estratta da package cursore_emens ( Att.15416 )
 1.1  31/05/2006  MS      Adeguamento per cambio normativa malattie ( Att. 16490 )
******************************************************************************/

d_valore NUMBER;
BEGIN
   d_valore := 0;
        BEGIN
         select sum ( decode(esrc.segno1,'*', vapa.tar * nvl(esrc.dato1,1)
                                            , vapa.tar ))
           into D_valore
           from EVENTI_PRESENZA           evpa
               , causali_evento            caev
               , prospetti_presenza        prpr
               , righe_prospetto_presenza  rppa
               , valori_presenza             vapa
               , classi_presenza clpa
               , estrazione_righe_contabili  esrc
            WHERE evpa.input      = 'V'
              AND evpa.ci         = P_ci
              and P_dal          <= evpa.al
              and P_al           >= evpa.dal
              and prpr.codice     = P_codice
              and evpa.causale    = caev.codice
              and caev.codice     = rppa.colonna
              and rppa.prospetto  = prpr.codice
              and evpa.ci         = clpa.ci
              and evpa.evento     = vapa.evento
              and clpa.ci         = evpa.ci
              and clpa.evento     = evpa.classe
              and prpr.note like '%EMENS%'
              and vapa.voce       = esrc.voce
              and vapa.sub        = esrc.sub
              and esrc.estrazione = 'DENUNCIA_EMENS'
              and esrc.colonna = 'MALATTIE'
              and evpa.al between esrc.dal and nvl(esrc.al, to_date('3333333','j'))
              ;
        EXCEPTION WHEN NO_DATA_FOUND THEN
           D_valore := null; 
        END;
        RETURN D_valore;
END GET_DIFF_ACCREDITO_EMENS;
/

CREATE OR REPLACE FUNCTION GET_GG_ACCREDITO_EMENS
(p_ci number, p_dal date, p_al date , p_codice varchar2 ) RETURN NUMBER IS
/******************************************************************************
 NOME:        Function GET_GG_ACCREDITO_EMENS
 DESCRIZIONE: La funzione permette di calcolare i giorni di accredito 
              per la denuncia emens dei privati 

 REVISIONI:
 Rev. Data        Autore  Descrizione
 ---- ----------  ------  -----------------------------------------------------
 1.0  20/03/2006  MS      Creazione Function estratta da package cursore_emens
 1.1  31/05/2006  MS      Adeguamento per cambio normativa malattie ( Att. 16490 )
                          Modificato conteggio gg di assenza rapp. ai gg lavorativi
******************************************************************************/
D_giorno      number;
D_gg_fine     number;
D_gg_lav      number;
D_gg_lav_tot  number;
BEGIN
   D_giorno     := 0;
   D_gg_fine    := 0;
   D_gg_lav     := 0;
   D_gg_lav_tot := 0;

        BEGIN
          select to_char(greatest(evpa.dal, P_dal),'dd')
               , to_char(least(evpa.al, P_al),'dd')
            into D_giorno
               , D_gg_fine
           from EVENTI_PRESENZA           evpa
               , causali_evento            caev
               , prospetti_presenza        prpr
               , righe_prospetto_presenza  rppa
               , classi_presenza clpa
            WHERE evpa.input      = 'V'
              AND evpa.ci         = P_ci
              and P_dal          <= evpa.al
              and P_al           >= evpa.dal
              and prpr.codice     = P_codice
              and evpa.causale    = caev.codice
              and caev.codice     = rppa.colonna
              and rppa.prospetto  = prpr.codice
              and evpa.ci         = clpa.ci
              and clpa.ci         = evpa.ci
              and clpa.evento     = evpa.classe
              and prpr.note like '%EMENS%'
              ;
        EXCEPTION 
             WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                  D_giorno := 0 ;
                  D_gg_fine := 0;
        END;

       WHILE D_giorno <= D_gg_fine LOOP

        BEGIN --Estrazione del giorno da Calendario
          select decode( substr(giorni,D_giorno,1)
                       , 'F', 0
                       , 'D', 0
                       , 'd', 0
                       , 'S', 0
                            , 1
                       ) 
            into D_gg_lav
            from calendari
           where calendario = '*'
             and anno = to_char(P_al,'yyyy')
             and mese = to_char(P_al,'mm')
           ;
        EXCEPTION 
             WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                  D_gg_lav := 0 ;
        END;
      
        D_giorno := nvl(D_giorno,0) + 1 ;
        D_gg_lav_tot := nvl(D_gg_lav_tot,0) + D_gg_lav;

       END LOOP;
   RETURN D_gg_lav_tot;
END GET_GG_ACCREDITO_EMENS;
/

CREATE OR REPLACE FUNCTION GET_QUALIFICA1_EMENS
(P_qua_inps number ) RETURN VARCHAR2 IS
/******************************************************************************
 NOME:        Function GET_QUALIFICA1_EMENS
 DESCRIZIONE: La funzione permette di estrarre il codice della qualifica1
              per la denuncia emens
              Richiede in INPUT il numero della qualifica legata al dipendente

 REVISIONI:
 Rev. Data        Autore  Descrizione
 ---- ----------  ------  -----------------------------------------------------
 1.0  20/03/2006  MS      Creazione Function
******************************************************************************/
D_valore VARCHAR2(1);
BEGIN
   D_valore := null;
        BEGIN
         select decode( to_char(qual.qua_inps)
                  , '0', 'Q'
                       , to_char(qual.qua_inps)
                  )
           into D_valore
           from qualifiche qual
          WHERE qual.numero (+) = P_qua_inps
              ;
        EXCEPTION WHEN NO_DATA_FOUND THEN
           D_valore := null; 
        END;
        RETURN D_valore;
END GET_QUALIFICA1_EMENS;
/

CREATE OR REPLACE FUNCTION GET_QUALIFICA2_EMENS
(P_posizione varchar2 ) RETURN VARCHAR2 IS
/******************************************************************************
 NOME:        Function GET_QUALIFICA2_EMENS
 DESCRIZIONE: La funzione permette di estrarre il codice della qualifica2
              per la denuncia emens 
              Richiede in INPUT il codice della posizione del dipendente

 REVISIONI:
 Rev. Data        Autore  Descrizione
 ---- ----------  ------  -----------------------------------------------------
 1.0  20/03/2006  MS      Creazione Function
******************************************************************************/
D_valore VARCHAR2(1);
BEGIN
   D_valore := null;
        BEGIN
         select decode( posi.part_time 
                  , 'SI', decode( posi.tipo_part_time
                                 ,'O', 'P'
                                 ,'V', 'V'
                                 ,'M', 'M'
                                     , 'P' )
                        , 'F')
           into D_valore
           from posizioni posi
          WHERE posi.codice (+) = P_posizione
        ;
        EXCEPTION WHEN NO_DATA_FOUND THEN
           D_valore := null; 
        END;
        RETURN D_valore;
END GET_QUALIFICA2_EMENS;
/

CREATE OR REPLACE FUNCTION GET_QUALIFICA3_EMENS
(P_posizione varchar2 ) RETURN VARCHAR2 IS
/******************************************************************************
 NOME:        Function GET_QUALIFICA3_EMENS
 DESCRIZIONE: La funzione permette di estrarre il codice della qualifica3
              per la denuncia emens 
              Richiede in INPUT il codice della posizione del dipendente

 REVISIONI:
 Rev. Data        Autore  Descrizione
 ---- ----------  ------  -----------------------------------------------------
 1.0  20/03/2006  MS      Creazione Function
******************************************************************************/

D_valore VARCHAR2(1);
BEGIN
   D_valore := null;
        BEGIN
         select decode( posi.stagionale
                       , 'SI', 'S'
                             , decode( posi.tempo_determinato
                                      ,'SI', 'D'
                                           , 'I')
                      )
           into D_valore
           from posizioni posi
          WHERE posi.codice (+) = P_posizione
        ;
        EXCEPTION WHEN NO_DATA_FOUND THEN
           D_valore := null; 
        END;
        RETURN D_valore;
END GET_QUALIFICA3_EMENS;
/

CREATE OR REPLACE FUNCTION GET_TIPO_CONTRIBUZIONE_EMENS
/******************************************************************************
 NOME:        Function GET_TIPO_CONTRIBUZIONE_EMENS
 DESCRIZIONE: La funzione permette di estrarre il tipo di contribuzione
              per la denuncia emens 
              Richiede in INPUT il codice di contribuzione legato al 
              trattamento previdenziale del dipendente

 REVISIONI:
 Rev. Data        Autore  Descrizione
 ---- ----------  ------  -----------------------------------------------------
 1.0  20/03/2006  MS      Creazione Function
******************************************************************************/

(P_contribuzione varchar2 ) RETURN VARCHAR2 IS
D_valore VARCHAR2(2);
BEGIN
   D_valore := null;
        BEGIN
         select substr(reco_t.rv_abbreviation,1,2)
           into D_valore
           from pec_ref_codes              reco_t
          where reco_t.rv_domain (+)    = 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
            and reco_t.rv_low_value (+) = P_contribuzione
        ;
        EXCEPTION WHEN NO_DATA_FOUND THEN
           D_valore := null; 
        END;
        RETURN D_valore;
END GET_TIPO_CONTRIBUZIONE_EMENS;
/

CREATE OR REPLACE FUNCTION GET_BASE_CALCOLO_TFR_EMENS
( P_ci      number
, P_anno    number
, P_mese    number
, P_colonna varchar2
, P_dal     date
, P_al date 
) RETURN NUMBER IS
/******************************************************************************
 NOME:        Function GET_BASE_CALCOLO_TFR
 DESCRIZIONE: La funzione permette di estrarre dalla colonna di DESRE
              estrazione DENUNCIA EMENS il valore della voce
              presente sui movimenti nell'anno , mese di denuncia

 REVISIONI:
 Rev. Data        Autore  Descrizione
 ---- ----------  ------  -----------------------------------------------------
 1.0  01/06/2007  MS      Prima Emissione
 1.1  02/08/2007  MS      Aggiunto parametro P_colonna
******************************************************************************/
d_valore NUMBER;
BEGIN
   d_valore := 0;
   BEGIN
      select round( sum(vacm.valore)/ max(nvl(esvc.arrotonda,0.01))
                  ) * max(nvl(esvc.arrotonda,0.01))
        into D_valore
        from valori_contabili_mensili    vacm
           , estrazione_valori_contabili esvc
       where vacm.estrazione = 'DENUNCIA_EMENS'
         and vacm.colonna    =  P_colonna
         and vacm.anno            = P_anno
         and vacm.mese            = P_mese
         and vacm.ci              = P_ci
         and vacm.riferimento between nvl(P_dal,to_date('2222222','j'))
                                  and nvl(P_al,to_date('3333333','j'))
         and vacm.riferimento between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
         and esvc.estrazione     = vacm.estrazione
         and esvc.colonna        = vacm.colonna
      having round( sum(vacm.valore)/ max(nvl(esvc.arrotonda,0.01))
                  ) * max(nvl(esvc.arrotonda,0.01)) != 0
   ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
             D_valore := 0;
   END;
  RETURN D_valore;
END GET_BASE_CALCOLO_TFR_EMENS;
/