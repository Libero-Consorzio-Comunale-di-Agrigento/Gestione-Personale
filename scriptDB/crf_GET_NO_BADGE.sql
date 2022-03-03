DECLARE
D_cliente  varchar2(8);
V_comando  varchar2(32000);
BEGIN
  BEGIN
    SELECT substr(note,instr(note, 'Cliente=')+8,100)
      INTO D_cliente
      from ad4_enti
     where note  like '%Cliente%'
       and ente   = '&1'
     ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
     D_cliente := 'XXXX';
  END;
  IF D_cliente = 'ER09' THEN -- Reggio
-- dbms_output.put_line('Reggio');
     V_comando := ' CREATE OR REPLACE function get_no_badge(pci in number) return varchar2 is'
                ||'   badge_no number;'
                ||'begin'
                ||'   begin'
                ||'      select badge'
                ||'        into badge_no'
                ||'        from badge'
                ||'       where ci = pci'
                ||'       ;'
                ||'    exception when no_data_found then'
                ||'      badge_no := null;'
                ||'    end;'
                ||'    if badge_no is null then'
                ||'	   return ''01''||substr(lpad(to_char(pci),7,''0''),3,5);'
                ||'    else'
                ||'      return lpad(to_char(badge_no),7,''0'');'
                ||'    end if;'
                ||'end;';
  ELSE -- Altro cliente
-- dbms_output.put_line('Altro');
     V_comando := ' CREATE OR REPLACE function get_no_badge(pci in number) return varchar2 is'
                ||'   badge_no number;'
                ||'begin'
                ||'   begin'
                ||'	select numero_badge'
                ||'	  into badge_no'
                ||'	  from assegnazioni_badge'
                ||'	 where asba_id =  pci'
                ||'       ;'
                ||'    exception when no_data_found then'
                ||'      badge_no := null;'
                ||'    end;'
                ||'return badge_no;'
                ||'end;';
  END IF;
     si4.sql_execute(V_comando);
END;
/
