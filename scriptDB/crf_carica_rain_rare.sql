CREATE OR REPLACE TRIGGER carica_rain_rare
AFTER insert  on rapporti_individuali for each row
declare
  temp           varchar2(2);
  temp1          varchar2(1);
  temp2          varchar2(1);
  temp_codice    varchar2(5);
  temp_sportello varchar2(5);
begin
  begin
   select nvl(min(codice),'PC')
   into   temp_codice
   from   istituti_credito
   where  pronta_cassa='SI'
   and    codice != '*';
  exception when no_data_found then
     temp_codice := 'PC';
  end;
  begin
   select nvl(min(sportello),'PC')
   into   temp_sportello
   from   sportelli spor,
          istituti_credito iscr
   where  spor.istituto     = iscr.codice
     and  iscr.codice       = temp_codice
     and  iscr.pronta_cassa = 'SI'
     and  sportello not like '*%';
  exception when no_data_found then
     temp_sportello := 'PC';
  end;
  begin
        select 'X' 
        into   temp2
        from   rapporti_diversi radi
        where  rilevanza='L' 
        and    :new.ci  =radi.ci_erede ;
        raise too_many_rows;
        exception
         when no_data_found then temp2:='Y';
         when too_many_rows then temp2:='X';
  end;
  select 'X'
    into temp1
    from rapporti_retributivi
	where :new.ci = ci;
  exception
    when no_data_found then
	begin
      select retributivo
        into temp
        from classi_rapporto clra
       where :new.rapporto =  clra.codice;
       if temp = 'SI' then
         insert into rapporti_retributivi_storici (ci,dal,matricola,istituto,sportello,spese,tipo_spese,tipo_ulteriori,utente,data_agg) values
                                                      (:new.ci,:new.dal,:new.ci,temp_codice,temp_sportello,99,'DD',null,'Aut.RAIN',sysdate);
       end if;
	end;
    if temp2='X' then
       delete rapporti_retributivi_storici where ci= :new.ci;
    end if;
end;
/

