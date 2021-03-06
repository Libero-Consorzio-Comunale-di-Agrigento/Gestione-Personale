delete from RELAZIONE_COND_OGGETTO 
where  OGGETTO = 'REIN'
and RIFERIMENTO =  'ASIN' ; 

delete from RELAZIONE_RIFE_OGGETTO 
where  OGGETTO = 'REIN'
and RIFERIMENTO =  'ASIN' ; 

INSERT INTO RELAZIONE_OGGETTI ( OGGETTO, DESCRIZIONE, TABELLA ) 
VALUES ( 'ASIN_REIN', 'Posizioni Assicurative INAIL ( per Autoliquidazione )', 'ASSICURAZIONI_INAIL');

INSERT INTO RELAZIONE_ATTRIBUTI ( ATTRIBUTO, DESCRIZIONE, OGGETTO, COLONNA )
VALUES ( 'INAIL_REIN', 'Codice identificativo della Posizione INAIL', 'ASIN_REIN', 'ASIN_REIN.codice'); 
INSERT INTO RELAZIONE_ATTRIBUTI ( ATTRIBUTO, DESCRIZIONE, OGGETTO, COLONNA ) 
VALUES ( 'INAIL_REIN_D', 'Descrizione della Posizione INAIL', 'ASIN_REIN', 'ASIN_REIN.descrizione'); 
INSERT INTO RELAZIONE_ATTRIBUTI ( ATTRIBUTO, DESCRIZIONE, OGGETTO,COLONNA ) 
VALUES ( '_INAIL_REIN', 'Sequenza di esposizione della Posizione INAIL', 'ASIN_REIN', 'nvl(to_char(ASIN_REIN.sequenza),''999999'')'); 


INSERT INTO RELAZIONE_CHIAVI ( CHIAVE, DESCRIZIONE, NOME )
VALUES ( 'INAIL_REIN', 'Posizione INAIL ( per Autoliquidazione )', 'I.N.A.I.L.'); 


INSERT INTO RELAZIONE_ATTR_CHIAVE ( CHIAVE, SEQUENZA, ATTRIBUTO, DESCRIZIONE, ALIAS )
VALUES ( 'INAIL_REIN', 1, '_INAIL_REIN', 'Sequenza di esposizione', 'S'); 
INSERT INTO RELAZIONE_ATTR_CHIAVE ( CHIAVE, SEQUENZA, ATTRIBUTO, DESCRIZIONE, ALIAS )
VALUES ( 'INAIL_REIN', 2, 'INAIL_REIN', 'Codice', 'C'); 
INSERT INTO RELAZIONE_ATTR_CHIAVE ( CHIAVE, SEQUENZA, ATTRIBUTO, DESCRIZIONE, ALIAS )
VALUES ( 'INAIL_REIN', 3, 'INAIL_REIN_D', 'Descrizione', 'D'); 

INSERT INTO RELAZIONE_RIFE_OGGETTO ( OGGETTO, RIFERIMENTO ) 
VALUES ( 'REIN', 'ASIN_REIN'); 

INSERT INTO RELAZIONE_COND_OGGETTO ( OGGETTO, RIFERIMENTO, SEQUENZA, RELAZIONE )
VALUES ( 'ASIN_REIN', 'REIN', 1, 'and REIN.POSIZIONE_INAIL = ASIN_REIN.codice');
