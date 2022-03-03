CREATE OR REPLACE VIEW ASSENZE_TOTALI
(CI, DAL, AL, ASSENZA)
AS 
select ci,dal,al,assenza
  from periodi_giuridici
 where rilevanza = 'A' 
union
select ci,dal,al,voce
  from assenze_a_ore
 where giorni >= 1;