start crq_vdz2.sql
start crt_idma.sql
start crt_toz1.sql
start crt_vdz2.sql
start crt_toz2.sql
start crv_tdma.sql
start crp_pecsmdma.sql

--
-- ABILITAZIONE A MENU
--
DELETE FROM A_GUIDE_O 
 WHERE GUIDA_O = 'P_AVDMA';

DELETE FROM A_MENU 
 WHERE VOCE_MENU = 'PECAVDMA';

DELETE FROM A_VOCI_MENU
 WHERE VOCE_MENU = 'PECAVDMA';

INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,TITOLO_ESTESO_AL2 ) VALUES ('P_AVDMA', 1, 'RIRE', 'M', NULL, NULL, 'Mese', NULL, NULL, NULL, 'PECRMERE', NULL, NULL, NULL, NULL, NULL); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECAVDMA','P00','AVDMA'
       ,'Aggiornamento Versamenti DMA','F','F','PECAVDMA','',1,'P_AVDMA');                                                                                                      

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','PEC','1013754','19939','PECAVDMA','8','');                                                                                                                                                                 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','*','1013754','19939','PECAVDMA','8','');                                                                                                                                                                   
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) values ('GP4','AMM','1013754','19939','PECAVDMA','8','');                                                                                                                                                                 
--
-- TIPO PAGAMENTO
--
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('1', null, '1', 'VERSAMENTI_DMA_Z2.TIPO_PAGAMENTO', 'Versamenti in Tesoreria', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('2', null, '2', 'VERSAMENTI_DMA_Z2.TIPO_PAGAMENTO', 'Tramite c/c postale', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('3', null, '3', 'VERSAMENTI_DMA_Z2.TIPO_PAGAMENTO', 'Banca', null, null, null);


--
-- VERSAMENTO
--
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('16', null, '16', 'VERSAMENTI_DMA_Z2.VERSAMENTO', 'Ruoli Generali / Sistemazioni Contributive / Supplettivi', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('17', null, '17', 'VERSAMENTI_DMA_Z2.VERSAMENTO', 'Ruoli per Benefici L.336/70', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('18', null, '18', 'VERSAMENTI_DMA_Z2.VERSAMENTO', 'Ruoli per Ricongiunzione L.29/79', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('19', null, '19', 'VERSAMENTI_DMA_Z2.VERSAMENTO', 'Ruoli per Riscatto ai fini pensionistici', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('20', null, '20', 'VERSAMENTI_DMA_Z2.VERSAMENTO', 'Ruoli quote a carico ante d.p.r. 538/86', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('21', null, '21', 'VERSAMENTI_DMA_Z2.VERSAMENTO', 'Ruoli per d.p.r. 538/86', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('22', null, '22', 'VERSAMENTI_DMA_Z2.VERSAMENTO', 'Recupero benefici concessi in sede di Pensione', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('23', null, '23', 'VERSAMENTI_DMA_Z2.VERSAMENTO', 'Recupero benefici concessi in sede di Buonauscita', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('24', null, '24', 'VERSAMENTI_DMA_Z2.VERSAMENTO', 'Somme versate per condono', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('25', null, '25', 'VERSAMENTI_DMA_Z2.VERSAMENTO', 'Sanzioni per omesso o ritardato pagamento', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('26', null, '26', 'VERSAMENTI_DMA_Z2.VERSAMENTO', 'Somme versate in conto anticipazione', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('27', null, '27', 'VERSAMENTI_DMA_Z2.VERSAMENTO', 'Somme a credito utilizzate (eccedenze)', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('31', null, '31', 'VERSAMENTI_DMA_Z2.VERSAMENTO', 'Versamenti da Z1', null, null, null);
insert into PEC_REF_CODES (RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING, RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2)
values ('33', null, '33', 'VERSAMENTI_DMA_Z2.VERSAMENTO', 'Restituzione contributi sospesi per eventi calamitosi', null, null, null);

