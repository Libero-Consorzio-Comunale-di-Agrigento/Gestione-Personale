CREATE OR REPLACE PACKAGE GP4EB IS
/******************************************************************************
 NOME:        GP4EB
 DESCRIZIONE: Package con funzionalita per presenze/assenze
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    21/06/2007  GM    Prima emissione.
******************************************************************************/
  FUNCTION VERSIONE RETURN VARCHAR2;
  PROCEDURE GET_NUMERO_BADGE 
  (
     P_CI                IN NUMBER
    ,P_DATA              IN DATE
    ,P_NUMERO_BADGE      OUT NUMBER
    ,P_PROGRESSIVO_BADGE OUT NUMBER
    ,P_ERRORE            OUT VARCHAR2
    ,P_SEGNALAZIONE      OUT VARCHAR2
  );
  PROCEDURE VALIDA_NUMERO_BADGE 
  (
     P_DATA              IN DATE  
    ,P_NUMERO_BADGE      IN NUMBER
    ,P_ERRORE            OUT VARCHAR2
    ,P_SEGNALAZIONE      OUT VARCHAR2
  );
  PROCEDURE VALIDA_PERIODI_BADGE 
  (
     P_CI                IN NUMBER
    ,P_DAL               IN DATE
    ,P_AL                IN DATE  
    ,P_NUMERO_BADGE      IN NUMBER
    ,P_ROWID             IN VARCHAR
    ,P_ERRORE            OUT VARCHAR2
    ,P_SEGNALAZIONE      OUT VARCHAR2
  );  
  PROCEDURE CONTROLLA_COPERTURA_PERIODI
  (
     P_CI                IN NUMBER
    ,P_ERRORE            OUT VARCHAR2
    ,P_SEGNALAZIONE      OUT VARCHAR2     
  );
  PROCEDURE INSERT_ASBA
  (
     P_CI                IN NUMBER
    ,P_DAL               IN DATE
    ,P_ERRORE            OUT VARCHAR2
    ,P_SEGNALAZIONE      OUT VARCHAR2     
  ); 
END;
/
CREATE OR REPLACE PACKAGE BODY GP4EB AS
 FUNCTION VERSIONE  RETURN varchar2 IS
 /******************************************************************************
  NOME:        VERSIONE
  DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
  PARAMETRI:   --
  RITORNA:     stringa varchar2 contenente versione e data.
  NOTE:        Il secondo numero della versione corrisponde alla revisione
               del package.
 ******************************************************************************/
 BEGIN
    RETURN 'V1.0 del 21/06/2007';
 END VERSIONE; 
 PROCEDURE GET_NUMERO_BADGE 
 (
     P_CI                IN NUMBER
    ,P_DATA              IN DATE
    ,P_NUMERO_BADGE      OUT NUMBER
    ,P_PROGRESSIVO_BADGE OUT NUMBER
    ,P_ERRORE            OUT VARCHAR2
    ,P_SEGNALAZIONE      OUT VARCHAR2 
 )IS
 /******************************************************************************
    NAME:      GET_NUMERO_BADGE
    PURPOSE:   Restituisce Il Numero Badge ed il Progressivo Badge 
               da Assegnare ad un CI
 ******************************************************************************/    
     d_tipo_numerazione  parametri_badge.tipo_numerazione%type;
     d_max_numero        parametri_badge.max_numero%type;
     d_riutilizzo_numeri parametri_badge.riutilizzo_numeri%type;
     d_numero_badge      assegnazioni_badge.numero_badge%type;
     d_progressivo_badge assegnazioni_badge.progressivo_badge%type;
     ERRORE              exception;
 BEGIN
   P_ERRORE := null;   
   /* Estraggo Parametri Badge */
   BEGIN
     select tipo_numerazione
           ,max_numero
           ,riutilizzo_numeri
       into d_tipo_numerazione
           ,d_max_numero    
           ,d_riutilizzo_numeri
       from parametri_badge
     ;
   EXCEPTION
     when NO_DATA_FOUND then
       d_tipo_numerazione  := 'PR';
       d_max_numero        := to_number(null);
       d_riutilizzo_numeri := 'NO';     
   END;
   /* determino Numerazione */
   BEGIN
     IF d_tipo_numerazione = 'PR' THEN
       select nvl(max(numero_badge),0)+1
         into d_numero_badge
         from assegnazioni_badge
       ;
       d_progressivo_badge := 0;
       /* Controllo se posso riutilizzare un numero di Badge */
       IF d_numero_badge > nvl(d_max_numero,0) AND nvl(d_max_numero,0) <> 0 THEN
         IF d_riutilizzo_numeri = 'NO' THEN
           P_ERRORE       := 'P00703';
           P_SEGNALAZIONE := ': raggiunto valore massimo consentito';   
           raise ERRORE;                              
         ELSE
           -- Riprendo un numero di Badge non più utilizzato
           BEGIN
             select min(numero_badge)
               into d_numero_badge
               from assegnazioni_badge asba
              where stato = 'C'
                and nvl(al,to_date('3333333','j')) < nvl(P_DATA,to_date('2222222','j'))
                and not exists (select 'x' 
                                  from assegnazioni_badge
                                 where nvl(al,to_date('3333333','j')) >= nvl(P_DATA,to_date('2222222','j'))
                                   and numero_badge = asba.numero_badge
                               )
             ;
             IF nvl(d_numero_badge,0) = 0 THEN
               P_ERRORE       := 'P00703';
               P_SEGNALAZIONE := ': non esistono numeri da riutilizzaere';
               raise ERRORE;
             END IF;
           END;
         END IF;
       END IF;  
     ELSIF d_tipo_numerazione = 'MT' THEN
       d_numero_badge := P_CI;  
       select nvl(max(progressivo_badge),0)+1
         into d_progressivo_badge
         from assegnazioni_badge
        where ci = P_CI
       ;
     ELSE
       /* Funzioni Personalizzate DA DEFINIRE */
       null;  
     END IF;
     P_NUMERO_BADGE := d_numero_badge; 
     P_PROGRESSIVO_BADGE := d_progressivo_badge;     
   EXCEPTION
     when ERRORE then
       null;  
   END;
 END GET_NUMERO_BADGE;
 --
 PROCEDURE VALIDA_NUMERO_BADGE
 (
     P_DATA              IN DATE
    ,P_NUMERO_BADGE      IN NUMBER
    ,P_ERRORE            OUT VARCHAR2
    ,P_SEGNALAZIONE      OUT VARCHAR2
 ) IS
 /******************************************************************************
    NAME:      VALIDA_NUMERO_BADGE
    PURPOSE:   Valida Il Numero Badge
 ******************************************************************************/    
     d_tipo_numerazione  parametri_badge.tipo_numerazione%type;
     d_max_numero        parametri_badge.max_numero%type;
     d_riutilizzo_numeri parametri_badge.riutilizzo_numeri%type;     
     d_temp varchar2(1);
     d_dal  assegnazioni_badge.dal%type; 
     d_numero_badge assegnazioni_badge.numero_badge%type;
     d_ci assegnazioni_badge.ci%type;
     errore exception;            
 BEGIN
   P_ERRORE := null;
   /* Estraggo Parametri Badge */
   BEGIN
     select tipo_numerazione
           ,max_numero
           ,riutilizzo_numeri
       into d_tipo_numerazione
           ,d_max_numero    
           ,d_riutilizzo_numeri
       from parametri_badge
     ;
   EXCEPTION
     when NO_DATA_FOUND then
       d_tipo_numerazione  := 'PR';
       d_max_numero        := to_number(null);
       d_riutilizzo_numeri := 'NO';     
   END;    
   BEGIN
     /* Controllo se il numero di Badge supera il limite massimo di numerazione previstro */
     BEGIN
       IF nvl(d_max_numero,0) <> 0 AND P_NUMERO_BADGE > d_max_numero THEN
         P_ERRORE       := 'P00702';
         P_SEGNALAZIONE := ' (' || to_char(d_max_numero) || ')';
         raise ERRORE;     
       END IF;     
     END; 
     /* Controllo se il numero di Badge è stato in precedenza ELIMINATO */  
     BEGIN
       select dal 
         into d_dal
         from assegnazioni_badge
        where numero_badge = P_NUMERO_BADGE
          and stato = 'E'
       ;
       RAISE TOO_MANY_ROWS;       
     EXCEPTION
       when NO_DATA_FOUND then
         null;
       when TOO_MANY_ROWS then
         -- Errore
         P_ERRORE       := 'P00701';
         P_SEGNALAZIONE := ': eliminato dal ' || to_char(d_dal,'DD/MM/YYYY');
         raise ERRORE;          
     END;
     /* Controllo se il numero di Badge è già UTILIZZATO */
     BEGIN
       select dal
            , ci 
         into d_dal
            , d_ci    
         from assegnazioni_badge
        where numero_badge = P_NUMERO_BADGE
          and stato in ('A','S')
          and nvl(al,to_date('3333333','j')) >= P_DATA
       ;
       RAISE TOO_MANY_ROWS;        
     EXCEPTION
       when NO_DATA_FOUND then
         null;
       when TOO_MANY_ROWS then
         -- Errore
         P_ERRORE       := 'P00700';
         P_SEGNALAZIONE := ' per matricola ' || to_char(d_ci) || ' dal ' || to_char(d_dal,'DD/MM/YYYY');
         raise ERRORE;        
     END;
   EXCEPTION
     when ERRORE then
       null;
   END;    
 END VALIDA_NUMERO_BADGE; 
 --
 PROCEDURE VALIDA_PERIODI_BADGE 
 (
    P_CI                IN NUMBER
   ,P_DAL               IN DATE
   ,P_AL                IN DATE  
   ,P_NUMERO_BADGE      IN NUMBER
   ,P_ROWID             IN VARCHAR
   ,P_ERRORE            OUT VARCHAR2
   ,P_SEGNALAZIONE      OUT VARCHAR2
 ) IS
 /******************************************************************************
    NAME:      VALIDA_PERIODI_BADGE
    PURPOSE:   Valida i periodi inseriti ina Assegnazioni Badge
 ******************************************************************************/    
 d_min                 DATE;
 d_max                 DATE; 
 d_dal                 VARCHAR2(10);
 d_al                  VARCHAR2(10);
 d_ci assegnazioni_badge.ci%type; 
 d_giorni_lavoro       NUMBER;
 d_giorni_assegnazione NUMBER;
 errore exception;
 BEGIN
   BEGIN
     /* Controllo che non esistano periodi sovrapposti con lo stesso numero di BADGE */
     BEGIN
       select  to_char(ASBA.DAL,'dd/mm/yyyy')
              ,to_char(ASBA.AL,'dd/mm/yyyy')
         into  d_dal
              ,d_al
         from  assegnazioni_badge ASBA
        where  asba.numero_badge  = P_NUMERO_BADGE
          and  nvl(ASBA.DAL,to_date('2222222','j'))
                             <=
               nvl(P_AL    ,to_date('3333333','j'))
          and  nvl(ASBA.AL ,to_date('3333333','j'))
                             >=
               nvl(P_DAL   ,to_date('2222222','j'))
          and  rowid != nvl(P_ROWID,0)
       ;
       P_ERRORE := 'P00855';
       P_SEGNALAZIONE := d_dal||' - '||d_al;
       /* Esiste periodo con validita` ... - ... */
       raise ERRORE;
     EXCEPTION
       when NO_DATA_FOUND then 
         null;
       when TOO_MANY_ROWS then
            d_dal := to_char(P_dal,'dd/mm/yyyy');
            d_al  := to_char(P_al ,'dd/mm/yyyy');
            P_ERRORE := 'P00856';
            P_SEGNALAZIONE := d_dal||' - '||d_al;            
            /* Esistono altre registrazioni nel periodo ... - ... */
            raise ERRORE;
     END;
     /* Verifico che per lo stesso CI non esistano periodi sovrapposti, a meno che uno dei due non sia in stato ELIMINATO */
     BEGIN
       select  to_char(ci)
              ,to_char(ASBA.DAL,'dd/mm/yyyy')
              ,to_char(ASBA.AL,'dd/mm/yyyy')
         into  d_ci
              ,d_dal
              ,d_al        
         from  assegnazioni_badge ASBA
        where  asba.ci        = P_CI
          and  asba.stato    != 'E'
          and  nvl(ASBA.DAL,to_date('2222222','j'))
                             <=
               nvl(P_AL    ,to_date('3333333','j'))
          and  nvl(ASBA.AL ,to_date('3333333','j'))
                             >=
               nvl(P_DAL   ,to_date('2222222','j'))
          and  rowid != nvl(P_ROWID,0)
       ;
       P_ERRORE := 'P00855';
       P_SEGNALAZIONE := d_dal||' - '||d_al||' per la matricola '||d_ci;
       /* Esiste periodo con validita` ... - ... */
       raise ERRORE;         
     EXCEPTION
       when NO_DATA_FOUND then
         null;
       when TOO_MANY_ROWS then
         raise ERRORE;
     END;   
     /* Verifica che i periodi di Assegnazione Badge siano contenuti all'interno dei suoi periodi di rapporto di lavoro */     
     IF P_CI <= 99990000 then 
       BEGIN
         select  nvl(PEGI.DAL,to_date('2222222','j'))
                ,nvl(PEGI.AL ,to_date('3333333','j'))
         into    d_min,d_max
         from    PERIODI_GIURIDICI PEGI
         where   PEGI.CI        = P_CI
         and     PEGI.RILEVANZA = 'P'
         and     PEGI.DAL      <= nvl(P_AL,to_date('3333333','j'))
         and     nvl(PEGI.AL,to_date('3333333','j'))
                               >= P_DAL
         ;
       EXCEPTION
         when TOO_MANY_ROWS then
           null;
         when NO_DATA_FOUND then
           P_ERRORE := 'P04220';
           P_SEGNALAZIONE := ' '; 
           raise ERRORE;
         when OTHERS THEN
              P_ERRORE := SQLERRM;
              raise ERRORE;
       END;
     END IF;
   EXCEPTION
     when ERRORE then
       null;  
   END;
 END VALIDA_PERIODI_BADGE; 
 --
 PROCEDURE CONTROLLA_COPERTURA_PERIODI 
 (  
     P_CI                IN NUMBER
    ,P_ERRORE            OUT VARCHAR2
    ,P_SEGNALAZIONE      OUT VARCHAR2     
 ) IS
 /******************************************************************************
    NAME:      CONTROLLA COPERTURA PERIODI
    PURPOSE:   Controlla  che tra i periodi di ASSEGNAZIONE_BADGE ed il periodo
               di rapporto di lavoro esista una esatta corrispondenza in termini
               di copertura 
 ******************************************************************************/    
   d_giorni_badge  number;
   d_giorni_lavoro number;
   d_min_dal       date;
   d_max_al        date;
 BEGIN
   FOR CUR_PEGI IN 
     (select ci 
            ,dal
            ,al
        from periodi_giuridici        
       where ci = P_CI
         and rilevanza = 'P'
     ) LOOP
     BEGIN
       /* calcolo giorni lavoro */
       BEGIN
         select nvl(CUR_PEGI.al,to_date('3333333','j')) - CUR_PEGI.dal + 1
           into d_giorni_lavoro
           from dual
         ;
       END;
       /* Controllo i Periodi di Assegnazioni BADGE che intersecato il periodi di lavoro */
       BEGIN
         select min(dal)
               ,max(nvl(al,to_date('3333333','j')))
               ,sum(nvl(al,to_date('3333333','j'))-dal+1)
           into d_min_dal
               ,d_max_al
               ,d_giorni_badge
           from assegnazioni_badge asba
          where asba.ci = CUR_PEGI.ci
            and nvl(CUR_PEGI.al, to_date(3333333, 'j')) >= asba.dal
            and CUR_PEGI.dal <= nvl(asba.al, to_date(3333333, 'j'))  
          ;
          IF d_min_dal > CUR_PEGI.dal OR d_max_al < nvl(CUR_PEGI.al,to_date('3333333','j')) then
            P_ERRORE := 'P00705';           
            P_SEGNALAZIONE := ': ' || to_char(CUR_PEGI.dal,'dd/mm/yyyy') || ' - ' || to_char(CUR_PEGI.al,'dd/mm/yyyy');   
          ELSIF d_min_dal < CUR_PEGI.dal OR d_max_al > nvl(CUR_PEGI.al,to_date('3333333','j')) then
            P_ERRORE := 'P00704';           
            P_SEGNALAZIONE := ': ' || to_char(CUR_PEGI.dal,'dd/mm/yyyy') || ' - ' || to_char(CUR_PEGI.al,'dd/mm/yyyy');
          ELSIF d_giorni_lavoro < d_giorni_badge then
            P_ERRORE := 'P00704';           
            P_SEGNALAZIONE := ': ' || to_char(CUR_PEGI.dal,'dd/mm/yyyy') || ' - ' || to_char(CUR_PEGI.al,'dd/mm/yyyy');
          ELSIF d_giorni_lavoro > d_giorni_badge then
            P_ERRORE := 'P00705';           
            P_SEGNALAZIONE := ': ' || to_char(CUR_PEGI.dal,'dd/mm/yyyy') || ' - ' || to_char(CUR_PEGI.al,'dd/mm/yyyy');            
          END IF;
       END;
     END; 
   END LOOP;                    
 END CONTROLLA_COPERTURA_PERIODI;
 --
 PROCEDURE INSERT_ASBA 
 (  
     P_CI                IN NUMBER
    ,P_DAL               IN DATE
    ,P_ERRORE            OUT VARCHAR2
    ,P_SEGNALAZIONE      OUT VARCHAR2     
 ) IS 
 /******************************************************************************
    NAME:      INSERT_ASBA
    PURPOSE:   Inserisce in ASSEGAZIONI_BADGE un recordo
 ******************************************************************************/
   	d_errore varchar2(8);
	d_segnalazione varchar2(256);
    d_numero_badge      assegnazioni_badge.numero_badge%type;
    d_progressivo_badge assegnazioni_badge.progressivo_badge%type;     
 BEGIN
   gp4eb.GET_NUMERO_BADGE(P_ci,P_dal,d_numero_badge,d_progressivo_badge,d_errore,d_segnalazione);
   IF d_errore is null THEN
     insert 
       into assegnazioni_badge(ASBA_ID
                              ,ci
                              ,numero_badge
                              ,progressivo_badge
                              ,dal
                              ,causale_attribuzione
                              ,stato
                              ,utente
                              ,data_agg
                              )
                              (select ASBA_SQ.NEXTVAL
                                     ,P_ci
                                     ,d_numero_badge
                                     ,d_progressivo_badge
                                     ,P_dal
                                     ,'ASU'
                                     ,'A'
                                     ,'Aut.PEGI'
                                     ,sysdate
                                 from dual
                              ) 
     ;
   ELSE
     P_errore := d_errore;
     P_segnalazione := d_segnalazione;
   END IF;
 END INSERT_ASBA;
END GP4EB;
/
