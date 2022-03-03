CREATE OR REPLACE PACKAGE PECCSMDO IS
/******************************************************************************
 NOME:          PECCSMDO
 DESCRIZIONE:
 ARGOMENTI:
 RITORNA:
 ECCEZIONI:
 ANNOTAZIONI:  Il PARAMETRO P_anno indica l'anno di riferimento da elaborare.
		   Il PARAMETRO P_periodo indica il semestre da elaborare
		   Il PARAMETRO P_gestione indica una specifica gestione da elaborare
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  08/07/2004	MV    Prima emissione
 1.1  16/09/2004  MS    Mod. per Attivita 7276
 1.2  24/01/2007  ML    Aggiunta condizione sull'anno in lettura eventi (A19381)
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (prenotazione in number, passo in number);
END;
/
CREATE OR REPLACE PACKAGE BODY PECCSMDO IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.2 del 24/01/2007';
END VERSIONE;
PROCEDURE MAIN (prenotazione IN NUMBER, passo IN NUMBER) IS
BEGIN
DECLARE
 D_ente        varchar(4);
 D_ambiente    varchar(8);
 D_utente      varchar(8);
 P_anno 	   number;
 P_gestione	   varchar2(8);
 P_periodo     number;
 D_evento      number;
 D_data        date;
 P_pagina      number := 0;
 P_riga        number := 0;
 D_tipo_albo   varchar2(6);
 D_data_iscr   date;
 D_num_iscr    varchar2(12);
 D_prov_iscr   varchar2(2);
BEGIN
-- estrazione parametri di selezione
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
  BEGIN
    SELECT to_number(valore)
      INTO P_anno
	  FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro       = 'P_ANNO'
    ;
	exception
	  when no_data_found then
            SELECT anno
	          INTO P_anno
                FROM RIFERIMENTO_RETRIBUZIONE
                WHERE rire_id = 'RIRE';
   END;
--dbms_output.put_line(P_anno);
   BEGIN
   select to_number(valore)
     into P_periodo
     from a_parametri
    WHERE no_prenotazione = prenotazione
      AND parametro       = 'P_PERIODO';
   END;
  BEGIN
   select valore
     into P_gestione
     from a_parametri
    WHERE no_prenotazione = prenotazione
      AND parametro       = 'P_GESTIONE';
   exception
     when no_data_found then
      P_gestione := '%';
   END;
-- DATI ECONOMICI
FOR CURS_DEON IN (
select ci, codice_fiscale, gestione, trattenuta_prec
     , mese1, mese2, mese3, mese4, mese5, mese6
     , credito_prec, totale_dovuto, totale_trattenuto, debito_credito
  from denuncia_onaosi deon
     , anagrafici anag
 where anag.ni = (select ni from rapporti_individuali
                   where ci = deon.ci)
   and anag.al is null
   and deon.anno     = P_anno
   and deon.periodo  = P_periodo
   and deon.gestione like P_gestione
   and exists
      (select 'x'
         from rapporti_individuali rain
        where rain.ci = deon.ci
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
) LOOP
-- dbms_output.put_line(CURS_DEON.ci);
P_pagina := P_pagina + 1;
begin
select evento, data
  into D_evento, D_data
from denuncia_eventi_onaosi
where ci      = CURS_DEON.ci
and  anno     = P_anno
and  periodo  = P_periodo
and  gestione = CURS_DEON.gestione
and  nr_evento= 1
and  anno     = P_anno
;
exception
when no_data_found then
  D_evento := null;
  D_data   := null;
end;
P_riga := 1;
insert into a_appoggio_stampe(no_prenotazione, no_passo, pagina, riga, testo)
values (prenotazione, 2, P_pagina, P_riga,
--        to_char(CURS_DEON.ci)||';'||
--        CURS_DEON.gestione||';'||
        CURS_DEON.codice_fiscale||';'||
        translate(to_char(CURS_DEON.trattenuta_prec,'99990.00'),'.',',')||';'||
        translate(to_char(CURS_DEON.mese1,'99990.00'),'.',',')||';'||
        translate(to_char(CURS_DEON.mese2,'99990.00'),'.',',')||';'||
        translate(to_char(CURS_DEON.mese3,'99990.00'),'.',',')||';'||
        translate(to_char(CURS_DEON.mese4,'99990.00'),'.',',')||';'||
        translate(to_char(CURS_DEON.mese5,'99990.00'),'.',',')||';'||
        translate(to_char(CURS_DEON.mese6,'99990.00'),'.',',')||';'||
        translate(to_char(CURS_DEON.credito_prec,'99990.00'),'.',',')||';'||
        translate(to_char(CURS_DEON.totale_dovuto,'99990.00'),'.',',')||';'||
        translate(to_char(CURS_DEON.totale_trattenuto,'99990.00'),'.',',')||';'||
        translate(to_char(CURS_DEON.debito_credito,'99990.00'),'.',',')||';'||
        to_char(D_evento)||';'||
        to_char(D_data,'dd/mm/yyyy')
        );
-- Per eventi successivi
FOR CUR_DEEO IN (
select evento,
data
from denuncia_eventi_onaosi
where ci      = CURS_DEON.ci
and   anno    = P_anno
and   periodo  = P_periodo
and   gestione = CURS_DEON.gestione
and   nr_evento > 1
order by nr_evento
) loop
P_riga := P_riga + 1;
insert into a_appoggio_stampe(no_prenotazione, no_passo, pagina, riga, testo)
values (prenotazione, 2, P_pagina, P_riga,
        CURS_DEON.codice_fiscale||';'||
        ';;;;;;;;;;;'||
        to_char(CUR_DEEO.evento)||';'||
        to_char(CUR_DEEO.data,'dd/mm/yyyy')
        );
end loop; -- cur_deeo
end loop; -- curs_deon
-- DATI ANAGRAFICI
P_riga   := 0;
P_pagina := P_pagina + 1;
FOR CURS_ANAG IN
( select deen.ci, deen.gestione, nome, cognome, sesso
       , data_nas, comu2.descrizione comune_nas
       , codice_fiscale,  indirizzo_res, comune_res, comu.descrizione comune
       , provincia_res, comu.sigla_provincia provincia, cap_res
    from denuncia_eventi_onaosi deen
       , anagrafici anag
       , comuni comu
       , comuni comu2
   where anno     = P_anno
     and periodo  = P_periodo
     and gestione like P_gestione
     and evento   in (1,2,8)
     and deen.ci in (select distinct rain.ci
                       from rapporti_individuali rain
                      where rain.ni = anag.ni)
     and to_date(lpad(P_periodo,2,'0')||P_anno,'mmyyyy')
         between dal and nvl(al,to_date('3333333','j'))
     and comu.cod_comune       = comune_res
     and comu.cod_provincia    = provincia_res
     and comu2.cod_comune      = comune_nas
     and comu2.cod_provincia   = provincia_nas
     and exists
      (select 'x'
         from rapporti_individuali rain
        where rain.ci = deen.ci
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
) loop
D_tipo_albo := null;
D_data_iscr := null;
D_num_iscr  := null;
D_prov_iscr := null;
begin
 select distinct scd , del, numero, comu.sigla_provincia
 into D_tipo_albo, D_data_iscr, D_num_iscr, D_prov_iscr
 from archivio_documenti_giuridici adogi, comuni comu
 where ci = CURS_ANAG.ci
 and comu.cod_provincia = adogi.provincia
 and comu.cod_comune    = adogi.comune
 and adogi.evento = 'ALBO'
 and to_date(lpad(P_periodo,2,'0')||P_anno,'mmyyyy')
                             between dal and nvl(al,to_date('3333333','j'))
;
exception
 when no_data_found then
   null;
end;
P_riga := P_riga +1;
 insert into    a_appoggio_stampe(no_prenotazione, no_passo, pagina, riga, testo)
        values (prenotazione, 4, P_pagina, P_riga,
            rpad(CURS_ANAG.codice_fiscale, 16,' ')||';'||
            rpad(CURS_ANAG.cognome,40, ' ')||';'||
            rpad(CURS_ANAG.nome,36, ' ')||';'||
            rpad(nvl(CURS_ANAG.sesso,' '),1,' ')||';'||
            rpad(nvl(CURS_ANAG.comune_nas,' '),40,' ')||';'||
            rpad(nvl(to_char(CURS_ANAG.data_nas, 'dd/mm/yyyy'),' '), 10, ' ')||';'||
            rpad(CURS_ANAG.indirizzo_res, 40, ' ')||';;'|| -- salta il campo del nr. civico
            rpad(CURS_ANAG.cap_res,5, ' ')||';'||
            rpad(CURS_ANAG.comune,40, ' ')||';'||
            rpad(CURS_ANAG.provincia,2, ' ')||';'||
            rpad(nvl(D_tipo_albo ,' '),1, ' ')||';'||
            rpad(nvl(to_char(D_data_iscr,'dd/mm/yyyy') ,' '),10, ' ')||';'||
            lpad(nvl(D_num_iscr ,' '),12, ' ')||';'||
            rpad(nvl(D_prov_iscr ,' '),2, ' ')||';'||
            rpad(CURS_ANAG.gestione,8,' ')||';'||
            lpad(to_char(CURS_ANAG.ci), 8, ' ')
            );
end loop; -- curs_anag
P_pagina := P_pagina + 1;
--
if P_anno = 2003 then
FOR CURS_PEGI IN
  (  select deon.ci, deon.gestione,  nome,  cognome, sesso, data_nas
          , comu2.descrizione comune_nas, codice_fiscale
          , indirizzo_res, comune_res, comu.descrizione comune
          , provincia_res, comu.sigla_provincia provincia, cap_res
       from denuncia_onaosi deon
          , periodi_giuridici pegi
          , anagrafici anag
          , comuni comu
          , comuni comu2
       where pegi.ci   = deon.ci
         and rilevanza = 'S'
         and anno      = 2003
         and periodo   = P_periodo
         and deon.gestione like P_gestione
         and deon.ci in (select distinct rain.ci
                          from rapporti_individuali rain
                          where rain.ni = anag.ni)
         and   to_date('31072003','ddmmyyyy')
                             between pegi.dal and nvl(pegi.al,to_date('3333333','j'))
         and   to_date('31072003','ddmmyyyy')
                             between anag.dal and nvl(anag.al,to_date('3333333','j'))
         and comu.cod_comune      = comune_res
         and comu.cod_provincia   = provincia_res
         and comu2.cod_comune      = comune_nas
         and comu2.cod_provincia   = provincia_nas
         and exists
         (select 'x'
            from rapporti_individuali rain
           where rain.ci = deon.ci
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
   ) loop
D_tipo_albo := null;
D_data_iscr := null;
D_num_iscr  := null;
D_prov_iscr := null;
begin
 select distinct scd , del, numero, comu.sigla_provincia
 into D_tipo_albo, D_data_iscr, D_num_iscr, D_prov_iscr
 from archivio_documenti_giuridici adogi, comuni comu
 where ci = CURS_PEGI.ci
 and comu.cod_provincia = adogi.provincia
 and comu.cod_comune    = adogi.comune
 and adogi.evento = 'ALBO'
 and to_date('31072003','ddmmyyyy')
                             between dal and nvl(al,to_date('3333333','j'))
;
exception
 when no_data_found then
   null;
end;
P_riga := P_riga +1;
 insert into    a_appoggio_stampe(no_prenotazione, no_passo, pagina, riga, testo)
        values (prenotazione, 6, P_pagina, P_riga,
            rpad(CURS_PEGI.codice_fiscale, 16,' ')||';'||
            rpad(CURS_PEGI.cognome,40, ' ')||';'||
            rpad(CURS_PEGI.nome,36, ' ')||';'||
            rpad(nvl(CURS_PEGI.sesso,' '),1,' ')||';'||
            rpad(nvl(CURS_PEGI.comune_nas,' '),40,' ')||';'||
            rpad(nvl(to_char(CURS_PEGI.data_nas, 'dd/mm/yyyy'),' '), 10, ' ')||';'||
            rpad(CURS_PEGI.indirizzo_res, 40, ' ')||';;'|| -- salta il campo del nr. civico
            rpad(CURS_PEGI.cap_res,5, ' ')||';'||
            rpad(CURS_PEGI.comune,40, ' ')||';'||
            rpad(CURS_PEGI.provincia,2, ' ')||';'||
            rpad(nvl(D_tipo_albo ,' '),1, ' ')||';'||
            rpad(nvl(to_char(D_data_iscr,'dd/mm/yyyy') ,' '),10, ' ')||';'||
            lpad(nvl(D_num_iscr ,' '),12, ' ')||';'||
            rpad(nvl(D_prov_iscr ,' '),2, ' ')||';'||
            rpad(CURS_PEGI.gestione,8,' ')||';'||
            lpad(to_char(CURS_PEGI.ci), 8, ' ')
            );
end loop; -- curs_pegi
else
 null;
end if;
commit;
END;
END;
END;
/
