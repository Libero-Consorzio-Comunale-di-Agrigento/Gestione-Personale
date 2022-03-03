CREATE TABLE calcolo_o1md
                       (CI                         NUMBER  (8)     NOT NULL ,
                        DEL                        NUMBER  (8)     NOT NULL ,
                        DAL                        NUMBER  (8)     NOT NULL ,
                        INPUT                   VARCHAR    (1)     NOT NULL ,
                        CAUSALE                 VARCHAR    (4)     NOT NULL ,
                        VOCE                    VARCHAR    (10)    NOT NULL ,
                        QTA                        NUMBER  (8,4)   ,
                        TAR                        NUMBER  (12,2)  ,
                        IMP                        NUMBER  (10)    ,
                        DATA_AGG                   NUMBER  (8)     ,
                        INIZIO                     NUMBER  (8)     ,
                        FINE                       NUMBER  (8)     )

/
COMMENT ON TABLE calcolo_o1md IS ' Valorizzazioni degli eventi con causale a val '
/
CREATE INDEX o1md_ik1 ON calcolo_o1md (     CI ,
                                            DAL ,
                                            CAUSALE )
/
CREATE INDEX o1md_ik2 ON calcolo_o1md (     INPUT )
/
