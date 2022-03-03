alter table eventi_infortunio 
modify IMPORTO  NUMBER(12,2);

insert into a_errori ( errore, descrizione )
values ('P00570', 'Mancano Informazioni per Calcolare Importo');

insert into a_errori ( errore, descrizione )
values ('P00571', 'Importo Calcolato Nullo');

start crp_gp4_evin.sql

INSERT INTO ESTRAZIONE_REPORT 
( ESTRAZIONE, DESCRIZIONE, SEQUENZA, OGGETTO, NUM_RIC, NOTE )
VALUES ( 'ESTRAZIONE_INFORTUNI', 'Voci per denuncia infortuni', 111, 'PERE', 0, NULL); 

INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE )
VALUES ( 'ESTRAZIONE_INFORTUNI', 'ACCESSORIE',  TO_Date( '01/01/2001 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Voci per Estrazione Importo Accessorie', 100, NULL, NULL, NULL, NULL); 

INSERT INTO ESTRAZIONE_VALORI_CONTABILI 
( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE )
VALUES ( 'ESTRAZIONE_INFORTUNI', 'TREDICESIMA',  TO_Date( '01/01/2001 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, 'Voci per Estrazione Importo Accessorie', 100, NULL, NULL, NULL, NULL);

BEGIN
FOR CUR_VOCE IN 
( select voce, sub, rownum
    from contabilita_voce covo
       , voci_economiche voec
   where ( voce, sub ) in ( select voce, nvl(sub,covo.sub)
                              from totalizzazioni_voce
                             where voce_acc like '%CP%'
                          )
     and ( voce, sub ) not in ( select voce, nvl(sub,covo.sub)
                                  from totalizzazioni_voce
                                 where voce_acc like '%INADEL%'
                          )
     and voec.codice = covo.voce
     and voec.tipo = 'C'
) LOOP
 BEGIN
    INSERT INTO ESTRAZIONE_RIGHE_CONTABILI
    ( ESTRAZIONE, COLONNA, DAL, SEQUENZA, VOCE, SUB, TIPO )
    select 'ESTRAZIONE_INFORTUNI'
         , 'ACCESSORIE'
         , TO_Date( '01/01/2001', 'MM/DD/YYYY')
         , CUR_VOCE.rownum
         , CUR_VOCE.voce
         , CUR_VOCE.sub
         , 'I'
      from dual;
 EXCEPTION WHEN OTHERS THEN NULL;      
 END;
END LOOP;
END;
/
