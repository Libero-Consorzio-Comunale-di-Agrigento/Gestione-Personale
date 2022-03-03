CREATE OR REPLACE PACKAGE GP4_POII IS
       FUNCTION  VERSIONE                RETURN VARCHAR2;
       PROCEDURE  PERCENTUALE_COPERTA (p_ci        in number
                                     ,p_dal        in date
                                     ,p_al         in date
                                     ,p_coperta    out varchar2
                                     ,p_aliquota   out number 
                                     ,p_data       out date                                   
                                     ) ;
END GP4_POII;
/
CREATE OR REPLACE PACKAGE BODY GP4_POII AS
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 aliquota:    Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 10/10/2007';
END VERSIONE;
--
PROCEDURE PERCENTUALE_COPERTA
   (
      p_ci        in number
     ,p_dal       in date
     ,p_al        in date
     ,p_coperta   out varchar2
     ,p_aliquota  out number
     ,p_data      out date
   ) is
      non_coperta exception;
      /******************************************************************************
         NAME:       PERCENTUALE_COPERTA
         PURPOSE:    Controlla che la ripartizione sulle voci di rischio, in un dato
                     periodo,  sia esatta (100%).
      ******************************************************************************/
   begin
      begin
         begin
             for chk in 
             (select p_dal data_chk
              from   dual
              union
              select p_al
              from dual
              union
              select distinct dal
              from ponderazioni_inail_individuali 
              where ci = p_ci
              and dal >= p_dal
              union
              select distinct nvl(al, to_date(3333333, 'j'))
              from ponderazioni_inail_individuali 
              where ci = p_ci
              and nvl(al, to_date(3333333, 'j')) <= p_al
              union
              select distinct dal - 1
              from ponderazioni_inail_individuali
              where ci = p_ci
              and dal - 1 >= p_dal
              union
              select distinct nvl(al + 1, to_date(3333333, 'j'))
              from ponderazioni_inail_individuali
              where ci = p_ci
              and nvl(al + 1, to_date(3333333, 'j')) <= p_al)
          loop
                  select sum(nvl(aliquota, 0))  
                  into   p_aliquota
                    from ponderazioni_inail_individuali
                   where ci = p_ci
                     and chk.data_chk between dal and nvl(al, to_date(3333333, 'j'));
                  if nvl(p_aliquota, 0) <> 100 then
                     p_data := chk.data_chk;
                     raise non_coperta;
                  end if;
               end loop;
               p_coperta := 'SI';
         end;
      exception
         when non_coperta then
            p_coperta := 'NO';
      end;
   end PERCENTUALE_COPERTA;
   
--
END GP4_POII;
/* End Package Body: GP4_POII */
/
