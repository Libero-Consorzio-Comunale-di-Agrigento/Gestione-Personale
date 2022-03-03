update denuncia_dma set fine_servizio = 0
where  fine_servizio is null;

ALTER TABLE DENUNCIA_DMA
MODIFY(FINE_SERVIZIO  NOT NULL);