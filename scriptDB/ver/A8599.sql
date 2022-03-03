start crp_gp4_ente.sql
start crp_peccsmds.sql

-- replica dell'attività A2295
alter table revisioni_dotazione modify (DATA  null);

start crv_ast2.sql

start crf_peccmore.sql