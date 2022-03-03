CREATE OR REPLACE PACKAGE AGGIORNO_A10364_1 IS
PROCEDURE MAIN		;
          FUNCTION  VERSIONE      	RETURN varchar2;
end;
/

CREATE OR REPLACE PACKAGE BODY AGGIORNO_A10364_1 IS
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 0    21/03/2005 CB
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 21/03/2005';
END VERSIONE;
--
procedure main  is
/******************************************************************************
 NOME:        
 DESCRIZIONE: 
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 0    21/03/2005 CB     Aggiorna i record di pegi con posizione nulla leggendo 
                        quella dell'evento giuridico se specificata, oppure quella 
                       del periodo precedente a parità di CI e Rilevanza  
******************************************************************************/
begin
declare
app number := 0;
ESCI 				   exception;
begin
   FOR rec_evgi1 IN
      (select pegi.ci,evgi.codice,evgi.posizione,pegi.dal,pegi.al,pegi.rilevanza
         from eventi_giuridici evgi
            , periodi_giuridici pegi
        where pegi.evento    = evgi.codice
        and   pegi.rilevanza in ('Q','S','I','E')
        and   pegi.posizione is null
        and   evgi.posizione is not null
        order by ci,pegi.dal) LOOP
        begin
          app :=1;
          update periodi_giuridici
           set posizione     = rec_evgi1.posizione
          where ci           = rec_evgi1.ci
          and rilevanza      = rec_evgi1.rilevanza
          and dal            = rec_evgi1.dal
          and evento         = rec_evgi1.codice
          and posizione is null
          ;
        end;
    END LOOP;
    if app=0 then
       for cur1 in
        (select ci,rilevanza,dal,evento
         from   periodi_giuridici
         where  rilevanza in ('Q','S','I','E')
         and    posizione is null
         )
         loop
          begin
           INSERT INTO  PEGI_A10364_1 (DESCRIZIONE) VALUES (  '1^ Posizione di eventi_giuridici nullo, mancato aggiornamento del record : '
                                                            ||'Cod.Ind.:'|| to_char(cur1.ci)||','
                                                            ||'Ril.:'    || cur1.rilevanza  ||','
                                                            ||'Dal:'    || to_char(cur1.dal,'dd/mm/yyyy') ||','
                                                            ||'Evento:'  || cur1.evento );
          commit;    
          end;
         end loop;
    else
       commit;
       app:=0;
    end if;

    FOR rec_evgi2 IN
        (select pegi.ci,evgi.codice,evgi.posizione,pegi.dal,pegi.al,pegi.rilevanza
         from eventi_giuridici evgi
            , periodi_giuridici pegi
        where pegi.evento    = evgi.codice
        and   pegi.rilevanza in ('Q','S','I','E')
        and   pegi.posizione is null
        and   evgi.posizione is null
        order by ci,pegi.dal) LOOP
        begin
         for cur in
          (select posizione
           from   periodi_giuridici
           where  ci         = rec_evgi2.ci
           and    rilevanza  = rec_evgi2.rilevanza
           and posizione is not null
           and al            =  rec_evgi2.dal-1
           order by ci,dal) loop
           begin
            app :=1;
            update periodi_giuridici
            set posizione     = cur.posizione
            where ci          = rec_evgi2.ci
            and rilevanza     = rec_evgi2.rilevanza
            and posizione is  null
            and dal           =  rec_evgi2.dal;
          end;
        end loop;
       end;
     END LOOP;
     if app=0 then
          for cur2 in
          (select ci,rilevanza,dal,evento
           from   periodi_giuridici
           where  rilevanza in ('Q','S','I','E')
           and    posizione is null
           )
           loop
            begin
            INSERT INTO  PEGI_A10364_1 (DESCRIZIONE) VALUES ( '2^ Posizione periodo precedente non valida, mancato aggiornamento del record : '
                                                            ||'Cod.Ind.:'|| to_char(cur2.ci)||','
                                                            ||'Ril.:'    || cur2.rilevanza  ||','
                                                            ||'Dal:'    || to_char(cur2.dal,'dd/mm/yyyy') ||','
                                                            ||'Evento:'  || cur2.evento );
          commit;    
            end;
           end loop;
         else
            commit;
            app:=0;
         end if;
 END;
end;
end;
/

