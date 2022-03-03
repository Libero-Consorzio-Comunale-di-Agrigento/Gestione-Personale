CREATE OR REPLACE PROCEDURE UPDATE_NUMERO_FASCIA IS
/******************************************************************************
 NOME:        UPDATE_NUMERO_FASCIA 
 DESCRIZIONE: Inizializza il campo numero_fascia di assegni_familiari e 
              scaglioni_assegno_familiare. La procedure verrà 
              in seguito droppata. Attività 7334.
 ARGOMENTI:   
 ECCEZIONI: 
 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0	20/09/2004    MV  Prima emissione
******************************************************************************/
p_conta number := 0;

BEGIN
delete from assegni_familiari asfa
where not exists
(select 'x' from scaglioni_assegno_familiare
 where  dal    = asfa.dal
 and scaglione = asfa.scaglione)
;

 for cur in
 (select distinct dal
  from scaglioni_assegno_familiare
  order by dal
  )
 loop
 
  p_conta := 0;
  for cur_1 in 
   (
   select scaglione
    from scaglioni_assegno_familiare
    where dal         = CUR.dal
    order by scaglione
   )  loop
    
   
   p_conta := p_conta +1;
   
   update scaglioni_assegno_familiare
   set numero_fascia = p_conta
   where dal         = CUR.dal
   and scaglione     = CUR_1.scaglione
   ;

   update assegni_familiari
   set numero_fascia = p_conta
   where dal         = CUR.dal
   and scaglione     = CUR_1.scaglione
   ;

  
   end loop;

 end loop;
END;
/
