delete from a_voci_menu  where voce_menu = 'PECSDEIN';
INSERT INTO A_VOCI_MENU 
( VOCE_MENU, AMBIENTE, ACRONIMO, TITOLO, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA )
VALUES ( 'PECSDEIN', 'P00', 'SDEIN', 'Stampa Modulo Denuncia Infortunio', 'F', 'D', 'ACAPARPR', NULL, 1, 'A_PARA', NULL);

delete from a_passi_proc where voce_menu = 'PECSDEIN';
INSERT INTO A_PASSI_PROC 
( VOCE_MENU, PASSO, TITOLO, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING )
VALUES ( 'PECSDEIN', 1, 'Stampa Modulo denuncia Inail', 'R', 'PECSDEIN', NULL, 'PECSDEIN', 'N'); 

delete from a_catalogo_stampe  where stampa = 'PECSDEIN';
INSERT INTO A_CATALOGO_STAMPE
( STAMPA, TITOLO, TIPO_PROPRIETA, TIPO_VISURA, CLASSE, STAMPA_BLOCCATA, STAMPA_PROTETTA, SEQUENZIALE ) 
VALUES ( 'PECSDEIN', 'Stampa Modulo denuncia Inail', 'U', 'U', 'PDF', 'N', 'N', 'S');

delete from a_selezioni where voce_menu = 'PECSDEIN';
INSERT INTO A_SELEZIONI 
( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK )
VALUES (  'P_CI', 'PECSDEIN', 1, 'Codice Individuale:', 8, 'N', 'S', NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI 
( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK )
VALUES ( 'P_DATA', 'PECSDEIN', 2, 'Data Infortunio:', 10, 'D', 'S', NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI 
( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK )
VALUES ( 'P_TUTTI', 'PECSDEIN', 3, 'Stampa tutti i Moduli', 1, 'U', 'N', 'X', 'P_X', NULL, NULL, NULL); 

delete from a_menu where voce_menu = 'PECSDEIN';
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE )
VALUES ( 'GP4', '*', 1013427, 1013428, 'PECSDEIN', 1, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE )
VALUES ( 'GP4', 'AMM', 1013427, 1013428, 'PECSDEIN', 1, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE )
VALUES ( 'GP4', 'PEC', 1013427, 1013428, 'PECSDEIN', 1, NULL); 

INSERT INTO ESTRAZIONE_REPORT 
( ESTRAZIONE, DESCRIZIONE, SEQUENZA, OGGETTO, NUM_RIC, NOTE )
select 'ESTRAZIONE_INFORTUNI', 'Voci per denuncia infortuni', 111, 'PERE', 0, NULL
  from dual
 where not exists ( select 'x' 
                      from ESTRAZIONE_REPORT 
                     where ESTRAZIONE = 'ESTRAZIONE_INFORTUNI'
                  );

INSERT INTO ESTRAZIONE_VALORI_CONTABILI
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE )
select 'ESTRAZIONE_INFORTUNI', '01',  TO_Date( '01/01/2001', 'MM/DD/YYYY'), NULL
, 'Voci per calcolo tariffa 13esima', 1, NULL, NULL, NULL, NULL
  from dual
 where not exists ( select 'x' 
                      from ESTRAZIONE_VALORI_CONTABILI
                     where ESTRAZIONE = 'ESTRAZIONE_INFORTUNI'
                       and COLONNA = '01'
                       and dal = TO_Date( '01/01/2001', 'MM/DD/YYYY')
                  );
				  
INSERT INTO ESTRAZIONE_VALORI_CONTABILI
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE )
select 'ESTRAZIONE_INFORTUNI', 'CAMPO_E',  TO_Date( '01/01/2001', 'MM/DD/YYYY'), NULL
, 'Voci per valorizzazione campo E - Elementi Aggiuntivi', 1, NULL, NULL, NULL, NULL
  from dual
 where not exists ( select 'x' 
                      from ESTRAZIONE_VALORI_CONTABILI
                     where ESTRAZIONE = 'ESTRAZIONE_INFORTUNI'
                       and COLONNA = 'CAMPO_E'
                       and dal = TO_Date( '01/01/2001', 'MM/DD/YYYY')
                  );
				  
INSERT INTO ESTRAZIONE_VALORI_CONTABILI
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE )
select 'ESTRAZIONE_INFORTUNI', 'CAMPO_F',  TO_Date( '01/01/2001', 'MM/DD/YYYY'), NULL
, 'Voci per valorizzazione campo F - Elementi Aggiuntivi', 1, NULL, NULL, NULL, NULL
  from dual
 where not exists ( select 'x' 
                      from ESTRAZIONE_VALORI_CONTABILI
                     where ESTRAZIONE = 'ESTRAZIONE_INFORTUNI'
                       and COLONNA = 'CAMPO_F'
                       and dal = TO_Date( '01/01/2001', 'MM/DD/YYYY')
                  );
				  
INSERT INTO ESTRAZIONE_VALORI_CONTABILI
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE )
select 'ESTRAZIONE_INFORTUNI', 'CAMPO_G',  TO_Date( '01/01/2001', 'MM/DD/YYYY'), NULL
, 'Voci per valorizzazione campo G - Elementi Aggiuntivi', 1, NULL, NULL, NULL, NULL
  from dual
 where not exists ( select 'x' 
                      from ESTRAZIONE_VALORI_CONTABILI
                     where ESTRAZIONE = 'ESTRAZIONE_INFORTUNI'
                       and COLONNA = 'CAMPO_G'
                       and dal = TO_Date( '01/01/2001', 'MM/DD/YYYY')
                  );
				  
INSERT INTO ESTRAZIONE_VALORI_CONTABILI
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE )
select 'ESTRAZIONE_INFORTUNI', 'CAMPO_H',  TO_Date( '01/01/2001', 'MM/DD/YYYY'), NULL
, 'Voci per valorizzazione campo H - Elementi Aggiuntivi', 1, NULL, NULL, NULL, NULL
  from dual
 where not exists ( select 'x' 
                      from ESTRAZIONE_VALORI_CONTABILI
                     where ESTRAZIONE = 'ESTRAZIONE_INFORTUNI'
                       and COLONNA = 'CAMPO_H'
                       and dal = TO_Date( '01/01/2001', 'MM/DD/YYYY')
                  );
				  
INSERT INTO ESTRAZIONE_VALORI_CONTABILI
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE )
select 'ESTRAZIONE_INFORTUNI', 'CAMPO_I',  TO_Date( '01/01/2001', 'MM/DD/YYYY'), NULL
, 'Voci per valorizzazione campo I - Elementi Aggiuntivi', 1, NULL, NULL, NULL, NULL
  from dual
 where not exists ( select 'x' 
                      from ESTRAZIONE_VALORI_CONTABILI
                     where ESTRAZIONE = 'ESTRAZIONE_INFORTUNI'
                       and COLONNA = 'CAMPO_I'
                       and dal = TO_Date( '01/01/2001', 'MM/DD/YYYY')
                  );
				  
INSERT INTO ESTRAZIONE_VALORI_CONTABILI
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE )
select 'ESTRAZIONE_INFORTUNI', 'CAMPO_L',  TO_Date( '01/01/2001', 'MM/DD/YYYY'), NULL
, 'Voci per valorizzazione campo L - Elementi Aggiuntivi', 1, NULL, NULL, NULL, NULL
  from dual
 where not exists ( select 'x' 
                      from ESTRAZIONE_VALORI_CONTABILI
                     where ESTRAZIONE = 'ESTRAZIONE_INFORTUNI'
                       and COLONNA = 'CAMPO_L'
                       and dal = TO_Date( '01/01/2001', 'MM/DD/YYYY')
                  );

alter table eventi_infortunio 
  add POSS_DEC VARCHAR2(2) NULL;  


INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'NO', NULL, '2', 'EVENTI_INFORTUNIO.POSS_DEC', 'La lesione non sembra poter provocare il decesso'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'SI', NULL, '1', 'EVENTI_INFORTUNIO.POSS_DEC', 'La lesione sembra porter provocare il decesso'
, 'CFG', NULL, NULL);