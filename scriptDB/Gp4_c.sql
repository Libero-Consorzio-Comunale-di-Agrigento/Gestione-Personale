-- Attivazione script di Generazione della Base Dati: GP4-- 
-- Esclusi moduli particolari vedi MT / EB 

PROMPT Argomento 1 = Numero Dipendenti

column C1 noprint new_value P1

select least(nvl(&1,10),10000) C1
  from dual
;

-- Creazione tabelle con dimensionamento escluso modulo MT
start crt_agfa.sql &P1
start crt_aico.sql &P1
start crt_aire.sql &P1
start crt_anag.sql &P1
start crt_agin.sql &P1
start crt_asco.sql &P1
start crt_asfa.sql &P1
start crt_asin.sql &P1
start crt_aste.sql &P1
start crt_atin.sql &P1
start crt_atti.sql &P1
start crt_aupa.sql &P1
start crt_bavo.sql &P1
start crt_bavp.sql &P1
start crt_bila.sql &P1
start crt_caaf.sql &P1
start crt_caco.sql &P1
start crt_cado.sql &P1
start crt_caev.sql &P1
start crt_cafa.sql &P1
start crt_cafi.sql &P1
start crt_cagi.sql &P1
start crt_cain.sql &P1
start crt_cale.sql &P1
start crt_calm.sql &P1
start crt_cami.sql &P1
start crt_capa.sql &P1
start crt_capo.sql &P1
start crt_capr.sql &P1
start crt_care.sql &P1
start crt_carr.sql &P1
start crt_case.sql &P1
start crt_cava.sql &P1
start crt_ceco.sql &P1
start crt_celo.sql &P1
start crt_cert.sql &P1
start crt_clbu.sql &P1
start crt_clde.sql &P1
start crt_clev.sql &P1
start crt_clfu.sql &P1
start crt_clpa.sql &P1
start crt_clra.sql &P1
start crt_cndo.sql &P1
start crt_cnpo.sql &P1
start crt_cobi.sql &P1
start crt_cofa.sql &P1
start crt_cofi.sql &P1
start crt_com730.sql &P1
start crt_conp.sql &P1
start crt_cont.sql &P1
start crt_conv.sql &P1
start crt_corr.sql &P1
start crt_cost.sql &P1
start crt_covo.sql &P1
start crt_ctev.sql &P1
start crt_d1is.sql &P1
start crt_d3is.sql &P1
start crt_decp.sql &P1
start crt_dedp.sql &P1
start crt_deec.sql &P1
start crt_defi.sql &P1
start crt_defs.sql &P1
start crt_degl.sql &P1
start crt_digl.sql &P1
start crt_deid.sql &P1
start crt_dein.sql &P1
start crt_deli.sql &P1
start crt_depa.sql &P1
start crt_dere.sql &P1
start crt_deri.sql &P1
start crt_derp.sql &P1
start crt_diid.sql &P1
start crt_adog.sql &P1
start crt_dppa.sql &P1
start crt_eapa.sql &P1
start crt_ente.sql &P1
start crt_erpg.sql &P1
start crt_esco.sql &P1
start crt_escr.sql &P1
start crt_esel.sql &P1
start crt_esge.sql &P1
start crt_esmo.sql &P1
start crt_esnc.sql &P1
start crt_eson.sql &P1
start crt_esrc.sql &P1
start crt_esre.sql &P1
start crt_esrm.sql &P1
start crt_esvc.sql &P1
start crt_esvo.sql &P1
start crt_evgi.sql &P1
start crt_evin.sql &P1
start crt_evpa.sql &P1
start crt_evpc.sql &P1
start crt_evra.sql &P1
start crt_fami.sql &P1
start crt_figi.sql &P1
start crt_figu.sql &P1
start crt_foca.sql &P1
start crt_foce.sql &P1
start crt_gest.sql &P1
start crt_gius.sql &P1
start crt_grra.sql &P1
start crt_imcc.sql &P1
start crt_imce.sql &P1
start crt_imco.sql &P1
start crt_imvo.sql &P1
start crt_inec.sql &P1
start crt_inex.sql &P1
start crt_inmo.sql &P1
start crt_inpd.sql &P1
start crt_inre.sql &P1
start crt_inrp.sql &P1
start crt_iscr.sql &P1
start crt_mens.sql &P1
start crt_mese.sql &P1
start crt_mobp.sql &P1
start crt_moco.sql &P1
start crt_mocp.sql &P1
start crt_moev.sql &P1
start crt_mofi.sql &P1
start crt_nocu.sql &P1
start crt_novo.sql &P1
start crt_o1md.sql &P1
start crt_paan.sql &P1
start crt_pare.sql &P1
start crt_pedo.sql &P1
start crt_pegi.sql &P1
start crt_pere.sql &P1
start crt_perp.sql &P1
start crt_pofu.sql &P1
start crt_poor.sql &P1
start crt_popi.sql &P1
start crt_posi.sql &P1
start crt_prec.sql &P1
start crt_prpa.sql &P1
start crt_prpr.sql &P1
start crt_qual.sql &P1
start crt_quge.sql &P1
start crt_qugi.sql &P1
start crt_qumi.sql &P1
start crt_qust.sql &P1
start crt_raco.sql &P1
start crt_radi.sql &P1
start crt_ragi.sql &P1
start crt_rain.sql &P1
start crt_ramo.sql &P1
start crt_rapa.sql &P1
start crt_rars.sql &P1
start crt_rarm.sql &P1
start crt_rava.sql &P1
start crt_reac.sql &P1
start crt_reae.sql &P1
start crt_reat.sql &P1
start crt_rece.sql &P1
start crt_rech.sql &P1
start crt_reco.sql &P1
start crt_rees.sql &P1
start crt_reoe.sql &P1
start crt_reog.sql &P1
start crt_rero.sql &P1
start crt_reuo.sql &P1
start crt_rfca.sql &P1
start crt_riar.sql &P1
start crt_rica.sql &P1
start crt_rico.sql &P1
start crt_riel.sql &P1
start crt_rifa.sql &P1
start crt_rifu.sql &P1
start crt_rili.sql &P1
start crt_rimo.sql &P1
start crt_rior.sql &P1
start crt_ripa.sql &P1
start crt_rire.sql &P1
start crt_rivo.sql &P1
start crt_rppa.sql &P1
start crt_rqmi.sql &P1
start crt_rqst.sql &P1
start crt_rrli.sql &P1
start crt_rtvo.sql &P1
start crt_ruol.sql &P1
start crt_scaf.sql &P1
start crt_scde.sql &P1
start crt_scdf.sql &P1
start crt_scfi.sql &P1
start crt_sede.sql &P1
start crt_sepr.sql &P1
start crt_sett.sql &P1
start crt_smim.sql &P1
start crt_smin.sql &P1
start crt_smpe.sql &P1
start crt_sodo.sql &P1
start crt_sogg.sql &P1
start crt_sopr.sql &P1
start crt_spor.sql &P1
start crt_stat.sql &P1
start crt_stci.sql &P1
start crt_suci.sql &P1
start crt_tavo.sql &P1
start crt_tefo.sql &P1
start crt_telo.sql &P1
start crt_tica.sql &P1
start crt_tira.sql &P1
start crt_tist.sql &P1
start crt_toca.sql &P1
start crt_tovo.sql &P1
start crt_trco.sql &P1
start crt_trfa.sql &P1
start crt_trpo.sql &P1
start crt_trpr.sql &P1
start crt_vaaf.sql &P1
start crt_vafi.sql &P1
start crt_vapa.sql &P1
start crt_vbvo.sql &P1
start crt_vbvp.sql &P1
start crt_vcev.sql &P1
start crt_veco.sql &P1
start crt_voco.sql &P1
start crt_vode.sql &P1
start crt_voec.sql &P1
start crt_voin.sql &P1
start crt_vpvo.sql &P1
start crt_vpvp.sql &P1
start crt_vqmi.sql &P1

-- Creazione tabelle senza dimensionamento escluso modulo MT
start crt_gp4_pers.sql
start Gp4_ref_codes_c.sql
start crt_acer.sql
start crt_alei.sql
start crt_alin.sql
start crt_aper.sql
start crt_asfi.sql
start crt_atgi.sql
start crt_atpi.sql
start crt_caat.sql
start crt_cacd.sql
start crt_cari.sql
start CRT_CF4CACO.sql
start crt_cf4acim.sql
start crt_cf4subimp.sql
start crt_cf4qtn.sql
start crt_coat.sql
start crt_coin.sql
start crt_crat.sql
start crt_esin.sql
start crt_dape.sql
start crt_ddia.sql
start crt_ddim.sql
start crt_defa.sql
start crt_deon.sql
start crt_deeo.sql
start crt_deie.sql
start crt_deve.sql
start crt_dged.sql
start crt_didi.sql
start crt_disp.sql
start crt_ddma.sql
start crt_ddmq.sql
start crt_ddre.sql
start crt_fian.sql
start crt_fose.sql
start crt_gete.sql
start crt_idma.sql
start crt_imas.sql
start crt_imma.sql
start crt_inaf.sql
start crt_noin.sql
start crt_mono.sql
start crt_mowo.sql
start crt_orva.sql
start crt_pano.sql
start crt_pebl.sql
start crt_pinf.sql
start crt_poii.sql
start crt_poin.sql
start crt_prin.sql
start crt_quin.sql
start crt_qus7.sql
start crt_rdre.sql
start crt_rcom.sql
start crt_rein.sql
start crt_resi.sql
start crt_riin.sql
start crt_rsst.sql
start crt_seie.sql
start crt_sein.sql
start crt_stim.sql
start crt_stin.sql
start crt_stms.sql
start crt_stmw.sql
start crt_stpe.sql
start crt_tccn.sql
start crt_tcir.sql
start crt_tecp.sql
start crt_tepi.sql
start crt_titi.sql
start crt_toz1.sql
start crt_toz2.sql
start crt_vaat.sql
start crt_vaag.sql
start crt_vaie.sql
start crt_vdz2.sql
start crt_vori.sql
start crt_vos7.sql
start crt_wote.sql

-- creazione sequence escluse quelle del modulo MT
start crq_atgi.sql
start crq_atpi.sql
start crq_ddis.sql
start crq_ddma.sql
start crq_ddmq.sql
start crq_deie.sql
start crq_dein.sql
start crq_digl.sql
start crq_disp.sql
start crq_door.sql
start crq_evpa.sql
start crq_figu.sql
start crq_imin.sql
start crq_imma.sql
start crq_indi.sql
start crq_inmo.sql
start crq_mono.sql
start crq_novo.sql
start crq_poii.sql
start crq_prin.sql
start crq_qual.sql
start crt_rare.sql
start crq_rein.sql
start crq_rgdo.sql
start crq_rigd.sql
start crq_sett.sql
start crq_sede.sql
start crq_sogi.sql
start crq_vdz2.sql