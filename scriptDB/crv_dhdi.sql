CREATE OR REPLACE VIEW DOTAZIONE_XORE_DIRITTO ( UTENTE, 
DATA, REVISIONE, DOOR_ID, GESTIONE, 
ORE, NUM_PREV, ORE_PREV, EFFETTIVI, 
DI_RUOLO, ASSENTI, INCARICATI, NON_RUOLO, 
CONTRATTISTI, SOVRANNUMERO,NUMERO ) AS select rido.UTENTE 
      ,rido.data 
      ,redo.revisione 
      ,gp4_pegi.get_pegi_door_id(pegi.ci,pegi.rilevanza,pegi.dal,redo.revisione) door_id 
	  ,pegi.gestione 
      ,pegi.ore 
      ,max(gp4_door.get_numero(redo.revisione,gp4_pegi.get_pegi_door_id(pegi.ci,pegi.rilevanza,pegi.dal,redo.revisione))) num_prev 
      ,max(gp4_door.get_numero_ore(redo.revisione,gp4_pegi.get_pegi_door_id(pegi.ci,pegi.rilevanza,pegi.dal,redo.revisione))) ore_prev 
      ,count(ci)                                                          effettivi 
      ,sum(decode(gp4_posi.get_ruolo(pegi.POSIZIONE),'SI',1,0)) di_ruolo 
      ,sum(gp4gm.get_se_ASSENTE(pegi.ci,rido.DATA))             assenti 
      ,sum(gp4gm.get_se_incaricato(pegi.ci,rido.DATA))          incaricati 
      ,sum(decode(gp4_posi.get_ruolo(pegi.POSIZIONE),'NO',1,0)) NON_RUOLO 
      ,sum(decode(gp4_posi.GET_CONTRATTO_OPERA(pegi.POSIZIONE),'NO',1,0)) contrattisti 
      ,sum(decode(gp4_posi.GET_SOVRANNUMERO(pegi.POSIZIONE),'NO',1,0))    sovrannumero
      ,count(ci)                                                          numero 
  from periodi_giuridici        pegi 
	  ,revisioni_dotazione      redo 
      ,riferimento_dotazione    rido 
 where pegi.rilevanza = 'Q' 
   and rido.data between pegi.dal 
                     and nvl(pegi.al,to_date(3333333,'j')) 
 group by rido.utente 
         ,rido.data 
         ,redo.revisione 
         ,pegi.gestione 
         ,gp4_pegi.get_pegi_door_id(pegi.ci,pegi.rilevanza,pegi.dal,redo.revisione) 
         ,pegi.ore
;

