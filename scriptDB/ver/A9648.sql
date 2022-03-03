alter table familiari add ( intestatario  VARCHAR2(2)
                          , origine       VARCHAR2(30)
                          );

update familiari set intestatario = 'NO';

alter table familiari modify intestatario default 'NO' NOT NULL ;