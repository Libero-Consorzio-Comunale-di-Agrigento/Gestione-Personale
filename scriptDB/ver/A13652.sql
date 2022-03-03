update denuncia_dma
   set riferimento  = to_char(dal,'yyyy')
 where anno         = 2005 
   and rilevanza    = 'V1' 
   and riferimento is null
;

start crp_peccadma.sql