/*  Registrazione Cliente sulla Base Dati: 
    --------------------------------------
    - Modifica ente su AD4
    - Inserimento Ente su GP4
*/ 


PROMPT Argomento 1 = Codice Cliente
PROMPT           2 = Codice Ente di provenienza (A00)
PROMPT           3 = Codice Ente di installazione (AD4)

-- Inserimento in A00 con valori fissi
insert into a_enti (ente, descrizione)
select '&3'
     , 'Ente '||upper(ltrim(rtrim(replace('&2','_'))))
  from dual
 where not exists ( select 'x'
                      from a_enti
                     where ente = '&3'
                  )
;

-- Aggiorna la descrizione in A00 se l'ente di provenienza è già esistente
update a_enti x
   set descrizione = (select nvl(max(descrizione),x.descrizione)
                        from a_enti
                       where ente = upper(ltrim(rtrim(replace('&2','_'))))
                     )
 where ente = '&3'
;

-- Insert preventiva (poco probabile) in AD4 nel caso di installazione con Ente diverso da ente già presente
insert into ad4_enti (ente, descrizione)
select '&3'
     , 'Ente '||upper(ltrim(rtrim(replace('&2','_'))))
  from dual
 where not exists ( select 'x'
                      from ad4_enti
                     where ente = '&3'
                  )
;

-- Update per identificazione Cliente in caso di Ente già presente
update ad4_enti x
   set note = 'Cliente=&1' 
     , descrizione = (select nvl(max(descrizione),x.descrizione)
                        from a_enti
                       where ente = '&3'
                     )
 where ente = '&3'
   and nvl(instr(note,'Cliente='),0) = 0
;
