--******************************************************************************
-- NOME:        afcKC.sql
-- DESCRIZIONE: Creazione Tabelle "Base Dati Appoggio" per gestione Constraint Error e Multilinguismo.
--
-- ANNOTAZIONI: Attivata da file afcKC.def
-- REVISIONI:
-- Rev.  Data        Autore  Descrizione
-- ----  ----------  ------  ----------------------------------------------------
-- 0     08/09/2006  MF      Prima versione.
-- 1     02/10/2006  MM      Commento con --.
--******************************************************************************

-- Script per creazione oggetti gestione Constraint Error e Multilinguismo.

start ver\afc\kc\afcKCkeco.sql

start ver\afc\kc\keel.crt
start ver\afc\kc\keel_tiu.trg


-- Script per creazione oggetti gestione Lingua Alternativa

start ver\afc\kc\afcKCkeal.sql