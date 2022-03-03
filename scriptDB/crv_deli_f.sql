create or replace view delibere
     ( sede
     , anno
     , numero
     , data
     , oggetto
     , descrizione
     , esecutivita
     , tipo_ese
     , numero_ese
     , data_ese
     , note
     ) as
select tdel_tipo_deli
     , to_number(to_char(data_delibera,'yyyy'))
     , nvl(nume_delibera,0)
     , data_delibera
     , null
     , decode( data_delibera
             , null, null
                   , 'Del '||to_char(data_delibera,'dd/mm/yyyy')||', '
             )||
       'Esecutivita`: '||esecutivita
     , esecutivita
     , substr(approvazione,1,30)
     , null                   
     , null                
     , approvazione 
  from f_delibere
/
