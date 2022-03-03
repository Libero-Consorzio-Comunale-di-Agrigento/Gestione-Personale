create or replace package GP4_EVIN is
/******************************************************************************
 NOME:         GP4_EVIN
 DESCRIZIONE:  Estrazione delle informazioni per il calcolo presunto del 
               rimborso dell'INAIL

 ANNOTAZIONI:  E' richiamata dalla form PECCDEIN

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  21/11/2006 MS     Prima Emissione
 1.1  06/06/2007 MS     Distinzione Fisse / Accessorie
******************************************************************************/
FUNCTION  VERSIONE              RETURN varchar2;
FUNCTION  CALCOLA_IMPORTO 
( P_CI           in number
, P_data_inf     in date
, P_data_rientro in date
) return number;

FUNCTION  CALCOLA_ACCESSORIE
( P_CI           in number
, P_data_inf     in date
, P_data_rientro in date
) return number;

end GP4_EVIN;
/
create or replace package body GP4_EVIN is

FUNCTION VERSIONE  RETURN varchar2 IS
BEGIN
   RETURN 'V1.1 del 06/06/2007';
END VERSIONE;

FUNCTION CALCOLA_IMPORTO 
( P_CI           in number
, P_data_inf     in date
, P_data_rientro in date
) return number IS

D_gg_limite     number(2) := 90;
D_importo       number(12,2) := 0;
D_importo_entro number(12,2) := 0;
D_importo_oltre number(12,2) := 0;
D_fisse         number(12,2) := 0;
D_acce          number(12,2) := 0;
D_ore_lavoro    number(5,2) := 0;
D_rapporto_orario number(5,2) := 0;
D_giorni_inf    number(5,2) := trunc(P_data_rientro)-trunc(P_data_inf)+1;
/* Estrazione retribuzioni fisse */
BEGIN
  BEGIN
      select cost.ore_lavoro       ore_lavoro
           , nvl(pegi_s.ore,cost.ore_lavoro) / cost.ore_lavoro  rapporto_orario
        into D_ore_lavoro
           , D_rapporto_orario
        FROM periodi_giuridici           pegi_s
           , qualifiche_giuridiche       qugi
           , contratti_storici           cost
     WHERE  pegi_s.ci              = P_ci
       AND  P_data_inf     BETWEEN pegi_s.dal 
                               AND NVL(pegi_s.al,TO_DATE(3333333,'j'))
       AND  pegi_s.rilevanza                     = 'S'
       AND  qugi.numero                          = pegi_s.qualifica
       AND  P_data_inf  BETWEEN qugi.dal 
                            AND NVL(qugi.al,TO_DATE(3333333,'j'))
       AND  cost.contratto  = qugi.contratto 
       AND  P_data_inf     BETWEEN cost.dal 
                               AND NVL(cost.al,TO_DATE(3333333,'j'))					 
       ;
  END;
  
/* Estrazione importo della informazioni retributive valide nel mese dell'infortunio */  
  BEGIN
     SELECT sUM( DISTINCT decode(covo_r.rapporto
                                  ,'R',inre_r.tariffa * D_rapporto_orario    
                                  ,'O',inre_r.tariffa * D_rapporto_orario    
                                      ,inre_r.tariffa
                                   )
                 )         retr_mensile
        into D_fisse
        FROM voci_economiche             voec_r
            ,informazioni_retributive    inre_r
            ,contabilita_voce            covo_r
       WHERE voec_r.codice = inre_r.voce
         AND inre_r.tipo != 'E'
         and covo_r.voce  = inre_r.voce
         and covo_r.sub   = inre_r.sub
         AND (   (    voec_r.classe IN ('P','B')
                  AND voec_r.tipo||NVL(voec_r.specie,'T') = 'CT')
              OR (    voec_r.classe = 'V'
                  AND voec_r.tipo||NVL(voec_r.specie,'T') IN ('CT','FT','QT'))
              OR (    voec_r.automatismo = 'ASS_FAM'
                  AND NVL(voec_r.specie,'T') = 'T')
             )
         AND (   (    inre_r.tipo != 'B')
              OR (    inre_r.tipo  = 'B'
                  AND NOT EXISTS
                               ( SELECT 1
                                 FROM informazioni_retributive inre2
                                     ,voci_contabili           voco
                                WHERE inre2.ci     = inre_r.ci
                                  AND inre2.voce   = inre_r.voce
                                  AND inre2.ROWID != inre_r.ROWID
                                  AND voco.voce    = inre_r.voce
                                  AND inre2.sub   != 'Q'
                                  AND P_data_inf BETWEEN NVL(inre2.dal,TO_DATE('2222222','j'))
                                                     AND NVL(inre2.al,TO_DATE('3333333','j'))
                               ))
             )
         AND P_data_inf BETWEEN NVL(inre_r.dal,TO_DATE('2222222','j'))
                            AND NVL(inre_r.al,TO_DATE('3333333','j'))
         AND inre_r.ci = P_ci;
  EXCEPTION WHEN NO_DATA_FOUND THEN
       D_fisse := 0;
  END;

-- dbms_output.put_line('Fisse: '||D_fisse);
 
/* Estrazione importo delle voci accessorie : equivale all'importo delle voci liquidate nell'ultimo 
mese elaborato per il dipendente prima dell'infortunio , potrebbe essere anche il mese dell'infortunio
le voci da considerare dovranno essere definite in DESRE nell'estrazione ESTRAZIONE_INFORTUNI
colonna ACCESSORIE */  

   BEGIN
    select sum(nvl(valore,0))
      into D_acce
      from valori_contabili_mensili vacm
     where estrazione = 'ESTRAZIONE_INFORTUNI'
       and colonna    = 'ACCESSORIE'
       and mensilita != '*AP'
       and vacm.ci    = P_ci
       and vacm.anno||lpad(vacm.mese,2,'0')
        = ( select max(anno||lpad(to_char(mese),2,'0'))
              from movimenti_fiscali mofi
             where mensilita != '*AP'
               and ci = vacm.ci
               and to_date('01'||lpad(to_char(mese),2,'0')||to_char(anno),'ddmmyyyy')  
                  <= P_data_inf
          )
     group by vacm.anno,vacm.mese;
    EXCEPTION WHEN NO_DATA_FOUND THEN
         D_acce := 0;
    END;
-- dbms_output.put_line('Accessorie: '||D_acce);
-- dbms_output.put_line('Giorni Infortunio: '||D_giorni_inf);
  select  ( ( nvl(D_fisse,0)*1.2033) + (nvl(D_acce,0)*2)
          ) / 25
            * ( least(D_giorni_inf,D_gg_limite)-4 )
            * 60 / 100
        , ( ( nvl(D_fisse,0)*1.2033) + (nvl(D_acce,0)*2)
          ) / 25
             * ( (D_giorni_inf-D_gg_limite) )
             * decode(sign(D_giorni_inf - D_gg_limite )
                   , 1, 75, 0)
           / 100
    into D_importo_entro
       , D_importo_oltre
    from dual;
-- dbms_output.put_line('Importo fino a 90gg: '||D_importo_entro);
-- dbms_output.put_line('Importo oltre 90gg: '||D_importo_oltre);
    D_importo := D_importo_entro + D_importo_oltre;
-- dbms_output.put_line('Importo: '||D_importo);
  return D_importo;
END CALCOLA_IMPORTO ;

FUNCTION CALCOLA_ACCESSORIE
( P_CI           in number
, P_data_inf     in date
, P_data_rientro in date
) return number IS

D_gg_limite     number(2) := 90;
D_importo       number(12,2) := 0;
D_importo_entro number(12,2) := 0;
D_importo_oltre number(12,2) := 0;
D_acce          number(12,2) := 0;
D_giorni_inf    number(5,2) := trunc(P_data_rientro)-trunc(P_data_inf)+1;

BEGIN

/* Estrazione importo delle voci accessorie : equivale all'importo delle voci liquidate nell'ultimo 
mese elaborato per il dipendente prima dell'infortunio , potrebbe essere anche il mese dell'infortunio
le voci da considerare dovranno essere definite in DESRE nell'estrazione ESTRAZIONE_INFORTUNI
colonna ACCESSORIE */  

   BEGIN
    select sum(nvl(valore,0))
      into D_acce
      from valori_contabili_mensili vacm
     where estrazione = 'ESTRAZIONE_INFORTUNI'
       and colonna    = 'ACCESSORIE'
       and mensilita != '*AP'
       and vacm.ci    = P_ci
       and vacm.anno||lpad(vacm.mese,2,'0')
        = ( select max(anno||lpad(to_char(mese),2,'0'))
              from movimenti_fiscali mofi
             where mensilita != '*AP'
               and ci = vacm.ci
               and to_date('01'||lpad(to_char(mese),2,'0')||to_char(anno),'ddmmyyyy')  
                  <= P_data_inf
          )
     group by vacm.anno,vacm.mese;
    EXCEPTION WHEN NO_DATA_FOUND THEN
         D_acce := 0;
    END;
-- dbms_output.put_line('Accessorie: '||D_acce);
-- dbms_output.put_line('Giorni Infortunio: '||D_giorni_inf);
  select  ( nvl(D_acce,0)*2
          ) / 25
            * ( least(D_giorni_inf,D_gg_limite)-4 )
            * 60 / 100
        , ( nvl(D_acce,0)*2
          ) / 25
             * ( (D_giorni_inf-D_gg_limite) )
             * decode(sign(D_giorni_inf - D_gg_limite )
                   , 1, 75, 0)
           / 100
    into D_importo_entro
       , D_importo_oltre
    from dual;
-- dbms_output.put_line('Importo fino a 90gg: '||D_importo_entro);
-- dbms_output.put_line('Importo oltre 90gg: '||D_importo_oltre);
    D_importo := D_importo_entro + D_importo_oltre;
-- dbms_output.put_line('Importo: '||D_importo);
  return D_importo;
END CALCOLA_ACCESSORIE; -- calcolo accessorie
END GP4_EVIN;
/
