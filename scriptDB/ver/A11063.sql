update denuncia_dma ddma
set tipo_servizio = ltrim(tipo_servizio)
where substr(tipo_servizio,1,1) = ' ';