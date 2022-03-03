CREATE OR REPLACE PACKAGE GP4_SOGI IS
/******************************************************************************
 NOME:        GP4_SOGI
 DESCRIZIONE: <Descrizione Package>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    21/08/2002 __     Prima emissione.
******************************************************************************/
   FUNCTION  VERSIONE                         RETURN VARCHAR2;
   FUNCTION  GET_ULTERIORE_SOSTITUTO  (p_sostituto in number,p_dal in date, p_al in date) RETURN VARCHAR2;
END GP4_SOGI;
/
CREATE OR REPLACE PACKAGE BODY GP4_SOGI AS
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
   RETURN 'V1.0 del 04/09/2005';
END VERSIONE;
--
FUNCTION GET_ULTERIORE_SOSTITUTO  (p_sostituto in number,p_dal in date,p_al in date) RETURN varchar2 IS
d_data date;
d_sostituto    varchar2(80);
d_assenza      varchar2(20) := to_char(null);
d_assente      number(1) := 0;
d_incaricato   number(1) := 0;
d_dal_ass      date;
d_dal_inc      date;
d_ci_sostituto varchar2(20);
d_evento       astensioni.codice%type;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: descrive la situazione del sostituto, se è assente ed eventualmente 
              sostituito e da chi.
 PARAMETRI:   --
******************************************************************************/
BEGIN
  /* Verifica se il sostituto indicato è assente nel periodo */
  begin 
    select 1,dal,assenza
	  into d_assente,d_dal_ass,d_evento
	  from periodi_giuridici
	 where ci                            = p_sostituto
	   and rilevanza                     = 'A'
	   and assenza                      in (select codice from astensioni where sostituibile = 1)
	   and dal                          <= nvl(p_al,to_date(3333333,'j'))
	   and nvl(al,to_date(3333333,'j')) >= p_dal
	   and dal                           = (select max(dal)
                             	              from periodi_giuridici
                             				 where ci = p_sostituto
                                          	   and rilevanza = 'A'
                                          	   and assenza in (select codice from astensioni where sostituibile = 1)
                                          	   and dal <= nvl(p_al,to_date(3333333,'j'))
                                          	   and nvl(al,to_date(3333333,'j')) >= p_dal
                                           )
	;
  exception when no_data_found then null;
  end;
  begin 
    select 1,dal
	  into d_incaricato,d_dal_inc
	  from periodi_giuridici
	 where ci                            = p_sostituto
	   and rilevanza                     = 'I'
	   and dal                          <= nvl(p_al,to_date(3333333,'j'))
	   and nvl(al,to_date(3333333,'j')) >= p_dal
	   and dal                           = (select max(dal)
                             	              from periodi_giuridici
                             				 where ci = p_sostituto
                                          	   and rilevanza = 'I'
                                          	   and dal <= nvl(p_al,to_date(3333333,'j'))
                                          	   and nvl(al,to_date(3333333,'j')) >= p_dal
                                           )
	;
  exception when no_data_found then null;
  end;
  begin
    if     d_assente = 1 and d_incaricato = 1	then   d_assenza := '[Ass./Inc.]';
	elsif  d_assente = 1 and d_incaricato = 0   then   d_assenza := '[Assente]';
	elsif  d_assente = 0 and d_incaricato = 1   then   d_assenza := '[Incaricato]';
    end if; 
  end;
  if d_assenza is not null then
     begin
        select '[sost.CI:'||max(sostituto)||']'
		  into d_ci_sostituto
		  from sostituzioni_giuridiche
		 where titolare              = p_sostituto
		   and dal_astensione       in (d_dal_ass,d_dal_inc)
		   and rilevanza_astensione in ('I','A')
		   and sostituto            <> 0
		;
     exception when no_data_found then null;
	 end; 
	 select d_assenza||decode(d_ci_sostituto,'[sost.CI:]',' ',d_ci_sostituto)
	   into d_sostituto
	   from dual
	 ;
	 return d_sostituto;
  end if;
  return d_assenza;
END GET_ULTERIORE_SOSTITUTO;
--
end gp4_sogi;
/
