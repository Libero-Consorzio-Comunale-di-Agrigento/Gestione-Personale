CREATE OR REPLACE PACKAGE GP4_RIGD IS
/******************************************************************************
 NOME:        GP4_RIGD
 DESCRIZIONE: Funzioni sulla tabella RIPARTIZIONE_DOTAZIONE_ORGANICA

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    06/02/2004 __     Prima emissione.
******************************************************************************/
   FUNCTION  VERSIONE                             RETURN VARCHAR2;
   FUNCTION  GET_GRUPPO     (p_rigd_id in number) RETURN VARCHAR2;
   FUNCTION  GET_TOT_ORE    (p_rigd_id in number) RETURN number;
   FUNCTION  GET_TOT_NUMERO (p_rigd_id in number) RETURN number;
   FUNCTION  GET_ORE_D      (p_rigd_id in number) RETURN number;
   FUNCTION  GET_NUMERO_D   (p_rigd_id in number) RETURN number;
   FUNCTION  GET_ORE_I      (p_rigd_id in number) RETURN number;
   FUNCTION  GET_NUMERO_I   (p_rigd_id in number) RETURN number;
   FUNCTION  GET_ORE_L      (p_rigd_id in number) RETURN number;
   FUNCTION  GET_NUMERO_L   (p_rigd_id in number) RETURN number;
   FUNCTION  GET_DAL        (p_rigd_id in number) RETURN date;
   FUNCTION  GET_AL         (p_rigd_id in number) RETURN date;
END GP4_RIGD;
/
CREATE OR REPLACE PACKAGE BODY GP4_RIGD AS

FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 06/02/2004';
END VERSIONE;
--
FUNCTION GET_TOT_ORE  (p_rigd_id in number) RETURN number IS
d_tot_ore number;
/******************************************************************************
 NOME:        GET_TOT_ORE
 DESCRIZIONE: Restituisce il totale delle ore 
              delle ripartizioni linguistiche per il gruppo indicato
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_tot_ore := 0;
  begin
   select nvl(NUMERO_ORE_I,0) + nvl(NUMERO_ORE_D,0) + nvl(NUMERO_ORE_L,0)
     into d_tot_ore
	 from ripartizione_gruppi_dotazione
	where rigd_id = p_rigd_id
   ;
  exception
    when no_data_found then
	   d_tot_ore := 0;
  end;
  return d_tot_ore;
END GET_TOT_ORE;
--
FUNCTION GET_TOT_numero  (p_rigd_id in number) RETURN number IS
d_tot_numero number;
/******************************************************************************
 NOME:        GET_TOT_numero
 DESCRIZIONE: Restituisce il totale del numero 
              delle ripartizioni linguistiche per il gruppo indicato
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_tot_numero := 0;
  begin
   select nvl(NUMERO_I,0) + nvl(NUMERO_D,0) + nvl(NUMERO_L,0)
     into d_tot_numero
	 from ripartizione_gruppi_dotazione
	where rigd_id = p_rigd_id
   ;
  exception
    when no_data_found then
	   d_tot_numero := 0;
  end;
  return d_tot_numero;
END GET_TOT_numero;
--
FUNCTION GET_ORE_D  (p_rigd_id in number) RETURN number IS
d_ore number;
/******************************************************************************
 NOME:        GET_ORE_D
 DESCRIZIONE: Restituisce il totale delle ore della ripartizione tedesca
              per il gruppo indicato
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_ore := 0;
  begin
   select nvl(NUMERO_ORE_D,0)
     into d_ore
	 from ripartizione_gruppi_dotazione
	where rigd_id = p_rigd_id
   ;
  exception
    when no_data_found then
	   d_ore := 0;
  end;
  return d_ore;
END GET_ORE_D;
--
FUNCTION GET_numero_D  (p_rigd_id in number) RETURN number IS
d_numero number;
/******************************************************************************
 NOME:        GET_NUMERO_D
 DESCRIZIONE: Restituisce il totale del numero della ripartizione tedesca
              per il gruppo indicato
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_numero := 0;
  begin
   select nvl(NUMERO_D,0)
     into d_numero
	 from ripartizione_gruppi_dotazione
	where rigd_id = p_rigd_id
   ;
  exception
    when no_data_found then
	   d_numero := 0;
  end;
  return d_numero;
END GET_numero_D;
--
FUNCTION GET_ORE_I  (p_rigd_id in number) RETURN number IS
d_ore number;
/******************************************************************************
 NOME:        GET_ORE_I
 DESCRIZIONE: Restituisce il totale delle ore della ripartizione italiana
              per il gruppo indicato
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_ore := 0;
  begin
   select nvl(NUMERO_ORE_I,0)
     into d_ore
	 from ripartizione_gruppi_dotazione
	where rigd_id = p_rigd_id
   ;
  exception
    when no_data_found then
	   d_ore := 0;
  end;
  return d_ore;
END GET_ORE_I;
--
FUNCTION GET_numero_I  (p_rigd_id in number) RETURN number IS
d_numero number;
/******************************************************************************
 NOME:        GET_NUMERO_I
 DESCRIZIONE: Restituisce il totale del numero della ripartizione italiana
              per il gruppo indicato
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_numero := 0;
  begin
   select nvl(NUMERO_I,0)
     into d_numero
	 from ripartizione_gruppi_dotazione
	where rigd_id = p_rigd_id
   ;
  exception
    when no_data_found then
	   d_numero := 0;
  end;
  return d_numero;
END GET_numero_I;
--
FUNCTION GET_ORE_L  (p_rigd_id in number) RETURN number IS
d_ore number;
/******************************************************************************
 NOME:        GET_ORE_L
 DESCRIZIONE: Restituisce il totale delle ore della ripartizione italiana
              per il gruppo indicato
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_ore := 0;
  begin
   select nvl(NUMERO_ORE_L,0)
     into d_ore
	 from ripartizione_gruppi_dotazione
	where rigd_id = p_rigd_id
   ;
  exception
    when no_data_found then
	   d_ore := 0;
  end;
  return d_ore;
END GET_ORE_L;
--
FUNCTION GET_numero_L  (p_rigd_id in number) RETURN number IS
d_numero number;
/******************************************************************************
 NOME:        GET_NUMERO_L
 DESCRIZIONE: Restituisce il totale del numero della ripartizione italiana
              per il gruppo indicato
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_numero := 0;
  begin
   select nvl(NUMERO_L,0)
     into d_numero
	 from ripartizione_gruppi_dotazione
	where rigd_id = p_rigd_id
   ;
  exception
    when no_data_found then
	   d_numero := 0;
  end;
  return d_numero;
END GET_numero_L;
--
FUNCTION GET_DAL  (p_rigd_id in number) RETURN date IS
d_DAL date;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce  la data di inizio del periodo 
              di ripartizione linguistica per il gruppo indicato
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_DAL := to_date(null);
  begin
   select dal
     into d_dal
	 from ripartizione_gruppi_dotazione
	where rigd_id = p_rigd_id
   ;
  exception
    when no_data_found then
	   d_dal := to_date(null);
  end;
  return d_dal;
END GET_DAL;
--
FUNCTION GET_al  (p_rigd_id in number) RETURN date IS
d_al date;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce  la data di termine del periodo 
              di ripartizione linguistica per il gruppo indicato
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_al := to_date(null);
  begin
   select al
     into d_al
	 from ripartizione_gruppi_dotazione
	where rigd_id = p_rigd_id
   ;
  exception
    when no_data_found then
	   d_al := to_date(null);
  end;
  return d_al;
END GET_al;
--
FUNCTION GET_gruppo  (p_rigd_id in number) RETURN varchar2 IS
d_gruppo gruppi_dotazione.gruppo%type;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce  il codice drl gruppo di ripartizione 
              di ripartizione linguistica per il periodo indicato
 PARAMETRI:   --
******************************************************************************/
BEGIN
  d_gruppo := to_char(null);
  begin
   select gruppo
     into d_gruppo
	 from ripartizione_gruppi_dotazione
	where rigd_id = p_rigd_id
   ;
  exception
    when no_data_found then
	   d_gruppo := to_char(null);
  end;
  return d_gruppo;
END GET_gruppo;
--
END GP4_RIGD;
/* End Package Body: GP4_RIGD */
/
