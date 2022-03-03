insert into a_errori ( errore, descrizione )
values ( 'P01087', 'Indicare dati obbligatori per Persona Giuridica')
/
alter table ANAGRAFICI modify
( PROVINCIA_RES  NULL
, COMUNE_RES     NULL
, CAP_RES        NULL
, PROVINCIA_DOM  NULL
, COMUNE_DOM     NULL
, CAP_DOM        NULL
)
/

alter table ANAGRAFICI modify
( CODICE_FISCALE  NULL
, CITTADINANZA    NULL
)
/

alter table anagrafici disable all triggers;

create table anag_ante_18075_ver2 as select * from anagrafici;

-- per gli individui
update anagrafici anag
   set codice_fiscale = decode( codice_fiscale, lpad('X',16,'X'), '', codice_fiscale )
     , cittadinanza = decode( cittadinanza, '', 'I', cittadinanza )
     , provincia_res = decode(provincia_res , 0, '', provincia_res )
     , comune_res = decode(comune_res , 0, '', comune_res )
     , cap_res = decode(cap_res , 0, '', cap_res )
     , provincia_dom = decode(provincia_dom , 0, '', provincia_dom )
     , comune_dom = decode(comune_dom , 0, '', comune_dom )
     , cap_dom = decode(cap_dom , 0, '', cap_dom )
     , data_agg = sysdate
     , utente = 'Aut.Agg.'
 where tipo_soggetto = 'I'
   and nvl(ambiente_prop,'GP4') in ( 'P00','GP4')
   and ( codice_fiscale = lpad('X',16,'X')
      or cittadinanza is null
      or provincia_res = 0
      or comune_res = 0
      or cap_res = 0
      or provincia_dom = 0
      or comune_dom = 0
      or cap_dom = 0
       )
/


-- per i soggetti giuridici 
update anagrafici anag
   set codice_fiscale = decode( codice_fiscale, lpad('X',16,'X'), '', codice_fiscale )
     , cittadinanza = ''
     , provincia_res = decode(provincia_res , 0, '', provincia_res )
     , comune_res = decode(comune_res , 0, '', comune_res )
     , cap_res = decode(cap_res , 0, '', cap_res )
     , provincia_dom = decode(provincia_dom , 0, '', provincia_dom )
     , comune_dom = decode(comune_dom , 0, '', comune_dom )
     , cap_dom = decode(cap_dom , 0, '', cap_dom )
     , data_agg = sysdate
     , utente = 'Aut.Agg.'
 where tipo_soggetto = 'E'
   and nvl(ambiente_prop,'GP4') in ( 'P00','GP4')
   and not exists ( select 'x' 
                 from unita_organizzative
                 where ni = anag.ni
              )
   and ( codice_fiscale = lpad('X',16,'X')
      or provincia_res = 0
      or comune_res = 0
      or cap_res = 0
      or provincia_dom = 0
      or comune_dom = 0
      or cap_dom = 0
       )
/

-- per i settori
update anagrafici anag
   set codice_fiscale = decode( codice_fiscale, lpad('X',16,'X'), '', codice_fiscale )
     , cittadinanza = ''
     , provincia_res = decode(provincia_res , 0, '', provincia_res )
     , comune_res = decode(comune_res , 0, '', comune_res )
     , cap_res = decode(cap_res , 0, '', cap_res )
     , provincia_dom = decode(provincia_dom , 0, '', provincia_dom )
     , comune_dom = decode(comune_dom , 0, '', comune_dom )
     , cap_dom = decode(cap_dom , 0, '', cap_dom )
     , data_agg = sysdate
     , utente = 'Aut.Agg.'
 where tipo_soggetto = 'E'
   and nvl(ambiente_prop,'GP4') in ( 'P00','GP4')
   and exists ( select 'x' 
                 from unita_organizzative
                 where ni = anag.ni
              )
   and ( codice_fiscale = lpad('X',16,'X')
      or provincia_res = 0
      or comune_res = 0
      or cap_res = 0
      or provincia_dom = 0
      or comune_dom = 0
      or cap_dom = 0
       )
/

-- per le sedi di DSEDI
update anagrafici anag
   set codice_fiscale = decode( codice_fiscale, lpad('X',16,'X'), '', codice_fiscale )
     , cittadinanza = ''
     , provincia_res = decode(provincia_res , 0, '', provincia_res )
     , comune_res = decode(comune_res , 0, '', comune_res )
     , cap_res = decode(cap_res , 0, '', cap_res )
     , provincia_dom = decode(provincia_dom , 0, '', provincia_dom )
     , comune_dom = decode(comune_dom , 0, '', comune_dom )
     , cap_dom = decode(cap_dom , 0, '', cap_dom )
     , data_agg = sysdate
     , utente = 'Aut.Agg.'
 where tipo_soggetto = 'S'
   and nvl(ambiente_prop,'GP4') in ( 'P00','GP4')
   and ( codice_fiscale = lpad('X',16,'X')
      or provincia_res = 0
      or comune_res = 0
      or cap_res = 0
      or provincia_dom = 0
      or comune_dom = 0
      or cap_dom = 0
       )
/

alter table anagrafici enable all triggers;
start crf_GP4GM.sql