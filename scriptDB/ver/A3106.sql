update a_prenotazioni 
   set voce_menu = 'PECCSMGM'
 where voce_menu in
( 'PXMSCIGM', 'PXSI36GM', 'PXSI36G4', 'PXTO13G4', 'PXTRBZG4', 'PXMSCIG4', 'PXER09GM'
, 'PXER25GM', 'PXER08GM', 'PXTO13GM', 'PXSI06GM', 'PXER32GM', 'PXTRBZGM', 'PXE432GM'
, 'PXT4BZGM', 'PXER09G4', 'PXER25G4', 'PXER32G4', 'PXSI06G4', 'PXHGSMGM', 'PXSI08GM'
, 'PXLO11GM', 'PXUCHIGM'
);

update a_stampe 
   set stampa = 'PECSSMGM'
 where stampa in ( 'PXXSSMGM', 'PXXSSINT', 'PECCSMGM' );

delete from gp4_personalizzazioni
 where voce_menu in
( 'PXMSCIGM', 'PXSI36GM', 'PXSI36G4', 'PXTO13G4', 'PXTRBZG4', 'PXMSCIG4', 'PXER09GM'
, 'PXER25GM', 'PXER08GM', 'PXTO13GM', 'PXSI06GM', 'PXER32GM', 'PXTRBZGM', 'PXE432GM'
, 'PXT4BZGM', 'PXER09G4', 'PXER25G4', 'PXER32G4', 'PXSI06G4', 'PXHGSMGM', 'PXSI08GM'
, 'PXLO11GM', 'PXUCHIGM'
);

delete from a_menu where voce_menu in
( 'PXMSCIGM', 'PXSI36GM', 'PXSI36G4', 'PXTO13G4', 'PXTRBZG4', 'PXMSCIG4', 'PXER09GM'
, 'PXER25GM', 'PXER08GM', 'PXTO13GM', 'PXSI06GM', 'PXER32GM', 'PXTRBZGM', 'PXE432GM'
, 'PXT4BZGM', 'PXER09G4', 'PXER25G4', 'PXER32G4', 'PXSI06G4', 'PXHGSMGM', 'PXSI08GM'
, 'PXLO11GM', 'PXUCHIGM'
);

delete from a_passi_proc where voce_menu in
( 'PXMSCIGM', 'PXSI36GM', 'PXSI36G4', 'PXTO13G4', 'PXTRBZG4', 'PXMSCIG4', 'PXER09GM'
, 'PXER25GM', 'PXER08GM', 'PXTO13GM', 'PXSI06GM', 'PXER32GM', 'PXTRBZGM', 'PXE432GM'
, 'PXT4BZGM', 'PXER09G4', 'PXER25G4', 'PXER32G4', 'PXSI06G4', 'PXHGSMGM', 'PXSI08GM'
, 'PXLO11GM', 'PXUCHIGM'
);

delete from a_selezioni where voce_menu in
( 'PXMSCIGM', 'PXSI36GM', 'PXSI36G4', 'PXTO13G4', 'PXTRBZG4', 'PXMSCIG4', 'PXER09GM'
, 'PXER25GM', 'PXER08GM', 'PXTO13GM', 'PXSI06GM', 'PXER32GM', 'PXTRBZGM', 'PXE432GM'
, 'PXT4BZGM', 'PXER09G4', 'PXER25G4', 'PXER32G4', 'PXSI06G4', 'PXHGSMGM', 'PXSI08GM'
, 'PXLO11GM', 'PXUCHIGM'
);

delete from a_guide_o where voce_menu in
( 'PXMSCIGM', 'PXSI36GM', 'PXSI36G4', 'PXTO13G4', 'PXTRBZG4', 'PXMSCIG4', 'PXER09GM'
, 'PXER25GM', 'PXER08GM', 'PXTO13GM', 'PXSI06GM', 'PXER32GM', 'PXTRBZGM', 'PXE432GM'
, 'PXT4BZGM', 'PXER09G4', 'PXER25G4', 'PXER32G4', 'PXSI06G4', 'PXHGSMGM', 'PXSI08GM'
, 'PXLO11GM'
);

delete from a_guide_v where voce_menu in
( 'PXMSCIGM', 'PXSI36GM', 'PXSI36G4', 'PXTO13G4', 'PXTRBZG4', 'PXMSCIG4', 'PXER09GM'
, 'PXER25GM', 'PXER08GM', 'PXTO13GM', 'PXSI06GM', 'PXER32GM', 'PXTRBZGM', 'PXE432GM'
, 'PXT4BZGM', 'PXER09G4', 'PXER25G4', 'PXER32G4', 'PXSI06G4', 'PXHGSMGM', 'PXSI08GM'
, 'PXLO11GM', 'PXUCHIGM'
);

delete from a_catalogo_stampe
where stampa in ( 'PXXSSMGM', 'PXXSSINT' );

-- Installazione voce di menu PECCSMGM - Supporto Magnetico Denucia ENPAM

delete from a_voci_menu where voce_menu = 'PECCSMGM';   
delete from a_passi_proc where voce_menu = 'PECCSMGM';  
delete from a_selezioni where voce_menu = 'PECCSMGM';   
delete from a_menu where voce_menu = 'PECCSMGM' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa in ( 'PXXSSMGM', 'PECCSMGM'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCSMGM','P00','CSMGM','Supporto Magnetico Denucia ENPAM','F','D','ACAPARPR','DENUNCIA_ENPAM',1,'P_INDI_S');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMGM','1','Supporto Magnetico Denucia ENPAM','Q','PECCSMGM','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMGM','2','Supporto Magnetico Denucia ENPAM','R','SI4V3WAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMGM','3','Supporto Magnetico Denucia ENPAM','R','PECSSMGM','','PECSSMGM','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMGM','4','Supporto Magnetico Denucia ENPAM','Q','ACACANAS','','','N'); 

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('NUM_CARATTERI','PECCSMGM','0','NUMERO CARATTERI PER SUBSTR','4','C','S','100','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_SUBSTR','PECCSMGM','0','ABILITA SUBSTRING','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('TXTFILE','PECCSMGM','0','Nome TXT da produrre','101','C','S','ENPAM.txt','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DA_ANNO','PECCSMGM','1','Elaborazione: da Anno','4','N','N','','','RIRE','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DA_MENSILITA','PECCSMGM','2','                    Mensilita''','4','U','N','','','RIRE','1','2');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_A_ANNO','PECCSMGM','3','                       a Anno','4','N','N','','','RIRE','1','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_A_MENSILITA','PECCSMGM','4','                    Mensilita''','4','U','N','','','RIRE','1','2'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_1','PECCSMGM','5','Raggruppamento: 1)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_2','PECCSMGM','6','2)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_3','PECCSMGM','7','3)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_4','PECCSMGM','8','4)','15','U','S','%','','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000554','1012523','PECCSMGM','32','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000554','1012523','PECCSMGM','32','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000554','1012523','PECCSMGM','32','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSSMGM','LISTA CONTROLLO DENUNCIA ENPAM','U','U','A_C','N','N','S'); 

-- Creazione dell'estrazione e della vista se inesistente
insert into ESTRAZIONE_REPORT (ESTRAZIONE, DESCRIZIONE, SEQUENZA, OGGETTO, NUM_RIC, NOTE)
select 'DENUNCIA_ENPAM', 'Denuncia Enpam', 1, 'PERE', 6, 'Per Denuncia ENPAM'
  from dual
 where not exists ( select 'x'
                      from estrazione_report
                     where estrazione = 'DENUNCIA_ENPAM'
                  );
insert into RELAZIONE_CHIAVI_ESTRAZIONE (ESTRAZIONE, SEQUENZA, CHIAVE)
select 'DENUNCIA_ENPAM', 1, 'ENTE' 
  from dual
 where not exists ( select 'x'
                      from relazione_chiavi_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 1
                  );
insert into RELAZIONE_CHIAVI_ESTRAZIONE (ESTRAZIONE, SEQUENZA, CHIAVE)
select 'DENUNCIA_ENPAM', 2, 'NULLA'
  from dual
 where not exists ( select 'x'
                      from relazione_chiavi_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 2
                  );
insert into RELAZIONE_CHIAVI_ESTRAZIONE (ESTRAZIONE, SEQUENZA, CHIAVE)
select 'DENUNCIA_ENPAM', 3, 'NULLA'   from dual
 where not exists ( select 'x'
                      from relazione_chiavi_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 3
                  );
insert into RELAZIONE_CHIAVI_ESTRAZIONE (ESTRAZIONE, SEQUENZA, CHIAVE)
select 'DENUNCIA_ENPAM', 4, 'NULLA'
  from dual
 where not exists ( select 'x'
                      from relazione_chiavi_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 4
                  );
insert into RELAZIONE_CHIAVI_ESTRAZIONE (ESTRAZIONE, SEQUENZA, CHIAVE)
select 'DENUNCIA_ENPAM', 5, 'ALFABETICO'
  from dual
 where not exists ( select 'x'
                      from relazione_chiavi_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 5
                  );
insert into RELAZIONE_CHIAVI_ESTRAZIONE (ESTRAZIONE, SEQUENZA, CHIAVE)
select 'DENUNCIA_ENPAM', 6, 'NULLA'
  from dual
 where not exists ( select 'x'
                      from relazione_chiavi_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 6
                  );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 1, 'CI.PERE', 'CI', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 1
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 2, 'ANNO', 'ANNO', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 2
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 3, 'MESE', 'MESE', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 3
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 4, 'VACM.MENSILITA', 'MENSILITA', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 4
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 5, 'VACM.01', 'COL1', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 5
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 6, 'VACM.02', 'COL2', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 6
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 7, 'VACM.03', 'COL3', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 7
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 8, 'VACM.04', 'COL4', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 8
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 9, 'VACM.05', 'COL5', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 9
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 10, 'VACM.06', 'COL6', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 10
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 11, 'VACM.07', 'COL7', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 11
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 12, 'VACM.08', 'COL8', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 12
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 13, 'VACM.09', 'COL9', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 13
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 14, 'VACM.10', 'COL10', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 14
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 15, 'VACM.11', 'COL11', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 15
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 16, 'VACM.12', 'COL12', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 16
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 17, 'VACM.13', 'COL13', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 17
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 18, 'VACM.14', 'COL14', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 18
                   );
insert into RELAZIONE_ATTR_ESTRAZIONE (ESTRAZIONE, SEQUENZA, ATTRIBUTO, ALIAS, DESCRIZIONE)
select 'DENUNCIA_ENPAM', 19, 'VACM.RIFERIMENTO', 'RIFERIMENTO', null
  from dual
 where not exists ( select 'x'
                      from relazione_attr_estrazione
                     where estrazione = 'DENUNCIA_ENPAM'
                       and sequenza = 19
                   );
insert into RELAZIONE_OGGETTI_ESTRAZIONE (ESTRAZIONE, OGGETTO)
select 'DENUNCIA_ENPAM', 'PERE'
  from dual
 where not exists ( select 'x'
                      from RELAZIONE_OGGETTI_ESTRAZIONE
                     where estrazione = 'DENUNCIA_ENPAM'
                       and oggetto = 'PERE'
                   );
insert into RELAZIONE_OGGETTI_ESTRAZIONE (ESTRAZIONE, OGGETTO)
select 'DENUNCIA_ENPAM', 'VACM'
  from dual
 where not exists ( select 'x'
                      from RELAZIONE_OGGETTI_ESTRAZIONE
                     where estrazione = 'DENUNCIA_ENPAM'
                       and oggetto = 'VACM'
                   );
insert into RELAZIONE_COND_ESTRAZIONE (ESTRAZIONE, OGGETTO, SEQUENZA, CONDIZIONE)
select 'DENUNCIA_ENPAM', 'PERE', 1, 'and pere.competenza = ''A'''
  from dual
 where not exists ( select 'x'
                      from RELAZIONE_COND_ESTRAZIONE
                     where estrazione = 'DENUNCIA_ENPAM'
                       and oggetto = 'PERE'
                       and sequenza = 1
                   );
insert into RELAZIONE_COND_ESTRAZIONE (ESTRAZIONE, OGGETTO, SEQUENZA, CONDIZIONE)
select 'DENUNCIA_ENPAM', 'VACM', 1, 'and vacm.estrazione = ''DENUNCIA_ENPAM'''
  from dual
 where not exists ( select 'x'
                      from RELAZIONE_COND_ESTRAZIONE
                     where estrazione = 'DENUNCIA_ENPAM'
                       and oggetto = 'VACM'
                       and sequenza = 1
                   );
insert into ESTRAZIONE_VALORI_CONTABILI (ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE )
select 'DENUNCIA_ENPAM', '01', to_date('01012000', 'ddmmyyyy'), null, 'Importo',  1, null, null, null, null
  from dual 
 where not exists ( select 'x'
                      from ESTRAZIONE_VALORI_CONTABILI 
                     where estrazione = '01'
                   );

start crp_peccsmgm.sql


BEGIN
  Gp4_crea_viste.peclesre('DENUNCIA_ENPAM');
END;
/
