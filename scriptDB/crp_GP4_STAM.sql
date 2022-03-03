CREATE OR REPLACE PACKAGE GP4_STAM IS
       TYPE REF_CUR_ASCENDENTI is record ( d_nota_settore varchar2(8),d_settore varchar2(50)/*, d_livello number */);
       TYPE ASCENDENTI is REF CURSOR return ref_cur_ascendenti;
       PROCEDURE GET_ASCENDENTI      (p_ni in number, p_data in date, p_revisione in varchar2,c_ascendenti in out ASCENDENTI);
       TYPE REF_CUR_SETTORI is record ( GESTIONE                     VARCHAR2(4)
	   						   		   ,NUMERO                       NUMBER
									   ,SUDDIVISIONE                 VARCHAR2(50)
									   ,CODICE                       VARCHAR2(15)
									   ,LIVELLO                      VARCHAR2(8)
									   ,DESCRIZIONE                  VARCHAR2(120)
									   ,REVISIONE                    NUMBER(8)
									   ,OTTICA                       VARCHAR2(4)
									   ,DAL                          DATE
									   ,UNITA_PADRE                  NUMBER(8)
									   ,UNITA_PADRE_OTTICA           VARCHAR2(4)
									   ,UNITA_PADRE_DAL              DATE
									   ,NI                           NUMBER(8)
                                      );
       TYPE SETT is REF CURSOR return ref_cur_settori;
       PROCEDURE GET_SETTORI      (p_revisione      in number, 
                                   p_codice         in varchar2, 
                                   p_suddivisione   in varchar2,
                                   p_livello        in varchar2,
                                   p_numero         in number,
                                   p_gestione       in varchar2, 
                                   c_settori        in out SETT);
		PROCEDURE GET_SETTORI_ESTAM      (p_revisione      in number, 
                                   p_codice         in varchar2, 
                                   p_suddivisione   in varchar2,
                                   p_livello        in varchar2,
                                   p_numero         in number,
                                   p_gestione       in varchar2, 
								   p_tutte          in varchar2,
								   p_descrizione 	in varchar2,
                                   c_settori        in out SETT);
       FUNCTION  GET_DES_ABB_SUST         (p_ottica in varchar2 , p_livello in varchar2) RETURN VARCHAR2 ;
       FUNCTION  GET_CODICE          (p_ni in number) RETURN VARCHAR2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_CODICE,wnds,wnps);
       FUNCTION  GET_NUMERO          (p_ni in number) RETURN NUMBER ;
                 PRAGMA RESTRICT_REFERENCES(GET_NUMERO,wnds,wnps);
       FUNCTION  GET_SEQUENZA        (p_ni in number) RETURN NUMBER ;
                 PRAGMA RESTRICT_REFERENCES(GET_SEQUENZA,wnds,wnps);
       FUNCTION  GET_DENOMINAZIONE   (p_ni in number) RETURN VARCHAR2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_DENOMINAZIONE,wnds,wnps);
       FUNCTION  GET_GESTIONE        (p_ni in number) RETURN VARCHAR2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_GESTIONE,wnds,wnps);
       FUNCTION  GET_NUMERO_GESTIONE (p_ni in number) RETURN NUMBER ;
                 PRAGMA RESTRICT_REFERENCES(GET_NUMERO_GESTIONE,wnds,wnps);
       FUNCTION  GET_ASSEGNABILE     (p_ni in number) RETURN VARCHAR2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_ASSEGNABILE,wnds,wnps);
       FUNCTION  GET_SETTORE_A       (p_ni in number) RETURN NUMBER ;
                 PRAGMA RESTRICT_REFERENCES(GET_SETTORE_A,wnds,wnps);
       FUNCTION  GET_SETTORE_B       (p_ni in number) RETURN NUMBER ;
                 PRAGMA RESTRICT_REFERENCES(GET_SETTORE_B,wnds,wnps);
       FUNCTION  GET_SETTORE_C       (p_ni in number) RETURN NUMBER ;
                 PRAGMA RESTRICT_REFERENCES(GET_SETTORE_C,wnds,wnps);
       FUNCTION  GET_NUMERO_SEDE     (p_ni in number) RETURN NUMBER ;
                 PRAGMA RESTRICT_REFERENCES(GET_NUMERO_SEDE,wnds,wnps);
       FUNCTION  GET_NI              (p_codice in varchar2) return number;
                 PRAGMA RESTRICT_REFERENCES(GET_NI,wnds,wnps);
       FUNCTION  GET_NI_NUMERO       (p_numero in number) return number;
                 PRAGMA RESTRICT_REFERENCES(GET_NI_NUMERO,wnds,wnps);
       FUNCTION  VERSIONE              RETURN varchar2;
                 PRAGMA RESTRICT_REFERENCES(VERSIONE,wnds,wnps);
/******************************************************************************
   NAME:       GP4_STAM
   PURPOSE:    To calculate the desired information.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        23/07/2002                   
   2.0        02/02/2005            MM-CB  Allineamento a febbraio 2005 delle ultime modifiche.
                                           Variazione dei parametri della GET_ASCENDENTI (p_revisione)
   2.1        07/04/2005               CB  Procedure GET_SETTORI   
   2.2        18/09/2006               CB  Order by GET_SETTORI_ESTAM  
   2.3        29/01/2007	       CB  P_descrizione	
******************************************************************************/
END GP4_STAM;
/

CREATE OR REPLACE PACKAGE BODY GP4_STAM AS

FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V2.3  del  29/01/2007';
END VERSIONE;
--
FUNCTION GET_CODICE (p_ni in number) RETURN VARCHAR2 IS
d_codice SETTORI_AMMINISTRATIVI.codice%TYPE;
/******************************************************************************
   NAME:       GET_CODICE
   PURPOSE:    Fornire in codice del settore amministrativo
               data una unita organizzativa

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          

******************************************************************************/
BEGIN
  d_codice := 'XXXXXXXXXXXXXX';
  begin
   select codice
     into d_codice
	 from settori_amministrativi
	where ni = p_ni
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_codice := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_codice := to_char(null);
	  end;
  end;
  RETURN d_codice;
END GET_CODICE;
--
FUNCTION GET_NI (p_codice in varchar2) RETURN NUMBER IS
d_ni SETTORI_AMMINISTRATIVI.NI%TYPE;
/******************************************************************************
   NAME:       GET_NI
   PURPOSE:    Fornire l'ni del settore amministrativo
               dato il codice del settore amministrativo

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          

******************************************************************************/
BEGIN
  d_ni := 0;
  begin
   select ni
     into d_ni
	 from settori_amministrativi
	where codice = p_codice
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_ni := null;
	  end;
    when too_many_rows then
	  begin
		d_ni := null;
	  end;
  end;
  RETURN d_ni;
END GET_NI;
--

FUNCTION GET_NI_NUMERO (p_numero in number) RETURN NUMBER IS
d_ni SETTORI_AMMINISTRATIVI.NI%TYPE;
/******************************************************************************
   NAME:       GET_NI_NUMERO
   PURPOSE:    Fornire l'ni del settore amministrativo
               dato il numero del settore

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/08/2002          

******************************************************************************/
BEGIN
  d_ni := 0;
  begin
   select ni
     into d_ni
	 from settori_amministrativi
	where numero = p_numero
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_ni := null;
	  end;
    when too_many_rows then
	  begin
		d_ni := null;
	  end;
  end;
  RETURN d_ni;
END GET_NI_NUMERO;
--
FUNCTION GET_NUMERO (p_ni in number) RETURN NUMBER IS
d_numero SETTORI_AMMINISTRATIVI.numero%TYPE;
/******************************************************************************
   NAME:       GET_numero
   PURPOSE:    Fornire in numero del settore amministrativo
               data una unita organizzativa

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          

******************************************************************************/
BEGIN
  d_numero := to_number(null);
  begin
   select numero
     into d_numero
	 from settori_amministrativi
	where ni = p_ni
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_numero := to_number(null);
	  end;
    when too_many_rows then
	  begin
		d_numero := to_number(null);
	  end;
  end;
  RETURN d_numero;
END GET_numero;
--
FUNCTION GET_SEQUENZA (p_ni in number) RETURN NUMBER IS
d_sequenza SETTORI_AMMINISTRATIVI.sequenza%TYPE;
/******************************************************************************
   NAME:       GET_sequenza
   PURPOSE:    Fornire in sequenza del settore amministrativo
               data una unita organizzativa

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          

******************************************************************************/
BEGIN
  d_sequenza := to_number(null);
  begin
   select sequenza
     into d_sequenza
	 from settori_amministrativi
	where ni = p_ni
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_sequenza := to_number(null);
	  end;
    when too_many_rows then
	  begin
		d_sequenza := to_number(null);
	  end;
  end;
  RETURN d_sequenza;
END GET_SEQUENZA;
--
FUNCTION GET_DENOMINAZIONE (p_ni in number) RETURN VARCHAR2 IS
d_DENOMINAZIONE SETTORI_AMMINISTRATIVI.DENOMINAZIONE%TYPE;
/******************************************************************************
   NAME:       GET_DENOMINAZIONE
   PURPOSE:    Fornire la DENOMINAZIONE del settore amministrativo
               data una unita organizzativa

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          


******************************************************************************/
BEGIN
  d_DENOMINAZIONE := 'XXXXXXXXXXXXXX';
  begin
   select DENOMINAZIONE
     into d_DENOMINAZIONE
	 from settori_amministrativi
	where ni = p_ni
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_DENOMINAZIONE := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_DENOMINAZIONE := to_char(null);
	  end;
  end;
  RETURN d_DENOMINAZIONE;
END GET_DENOMINAZIONE;
--
FUNCTION GET_ASSEGNABILE (p_ni in number) RETURN VARCHAR2 IS
d_ASSEGNABILE SETTORI_AMMINISTRATIVI.ASSEGNABILE%TYPE;
/******************************************************************************
   NAME:       GET_ASSEGNABILE
   PURPOSE:    Fornire la ASSEGNABILE del settore amministrativo
               data una unita organizzativa

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          


******************************************************************************/
BEGIN
  d_ASSEGNABILE := 'XX';
  begin
   select ASSEGNABILE
     into d_ASSEGNABILE
	 from settori_amministrativi
	where ni = p_ni
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_ASSEGNABILE := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_ASSEGNABILE := to_char(null);
	  end;
  end;
  RETURN d_ASSEGNABILE;
END GET_ASSEGNABILE;
--
FUNCTION GET_gestione (p_ni in number) RETURN VARCHAR2 IS
d_gestione SETTORI_AMMINISTRATIVI.gestione%TYPE;
/******************************************************************************
   NAME:       GET_CODICE
   PURPOSE:    Fornire la gestione del settore amministrativo
               data una unita organizzativa

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          


******************************************************************************/
BEGIN
  d_gestione := 'XXXX';
  begin
   select gestione
     into d_gestione
	 from settori_amministrativi
	where ni = p_ni
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_gestione := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_gestione := to_char(null);
	  end;
  end;
  RETURN d_gestione;
END GET_GESTIONE;
--
FUNCTION GET_numero_gestione (p_ni in number) RETURN NUMBER IS
d_num_gestione SETTORI_AMMINISTRATIVI.numero%TYPE;
/******************************************************************************
   NAME:       GET_CODICE
   PURPOSE:    Fornire il numero del settore amministrativo della gestione
               data una unita organizzativa

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          


******************************************************************************/
BEGIN
  d_num_gestione := to_number(null);
  begin
   select numero
     into d_num_gestione
	 from settori_amministrativi
	where codice = get_gestione(p_ni)
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_num_gestione := to_number(null);
	  end;
    when too_many_rows then
	  begin
		d_num_gestione := to_number(null);
	  end;
  end;
  RETURN d_num_gestione;
END GET_NUMERO_GESTIONE;
--
FUNCTION GET_settore_a(p_ni in number) RETURN number IS
d_settore_a    SETTORI_AMMINISTRATIVI.numero%TYPE;
d_suddivisione unita_organizzative.suddivisione%TYPE;
d_livello      SETTORI_AMMINISTRATIVI.numero%TYPE;
/******************************************************************************
   NAME:       GET_SETTORE_A
   PURPOSE:    Fornire il numero del settore amministrativo ascendente
               dell'NI, di profondita 1
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          
******************************************************************************/
BEGIN
  d_settore_a :=  to_number(null);
  d_livello   :=  least(gp4_unor.GET_LIVELLO(p_ni,'GP4',gp4_unor.get_dal(p_ni)),4);
  if     d_livello = 1
    then d_settore_a := to_number(null);
  elsif  d_livello = 2
    then d_settore_a := nvl(get_numero ( gp4_unor.get_padre( p_ni ,'GP4' ,gp4_unor.get_dal(p_ni) ) ),get_numero_gestione(p_ni));
  elsif  d_livello = 3
    then d_settore_a := nvl(get_numero ( gp4_unor.get_padre( gp4_unor.get_padre( p_ni
                	                                                        ,'GP4'
                														    ,gp4_unor.get_dal(p_ni)
                														   )
                                                        ,'GP4'
                										,gp4_unor.get_dal( gp4_unor.get_padre( p_ni
                										                                      ,'GP4'
                										                                      ,gp4_unor.get_dal(p_ni)
                																			 )
                												         )
                									   )
				                   ),get_numero_gestione(p_ni));
  elsif  d_livello = 4
    then d_settore_a := nvl(get_numero( gp4_unor.get_padre( gp4_unor.get_padre( gp4_unor.get_padre( p_ni ,'GP4' ,gp4_unor.get_dal(p_ni) )
                	                                                        ,'GP4'
                														    ,gp4_unor.get_dal(gp4_unor.get_padre( p_ni ,'GP4' ,gp4_unor.get_dal(p_ni) ))
                														   )
                                                        ,'GP4'
                										,gp4_unor.get_dal( gp4_unor.get_padre( gp4_unor.get_padre( p_ni ,'GP4' ,gp4_unor.get_dal(p_ni) )
                										                                      ,'GP4'
                										                                      ,gp4_unor.get_dal(gp4_unor.get_padre( p_ni ,'GP4' ,gp4_unor.get_dal(p_ni) ))
                																			 )
                												         )
					            					  )
				                  ),get_numero_gestione(p_ni));
  end if;
  RETURN d_settore_a;
END GET_SETTORE_A;
--
FUNCTION GET_settore_b(p_ni in number) RETURN number IS
d_settore_b SETTORI_AMMINISTRATIVI.numero%TYPE;
d_livello   SETTORI_AMMINISTRATIVI.sequenza%TYPE;
/******************************************************************************
   NAME:       GET_settore_b
   PURPOSE:    Fornire il numero del settore amministrativo ascendente
               dell'NI, di profondita 1
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          
******************************************************************************/
BEGIN
  d_settore_b :=  to_number(null);
  d_livello   :=  least(gp4_unor.GET_LIVELLO(p_ni,'GP4',gp4_unor.get_dal(p_ni)),4);
  if     d_livello = 1
    then d_settore_b := to_number(null);
  elsif  d_livello = 2
    then d_settore_b := to_number(null);
  elsif  d_livello = 3
    then d_settore_b := nvl(get_numero( gp4_unor.get_padre( p_ni
	                                                   ,'GP4'
										               ,gp4_unor.get_dal(p_ni)
										              )
							      ),get_numero_gestione(p_ni));
  elsif  d_livello = 4
    then d_settore_b := nvl(get_numero( gp4_unor.get_padre( gp4_unor.get_padre( p_ni
	                                                   ,'GP4'
										               ,gp4_unor.get_dal(p_ni)
										              )
	                                                   ,'GP4'
										               ,gp4_unor.get_dal(gp4_unor.get_padre( p_ni
	                                                   ,'GP4'
										               ,gp4_unor.get_dal(p_ni)
										              ))
										              )
							      ),get_numero_gestione(p_ni));
  end if;
  RETURN d_settore_b;
END GET_settore_b;
--
FUNCTION GET_settore_c(p_ni in number) RETURN number IS
d_settore_c SETTORI_AMMINISTRATIVI.numero%TYPE;
d_livello   SETTORI_AMMINISTRATIVI.sequenza%TYPE;
/******************************************************************************
   NAME:       GET_settore_c
   PURPOSE:    Fornire il numero del settore amministrativo ascendente
               dell'NI, di profondita 1

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          

******************************************************************************/
BEGIN
  d_settore_c :=  to_number(null);
  d_livello   :=  least(gp4_unor.GET_LIVELLO(p_ni,'GP4',gp4_unor.get_dal(p_ni)),4);
  if     d_livello = 1
    then d_settore_c := to_number(null);
  elsif  d_livello = 2
    then d_settore_c := to_number(null);
  elsif  d_livello = 3
    then d_settore_c := to_number(null);
  elsif  d_livello = 4
    then d_settore_c := nvl(get_numero( gp4_unor.get_padre( p_ni
	                                                   ,'GP4'
										               ,gp4_unor.get_dal(p_ni)
										              )
						          ),get_numero_gestione(p_ni));
  end if;
  RETURN d_settore_c;
END GET_settore_c;
--
FUNCTION GET_DES_ABB_SUST (p_ottica in varchar2 , p_livello in varchar2) RETURN VARCHAR2 IS
d_des_abb SUDDIVISIONI_STRUTTURA.DES_ABB%TYPE;
/******************************************************************************
   NAME:       GET_DES_ABB_SUST
   PURPOSE:    Fornire ila descrizione abbreviata di uu livello di suddivisione
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          1. Created this function.
******************************************************************************/
BEGIN
  d_des_abb := to_char(null);
  begin
   select des_abb
     into d_des_abb
    from suddivisioni_struttura
   where ottica  = p_ottica
     and livello = p_livello
   ;
   EXCEPTION
    when no_data_found then
     begin
      d_des_abb := to_char(null);
     end;
    when too_many_rows then
     begin
      d_des_abb := to_char(null);
     end;
  end;
  RETURN d_des_abb;
END GET_DES_ABB_SUST;
--
FUNCTION GET_numero_sede(p_ni in number) RETURN number IS
d_numero_sede SETTORI_AMMINISTRATIVI.numero%TYPE;
/******************************************************************************
   NAME:       GET_numero_sede
   PURPOSE:    Fornire il numero della sede del settore amministrativo

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          


******************************************************************************/
BEGIN
  d_numero_sede :=  to_number(null);
  begin
   select sede
     into d_numero_sede
	 from settori_amministrativi
	where ni = p_ni
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_numero_sede := to_number(null);
		RETURN d_numero_sede;
	  end;
    when too_many_rows then
	  begin
		d_numero_sede := to_number(null);
		RETURN d_numero_sede;
	  end;
  end;
  RETURN d_numero_sede;
END GET_numero_sede;
--
PROCEDURE GET_ASCENDENTI (p_ni in number, p_data in date, p_revisione in varchar2, c_ascendenti in out ASCENDENTI) is
 d_ascendente                      varchar2(50);
 begin
    open c_ascendenti
	 for select substr(gp4_stam.get_des_abb_sust('GP4',suddivisione),1,8)||':'
               ,codice_uo||' - '||descrizione
--			   ,gp4_unor.GET_LIVELLO(ni,'GP4',gp4_unor.get_dal(ni))
           from unita_organizzative unor
          where unor.ottica                      = 'GP4'
            --and tipo                        ='P'
            and revisione                   = decode(p_revisione,'M',gp4gm.get_revisione_m,
                                                    gp4gm.get_revisione(nvl(p_data,to_date('3333333','j')))
                                                    )
            and nvl(p_data,to_date('3333333','j')) between unor.dal and nvl(al, to_date('3333333','j'))
		    --and dal                         = gp4_unor.get_dal_data(p_ni,nvl(p_data,to_date('3333333','j')))
            and gp4_stam.get_gestione(ni)   = gp4_stam.get_gestione(p_ni)
          start with ni                     = p_ni
		    --and dal                         = gp4_unor.get_dal_data(p_ni,nvl(p_data,to_date('3333333','j')))
            and nvl(p_data,to_date('3333333','j')) between unor.dal and nvl(al, to_date('3333333','j'))
            --and tipo                        ='P'
            and unor.ottica                      = 'GP4'
            and revisione                   = decode(p_revisione,'M',gp4gm.get_revisione_m,
                                                    gp4gm.get_revisione(nvl(p_data,to_date('3333333','j')))
                                                    )
            and gp4_stam.get_gestione(ni)   = gp4_stam.get_gestione(p_ni)
        connect by prior unita_padre               = ni
           -- and tipo='P'
			and unor.ottica                    = 'GP4'
            and revisione                   = decode(p_revisione,'M',gp4gm.get_revisione_m,
                                                    gp4gm.get_revisione(nvl(p_data,to_date('3333333','j')))
                                                    )
		    --and dal                         = gp4_unor.get_dal_data(p_ni,nvl(p_data,to_date('3333333','j')))
            and nvl(p_data,to_date('3333333','j')) between unor.dal and nvl(al, to_date('3333333','j'))
            and gp4_stam.get_gestione(ni) = gp4_stam.get_gestione(p_ni)
		  order by   gp4_unor.GET_LIVELLO(ni,'GP4',gp4_unor.get_dal(ni))
     ;
 end GET_ASCENDENTI;
--
PROCEDURE GET_SETTORI (p_revisione     in number, 
                       p_codice        in varchar2,
                       p_suddivisione  in varchar2,
                       p_livello       in varchar2,
                       p_numero        in number,
                       p_gestione      in varchar2,
                       c_settori in out SETT) is
 d_settore                     varchar2(50);
 begin
    open c_settori
	        for
            select substr(gp4_stam.get_gestione(unor.ni) ,1,4)                                gestione
                  ,gp4_stam.get_numero(ni)                                                    numero
                  ,substr(lpad(' ',(gp4_unor.get_livello(unor.ni,'GP4',unor.dal)-1) * 2,' ')||
            	   substr(gp4gm.get_des_abb_sust('GP4',suddivisione),1,8),1,30)               suddivisione
            	  ,substr(codice_uo,1,15)                                                     codice
            	  ,suddivisione                                                               livello
                  ,descrizione
            	  ,revisione
                  ,ottica
            	  ,dal
                  ,unita_padre
            	  ,unita_padre_ottica
            	  ,unita_padre_dal
                  ,ni
             from unita_organizzative unor
             where unor.dal = (decode (gp4_rest.get_stato('GP4',revisione),'M',gp4_unor.GET_DAL_M(ni)
                                                                          ,'O',gp4_unor.GET_DAL_O(ni,REVISIONE)
                                                                              ,gp4_unor.GET_DAL(ni)))
               and ottica||' ' = 'GP4'||' '
               and revisione   = p_revisione
			   and substr(codice_uo,1,15)   like nvl(p_codice,'%')
               and nvl(suddivisione,'%') like NVL(p_livello ,'%') 
               and substr(gp4gm.get_des_abb_sust('GP4',suddivisione),1,8)   like nvl(p_suddivisione,'%')
               and to_char(gp4_stam.get_numero(ni))  like nvl(to_char(P_numero),'%')
               and substr(gp4_stam.get_gestione(unor.ni) ,1,4) like nvl(P_gestione,'%')
             start with unita_padre = 0
               and ottica           ='GP4'
               and revisione        = p_revisione
             connect by prior  ni = unita_padre
                          and ottica='GP4' and revisione = p_revisione
               order by gp4gm.ordertree(level,nvl(lpad((nvl(lpad(gp4_stam.get_sequenza(ni),6,'0'),'999999')||rpad(codice_uo,15,' ')),21,'0'),'999999'||codice_uo))
            ;
 end GET_SETTORI;
--
PROCEDURE GET_SETTORI_ESTAM (p_revisione     in number, 
                       p_codice        in varchar2,
                       p_suddivisione  in varchar2,
                       p_livello       in varchar2,
                       p_numero        in number,
                       p_gestione      in varchar2,
					   p_tutte         in varchar2,
					   p_descrizione   in varchar2,
                       c_settori 	   in out SETT) is
 d_settore                     varchar2(50);
 begin
    if p_tutte is null then
	begin
    open c_settori
	        for
            select substr(gp4_stam.get_gestione(unor.ni) ,1,4)                                gestione
                  ,gp4_stam.get_numero(ni)                                                    numero
                  ,substr(lpad(' ',(gp4_unor.get_livello(unor.ni,'GP4',unor.dal)-1) * 2,' ')||
            	   substr(gp4gm.get_des_abb_sust('GP4',suddivisione),1,8),1,30)               suddivisione
            	  ,substr(codice_uo,1,15)                                                     codice
            	  ,suddivisione                                                               livello
                  ,descrizione
            	  ,revisione
                  ,ottica
            	  ,dal
                  ,unita_padre
            	  ,unita_padre_ottica
            	  ,unita_padre_dal
                  ,ni
             from unita_organizzative unor
             where unor.dal = (decode (gp4_rest.get_stato('GP4',revisione),'M',gp4_unor.GET_DAL_M(ni)
                                                                          ,'O',gp4_unor.GET_DAL_O(ni,REVISIONE)
                                                                              ,gp4_unor.GET_DAL(ni)))
               and ottica||' ' = 'GP4'||' '
                  and TO_CHAR(revisione) LIKE NVL(TO_CHAR(p_revisione),'%')
			   and substr(codice_uo,1,15)   like nvl(p_codice,'%')
               and nvl(suddivisione,'%') like NVL(p_livello ,'%') 
               and substr(gp4gm.get_des_abb_sust('GP4',suddivisione),1,8)   like nvl(p_suddivisione,'%')
               and to_char(gp4_stam.get_numero(ni))  like nvl(to_char(P_numero),'%')
               and substr(gp4_stam.get_gestione(unor.ni) ,1,4) like nvl(P_gestione,'%')
			   and nvl(descrizione,'%') like nvl(p_descrizione,'%')
             start with unita_padre = 0
               and ottica           ='GP4'
                  and TO_CHAR(revisione) LIKE NVL(TO_CHAR(p_revisione),'%')
             connect by prior  ni = unita_padre
                          and ottica='GP4' 
						     and TO_CHAR(revisione) LIKE NVL(TO_CHAR(p_revisione),'%')
               order by revisione,gp4gm.ordertree(level,nvl(lpad((nvl(lpad(gp4_stam.get_sequenza(ni),6,'0'),'999999')||rpad(codice_uo,15,' ')),21,'0'),'999999'||codice_uo))
            ;
     end;
	 else
	 begin
	 	open c_settori
	        for
            select substr(gp4_stam.get_gestione(unor.ni) ,1,4)                                gestione
                  ,gp4_stam.get_numero(ni)                                                    numero
                  ,substr(lpad(' ',(gp4_unor.get_livello(unor.ni,'GP4',unor.dal)-1) * 2,' ')||
            	   substr(gp4gm.get_des_abb_sust('GP4',suddivisione),1,8),1,30)               suddivisione
            	  ,substr(codice_uo,1,15)                                                     codice
            	  ,suddivisione                                                               livello
                  ,descrizione
            	  ,revisione
                  ,ottica
            	  ,dal
                  ,unita_padre
            	  ,unita_padre_ottica
            	  ,unita_padre_dal
                  ,ni
             from unita_organizzative unor
             where unor.dal = (decode (gp4_rest.get_stato('GP4',revisione),'M',gp4_unor.GET_DAL_M(ni)
                                                                          ,'O',gp4_unor.GET_DAL_O(ni,REVISIONE)
                                                                              ,gp4_unor.GET_DAL(ni)))
               and ottica||' ' = 'GP4'||' '
                  and TO_CHAR(revisione) LIKE NVL(TO_CHAR(p_revisione),'%')
			   and substr(codice_uo,1,15)   like nvl(p_codice,'%')
               and nvl(suddivisione,'%') like NVL(p_livello ,'%') 
               and substr(gp4gm.get_des_abb_sust('GP4',suddivisione),1,8)   like nvl(p_suddivisione,'%')
               and to_char(gp4_stam.get_numero(ni))  like nvl(to_char(P_numero),'%')
               and substr(gp4_stam.get_gestione(unor.ni) ,1,4) like nvl(P_gestione,'%')
	       and nvl(descrizione,'%') like nvl(p_descrizione,'%')
              order by revisione
            ;
    end;			
	end if;				
 end GET_SETTORI_ESTAM;

END GP4_STAM;
/

