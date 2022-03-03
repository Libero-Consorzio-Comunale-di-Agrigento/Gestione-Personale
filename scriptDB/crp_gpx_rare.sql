CREATE OR REPLACE package GPX_RARE is
procedure INIT_IBAN(par_stringa varchar2);
procedure INIT_CIN(par_cin_ita in varchar2, par_stringa in varchar2);
procedure MSG_CONTO_CORRENTE(par_stringa in varchar2);
procedure CHK_CIN(par_cin in varchar2, par_stringa in varchar2);
procedure MSG_CIN_ITA(par_cin_ita in varchar2, par_stringa in varchar2);
end;
/

CREATE OR REPLACE package body GPX_RARE is
procedure INIT_IBAN(par_stringa in varchar2)is
begin
   raise_application_error(-20997,'#IT#');
end;
procedure INIT_CIN(par_cin_ita in varchar2, par_stringa in varchar2)is
begin
   raise_application_error(-20997,'#'||calcola_cin(par_stringa)||'#');
end;
procedure MSG_CONTO_CORRENTE(par_stringa in varchar2)is
begin
   raise_application_error(-20999,'Attenzione Verifica il valore del CC');
end;
procedure MSG_CIN_ITA(par_cin_ita in varchar2, par_stringa in varchar2) is
begin
   if par_cin_ita is not null and calcola_cin(par_stringa) != par_cin_ita then
 
      raise_application_error(-20998,'Valore del CIN consentito '||calcola_cin(par_stringa));

   end if;
end;
procedure CHK_CIN(par_cin in varchar2, par_stringa in varchar2) is
temp_pronta_cassa varchar2(2);
begin
  begin
  select pronta_cassa
  into   temp_pronta_cassa
  from   istituti_credito
  where  codice = par_stringa;
  end;
   if par_cin is null and temp_pronta_cassa not in ('PASSC' ,'SI') then
      
      raise_application_error(-20999,'Dato Obbligatorio. Inserire Codice Iban.');
   
   end if;
end;

END;
/
