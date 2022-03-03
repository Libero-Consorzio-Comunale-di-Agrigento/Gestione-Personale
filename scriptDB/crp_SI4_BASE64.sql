CREATE OR REPLACE package si4_base64
as
    function encode(r in raw) return varchar2;
    function decode(p_base64 in varchar2) return raw;
end si4_base64;
/

CREATE OR REPLACE package body si4_base64
as
    g_base64 varchar2(64) :=
'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    --
    TYPE vc2_table IS TABLE OF VARCHAR2(1) INDEX BY BINARY_INTEGER;
   map vc2_table;
   -- Initialize the Base64 mapping
   PROCEDURE init_map IS
   BEGIN
      map(0) :='A'; map(1) :='B'; map(2) :='C'; map(3) :='D'; map(4) :='E';
      map(5) :='F'; map(6) :='G'; map(7) :='H'; map(8) :='I'; map(9):='J';
      map(10):='K'; map(11):='L'; map(12):='M'; map(13):='N'; map(14):='O';
      map(15):='P'; map(16):='Q'; map(17):='R'; map(18):='S'; map(19):='T';
      map(20):='U'; map(21):='V'; map(22):='W'; map(23):='X'; map(24):='Y';
      map(25):='Z'; map(26):='a'; map(27):='b'; map(28):='c'; map(29):='d';
      map(30):='e'; map(31):='f'; map(32):='g'; map(33):='h'; map(34):='i';
      map(35):='j'; map(36):='k'; map(37):='l'; map(38):='m'; map(39):='n';
      map(40):='o'; map(41):='p'; map(42):='q'; map(43):='r'; map(44):='s';
      map(45):='t'; map(46):='u'; map(47):='v'; map(48):='w'; map(49):='x';
      map(50):='y'; map(51):='z'; map(52):='0'; map(53):='1'; map(54):='2';
      map(55):='3'; map(56):='4'; map(57):='5'; map(58):='6'; map(59):='7';
      map(60):='8'; map(61):='9'; map(62):='+'; map(63):='/';
   END;
   FUNCTION encode(r IN RAW) RETURN VARCHAR2 IS
     i pls_integer;
     x pls_integer;
     y pls_integer;
     v VARCHAR2(32767);
   BEGIN
      -- For every 3 bytes, split them into 4 6-bit units and map them to
      -- the Base64 characters
      i := 1;
      WHILE ( i + 2 <= utl_raw.length(r) ) LOOP
	 x := to_number(utl_raw.substr(r, i, 1), '0X') * 65536 +
	      to_number(utl_raw.substr(r, i + 1, 1), '0X') * 256 +
	      to_number(utl_raw.substr(r, i + 2, 1), '0X');
	 y := floor(x / 262144); v := v || map(y); x := x - y * 262144;
	 y := floor(x / 4096);	 v := v || map(y); x := x - y * 4096;
	 y := floor(x / 64);	 v := v || map(y); x := x - y * 64;
	                         v := v || map(x);
	 i := i + 3;
      END LOOP;
      -- Process the remaining bytes that has fewer than 3 bytes.
      IF ( utl_raw.length(r) - i = 0) THEN
	 x := to_number(utl_raw.substr(r, i, 1), '0X');
	 y := floor(x / 4);	 v := v || map(y); x := x - y * 4;
	 x := x * 16;            v := v || map(x);
         v := v || '==';
      ELSIF ( utl_raw.length(r) - i = 1) THEN
	 x := to_number(utl_raw.substr(r, i, 1), '0X') * 256 +
  	      to_number(utl_raw.substr(r, i + 1, 1), '0X');
	 y := floor(x / 1024);	 v := v || map(y); x := x - y * 1024;
	 y := floor(x / 16);	 v := v || map(y); x := x - y * 16;
	 x := x * 4;             v := v || map(x);
         v := v || '=';
      END IF;
      RETURN v;
   END;
function decode(p_base64 in varchar2) return raw
    is
        l_len       pls_integer;
        l_base64    varchar2(32767) := p_base64;
        l_raw       raw(24576);
        -- base64 values
        b1          pls_integer;
        b2          pls_integer;
        b3          pls_integer;
        b4          pls_integer;
        -- raw bytes
        r1          pls_integer;
        r2          pls_integer;
        r3          pls_integer;
    begin
        l_base64 := replace(replace(replace(l_base64,chr(10),null),chr(1),null),chr(32),null);
		l_base64 := replace(replace(l_base64,chr(10),null),chr(13),null);
        l_base64 := rtrim(l_base64,'=');
        l_len := length(l_base64);
        for i in 0 .. trunc(l_len / 4)-1 loop
            -- retrieve 4 base64 values (6-bit)
            b1 := instr(g_base64,substr(l_base64,(i*4)+1,1))-1;
            b2 := instr(g_base64,substr(l_base64,(i*4)+2,1))-1;
            b3 := instr(g_base64,substr(l_base64,(i*4)+3,1))-1;
            b4 := instr(g_base64,substr(l_base64,(i*4)+4,1))-1;
            -- bit manipulate into 8-bit values
            r1 := (b1 * 4) + trunc(b2 / 16);
            r2 := (bitand(b2,15) * 16) + trunc(b3 / 4);
            r3 := (bitand(b3,3) * 64) + b4;
            -- concatenate result with raw bytes
            l_raw := utl_raw.concat(l_raw,hextoraw(
to_char(r1,'FM0X')||to_char(r2,'FM0X')||to_char(r3,'FM0X')));
        end loop;
        if mod(l_len,4) = 2 then
            b1 := instr(g_base64,substr(l_base64,l_len-1,1))-1;
            b2 := instr(g_base64,substr(l_base64,l_len,1))-1;
            r1 := (b1 * 4) + trunc(b2 / 16);
            l_raw := utl_raw.concat(l_raw,hextoraw(to_char(r1,'FM0X')));
        elsif mod(l_len,4) = 3 then
            b1 := instr(g_base64,substr(l_base64,l_len-2,1))-1;
            b2 := instr(g_base64,substr(l_base64,l_len-1,1))-1;
            b3 := instr(g_base64,substr(l_base64,l_len,1))-1;
            r1 := (b1 * 4) + trunc(b2 / 16);
            r2 := (bitand(b2,15) * 16) + trunc(b3 / 4);
            l_raw := utl_raw.concat(l_raw,hextoraw(
                to_char(r1,'FM0X')||to_char(r2,'FM0X')));
        end if;
        return l_raw;
    end decode;
BEGIN
   init_map;
end si4_base64;
/

