CREATE OR REPLACE PACKAGE peconarf IS
   PROCEDURE Main ( prenotazione Number, passo Number );
END;
/

CREATE OR REPLACE PACKAGE BODY peconarf IS
   PROCEDURE Main ( prenotazione Number, passo Number ) is
   p_nome_file		varchar2(50);
   p_lunghezza		varchar2(20);
   p_substr			varchar2(20);
   p_voce_menu		varchar2(8);
   P_anno			number;
   P_periodo		number;
begin
select voce_menu
  into P_voce_menu
  from a_prenotazioni
 where no_prenotazione = prenotazione
 ;
BEGIN
select valore
  into P_anno
  from a_parametri
 where no_prenotazione = prenotazione
   and parametro = 'P_ANNO'
 ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
       select anno
         into P_anno
         from riferimento_retribuzione
        where rire_id = 'RIRE';
END;
select valore
  into P_periodo
  from a_parametri
 where no_prenotazione = prenotazione
   and parametro = 'P_PERIODO'
 ;
if passo = 2 then
   p_nome_file	:= 'CONTRIBUZIONE_'||P_ANNO||lpad(P_PERIODO,2,'0')||'.txt';
--   p_substr		:= 'NO';
--   p_lunghezza	:= '270';
elsif passo = 4 then
   p_nome_file	:= 'ANAGRAFICI_'||P_ANNO||lpad(P_PERIODO,2,'0')||'.txt';
--   p_substr		:= 'SI';
--   p_lunghezza	:= '270';
elsif p_anno = 2003 then 
   p_nome_file	:= 'ANAGRAFICI_31072003.txt';
--   p_substr		:= 'SI';
--   p_lunghezza	:= '270';
else 
   update a_prenotazioni 
      set prossimo_passo = 8
    where no_prenotazione = prenotazione;
end if;
  update a_selezioni
     set valore_default	= p_nome_file
   where parametro	='TXTFILE'
     and voce_menu	= p_voce_menu
                 ;
--  update a_selezioni
--     set valore_default	= p_substr
--   where parametro	='SE_SUBSTR'
--     and voce_menu	= p_voce_menu
--                 ;
--  update a_selezioni
--     set valore_default	= p_lunghezza
--   where parametro	='NUM_CARATTERI'
--     and voce_menu	= p_voce_menu
--                 ;
COMMIT;
end;
END;
/

