create or replace trigger pagheads_tiu
   before insert or update of codpaghe on pagheads
   for each row
declare
   d_voce varchar2(12);
begin
   -- determinazione di voce e sub
   if inserting or :new.codpaghe <> :old.codpaghe then
      d_voce    := ppacderi.get_voce(ppacderi.get_causale(:new.codpaghe));
      :new.voce := translate(rtrim(substr(d_voce, 1, 10)), '?', ' ');
      :new.sub  := translate(rtrim(substr(d_voce, 11, 2)), '?', ' ');
   end if;
end pagheads_tma;
/
