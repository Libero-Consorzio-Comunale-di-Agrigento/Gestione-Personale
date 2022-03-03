create or replace view stampa_utente_cafa2007 as
select rain.ci ci
           , rain.cognome||'  '||rain.nome nominativo
           , cafa.mese
           , cafa.figli
           , cafa.figli_dd
           , cafa.altri
           , cafa.figli_mn
           , cafa.figli_mn_dd
           , cafa.figli_hh
           , cafa.figli_hh_dd
        from carichi_familiari cafa
           , rapporti_individuali rain
       where rain.ci   = cafa.ci
         and cafa.anno = 2007
         and (   nvl(cafa.figli,0)       > 2
              or nvl(cafa.figli_dd,0)    > 2
              or nvl(cafa.altri,0)       > 2
              or nvl(cafa.figli_mn,0)    > 2
              or nvl(cafa.figli_mn_dd,0) > 2
              or nvl(cafa.figli_hh,0)    > 2
              or nvl(cafa.figli_hh_dd,0) > 2)
union
select rain.ci ci
           , rain.cognome||'  '||rain.nome nominativo
           , cafa.mese
           , cafa.figli
           , cafa.figli_dd
           , cafa.altri
           , cafa.figli_mn
           , cafa.figli_mn_dd
           , cafa.figli_hh
           , cafa.figli_hh_dd
        from carichi_familiari cafa
           , rapporti_individuali rain
       where rain.ci   = cafa.ci
         and cafa.anno = 2007
         and (   nvl(cafa.figli,0)       < 0
              or nvl(cafa.figli_dd,0)    < 0
              or nvl(cafa.altri,0)       < 0
              or nvl(cafa.figli_mn,0)    < 0
              or nvl(cafa.figli_mn_dd,0) < 0
              or nvl(cafa.figli_hh,0)    < 0
              or nvl(cafa.figli_hh_dd,0) < 0)
/
