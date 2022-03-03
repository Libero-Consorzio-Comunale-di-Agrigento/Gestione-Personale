alter table estrazione_valori_contabili add
(note_al1                        VARCHAR(240),
 note_al2                        VARCHAR(240)
);

delete from pec_ref_codes where rv_domain = 'DENUNCIA_CUD.ANNOTAZIONI';

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AB_1', 'AB', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Somme corrisposte al percipiente in qualita'' di erede o di avente diritto ai sensi dell''art. 2122'
       ||'del codice civile. Dati del deceduto: Codice Fiscale - ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AB_2', 'AB', 'DENUNCIA_CUD.ANNOTAZIONI'
       , ' ; dati anagrafici: ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AB_3', 'AB', 'DENUNCIA_CUD.ANNOTAZIONI'
       ,' - sesso ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AB_4', 'AB', 'DENUNCIA_CUD.ANNOTAZIONI'
       ,' nata il ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AB_5', 'AB', 'DENUNCIA_CUD.ANNOTAZIONI'
       ,' nato il ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AB_6', 'AB', 'DENUNCIA_CUD.ANNOTAZIONI'
       , ' Le somme indicate nei punti 1 e/o 2 del CUD non devono essere riportate nella dichiarazione dei redditi.');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AB_7', 'AB', 'DENUNCIA_CUD.ANNOTAZIONI'
       , ' Le somme indicate nel punto 68 ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AB_8', 'AB', 'DENUNCIA_CUD.ANNOTAZIONI'
       ,'costituiscono reddito ai sensi dell''articolo 2122 c.c. o leggi speciali corrispondenti.');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AB_9', 'AB', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'sono state corrisposti per eredita''.');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AJ_1', 'AJ', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Importo ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AJ_2', 'AJ', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'delle erogazioni liberali concesse in occasione di festivita'' e ricorrenze pari a Euro ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AJ_3', 'AJ', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'e ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AJ_4', 'AJ', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'dei compensi in natura comunque erogati pari a Euro ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AJ_5', 'AJ', 'DENUNCIA_CUD.ANNOTAZIONI'
       , ' indipendentemente dall''ammontare');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AK_1', 'AK', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Informazioni relative al reddito certificato: '); 
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AK_2', 'AK', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Informazioni relative ai redditi certificati: ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AK_3', 'AK', 'DENUNCIA_CUD.ANNOTAZIONI'
       , ' a tempo determinato');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AK_4', 'AK', 'DENUNCIA_CUD.ANNOTAZIONI'
       , ' a tempo indeterminato');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AK_5', 'AK', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Si precisa che il periodo di lavoro e'' il seguente: ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AK_6', 'AK', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Si precisa che i periodi di lavoro sono i seguenti: ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AK_7', 'AK', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'E'' stato corrisposto un importo pari a Euro: ');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AM_1', 'AM', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Le operazioni di conguaglio sono state effettuate sulla base delle comunicazioni fornite '
       ||'dal Casellario delle pensioni. ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AM_2', 'AM', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Se non si possiedono altri redditi e le operazioni di conguaglio sono state correttamente effettuate, '
       ||'si e'' esonerati dalla presentazione della dichiarazione.');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AN_1','AN', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Cessazione del rapporto di lavoro. ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AN_2','AN', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Le addizionali regionale e comunale sono state interamente trattenute.');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AN_3','AN', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'L'' addizionale regionale e'' stata interamente trattenuta.');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AN_4','AN', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Le addizionali regionale e comunale sono state trattenute per un importo pari a Euro ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AN_5','AN', 'DENUNCIA_CUD.ANNOTAZIONI'
       , ' per la regionale e a Euro ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AN_6','AN', 'DENUNCIA_CUD.ANNOTAZIONI'
       , ' per la comunale. ');          
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AN_7','AN', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'L'' addizionale regionale e'' stata trattenuta per un importo pari a Euro ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AN_8','AN', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'L''addizionale comunale e'' stata interamente trattenuta. '
       ||' Per l''addizionale regionale e'' stato trattenuto un importo pari a Euro ');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AO_1', 'AO', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Rimborsi effettuati dal sostituto a seguito di assistenza fiscale: ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AO_2', 'AO', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'credito Irpef rimborsato: '); 
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AO_3', 'AO', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'credito addizionale regionale rimborsato: '); 
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AO_4', 'AO', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'credito addizionale comunale rimborsato: ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AQ', 'AQ', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Dati relativi agli altri redditi non certificati comunicati dal lavoratore al sostituto per il corretto '
       ||'calcolo delle deduzioni di cui agli artt. 11 e 12, '
       ||'commi 1 e 2 del TUIR: ammontare complessivo degli altri redditi pari a Euro ');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AP_1', 'AP', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'La deduzione base per la progressivita'' dell’imposizione e'' stata ragguagliata al periodo di lavoro. ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AP_2', 'AP', 'DENUNCIA_CUD.ANNOTAZIONI'
       ,'Il percipiente puo'' fruire della deduzione teorica per l’intero anno in sede di dichiarazione dei redditi, '
       ||'sempreche'' non sia stata gia'' attribuita da un altro datore di lavoro e risulti effettivamente spettante.');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AR_1', 'AR', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Dettaglio oneri deducibili: ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AR_2', 'AR', 'DENUNCIA_CUD.ANNOTAZIONI'
       , ': Euro ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AR_3', 'AR', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Tali importi non vanno riportati nella dichiarazione dei redditi.');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AT', 'AT', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Importo della detrazione forfetaria relativa al mantenimento del cane guida pari a Euro ');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AU_1', 'AU', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Dettaglio degli oneri per i quali e'' stata riconosciuta la detrazione del 19% '
       ||'al lordo delle franchigie applicate: ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AU_2', 'AU', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'importo delle spese mediche inferiore alla franchigia ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AU_3', 'AU', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Euro ');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AV_1', 'AV', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Contributi per assistenza sanitaria versati ad enti o casse aventi esclusivamente fini assistenziali. ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AV_2', 'AV', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Le spese sanitarie rimborsate per effetto di tali contributi non sono deducibili o detraibili '
       ||'in sede di dichiarazione dei redditi.');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AV_3', 'AV', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Le spese sanitarie rimborsate per effetto di tali contributi sono deducibili o detraibili '
       ||'in sede di dichiarazione dei redditi in proporzione alla quota di contributi eccedente euro 3.615,20;'
       ||' tale quota e'' pari a euro ');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AW', 'AW', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Spese sanitarie rimborsate per effetto di assicurazioni sanitarie: puo'' essere presentata '
       ||'la dichiarazione dei redditi per far valere deduzioni o detrazioni d’imposta relative alle spese rimborsate');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AX', 'AX', 'DENUNCIA_CUD.ANNOTAZIONI'
       , ' Incapienza della retribuzione a subire il prelievo dell''Irpef dovuta in sede di conguaglio di fine anno: '
       ||'sull''Irpef da trattenere dal sostituto successivamente al 28 febbraio sono dovuti gli interessi nella misura '
       ||'dello 0,50% mensile.');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AY_1', 'AY', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Trattamento di fine rapporto, altre indennita'' e prestazioni in forma di capitale erogate: ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AY_2', 'AY', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'importo maturato fino al 31 dicembre 2000: ');
insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'AY_3', 'AY', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'importo maturato dal 1 gennaio 2001: ');

insert into pec_ref_codes ( RV_LOW_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING )
values ( 'BA', 'BA', 'DENUNCIA_CUD.ANNOTAZIONI'
       , 'Trattamento di fine rapporto: imposta sostitutiva sulla rivalutazione maturata dal 1/1/2001 pari a Euro ');

-- Modifica parametro per CNOCU

delete from a_selezioni where voce_menu = 'PECCNOCU' and parametro = 'P_ANNO_SFASATO';
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO_SFASATO','PECCNOCU','7','Anno Prev.da Nov.(note gg.det)','1','U','N','','P_X','','','');

start crp_pec_reco.sql
start crp_peccnocu.sql