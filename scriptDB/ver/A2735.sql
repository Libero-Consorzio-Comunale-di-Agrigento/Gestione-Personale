-- Riabilitazione delle guide di PO e successiva eliminazione per chi NON ha la PO con test su menu principale

delete from a_guide_o where guida_o = 'P_FIGI_Q';

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGI_Q','1','FIGU','R','Rettifica','','PGMDFIGU','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGI_Q','2','POFU','Z','posiZ.f.','','PGMEPOFU','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGI_Q','3','PEGI','I','Inquadr.','','PGMRPEGI','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGI_Q','4','POPI','O','Organico','','PPORPOPI','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGI_Q','5','QUAL','Q','Qualifica','P_QUAL_Q','','');

delete from a_guide_o where guida_o = 'P_FIGU';   

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU','1','FIGU','E','Elenco','P_FIGU_Q','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU','2','PRPR','R','pRof.pr.','','PGMDPRPR','');   
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU','3','POFU','Z','posiZ.f.','P_POFU','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU','4','CARR','C','Carriere','','PGMDCARR','');   
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU','5','QUAL','Q','Qualifica','P_QUAL','','');    
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU','6','PEGI','I','Inquadr.','','PGMRPEGI','');   
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU','7','POPI','O','Organico','','PPORPOPI','');   
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU','8','CRFI','G','cod.reG.','','PGMDCRFI','');   
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU','9','CONT','T','conTratti','','PGMDCONT','');  

delete from a_guide_o where guida_o = 'P_FIGU_Q';  

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU_Q','1','FIGU','R','Rettifica','','PGMDFIGU','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU_Q','2','FIGU','S','Storico','','PGMRFIGU','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU_Q','3','POFU','Z','posiZ.f.','','PGMEPOFU',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU_Q','4','PEGI','I','Inquadr.','','PGMRPEGI',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU_Q','5','POPI','O','Organico','','PPORPOPI',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_FIGU_Q','6','QUAL','Q','Qualifica','P_QUAL_Q','','');

delete from a_guide_o where guida_o = 'P_PEGI_E'; 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_E','1','PEGI','E','Elenco','P_PEGI_Q','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_E','2','PEGI','P','Periodi','P_PEGI_E','',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_E','3','EVGI','V','eVenti','P_EVGI','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_E','4','DELI','D','Delibere','P_DELI','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_E','5','FIGU','F','Figure','P_FIGU','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_E','6','ATTI','A','Attivita''','','PGMDATTI',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_E','7','SETT','S','Sudd.set.','P_SETT','',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_E','8','POOR','O','Organico', 'P_POOR','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_E','9','PEGI','C','Contabile','P_RARE','',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_E','10','PEGI','C','Contabile','P_RARE','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_E','11','UNO','A','Att.giur.','','PGMAATGI',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_E','12','UNO','G','r.att.Giu','','PGMRATGI',''); 

delete from a_guide_o where guida_o = 'P_PEGI_F';  

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_F','1','PEGI','E','Elenco','P_PEGI_Q','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_F','2','PEGI','P','Periodi','P_PEGI_F','','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_F','3','EVGI','V','eVenti','P_EVGI','','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_F','4','DELI','D','Delibere','P_DELI','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_F','5','FIGU','F','Figure','P_FIGU','','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_F','6','ATTI','A','Attivita''','','PGMDATTI','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_F','7','SETT','S','Sudd.set.','P_SETT','','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_F','8','POOR','O','Organico','P_POOR','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_F','9','PEGI','C','Contabile','P_RARE','','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_F','10','PEGI','I','pos.Inail','','PGMAPOIN','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_F','11','PEGI','E','pOsti esa','','PDOADOES','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_F','14','VISU','S','el.suBen.','','PGMRPESU','');  
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_F','15','UNO','A','Att.giur.','','PGMAATGI','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI_F','16','UNO','G','r.att.Giu','','PGMRATGI','');

delete from a_guide_o where guida_o = 'P_PEAS'; 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEAS','1','PEGI','E','Elenco','P_PEGI_Q','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEAS','2','PEGI','P','Periodi','P_PEAS','',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEAS','3','ASTE','A','Assenze','P_ASTE','',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEAS','4','POOR','O','Organico','P_POOR','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEAS','5','DELI','D','Delibere','P_DELI','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEAS','6','PEGI','C','Contabile','P_RARE','',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEAS','7','UNO','A','Att.giur.','','PGMAATGI','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEAS','8','UNO','G','r.att.Giu','','PGMRATGI','');

delete from a_guide_o where guida_o = 'P_PEGI'; 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI','1','PEGI','E','Elenco','P_PEGI_Q','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI','2','PEGI','P','Periodi','P_PEGI_P','',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI','3','EVGI','V','eVenti','P_EVGI','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI','4','DELI','D','Delibere','P_DELI','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI','5','FIGU','F','Figure','P_FIGU','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI','6','ATTI','A','Attivita''','','PGMDATTI',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI','7','SETT','S','Sudd.set.','P_SETT','',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif) 
values ('P_PEGI','8','POOR','O','Organico','P_POOR','','');

delete from a_guide_v where guida_v = 'P_POOR'; 

insert into a_guide_v (guida_v,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_POOR','1','','T','ricerca per Titolare','PGMRSOST','*');  
insert into a_guide_v (guida_v,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_POOR','2','','P','ricerca Posti','PPOEPOOR',''); 
insert into a_guide_v (guida_v,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_POOR','5','','E','Elenco storia posto','PPOEPOPI',''); 
insert into a_guide_v (guida_v,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_POOR','6','','C','Copertura posto','PPOCPOPI','');  
insert into a_guide_v (guida_v,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_POOR','7','','S','Sostituzioni','PGMESOGI','');  

-- eliminazione dalle guide delle voci del modulo PO in caso di modulo DO

delete from a_guide_o 
 where guida_o = 'P_FIGI_Q' 
   and voce_menu = 'PPORPOPI'
   and not exists ( select 'x' 
                      from a_menu 
                     where voce_menu = 'PPOPO'
                       and ruolo != '*'
                  );

delete from a_guide_o 
 where guida_o = 'P_FIGU'
   and voce_menu = 'PPORPOPI'
   and not exists ( select 'x' 
                      from a_menu 
                     where voce_menu = 'PPOPO'
                       and ruolo != '*'
                  );

delete from a_guide_o 
 where guida_o = 'P_FIGU_Q'
   and voce_menu = 'PPORPOPI'
   and not exists ( select 'x' 
                      from a_menu 
                     where voce_menu = 'PPOPO'
                       and ruolo != '*'
                  );

delete from a_guide_o 
 where guida_o = 'P_PEGI_E'
   and guida_v = 'P_POOR'
   and not exists ( select 'x' 
                      from a_menu 
                     where voce_menu = 'PPOPO'
                       and ruolo != '*'
                  );

delete from a_guide_o 
 where guida_o = 'P_PEGI_F'
   and guida_v = 'P_POOR'
   and not exists ( select 'x' 
                      from a_menu 
                     where voce_menu = 'PPOPO'
                       and ruolo != '*'
                  );

delete from a_guide_o 
 where guida_o = 'P_PEAS'
   and guida_v = 'P_POOR'
   and not exists ( select 'x' 
                      from a_menu 
                     where voce_menu = 'PPOPO'
                       and ruolo != '*'
                  );

delete from a_guide_o 
 where guida_o = 'P_PEGI'
   and guida_v = 'P_POOR'
   and not exists ( select 'x' 
                      from a_menu 
                     where voce_menu = 'PPOPO'
                       and ruolo != '*'
                  );

delete from a_guide_v 
 where guida_v = 'P_POOR'
   and not exists ( select 'x' 
                      from a_menu 
                     where voce_menu = 'PPOPO'
                       and ruolo != '*'
                  ); 