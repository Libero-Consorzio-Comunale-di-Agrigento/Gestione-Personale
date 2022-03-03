-- tolta la create della vista che segnala problemi in oracle 7
-- inserita la start del crv
start crv_gp4gm_2.sql

-- riallinea i settori vecchi
begin
  gp4gm.allinea_settori('');
end;
/