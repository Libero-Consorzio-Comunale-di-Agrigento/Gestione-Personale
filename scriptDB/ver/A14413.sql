-- Attività 14413

start crp_gp4gm.sql
start crp_gp4_unor.sql
start crp_gp4_reuo.sql

-- per poter eseguire le modifiche successive gli oggetti di DB devono 
-- essere tutti correttamente compilati
--
BEGIN
    utilitypackage.compile_all;
END;
/

-- salva le tabelle che vengono ricreate in base alla nuove reuo
--
create table reuo_ante_4814 as select * from relazioni_uo;
create table sett_ante_4814 as select * from settori;

BEGIN
    gp4gm.allinea_reuo;
end;
/

-- prima di ricreare SETTORI verifica se la tabella è allineata alla vista
-- e se i trigger di allineamento sono attivi
--

declare
v_comando     varchar2(4000);
v_trg_attivo  varchar2(1);
v_conta_diff  number(5);
v_versione varchar2(1);

begin

  BEGIN
-- estrazione della versione
  select '7'
    into v_versione
    from v$version
   where instr(upper(banner),'RELEASE')>0
     and substr(banner,7,1) = '7'
     and substr(banner,instr(upper(banner),'RELEASE ')+8,1)= '7'
      ;
   exception
   when no_data_found then
        v_versione := '8';
   END;

IF v_versione = '7' THEN
v_comando := 'CREATE OR REPLACE FORCE VIEW settori_view 
              (codice
              ,descrizione
              ,descrizione_al1
              ,descrizione_al2
              ,numero
              ,sequenza
              ,suddivisione
              ,gestione
              ,settore_g
              ,settore_a
              ,settore_b
              ,settore_c
              ,assegnabile
              ,sede
              ,cod_reg
              ) AS
  select  stam.codice  
         ,substr(gp4_unor.get_descrizione(stam.ni),1,30)  
		 ,substr(gp4_unor.get_descrizione_al1(stam.ni),1,30)  
		 ,substr(gp4_unor.get_descrizione_al2(stam.ni),1,30)  
		 ,stam.numero  
		 ,stam.sequenza  
		 ,decode(gp4_unor.get_livello(stam.ni,''GP4'',gp4_unor.get_dal(stam.ni)),0,0,1,1,2,2,3,3,4,4,4)  
		 ,stam.gestione  
		 ,decode( gp4_unor.get_livello(stam.ni,''GP4'',gp4_unor.get_dal(stam.ni))  
		         ,0,to_number(null)  
				 ,gp4_stam.GET_NUMERO_GESTIONE(stam.ni)  
				)  
		 ,decode( gp4_unor.get_livello(stam.ni,''GP4'',gp4_unor.get_dal(stam.ni))  
		         ,0,to_number(null)  
		         ,1,to_number(null)  
				   ,gp4_stam.get_settore_a(stam.ni)  
				)  
		 ,decode( gp4_unor.get_livello(stam.ni,''GP4'',gp4_unor.get_dal(stam.ni))  
		         ,0,to_number(null)  
		         ,1,to_number(null)  
		         ,2,to_number(null)  
				 ,gp4_stam.get_settore_b(stam.ni)  
				)  
		 ,decode( gp4_unor.get_livello(stam.ni,''GP4'',gp4_unor.get_dal(stam.ni))  
		         ,0,to_number(null)  
		         ,1,to_number(null)  
		         ,2,to_number(null)  
		         ,3,to_number(null)  
				   ,gp4_stam.get_settore_c(stam.ni)  
				)  
		 ,stam.assegnabile  
		 ,stam.sede  
		 ,to_char(null)  
  from    settori_amministrativi stam  
 where    exists  
        ( select ''x''  
		    from unita_organizzative  
		   where tipo   = ''P''  
		     and ottica = ''GP4''  
			 and ni     = gp4_stam.get_ni_numero(stam.numero)  
		)';
si4.sql_execute(v_comando);
ELSE

v_comando    := null;
v_trg_attivo := 'N';
v_conta_diff := 0;

begin
  select 'Y'
    into v_trg_attivo
    from user_triggers
   where trigger_name = 'SETTORI_TMA'
     and table_name = 'SETTORI'
     and status = 'ENABLED'
  ;
exception
  when no_data_found then v_trg_attivo := 'N';
end;

begin
  select count(*) 
    into v_conta_diff
    from settori x
   where not exists 
 (select 'x' from settori_view
   where codice = x.codice
     and numero = x.numero
     and suddivisione = x.suddivisione
     and gestione = x.gestione
     and assegnabile = x.assegnabile)
  ;
exception
  when no_data_found then v_conta_diff := 0;
end;

-- dbms_output.put_line('v_trg_attivo '||v_trg_attivo||' v_conta_diff '||v_conta_diff);

-- ricrea settori_view in ogni caso
--
v_comando := 'CREATE OR REPLACE FORCE VIEW settori_view 
             (codice
              ,descrizione
              ,descrizione_al1
              ,descrizione_al2
              ,numero
              ,sequenza
              ,suddivisione
              ,gestione
              ,settore_g
              ,settore_a
              ,settore_b
              ,settore_c
              ,assegnabile
              ,sede
              ,cod_reg
             ) AS
   SELECT gp4_unor.get_codice_uo (gp4_stam.get_ni_numero (stam.numero),''GP4'',gp4_unor.get_dal (stam.ni))
         ,SUBSTR (gp4_unor.get_descrizione (stam.ni), 1, 30)
         ,SUBSTR (gp4_unor.get_descrizione_al1 (stam.ni), 1, 30)
         ,SUBSTR (gp4_unor.get_descrizione_al2 (stam.ni), 1, 30)
         ,stam.numero
         ,stam.sequenza
         ,DECODE (gp4_unor.get_livello (stam.ni, ''GP4'', gp4_unor.get_dal (stam.ni) )
                 ,0, 0
                 ,1, 1
                 ,2, 2
                 ,3, 3
                 ,4, 4
                 ,4
                 )
         ,stam.gestione
         ,DECODE (gp4_unor.get_livello (stam.ni, ''GP4'', gp4_unor.get_dal (stam.ni) )
                 ,0, TO_NUMBER (NULL)
                 ,gp4_stam.get_numero_gestione (stam.ni)
                 ) settore_g
         ,DECODE (gp4_unor.get_livello (stam.ni, ''GP4'', gp4_unor.get_dal (stam.ni) )
                 ,0, TO_NUMBER (NULL)
                 ,1, TO_NUMBER (NULL)
                 ,gp4_stam.get_numero (gp4_reuo.get_ni_padre (gp4_unor.get_revisione (stam.ni)
                                                             ,stam.ni
                                                             ,1
                                                             )
                                      )
                 ) settore_a
         ,DECODE (gp4_unor.get_livello (stam.ni, ''GP4'', gp4_unor.get_dal (stam.ni) )
                 ,0, TO_NUMBER (NULL)
                 ,1, TO_NUMBER (NULL)
                 ,2, TO_NUMBER (NULL)
                 ,gp4_stam.get_numero (gp4_reuo.get_ni_padre (gp4_unor.get_revisione (stam.ni)
                                                             ,stam.ni
                                                             ,2
                                                             )
                                      )
                 ) settore_b
         ,DECODE (gp4_unor.get_livello (stam.ni, ''GP4'', gp4_unor.get_dal (stam.ni) )
                 ,0, TO_NUMBER (NULL)
                 ,1, TO_NUMBER (NULL)
                 ,2, TO_NUMBER (NULL)
                 ,3, TO_NUMBER (NULL)
                 ,gp4_stam.get_numero (gp4_reuo.get_ni_padre (gp4_unor.get_revisione (stam.ni)
                                                             ,stam.ni
                                                             ,3
                                                             )
                                      )
                 ) settore_c
         ,stam.assegnabile
         ,stam.sede
         ,TO_CHAR (NULL)
     FROM settori_amministrativi stam
    WHERE EXISTS (SELECT ''x''
                    FROM unita_organizzative
                   WHERE tipo = ''P''
                     AND ottica = ''GP4''
                     AND ni = gp4_stam.get_ni_numero (stam.numero) )';
si4.sql_execute(v_comando);

-- solo se i trigger sono attivi e se non esistevano diffrenze tra settori e settori_view
-- ricostruisce SETTORI sulla base di settori_view nuova
if v_trg_attivo = 'Y' and v_conta_diff = 0 then

-- dbms_output.put_line('allineo settori');
-- begin
-- for cur_gest in (select codice from gestioni gest
--                   where exists (select 'x' from settori
--                                  where gestione = gest.codice) )
--  loop
--   v_comando := ' begin gp4gm.allinea_settori('''||cur_gest.codice||'''); end;';
--   si4.sql_execute(v_comando);
--  end loop;
-- end;

begin
gp4gm.allinea_settori('');
end;

end if;

END IF; -- se versione 8
end;
/
