INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'11', NULL, NULL, 'DENUNCIA_DMA_QUOTE.TIPO_AMM', 'Riscatto ai fini pensionistici'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'12', NULL, NULL, 'DENUNCIA_DMA_QUOTE.TIPO_AMM', 'Ricongiunzione L.29/79'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'13', NULL, NULL, 'DENUNCIA_DMA_QUOTE.TIPO_AMM', 'Riscatto ai fini TFS'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'14', NULL, NULL, 'DENUNCIA_DMA_QUOTE.TIPO_AMM', 'Mutuo'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'15', NULL, NULL, 'DENUNCIA_DMA_QUOTE.TIPO_AMM', 'Prestito'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'28', NULL, NULL, 'DENUNCIA_DMA_QUOTE.TIPO_AMM', 'Riscatto ai fini TFR'
, 'CFG', NULL, NULL); 

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'R', NULL, NULL, 'DENUNCIA_DMA_QUOTE.OPERAZIONE', 'Rimborso'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'V', NULL, NULL, 'DENUNCIA_DMA_QUOTE.OPERAZIONE', 'Versamento'
, 'CFG', NULL, NULL); 

insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('CARTOLARIZZAZIONE', '1_RICONGIUNZIONE', to_date('01012005','ddmmyyyy'), null
       ,'Ricongiunzione Cassa Stato','12', 50,null ,null,null)
;
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('CARTOLARIZZAZIONE', '2_RICONGIUNZIONE', to_date('01012005','ddmmyyyy'), null
       ,'Ricongiunzione CPDEL','12', 51,null ,null,null)
;
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('CARTOLARIZZAZIONE', '3_RICONGIUNZIONE', to_date('01012005','ddmmyyyy'), null
       ,'Ricongiunzione CPI','12', 52,null ,null,null)
;
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('CARTOLARIZZAZIONE', '5_RICONGIUNZIONE', to_date('01012005','ddmmyyyy'), null
       ,'Ricongiunzione CPS','12', 53,null ,null,null)
;
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('CARTOLARIZZAZIONE', '1_RISCATTO_PENSIONE', to_date('01012005','ddmmyyyy'), null
       ,'Riscatto ai fini pensionistici Cassa Stato','11', 60,null ,null,null)
;
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('CARTOLARIZZAZIONE', '2_RISCATTO_PENSIONE', to_date('01012005','ddmmyyyy'), null
       ,'Riscatto ai fini pensionistici CPDEL','11', 61,null ,null,null)
;
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('CARTOLARIZZAZIONE', '3_RISCATTO_PENSIONE', to_date('01012005','ddmmyyyy'), null
       ,'Riscatto ai fini pensionistici CPI','11', 62,null ,null,null)
;
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('CARTOLARIZZAZIONE', '5_RISCATTO_PENSIONE', to_date('01012005','ddmmyyyy'), null
       ,'Riscatto ai fini pensionistici CPS','11', 63,null ,null,null)
;
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('CARTOLARIZZAZIONE', '6_RISCATTO_TFS', to_date('01012005','ddmmyyyy'), null
       ,'Riscatto ai fini TFS - INADEL','13', 70,null ,null,null)
;
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('CARTOLARIZZAZIONE', '6_RISCATTO_TFR', to_date('01012005','ddmmyyyy'), null
       ,'Riscatto ai fini TFR - INADEL','28', 75,null ,null,null)
;
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('CARTOLARIZZAZIONE', '7_RISCATTO_TFS', to_date('01012005','ddmmyyyy'), null
       ,'Riscatto ai fini TFS - ENPAS ','13', 77,null ,null,null)
;
insert into estrazione_valori_contabili 
       (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
values ('CARTOLARIZZAZIONE', '7_RISCATTO_TFR', to_date('01012005','ddmmyyyy'), null
       ,'Riscatto ai fini TFR - ENPAS','28', 78,null ,null,null)
;


column C1 noprint new_value P1

select count(*) C1
  from anagrafici
 where al is null
;

start crt_ddmq.sql &P1
start crq_ddmq.sql
