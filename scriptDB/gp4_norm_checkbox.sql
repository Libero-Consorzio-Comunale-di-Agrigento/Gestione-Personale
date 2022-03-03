-- Tabella Posizioni

update posizioni 
   set TIPO_DETERMINATO = 'NO'
 where TIPO_DETERMINATO is null
/
update posizioni 
   set UNIVERSITARIO = 'NO'
 where UNIVERSITARIO is null
/
update posizioni 
   set COLLABORATORE = 'NO'
 where COLLABORATORE is null
/

-- Tabella DENUNCIA_O1_INPS

update DENUNCIA_O1_INPS
   set TEMPO_PIENO = 'NO'
 where TEMPO_PIENO is null
/
update DENUNCIA_O1_INPS
   set TEMPO_DETERMINATO = 'NO'
 where TEMPO_DETERMINATO is null
/
update DENUNCIA_O1_INPS
   set TRASF_RAPPORTO = 'NO'
 where TRASF_RAPPORTO is null
/        

-- Tabella FIGURE_GIURIDICHE

update FIGURE_GIURIDICHE
   set CERT_QUA = 'NO'
 where CERT_QUA is null
/        

-- Tabella VOCI_CONTABILI_EVENTO

update VOCI_CONTABILI_EVENTO
   set PART_TIME = 'NO'
 where PART_TIME is null
/        



