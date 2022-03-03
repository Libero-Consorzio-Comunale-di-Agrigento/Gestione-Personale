-- sistemazione dei menu in upgrade

create table vome_ante_49 as select * from a_voci_menu;
create table pass_ante_49 as select * from a_passi_proc;
create table sele_ante_49 as select * from a_selezioni;
create table dose_ante_49 as select * from a_domini_selezioni;
create table cats_ante_49 as select * from a_catalogo_stampe;
create table menu_ante_49 as select * from a_menu;
create table guor_ante_49 as select * from a_guide_o;
create table guve_ante_49 as select * from a_guide_v;

-- cancellazione abilitazioni doppie e voci non più in uso

delete from a_menu where voce_menu = 'PAMECATE' and padre = 1000105;
delete from a_menu where voce_menu = 'PGMEREST' and padre = 1000187;
delete from a_menu where voce_menu = 'PGMESTAM' and padre = 1000187;
delete from a_menu where voce_menu = 'PECCDEIN' and padre = 1000548;
delete from a_menu where voce_menu = 'PGMSDOPE' and padre = 1000548;
delete from a_menu where voce_menu = 'PGMSDOEF' and padre = 1000548;
delete from a_menu where voce_menu = 'PGMDQUST' and padre = 1000220;
delete from a_menu where voce_menu = 'PTCAPSTD' and padre = 1002610;
delete from a_menu where voce_menu = 'PECLTAVO' and padre = 1013142;
delete from a_menu where voce_menu = 'PECLRIVO' and padre = 1013142;
delete from a_menu where voce_menu = 'PECLIMVO' and padre = 1013142;
delete from a_menu where voce_menu = 'PECSESRE' and padre = 1013142;
delete from a_menu where voce_menu = 'PPALFOCA' and padre = 1013142;
delete from a_menu where voce_menu = 'PPALVCEV' and padre = 1013142;
delete from a_menu where voce_menu = 'PECDMONO' and padre = 1000549;
delete from a_menu where voce_menu = 'PECEANOC' and padre = 1000549;
delete from a_menu where voce_menu = 'PECANOIN' and padre = 1000549;
delete from a_menu where voce_menu = 'PECENOIN' and padre = 1000549;
delete from a_menu where voce_menu = 'PGMRSOST' and padre = 1000195;
delete from a_menu where voce_menu = 'PGMDSEST' and figlio = 1013494;

delete from a_voci_menu where voce_menu = 'PGMSCESE';
delete from a_passi_proc where voce_menu = 'PGMSCESE';
delete from a_selezioni where voce_menu = 'PGMSCESE';
delete from a_menu where voce_menu = 'PGMSCESE'; 
delete from a_catalogo_stampe where stampa = 'PGMSCESE' and stampa not in ( select stampa from a_passi_proc );

delete from a_voci_menu where voce_menu = 'PGMAVOSC';
delete from a_passi_proc where voce_menu = 'PGMAVOSC';
delete from a_selezioni where voce_menu = 'PGMAVOSC';
delete from a_menu where voce_menu = 'PGMAVOSC';

delete from a_voci_menu where voce_menu = 'PECCCSTO';
delete from a_passi_proc where voce_menu = 'PECCCSTO';
delete from a_selezioni where voce_menu = 'PECCCSTO';
delete from a_menu where voce_menu = 'PECCCSTO';

delete from a_voci_menu where voce_menu = 'PECCSTOR';
delete from a_passi_proc where voce_menu = 'PECCSTOR';
delete from a_selezioni where voce_menu = 'PECCSTOR';
delete from a_menu where voce_menu = 'PECCSTOR';

delete from a_voci_menu where voce_menu = 'PECCADED';
delete from a_passi_proc where voce_menu = 'PECCADED';
delete from a_selezioni where voce_menu = 'PECCADED';
delete from a_menu where voce_menu = 'PECCADED';

delete from a_voci_menu where voce_menu = 'PECCCDMA';
delete from a_passi_proc where voce_menu = 'PECCCDMA';
delete from a_selezioni where voce_menu = 'PECCCDMA';
delete from a_menu where voce_menu = 'PECCCDMA';

delete from a_voci_menu where voce_menu = 'PECSDEI2';
delete from a_catalogo_stampe where stampa = 'PECSDEI2';
delete from a_passi_proc where voce_menu = 'PECSDEI2';
delete from a_selezioni where voce_menu = 'PECSDEI2';
delete from a_menu where voce_menu = 'PECSDEI2';

delete from a_voci_menu where voce_menu = 'PECSDEI3';
delete from a_catalogo_stampe where stampa = 'PECSDEI3';
delete from a_passi_proc where voce_menu = 'PECSDEI3';
delete from a_selezioni where voce_menu = 'PECSDEI3';
delete from a_menu where voce_menu = 'PECSDEI3';

delete from a_voci_menu where voce_menu = 'PECLDCFS';
delete from a_catalogo_stampe where stampa = 'PECLDCFS';
delete from a_passi_proc where voce_menu = 'PECLDCFS';
delete from a_selezioni where voce_menu = 'PECLDCFS';
delete from a_menu where voce_menu = 'PECLDCFS';

delete from a_voci_menu where voce_menu = 'PECXAC7B';
delete from a_passi_proc where voce_menu = 'PECXAC7B';
delete from a_selezioni where voce_menu = 'PECXAC7B';
delete from a_menu where voce_menu = 'PECXAC7B';

delete from a_voci_menu where voce_menu = 'PECXAC61';
delete from a_passi_proc where voce_menu = 'PECXAC61';
delete from a_selezioni where voce_menu = 'PECXAC61';
delete from a_menu where voce_menu = 'PECXAC61';

delete from a_voci_menu where voce_menu = 'PROVARFI'; 
delete from a_passi_proc where voce_menu = 'PROVARFI';
delete from a_selezioni where voce_menu = 'PROVARFI';
delete from a_menu where voce_menu = 'PROVARFI';

delete from a_voci_menu where voce_menu = 'PECSMTEL';
delete from a_passi_proc where voce_menu = 'PECSMTEL';
delete from a_selezioni where voce_menu = 'PECSMTEL';
delete from a_menu where voce_menu = 'PECSMTEL'; 

delete from a_voci_menu where voce_menu = 'PECDON05';
delete from a_passi_proc where voce_menu = 'PECDON05';
delete from a_selezioni where voce_menu = 'PECDON05';
delete from a_menu where voce_menu = 'PECDON05';
delete from a_catalogo_stampe where stampa = 'PECDON05';

delete from a_voci_menu where voce_menu = 'PECDVO13';
delete from a_catalogo_stampe where stampa = 'PECDVO13';
delete from a_passi_proc where voce_menu = 'PECDVO13';
delete from a_selezioni where voce_menu = 'PECDVO13';
delete from a_menu where voce_menu = 'PECDVO13';
delete from a_domini_selezioni where dominio = 'P_PECDVO13_IR';
delete from a_domini_selezioni where dominio = 'P_PECDVO13_MAT';
delete from a_domini_selezioni where dominio = 'P_PECDVO13_MG';
delete from a_domini_selezioni where dominio = 'P_PECDVO13_PA';

delete from a_voci_menu where voce_menu = 'PPAPAAC';
delete from a_passi_proc where voce_menu = 'PPAPAAC';
delete from a_selezioni where voce_menu = 'PPAPAAC';
delete from a_menu where voce_menu = 'PPAPAAC';

delete from a_voci_menu where voce_menu = 'PPACCOCA';
delete from a_passi_proc where voce_menu = 'PPACCOCA';
delete from a_selezioni where voce_menu = 'PPACCOCA';
delete from a_menu where voce_menu = 'PPACCOCA';

delete from a_voci_menu where voce_menu = 'PPACCOCM';
delete from a_passi_proc where voce_menu = 'PPACCOCM';
delete from a_selezioni where voce_menu = 'PPACCOCM';
delete from a_menu where voce_menu = 'PPACCOCM';

delete from a_voci_menu where voce_menu = 'PPAXCOCA';
delete from a_passi_proc where voce_menu = 'PPAXCOCA';
delete from a_selezioni where voce_menu = 'PPAXCOCA';
delete from a_menu where voce_menu = 'PPAXCOCA';

delete from a_voci_menu where voce_menu = 'PIAIAPPO';
delete from a_passi_proc where voce_menu = 'PIAIAPPO';
delete from a_selezioni where voce_menu = 'PIAIAPPO';
delete from a_menu where voce_menu = 'PIAIAPPO';

delete from a_voci_menu where voce_menu = 'PIAIAPPA';
delete from a_passi_proc where voce_menu = 'PIAIAPPA';
delete from a_selezioni where voce_menu = 'PIAIAPPA';
delete from a_menu where voce_menu = 'PIAIAPPA';

delete from a_voci_menu where voce_menu = 'PIAIAPMA';
delete from a_passi_proc where voce_menu = 'PIAIAPMA';
delete from a_selezioni where voce_menu = 'PIAIAPMA';
delete from a_menu where voce_menu = 'PIAIAPMA';

delete from a_voci_menu where voce_menu = 'PIAIAPIP';
delete from a_passi_proc where voce_menu = 'PIAIAPIP';
delete from a_selezioni where voce_menu = 'PIAIAPIP';
delete from a_menu where voce_menu = 'PIAIAPIP';

delete from a_voci_menu where voce_menu = 'PIAIAPGM';
delete from a_passi_proc where voce_menu = 'PIAIAPGM';
delete from a_selezioni where voce_menu = 'PIAIAPGM';
delete from a_menu where voce_menu = 'PIAIAPGM';

delete from a_voci_menu where voce_menu = 'PIAIAPGE';
delete from a_passi_proc where voce_menu = 'PIAIAPGE';
delete from a_selezioni where voce_menu = 'PIAIAPGE';
delete from a_menu where voce_menu = 'PIAIAPGE';

delete from a_voci_menu where voce_menu = 'PIAIAPEC';
delete from a_passi_proc where voce_menu = 'PIAIAPEC';
delete from a_selezioni where voce_menu = 'PIAIAPEC';
delete from a_menu where voce_menu = 'PIAIAPEC';

delete from a_voci_menu where voce_menu = 'PIAIAAPO';
delete from a_passi_proc where voce_menu = 'PIAIAAPO';
delete from a_selezioni where voce_menu = 'PIAIAAPO';
delete from a_menu where voce_menu = 'PIAIAAPO';

delete from a_voci_menu where voce_menu = 'PIAIAAPA';
delete from a_passi_proc where voce_menu = 'PIAIAAPA';
delete from a_selezioni where voce_menu = 'PIAIAAPA';
delete from a_menu where voce_menu = 'PIAIAAPA';

delete from a_voci_menu where voce_menu = 'PIAIAAMA';
delete from a_passi_proc where voce_menu = 'PIAIAAMA';
delete from a_selezioni where voce_menu = 'PIAIAAMA';
delete from a_menu where voce_menu = 'PIAIAAMA';

delete from a_voci_menu where voce_menu = 'PIAIAAIP';
delete from a_passi_proc where voce_menu = 'PIAIAAIP';
delete from a_selezioni where voce_menu = 'PIAIAAIP';
delete from a_menu where voce_menu = 'PIAIAAIP';

delete from a_voci_menu where voce_menu = 'PIAIAAGM';
delete from a_passi_proc where voce_menu = 'PIAIAAGM';
delete from a_selezioni where voce_menu = 'PIAIAAGM';
delete from a_menu where voce_menu = 'PIAIAAGM';

delete from a_voci_menu where voce_menu = 'PIAIAAGE';
delete from a_passi_proc where voce_menu = 'PIAIAAGE';
delete from a_selezioni where voce_menu = 'PIAIAAGE';
delete from a_menu where voce_menu = 'PIAIAAGE';

delete from a_voci_menu where voce_menu = 'PIAIAAEC';
delete from a_passi_proc where voce_menu = 'PIAIAAEC';
delete from a_selezioni where voce_menu = 'PIAIAAEC';
delete from a_menu where voce_menu = 'PIAIAAEC';

delete from a_voci_menu where voce_menu = 'PIAAAIIA';
delete from a_passi_proc where voce_menu = 'PIAAAIIA';
delete from a_selezioni where voce_menu = 'PIAAAIIA';
delete from a_menu where voce_menu = 'PIAAAIIA';

delete from a_voci_menu where voce_menu = 'PIAAAIAP';
delete from a_passi_proc where voce_menu = 'PIAAAIAP';
delete from a_selezioni where voce_menu = 'PIAAAIAP';
delete from a_menu where voce_menu = 'PIAAAIAP';

delete from a_voci_menu where voce_menu = 'PIAAAIAL';
delete from a_passi_proc where voce_menu = 'PIAAAIAL';
delete from a_selezioni where voce_menu = 'PIAAAIAL';
delete from a_menu where voce_menu = 'PIAAAIAL';

delete from a_voci_menu where voce_menu = 'PIAAAIAA';
delete from a_passi_proc where voce_menu = 'PIAAAIAA';
delete from a_selezioni where voce_menu = 'PIAAAIAA';
delete from a_menu where voce_menu = 'PIAAAIAA';

delete from a_voci_menu where voce_menu = 'PAAAAIAQ';
delete from a_passi_proc where voce_menu = 'PAAAAIAQ';
delete from a_selezioni where voce_menu = 'PAAAAIAQ';
delete from a_menu where voce_menu = 'PAAAAIAQ';

delete from a_voci_menu where voce_menu = 'PIAAAIN';
delete from a_passi_proc where voce_menu = 'PIAAAIN';
delete from a_selezioni where voce_menu = 'PIAAAIN';
delete from a_menu where voce_menu = 'PIAAAIN';

delete from a_voci_menu where voce_menu = 'PAAAAMAD';
delete from a_passi_proc where voce_menu = 'PAAAAMAD';
delete from a_selezioni where voce_menu = 'PAAAAMAD';
delete from a_menu where voce_menu = 'PAAAAMAD';

delete from a_voci_menu where voce_menu = 'PAAAAMRD';
delete from a_passi_proc where voce_menu = 'PAAAAMRD';
delete from a_selezioni where voce_menu = 'PAAAAMRD';
delete from a_menu where voce_menu = 'PAAAAMRD';

delete from a_voci_menu where voce_menu = 'PAAAAMVS';
delete from a_passi_proc where voce_menu = 'PAAAAMVS';
delete from a_selezioni where voce_menu = 'PAAAAMVS';
delete from a_menu where voce_menu = 'PAAAAMVS';

delete from a_voci_menu where voce_menu = 'PAAAAMVU';
delete from a_passi_proc where voce_menu = 'PAAAAMVU';
delete from a_selezioni where voce_menu = 'PAAAAMVU';
delete from a_menu where voce_menu = 'PAAAAMVU';

delete from a_voci_menu where voce_menu = 'PAAABDEC';
delete from a_passi_proc where voce_menu = 'PAAABDEC';
delete from a_selezioni where voce_menu = 'PAAABDEC';
delete from a_menu where voce_menu = 'PAAABDEC';

delete from a_voci_menu where voce_menu = 'PAACBDEC';
delete from a_passi_proc where voce_menu = 'PAACBDEC';
delete from a_selezioni where voce_menu = 'PAACBDEC';
delete from a_menu where voce_menu = 'PAACBDEC';

delete from a_voci_menu where voce_menu = 'PAAEBDEC';
delete from a_passi_proc where voce_menu = 'PAAEBDEC';
delete from a_selezioni where voce_menu = 'PAAEBDEC';
delete from a_menu where voce_menu = 'PAAEBDEC';

delete from a_voci_menu where voce_menu = 'PAAIBDEC';
delete from a_passi_proc where voce_menu = 'PAAIBDEC';
delete from a_selezioni where voce_menu = 'PAAIBDEC';
delete from a_menu where voce_menu = 'PAAIBDEC';

delete from a_voci_menu where voce_menu = 'PAAXBDEC';
delete from a_passi_proc where voce_menu = 'PAAXBDEC';
delete from a_selezioni where voce_menu = 'PAAXBDEC';
delete from a_menu where voce_menu = 'PAAXBDEC';

delete from a_voci_menu where voce_menu = 'PECCONAR';
delete from a_passi_proc where voce_menu = 'PECCONAR';
delete from a_selezioni where voce_menu = 'PECCONAR';
delete from a_menu where voce_menu = 'PECCONAR';

delete from a_voci_menu where voce_menu = 'PECVCIRE';
delete from a_passi_proc where voce_menu = 'PECVCIRE';
delete from a_selezioni where voce_menu = 'PECVCIRE';
delete from a_menu where voce_menu = 'PECVCIRE';
delete from a_catalogo_stampe where stampa = 'PECVCIRE';

delete from a_voci_menu where voce_menu = 'PECVCIRP';
delete from a_passi_proc where voce_menu = 'PECVCIRP';
delete from a_selezioni where voce_menu = 'PECVCIRP';
delete from a_menu where voce_menu = 'PECVCIRP';

delete from a_voci_menu where voce_menu = 'PGMLDNDG';
delete from a_catalogo_stampe where stampa = 'PGMLDNDG';
delete from a_passi_proc where voce_menu = 'PGMLDNDG';
delete from a_selezioni where voce_menu = 'PGMLDNDG';
delete from a_menu where voce_menu = 'PGMLDNDG';

delete from a_voci_menu where voce_menu = 'PECVD';
delete from a_passi_proc where voce_menu = 'PECVD';
delete from a_selezioni where voce_menu = 'PECVD';
delete from a_menu where voce_menu = 'PECVD';

delete from a_voci_menu where voce_menu = 'PECSMT8A';
delete from a_catalogo_stampe where stampa = 'PECSMT8A';
delete from a_passi_proc where voce_menu = 'PECSMT8A';
delete from a_selezioni where voce_menu = 'PECSMT8A';
delete from a_menu where voce_menu = 'PECSMT8A';

delete from a_voci_menu where voce_menu = 'PECSMT8B';
delete from a_catalogo_stampe where stampa = 'PECSMT8B';
delete from a_passi_proc where voce_menu = 'PECSMT8B';
delete from a_selezioni where voce_menu = 'PECSMT8B';
delete from a_menu where voce_menu = 'PECSMT8B';

delete from a_voci_menu where voce_menu = 'PECSMT8C';
delete from a_catalogo_stampe where stampa = 'PECSMT8C';
delete from a_passi_proc where voce_menu = 'PECSMT8C';
delete from a_selezioni where voce_menu = 'PECSMT8C';
delete from a_menu where voce_menu = 'PECSMT8C';

delete from a_voci_menu where voce_menu = 'PAASQLPL';
delete from a_passi_proc where voce_menu = 'PAASQLPL';
delete from a_selezioni where voce_menu = 'PAASQLPL';
delete from a_menu where voce_menu = 'PAASQLPL';

delete from a_menu where voce_menu = 'PECCSMVR' and ruolo != '*';

delete from a_voci_menu where voce_menu = 'PECLPDNA';
delete from a_passi_proc where voce_menu = 'PECLPDNA';
delete from a_selezioni where voce_menu = 'PECLPDNA';
delete from a_menu where voce_menu = 'PECLPDNA';

delete from a_voci_menu where voce_menu = 'PECSMSSN';
delete from a_catalogo_stampe where stampa = 'PECSMSSN';
delete from a_passi_proc where voce_menu = 'PECSMSSN';
delete from a_selezioni where voce_menu = 'PECSMSSN';
delete from a_menu where voce_menu = 'PECSMSSN';

delete from a_voci_menu where voce_menu = 'PECSMDMS';
delete from a_catalogo_stampe where stampa = 'PECSMDMS';
delete from a_passi_proc where voce_menu = 'PECSMDMS';
delete from a_selezioni where voce_menu = 'PECSMDMS';
delete from a_menu where voce_menu = 'PECSMDMS';

delete from a_voci_menu where voce_menu = 'PECSMCRD';
delete from a_catalogo_stampe where stampa = 'PECSMCRD';
delete from a_passi_proc where voce_menu = 'PECSMCRD';
delete from a_selezioni where voce_menu = 'PECSMCRD';
delete from a_menu where voce_menu = 'PECSMCRD';

delete from a_voci_menu where voce_menu = 'PECSM101';
delete from a_catalogo_stampe where stampa = 'PECSM101';
delete from a_passi_proc where voce_menu = 'PECSM101';
delete from a_selezioni where voce_menu = 'PECSM101';
delete from a_menu where voce_menu = 'PECSM101';

delete from a_voci_menu where voce_menu = 'PECSRCCP';
delete from a_catalogo_stampe where stampa = 'PECSRCCP';
delete from a_passi_proc where voce_menu = 'PECSRCCP';
delete from a_selezioni where voce_menu = 'PECSRCCP';
delete from a_menu where voce_menu = 'PECSRCCP';

delete from a_voci_menu where voce_menu = 'PECCRCDP';
delete from a_catalogo_stampe where stampa = 'PECCRCDP';
delete from a_passi_proc where voce_menu = 'PECCRCDP';
delete from a_selezioni where voce_menu = 'PECCRCDP';
delete from a_menu where voce_menu = 'PECCRCDP';


-- sistemazione dei rami del menu

update a_menu 
   set padre = 1000187, figlio = 1013707, sequenza = 81 
 where voce_menu = 'PGMRSOGI' 
   and padre = 1000195;
update a_menu 
   set padre = 1000187, figlio = 1013768, sequenza = 82 
 where voce_menu = 'PGMRPESU'
   and padre = 1000195;
update a_menu 
   set padre = 1002253, figlio = 1013763, sequenza = 9  
 where voce_menu = 'PGMLSOGI'
   and padre = 1000195;
update a_menu 
   set padre = 1000222, figlio = 1013770, sequenza = 6 
 where voce_menu = 'PGMDATGI'
   and padre = 1000195;
update a_menu 
   set sequenza = 10
 where voce_menu = 'PGMDTIRA'
   and padre =  1000221;
update a_menu 
   set sequenza = 30
 where voce_menu = 'PGMDSTAT'
   and padre =  1000221;
update a_menu 
   set sequenza = 30
 where voce_menu = 'PGMDQUST'
   and padre =  1000221;
update a_menu 
   set sequenza = 50
 where voce_menu = 'PGMAAPEA'
   and padre =  1000222;
 update a_menu 
    set padre = 1000220, figlio = 1013539, sequenza = 84
  where voce_menu = 'PGMEUNOR'
    and padre = 1000187;

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','*','1000220','1020044','PGMDSTAT',69,'');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1000220','1020044','PGMDSTAT',69,'');

delete from a_menu 
 where voce_menu in ( 'PGMLPEGI','PGMLPEGM')
   and padre = 1013213;

update a_menu 
   set padre = 1013213, figlio = 1013218
 where voce_menu = 'PECLEVGM';
update a_menu 
   set padre = 1013213, figlio = 1013219
 where voce_menu = 'PECLMOGI';

delete from a_menu
 where voce_menu = 'PECCMOIP' and ruolo != '*'
   and not exists ( select 'x' from ad4_enti where note like '%ER31%');

delete from a_menu
 where voce_menu = 'PECCSMVR' 
   and ruolo != '*';

update a_menu 
   set padre = 1013306 , sequenza = 90
 where voce_menu = 'PECECASI';
update a_menu 
   set padre = 1000554, sequenza = 20
 where voce_menu = 'PECECCST';

update a_menu set sequenza = 4 where voce_menu = 'PECCARP6';
update a_menu set sequenza = 3 where voce_menu = 'PECCARR6';
update a_menu set padre = 1001040, sequenza = 4
 where voce_menu = 'PECEMOCA';

update a_menu set sequenza = 19 where voce_menu = 'PECSADIR';
update a_menu set sequenza = 20 where voce_menu = 'PECCSMDM';
update a_menu set sequenza = 41 where voce_menu = 'PECSESSN';
update a_menu set sequenza = 6  where voce_menu = 'PECSEPFI';
update a_menu set sequenza = 40 where voce_menu = 'PECSDEDI';
update a_menu set sequenza = 41 where voce_menu = 'PECCSR18';
update a_menu set sequenza = 42 where voce_menu = 'PECCDS22';

delete from a_menu 
 where voce_menu in ( 'PECEMOBI', 'PECEMOBD','PECRMOBI', 'PECRMEBI') 
;

update a_menu set padre = 1000557, sequenza = 7  where voce_menu = 'PECSRIFI';
update a_menu set padre = 1013640, sequenza = 60 where voce_menu = 'PECCALPI';
update a_menu set padre = 1013640, sequenza = 60 where voce_menu = 'PECAALPI';
update a_menu set padre = 1013640, sequenza = 60 where voce_menu = 'PECSALPI';
update a_menu set padre = 1000350, sequenza = 20 where voce_menu = 'PECEVONU';
update a_menu set padre = 1000467, sequenza = 60 where voce_menu = 'PECLBAVO';
update a_menu set padre = 1000467, sequenza = 65 where voce_menu = 'PECLBAVP';

update a_menu set sequenza = 35 where voce_menu = 'PPACDERI';

delete from a_selezioni where voce_menu in ( 'PECCSMV4', 'PECSMCU7', 'PROV');
delete from a_passi_proc where voce_menu in ( 'PECCMADP', 'PROVA');
delete from a_passi_proc where voce_menu in ( 'PXACALPR', 'PXACALRC', 'PXACALRM', 'PXACALRP', 'PXACALRR');

delete from a_menu where voce_menu = 'PXER08G4';
delete from a_passi_proc where voce_menu = 'PXER08G4';
delete from a_selezioni where voce_menu = 'PXER08G4';
delete from a_guide_o where voce_menu = 'PXER08G4';
delete from a_guide_v where voce_menu = 'PXER08G4';

-- Nuovo Menu per Modello CUD

delete from a_voci_menu where voce_menu = 'PECMCUD';
delete from a_menu where voce_menu = 'PECMCUD' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECMCUD','P00','MCUD','Modello CUD','N','M','','',1,'');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000555','1020046','PECMCUD','2','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000555','1020046','PECMCUD','2','');

update a_menu
   set padre = 1020046
 where voce_menu in  (  'PXCA01OD', 'PECECFFS' );

update a_menu set padre = 1020046, sequenza = 1 where voce_menu = 'PECATITS';
update a_menu set padre = 1020046, sequenza = 2 where voce_menu = 'PECCARFI';
update a_menu set padre = 1020046, sequenza = 3 where voce_menu = 'PECAARFI';
update a_menu set padre = 1020046, sequenza = 4 where voce_menu = 'PECCNOCU';
update a_menu set padre = 1020046, sequenza = 5 where voce_menu = 'PECANOCU';
update a_menu set padre = 1020046, sequenza = 6 where voce_menu = 'PECSMCU6';
update a_menu set padre = 1020046, sequenza = 10 where voce_menu = 'PECCADFA';
update a_menu set padre = 1020046, sequenza = 11 where voce_menu = 'PECAADFA';
update a_menu set padre = 1020046, sequenza = 12 where voce_menu = 'PECSMDSI';
update a_menu set padre = 1020046, sequenza = 15 where voce_menu = 'PECLACRD';
update a_menu set padre = 1001101, sequenza = 14 where voce_menu = 'PECAIMCE';
update a_menu set padre = 1001101, sequenza = 15 where voce_menu = 'PECEIMCE';
update a_menu set padre = 1001101, sequenza = 16 where voce_menu = 'PECLIMCE';
update a_menu set padre = 1001101, sequenza = 17 where voce_menu = 'PECSIMCE';
update a_menu set sequenza = 4 where voce_menu = 'PECSALBI' and padre = 1001101;
update a_menu set sequenza = 5 where voce_menu = 'PECVMOBI' and padre = 1001101;
update a_menu set sequenza = 91 where voce_menu = 'PECAINRE' ;

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000508', '1020048', 'PECLADIC', '14', '');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000508', '1020048', 'PECLADIC', '14', '');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000508', '1020049', 'PECLADIR', '15', '');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000508', '1020049', 'PECLADIR', '15', '');

update a_guide_v set voce_menu = 'PECARARE'  where voce_menu = 'PECARARP';

-- Nuovo Menu per Modello 770

delete from a_voci_menu where voce_menu = 'PECM770';
delete from a_menu where voce_menu = 'PECM770' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECM770','P00','M770','Modello 770','N','M','','',1,'');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000555','1020047','PECM770','3','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1000555','1020047','PECM770','3','');

update a_menu set padre = 1020047, sequenza = 1 where voce_menu = 'PECCASFI';
update a_menu set padre = 1020047, sequenza = 2 where voce_menu = 'PECAASFI';
update a_menu set padre = 1020047, sequenza = 3 where voce_menu = 'PECCATFR';
update a_menu set padre = 1020047, sequenza = 10 where voce_menu = 'PECL70SA';
update a_menu set padre = 1020047, sequenza = 11 where voce_menu = 'PECCSMFA';
update a_menu set padre = 1020047, sequenza = 20 where voce_menu = 'PECL70SC';
update a_menu set padre = 1020047, sequenza = 21 where voce_menu = 'PECCSMFC';

-- Sistemazione voci create in doppio

delete from a_voci_menu where voce_menu = 'PAA4IREC';
delete from a_passi_proc where voce_menu = 'PAA4IREC';
delete from a_selezioni where voce_menu = 'PAA4IREC';
delete from a_menu where voce_menu = 'PAA4IREC';
delete from a_voci_menu where voce_menu = 'PAAMIREC';
delete from a_passi_proc where voce_menu = 'PAAMIREC';
delete from a_selezioni where voce_menu = 'PAAMIREC';
delete from a_menu where voce_menu = 'PAAMIREC' and ruolo in ('*','AMM','PEC');
delete from a_catalogo_stampe where stampa = 'PAAAAMIR';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PAAMIREC','P00','MIREC','Integr. Economico-Contabile','F','D','','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIREC','1','Intregrita` Economico-Contabile','Q','PAAMIREC','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIREC','2','Intregrita` Economico-Contabile','R','PAAWRAAS','','PAAAAMIR','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIREC','3','Intregrita` Economico-Contabile','Q','ACACANAS','','','N');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1002626','1002661','PAAMIREC','30','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1002626','1002661','PAAMIREC','30','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PAAAAMIR','REPORT VERIFICA INTEGRITA` BASE-DATI','U','U','A_A','N','N','S');

delete from a_voci_menu where voce_menu = 'PAA4IRGE';
delete from a_passi_proc where voce_menu = 'PAA4IRGE';
delete from a_selezioni where voce_menu = 'PAA4IRGE';
delete from a_menu where voce_menu = 'PAA4IRGE';
delete from a_voci_menu where voce_menu = 'PAAMIRGE';
delete from a_passi_proc where voce_menu = 'PAAMIRGE';
delete from a_selezioni where voce_menu = 'PAAMIRGE';
delete from a_menu where voce_menu = 'PAAMIRGE' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PAAMIRGE','P00','MIRGE','Integr. Giuridico ed Economico-Contabile','F','D','','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRGE','1','Intregrita` Giuridico-Economica','Q','PAAMIRGE','','PAAAAMIR','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRGE','2','Intregrita` Giuridico-Economica','R','PAAWRAAS','','PAAAAMIR','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRGE','3','Intregrita` Giuridico-Economica','Q','ACACANAS','','','N');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1002626','1002659','PAAMIRGE','10','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1002626','1002659','PAAMIRGE','10','');

delete from a_voci_menu where voce_menu = 'PAA4IRGM';
delete from a_passi_proc where voce_menu = 'PAA4IRGM';
delete from a_selezioni where voce_menu = 'PAA4IRGM';
delete from a_menu where voce_menu = 'PAA4IRGM';
delete from a_voci_menu where voce_menu = 'PAAMIRGM';
delete from a_passi_proc where voce_menu = 'PAAMIRGM';
delete from a_selezioni where voce_menu = 'PAAMIRGM';
delete from a_menu where voce_menu = 'PAAMIRGM' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PAAMIRGM','P00','MIRGM','Integr. Giuridico-Matricolare','F','D','','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRGM','1','Intregrita` Giuridico-Matricolare','Q','PAAMIRGM','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRGM','2','Intregrita` Giuridico-Matricolare','R','PAAWRAAS','','PAAAAMIR','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRGM','3','Intregrita` Giuridico-Matricolare','Q','ACACANAS','','','N');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1002626','1002660','PAAMIRGM','20','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1002626','1002660','PAAMIRGM','20','');

delete from a_voci_menu where voce_menu = 'PAA4IRIP';
delete from a_passi_proc where voce_menu = 'PAA4IRIP';
delete from a_selezioni where voce_menu = 'PAA4IRIP';
delete from a_menu where voce_menu = 'PAA4IRIP';
delete from a_voci_menu where voce_menu = 'PAAMIRIP';
delete from a_passi_proc where voce_menu = 'PAAMIRIP';
delete from a_selezioni where voce_menu = 'PAAMIRIP';
delete from a_menu where voce_menu = 'PAAMIRIP' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PAAMIRIP','P00','MIRIP','Integr. Incentivazione Produttivita`','F','D','','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRIP','1','Integrita` Incentivazione Produttivita`','Q','PAAMIRIP','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRIP','2','Integrita` Incentivazione Produttivita`','R','PAAWRAAS','','PAAAAMIR','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRIP','3','Integrita` Incentivazione Produttivita`','Q','ACACANAS','','','N');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1002662','1002664','PAAMIRIP','20','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1002662','1002664','PAAMIRIP','20','');

delete from a_voci_menu where voce_menu = 'PAA4IRPA';
delete from a_passi_proc where voce_menu = 'PAA4IRPA';
delete from a_selezioni where voce_menu = 'PAA4IRPA';
delete from a_menu where voce_menu = 'PAA4IRPA';
delete from a_voci_menu where voce_menu = 'PAAMIRPA';
delete from a_passi_proc where voce_menu = 'PAAMIRPA';
delete from a_selezioni where voce_menu = 'PAAMIRPA';
delete from a_menu where voce_menu = 'PAAMIRPA' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PAAMIRPA','P00','MIRPA','Integr. Presenze-Assenze','F','D','','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRPA','1','Intregrita` Presenze-Assenze','Q','PAAMIRPA','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRPA','2','Intregrita` Presenze-Assenze','R','PAAWRAAS','','PAAAAMIR','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRPA','3','Intregrita` Presenze-Assenze','Q','ACACANAS','','','N');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1002662','1004705','PAAMIRPA','30','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1002662','1004705','PAAMIRPA','30','');

delete from a_voci_menu where voce_menu = 'PAA4IRPO';
delete from a_passi_proc where voce_menu = 'PAA4IRPO';
delete from a_selezioni where voce_menu = 'PAA4IRPO';
delete from a_menu where voce_menu = 'PAA4IRPO';
delete from a_voci_menu where voce_menu = 'PAAMIRPO';
delete from a_passi_proc where voce_menu = 'PAAMIRPO';
delete from a_selezioni where voce_menu = 'PAAMIRPO';
delete from a_menu where voce_menu = 'PAAMIRPO' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PAAMIRPO','P00','MIRPO','Integr. Pianta Organica','F','D','','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRPO','1','Intregrita` Pianta Organica','Q','PAAMIRPO','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRPO','2','Intregrita` Pianta Organica','R','PAAWRAAS','','PAAAAMIR','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PAAMIRPO','3','Intregrita` Pianta Organica','Q','ACACANAS','','','N');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1002662','1002663','PAAMIRPO','10','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1002662','1002663','PAAMIRPO','10','');

delete from a_voci_menu where voce_menu = 'PEC4SMAP';
delete from a_passi_proc where voce_menu = 'PEC4SMAP';
delete from a_selezioni where voce_menu = 'PEC4SMAP';
delete from a_menu where voce_menu = 'PEC4SMAP';
delete from a_voci_menu where voce_menu = 'PECCSMAP';
delete from a_passi_proc where voce_menu = 'PECCSMAP';
delete from a_selezioni where voce_menu = 'PECCSMAP';
delete from a_menu where voce_menu = 'PECCSMAP' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCSMAP','P00','CSMAP','Creazione Supp.Magnetico Denuncia Inpdap','F','D','ACAPARPR','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMAP','1','Creazione Supp.Magnetico Denuncia Inpdap','Q','PECCSMAP','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMAP','2','Elenco nominativo Denuncia I.N.P.D.A.P.','R','SI4V3WAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMAP','3','Elenco nominativo Denuncia I.N.P.D.A.P.','Q','ACACANAS','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_RTRIM','PECCSMAP','0','Abilita rtrim','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('TXTFILE','PECCSMAP','0','Nome TXT da produrre','80','C','S','PECCSMAP.txt','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCSMAP','1','Elaborazione  : Anno','4','N','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_1','PECCSMAP','2','Raggruppamento: 1)','15','U','S','%','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_2','PECCSMAP','3','Raggruppamento: 2)','15','U','S','%','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_3','PECCSMAP','4','Raggruppamento: 3)','15','U','S','%','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_4','PECCSMAP','5','Raggruppamento: 4)','15','U','S','%','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_5','PECCSMAP','6','Raggruppamento: 5)','15','U','S','%','','','','');  

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1005912','1012906','PECCSMAP','6',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1005912','1012906','PECCSMAP','6','');   
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1005912','1012906','PECCSMAP','6',''); 

delete from a_voci_menu where voce_menu = 'PEC4SMDL';
delete from a_passi_proc where voce_menu = 'PEC4SMDL';
delete from a_selezioni where voce_menu = 'PEC4SMDL';
delete from a_menu where voce_menu = 'PEC4SMDL';
delete from a_voci_menu where voce_menu = 'PECCSMDL';
delete from a_passi_proc where voce_menu = 'PECCSMDL';
delete from a_selezioni where voce_menu = 'PECCSMDL';
delete from a_menu where voce_menu = 'PECCSMDL' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCSMDL','P00','CSMDL','Supporto Magnetico Denuncia I.N.A.I.L.','F','D','ACAPARPR','',1,'P_ARDE_Q');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMDL','1','Supporto Magnetico Denuncia I.N.A.I.L.','Q','PECCSMDL','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMDL','2','Stampa Denuncia Nominativa I.N.A.I.L.','R','SI4V3WAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMDL','3','Lista Denuncia Nominativa I.N.A.I.L.','R','PECCSMDL','','PECCSMDL','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMDL','4','Lista Denuncia Nominativa I.N.A.I.L.','R','PECLNDNA','','PECLNDNA','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMDL','5','Cancellazione appoggio stampe','Q','ACACANAS','','','N');  

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('NUM_CARATTERI','PECCSMDL','0','Caratteri per substring','4','C','S','100','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_DISTINCT','PECCSMDL','0','Abilita distinct','2','C','S','SI','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_SUBSTR','PECCSMDL','0','Abilita substring','2','C','S','SI','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('TXTFILE','PECCSMDL','0','Nome TXT da produrre','80','C','S','PECCSMD4.dat','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCSMDL','1','Elaborazione: Anno','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_POS_INAIL','PECCSMDL','2','              Posizione INAIL','12','U','S','%','','','','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCSMDL','STAMPA DENUNCIA NOMINATIVA I.N.A.I.L.','U','U','A_C','N','N','S');
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECLNDNA','LISTA DENUNCIA NOMINATIVA I.N.A.I.L.','U','U','A_C','N','N','S');

delete from a_voci_menu where voce_menu = 'PECCSMI4';
delete from a_passi_proc where voce_menu = 'PECCSMI4';
delete from a_selezioni where voce_menu = 'PECCSMI4';
delete from a_menu where voce_menu = 'PECCSMI4';
delete from a_voci_menu where voce_menu = 'PECCSMDS';
delete from a_passi_proc where voce_menu = 'PECCSMDS';
delete from a_selezioni where voce_menu = 'PECCSMDS';
delete from a_menu where voce_menu = 'PECCSMDS' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCSMDL','P00','CSMDS','Supporto Magnetico Denuncia I.N.P.S.','F','D','ACAPARPR','',1,'P_ARDE_Q');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMDL','1','Supporto Magnetico Denuncia I.N.P.S.','Q','PECCSMDS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMDL','2','Eliminazione Registrazioni di lavoro','R','SI4V3WAS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCSMDL','3','Eliminazione Registrazioni di lavoro','Q','ACACANAS','','','N');   

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCSMDL','1','Elaborazione: Anno','4','N','N','','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CED','PECCSMDL','2','              C.E.D.','4','U','S','','','GEST','1','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_POS_INPS','PECCSMDL','3','              Posizione INPS','12','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_PROG_DEN','PECCSMDL','4','              Progr. Denuncia','2','N','S','01','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_SUP','PECCSMDL','5','              Tipo Supporto','2','U','S','','P_CSMDS','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1001044','1013585','PECCSMDL','12','');   
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1001044','1013585','PECCSMDL','12','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1001044','1013585','PECCSMDL','12','');   

delete from a_domini_selezioni where dominio = 'P_CSMDS';

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CSMDS','09','','Dischetto da 5.25');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_CSMDS','10','','Dischetto da 3.50');

delete from a_voci_menu where voce_menu = 'PGP4INPD';
delete from a_passi_proc where voce_menu = 'PGP4INPD';
delete from a_selezioni where voce_menu = 'PGP4INPD';
delete from a_menu where voce_menu = 'PGP4INPD';
delete from a_voci_menu where voce_menu = 'PGPCINPD';
delete from a_passi_proc where voce_menu = 'PGPCINPD';
delete from a_selezioni where voce_menu = 'PGPCINPD';
delete from a_menu where voce_menu = 'PGPCINPD' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PGPCINPD','P00','CINPD','Archiviazione progetto pensioni','F','D','ACAPARPR','',1,'P_INPD');   

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCINPD','1','Archiviazione progetto pensioni','Q','PGPCINPD','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCINPD','2','Lista Iscritti Selezionati','R','PGPLINPD','','PGPLINPD','N');   

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PGPCINPD','1','Codice della Gestione','4','U','N','%','','GEST','1','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CASSA','PGPCINPD','2','Cassa Previdenziale','5','U','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CONTRATTO','PGPCINPD','3','Contratto di Lavoro','4','U','N','%','','CONT','1','1');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PGPCINPD','4','Dipendente: Codice Individuale','8','N','N','','','RAIN','1','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TUTTI_CI','PGPCINPD','5','Elabora Tutti i Rapporti Indiv','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CESSATI_DAL','PGPCINPD','7','Solo cessati dal','10','C','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CESSATI_AL','PGPCINPD','8','al','10','C','N','','','','',''); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1012552','1012553','PGPCINPD','1','');   
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1012552','1012553','PGPCINPD','1',''); 

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PGPLINPD','Lista Iscritti Selezionati','U','U','A_C','N','N','S'); 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_INPD','1','RAIN','I','Individui','','P00RINDI','','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_INPD','2','GEST','G','Gestioni','','PGMEGEST','',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_INPD','3','CONT','C','Contratti','','PPAECONT','','');

delete from a_voci_menu where voce_menu = 'PGP4PERI';
delete from a_passi_proc where voce_menu = 'PGP4PERI';
delete from a_selezioni where voce_menu = 'PGP4PERI';
delete from a_menu where voce_menu = 'PGP4PERI';
delete from a_voci_menu where voce_menu = 'PGPCPERI';
delete from a_passi_proc where voce_menu = 'PGPCPERI';
delete from a_selezioni where voce_menu = 'PGPCPERI';
delete from a_menu where voce_menu = 'PGPCPERI' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PGPCPERI','P00','CPERI','Creazione File Periodi Retributivi','F','D','ACAPARPR','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCPERI','1','Creazione File Periodi Retributivi','Q','PGPCPERI','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCPERI','2','Creazione File Periodi Retributivi','R','SI4V3WAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCPERI','3','Lista periodi','R','PGPLPERI','','PGPLPERI','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCPERI','4','Creazione File Periodi Retributivi','Q','ACACANAS','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('NUM_CARATTERI','PGPCPERI','0','Caratteri per substring','4','C','S','70','','','','');
     
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_SUBSTR','PGPCPERI','0','Abilita substring','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_UPPER','PGPCPERI','0','Abilita upper','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('TXTFILE','PGPCPERI','0','Nome TXT da produrre','80','C','S','Periodi.txt','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DAL','PGPCPERI','1','Dal','10','D','N','','','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1012552','1013049','PGPCPERI','9',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1012552','1013049','PGPCPERI','9','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PGPLPERI','Periodi di Servizio','U','U','A_C','N','N','S');   

delete from a_voci_menu where voce_menu = 'PGP4RETR';
delete from a_passi_proc where voce_menu = 'PGP4RETR';
delete from a_selezioni where voce_menu = 'PGP4RETR';
delete from a_menu where voce_menu = 'PGP4RETR';
delete from a_voci_menu where voce_menu = 'PGPCRETR';
delete from a_passi_proc where voce_menu = 'PGPCRETR';
delete from a_selezioni where voce_menu = 'PGPCRETR';
delete from a_menu where voce_menu = 'PGPCRETR' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PGPCRETR','P00','CRETR','Creazione File Retribuzioni','F','D','ACAPARPR','',1,''); 

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCRETR','1','Creazione file Retribuzioni ante 1992','Q','PGPCRE92','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCRETR','2','Lista Retribuzioni ante 1992 esportate','R','SI4V3WAS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCRETR','3','Lista Retribuzioni ante 1992 esportate','R','PGPLRE92','','PGPLRE92','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCRETR','4','Cancellazione appoggio stampe','Q','ACACANAS','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('NUM_CARATTERI','PGPCRETR','0','Caratteri per substring','4','C','S','50','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_SUBSTR','PGPCRETR','0','Abilita substring','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_UPPER','PGPCRETR','0','Abilita upper','2','C','S','SI','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('TXTFILE','PGPCRETR','0','Nome TXT da produrre','80','C','S','Importi9.txt','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DAL','PGPCRETR','1','Dal ','10','U','N','','','','','');  

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1012552','1012558','PGPCRETR','6','');   
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1012552','1012558','PGPCRETR','6',''); 

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PGPLRE92','IMPORTI RETRIBUZIONI PRE-1992 ESPORTATI','U','U','A_C','N','N','S');

delete from a_voci_menu where voce_menu = 'PGP4SCON';
delete from a_passi_proc where voce_menu = 'PGP4SCON';
delete from a_selezioni where voce_menu = 'PGP4SCON';
delete from a_menu where voce_menu = 'PGP4SCON';
delete from a_voci_menu where voce_menu = 'PGPCSCON';
delete from a_passi_proc where voce_menu = 'PGPCSCON';
delete from a_selezioni where voce_menu = 'PGPCSCON';
delete from a_menu where voce_menu = 'PGPCSCON' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PGPCSCON','P00','CSCON','Creazione File Servizi con Onere','F','D','','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCSCON','1','Creazione file Servizi con Onere','Q','PGPCSCON','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCSCON','2','Creazione file Servizi con Onere','R','SI4V3WAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCSCON','3','Lista Servizi con Onere esportati','R','PGPLSCON','','PGPLSCON','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCSCON','4','Lista Servizi con Onere esportati','Q','ACACANAS','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('NUM_CARATTERI','PGPCSCON','0','Caratteri per substring','4','C','S','179','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_SUBSTR','PGPCSCON','0','Abilita substring','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_UPPER','PGPCSCON','0','Abilita upper','2','C','S','SI','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('TXTFILE','PGPCSCON','0','Nome TXT da produrre','80','C','S','ServCon.txt','','','',''); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1012552','1012556','PGPCSCON','4','');   
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1012552','1012556','PGPCSCON','4',''); 

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PGPLSCON','SERVIZI CON ONERE ESPORTATI','U','U','A_E','N','N','S');   

delete from a_voci_menu where voce_menu = 'PGP4ISCR';
delete from a_passi_proc where voce_menu = 'PGP4ISCR';
delete from a_selezioni where voce_menu = 'PGP4ISCR';
delete from a_menu where voce_menu = 'PGP4ISCR';
delete from a_voci_menu where voce_menu = 'PGPCISCR';
delete from a_passi_proc where voce_menu = 'PGPCISCR';
delete from a_selezioni where voce_menu = 'PGPCISCR';
delete from a_menu where voce_menu = 'PGPCISCR' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PGPCISCR','P00','CISCR','Creazione File Iscritti','F','D','','',1,'');   

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCISCR','1','Creazione file Iscritti','Q','PGPCISCR','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCISCR','2','Creazione file Iscritti','R','SI4V3WAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PGPCISCR','3','Lista iscritti esportati','R','PGPLISCR','','PGPLISCR','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
 values ('PGPCISCR','4','Lista iscritti esportati','Q','ACACANAS','','','N');   

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('NUM_CARATTERI','PGPCISCR','0','Caratteri per substring','4','C','S','138','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_SUBSTR','PGPCISCR','0','Abilita substring','2','C','S','SI','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('SE_UPPER','PGPCISCR','0','Abilita upper','2','C','S','SI','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('TXTFILE','PGPCISCR','0','Nome TXT da produrre','80','C','S','Iscritti.txt','','','','');  

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1012552','1012554','PGPCISCR','2',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1012552','1012554','PGPCISCR','2','');   

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PGPLISCR','ISCRITTI ESPORTATI','U','U','A_E','N','N','S'); 

delete from a_voci_menu where voce_menu = 'PGP4QUAL'; 
delete from a_passi_proc where voce_menu = 'PGP4QUAL';
delete from a_selezioni where voce_menu = 'PGP4QUAL'; 
delete from a_menu where voce_menu = 'PGP4QUAL'; 
delete from a_voci_menu where voce_menu = 'PGPCQUAL'; 
delete from a_passi_proc where voce_menu = 'PGPCQUAL';
delete from a_selezioni where voce_menu = 'PGPCQUAL'; 
delete from a_menu where voce_menu = 'PGPCQUAL' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PGPCQUAL','P00','CQUAL','Creazione File Qualifiche Ente','F','D','ACAPARPR','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PGPCQUAL','1','Creazione file Qualifiche Ente','Q','PGPCQUAL','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PGPCQUAL','2','Creazione file Qualifiche Ente','R','SI4V3WAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PGPCQUAL','3','Lista qualifiche ente esportate','R','PGPLQUAL','','PGPLQUAL','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PGPCQUAL','4','Cancellazione appoggio stampe','Q','ACACANAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PGPCQUAL','5','Verifica presenza segnalazioni','Q','CHK_ERR','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PGPCQUAL','91','Errori di Elaborazione','R','ACARAPPR','','PGPCQUAL','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PGPCQUAL','92','Cancellazione errori','Q','ACACANRP','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('NUM_CARATTERI','PGPCQUAL','0','Caratteri per substring','4','C','S','122','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_ERRORE','PGPCQUAL','0','verifica segnalazioni errore','2','U','N','NO','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_SUBSTR','PGPCQUAL','0','Abilita substring','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('TXTFILE','PGPCQUAL','0','Nome TXT da produrre','80','C','S','Qualifi2.txt','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_UPPER','PGPCQUAL','0','Abilita upper','2','C','S','SI','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_GESTIONE','PGPCQUAL','1','Codice della Gestione','4','U','S','%','','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','*','1012552','1012560','PGPCQUAL','8',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1012552','1012560','PGPCQUAL','8',''); 

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale)
values ('PGPCQUAL','SEGNALAZIONI QUALIFICHE S7','U','U','A_C','N','N','S'); 
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale)
values ('PGPLQUAL','QUALIFICHE ENTE ESPORTATE','U','U','A_C','N','N','S');

delete from a_voci_menu where voce_menu = 'PGP4VOCI'; 
delete from a_passi_proc where voce_menu = 'PGP4VOCI';
delete from a_selezioni where voce_menu = 'PGP4VOCI';
delete from a_menu where voce_menu = 'PGP4VOCI' and ruolo in ('*','AMM','PEC');  
delete from a_voci_menu where voce_menu = 'PGPCVOCI'; 
delete from a_passi_proc where voce_menu = 'PGPCVOCI';
delete from a_selezioni where voce_menu = 'PGPCVOCI';
delete from a_menu where voce_menu = 'PGPCVOCI' and ruolo in ('*','AMM','PEC');  

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PGPCVOCI','P00','CVOCI','Creazione File Voci Emolumenti','F','D','ACAPARPR','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PGPCVOCI','1','Creazione file Voci Emolumenti','Q','PGPCVOCI','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PGPCVOCI','2','Creazione file Voci Emolumenti','R','SI4V3WAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PGPCVOCI','3','Lista Voci emolumenti esportate','R','PGPLVOCI','','PGPLVOCI','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PGPCVOCI','4','Cancellazione appoggio stampe','Q','ACACANAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PGPCVOCI','5','Verifica presenza segnalazioni','Q','CHK_ERR','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PGPCVOCI','91','Errori di Elaborazione','R','ACARAPPR','','PGPCVOCI','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PGPCVOCI','92','Cancellazione errori','Q','ACACANRP','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('NUM_CARATTERI','PGPCVOCI','0','Caratteri per substring','4','C','S','110','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_ERRORE','PGPCVOCI','0','verifica segnalazioni errore','2','U','N','NO','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_SUBSTR','PGPCVOCI','0','Abilita substring','2','C','S','SI','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('TXTFILE','PGPCVOCI','0','Nome TXT da produrre','80','C','S','VociEmo2.txt','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_UPPER','PGPCVOCI','0','Abilita upper','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_GESTIONE','PGPCVOCI','1','Codice della Gestione','4','C','S','%','','','','');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','*','1012552','1012559','PGPCVOCI','7','');  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1012552','1012559','PGPCVOCI','7','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale)
values ('PGPCVOCI','SEGNALAZIONI VOCI S7','U','U','A_C','N','N','S');  
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale)
values ('PGPLVOCI','VOCI EMOLUMENTI ESPORTATE','U','U','A_C','N','N','S');

delete from a_voci_menu where voce_menu = 'PEC4ASFA';
delete from a_passi_proc where voce_menu = 'PEC4ASFA';
delete from a_selezioni where voce_menu = 'PEC4ASFA';
delete from a_menu where voce_menu = 'PEC4ASFA';
delete from a_voci_menu where voce_menu = 'PECLASFA';
delete from a_passi_proc where voce_menu = 'PECLASFA';
delete from a_selezioni where voce_menu = 'PECLASFA';
delete from a_menu where voce_menu = 'PECLASFA' and ruolo in ('*','AMM','PEC');

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECLASFA','P00','LASFA','Lista Assegni per Nucleo Familiare','F','D','','',1,'');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECLASFA','1','Lista Assegni per Nucleo Familiare','R','PECLASFA','','PECLASFA','N');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000609','1012646','PECLASFA','30','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000609','1012646','PECLASFA','30','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000609','1012646','PECLASFA','30','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECLASFA','Lista Assegni per Nucleo Familiare','U','U','A_C','N','N','S');

-- Ulteriori assestamenti

update a_voci_menu 
   set tipo_voce = 'A', tipo = 'F' 
 where voce_menu = 'PECXCAFA';
