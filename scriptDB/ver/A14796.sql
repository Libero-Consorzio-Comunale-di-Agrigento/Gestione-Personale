delete from a_passi_proc a1
 where voce_menu in (select distinct voce_menu from a_passi_proc where modulo = 'PECCMORE')
   and modulo = 'ACACANAS'
   and exists (select 'x' from a_passi_proc a2
                where a2.voce_menu = a1.voce_menu
                  and a2.modulo = 'PECSAPST'
                  and a2.passo = a1.passo -1)
;

delete from a_passi_proc
 where voce_menu in (select distinct voce_menu from a_passi_proc where modulo = 'PECCMORE')
   and modulo = 'PECSAPST'
;

declare d_passo NUMBER;
begin
     for CURV in
        (select distinct voce_menu
           from A_PASSI_PROC a1
          where modulo = 'PECCMORE'
        ) LOOP
          begin
                select max(passo) + 1
                  into d_passo
                  from A_PASSI_PROC
                 where voce_menu = curv.voce_menu
                   and modulo = 'ACACANRP'
                   and passo < 90
                ;
          end;
          for CURM in
             (select passo
                from a_passi_proc
               where voce_menu = curv.voce_menu
                 and passo between d_passo + 1 and 89
               order by passo
              ) LOOP
                begin
                update a_passi_proc
                   set passo = d_passo
                 where voce_menu = curv.voce_menu
                   and passo = curm.passo
                ;
                d_passo := d_passo + 1;
                end;
          end loop;
     end loop;
end;
.
/

                
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

