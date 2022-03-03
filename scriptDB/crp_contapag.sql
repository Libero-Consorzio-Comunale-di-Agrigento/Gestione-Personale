CREATE OR REPLACE PACKAGE CONTAPAG IS

/* funzioni utilizzate in interfaccia web su piattaforma UNIX o LINUX */

function valore(pdesname in varchar2)  return number;
procedure inizializza(pno_prenotazione in number,pdesname in varchar2);
procedure incrementa(pdesname in varchar2);

/* funzioni utilizzate in interfaccia web su piattaforma WINDOWS */

numpag number(10);
function valore  return number;
procedure inizializza;
procedure incrementa;
end;
/


CREATE OR REPLACE PACKAGE body CONTAPAG IS

/* funzioni utilizzate in interfaccia web su piattaforma UNIX o LINUX */

function valore(pdesname in varchar2) return number is
  ret_value number;		 		 
begin
  select to_number(substr(testo,instr(testo,'=')+1))
     into ret_value
     from a_prenotazioni_log
    where testo like pdesname||'=%'  
	  and sequenza = 0
	  ;
  return ret_value;
end;

procedure inizializza(pno_prenotazione in number,pdesname in varchar2) is
begin
  delete a_prenotazioni_log where sequenza = 0 and no_prenotazione=pno_prenotazione;
  insert into a_prenotazioni_log ( NO_PRENOTAZIONE, SEQUENZA, TESTO )
  values (pno_prenotazione,0,pdesname||'=1');
  commit;
end;

procedure incrementa(pdesname in varchar2) is
begin
  update a_prenotazioni_log set testo = (
     select pdesname||'='||to_char(to_number(substr(testo,instr(testo,'=')+1))+1)
     from a_prenotazioni_log
    where testo like pdesname||'=%'  
	  and sequenza = 0)
	where testo like pdesname||'=%'  
	  and sequenza =   0;
  commit;
end;

/* funzioni utilizzate in interfaccia web su piattaforma WINDOWS */

function valore return number is
begin
  return numpag;
end;
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V2.0 del 10/08/2006';
 END VERSIONE;
procedure inizializza is
begin
  numpag := 1;
end;
procedure incrementa is
begin
  numpag := numpag+1;
end;
END CONTAPAG;
/
