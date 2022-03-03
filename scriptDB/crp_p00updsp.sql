create or replace package p00updsp is
   /******************************************************************************
    NOME:        p00updsp
    DESCRIZIONE: Modifica i valori del nome file e della lunghezza record per invio file multipli
    
    Rev. Data       Autore Descrizione
    ---- ---------- ------ --------------------------------------------------------
    1.0  06/04/2007 MM     Prima Emissione
   ******************************************************************************/
   s_num_caratteri_primario a_selezioni.valore_default%type;
   s_nome_file_primario     a_selezioni.valore_default%type;
   function versione return varchar2;
   procedure main
   (
      prenotazione in number
     ,passo        in number
   );
end;
/
create or replace package body p00updsp is
   function versione return varchar2 is
   begin
      return 'V1.0 del 06/04/2007';
   end versione;
   procedure main
   (
      prenotazione in number
     ,passo        in number
   ) is
      d_primo_passo   a_passi_proc.passo%type;
      d_ultimo_passo  a_passi_proc.passo%type;
      d_nome_file     a_selezioni.valore_default%type;
      d_num_caratteri varchar2(20);
      d_voce_menu     a_selezioni.voce_menu%type;
      parametri_incompleti exception;
   begin
      select voce_menu
        into d_voce_menu
        from a_prenotazioni
       where no_prenotazione = prenotazione;
      /*        determina primo e ultimo passo procedurale della voce di menù in cui viene lanciato il
                package per ordinare le operazioni da eseguire  
      */
      begin
         select min(passo)
               ,max(passo)
           into d_primo_passo
               ,d_ultimo_passo
           from a_passi_proc
          where voce_menu = d_voce_menu
            and modulo = 'P00UPDSP';
      
      exception
         when no_data_found or too_many_rows then
            raise parametri_incompleti;
      end;
      if passo = d_primo_passo then
         -- duplica valori principali a sequenza 99 per ripristino finale
         begin
            select valore_default
              into s_nome_file_primario
              from a_selezioni
             where voce_menu = d_voce_menu
               and parametro = 'TXTFILE';
         
            select valore_default
              into s_num_caratteri_primario
              from a_selezioni
             where voce_menu = d_voce_menu
               and parametro = 'NUM_CARATTERI';
         
         exception
            when no_data_found or too_many_rows then
               raise parametri_incompleti;
         end;
      
         -- modifica dei valori di default per il passo specifico
         begin
            select valore_default
              into d_nome_file
              from a_selezioni
             where voce_menu = d_voce_menu
               and lunghezza = -passo
               and parametro = 'TXTFILE' || -passo;
         
            select valore_default
              into d_num_caratteri
              from a_selezioni
             where voce_menu = d_voce_menu
               and lunghezza = -passo
               and parametro = 'NUM_CARATTERI' || -passo;
         exception
            when no_data_found or too_many_rows then
               raise parametri_incompleti;
         end;
         d_nome_file     := d_nome_file;
         d_num_caratteri := d_num_caratteri;
      
      elsif passo = d_ultimo_passo then
         -- ripristino ai valori principali
         d_nome_file     := s_nome_file_primario;
         d_num_caratteri := s_num_caratteri_primario;
      else
         -- modifica dei valori di default per il passo specifico
         begin
            select valore_default
              into d_nome_file
              from a_selezioni
             where voce_menu = d_voce_menu
               and lunghezza = -passo
               and parametro = 'TXTFILE' || -passo;
         
            select valore_default
              into d_num_caratteri
              from a_selezioni
             where voce_menu = d_voce_menu
               and lunghezza = -passo
               and parametro = 'NUM_CARATTERI' || -passo;
         exception
            when no_data_found or too_many_rows then
               raise parametri_incompleti;
         end;
         d_nome_file     := d_nome_file;
         d_num_caratteri := d_num_caratteri;
      end if;
      update a_selezioni
         set valore_default = d_nome_file
       where parametro = 'TXTFILE'
         and voce_menu = d_voce_menu;
      update a_selezioni
         set valore_default = d_num_caratteri
       where parametro = 'NUM_CARATTERI'
         and voce_menu = d_voce_menu;
      update a_prenotazioni
         set errore = 'P05808'
       where no_prenotazione = prenotazione
         and exists (select 'x'
                from a_appoggio_stampe
               where no_prenotazione = prenotazione
                 and no_passo = d_ultimo_passo);
      commit;
   exception
      when parametri_incompleti then
         update a_prenotazioni
            set errore = 'Parametri Incompleti'
          where no_prenotazione = prenotazione
            and exists (select 'x'
                   from a_appoggio_stampe
                  where no_prenotazione = prenotazione
                    and no_passo = d_ultimo_passo);
         commit;
   end;
end;
/
