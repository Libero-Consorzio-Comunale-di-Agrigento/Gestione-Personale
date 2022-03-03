CREATE OR REPLACE PACKAGE PECCSMDD IS
/******************************************************************************
 NOME:          PECCSMDD CREAZIONE SUPPORTO MAGNETICO INADEL 
 DESCRIZIONE:   
      Questa fase produce un file secondo i tracciati imposti dalla 
      Direzione INADEL, leggendo i dati archiviati con la fase << CARDD >>.
      Il file prodotto si trovera' nella directory \\dislocazione\sta del report server con il nome  
      PECCSMDD.txt .

      N.B.: La gestione che deve risultare come intestataria della denuncia 
            deve essere stata inserita in << DGEST >> in modo tale che la 
            ragione sociale (campo nome) risulti essere la minore di tutte 
            le altre eventualmente inserite.
            Lo stesso risultato si raggiunge anche inserendo un BLANK prima
            del nome di tutte le gestioni che devono essere escluse.
 ARGOMENTI:   
      Creazione del flusso per la Denuncia Contributiva Annuale INADEL su    
      supporto magnetico (nastro a 9 piste - EBCDIC - lung. 256 crt.).
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000             
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
 PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/

CREATE OR REPLACE PACKAGE BODY PECCSMDD IS
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.0 del 20/01/2003';
 END VERSIONE;
 PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER) IS
BEGIN
DECLARE

P_anno         varchar2(4);
P_par_inadel   varchar2(12);
P_pos_inadel   varchar2(12);
P_gestione     varchar2(12);
P_disciplinari varchar2(9);
P_riga         number:=0;

BEGIN
 BEGIN

--         Estrazione Parametri per Elaborazione
begin
      select substr(valore,1,4)               D_anno
	    into P_anno
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_ANNO'
      ;
--        Preleva Anno di Riferimento Fine Anno se non specificato
exception when no_data_found then
      select nvl(P_anno,to_char(anno))  D_anno
	    into P_anno
        from riferimento_fine_anno
       where rifa_id = 'RIFA'
      ;
end;	  
begin	  
      select substr(valore,1,12)              D_par_inadel
	    into P_par_inadel
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_POS_INADEL'
      ;
--        Preleva Codice e Posizione Inadel della Gestione Principale
exception when no_data_found then

      select nvl(P_gestione,gest.codice)
           , nvl(P_pos_inadel,gest.posizione_inadel)
		into P_gestione,P_pos_inadel
        from gestioni gest
       where gest.nome = (select min(nome) from gestioni
                           where posizione_inadel like nvl(P_par_inadel,'%')
                             and substr(nome,1,1) != ' ')
         and exists
            (select 'x' from denuncia_inadel deid
                           , gestioni
              where deid.anno        = P_anno
                and deid.gestione    = gestioni.codice
                and posizione_inadel = gest.posizione_inadel
            )
       ;
end;	  
begin	  
      select rpad(substr(valore,1,9),9,'0')   D_disciplinari
	    into P_disciplinari
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_DISCIPLINARI'
      ;
exception when no_data_found then
	  P_disciplinari := null;
end;	  

END;

FOR CUR_CI_1 IN (
select '0'
     || substr(lpad(gest.posizione_inadel,12,'0'),4,8)
     || substr(lpad(gest.posizione_inadel,12,'0'),12,1)
     || lpad(' ',25,' ')
     || substr(rpad(gest.codice_fiscale,16,' '),1,11)
     || P_anno
     || nvl(P_disciplinari,'000000000')
     || rpad( decode( instr(cost.dpr,'/')
                   , 0, nvl(cost.dpr,' ')
                      , substr(cost.dpr,1,instr(cost.dpr,'/')-1)
                   )
           , 4, ' ')
     || substr(to_char(cost.dal,'ddmmyyyy'),1,8)
     || lpad(' ',185,' ')						stringa_1
  from gestioni gest
     , contratti_storici cost
 where gest.codice            = P_gestione
   and ( nvl(cost.dal,to_date('3333333','j'))
       , nvl(cost.contratto,' ')
       ) =
      (select nvl(substr(max(dal||contratto),1,9),to_date('3333333','j'))
            , nvl(substr(max(dal||contratto),10,4),' ')
         from contratti_storici
        where dal         <= to_date( '3112'||P_anno,'ddmmyyyy')
          and nvl(al,to_date('3333333','j'))>=to_date( '01'||P_anno,'mmyyyy')
          and con_inps = 'EP')

)LOOP
 BEGIN
 P_riga:=P_riga+1;
 insert into a_appoggio_stampe
 values (prenotazione,passo,1,P_riga,cur_ci_1.stringa_1);
 END;
 END LOOP;
FOR CUR_CI_2 IN(
select '1'
     || substr(lpad(P_pos_inadel,12,'0'),4,8)
     || substr(lpad(P_pos_inadel,12,'0'),12,1)
     || '         '
     || rpad(max(anag.codice_fiscale),16,' ')
     || '1'
     || substr(max(rtrim(anag.cognome)||' '||anag.nome),1,23)
     || substr(decode(max(posi.di_ruolo),'R',1,2),1,1)
     || max(anag.sesso)
     || substr(nvl(max(qual.cat_inadel),0),1,1)
     || lpad(nvl(max(qual.qua_inadel),0),2,0)
     || substr(nvl(to_char(max(deid.data_assunzione),'ddmmyy'),'      '),1,6)
     || substr(nvl(to_char(max(deid.data_passaggio),'ddmmyy'),'      '),1,6)
     || substr(nvl(to_char(max(deid.data_cessazione),'ddmmyy'),'      '),1,6)
     || substr( nvl(decode( to_char(max(deid.data_assunzione),'yyyy')
                         , P_anno, 'A'||to_char( max(deid.data_assunzione)
                                                  , 'ddmmyy')
                                    , null)
                  , '       '),1,7)
     || substr( nvl(decode( to_char(max(deid.data_passaggio),'yyyy')
                         , P_anno, 'P'||to_char( max(deid.data_passaggio)
                                                  , 'ddmmyy')
                                    , null)
                  , '       '),1,7)
     || substr( nvl(decode( to_char(max(deid.data_cessazione),'yyyy')
                         , P_anno, 'C'||to_char( max(deid.data_cessazione)
                                                  ,'ddmmyy')
                                    , null)
                  , '       '),1,7)
     || nvl(max(deid.tp),' ')
     || substr(nvl(to_char(max(aste1.sequenza)),' '),1,1)
     || lpad(nvl(to_char(max(deid.gg_asp1)),' '),3,' ')
     || substr(nvl(to_char(max(aste2.sequenza)),' '),1,1)
     || lpad(nvl(to_char(max(deid.gg_asp2)),' '),3,' ')
     || substr(nvl(to_char(max(aste3.sequenza)),' '),1,1)
     || lpad(nvl(to_char(max(deid.gg_asp3)),' '),3,' ')
     || 'A'
     || lpad(sum(decode( diid.riferimento||diid.codice
                      , 'A',diid.importo,0)),9,0)
     || 'B'
     || lpad(sum(decode( diid.riferimento||diid.codice
                      , 'B',diid.importo,0)),9,0)
     || rpad( max(decode(diid.riferimento||diid.codice,'C','C',null))||
             max(decode(diid.riferimento||diid.codice,'D','D',null))||
             max(decode(diid.riferimento||diid.codice,'E','E',null))||
             max(decode(diid.riferimento||diid.codice,'F','F',null))||
             max(decode(diid.riferimento||diid.codice,'G','G',null))||
             max(decode(diid.riferimento||diid.codice,'H','H',null))||
             max(decode(diid.riferimento||diid.codice,'I','I',null))||
             max(decode(diid.riferimento||diid.codice,'J','J',null))||
             max(decode(diid.riferimento||diid.codice,'K','K',null))||
             max(decode(diid.riferimento||diid.codice,'L','L',null))||
             max(decode(diid.riferimento||diid.codice,'M','M',null))||
             max(decode(diid.riferimento||diid.codice,'N','N',null))||
             max(decode(diid.riferimento||diid.codice,'O','O',null))||
             max(decode(diid.riferimento||diid.codice,'P','P',null))||
             max(decode(diid.riferimento||diid.codice,'Q','Q',null))||
             max(decode(diid.riferimento||diid.codice,'R','R',null))||
             max(decode(diid.riferimento||diid.codice,'S','S',null))||
             max(decode(diid.riferimento||diid.codice,'T','T',null))||
             max(decode(diid.riferimento||diid.codice,'U','U',null))||
             max(decode(diid.riferimento||diid.codice,'V','V',null))||
             max(decode(diid.riferimento||diid.codice,'W','W',null))||
             max(decode(diid.riferimento||diid.codice,'X','X',null))||
             max(decode(diid.riferimento||diid.codice,'Y','Y',null))||
             max(decode(diid.riferimento||diid.codice,'Z','Z',null))
           , 7, ' ')
     || lpad(sum(decode( diid.riferimento
                      , null, decode(diid.codice,'A',0,'B',0,diid.importo)
                            , 0
                      )),9,0)
     || rpad(
       max(decode( diid.riferimento
                 , diid.anno-6,substr(diid.riferimento,3,2),null))||
       rpad(
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'A','A',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'B','B',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'C','C',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'D','D',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'E','E',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'F','F',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'G','G',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'H','H',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'I','I',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'J','J',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'K','K',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'L','L',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'M','M',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'N','N',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'O','O',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'P','P',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'Q','Q',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'R','R',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'S','S',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'T','T',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'U','U',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'V','V',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'W','W',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'X','X',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'Y','Y',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-6||'Z','Z',null))
       ,6,' ')||
       max(decode( diid.riferimento
                 , diid.anno-5,substr(diid.riferimento,3,2),null))||
       rpad(
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'A','A',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'B','B',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'C','C',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'D','D',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'E','E',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'F','F',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'G','G',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'H','H',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'I','I',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'J','J',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'K','K',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'L','L',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'M','M',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'N','N',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'O','O',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'P','P',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'Q','Q',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'R','R',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'S','S',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'T','T',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'U','U',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'V','V',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'W','W',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'X','X',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'Y','Y',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-5||'Z','Z',null))
       ,6,' ')||
       max(decode( diid.riferimento
                 , diid.anno-4,substr(diid.riferimento,3,2),null))||
       rpad(
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'A','A',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'B','B',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'C','C',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'D','D',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'E','E',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'F','F',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'G','G',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'H','H',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'I','I',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'J','J',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'K','K',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'L','L',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'M','M',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'N','N',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'O','O',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'P','P',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'Q','Q',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'R','R',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'S','S',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'T','T',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'U','U',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'V','V',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'W','W',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'X','X',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'Y','Y',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-4||'Z','Z',null))
       ,6,' ')||
       max(decode( diid.riferimento
                 , diid.anno-3,substr(diid.riferimento,3,2),null))||
       rpad(
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'A','A',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'B','B',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'C','C',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'D','D',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'E','E',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'F','F',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'G','G',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'H','H',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'I','I',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'J','J',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'K','K',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'L','L',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'M','M',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'N','N',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'O','O',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'P','P',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'Q','Q',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'R','R',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'S','S',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'T','T',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'U','U',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'V','V',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'W','W',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'X','X',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'Y','Y',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-3||'Z','Z',null))
       ,6,' ')||
       max(decode( diid.riferimento
                 , diid.anno-2,substr(diid.riferimento,3,2),null))||
       rpad(
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'A','A',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'B','B',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'C','C',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'D','D',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'E','E',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'F','F',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'G','G',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'H','H',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'I','I',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'J','J',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'K','K',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'L','L',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'M','M',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'N','N',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'O','O',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'P','P',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'Q','Q',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'R','R',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'S','S',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'T','T',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'U','U',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'V','V',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'W','W',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'X','X',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'Y','Y',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-2||'Z','Z',null))
       ,6,' ')||
       max(decode( diid.riferimento
                 , diid.anno-1,substr(diid.riferimento,3,2),null))||
       rpad(
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'A','A',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'B','B',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'C','C',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'D','D',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'E','E',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'F','F',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'G','G',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'H','H',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'I','I',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'J','J',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'K','K',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'L','L',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'M','M',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'N','N',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'O','O',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'P','P',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'Q','Q',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'R','R',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'S','S',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'T','T',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'U','U',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'V','V',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'W','W',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'X','X',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'Y','Y',null))||
       max(decode(diid.riferimento||diid.codice,diid.anno-1||'Z','Z',null))
       ,6,' ')
       , 48)
     || lpad(nvl(sum(decode(diid.riferimento,null,0,diid.importo)),0),9,0)
     || lpad(nvl(sum(diid.importo),0),9,0)
     || lpad(' ',38,' ')				  stringa_2
  from posizioni                posi
     , astensioni               aste1
     , astensioni               aste2
     , astensioni               aste3
     , qualifiche               qual
     , anagrafici               anag
     , denuncia_importi_inadel  diid
     , denuncia_inadel          deid
 where deid.anno      = to_number(P_anno)
   and anag.ni        = (select ni from rapporti_individuali
                        where ci = deid.ci)
   and deid.gestione in (select codice from gestioni
                          where posizione_inadel = P_pos_inadel)
   and diid.anno      = deid.anno
   and diid.ci        = deid.ci
   and posi.codice         = (select pegi.posizione
                                from periodi_giuridici pegi
                               where pegi.ci        = deid.ci
                                 and pegi.rilevanza = 'S'
                                 and pegi.dal       =
                                    (select max(dal) from periodi_giuridici
                                      where ci        = pegi.ci
                                        and rilevanza = 'S'
                                        and dal      <= to_date('3112'||
                                                                deid.anno
                                                               ,'ddmmyyyy')
                                    ))
   and qual.numero  (+) = deid.qualifica
   and aste1.codice (+) = deid.cod_asp1
   and aste2.codice (+) = deid.cod_asp2
   and aste3.codice (+) = deid.cod_asp3
 group by deid.anno,deid.ci

)LOOP
 BEGIN
 P_riga:=P_riga+1;
 insert into a_appoggio_stampe
 values (prenotazione,passo,1,P_riga,cur_ci_2.stringa_2);
 END;
 END LOOP;
END;
END;
END;
/

