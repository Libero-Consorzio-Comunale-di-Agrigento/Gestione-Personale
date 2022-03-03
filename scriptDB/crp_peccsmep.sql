/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE peccsmep IS
/******************************************************************************
 NOME:        PECCSMEP
 DESCRIZIONE: 
              
              
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI: 
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    01/12/2003      MV   

******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (P_prenotazione in number, passo in number);
END;
/
/*<TOAD_FILE_CHUNK>*/

CREATE OR REPLACE PACKAGE BODY peccsmep IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 01/12/2003';
END VERSIONE;
PROCEDURE MAIN (P_prenotazione in number, passo in number)IS
-- Parametri di selezioni
D_estrazione   varchar2(30);
D_da_anno      varchar2(4);
D_da_mensilita varchar2(4);
D_da_cod_mens  varchar2(4);
D_da_mese      varchar2(2);
D_a_anno       varchar2(4);
D_a_mensilita  varchar2(4);
D_a_cod_mens   varchar2(4);
D_a_mese       varchar2(2);
D_filtro_1     varchar2(15);
D_filtro_2     varchar2(15);
D_filtro_3     varchar2(15);
D_filtro_4     varchar2(15);
-- Parametri vari
D_riga           number;
D_pagina         number := 1;
D_anno           number;
D_mese           number;
D_c1             varchar2(15);
D_c2             varchar2(15);
D_c3             varchar2(15);
D_c4             varchar2(15);
D_conta          number :=0;
D_col1           number(15,5);
D_col2           number(15,5);
D_col3           number(15,5);
D_col4           number(15,5);
D_col5           number(15,5);
D_col6           number(15,5);
D_col7           number(15,5);
D_col8           number(15,5);
D_col9           number(15,5);
D_col10          number(15,5);
D_col11          number(15,5);
D_col12          number(15,5);
D_col13          number(15,5);
D_col14          number(15,5);
D_t_col1           number(15,5);
D_t_col2           number(15,5);
D_t_col3           number(15,5);
D_t_col4           number(15,5);
D_t_col5           number(15,5);
D_t_col6           number(15,5);
D_t_col7           number(15,5);
D_t_col8           number(15,5);
D_t_col9           number(15,5);
D_t_col10          number(15,5);
D_t_col11          number(15,5);
D_t_col12          number(15,5);
D_t_col13          number(15,5);
D_t_col14          number(15,5);

Des_col1           varchar2(14);
Des_col2           varchar2(14);
Des_col3           varchar2(14);
Des_col4           varchar2(14);
Des_col5           varchar2(14);
Des_col6           varchar2(14);
Des_col7           varchar2(14);
Des_col8           varchar2(14);
Des_col9           varchar2(14);
Des_col10          varchar2(14);
Des_col11          varchar2(14);
Des_col12          varchar2(14);
Des_col13          varchar2(14);
Des_col14          varchar2(14);

Des_c1          varchar2(15);
Des_c2          varchar2(15);

D_d1          varchar2(50);
D_d2          varchar2(50);

BEGIN

--PROMPT  Estrazione Parametri di Selezione della Prenotazione
begin
      select valore 
	    into D_estrazione
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro       = 'P_ESTRAZIONE'
      ;
exception
      when no_data_found then
       D_estrazione := null;
end;  
begin
      select valore 
	    into D_da_anno
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_DA_ANNO'
      ;
exception
  when no_data_found then
     D_da_anno := null;    
end;
begin
      select valore 
	    into D_da_mensilita
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_DA_MENSILITA'
      ;
exception
  when no_data_found then
     D_da_mensilita := null;
end;
begin
    select to_char(mese)   
           , mensilita     
		into D_da_mese, D_da_cod_mens
        from mensilita
       where codice = D_da_mensilita
      ;
exception 
  when no_data_found then
     begin
      select nvl(D_da_anno,to_char(anno)) 
           , nvl(D_da_mese,to_char(mese)) 
           , nvl(D_da_cod_mens,mensilita) 
		into D_da_anno, D_da_mese, D_da_cod_mens
        from riferimento_retribuzione
       where rire_id = 'RIRE'
	    and  D_da_mensilita is null
      ;
     exception
      when no_data_found then
	     D_da_anno := 0;
		 D_da_mese := 0;
		 D_da_cod_mens := '';
   end;
	
end;
begin

      select valore 
	    into D_a_anno
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_A_ANNO'
      ;
exception
  when no_data_found then
     D_a_anno := null;
end;
begin

      select valore 
	    into D_a_mensilita
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_A_MENSILITA'
      ;
exception
  when no_data_found then
      D_a_mensilita := null;
end;
begin

      select to_char(mese) 
           , mensilita     
		into D_a_mese, D_a_cod_mens
        from mensilita
       where codice = D_a_mensilita
      ;
exception
  when no_data_found then
     D_a_mese := null;
     D_a_mensilita :=null;
end;
begin

      select valore 
	    into D_filtro_1
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_FILTRO_1'
      ;
exception
  when no_data_found then
     D_filtro_1 := '%';
end;
begin

      select valore 
	    into D_filtro_2
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_FILTRO_2'
      ;
exception
  when no_data_found then
    D_filtro_2 := '%';
end;
begin

      select valore 
	    into D_filtro_3
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_FILTRO_3'
      ;
exception
  when no_data_found then
     D_filtro_3 := '%';
end;
begin

      select valore 
	    into D_filtro_4
        from a_parametri
       where no_prenotazione = P_prenotazione
         and parametro    = 'P_FILTRO_4'
      ;
exception
  when no_data_found then
     D_filtro_4 := '%';
end;

begin
      select max(substr(decode(colonna,'01',descrizione,''),1,14)) des_col1 
           , max(substr(decode(colonna,'02',descrizione,''),1,14)) des_col2
           , max(substr(decode(colonna,'03',descrizione,''),1,14)) des_col3
           , max(substr(decode(colonna,'04',descrizione,''),1,14)) des_col4
           , max(substr(decode(colonna,'05',descrizione,''),1,14)) des_col5
           , max(substr(decode(colonna,'06',descrizione,''),1,14)) des_col6
           , max(substr(decode(colonna,'07',descrizione,''),1,14)) des_col7
           , max(substr(decode(colonna,'08',descrizione,''),1,14)) des_col8
           , max(substr(decode(colonna,'09',descrizione,''),1,14)) des_col9
           , max(substr(decode(colonna,'10',descrizione,''),1,14)) des_col10
           , max(substr(decode(colonna,'11',descrizione,''),1,14)) des_col11
           , max(substr(decode(colonna,'12',descrizione,''),1,14)) des_col12
           , max(substr(decode(colonna,'13',descrizione,''),1,14)) des_col13
           , max(substr(decode(colonna,'14',descrizione,''),1,14)) des_col14
	    into Des_col1
             , Des_col2
             , Des_col3
             , Des_col4
             , Des_col5
             , Des_col6
             , Des_col7
             , Des_col8
             , Des_col9
             , Des_col10
             , Des_col11
             , Des_col12
             , Des_col13
             , Des_col14
        from estrazione_valori_contabili
       where estrazione = D_estrazione
      ;
exception
  when no_data_found then
     Des_col1 := '';
     Des_col2 := '';
     Des_col3 := '';
     Des_col4 := '';
     Des_col5 := '';
     Des_col6 := '';
     Des_col7 := '';
     Des_col8 := '';
     Des_col9 := '';
     Des_col10 := '';
     Des_col11 := '';
     Des_col12 := '';
     Des_col13 := '';
     Des_col14 := '';
end;

begin
      select max(decode(sequenza,1,chiave,'')) des_c1 
           , max(decode(sequenza,2,chiave,'')) des_c2 
	    into Des_c1
             , Des_c2
        from relazione_chiavi_estrazione
       where estrazione = D_estrazione
         and sequenza in (1,2)
      ;
exception
  when no_data_found then
     Des_c1 := '';
     Des_c2 := '';
end;

D_riga := 1;

insert into a_appoggio_stampe
   values ( P_prenotazione
                    , passo
                    , D_pagina 
                    , D_riga
                    , lpad(to_char(sysdate,'dd/mm/yyyy'),14,' ')||' '||
					  lpad(D_estrazione,30, ' ')||' '||
                      lpad(D_da_anno,4,' ')||' '||
                      lpad(D_da_mese,2, ' ')||' '||
                      rpad(D_da_mensilita,4, ' ')||' '||
                      rpad(D_da_cod_mens,30,' ')||' '||
                      lpad(nvl(D_a_anno,D_da_anno),4,' ')||' '||
                      lpad(nvl(D_a_mese,D_da_mese),2, ' ')||' '||
                      rpad(nvl(D_a_mensilita,D_da_mensilita),4, ' ')||' '||
                      rpad(nvl(D_a_cod_mens,D_da_cod_mens),30,' ')||' '||
                      rpad(D_filtro_1,15, ' ')||' '||
                      rpad(D_filtro_2,15, ' ')||' '|| 
                      rpad(D_filtro_3,15, ' ')||' '||
                      rpad(D_filtro_4,15, ' ')
            );

D_riga := D_riga + 1;

insert into a_appoggio_stampe
   values ( P_prenotazione
                    , passo
                    , D_pagina 
                    , D_riga
                    , 'Tot.'||' '||
                      'Anno'||' '||
                      'Ms'||' '||
                      rpad(Des_c1,15, ' ')||' '||
                      rpad(Des_c2,15,' ')||' '||
                      'Cod.Ind.'||' '||
                      rpad('Nome',60, ' ')||' '||
                      rpad(Des_col1,14, ' ')||' '||
                      rpad(Des_col2,14, ' ')||' '||
                      rpad(Des_col3,14, ' ')||' '||
                      rpad(Des_col4,14, ' ')||' '||
                      rpad(Des_col5,14, ' ')||' '||
                      rpad(Des_col6,14, ' ')||' '||
                      rpad(Des_col7,14, ' ')||' '||
                      rpad(Des_col8,14, ' ')||' '||
                      rpad(Des_col9,14, ' ')||' '||
                      rpad(Des_col10,14, ' ')||' '||
                      rpad(Des_col11,14, ' ')||' '||
                      rpad(Des_col12,14, ' ')||' '||
                      rpad(Des_col13,14, ' ')||' '||
                      rpad(Des_col14,14, ' ')
            );

D_anno := null;
D_mese := null;
D_c1 := null;
D_c2 := null;
D_c3 := null;
D_c4 := null;

D_d1 := null;
D_d2 := null;

for CAVA in (select to_char(anno) anno,
                    to_char(mese) mese,
                    c1,
                    c2,
                    c3,
                    c4,
                    substr(d1,1,50) d1,
                    substr(d2,1,50) d2,
                    to_char(cava.ci) ci,
                    rain.cognome||' '||rain.nome nominativo,
                    col1,
                    col2,
                    col3,
                    col4,
                    col5,
                    col6,
                    col7,
                    col8,
                    col9,
                    col10,
                    col11,
                    col12,
                    col13,
                    col14
                from calcolo_valori cava, rapporti_individuali rain
                where to_char(anno)||to_char(mese) between D_da_anno||D_da_mese 
                                                       and nvl(D_a_anno,d_da_anno)||nvl(D_a_mese,D_da_mese)
                and rain.ci = cava.ci
                order by cava.s1,cava.c1,cava.s2,cava.c2,
                cava.s3,cava.c3,cava.s4,cava.c4,
                cava.s5,cava.c5,cava.s6,cava.c6,cava.ci) loop

D_conta:= D_conta + 1;


if D_conta = 1 then

 
                D_anno := cava.anno;
                D_mese := cava.mese;
                D_c1 := cava.c1;
                D_c2 := cava.c2;
                D_c3 := cava.c3;
                D_c4 := cava.c4;

                D_d1 := cava.d1;
                D_d2 := cava.d2;

else
  if (D_c1 != cava.c1 or D_c2 != cava.c2 or D_c3 != cava.c3 or D_c4 != cava.c4) then

            D_col1 := null;
            D_col2 := null;
            D_col3 := null;
            D_col4 := null;
            D_col5 := null;
            D_col6 := null;
            D_col7 := null;
            D_col8 := null;
            D_col9 := null;
            D_col10:= null;
            D_col11:= null;
            D_col12:= null;
            D_col13:= null;
            D_col14:= null;

    begin
     select sum(col1), sum(col2), sum(col3), sum(col4), sum(col5), sum(col6), sum(col7), sum(col8),
            sum(col9), sum(col10), sum(col11), sum(col12), sum(col13), sum(col14)
      into D_col1, D_col2, D_col3, D_col4, D_col5, D_col6, D_col7, D_col8, D_col9, D_col10, D_col11,
           D_col12, D_col13 , D_col14
      from calcolo_valori cava
      where to_char(anno)||to_char(mese) between D_da_anno||D_da_mese 
                                             and nvl(D_a_anno,D_da_anno)||nvl(D_a_mese,D_da_mese)
      and   c1 = D_c1
      and   c2 = D_c2
      and   c3 = D_c3
      and   c4 = D_c4;
    exception
     when no_data_found then
            D_col1 := null;
            D_col2 := null;
            D_col3 := null;
            D_col4 := null;
            D_col5 := null;
            D_col6 := null;
            D_col7 := null;
            D_col8 := null;
            D_col9 := null;
            D_col10:= null;
            D_col11:= null;
            D_col12:= null;
            D_col13:= null;
            D_col14:= null;
    end;
 D_riga := D_riga + 1;

-- dbms_output.put_line('Nel totale: D_d2: '||d_d2);
-- dbms_output.put_line('Nella insert: '||rpad('Totale '||D_d2,60, ' '));

 insert into a_appoggio_stampe
   values ( P_prenotazione
                    , passo
                    , D_pagina 
                    , D_riga
                    , lpad('*',4,' ')||' '||
                      lpad(D_anno,4,' ')||' '||
                      lpad(D_mese,2, ' ')||' '||
                      rpad(nvl(D_c1,' '),15, ' ')||' '||
                      rpad(nvl(D_c2,' '),15,' ')||' '||
                      lpad('0',8,' ')||' '||
                      rpad('Totale '||D_d2,60, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col1,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col2,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col3,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col4,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col5,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col6,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col7,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col8,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col9,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col10,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col11,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col12,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col13,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col14,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')                      
            );
           

                D_anno := cava.anno;
                D_mese := cava.mese;
                D_c1 := cava.c1;
                D_c2 := cava.c2;
                D_c3 := cava.c3;
                D_c4 := cava.c4;

                D_d1 := cava.d1;
                D_d2 := cava.d2;

  end if;
end if;

D_riga := D_riga + 1;
 insert into a_appoggio_stampe
   values ( P_prenotazione
                    , passo
                    , D_pagina 
                    , D_riga
                    , lpad(' ',4,' ')||' '||
                      lpad(cava.anno,4,' ')||' '||
                      lpad(cava.mese,2, ' ')||' '||
                      rpad(nvl(cava.c1,' '),15, ' ')||' '||
                      rpad(nvl(cava.c2,' '),15,' ')||' '||
                      lpad(cava.ci,8,' ')||' '||
                      rpad(cava.nominativo,60, ' ')||' '||
                      lpad((translate(to_char(nvl(cava.col1,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(cava.col2,0),'9999999990.00'),',.','.,')
                                  ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(cava.col3,0),'9999999990.00'),',.','.,')
                                  ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(cava.col4,0),'9999999990.00'),',.','.,')
                                  ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(cava.col5,0),'9999999990.00'),',.','.,')
                                  ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(cava.col6,0),'9999999990.00'),',.','.,')
                                  ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(cava.col7,0),'9999999990.00'),',.','.,')
                                  ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(cava.col8,0),'9999999990.00'),',.','.,')
                                  ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(cava.col9,0),'9999999990.00'),',.','.,')
                                  ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(cava.col10,0),'9999999990.00'),',.','.,')
                                  ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(cava.col11,0),'9999999990.00'),',.','.,')
                                  ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(cava.col12,0),'9999999990.00'),',.','.,')
                                  ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(cava.col13,0),'9999999990.00'),',.','.,')
                                  ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(cava.col14,0),'9999999990.00'),',.','.,')
                                  ),14, ' ')

            );




end loop;

            D_col1 := null;
            D_col2 := null;
            D_col3 := null;
            D_col4 := null;
            D_col5 := null;
            D_col6 := null;
            D_col7 := null;
            D_col8 := null;
            D_col9 := null;
            D_col10:= null;
            D_col11:= null;
            D_col12:= null;
            D_col13:= null;
            D_col14:= null;

    begin
     select sum(col1), sum(col2), sum(col3), sum(col4), sum(col5), sum(col6), sum(col7), sum(col8),
            sum(col9), sum(col10), sum(col11), sum(col12), sum(col13), sum(col14)
      into D_col1, D_col2, D_col3, D_col4, D_col5, D_col6, D_col7, D_col8, D_col9, D_col10, D_col11,
           D_col12, D_col13 , D_col14
      from calcolo_valori cava
      where to_char(anno)||to_char(mese) between D_da_anno||D_da_mese 
                                             and nvl(D_a_anno,D_da_anno)||nvl(D_a_mese,D_da_mese)
      and   c1 = D_c1
      and   c2 = D_c2
      and   c3 = D_c3
      and   c4 = D_c4;
    exception
     when no_data_found then
            D_col1 := null;
            D_col2 := null;
            D_col3 := null;
            D_col4 := null;
            D_col5 := null;
            D_col6 := null;
            D_col7 := null;
            D_col8 := null;
            D_col9 := null;
            D_col10:= null;
            D_col11:= null;
            D_col12:= null;
            D_col13:= null;
            D_col14:= null;
    end;

 D_riga := D_riga + 1;
 insert into a_appoggio_stampe
   values ( P_prenotazione
                    , passo
                    , D_pagina 
                    , D_riga
                    , lpad('*',4,' ')||' '||
                      lpad(D_anno,4,' ')||' '||
                      lpad(D_mese,2, ' ')||' '||
                      rpad(nvl(D_c1,' '),15, ' ')||' '||
                      rpad(nvl(D_c2,' '),15,' ')||' '||
                      lpad('0',8,' ')||' '||
                      rpad('Totale '||D_d2,60, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col1,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col2,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col3,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col4,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col5,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col6,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col7,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col8,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col9,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col10,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col11,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col12,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col13,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_col14,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')                      
            );
           

            D_t_col1 := null;
            D_t_col2 := null;
            D_t_col3 := null;
            D_t_col4 := null;
            D_t_col5 := null;
            D_t_col6 := null;
            D_t_col7 := null;
            D_t_col8 := null;
            D_t_col9 := null;
            D_t_col10:= null;
            D_t_col11:= null;
            D_t_col12:= null;
            D_t_col13:= null;
            D_t_col14:= null;

begin
     select sum(col1), sum(col2), sum(col3), sum(col4), sum(col5), sum(col6), sum(col7), sum(col8),
            sum(col9), sum(col10), sum(col11), sum(col12), sum(col13), sum(col14)
      into D_t_col1, D_t_col2, D_t_col3, D_t_col4, D_t_col5, D_t_col6, D_t_col7, D_t_col8, D_t_col9, D_t_col10, D_t_col11,
           D_t_col12, D_t_col13 , D_t_col14
      from calcolo_valori cava
      where to_char(anno)||to_char(mese) between D_da_anno||D_da_mese 
                                             and nvl(D_a_anno,D_da_anno)||nvl(D_a_mese,D_da_mese)
      ;
    exception
     when no_data_found then
            D_t_col1 := null;
            D_t_col2 := null;
            D_t_col3 := null;
            D_t_col4 := null;
            D_t_col5 := null;
            D_t_col6 := null;
            D_t_col7 := null;
            D_t_col8 := null;
            D_t_col9 := null;
            D_t_col10:= null;
            D_t_col11:= null;
            D_t_col12:= null;
            D_t_col13:= null;
            D_t_col14:= null;
    end;

 D_riga := D_riga + 1;
 insert into a_appoggio_stampe
   values ( P_prenotazione
                    , passo
                    , D_pagina 
                    , D_riga
                    , lpad('*',4,' ')||' '||
                      lpad(' ',4,' ')||' '||
                      lpad(' ',2, ' ')||' '||
                      lpad(' ',15, ' ')||' '||
                      lpad(' ',15,' ')||' '||
                      lpad('0',8,' ')||' '||
                      rpad('Totale '||D_d1,60, ' ')||' '||
                      lpad((translate(to_char(nvl(D_t_col1,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_t_col2,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_t_col3,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_t_col4,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_t_col5,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_t_col6,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_t_col7,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_t_col8,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_t_col9,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_t_col10,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_t_col11,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_t_col12,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_t_col13,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')||' '||
                      lpad((translate(to_char(nvl(D_t_col14,0),'9999999990.00'),',.','.,')
                                     ),14, ' ')
            );






END;
END;
/

