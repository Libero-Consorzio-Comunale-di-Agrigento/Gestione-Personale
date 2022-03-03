CREATE OR REPLACE FORCE VIEW VISTA_DOTAZIONE_ORGANICA
(REVISIONE, DOOR_ID, DOTAZIONE, NUMERO, NUMERO_ORE)
AS 
select door.revisione
      ,door.door_id
 	  ,decode(gestione,'%',to_char(null),'Gestione: '||rpad(door.gestione,4,' '))||
 	   decode(settore,'%',to_char(null),' Settore: '||rpad(door.settore,15,' '))||
 	   decode(ruolo,'%',to_char(null),' Ruolo: '||rpad(door.ruolo,4,' '))||
 	   decode(profilo,'%',to_char(null),' Profilo: '||rpad(door.profilo,4,' '))||
 	   decode(posizione,'%',to_char(null),' Posizione: '||rpad(door.posizione,4,' '))||
 	   decode(attivita,'%',to_char(null),' Attivita: '||rpad(door.attivita,4,' '))||
 	   decode(figura,'%',to_char(null),' Figura: '||rpad(door.figura,8,' '))||
 	   decode(qualifica,'%',to_char(null),' Qualifica: '||rpad(door.qualifica,8,' '))||
 	   decode(livello,'%',to_char(null),' Livello: '||rpad(door.livello,4,' '))||
 	   decode(tipo_rapporto,'%',to_char(null),' Tipo Rapporto: '||rpad(door.tipo_rapporto,4,' '))||
 	   decode(ore,'',to_char(null),' Ore: '||rpad(door.ore,5,' '))      	   dotazione
	  ,door.numero
	  ,door.numero_ore
  from dotazione_organica door
/


