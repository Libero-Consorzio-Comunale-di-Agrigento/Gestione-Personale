-- prima create per sicurezza
create table sodo_ante_A19187 as select * from SOTTOCODICI_DOCUMENTO;
create table adog_ante_A19187 as select * from archivio_documenti_giuridici;

DECLARE
V_update varchar2(2) := 'SI';

BEGIN
  BEGIN
  select 'NO'
    into V_update
    from dual
   where exists ( select 'x'
                    from obj
                   where object_name = 'SODO_ANTE_19187'
                );
  EXCEPTION WHEN NO_DATA_FOUND THEN
      V_update := 'SI';
  END;
  IF V_update = 'SI' THEN
-- seconda create per sicurezza e update
     si4.sql_execute('create table sodo_ante_19187 as select * from SOTTOCODICI_DOCUMENTO');

     update SOTTOCODICI_DOCUMENTO
        set nota_n3 = nota_a1
          , nota_n4 = nota_a2
      where evento = 'SCON'
        and ( ( nota_n3 is null
            and nota_a1 is not null
              )
           or ( nota_n4 is null
            and nota_a2 is not null
              )
            );
     update SOTTOCODICI_DOCUMENTO
        set nota_a1 = ''
          , nota_a2 = ''
      where evento = 'SCON'
        and ( ( nota_n3 is not null
            and nota_a1 is not null
              )
           or ( nota_n4 is not null
            and nota_a2 is not null
              )
            );
  END IF;

  BEGIN
  select 'NO'
    into V_update
    from dual
   where exists ( select 'x'
                    from obj
                   where object_name = 'ADOG_ANTE_19187'
                );
  EXCEPTION WHEN NO_DATA_FOUND THEN
      V_update := 'SI';
  END;
  IF V_update = 'SI' THEN
-- seconda create per sicurezza e update
     si4.sql_execute('create table adog_ante_19187 as select * from archivio_documenti_giuridici');

     update archivio_documenti_giuridici
        set dato_n3 = dato_a1
          , dato_n4 = dato_a2
      where evento = 'SCON'
        and ( ( dato_n3 is null
            and dato_a1 is not null
              )
           or ( dato_n4 is null
            and dato_a2 is not null
              )
            );
     update archivio_documenti_giuridici
        set dato_a1 = ''
          , dato_a2 = ''
      where evento = 'SCON'
        and ( ( dato_n3 is not null
            and dato_a1 is not null
              )
           or ( dato_n4 is not null
            and dato_a2 is not null
              )
            );
  END IF;
END;
/

-- Inserimento codifiche SCON in EVGI e sottocodifiche in SODO se mancanti

insert into EVENTI_GIURIDICI (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, SEQUENZA, DELIBERA, CERTIFICABILE, PRESSO, STATO_SERVIZIO, RILEVANZA, POSIZIONE, UNICO, CONTO_ANNUALE, CERT_SETT, ONAOSI, INPS)
select 'SCON', 'Servizi con onere', null, null, 900, 'NO', 'SI', 'SI', 'SI', 'D', 'INPD', 'NO', null, 'NO', null, null
  from dual
 where not exists ( select 'x' 
                      from eventi_giuridici
                     where codice = 'SCON'
                  );

insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '1', 'Riscatto (ai soli fini cassa pensione)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '1');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '10', 'Ricongiunzione legge 45/90 in sede di pensione (ai soli fini cassa pensione)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '10');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '101', 'Riscatto (ai fini cassa pensione e TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '101');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '102', 'Ricongiunzione art.2 L.29/79 (ai fini cassa pensione e TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '102');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '103', 'Ricongiunzione legge 45/90 (ai fini cassa pensione e TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '103');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '104', 'Riscatto per iscrizione facoltativa (ai fini cassa pensione e TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '104');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '105', 'Ric. Art.2 L.29/79 per iscrizione facoltativa (ai fini cassa pensione e TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '105');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '106', 'Riscatto in sede di pensione (ai fini cassa pensione e TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '106');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '107', 'Ric. Art.2 L.29/79 in sede di pensione (ai fini cassa pensione e TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '107');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '108', 'Riscatto in sede di pensione per iscrizione facoltativa (ai fini cassa pensione e TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '108');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '109', 'Ric. Art.2 L.29/79 in sede di pensione per iscr.facoltativa (ai fini cassa pensione e TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '109');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '110', 'Ricongiunzione legge 45/90 in sede di pensione (ai fini cassa pensione e TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '110');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '2', 'Ricongiunzione art.2 L.29/79 (ai soli fini cassa pensione)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '2');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '201', 'Riscatto (solo ai fini TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '201');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '202', 'Ricongiunzione art.2 L.29/79 (solo ai fini TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '202');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '203', 'Ricongiunzione legge 45/90 (solo ai fini TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '203');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '204', 'Riscatto per iscrizione facoltativa (solo ai fini TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '204');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '205', 'Ric. Art.2 L.29/79 per iscrizione facoltativa (solo ai fini TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '205');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '206', 'Riscatto in sede di pensione (solo ai fini TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '206');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '207', 'Ric. Art.2 L.29/79 in sede di pensione (solo ai fini TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '207');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '208', 'Riscatto in sede di pensione per iscrizione facoltativa (solo ai fini TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '208');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '209', 'Ric. Art.2 L.29/79 in sede di pensione per iscr.facoltativa (solo ai fini TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '209');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '210', 'Ricongiunzione legge 45/90 in sede di pensione (solo ai fini TFS)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '210');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '3', 'Ricongiunzione legge 45/90 (ai soli fini cassa pensione)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '3');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '4', 'Riscatto per iscrizione facoltativa (ai soli fini cassa pensione)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '4');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '5', 'Ric. Art.2 L.29/79 per iscrizione facoltativa (ai soli fini cassa pensione)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '5');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '6', 'Riscatto in sede di pensione (ai soli fini cassa pensione)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '6');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '7', 'Ric. Art.2 L.29/79 in sede di pensione (ai soli fini cassa pensione)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '7');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '8', 'Riscatto in sede di pensione per iscrizione facoltativa (ai soli fini cassa pensione)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '8');
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SCON', '9', 'Ric. Art.2 L.29/79 in sede di pensione per iscr.facoltativa (ai soli fini cassa pensione)', null, null, 'Del', null, null, 'Riferimento', null, null, null, null, null, '...............', null, null, '.......', null, null, 'Anni', null, null, 'Mesi', null, null, null, null, null, null, null, null, 'Giorni', null, null, null, null, null, 'Contr.Unica.So.', null, null, null, null, null
  from dual
 where not exists ( select 'x' from sottocodici_documento
                     where evento = 'SCON'
                       and codice = '9');

-- Inserimento codifiche SSON in EVGI e sottocodifiche in SODO se mancanti

insert into EVENTI_GIURIDICI (CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, SEQUENZA, DELIBERA, CERTIFICABILE, PRESSO, STATO_SERVIZIO, RILEVANZA, POSIZIONE, UNICO, CONTO_ANNUALE, CERT_SETT, ONAOSI, INPS)
select 'SSON', 'Servizi senza onere', null, null, 901, 'NO', 'SI', 'SI', 'SI', 'D', 'INPD', 'NO', null, 'NO', null, null
  from dual
 where not exists ( select 'x' 
                      from eventi_giuridici
                     where codice = 'SSON'
                  );

insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '0', 'Servizio di Istituto (ai soli fini cassa pensione)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '0');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '1', 'Servizio Militare art. 1 legge 274/91 (ai soli fini cassa pensione)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '1');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '10', 'Maternit` con retribuzione ridotta', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore Cont.', null, null, 'Qualifica', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '10');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '100', 'Servizio di Istituto (ai fini cassa pensione e TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '100');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '101', 'Servizio Militare art. 1 legge 274/91 (ai fini cassa pensione e TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '101');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '102', 'Ricongiunzione art. 6 legge 29/79 (ai fini cassa pensione e TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '102');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '104', 'Ricong.D.P.R.1092/73 (ai fini cassa pensione e TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '104');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '105', 'Ricong.L.761/73 (ai fini cassa pensione e TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '105');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '106', 'Servizio Militare a carico dello Stato (ai fini cassa pensione e TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '106');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '11', 'Maternit` in assenza di retribuzione', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '11');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '12', 'Mandati Sindacali', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '12');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '13', 'Mandati Parlamentari', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '13');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '130', 'Ricongiunzione L.523/54 Stato (ai fini cassa pensione e TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '130');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '132', 'Ricongiunzione L.523/54 Cpdel (ai fini cassa pensione e TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '132');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '133', 'Ricongiunzione L.523/54 Cpi (ai fini cassa pensione e TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '133');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '134', 'Ricongiunzione L.523/54 Cpug (ai fini cassa pensione e TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '134');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '135', 'Ricongiunzione L.523/54 Cps (ai fini cassa pensione e TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '135');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '136', 'Serv. Militare art.1 legge 274/91 in sede di pensione (ai fini cassa pensione e TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '136');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '14', 'Formazione Lavoro con iscr. obblig. dopo 01/01/1991', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore Cont.', null, null, 'Qualifica', null, null, 'Motivo cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '14');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '15', 'Formazione Lavoro con iscr. obblig. prima 01/01/1991', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore Cont.', null, null, 'Qualifica', null, null, 'Motivo cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '15');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '16', 'Contribuzione volonataria', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '16');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '17', 'Maternit` art.25 D.Lg.vo n 151/2001', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore Cont.', null, null, 'Qualifica', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '17');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '2', 'Ricongiunzione art. 6 legge 29/79 (ai soli fini cassa pensione)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '2');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '200', 'Servizio di Istituto (ai soli fini TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '200');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '201', 'Servizio Militare art. 1 legge 274/91 (ai soli fini TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '201');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '202', 'Ricongiunzione art. 6 legge 29/79 (ai soli fini TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '202');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '204', 'Ricong.D.P.R.1092/73 (solo ai fini TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '204');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '205', 'Ricong.L.761/73 (solo ai fini TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '205');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '206', 'Servizio Militare a carico dello Stato (ai soli fini TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '206');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '230', 'Ricongiunzione L.523/54 Stato (ai soli fini TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '230');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '232', 'Ricongiunzione L.523/54 Cpdel (ai soli fini TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '232');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '233', 'Ricongiunzione L.523/54 Cpi (ai soli fini TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '233');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '234', 'Ricongiunzione L.523/54 Cpug (ai soli fini TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '234');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '235', 'Ricongiunzione L.523/54 Cps (ai soli fini TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '235');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '236', 'Serv. Militare art.1 legge 274/91 in sede di pensione (ai soli fini TFS)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '236');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '30', 'Ricongiunzione L.523/54 Stato (ai soli fini cassa pensione)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '30');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '32', 'Ricongiunzione L.523/54 Cpdel (ai soli fini cassa pensione)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '32');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '33', 'Ricongiunzione L.523/54 Cpi (ai soli fini cassa pensione)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '33');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '34', 'Ricongiunzione L.523/54 Cpug (ai soli fini cassa pensione)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '34');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '35', 'Ricongiunzione L.523/54 Cps (ai soli fini cassa pensione)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '35');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '36', 'Serv. Militare art.1 legge 274/91 in sede di pensione (ai soli fini cassa pensione)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '36');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '4', 'Ricong.D.P.R.1092/73 (solo ai fini cassa pensione)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '4');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '5', 'Ricong.L.761/73 (solo ai fini cassa pensione)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, 'Ente', null, null, 'Ore', null, null, 'Ore contr.', null, null, 'Qualifica', null, null, 'Motivo Cess.', null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '5');
 
insert into SOTTOCODICI_DOCUMENTO (EVENTO, CODICE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, NOTA_DEL, NOTA_DEL_AL1, NOTA_DEL_AL2, NOTA_DESCRIZIONE, NOTA_DESCRIZIONE_AL1, NOTA_DESCRIZIONE_AL2, NOTA_NUMERO, NOTA_NUMERO_AL1, NOTA_NUMERO_AL2, NOTA_CATEGORIA, NOTA_CATEGORIA_AL1, NOTA_CATEGORIA_AL2, NOTA_PRESSO, NOTA_PRESSO_AL1, NOTA_PRESSO_AL2, NOTA_N1, NOTA_N1_AL1, NOTA_N1_AL2, NOTA_N2, NOTA_N2_AL1, NOTA_N2_AL2, NOTA_A1, NOTA_A1_AL1, NOTA_A1_AL2, NOTA_A2, NOTA_A2_AL1, NOTA_A2_AL2, NOTA_N3, NOTA_N3_AL1, NOTA_N3_AL2, NOTA_A3, NOTA_A3_AL1, NOTA_A3_AL2, NOTA_N4, NOTA_N4_AL1, NOTA_N4_AL2, NOTA_A4, NOTA_A4_AL1, NOTA_A4_AL2)
select 'SSON', '6', 'Servizio Militare a carico dello Stato (ai soli fini cassa pensione)', null, null, null, null, null, 'Servizio', null, null, null, null, null, null, null, null, '.......', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
 from dual
where not exists ( select 'x' from sottocodici_documento
                    where evento = 'SSON'
                      and codice = '6');

start crp_PGPCSCON.sql

WHENEVER SQLERROR EXIT

select to_number('X')
  FROM DUAL
 where not exists ( select 'x' 
                      from obj 
                     where object_name = 'GPX_DOGI'
                  )
/

start crp_gpx_dogi.sql

WHENEVER SQLERROR CONTINUE