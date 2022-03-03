create table inex_ante_21712 as 
select * from informazioni_extracontabili
;

alter table informazioni_extracontabili disable all triggers;

 update informazioni_extracontabili
    set ipn_fam_1 = decode( nvl(ipn_fam_1,0)
                          , ipn_fam_2ap, ''
                                       , ipn_fam_1)
      , ipn_fam_2 = decode( nvl(ipn_fam_2,0)
                          , ipn_fam_2ap, ''
                                       , ipn_fam_2)
      , ipn_fam_3 = decode( nvl(ipn_fam_3,0)
                          , ipn_fam_2ap, ''
                                       , ipn_fam_3)
      , ipn_fam_4 = decode( nvl(ipn_fam_4,0)
                          , ipn_fam_2ap, ''
                                       , ipn_fam_4)
      , ipn_fam_5 = decode( nvl(ipn_fam_5,0)
                          , ipn_fam_2ap, ''
                                       , ipn_fam_5)
      , ipn_fam_6 = decode( nvl(ipn_fam_6,0)
                          , ipn_fam_2ap, ''
                                       , ipn_fam_6)
 where nvl(IPN_FAM_2ap,0) != 0
;

 update informazioni_extracontabili
    set ipn_fam_7 = decode( nvl(ipn_fam_7,0)
                          , ipn_fam_1ap, ''
                                       , ipn_fam_7)
      , ipn_fam_8 = decode( nvl(ipn_fam_8,0)
                          , ipn_fam_1ap, ''
                                       , ipn_fam_8)
      , ipn_fam_9 = decode( nvl(ipn_fam_9,0)
                          , ipn_fam_1ap, ''
                                       , ipn_fam_9)
      , ipn_fam_10 = decode( nvl(ipn_fam_10,0)
                          , ipn_fam_1ap, ''
                                       , ipn_fam_10)
      , ipn_fam_11 = decode( nvl(ipn_fam_11,0)
                          , ipn_fam_1ap, ''
                                       , ipn_fam_11)
      , ipn_fam_12 = decode( nvl(ipn_fam_12,0)
                          , ipn_fam_1ap, ''
                                       , ipn_fam_12)
 where nvl(IPN_FAM_1ap,0) != 0
;


alter table informazioni_extracontabili enable all triggers;

start crf_rire_cambio_anno.sql