rem
rem Ricava dai tipo X4 i tipi Z4
rem
update denuncia_o1_inps x
set importo_c1 = nvl(importo_c1,0) + nvl(importo_c2,0) +
                 nvl(importo_c3,0) + nvl(importo_c4,0)
  , importo_pen_c1 = nvl(importo_pen_c1,0) + nvl(importo_pen_c2,0) +
                     nvl(importo_pen_c3,0) + nvl(importo_pen_c4,0)
  , tipo_c1 = 'Z4'
  , importo_c2 = ''
  , importo_c3 = ''
  , importo_c4 = ''
  , importo_pen_c2 = ''
  , importo_pen_c3 = ''
  , importo_pen_c4 = ''
  , tipo_c2 = ''
  , tipo_c3 = ''
  , tipo_c4 = ''
  , dal_c2 = ''
  , dal_c3 = ''
  , dal_c4 = ''
  , al_c2 = ''
  , al_c3 = ''
  , al_c4 = ''
where anno = (select anno from riferimento_fine_anno)
  and ci in 
(select ci from periodi_retributivi pere
              , riferimento_fine_anno rifa
  where pere.periodo between to_date('0101'||rifa.anno,'ddmmyyyy')
                         and to_date('3112'||rifa.anno,'ddmmyyyy')
    and trattamento = 'R96'
)
/
rem
rem Sistema le date degli arretrati per X4
rem
update denuncia_o1_inps x
set dal_c2 = to_date('0107'||to_char(anno-1),'ddmmyyyy') 
  , al_c2  = to_date('3112'||to_char(anno-1),'ddmmyyyy') 
where anno    = (select anno from riferimento_fine_anno)
  and tipo_c2 = 'X4'
  and nvl(importo_c2,0) + nvl(importo_pen_c2,0) != 0
/
rem
rem Arrotonda gli importi del quadro C SOLO VERSIONE EURO
rem
update denuncia_o1_inps x
set importo_c1 = round(importo_c1)
  , importo_c2 = round(importo_c2)
  , importo_c3 = round(importo_c3)
  , importo_c4 = round(importo_c4)
  , importo_pen_c1 = round(importo_pen_c1)
  , importo_pen_c2 = round(importo_pen_c2)
  , importo_pen_c3 = round(importo_pen_c3)
  , importo_pen_c4 = round(importo_pen_c4)
where anno = (select anno from riferimento_fine_anno)
/
update denuncia_o1_inps x
set importo_c1     = importo_c1 - nvl(importo_c2,0)
   ,importo_pen_c1 = importo_pen_c1 - nvl(importo_pen_c2,0)
where anno = (select anno from riferimento_fine_anno)
/