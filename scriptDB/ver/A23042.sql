alter table periodi_giuridici
add delibera varchar2(4)
/

alter table calcoli_retributivi
add delibera varchar2(4)
/

alter table periodi_retributivi
add delibera varchar2(4)
/

alter table periodi_giuridici enable all triggers;

