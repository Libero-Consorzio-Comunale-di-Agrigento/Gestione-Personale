afcKC - Application Foundation Classes DB - Oracle Server - Key Constraints & Errors 
__________________________________________________________________________________________
(c) 2004 Gruppo Finmatica - www.ads.it 


Versione: 2007.10  del 31/10/2007


Application Foundation Classes per DataBase Oracle Server. 

Componente "KC" per la inclusione nel progetto della gestione funzionalità base, gestione dei 
"Key Constraints", degli "Errori di Applicazione" e del "Multilinguismo".


Componenti
==========

- afcKC.def	- File per l'attivazione degli script di creazione di "afc KC" sul DataBase.

- afcKCDef.sql	- File richiamato da "afcKC.def" per l'inserimento delle registrazioni di default
                  nelle Tabelle di gestione "Constraints, Errors e Multilinguismo".

- AFC		- Cartella dei files per la creazione Package di Base e Trigger AFC.

- AFC\KC	- Cartella dei files riutilizzati anche da AD4 per la creazione delle Tabelle
                  e dei Package di gestione "Constraints, Errors e Multilinguismo" per le
                  applicazioni del Sistema Informativo V4.     


Prerequisiti
============

- Oracle Versione 8.1.7 o successivi (per versione Oracle 7 deve essere modificato AFC_DML).


Novità:
=======
Elenco delle novità più rilevanti rispetto alle versioni precedenti.

- Introduzione del componente AFC\KC.
- Il file Si4KC.def richiama i file KC direttamente sulla sua cartella senza necessità di avere come 
  prerequisito la presenza dei file di installazione di AD4 sul Client.


Funzionalità:
=============
Caratteristiche del prodotto e modalità d'uso o di installazione.

E' prevista l'installazione con l'uso del programma "Si4insta - DataBase Installer".

Il file "afcKC.def" contiene l'attivazione degli script di generazione "Base Dati Appoggio" per la gestione
"Constraint Error e Multilinguismo".Il file deve essere incluso nei file della propria installazione con 
attivazione dal componente "KC - Base Dati di Appoggio Prodotto" del file .INF.

Istruzioni:
----------
Per la adozione del componente nel proprio progetto operare come segue:

- Includere i componenti AFC nella cartella "ins\ver\afc".

- Includere i componenti AFC "Special" o "Mix" che si intendono utilizzare nella cartella "ins\ver\afc".

- Includere i componenti AFC\KC   nella cartella "ins\ver\afc\kc".

- Copiare i file afcKC.def e afcKCDef.sql nella cartella "ins".

- Modificare il file afcKC.def per eliminare righe di elementi non utilizzati o per togliere il commento
  a righe che attivano elementi facoltativi.



