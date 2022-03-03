PROMPT Creating procedure DEFI_INS
CREATE OR REPLACE PROCEDURE DEFI_INS
( V_ini_anno   IN DATE ) IS
/******************************************************************************
 NOME:         DEFI_INS
 DESCRIZIONE:  Duplica la tabella DETRAZIONI_FISCALI a cambio d'anno inserendo il 
               nuovo record

 ANNOTAZIONI:  E' richiamata dalla procedure VAFI_INS

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/01/2006 MS     Mod. per clienti con dizionari condivisi ( att. 14314 )
 1.2  27/01/2006 MS     Mod. errore Oracle ( att. 14370.1 )
 1.3  26/03/2007 ML     Gestione campo aumento (A20236)
******************************************************************************/
V_esiste varchar2(1) := '';
V_TYPE   VARCHAR2(13) := '';
V_comando VARCHAR2(2000) := '';
BEGIN
   BEGIN
     select 'S'
       into V_esiste
       from dual
      where ( exists ( select 'x'
                       from detrazioni_fiscali
                      where dal = V_ini_anno 
                    )
           or exists ( select 'x'
                        from detrazioni_fiscali
                       where V_ini_anno between nvl(dal,to_date('2222222','j')) and nvl(al,to_date('3333333','j'))
                         and nvl(al,V_ini_anno-1) >= V_ini_anno
                     )
             );
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_esiste := 'N';
   END;
   BEGIN
   select object_type 
     into V_type
     from obj 
    where object_name = 'DETRAZIONI_FISCALI';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_type := '';
   END;
   IF V_esiste = 'N' and V_type = 'TABLE' THEN
     BEGIN
      V_comando := 
       'insert into detrazioni_fiscali
       ( CODICE, DAL, AL, SCAGLIONE, TIPO, NUMERO, IMPORTO, IMPONIBILE, AUMENTO )
       select codice, '''||V_ini_anno||''', null, SCAGLIONE, TIPO, NUMERO, IMPORTO, IMPONIBILE, AUMENTO
         from detrazioni_fiscali
        where dal = (select max(dal)
                       from validita_fiscale
                      where dal < '''||V_ini_anno||'''
                     )'
        ;
      si4.sql_execute(V_comando);
     END;
   END IF;
END DEFI_INS;
/
PROMPT Creating procedure SCFI_INS
CREATE OR REPLACE PROCEDURE SCFI_INS
( V_ini_anno   IN DATE ) IS
/******************************************************************************
 NOME:         SCFI_INS
 DESCRIZIONE:  Duplica la tabella SCAGLIONI_FISCALI a cambio d'anno inserendo il 
               nuovo record

 ANNOTAZIONI:  E' richiamata dalla procedure VAFI_INS

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/01/2006 MS     Mod. per clienti con dizionari condivisi ( att. 14314 )
 1.2  27/01/2006 MS     Mod. errore Oracle ( att. 14370.1 )
******************************************************************************/
V_esiste varchar2(1) := '';
V_TYPE   VARCHAR2(13) := '';
V_comando VARCHAR2(2000) := '';
BEGIN
   BEGIN
     select 'S'
       into V_esiste
       from dual
      where ( exists ( select 'x'
                       from scaglioni_fiscali
                      where dal = V_ini_anno 
                     )
           or exists ( select 'x'
                        from scaglioni_fiscali
                       where V_ini_anno between nvl(dal,to_date('2222222','j')) and nvl(al,to_date('3333333','j'))
                         and nvl(al,V_ini_anno-1) >= V_ini_anno
                     )
             );
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_esiste := 'N';
   END;
   BEGIN
   select object_type 
     into V_type
     from obj 
    where object_name = 'SCAGLIONI_FISCALI';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_type := '';
   END;
   IF V_esiste = 'N' and V_type = 'TABLE' THEN
     BEGIN
      V_comando := 
       'insert into  scaglioni_fiscali
       ( DAL, AL, SCAGLIONE, ALIQUOTA, IMPOSTA )
       select '''||V_ini_anno||''', null, SCAGLIONE, ALIQUOTA, IMPOSTA
         from scaglioni_fiscali
        where dal = (select max(dal)
                       from validita_fiscale
                      where dal < '''||V_ini_anno||'''
                     )'
        ;
      si4.sql_execute(V_comando);
     END;
   END IF;
END SCFI_INS;
/
PROMPT Creating procedure SCDF_INS
CREATE OR REPLACE PROCEDURE SCDF_INS 
( V_ini_anno   IN DATE ) IS
/******************************************************************************
 NOME:         SCDF_INS
 DESCRIZIONE:  Duplica la tabella SCAGLIONI_DETRAZIONE_FISCALE a cambio d'anno inserendo il 
               nuovo record

 ANNOTAZIONI:  E' richiamata dalla procedure VAFI_INS

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/01/2006 MS     Mod. per clienti con dizionari condivisi ( att. 14314 )
 1.2  27/01/2006 MS     Mod. errore Oracle ( att. 14370.1 )
******************************************************************************/
V_esiste varchar2(1) := '';
V_TYPE   VARCHAR2(13) := '';
V_comando VARCHAR2(2000) := '';
BEGIN
   BEGIN
     select 'S'
       into V_esiste
       from dual
      where ( exists ( select 'x'
                       from scaglioni_detrazione_fiscale
                      where dal = V_ini_anno 
                     )
           or exists ( select 'x'
                        from scaglioni_detrazione_fiscale
                       where V_ini_anno between nvl(dal,to_date('2222222','j')) and nvl(al,to_date('3333333','j'))
                         and nvl(al,V_ini_anno-1) >= V_ini_anno
                     )
             );
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_esiste := 'N';
   END;
   BEGIN
   select object_type 
     into V_type
     from obj 
    where object_name = 'SCAGLIONI_DETRAZIONE_FISCALE';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_type := '';
   END;
   IF V_esiste = 'N' and V_type = 'TABLE' THEN
     BEGIN
      V_comando := 
       'insert into scaglioni_detrazione_fiscale
       ( DAL, AL, SCAGLIONE, DETRAZIONE, IMPOSTA, TIPO )
       select '''||V_ini_anno||''', null, SCAGLIONE, DETRAZIONE, IMPOSTA, TIPO
         from scaglioni_detrazione_fiscale
        where dal = (select max(dal)
                       from validita_fiscale
                      where dal < '''||V_ini_anno||'''
                     )'
        ;
      si4.sql_execute(V_comando);
     END;
   END IF;
END SCDF_INS;
/
PROMPT Creating procedure ADIR_INS
CREATE OR REPLACE PROCEDURE ADIR_INS 
( V_ini_anno   IN DATE ) IS
/******************************************************************************
 NOME:         ADIR_INS
 DESCRIZIONE:  Duplica la tabella ADDIZIONALE_IRPEF_REGIONALE a cambio d'anno inserendo il 
               nuovo record

 ANNOTAZIONI:  E' richiamata dalla procedure VAFI_INS

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/01/2006 MS     Mod. per clienti con dizionari condivisi ( att. 14314 )
 1.2  27/01/2006 MS     Mod. errore Oracle ( att. 14370.1 )
 1.3  02/01/2007 MS     gestione campo "regione" ( att. 19056 )
******************************************************************************/
V_esiste varchar2(1) := '';
V_TYPE   VARCHAR2(13) := '';
V_comando VARCHAR2(2000) := '';
BEGIN
   BEGIN
     select 'S'
       into V_esiste
       from dual
      where ( exists ( select 'x'
                       from addizionale_irpef_regionale
                      where dal = V_ini_anno 
                     )
           or exists ( select 'x'
                        from addizionale_irpef_regionale
                       where V_ini_anno between nvl(dal,to_date('2222222','j')) and nvl(al,to_date('3333333','j'))
                         and nvl(al,V_ini_anno-1) >= V_ini_anno
                     )
             );
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_esiste := 'N';
   END;
   BEGIN
   select object_type 
     into V_type
     from obj 
    where object_name = 'ADDIZIONALE_IRPEF_REGIONALE';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_type := '';
   END;
   IF V_esiste = 'N' and V_type = 'TABLE' THEN
     BEGIN
      V_comando := 
       'insert into addizionale_irpef_regionale
       ( COD_REGIONE, DAL, AL, ALIQUOTA, aliquota_cond1, aliquota_cond2, scaglione, imposta, regione )
       select COD_REGIONE, '''||V_ini_anno||''', null, ALIQUOTA, aliquota_cond1, aliquota_cond2, scaglione, imposta, regione
         from addizionale_irpef_regionale
        where dal = (select max(dal)
                       from validita_fiscale
                      where dal < '''||V_ini_anno||'''
                     )'
        ;
      si4.sql_execute(V_comando);
     END;
   END IF;
END ADIR_INS;
/
PROMPT Creating procedure ADIC_INS
CREATE OR REPLACE PROCEDURE ADIC_INS 
( V_ini_anno   IN DATE ) IS
/******************************************************************************
 NOME:         ADIC_INS
 DESCRIZIONE:  Duplica la tabella ADDIZIONALE_IRPEF_COMUNALE a cambio d'anno inserendo il 
               nuovo record

 ANNOTAZIONI:  E' richiamata dalla procedure VAFI_INS

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/01/2006 MS     Mod. per clienti con dizionari condivisi ( att. 14314 )
 1.2  27/01/2006 MS     Mod. errore Oracle ( att. 14370.1 )
******************************************************************************/
V_esiste varchar2(1) := '';
V_TYPE   VARCHAR2(13) := '';
V_comando VARCHAR2(2000) := '';
BEGIN
   BEGIN
     select 'S'
       into V_esiste
       from dual
      where ( exists ( select 'x'
                       from addizionale_irpef_comunale
                      where dal = V_ini_anno 
                     )
           or exists ( select 'x'
                        from addizionale_irpef_comunale
                       where V_ini_anno between nvl(dal,to_date('2222222','j')) and nvl(al,to_date('3333333','j'))
                         and nvl(al,V_ini_anno-1) >= V_ini_anno
                     )
             );
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_esiste := 'N';
   END;
   BEGIN
   select object_type 
     into V_type
     from obj 
    where object_name = 'ADDIZIONALE_IRPEF_COMUNALE';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_type := '';
   END;
   IF V_esiste = 'N' and V_type = 'TABLE' THEN
     BEGIN
      V_comando :=
       'insert into addizionale_irpef_comunale
       ( COD_PROVINCIA, COD_COMUNE, DAL, AL, ALIQUOTA, esenzione, scaglione, imposta )
       select COD_PROVINCIA, COD_COMUNE, '''||V_ini_anno||''', null, ALIQUOTA, esenzione, scaglione, imposta
         from addizionale_irpef_comunale
        where dal = (select max(dal)
                       from validita_fiscale
                      where dal < '''||V_ini_anno||'''
                     )'
        ;
      si4.sql_execute(V_comando);
     END;
   END IF;
END ADIC_INS;
/
PROMPT Creating procedure VAFI_INS
CREATE OR REPLACE PROCEDURE VAFI_INS
( P_anno   IN NUMBER ) IS
/******************************************************************************
 NOME:         VAFI_INS
 DESCRIZIONE:  Duplica le tabelle fiscali a cambio d'anno inserendo il 
               nuovo record

 ANNOTAZIONI:  Richiama le procedure  
               DEFI_INS - Inserimento DETRAZIONI_FISCALI
               SCFI_INS - Inserimento SCAGLIONI_FISCALI
               SCDF_INS - Inserimento SCAGLIONI_DETRAZIONE_FISCALE
               ADIR_INS - Inserimenti ADDIZIONALE_IRPEF_REGIONALE
               ADIC_INS - Inserimenti ADDIZIONALE_IRPEF_COMUNALE

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/01/2006 MS     Mod. per clienti con dizionari condivisi ( att. 14314 )
 1.2  27/01/2006 MS     Mod. errore Oracle ( att. 14370.1 )
 1.3  03/01/2007 MS     Gestione nuovi campi per Finanziaria 2007
******************************************************************************/
V_ini_anno date;
V_esiste varchar2(1) := '';
V_TYPE   VARCHAR2(13) := '';
V_comando VARCHAR2(2000) := '';

BEGIN
   BEGIN
     select to_date('0101'||P_anno,'ddmmyyyy')
       into V_ini_anno
      from dual;
   END;
   BEGIN
     select 'S'
       into V_esiste
       from dual
      where ( exists ( select 'x'
                       from validita_fiscale 
                      where dal = V_ini_anno 
                     )
           or exists ( select 'x'
                        from validita_fiscale 
                       where V_ini_anno between nvl(dal,to_date('2222222','j')) and nvl(al,to_date('3333333','j'))
                         and nvl(al,V_ini_anno-1) >= V_ini_anno
                     )
             );
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_esiste := 'N';
   END;
   BEGIN
   select object_type 
     into V_type
     from obj 
    where object_name = 'VALIDITA_FISCALE';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_type := '';
   END;
   IF V_esiste = 'N' and V_type = 'TABLE' THEN
     BEGIN
      IF P_anno < 2007 THEN
       V_comando := 
       'insert into validita_fiscale 
       ( DAL, AL, NOTE, ALIQUOTA_IRPEF_COMUNALE, ALIQUOTA_IRPEF_REGIONALE, ALIQUOTA_IRPEF_PROVINCIALE     
       , RIDUZIONI_TFR, DETRAZIONI_TFR, VAL_CONV_DED, DED_FIS_BASE, VAL_CONV_DED_FAM 
       , VAL_CONV_DET_FAM, VAL_CONV_DET_AGG_FIG, VAL_CONV_DET_DIP, VAL_CONV_DET_PEN1, VAL_CONV_DET_PEN2
       , VAL_MIN_DET_DIP, VAL_MIN_DET_PEN1, VAL_MIN_DET_PEN2
       )
       select '''||V_ini_anno||''', null, NOTE, ALIQUOTA_IRPEF_COMUNALE, ALIQUOTA_IRPEF_REGIONALE, ALIQUOTA_IRPEF_PROVINCIALE     
            , RIDUZIONI_TFR, DETRAZIONI_TFR, VAL_CONV_DED, DED_FIS_BASE, VAL_CONV_DED_FAM 
            , to_number(null), to_number(null), to_number(null), to_number(null), to_number(null)
            , to_number(null), to_number(null), to_number(null)
         from validita_fiscale 
        where dal = (select max(dal)
                       from validita_fiscale
                      where dal < '''||V_ini_anno||'''
                     )'
        ;
       si4.sql_execute(V_comando);
      ELSIF P_anno = 2007 THEN
       V_comando := 
       'insert into validita_fiscale 
       ( DAL, AL, NOTE, ALIQUOTA_IRPEF_COMUNALE, ALIQUOTA_IRPEF_REGIONALE, ALIQUOTA_IRPEF_PROVINCIALE     
       , RIDUZIONI_TFR, DETRAZIONI_TFR
       , VAL_CONV_DED, DED_FIS_BASE, VAL_CONV_DED_FAM
       , VAL_CONV_DET_FAM, VAL_CONV_DET_AGG_FIG, VAL_CONV_DET_DIP, VAL_CONV_DET_PEN1, VAL_CONV_DET_PEN2
       , VAL_MIN_DET_DIP, VAL_MIN_DET_PEN1, VAL_MIN_DET_PEN2
       )
       select '''||V_ini_anno||''', null, NOTE, ALIQUOTA_IRPEF_COMUNALE, ALIQUOTA_IRPEF_REGIONALE, ALIQUOTA_IRPEF_PROVINCIALE     
            , RIDUZIONI_TFR, DETRAZIONI_TFR
            , to_number(null), to_number(null), to_number(null)
            , to_number(null), to_number(null), to_number(null), to_number(null), to_number(null)
            , to_number(null), to_number(null), to_number(null)
         from validita_fiscale 
        where dal = (select max(dal)
                       from validita_fiscale
                      where dal < '''||V_ini_anno||'''
                     )'
        ;
       si4.sql_execute(V_comando);
      ELSE -- P_anno > 2007
       V_comando := 
       'insert into validita_fiscale 
       ( DAL, AL, NOTE, ALIQUOTA_IRPEF_COMUNALE, ALIQUOTA_IRPEF_REGIONALE, ALIQUOTA_IRPEF_PROVINCIALE     
       , RIDUZIONI_TFR, DETRAZIONI_TFR
       , VAL_CONV_DED, DED_FIS_BASE, VAL_CONV_DED_FAM
       , VAL_CONV_DET_FAM, VAL_CONV_DET_AGG_FIG, VAL_CONV_DET_DIP, VAL_CONV_DET_PEN1, VAL_CONV_DET_PEN2
       , VAL_MIN_DET_DIP, VAL_MIN_DET_PEN1, VAL_MIN_DET_PEN2
       )
       select '''||V_ini_anno||''', null, NOTE, ALIQUOTA_IRPEF_COMUNALE, ALIQUOTA_IRPEF_REGIONALE, ALIQUOTA_IRPEF_PROVINCIALE     
            , RIDUZIONI_TFR, DETRAZIONI_TFR
            , to_number(null), to_number(null), to_number(null)
            , VAL_CONV_DET_FAM, VAL_CONV_DET_AGG_FIG, VAL_CONV_DET_DIP, VAL_CONV_DET_PEN1, VAL_CONV_DET_PEN2
            , VAL_MIN_DET_DIP, VAL_MIN_DET_PEN1, VAL_MIN_DET_PEN2
         from validita_fiscale 
        where dal = (select max(dal)
                       from validita_fiscale
                      where dal < '''||V_ini_anno||'''
                     )'
        ;
       si4.sql_execute(V_comando);
      END IF; -- fine controllo su anno
       DEFI_INS(V_ini_anno);
       SCFI_INS(V_ini_anno);
       SCDF_INS(V_ini_anno);
       ADIR_INS(V_ini_anno);
       ADIC_INS(V_ini_anno);
     END;
   END IF;
END VAFI_INS;
/
PROMPT Creating procedure DEFI_UPD
CREATE OR REPLACE PROCEDURE DEFI_UPD
( V_ini_anno   IN DATE , V_fin_anno_ap IN DATE) IS
/******************************************************************************
 NOME:         DEFI_UPD
 DESCRIZIONE:  Esegue la chiusura dei record di DETRAZIONI_FISCALI al 31/12/AP

 ANNOTAZIONI:  E' richiamata dalla procedure VAFI_UPD

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/01/2006 MS     Mod. per clienti con dizionari condivisi ( att. 14314 )
 1.2  27/01/2006 MS     Mod. errore Oracle ( att. 14370.1 )
******************************************************************************/
V_esiste varchar2(1) := '';
V_TYPE   VARCHAR2(13) := '';
V_comando VARCHAR2(2000) := '';
BEGIN
   BEGIN
     select 'S'
       into V_esiste
       from dual
      where exists ( select 'x'
                       from detrazioni_fiscali
                      where dal < V_ini_anno 
                        and al is null
                   )
        and exists ( select 'x'
                       from detrazioni_fiscali
                      where dal = V_ini_anno 
                    )
      ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_esiste := 'N';
   END;
   BEGIN
   select object_type 
     into V_type
     from obj 
    where object_name = 'DETRAZIONI_FISCALI';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_type := '';
   END;
   IF V_esiste = 'S' and V_type = 'TABLE' THEN
     BEGIN
      V_comando :=
      'update detrazioni_fiscali
          set al = '''||V_fin_anno_ap||'''
        where dal = (select max(dal)
                       from validita_fiscale
                      where dal < '''||V_ini_anno||'''
                     )
          and al is null';
      si4.sql_execute(V_comando);
     END;
   END IF;
END DEFI_UPD;
/
PROMPT Creating procedure SCFI_UPD
CREATE OR REPLACE PROCEDURE SCFI_UPD
( V_ini_anno   IN DATE, V_fin_anno_ap IN DATE ) IS
/******************************************************************************
 NOME:         DEFI_UPD
 DESCRIZIONE:  Esegue la chiusura dei record di SCAGLIONI_FISCALI al 31/12/AP

 ANNOTAZIONI:  E' richiamata dalla procedure VAFI_UPD

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/01/2006 MS     Mod. per clienti con dizionari condivisi ( att. 14314 )
 1.2  27/01/2006 MS     Mod. errore Oracle ( att. 14370.1 )
******************************************************************************/
V_esiste varchar2(1) := '';
V_TYPE   VARCHAR2(13) := '';
V_comando VARCHAR2(2000) := '';
BEGIN
   BEGIN
     select 'S'
       into V_esiste
       from dual
      where exists ( select 'x'
                       from scaglioni_fiscali
                      where dal < V_ini_anno 
                        and al is null
                   )
        and exists ( select 'x'
                       from scaglioni_fiscali
                      where dal = V_ini_anno 
                    )
      ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_esiste := 'N';
   END;
   BEGIN
   select object_type 
     into V_type
     from obj 
    where object_name = 'SCAGLIONI_FISCALI';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_type := '';
   END;
   IF V_esiste = 'S' and V_type = 'TABLE' THEN
     BEGIN
      V_comando := 
       'update scaglioni_fiscali
          set al = '''||V_fin_anno_ap||'''
        where dal = (select max(dal)
                       from validita_fiscale
                      where dal < '''||V_ini_anno||'''
                     )
          and al is null';
      si4.sql_execute(V_comando);
     END;
   END IF;
END SCFI_UPD;
/
PROMPT Creating procedure SCDF_UPD
CREATE OR REPLACE PROCEDURE SCDF_UPD
( V_ini_anno   IN DATE , V_fin_anno_ap IN DATE) IS
/******************************************************************************
 NOME:         SCDF_UPD
 DESCRIZIONE:  Esegue la chiusura dei record di SCAGLIONI_DETRAZIONE_FISCALE 
               al 31/12/AP

 ANNOTAZIONI:  E' richiamata dalla procedure VAFI_UPD

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/01/2006 MS     Mod. per clienti con dizionari condivisi ( att. 14314 )
 1.2  27/01/2006 MS     Mod. errore Oracle ( att. 14370.1 )
******************************************************************************/
V_esiste varchar2(1) := '';
V_TYPE   VARCHAR2(13) := '';
V_comando VARCHAR2(2000) := '';
BEGIN
   BEGIN
     select 'S'
       into V_esiste
       from dual
      where exists ( select 'x'
                       from scaglioni_detrazione_fiscale
                      where dal < V_ini_anno 
                        and al is null
                   )
        and exists ( select 'x'
                       from scaglioni_detrazione_fiscale
                      where dal = V_ini_anno 
                    )
      ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_esiste := 'N';
   END;
   BEGIN
   select object_type 
     into V_type
     from obj 
    where object_name = 'SCAGLIONI_DETRAZIONE_FISCALE';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_type := '';
   END;
   IF V_esiste = 'S' and V_type = 'TABLE' THEN
     BEGIN
       V_comando :=
      'update scaglioni_detrazione_fiscale
          set al = '''||V_fin_anno_ap||'''
        where dal = (select max(dal)
                       from validita_fiscale
                      where dal < '''||V_ini_anno||'''
                     )
          and al is null';
      si4.sql_execute(V_comando);
     END;
   END IF;
END SCDF_UPD;
/
PROMPT Creating procedure ADIR_UPD
CREATE OR REPLACE PROCEDURE ADIR_UPD
( V_ini_anno   IN DATE , V_fin_anno_ap IN DATE) IS
/******************************************************************************
 NOME:         ADIR_UPD
 DESCRIZIONE:  Esegue la chiusura dei record di ADDIZIONALE_IRPEF_REGIONALE
               al 31/12/AP

 ANNOTAZIONI:  E' richiamata dalla procedure VAFI_UPD

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/01/2006 MS     Mod. per clienti con dizionari condivisi ( att. 14314 )
 1.2  27/01/2006 MS     Mod. errore Oracle ( att. 14370.1 )
******************************************************************************/
V_esiste varchar2(1) := '';
V_TYPE   VARCHAR2(13) := '';
V_comando VARCHAR2(2000) := '';
BEGIN
   BEGIN
     select 'S'
       into V_esiste
       from dual
      where exists ( select 'x'
                       from addizionale_irpef_regionale
                      where dal < V_ini_anno 
                        and al is null
                   )
        and exists ( select 'x'
                       from addizionale_irpef_regionale
                      where dal = V_ini_anno 
                    )
      ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_esiste := 'N';
   END;
   BEGIN
   select object_type 
     into V_type
     from obj 
    where object_name = 'ADDIZIONALE_IRPEF_REGIONALE';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_type := '';
   END;
   IF V_esiste = 'S' and V_type = 'TABLE' THEN
     BEGIN
      V_comando :=
      'update addizionale_irpef_regionale
          set al = '''||V_fin_anno_ap||'''
        where dal = (select max(dal)
                       from validita_fiscale
                      where dal < '''||V_ini_anno||'''
                     )
          and al is null';
      si4.sql_execute(V_comando);
     END;
   END IF;
END ADIR_UPD;
/
PROMPT Creating procedure ADIC_UPD
CREATE OR REPLACE PROCEDURE ADIC_UPD
( V_ini_anno   IN DATE , V_fin_anno_ap IN DATE) IS
/******************************************************************************
 NOME:         ADIC_UPD
 DESCRIZIONE:  Esegue la chiusura dei record di ADDIZIONALE_IRPEF_COMUNALE
               al 31/12/AP

 ANNOTAZIONI:  E' richiamata dalla procedure VAFI_UPD

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/01/2006 MS     Mod. per clienti con dizionari condivisi ( att. 14314 )
 1.2  27/01/2006 MS     Mod. errore Oracle ( att. 14370.1 )
 1.3  01/03/2006 MS     Aggiunta sql_execute mancante
******************************************************************************/
V_esiste varchar2(1) := '';
V_TYPE   VARCHAR2(13) := '';
V_comando VARCHAR2(2000) := '';
BEGIN
   BEGIN
     select 'S'
       into V_esiste
       from dual
      where exists ( select 'x'
                       from addizionale_irpef_comunale
                      where dal < V_ini_anno 
                        and al is null
                   )
        and exists ( select 'x'
                       from addizionale_irpef_comunale
                      where dal = V_ini_anno 
                    )
      ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_esiste := 'N';
   END;
   BEGIN
   select object_type 
     into V_type
     from obj 
    where object_name = 'ADDIZIONALE_IRPEF_COMUNALE';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_type := '';
   END;
   IF V_esiste = 'S' and V_type = 'TABLE' THEN
     BEGIN
      V_comando := 
      'update addizionale_irpef_comunale
          set al = '''||V_fin_anno_ap||'''
        where dal = (select max(dal)
                       from validita_fiscale
                      where dal < '''||V_ini_anno||'''
                     )
          and al is null';
      si4.sql_execute(V_comando);
     END;
   END IF;
END ADIC_UPD;
/
PROMPT Creating procedure VAFI_UPD
CREATE OR REPLACE PROCEDURE VAFI_UPD
( P_anno   IN NUMBER
) IS
/******************************************************************************
 NOME:         VAFI_UPD
 DESCRIZIONE:  Esegue la chiusura delle tabelle fiscali al 31/12/AP

 ANNOTAZIONI:  Richiama le procedure  
               DEFI_UPD - Chiusura DETRAZIONI_FISCALI
               SCFI_UPD - Chiusura SCAGLIONI_FISCALI
               SCDF_UPD - Chiusura SCAGLIONI_DETRAZIONE_FISCALE
               ADIR_UPD - Chiusura ADDIZIONALE_IRPEF_REGIONALE
               ADIC_UPD - Chiusura ADDIZIONALE_IRPEF_COMUNALE

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/01/2006 MS     Mod. per clienti con dizionari condivisi ( att. 14314 )
 1.2  27/01/2006 MS     Mod. errore Oracle ( att. 14370.1 )
******************************************************************************/
V_ini_anno date;
V_fin_anno_ap date;
V_esiste varchar2(1) := '';
V_TYPE   VARCHAR2(13) := '';
V_comando VARCHAR2(2000) := '';
BEGIN
   BEGIN
     select to_date('0101'||P_anno,'ddmmyyyy')
       into V_ini_anno
      from dual;
   END;
   V_fin_anno_ap := V_ini_anno-1;
   BEGIN
     select 'S'
       into V_esiste
       from dual
      where exists ( select 'x'
                       from validita_fiscale 
                      where dal < V_ini_anno 
                        and al is null
                   )
        and exists ( select 'x'
                       from validita_fiscale 
                      where dal = V_ini_anno 
                    )
      ;
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_esiste := 'N';
   END;
   BEGIN
   select object_type 
     into V_type
     from obj 
    where object_name = 'VALIDITA_FISCALE';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_type := '';
   END;
   IF V_esiste = 'S' and V_type = 'TABLE' THEN
     BEGIN
       V_comando  :=
      'update validita_fiscale 
          set al = '''||V_fin_anno_ap||'''
        where dal = (select max(dal)
                       from validita_fiscale
                      where dal < '''||V_ini_anno||'''
                     )
          and al is null';
       si4.sql_execute(V_comando);
       DEFI_UPD(V_ini_anno,V_fin_anno_ap);
       SCFI_UPD(V_ini_anno,V_fin_anno_ap);
       SCDF_UPD(V_ini_anno,V_fin_anno_ap);
       ADIR_UPD(V_ini_anno,V_fin_anno_ap);
       ADIC_UPD(V_ini_anno,V_fin_anno_ap);
     END;
   END IF;
END VAFI_UPD;
/
PROMPT Creating procedure MESI_INS
CREATE OR REPLACE PROCEDURE MESI_INS
( P_anno   IN NUMBER , P_mese   IN NUMBER ) IS
/******************************************************************************
 NOME:         MESI_INS
 DESCRIZIONE:  Inserisce i record in Tabella MESI

 ANNOTAZIONI:   Richiamata dalla procedure CALE_INS

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/01/2006 MS     Mod. per clienti con dizionari condivisi ( att. 14314 )
******************************************************************************/
V_ini_mese date;
V_fin_mese date;
V_esiste   varchar2(1) := '';
V_TYPE   VARCHAR2(13) := '';
V_comando VARCHAR2(2000) := '';
BEGIN
    BEGIN
      select 'S' 
        into V_esiste
        from mesi
       where anno = P_anno
         and mese = P_mese;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      V_esiste := 'N';
    END;
   BEGIN
   select object_type 
     into V_type
     from obj 
    where object_name = 'MESI';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_type := '';
   END;
   IF V_esiste = 'N' and V_type = 'TABLE' THEN
      V_ini_mese := to_date('01'||lpad(to_char(P_mese),2,'0')||to_char(P_anno),'ddmmyyyy');
      V_fin_mese := last_day(to_date(lpad(to_char(P_mese),2,'0')||to_char(P_anno),'mmyyyy'));
      BEGIN
      V_comando :=
        'insert into mesi
        (  ANNO, MESE, INI_MESE, FIN_MESE )
        select '||P_anno||', '||P_mese||', '''||V_ini_mese||''', '''||V_fin_mese||''' from dual';
      si4.sql_execute(V_comando);
     EXCEPTION
        WHEN OTHERS THEN 
          raise_application_error(-20999,'Impossibile Inserire il Calendario per Anno/Mese: '||P_anno||' '||P_mese);
     END;
    END IF; -- V_esiste
END MESI_INS;
/
PROMPT Creating procedure CALCOLA_CAL
CREATE OR REPLACE PROCEDURE CALCOLA_CAL 
(  p_giorno IN OUT VARCHAR2 
 , p_pos    IN     NUMBER 
 , P_anno   IN     NUMBER
 , P_mese   IN     NUMBER
) IS
/******************************************************************************
 NOME:         CALCOLA_CAL
 DESCRIZIONE:  Determina il tipo di giorno 
 ANNOTAZIONI:  Richiamata dalla procedure CALE_INS

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
******************************************************************************/
dep_gg VARCHAR2(3);
BEGIN
 BEGIN
   select to_char(to_date(to_char(P_pos)||'/'||
                          to_char(P_mese)||'/'||
                          to_char(P_anno)
                        ,'dd/mm/yyyy'
                         )
                 ,'DY'
                 )
     into dep_gg
     from dual
   ;
   IF dep_gg in ('SAT','SAB','SA ') THEN /* Inglese, Italiano, Tedesco */
      p_giorno := 's';
   ELSIF
      dep_gg in ('SUN','DOM','SO ') THEN /* Inglese, Italiano, Tedesco */
      p_giorno := 'd';
   ELSE
      p_giorno := 'f';
   END IF;
 EXCEPTION
   WHEN OTHERS THEN
     p_giorno := '*';
 END;
END CALCOLA_CAL;
/
PROMPT Creating procedure DETERMINO_PASQUA
CREATE OR REPLACE PROCEDURE DETERMINO_PASQUA
( P_anno     IN     NUMBER
, P_pasqua   IN OUT DATE
) IS
/******************************************************************************
 NOME:         DETERMINO_PASQUA
 DESCRIZIONE:  Determina il giorno di Pasqua utilizzando l'algoritmo di Gauss
               dal 1583 al 2499 Richiamata dalla CALE_INS

REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  21/05/2007 CB  Prima Emissione
******************************************************************************/
P_a   number;
P_b   number;
P_c   number;
P_n   number;
P_m   number;
P_d   number;
P_e   number;
BEGIN
P_a := mod(P_anno,19);
P_b := mod(P_anno,4);
P_c := mod(P_anno,7);

if P_anno    between 1583 and 1699 then 
   P_m:= 22;
   P_n:= 2;
elsif P_anno between 1700 and 1799 then
   P_m:= 23;
   P_n:= 3;
elsif P_anno between 1800 and 1899 then
   P_m:= 23;
   P_n:= 4;
elsif P_anno between 1900 and 2099 then
   P_m:= 24;
   P_n:= 5;
elsif P_anno between 2100 and 2199 then
   P_m:= 24;
   P_n:= 6;
elsif P_anno between 2200 and 2299 then
   P_m:= 25;
   P_n:= 0;
elsif P_anno between 2300 and 2399 then
   P_m:= 26;
   P_n:= 1;
elsif P_anno between 2400 and 2499 then
   P_m:= 25;
   P_n:= 1;
end if;
P_d := mod((19*P_a + P_m),30 );
P_e := mod((2*P_b + 4*P_c + 6*P_d + P_n) , 7 );

if P_d+P_e <10 then
   P_pasqua := to_date(lpad(to_char(P_d+P_e+22),2,'0')||'03'||to_char(P_anno),'ddmmyyyy');
else
   P_pasqua := to_date(lpad(to_char(P_d+P_e-9),2,'0')||'04'||to_char(P_anno),'ddmmyyyy');
end if;

if P_d+P_e >= 10 and P_d+P_e-9= 26 then 
   P_pasqua := to_date('1904'||to_char(P_anno),'ddmmyyyy');
elsif P_d+P_e >= 10 and P_d+P_e-9= 25 and P_d=28 and P_e=6 and P_a>10 then 
   P_pasqua := to_date('1804'||to_char(P_anno),'ddmmyyyy');
end if;
END DETERMINO_PASQUA;
/
PROMPT Creating procedure CALE_INS
CREATE OR REPLACE PROCEDURE CALE_INS
( P_anno   IN NUMBER
, P_mese   IN NUMBER
) IS
/******************************************************************************
 NOME:         CALE_INS
 DESCRIZIONE:  Determina il calendario avendo come input anno e mese

 ANNOTAZIONI:  In caso di apertura anno nuovo passare l'anno e mese = 0
               In caso di utilizzo per inserire un mese solo passare anno e mese 
               Richiama al suo interno la procedure CALCOLA_CAL

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/01/2006 MS     Mod. per clienti con dizionari condivisi ( att. 14314 )
 1.2  19/01/2006 MS     Aggiunto controllo su calendario *  ( att. 14370 )
 1.3  27/01/2006 MS     Mod. errore Oracle ( att. 14370.1 )
 1.4  21/05/2007 CB     Upper delle festività
******************************************************************************/
V_giorno VARCHAR2(1);
V_cale   VARCHAR2(31) := '';
V_esiste   varchar2(1) := '';
V_TYPE   VARCHAR2(13) := '';
V_comando VARCHAR2(2000) := '';
P_pasqua    date;
P_pasquetta date;
BEGIN
 IF P_mese = 0 THEN
  BEGIN
   FOR V_mese in 1..12 LOOP
       V_esiste := '';
       V_cale := '';
    BEGIN
      select 'S' 
        into V_esiste
        from calendari
       where anno = P_anno
         and mese = V_mese
         and calendario = '*';
    EXCEPTION WHEN NO_DATA_FOUND THEN
      V_esiste := 'N';
    END;
   BEGIN
   select object_type 
     into V_type
     from obj 
    where object_name = 'CALENDARI';
   EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          V_type := '';
   END;
    IF V_esiste = 'N' and V_type = 'TABLE' THEN
       BEGIN
       FOR V_pos in 1..31 LOOP
         BEGIN
            CALCOLA_CAL(V_giorno, V_pos, P_anno, V_mese);
         END;
       determino_pasqua(P_anno,P_pasqua);
       P_pasquetta := P_pasqua+1;
       if lpad(V_pos,2,'0')||lpad(V_mese,2,0) in ('0101','0601','2504','0105','0206','1508','0111','0812','2512','2612',to_char(P_pasqua,'ddmm'),to_char(P_pasquetta,'ddmm')) then
           V_giorno:=upper(V_giorno);
       end if;
       V_cale := rtrim(V_cale)||V_giorno;
       END LOOP; -- POS
      END;
     BEGIN
        MESI_INS(P_anno,V_mese);
     END;
     BEGIN
      V_comando := 
       'insert into calendari(anno,mese,calendario,giorni)
        select '||P_anno||', '||V_mese||',''*'','''||V_cale||''' from dual';
      si4.sql_execute(V_comando);
     EXCEPTION
        WHEN OTHERS THEN 
          raise_application_error(-20999,'Impossibile Inserire il Calendario per Anno/Mese: '||P_anno||' '||V_mese);
     END;
    END IF; -- V_esiste
   END LOOP; -- V_mese
  END;
 ELSE
       V_esiste := '';
       V_cale := '';
    BEGIN
      select 'S' 
        into V_esiste
        from calendari
       where anno = P_anno
         and mese = P_mese
         and calendario = '*';
    EXCEPTION WHEN NO_DATA_FOUND THEN
      V_esiste := 'N';
    END;
    IF V_esiste = 'N' THEN
      BEGIN
       FOR POS in 1..31 LOOP
         BEGIN
            CALCOLA_CAL(V_giorno, pos, P_anno, P_mese);
         END;
       determino_pasqua(P_anno,P_pasqua);
       P_pasquetta := P_pasqua+1;
       if lpad(pos,2,'0')||lpad(P_mese,2,0) in ('0101','0601','2504','0101','0206','1508','0111','0812','2512','2612',to_char(P_pasqua,'ddmm'),to_char(P_pasquetta,'ddmm')) then
           V_giorno:=upper(V_giorno);
       end if;
        V_cale := rtrim(V_cale)||V_giorno;
       END LOOP; -- POS
      END;
     BEGIN
        MESI_INS(P_anno,P_mese);
     END;
     BEGIN
      V_comando := 
        'insert into calendari(anno,mese,calendario,giorni)
        select '||P_anno||', '||P_mese||',''*'','''||V_cale||''' from dual';
      si4.sql_execute(V_comando);
     EXCEPTION
        WHEN OTHERS THEN 
          raise_application_error(-20999,'Impossibile Inserire il Calendario per Anno/Mese: '||P_anno||' '||P_mese);
     END;
    END IF;
 END IF;
END CALE_INS;
/
PROMPT Creating procedure RAIN_UPD
CREATE OR REPLACE PROCEDURE RAIN_UPD
( P_anno    number, P_tipo varchar2 ) IS
/******************************************************************************
 NOME:         RAIN_UPD
 DESCRIZIONE:  Ciclo sui Dipendenti che hanno concluso il Rapporto di Lavoro 
               nell'anno precedente: chiusura automatica di RAIN

 ANNOTAZIONI:  E' richiamata dalla procedure RIRE_CAMBIO_ANNO

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
******************************************************************************/
V_chiusura_rain varchar2(2) := '';
BEGIN
   BEGIN
     select chiusura_rain
       into V_chiusura_rain
       from ente;
   EXCEPTION WHEN NO_DATA_FOUND THEN
     V_chiusura_rain := 'SI';
   END;
   IF V_chiusura_rain = 'SI' THEN
    IF P_tipo !=  'B' THEN
      FOR CURP IN
         ( select distinct pegi.ci
            from periodi_giuridici pegi
           where pegi.rilevanza = 'P'
             and pegi.al  between to_date( '12'||to_char(P_anno-2), 'mmyyyy')
                              and to_date( '3112'||to_char(P_anno-1), 'ddmmyyyy')
             and not exists
                (select 'x'
                   from periodi_giuridici
                  where ci        = pegi.ci
                    and rilevanza = 'P'
                    and nvl(al,to_date('3101'||P_anno,'ddmmyyyy')) >=
                        to_date('01'||to_char(P_anno),'mmyyyy')
                )
         ) 
       LOOP
         BEGIN  -- Chiusura del Rapporto Individuale
            update rapporti_individuali
               set al  = to_date( '3112'||to_char(P_anno - 1), 'ddmmyyyy')
             where ci  = curp.ci
               and al is null
            ;
         END;
      END LOOP;
    END IF; -- tipo mens
   END IF; -- chiusura rain
EXCEPTION
   WHEN OTHERS THEN
      raise_application_error(-20999,'Impossibile Modificare i Rapporti Individuali');
END RAIN_UPD;
/
PROMPT Creating procedure INEX_UPD
CREATE OR REPLACE PROCEDURE INEX_UPD
( P_anno    number, P_mese    number, P_rif_alq_ap date, P_max_aliquota number) IS
/******************************************************************************
 NOME:         INEX_UPD
 DESCRIZIONE:  Aggiorna INFORMAZIONI_EXTRACONTABILI Nuovo Anno 
               ( in caso siano gia` presenti oppure post-inserimento )
               Ricalcolo Aliquota AP in INFORMAZIONI_EXTRACONTABILI

 ANNOTAZIONI:  E' richiamata dalla procedure RIRE_CAMBIO_ANNO

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  02/10/2006 MS     Gestione nuovi flag per cafa ( a17266 )
 1.2  17/10/2006 MS     Gestione nuovi campi per ipn fam ( A17262 )
 1.3  24/10/2006 MS     Miglioria gestione nuovi flag per cafa ( A17266.1 )
 1.4  30/10/2006 MS     Aggiunta perc_car_fam ( A17266.2 )
 1.5  23/02/2007 MS     Sistemazione gestione car. fam. a cambio anno (Att. 19662)
 1.6  23/03/2007 GM     Aggiunta parametro P_max_aliquota (A18053.1)
 1.7  05/06/2007 MS     Aggiunto controllo su mese per ipn.ass.fam (Att. 21422)
 1.8  21/06/2007 MS     Modifica gestione ipn_fam mensile ( A21712 )
******************************************************************************/
BEGIN
      update informazioni_extracontabili x
         set ( ipn_1ap
             , ipn_fam_1ap
             , ipn_fam_2ap
             , ipn_fam_1
             , ipn_fam_2
             , ipn_fam_3
             , ipn_fam_4
             , ipn_fam_5
             , ipn_fam_6
             , ipn_fam_7
             , ipn_fam_8
             , ipn_fam_9
             , ipn_fam_10
             , ipn_fam_11
             , ipn_fam_12
             , aut_ass_fam
             , aut_ded_fam
             , perc_car_fam
             , perc_irpef_ord
             , perc_irpef_sep
             , perc_irpef_liq
             , base_cong
             , effe_cong
             , ant_liq_ap
             , ant_acc_ap
             , ant_acc_2000
             , ipt_liq_ap
             , ipn_liq_ap
             , fdo_tfr_ap
             , riv_tfr_ap
             , fdo_tfr_2000     
             , gg_anz_c
             , gg_anz_t_2000
             , gg_anz_i_2000
             , gg_anz_r_2000
             , det_liq_ap
             ) =
     (select decode(greatest(nvl(sum(prfi.ipn_ac),0) - sum(nvl(prfi.ded_base_ac,0)+nvl(prfi.ded_agg_ac,0)+nvl(prfi.ded_con_ac,0)+nvl(prfi.ded_fig_ac,0)+nvl(prfi.ded_alt_ac,0)),0)

                  , 0, null
                     , greatest(nvl(sum(prfi.ipn_ac),0) - sum(nvl(prfi.ded_base_ac,0)+nvl(prfi.ded_agg_ac,0)+nvl(prfi.ded_con_ac,0)+nvl(prfi.ded_fig_ac,0)+nvl(prfi.ded_alt_ac,0)),0))
           , decode(P_mese,1,null,x.ipn_fam_1ap) -- ipn_fam_1ap
           , decode(P_mese,1,decode(greatest(max(inex.ipn_fam_1ap),0),0,null,greatest(max(inex.ipn_fam_1ap),0))
                            ,x.ipn_fam_2ap) -- ipn_fam_2ap
           , decode(P_mese,1,decode(greatest(max(nvl(inex.ipn_fam_12,0)),0)
                                   ,0,null,greatest(max(nvl(inex.ipn_fam_12,0)),0))
                            ,x.ipn_fam_1) -- ipn_fam_1
           , decode(P_mese,1,decode(greatest(max(nvl(inex.ipn_fam_12,0)),0)
                                   ,0,null,greatest(max(nvl(inex.ipn_fam_12,0)),0))
                            ,x.ipn_fam_2) -- ipn_fam_2
           , decode(P_mese,1,decode(greatest(max(nvl(inex.ipn_fam_12,0)),0)
                                   ,0,null,greatest(max(nvl(inex.ipn_fam_12,0)),0))
                            ,x.ipn_fam_3) -- ipn_fam_3
           , decode(P_mese,1,decode(greatest(max(nvl(inex.ipn_fam_12,0)),0)
                                   ,0,null,greatest(max(nvl(inex.ipn_fam_12,0)),0))
                            ,x.ipn_fam_4) -- ipn_fam_4
           , decode(P_mese,1,decode(greatest(max(nvl(inex.ipn_fam_12,0)),0)
                                   ,0,null,greatest(max(nvl(inex.ipn_fam_12,0)),0))
                            ,x.ipn_fam_5) -- ipn_fam_5
           , decode(P_mese,1,decode(greatest(max(nvl(inex.ipn_fam_12,0)),0)
                                   ,0,null,greatest(max(nvl(inex.ipn_fam_12,0)),0))
                            ,x.ipn_fam_6) -- ipn_fam_6
           , decode(P_mese,1,null,x.ipn_fam_7)
           , decode(P_mese,1,null,x.ipn_fam_8)
           , decode(P_mese,1,null,x.ipn_fam_9)
           , decode(P_mese,1,null,x.ipn_fam_10)
           , decode(P_mese,1,null,x.ipn_fam_11)
           , decode(P_mese,1,null,x.ipn_fam_12)
           , decode(P_mese,1,nvl(max(nvl(inex.aut_ass_fam, decode( greatest(nvl(inex.ipn_fam_1ap,0),0)
                                                                 + greatest(nvl(inex.ipn_fam_12,0),0)
                                                                 , 0, 'NO', 'SI'))),x.aut_ass_fam)
                            ,x.aut_ass_fam) -- aut_ass_fam
           , nvl(max(inex.aut_ded_fam),x.aut_ded_fam)
           , max(inex.perc_car_fam)
           , least(max(inex.perc_irpef_ord),P_max_aliquota) -- Inserisce il più piccolo tra perc_irpef_ord e P_max_aliquota se perc_irpef_ord non è NULL
           , max(perc_irpef_sep)
           , max(perc_irpef_liq)
           , max(base_cong)
           , max(effe_cong)
           , nvl(max(inex.ant_liq_ap),0) + nvl(sum(prfi.lor_liq),0)
           , nvl(max(inex.ant_acc_ap),0) + nvl(sum(prfi.lor_acc),0)
           , nvl(max(inex.ant_acc_2000),0) + nvl(sum(prfi.lor_acc_2000),0)
           , nvl(max(inex.ipt_liq_ap),0) + nvl(sum(prfi.ipt_liq),0)
           , nvl(max(inex.ipn_liq_ap),0) + nvl(sum(prfi.ipn_liq),0)
           , nvl(sum(prfi.fdo_tfr_ap),0)
           - nvl(sum(prfi.fdo_tfr_ap_liq),0)
           + nvl(sum(prfi.qta_tfr_ac),0)
           - nvl(sum(prfi.qta_tfr_ac_liq),0)
           - nvl(sum(prfi.rit_tfr),0)                  fdo_tfr_ap
           , nvl(sum(prfi.riv_tfr_ap),0)
           - nvl(sum(prfi.riv_tfr_ap_liq),0)
           + nvl(sum(prfi.riv_tfr),0)
           - nvl(sum(prfi.riv_tfr_liq),0)
           , nvl(sum(prfi.fdo_tfr_2000),0)
           - nvl(sum(prfi.fdo_tfr_2000_liq),0)         fdo_tfr_2000
           , max(inex.gg_anz_c)
           , max(inex.gg_anz_t_2000)
           , max(inex.gg_anz_i_2000)
           , max(inex.gg_anz_r_2000)
           , nvl(max(inex.det_liq_ap),0) + nvl(sum(prfi.det_liq),0)
        from informazioni_extracontabili inex
           , progressivi_fiscali         prfi
       where inex.ci         = x.ci
         and inex.anno       = P_anno - 1
         and prfi.ci         = inex.ci
         and prfi.anno       = P_anno - 1
         and prfi.mese       = 12
         and prfi.mensilita  =
            (select max(mensilita)
               from mensilita
              where mese = 12
            )
     )
      where x.anno = P_anno
        and exists
           (select 'x'
              from informazioni_extracontabili
             where ci         = x.ci
               and anno       = x.anno - 1
           )
      ;
      update informazioni_extracontabili inex
         set alq_ap =
         (select decode(
                 round( ( ( (nvl(inex.ipn_1ap,0) + nvl(inex.ipn_2ap,0)
                            ) / 2 - scaglione
                          ) * aliquota / 100 + imposta
                        ) * 100
                        / decode( nvl(inex.ipn_1ap,0)
                                + nvl(inex.ipn_2ap,0)
                                , 0, 1
                                   , ( ( nvl(inex.ipn_1ap,0)
                                       + nvl(inex.ipn_2ap,0)
                                       ) / 2
                                     )
                                )
                      , 2 )
                       , 0, ''
                          ,
                 round( ( ( (nvl(inex.ipn_1ap,0) + nvl(inex.ipn_2ap,0)
                            ) / 2 - scaglione
                          ) * aliquota / 100 + imposta
                        ) * 100
                        / decode( nvl(inex.ipn_1ap,0)
                                + nvl(inex.ipn_2ap,0)
                                , 0, 1
                                   , ( ( nvl(inex.ipn_1ap,0)
                                       + nvl(inex.ipn_2ap,0)
                                       ) / 2
                                     )
                                )
                      , 2 )
                       )
            from scaglioni_fiscali
           where scaglione =
                (select max(scaglione)
                   from scaglioni_fiscali
                  where scaglione <= ( nvl(inex.ipn_1ap,0)
                                     + nvl(inex.ipn_2ap,0)
                                     ) / 2
                    and P_rif_alq_ap
                        between nvl(dal,to_date('2222222','j'))
                            and nvl(al ,to_date('3333333','j'))
                )
             and P_rif_alq_ap between nvl(dal,to_date('2222222','j'))
                                   and nvl(al ,to_date('3333333','j'))
         )
       where nvl(alq_ap,99) != 0
         and     anno      = P_anno
      ;
EXCEPTION
   WHEN OTHERS THEN
      raise_application_error(-20999,'Impossibile Modificare le Informazioni Extracontabili');
END INEX_UPD;
/
PROMPT Creating procedure INEX_INS
CREATE OR REPLACE PROCEDURE INEX_INS
( P_anno    number, P_max_aliquota number) IS
/******************************************************************************
 NOME:         INEX_INS
 DESCRIZIONE:  Inserimento INFORMAZIONI_EXTRACONTABILI Nuovo Anno

 ANNOTAZIONI:  E' richiamata dalla procedure RIRE_CAMBIO_ANNO

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  02/10/2006 MS     Gestione nuovi flag per cafa ( a17266 )
 1.2  17/10/2006 MS     Gestione nuovi campi per ipn fam ( A17262 )
 1.3  24/10/2006 MS     Miglioria gestione nuovi flag per cafa ( A17266.1 )
 1.4  30/10/2006 MS     Aggiunta perc_car_fam ( A17266.2 )
 1.5  23/02/2007 MS     Sistemazione gestione car. fam. a cambio anno (Att. 19662)
 1.6  23/03/2007 GM     Aggiunta parametro P_max_aliquota (A18053.1) 
 1.7  02/04/2007 ML     Aggiunto flag rinuncia_esenzione_add_com (A20240)
 1.8  21/06/2007 MS     Modifica gestione ipn_fam mensile ( A21712 )
******************************************************************************/
BEGIN  
      insert into informazioni_extracontabili
           ( ci, anno
           , ipn_1ap, ipn_2ap, alq_ap
           , ipn_fam_1ap
           , ipn_fam_2ap
           , ipn_fam_1
           , ipn_fam_2
           , ipn_fam_3
           , ipn_fam_4
           , ipn_fam_5
           , ipn_fam_6
           , ipn_fam_7
           , ipn_fam_8
           , ipn_fam_9
           , ipn_fam_10
           , ipn_fam_11
           , ipn_fam_12
           , perc_car_fam
           , perc_irpef_ord, perc_irpef_sep, perc_irpef_liq
           , base_cong, effe_cong
           , det_con, det_fig, det_alt
           , det_spe, det_ult
           , ant_liq_ap
           , ant_acc_ap
           , ant_acc_2000                    -- nuovo
           , ipt_liq_ap
           , ipn_liq_ap
           , fdo_tfr_ap      -- da fare
           , riv_tfr_ap
           , fdo_tfr_2000     
           , gg_anz_c
           , gg_anz_t_2000
           , gg_anz_i_2000
           , gg_anz_r_2000
           , det_liq_ap
           , aut_ass_fam
           , aut_ded_fam
           , rinuncia_esenzione_add_com
           )
      select inex.ci, P_anno
           , decode(greatest(nvl(sum(prfi.ipn_ac),0) - sum(nvl(prfi.ded_base_ac,0)+nvl(prfi.ded_agg_ac,0)+nvl(prfi.ded_con_ac,0)+nvl(prfi.ded_fig_ac,0)+nvl(prfi.ded_alt_ac,0)),0)
                  , 0, null
                     , greatest(nvl(sum(prfi.ipn_ac),0) - sum(nvl(prfi.ded_base_ac,0)+nvl(prfi.ded_agg_ac,0)+nvl(prfi.ded_con_ac,0)+nvl(prfi.ded_fig_ac,0)+nvl(prfi.ded_alt_ac,0)),0)) -- ipn_1ap
           , decode(greatest(max(inex.ipn_1ap),0),0, null, greatest(max(inex.ipn_1ap),0)) -- ipn_2ap
           , null -- alq_ap
           , null -- ipn_fam_1ap
           , decode(greatest(max(inex.ipn_fam_1ap),0),0,null,greatest(max(inex.ipn_fam_1ap),0)) -- ipn_fam_2ap
           , decode(greatest(max(nvl(inex.ipn_fam_12,0)),0)
                   ,0,null,greatest(max(nvl(inex.ipn_fam_12,0)),0)) -- ipn_fam_1
           , decode(greatest(max(nvl(inex.ipn_fam_12,0)),0)
                   ,0,null,greatest(max(nvl(inex.ipn_fam_12,0)),0)) -- ipn_fam_2
           , decode(greatest(max(nvl(inex.ipn_fam_12,0)),0)
                   ,0,null,greatest(max(nvl(inex.ipn_fam_12,0)),0)) -- ipn_fam_3
           , decode(greatest(max(nvl(inex.ipn_fam_12,0)),0)
                   ,0,null,greatest(max(nvl(inex.ipn_fam_12,0)),0)) -- ipn_fam_4
           , decode(greatest(max(nvl(inex.ipn_fam_12,0)),0)
                   ,0,null,greatest(max(nvl(inex.ipn_fam_12,0)),0)) -- ipn_fam_5
           , decode(greatest(max(nvl(inex.ipn_fam_12,0)),0)
                   ,0,null,greatest(max(nvl(inex.ipn_fam_12,0)),0)) -- ipn_fam_6
           , null -- ipn_fam_7
           , null -- ipn_fam_8
           , null -- ipn_fam_9
           , null -- ipn_fam_10
           , null -- ipn_fam_11
           , null -- ipn_fam_12
           , max(inex.perc_car_fam)
           , least(max(inex.perc_irpef_ord),P_max_aliquota), max(inex.perc_irpef_sep) -- Inserisce il più piccolo tra perc_irpef_ord e P_max_aliquota se perc_irpef_ord non è NULL
           , max(inex.perc_irpef_liq)
           , max(inex.base_cong), max(inex.effe_cong)
           , max(inex.det_con), max(inex.det_fig), max(inex.det_alt)
           , max(inex.det_spe), max(inex.det_ult)
           , nvl(max(inex.ant_liq_ap),0) + nvl(sum(prfi.lor_liq),0)
           , nvl(max(inex.ant_acc_ap),0) + nvl(sum(prfi.lor_acc),0)
           , nvl(max(inex.ant_acc_2000),0) + nvl(sum(prfi.lor_acc_2000),0)
           , nvl(max(inex.ipt_liq_ap),0) + nvl(sum(prfi.ipt_liq),0)
           , nvl(max(inex.ipn_liq_ap),0) + nvl(sum(prfi.ipn_liq),0)
           , nvl(sum(prfi.fdo_tfr_ap),0)
           - nvl(sum(prfi.fdo_tfr_ap_liq),0)
           + nvl(sum(prfi.qta_tfr_ac),0)
           - nvl(sum(prfi.qta_tfr_ac_liq),0)
           - nvl(sum(prfi.rit_tfr),0)                  fdo_tfr_ap
           , nvl(sum(prfi.riv_tfr_ap),0)
           - nvl(sum(prfi.riv_tfr_ap_liq),0)
           + nvl(sum(prfi.riv_tfr),0)
           - nvl(sum(prfi.riv_tfr_liq),0)
           , nvl(sum(prfi.fdo_tfr_2000),0)
           - nvl(sum(prfi.fdo_tfr_2000_liq),0)         fdo_tfr_2000
           , max(inex.gg_anz_c)
           , max(inex.gg_anz_t_2000)
           , max(inex.gg_anz_i_2000)
           , max(inex.gg_anz_r_2000)
           , nvl(max(inex.det_liq_ap),0) + nvl(sum(prfi.det_liq),0)
           , max(nvl(inex.aut_ass_fam, decode( greatest(nvl(inex.ipn_fam_1ap,0),0)
                                        + greatest(nvl(inex.ipn_fam_12,0),0)
                                        , 0, 'NO', 'SI')))
           , max(nvl(inex.aut_ded_fam,'SI'))
           , max(inex.rinuncia_esenzione_add_com)
        from informazioni_extracontabili inex
           , progressivi_fiscali         prfi
       where inex.anno       = P_anno - 1
         and prfi.ci   (+)   = inex.ci
         and prfi.anno (+)   = P_anno - 1
         and prfi.mese (+)   = 12
         and (   prfi.mensilita is null
              or prfi.mensilita  =
                (select max(mensilita)
                   from mensilita
                  where mese = 12
                )
             )
         and not exists
            (select 'x'
               from informazioni_extracontabili
              where ci         = inex.ci
                and anno       = P_anno
            )
       group by inex.ci
       having nvl(sum(prfi.ipn_ac),0) != 0
           or max(inex.ipn_1ap)       != 0
           or ( nvl(sum(prfi.fdo_tfr_ap),0)
              + nvl(sum(prfi.riv_tfr),0)
              + nvl(sum(prfi.qta_tfr_ac),0)
              - nvl(sum(prfi.rit_tfr),0)
              ) != 0
      ;
EXCEPTION
   WHEN OTHERS THEN
      raise_application_error(-20999,'Impossibile Inserire le Informazioni Extracontabili');
END INEX_INS;
/
PROMPT Creating procedure MOFI_INS
CREATE OR REPLACE PROCEDURE MOFI_INS
( P_anno    number  ) IS
/******************************************************************************
 NOME:         MOFI_INS
 DESCRIZIONE:  Produzione Movimenti Fiscali di Riporto da A.P.

 ANNOTAZIONI:  E' richiamata dalla procedure RIRE_CAMBIO_ANNO

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
******************************************************************************/
BEGIN  
          BEGIN
            delete from movimenti_fiscali
             where anno = P_anno
               and mese = 1
               and mensilita = '*AP'
            ;
         END;
         BEGIN
            insert into movimenti_fiscali
                 ( ci, anno, mese, mensilita
                 , rit_ord, ipn_ord, alq_ord, ipt_ord
                 , alq_ac, ipt_ac, det_fis, det_god, con_fis
                 , det_con, det_fig, det_alt, det_spe, det_ult
                 , rit_ap, ipn_ap, alq_ap, ipt_ap
                 , lor_liq, lor_acc, rit_liq, rid_liq, rtp_liq
                 , ipn_liq, alq_liq, ipt_liq
                 , gg_anz_t
                 , gg_anz_i
                 , gg_anz_r
                 , lor_tra, rit_tra, ipn_tra
                 )
            select prfi.ci, P_anno, 1, '*AP'
                 , 0, 0, 0, 0
                 , 0, 0, 0, 0, 0
                 , 0, 0, 0, 0, 0
                 , 0, 0, 0, 0
                 , 0, 0, 0, 0, 0
                 , 0, 0, 0
                 , sum(prfi.gg_anz_t)
                 , sum(prfi.gg_anz_i)
                 , sum(prfi.gg_anz_r)
                 , 0, 0, 0
              from progressivi_fiscali  prfi
                 , rapporti_individuali rain
             where prfi.anno      = P_anno - 1
               and prfi.mese      = 12
               and prfi.mensilita =
                  (select max(mensilita)
                     from mensilita
                    where mese    = 12
                  )
               and rain.ci        = prfi.ci
               and nvl(rain.al,to_date('3333333','j'))
                                 >= to_date( '0101'||
                                             to_char(P_anno - 1)
                                           , 'ddmmyyyy'
                                           )
             group by prfi.ci
             having sum(gg_anz_t) != 0
                 or sum(gg_anz_i) != 0
                 or sum(gg_anz_r) != 0
            ;
         END;
EXCEPTION
   WHEN OTHERS THEN
      raise_application_error(-20999,'Impossibile Inserire i Movimenti Fiscali');
END MOFI_INS;
/
PROMPT Creating procedure MOCO_INS
CREATE OR REPLACE PROCEDURE MOCO_INS
( P_anno    number ) IS
/******************************************************************************
 NOME:         MOCO_INS
 DESCRIZIONE:  Produzione Movimenti Contabili di Riporto da A.P.
               Inserisce registrazioni Storiche

 ANNOTAZIONI:  E' richiamata dalla procedure RIRE_CAMBIO_ANNO

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/12/2005 MS     Separata gestione Add. sospese
 1.2  13/12/2005 MS     Aggiunto NVL nelle Add. sospese
 1.3  14/12/2005 MS     Miglioria per Tempi di Elaborazione
******************************************************************************/
BEGIN  
      BEGIN
            insert into mensilita
            (mese,mensilita,codice,tipo,estrazione,giorno,mese_liq)
            values(13,'*RP','rp','S','X',1,1)
            ;
      FOR CUR_CI IN 
         ( select distinct mofi.ci
             from movimenti_fiscali mofi
                , rapporti_individuali rain
            where mofi.anno = P_anno-1
              and rain.ci        = mofi.ci
              and nvl(rain.al,to_date('3333333','j'))
                                >= to_date( '0101'||to_char(P_anno - 1), 'ddmmyyyy')
         ) LOOP
         BEGIN
            delete from movimenti_contabili
             where anno = P_anno
               and mese = 1
               and mensilita = '*AP'
               and ci = CUR_CI.ci
            ;
         END;
         BEGIN  -- Inserisce registrazioni di Riporto
            insert into movimenti_contabili
                 ( ci, anno, mese, mensilita
                 , voce, sub, riferimento, arr
                 , input
                 , tar, qta, imp
                 , ipn_p, ipn_eap
                 )
            select prco.ci, P_anno, 1, '*AP'
                 , prco.voce, prco.sub, max(prco.riferimento), prco.arr
                 , decode(max(voec.memorizza),'A','S','C')
                 , sum(prco.p_tar), sum(prco.p_qta), sum(prco.p_imp)
                 , sum(prco.p_ipn_p), sum(prco.p_ipn_eap)
             from progressivi_contabili prco
                , voci_economiche       voec
             where prco.anno       = P_anno - 1
               and prco.mese       = 13
               and prco.mensilita  = '*RP'
               and prco.ci = CUR_CI.ci
               and voec.codice     = prco.voce
               and (   voec.memorizza in('S','P','M')
                    or voec.memorizza  = 'A' and
                       voec.mensilita  = '*AP'
                   )
               and nvl(voec.specifica,' ' ) not in ( 'ADD_REG_SO','ADD_PRO_SO','ADD_COM_SO')
             group by prco.ci, prco.voce, prco.sub
                    , to_char(prco.riferimento,'yyyy'), prco.arr
             having nvl(sum(prco.p_tar),0) != 0
                 or nvl(sum(prco.p_qta),0) != 0
                 or nvl(sum(prco.p_imp),0) != 0
                 or nvl(sum(prco.p_ipn_eap),0) != 0
            ;
/* Inserimento in movimenti contabili delle sole voci di sospensione delle addizionali */
            insert into movimenti_contabili
                 ( ci, anno, mese, mensilita
                 , voce, sub, riferimento, arr
                 , input
                 , tar, qta, imp
                 , ipn_p, ipn_eap
                 )
            select moco.ci, P_anno, 1, '*AP'
                 , moco.voce, moco.sub, max(moco.riferimento), moco.arr
                 , decode(max(voec.memorizza),'A','S','C')
                 , sum(moco.tar), sum(moco.qta), sum(moco.imp)
                 , sum(moco.ipn_p), sum(moco.ipn_eap)
              from movimenti_contabili moco
                 , voci_economiche       voec
             where moco.anno       = P_anno - 1
               and moco.mese       = 12
               and moco.ci = CUR_CI.ci
               and voec.codice     = moco.voce
               and (   voec.memorizza in('S','P','M')
                    or voec.memorizza  = 'A' and
                       voec.mensilita  = '*AP'
                   )
               and voec.specifica in ( 'ADD_REG_SO','ADD_PRO_SO','ADD_COM_SO')
             group by moco.ci, moco.voce, moco.sub
                    , to_char(moco.riferimento,'yyyy'), moco.arr
             having nvl(sum(moco.tar),0) != 0
                 or nvl(sum(moco.qta),0) != 0
                 or nvl(sum(moco.imp),0) != 0
                 or nvl(sum(moco.ipn_eap),0) != 0
            ;
         END;
         BEGIN
            insert into movimenti_contabili
                 ( ci, anno, mese, mensilita
                 , voce, sub, riferimento, arr
                 , input
                 , tar, qta, imp
                 , ipn_p, ipn_eap
                 )
            select moco.ci, P_anno, 1, '*AP'
                 , moco.voce, moco.sub, moco.riferimento, moco.arr
                 , moco.input
                 , moco.tar, moco.qta, moco.imp
                 , moco.ipn_p, moco.ipn_eap
              from movimenti_contabili  moco
             where moco.anno      = P_anno - 1
               and moco.mese      = 1
               and moco.mensilita = '*AP'
               and moco.input     = 'S'
               and moco.ci = CUR_CI.ci
            ;
         END;
       END LOOP; -- cur_ci
            delete from mensilita
             where mese = 13
            ;
      END;
EXCEPTION
   WHEN OTHERS THEN
      raise_application_error(-20999,'Impossibile Inserire i Movimenti Contabili');
END MOCO_INS;
/
PROMPT Creating procedure MOCO_DEL
CREATE OR REPLACE PROCEDURE MOCO_DEL
( P_anno    number ) IS
/******************************************************************************
 NOME:         MOCO_DEL
 DESCRIZIONE:  Cancellazione da Movimenti Contabili di Riporto da A.P.
               voci relative alle addizionali con riferimento < A.P.

 ANNOTAZIONI:  E' richiamata dalla procedure RIRE_CAMBIO_ANNO

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/12/2005 MS     Aggiunte le addizionali sospese
 1.2  13/12/2005 MS     Sistemato controllo sull'anno
******************************************************************************/
BEGIN  
         BEGIN  
            delete from movimenti_contabili
             where anno = P_anno
               and mese = 1
               and mensilita = '*AP'
               and voce in ( select codice 
                               from voci_economiche
                              where ( automatismo in ( 'ADD_IRPEF', 'ADD_COMUS', 'ADD_COMU'
                                                   , 'ADD_IRPEFP', 'ADD_IRPEFS', 'ADD_COMUP'
                                                   , 'ADD_PROVP', 'ADD_PROVS', 'ADD_PROV'
                                                   )
                                 or specifica in ( 'ADD_REG_SO','ADD_PRO_SO','ADD_COM_SO' )
                                    )
                           )
               and to_char(riferimento,'yyyy') < P_anno-1
            ;
         END;
EXCEPTION
   WHEN OTHERS THEN
      raise_application_error(-20999,'Impossibile Cancellare i Movimenti Contabili');
END MOCO_DEL;
/
PROMPT Creating procedure NOIN_INS
CREATE OR REPLACE PROCEDURE NOIN_INS
( P_anno   IN NUMBER ) IS
/******************************************************************************
 NOME:         NOIN_INS
 DESCRIZIONE:  Inserimento NOTE_INDIVIDUALI per il nuovo anno se presenti 
               note con anno = 9999

 ANNOTAZIONI:  E' richiamata dalla procedure RIR_CAMBIO_ANNO
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  06/04/2006 ML     Prima Emissione
 1.1  02/01/2006 MS     correzione errore su AL ( Att.15408.1.0 )
 1.2  29/11/2006 ML     Modificata la NOIN_INS (A18444)
 ******************************************************************************/
BEGIN
insert into note_individuali
(anno,mese,mensilita,nota,ci)
select cale.anno
     , mens.mese
     , mens.mensilita
     , noin.nota
     , noin.ci
  from calendari cale
     , mensilita mens
     , note_individuali noin
 where cale.anno = P_anno
   and cale.mese = mens.mese
   and cale.calendario = '*'
   and mens.tipo = 'N'
   and noin.anno = 9999
   and exists
      (select 'x' from rapporti_giuridici
        where ci = noin.ci
          and dal is not null
          and last_day(to_date(lpad(cale.mese,2,0)||cale.anno,'mmyyyy'))
              between to_date('01'||to_char(nvl(dal,to_date('3333333','j')),'mmyyyy'),'ddmmyyyy')
                  and last_day(to_date(to_char(nvl(al,to_date('3333333','j')),'mmyyyy'),'mmyyyy'))
      )
   and not exists
      (select 'x' from note_individuali
        where anno = cale.anno
          and mese = cale.mese
          and mensilita = mens.mensilita
          and ci   = noin.ci
          and nota = noin.nota)
;
EXCEPTION
   WHEN OTHERS THEN
      raise_application_error(-20999,'Impossibile Inserire le Note Individuali');
END NOIN_INS;
/
PROMPT Creating procedure RIRE_CAMBIO_ANNO
CREATE OR REPLACE PROCEDURE RIRE_CAMBIO_ANNO 
( P_anno in number , P_mese in number, P_tipo in varchar2, P_rif_alq_ap in date ) IS
/******************************************************************************
 NOME:         RIRE_CAMBIO_ANNO 
 DESCRIZIONE:  Esegue le operazioni di cambio d'anno:
               - duplica della tabelle relative ai dizionari fiscali 
               - inserimento del nuovo calendario
               - chiusura del personale cessato AP 
               - duplica delle informazioni extracontabili
               - riporto degli *AP relativi ai movimenti_fiscali
               - riporto degli *AP relativi ai movimenti_contabili

 ANNOTAZIONI:  Richiede i seguenti parametri
               - P_anno: anno di apertura di APEEL
               - P_mese: mese di apertura di APEEL
               - P_tipo: tipo della mensilita del DMENS che si sta aprendo
               - P_rif_alq_ap: riferimento aliquota anni precedenti

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1.0  05/12/2005 MS     Prima Emissione
 1.1  12/04/2006 ML     Aggiunta procedure INS_NOIN (15408).
 1.2  26/01/2007 MS     Inibita la duplica diz. fiscali se apertura Bil.prev.
 1.3  23/03/2007 GM     Mod. Riporto Aliquota (att. 18053.1) 
 1.4  05/06/2007 MS     Passato anche mese alle procedure INEX_UPD (att. 21422)
******************************************************************************/
 D_max_aliquota scaglioni_fiscali.aliquota%type; 
BEGIN
 /* Calcolo la Massima Aliquota del Nuovo Anno */
 BEGIN
   select max(aliquota)
     into D_max_aliquota 
  from scaglioni_fiscali scaf
 where to_date('3101'||to_char(P_anno),'ddmmyyyy') between scaf.dal 
                                                       and nvl(scaf.al,to_date('3333333','j'))
   ;
 EXCEPTION
   when OTHERS then
     D_max_aliquota := to_number(null);  
 END;
 IF P_tipo !=  'B' THEN
   VAFI_INS(P_anno);
   VAFI_UPD(P_anno);
 END IF;
 IF P_mese = 1 THEN
-- Inserisco il calendario solo se sto aprendo un nuovo anno e solo se il mese è 1 
   CALE_INS(P_anno,0);
 END IF;
   RAIN_UPD(P_anno,P_tipo);
   INEX_INS(P_anno, D_max_aliquota);
   INEX_UPD(P_anno, P_mese, P_rif_alq_ap, D_max_aliquota);
 IF P_mese = 1 THEN
   MOFI_INS(P_anno);
   MOCO_INS(P_anno);
   MOCO_DEL(P_anno);
   NOIN_INS(P_anno);
 END IF;
END RIRE_CAMBIO_ANNO;
/
