create or replace view
valori_evento     as
select evpa.ci
      ,clpa.classe       classe
      ,clpa.dal          inizio
      ,clpa.riferimento  rife_classe
      ,evpa.evento
      ,evpa.causale
      ,evpa.dal
      ,evpa.al
      ,evpa.riferimento  rife_causale
      ,evpa.valore       giorni
      ,vapa.voce
      ,vapa.sub
      ,vapa.operazione
      ,vapa.tar
      ,vapa.qta
      ,vapa.imp
      ,evpa.data_agg     data_evpa
      ,vapa.data_agg     data_vapa
  from eventi_presenza evpa
      ,classi_presenza clpa
      ,valori_presenza vapa
 where evpa.evento     = vapa.evento
   and evpa.input      = 'V'
   and causale        <> 'XXXXXXXX'
   and clpa.ci         = evpa.ci
   and clpa.evento     = evpa.classe
 union
select evpa.ci
      ,to_char(null)     classe
      ,to_date(null)     inizio
      ,to_date(null)     rife_classe
      ,evpa.evento
      ,evpa.causale
      ,evpa.dal
      ,evpa.al
      ,evpa.riferimento  rife_causale
      ,evpa.valore       giorni
      ,vapa.voce
      ,vapa.sub
      ,vapa.operazione
      ,vapa.tar
      ,vapa.qta
      ,vapa.imp
      ,evpa.data_agg     data_evpa
      ,vapa.data_agg     data_vapa
  from eventi_presenza evpa
      ,valori_presenza vapa
 where evpa.evento     = vapa.evento
   and evpa.input      = 'V'
   and causale         = 'XXXXXXXX'
/
