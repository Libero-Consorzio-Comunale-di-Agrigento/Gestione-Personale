update pec_ref_codes set RV_MEANING = 'La deduzione base per la progressivita'' dell''imposizione e'' stata ragguagliata al periodo di lavoro. '
where RV_LOW_VALUE = 'AP_1'
and RV_DOMAIN = 'DENUNCIA_CUD.ANNOTAZIONI'
/

update pec_ref_codes set RV_MEANING = 'Il percipiente puo'' fruire della deduzione teorica per l''intero anno in sede di dichiarazione dei redditi, '
       ||'sempreche'' non sia stata gia'' attribuita da un altro datore di lavoro e risulti effettivamente spettante.'
where RV_LOW_VALUE = 'AP_2'
and RV_DOMAIN = 'DENUNCIA_CUD.ANNOTAZIONI'
/

start crp_peccnocu.sql