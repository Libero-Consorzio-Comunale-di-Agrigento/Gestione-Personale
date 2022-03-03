-- Eliminazione della voce CEVIN sostituita da CDEIN

delete from a_voci_menu where voce_menu = 'PECCEVIN';
delete from a_passi_proc where voce_menu = 'PECCEVIN';
delete from a_selezioni where voce_menu = 'PECCEVIN';
delete from a_menu where voce_menu = 'PECCEVIN';