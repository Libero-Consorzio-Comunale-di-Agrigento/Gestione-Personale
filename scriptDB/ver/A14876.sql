create table gest_4814
as select * from gestioni;

update gestioni set forma_giuridica = null;

alter table gestioni modify forma_giuridica varchar2(2);

update gestioni gest 
   set forma_giuridica = 
     (select lpad(forma_giuridica,2,'0')
        from gest_4814
       where codice = gest.codice);

start crp_pecsmdma.sql
  