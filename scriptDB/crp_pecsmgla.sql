/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE PECSMGLA IS
/******************************************************************************
 NOME:        PECSMGLA
 DESCRIZIONE: Creazione Supporto Magnetico Denuncia Gla
              Il Supporto Magnatico contenente il modello GLA deve contenere i compensi
			  corrisposti per ogni collaboratore coordinato e continuativo.
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  II PARAMETRO D_anno determina quale anno elaborare.
               Il parametro D_ced indica l'ente dichiarante
               Il PARAMETRO D_gestione determina quale gestione elaborare, valore di dafault %.
               Il PARAMETRO D_tipo     determina il tipo di denuncia, valori possibili P (Principale)
			   ed S (Sostitutiva), di default P.
              Il PARAMETRO D_fascia    indica la fascia di gestione (campo fascia della tabella gestioni), valore di
			   defaul %.
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    07/04/2003 MV
 1.1  16/09/2004 MS     Mod. per Attività 7276
 1.2  27/08/2007 GM     Mosdificata dimensione campo E_mail
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO IN NUMBER);
END;
/
/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE BODY PECSMGLA IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.2 del 27/08/2007';
END VERSIONE;
PROCEDURE MAIN (prenotazione in number, passo in number) IS
 BEGIN
DECLARE
  D_ente          varchar(4);
  D_ambiente      varchar(8);
  D_utente        varchar(8);
  D_anno          number(4);
  D_fascia        varchar(2);
  D_gestione      varchar(4);
  D_ced           varchar(4);
  D_tipo          varchar(1);
  D_referente     varchar2(40);
  D_codice_fiscale varchar2(16);
  P_pagina        number:= 1;
  P_riga          number:= 0;
  D_progressivo   number;
  D_codice_1      varchar(2);
  D_codice_2      varchar(2);
  D_codice_3      varchar(2);
  contatore       number;
  mese_1          number(3);
  dal_1           date;
  al_1            date;
  assicurazione_1 varchar(3);
  tariffa_1       number(10);
  qta_1           number(15,5);
  importo_1       number(12,2);
  eccedenza_01_1  number(12,2);
  eccedenza_02_1  number(12,2);
  eccedenza_03_1  number(12,2);
  mese_2          number(3);
  dal_2           date;
  al_2            date;
  assicurazione_2 varchar(3);
  tariffa_2       number(12,2);
  qta_2           number(15,5);
  importo_2       number(12,2);
  eccedenza_01_2  number(12,2);
  eccedenza_02_2  number(12,2);
  eccedenza_03_2  number(12,2);
  C_16            number(12,2);
  C_17            NUMBER(12,2);
  C_20            NUMBER(12,2);
  C_22            NUMBER(12,2);
  C_24            NUMBER(12,2);
  C_18            NUMBER(12,2);
  type t_mese     is TABLE of number(2)  index by binary_integer;
  type t_importo  is TABLE of number(16) index by binary_integer;
  v_mese          t_mese;
  v_importo       t_importo;
  v_entry           binary_integer := 0;
  D_mese            varchar(2);
  v_stringa_importo varchar(192);
  R_21              number(12,2);
  R_22              number(12,2);
  conta_GL          number;
  conta_GM          number;
  Tot_R_20          number(12,2);
  Tot_R_22			number(12,2);
  conta_GC          number;
  conta_GL_GS       number;
  ragione_sociale_GS varchar(50);
  codice_fiscale_GS varchar(16);
  tel_res_GS        varchar(15);
  e_mail_GS           GESTIONI.E_MAIL%TYPE;
  comm_codice_fiscale varchar(16);
  comm_nome           varchar(60);
  comm_indirizzo_res  varchar(40);
  comm_numero_civico  varchar(5);
  comm_cap            varchar(5);
  comm_comune_res     varchar(30);
  comm_provincia_res  varchar(2);
  comm_sede_inps      varchar(4);
  comm_tel_res        varchar(15);
  comm_fax_res        varchar(15);
  comm_codice_attivita varchar(5);
  comm_e_mail         GESTIONI.E_MAIL%TYPE;
-- Estrazione importi collaboratore
--
cursor cur_imp (p_ci number, p_anno number, p_gestione varchar2)is
select 	           mese,
		           dal,
				   al,
				   nvl(assicurazione,' ') assicurazione,
		               e_round(nvl(tariffa,0),'I')  tariffa,
				   e_round(nvl(qta,0),'A')      qta,
				   e_round(nvl(importo,0),'I')  importo,
				   e_round(nvl(eccedenza_01,0),'I') eccedenza_01,
				   e_round(nvl(eccedenza_02,0),'I') eccedenza_02,
				   e_round(nvl(eccedenza_03,0),'I') eccedenza_03
			from   denuncia_importi_gla
			where    ci     = p_ci
			and    anno     = p_anno
			and    gestione = p_gestione
			ORDER BY MESE
;
v_imp cur_imp%ROWTYPE;
trovato boolean := true;
--
-- Estrazione Parametri di Selezione della Prenotazione
--
BEGIN
BEGIN
  select valore
    into D_tipo
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_TIPO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_tipo := 'P';
END;
--dbms_output.put_line('tipo'||D_tipo);
BEGIN
  select valore
    into D_ced
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_CED'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_ced := null;
END;
BEGIN
  select valore
    into D_gestione
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_GESTIONE'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_gestione := '%';
END;
BEGIN
  select to_number(valore)
    into D_anno
   from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_ANNO'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    select anno
      into D_anno
      from riferimento_fine_anno
     where rifa_id = 'RIFA'
  ;
END;
begin
      select valore
       into D_fascia
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_FASCIA'
      ;
exception when no_data_found then
    D_fascia := '%';
end;
begin
      select valore
       into D_referente
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro       = 'P_REFERENTE'
      ;
exception when no_data_found then
    D_referente := null;
end;

BEGIN
  select valore
    into D_codice_fiscale
    from a_parametri
   where no_prenotazione = prenotazione
     and parametro       = 'P_CODICE_FISCALE'
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_codice_fiscale := null;
END;

BEGIN
  select ente     D_ente
       , utente   D_utente
       , ambiente D_ambiente
    into D_ente,D_utente,D_ambiente
    from a_prenotazioni
   where no_prenotazione = prenotazione
  ;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       D_ente     := null;
       D_utente   := null;
       D_ambiente := null;
END;

--
-- Estrazione codici delle eccezioni
--
 begin
 select note
 into   D_codice_1
 from estrazione_valori_contabili
 where estrazione = 'DENUNCIA_GLA'
 and colonna = 'ECCEDENZA_01'
 and to_date('3112'||to_char(D_anno),'ddmmyyyy') between dal and nvl(al,to_date('3333333','j'));
 exception
  when no_data_found then
     D_codice_1 := ' ';
 end;
 begin
 select note
 into   D_codice_2
 from estrazione_valori_contabili
 where estrazione = 'DENUNCIA_GLA'
 and colonna = 'ECCEDENZA_02'
 and to_date('3112'||to_char(D_anno),'ddmmyyyy') between dal and nvl(al,to_date('3333333','j'));
 exception
  when no_data_found then
     D_codice_2 := ' ';
 end;
 begin
 select note
 into   D_codice_3
 from estrazione_valori_contabili
 where estrazione = 'DENUNCIA_GLA'
 and colonna = 'ECCEDENZA_03'
 and to_date('3112'||to_char(D_anno),'ddmmyyyy') between dal and nvl(al,to_date('3333333','j'));
 exception
  when no_data_found then
     D_codice_3 := ' ';
 end;

conta_GC := 0;

-- Estrazione del Committente
FOR CUR_COMM IN -- estrae i record per GM
   (select nvl(gest.aut_01m, D_ced) aut_01m
	from gestioni gest
	where gest.codice          like D_gestione
	and   nvl(gest.fascia,' ') like D_fascia
	and   gest.codice in  (select degl.gestione
                               from denuncia_gla degl
				      )
	group by nvl(gest.aut_01m, D_ced)
   ) LOOP
-- dbms_output.put_line('committente'||cur_comm.aut_01m);
begin
   select gest.codice_fiscale codice_fiscale,
          gest.nome            nome,
		   gest.indirizzo_res   indirizzo_res,
		   gest.numero_civico   numero_civico,
		   gest.cap             cap,
		   substr(comu.descrizione,1,30)      comune_res,
		   comu.sigla_provincia  provincia_res,
		   lpad(gest.provincia_sede_inps,2,0)||lpad(gest.zona_sede_inps,2,0) sede_inps,
		   gest.tel_res         tel_res,
		   gest.fax_res         fax_res,
		   gest.codice_attivita codice_attivita,
		   substr(gest.e_mail,1,30)         e_mail
      into comm_codice_fiscale,comm_nome,comm_indirizzo_res,comm_numero_civico,comm_cap,
           comm_comune_res,comm_provincia_res,comm_sede_inps,comm_tel_res,comm_fax_res,
           comm_codice_attivita,comm_e_mail
	from gestioni gest
         , comuni comu
	where comu.cod_provincia (+) = gest.provincia_res
      and   comu.cod_comune (+)    = gest.comune_res
      and   gest.codice            = CUR_COMM.aut_01m;
 exception
--  when no_data_found then null;
  when no_data_found then
       select ente.codice_fiscale codice_fiscale,
              ente.nome            nome,
		  ente.indirizzo_res   indirizzo_res,
		  ente.numero_civico   numero_civico,
		  ente.cap             cap,
		  substr(comu.descrizione,1,30)     comune_res,
		  comu.sigla_provincia provincia_res,
		  null                 sede_inps,
		  ente.tel_res         tel_res,
		  ente.fax_res         fax_res,
		  ente.codice_attivita codice_attivita,
		  substr(ente.e_mail,1,30)          e_mail
      into comm_codice_fiscale,comm_nome,comm_indirizzo_res,comm_numero_civico,comm_cap,
           comm_comune_res,comm_provincia_res,comm_sede_inps,comm_tel_res,comm_fax_res,
           comm_codice_attivita,comm_e_mail
	from ente
          , comuni comu
	where comu.cod_provincia (+) = ente.provincia_res
      and   comu.cod_comune (+)    = ente.comune_res
;
end;
   P_pagina := P_pagina + 1;
 -- Estrazione delle gestioni per Committente
  for CUR_GEST in
   (select codice
    from gestioni
	where nvl(aut_01m, D_ced) = CUR_COMM.aut_01m
	and       codice       like D_gestione
	and   nvl(fascia,' ')  like D_fascia   ) loop
--   dbms_output.put_line('gestione'||cur_gest.codice);
   D_progressivo := 0;
   FOR CUR_CI IN   -- estrae record per record GL
   (select  codice_fiscale     ,
            substr(anag.cognome,1,20) cognome           ,
		substr(anag.nome,1,20) nome             ,
		anag.data_nas          ,
		substr(comu1.descrizione,1,30)      comune_nas,
            substr( decode( sign(199-comu1.cod_provincia)
                                 , -1, 'EE'
                                     , comu1.sigla_provincia)
                   ,1,2)           provincia_nas,
		anag.indirizzo_dom     ,
		anag.cap_dom           ,
		substr(comu2.descrizione,1,30)      comune_dom,
		comu2.sigla_provincia  provincia_dom,
		degl.ci,
		degl.anno              ,
		degl.gestione          ,
		degl.attivita          ,
		degl.eccedenza_versata
from       anagrafici   anag,
           denuncia_gla degl,
		   rapporti_individuali rain,
		   comuni       comu1,
		   comuni       comu2
  where rain.ni = anag.ni
  and anag.al is null
  and degl.ci = rain.ci
  and anag.comune_nas     = comu1.cod_comune (+)
  and anag.provincia_nas  = comu1.cod_provincia (+)
  and anag.comune_dom     = comu2.cod_comune (+)
  and anag.provincia_dom  = comu2.cod_provincia (+)
  and anno     = D_anno
  and gestione = CUR_GEST.codice
  and (   rain.cc is null
       or exists
          (select 'x'
             from a_competenze
            where ente        = D_ente
              and ambiente    = D_ambiente
              and utente      = D_utente
              and competenza  = 'CI'
              and oggetto     = rain.cc
            )
          )
  order by degl.ci
  ) loop
--  dbms_output.put_line('ci'||cur_ci.ci);
  D_progressivo := D_progressivo +1;
--  dbms_output.put_line('progressivo'||d_progressivo);
-- TIPO GL
P_riga := P_riga + 10;
insert into a_appoggio_stampe VALUES
           (prenotazione
           , 1
           , P_pagina
           , P_riga
		   , 'GL'
		   ||rpad(nvl(COMM_codice_fiscale,' '),16,' ')
		   ||lpad(to_char(D_anno),4,'0')
		   ||rpad(CUR_CI.codice_fiscale,16,' ')
		   ||rpad(CUR_CI.cognome,20,' ')
		   ||rpad(CUR_CI.nome,20,' ')
		   ||rpad(to_char(CUR_CI.data_nas,'ddmmyyyy'),8,' ')
		   ||rpad(nvl(CUR_CI.comune_nas,' '),30,' ')
		   ||rpad(nvl(CUR_CI.provincia_nas,' '),2,' ')
		   ||rpad(nvl(CUR_CI.indirizzo_dom,' '),40,' ')
		   ||rpad(' ',5,' ')
		   ||rpad(nvl(CUR_CI.cap_dom,' '),5,' ')
		   ||rpad(nvl(CUR_CI.comune_dom,' '),30,' ')
		   ||rpad(nvl(CUR_CI.provincia_dom,' '),2,' ')
		   ||rpad(' ',3,' ')    -- Sigla Stato Estero
		   ||rpad(substr(nvl(ltrim(rtrim(CUR_CI.attivita)),' '),1,2),2,' ')
		   ||lpad(to_char(D_progressivo),6,'0')
		   ||rpad(' ',42,' ')
		   ||rpad(' ',1,' ')
		   ||rpad(' ',2,' ')
		   );
trovato := true;
open cur_imp (cur_ci.ci, D_anno,CUR_GEST.codice);
while trovato loop
-- Azzera le variabili per i mesi dei collaboratori
   mese_1 :='';
   dal_1  := '';
   al_1   := '';
   assicurazione_1 :='';
   tariffa_1       := '';
   qta_1           := '';
   importo_1       := '';
   eccedenza_01_1  := '';
   eccedenza_02_1  := '';
   eccedenza_03_1  := '';
   mese_2 :=	'';
   dal_2  :=    '';
   al_2   :=    '';
   assicurazione_2 := '';
   tariffa_2       := '';
   qta_2           := '';
   importo_2       := '';
   eccedenza_01_2  := '';
   eccedenza_02_2  := '';
   eccedenza_03_2  := '';
   --dbms_output.put_line('contatore'||contatore);
   -- Record dispari
   fetch cur_imp into v_imp;
   if cur_imp%NOTFOUND then
       trovato := false;
    else
       mese_1 :=	V_IMP.mese;
       dal_1  :=    V_IMP.dal;
       al_1   :=    V_IMP.al;
       assicurazione_1 := V_IMP.assicurazione;
       tariffa_1       := V_IMP.tariffa;
       qta_1           := V_IMP.qta;
       importo_1       := V_IMP.importo;
       eccedenza_01_1  := V_IMP.eccedenza_01;
       eccedenza_02_1  := V_IMP.eccedenza_02;
       eccedenza_03_1  := V_IMP.eccedenza_03;
       -- ho trovato il primo
       fetch cur_imp into v_imp;
       if cur_imp%NOTFOUND then
          trovato := false;
       else
           mese_2 :=	V_IMP.mese;
           dal_2  :=    V_IMP.dal;
           al_2   :=    V_IMP.al;
           assicurazione_2 := V_IMP.assicurazione;
           tariffa_2       := V_IMP.tariffa;
           qta_2           := V_IMP.qta;
           importo_2       := V_IMP.importo;
           eccedenza_01_2  := V_IMP.eccedenza_01;
           eccedenza_02_2  := V_IMP.eccedenza_02;
           eccedenza_03_2  := V_IMP.eccedenza_03;
      end if;
   end if; -- caricati i record
-- GC
if mese_1 is not null then -- almeno un record da inserire
P_riga := P_riga +1;
conta_GC := conta_GC +1;
insert into a_appoggio_stampe VALUES
           (prenotazione
           , 1
           , P_pagina
           , P_riga
		   , 'GC'
		   ||rpad(nvl(COMM_codice_fiscale,' '),16,' ')
		   ||lpad(to_char(D_anno),4,'0')
		   ||rpad(CUR_CI.codice_fiscale,16,' ')
		   -- Mese_1'
		   ||lpad(to_char(Mese_1),2,'0')
		   ||lpad(to_char(Tariffa_1),10,'0')
		   ||lpad(substr(to_char(Qta_1 * 100),1,4),4,'0')
		   ||lpad(to_char(Importo_1),10,'0')
		   ||rpad(D_codice_1,2,' ')
		   ||lpad(to_char(Eccedenza_01_1),10,'0')
		   ||rpad(D_codice_2,2,' ')
		   ||lpad(to_char(Eccedenza_02_1),10,'0')
		   ||rpad(D_codice_3,2,' ')
		   ||lpad(to_char(Eccedenza_03_1),10,'0')
		   ||rpad(to_char(dal_1,'ddmmyyyy'),8,' ')
		   ||rpad(to_char(al_1,'ddmmyyyy'),8,' ')
		   ||rpad(assicurazione_1,3,' ')
		   ||rpad(' ',1,' ')
		   -- Mese 2'
		   ||lpad(to_char(nvl(Mese_2,0)),2,'0')
		   ||lpad(to_char(nvl(Tariffa_2,0)),10,'0')
		   ||lpad(substr(to_char(nvl(Qta_2,0) * 100),1,4),4,'0')
		   ||lpad(to_char(nvl(Importo_2,0)),10,'0')
		   ||rpad(D_codice_1,2,' ')
		   ||lpad(to_char(nvl(Eccedenza_01_2,0)),10,'0')
		   ||rpad(D_codice_2,2,' ')
		   ||lpad(to_char(nvl(Eccedenza_02_2,0)),10,'0')
		   ||rpad(D_codice_3,2,' ')
		   ||lpad(to_char(nvl(Eccedenza_03_2,0)),10,'0')
		   ||rpad(nvl(to_char(dal_2,'ddmmyyyy'),' '),8,' ')
		   ||rpad(nvl(to_char(al_2,'ddmmyyyy'),' '),8,' ')
		   ||rpad(nvl(assicurazione_2,' '),3,' ')
		   ||rpad(' ',52,' ')
		   ||rpad(' ',2,' ')
  	   );
end if;
end loop; -- END CUR_IMP
close cur_imp;
-- Totalizza i record di CUR_IMP raggruppamento per ci
BEGIN
select             e_round(sum(nvl(tariffa,0)),'I'),
				   e_round(sum(nvl(importo,0)),'I'),
				   e_round(sum(nvl(eccedenza_01,0)) + sum(nvl(eccedenza_02,0))+ sum(nvl(eccedenza_03,0)),'I'),
				   e_round(sum(nvl(eccedenza_01,0)),'I'),
				   e_round(sum(nvl(eccedenza_02,0)),'I'),
				   e_round(sum(nvl(eccedenza_03,0)),'I')
			into C_16, C_17, C_18,C_20, C_22, C_24
			from   denuncia_importi_gla digl
			where    ci     = CUR_CI.ci
			and    anno     = D_anno
			and    gestione = CUR_GEST.codice
			group by ci;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       C_16 := 0;
	   C_17 := 0;
	   C_18 := 0;
	   C_20 := 0;
	   C_22 := 0;
	   C_24 := 0;
END;
-- TC
P_riga := P_riga +1;
insert into a_appoggio_stampe VALUES
           (prenotazione
           , 1
           , P_pagina
           , P_riga
		   , 'TC'
		   ||rpad(nvl(COMM_codice_fiscale,' '),16,' ')
		   ||lpad(to_char(D_anno),4,'0')
		   ||rpad(CUR_CI.codice_fiscale,16,' ')
		   ||lpad(to_char(C_16),15,'0')
		   ||lpad(to_char(C_17),15,'0')
		   ||lpad(to_char(C_18),15,'0')
		   ||rpad(D_codice_1,2,' ')
		   ||lpad(to_char(C_20),10,'0')
		   ||rpad(D_codice_2,2,' ')
		   ||lpad(to_char(C_22),10,'0')
		   ||rpad(D_codice_3,2,' ')
		   ||lpad(to_char(C_24),10,'0')
		   ||rpad(' ',124,' ')
		   ||lpad('0',10,'0')
		   ||rpad(' ',1,' ')
		   ||rpad(' ',2,' ')
		   );
end loop; -- END CUR_CI
end loop; -- END CUR_GEST
P_riga :=  1;
-- GM
insert into a_appoggio_stampe VALUES
           (prenotazione
           , 1
           , P_pagina
           , P_riga
		   , 'GM'
		   ||rpad(nvl(COMM_codice_fiscale,' '),16,' ')
		   ||lpad(to_char(D_anno),4,'0')
		   ||rpad(nvl(COMM_nome,' '),60,' ')
		   ||rpad(nvl(COMM_indirizzo_res,' '),40,' ')
		   ||rpad(nvl(COMM_numero_civico,' '),5, ' ')
		   ||rpad(nvl(COMM_cap,' '),5,' ')
		   ||rpad(nvl(COMM_comune_res,' '),30,' ')
		   ||rpad(nvl(COMM_provincia_res,' '),2,' ')
		   ||rpad(nvl(COMM_sede_inps,' '),4,' ')
		   ||rpad(nvl(COMM_tel_res,' '),15,' ')
		   ||rpad(nvl(COMM_fax_res,' '),15,' ')
		   ||rpad(nvl(COMM_e_mail,' '),30,' ')
		   ||lpad(nvl(COMM_codice_attivita,'0'),5,'0')
		   ||lpad('0',5,'0')
		   ||rpad(' ',3,' ')
		   ||'1'
		   ||rpad(' ',11,' ')
		   ||rpad(D_tipo,1,' ')
		   ||rpad(' ',2,' ')
		   );
-- Utilizzo delle plsql tables
v_entry:= 1;
  v_stringa_importo := null;
for CUR_MESE in
(select mese, e_round(sum(importo),'I') importo
from   denuncia_importi_gla digl
where  anno     = D_anno
and    gestione like D_gestione
and    gestione in
                  (select codice
                    from gestioni
                    where nvl(aut_01m, D_ced) = CUR_COMM.aut_01m
				   )
and importo is not null
           and exists
               (select 'x'
                  from rapporti_individuali rain
                 where rain.ci = digl.ci
                   and (   rain.cc is null
                        or exists
                          (select 'x'
                             from a_competenze
                            where ente        = D_ente
                              and ambiente    = D_ambiente
                              and utente      = D_utente
                              and competenza  = 'CI'
                              and oggetto     = rain.cc
                          )
                       )
                 )
group by mese
order by mese
)
loop
v_stringa_importo := v_stringa_importo ||
                     lpad(to_char(cur_mese.mese),2,'0')||'0001'||
                     lpad(to_char(cur_mese.Importo),10,'0');
/* vecchia funzione
    -- tengo comunque tutti i valori
       v_mese(v_entry)    := cur_mese.mese;
       v_importo(v_entry) := cur_mese.importo;
       v_entry := v_entry + 1;
*/
end loop;
/* vecchia funzione
if (v_mese.first is not null and  v_mese.last is not null) then
 for i in v_mese.first .. v_mese.last loop
        if v_stringa_importo is null then
		 D_mese    :=  lpad(to_char(v_mese(i)),2,'0');
		 v_stringa_importo :=  lpad(to_char(v_Importo(i)),16, '0');
        else
         -- mi interessa solo il primo mese, dopo tengo solo gli importi
		 v_stringa_importo := v_stringa_importo ||lpad(to_char(v_Importo(i)),16, '0');
        end if;
 end loop;
end if;
--pulizia variabili
   v_mese.delete;
   v_importo.delete;
-- dbms_output.put_line('v_stringa_importo' || v_stringa_importo);
*/
-- GR
P_riga := P_riga + 1;
		insert into a_appoggio_stampe VALUES
           (prenotazione
           , 1
           , P_pagina
           , P_riga
		   , 'GR'
		   ||rpad(nvl(COMM_codice_fiscale,' '),16,' ')
		   ||lpad(to_char(D_anno),4,'0')
		   ||rpad(nvl(v_stringa_importo,'0'),192,'0')
		   ||rpad(' ',40,' ')
		   ||rpad(' ',2,' ')
		   );
begin
  -- I record R_20 ed R_22 sono uguali
   select   e_round(sum(nvl(eccedenza_01,0)) + sum(nvl(eccedenza_02,0))+ sum(nvl(eccedenza_03,0)),'I'),
            e_round(sum(nvl(importo,0)),'I')
	into    R_21,
	        R_22
	from   denuncia_importi_gla digl
	where   anno     = D_anno
      and    gestione like D_gestione
	and    gestione in
                      (select codice
                       from gestioni
                       where nvl(aut_01m, D_ced) = CUR_COMM.aut_01m
					   )
           and exists
               (select 'x'
                  from rapporti_individuali rain
                 where rain.ci = digl.ci
                   and (   rain.cc is null
                        or exists
                          (select 'x'
                             from a_competenze
                            where ente        = D_ente
                              and ambiente    = D_ambiente
                              and utente      = D_utente
                              and competenza  = 'CI'
                              and oggetto     = rain.cc
                          )
                       )
                 )
			;
	exception
	  when no_data_found then
	    R_21 := 0;
		R_22 := 0;
end;
-- TR
P_riga := P_riga + 1;
insert into a_appoggio_stampe VALUES
           (prenotazione
           , 1
           , P_pagina
           , P_riga
		   , 'TR'
		   ||rpad(nvl(COMM_codice_fiscale,' '),16,' ')
		   ||lpad(to_char(D_anno),4,'0')
		   ||lpad(to_char(R_22),15,'0')
		   ||lpad(to_char(R_21),15,'0')
		   ||lpad(to_char(R_22),15,'0')
		   ||lpad('0',15,'0')
		   ||lpad('0',15,'0')
		   ||lpad('0',15,'0')
		   ||rpad(' ',8,' ')
		   ||rpad(' ',134,' ')
		   ||rpad(' ',2,' ')
		   );
begin
select  count(*)    -- totalizza i record estratti da CUR_CI per gestione
into    conta_GL
from    denuncia_gla degl 
  where anno     = D_anno
  and   gestione like D_gestione
  and   gestione in
                    (select codice
                      from gestioni
                      where nvl(aut_01m, D_ced) = CUR_COMM.aut_01m
					  )
           and exists
               (select 'x'
                  from rapporti_individuali rain
                 where rain.ci = degl.ci
                   and (   rain.cc is null
                        or exists
                          (select 'x'
                             from a_competenze
                            where ente        = D_ente
                              and ambiente    = D_ambiente
                              and utente      = D_utente
                              and competenza  = 'CI'
                              and oggetto     = rain.cc
                          )
                       )
                 )
  ;
end;
-- TT
insert into a_appoggio_stampe VALUES
           (prenotazione
           , 1
           , P_pagina
           , 999999
		   , 'TT'
		   ||rpad(nvl(COMM_codice_fiscale,' '),16,' ')
		   ||lpad(to_char(D_anno),4,'0')
		   ||lpad(to_char(conta_GL),6,'0')
		   ||rpad(' ',226,' ')
		   ||rpad(' ',2,' ')
		   );
END LOOP; -- END CUR_COMM
begin
-- totalizza  i record estratti dal cursore CUR_COMM
    select count(distinct nvl(aut_01m, D_ced) )
    into conta_GM
	from gestioni
	where codice      like D_gestione
	and   nvl(fascia,' ') like D_fascia
	and   codice in  (select degl.gestione
	                  from denuncia_gla degl
           where exists
               (select 'x'
                  from rapporti_individuali rain
                 where rain.ci = degl.ci
                   and (   rain.cc is null
                        or exists
                          (select 'x'
                             from a_competenze
                            where ente        = D_ente
                              and ambiente    = D_ambiente
                              and utente      = D_utente
                              and competenza  = 'CI'
                              and oggetto     = rain.cc
                          )
                       )
                 )
				      );
	select  count(degl.ci)
	   into conta_GL_GS                         -- totalizza i record GL
       from denuncia_gla degl
     where  anno    = D_anno
	and   gestione in (select codice from gestioni
                          where codice     like D_gestione
	                      and   nvl(fascia,' ') like D_fascia
                         )
           and exists
               (select 'x'
                  from rapporti_individuali rain
                 where rain.ci = degl.ci
                   and (   rain.cc is null
                        or exists
                          (select 'x'
                             from a_competenze
                            where ente        = D_ente
                              and ambiente    = D_ambiente
                              and utente      = D_utente
                              and competenza  = 'CI'
                              and oggetto     = rain.cc
                          )
                       )
                 );
end;
  begin
 -- Totalizza R_20 ed R_22 del record TR
   select e_round(sum(nvl(importo,0)) ,'I')
        , e_round(sum(nvl(importo,0)) ,'I')
--        , e_round(sum(nvl(eccedenza_01,0)) + sum(nvl(eccedenza_02,0)) + sum(nvl(eccedenza_03,0)),'I')
	into    Tot_R_20,
	        Tot_R_22
	from    denuncia_importi_gla digl
	where   anno     = D_anno
	and   gestione in (select codice from gestioni
                          where codice     like D_gestione
	                      and   nvl(fascia,' ') like D_fascia
                         )
           and exists
               (select 'x'
                  from rapporti_individuali rain
                 where rain.ci = digl.ci
                   and (   rain.cc is null
                        or exists
                          (select 'x'
                             from a_competenze
                            where ente        = D_ente
                              and ambiente    = D_ambiente
                              and utente      = D_utente
                              and competenza  = 'CI'
                              and oggetto     = rain.cc
                          )
                       )
                 );
   exception
     when no_data_found then
	       Tot_R_20 := 0;
		   Tot_R_22 := 0;
 end;
/* Conteggio vecchio: i record GC non si possono determinare dalla nostra tabella
   perche dipendono dal numero di mesi dicharati per collaboratore (ogni GC contiene max
   2 mesi); sostituito con un contatore attivato all'inserimento fisico del rec. GC
	select count(*)                                 -- totalizza  i record estratti dal cursore CUR_IMP
	into conta_GC
	from   denuncia_importi_gla digl
	where   anno     = D_anno
	and   gestione in (select codice from gestioni
                          where codice     like D_gestione
	                      and   nvl(fascia,' ') like D_fascia
                         )

			;
*/
begin
	select codice_fiscale,nome,nvl(tel_res,' '),nvl(substr(e_mail,1,30),' ')
	into   codice_fiscale_GS, ragione_sociale_GS,tel_res_GS, e_mail_GS
    from gestioni
	where codice      like D_ced;
   exception
     when no_data_found then
	select codice_fiscale,nome,nvl(tel_res,' '),nvl(substr(e_mail,1,30),' ')
	into   codice_fiscale_GS, ragione_sociale_GS,tel_res_GS, e_mail_GS
    from ente;
end ;
-- GS
P_pagina := 1;
P_riga   := 1;

-- dbms_output.put_line('conta_GM '||conta_GM);
-- dbms_output.put_line('conta_GC '||conta_GC);

insert into a_appoggio_stampe VALUES
           (prenotazione
           , 1
           , P_pagina
           , P_riga
		   , 'GS'
		   ||rpad(nvl(ragione_sociale_GS,' '),50,' ')
		   ||rpad(nvl(D_codice_fiscale,nvl(codice_fiscale_GS,' ')),16,' ')
		   ||lpad(to_char(conta_GM),6,'0')
		   ||lpad(to_char(conta_GL_GS),6,'0')
		   ||lpad(to_char(Tot_R_20),15,'0')
		   ||lpad(to_char(Tot_R_22),15,'0')
		   ||rpad(nvl(D_referente,' '),40,' ')
		   ||rpad(nvl(tel_res_GS,' '),15,' ')
		   ||lpad(to_char(conta_GM),6,'0') -- anche numero di record presenti in GR
		   ||lpad(to_char(conta_GC),6,'0')
		   ||rpad(nvl(e_mail_GS,' '),30,' ')
		   ||rpad(' ',47,' ')
		   ||rpad(' ',2,' ')
		   );
commit;
END;
end;
end;
/

