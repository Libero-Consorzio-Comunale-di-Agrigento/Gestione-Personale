BEGIN
declare
w_chiave  varchar(30);
w_esnc_0  varchar(37);
w_esnc_6  varchar(37);
w_esnc_7  varchar(37);
w_esnc_9  varchar(37);
w_esnc_10 varchar(37);
w_esnc_13 varchar(37);
w_esnc_14 varchar(37);
w_esnc_15 varchar(37);
w_esnc_18 varchar(37);
w_esnc_16 varchar(37);
w_esnc_19 varchar(37);
w_esnc_20 varchar(37);
w_esnc_22 varchar(37);
w_esnc_23 varchar(37);
w_nr_ruo  number;
w_conta_des_oriz number;
w_conta_stampa number;
i         number;
BEGIN
  delete struttura_modelli_stampa 
   where codice = 'CEDOLINO'
  ;
  select chiave 
   into w_chiave
   from RELAZIONE_CHIAVI_ESTRAZIONE
  where estrazione = 'CEDOLINO'
    and sequenza = 1
  ;
  select count(*)
    into w_conta_des_oriz
    from estrazione_valori_contabili esvc
   where estrazione = 'CEDOLINO_VOCI_ORIZ'
     and al is null
  ;
  select max(decode(esnc.sub,14,esnc.descrizione,null))
       , max(decode(esnc.sub,6,esnc.descrizione,null))
       , max(decode(esnc.sub,7,esnc.descrizione,null))
       , max(decode(esnc.sub,20,esnc.descrizione,null))
       , max(decode(esnc.sub,15,esnc.descrizione,null))
       , max(decode(esnc.sub,18,esnc.descrizione,null))
       , max(decode(esnc.sub,16,esnc.descrizione,null))
       , max(decode(esnc.sub,23,esnc.descrizione,null))
       , max(decode(esnc.sub,0,esnc.descrizione,null))
       , max(decode(esnc.sub,13,esnc.descrizione,null))
       , max(decode(esnc.sub,19,esnc.descrizione,null))
       , max(decode(esnc.sub,22,esnc.descrizione,null))
       , max(decode(esnc.sub,9,esnc.descrizione,null))
       , max(decode(esnc.sub,10,esnc.descrizione,null))
    into w_esnc_14,w_esnc_6,w_esnc_7,w_esnc_20,w_esnc_15,w_esnc_18,w_esnc_16
       , w_esnc_23,w_esnc_0,w_esnc_13,w_esnc_19,w_esnc_22,w_esnc_9,w_esnc_10
    from estrazione_note_cedolini esnc
   where sequenza = 0
     and sub in (0,6,7,9,10,13,14,15,16,18,19,20,22,23)
  ;
  select count(*)
    into w_nr_ruo
    from ruoli
  ;
  select count(*)
    into w_conta_stampa
    from a_prenotazioni
   where voce_menu in ('PXXCALR4','PXXSMOR4','PXXSCER4')
  ;
 insert into struttura_modelli_stampa 
 select 'CEDOLINO',1,'I','T',decode(w_chiave,'GESTIONE_N',' ',decode(w_esnc_14,'X',' ','<V:'||decode(w_chiave,'GESTIONE','gest','ente')||'.descrizione,39,40>'))
   from dual
 ;
 insert into struttura_modelli_stampa 
 select 'CEDOLINO',2,'I','T',decode(w_chiave,'GESTIONE_N',' ',decode(w_esnc_14,'X','<V:'||decode(w_chiave,'GESTIONE','gest','ente')||'.descrizione,39,40>',
                                    '<V:'||decode(w_chiave,'GESTIONE','gest','ente')||'.indirizzo,39,40>'))
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',3,'I','T',decode(w_chiave,'GESTIONE_N',' ',decode(w_esnc_14,'X','<V:'||decode(w_chiave,'GESTIONE','gest','ente')||'.indirizzo,39,40>',
                                    '<V:'||decode(w_chiave,'GESTIONE','gest','ente')||'.comune,39,40>'))
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',4,'I','T',decode(w_chiave,'GESTIONE_N',' ',decode(w_esnc_14,'X','<V:'||decode(w_chiave,'GESTIONE','gest','ente')||'.comune,39,40>',
                                    '<V:'||decode(w_chiave,'GESTIONE','gest','ente')||'.codice_fiscale,39,40>'))
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',5,'I','T',decode(w_esnc_6,'CS','<V:gest.codice,1,4>'
                           ||decode(substr(w_esnc_7,1,1),1,'<V:sett.codice,7,15>'
                                                        ,3,'<V:sett.codice,7,15>'
                                                          ,decode(w_nr_ruo,1,'<V:ragi.ruolo,7,4>'
                                                                            ,'<V:ragi.ruolo,7,4><V:sedi.codice,13,6>'))
                  ||decode(substr(w_esnc_7,1,1),2,'<V:gest.posizione_inps,23,14>'
                                               ,3,'<V:gest.posizione_inps,23,14>'
                                               ,4,'<V:sett.codice,23,6>'
                                               ,5,'<V:rare.codice_inps,23,10>'
                                                 ,'<V:aina.posizione,23,14>'))
                  ||decode(w_chiave,'GESTIONE_N',' ',decode(w_esnc_14,'X','<V:'||decode(w_chiave,'GESTIONE','gest','ente')||'.codice_fiscale,39,22>',' '))
                  ||decode(w_esnc_6,'CS','<V:rain.ci_st,70,11>',' ')
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',6,'I','T',decode(w_esnc_6,'CS',' ','<V:gest.codice,1,4>'
                           ||decode(substr(w_esnc_7,1,1),1,'<V:sett.codice,7,15>'
                                                        ,3,'<V:sett.codice,7,15>'
                                                          ,decode(w_nr_ruo,1,'<V:ragi.ruolo,7,4>'
                                                                            ,'<V:ragi.ruolo,7,4><V:sedi.codice,13,6>'))
                  ||decode(substr(w_esnc_7,1,1),2,'<V:gest.posizione_inps,23,14>'
                                               ,3,'<V:gest.posizione_inps,23,14>'
                                               ,4,'<V:sett.codice,23,6>'
                                               ,5,'<V:rare.codice_inps,23,10>'
                                                 ,'<V:aina.posizione,23,14>'))
                  ||decode(w_esnc_6,'CS',' ','<V:rain.ci_st,'||decode(w_esnc_20,'X',49,57)||',11>'
                                           ||decode(w_esnc_15,'X','<P:Pag.,73><V:sys.num_pag,73,5>',' '))
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',7,'I','T',decode(w_esnc_6,'CS','<V:anag.data_nas,1,8><V:anag.codice_fiscale,10,16><V:rare.matricola,27,8>'
                                                  ||decode(w_esnc_15,'X','<P:Pag.,73><V:sys.num_pag,73,5>',' ') 
                                                 ,' ')         
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',8,'I','T',decode(w_esnc_6,'CS',' '
                                            ,'<V:anag.data_nas,1,8><V:anag.codice_fiscale,10,16><V:rare.matricola,27,8>')
                            ||decode(w_esnc_23,'X',' ','<V:anag.cognome_nome,39,40>')
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',9,'I','T',decode(w_esnc_6,'CS',decode(substr(w_esnc_7,3,1),1,'<V:rain.dal,1,8><V:pegi.al,11,8><V:rare.codice_inps,21,10>'
                                                                             ,2,'<V:rain.rapporto,1,4><V:rain.dal,7,8>'
                                                                               ,'<V:rain.rapporto,1,4><V:rain.dal,7,8><V:pegi.dal,17,8><V:pegi.al,27,8>')
                                                 ,' ')
                            ||decode(w_esnc_23,'X','<V:anag.cognome_nome,46,34>',decode(w_esnc_18,'X','<V:anag.presso,39,40>',' '))
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',10,'I','T',decode(w_esnc_6,'CS',' ',decode(substr(w_esnc_7,3,1),1,'<V:rain.dal,1,8><V:pegi.al,11,8><V:rare.codice_inps,21,10>'
                                                                             ,2,'<V:rain.rapporto,1,4><V:rain.dal,7,8>'
                                                                               ,'<V:rain.rapporto,1,4><V:rain.dal,7,8><V:pegi.dal,17,8><V:pegi.al,27,8>')
                                                 )
                            ||decode(w_esnc_23,'X',decode(w_esnc_18,'X','<V:anag.presso,46,34>',' '),decode(w_esnc_22,'X',' ','<V:anag.indirizzo_dom,39,40>'))
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',11,'I','T',decode(w_esnc_6,'CS','<V:qual.descrizione,1,14><V:ragi.tipo_rapporto,15,4><V:ragi.posizione,20,4><V:qugi.livello,25,4><V:ragi.ore_coco_td,29,6>'
                                                 ,' ')
                            ||decode(w_esnc_23,'X',decode(w_esnc_22,'X',' ','<V:anag.indirizzo_dom,46,34>'),decode(w_esnc_22,'X',' ','<V:anag.comune_dom,39,40>'))
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',12,'I','T',decode(w_esnc_6,'CS',' '
                                                  ,'<V:qual.descrizione,1,14><V:ragi.tipo_rapporto,15,4><V:ragi.posizione,20,4><V:qugi.livello,25,4><V:ragi.ore_coco_td,29,6>'
                                                 )
                            ||decode(w_esnc_23,'X',decode(w_esnc_22,'X',' ','<V:anag.comune_dom,46,34>'),decode(w_esnc_16,'X','<V:rare.statistico1,39,40>',' '))
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',13,'I','T',decode(w_esnc_6,'NO',' '
                                             ,'SI','<V:figi.descrizione,1,34>'
                                             ,'DQ','<V:pegi.qual_dal,1,35>'
                                             ,'DI','<V:pegi.qual_inps_dal,1,35>'
                                                  ,'<V:figi.descrizione,1,34>')
                            ||decode(w_esnc_23,'X','<V:sedi.descrizione,46,34>',decode(substr(w_esnc_10,1,15),'SEDE','<V:sedi.descrizione,39,40>'
                                                                                                             ,'SETTORE','<V:sett.descrizione,39,40>'
                                                                                                             ,'C.SETTORE','<V:sett.cod_descrizione,39,40>'
                                                                                                             ,null)
                                    )
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',14,'I','T',decode(w_esnc_0,'ANZ PENS','<V:sys.esnc0,1,8><P:anni,10><V:prfi_anni_anz,12,2><P:mesi,15><V:prfi_mesi_anz,17,2><P:gg,19><V:prfi_giorni_anz,21,2>'
                                                        ,'<V:sys.esnc0,12,8>')||'<V:anag.partita_iva,39,16>'
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',15,'I','T','<C:sel_inec.anz_voce,1,8><C:sel_inec.anz_numero,11,2><C:sel_inec.anz_data,16,10><C:sel_inec.qual_descrizione,29,18>'
   from dual
 ;
IF w_conta_des_oriz != 0 THEN
insert into struttura_modelli_stampa 
 select 'CEDOLINO',16,'I','T',' '
   from dual
 ;
 i := 0;
 WHILE i < w_conta_des_oriz LOOP
   insert into struttura_modelli_stampa 
   select 'CEDOLINO',17 + i,'I','T','<C:sel_mov_oriz.des_v1,2,8><C:sel_mov_oriz.val_v1,12,12><C:sel_mov_oriz.des_v2,30,8><C:sel_mov_oriz.val_v2,40,12><C:sel_mov_oriz.des_v3,58,8><C:sel_mov_oriz.val_v3,68,12>'
     from dual
   ;
   i := i +1;
 END LOOP;
 insert into struttura_modelli_stampa 
 select 'CEDOLINO',17 + w_conta_des_oriz +1,'I','T',' '
   from dual
 ;
 insert into struttura_modelli_stampa 
 select 'CEDOLINO',17 + w_conta_des_oriz +2,'C','T','<C:sel_moco.sequenza,1,4><C:sel_moco.descrizione,6,37><C:sel_moco.tar_st,43,11><C:sel_moco.qta_st,54,8><C:sel_moco.imp_st,62,17>'
   from dual
 ;
ELSE
 insert into struttura_modelli_stampa 
 select 'CEDOLINO',16,'C','T','<C:sel_moco.sequenza,1,4><C:sel_moco.descrizione,6,37><C:sel_moco.tar_st,43,11><C:sel_moco.qta_st,54,8><C:sel_moco.imp_st,62,17>'
   from dual
 ;
END IF;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',58,'P','T',' '
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',59,'P','T',' '
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',60,'P','P',decode(w_esnc_9,null,'<V:mens.descrizione,1,31>','Val1','<V:mens.periodo_comp1,1,31>','<V:mens.periodo_comp,1,31>')
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',60,'P','U',decode(w_esnc_9,null,'<V:mens.descrizione,1,29>','Val1','<V:mens.periodo_comp1,1,29>','<V:mens.periodo_comp,1,29>')||'<V:moco.arr_pre,32,7><V:moco.arr_att,38,7><V:moco.totale_comp,45,10><V:moco.totale_rit,54,10><V:moco.netto,63,13>'
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',61,'P','T','<V:sys.pagina,66,6><V:sys.num_pag_dip,74,1><V:sys.separatore_pag,75,1><V:sys.tot_pag_dip,76,1>'
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',62,'P','T','<V:rare_descrizione_banca,1,65>'
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',63,'P','T',decode(w_esnc_13,'X','<V:sys.imb1,74,5>',' ')
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',64,'P','T',decode(w_esnc_13,'X','<V:sys.imb2,74,5>',' ')
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',64,'P','U',decode(w_esnc_19,'X','<V:sys.data_elab,1,16><V:sys.prg_cedolino,29,4>',' ')
                             ||decode(w_esnc_13,'X','<V:sys.imb2,74,5>',' ')
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',65,'P','T',decode(w_esnc_13,'X','<V:sys.imb3,74,5>',' ')
   from dual
 ;
insert into struttura_modelli_stampa 
 select 'CEDOLINO',66,'P','T',' '
   from dual
 ;
update estrazione_note_cedolini set
 descrizione = '====='
 where sub = 13
   and sequenza = 0
;
IF w_conta_stampa != 0 THEN
  update a_selezioni set valore_default = 'PDF'
   where voce_menu in ('PECSCER6','PECSMOR6','PECCALR6')
     and parametro = 'P_TIPO_DESFORMAT'
  ;
  update a_catalogo_stampe set classe = 'PDF'
   where stampa in ('PECSMOR6','PECSCER6')
  ;
END IF;
END;
END;
/