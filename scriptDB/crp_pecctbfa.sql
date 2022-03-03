CREATE OR REPLACE PACKAGE pecctbfa IS
/******************************************************************************
 NOME:        PECCTBFA
 DESCRIZIONE: Creazione della tabella di lavoro per denunce fiscali di fine anno.
              Creazione della tabella di lavoro  da cui estrarre gli individui da
              elaborare. Viene clonata dalla vista REPORT_FISCALE_ANNO, rispettandone
              le chiavi di ordinamento.
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003             

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 passo in number);
end;
/

CREATE OR REPLACE PACKAGE BODY pecctbfa IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 20/01/2003';
END VERSIONE;
procedure main (prenotazione in number,
	   			 	   passo in number) is
	begin
    begin
	si4.sql_execute('truncate table tabella_fiscale_anno');
	end;
  begin
  insert into TABELLA_FISCALE_ANNO 
  select ci
       , anno
       , s1
       , c1
       , d1
       , s2
       , c2
       , d2
       , s3
       , c3
       , d3
       , s4
       , c4
       , d4
       , s5
       , c5
       , nvl(d5,' ') d5
       , s6
       , c6
       , nvl(d6,' ') d6
    from report_fiscale_anno ;
  end;
begin
si4.sql_execute('drop index tbfa_ik');
exception when others then null;
end;
begin
si4.sql_execute('create index tbfa_ik on tabella_fiscale_anno (anno)');
end;
end;
end;
/

