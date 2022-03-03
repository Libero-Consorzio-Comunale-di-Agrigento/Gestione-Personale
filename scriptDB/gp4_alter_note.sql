declare
v_comando varchar2(32000);
v_lunghezza number;
v_versione varchar2(1);
procedure ridimensiona (p_table_name varchar2, p_dimensione number) is
D_table varchar2(150);
begin
begin
  select OBJECT_TYPE    
     into D_table
 from obj where OBJECT_NAME = p_table_name;
exception
  when no_data_found then
    D_table := null;
end;
if D_table  = 'TABLE' THEN
   
 v_comando := ' alter table '|| p_table_name || 
                   ' modify (note     varchar2( ' || p_dimensione|| '),
                             note_al1 varchar2( ' || p_dimensione|| '),
                             note_al2 varchar2( ' || p_dimensione|| '))';
 si4.sql_execute(v_comando);
end if;
end ridimensiona;

procedure ridimensiona_2 (p_table_name varchar2, p_dimensione number) is
D_table varchar2(150);
begin
begin
  select OBJECT_TYPE    
     into D_table
 from obj where OBJECT_NAME = p_table_name;
exception
  when no_data_found then
    D_table := null;
end;

if D_table  = 'TABLE' THEN
   
 v_comando := ' alter table '|| p_table_name || 
                   ' modify (note     varchar2( ' || p_dimensione|| '))';
 si4.sql_execute(v_comando);
end if;
end ridimensiona_2;

begin
  begin
  -- estrazione della versione
  select '8', 4000
    into v_versione, v_lunghezza
    from v$version
   where instr(upper(banner),'RELEASE')>0
     and substr(banner,7,1) = '8'
     and substr(banner,instr(upper(banner),'RELEASE ')+8,1)= '8';
   exception
   when no_data_found then
        v_versione := '7';
	     v_lunghezza := 2000;
   END;
   ridimensiona('CONTRATTI_STORICI',v_lunghezza);
   ridimensiona('FIGURE_GIURIDICHE',v_lunghezza);
   ridimensiona('PERIODI_GIURIDICI',v_lunghezza);
   ridimensiona('QUALIFICHE_GIURIDICHE',v_lunghezza);
   ridimensiona('ARCHIVIO_DOCUMENTI_GIURIDICI',v_lunghezza);
   ridimensiona('MODELLI_NOTE',v_lunghezza);
   ridimensiona('NOTE_INDIVIDUALI',v_lunghezza);
   ridimensiona('ISTITUTI_CREDITO',v_lunghezza);
   ridimensiona('SPORTELLI',v_lunghezza);
   ridimensiona('CODICI_BILANCIO',v_lunghezza);

/* Le table che seguono non hanno i campi note_al1 e note_al2, a tal proposito 
   è stata creata la ridimensiona_2 */   
   ridimensiona_2('TIPI_RAPPORTO',v_lunghezza);
   ridimensiona_2('ANAGRAFICI',v_lunghezza);
   ridimensiona_2('ASSEGNAZIONI_CONTABILI',v_lunghezza);
   ridimensiona_2('CONVOCAZIONI',v_lunghezza);
   ridimensiona_2('DELIBERE',v_lunghezza);
   ridimensiona_2('INFORMAZIONI_RETRIBUTIVE',v_lunghezza);
   ridimensiona_2('INFORMAZIONI_RETRIBUTIVE_BP',v_lunghezza);
   ridimensiona_2('RAPPORTI_GIURIDICI',v_lunghezza);
   ridimensiona_2('RAPPORTI_INDIVIDUALI',v_lunghezza);
   ridimensiona_2('SOSTITUZIONI_GIURIDICHE',v_lunghezza);
END;
/

