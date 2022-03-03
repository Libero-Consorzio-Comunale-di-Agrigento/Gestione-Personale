alter table informazioni_extracontabili add
( aut_ass_fam                     varchar2(2)      NULL
, aut_ded_fam                     varchar2(2)      NULL
);

update informazioni_extracontabili 
   set aut_ded_fam = 'SI'
;
update informazioni_extracontabili 
   set aut_ass_fam = 'SI'
  where nvl(ipn_fam_1ap,0) + nvl(ipn_fam_2ap,0) != 0
;

update informazioni_extracontabili 
   set aut_ass_fam = 'NO'
  where nvl(ipn_fam_1ap,0) + nvl(ipn_fam_2ap,0) = 0
;


alter table informazioni_extracontabili modify
( aut_ass_fam                     varchar2(2)      NOT NULL
, aut_ded_fam                     varchar2(2)      NOT NULL
);

insert into A_GUIDE_O
( GUIDA_O, SEQUENZA, ALIAS, LETTERA, TITOLO, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO )
values ('P_FAMI', 4, 'INEX', 'I', 'Inform.', 'P_INEX', null, null, null, null );

insert into A_GUIDE_V
( GUIDA_V, SEQUENZA, ALIAS, LETTERA, TITOLO, VOCE_MENU, VOCE_RIF, PROPRIETA)
values ('P_INEX', 1, 'CAFA', 'F', 'carichi Fam.', 'PECACAFA', null, null);
insert into A_GUIDE_V
( GUIDA_V, SEQUENZA, ALIAS, LETTERA, TITOLO, VOCE_MENU, VOCE_RIF, PROPRIETA)
values ('P_INEX', 2, 'INEX', 'X', 'eXtra c.', 'PECAINEX', null, null);

start crf_rire_cambio_anno.sql
start crp_peccmore1.sql
start crp_peccmocp1.sql
start crp_pecccafa.sql