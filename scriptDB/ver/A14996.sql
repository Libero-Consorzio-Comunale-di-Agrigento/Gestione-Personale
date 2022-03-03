alter table eventi_infortunio add CODICE_REGIONALE_ATTIVITA VARCHAR2(2) ;

start crt_crat.sql

insert into a_errori ( errore, descrizione)
values ( 'P00527','I valori consentiti sono SI, N0, SS');

insert into a_errori ( errore, descrizione)
values ( 'P00528','Codice Attivita non prevista');

insert into a_errori ( errore, descrizione)
values ( 'P00529','Esiste Denuncia Infortunio collegata a: ');

insert into a_errori ( errore, descrizione)
values ( 'P00599','Descrizione Obbligatoria');

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '01', 'Anatomia Patologica', 1);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '02', 'Area di Degenza Chirurgica', 2);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '03', 'Area di Degenza Medica', 3);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '04', 'Attività di Diagnostica di Laboratorio', 4);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '05', 'Attività di Disinfezione', 5);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '06', 'Attività di Sterilizzazione', 6);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '07', 'Attività in Sala Operatoria', 7);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '08', 'Attività Pronto Soccorso Ospedaliero', 8);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '09', 'Diagnostica Per Immagini', 9);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '10', 'Gestione Farmaci e Materiale Sanitario', 10);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '11', 'Rianimazione', 11);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '12', 'Supporto alle Attività Sanitarie', 12);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '13', 'Centri Ambulatoriali di Riabilitazione', 13);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '14', 'Centri di Salute Mentale', 14);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '15', 'Consultori Familiari', 15);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '16', 'Presidi Per Il Trattamento Dei Tossicodipendenti: Centro Ambulatoriale', 16);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '17', 'Assistenza specialistica Ambulatoriale', 17);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '18', 'Attività di Diagnostica Per Immagini', 18);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '19', 'Presidi Ambulatoriali di Recupero e riaducazione funzionale', 19);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '20', 'Servizi di Medicina di Laboratorio', 20);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '21', 'Presidi Di Riabilitazione Funzionale Dei Soggetti Portatori Di Disabilità Fisiche, Psichiche e Funzionali', 21);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '22', 'Presidi Di Tutela Della Salute Mentale: Centro Diurno Psichiatrico e Day Hospital Psichiatrico', 22);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '23', 'Presidi Di Tutela Della Salute Mentale: Struttura Residenziale Psichiatrica', 23);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '24', 'Residenze Sanitarie Assistenziali (R.S.A.)', 24);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '25', 'Strutture di Riabilitazione e Strutture Educativo-Assistenziali per i Tossicodipendenti', 25);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '26', 'Strutture Amministrative Varie', 26);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '27', 'U.O. Economato', 27);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '28', 'U.O. Gestione Tecnica', 28);

insert into CODICI_REGIONALI_ATTIVITA ( codice, descrizione, sequenza )
values( '29', 'Strutture area dell''Igiene e della Prevenzione: Pubblica, Veterinaria, Alimenti, Prev./Sic. Ambienti Lavoro, ecc.', 29);

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECDCRAT','P00','DCRAT','Definizione Codici Regionali Attivita''','F','F','PECDCRAT','',1,'');

update a_menu set sequenza = 9 where voce_menu = 'PECCDEIN' and padre = 1013306;

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013306','1013837','PECDCRAT','8','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013306','1013837','PECDCRAT','8','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013306','1013837','PECDCRAT','8','');

delete from a_guide_o where guida_o = 'P_CDEIN';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_CDEIN','1','CAIN','C','Cause','PECDCAIN','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CDEIN','2','QUIN','Q','Qua.inail','PECDQUIN','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CDEIN','3','CAIN','A','Agenti','PECDAGIN','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CDEIN','4','PAAN','P','Parti an.','PECDPAAN','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CDEIN','5','ATIN','T','aTtivita','PECDATIN','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,voce_menu,voce_rif)
values ('P_CDEIN','6','CRAT','R','att.Reg.','PECDCRAT','');

