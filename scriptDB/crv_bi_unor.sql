CREATE OR REPLACE VIEW VISTA_UNITA_ORGANIZZATIVE AS
SELECT   unor.revisione
        ,MAX (rest.stato) stato_revisione
        ,MAX (rest.dal) decorrenza_revisione
        ,MAX (rest.sede_del) sede_del_revisione
        ,MAX (rest.anno_del) anno_del_revisione
        ,MAX (rest.numero_del) numero_del_revisione
        ,MAX (rest.descrizione) descrizione_revisione
        ,unor.ni ni_unita_organizzative
        ,stam.numero numero_settore
        ,MAX (unor.codice_uo) codice_unita_organizzative
        ,MAX (unor.descrizione) descr_unita_organizzative
        ,MAX (stam.denominazione) definizione_settore
        ,MAX (stam.sequenza) sequenza_settore
        ,MAX (unor.suddivisione) sudd_unita_organizzative
        ,MAX (stam.gestione) gestione
        ,MAX (reuo.livello_figlio)  livello
        ,MAX (reuo.livello_padre) livello_padre
        ,MAX (DECODE (reuo.livello_padre, 0, reuo.codice_padre, '') ) codice_uo_padre_liv_0
        ,MAX (DECODE (reuo.livello_padre, 0, reuo.padre, '') ) ni_uo_padre_liv_0
        ,MAX (DECODE (reuo.livello_padre, 0, reuo.descrizione_padre, '') ) descr_uo_padre_liv_0
        ,MAX (DECODE (reuo.livello_padre, 0, reuo.sequenza_padre, '') ) seque_uo_padre_liv_0
        ,MAX (DECODE (reuo.livello_padre, 1, reuo.codice_padre, '') ) codice_uo_padre_liv_1
        ,MAX (DECODE (reuo.livello_padre, 1, reuo.padre, '') ) ni_uo_padre_liv_1
        ,MAX (DECODE (reuo.livello_padre, 1, reuo.descrizione_padre, '') ) descr_uo_padre_liv_1
        ,MAX (DECODE (reuo.livello_padre, 1, reuo.sequenza_padre, '') ) seque_uo_padre_liv_1
        ,MAX (DECODE (reuo.livello_padre, 2, reuo.codice_padre, '') ) codice_uo_padre_liv_2
        ,MAX (DECODE (reuo.livello_padre, 2, reuo.padre, '') ) ni_uo_padre_liv_2
        ,MAX (DECODE (reuo.livello_padre, 2, reuo.descrizione_padre, '') ) descr_uo_padre_liv_2
        ,MAX (DECODE (reuo.livello_padre, 2, reuo.sequenza_padre, '') ) seque_uo_padre_liv_2
        ,MAX (DECODE (reuo.livello_padre, 3, reuo.codice_padre, '') ) codice_uo_padre_liv_3
        ,MAX (DECODE (reuo.livello_padre, 3, reuo.padre, '') ) ni_uo_padre_liv_3
        ,MAX (DECODE (reuo.livello_padre, 3, reuo.descrizione_padre, '') ) descr_uo_padre_liv_3
        ,MAX (DECODE (reuo.livello_padre, 3, reuo.sequenza_padre, '') ) seque_uo_padre_liv_3
        ,MAX (DECODE (reuo.livello_padre, 4, reuo.codice_padre, '') ) codice_uo_padre_liv_4
        ,MAX (DECODE (reuo.livello_padre, 4, reuo.padre, '') ) ni_uo_padre_liv_4
        ,MAX (DECODE (reuo.livello_padre, 4, reuo.descrizione_padre, '') ) descr_uo_padre_liv_4
        ,MAX (DECODE (reuo.livello_padre, 4, reuo.sequenza_padre, '') ) seque_uo_padre_liv_4
        ,MAX (DECODE (reuo.livello_padre, 5, reuo.codice_padre, '') ) codice_uo_padre_liv_5
        ,MAX (DECODE (reuo.livello_padre, 5, reuo.padre, '') ) ni_uo_padre_liv_5
        ,MAX (DECODE (reuo.livello_padre, 5, reuo.descrizione_padre, '') ) descr_uo_padre_liv_5
        ,MAX (DECODE (reuo.livello_padre, 5, reuo.sequenza_padre, '') ) seque_uo_padre_liv_5
        ,MAX (DECODE (reuo.livello_padre, 6, reuo.codice_padre, '') ) codice_uo_padre_liv_6
        ,MAX (DECODE (reuo.livello_padre, 6, reuo.padre, '') ) ni_uo_padre_liv_6
        ,MAX (DECODE (reuo.livello_padre, 6, reuo.descrizione_padre, '') ) descr_uo_padre_liv_6
        ,MAX (DECODE (reuo.livello_padre, 6, reuo.sequenza_padre, '') ) seque_uo_padre_liv_6
        ,MAX (DECODE (reuo.livello_padre, 7, reuo.codice_padre, '') ) codice_uo_padre_liv_7
        ,MAX (DECODE (reuo.livello_padre, 7, reuo.padre, '') ) ni_uo_padre_liv_7
        ,MAX (DECODE (reuo.livello_padre, 7, reuo.descrizione_padre, '') ) descr_uo_padre_liv_7
        ,MAX (DECODE (reuo.livello_padre, 7, reuo.sequenza_padre, '') ) seque_uo_padre_liv_7
        ,MAX (DECODE (reuo.livello_padre, 8, reuo.codice_padre, '') ) codice_uo_padre_liv_8
        ,MAX (DECODE (reuo.livello_padre, 8, reuo.padre, '') ) ni_uo_padre_liv_8
        ,MAX (DECODE (reuo.livello_padre, 8, reuo.descrizione_padre, '') ) descr_uo_padre_liv_8
        ,MAX (DECODE (reuo.livello_padre, 8, reuo.sequenza_padre, '') ) seque_uo_padre_liv_8
        ,MAX (stam.assegnabile) assegnabile
    FROM unita_organizzative unor
        ,settori_amministrativi stam
        ,revisioni_struttura rest
        ,relazioni_uo reuo
   WHERE unor.ni = reuo.figlio
     AND unor.ni = stam.ni
     AND unor.revisione = reuo.revisione
     AND rest.revisione = unor.revisione
GROUP BY unor.revisione
        ,unor.ni
        ,stam.numero
/
