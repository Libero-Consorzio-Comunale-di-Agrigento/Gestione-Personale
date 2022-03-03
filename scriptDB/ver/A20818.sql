DECLARE
  out_valore  varchar2(200);
BEGIN
  si4_registro_utility.leggi_stringa('DB_USERS/'||user,'Tipo Invio Mail',out_valore, false);  
  IF nvl(out_valore,' ') = ' ' THEN
	  BEGIN
			si4_registro_utility.scrivi_stringa('DB_USERS/'||user,'Tipo Invio Mail', 'mail' ,'INOLTRO CEDOLINO MAIL: Tag Mail',false);
		EXCEPTION WHEN OTHERS THEN
			if instr(sqlerrm,'ORA-20922') != 0 then	/* Non esiste la chiave, quindi la creo */
				si4_registro_utility.crea_chiave('DB_USERS/'||user);
			end if;	
			si4_registro_utility.scrivi_stringa('DB_USERS/'||user,'Tipo Invio Mail', 'mail' ,'INOLTRO CEDOLINO MAIL: Tag Mail',false);			
		END;
  END IF;
  COMMIT;
END;
/
