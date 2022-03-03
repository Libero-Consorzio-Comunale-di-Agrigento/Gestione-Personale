delete from a_voci_menu where voce_menu = 'PECSMDSI';     
delete from a_passi_proc where voce_menu = 'PECSMDSI';    
delete from a_selezioni where voce_menu = 'PECSMDSI';     
delete from a_menu where voce_menu = 'PECSMDSI' and ruolo in ('*','AMM','PEC');
delete from a_catalogo_stampe where stampa = 'PECSMDSI';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECSMDSI','P00','SMDSI','Modello Dichiarazione Sostituti Imposta','F','D','ACAPARPR','FINE_ANNO',1,'P_INDI_S');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMDSI','1','Estrazione dati per Stampa CUD','Q','PECSMDSI','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMDSI','2','Modello Dichiarazione Sostituti Imposta','R','PECSMDSI','','PECSMDSI','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMDSI','3','Eliminazione registrazioni di lavoro','Q','ACACANAS','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANNO','PECSMDSI','1','Elaborazione : Anno','4','N','N','','','','','');      
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ARTICOLO','PECSMDSI','2','Estremi legge:','55','C','N','','','','','');      
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECSMDSI','3','Individuale  : Codice','8','N','N','','','RAIN','0','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_1','PECSMDSI','4','Collettiva   : Raggruppam. 1)','15','U','S','%','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_SEGNO','PECSMDSI','5','Stampa Imp. in Val. Assol.','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_NOTE_1','PECSMDSI','6','Note fisse: 1 Riga','70','C','N','','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_NOTE_2','PECSMDSI','7','    2 Riga','70','C','N','','','','','');     

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','PEC','1000555','1004856','PECSMDSI','32','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','*','1000555','1004856','PECSMDSI','32','');  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1000555','1004856','PECSMDSI','32','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSMDSI','STAMPA MODULO DICHIARAZIONE SOSTITUTI IMPOSTA','U','U','A_A','N','N','S'); 

start crp_pecsmdsi.sql

INSERT INTO ESTRAZIONE_REPORT 
( ESTRAZIONE, DESCRIZIONE, SEQUENZA, OGGETTO, NUM_RIC,NOTE ) 
VALUES ( 'DENUNCIA_SOSTITUTI', 'Modello di Dichiarazione per Sostituti Imposta', 100, 'RAGI', 0, 'PECSMDSI - PECL70SC'); 

INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE ) 
VALUES ( 'DENUNCIA_SOSTITUTI', 'COMPETENZE',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Competenza ', 1, 'Vengono aggiunte nelle righe Totale e Non Soggette di SMDSI', NULL, NULL, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE ) 
VALUES ( 'DENUNCIA_SOSTITUTI', 'ALTRE_COMP',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Altre Competenze Non soggette ', 2, 'Vengono aggiunte nella riga Non Soggette di SMDSI', NULL, NULL, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE ) 
VALUES ( 'DENUNCIA_SOSTITUTI', 'R_NO_FISC',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Ritenute non soggette a Fiscale ', 3, 'Vengono aggiunte nella riga Non Soggette di SMDSI', NULL, NULL, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE ) 
VALUES ( 'DENUNCIA_SOSTITUTI', 'R_INPS',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Ritenuta INPS', 4, NULL, NULL, NULL, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE ) 
VALUES ( 'DENUNCIA_SOSTITUTI', 'C_INPS',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Contributo INPS carico Ente', 5, NULL, NULL, NULL, NULL); 
INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE ) 
VALUES ( 'DENUNCIA_SOSTITUTI', 'ALTRE_RIT',  TO_Date( '01/01/2000 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Altre Ritenute', 6, 'Vengono stampante nella riga Altre ritenute di SMDSI', NULL, NULL, NULL); 


BEGIN
DECLARE
V_conta number(3) := 0;
V_sequenza number(3) := 0;
BEGIN
   FOR CUR_VOCE IN 
       ( select distinct covo.voce, covo.sub , voec.tipo, covo.somme, covo.fiscale
           from contabilita_voce covo
              , voci_economiche voec
          where to_date('01122005','ddmmyyyy')
                between nvl(covo.dal,to_date('2222222','j')) and nvl(covo.al,to_date('3333333','j'))
            and covo.somme in ('1', '2', '3', '4', '5', '6', '7', '8', '9', '11', '12', '18') 
            and voec.codice = covo.voce
       ) LOOP
      BEGIN
      V_sequenza := nvl(V_sequenza,0) + 1;
      INSERT INTO ESTRAZIONE_RIGHE_CONTABILI 
      ( ESTRAZIONE, COLONNA, DAL, AL, SEQUENZA, VOCE, SUB, TIPO, SEGNO1, DATO1 ) 
       select 'DENUNCIA_SOSTITUTI'
            , decode( cur_voce.somme
                    , '1', decode( CUR_VOCE.tipo, 'C', 'COMPETENZE','ALTRE_RIT')
                    , '2', decode( CUR_VOCE.tipo, 'C', 'COMPETENZE','ALTRE_RIT')
                    , '3', decode( CUR_VOCE.tipo, 'C', 'COMPETENZE','ALTRE_RIT')
                    , '4', decode( CUR_VOCE.tipo, 'C', 'COMPETENZE','ALTRE_RIT')
                    , '5', decode( CUR_VOCE.tipo, 'C', 'COMPETENZE','ALTRE_RIT')
                    , '6', decode( CUR_VOCE.tipo, 'C', 'COMPETENZE','ALTRE_RIT')
                    , '7', decode( CUR_VOCE.tipo, 'C', 'COMPETENZE','ALTRE_RIT')
                    , '8', decode( CUR_VOCE.tipo, 'C', 'COMPETENZE','ALTRE_RIT')
                    , '9', decode( CUR_VOCE.tipo, 'C', 'COMPETENZE','ALTRE_RIT')
                    , '18','ALTRE_COMP'
                    , '11', 'R_INPS'
                    , '12', 'C_INPS'
                    )
            , to_date('01012000','ddmmyyyy')
            , null
            , V_sequenza
            , CUR_VOCE.voce
            , CUR_VOCE.sub
            , 'P'
            , decode( cur_voce.somme
                    , '1', decode( CUR_VOCE.tipo, 'T', '*', null)
                    , '2', decode( CUR_VOCE.tipo, 'T', '*', null)
                    , '3', decode( CUR_VOCE.tipo, 'T', '*', null)
                    , '4', decode( CUR_VOCE.tipo, 'T', '*', null)
                    , '5', decode( CUR_VOCE.tipo, 'T', '*', null)
                    , '6', decode( CUR_VOCE.tipo, 'T', '*', null)
                    , '7', decode( CUR_VOCE.tipo, 'T', '*', null)
                    , '8', decode( CUR_VOCE.tipo, 'T', '*', null)
                    , '9', decode( CUR_VOCE.tipo, 'T', '*', null)
                    , '18', decode( CUR_VOCE.tipo, 'T', '*', null)
                    , '11', decode( CUR_VOCE.tipo, 'T', '*', null)
                    , '12', decode( CUR_VOCE.tipo, 'T', '*', null)
                    )

             , decode( cur_voce.somme
                    , '1', decode( CUR_VOCE.tipo, 'T', -1,null)
                    , '2', decode( CUR_VOCE.tipo, 'T', -1,null)
                    , '3', decode( CUR_VOCE.tipo, 'T', -1,null)
                    , '4', decode( CUR_VOCE.tipo, 'T', -1,null)
                    , '5', decode( CUR_VOCE.tipo, 'T', -1,null)
                    , '6', decode( CUR_VOCE.tipo, 'T', -1,null)
                    , '7', decode( CUR_VOCE.tipo, 'T', -1,null)
                    , '8', decode( CUR_VOCE.tipo, 'T', -1,null)
                    , '9', decode( CUR_VOCE.tipo, 'T', -1,null)
                    , '18', decode( CUR_VOCE.tipo, 'T', -1,null)
                    , '11', decode( CUR_VOCE.tipo, 'T', -1,null)
                    , '12', decode( CUR_VOCE.tipo, 'T', -1,null)
                    )
        from dual;
     commit;
      END;
    END LOOP; -- cur_voce

   FOR CUR_VOCE_1 IN 
       ( select distinct covo.voce, covo.sub , voec.tipo, covo.somme, covo.fiscale
           from contabilita_voce covo
              , voci_economiche voec
          where to_date('01122005','ddmmyyyy')
                between nvl(covo.dal,to_date('2222222','j')) and nvl(covo.al,to_date('3333333','j'))
            and covo.somme = '19'
            and covo.fiscale = 'N'
            and voec.tipo = 'T'
            and voec.codice = covo.voce
       ) LOOP
      BEGIN
      V_sequenza := nvl(V_sequenza,0) + 1;
      INSERT INTO ESTRAZIONE_RIGHE_CONTABILI 
      ( ESTRAZIONE, COLONNA, DAL, AL, SEQUENZA, VOCE, SUB, TIPO, SEGNO1, DATO1 ) 
       select 'DENUNCIA_SOSTITUTI'
            , 'R_NO_FISC'
            , to_date('01012000','ddmmyyyy')
            , null
            , V_sequenza
            , CUR_VOCE_1.voce
            , CUR_VOCE_1.sub
            , 'P'
            , '*'
            , '-1'
        from dual;
     commit;
      END;
    END LOOP; -- cur_voce
END;
END;
/