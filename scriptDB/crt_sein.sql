create table sedi_inail
( Codice 	      Varchar2(15)
 ,Descrizione	Varchar2(30)
 ,Cod_provincia	Number(3)
 ,Cod_comune	Number(3)
 ,Indirizzo	      Varchar2(40)
 ,Cap     	      Varchar2(5)
 ,Num_civico	Varchar2(8)
);
create index sein_pk on sedi_inail (codice);
