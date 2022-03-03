PROMPT Creating Sequence INDI_SQ su campo NI della Table ANAGRAFICI 
col C2 noprint format 99999999 new_value P2
select least ( greatest(nvl(max(anag.ni),0) 
                      , nvl(max(rain.ci),0)), 99999998 ) mni 
     , to_number( least ( greatest(nvl(max(anag.ni),0)
                                  ,nvl(max(rain.ci),0))+1
                        , 99999998 ) ) C2 
  from rapporti_individuali rain, anagrafici  anag
  where rain.ni (+) = anag.ni 
;
DROP SEQUENCE indi_sq
;
CREATE SEQUENCE indi_sq
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 99999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence SETT_SQ su campo NUMERO della Table SETTORI
col C2 new_value P2
select greatest( nvl(max(sett.numero),0)
               , nvl(max(seam.numero),0) ) mns
      ,greatest( nvl(max(sett.numero),0)+1 
               , nvl(max(seam.numero),0)+1 ) C2
  from settori sett,settori_amministrativi seam
  where sett.numero(+) = seam.numero
;
DROP SEQUENCE sett_sq
;
CREATE SEQUENCE sett_sq
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 999999
 NOCYCLE 
 CACHE 2
 NOORDER 
; 

PROMPT Creating Sequence SEDE_SQ su campo NUMERO della Table SEDI
col C2 new_value P2
select nvl(max(numero),0) mns    
      ,nvl(max(numero),0)+1 C2    
  from sedi    
;
DROP SEQUENCE sede_sq
;
CREATE SEQUENCE sede_sq
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 999999
 NOCYCLE 
 CACHE 2
 NOORDER 
; 

PROMPT Creating Sequence QUAL_SQ su campo NUMERO della Table QUALIFICHE
col C2 new_value P2
select nvl(max(numero),0) mnq
      ,nvl(max(numero),0)+1 C2
  from qualifiche
;
DROP SEQUENCE qual_sq
;
CREATE SEQUENCE qual_sq
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 999999
 NOCYCLE 
 CACHE 2
 NOORDER 
; 

PROMPT Creating Sequence FIGU_SQ su campo NUMERO della Table FIGURE
col C2 new_value P2
select nvl(max(numero),0) mnf 
      ,nvl(max(numero),0)+1 C2 
  from figure  
;
DROP SEQUENCE figu_sq
;
CREATE SEQUENCE figu_sq
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 999999
 NOCYCLE 
 CACHE 2
 NOORDER 
; 

PROMPT Creating Sequence EVPA_SQ su campo EVENTO della Table EVENTI_PRESENZA
col C2 new_value P2
select nvl(max(evento),0) mne 
      ,nvl(max(evento),0)+1  C2 
  from eventi_presenza  
;
DROP SEQUENCE evpa_sq
;
CREATE SEQUENCE evpa_sq
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence IMIN_SQ su campo IMIN_ID della Table RETRIBUZIONI_INAIL
col C2 new_value P2
select nvl(max(imin_id),0) mni 
      ,nvl(max(imin_id),0)+1  C2 
  from retribuzioni_inail
;
drop sequence IMIN_SQ
;
CREATE SEQUENCE IMIN_SQ 
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence DDMA_SQ su campo DDMA_ID della Table DENUNCIA_DMA
col C2 new_value P2
select nvl(max(ddma_id),0) mnd 
      ,nvl(max(ddma_id),0)+1  C2 
  from denuncia_dma 
;
drop sequence ddma_sq
;
CREATE SEQUENCE DDMA_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence DDMQ_SQ su campo DDMQ_ID della Table DENUNCIA_DMA_QUOTE
col C2 new_value P2
select nvl(max(ddmq_id),0) mnd
      ,nvl(max(ddmq_id),0)+1  C2 
  from denuncia_dma_quote 
;
drop sequence ddmq_sq
;
CREATE SEQUENCE DDMQ_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence DIGL_SQ su campo DIGL_ID della Table DENUNCIA_IMPORTI_GLA
col C2 new_value P2
select nvl(max(digl_id),0) mnd
      ,nvl(max(digl_id),0)+1  C2 
  from denuncia_importi_gla
;
drop sequence digl_sq
;
CREATE SEQUENCE DIGL_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence DEIE_SQ su campo DEIE_ID della Table DENUNCIA_EMENS
col C2 new_value P2
select nvl(max(deie_id),0) mnd
      ,nvl(max(deie_id),0)+1  C2 
  from denuncia_emens
;
drop sequence deie_sq
;
CREATE SEQUENCE DEIE_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence DISP_SQ su campo DISP_ID della Table DEF_ISTITUTI_PREVIDENZIALI
col C2 new_value P2
select nvl(max(disp_id),0) mnd
      ,nvl(max(disp_id),0)+1  C2 
  from def_istituti_previdenziali
;
drop sequence DISP_sq
;
CREATE SEQUENCE DISP_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence PRIN_SQ su campo PRIN_ID della Table PREMI_INAIL
col C2 new_value P2
select nvl(max(PRIN_ID),0) mnp
      ,nvl(max(PRIN_ID),0)+1  C2 
  from PREMI_INAIL
;
drop sequence PRIN_SQ
;
CREATE SEQUENCE PRIN_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence NOVO_SQ su campo NOVO_ID della Table NORMATIVA_VOCE
col C2 new_value P2
select nvl(max(NOVO_ID),0) mnn
      ,nvl(max(NOVO_ID),0)+1  C2 
  from NORMATIVA_VOCE
;
drop sequence NOVO_SQ
;
CREATE SEQUENCE NOVO_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence VDZ2_SQ su campo VDZ2_ID della Table VERSAMENTI_DMA_Z2
col C2 new_value P2
select nvl(max(VDZ2_ID),0) mnv 
      ,nvl(max(VDZ2_ID),0)+1  C2 
  from VERSAMENTI_DMA_Z2
;
drop SEQUENCE VDZ2_SQ
;
CREATE SEQUENCE VDZ2_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence ATGI_SQ su campo ATGI_ID della Table ATTRIBUTI_GIURIDICI
col C2 new_value P2
select nvl(max(ATGI_ID),0) mna
      ,nvl(max(ATGI_ID),0)+1  C2 
  from attributi_giuridici
;
drop SEQUENCE ATGI_SQ
;
CREATE SEQUENCE ATGI_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence DDIS_SQ su campo DDIS_ID della Table DICHIARAZIONE_DIS
col C2 new_value P2
select nvl(max(DDIS_ID),0) mnd 
      ,nvl(max(DDIS_ID),0)+1  C2 
  from dichiarazione_dis
;
drop SEQUENCE DDIS_SQ
;
CREATE SEQUENCE DDIS_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence DEIN_SQ su campo DEIN_ID della Table DENUNCIA_INAIL
col C2 new_value P2
select nvl(max(DEIN_ID),0) mnd
      ,nvl(max(DEIN_ID),0)+1  C2 
  from denuncia_inail
;
drop SEQUENCE DEIN_SQ
;
CREATE SEQUENCE DEIN_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence DOOR_SQ su campo DOOR_ID della Table DOTAZIONE_ORGANICA
col C2 new_value P2
select nvl(max(DOOR_ID),0) mnd 
      ,nvl(max(DOOR_ID),0)+1  C2 
  from dotazione_organica
;
drop SEQUENCE DOOR_SQ
;
CREATE SEQUENCE DOOR_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence MONO_SQ su campo NOTA della Table MODELLI_NOTE
col C2 new_value P2
select nvl(max(NOTA),0) mnm 
      ,nvl(max(NOTA),0)+1  C2 
  from modelli_note
;
drop SEQUENCE MONO_SQ
;
CREATE SEQUENCE MONO_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence IMAGESEQ su campo SEQUENZA della Table IMMAGINI
col C2 new_value P2
select nvl(max(sequenza),0) mni 
      ,nvl(max(sequenza),0)+1  C2 
  from immagini
;
drop SEQUENCE IMAGESEQ
;
CREATE SEQUENCE IMAGESEQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence REIN_SQ su campo REIN_ID della Table RIGHE_ESENZIONE_INAIL
col C2 new_value P2
select nvl(max(ESIN_ID),0) mnr 
      ,nvl(max(ESIN_ID),0)+1  C2 
  from righe_esenzione_inail
;
drop SEQUENCE REIN_SQ
;
CREATE SEQUENCE REIN_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence RGDO_SQ su campo RGDO_ID della Table RIGHE_GRUPPI_DOTAZIONE
col C2 new_value P2
select nvl(max(RGDO_ID),0) mnr 
      ,nvl(max(RGDO_ID),0)+1  C2 
  from righe_gruppi_dotazione
;
drop SEQUENCE RGDO_SQ
;
CREATE SEQUENCE RGDO_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence RIGD_SQ su campo RIGD_ID della Table RIPARTIZIONE_GRUPPI_DOTAZIONE
col C2 new_value P2
select nvl(max(RIGD_ID),0) mnr 
      ,nvl(max(RIGD_ID),0)+1  C2 
  from ripartizione_gruppi_dotazione
;
drop SEQUENCE RIGD_SQ
;
CREATE SEQUENCE RIGD_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence SOGI_SQ su campo SOGI_ID della Table SOSTITUZIONI_GIURIDICHE
col C2 new_value P2
select nvl(max(SOGI_ID),0) mns
      ,nvl(max(SOGI_ID),0)+1  C2 
  from sostituzioni_giuridiche
;
drop SEQUENCE SOGI_SQ
;
CREATE SEQUENCE SOGI_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence REDI_SQ su campo REDI_ID della Table REGOLE_DIARIA
col C2 new_value P2
select nvl(max(redi_id),0) mnr 
      ,nvl(max(redi_id),0)+1  C2 
  from regole_diaria
;
drop SEQUENCE REDI_SQ
;
CREATE SEQUENCE REDI_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence RIRI_SQ su campo RIRI_ID della Table RICHIESTE_RIMBORSO
col C2 new_value P2
select nvl(max(riri_id),0) mnr
      ,nvl(max(riri_id),0)+1  C2 
  from richieste_rimborso
;
drop SEQUENCE RIRI_SQ
;
CREATE SEQUENCE RIRI_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence RIRR_SQ su campo RIRR_ID della Table RIGHE_RICHIESTA_RIMBORSO
col C2 new_value P2
select nvl(max(rirr_id),0) mnr 
      ,nvl(max(rirr_id),0)+1  C2 
  from righe_richiesta_rimborso
;
drop SEQUENCE RIRR_SQ
;
CREATE SEQUENCE RIRR_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence DIST_SQ su campo NUMERO_DISTINTA della Table RICHESTE_RIMBORSO
col C2 new_value P2
select nvl(max(numero_distinta),0) mnd 
      ,nvl(max(numero_distinta),0)+1  C2 
  from richieste_rimborso
;
drop SEQUENCE DIST_SQ
;
CREATE SEQUENCE DIST_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence GP4MT_DEVE_ID su campo DEVE_ID della Table DEPOSITO_VARIABILI_ECONOMICHE input PMT
col C2 new_value P2
select nvl(max(deve_id),0) mng
      ,nvl(max(deve_id),0)+1  C2 
  from deposito_variabili_economiche
 where input = 'PMT'
;
drop SEQUENCE GP4MT_DEVE_ID
;
CREATE SEQUENCE GP4MT_DEVE_ID
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence POII_SQ su campo POII_ID della Table PONDERAZIONI_INAIL_INDIVIDUALI
col C2 new_value P2
select nvl(max(POII_ID),0) mng
      ,nvl(max(POII_ID),0)+1  C2 
  from PONDERAZIONI_INAIL_INDIVIDUALI
;
drop SEQUENCE POII_SQ
;
CREATE SEQUENCE POII_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence ATPI_SQ su campo POII_ID della Table ATTRIBUZIONI_POSIZIONE_INAIL
col C2 new_value P2
select nvl(max(ATPI_ID),0) mng
      ,nvl(max(ATPI_ID),0)+1  C2 
  from ATTRIBUZIONI_POSIZIONE_INAIL
;
drop SEQUENCE ATPI_SQ
;
CREATE SEQUENCE ATPI_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;

PROMPT Creating Sequence INMO_SQ su campo PROGRESSIVO della Table INDIVIDUI_MODIFICATI
col C2 new_value P2
select nvl(max(PROGRESSIVO),0) mng
      ,nvl(max(PROGRESSIVO),0)+1  C2 
  from INDIVIDUI_MODIFICATI
;
drop SEQUENCE INMO_SQ
;
CREATE SEQUENCE INMO_SQ
 INCREMENT BY 1
 START WITH &P2
 MINVALUE 1
 MAXVALUE 9999999999
 NOCYCLE 
 CACHE 2
 NOORDER 
;


