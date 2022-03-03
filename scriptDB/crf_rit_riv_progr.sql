create or replace function rit_riv_progr
(
   p_anno number
  ,p_mese number
  ,p_ci   number
) return number is
   d_rit_riv number;
begin
   select sum(nvl(rit_riv, 0))
     into d_rit_riv
     from movimenti_fiscali
    where anno >= 2001
      and anno < p_anno
      and ci = p_ci;
   return d_rit_riv;
end rit_riv_progr;
/
