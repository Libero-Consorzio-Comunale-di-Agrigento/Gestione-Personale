--
-- Inserimento nuova specifica
--
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('ADD_COM_AC', null, '326', 'VOCI_ECONOMICHE.SPECIFICA', 'Addizionale IRPEF Comunale in Acconto', 'CFG', null, null);

insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('ADD_COM_RI', null, '326', 'VOCI_ECONOMICHE.SPECIFICA', 'Addizionale IRPEF Comunale Rimborso Acconto', 'CFG', null, null);

--
-- Inserimento nuovo istituto
--
insert into ISTITUTI_CREDITO (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, SOGGETTO
                             , CODICE_ABI, CODICE_CAB, NUM_QUIETANZA, PRONTA_CASSA, NOTE, NOTE_AL1, NOTE_AL2)
values ('ADFS', 'Addizionali Fiscali', null, null, null, '00000', null, null, 'NO', null, null, null);

--
-- Inserimento nuova voce
--
INSERT INTO VOCI_ECONOMICHE ( CODICE, OGGETTO, OGGETTO_AL1, OGGETTO_AL2, SEQUENZA, CLASSE,
ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA, MESE, MENSILITA, NOTE )
select 'ADD.COM.AC', 'Add.IRPEF Comunale Acconto', null, null, sequenza+1, 'V', null, null
     , 'T', null, 'ADD_COM_AC', null, 'P', null, null, null
  from voci_economiche
where sequenza =(select min(sequenza) from voci_economiche x
where not exists (select 'x' from voci_economiche where sequenza = x.sequenza+1)
and sequenza > (select max(sequenza) from voci_economiche where automatismo like 'ADD_COMU%')
);

insert into CONTABILITA_VOCE (VOCE, SUB, DAL, AL, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, DES_ABB, DES_ABB_AL1, DES_ABB_AL2
                             , NOTE, FISCALE, SOMME, RAPPORTO, STAMPA_TAR, STAMPA_QTA, STAMPA_IMP, STARIE_TAR, STARIE_QTA, STARIE_IMP
                             , BILANCIO, BUDGET, SEDE_DEL, ANNO_DEL, NUMERO_DEL, CAPITOLO, ARTICOLO, CONTO, ISTITUTO, STAMPA_FR
                             , IMPEGNO, RISORSA_INTERVENTO, ANNO_IMPEGNO, SUB_IMPEGNO, ANNO_SUB_IMPEGNO, CODICE_SIOPE)
values ('ADD.COM.AC', '07', null, null, 'ADDIZIONALE IRPEF COMUNALE ACC', null, null, 'A', null, null
       , null, 'N', null, null, 'T', 'Q', 'I', 'Q', 'N', 'I'
       , '99', null, null, null, null, null, null, null, 'ADFS', 'F'
       , null, null, null,  null, null, null);

insert into voci_contabili (VOCE, SUB, ALIAS, ALIAS_AL1, ALIAS_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, DAL, AL)
values ('ADD.COM.AC', '07', 'ADDCOMAC07', null, null, 'ADD. COMUNALE ACCONTO 2007', null, null, null, null);

--
INSERT INTO VOCI_ECONOMICHE ( CODICE, OGGETTO, OGGETTO_AL1, OGGETTO_AL2, SEQUENZA, CLASSE,
ESTRAZIONE, SPECIE, TIPO, AUTOMATISMO, SPECIFICA, NUMERO, MEMORIZZA, MESE, MENSILITA, NOTE )
select 'ADD.COM.RI', 'Add.IRPEF Comunale Rimb. Acc.', null, null, sequenza+1, 'V', null, null
     , 'T', null, 'ADD_COM_RI', null, 'A', null, null, null
  from voci_economiche
where sequenza =(select min(sequenza) from voci_economiche x
where not exists (select 'x' from voci_economiche where sequenza = x.sequenza+1)
and sequenza > (select max(sequenza) from voci_economiche where automatismo like 'ADD_COMU%')
);

insert into CONTABILITA_VOCE (VOCE, SUB, DAL, AL, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, DES_ABB, DES_ABB_AL1, DES_ABB_AL2
                             , NOTE, FISCALE, SOMME, RAPPORTO, STAMPA_TAR, STAMPA_QTA, STAMPA_IMP, 
                              STARIE_TAR, STARIE_QTA, STARIE_IMP, BILANCIO, BUDGET, SEDE_DEL, ANNO_DEL, NUMERO_DEL, 
                              CAPITOLO, ARTICOLO, CONTO, ISTITUTO, STAMPA_FR, IMPEGNO, RISORSA_INTERVENTO, ANNO_IMPEGNO, 
                              SUB_IMPEGNO, ANNO_SUB_IMPEGNO, CODICE_SIOPE)
values ('ADD.COM.RI', '*', null, null, 'ADD. IRPEF COMUNALE RIMB. ACC.', null, null, 'A', null, null, null, 'N'
       , null, null, 'T', 'Q', 'I', 'Q', 'N', 'I', '99', null, null, null, null, null, null, null, null, 'F'
       , null, null, null,  null, null, null);

insert into voci_contabili (VOCE, SUB, ALIAS, ALIAS_AL1, ALIAS_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, DAL, AL)
values ('ADD.COM.RI', '*', 'ADDCOMRI', null, null, 'ADD. COMUNALE RIMBORSO ACCONTO', null, null, null, null);



--
-- Inserimento nuova voce di menu PECCRAAD
--

delete from a_guide_o where guida_o in (select guida_o from a_voci_menu where voce_menu = 'PECCRAAD');
delete from a_guide_v where guida_v in (select guida_v from a_guide_o 
                                         where guida_o in (select guida_o from a_voci_menu
                                                            where voce_menu = 'PECCRAAD'));
delete from a_voci_menu where voce_menu = 'PECCRAAD';
delete from a_passi_proc where voce_menu = 'PECCRAAD';
delete from a_selezioni where voce_menu = 'PECCRAAD';
delete from a_menu where voce_menu = 'PECCRAAD' and ruolo in ('*','AMM','PEC');
delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc 
                                                where substr(stampa,1,1) = 'P' and voce_menu = 'PECCRAAD');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCRAAD','P00','CRAAD','Caricamento Rate Addizionali','F','D','ACAPARPR','',1,'P_CCADMA');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCRAAD','1','Caricamento Rate Addizionali','Q','PECCRAAD','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCRAAD','2','Stampa Caricamento Rate Addizionali','R','PECSAPST','','PECSAPST','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default
                        ,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECCRAAD','1','Gestione','8','U','N','%','','GEST','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo
                        ,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FASCIA','PECCRAAD','2','Fascia','1','U','N','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default
                        ,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RAPPORTO','PECCRAAD','3','Rapporto','4','U','N','%','','CLRA','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default
                        ,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GRUPPO','PECCRAAD','4','Gruppo','12','U','N','%','','GRRA','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default
                        ,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECCRAAD','5','Cod.Ind.','8','N','N','','','RAIN','0','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default
                        ,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MESE','PECCRAAD','6','Mese decorrenza rate','2','N','S','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default
                        ,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECCRAAD','7','Tipo Elaborazione','1','U','S','T','P_CRAAD','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000548','1013870','PECCRAAD','3','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000548','1013870','PECCRAAD','3','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000548','1013870','PECCRAAD','3','');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CCADMA','1','PREN','P','Pren.','','ACAEPRPA','*','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CCADMA','2','RAIN','I','Individuo','','P00RANAG','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CCADMA','3','GEST','G','Gestioni','','PGMEGEST','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CCADMA','4','CLRA','R','Rapporti','','PAMDCLRA','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_CCADMA','5','GRRA','U','grUppi','','PAMDGRRA','','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CRAAD','S','','Solo Stampa');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CRAAD','T','','Totale: caricamento + stampa');

start crp_peccraad.sql

