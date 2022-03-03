update a_voci_menu set guida_o = 'P_SDOOR'
where voce_menu = 'PDOSDOOR';

delete from A_GUIDE_O where guida_o = 'P_SDOOR';

INSERT INTO A_GUIDE_O
( GUIDA_O, SEQUENZA, ALIAS, LETTERA, TITOLO, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO )
VALUES ( 'P_SDOOR', 1, 'PREN', 'P', 'Prenot.', NULL, 'ACAEPRPA', '*', NULL, NULL); 
INSERT INTO A_GUIDE_O
( GUIDA_O, SEQUENZA, ALIAS, LETTERA, TITOLO, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO )
VALUES ( 'P_SDOOR', 2, 'REDO', 'R', 'Revisioni', NULL, 'PDODREDO', NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O
( GUIDA_O, SEQUENZA, ALIAS, LETTERA, TITOLO, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO )
 VALUES ( 'P_SDOOR', 3, 'GEST', 'G', 'El. Gest.', NULL, 'PGMEGEST', NULL, NULL, NULL); 

update a_selezioni
set alias = 'GEST'
  , gruppo_alias = 0
  , numero_fk = 1
where voce_menu = 'PDOSDOOR' 
  and parametro = 'P_GESTIONE';

update a_selezioni
set alias = 'REDO'
  , gruppo_alias = 0
  , numero_fk = 1
where voce_menu = 'PDOSDOOR' 
  and parametro = 'P_REVISIONE';
