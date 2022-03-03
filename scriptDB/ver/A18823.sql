delete from A_PASSI_PROC where voce_menu = 'PGMSDOPE';

insert into A_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('PGMSDOPE', 1, 'Situazione parametrica di Dotazione', null, null, 'F', 'PGMCDOPE', null, null, 'N');
insert into A_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('PGMSDOPE', 2, 'Situazione parametrica di Dotazione', null, null, 'R', 'PGMSDOPE', null, 'PGMSDOPE', 'N');
insert into A_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('PGMSDOPE', 3, 'Situazione parametrica di Dotazione', null, null, 'Q', 'PGMDCADO', null, null, 'N');
insert into A_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('PGMSDOPE', 91, 'Errore in Elaborazione', null, null, 'R', 'ACARAPPR', null, 'PGMCDOER', 'N');
insert into A_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('PGMSDOPE', 92, 'Cancellazione Errori', null, null, 'Q', 'ACACANRP', null, null, 'N');

insert into A_CATALOGO_STAMPE (STAMPA, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_PROPRIETA, TIPO_VISURA, CLASSE, STAMPA_BLOCCATA, STAMPA_PROTETTA, SEQUENZIALE)
values ('PGMCDOER', 'ERRORI CALCOLO DOTAZIONE', null, null, 'U', 'U', 'A_C', 'N', 'N', 'S');
