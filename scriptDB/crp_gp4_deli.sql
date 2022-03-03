CREATE OR REPLACE PACKAGE GP4_DELI IS
/******************************************************************************
 NOME:        GP4_DELI
 DESCRIZIONE: Estrazione Personalizzata dati Delibera

 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:
     Il package prevede: controlli sui documenti con codice SCON (Servizi con Onere passati al procedura INPDAP Sonar)
				 - il campo dato_n2 che corrisponde ai mese non puo avere un valore superiore a 11
				 - il campo dato_a1 che corrisponde ai giorni non puo avere un valore superiore a 30

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 0    08/03/2005  ML
 1    16/11/2006  ML    Aggiunta function DATA_DEL
 1.1  07/11/2007  MS    Gestione function personalizzate
******************************************************************************/
FUNCTION  VERSIONE                RETURN VARCHAR2;
FUNCTION  ESTREMI (sede_del    in varchar2
                  ,numero_del  in number
                  ,anno_del    in number
                  )               RETURN VARCHAR2;
FUNCTION  DATA_DEL (sede_del    in varchar2
                   ,numero_del  in number
                   ,anno_del    in number
                   )               RETURN DATE;
END;
/
CREATE OR REPLACE PACKAGE BODY GP4_DELI IS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.1 del 07/11/2007';
END VERSIONE;

FUNCTION  ESTREMI (sede_del    in varchar2
                  ,numero_del  in number
                  ,anno_del    in number
                  )  RETURN VARCHAR2      IS

d_estremi      varchar2(18);
D_cod_cliente  varchar2(10);

BEGIN
  BEGIN
-- Estrazione del codice clientete,'Cliente=')+8,4))))
      select max(upper(substr(note,instr(note, 'Cliente=')+8,10)))
        into D_cod_cliente
        from ad4_enti ad4e
      ;
  END;
  BEGIN
  select decode( D_cod_cliente
               , 'PR_MILANO', decode( greatest(numero,8000000)
                                     , numero, ' '
                                             , decode( nvl(sede,' ')||nvl(numero,0)||nvl(anno,0)
                                                     , ' 00', ' '
                                                            , sede||'/'||to_char(numero)||'/'||decode(to_char(anno),'1900',' ',to_char(anno))
                                                     )
                                     )
                            , decode( nvl(sede,' ')||nvl(numero,0)||nvl(anno,0)
                                     , ' 00', ' '
                                            , sede||'/'||to_char(numero)||'/'||to_char(anno)
                                    )
               )
    into D_estremi
    from delibere
   where sede   (+) = nvl(sede_del,' ')
     and numero (+) = nvl(numero_del,0)
     and anno   (+) = nvl(anno_del,0);
  END;
  
  RETURN D_estremi;

END ESTREMI;

FUNCTION  DATA_DEL (sede_del    in varchar2
                   ,numero_del  in number
                   ,anno_del    in number
                   )  RETURN DATE      IS

D_data         date;
D_cod_cliente  varchar2(10);
BEGIN

  BEGIN
-- Estrazione del codice clientete,'Cliente=')+8,4))))
      select max(upper(substr(note,instr(note, 'Cliente=')+8,10)))
        into D_cod_cliente
        from ad4_enti ad4e
      ;
  END;

  BEGIN
  select decode( D_cod_cliente
               , 'PR_MILANO', decode( greatest(numero,8000000)
               , numero, to_date('')
                       , data
               )
                            , data
               )
    into D_data
    from delibere
   where sede   (+) = nvl(sede_del,' ')
     and numero (+) = nvl(numero_del,0)
     and anno   (+) = nvl(anno_del,0);
  END;

  RETURN D_data;
END DATA_DEL;

END;
/
