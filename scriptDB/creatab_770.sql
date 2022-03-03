DECLARE 

V_controllo   varchar2(1);
V_comando     varchar2(2000);
BEGIN 
  BEGIN
<<CREA_TAB>>
/* creazione tabella TAB_REPORT_FINE_ANNO se non esiste  */
   BEGIN
   select 'Y'
     into V_controllo
     from obj
    where object_name = 'TAB_REPORT_FINE_ANNO'
     ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN V_controllo := 'X';
   END;
   IF V_controllo= 'Y' THEN  NULL;
   ELSE
      V_comando := 'CREATE TABLE TAB_REPORT_FINE_ANNO(
                   CI       NUMBER(8) NOT NULL,
                   ANNO     NUMBER(4) NOT NULL,
                   S1       VARCHAR2(15),
                   C1       VARCHAR2(15),
                   D1       VARCHAR2(60),
                   S2       VARCHAR2(15),
                   C2       VARCHAR2(15),
                   D2       VARCHAR2(60),
                   S3       VARCHAR2(15),
                   C3       VARCHAR2(15),
                   D3       VARCHAR2(60),
                   S4       VARCHAR2(15),
                   C4       VARCHAR2(15),
                   D4       VARCHAR2(60),
                   S5       VARCHAR2(100),
                   C5       VARCHAR2(100),
                   D5       VARCHAR2(100),
                   S6       VARCHAR2(100),
                   C6       VARCHAR2(100),
                   D6       VARCHAR2(100))';
         si4.sql_execute(V_comando);
   END IF;
END CREA_TAB;
BEGIN
<<CREA_IDX>>
/* creazione indice TRPFA_IK se non esiste  */
   BEGIN
   select 'Y'
     into V_controllo
     from obj
    where object_name = 'TRPFA_IK';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN V_controllo := 'X';
   END;
   IF V_controllo= 'Y' THEN  NULL;
   ELSE
       si4.sql_execute ('create index trpfa_ik on tab_report_fine_anno (ci)');
   END IF;
END CREA_IDX;
END;
/