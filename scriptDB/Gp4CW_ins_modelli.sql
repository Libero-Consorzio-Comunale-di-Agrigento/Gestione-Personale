insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CDIRASST', 'Dirigente - Assunzione', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CNDRCOLT', 'NDR Collocamento', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CNDRSOST', 'NDR Sostituzione', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CRUO56ST', 'Ruolo - Assunzione L56 pat-time Strutturale', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CRUO56TT', 'Ruolo - Assunzione L56', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CRUOASST', 'Ruolo Assunzione', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CRUOCOIT', 'Ruolo - Concorso Interno', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CRUOISMT', 'Ruolo - Assunzione Insegnanti Scuola materna', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CRUOL68T', 'Ruolo - Assunzione L68', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CRUOMOBT', 'Ruolo - Assunzione Mobilita', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CRUOMOST', 'Ruolo - Assunzione Mobilita Contratto S', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CRUOREST', 'Ruolo - Responsabile Segreteria', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CRUORIAT', 'Ruolo - Riassunzione', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CRUOSTA2T', 'Ruolo stabilizzazione 2 mesi prova', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CRUOSTA6T', 'Ruolo stabilizzazione 6 mesi prova', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('CRUOTPTT', 'Ruolo - Trasformazione Part-time', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('PGMFASPE', 'Stampa Fascicolo del Personale', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('PGMFASPF', 'Stampa Fascicolo del Personale con Foto', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('PGMRMODT', 'Rapp.Ind. Modifica % Part-time', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('PGMRRFUT', 'Rapp.Ind. Rientro a Full-time', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('PGMRTPTT', 'Rapp.Ind. Trasf. da Full a Part-time', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('PGMRTTPT', 'Rapp.Ind. Trasf. da Part-time a Part-time', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('PGMSSAMM', 'Stato Servizio Amministrativo', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('PGMSTASE', 'Stato Servizio', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('PGMSTCON', 'Stampa Contratto', null, null);
insert into MODELLI_WORD (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
values ('PGMSTPRO', 'Stampa Proroga del Contratto', null, null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CDIRASST', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)' || chr(10) || '', 'CDIRASSP', null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CNDRCOLT', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)', 'CNDRCOLP', 20);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CNDRSOST', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)', 'CNDRSOSP', 21);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CRUO56ST', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)' || chr(10) || '', 'CRUO56SP', null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CRUO56TT', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)' || chr(10) || '', 'CRUO56TP', null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CRUOASST', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)', 'CRUOASSP', null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CRUOCOIT', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)' || chr(10) || '', 'CRUOCOIP', null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CRUOISMT', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)' || chr(10) || '', 'CRUOISMP', null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CRUOL68T', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)' || chr(10) || '', 'CRUOL68P', null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CRUOMOBT', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)' || chr(10) || '', 'CRUOMOBP', null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CRUOMOST', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)' || chr(10) || '', 'CRUOMOSP', null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CRUOREST', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)' || chr(10) || '', 'CRUORESP', null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CRUORIAT', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)', 'CRUORIAP', null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CRUOSTA2T', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)', 'CRUOSTA2P', null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CRUOSTA6T', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)', 'CRUOSTA6P', null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('CRUOTPTT', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)', 'CRUOTPTP', null);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'ASSEGNI_FAMILIARI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''ASSF''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 16);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'ASSENZE', 'WORD_ASSENZE', 'sede_del||to_char(numero_del)||to_char(anno_del) is not null' || chr(10) || 'and pegi_dal <= p_al' || chr(10) || 'order by pegi_dal', 'PGMASSENZE', 7);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'ATTUALE', 'WORD_PEGI_SE', 'pegi_dal  = (select max(pegi_dal) from word_pegi_se' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and rilevanza = ''S''' || chr(10) || '                       and  pegi_dal <= p_al)', 'PGMATTUALE', 1);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'ATT_LED', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''LED''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 15);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'BENEMERENZE', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''BENE''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 9);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'CARRIERA', 'WORD_CARRIERA', 'rilevanza = ''S''' || chr(10) || 'and pegi_dal <= p_al' || chr(10) || 'order by pegi_dal', 'PGMCARRIERA', 4);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'COMPENSI_PARTICOLARI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''COMP''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 22);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'CONCORSO', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''CONC''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 32);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'DOCENZA', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''DOCE''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 33);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'ENCOMI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''ENCO''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 8);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'FAMILIARI', 'WORD_FAMILIARI', 'dal <= p_al' || chr(10) || 'order by cognome,nome,data_nas', 'PGMFAMILIARI', 2);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'INCARICHI_DIRIGENZIALI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''IDIR''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 18);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'INCARICHI_SPECIALI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''ISPE''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 17);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'INC_EST_PROVINCIA', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''IEST''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 29);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'INDENNITA', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''INDE''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 23);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'INFORTUNIO', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''INFO''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 36);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'ISCR_ALBO_ONAOSI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''ALBO''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 19);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'ISCR_FOND_ONAOSI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''ONA''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 20);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'LIQ_APM', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''LAPM''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 24);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'MALATTIE', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''MALA''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 27);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'NOTE_MERITO', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''NOME''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 35);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'PORTO_ARMI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''ARMI''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 11);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'PREC_OCCUPAZIONI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''SSON''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 31);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'PRIMA_SPEC', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''CORS''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 21);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'PROV_DISCIPLINARI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''DISC''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 13);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'REGGENZE', 'WORD_CARRIERA', 'rilevanza = ''E''' || chr(10) || 'and pegi_dal <= p_al' || chr(10) || 'order by pegi_dal', 'PGMREGGENZE', 5);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'RIC_ECONOMICO', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''RECO''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 12);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'RIC_L29', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''RIC''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 37);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'RUOLO', 'WORD_PEGI_QI', 'rilevanza = ''Q''' || chr(10) || 'and pegi_dal =' || chr(10) || '     (select min(pegi_dal)' || chr(10) || '        from WORD_PEGI_QI' || chr(10) || '       where ci = p_ci' || chr(10) || '         and rilevanza = ''Q''' || chr(10) || '         and pegi_posizione in' || chr(10) || '            (select codice' || chr(10) || '               from posizioni' || chr(10) || '              where di_ruolo = ''R''))' || chr(10) || '  and pegi_dal <= p_al' || chr(10) || '  and pegi_dal = greatest(pegi_dal,figi_dal)', 'PGMRUOLO', 3);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'SEDI', 'WORD_SETTORI', 'pegi_dal <= p_al' || chr(10) || 'order by pegi_dal', 'PGMSEDI', 6);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'SOSP_CAUTELARE', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''SOCA''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 34);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'TRATTENUTE', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''TRAT''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 25);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'VALUTARE_FASC', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''FASC''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 28);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'VALUTARE_PRD', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''PRDI''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 30);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'VISITE_COLLEGIALI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''VICO''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 26);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPE', 'VISITE_PERIODICHE', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''VIPE''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 10);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPF', 'ASSENZE', 'WORD_ASSENZE', 'sede_del||to_char(numero_del)||to_char(anno_del) is not null' || chr(10) || 'and pegi_dal <= p_al' || chr(10) || 'order by pegi_dal', 'PGMASSENZE', 7);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPF', 'ATTUALE', 'WORD_PEGI_SE', 'pegi_dal  = (select max(pegi_dal) from word_pegi_se' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and rilevanza = ''S''' || chr(10) || '                       and  pegi_dal <= p_al)', 'PGMATTUALE', 1);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPF', 'CARRIERA', 'WORD_CARRIERA', 'rilevanza = ''S''' || chr(10) || 'and pegi_dal <= p_al' || chr(10) || 'order by pegi_dal', 'PGMCARRIERA', 4);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPF', 'DOCUMENTI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''dd/mm/yyyy'')) <= nvl(p_al,to_date(sysdate,''dd/mm/yyyy''))' || chr(10) || 'and evento in' || chr(10) || '  (select codice from eventi_giuridici where rilevanza = ''D'')' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 8);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPF', 'FAMILIARI', 'WORD_FAMILIARI', 'dal <= p_al' || chr(10) || 'order by cognome,nome,data_nas', 'PGMFAMILIARI', 2);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPF', 'REGGENZE', 'WORD_CARRIERA', 'rilevanza = ''E''' || chr(10) || 'and pegi_dal <= p_al' || chr(10) || 'order by pegi_dal', 'PGMREGGENZE', 5);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPF', 'RUOLO', 'WORD_PEGI_QI', 'rilevanza = ''Q''' || chr(10) || 'and pegi_dal =' || chr(10) || '     (select min(pegi_dal)' || chr(10) || '        from WORD_PEGI_QI' || chr(10) || '       where ci = p_ci' || chr(10) || '         and rilevanza = ''Q''' || chr(10) || '         and pegi_posizione in' || chr(10) || '            (select codice' || chr(10) || '               from posizioni' || chr(10) || '              where di_ruolo = ''R''))' || chr(10) || '  and pegi_dal <= p_al' || chr(10) || '  and pegi_dal = greatest(pegi_dal,figi_dal)', 'PGMRUOLO', 3);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMFASPF', 'SEDI', 'WORD_SEDI', 'pegi_dal <= p_al' || chr(10) || 'order by pegi_dal', 'PGMSEDI', 6);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMPRFUT', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select min(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al' || chr(10) || '                       and nvl(ser_al,to_date(''3333333'',''j'')) >= p_al' || chr(10) || ')' || chr(10) || '', 'PGMPRFUP', 1);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMRMODT', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select min(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al' || chr(10) || '                       and nvl(ser_al,to_date(''3333333'',''j'')) >= p_al' || chr(10) || ')' || chr(10) || '', 'PGMRMODP', 1);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMRTPTT', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al' || chr(10) || '                       and nvl(ser_al,to_date(''3333333'',''j'')) >= p_al' || chr(10) || ')' || chr(10) || '', 'PGMRTPTP', 1);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMRTTPT', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al' || chr(10) || '                       and nvl(ser_al,to_date(''3333333'',''j'')) >= p_al' || chr(10) || ')' || chr(10) || '', 'PGMRTTPP', 1);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMSSAMM', 'ATTUALE', 'WORD_PEGI_SE', 'pegi_dal  = (select max(pegi_dal) from word_pegi_se' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and rilevanza = ''S''' || chr(10) || '                       and  pegi_dal <= p_al)', 'PGMSSATT', 1);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMSTASE', 'ASSENZE', 'WORD_ASSENZE', 'sede_del||to_char(numero_del)||to_char(anno_del) is not null' || chr(10) || 'and pegi_dal <= p_al' || chr(10) || 'and evento = ''CNR'' ' || chr(10) || 'order by pegi_dal', 'PGMASSENZE', 30);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMSTASE', 'ATTUALE', 'WORD_PEGI_SE', 'pegi_dal  = (select max(pegi_dal) from word_pegi_se' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and rilevanza = ''S''' || chr(10) || '                       and  pegi_dal <= p_al)' || chr(10) || '', 'PGMSSATT', 1);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMSTASE', 'CARRIERA', 'WORD_CARRIERA', 'rilevanza = ''S''' || chr(10) || 'and pegi_dal <= p_al' || chr(10) || 'order by pegi_dal', 'PGMCARRIERA', 3);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMSTASE', 'ENCOMI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''ENCO''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 25);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMSTASE', 'ENTE', 'WORD_ENTE', 'ente_id = ''ENTE''', 'PGMENTE', 2);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMSTASE', 'INCARICHI_DIRIGENZIALI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''IDIR''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 20);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMSTASE', 'INCARICHI_SPECIALI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''ISPE''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 15);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMSTASE', 'INC_EST_PROVINCIA', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''IEST''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 10);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMSTASE', 'PROV_DISCIPLINARI', 'WORD_PEGI_D', 'nvl(dogi_dal,to_date(sysdate,''DD/MM/YYYY'')) <= nvl(p_al,to_date(sysdate,''DD/MM/YYYY''))' || chr(10) || 'and evento = ''DISC''' || chr(10) || 'order by evento,dogi_dal', 'PGMDOCUM', 26);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMSTASE', 'SEDI', 'WORD_SETTORI', 'pegi_dal <= p_al' || chr(10) || 'order by pegi_dal', 'PGMSEDI', 5);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMSTCON', 'CONTRATTO', 'WORD_CONTRATTI', 'ser_dal  = (select min(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al' || chr(10) || '                       and nvl(ser_al,to_date(''3333333'',''j'')) >= p_al' || chr(10) || ')' || chr(10) || '', 'PGMPARCO', 1);
insert into STRUTTURA_MODELLI_WORD (DOCUMENTO, PARAGRAFO, VISTA, CONDIZIONI, SOTTODOCUMENTO, SEQUENZA)
values ('PGMSTPRO', 'PROROGA', 'WORD_CONTRATTI', 'ser_dal  = (select max(ser_dal) from word_contratti' || chr(10) || '                     where ci = p_ci' || chr(10) || '                       and  ser_dal <= p_al)' || chr(10) || '', 'PGMSPCON', 1);

