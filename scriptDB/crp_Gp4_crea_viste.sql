CREATE OR REPLACE PACKAGE Gp4_crea_viste IS
/******************************************************************************
 NOME:          Package per la creazione delle viste di DESRE in new-install
 DESCRIZIONE:
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000
 1.1  17/06/2005 MS     Attivita 8828
 1.2  01/06/2007 ML     Passaggio parametro estrazione (A20438).
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE peccesre(parametro_nome_report varchar2);
PROCEDURE peclesre(P_estrazione varchar2);
end;
/
CREATE OR REPLACE PACKAGE BODY Gp4_crea_viste IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.2 del 01/06/2007';
 END VERSIONE;
procedure peclesre(P_estrazione varchar2) IS
cursor c_estrazione is
select estrazione
from estrazione_report
where num_ric >0
  and estrazione like upper(nvl(p_estrazione,'%'))
;
begin
for v_estrazione in c_estrazione LOOP
   peccesre(v_estrazione.estrazione);
END LOOP;
end;
procedure peccesre(parametro_nome_report varchar2)  is
begin
declare
comando      varchar2(32767);
comando_commento varchar2(32767);
comando_grant varchar2(32767);
cursor c_colonne (p_nome_report varchar2) is
select decode(escr.sequenza,1,'SELECT ','     , ')||
       decode( decode( escr.attributo
                     , 'C1', 'x'
                     , 'C2', 'x'
                     , 'C3', 'x'
                     , 'C4', 'x'
                     , 'S1', 'x'
                     , 'S2', 'x'
                     , 'S3', 'x'
                     , 'S4', 'x'
                     , 'D1', 'x'
                     , 'D2', 'x'
                     , 'D3', 'x'
                     , 'D4', 'x'
                          , null
                     )
             , 'x', 'nvl(rtrim(rpad('
                  , null
             )||
       substr(escr.colonna,1,length(escr.colonna))||
       decode( decode( escr.attributo
                     , 'C1', 'c'
                     , 'C2', 'c'
                     , 'C3', 'c'
                     , 'C4', 'c'
                     , 'S1', 's'
                     , 'S2', 's'
                     , 'S3', 's'
                     , 'S4', 's'
                     , 'D1', 'd'
                     , 'D2', 'd'
                     , 'D3', 'd'
                     , 'D4', 'd'
                          , null
                     )
             , 'c', ',15)),'' '')'
             , 's', ',15)),0)'
             , 'd', ',60)),'' '')'
                  , null
             )||' '||
       escr.attributo     attributo_totale
  from estrazione_crea_report escr
 where estrazione = upper(p_nome_report)
   and tipo       = 'C'
 order by escr.sequenza
;
cursor c_colonne2 (p_nome_report varchar2) is
select 'SELECT ''x'' colonna' etichetta
  from estrazione_report
 where estrazione = upper(p_nome_report)
   and num_ric   != 0
   and not exists
      (select 'x'
         from estrazione_crea_report escr
        where estrazione = upper(p_nome_report)
          and tipo       = 'C'
      )
;
cursor c_colonne3 (p_nome_report varchar2) is
select decode(escr.sequenza,1,'  FROM ','     , ')||
       rpad(escr.colonna,30,' ')||' '||escr.oggetto oggetto_totale
  from estrazione_crea_report escr
 where estrazione = upper(p_nome_report)
   and tipo       = 'T'
 order by escr.sequenza,escr.colonna,escr.oggetto;
cursor c_colonne4 (p_nome_report varchar2) is
select ' WHERE 1 = 1' where1
  from estrazione_report
 where estrazione = upper(p_nome_report)
   and num_ric   != 0
;
cursor c_colonne5 (p_nome_report varchar2) is
select '   '||rece.condizione condizione_totale
  from relazione_cond_estrazione rece
 where rece.estrazione = upper(p_nome_report)
   and exists
      (select 'x'
         from estrazione_crea_report escr
        where escr.estrazione = rece.estrazione
          and escr.tipo       = 'T'
          and escr.oggetto    = rece.oggetto
      )
order by rece.oggetto,rece.sequenza
;
cursor c_colonne6 (p_nome_report varchar2) is
select '   '||substr(escr.colonna,1,length(escr.colonna)) colonna_totale
  from estrazione_crea_report escr
 where escr.estrazione = upper(p_nome_report)
   and escr.tipo       = 'W'
 order by escr.attributo, escr.sequenza;
cursor c_colonne7 (p_nome_report varchar2) is
select decode(escr.oggetto, escr.sequenza,' GROUP BY ','        , ')||
       substr(escr.colonna,1,length(escr.colonna)) groupby
  from estrazione_crea_report escr
 where escr.estrazione = upper(p_nome_report)
   and escr.tipo       = 'G'
 order by escr.sequenza;
cursor c_colonne8 (p_nome_report varchar2) is
select 'COMMENT ON TABLE REPORT_'||upper(p_nome_report)||' IS '||
       ''''||descrizione||''''   commento
  from estrazione_report
 where estrazione = upper(p_nome_report)
   and num_ric   != 0;
cursor c_colonne9 (p_nome_report varchar2) is
select 'GRANT SELECT ON REPORT_'||upper(p_nome_report)||' TO PUBLIC' grant1
  from estrazione_report
 where estrazione = upper(p_nome_report)
   and num_ric   != 0;
begin
--Inserimento campi di estrazione
insert
  into estrazione_crea_report
     ( estrazione
     , tipo
     , attributo
     , oggetto
     , colonna
     , sequenza
     )
select reae.estrazione
     , 'C'
     , nvl(reae.alias,substr(reat.attributo,instr(reat.attributo,'.')+1))
     , reat.oggetto
     , reat.colonna
     , reae.sequenza + 2
  from relazione_attributi       reat
     , relazione_attr_estrazione reae
 where reat.attributo =  reae.attributo
   and reae.estrazione=  upper(parametro_nome_report)
   and not exists
       ( select 'x'
           from estrazione_crea_report
          where estrazione =     upper(parametro_nome_report)
            and attributo  = nvl(reae.alias,substr( reat.attributo
                                                   ,instr(reat.attributo,'.')+1
                                                  )
                                )
       )
;
-- INSERIMENTO campi chiave di ordinamento
insert
  into estrazione_crea_report
     ( estrazione
     , tipo
     , attributo
     , oggetto
     , colonna
     , sequenza
     )
select rees.estrazione
     , 'C'
     , reac.alias||rees.sequenza
     , reat.oggetto
     , reat.colonna
     , 10000 + rees.sequenza * 1000 + reac.sequenza
  from relazione_attributi   reat
     , relazione_attr_chiave reac
     , relazione_chiavi_estrazione rees
 where reat.attributo   = reac.attributo
   and reac.chiave      = rees.chiave
   and rees.estrazione  = upper(parametro_nome_report)
;
-- Modifica ESTRAZIONE_CREA_REPORT mettendo la sequenza = 1 in primo campo
update estrazione_crea_report
  set  sequenza = 1
where estrazione = upper(parametro_nome_report)
  and tipo       = 'C'
  and sequenza =
     (select min(sequenza)
        from estrazione_crea_report
       where estrazione  = upper(parametro_nome_report)
         and tipo        = 'C'
     )
;
-- Inserimento oggetto di riferimento principale dell'estrazione
insert
  into estrazione_crea_report
     ( estrazione
     , tipo
     , oggetto
     , colonna
     , sequenza
     )
select esre.estrazione
     , 'T'
     , reog.oggetto
     , reog.tabella
     , 3
  from relazione_oggetti reog
     , estrazione_report esre
 where reog.oggetto    = esre.oggetto
   and esre.estrazione = upper(parametro_nome_report)
   and esre.num_ric   != 0
;
-- Inserimento oggetti relativi ai campi di estrazione
insert
  into estrazione_crea_report
     ( estrazione
     , tipo
     , oggetto
     , colonna
     , sequenza
     )
select distinct escr.estrazione
              , 'T'
              , reog.oggetto
              , reog.tabella
              , 2
  from relazione_oggetti      reog
     , estrazione_crea_report escr
 where escr.tipo       = 'C'
   and escr.estrazione = upper(parametro_nome_report)
   and reog.oggetto    = escr.oggetto
   and not exists
      (select 'x'
         from estrazione_crea_report
        where estrazione = escr.estrazione
          and sequenza   = 3
          and tipo       = 'T'
          and oggetto    = escr.oggetto
      )
;
-- Inserimento oggetti secondari per l'estrazione sui quali esistono condizioni di relazione
insert
  into estrazione_crea_report
     ( estrazione
     , tipo
     , oggetto
     , colonna
     , sequenza
     )
select reoe.estrazione
     , 'T'
     , reoe.oggetto
     , reog.tabella
     , 2
  from relazione_oggetti         reog
     , relazione_oggetti_estrazione reoe
 where reog.oggetto    = reoe.oggetto
   and reoe.estrazione = upper(parametro_nome_report)
   and not exists
      (select 'x'
         from estrazione_crea_report
        where estrazione = reoe.estrazione
          and tipo       = 'T'
          and oggetto    = reoe.oggetto
      )
;
/* Inserimento oggetti trasversali dell'estrazione
             con relazione indiretta tra due oggetti gia` presenti
  L'oggetto e` da inserire se:
  - non e` gia' previsto
  - ha una relazione trasversale con altri due oggetti presenti
    che non abbiano una relazione diretta fra di loro
    e non siano in relazione con altri oggetti gia' presenti.*/
insert
  into estrazione_crea_report
     ( estrazione
     , tipo
     , oggetto
     , colonna
     , sequenza
     )
select distinct upper(parametro_nome_report)
     , 'T'
     , reog.oggetto
     , reog.tabella
     , 2
  from relazione_oggetti      reog
     , relazione_rife_oggetto rero
 where reog.oggetto = rero.oggetto
   and not exists
      (select 'x'
         from estrazione_crea_report
        where estrazione = upper(parametro_nome_report)
          and tipo       = 'T'
          and oggetto    = rero.oggetto
      )
   and rero.riferimento in
      (select oggetto
         from estrazione_crea_report escr
        where escr.estrazione = upper(parametro_nome_report)
          and escr.tipo       = 'T'
      )
   and exists
      (select 'x'
         from relazione_rife_oggetto rero2
        where rero2.oggetto      =  rero.oggetto
          and rero2.riferimento in
             (select escr2.oggetto
                from estrazione_crea_report escr2
               where escr2.estrazione = upper(parametro_nome_report)
                 and escr2.tipo       = 'T'
                 and escr2.oggetto   != rero.riferimento
                 and not exists
                    (select 'x'
                       from estrazione_crea_report escr3
                          , relazione_rife_oggetto rero3
                      where escr3.oggetto = rero3.riferimento
                        and rero3.oggetto = escr2.oggetto
                    )
             )
          and not exists
             (select 'x'
                from relazione_rife_oggetto rero4
               where rero4.oggetto    = rero.riferimento
                 and rero4.riferimento= rero2.riferimento
             )
      )
;
-- Modifica ESTRAZIONE_CREA_REPORT mettendo la sequenza = 1 in prima tabella
update estrazione_crea_report
  set  sequenza = 1
where estrazione = upper(parametro_nome_report)
  and tipo       = 'T'
  and to_char(sequenza)||colonna||oggetto =
     (select min(to_char(sequenza)||colonna||oggetto)
        from estrazione_crea_report
       where estrazione  = upper(parametro_nome_report)
         and tipo        = 'T'
     )
;
/* Inserimento condizioni relative agli oggetti
             Attiva le relazioni abbinate all'oggetto in considerazione
             con un oggetto di riferimento se:
               - si considera l'oggetto principale dell'estrazione
               - si tratta di una relazione su se stesso
               - non esiste una relazione dell'oggetto di riferimento con
                 con un altro oggetto gia` in relazione con l'oggetto in
                 considerazione*/
insert
  into estrazione_crea_report
     ( estrazione
     , tipo
     , attributo
     , colonna
     , sequenza
     )
select upper(parametro_nome_report)
     , 'W'
     , max(reco.oggetto||reco.riferimento)
     , reco.relazione
     , reco.sequenza
  from relazione_cond_oggetto reco
 where reco.oggetto in
      (select oggetto
         from estrazione_crea_report
        where estrazione = upper(parametro_nome_report)
          and tipo       = 'T'
      )
   and reco.riferimento in
      (select oggetto
         from estrazione_crea_report
        where estrazione = upper(parametro_nome_report)
          and tipo       = 'T'
      )
   and (   reco.oggetto =
          (select oggetto
             from estrazione_report
            where estrazione = upper(parametro_nome_report)
          )
        or reco.oggetto = reco.riferimento
        or not exists
          (select 'x'
             from relazione_rife_oggetto
            where oggetto     = reco.oggetto
              and oggetto    != riferimento
              and riferimento in
                 (select riferimento
                    from relazione_rife_oggetto
                   where oggetto     = reco.riferimento
                     and riferimento in
                        (select oggetto
                           from estrazione_crea_report
                          where estrazione = upper(parametro_nome_report)
                            and tipo       = 'T'
                        )
                 )
          )
       )
group by sequenza,relazione
;
/* Select dell'eventuale group by
        da inserire in caso
        esistano dei campi con funzioni di gruppo
       e campi non con funzione di gruppo*/
insert
  into estrazione_crea_report
     ( estrazione
     , tipo
     , colonna
     , sequenza
     )
select escr.estrazione
     , 'G'
     , escr.colonna
     , escr.sequenza
  from estrazione_crea_report escr
 where estrazione = upper(parametro_nome_report)
   and tipo       = 'C'
   and instr(upper(colonna),'MAX(')   = 0
   and instr(upper(colonna),'MIN(')   = 0
   and instr(upper(colonna),'SUM(')   = 0
   and instr(upper(colonna),'COUNT(') = 0
   and instr(upper(colonna),'AVG(')   = 0
   and upper(colonna)               != 'NULL'
   and exists
      (select 'x'
         from estrazione_crea_report
        where estrazione = escr.estrazione
          and tipo       = 'C'
          and (   instr(upper(colonna),'MAX(')   != 0
               or instr(upper(colonna),'MIN(')   != 0
               or instr(upper(colonna),'SUM(')   != 0
               or instr(upper(colonna),'COUNT(') != 0
               or instr(upper(colonna),'AVG(')   != 0
              )
      )
;
-- Modifica su ESTRAZIONE_CREA_REPORT mettendo la minor sequenza in oggetto
update estrazione_crea_report
  set  oggetto = (select min(sequenza)
                    from estrazione_crea_report
                   where estrazione  = upper(parametro_nome_report)
                     and tipo        = 'G'
                 )
where estrazione = upper(parametro_nome_report)
  and tipo       = 'G'
;
--Emissione su SPOOL dell'eseguibile per creazione VIEW
-- Select del contenuto di ESTRAZIONE_CREA_REPORT
-- Creazione nuova vista
comando := 'CREATE OR REPLACE VIEW REPORT_' || parametro_nome_report || ' AS ';
for v_colonne in c_colonne (parametro_nome_report) loop
 comando := comando||chr(10)||v_colonne.attributo_totale ;
end loop;
for v_colonne2 in c_colonne2 (parametro_nome_report) loop
 comando := comando|| v_colonne2.etichetta;
end loop;
for v_colonne3 in c_colonne3 (parametro_nome_report) loop
 comando :=  comando||chr(10)||v_colonne3.oggetto_totale;
end loop;
for v_colonne4 in c_colonne4(parametro_nome_report) loop
 comando :=  comando||chr(10)||v_colonne4.where1;
end loop;
for v_colonne5 in c_colonne5(parametro_nome_report) loop
 comando :=  comando||chr(10)||v_colonne5.condizione_totale;
end loop;
for v_colonne6 in c_colonne6(parametro_nome_report) loop
 comando :=  comando||chr(10)||v_colonne6.colonna_totale;
end loop;
for v_colonne7 in c_colonne7(parametro_nome_report) loop
 comando :=  comando||chr(10)||v_colonne7.groupby;
 end loop;
-- Commento alla vista
for v_colonne8 in c_colonne8(parametro_nome_report) loop
 comando_commento :=  v_colonne8.commento ;
end loop;
-- Grant
for v_colonne9 in c_colonne9(parametro_nome_report) loop
 comando_grant :=  v_colonne9.grant1;
end loop;
rollback;
BEGIN
si4.sql_execute(comando);
EXCEPTION WHEN OTHERS THEN NULL;
END;
BEGIN
si4.sql_execute(comando_commento);
EXCEPTION WHEN OTHERS THEN NULL;
END;
BEGIN
si4.sql_execute(comando_grant);
EXCEPTION WHEN OTHERS THEN NULL;
END;
end;
end;
end;
/
