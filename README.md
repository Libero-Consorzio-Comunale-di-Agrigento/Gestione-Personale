# GP4

Gestione Integrata del Personale
 
## Descrizione
Il prodotto è composto da diversi moduli finalizzati alla gestione anagrafica, giuridica e contabile del personale dipendente o assimilato e dei rapporti occasionali con l’Ente.

Ogni modulo condivide i dati utili con gli altri moduli del prodotto, evitando la duplicazione di informazioni; sono sempre disponibili una serie di funzioni per agevolare il lavoro degli operatori, come la Barra degli strumenti per accedere alle funzionalità di maggiore uso, il Menù verticale per consentire l’accesso alle fasi da una qualsiasi altra fase, la gestione delle elaborazioni batch tramite tecnica di schedulazione, ecc.

Il modulo Anagrafico-Giuridico gestisce i dati dell’Anagrafe Individuale e dei Familiari, i Rapporti con l’Ente e il Fascicolo Personale (Rapporto di Lavoro, Inquadramento, Incarico, Astensioni, Altri Documenti); permette la stampa della Certificazione di Servizio secondo modelli personalizzabili. 
I dati Anagrafici e Giuridici sono utilizzati dalla Dotazione Organica per determinare la copertura dei posti e dal modulo Economico per determinare i valori economici spettanti e le eventuali trattenute o riduzioni per i periodi di assenza.

Il modulo di Dotazione Organica permette la Definizione e Aggiornamento dei Posti in Pianta e del Piano di Assegnazione; le informazioni sono accessibili sia con funzioni di consultazione sia con stampe dedicate.
Per determinare la copertura dei posti vengono utilizzati i dati del modulo Giuridico

Il modulo Economico utilizza le informazioni Anagrafiche e Giuridiche, da cui deriva le informazioni dell’inquadramento economico spettante; permette di specificare per ogni soggetto le informazioni dell’anagrafe economica (IBAN, trattamento previdenziale, ecc.), le informazioni contabili personali (ad es. indennità ad personam) e le rate e voci a scadenza.
La sezione di Retribuzione del Personale permette l’acquisizione dei dati delle Variabili alla Retribuzione (eventualmente forniti da fonti esterne) e permette il Calcolo Retribuzioni collettivo o individuale, con gestione delle mensilità normali, speciali, aggiuntive ed eventuali conguaglio giuridico su mensilità pregresse.
Funzioni specifiche permettono l’interrogazione e la stampa delle retribuzioni e dei dati contabili e fiscali, mensili e progressivi; sono previste la stampa dei movimenti di bilancio e imputazione a bilancio, il riepilogo contributi, il dettaglio oneri, la distinta situazioni debitorie e sindacali, nonché le denunce mensili (DMA, Uniemens) e l’estrazione del file per gli accrediti.
La sezione Situazione Contabile Annuale permette le interrogazioni e stampe dei dati contabili e fiscali annuali, e il trattamento delle denunce annuali: acquisizione e memorizzazione dati comunicati con modello 730 per includerli nel calcolo dei cedolini e per l’esposizione nelle denunce fiscali, estrazione dati per la CU, estrazione dati per il modello 770, autoliquidazione INAIL, denuncia ONAOSI, Statistiche del Ministero del Tesoro (conto annuale).

Nel prodotto sono proposte sia integrazioni verso altri applicativi: contabilità Finanziaria o Economica, Controllo di Gestione, rilevazione presenze (relativamente ai dati anagrafici e giuridici); che di acquisizione dati dall’esterno: variabili mensili (da rilevazione presenze o da altre fonti), periodi di assenza (da ril.pres.). 

## Struttura del Repository
Il repository è suddiviso nelle seguenti cartelle:
- __source__ contiene il codice sorgente e le risorse statiche incluse nella webapp.
- __scriptDB__ contiene gli script PL/SQL per la creazione della struttura dello schema database.
- __diagrammiER__ contiene i diagrammi Entità-Relazione in formato Portable Document Format e Rich Text Format

## Prerequisiti e dipendenze

### Prerequisiti
- Database Oracle versione 10 o superiore 
- Oracle Server 9ias almeno rel. 1 (Patch set 11)
- AD4: Amministrazione Database di Finmatica S.p.A. 
- SI4V3 – Amministrazione di Ambiente di Sistema di Finmatica S.p.A.

### Dipendenze
- Oracle Developer 6i

## Istruzioni per l’installazione:
- Seguire le indicazioni del MIP.Gp4 (Manuale di INstallaizone Prodotto)

## Stato del progetto 
Stabile

## Amministrazione committente
Libero Consorzio Comunale di Agrigento

## Incaricati del mantenimento del progetto open source
Finmatica S.p.A. 
Via della Liberazione, 15
40128 Bologna

## Indirizzo e-mail a cui inviare segnalazioni di sicurezza 
sicurezza@ads.it
