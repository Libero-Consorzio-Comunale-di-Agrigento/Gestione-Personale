update settori_amministrativi set assegnabile = 'SI'
where exists (select 'x' from periodi_giuridici
        where  settore=numero);