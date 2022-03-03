--A6944
column C1 noprint new_value P1

select count(*) C1   from anagrafici  where al is null;

start crt_reuo.sql &P1
start crf_UNOR_REUO_TMA.sql
start crf_PEGI_DOES_TMA.sql
start crp_GP4GM.sql

-- popolamento tabella relazioni_uo

DECLARE 
  RetVal VARCHAR2(200);
  P_NI NUMBER;
  P_OTTICA VARCHAR2(200);
  P_DATA DATE;
BEGIN 
  P_NI := NULL;
  P_OTTICA := NULL;
  P_DATA := NULL;
  delete from relazioni_uo;
  for rest in
     (select revisione,dal
        from revisioni_struttura
       order by revisione
	 ) loop
       for sett in
          (select stam.ni
                 ,unor.codice_uo                codice        
                 ,unor.suddivisione
                 ,unor.revisione
                 ,stam.gestione
             from settori_amministrativi stam
                 ,unita_organizzative    unor
            where unor.revisione          = rest.revisione
              and unor.ottica             = 'GP4'
              and rest.dal    between unor.dal             
                                  and nvl(unor.al,to_date(3333333,'j'))
     	      and  stam.ni = unor.ni
          ) loop
            insert into relazioni_uo
            select  sett.revisione
                   ,sett.gestione
                   ,sett.ni
                   ,sett.codice 
                   ,sett.suddivisione
                   ,unor.ni
                   ,unor.codice_uo
                   ,unor.suddivisione
            from unita_organizzative unor 
           where ottica             = 'GP4' 
             and revisione          = sett.revisione
             and rest.dal     between dal                              
                                  and nvl(al,to_date(3333333,'j')) 
           start with ni            = sett.ni 
             and ottica             = 'GP4' 
             and revisione          = sett.revisione 
          connect by prior ni = unita_padre 
                       and ottica                      = 'GP4' 
                       and revisione                   = sett.revisione
           ;
        end loop;
   end loop;
END; 
/
