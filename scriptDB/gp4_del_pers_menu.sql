/* Eliminazione voci di menù già disabilitate per il Cliente 
   ---------------------------------------------------------

Elimina eventuali Voci Menu, eventualmente inserite con Ruolo "AMM" in fase di Installazione Moduli, e precedentemente eliminate dal Ruolo "*", perchè non abilitabili al Cliente.

*/

delete from a_menu x
where applicazione = 'GP4'
  and not exists
     (select 'x' from a_menu
       where applicazione = 'GP4'
         and ruolo        = '*'
         and voce_menu    = x.voce_menu
     )
/