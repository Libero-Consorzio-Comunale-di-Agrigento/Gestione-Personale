CREATE OR REPLACE PACKAGE PXXCMORE IS 
   FUNCTION  VERSIONE              RETURN VARCHAR2;

   PROCEDURE PXAMIPEG         ( P_ci         IN   NUMBER
                              , P_al         IN   DATE
                              , P_anno       IN   NUMBER
                              , P_mese       IN   NUMBER 
                              , P_MENSILITA  IN   VARCHAR2
                              );
END PXXCMORE;
/
CREATE OR REPLACE PACKAGE BODY PXXCMORE AS
FUNCTION VERSIONE  RETURN VARCHAR2 IS
BEGIN
   RETURN 'V1.0 del 17/09/2002';
END VERSIONE;

PROCEDURE PXAMIPEG
( P_ci         IN   NUMBER
, P_al         IN   DATE
, P_anno       IN   NUMBER
, P_mese       IN   NUMBER 
, P_MENSILITA  IN   VARCHAR2
)IS
   d_fisso       NUMBER;
   d_contributo  NUMBER;
   d_fiscale     NUMBER;
   d_tfr         NUMBER;
BEGIN
 delete from calcoli_contabili 
   where voce = 'PEG.ONEDED'
     and ci = P_ci
  ;
     d_contributo := 0;
     d_fiscale := 0;
     d_tfr := 0;
     d_fisso := 0;
  BEGIN
  select decode(valuta,'I',10000000,10000000 / 1936.27)
    into d_fisso 
    from dual
  ;
  select sum(decode(caco.voce,'PEG.CTR.AZ',caco.imp,'PEG.CTR.DI',caco.imp * -1,'PEG.ISC.DI',caco.imp * -1
                             ,'PEG.ISC.AZ',caco.imp,0))
       , e_round(sum(decode(caco.voce,'IPT.ORD',caco.tar,0)) * 12 / 100,'I')
       , sum(decode(caco.voce,'PEG.TFR',caco.imp,0)) * 2 
       , e_round(d_fisso / 12,'I') 
    into d_contributo
       , d_fiscale
       , d_tfr
       , d_fisso
    from calcoli_contabili caco
   where caco.ci = P_ci
     and caco.voce in ('PEG.CTR.AZ','PEG.CTR.DI','PEG.ISC.AZ','PEG.ISC.DI',
                       'IPT.ORD','PEG.TFR')
     and exists (select 'x'
                   from calcoli_contabili caco1
                  where caco1.ci = caco.ci
                    and caco1.voce = 'PEG.CTR.AZ'
                )
  ;
  insert into calcoli_contabili
            ( ci, voce, sub
            , riferimento
            , competenza
            , arr
            , input
            , estrazione
            , data
            , imp
            )
  select P_ci,'PEG.ONEDED','*'
       , P_al
       ,null
       ,null
       ,'C'
       ,'AF'
       ,sysdate
       ,least(decode(d_contributo,0,999999999,d_contributo),decode(d_fiscale,0,999999999,d_fiscale)
             ,decode(d_tfr,0,999999999,d_tfr),decode(d_fisso,0,999999999,d_fisso)) * -1
   from dual
--  where d_contributo + d_tfr != 0
  where d_contributo != 0
  ;
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
     d_contributo := 0;
     d_fiscale := 0;
     d_tfr := 0;
     d_fisso := 0;
  END;
     d_contributo := 0;
     d_fiscale := 0;
     d_tfr := 0;
     d_fisso := 0;
  BEGIN
  select sum(decode(caco.voce,'C.PREVIN',caco.imp,'R.PREVIN',caco.imp * -1,0))
       , e_round(sum(decode(caco.voce,'IPT.ORD',caco.tar,0)) * 12 / 100,'I')
       , sum(decode(caco.voce,'TFR.PREVIN',caco.imp,0)) * 2 
       , e_round(d_fisso / 12,'I') 
    into d_contributo
       , d_fiscale
       , d_tfr
       , d_fisso
    from calcoli_contabili caco
   where caco.ci = P_ci
     and caco.voce in ('C.PREVIN','R.PREVIN',
                       'IPT.ORD','TFR.PREVIN')
     and exists (select 'x'
                   from calcoli_contabili caco1
                  where caco1.ci = caco.ci
                    and caco1.voce = 'C.PREVIN'
                )
  ;
  insert into calcoli_contabili
            ( ci, voce, sub
            , riferimento
            , competenza
            , arr
            , input
            , estrazione
            , data
            , imp
            )
  select P_ci,'PEG.ONEDED','*'
       , P_al
       ,null
       ,null
       ,'C'
       ,'AF'
       ,sysdate
       ,least(decode(d_contributo,0,999999999,d_contributo),decode(d_fiscale,0,999999999,d_fiscale)
             ,decode(d_tfr,0,999999999,d_tfr),decode(d_fisso,0,999999999,d_fisso)) * -1
   from dual
--  where d_contributo + d_tfr != 0
  where d_contributo != 0
  ;
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
     d_contributo := 0;
     d_fiscale := 0;
     d_tfr := 0;
     d_fisso := 0;
  END;
END PXAMIPEG;
END PXXCMORE;
/
 
