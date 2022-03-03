create or replace package gp4gm is
   function versione return varchar2;
   pragma restrict_references(versione, wnds, wnps);
   type ref_cur_non_assegnati is record(
       d_ci        number(8)
      ,d_rilevanza varchar2(1)
      ,d_dal       date
      ,d_al        date
      ,d_settore   varchar2(15)
      ,d_figura    varchar2(8));
   type non_assegnati is ref cursor return ref_cur_non_assegnati;
   procedure get_non_assegnati(c_non_assegnati in out non_assegnati);
   function get_nome_responsabile_uo
   (
      p_ni       in number
     ,p_dal_unor in date
     ,p_al       in date
   ) return varchar2;
   pragma restrict_references(get_nome_responsabile_uo, wnds, wnps);
   function get_se_assente
   (
      p_ci   in number
     ,p_data in date
   ) return number;
   pragma restrict_references(get_se_assente, wnds, wnps);
   function get_se_incaricato
   (
      p_ci   in number
     ,p_data in date
   ) return number;
   pragma restrict_references(get_se_incaricato, wnds, wnps);
   function get_se_di_ruolo
   (
      p_ci   in number
     ,p_data in date
   ) return number;
   pragma restrict_references(get_se_di_ruolo, wnds, wnps);
   function get_ci_responsabile_uo
   (
      p_ni       in number
     ,p_dal_unor in date
   ) return number;
   pragma restrict_references(get_ci_responsabile_uo, wnds, wnps);
   function get_responsabile
   (
      p_ci           in number
     ,p_data         in date
     ,p_livello      in number
     ,p_suddivisione in varchar2
     ,p_rilevanza    in varchar2
   ) return number;
   pragma restrict_references(get_ci_responsabile_uo, wnds, wnps);
   function get_icona_sust
   (
      p_ottica  in varchar2
     ,p_livello in varchar2
   ) return varchar2;
   pragma restrict_references(get_icona_sust, wnds, wnps);
   function get_revisione(p_data in date) return number;
   pragma restrict_references(get_revisione, wnds, wnps);
   function get_revisione_m return number;
   pragma restrict_references(get_revisione_m, wnds, wnps);
   function get_revisione_a return number;
   pragma restrict_references(get_revisione_a, wnds, wnps);
   function get_revisione_o return number;
   pragma restrict_references(get_revisione_o, wnds, wnps);
   function get_revisione_gest(p_gestione in varchar2) return number;
   pragma restrict_references(get_revisione_gest, wnds, wnps);
   function get_des_abb_sust
   (
      p_ottica  in varchar2
     ,p_livello in varchar2
   ) return varchar2;
   pragma restrict_references(get_des_abb_sust, wnds, wnps);
   function ordertree
   (
      p_level  in number
     ,p_figlio in varchar2
   ) return varchar2;
   pragma restrict_references(ordertree, wnds);
   v_testo varchar2(200);
   procedure pgmcunor
   (
      p_revisione    in varchar2
     ,p_ottica       in varchar2
     ,p_dal          in date
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );
   function get_denominazione_livello(p_ni in number) return varchar2;
   procedure valida_revisione
   (
      p_errore       out varchar2
     ,p_segnalazione out varchar2
   );
   procedure set_assegnazione
   (
      p_ci               in number
     ,p_rilevanza        in varchar2
     ,p_dal              in date
     ,p_num_settore_dest in number
     ,p_num_sede         in number
     ,p_evento           in varchar2
     ,p_note             in varchar2
     ,p_sede_del         in varchar2
     ,p_anno_del         in number
     ,p_numero_del       in number
     ,p_errore           out varchar2
     ,p_segnalazione     out varchar2
   );
   procedure crea_organigramma
   (
      p_gestione     in varchar2
     ,p_rilevanza    in varchar2
     ,p_data         in date
     ,p_revisione    in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );
   procedure elimina_nodo
   (
      p_ottica       in varchar2
     ,p_ni           in number
     ,p_dal          in date
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );
   procedure muovi_nodo
   (
      p_ottica           in varchar2
     ,p_revisione        in number
     ,p_ni               in number
     ,p_ni_padre_old     in number
     ,p_dal_padre_old    in date
     ,p_ni_padre_new     in number
     ,p_suddivisione_old in varchar2
     ,p_suddivisione_new in varchar2
     ,p_errore           out varchar2
     ,p_segnalazione     out varchar2
   );
   procedure chk_revisione_m
   (
      p_revisione    in number
     ,p_ottica       in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   );
   procedure allinea_settori(p_gestione in varchar2);
   procedure svuota
   (
      p_livello  in number
     ,p_gestione in varchar2
   );
   procedure update_devgi
   (
      p_posizione in varchar2
     ,p_codice    in varchar2
     ,p_rowid     in varchar2
   );
   procedure allinea_reuo;
   procedure aggiorna_reuo
   (
      p_new_figlio    in number
     ,p_old_figlio    in number
     ,p_new_padre     in number
     ,p_old_padre     in number
     ,p_new_revisione in number
     ,p_old_revisione in number
     ,p_operazione    in varchar2
   );
   procedure continuato
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_dal       in date
     ,p_dal_old   in date
   );
   function astensione_sostituita
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_dal       in date
   ) return varchar2;
   function get_gg_certificato
   (
      p_dal in date
     ,p_al  in date
   ) return number;
   /******************************************************************************
      NAME:       GP4GM
      PURPOSE:    Contiene tutti gli oggetti PL/SQL del Modulo Giuridico Matricolare
      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        19/07/2002
      2.0        07/02/2005               MM  Allineamento modifica febbraio 2005
                                              Utilizzo di UNOR.CODICE_UO al posto
                                              di STAM.CODICE
                                              Nuova procedure ALLINEA_REUO
      2.1        28/02/2005               MM  Attivita 6950.4 - In caso di svuotamento
                                              di revisione i modifica, elimina anche
                                              STAM e ANAG delle nuove UO
      2.2        21/03/2005               MM  Attivita 9890.7 - Modifiche al controllo
                                              di esistenza del padre nella MUOVI_NODO
                                              Attivita 10292.4 - Migliorate le prestazioni
                                              della SVUOTA
      2.3        29/03/2005               MM  Attivita 10421.6 - Modifiche alla get_se_di_ruolo
      2.4        01/04/2005               MM  Attivita 10421.4 - Modifiche alla duplica e alla
                                              validazione della revisione di struttura; disabilitazione
                                              del trigger UNOR_REUO_TMA e attivazione esplicita
                                              della procedure ALLINEA_REUO
      2.5        22/06/2005               CB  Creazione della procedure CONTINUATO
      2.6        03/01/2006               MM  Modifiche per miglioramento prestazioni (SVUOTA, GET_SE_DI_RUOLO)
      2.7        24/01/2006               MM  Attivita 14413 su allinea_reuo
      2.8        12/04/2006               MM  Attivita 15173. Riabilita il trigger UNOR_REUO_TMA nelle raise
      2.9        05/05/2006               MM  Attivita _____. Funzione ASTENSIONE_SOSTITUITA
      2.10       21/09/2006               MM  Attivita 17720. Caso particolare di duplicazione di chiave in valida revisione
                                              Miglioramento della funzione astensione_sostituita
      2.11       18/10/2006               ML  Aggiunti campi nella insert di revisione_uo (A18125)
      2.12       18/10/2006               ML  Aggiunta funzione get_gg_certificato (A17765).
      2.13       18/10/2006               MM  Gestione nuovi campi su RELAZIONI_UO nella proc. ALLINEA_REUO
                                               (A17716).
      2.14       28/11/2006               ML  Modificata funzione get_gg_certificato (A18646).
      2.15       06/12/2006               ML  Modificata procedure Valida_revisione per componenti ( A16657.0.2 )
      2.16       22/12/2006               MM  Modificata funzione astensione_sostituita ( A17702 )
      2.17       26/01/2007               MM  Nuova funzione aggiorna_reuo ( A4442 )
      2.18       05/02/2007               MM  Modifica alla valida_revisione ( A16266)
      2.19       08/02/2007               MM  Nuova funzione get_responsabile (A9054)
      2.20       05/06/2007               MM  Modifiche alla set_assegnazione (A20310)
                                              
   ***********************************************************************************************************/
end gp4gm;
/
create or replace package body gp4gm as
   function versione return varchar2 is
      /******************************************************************************
       NOME:        VERSIONE
       DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
       PARAMETRI:   --
       RITORNA:     stringa varchar2 contenente versione e data.
       NOTE:        Il secondo numero della versione corrisponde alla revisione
                    del package.
      ******************************************************************************/
   begin
      return '2.20  del  05/06/2007';
   end versione;
   function get_denominazione_livello(p_ni in number) return varchar2 is
      d_den_livello varchar2(60);
      /******************************************************************************
         NAME:       GET_DENOMINAZIONE_LIVELLO
         PURPOSE:    Restituire il nome del componente dell'U.O.
      ******************************************************************************/
   begin
      begin
         select denominazione
           into d_den_livello
           from suddivisioni_struttura sust
               ,unita_organizzative    unor
          where sust.ottica = unor.ottica
            and unor.suddivisione = sust.livello
            and unor.tipo = 'P'
            and unor.ottica = 'GP4'
            and unor.dal = gp4_unor.get_dal(unor.ni)
            and unor.ni = p_ni;
      exception
         when no_data_found then
            d_den_livello := to_char(null);
            return d_den_livello;
         when too_many_rows then
            d_den_livello := to_char(null);
            return d_den_livello;
      end;
      return d_den_livello;
   end get_denominazione_livello;
   --
   function get_nome_responsabile_uo
   (
      p_ni       in number
     ,p_dal_unor in date
     ,p_al       in date
   ) return varchar2 is
      d_responsabile varchar2(80);
      /******************************************************************************
         NAME:       GET_NOME_RESPONSABILE_UO
         PURPOSE:    Restituisce cognome e nome del responsabile della UO (identificata dall'NI)
                     ad una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
         PARAMETERS:
         INPUT:
         OUTPUT:
         RETURNED VALUE:  NUMBER
         CALLED BY:
         CALLS:
         EXAMPLE USE:     NUMBER := GET_NOME_RESPONSABILE_UO();
         ASSUMPTIONS:
         LIMITATIONS:
         ALGORITHM:
         NOTES:
      ******************************************************************************/
   begin
      select anag.cognome || '  ' || anag.nome
        into d_responsabile
        from anagrafe anag
       where ni = (select ni
                     from componenti comp
                    where comp.unita_ni = p_ni
                      and comp.unita_ottica = 'GP4'
                      and comp.unita_dal = p_dal_unor
                      and p_al between comp.dal and nvl(comp.al, to_date(3333333, 'j'))
                      and exists (select 'x'
                             from tipi_incarico
                            where incarico = comp.incarico
                              and responsabile = 'SI'));
      return d_responsabile;
   exception
      when no_data_found then
         d_responsabile := to_char(null);
         return d_responsabile;
      when others then
         d_responsabile := to_char(null);
         return d_responsabile;
   end get_nome_responsabile_uo;
   --
   function get_se_assente
   (
      p_ci   in number
     ,p_data in date
   ) return number is
      d_assente number;
      /******************************************************************************
         NAME:       GET_SE_ASSENTE
         PURPOSE:    Indica se l'individuo era assente e sostituibile in una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        21/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_assente := 0;
      select 1
        into d_assente
        from periodi_giuridici pegi
       where ci = p_ci
         and rilevanza = 'A'
         and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
         and exists (select 'x'
                from astensioni
               where codice = pegi.assenza
                 and sostituibile = 1)
         and get_se_di_ruolo(pegi.ci, p_data) = 1;
      return d_assente;
   exception
      when no_data_found then
         d_assente := 0;
         return d_assente;
   end get_se_assente;
   --
   function ordertree
   (
      p_level  in number
     ,p_figlio in varchar2
   ) return varchar2 is
      /******************************************************************************
         NAME:       ORDERTREE
         PURPOSE:    Gestisce l'ordinamento di un tree mantenendo la gerarchia(da usare nella order by)
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        20/03/2003   Cinzia Baffo    1. Created this function.
      ******************************************************************************/
   begin
      v_testo := substr(v_testo, 1, (p_level - 1) * 21) || p_figlio;
      return v_testo;
   exception
      when no_data_found then
         return(null);
   end ordertree;
   --
   function get_se_incaricato
   (
      p_ci   in number
     ,p_data in date
   ) return number is
      d_incaricato number;
      /******************************************************************************
         NAME:       GET_SE_INCARICATO
         PURPOSE:    Indica se l'individuo era INCARICATO  in una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        21/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_incaricato := 0;
      select 1
        into d_incaricato
        from periodi_giuridici pegi
       where ci = p_ci
         and rilevanza = 'I'
         and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
         and get_se_di_ruolo(pegi.ci, p_data) = 1;
      return d_incaricato;
   exception
      when no_data_found then
         d_incaricato := 0;
         return d_incaricato;
   end get_se_incaricato;
   --
   function get_se_di_ruolo
   (
      p_ci   in number
     ,p_data in date
   ) return number is
      d_di_ruolo number;
      /******************************************************************************
         NAME:       GET_SE_DI_RUOLO
         PURPOSE:    Indica se l'individuo era di ruolo  in una certa data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        21/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      d_di_ruolo := 0;
      select 1
        into d_di_ruolo
        from periodi_giuridici pegi
            ,posizioni         posi
       where ci = p_ci
         and rilevanza = 'Q'
         and p_data between pegi.dal and nvl(pegi.al, to_date(3333333, 'j'))
         and posi.codice = pegi.posizione
         and nvl(posi.ruolo_do, posi.ruolo) = 'SI';
      return d_di_ruolo;
   exception
      when no_data_found then
         d_di_ruolo := 0;
         return d_di_ruolo;
   end get_se_di_ruolo;
   --
   function get_ci_responsabile_uo
   (
      p_ni       in number
     ,p_dal_unor in date
   ) return number is
      d_responsabile number;
      /******************************************************************************
         NAME:       GET_NOME_RESPONSABILE_UO
         PURPOSE:    Restituisce il codice individuale del responsabile della UO (identificata dall'NI)
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
      ******************************************************************************/
   begin
      select max(rain.ci)
        into d_responsabile
        from rapporti_individuali rain
       where ni in (select ni
                      from componenti comp
                     where comp.unita_ni = p_ni
                       and comp.unita_ottica = 'GP4'
                       and comp.unita_dal = p_dal_unor
                       and comp.dal = (select max(dal)
                                         from componenti
                                        where unita_ni = p_ni
                                          and unita_ottica = 'GP4'
                                          and unita_dal = p_dal_unor
                                          and componente = comp.componente)
                       and exists (select 'x'
                              from tipi_incarico
                             where incarico = comp.incarico
                               and responsabile = 'SI'));
      return d_responsabile;
   exception
      when no_data_found then
         d_responsabile := to_number(null);
         return d_responsabile;
      when others then
         d_responsabile := to_number(null);
         return d_responsabile;
   end get_ci_responsabile_uo;
   --
   function get_responsabile
   (
      p_ci           in number
     ,p_data         in date
     ,p_livello      in number
     ,p_suddivisione in varchar2
     ,p_rilevanza    in varchar2
   ) return number is
      d_responsabile    rapporti_individuali.ci%type;
      d_revisione       revisioni_struttura.revisione%type;
      d_uo_dipendente   unita_organizzative.ni%type;
      d_uo_responsabile unita_organizzative.ni%type;
      errore exception;
      /******************************************************************************
         NAME:       GET_RESPONSABILE
         PURPOSE:    Restituisce il codice individuale del responsabile del dipendendente
                     indicato dal p_ci
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        08/02/2007  MM
      ******************************************************************************/
   begin
      /* determino la revisione valida alla p_data */
      d_revisione := get_revisione(p_data);
      /* determino l'unita organizzativa del dipendente */
      d_uo_dipendente := gp4_stam.get_ni_numero(gp4_pegi.get_settore(p_ci
                                                                    ,p_rilevanza
                                                                    ,p_data));
      /* verifico la compatibilita tra il livello di assegnazione del dipendente e 
      il livello di responsabilita richiesto */
      if p_livello is not null and
         p_livello >
         gp4_unor.get_livello(d_uo_dipendente
                             ,'GP4'
                             ,gp4_unor.get_dal_data(d_uo_dipendente, p_data)) then
         d_responsabile := -3;
         raise errore;
      end if;
      if p_suddivisione is not null and
         gp4_sust.get_livello(p_suddivisione) >
         gp4_unor.get_livello(d_uo_dipendente
                             ,'GP4'
                             ,gp4_unor.get_dal_data(d_uo_dipendente, p_data)) then
         d_responsabile := -3;
         raise errore;
      end if;
      /* Controllo la compatibilita dei parametri p_livello e p_suddivisione 
      e determino l'unita organizzativa del responsabile */
      if p_livello is not null and p_suddivisione is not null then
         if p_livello <> gp4_sust.get_livello(p_suddivisione) then
            d_responsabile := -4;
            raise errore;
         end if;
      elsif p_livello is null and p_suddivisione is null then
         d_responsabile := -5;
         raise errore;
      elsif p_livello is null and p_suddivisione is not null then
         d_uo_responsabile := gp4_reuo.get_ni_padre(d_revisione
                                                   ,d_uo_dipendente
                                                   ,p_suddivisione);
      elsif p_livello is not null and p_suddivisione is null then
         d_uo_responsabile := gp4_reuo.get_ni_padre_livello(d_revisione
                                                           ,d_uo_dipendente
                                                           ,p_livello);
      end if;
      if d_uo_responsabile is null then
         d_responsabile := -6;
         raise errore;
      end if;
      d_responsabile := get_ci_responsabile_uo(d_uo_responsabile
                                              ,gp4_unor.get_dal_data(d_uo_responsabile
                                                                    ,p_data));
      return d_responsabile;
   exception
      when no_data_found then
         d_responsabile := -1;
         return d_responsabile;
      when too_many_rows then
         d_responsabile := -2;
         return d_responsabile;
      when errore then
         return d_responsabile;
   end get_responsabile;
   --
   function get_des_abb_sust
   (
      p_ottica  in varchar2
     ,p_livello in varchar2
   ) return varchar2 is
      d_des_abb suddivisioni_struttura.des_abb%type;
      /******************************************************************************
         NAME:       GET_DES_ABB_SUST
         PURPOSE:    Fornire ila descrizione abbreviata di ul livello di suddivisione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
         PARAMETERS:
         INPUT:
         OUTPUT:
         RETURNED VALUE:  VARCHAR
         CALLED BY:
         CALLS:
         EXAMPLE USE:     VARCHAR := GET_DES_ABB_SUST();
         ASSUMPTIONS:
         LIMITATIONS:
         ALGORITHM:
         NOTES:
      ******************************************************************************/
   begin
      d_des_abb := to_char(null);
      begin
         select des_abb
           into d_des_abb
           from suddivisioni_struttura
          where ottica = p_ottica
            and livello = p_livello;
      exception
         when no_data_found then
            begin
               -- gestione errore       P_errore := 'P08002';  -- Non esistono il settore amministrativo
               d_des_abb := to_char(null);
            end;
         when too_many_rows then
            begin
               -- gestione errore       P_errore := 'P08003';  -- Esistono piu di un settore amministrativo per la UO
               d_des_abb := to_char(null);
            end;
      end;
      return d_des_abb;
   end get_des_abb_sust;
   --
   function get_icona_sust
   (
      p_ottica  in varchar2
     ,p_livello in varchar2
   ) return varchar2 is
      d_nome_icona suddivisioni_struttura.icona%type;
      /******************************************************************************
         NAME:       GET_ICONA_SUST
         PURPOSE:    Fornire il nome del file dell'icona di un livello di suddivisione
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
         PARAMETERS:
         INPUT:
         OUTPUT:
         RETURNED VALUE:  VARCHAR
         CALLED BY:
         CALLS:
         EXAMPLE USE:     VARCHAR := GET_ICONA_SUST();
         ASSUMPTIONS:
         LIMITATIONS:
         ALGORITHM:
         NOTES:
      ******************************************************************************/
   begin
      d_nome_icona := 'XXXXXXXXXXXXXX';
      begin
         select icona
           into d_nome_icona
           from suddivisioni_struttura
          where ottica = p_ottica
            and livello = p_livello;
      exception
         when no_data_found then
            begin
               d_nome_icona := to_char(null);
            end;
         when too_many_rows then
            begin
               d_nome_icona := to_char(null);
            end;
      end;
      return d_nome_icona;
   end get_icona_sust;
   --
   --
   function get_revisione_m return number is
      d_revisione revisioni_struttura.revisione%type;
      /******************************************************************************
         NAME:       GET_REVISIONE_M
         PURPOSE:    Fornire il codice della revisione in modifica
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
         PARAMETERS:
         INPUT:
         OUTPUT:
         RETURNED VALUE:  VARCHAR
         CALLED BY:
         CALLS:
         EXAMPLE USE:     VARCHAR := GET_REVISIONE_M();
         ASSUMPTIONS:
         LIMITATIONS:
         ALGORITHM:
         NOTES:
      ******************************************************************************/
   begin
      d_revisione := 0;
      begin
         select revisione
           into d_revisione
           from revisioni_struttura
          where stato = 'M'
            and ottica = 'GP4';
      exception
         when no_data_found then
            begin
               d_revisione := to_number(null);
            end;
         when too_many_rows then
            begin
               d_revisione := 99999999;
            end;
      end;
      return d_revisione;
   end get_revisione_m;
   --
   function get_revisione_a return number is
      d_revisione revisioni_struttura.revisione%type;
      /******************************************************************************
         NAME:       GET_REVISIONE_A
         PURPOSE:    Fornire il codice della revisione attiva
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
         PARAMETERS:
         INPUT:
         OUTPUT:
         RETURNED VALUE:  VARCHAR
         CALLED BY:
         CALLS:
         EXAMPLE USE:     VARCHAR := GET_REVISIONE_A();
         ASSUMPTIONS:
         LIMITATIONS:
         ALGORITHM:
         NOTES:
      ******************************************************************************/
   begin
      d_revisione := 0;
      begin
         select revisione
           into d_revisione
           from revisioni_struttura
          where stato = 'A'
            and ottica = 'GP4';
      exception
         when no_data_found then
            begin
               d_revisione := to_char(null);
            end;
         when too_many_rows then
            begin
               d_revisione := to_char(null);
            end;
      end;
      return d_revisione;
   end get_revisione_a;
   --
   function get_revisione_o return number is
      d_revisione revisioni_struttura.revisione%type;
      /******************************************************************************
         NAME:       GET_REVISIONE_O
         PURPOSE:    Fornire il codice dell'ultima revisione obsoleta prima di quella attiva
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
         PARAMETERS:
         INPUT:
         OUTPUT:
         RETURNED VALUE:  VARCHAR
         CALLED BY:
         CALLS:
         EXAMPLE USE:     VARCHAR := GET_REVISIONE_O();
         ASSUMPTIONS:
         LIMITATIONS:
         ALGORITHM:
         NOTES:
      ******************************************************************************/
   begin
      d_revisione := 0;
      begin
         select revisione
           into d_revisione
           from revisioni_struttura
          where stato = 'O'
            and dal = (select max(dal)
                         from revisioni_struttura
                        where ottica = 'GP4'
                          and stato = 'O')
            and ottica = 'GP4';
      exception
         when no_data_found then
            begin
               d_revisione := to_char(null);
            end;
         when too_many_rows then
            begin
               d_revisione := to_char(null);
            end;
      end;
      return d_revisione;
   end get_revisione_o;
   function get_revisione(p_data in date) return number is
      d_revisione revisioni_struttura.revisione%type;
      /******************************************************************************
         NAME:       GET_REVISIONE
         PURPOSE:    Fornire il codice della revisione valida alla data indicata
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        01/10/2003                   1. Created this function.
         PARAMETERS:
         INPUT:
         OUTPUT:
         RETURNED VALUE:  VARCHAR
         CALLED BY:
         CALLS:
         EXAMPLE USE:     VARCHAR := GET_REVISIONE();
         ASSUMPTIONS:
         LIMITATIONS:
         ALGORITHM:
         NOTES:
      ******************************************************************************/
   begin
      d_revisione := 0;
      begin
         select revisione
           into d_revisione
           from revisioni_struttura
          where dal = (select max(dal)
                         from revisioni_struttura
                        where dal <= nvl(p_data, to_date('3333333', 'j'))
                          and stato in ('A', 'O'));
      exception
         when no_data_found then
            begin
               d_revisione := to_number(null);
            end;
         when too_many_rows then
            begin
               d_revisione := to_number(null);
            end;
      end;
      return d_revisione;
   end get_revisione;
   --
   function get_revisione_gest(p_gestione in varchar2) return number is
      d_revisione revisioni_struttura.revisione%type;
      d_max_dal   date;
      /******************************************************************************
         NAME:       GET_REVISIONE_GEST
         PURPOSE:    Fornire il codice dell'ultima revisione attiva
                     od obsoleta nella quale sia trattata la gestione data
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        18/07/2002          1. Created this function.
         PARAMETERS:
         INPUT:
         OUTPUT:
         RETURNED VALUE:  VARCHAR
         CALLED BY:
         CALLS:
         EXAMPLE USE:     VARCHAR := GET_REVISIONE_O();
         ASSUMPTIONS:
         LIMITATIONS:
         ALGORITHM:
         NOTES:
      ******************************************************************************/
   begin
      d_revisione := 0;
      begin
         select max(rest.dal)
           into d_max_dal
           from unita_organizzative unor
               ,revisioni_struttura rest
          where unor.ottica = 'GP4'
            and rest.ottica = unor.ottica
            and rest.revisione = unor.revisione
            and rest.stato in ('A', 'O')
            and unor.ni in
                (select ni from settori_amministrativi where gestione = p_gestione);
         select max(revisione)
           into d_revisione
           from revisioni_struttura
          where ottica = 'GP4'
            and dal = d_max_dal;
      exception
         when no_data_found then
            begin
               d_revisione := to_char(null);
            end;
         when too_many_rows then
            begin
               d_revisione := to_char(null);
            end;
      end;
      return d_revisione;
   end get_revisione_gest;
   --
   procedure pgmcunor
   (
      p_revisione    in varchar2
     ,p_ottica       in varchar2
     ,p_dal          in date
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      d_revisione_m number(8);
      situazione_anomala exception;
   begin
      p_errore      := null;
      d_revisione_m := get_revisione_m;
      if d_revisione_m is null then
         p_errore       := 'P08000'; -- Non esistono revisioni in modifica
         p_segnalazione := si4.get_error(p_errore);
         raise situazione_anomala;
      end if;
      if d_revisione_m = 99999999 then
         p_errore       := 'P08001'; -- Esistono piu di una revisione in stato di modifica
         p_segnalazione := si4.get_error(p_errore);
         raise situazione_anomala;
      end if;
      if p_dal is null then
         p_errore       := 'P08037'; -- Data validita revisione non indicata
         p_segnalazione := si4.get_error(p_errore);
         raise situazione_anomala;
      end if;
      begin
         -- Duplica le UO della revisione modello sulla revisione in modifica
         -- Disattiva temporaneamente l'allineamento di REUO
         si4.sql_execute('alter trigger unor_reuo_tma disable');
         lock table unita_organizzative in exclusive mode nowait;
         lock table relazioni_uo in exclusive mode nowait;
         -- Elimina le registrazioni relative all'attuale revisione in modifica
         delete from anagrafici
          where ni in (select ni
                         from unita_organizzative unor
                        where revisione = d_revisione_m
                          and ottica = 'GP4'
                          and not exists (select 'x'
                                 from unita_organizzative
                                where ni = unor.ni
                                  and ottica = 'GP4'
                                  and revisione <> d_revisione_m))
            and tipo_soggetto = 'S';
         delete from settori_amministrativi
          where ni in (select ni
                         from unita_organizzative unor
                        where revisione = d_revisione_m
                          and ottica = 'GP4'
                          and not exists (select 'x'
                                 from unita_organizzative
                                where ni = unor.ni
                                  and ottica = 'GP4'
                                  and revisione <> d_revisione_m));
         delete from unita_organizzative
          where ottica = 'GP4'
            and revisione = d_revisione_m;
         insert into unita_organizzative
            (ottica
            ,ni
            ,dal
            ,al
            ,descrizione
            ,codice_uo
            ,codice_amministrazione
            ,unita_padre
            ,unita_padre_ottica
            ,unita_padre_dal
            ,tipo
            ,sede
            ,suddivisione
            ,revisione)
            select 'GP4'
                  ,ni
                  ,greatest(p_dal, unor.dal)
                  ,unor.al
                  ,descrizione
                  ,codice_uo
                  ,codice_amministrazione
                  ,unita_padre
                  ,unita_padre_ottica
                  ,p_dal
                  ,'T' -- Tipo Temporaneo
                  ,sede
                  ,suddivisione
                  ,d_revisione_m
              from unita_organizzative unor
             where ottica = p_ottica
               and revisione = p_revisione
               and tipo = 'P'
               and nvl(al, to_date('3333333', 'j')) >= p_dal;
         -- Allinea relazioni_uo e riabilita trigger
         gp4gm.allinea_reuo;
         si4.sql_execute('alter trigger unor_reuo_tma enable');
         commit;
      exception
         when others then
            p_errore       := 'P08061'; -- Lock su UNOR
            p_segnalazione := si4.get_error(p_errore) || ' ' ||
                              'Riprovare piu tardi o contattare il servizio di assistenza';
            raise situazione_anomala;
         
      end;
   exception
      when situazione_anomala then
         rollback;
         si4.sql_execute('alter trigger unor_reuo_tma enable');
   end pgmcunor;
   --
   procedure valida_revisione
   (
      p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      d_revisione_m   number(8);
      d_revisione_a   number(8);
      d_dal_a         date;
      d_data_m        date;
      d_dal_m         date;
      d_descrizione   unita_organizzative.descrizione%type;
      d_codice        settori_amministrativi.codice%type;
      d_dummy         varchar2(1);
      d_riassegnabili number(8);
      d_ci_prec       number(8);
      situazione_anomala exception;
      situazione_errata exception;
   begin
      p_errore := null;
      si4.sql_execute('alter trigger unor_reuo_tma disable');
      lock table revisioni_struttura in exclusive mode nowait;
      lock table unita_organizzative in exclusive mode nowait;
      lock table relazioni_uo in exclusive mode nowait;
      begin
         d_revisione_m := get_revisione_m;
         d_revisione_a := get_revisione_a;
         d_dal_m       := gp4_rest.get_dal_rest_modifica('GP4');
         d_data_m      := gp4_rest.get_data_rest_modifica('GP4');
         d_dal_a       := gp4_rest.get_dal_rest_attiva('GP4');
         if d_revisione_m is null or d_revisione_a is null then
            p_errore       := 'P08000';
            p_segnalazione := si4.get_error(p_errore);
            raise situazione_anomala;
         end if;
         if d_dal_m is null then
            p_errore       := 'P08050';
            p_segnalazione := si4.get_error(p_errore);
            raise situazione_anomala;
         end if;
         begin
            select 'x'
              into d_dummy
              from unita_organizzative
             where ottica = 'GP4'
               and revisione = d_revisione_m;
         exception
            when no_data_found then
               p_errore       := 'P08051';
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            when too_many_rows then
               null;
         end;
         begin
            select 'x' into d_dummy from individui_riassegnabili inri where rownum = 1;
            raise too_many_rows;
         exception
            when no_data_found then
               null;
            when too_many_rows then
               p_errore       := 'P08042';
               p_segnalazione := 'Operazione Interrotta. Validazione della Revisione precedente non completata. ' ||
                                 si4.get_error(p_errore);
               raise situazione_anomala;
         end;
         if d_dal_m > d_data_m then
            /*
               Controllo se esistono periodi di definizione delle UO con decorrenza
               successiva alla DATA e precedente il DAL della revisione che
               stiamo attivando, se la data di attivazione e successiva alla data di
               creazione della revisione in modifica
            */
            begin
               select gp4_stam.get_codice(unor.ni)
                     ,unor.descrizione
                 into d_codice
                     ,d_descrizione
                 from unita_organizzative unor
                where ottica = 'GP4'
                  and revisione = d_revisione_m
                  and dal > d_data_m
                  and dal < d_dal_m
                  and rownum = 1;
            exception
               when no_data_found then
                  null;
               when others then
                  p_errore       := 'P08049';
                  p_segnalazione := si4.get_error(p_errore) || ' Settore Amm.: ' ||
                                    d_codice || ' - ' || d_descrizione;
                  raise situazione_anomala;
            end;
            /*
               Modifico la data DAL delle unita organizzative, ponendola al DAL della
              revisione in fase di attivazione. Vengono modificati anche i riferimenti
              al padre delle UO figlie
            */
            for cur_unor in (select ottica
                                   ,revisione
                                   ,ni
                                   ,dal
                               from unita_organizzative
                              where ottica = 'GP4'
                                and revisione = d_revisione_m
                                and dal < d_dal_m
                              order by ni
                                      ,dal)
            loop
               begin
                  -- Elimino le registrazioni di UNOR della revisione in modifica rese inutili
                  -- da successive storicizzazioni
                  delete from unita_organizzative unor
                   where ni = cur_unor.ni
                     and ottica = cur_unor.ottica
                     and revisione = cur_unor.revisione
                     and dal = cur_unor.dal
                     and exists (select 'x'
                            from unita_organizzative
                           where ni = unor.ni
                             and revisione = unor.revisione
                             and ottica = unor.ottica
                             and dal > unor.dal
                             and dal <= d_dal_m);
                  -- Modifico il dal del nodo della revisione in modifica
                  update unita_organizzative
                     set dal = d_dal_m
                   where ottica = cur_unor.ottica
                     and revisione = cur_unor.revisione
                     and ni = cur_unor.ni
                     and dal = cur_unor.dal;
                  -- Modifico il riferimento al padre degli eventuali figli
                  update unita_organizzative
                     set unita_padre_dal = d_dal_m
                   where unita_padre_ottica = cur_unor.ottica
                     and revisione = cur_unor.revisione
                     and unita_padre = cur_unor.ni
                     and unita_padre_dal = cur_unor.dal;
               end;
            end loop;
         elsif d_dal_m < d_data_m then
            for cur_unor in (select ottica
                                   ,revisione
                                   ,ni
                                   ,dal
                               from unita_organizzative
                              where ottica = 'GP4'
                                and revisione = d_revisione_m
                                and dal = d_data_m
                              order by ni
                                      ,dal)
            loop
               begin
                  -- Elimino le registrazioni di UNOR della revisione in modifica rese inutili
                  -- da successive storicizzazioni
                  delete from unita_organizzative unor
                   where ni = cur_unor.ni
                     and ottica = cur_unor.ottica
                     and revisione = cur_unor.revisione
                     and dal = cur_unor.dal
                     and exists (select 'x'
                            from unita_organizzative
                           where ni = unor.ni
                             and revisione = unor.revisione
                             and ottica = unor.ottica
                             and dal > unor.dal
                             and dal > d_dal_m);
                  -- Modifico il dal del nodo della revisione in modifica
                  update unita_organizzative
                     set dal = d_dal_m
                   where ottica = cur_unor.ottica
                     and revisione = cur_unor.revisione
                     and ni = cur_unor.ni
                     and dal = cur_unor.dal;
                  -- Modifico il riferimento al padre degli eventuali figli
                  update unita_organizzative
                     set unita_padre_dal = d_dal_m
                   where unita_padre_ottica = cur_unor.ottica
                     and revisione = cur_unor.revisione
                     and unita_padre = cur_unor.ni
                     and unita_padre_dal = cur_unor.dal;
               end;
            end loop;
         end if;
         -- else con modifica del dal se l'ni esiste in qualche revisione precedente.
         update unita_organizzative
            set tipo = 'P'
          where ottica = 'GP4'
            and revisione = d_revisione_m;
         update revisioni_struttura
            set stato = 'O'
          where stato = 'A'
            and revisione = d_revisione_a;
         update revisioni_struttura
            set stato = 'A'
          where stato = 'M'
            and revisione = d_revisione_m;
         -- Allinea relazioni_uo e riabilita trigger
         gp4gm.allinea_reuo;
         si4.sql_execute('alter trigger unor_reuo_tma enable');
         -- Controllo per verificare l'esistenza di componenti non presenti sulla vista ANAGRAFE
         begin
            select 'x'
              into d_dummy
              from componenti comp
             where unita_ni in
                   (select ni from unita_organizzative where revisione = d_revisione_a)
               and unita_ottica = 'GP4'
               and nvl(al, to_date(3333333, 'j')) >= d_dal_a
               and not exists (select 'x' from anagrafe where ni = comp.ni);
            raise too_many_rows;
         exception
            when no_data_found then
               null;
            when too_many_rows then
               p_errore       := 'P08052';
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
         end;
         /*
               Replica le registrazioni dei componenti della revisione precedente ancora validi alla data 
               di attivazione della nuova revisione, per mantenere il legame con la chiave primaria di UNOR
               
               Passa nella nuova revisione i periodi di assegnazione componenti completamente
               compresi nella validita della nuova revisione, solo se il settore di assegnazione e esistente
               anche nella nuova revisione
         */
         update componenti
            set unita_dal = gp4_rest.get_dal_rest_attiva('GP4')
               ,utente    = 'Dup.REST'
               ,data_agg  = sysdate
          where unita_ni in
                (select ni from unita_organizzative where revisione = d_revisione_a)
            and unita_ottica = 'GP4'
            and exists (select 'x'
                   from unita_organizzative
                  where ottica = 'GP4'
                    and ni = componenti.unita_ni
                    and dal = gp4_rest.get_dal_rest_attiva('GP4')
                    and revisione = get_revisione_a)
            and dal >= gp4_rest.get_dal_rest_attiva('GP4')
            and al is null;
         /* 
               chiude i periodi di assegnazione componenti la cui validita interseca la validita della nuova revisione 
               solo se il settore di assegnazione e esistente anche nella nuova revisione
               per poi reinserirli con riferimento al settore nellanuova revisione
         */
         update componenti
            set al       = gp4_rest.get_dal_rest_attiva('GP4') - 1
               ,utente   = 'Dup.REST'
               ,data_agg = sysdate
          where unita_ni in
                (select ni from unita_organizzative where revisione = d_revisione_a)
            and unita_ottica = 'GP4'
            and exists (select 'x'
                   from unita_organizzative
                  where ottica = 'GP4'
                    and ni = componenti.unita_ni
                    and dal = gp4_rest.get_dal_rest_attiva('GP4')
                    and revisione = get_revisione_a)
            and dal < gp4_rest.get_dal_rest_attiva('GP4')
            and al is null;
         insert into componenti
            (componente
            ,dal
            ,al
            ,codice_amministrazione
            ,amm_dal
            ,unita_ottica
            ,unita_ni
            ,unita_dal
            ,denominazione
            ,denominazione_al1
            ,denominazione_al2
            ,ni
            ,incarico
            ,titolo
            ,codice_fiscale
            ,telefono
            ,fax
            ,e_mail
            ,utente
            ,data_agg)
            select componente
                  ,gp4_rest.get_dal_rest_attiva('GP4')
                  ,to_date('')
                  ,codice_amministrazione
                  ,amm_dal
                  ,unita_ottica
                  ,unita_ni
                  ,gp4_rest.get_dal_rest_attiva('GP4')
                  ,denominazione
                  ,denominazione_al1
                  ,denominazione_al2
                  ,ni
                  ,incarico
                  ,titolo
                  ,codice_fiscale
                  ,telefono
                  ,fax
                  ,e_mail
                  ,'Dup.REST'
                  ,sysdate
              from componenti comp
             where unita_ni in (select ni
                                  from unita_organizzative
                                 where revisione = gp4gm.get_revisione_a)
               and unita_ottica = 'GP4'
               and dal < gp4_rest.get_dal_rest_attiva('GP4')
               and al = gp4_rest.get_dal_rest_attiva('GP4') - 1
               and not exists
             (select 'x'
                      from componenti
                     where componente = comp.componente
                       and dal = gp4_rest.get_dal_rest_attiva('GP4'));
         /* 
               inserisce i periodi di assegnazione componenti spostati sul setttore con riferimento alla revisione attuale 
                ma che hanno mantenuto la decorrenza originle e futura rispetto alla data di inizio della nuova revisione
               (in pratica inserisce il primo pezzo di assegnazione con dal = inizio revisione e al = vecchia decorrenza -1)
         */
         insert into componenti
            (componente
            ,dal
            ,al
            ,codice_amministrazione
            ,amm_dal
            ,unita_ottica
            ,unita_ni
            ,unita_dal
            ,denominazione
            ,denominazione_al1
            ,denominazione_al2
            ,ni
            ,incarico
            ,titolo
            ,codice_fiscale
            ,telefono
            ,fax
            ,e_mail
            ,utente
            ,data_agg)
            select componente
                  ,gp4_rest.get_dal_rest_attiva('GP4')
                  ,dal - 1
                  ,codice_amministrazione
                  ,amm_dal
                  ,unita_ottica
                  ,unita_ni
                  ,gp4_rest.get_dal_rest_attiva('GP4')
                  ,denominazione
                  ,denominazione_al1
                  ,denominazione_al2
                  ,ni
                  ,incarico
                  ,titolo
                  ,codice_fiscale
                  ,telefono
                  ,fax
                  ,e_mail
                  ,'Dup.REST'
                  ,sysdate
              from componenti comp
             where unita_ni in (select ni
                                  from unita_organizzative
                                 where revisione = gp4gm.get_revisione_a)
               and unita_ottica = 'GP4'
               and dal > gp4_rest.get_dal_rest_attiva('GP4');
         begin
            select 'x'
              into d_dummy
              from individui_riassegnabili inri
             where exists (select 'x'
                      from rapporti_giuridici
                     where ci = inri.ci
                       and flag_elab in (select 'P'
                                           from dual
                                         union
                                         select 'E'
                                           from dual
                                         union
                                         select 'C' from dual))
               and rownum = 1;
            raise too_many_rows;
         exception
            when no_data_found then
               null;
            when too_many_rows then
               p_errore       := 'P08041';
               p_segnalazione := si4.get_error(p_errore) ||
                                 '. Operazione Interrotta. Eliminare le selezioni per il calcolo';
               raise situazione_anomala;
         end;
         d_riassegnabili := 0;
         d_ci_prec       := 0;
         for inri in (select ragi.ci
                            ,ragi.flag_elab
                        from individui_riassegnabili inri
                            ,rapporti_giuridici      ragi
                       where ragi.ci = inri.ci
                       order by ragi.ci)
         loop
            begin
               if d_ci_prec <> inri.ci then
                  /* Verifico se l'individuo e in fase di calcolo cedolino */
                  begin
                     select 'x'
                       into d_dummy
                       from dual
                      where inri.flag_elab in ('P', 'E', 'C');
                  exception
                     when no_data_found then
                        null;
                     when too_many_rows then
                        p_errore       := 'P08041';
                        p_segnalazione := si4.get_error(p_errore) ||
                                          '. Operazione Interrotta. Eliminare le selezioni per il calcolo';
                        raise situazione_anomala;
                  end;
                  d_riassegnabili := d_riassegnabili + 1;
                  -- incremento il contatore dei riassegnabili
                  /* Blocco Giuridico del rassegnabile */
                  update rapporti_giuridici set flag_elab = 'B' where ci = inri.ci;
               end if;
               d_ci_prec := inri.ci;
            end;
         end loop;
         /*         spezza i periodi giuridici a cavallo della data di attivazione per i settori che hanno cambiato codice
         */
         if nvl(gp4_ente.get_dividi_pegi_in_validazione, 'NO') = 'SI' then
            d_dal_a := gp4_rest.get_dal_rest_attiva('GP4');
            for cur_spezza in (select ci
                                     ,rilevanza
                                     ,dal
                                     ,al
                                     ,evento
                                     ,settore
                                     ,sede
                                 from periodi_giuridici pegi
                                where rilevanza in ('Q', 'S', 'I', 'E')
                                  and d_dal_a between dal and
                                      nvl(al, to_date(3333333, 'j'))
                                  and gp4_unor.get_codice_uo(gp4_stam.get_ni_numero(pegi.settore)
                                                            ,'GP4'
                                                            ,d_dal_a) <>
                                      gp4_unor.get_codice_uo(gp4_stam.get_ni_numero(pegi.settore)
                                                            ,'GP4'
                                                            ,d_dal_a - 1))
            loop
               gp4gm.set_assegnazione(cur_spezza.ci
                                     ,cur_spezza.rilevanza
                                     ,cur_spezza.dal
                                     ,cur_spezza.settore
                                     ,cur_spezza.sede
                                     ,cur_spezza.evento
                                     ,''
                                     ,''
                                     ,''
                                     ,''
                                     ,p_errore
                                     ,p_segnalazione);
            end loop;
         end if;
         if d_riassegnabili > 0 then
            p_errore       := 'P08042';
            p_segnalazione := si4.get_error(p_errore) || ' <n.' || d_riassegnabili || '>';
         end if;
      exception
         when situazione_anomala then
            raise situazione_errata;
         when others then
            p_errore       := 'P08061'; -- Lock su UNOR
            p_segnalazione := si4.get_error(p_errore) || ' ' ||
                              'Riprovare piu tardi o contattare il servizio di assistenza';
            raise situazione_errata;
      end;
   exception
      when situazione_errata then
         rollback;
         si4.sql_execute('alter trigger unor_reuo_tma enable');
   end valida_revisione;
   --
   procedure set_assegnazione
   (
      p_ci               in number
     ,p_rilevanza        in varchar2
     ,p_dal              in date
     ,p_num_settore_dest in number
     ,p_num_sede         in number
     ,p_evento           in varchar2
     ,p_note             in varchar2
     ,p_sede_del         in varchar2
     ,p_anno_del         in number
     ,p_numero_del       in number
     ,p_errore           out varchar2
     ,p_segnalazione     out varchar2
   ) is
      d_dal_revisione date;
      d_al_pegi       date;
      d_chk           varchar2(1);
      d_sede          sedi_amministrative.numero%type;
      situazione_anomala exception;
   begin
      p_errore        := null;
      d_dal_revisione := gp4_rest.get_dal_rest_attiva('GP4');
      dbms_output.put_line('Dal revisione :' || d_dal_revisione);
      if p_rilevanza = 'S' or p_rilevanza = 'E' then
         if p_num_sede is not null then
            begin
               select 'x'
                 into d_chk
                 from ripartizioni_funzionali
                where settore = p_num_settore_dest
                  and sede = nvl(p_num_sede, 0);
            exception
               when no_data_found then
                  p_errore       := 'P04042';
                  p_segnalazione := si4.get_error(p_errore) || ' CI :' || p_ci ||
                                    ' dal :' || to_char(p_dal, 'dd/mm/yyyy') || ' sett. ' ||
                                    p_num_settore_dest || ' sede. ' || nvl(p_num_sede, 0);
                  raise situazione_anomala;
            end;
         else
            /* Verifichiamo se il settore di destinazione prevede la sede contabile 0 */
            begin
               select 0
                 into d_sede
                 from ripartizioni_funzionali rifu
                where settore = p_num_settore_dest
                  and sede = 0;
            exception
               when no_data_found then
                  begin
                     select sede
                       into d_sede
                       from periodi_giuridici
                      where ci = p_ci
                        and rilevanza = p_rilevanza
                        and dal = p_dal;
                  exception
                     when no_data_found then
                        begin
                           select decode(p_rilevanza
                                        ,'S'
                                        ,'P04237'
                                        ,'E'
                                        ,'P04237'
                                        ,'P04247')
                             into p_errore
                             from dual;
                           p_segnalazione := si4.get_error(p_errore) || ' CI :' || p_ci ||
                                             ' dal :' || to_char(p_dal, 'dd/mm/yyyy') ||
                                             ' sett. ' || p_num_settore_dest || ' sede. ' ||
                                             nvl(p_num_sede, 0);
                           raise situazione_anomala;
                        end;
                  end;
            end;
            dbms_output.put_line('d_sede :' || d_sede);
            begin
               select 'x'
                 into d_chk
                 from ripartizioni_funzionali
                where settore = p_num_settore_dest
                  and sede = nvl(d_sede, 0);
            exception
               when no_data_found then
                  p_errore       := 'P04042';
                  p_segnalazione := si4.get_error(p_errore) || ' CI :' || p_ci ||
                                    ' dal :' || to_char(p_dal, 'dd/mm/yyyy') || ' sett. ' ||
                                    p_num_settore_dest || ' sede' || nvl(d_sede, 0);
                  raise situazione_anomala;
            end;
         end if;
      end if;
      dbms_output.put_line('Dal :' || p_dal);
      dbms_output.put_line('rilevanza :' || p_rilevanza);
      if p_dal < d_dal_revisione then
         begin
            select al
              into d_al_pegi
              from periodi_giuridici
             where ci = p_ci
               and rilevanza = p_rilevanza
               and dal = p_dal;
         exception
            when no_data_found then
               begin
                  select decode(p_rilevanza, 'S', 'P04237', 'E', 'P04237', 'P04247')
                    into p_errore
                    from dual;
                  p_segnalazione := si4.get_error(p_errore) || ' CI : ' || p_ci ||
                                    ' dal : ' || to_char(p_dal, 'dd/mm/yyyy');
                  raise situazione_anomala;
               end;
         end;
         update periodi_giuridici
            set al = d_dal_revisione - 1
          where ci = p_ci
            and rilevanza = p_rilevanza
            and dal = p_dal;
         dbms_output.put_line('ci :' || p_ci);
         dbms_output.put_line('Dal :' || p_dal);
         dbms_output.put_line('Nuovo Dal :' || d_dal_revisione);
         dbms_output.put_line('rilevanza :' || p_rilevanza);
         dbms_output.put_line('Al :' || d_al_pegi);
         dbms_output.put_line('settore :' || p_num_settore_dest);
         insert into periodi_giuridici
            (ci
            ,rilevanza
            ,dal
            ,al
            ,evento
            ,posizione
            ,tipo_rapporto
            ,sede_posto
            ,anno_posto
            ,numero_posto
            ,posto
            ,sostituto
            ,qualifica
            ,ore
            ,figura
            ,attivita
            ,gestione
            ,settore
            ,sede
            ,gruppo
            ,assenza
            ,confermato
            ,note
            ,note_al1
            ,note_al2
            ,sede_del
            ,anno_del
            ,numero_del
            ,utente
            ,data_agg)
            select ci
                  ,rilevanza
                  ,d_dal_revisione
                  ,d_al_pegi
                  ,p_evento
                  ,posizione
                  ,tipo_rapporto
                  ,sede_posto
                  ,anno_posto
                  ,numero_posto
                  ,posto
                  ,sostituto
                  ,qualifica
                  ,ore
                  ,figura
                  ,attivita
                  ,gestione
                  ,p_num_settore_dest
                  ,decode(rilevanza
                         ,'S'
                         ,decode(d_sede, 0, to_number(null), nvl(p_num_sede, sede))
                         ,'E'
                         ,decode(d_sede, 0, to_number(null), nvl(p_num_sede, sede))
                         ,sede)
                  ,gruppo
                  ,assenza
                  ,confermato
                  ,p_note
                  ,note_al1
                  ,note_al2
                  ,p_sede_del
                  ,p_anno_del
                  ,p_numero_del
                  ,utente
                  ,data_agg
              from periodi_giuridici
             where ci = p_ci
               and rilevanza = p_rilevanza
               and dal = p_dal;
         dbms_output.put_line('eseguito inserimento :' || d_dal_revisione);
      else
         update periodi_giuridici
            set settore = p_num_settore_dest
               ,sede    = decode(rilevanza
                                ,'S'
                                ,decode(d_sede, 0, to_number(null), nvl(p_num_sede, sede))
                                ,'E'
                                ,decode(d_sede, 0, to_number(null), nvl(p_num_sede, sede))
                                ,sede)
          where ci = p_ci
            and rilevanza = p_rilevanza
            and dal = p_dal;
      end if;
      update rapporti_giuridici
         set flag_elab = ''
       where ci = p_ci
         and flag_elab = 'B'
         and not exists -- Aggiunto controllo che serve ad evitare che il flag sia sbloccato
       (select 'x' -- in presenza di altri periodi da sistemare
                from individui_riassegnabili
               where ci = p_ci);
   exception
      when situazione_anomala then
         rollback;
   end set_assegnazione;
   --
   procedure crea_organigramma
   (
      p_gestione     in varchar2
     ,p_rilevanza    in varchar2
     ,p_data         in date
     ,p_revisione    in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      d_ci_padre        periodi_giuridici.ci%type;
      d_ci_responsabile periodi_giuridici.ci%type;
      situazione_anomala exception;
      connect_by_loop_detected exception;
      pragma exception_init(connect_by_loop_detected, -1436);
   begin
      p_errore       := null;
      p_segnalazione := null;
      begin
         /* pulizia preventiva della tabella di appoggio */
         delete from organigramma;
      end;
      /* determino il responsabile della gestione */
      d_ci_responsabile := get_ci_responsabile_uo(gp4_stam.get_ni(p_gestione)
                                                 ,gp4_unor.get_dal(gp4_stam.get_ni(p_gestione)));
      if d_ci_responsabile is null then
         p_errore       := 'P08003';
         p_segnalazione := si4.get_error(p_errore) || ' : ' || p_gestione;
         raise situazione_anomala;
      end if;
      dbms_output.put_line('Responsabile Gestione : ' || d_ci_responsabile);
      insert into organigramma
         (unita
         ,unita_padre
         ,ci
         ,ci_padre
         ,ci_responsabile
         ,sequenza)
      values
         (gp4_stam.get_ni(p_gestione)
         ,0
         ,d_ci_responsabile
         ,0
         ,d_ci_responsabile
         ,0);
      for sust in (select livello
                     from suddivisioni_struttura
                    where ottica = 'GP4'
                    order by sequenza)
      loop
         dbms_output.put_line('Suddivisione : ' || sust.livello);
         for unor in (select ni
                            ,dal
                            ,unita_padre
                        from unita_organizzative
                       where revisione = p_revisione
                         and ottica = 'GP4'
                         and gp4_stam.get_gestione(ni) = p_gestione
                         and dal = gp4_unor.get_dal(ni)
                         and suddivisione = sust.livello
                       order by ni)
         loop
            /* determiniamo le informazioni del responsabile della UO */
            d_ci_responsabile := get_ci_responsabile_uo(unor.ni, unor.dal);
            if gp4_unor.get_livello(unor.ni, 'GP4', unor.dal) > 0 then
               begin
                  select ci_responsabile
                    into d_ci_padre
                    from organigramma
                   where unita = unor.unita_padre
                     and nvl(ci, ci_padre) = ci_responsabile;
               exception
                  when no_data_found then
                     dbms_output.put_line('Dipendente anomalo: ' || unor.ni || ' ' ||
                                          unor.unita_padre || ' ' || d_ci_responsabile || ' ' ||
                                          d_ci_responsabile);
                     raise situazione_anomala;
               end;
               dbms_output.put_line('Responsabile : ' || unor.ni || ' ' ||
                                    unor.unita_padre || ' 0 ' || d_ci_responsabile || ' ' ||
                                    d_ci_padre);
               if d_ci_padre = d_ci_responsabile then
                  d_ci_responsabile := to_number(null);
               end if;
               insert into organigramma
                  (unita
                  ,unita_padre
                  ,ci
                  ,ci_padre
                  ,ci_responsabile
                  ,sequenza)
               values
                  (unor.ni
                  ,unor.unita_padre
                  ,d_ci_responsabile
                  ,d_ci_padre
                  ,nvl(d_ci_responsabile, d_ci_padre)
                  ,2);
            end if;
            for pegi in (select ci
                           from periodi_giuridici pegi
                          where rilevanza = p_rilevanza
                            and p_data between dal and nvl(al, to_date(3333333, 'j'))
                            and settore = gp4_stam.get_numero(unor.ni)
                            and not exists
                          (select 'x'
                                   from organigramma
                                  where ci = pegi.ci
                                    and unita = (select ni
                                                   from settori_amministrativi
                                                  where numero = pegi.settore)))
            loop
               /* inseriamo i dipendenti della UO */
               dbms_output.put_line('Dipendente : ' || unor.ni || ' ' ||
                                    unor.unita_padre || ' ' || pegi.ci || ' ' ||
                                    nvl(d_ci_responsabile, 0) || ' ' || d_ci_padre);
               if pegi.ci <> nvl(d_ci_responsabile, d_ci_padre) then
                  insert into organigramma
                     (unita
                     ,unita_padre
                     ,ci
                     ,ci_padre
                     ,ci_responsabile
                     ,sequenza)
                  values
                     (unor.ni
                     ,unor.unita_padre
                     ,pegi.ci
                     ,nvl(d_ci_responsabile, d_ci_padre)
                     ,d_ci_responsabile
                     ,3);
               end if;
            end loop;
         end loop;
      end loop;
      /*
      BEGIN
        d_chk := 0;
        FOR CHK_ORG in
          (select unita
                ,unita_padre
                ,ci_padre
                   ,ci_responsabile
                   ,ci
               from organigramma
              start with ci_padre= d_ci_responsabile
            connect by prior ci                          = ci_padre
         ) LOOP
             d_chk := CHK_ORG.CI;
           END LOOP;
      EXCEPTION WHEN connect_by_loop_detected THEN
                    p_errore       := 'P08038';
                   p_segnalazione := si4.get_error(p_errore)||' Cod.Ind.: '||d_chk;
      END;
      */
      --    commit;
   exception
      when situazione_anomala then
         dbms_output.put_line('anomala');
         rollback;
   end crea_organigramma;
   --
   procedure get_non_assegnati(c_non_assegnati in out non_assegnati) is
   begin
      open c_non_assegnati for
         select ci
               ,rilevanza
               ,pegi.dal
               ,pegi.al
               ,gp4_unor.get_codice_uo(stam.ni, 'GP4', pegi.al)
               ,figi.codice
           from periodi_giuridici      pegi
               ,settori_amministrativi stam
               ,figure_giuridiche      figi
          where rilevanza in (select 'Q'
                                from dual
                              union
                              select 'S'
                                from dual
                              union
                              select 'I'
                                from dual
                              union
                              select 'E' from dual)
            and nvl(pegi.al, to_date(3333333, 'j')) >=
                gp4_rest.get_dal_rest_attiva('GP4')
            and not exists
          (select 'x'
                   from unita_organizzative unor
                  where ni =
                        (select ni from settori_amministrativi where numero = pegi.settore)
                    and unor.ottica = 'GP4'
                    and unor.revisione = gp4gm.get_revisione_a)
            and exists
          (select 'x'
                   from unita_organizzative unor
                  where ni =
                        (select ni from settori_amministrativi where numero = pegi.settore)
                    and unor.ottica = 'GP4'
                    and unor.revisione = gp4gm.get_revisione_o)
            and stam.numero = pegi.settore
            and figi.numero = pegi.figura
            and nvl(pegi.al, to_date(3333333, 'j')) between figi.dal and
                nvl(figi.al, to_date(3333333, 'j'));
   end get_non_assegnati;
   --
   procedure muovi_nodo
   (
      p_ottica           in varchar2
     ,p_revisione        in number
     ,p_ni               in number
     ,p_ni_padre_old     in number
     ,p_dal_padre_old    in date
     ,p_ni_padre_new     in number
     ,p_suddivisione_old in varchar2
     ,p_suddivisione_new in varchar2
     ,p_errore           out varchar2
     ,p_segnalazione     out varchar2
   ) is
      /******************************************************************************
         NAME:       MUOVI_NODO
         PURPOSE:    Modifica il padre del nodo indicato, cambiando la struttura gerarchica delle
                     unita organizzative
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        13/08/2002          1. Created this function.
         NOTES:
      ******************************************************************************/
      d_revisione_m revisioni_struttura.revisione%type;
      situazione_anomala exception;
      d_appoggio varchar2(1);
   begin
      /* Determino la revisione in modifica */
      d_revisione_m := get_revisione_m;
      if d_revisione_m is null then
         p_errore       := 'P08000'; -- Non esistono revisioni in modifica
         p_segnalazione := si4.get_error(p_errore);
         --       raise situazione_anomala;
      end if;
      if d_revisione_m = 99999999 then
         p_errore       := 'P08001'; -- Esistono piu di una revisione in stato di modifica
         p_segnalazione := si4.get_error(p_errore);
         --       raise situazione_anomala;
      end if;
      if p_suddivisione_new is null then
         p_errore       := 'P08059'; -- suddivisione successiva non definita
         p_segnalazione := si4.get_error(p_errore);
         raise situazione_anomala;
      end if;
      begin
         select 'x'
           into d_appoggio
           from unita_organizzative
          where ni = p_ni_padre_new
            and ottica = p_ottica
            and revisione = p_revisione
            and dal = decode(p_revisione
                            ,get_revisione_a
                            ,gp4_unor.get_dal(p_ni_padre_new)
                            ,get_revisione_m
                            ,gp4_unor.get_dal_m(p_ni_padre_new)
                            ,to_date(null));
      exception
         when no_data_found then
            p_errore       := 'P08009'; -- Non esiste padre sotto cui appendere.....
            p_segnalazione := si4.get_error(p_errore);
            raise situazione_anomala;
      end;
      /* Determino la revisione in modifica */
      /* Individuo il livello di profondita della suddivisione di struttura */
      update unita_organizzative
         set unita_padre  = p_ni_padre_new
            ,suddivisione = p_suddivisione_new
       where ni = p_ni
         and ottica = p_ottica
         and revisione = p_revisione
         and unita_padre = p_ni_padre_old
         and unita_padre_ottica = p_ottica
            --   and unita_padre_dal    = p_dal_padre_old
         and suddivisione = p_suddivisione_old;
      --modifico la suddivisione dei figli
      update unita_organizzative
         set suddivisione = gp4_sust.get_suddivisione(gp4_sust.get_livello(suddivisione) +
                                                      (gp4_sust.get_livello(p_suddivisione_new) -
                                                       gp4_sust.get_livello(p_suddivisione_old)))
       where ni in (select ni
                      from unita_organizzative
                     where ottica = p_ottica
                       and revisione = p_revisione
                       and dal = p_dal_padre_old
                     start with unita_padre = p_ni
                    connect by prior ni = unita_padre
                           and ottica = unita_padre_ottica
                           and dal = unita_padre_dal);
      commit;
   exception
      when situazione_anomala then
         rollback;
   end muovi_nodo;
   --
   procedure elimina_nodo
   (
      p_ottica       in varchar2
     ,p_ni           in number
     ,p_dal          in date
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      d_revisione_m revisioni_struttura.revisione%type;
      situazione_anomala exception;
      d_appoggio varchar2(1);
   begin
      d_revisione_m := get_revisione_m;
      if d_revisione_m is null then
         p_errore       := 'P08000'; -- Non esistono revisioni in modifica
         p_segnalazione := si4.get_error(p_errore);
         raise situazione_anomala;
      end if;
      if d_revisione_m = 99999999 then
         p_errore       := 'P08001'; -- Esistono piu di una revisione in stato di modifica
         p_segnalazione := si4.get_error(p_errore);
         raise situazione_anomala;
      end if;
      /* Controllo di esistenza del nodo selezionato */
      begin
         select 'x'
           into d_appoggio
           from unita_organizzative
          where ni = p_ni
            and ottica = p_ottica
            and dal = p_dal
            and revisione = d_revisione_m;
      exception
         when no_data_found then
            p_errore       := 'P08011'; -- Non esistono il nodo da eliminare
            p_segnalazione := si4.get_error(p_errore);
            raise situazione_anomala;
      end;
      /* Eliminazione del nodo selezionato */
      /* Verifica della necessita di cancellare anche il settore amministrativo */
      begin
         select 'x'
           into d_appoggio
           from unita_organizzative
          where ni = p_ni
            and ottica = p_ottica
            and revisione <> d_revisione_m;
      exception
         when too_many_rows then
            null;
         when no_data_found then
            /* Il settore amministrativo e stato creato nell'ambito di questa revisione
            e quindi va cancellato  */
            delete from settori_amministrativi where ni = p_ni;
      end;
      delete from unita_organizzative
       where ottica = p_ottica
         and ni = p_ni
         and dal = p_dal
         and revisione = d_revisione_m;
      commit;
   exception
      when situazione_anomala then
         rollback;
   end elimina_nodo;
   --
   procedure chk_revisione_m
   (
      p_revisione    in number
     ,p_ottica       in varchar2
     ,p_errore       out varchar2
     ,p_segnalazione out varchar2
   ) is
      /******************************************************************************
         NAME:       CHK_REVISIONE_M
         PURPOSE:    Controlla l'esistenza di differenze tra la revisione attiva (che deve essere duplicata) e
                     la revisione in modifica; da eseguire prima della cancellazione del contenuto della
                  revisione in modifica, per salvaguardare le modifiche manuali eseguite dopo una precedente
                  operazione di copia.
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        10/09/2002          1. Created this function.
      ******************************************************************************/
      cursor cpk_revisione is(
         select codice_uo || unita_padre || unita_padre_ottica || descrizione || settore ||
                settore_unita || sede || suddivisione
           from unita_organizzative
          where revisione = get_revisione_m
            and ottica = 'GP4'
         minus
         select codice_uo || unita_padre || unita_padre_ottica || descrizione || settore ||
                settore_unita || sede || suddivisione
           from unita_organizzative
          where revisione = p_revisione
            and ottica = p_ottica)
         union (select codice_uo || unita_padre || unita_padre_ottica || descrizione ||
                       settore || settore_unita || sede || suddivisione
                  from unita_organizzative
                 where revisione = p_revisione
                   and ottica = p_ottica
                minus
                select codice_uo || unita_padre || unita_padre_ottica || descrizione ||
                       settore || settore_unita || sede || suddivisione
                  from unita_organizzative
                 where revisione = get_revisione_m
                   and ottica = 'GP4');
      d_revisione_m number(8);
      w_dummy       varchar2(100);
      app           varchar2(1);
      found         boolean;
      situazione_anomala exception;
   begin
      p_errore := to_char(null);
      w_dummy  := to_char(null);
      begin
         select revisione into d_revisione_m from revisioni_struttura where stato = 'M';
      exception
         when no_data_found then
            begin
               p_errore       := 'P08001'; -- Non esistono revisioni in modifica
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end;
         when too_many_rows then
            begin
               p_errore       := 'P08002'; -- Esistono piu di una revisione in stato di modifica
               p_segnalazione := si4.get_error(p_errore);
               raise situazione_anomala;
            end;
      end;
      begin
         select 'x'
           into app
           from unita_organizzative
          where revisione = gp4gm.get_revisione_m;
         raise too_many_rows;
      exception
         when too_many_rows then
            begin
               -- controllo di identita tra la revisione M e la revisione modello
               open cpk_revisione;
               fetch cpk_revisione
                  into w_dummy;
               found := cpk_revisione%found;
               close cpk_revisione;
               if found then
                  p_errore       := 'P08035';
                  p_segnalazione := si4.get_error(p_errore);
               end if;
            end;
         when no_data_found then
            null;
      end;
   exception
      when situazione_anomala then
         rollback;
   end chk_revisione_m;
   --
   procedure svuota
   (
      p_livello  in number
     ,p_gestione in varchar2
   ) is
      d_revisione_m revisioni_struttura.revisione%type;
      situazione_anomala exception;
      /*************************************************************************
         NAME:       SVUOTA
         PURPOSE:    Procedure che elimina le unita organizzative con revisione
                     in modifica al di sotto della gestione data al di sopra di un certo
                     livello richiesto
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        05/11/2004
         1.1        21/03/2005            MM  Ottimizzate le prestazioni, spostando
                                             l'esecuzione della  gp4gm.get_revisione_m
                                       e della gp4_sust.get_livello
      **************************************************************************/
   begin
      d_revisione_m := gp4gm.get_revisione_m;
      si4.sql_execute('alter trigger unor_reuo_tma disable');
      lock table revisioni_struttura in exclusive mode nowait;
      lock table unita_organizzative in exclusive mode nowait;
      lock table relazioni_uo in exclusive mode nowait;
      -- Elimina le registrazioni relative all'attuale revisione in modifica
      for sust in -- determina le suddivisioni di struttura da eliminare
       (select livello
          from suddivisioni_struttura
         where gp4_sust.get_livello(livello) >= p_livello
         order by sequenza desc)
      loop
         for cancella in (select ni
                            from unita_organizzative unor
                           where suddivisione = sust.livello
                             and revisione = d_revisione_m
                             and ottica = 'GP4'
                             and exists (select 'x'
                                    from settori_amministrativi
                                   where ni = unor.ni
                                     and gestione = p_gestione))
         loop
            begin
               delete from anagrafici
                where ni = cancella.ni
                  and tipo_soggetto = 'S'
                  and not exists (select 'x'
                         from unita_organizzative
                        where ni = cancella.ni
                          and ottica = 'GP4'
                          and revisione <> d_revisione_m);
               delete unita_organizzative unor
                where suddivisione = sust.livello
                  and revisione = d_revisione_m
                  and ni = cancella.ni;
               delete from settori_amministrativi
                where ni = cancella.ni
                  and not exists (select 'x'
                         from unita_organizzative
                        where ni = cancella.ni
                          and ottica = 'GP4'
                          and revisione <> d_revisione_m);
            end;
         end loop;
      end loop;
      -- Allinea relazioni_uo e riabilita trigger
      gp4gm.allinea_reuo;
      si4.sql_execute('alter trigger unor_reuo_tma enable');
   end svuota;
   procedure allinea_settori(p_gestione in varchar2) is
      /******************************************************************************
         NAME:       ALLINEA_SETTORI
         PURPOSE:    Procedure di allineamento tra la vista settori_view e la tabella settori
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        20/02/2003                  1. Created this function.
      ******************************************************************************/
      d_gestione             varchar2(4);
      settori_view_not_exist number;
      settori_not_exist      number;
   begin
      settori_view_not_exist := 0;
      settori_not_exist      := 0;
      d_gestione             := p_gestione;
      integritypackage.nextnestlevel;
      if d_gestione is null then
         --         DBMS_OUTPUT.put_line ('la gestione e nulla');
         delete settori;
         --         DBMS_OUTPUT.put_line ('ho cancellato settori');
         insert into settori
            (codice
            ,descrizione
            ,descrizione_al1
            ,descrizione_al2
            ,numero
            ,sequenza
            ,suddivisione
            ,gestione
            ,settore_g
            ,settore_a
            ,settore_b
            ,settore_c
            ,assegnabile
            ,sede
            ,cod_reg)
            (select codice
                   ,substr(descrizione, 1, 30)
                   ,substr(descrizione_al1, 1, 30)
                   ,substr(descrizione_al2, 1, 30)
                   ,numero
                   ,sequenza
                   ,suddivisione
                   ,gestione
                   ,settore_g
                   ,settore_a
                   ,settore_b
                   ,settore_c
                   ,assegnabile
                   ,sede
                   ,cod_reg
               from settori_view);
      else
         --         DBMS_OUTPUT.put_line ('la gestione e ' || d_gestione);
         select count(*)
           into settori_not_exist
           from (select numero
                   from settori_view
                 minus
                 select numero from settori);
         select count(*)
           into settori_view_not_exist
           from (select numero
                   from settori
                 minus
                 select numero from settori_view);
         if (settori_not_exist > 0) or (settori_view_not_exist > 0) then
            if settori_not_exist > 0 then
               insert into settori
                  (codice
                  ,descrizione
                  ,descrizione_al1
                  ,descrizione_al2
                  ,numero
                  ,sequenza
                  ,suddivisione
                  ,gestione
                  ,settore_g
                  ,settore_a
                  ,settore_b
                  ,settore_c
                  ,assegnabile
                  ,sede
                  ,cod_reg)
                  select codice
                        ,substr(descrizione, 1, 30)
                        ,substr(descrizione_al1, 1, 30)
                        ,substr(descrizione_al2, 1, 30)
                        ,numero
                        ,sequenza
                        ,suddivisione
                        ,gestione
                        ,settore_g
                        ,settore_a
                        ,settore_b
                        ,settore_c
                        ,assegnabile
                        ,sede
                        ,cod_reg
                    from settori_view
                   where numero in (select numero
                                      from settori_view
                                    minus
                                    select numero from settori);
            end if;
            if settori_view_not_exist > 0 then
               delete settori
                where numero in (select numero
                                   from settori
                                 minus
                                 select numero from settori_view);
            end if;
         else
            for gest in (select codice
                               ,descrizione
                               ,descrizione_al1
                               ,descrizione_al2
                               ,numero
                               ,sequenza
                               ,suddivisione
                               ,gestione
                               ,settore_g
                               ,settore_a
                               ,settore_b
                               ,settore_c
                               ,assegnabile
                               ,sede
                               ,cod_reg
                           from settori_view
                          where gestione = d_gestione)
            loop
               update settori
                  set --CODICE = GEST.CODICE
                        descrizione = substr(gest.descrizione, 1, 30)
                     ,descrizione_al1 = substr(gest.descrizione_al1, 1, 30)
                     ,descrizione_al2 = substr(gest.descrizione_al2, 1, 30)
                      --,NUMERO = GEST.NUMERO
                     ,sequenza     = gest.sequenza
                     ,suddivisione = least(gest.suddivisione, 4)
                     ,gestione     = gest.gestione
                     ,settore_g    = gest.settore_g
                     ,settore_a    = gest.settore_a
                     ,settore_b    = gest.settore_b
                     ,settore_c    = gest.settore_c
                     ,assegnabile  = gest.assegnabile
                     ,sede         = gest.sede
                     ,cod_reg      = gest.cod_reg
                where gestione = d_gestione
                  and codice = gest.codice;
            end loop;
         end if;
      end if;
      integritypackage.previousnestlevel;
   end allinea_settori;
   --
   --
   procedure update_devgi
   (
      p_posizione in varchar2
     ,p_codice    in varchar2
     ,p_rowid     in varchar2
   ) is
      /******************************************************************************
         NAME:       UPDATE_DEVGI
         PURPOSE:    Procedure di allineamento tra le posizioni di DEVGI e quelle di PEGI
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        05/01/2005   CB               1. Created this function.
      ******************************************************************************/
      app         varchar2(20);
      w_dal_post  date;
      w_al_post   date;
      w_evento    varchar2(20);
      w_posizione varchar2(20);
      form_trigger_failure exception;
   begin
      if p_posizione is not null then
         begin
            select 'x'
              into app
              from eventi_giuridici evgi
             where evgi.rowid = p_rowid
               and nvl(evgi.posizione, 'XXX') != p_posizione;
            for rec_evgi1 in (select ci
                                    ,evgi.codice
                                    ,evgi.posizione
                                    ,pegi.dal
                                    ,pegi.al
                                from eventi_giuridici  evgi
                                    ,periodi_giuridici pegi
                               where pegi.evento = evgi.codice
                                 and evgi.codice = p_codice
                               order by ci
                                       ,pegi.dal)
            loop
               begin
                  begin
                     update periodi_giuridici
                        set posizione = p_posizione
                      where ci = rec_evgi1.ci
                        and evento = rec_evgi1.codice
                        and dal = rec_evgi1.dal;
                  end;
                  w_dal_post := rec_evgi1.dal;
                  w_al_post  := rec_evgi1.al;
                  while w_dal_post is not null
                  loop
                     begin
                        select pegi.evento
                              ,pegi.posizione
                              ,pegi.dal
                              ,pegi.al
                          into w_evento
                              ,w_posizione
                              ,w_dal_post
                              ,w_al_post
                          from periodi_giuridici pegi
                              ,eventi_giuridici  evgi
                         where evgi.codice = pegi.evento
                           and ci = rec_evgi1.ci
                           and dal = w_al_post + 1
                           and evgi.posizione is null;
                        raise too_many_rows;
                     exception
                        when no_data_found then
                           w_evento    := '';
                           w_posizione := '';
                           w_dal_post  := to_date(null);
                        when too_many_rows then
                           begin
                              update periodi_giuridici pegi
                                 set posizione = p_posizione
                               where ci = rec_evgi1.ci
                                 and dal = w_dal_post
                                 and evento = w_evento
                                 and posizione = w_posizione;
                              if sql%notfound then
                                 w_dal_post := to_date(null);
                              end if;
                           exception
                              when others then
                                 null;
                           end;
                     end;
                  end loop;
               end;
            end loop;
         exception
            when no_data_found then
               null;
            when others then
               null;
         end;
      end if;
      integritypackage.previousnestlevel;
   end update_devgi;
   --
   procedure allinea_reuo is
      /******************************************************************************
         NAME:       ALLINEA_REUO
         PURPOSE:    Procedure di allineamento di RELAZIONI_UO con UNITA_ORGANIZZATIVE
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        03/02/2005  MM
         2.0        24/01/2006  MM               Attivata su tutte le revisione (A14413)
         3.0        24/10/2006  MM               Nuovi campi sequenza,descrizione,livello (A17716)
         3.1        26/01/2007  MM               Modifica al primo loop (A4442)
      ******************************************************************************/
   begin
      for rest in (select rest.revisione
                         ,max(unor.dal) dal
                         ,max(rest.data) data
                     from revisioni_struttura rest
                         ,unita_organizzative unor
                    where unor.revisione = rest.revisione
                    group by rest.revisione)
      loop
         delete from relazioni_uo where revisione = rest.revisione;
         for sett in (select stam.ni
                            ,unor.codice_uo codice
                            ,unor.suddivisione
                            ,unor.revisione
                            ,stam.gestione
                            ,stam.sequenza sequenza_padre
                            ,unor.descrizione descrizione_padre
                            ,gp4_sust.get_livello(unor.suddivisione) livello_padre
                        from unita_organizzative    unor
                            ,settori_amministrativi stam
                       where unor.revisione = rest.revisione
                         and unor.ottica = 'GP4'
                         and nvl(rest.dal, rest.data) between unor.dal and
                             nvl(unor.al, to_date(3333333, 'j'))
                         and stam.ni = unor.ni)
         loop
            for cur_unor in (select sett.revisione
                                   ,sett.gestione
                                   ,sett.ni padre
                                   ,sett.codice codice_padre
                                   ,sett.suddivisione suddivisione_padre
                                   ,unor.ni figlio
                                   ,unor.codice_uo codice_figlio
                                   ,unor.suddivisione suddivisione_figlio
                                   ,gp4_stam.get_sequenza(unor.ni) sequenza_figlio
                                   ,unor.descrizione descrizione_figlio
                                   ,gp4_sust.get_livello(unor.suddivisione) livello_figlio
                               from unita_organizzative unor
                              where unor.ottica = 'GP4'
                                and unor.revisione = sett.revisione
                                and nvl(rest.dal, rest.data) between unor.dal and
                                    nvl(unor.al, to_date(3333333, 'j'))
                              start with unor.ni = sett.ni
                                     and unor.ottica = 'GP4'
                                     and unor.revisione = sett.revisione
                             connect by prior unor.ni = unor.unita_padre
                                    and unor.ottica = 'GP4'
                                    and unor.revisione = sett.revisione)
            loop
               insert into relazioni_uo
                  (revisione
                  ,gestione
                  ,padre
                  ,codice_padre
                  ,suddivisione_padre
                  ,figlio
                  ,codice_figlio
                  ,suddivisione_figlio
                  ,sequenza_figlio
                  ,sequenza_padre
                  ,descrizione_figlio
                  ,descrizione_padre
                  ,livello_figlio
                  ,livello_padre)
                  select cur_unor.revisione
                        ,cur_unor.gestione
                        ,cur_unor.padre
                        ,cur_unor.codice_padre
                        ,cur_unor.suddivisione_padre
                        ,cur_unor.figlio
                        ,cur_unor.codice_figlio
                        ,cur_unor.suddivisione_figlio
                        ,cur_unor.sequenza_figlio
                        ,sett.sequenza_padre
                        ,cur_unor.descrizione_figlio
                        ,sett.descrizione_padre
                        ,cur_unor.livello_figlio
                        ,sett.livello_padre
                    from dual
                   where not exists
                   (select 'x'
                            from relazioni_uo
                           where revisione = cur_unor.revisione
                             and gestione = cur_unor.gestione
                             and padre = cur_unor.padre
                             and codice_padre = cur_unor.codice_padre
                             and suddivisione_padre = cur_unor.suddivisione_padre
                             and figlio = cur_unor.figlio
                             and codice_figlio = cur_unor.codice_figlio
                             and suddivisione_figlio = cur_unor.suddivisione_figlio);
            end loop;
         end loop;
      end loop;
   end allinea_reuo;
   --
   procedure aggiorna_reuo
   (
      p_new_figlio    in number
     ,p_old_figlio    in number
     ,p_new_padre     in number
     ,p_old_padre     in number
     ,p_new_revisione in number
     ,p_old_revisione in number
     ,p_operazione    in varchar2
   ) is
      /******************************************************************************
         NAME:       AGGIORNA_REUO
         PURPOSE:    Richiamata dal trigger UNOR_REUO_TMA
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        24/01/2007  MM
      ******************************************************************************/
      d_rest_dal  date;
      d_rest_data date;
      d_revisione revisioni_struttura.revisione%type;
      d_data      date;
   begin
      d_revisione := nvl(p_new_revisione, p_old_revisione);
      /*      dbms_output.put_line('NEW REVISIONE : ' || p_new_revisione);
            dbms_output.put_line('OLD REVISIONE : ' || p_old_revisione);
            dbms_output.put_line('    REVISIONE : ' || d_revisione);
      */
      if p_operazione = 'I' then
         select max(unor.dal) dal
               ,max(rest.data) data
           into d_rest_dal
               ,d_rest_data
           from revisioni_struttura rest
               ,unita_organizzative unor
          where rest.revisione = d_revisione
            and unor.revisione = d_revisione;
         d_data := nvl(d_rest_dal, d_rest_data);
         dbms_output.put_line('    DATA : ' || d_data);
         for sett in (select stam.ni
                            ,unor.codice_uo codice
                            ,unor.suddivisione
                            ,unor.revisione
                            ,stam.gestione
                            ,stam.sequenza sequenza_padre
                            ,unor.descrizione descrizione_padre
                            ,gp4_sust.get_livello(unor.suddivisione) livello_padre
                        from unita_organizzative    unor
                            ,settori_amministrativi stam
                       where unor.revisione = d_revisione
                         and unor.ottica = 'GP4'
                         and d_data between unor.dal and
                             nvl(unor.al, to_date(3333333, 'j'))
                         and stam.ni = unor.ni
                         and unor.ni in
                             (p_new_figlio, p_old_figlio, p_new_padre, p_old_padre))
         loop
            delete from relazioni_uo
             where revisione = d_revisione
               and padre = sett.ni;
            /*            dbms_output.put_line('NEW PADRE : ' || sett.codice);
            */
            for cur_unor in (select sett.revisione
                                   ,sett.gestione
                                   ,sett.ni padre
                                   ,sett.codice codice_padre
                                   ,sett.suddivisione suddivisione_padre
                                   ,unor.ni figlio
                                   ,unor.codice_uo codice_figlio
                                   ,unor.suddivisione suddivisione_figlio
                                   ,gp4_stam.get_sequenza(unor.ni) sequenza_figlio
                                   ,unor.descrizione descrizione_figlio
                                   ,gp4_sust.get_livello(unor.suddivisione) livello_figlio
                               from unita_organizzative unor
                              where unor.ottica = 'GP4'
                                and unor.revisione = d_revisione
                                and d_data between unor.dal and
                                    nvl(unor.al, to_date(3333333, 'j'))
                              start with unor.ni = sett.ni
                                     and unor.ottica = 'GP4'
                                     and unor.revisione = d_revisione
                             connect by prior unor.ni = unor.unita_padre
                                    and unor.ottica = 'GP4'
                                    and unor.revisione = d_revisione)
            loop
               /*               dbms_output.put_line('    NEW FIGLI : ' || cur_unor.codice_figlio);
               */
               insert into relazioni_uo
                  (revisione
                  ,gestione
                  ,padre
                  ,codice_padre
                  ,suddivisione_padre
                  ,figlio
                  ,codice_figlio
                  ,suddivisione_figlio
                  ,sequenza_figlio
                  ,sequenza_padre
                  ,descrizione_figlio
                  ,descrizione_padre
                  ,livello_figlio
                  ,livello_padre)
                  select cur_unor.revisione
                        ,cur_unor.gestione
                        ,cur_unor.padre
                        ,cur_unor.codice_padre
                        ,cur_unor.suddivisione_padre
                        ,cur_unor.figlio
                        ,cur_unor.codice_figlio
                        ,cur_unor.suddivisione_figlio
                        ,cur_unor.sequenza_figlio
                        ,sett.sequenza_padre
                        ,cur_unor.descrizione_figlio
                        ,sett.descrizione_padre
                        ,cur_unor.livello_figlio
                        ,sett.livello_padre
                    from dual
                   where not exists
                   (select 'x'
                            from relazioni_uo
                           where revisione = cur_unor.revisione
                             and gestione = cur_unor.gestione
                             and padre = cur_unor.padre
                             and codice_padre = cur_unor.codice_padre
                             and suddivisione_padre = cur_unor.suddivisione_padre
                             and figlio = cur_unor.figlio
                             and codice_figlio = cur_unor.codice_figlio
                             and suddivisione_figlio = cur_unor.suddivisione_figlio);
            end loop;
         end loop;
      elsif p_operazione = 'D' then
         delete from relazioni_uo
          where revisione = p_old_revisione
            and figlio = p_old_figlio;
      end if;
   end aggiorna_reuo;
   --
   procedure continuato
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_dal       in date
     ,p_dal_old   date
   ) is
      /******************************************************************************
         NAME:       CONTINUATO
         PURPOSE:    Procedure di duplica su attributi_giuridici se su codici_attributo
                     e attivo il flag "continuato" alla creazione di un periodo
                     consecutivo su pegi di rilevanza I o Q
         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        22/06/2005  CB
      ******************************************************************************/
      p_atgi_id number;
   begin
      for cur in (select atgi_id
                        ,ci
                        ,rilevanza
                        ,dal
                        ,coat_id
                        ,note
                        ,sede_del
                        ,anno_del
                        ,numero_del
                        ,utente
                        ,data_agg
                    from attributi_giuridici atgi
                   where rilevanza = p_rilevanza
                     and ci = p_ci
                     and dal = p_dal_old
                     and exists (select 'x'
                            from codici_attributo coat
                           where coat.coat_id = atgi.coat_id
                             and coat.continuato = 'SI'))
      loop
         begin
            begin
               select atgi_sq.nextval into p_atgi_id from dual;
            end;
            insert into attributi_giuridici
               (atgi_id
               ,ci
               ,rilevanza
               ,dal
               ,coat_id
               ,note
               ,sede_del
               ,anno_del
               ,numero_del
               ,utente
               ,data_agg)
            values
               (p_atgi_id
               ,cur.ci
               ,cur.rilevanza
               ,p_dal
               ,cur.coat_id
               ,cur.note
               ,cur.sede_del
               ,cur.anno_del
               ,cur.numero_del
               ,cur.utente
               ,cur.data_agg);
            for cur_v in (select atgi_id
                                ,vaat_id
                                ,valore
                                ,utente
                                ,data_agg
                            from valori_attributi_giuridici vatg
                           where vatg.atgi_id = cur.atgi_id)
            loop
               begin
                  insert into valori_attributi_giuridici
                     (atgi_id
                     ,vaat_id
                     ,valore
                     ,utente
                     ,data_agg)
                  values
                     (p_atgi_id
                     ,cur_v.vaat_id
                     ,cur_v.valore
                     ,cur_v.utente
                     ,cur_v.data_agg);
               end;
            end loop;
         end;
      end loop;
   end continuato;
   --
   function astensione_sostituita
   (
      p_ci        in number
     ,p_rilevanza in varchar2
     ,p_dal       in date
   ) return varchar2 is
      d_sostituita       varchar2(2) := 'NS';
      d_ore_sostituite   number;
      d_ore_sostituibili number;
      d_al               date;
      non_coperta exception;
      /******************************************************************************
         NAME:       ASTENSIONE_SOSTITUITA
         PURPOSE:    Verifica se l'astensione data e completamente sostituita
      ******************************************************************************/
   begin
      begin
         begin
         
            select nvl(al, to_date(3333333, 'j'))
              into d_al
              from periodi_giuridici
             where ci = p_ci
               and rilevanza = p_rilevanza
               and dal = p_dal;
         
            select ore_sostituibili
              into d_ore_sostituibili
              from sostituzioni_giuridiche
             where titolare = p_ci
               and rilevanza_astensione = p_rilevanza
               and dal_astensione = p_dal
               and rownum = 1;
         
            raise too_many_rows;
         
         exception
            when no_data_found then
               return d_sostituita;
            when too_many_rows then
               for chk in (select p_dal data_chk
                             from dual
                           union
                           select d_al
                             from dual
                           union
                           select distinct dal
                             from sostituzioni_giuridiche
                            where titolare = p_ci
                              and rilevanza_astensione = p_rilevanza
                              and dal_astensione = p_dal
                              and dal >= p_dal
                           union
                           select distinct nvl(al, to_date(3333333, 'j'))
                             from sostituzioni_giuridiche
                            where titolare = p_ci
                              and rilevanza_astensione = p_rilevanza
                              and dal_astensione = p_dal
                              and nvl(al, to_date(3333333, 'j')) <= d_al
                           union
                           select distinct dal - 1
                             from sostituzioni_giuridiche
                            where titolare = p_ci
                              and rilevanza_astensione = p_rilevanza
                              and dal_astensione = p_dal
                              and dal - 1 >= p_dal
                           union
                           select distinct nvl(al + 1, to_date(3333333, 'j'))
                             from sostituzioni_giuridiche
                            where titolare = p_ci
                              and rilevanza_astensione = p_rilevanza
                              and dal_astensione = p_dal
                              and nvl(al + 1, to_date(3333333, 'j')) <= d_al)
               loop
                  select sum(nvl(ore_sostituzione, 0))
                    into d_ore_sostituite
                    from sostituzioni_giuridiche
                   where titolare = p_ci
                     and rilevanza_astensione = p_rilevanza
                     and dal_astensione = p_dal
                     and chk.data_chk between dal and nvl(al, to_date(3333333, 'j'));
                  if nvl(d_ore_sostituite, 0) <> d_ore_sostituibili then
                     raise non_coperta;
                  end if;
               end loop;
               d_sostituita := 'TS';
               return d_sostituita;
         end;
      exception
         when non_coperta then
            d_sostituita := 'PS';
            return d_sostituita;
      end;
   end astensione_sostituita;
   --
   function get_gg_certificato
   (
      p_dal in date
     ,p_al  in date
   ) return number is
      /******************************************************************************
         NAME:       GG_CERTIFICATO
         PURPOSE:    Dato un periodo calcola i giorni considerando i mesi di 30
                     +/- i giorni del primo e dell'ultimo mese.
                     Questo tipo di calcolo serve per evitare che la "ritrasformazione"
                     in anni/mesi/giorni determini un numero di giorni <= 30
      ******************************************************************************/
      giorni number;
   begin
      select decode(to_char(p_al, 'mmyyyy')
                   ,to_char(p_dal, 'mmyyyy')
                   ,(p_al - p_dal) + 1
                   ,trunc(months_between(last_day(p_al + 1), last_day(p_dal))) * 30 -
                    decode(to_char(p_dal, 'dd')
                          ,'01'
                          ,0
                          ,least(to_char(last_day(p_dal), 'dd')
                                ,decode(to_char(last_day(p_dal), 'dd')
                                       ,28
                                       ,to_char(to_date(p_dal) + 1, 'dd')
                                       ,29
                                       ,to_char(to_date(p_dal), 'dd')
                                       ,30
                                       ,to_char(to_date(p_dal) - 1, 'dd')
                                       ,to_char(to_date(p_dal) - 2, 'dd')))) +
                    decode(to_char(last_day(p_al), 'dd')
                          ,to_char(to_date(p_al), 'dd')
                          ,0
                          ,least(to_char(last_day(p_al), 'dd')
                                ,to_char(to_date(p_al), 'dd')))) gg_calc
        into giorni
        from dual;
      return(giorni);
   end get_gg_certificato;
   --
end gp4gm;
/
