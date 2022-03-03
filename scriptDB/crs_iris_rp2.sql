/* --------------------------------------------------------------------------

   Crea i sinonimmi da P00 a P00rp

   &1 = user di installazione normalmente P00

*/ --------------------------------------------------------------------------

-- creazione dei sinonimi dei dizionari sul nuovo utente 
CREATE SYNONYM p00contratti FOR &1.contratti;
CREATE SYNONYM p00ruoli FOR &1.ruoli;
CREATE SYNONYM p00posizioni FOR &1.posizioni;
CREATE SYNONYM p00centri_costo FOR &1.centri_costo;
CREATE SYNONYM p00sedi FOR &1.sedi;
CREATE SYNONYM p00profili_professionali FOR &1.profili_professionali;
CREATE SYNONYM p00qualifiche_ministeriali FOR &1.qualifiche_ministeriali;
CREATE SYNONYM p00qualifiche_giuridiche FOR &1.qualifiche_giuridiche;
CREATE SYNONYM p00figure_giuridiche FOR &1.figure_giuridiche;
CREATE SYNONYM p00unita_organizzative FOR &1.unita_organizzative;
CREATE SYNONYM p00settori_amministrativi FOR &1.settori_amministrativi;
CREATE SYNONYM p00relazioni_uo FOR &1.relazioni_uo;

-- Dizionari elaborati da p00 con viste specifiche
CREATE SYNONYM p00v_qualifiche_giuridiche FOR &1.rp_v_qualifiche_giuridiche;
CREATE SYNONYM p00v_figure_giuridiche FOR &1.rp_v_figure_giuridiche;
CREATE SYNONYM p00v_settori FOR &1.rp_v_settori;
CREATE SYNONYM p00v_sindacati FOR &1.rp_v_sindacati;
CREATE SYNONYM p00v_zona FOR &1.rp_v_zona;
CREATE SYNONYM p00v_presidio FOR &1.rp_v_presidio;
CREATE SYNONYM p00v_codici_assunzione  FOR &1.rp_v_codici_assunzione;
CREATE SYNONYM p00v_codici_attivita  FOR &1.rp_v_codici_attivita;
CREATE SYNONYM p00v_codici_comuni  FOR &1.rp_v_comuni;
CREATE SYNONYM p00v_codici_dimissione  FOR &1.rp_v_codici_dimissione;
CREATE SYNONYM p00v_posizioni_inail  FOR &1.rp_v_posizioni_inail;
CREATE SYNONYM p00v_stati_civili  FOR &1.rp_v_stati_civili;

-- tabella INDIVIDUI_MODIFICATI
create synonym individui_modificati for &1.individui_modificati;

-- Dati Individuali
CREATE SYNONYM p00x_anagrafici FOR &1.rp_v_anagrafici;
CREATE SYNONYM p00x_familiari FOR &1.rp_v_familiari;
CREATE SYNONYM p00x_periodi_rapporto  FOR &1.rp_v_periodi_rapporto;
CREATE SYNONYM p00x_periodi_giuridici  FOR &1.rp_v_periodi_giuridici;
CREATE SYNONYM p00x_codici_minist  FOR &1.rp_v_codici_minist;
CREATE SYNONYM p00x_sindacati  FOR &1.rp_v_sindacato;

