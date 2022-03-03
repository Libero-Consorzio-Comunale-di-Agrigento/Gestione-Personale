-- trasco dello storico di POPI

declare 
d_coat_id     number; 
d_vaat_id     number; 
begin 
    delete from vaat_new 
	 where coat_id in 
	      (select coat_id 
		     from coat_new 
			where categoria      = 'POPI' 
		  ) 
	; 
    delete from coat_new where categoria = 'POPI' 
	; 
    for posti in 
	   ( select PIANTA 
               ,SETTORE 
               ,FIGURA 
               ,ATTIVITA 
               ,SEDE_POSTO 
               ,ANNO_POSTO 
               ,NUMERO_POSTO 
               ,POSTO 
               ,DAL 
               ,AL 
               ,ORE 
               ,SITUAZIONE 
               ,SEDE_PROV 
               ,ANNO_PROV 
               ,NUMERO_PROV 
               ,DISPONIBILITA 
               ,GRUPPO 
               ,STATO 
               ,NOTE 
               ,NOTE_AL1 
               ,NOTE_AL2 
		  from  posti_pianta 
		 where  stato in ('I','C','T') 
		 order  by situazione,sede_posto,anno_posto,numero_posto,posto,dal 
	   ) 
	loop 
	     select atgi_sq.nextval 
		   into d_coat_id 
		   from dual 
		 ; 
         insert into coat_new 
         ( 
           COAT_ID 
          ,CATEGORIA 
          ,ATTRIBUTO 
          ,DAL 
          ,AL 
          ,DESCRIZIONE 
          ,SEDE_DEL 
          ,ANNO_DEL 
          ,NUMERO_DEL 
          ,SEQUENZA 
          ,NOTE 
          ,UTENTE 
          ,DATA_AGG 
         ) values 
		 ( d_coat_id 
		  ,'POPI' 
		  ,posti.sede_posto||'-'||posti.numero_posto||'/'||substr(posti.anno_posto,3,2)||'.'||posti.posto 
		  ,posti.dal 
		  ,posti.al 
		  ,'ex Posto '||posti.sede_posto||'-'||posti.numero_posto||'/'||substr(posti.anno_posto,3,2)||'.'||posti.posto 
		  ,posti.sede_prov 
		  ,posti.anno_prov 
		  ,posti.numero_prov 
		  ,posti.posto 
		  ,posti.note||decode(posti.stato,'T','  Trasformato',' ') 
		  ,'Aut.POPI' 
		  ,sysdate 
		 ); 
	     select atgi_sq.nextval 
		   into d_vaat_id 
		   from dual 
		 ; 
		 insert into vaat_new 
		 ( VAAT_ID 
          ,COAT_ID 
          ,VARIABILE 
          ,TIPO 
          ,DESCRIZIONE 
,valore_default 
		 ) values 
		 ( d_vaat_id 
		  ,d_coat_id 
		  ,'POSTO' 
		  ,'N' 
		  ,'Numero Posto' 
,posti.posto 
		 ); 
	     select atgi_sq.nextval 
		   into d_vaat_id 
		   from dual 
		 ; 
		 insert into vaat_new 
		 ( VAAT_ID 
          ,COAT_ID 
          ,VARIABILE 
          ,TIPO 
          ,DESCRIZIONE 
,valore_default 
		 ) values 
		 ( d_vaat_id 
		  ,d_coat_id 
		  ,'FIGURA' 
		  ,'A' 
		  ,'Figura Professionale' 
,gp4_figi.get_codice(posti.figura,nvl(posti.al,sysdate)) 
		 ); 
	     select atgi_sq.nextval 
		   into d_vaat_id 
		   from dual 
		 ; 
		 insert into vaat_new 
		 ( VAAT_ID 
          ,COAT_ID 
          ,VARIABILE 
          ,TIPO 
          ,DESCRIZIONE 
,valore_default 
		 ) values 
		 ( d_vaat_id 
		  ,d_coat_id 
		  ,'ATTIVITA' 
		  ,'A' 
		  ,'Attivita' 
,posti.attivita 
		 ); 
	     select atgi_sq.nextval 
		   into d_vaat_id 
		   from dual 
		 ; 
		 insert into vaat_new 
		 ( VAAT_ID 
          ,COAT_ID 
          ,VARIABILE 
          ,TIPO 
          ,DESCRIZIONE 
,valore_default 
		 ) values 
		 ( d_vaat_id 
		  ,d_coat_id 
		  ,'SETTORE' 
		  ,'A' 
		  ,'Codice del Settore Amministrativo' 
,gp4_unor.get_codice_uo(gp4_stam.get_ni_numero(posti.settore),'GP4',nvl(posti.al,sysdate)) 
		 ); 
	     select atgi_sq.nextval 
		   into d_vaat_id 
		   from dual 
		 ; 
		 insert into vaat_new 
		 ( VAAT_ID 
          ,COAT_ID 
          ,VARIABILE 
          ,TIPO 
          ,DESCRIZIONE 
,valore_default 
		 ) values 
		 ( d_vaat_id 
		  ,d_coat_id 
		  ,'ORE' 
		  ,'N' 
		  ,'Ore settimanali' 
,posti.ore 
		 ); 
    end loop; 
    update coat_new coat 
	   set note = (select nvl(coat.note,' ')||'  '||nvl(note,' ') 
	                 from posti_pianta 
				    where stato      = 'R' 
				      and sede_posto||'-'||numero_posto||'/'||substr(anno_posto,3,2)||'.'||posto = coat.attributo 
					  and dal        = coat.al+1 
				  ) 
	 where dal = (select max(dal) 
	                from coat_new 
				   where attributo = coat.attributo 
				     and categoria = 'POPI' 
			     ) 
	   and categoria = 'POPI' 
	   and exists 
	      (select 'x' 
	         from posti_pianta 
			where stato      = 'R' 
			  and sede_posto||'-'||numero_posto||'/'||substr(anno_posto,3,2)||'.'||posto = coat.attributo 
			  and dal        = coat.al+1 
		  ); 
end;
/

commit;

-- trasco delle assegnazioni ai posti di pianta

declare 
d_coat_id          number; 
d_atgi_id          number; 
d_vaag_id          number; 
d_valore           varchar2(25); 
begin 
  delete from vaag_new 
   where vaat_id in 
   (select vaat_id 
      from vaat_new 
	 where coat_id in 
	 (select coat_id 
        from coat_new 
	   where categoria='POPI' 
	 ) 
   ); 
  delete from atgi_new 
   where coat_id in 
   (select coat_id 
      from coat_new 
	 where categoria='POPI' 
   ); 
  for pegi in 
     ( select pegi.ci 
	         ,pegi.rilevanza 
			 ,pegi.dal 
			 ,nvl(pegi.al,to_date(3333333,'j')) al 
			 ,pegi.sede_posto 
			 ,pegi.anno_posto 
			 ,pegi.numero_posto 
			 ,pegi.sede_posto||'-'||pegi.numero_posto||'/'||substr(pegi.anno_posto,3,2)||'.'||pegi.posto attributo 
			 ,popi.sede_prov            sede_del 
			 ,popi.anno_prov            anno_del 
			 ,popi.sede_prov            numero_del 
			 ,pegi.posto 
			 ,pegi.note 
--			 ,pegi.figura 
--			 ,pegi.settore 
--			 ,pegi.attivita 
--			 ,pegi.ore 
			 ,gp4_cost.get_ore_lavoro( gp4_figi.get_qualifica(pegi.figura,nvl(pegi.al,to_date(3333333,'j'))) 
			                          ,nvl(pegi.al,to_date(3333333,'j'))) ore_lavoro 
		 from periodi_giuridici    pegi 
		     ,posti_pianta         popi 
		where pegi.rilevanza         in ('Q','I') 
		  and pegi.sede_posto        is not null 
          and popi.sede_posto   = pegi.sede_posto 
	      and popi.anno_posto   = pegi.anno_posto 
		  and popi.numero_posto = pegi.numero_posto 
		  and popi.posto        = pegi.posto 
		  and nvl(pegi.al,sysdate) between popi.dal 
				                       and nvl(popi.al,to_date(3333333,'j')) 
		  and popi.stato in ('I','T','C') 
	--	  and ci = 903850 
	) 
  loop 
  dbms_output.put_line(pegi.ci||' '||pegi.dal||' '||pegi.attributo); 
      select coat_id 
	    into d_coat_id 
	    from coat_new 
	   where categoria = 'POPI' 
	     and attributo = pegi.attributo 
		 and pegi.al between dal and nvl(al,to_date(3333333,'j')) 
	  ; 
      select atgi_sq.nextval 
	    into d_atgi_id 
	    from dual 
	  ; 
      insert into atgi_new 
	  ( 
	     ATGI_ID 
        ,CI 
        ,RILEVANZA 
        ,DAL 
        ,COAT_ID 
        ,NOTE 
        ,SEDE_DEL 
        ,ANNO_DEL 
        ,NUMERO_DEL 
        ,UTENTE 
        ,DATA_AGG 
	  ) values 
	  ( d_atgi_id 
	   ,pegi.ci 
	   ,pegi.rilevanza 
	   ,pegi.dal 
	   ,d_coat_id 
	   ,pegi.note 
	   ,pegi.sede_del 
	   ,pegi.anno_del 
	   ,pegi.numero_del 
	   ,'Aut.PEGI' 
	   ,sysdate 
	  ); 
	  d_valore := to_char(null); 
	  for vaat in 
    	 (select vaat.vaat_id 
			    ,vaat.variabile 
			    ,vaat.valore_default 
		 from vaat_new  vaat 
		where vaat.coat_id               = d_coat_id 
		order by vaat.variabile 
    	  ) 
	  loop 
if vaat.valore_default is not null then
    	  insert into vaag_new 
    	  ( ATGI_ID 
           ,VAAT_ID 
           ,VALORE 
           ,UTENTE 
           ,DATA_AGG 
    	  ) values 
    	  ( d_atgi_id 
		   ,vaat.vaat_id 
		   ,vaat.valore_default 
		   ,'Aut.PEGI' 
		   ,sysdate 
    	  ); 
end if;
	  end loop; 
  end loop; 
end;
/

commit;


