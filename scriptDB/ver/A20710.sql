alter table com730 add 
( IRPEF_DB_CON        VARCHAR (9)
, IRPEF_CR_CON        VARCHAR (9)
, COD_COM_ACC_DIC_DB  VARCHAR (4)
, ACC_ADD_COM_DIC_DB  VARCHAR (8)
, COD_COM_ACC_CON_DB  VARCHAR (4)
, ACC_ADD_COM_CON_DB  VARCHAR (8)
);

alter table denuncia_caaf add
( IRPEF_DB_CON           NUMBER(12,2)
, IRPEF_CR_CON           NUMBER(12,2)
, INT_RATE_IRPEF_CON     NUMBER(12,2)
, COD_COM_ACC_DIC_DB     VARCHAR2(4)
, ACC_ADD_COM_DIC_DB     NUMBER(12,2)
, INT_RATE_ACC_COM_DIC   NUMBER(12,2)
, COD_COM_ACC_CON_DB     VARCHAR2(4)
, ACC_ADD_COM_CON_DB     NUMBER(12,2)
, INT_RATE_ACC_COM_CON   NUMBER(12,2)
);


start crp_pecca730.sql
start crp_pecccaaf.sql

-- cancellazione voce di menu vecchia e dismessa PEC4A730 e sistemazione nuove voce di menu PECCA730

delete from a_voci_menu where voce_menu = 'PEC4A730';
delete from a_passi_proc where voce_menu = 'PEC4A730';
delete from a_selezioni where voce_menu = 'PEC4A730';
delete from a_menu where voce_menu = 'PEC4A730';

delete from a_voci_menu where voce_menu = 'PECCA730'; 
delete from a_passi_proc where voce_menu = 'PECCA730';
delete from a_selezioni where voce_menu = 'PECCA730'; 
delete from a_menu where voce_menu = 'PECCA730' and ruolo in ('*','AMM','PEC');  
delete from a_catalogo_stampe where stampa = 'PECCA730';
delete from a_domini_selezioni where dominio = 'P_INVIO';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCA730','P00','CA730','Caricamento Dati trasmessi dal C.A.A.F.','F','D','ACAPARPR','',1,'A_PARA');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCA730','1','Caricamento dati trasmessi','Q','PECCA730','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCA730','2','Stampa Caricamento dati trasmessi','R','PECSAPST','','PECCA730','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCA730','3','Cancellazione Appoggio Stampe','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCA730','4','Verifica Presenza Errori','Q','CHK_ERR','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCA730','91','Errori in elaborazione','R','ACARAPPR','','PECELASE','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCA730','92','Cancellazione errori','Q','ACACANRP','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_INVIO','PECCA730','30','Tipo di Invio','1','U','S','1','P_INVIO','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DATA_RIC','PECCA730','40','Data di Ricezione','10','D','S','sysdate','','','','');  

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCA730','TOTALI CARICAMENTO DATI CAAF','U','U','PDF','N','N','S');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1006751','1013043','PECCA730','3','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1006751','1013043','PECCA730','3','');  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1006751','1013043','PECCA730','3','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_INVIO','1','','Primo Invio'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_INVIO','A','','Mod. 730-4 Integrativo');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_INVIO','B','','Mod. 730-3 Rettificativo');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_INVIO','E','','Mod. 730-4 Rettificativo entro i termini');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_INVIO','F','','Mod. 730-4 Rettificativo oltre i termini');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_INVIO','L','','Rettifica comunic. prec. temp. non cong.');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_INVIO','T','','Altro'); 

-- inserimento nuove specifiche

insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('IRPEF_CRC', null, '50', 'VOCI_ECONOMICHE.SPECIFICA', 'IRPEF a Credito Coniuge', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('IRPEF_DBC', null, '50', 'VOCI_ECONOMICHE.SPECIFICA', 'IRPEF a Debito Coniuge', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('IRPEF_RASC', null, '58', 'VOCI_ECONOMICHE.SPECIFICA', 'Rata mensile Saldo IRPEF Coniuge da 730', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('IRPEF_RISC', null, '60', 'VOCI_ECONOMICHE.SPECIFICA', 'Interessi mensili rateizzati Saldo IRPEF Coniuge da 730', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('IRPEF_SINC', null, '51', 'VOCI_ECONOMICHE.SPECIFICA', 'Interessi saldo IRPEF Coniuge da 730 ritardato pagamento', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('ADD_C_AC', null, 79, 'VOCI_ECONOMICHE.SPECIFICA', 'Acconto Addiz. Comunale da 730', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('ADD_C_RAC', null, 79, 'VOCI_ECONOMICHE.SPECIFICA', 'Rata Acconto Add. Comunale IRPEF da 730', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('ADD_C_RIA', null, 79, 'VOCI_ECONOMICHE.SPECIFICA', 'Int. mens. rateali Acconto Add. Comunale IRPEF da 730', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('ADD_C_IAC', null, 79, 'VOCI_ECONOMICHE.SPECIFICA', 'Int. Acconto Addiz. Com.le da 730 Ritardato Pagamento', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('ADD_C_ACC', null, 79, 'VOCI_ECONOMICHE.SPECIFICA', 'Acconto Addiz. Com.Coniuge da 730', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('ADD_C_RACC', null, 79, 'VOCI_ECONOMICHE.SPECIFICA', 'Rata Acconto Add. Comunale IRPEF Coniuge da 730', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('ADD_C_RIAC', null, 79, 'VOCI_ECONOMICHE.SPECIFICA', 'Int. mens. rateali Acconto Add. Comunale IRPEF Coniuge da 730', 'CFG', null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('ADD_C_IACC', null, 79, 'VOCI_ECONOMICHE.SPECIFICA', 'Int. Acconto Addiz. Com.le Coniuge da 730 Ritardato Pagamento', 'CFG', null, null);


insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
select 'IRPEF_1RC', null, '53', 'VOCI_ECONOMICHE.SPECIFICA', 'I  Rata Acconto IRPEF Coniuge', 'CFG', null, null
  from dual
 where not exists ( select 'x'
                      from PEC_REF_CODES
                     where rv_domain = 'VOCI_ECONOMICHE.SPECIFICA'
                       and rv_low_value = 'IRPEF_1RC'
                  );
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
select 'IRPEF_2RC', null, '56', 'VOCI_ECONOMICHE.SPECIFICA', 'II Rata Acconto IRPEF Coniuge', 'CFG', null, null
  from dual
 where not exists ( select 'x'
                      from PEC_REF_CODES
                     where rv_domain = 'VOCI_ECONOMICHE.SPECIFICA'
                       and rv_low_value = 'IRPEF_2RC'
                  );
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
select 'IRPEF_1INC', null, '54', 'VOCI_ECONOMICHE.SPECIFICA', 'Interessi I rata IRPEF da 730 rit.pag. coniuge', 'CFG', null, null
  from dual
 where not exists ( select 'x'
                      from PEC_REF_CODES
                     where rv_domain = 'VOCI_ECONOMICHE.SPECIFICA'
                       and rv_low_value = 'IRPEF_1INC'
                  );
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
select 'IRPEF_2INC', null, '56', 'VOCI_ECONOMICHE.SPECIFICA', 'Interessi II Rata Acconto IRPEF rit.pag. coniuge', 'CFG', null, null
  from dual
 where not exists ( select 'x'
                      from PEC_REF_CODES
                     where rv_domain = 'VOCI_ECONOMICHE.SPECIFICA'
                       and rv_low_value = 'IRPEF_2INC'
                  );
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
select 'IRPEF_RA1C', null, '59', 'VOCI_ECONOMICHE.SPECIFICA', 'Rata mensile I Rata Acc. IRPEF da 730 Coniuge', 'CFG', null, null
  from dual
 where not exists ( select 'x'
                      from PEC_REF_CODES
                     where rv_domain = 'VOCI_ECONOMICHE.SPECIFICA'
                       and rv_low_value = 'IRPEF_RA1C'
                  );

insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
select 'IRPEF_RI1C', null, '61', 'VOCI_ECONOMICHE.SPECIFICA', 'Int.mens.rateizzati I Rata Acc. IRPEF da 730 Coniuge', 'CFG', null, null
  from dual
 where not exists ( select 'x'
                      from PEC_REF_CODES
                     where rv_domain = 'VOCI_ECONOMICHE.SPECIFICA'
                       and rv_low_value = 'IRPEF_RI1C'
                  );

insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
select 'IRP_RET_1C', null, '50', 'VOCI_ECONOMICHE.SPECIFICA', 'IRPEF I Rata rimborso per rettifica Coniuge', 'CFG', null, null
  from dual
 where not exists ( select 'x'
                      from PEC_REF_CODES
                     where rv_domain = 'VOCI_ECONOMICHE.SPECIFICA'
                       and rv_low_value = 'IRP_RET_1C'
                  );

insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
select 'IRP_RET_2C', null, '50', 'VOCI_ECONOMICHE.SPECIFICA', 'IRPEF II Rata rimborso per rettifica Coniuge', 'CFG', null, null
  from dual
 where not exists ( select 'x'
                      from PEC_REF_CODES
                     where rv_domain = 'VOCI_ECONOMICHE.SPECIFICA'
                       and rv_low_value = 'IRP_RET_2C'
                  );

insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
select 'IRP_RET_AC', null, '50', 'VOCI_ECONOMICHE.SPECIFICA', 'IRPEF Tass.Sep. rimborso per rettifica Coniuge', 'CFG', null, null
  from dual
 where not exists ( select 'x'
                      from PEC_REF_CODES
                     where rv_domain = 'VOCI_ECONOMICHE.SPECIFICA'
                       and rv_low_value = 'IRP_RET_AC'
                  );

update pec_ref_codes
  set rv_abbreviation = 79
where rv_low_value like 'ADD_C_%'
  and rv_abbreviation is null; 

update pec_ref_codes
  set rv_abbreviation = 78
where rv_low_value like 'ADD_R_%'
  and rv_abbreviation is null; 


-- inserimento voce irpef a debito coniuge

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRPEF.DBC', 'Irpef Versata X 730 Coniuge', sequenza+1, 'V', null, null, 'T', null, 'IRPEF_DBC', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRPEF_DB' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRPEF_DBC'
                  );

-- inserimento voce irpef a credito coniuge

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRPEF.CRC', 'Irpef Rimborsata X 730 Coniuge', sequenza+1, 'V', null, null, 'T', null, 'IRPEF_CRC', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRPEF_CR' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRPEF_CRC'
                  );

-- inserimento voce Rata Mensile Saldo Irpef Coniuge

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRPEF.RASC', 'Rata saldo irpef Coniuge 730', sequenza+1, 'V', null, null, 'T', null, 'IRPEF_RASC', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRPEF_RAS' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRPEF_RASC'
                  );

-- inserimento voce Interessi Mensili Saldo Irpef Coniuge

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA , NOTE)
select 'IRPEF.RISC', 'Int. rata saldo irpef 730 con.', sequenza+1, 'V', null, null, 'T', null, 'IRPEF_RISC', null, 'A'
     , 'Interessi Mensili rateizzati Saldo IRPEF coniuge da 730'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRPEF_RIS' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRPEF_RISC'
                  );

-- inserimento voce Interessi Mensili Saldo Irpef Coniuge Ritardato Pagamento

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA, NOTE)
select 'IRPEF.SINC', 'Int. irpef rit.pag. coniuge', sequenza+1, 'V', null, null, 'T', null, 'IRPEF_SINC', null, 'A'
     , 'Interessi Saldo IRPEF coniuge da 730 Ritardato Pagamento'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRPEF_SINT' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRPEF_SINC'
                  );

-- inserimento voce acconto addizionale comunale da 730

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'ADD.C.AC', 'Acconto Add.Com. 730', sequenza+1, 'V', null, null, 'T', null, 'ADD_C_AC', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'ADD_C_DB' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'ADD_C_AC'
                  );

-- inserimento voce rata acconto addizionale comunale da 730

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'ADD.C.RAC', 'Rata Acconto Add.Com. 730', sequenza+1, 'V', null, null, 'T', null, 'ADD_C_RAC', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'ADD_C_RAS' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'ADD_C_RAC'
                  );

-- inserimento voce interessi acconto addizionale comunale da 730

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA, NOTE )
select 'ADD.C.RIA', 'Int. Acconto Add.Com. 730 ', sequenza+1, 'V', null, null, 'T', null, 'ADD_C_RIA', null, 'A'
     , 'Interessi Mensili rateizzati Acconto Addizionale Comunale IRPEF da 730'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'ADD_C_RIS' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'ADD_C_RIA'
                  );

-- inserimento voce interessi ritardato paragmento acconto addizionale comunale da 730

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA, NOTE )
select 'ADD.C.IAC', 'Int. Rit.Pag. Acc.Add.Com. 730', sequenza+1,'V', null, null, 'T', null, 'ADD_C_IAC', null, 'A'
     , 'Interessi Acconto Addizionale Comunale IRPEF da 730 Ritardato Pagamento'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'ADD_C_INT' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'ADD_C_IAC'
                  );

-- inserimento voce acconto addizionale comunale coniuge da 730

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'ADD.C.ACC', 'Acconto Add.Com. 730 Coniuge', sequenza+1, 'V', null, null, 'T', null, 'ADD_C_ACC', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'ADD_C_DBC' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'ADD_C_ACC'
                  );

-- inserimento voce rata acconto addizionale comunale coniuge da 730

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA, NOTE )
select 'ADD.C.RACC', 'Rata Acc. Add.Com. Coniuge 730', sequenza+1, 'V', null, null, 'T', null, 'ADD_C_RACC', null, 'A'
     , 'Rata Acconto Addizionale Comunale IRPEF Coniuge da 730'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'ADD_C_RASC' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'ADD_C_RACC'
                  );

-- inserimento voce interessi acconto addizionale comunale coniuge da 730

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA, NOTE )
select 'ADD.C.RIAC', 'Int. Acc. Add.Com. Coniuge 730', sequenza+1, 'V', null, null, 'T', null, 'ADD_C_RIAC', null, 'A'
     , 'Interessi Mensili rateizzati Acconto Addizionale Comunale IRPEF Coniuge da 730'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'ADD_C_RISC' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'ADD_C_RIAC'
                  );

-- inserimento voce interessi ritardato paragmento acconto addizionale comunale coniuge da 730

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA, NOTE )
select 'ADD.C.IACC', 'Int.Rit.Pag.Acc.ACom.Con. 730', sequenza+1,'V', null, null, 'T', null, 'ADD_C_IACC', null, 'A'
     , 'Interessi Acconto Addizionale Comunale IRPEF Coniuge da 730 Ritardato Pagamento'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'ADD_C_INTC' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'ADD_C_IACC'
                  );

-- inserimento prima rata irpef coniuge 

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRPEF.1RC', 'I Rata Acc. Irpef Coniuge 730', sequenza+1,'V', null, null, 'T', null, 'IRPEF_1RC', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRPEF_1R' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRPEF_1RC'
                  );

-- inserimento seconda rata irpef coniuge

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRPEF.2RC', 'II Rata Acc. Irpef Coniuge 730', sequenza+1,'V', null, null, 'T', null, 'IRPEF_2RC', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRPEF_2R' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRPEF_2RC'
                  );

-- inserimento interessi prima rata irpef coniuge ritardato pagamento

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRPEF.1INC', 'Int.I rata irpef rit.pag.con.', sequenza+1,'V', null, null, 'T', null, 'IRPEF_1INC', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRPEF_1INT' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRPEF_1INC'
                  );


-- inserimento interessi seconda rata irpef coniuge ritardato pagamento

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRPEF.2INC', 'Int.2 rata irpef rit.pag.con.', sequenza+1,'V', null, null, 'T', null, 'IRPEF_2INC', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRPEF_2INT' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRPEF_2INC'
                  );

-- inserimento rata mensile primo acconto irpef coniuge

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRPEF.RA1C', 'Rata I rata acc. coniuge', sequenza+1,'V', null, null, 'T', null, 'IRPEF_RA1C', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRPEF_RA1R' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRPEF_RA1C'
                  );

-- inserimento interessi mensili primo acconto irpef coniuge

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRPEF.RI1C', 'Int. I rata acc. coniuge', sequenza+1,'V', null, null, 'T', null, 'IRPEF_RI1C', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRPEF_RI1R' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRPEF_RI1C'
                  );

-- inserimento rettifica prima rata irpef e prima rata irpef coniuge

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRP.RET.1R', 'Irpef I Rata Rimb Per Rettif.', sequenza+1,'V', null, null, 'T', null, 'IRP_RET_1R', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRPEF_1R' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRP_RET_1R'
                  );

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRP.RET.1C', 'Irpef I Rata Rimb Per Ret.Con', sequenza+1,'V', null, null, 'T', null, 'IRP_RET_1C', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRP_RET_1R' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRP_RET_1C'
                  );

-- inserimento rettifica seconda rata irpef e seconda rata irpef coniuge

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRP.RET.2R', 'Irpef II Rata Rimb Per Rett.', sequenza+1,'V', null, null, 'T', null, 'IRP_RET_2R', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRPEF_2R' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRP_RET_2R'
                  );

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRP.RET.2C', 'Irpef II Rata Rimb Per Ret.Con', sequenza+1,'V', null, null, 'T', null, 'IRP_RET_2C', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRP_RET_2R' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRP_RET_2C'
                  );

-- inserimento rettifica irpef ap e irpef ap coniuge

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRP.RET.AP', 'Irpef Tass. Sep. Rimb. Rett.', sequenza+1,'V', null, null, 'T', null, 'IRP_RET_AP', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRPEF_AP' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRP_RET_AP'
                  );

insert into VOCI_ECONOMICHE 
( CODICE, OGGETTO, SEQUENZA, CLASSE, ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA )
select 'IRP.RET.AC', 'Irpef Tass.Sep Rimb Rett. Con', sequenza+1,'V', null, null, 'T', null, 'IRP_RET_AC', null, 'A'
  from voci_economiche
 where sequenza = ( select min(sequenza)
                      from voci_economiche x
                     where not exists ( select 'x' from voci_economiche where sequenza = x.sequenza+1 )
                       and sequenza > (select max(sequenza) from voci_economiche where specifica = 'IRP_RET_AP' )
                  )
   and not exists ( select 'x' 
                      from voci_economiche x
                     where  specifica = 'IRP_RET_AC'
                  );

-- inserimento contabilita voce

insert into CONTABILITA_VOCE
( VOCE, SUB, DAL, AL, DESCRIZIONE, DES_ABB,  FISCALE, SOMME, RAPPORTO
, STAMPA_TAR, STAMPA_QTA, STAMPA_IMP, STARIE_TAR, STARIE_QTA, STARIE_IMP , BILANCIO, STAMPA_FR )
select voec.codice, '*', null, null, upper(voec.oggetto), voec.codice, 'N', null, null
, 'N', 'N', 'I', 'N', 'N', 'I', covo.bilancio, 'F'
 from contabilita_voce covo
    , voci_economiche  voec
where covo.voce in ( select min(voec1.codice)
                       from voci_economiche  voec1
                      where voec1.specifica = decode( voec.specifica
                                                    , 'IRPEF_DBC'  , 'IRPEF_DB' 
                                                    , 'IRPEF_CRC'  , 'IRPEF_CR'
                                                    , 'IRPEF_RASC' , 'IRPEF_RAS'
                                                    , 'IRPEF_RISC' , 'IRPEF_RIS'
                                                    , 'IRPEF_SINC' , 'IRPEF_SINT'
                                                    , 'ADD_C_AC'   , 'ADD_C_DB'
                                                    , 'ADD_C_RAC'  , 'ADD_C_RAS'
                                                    , 'ADD_C_RIA'  , 'ADD_C_RIS'
                                                    , 'ADD_C_IAC'  , 'ADD_C_INT'
                                                    , 'ADD_C_ACC'  , 'ADD_C_DBC'
                                                    , 'ADD_C_RACC' , 'ADD_C_RASC'
                                                    , 'ADD_C_RIAC' , 'ADD_C_RISC'
                                                    , 'ADD_C_IACC' , 'ADD_C_INTC'
                                                    , 'IRPEF_1RC'  , 'IRPEF_1R'
                                                    , 'IRPEF_2RC'  , 'IRPEF_2R'
                                                    , 'IRPEF_1INC' , 'IRPEF_1INT'
                                                    , 'IRPEF_2INC' , 'IRPEF_2INT'
                                                    , 'IRPEF_RA1C' , 'IRPEF_RA1R'
                                                    , 'IRPEF_RI1C' , 'IRPEF_RI1R'
                                                    , 'IRP_RET_1R' , 'IRPEF_1R'
                                                    , 'IRP_RET_2R' , 'IRPEF_2R'
                                                    , 'IRP_RET_AP' , 'IRPEF_AP'
                                                    )
                    )
  and covo.al is null
  and voec.specifica in ( 'IRPEF_DBC'  , 'IRPEF_CRC'  , 'IRPEF_RASC' , 'IRPEF_RISC' , 'IRPEF_SINC' 
                        , 'ADD_C_AC'   , 'ADD_C_RAC'  , 'ADD_C_RIA'  , 'ADD_C_IAC'
                        , 'ADD_C_ACC'  , 'ADD_C_RACC' , 'ADD_C_RIAC' , 'ADD_C_IACC'
                        , 'IRPEF_1RC'  , 'IRPEF_2RC'  , 'IRPEF_1INC' , 'IRPEF_2INC' , 'IRPEF_RA1C' , 'IRPEF_RI1C' 
                        , 'IRP_RET_1R' , 'IRP_RET_2R' , 'IRP_RET_AP' )
  and not exists ( select 'x'
                     from contabilita_voce x
                    where voce = voec.codice
                     and sub = '*'
                     and dal is null
                 )
;


insert into CONTABILITA_VOCE
( VOCE, SUB, DAL, AL, DESCRIZIONE, DES_ABB,  FISCALE, SOMME, RAPPORTO
, STAMPA_TAR, STAMPA_QTA, STAMPA_IMP, STARIE_TAR, STARIE_QTA, STARIE_IMP , BILANCIO, STAMPA_FR )
select voec.codice, '*', null, null, upper(voec.oggetto), voec.codice, 'N', null, null
, 'N', 'N', 'I', 'N', 'N', 'I', covo.bilancio, 'F'
 from contabilita_voce covo
    , voci_economiche  voec
where covo.voce in ( select min(voec1.codice)
                       from voci_economiche  voec1
                      where voec1.specifica = decode( voec.specifica
                                                    , 'IRP_RET_1C' , 'IRP_RET_1R'
                                                    , 'IRP_RET_2C' , 'IRP_RET_2R'
                                                    , 'IRP_RET_AC' , 'IRP_RET_AP'
                                                    )
                   )
  and covo.al  is null
  and voec.specifica in ( 'IRP_RET_1C' , 'IRP_RET_2C' , 'IRP_RET_AC' )
  and not exists ( select 'x'
                     from contabilita_voce x
                    where voce = voec.codice
                 )
;

-- inserimento voci contabili

insert into voci_contabili 
( VOCE, SUB, ALIAS, TITOLO, DAL, AL)
select voec.codice, '*', voec.codice, upper(voec.oggetto), null, null
  from voci_economiche  voec
 where voec.specifica in (  'IRPEF_DBC'  , 'IRPEF_CRC'  , 'IRPEF_RASC' , 'IRPEF_RISC' , 'IRPEF_SINC' 
                          , 'ADD_C_AC'   , 'ADD_C_RAC'  , 'ADD_C_RIA'  , 'ADD_C_IAC'
                          , 'ADD_C_ACC'  , 'ADD_C_RACC' , 'ADD_C_RIAC' , 'ADD_C_IACC'
                          , 'IRPEF_1RC'  , 'IRPEF_2RC'  , 'IRPEF_1INC' , 'IRPEF_2INC' , 'IRPEF_RA1C' , 'IRPEF_RI1C' 
                          , 'IRP_RET_1R' , 'IRP_RET_2R' , 'IRP_RET_AP' 
                          , 'IRP_RET_1C' , 'IRP_RET_2C' , 'IRP_RET_AC' )
   and not exists ( select 'x' 
                     from voci_contabili  x
                    where voce = voec.codice
                      and sub = '*'
                 )
;
