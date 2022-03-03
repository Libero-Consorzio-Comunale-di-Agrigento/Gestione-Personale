CREATE OR REPLACE PACKAGE PECSMTFC IS
/******************************************************************************
 NOME:        PECSMTFC
 DESCRIZIONE: FUNZIONI COMUNI PER I PECKAGE RIGUARDANTI LE STATISTICHE DEL MINISTERO DEL TESORO

 ANNOTAZIONI: -  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    15/12/2002 __     Prima emissione.
******************************************************************************/
  FUNCTION  VERSIONE                             RETURN VARCHAR2;
  FUNCTION INT_COM ( P_ci          NUMBER
                   , P_gestione    VARCHAR2
                   , P_a           DATE
                   , P_fin_a       DATE
                   , P_retributivo VARCHAR)      RETURN VARCHAR2;
  FUNCTION EST_COM ( P_ci          NUMBER
                   , P_gestione    VARCHAR2
                   , P_a           DATE
                   , P_fin_a       DATE
                   , P_retributivo VARCHAR)      RETURN VARCHAR2;
END PECSMTFC;
/

CREATE OR REPLACE PACKAGE BODY PECSMTFC AS
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 15/12/2002';
END VERSIONE;

FUNCTION INT_COM ( P_ci          NUMBER
                 , P_gestione    VARCHAR2
                 , P_a           DATE
                 , P_fin_a       DATE
                 , P_retributivo VARCHAR) RETURN VARCHAR2 IS
D_int_com varchar2(2);
/******************************************************************************
 NOME:        INT_COM
 DESCRIZIONE: Determina se un determinato individua risulta ESTERNO COMANDATO

 PARAMETRI:   p_<par1> <type> <Descrizione parametro 1>
              p_<par2> <type> <Descrizione parametro 2>.

 RITORNA:     <type> n : <Descrizione caso n>
                     m : <Descrizione caso m>

 ECCEZIONI:   nnnnn, <Descrizione eccezione>

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    09/12/03      Prima emissione.
******************************************************************************/
BEGIN
  BEGIN
    SELECT 'SI'
      INTO D_int_com
      FROM dual
     WHERE exists (select 'x'
                     from periodi_giuridici pegi_s
                    where pegi_s.ci = P_ci
                      and rilevanza = 'S'
                      and gestione = P_gestione
                      and nvl(P_a,P_fin_a) between pegi_s.dal and nvl(pegi_s.al,to_date('3333333','J'))
                      and exists (select 'x'
                                    from periodi_giuridici pegi_p
                                   where pegi_p.ci = pegi_s.ci
                                     and rilevanza = 'P'
                                     and nvl(P_a,P_fin_a) between pegi_p.dal and nvl(pegi_p.al,to_date('3333333','J'))
                                 )
                      and exists (select 'x'
                                    from periodi_giuridici pegi_e
                                        ,gestioni          gest
                                   where pegi_e.ci = pegi_s.ci
                                     and rilevanza = 'I'
                                     and nvl(P_a,P_fin_a) between pegi_e.dal and nvl(pegi_e.al,to_date('3333333','J'))
                                     and pegi_e.gestione like gest.codice
                                     and gestito = 'NO'
                                 )
                  )
       AND P_retributivo = 'SI'
    ;
  EXCEPTION
    WHEN no_data_found then
      D_int_com := 'NO';
  END;
  RETURN D_int_com;
END INT_COM;

FUNCTION EST_COM ( P_ci          NUMBER
                 , P_gestione    VARCHAR2
                 , P_a           DATE
                 , P_fin_a       DATE
                 , P_retributivo VARCHAR) RETURN VARCHAR2 IS
D_est_com varchar2(2);
/******************************************************************************
 NOME:        EST_COM
 DESCRIZIONE: Determina se un determinato individua risulta ESTERNO COMANDATO

 PARAMETRI:   p_<par1> <type> <Descrizione parametro 1>
              p_<par2> <type> <Descrizione parametro 2>.

 RITORNA:     <type> n : <Descrizione caso n>
                     m : <Descrizione caso m>

 ECCEZIONI:   nnnnn, <Descrizione eccezione>

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    09/12/03      Prima emissione.
******************************************************************************/
BEGIN
  BEGIN
    SELECT 'SI'
	  INTO D_est_com
      FROM dual
     WHERE exists (select 'x'
                     from periodi_giuridici pegi_s
                    where pegi_s.rilevanza = 'S'
                      and pegi_s.ci = P_ci
                      and gestione  = P_gestione
                      and nvl(P_a,P_fin_a) between pegi_s.dal and nvl(pegi_s.al,to_date('3333333','J'))
                      and not exists (select 'x'
                                        from periodi_giuridici pegi_p
                                       where pegi_s.ci = pegi_p.ci
                                         and nvl(P_a,P_fin_a) between pegi_p.dal and nvl(pegi_p.al,to_date('3333333','J'))
                                         and pegi_p.rilevanza = 'P'
                                     )
                  )
       AND P_retributivo = 'NO'
    ;
  EXCEPTION
    WHEN no_data_found then
      D_est_com := 'NO';
  END;
  RETURN D_est_com;
END EST_COM;

END PECSMTFC;
/
/ 
