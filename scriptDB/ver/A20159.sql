delete from A_GUIDE_O where guida_o = 'P_RIRE';

insert into A_GUIDE_O (GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1, TITOLO_ESTESO_AL2)
values ('P_RIRE', 1, 'RIRE', 'M', null, null, 'Mese', null, null, null, 'PECRMERE', null, null, null, null, null);

insert into A_GUIDE_O (GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1, TITOLO_ESTESO_AL2)
values ('P_NOIN', 1, 'RIRE', 'M', null, null, 'Mese', null, null, null, 'PECRMERE', null, null, null, null, null);
insert into A_GUIDE_O (GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1, TITOLO_ESTESO_AL2)
values ('P_NOIN', 2, 'NOIN', 'A', null, null, 'Aggiorn.', null, null, null, 'PECANOIN', null, null, null, null, null);

update a_voci_menu
set guida_o = 'P_NOIN'
where voce_menu = 'PECENOIN';
