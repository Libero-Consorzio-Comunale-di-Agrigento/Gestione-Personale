-- Inserimento ref_codes per Causale

delete from pec_ref_codes
where rv_domain = 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
;
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'A', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Prestazioni di lavoro autonomo rientranti nell''esercizio di arte o professione abituale');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'B', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Utilizzazione economica, da parte dell’autore o dell''inventore, di opere dell''ingegno, di '
      ||'brevetti industriali e di processi, formule o informazioni relativi ad esperienze acquisite in '
      ||'campo industriale, commerciale o scientifico');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'C', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Utili derivanti da contratti di associazione in partecipazione e da contratti di cointeressenza, '
      ||'quando l''apporto e'' costituito esclusivamente dalla prestazione di lavoro');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'D', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Utili spettanti ai soci promotori ed ai soci fondatori delle societa'' di capitali');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'E', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Levata di protesti cambiari da parte dei segretari comunali');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'F', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Prestazioni rese dagli sportivi con contratto di lavoro autonomo');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'G', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Indennita'' corrisposte per la cessazione di attivita'' sportiva professionale');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'H', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Indennita'' corrisposte per la cessazione dei rapporti di agenzia delle persone fisiche e delle '
      ||'societa'' di persone con esclusione delle somme maturate entro il 31 dicembre 2003, '
      ||'gia'' imputate per competenza e tassate come reddito d''impresa');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'I', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Indennita'' corrisposte per la cessazione da funzioni notarili');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'L', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Utilizzazione economica, da parte di soggetto diverso dall''autore o dall''inventore, di opere '
      ||'dell''ingegno, di brevetti ind.i e di processi, formule e infor. relativi ad esperienze '
      ||'acquisite in campo industriale, commerciale o scientifico');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'M', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Prestazioni di lavoro autonomo non esercitate abitualmente, obblighi di fare, di non fare o permettere');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'N', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Ind. di trasferta, rimborso forfetario di spese, premi e compensi erogati: '
      ||'nell''esercizio diretto di attivita'' sportive dilettantistiche '
      ||'e/o in relazione a rapporti di co.co.co. '
      ||'a favore di soc. e ass. sportive dilettantistiche etc...');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'P', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Compensi corrisposti a soggetti non residenti privi di stabile org. per '
      ||'concessione in uso di attrezzature e/o a soc. svizzere '
      ||'che possiedono i req. di cui all''art. 15, c.2 del 26 ottobre 2004 ( pubb. in G.U.C.E. n.L385/30 del 29/12/2004 )');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'Q', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Provvigioni corrisposte ad agente o rappresentante di commercio monomandatario');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'R', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Provvigioni corrisposte ad agente o rappresentante di commercio plurimandatario');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'S', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Provvigioni corrisposte a commissionario');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'T', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Provvigioni corrisposte a mediatore');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'U', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Provvigioni corrisposte a procacciatore di affari');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'V', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Provvigioni corrisposte a incaricato per le vendite a domicilio');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'W', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Provvigioni corrisposte a incaricato per la vendita porta a porta e per la vendita ambulante '
      ||'di giornali quotidiani e periodici (L. 25 febbraio 1987, n. 67)');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'X', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Canoni corrisposti nel 2004 da soc. o enti residenti o soc. estere '
      ||'di cui all''art. 26-quater, comma 1, lett. a) e b) del D.P.R. 600/73 e/o '
      ||' per i quali e'' stato effettuato, nel 2006, il rimborso della rit. art. 4 del D.L. 30/05/2005 n. 143');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'Y', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Canoni corrisposti dal 01/01/2005 al 26/07/2005 da soc. o enti '
      ||'di cui all''art. 26-quater, comma 1, lett. a) e b) del D.P.R. 600/73 e/o '
      ||' per i quali e'' stato effettuato, nel 2006, il rimborso della rit. art. 4 del D.L. 30/05/2005 n. 143');
insert into pec_ref_codes
( rv_low_value, rv_domain, rv_meaning  )
values( 'Z', 'DENUNCIA_FISCALE_AUTONOMI.CAUSALE'
      , 'Titolo diverso dai precedenti.');


-- Abilitazione voce di menu CADFA archiviazione denuncia fiscale autonomi

delete from a_voci_menu where voce_menu = 'PECCADFA';
delete from a_passi_proc where voce_menu = 'PECCADFA';  
delete from a_selezioni where voce_menu = 'PECCADFA';
delete from a_menu where voce_menu = 'PECCADFA' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa = 'PECCADFA'; 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCADFA','P00','CADFA','Caricamento Archivio Fiscale Autonomi','F','D','ACAPARPR','',1,'P_RAIN_S');  

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADFA','1','Verifica Scadenza denuncia','Q','CHK_SCAD','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADFA','2','Caricamento Archivio Fiscale Autonomi','Q','PECCADFA','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCADFA','3','Verifica presenza errori','Q','CHK_ERR','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCADFA','91','Stampa Segnalazioni Anomalie','R','ACARAPPR','','PECCADFA','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCADFA','92','Cancellazione Segnalazioni','Q','ACACANRP','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_DENUNCIA','PECCADFA','0','Tipo Denuncia','10','U','N','CUD','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANNO','PECCADFA','1','Anno','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_RAPPORTO','PECCADFA','2','Rapporto ...:','4','U','S','%','','CLRA','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECCADFA','3','Archiviazione:','1','U','S','T','P_TIPO','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECCADFA','4','Singolo Individuo : Codice','8','N','N','','','RAIN','1','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_EVENTO','PECCADFA','5','Codice Eventi Eccezionali','1','U','N','','','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000555','1013881','PECCADFA','31','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000555','1013881','PECCADFA','31','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000555','1013881','PECCADFA','31','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ( 'PECCADFA', 'SEGNALAZIONI ARCHIVIAZIONE FISCALE', 'U', 'U', 'A_C', 'N', 'N', 'S'); 

-- Abilitazione voce di menu AADFA Archivio denuncia fiscale autonomi

delete from a_voci_menu where voce_menu = 'PECAADFA';
delete from a_menu where voce_menu = 'PECAADFA' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PECAADFA','P00','AADFA','Agg. Archivio Denuncia Fiscale Autonomi','F','F','PECAADFA','',1,'P_RIRE');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000555','1013882','PECAADFA','32','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000555','1013882','PECAADFA','32','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000555','1013882','PECAADFA','32','');

-- Modifica ordinamento stampa dei lavoratori autonomi SMDSI

update a_menu 
   set sequenza = 33
 where voce_menu = 'PECSMDSI';

start crt_defa.sql
start crp_chk_scad.sql
-- contiene start crp_peccadfa anche per A21421
start crp_peccadfa.sql
start crp_pecsmdsi.sql
start crp_PECCSMFC.sql