CREATE TABLE periodi_blocco(
 ci                              NUMBER(8,0)      NOT NULL,
 dal                             DATE             NOT NULL,
 al                              DATE             NULL,
 evento                          VARCHAR(6)       NOT NULL,
 assenza                         VARCHAR(4)       NULL,
 utente                          VARCHAR(8)       NULL,
 data_agg                        DATE             NULL
);

CREATE UNIQUE INDEX PEBL_PK ON PERIODI_BLOCCO
(      ci ,
      dal );

