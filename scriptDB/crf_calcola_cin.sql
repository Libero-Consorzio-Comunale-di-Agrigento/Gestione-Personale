CREATE OR REPLACE FUNCTION CALCOLA_CIN
/******************************************************************************
 NOME:        Function CALCOLA_CIN
 DESCRIZIONE: La funzione permette di calcolare / controllare il codice CIN 
              presupponendo di avere in input una stringa di 23 caratteri 
              composta da :
              CODICE CIN      posizione 1 - lunghezza 1 
              CODICE ABI      posizione 2 - lunghezza 5 
                              allineato a dx con ZERI di riempimento a sx 
              CODICE CAB      posizione 7 - lunghezza 5
                              allineato a dx con ZERI di riempimento a sx 
              CONTO CORRENTE  posizione 12 - lunghezza 12
                              allineato a dx con ZERI di riempimento a sx 

 REVISIONI:
 Rev. Data        Autore  Descrizione
 ---- ----------  ------  -----------------------------------------------------
 1    10/08/2004  MS      Creazione Function
******************************************************************************/
( p_stringa        varchar2
)
 RETURN varchar IS
 d_cin             varchar2(1);
 rval_dispari      varchar2(52) := '0100050709131517192102041820110306081214161022252423';
 
 P_posizione  varchar2(2);
 p_indice          number;
 v_appoggio        varchar2(40);
 v_totale          number;

 BEGIN
  IF length(ltrim(rtrim(substr(p_stringa,12,12)))) = 0
  then null;
  ELSE
     p_posizione := 2;
   for cursor in 2..23 LOOP
	 IF translate(substr(p_stringa, p_posizione, 1 ),'0123456789','0000000000') = '0'
       THEN 
/* carattere numerico */
         IF round( p_posizione/2) - trunc( p_posizione/2) != 0
            THEN
            v_totale := nvl(v_totale,0) + ascii ( substr(p_stringa, p_posizione, 1 ) ) - 48;
         ELSE
            p_indice :=  ascii ( substr(p_stringa, p_posizione, 1 ) ) -48   + 1 ;
            select substr( rval_dispari, p_indice*2-1, 2 )
              into v_appoggio 
              from dual;
            v_totale := nvl(v_totale,0) + nvl(v_appoggio,0) ;
         END IF; -- controllo pari - dispari
     ELSE
/* carattere non numerico */
         IF  round( p_posizione/2) - trunc( p_posizione/2) != 0
           THEN
           select ascii(substr(p_stringa, p_posizione, 1)) - 65
             into v_appoggio
             from dual;
            v_totale := nvl(v_totale,0) + nvl(v_appoggio,0) ;
         ELSE
            p_indice :=  ascii(substr(p_stringa, p_posizione, 1)) - 65 + 1 ;
            select substr( rval_dispari, p_indice*2-1, 2 )
              into v_appoggio 
              from dual;
            v_totale := nvl(v_totale,0) + nvl(v_appoggio,0) ;
         END IF; -- controllo pari - dispari
     END IF; -- controllo su dato numerico
	 P_posizione := P_posizione + 1;
	 END LOOP;
	 v_totale := ( v_totale - trunc(v_totale / 26)*26 ) + 65;
	 d_cin    := chr(v_totale);
   END IF; -- controllo su conto-corrente
  RETURN d_cin;
END  calcola_CIN;
/