/* Cancellazione Personalizzaione per Comune di Pesaro  - Prov. Pesaro e AMI */
delete from a_voci_menu where voce_menu = 'PXCPESCP';
delete from a_passi_proc where voce_menu = 'PXCPESCP';    
delete from a_selezioni where voce_menu = 'PXCPESCP';
delete from a_menu where voce_menu = 'PXCPESCP';
delete  from gp4_personalizzazioni where voce_menu  = 'PXCPESCP';

/* Cancellazione Personalizzaione per Usl Urbino */
delete from a_voci_menu where voce_menu = 'PXMA05CP';
delete from a_passi_proc where voce_menu = 'PXMA05CP';    
delete from a_selezioni where voce_menu = 'PXMA05CP';
delete from a_menu where voce_menu = 'PXMA05CP';
delete from gp4_personalizzazioni where voce_menu = 'PXMA05CP';

/* Cancellazione Personalizzaione per Usl Siena */
delete from a_voci_menu where voce_menu = 'PXTO30CP';
delete from a_passi_proc where voce_menu = 'PXTO30CP';    
delete from a_selezioni where voce_menu = 'PXTO30CP';
delete from a_menu where voce_menu = 'PXTO30CP';
delete from gp4_personalizzazioni where voce_menu = 'PXTO30CP';

/* Cancellazione Personalizzaione per comune di Rimini */
delete from a_voci_menu where voce_menu = 'PXHARRCP';
delete from a_passi_proc where voce_menu = 'PXHARRCP';    
delete from a_selezioni where voce_menu = 'PXHARRCP';
delete from a_menu where voce_menu = 'PXHARRCP';
delete from gp4_personalizzazioni where voce_menu = 'PXHARRCP';

/* presente solo il pks e in gp4_personalizzazioni ma non la voce di menu */
delete from gp4_personalizzazioni where voce_menu = 'PXCAMICP';

/* PXCSLACP presente solo il pks */

/* Cancellazione Personalizzaione per Brunico e Bressanone non abilitata da noi */
delete from a_voci_menu where voce_menu = 'PXTRBRCP';
delete from a_passi_proc where voce_menu = 'PXTRBRCP';
delete from a_selezioni where voce_menu = 'PXTRBRCP';
delete from a_menu where voce_menu = 'PXTRBRCP';
delete from a_catalogo_stampe where stampa = 'PXTRBRCP';
delete from gp4_personalizzazioni where voce_menu = 'PXTRBRCP';
