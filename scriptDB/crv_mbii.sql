create or replace force view movimenti_bilancio_inail
(anno, gestione, divisione, sezione, tipo_ipn, funzionale, risorsa_intervento, impegno, anno_impegno, sub_impegno, anno_sub_impegno, cdc, ruolo, capitolo, articolo, conto, importo, imponibile, nr_voci, importo_previsto, imponibile_previsto, importo_regolazione, imponibile_regolazione, importo_presunto, imponibile_presunto)
as
select trei.anno
      ,trei.gestione
      ,trei.gestione
      ,trei.gestione
      ,trei.tipo_ipn
      ,trei.funzionale
      ,trei.risorsa_intervento
      ,trei.impegno
      ,trei.anno_impegno
      ,trei.sub_impegno
      ,trei.anno_sub_impegno
      ,trei.cdc
      ,trei.ruolo
      ,trei.capitolo
      ,trei.articolo
      ,trei.conto
      ,trei.premio
      ,trei.imponibile
      ,1
      ,decode(trei.tipo_ipn, 'P', trei.premio, 0) importo_previsto
      ,decode(trei.tipo_ipn, 'P', trei.imponibile, 0) imponibile_previsto
      ,peccrein.calcolo_regolazione(trei.anno-1
                                   ,'P'
                                   ,trei.gestione
                                   ,trei.funzionale
                                   ,trei.cdc
                                   ,trei.ruolo
                                   ,trei.capitolo
                                   ,trei.articolo
                                   ,trei.conto
                                   ,trei.risorsa_intervento
                                   ,trei.impegno
                                   ,trei.anno_impegno
                                   ,trei.sub_impegno
                                   ,trei.anno_sub_impegno
                                   ,trei.codice_siope) importo_regolazione
      ,peccrein.calcolo_regolazione(trei.anno-1
                                   ,'I'
                                   ,trei.gestione
                                   ,trei.funzionale
                                   ,trei.cdc
                                   ,trei.ruolo
                                   ,trei.capitolo
                                   ,trei.articolo
                                   ,trei.conto
                                   ,trei.risorsa_intervento
                                   ,trei.impegno
                                   ,trei.anno_impegno
                                   ,trei.sub_impegno
                                   ,trei.anno_sub_impegno
                                   ,trei.codice_siope) imponibile_regolazione
      ,peccrein.calcolo_presunto(trei.anno
                                ,'P'
                                ,trei.gestione
                                ,trei.funzionale
                                ,trei.cdc
                                ,trei.ruolo
                                ,trei.capitolo
                                ,trei.articolo
                                ,trei.conto
                                ,trei.risorsa_intervento
                                ,trei.impegno
                                ,trei.anno_impegno
                                ,trei.sub_impegno
                                ,trei.anno_sub_impegno
                                ,trei.codice_siope) importo_presunto
      ,peccrein.calcolo_presunto(trei.anno
                                ,'I'
                                ,trei.gestione
                                ,trei.funzionale
                                ,trei.cdc
                                ,trei.ruolo
                                ,trei.capitolo
                                ,trei.articolo
                                ,trei.conto
                                ,trei.risorsa_intervento
                                ,trei.impegno
                                ,trei.anno_impegno
                                ,trei.sub_impegno
                                ,trei.anno_sub_impegno
                                ,trei.codice_siope) imponibile_presunto
  from totali_retribuzioni_inail trei
/

