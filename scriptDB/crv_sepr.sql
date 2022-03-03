CREATE OR REPLACE VIEW selezione_previdenziale
AS 
select 1 posizione ,defs.ci ci, defs.anno
  from denuncia_fiscale defs
 where  defs.rilevanza  = 'T'
 union all
select 2,deo1.ci, anno
  from denuncia_O1_inps deo1
union all
select 3, dedp.ci, dedp.anno
  from denuncia_inpdap dedp
union all
select 4, ddma.ci, ddma.anno
  from denuncia_dma ddma
union all
select 5, deie.ci, deie.anno
  from denuncia_emens deie
union all
select 6, asfi.ci, asfi.anno
  from archivio_assistenza_fiscale asfi
union all
select 7, dein.ci, dein.anno
  from denuncia_inail dein
;