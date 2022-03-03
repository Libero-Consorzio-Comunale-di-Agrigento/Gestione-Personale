start crp_peccmore_veneto.sql
start crp_peccmore10.sql
start crp_peccmore1.sql
start crp_peccmore.sql

update a_passi_proc a1
   set passo = passo + 2
 where voce_menu in (select distinct voce_menu from a_passi_proc where modulo = 'PECCMORE')
   and passo > (select max(a2.passo)
                  from a_passi_proc a2
                 where a2.voce_menu = a1.voce_menu
                   and a2.modulo = 'ACACANRP'
                   and a2.passo < 90)
   and passo < 90
;

insert into a_passi_proc
     ( voce_menu, passo, titolo, titolo_al1, titolo_al2
     , tipo, modulo, stringa, stampa, gruppo_ling)
select voce_menu, passo + 1, 'Stampa Casi Particolari', null, null
     , 'R', 'PECSAPST', null, 'PECSAPST', 'N'
  from a_passi_proc a1
 where voce_menu in (select distinct voce_menu from a_passi_proc where modulo = 'PECCMORE')
   and modulo = 'ACACANRP'
   and passo = (select max(a2.passo)
                  from a_passi_proc a2
                 where a2.voce_menu = a1.voce_menu
                   and a2.modulo = 'ACACANRP'
                   and a2.passo < 90)
;

insert into a_passi_proc
     ( voce_menu, passo, titolo, titolo_al1, titolo_al2
     , tipo, modulo, stringa, stampa, gruppo_ling)
select voce_menu, passo + 2, 'Cancellazione appoggio stampe', null, null
     , 'Q', 'ACACANAS', null, null, 'N'
  from a_passi_proc a1
 where voce_menu in (select distinct voce_menu from a_passi_proc where modulo = 'PECCMORE')
   and modulo = 'ACACANRP'
   and passo = (select max(a2.passo)
                  from a_passi_proc a2
                 where a2.voce_menu = a1.voce_menu
                   and a2.modulo = 'ACACANRP'
                   and a2.passo < 90)
;
