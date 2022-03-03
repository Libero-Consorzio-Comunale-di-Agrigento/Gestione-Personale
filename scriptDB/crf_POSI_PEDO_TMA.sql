CREATE OR REPLACE TRIGGER POSI_PEDO_TMA
AFTER UPDATE
OF RUOLO_DO
  ,PART_TIME
  ,CONTRATTO_OPERA
  ,SOVRANNUMERO
ON POSIZIONI
FOR EACH ROW
/******************************************************************************
   NAME:     Allinea i campi di PERIODI_DOTAZIONE in caso di modifica degli attributi
             della posizione giuridica
******************************************************************************/
declare
   d_tipo_part_time_note posizioni.tipo_part_time%type;
begin
   for pedo in (select ci
                      ,revisione
                      ,rilevanza
                      ,dal
                      ,rowid
                  from periodi_dotazione
                 where posizione = :new.codice)
   loop
      d_tipo_part_time_note := gp4_pegi.get_tipo_part_time(pedo.ci
                                                          ,pedo.rilevanza
                                                          ,pedo.dal);
      update periodi_dotazione
         set di_ruolo       = :new.ruolo_do
            ,part_time      = :new.part_time
            ,tipo_part_time = nvl(d_tipo_part_time_note
                                 ,decode(:new.part_time
                                        ,'SI'
                                        ,nvl(:new.tipo_part_time, 'O')))
            ,contrattista   = :new.contratto_opera
            ,sovrannumero   = :new.sovrannumero
       where rowid = pedo.rowid;
   end loop;
exception
   when others then
      raise;
end;
/
