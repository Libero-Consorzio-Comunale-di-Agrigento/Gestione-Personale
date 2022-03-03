CREATE OR REPLACE TRIGGER SET_ANAG_TIPO_SOGGETTO
BEFORE INSERT OR UPDATE ON ANAGRAFICI FOR EACH ROW
declare
 dummy varchar2(1);
BEGIN
 begin
  select 'x'
  into   dummy
  from   dual
  where  exists (select 'x'
                 from    unita_organizzative unor
				 where   unor.ni = :NEW.NI);
  exception
   when no_data_found then null;				 
 end;
   IF :NEW.tipo_soggetto is null
   THEN
     IF :NEW.nome is null THEN
	  if dummy is not null then
       :NEW.tipo_soggetto := 'S';
	  else
	   :NEW.tipo_soggetto := 'E';
	  end if;  
     ELSE 
       :NEW.tipo_soggetto := 'I';
     END IF;
   END IF;
END;
/
CREATE OR REPLACE TRIGGER SET_RAIN_TIPO_SOGGETTO
BEFORE INSERT OR UPDATE ON RAPPORTI_INDIVIDUALI FOR EACH ROW
declare
 dummy varchar2(1);
BEGIN
 begin
  select 'x'
  into   dummy
  from   dual
  where  exists (select 'x'
                 from    unita_organizzative unor
				 where   unor.ni = :NEW.NI);
  exception
   when no_data_found then null;				 
 end;
   IF :NEW.tipo_ni is null
   THEN
     IF :NEW.nome is null THEN
       	  if dummy is not null then
       :NEW.tipo_ni := 'S';
	  else
	   :NEW.tipo_ni := 'E';
	  end if; 
     ELSE 
       :NEW.tipo_ni := 'I';
     END IF;
   END IF;
END;
/