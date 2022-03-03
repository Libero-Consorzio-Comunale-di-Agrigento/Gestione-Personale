-- Da rilasci precedenti

start ver\A6951_1.sql
start ver\A9898.sql


-- Patch 4.8.4

-- Attivita' 9755
start ver\A9755.sql

-- Attivita' 9890.1
start ver\A9890_1.sql

-- Attivita' 9925
start ver\A9925.sql

-- Attivita' 9944
start ver\A9944.sql

-- Attivita' 9946
start ver\A9946.sql

-- Attivita' 10038
start ver\A10038.sql

-- Alter table x Attivita' 9882.1

alter table gestioni add mittente_emens number(8);
alter table gestioni add perc_copertura number(5,2);