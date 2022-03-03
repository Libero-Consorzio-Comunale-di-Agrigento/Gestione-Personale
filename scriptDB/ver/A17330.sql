insert into relazione_attributi
       (attributo,descrizione,oggetto,colonna)
values ('_PRONTA_CASSA','Sequenza di esposizione del tipo di accredito'
       ,'ISCR','decode(nvl(ISCR.pronta_cassa,''NO''),''NO'',1,2)');

insert into relazione_attributi
       (attributo,descrizione,oggetto,colonna)
values ('PRONTA_CASSA','Tipo di accredito'
       ,'ISCR','ISCR.pronta_cassa');
 
insert into relazione_attributi
       (attributo,descrizione,oggetto,colonna)
values ('PRONTA_CASSA_D','Descrizione del tipo di accredito'
       ,'ISCR','decode( nvl(ISCR.pronta_cassa,''NO''), ''NO'', ''Accredito in c/c'', ''Pronta Cassa'')');

insert into relazione_chiavi
       (chiave,descrizione,nome)
values ('PRONTA_CASSA','Tipo di Accredito','Pronta Cassa');

insert into relazione_attr_chiave
       (chiave,sequenza,attributo,descrizione,alias)
values ('PRONTA_CASSA',1,'_PRONTA_CASSA','Sequenza','S');

insert into relazione_attr_chiave
       (chiave,sequenza,attributo,descrizione,alias)
values ('PRONTA_CASSA',2,'PRONTA_CASSA','Codice','C');

insert into relazione_attr_chiave
       (chiave,sequenza,attributo,descrizione,alias)
values ('PRONTA_CASSA',3,'PRONTA_CASSA_D','Descrizione','D');
