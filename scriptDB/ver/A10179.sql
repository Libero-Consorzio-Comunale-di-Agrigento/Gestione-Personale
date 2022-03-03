declare
v_controllo varchar2(2);
v_comando   varchar2(200);
begin
 begin
  select 'SI' 
    into v_controllo
    from dual
   where exists ( select 'x' from obj where object_name = 'DDMA_OLD_V485');
 exception when no_data_found then v_controllo := 'NO';
 end;
 v_comando := null;
 if v_controllo = 'NO' then
    v_comando := 'create table ddma_old_V485 as select * from denuncia_dma';
    si4.sql_execute(v_comando);
    v_comando := 'drop table denuncia_dma';
    si4.sql_execute(v_comando);
     --
     -- Revisione estrazione DENUNCIA_DMA
     --
     delete from estrazione_valori_contabili 
     where estrazione = 'DENUNCIA_DMA';
     delete from estrazione_righe_contabili
     where estrazione = 'DENUNCIA_DMA';
     --
     -- comp_fisse
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_FISSE', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Competenze Fisse CPDEL',null, 10,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_FISSE', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Competenze Fisse CPDEL',null, 10,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_FISSE', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Competenze Fisse CPDEL',null, 10,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_FISSE', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Competenze Fisse CPDEL',null, 10,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_FISSE', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Competenze Fisse CPDEL',null, 10,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_FISSE', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Competenze Fisse CPDEL',null, 10,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_FISSE', to_date('01011997','ddmmyyyy'), null
            ,'Competenze Fisse CPDEL',null, 10,null ,null,null);
     insert into estrazione_righe_contabili
     select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
          , esrc.sequenza, esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
       from estrazione_valori_contabili esvc
          , estrazione_righe_contabili  esrc
      where esvc.estrazione = 'DENUNCIA_DMA'
        and esvc.colonna    = 'COMP_FISSE'
        and esrc.estrazione = 'DENUNCIA_INPDAP'
        and esrc.colonna    = esvc.colonna
        and nvl(esvc.al,to_date('3333333','j')) between
            esrc.dal and nvl(esrc.al,to_date('3333333','j'));
     --
     -- comp_accessorie
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_ACCESSORIE', to_date('01011996','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Competenze Accessorie CPDEL',null, 15,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_ACCESSORIE', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Competenze Accessorie CPDEL',null, 15,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_ACCESSORIE', to_date('01011997','ddmmyyyy'), null
            ,'Competenze Accessorie CPDEL',null, 15,null ,null,null);
     insert into estrazione_righe_contabili
     select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
          , esrc.sequenza, esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
       from estrazione_valori_contabili esvc
          , estrazione_righe_contabili  esrc
      where esvc.estrazione = 'DENUNCIA_DMA'
        and esvc.colonna    = 'COMP_ACCESSORIE'
        and esrc.estrazione = 'DENUNCIA_INPDAP'
        and esrc.colonna    = esvc.colonna
        and nvl(esvc.al,to_date('3333333','j')) between
            esrc.dal and nvl(esrc.al,to_date('3333333','j'));
     --
     -- comp_18
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_18', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Retribuzione di Base per il 18%' ,null, 20,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_18', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Retribuzione di Base per il 18%' ,null, 20,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_18', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Retribuzione di Base per il 18%' ,null, 20,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_18', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Retribuzione di Base per il 18%' ,null, 20,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_18', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Retribuzione di Base per il 18%' ,null, 20,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_18', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Retribuzione di Base per il 18%' ,null, 20,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_18', to_date('01011997','ddmmyyyy'), null
            ,'Retribuzione di Base per il 18%' ,null, 20,null ,null,null);
     insert into estrazione_righe_contabili
     select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
          , esrc.sequenza, esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
       from estrazione_valori_contabili esvc
          , estrazione_righe_contabili  esrc
      where esvc.estrazione = 'DENUNCIA_DMA'
        and esvc.colonna    = 'COMP_18'
        and esrc.estrazione = 'DENUNCIA_INPDAP'
        and esrc.colonna    = esvc.colonna
        and nvl(esvc.al,to_date('3333333','j')) between
            esrc.dal and nvl(esrc.al,to_date('3333333','j'));
     --
     -- ind_non_a
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IND_NON_A', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Indennita non annualizzabili',null, 25,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IND_NON_A', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Indennita non annualizzabili',null, 25,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IND_NON_A', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Indennita non annualizzabili',null, 25,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IND_NON_A', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Indennita non annualizzabili',null, 25,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IND_NON_A', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Indennita non annualizzabili',null, 25,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IND_NON_A', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Indennita non annualizzabili',null, 25,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IND_NON_A', to_date('01011997','ddmmyyyy'), null
            ,'Indennita non annualizzabili',null, 25,null ,null,null);
     insert into estrazione_righe_contabili
     select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
          , decode(esrc.colonna,'FERIE_NON_GODUTE',esrc.sequenza, esrc.sequenza+100), esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
       from estrazione_valori_contabili esvc
          , estrazione_righe_contabili  esrc
      where esvc.estrazione = 'DENUNCIA_DMA'
        and esvc.colonna    = 'IND_NON_A'
        and esrc.estrazione = 'DENUNCIA_INPDAP'
        and esrc.colonna    in ('FERIE_NON_GODUTE','PREAVV_RISARCITORIO')
        and nvl(esvc.al,to_date('3333333','j')) between
            esrc.dal and nvl(esrc.al,to_date('3333333','j'));
     --
     -- iis_conglobata
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IIS_CONGLOBATA', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Iis. Conglobata',null, 30,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IIS_CONGLOBATA', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Iis. Conglobata',null, 30,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IIS_CONGLOBATA', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Iis. Conglobata',null, 30,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IIS_CONGLOBATA', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Iis. Conglobata',null, 30,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IIS_CONGLOBATA', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Iis. Conglobata',null, 30,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IIS_CONGLOBATA', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Iis. Conglobata',null, 30,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IIS_CONGLOBATA', to_date('01011997','ddmmyyyy'), null
            ,'Iis. Conglobata',null, 30,null ,null,null);
     --
     -- ipn_pens
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_PENS', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Imponibile Pensionabile del Periodo',null, 35,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_PENS', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Imponibile Pensionabile del Periodo',null, 35,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_PENS', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Imponibile Pensionabile del Periodo',null, 35,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_PENS', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Imponibile Pensionabile del Periodo',null, 35,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_PENS', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Imponibile Pensionabile del Periodo',null, 35,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_PENS', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Imponibile Pensionabile del Periodo',null, 35,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_PENS', to_date('01011997','ddmmyyyy'), null
            ,'Imponibile Pensionabile del Periodo',null, 35,null ,null,null);
     --
     -- contr_pens
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PENS', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Contributo Pensionabile del Periodo',null, 40,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PENS', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Contributo Pensionabile del Periodo',null, 40,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PENS', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Contributo Pensionabile del Periodo',null, 40,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PENS', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Contributo Pensionabile del Periodo',null, 40,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PENS', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Contributo Pensionabile del Periodo',null, 40,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PENS', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Contributo Pensionabile del Periodo',null, 40,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PENS', to_date('01011997','ddmmyyyy'), null
            ,'Contributo Pensionabile del Periodo',null, 40,null ,null,null);
     --
     -- contr_agg
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_AGG', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Contributo Aggiuntivo 1%',null, 45,null ,null,null);                                                                                       
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_AGG', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Contributo Aggiuntivo 1%',null, 45,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_AGG', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Contributo Aggiuntivo 1%',null, 45,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_AGG', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Contributo Aggiuntivo 1%',null, 45,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_AGG', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Contributo Aggiuntivo 1%',null, 45,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_AGG', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Contributo Aggiuntivo 1%',null, 45,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_AGG', to_date('01011997','ddmmyyyy'), null
            ,'Contributo Aggiuntivo 1%',null, 45,null ,null,null);
     --
     -- ipn_tfs
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_TFS', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Competenze INADEL',null, 50,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_TFS', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Competenze INADEL',null, 50,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_TFS', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Competenze INADEL',null, 50,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_TFS', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Competenze INADEL',null, 50,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_TFS', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Competenze INADEL',null, 50,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_TFS', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Competenze INADEL',null, 50,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_TFS', to_date('01011997','ddmmyyyy'), null
            ,'Competenze INADEL',null, 50,null ,null,null);
     insert into estrazione_righe_contabili
     select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
          , esrc.sequenza, esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
       from estrazione_valori_contabili esvc
          , estrazione_righe_contabili  esrc
      where esvc.estrazione = 'DENUNCIA_DMA'
        and esvc.colonna    = 'IPN_TFS'
        and esrc.estrazione = 'DENUNCIA_INPDAP'
        and esrc.colonna    = 'COMP_INADEL'
        and nvl(esvc.al,to_date('3333333','j')) between
            esrc.dal and nvl(esrc.al,to_date('3333333','j'));
     --
     -- contr_tfs
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_TFS', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Contributi INADEL',null, 55,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_TFS', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Contributi INADEL',null, 55,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_TFS', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Contributi INADEL',null, 55,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_TFS', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Contributi INADEL',null, 55,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_TFS', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Contributi INADEL',null, 55,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_TFS', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Contributi INADEL',null, 55,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_TFS', to_date('01011997','ddmmyyyy'), null
            ,'Contributi INADEL',null, 55,null ,null,null);
     --
     -- ipn_tfr
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_TFR', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Imponibile TFR',null, 60,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_TFR', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Imponibile TFR',null, 60,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_TFR', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Imponibile TFR',null, 60,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_TFR', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Imponibile TFR',null, 60,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_TFR', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Imponibile TFR',null, 60,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_TFR', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Imponibile TFR',null, 60,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_TFR', to_date('01011997','ddmmyyyy'), null
            ,'Imponibile TFR',null, 60,null ,null,null);
     --
     -- contr_tfr
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_TFR', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Contributi TFR',null, 65,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_TFR', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Contributi TFR',null, 65,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_TFR', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Contributi TFR',null, 65,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_TFR', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Contributi TFR',null, 65,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_TFR', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Contributi TFR',null, 65,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_TFR', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Contributi TFR',null, 65,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_TFR', to_date('01011997','ddmmyyyy'), null
            ,'Contributi TFR',null, 65,null ,null,null);
     --
     -- ult_ipn_tfr
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'ULT_IPN_TFR', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Ulteriori Elementi TFR',null, 70,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'ULT_IPN_TFR', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Ulteriori Elementi TFR',null, 70,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'ULT_IPN_TFR', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Ulteriori Elementi TFR',null, 70,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'ULT_IPN_TFR', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Ulteriori Elementi TFR',null, 70,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'ULT_IPN_TFR', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Ulteriori Elementi TFR',null, 70,null ,null,null);                                                                                         
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'ULT_IPN_TFR', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Ulteriori Elementi TFR',null, 70,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'ULT_IPN_TFR', to_date('01011997','ddmmyyyy'), null
            ,'Ulteriori Elementi TFR',null, 70,null ,null,null);
     --
     -- contr_ult_ipn_tfr
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_ULT_IPN_TFR', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Contributi Ulteriori Elementi TFR',null, 75,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_ULT_IPN_TFR', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Contributi Ulteriori Elementi TFR',null, 75,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_ULT_IPN_TFR', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Contributi Ulteriori Elementi TFR',null, 75,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_ULT_IPN_TFR', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Contributi Ulteriori Elementi TFR',null, 75,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_ULT_IPN_TFR', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Contributi Ulteriori Elementi TFR',null, 75,null ,null,null)
     ;                                                                                         
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_ULT_IPN_TFR', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Contributi Ulteriori Elementi TFR',null, 75,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_ULT_IPN_TFR', to_date('01011997','ddmmyyyy'), null
            ,'Contributi Ulteriori Elementi TFR',null, 75,null ,null,null);
     --
     -- ipn_cassa_credito
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_CASSA_CREDITO', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Imponibile Fondo Credito / ENPDEDP',null, 80,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_CASSA_CREDITO', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Imponibile Fondo Credito / ENPDEDP',null, 80,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_CASSA_CREDITO', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Imponibile Fondo Credito / ENPDEDP',null, 80,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_CASSA_CREDITO', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Imponibile Fondo Credito / ENPDEDP',null, 80,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_CASSA_CREDITO', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Imponibile Fondo Credito / ENPDEDP',null, 80,null ,null,null);                                                                                         
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_CASSA_CREDITO', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Imponibile Fondo Credito / ENPDEDP',null, 80,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'IPN_CASSA_CREDITO', to_date('01011997','ddmmyyyy'), null
            ,'Imponibile Fondo Credito / ENPDEDP',null, 80,null ,null,null);
     --
     -- contr_cassa_credito
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_CASSA_CREDITO', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Contributi Fondo Credito',null, 85,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_CASSA_CREDITO', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Contributi Fondo Credito',null, 85,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_CASSA_CREDITO', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Contributi Fondo Credito',null, 85,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_CASSA_CREDITO', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Contributi Fondo Credito',null, 85,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_CASSA_CREDITO', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Contributi Fondo Credito',null, 85,null ,null,null);                                                                                         
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_CASSA_CREDITO', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Contributi Fondo Credito',null, 85,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_CASSA_CREDITO', to_date('01011997','ddmmyyyy'), null
            ,'Contributi Fondo Credito',null, 85,null ,null,null);
     --
     -- contr_enpdedp
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_ENPDEDP', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Contributi ENPDEDP',null, 90,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_ENPDEDP', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Contributi ENPDEDP',null, 90,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_ENPDEDP', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Contributi ENPDEDP',null, 90,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_ENPDEDP', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Contributi ENPDEDP',null, 90,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_ENPDEDP', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Contributi ENPDEDP',null, 90,null ,null,null);                                                                                         
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_ENPDEDP', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Contributi ENPDEDP',null, 90,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_ENPDEDP', to_date('01011997','ddmmyyyy'), null
            ,'Contributi ENPDEDP',null, 90,null ,null,null);
     --
     -- Tredicesima
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'TREDICESIMA', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Tredicesima',null, 95,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'TREDICESIMA', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Tredicesima',null, 95,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'TREDICESIMA', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Tredicesima',null, 95,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'TREDICESIMA', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Tredicesima',null, 95,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'TREDICESIMA', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Tredicesima',null, 95,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'TREDICESIMA', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Tredicesima',null, 95,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'TREDICESIMA', to_date('01011997','ddmmyyyy'), null
            ,'Tredicesima',null, 95,null ,null,null);
     insert into estrazione_righe_contabili
     select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
          , esrc.sequenza, esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
       from estrazione_valori_contabili esvc
          , estrazione_righe_contabili  esrc
      where esvc.estrazione = 'DENUNCIA_DMA'
        and esvc.colonna    = 'TREDICESIMA'
        and esrc.estrazione = 'DENUNCIA_INPDAP'
        and esrc.colonna    = esvc.colonna
        and nvl(esvc.al,to_date('3333333','j')) between
            esrc.dal and nvl(esrc.al,to_date('3333333','j'));
     --
     -- Teorico_tfr
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'TEORICO_TFR', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Retribuzione Teorica Tabellare TFR',null, 100,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'TEORICO_TFR', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Retribuzione Teorica Tabellare TFR',null, 100,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'TEORICO_TFR', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Retribuzione Teorica Tabellare TFR',null, 100,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'TEORICO_TFR', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Retribuzione Teorica Tabellare TFR',null, 100,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'TEORICO_TFR', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Retribuzione Teorica Tabellare TFR',null, 100,null ,null,null);                                                                                        
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'TEORICO_TFR', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Retribuzione Teorica Tabellare TFR',null, 100,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'TEORICO_TFR', to_date('01011997','ddmmyyyy'), null
            ,'Retribuzione Teorica Tabellare TFR',null, 100,null ,null,null);
     --
     -- Comp_tfr
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_TFR', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Retribuzione Utile TFR',null, 105,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_TFR', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Retribuzione Utile TFR',null, 105,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_TFR', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Retribuzione Utile TFR',null, 105,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_TFR', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Retribuzione Utile TFR',null, 105,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_TFR', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Retribuzione Utile TFR',null, 105,null ,null,null);                                                                                        
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_TFR', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Retribuzione Utile TFR',null, 105,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_TFR', to_date('01011997','ddmmyyyy'), null
            ,'Retribuzione Utile TFR',null, 105,null ,null,null);
     --
     -- quota_l166
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'QUOTA_L166', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Quota Previdenza Integrativa L.166/91',null, 105,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'QUOTA_L166', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Quota Previdenza Integrativa L.166/91',null, 105,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'QUOTA_L166', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Quota Previdenza Integrativa L.166/91',null, 105,null ,null,null);                                                                                          
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'QUOTA_L166', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Quota Previdenza Integrativa L.166/91',null, 105,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'QUOTA_L166', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Quota Previdenza Integrativa L.166/91',null, 105,null ,null,null);                                                                                        
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'QUOTA_L166', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Quota Previdenza Integrativa L.166/91',null, 105,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'QUOTA_L166', to_date('01011997','ddmmyyyy'), null
            ,'Quota Previdenza Integrativa L.166/91',null, 105,null ,null,null);
     --
     -- contr_l166
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_L166', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Contributi Previdenza Integrativa L.166/91',null, 110,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_L166', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Contributi Previdenza Integrativa L.166/91',null, 110,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_L166', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Contributi Previdenza Integrativa L.166/91',null, 110,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_L166', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Contributi Previdenza Integrativa L.166/91',null, 110,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_L166', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Contributi Previdenza Integrativa L.166/91',null, 110,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_L166', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Contributi Previdenza Integrativa L.166/91',null, 110,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_L166', to_date('01011997','ddmmyyyy'), null
            ,'Contributi Previdenza Integrativa L.166/91',null, 110,null ,null,null);
     --
     -- comp_premio
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_PREMIO', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Retribuzione Decontribuita L.135/97',null, 115,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_PREMIO', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Retribuzione Decontribuita L.135/97',null, 115,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_PREMIO', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Retribuzione Decontribuita L.135/97',null, 115,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_PREMIO', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Retribuzione Decontribuita L.135/97',null, 115,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_PREMIO', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Retribuzione Decontribuita L.135/97',null, 115,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_PREMIO', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Retribuzione Decontribuita L.135/97',null, 115,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'COMP_PREMIO', to_date('01011997','ddmmyyyy'), null
            ,'Retribuzione Decontribuita L.135/97',null, 115,null ,null,null);
     
     insert into estrazione_righe_contabili
     select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
          , esrc.sequenza, esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
       from estrazione_valori_contabili esvc
          , estrazione_righe_contabili  esrc
      where esvc.estrazione = 'DENUNCIA_DMA'
        and esvc.colonna    = 'COMP_PREMIO'
        and esrc.estrazione = 'DENUNCIA_INPDAP'
        and esrc.colonna    = esvc.colonna
        and nvl(esvc.al,to_date('3333333','j')) between
            esrc.dal and nvl(esrc.al,to_date('3333333','j'));
          --
     -- contr_l135
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_L135', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Contributi Previdenza Integrativa L.166/91',null, 120,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_L135', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Contributi Previdenza Integrativa L.166/91',null, 120,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_L135', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Contributi Previdenza Integrativa L.166/91',null, 120,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_L135', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Contributi Previdenza Integrativa L.166/91',null, 120,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_L135', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Contributi Previdenza Integrativa L.166/91',null, 120,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_L135', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Contributi Previdenza Integrativa L.166/91',null, 120,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_L135', to_date('01011997','ddmmyyyy'), null
            ,'Contributi Previdenza Integrativa L.166/91',null, 120,null ,null,null);
     --
     -- contr_pens_sospesi
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PENS_SOSPESI', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Contributi Pensione Sospesi',null, 125,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PENS_SOSPESI', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Contributi Pensione Sospesi',null, 125,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PENS_SOSPESI', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Contributi Pensione Sospesi',null, 125,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PENS_SOSPESI', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Contributi Pensione Sospesi',null, 125,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PENS_SOSPESI', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Contributi Pensione Sospesi',null, 125,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PENS_SOSPESI', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Contributi Pensione Sospesi',null, 125,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PENS_SOSPESI', to_date('01011997','ddmmyyyy'), null
            ,'Contributi Pensione Sospesi',null, 125,null ,null,null);
     --
     -- contr_prev_sospesi
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PREV_SOSPESI', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Contributi Previdenziali Sospesi',null, 130,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PREV_SOSPESI', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Contributi Previdenziali Sospesi',null, 130,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PREV_SOSPESI', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Contributi Previdenziali Sospesi',null, 130,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PREV_SOSPESI', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Contributi Previdenziali Sospesi',null, 130,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PREV_SOSPESI', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Contributi Previdenziali Sospesi',null, 130,null ,null,null);                   
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PREV_SOSPESI', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Contributi Previdenziali Sospesi',null, 130,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'CONTR_PREV_SOSPESI', to_date('01011997','ddmmyyyy'), null
            ,'Contributi Previdenziali Sospesi',null, 130,null ,null,null);
     --
     -- sanzione_pens
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_PENS', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Sanzione su Contributi Pensionabili',null, 135,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_PENS', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Sanzione su Contributi Pensionabili',null, 135,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_PENS', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Sanzione su Contributi Pensionabili',null, 135,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_PENS', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Sanzione su Contributi Pensionabili',null, 135,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_PENS', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Sanzione su Contributi Pensionabili',null, 135,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_PENS', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Sanzione su Contributi Pensionabili',null, 135,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_PENS', to_date('01011997','ddmmyyyy'), null
            ,'Sanzione su Contributi Pensionabili',null, 135,null ,null,null);
     --
     -- sanzione_prev
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_PREV', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Sanzione su Contributi Previdenziali',null, 140,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_PREV', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Sanzione su Contributi Previdenziali',null, 140,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_PREV', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Sanzione su Contributi Previdenziali',null, 140,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_PREV', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Sanzione su Contributi Previdenziali',null, 140,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_PREV', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Sanzione su Contributi Previdenziali',null, 140,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_PREV', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Sanzione su Contributi Previdenziali',null, 140,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_PREV', to_date('01011997','ddmmyyyy'), null
            ,'Sanzione su Contributi Previdenziali',null, 140,null ,null,null);
     --
     -- sanzione_cred
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_CRED', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Sanzione su Contributi Fondo Credito',null, 145,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_CRED', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Sanzione su Contributi Fondo Credito',null, 145,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_CRED', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Sanzione su Contributi Fondo Credito',null, 145,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_CRED', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Sanzione su Contributi Fondo Credito',null, 145,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_CRED', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Sanzione su Contributi Fondo Credito',null, 145,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_CRED', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Sanzione su Contributi Fondo Credito',null, 145,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_CRED', to_date('01011997','ddmmyyyy'), null
            ,'Sanzione su Contributi Fondo Credito',null, 145,null ,null,null);
     --
     -- sanzione_enpdedp
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_ENPDEDP', to_date('01011940','ddmmyyyy'), to_date('30041991','ddmmyyyy')
            ,'Sanzione su Contributi ENPDEDP',null, 150,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_ENPDEDP', to_date('01051991','ddmmyyyy'), to_date('31121991','ddmmyyyy')
            ,'Sanzione su Contributi ENPDEDP',null, 150,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_ENPDEDP', to_date('01011992','ddmmyyyy'), to_date('30061992','ddmmyyyy')
            ,'Sanzione su Contributi ENPDEDP',null, 150,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_ENPDEDP', to_date('01071992','ddmmyyyy'), to_date('31121992','ddmmyyyy')
            ,'Sanzione su Contributi ENPDEDP',null, 150,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_ENPDEDP', to_date('01011993','ddmmyyyy'), to_date('30111996','ddmmyyyy')
            ,'Sanzione su Contributi ENPDEDP',null, 150,null ,null,null);                      
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_ENPDEDP', to_date('01121996','ddmmyyyy'), to_date('31121996','ddmmyyyy')
            ,'Sanzione su Contributi ENPDEDP',null, 150,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'SANZIONE_ENPDEDP', to_date('01011997','ddmmyyyy'), null
            ,'Sanzione su Contributi ENPDEDP',null, 150,null ,null,null);
     --
     -- enpam
     --
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'ENPAS', to_date('01011940','ddmmyyyy'), to_date('31122002','ddmmyyyy')
            ,'Contribuzione ENPAS',null, 155,null ,null,null);
     insert into estrazione_valori_contabili 
            (estrazione,colonna,dal,al,descrizione,note,sequenza,moltiplica,arrotonda,divide) 
     values ('DENUNCIA_DMA', 'ENPAS', to_date('01012003','ddmmyyyy'), null
            ,'Contribuzione ENPAS',null, 155,null ,null,null);
     insert into estrazione_righe_contabili
     select distinct esvc.estrazione, esvc.colonna, esvc.dal, esvc.al
          , esrc.sequenza, esrc.voce, esrc.sub, esrc.tipo, esrc.anno, esrc.segno1, esrc.dato1, esrc.segno2, esrc.dato2
       from estrazione_valori_contabili esvc
          , estrazione_righe_contabili  esrc
      where esvc.estrazione = 'DENUNCIA_DMA'
        and esvc.colonna    = 'ENPAS'
        and esrc.estrazione = 'DENUNCIA_INPDAP'
        and esrc.colonna    = esvc.colonna
        and nvl(esvc.al,to_date('3333333','j')) between
            esrc.dal and nvl(esrc.al,to_date('3333333','j'));
  end if;
end;
/

start crt_ddma.sql
start crq_ddma.sql

-- Modifica campo competenza / tipo_aliquota
update pec_ref_codes 
   set rv_domain = 'DENUNCIA_DMA.TIPO_ALIQUOTA'
 where rv_domain = 'DENUNCIA_DMA.COMPETENZA'
   and not exists
      (select 'x' from pec_ref_codes
        where rv_domain = 'DENUNCIA_DMA.TIPO_ALIQUOTA')
;
-- Nuovo ref_codes per nuovo campo Competenza
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'C', NULL, NULL, 'DENUNCIA_DMA.COMPETENZA', 'Corrente Attribuzione'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'P', NULL, NULL, 'DENUNCIA_DMA.COMPETENZA', 'Precedente Attribuzione'
, 'CFG', NULL, NULL); 

-- Nuovo valore per previdenza
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'CPFPC', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.PREVIDENZA', 'Fondo Previdenza e Credito'
, 'CFG', NULL, NULL); 

-- Modifica valore 33 delle cause di cessazione
update pec_ref_codes
   set rv_abbreviation = '33_SOSPENSIONE'
 where rv_domain = 'DENUNCIA_DMA.CAUSA_CESSAZIONE'
   and rv_low_value = '33';

update pec_ref_codes
   set rv_abbreviation = '30_SOSPENSIONE'
 where rv_domain = 'DENUNCIA_DMA.CAUSA_CESSAZIONE'
   and rv_low_value = '32';

-- Nuove cause di cessazione
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'28', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Cessazione per trasformazione o chiusura ente'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'29', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Risoluzione consensuale per i dirigenti'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'30', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Perdita della cittadinanza nel rispetto della normativa comunitaria'
, 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'31', NULL, NULL, 'DENUNCIA_DMA.CAUSA_CESSAZIONE', 'Prosecuzione del rapporto di lavoro oltre i limiti di eta'' per il collocamento a riposo (L.186/2004)'
, 'CFG', NULL, NULL); 


-- Nuove cat fiscali astensione
INSERT INTO PGM_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) 
select RV_LOW_VALUE, RV_HIGH_VALUE, null, 'ASTENSIONI.CAT_FISCALE', RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 from pec_ref_codes
where rv_domain = 'DENUNCIA_DMA.CAUSA_CESSAZIONE'
and rv_low_value = '33';


