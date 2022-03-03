CREATE OR REPLACE PACKAGE PECCSBRF IS
   PROCEDURE Main ( prenotazione Number, passo Number );
END;
/

CREATE OR REPLACE PACKAGE BODY PECCSBRF IS
   PROCEDURE Main ( prenotazione Number, passo Number ) is
   p_valore_default	varchar2(80);
   p_accrediti          varchar2(1);
   D_dummy              varchar2(1);
begin
  BEGIN  
    select substr(valore,1,4)
      into P_accrediti
         from a_parametri
     where no_prenotazione = prenotazione
       and parametro       = 'P_ACCREDITI'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
         P_accrediti := null;
  END;

if passo = 3 then
   BEGIN
     select 'X' 
       into D_dummy
      from dual
     where exists (select 'X' from a_appoggio_stampe 
                    where no_prenotazione = prenotazione
                      and no_passo = 3);
   EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
   END;
   IF D_dummy = 'X'  
   THEN 
      select 'PEC'||avme.acronimo||decode(P_accrediti,'A','A_1.txt','_1.txt')
        into p_valore_default
       from a_prenotazioni apre
          , a_voci_menu    avme
      where apre.no_prenotazione = prenotazione
        and apre.voce_menu       = avme.voce_menu;
   ELSE 
   update a_prenotazioni set prossimo_passo = 11
           where no_prenotazione = prenotazione;
   END IF;
else
  if passo = 5 then
        BEGIN
          select 'X' 
            into D_dummy
            from dual
          where exists (select 'X' from a_appoggio_stampe 
                         where no_prenotazione = prenotazione
                           and no_passo = 5);
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;
        IF D_dummy = 'X'  
        THEN 
        select 'PEC'||avme.acronimo||decode(P_accrediti,'A','A_2.txt','_2.txt')
          into p_valore_default
         from a_prenotazioni apre
            , a_voci_menu    avme
        where apre.no_prenotazione = prenotazione
          and apre.voce_menu       = avme.voce_menu;
        ELSE 
        update a_prenotazioni set prossimo_passo = 11
                where no_prenotazione = prenotazione;
        END IF;
  else
    if passo = 7 then
          BEGIN
            select 'X' 
              into D_dummy
              from dual
            where exists (select 'X' from a_appoggio_stampe 
                           where no_prenotazione = prenotazione
                             and no_passo = 7);
          EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
          END;
          IF D_dummy = 'X'  
          THEN 
          select 'PEC'||avme.acronimo||decode(P_accrediti,'A','A_3.txt','_3.txt')
            into p_valore_default
           from a_prenotazioni apre
              , a_voci_menu    avme
          where apre.no_prenotazione = prenotazione
            and apre.voce_menu       = avme.voce_menu;
          ELSE 
          update a_prenotazioni set prossimo_passo = 11
                  where no_prenotazione = prenotazione;
          END IF;
    else
      if passo = 9 then
            BEGIN
              select 'X' 
                into D_dummy
                from dual
              where exists (select 'X' from a_appoggio_stampe 
                             where no_prenotazione = prenotazione
                               and no_passo = 9);
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;
            IF D_dummy = 'X'  
            THEN 
            select 'PEC'||avme.acronimo||decode(P_accrediti,'A','A_4.txt','_4.txt')
              into p_valore_default
             from a_prenotazioni apre
                , a_voci_menu    avme
          where apre.no_prenotazione = prenotazione
            and apre.voce_menu       = avme.voce_menu;
            ELSE 
            update a_prenotazioni set prossimo_passo = 11
                    where no_prenotazione = prenotazione;
            END IF;
      else
        select 'PEC'||avme.acronimo||'.txt'
            into p_valore_default
           from a_prenotazioni apre
              , a_voci_menu    avme
          where apre.no_prenotazione  = prenotazione
            and apre.voce_menu   = avme.voce_menu;
      end if;
    end if;
  end if;
end if;
  update a_selezioni
     set valore_default = p_valore_default
   where parametro='TXTFILE'
     and voce_menu = (select voce_menu
	 	 		   	    from a_prenotazioni
					   where no_prenotazione = prenotazione
					  );
COMMIT;
end;
END;
/