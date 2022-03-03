/* Eliminazione delle Voci di Menu non abilitate al Cliente */

delete from a_menu
where voce_menu     like 'PX%'
  and applicazione     = 'GP4'
  and not exists
     (select 'x'
        from gp4_personalizzazioni pers, ad4_enti ad4e
       where pers.voce_menu    = a_menu.voce_menu
	 and pers.tipo         = '+'
         and ad4e.note      like '%Cliente='||pers.cliente||'%'
         and ad4e.ente         = '&1'
     )
/
delete from a_menu
where applicazione = 'GP4'
  and voce_menu in
     (select voce_menu
        from gp4_personalizzazioni pers, ad4_enti ad4e
       where pers.tipo         = '-'
         and ad4e.note      like '%Cliente='||pers.cliente||'%'
         and ad4e.ente         = '&1'
     )
/