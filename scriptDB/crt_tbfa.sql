  create table TABELLA_FISCALE_ANNO as
  select ci , anno
       , s1 , c1 , d1
       , s2 , c2 , d2
       , s3 , c3 , d3
       , s4
       , c4
       , d4
       , s5
       , c5
       , nvl(d5,' ') d5
       , s6
       , c6
       , nvl(d6,' ') d6
    from report_fiscale_anno
/
create index tbfa_ik on tabella_fiscale_anno (anno)
/
