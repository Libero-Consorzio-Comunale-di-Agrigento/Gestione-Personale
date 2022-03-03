CREATE OR REPLACE FORCE VIEW COLONNE_EASFA
(DAL, AL, NUMERO_FASCIA, TABELLA, COD_SCAGLIONE, 
 SCAGLIONE, COLONNA1, COLONNA2, COLONNA3, COLONNA4, 
 COLONNA5, COLONNA6, COLONNA7, COLONNA8)
AS 
select dati.dal
, dati.al
, dati.numero_fascia
, dati.tabella
, dati.cod_scaglione
, dati.scaglione
, sum(nvl(dati.colonna1,0))
, sum(nvl(dati.colonna2,0))
, sum(nvl(dati.colonna3,0))
, sum(nvl(dati.colonna4,0))
, sum(nvl(dati.colonna5,0))
, sum(nvl(dati.colonna6,0))
, sum(nvl(dati.colonna7,0))
, sum(nvl(dati.colonna8,0))
from (
select scaf.dal    dal,
 scaf.al,
scaf.numero_fascia numero_fascia,
asfa1.tabella       tabella,
scaf.cod_scaglione cod_scaglione,
scaf.scaglione     scaglione,
nvl(asfa1.importo,0) + nvl(asfa1.integrativo,0) + nvl(asfa1.aumento,0) colonna1,
to_number(0) colonna2, to_number(0) colonna3, to_number(0) colonna4, to_number(0) colonna5,to_number(0) colonna6, to_number(0) colonna7, to_number(0) colonna8
from scaglioni_assegno_familiare scaf,
assegni_familiari asfa1
where  ( scaf.dal, scaf.cod_scaglione ,asfa1.tabella) in 
( select vaaf.dal,cofa.cod_scaglione ,  cofa.tabella
from validita_assegni_familiari vaaf,     condizioni_familiari cofa 
where cofa.tabella is not null
)     
and asfa1.numero       = 1
and scaf.dal = asfa1.dal (+)
and scaf.numero_fascia = asfa1.numero_fascia (+)
union  -- colonna2
select scaf.dal    dal,
 scaf.al,
scaf.numero_fascia numero_fascia,
asfa2.tabella       tabella,
scaf.cod_scaglione cod_scaglione,
scaf.scaglione     scaglione,
to_number(0) colonna1,
nvl(asfa2.importo,0) + nvl(asfa2.integrativo,0) + nvl(asfa2.aumento,0) colonna2,
to_number(0) colonna3, to_number(0) colonna4, to_number(0) colonna5,to_number(0) colonna6, to_number(0) colonna7, to_number(0) colonna8
from scaglioni_assegno_familiare scaf,
assegni_familiari asfa2
where  ( scaf.dal, scaf.cod_scaglione ,asfa2.tabella) in 
( select vaaf.dal,cofa.cod_scaglione ,  cofa.tabella
from validita_assegni_familiari vaaf,     condizioni_familiari cofa 
where cofa.tabella is not null
)   
and scaf.dal = asfa2.dal (+)
and asfa2.numero       = 2
and scaf.numero_fascia = asfa2.numero_fascia (+)
union -- colonna3
select scaf.dal    dal,
 scaf.al,
scaf.numero_fascia numero_fascia,
asfa3.tabella       tabella,
scaf.cod_scaglione cod_scaglione,
scaf.scaglione     scaglione,
to_number(0) colonna1, to_number(0) colonna2,
nvl(asfa3.importo,0) + nvl(asfa3.integrativo,0) + nvl(asfa3.aumento,0) colonna3,
 to_number(0) colonna4, to_number(0) colonna5,to_number(0) colonna6, to_number(0) colonna7, to_number(0) colonna8
from scaglioni_assegno_familiare scaf,
assegni_familiari asfa3
where  ( scaf.dal, scaf.cod_scaglione ,asfa3.tabella) in 
( select vaaf.dal,cofa.cod_scaglione ,  cofa.tabella
from validita_assegni_familiari vaaf,     condizioni_familiari cofa 
where cofa.tabella is not null
)     
and scaf.dal = asfa3.dal (+)
and asfa3.numero       = 3
and scaf.numero_fascia = asfa3.numero_fascia (+)
union -- colonna4
select scaf.dal    dal,
 scaf.al,
scaf.numero_fascia numero_fascia,
asfa4.tabella       tabella,
scaf.cod_scaglione cod_scaglione,
scaf.scaglione     scaglione,
to_number(0) colonna1, to_number(0) colonna2, to_number(0) colonna3,
nvl(asfa4.importo,0) + nvl(asfa4.integrativo,0) + nvl(asfa4.aumento,0) colonna4
, to_number(0) colonna5,to_number(0) colonna6, to_number(0) colonna7, to_number(0) colonna8
from scaglioni_assegno_familiare scaf,
assegni_familiari asfa4
where  ( scaf.dal, scaf.cod_scaglione ,asfa4.tabella) in 
( select vaaf.dal,cofa.cod_scaglione ,  cofa.tabella
from validita_assegni_familiari vaaf,     condizioni_familiari cofa 
where cofa.tabella is not null
)     
and scaf.dal = asfa4.dal (+)
and asfa4.numero       = 4
and scaf.numero_fascia = asfa4.numero_fascia (+)
union --colonna5
select scaf.dal    dal,
 scaf.al,
scaf.numero_fascia numero_fascia,
asfa5.tabella       tabella,
scaf.cod_scaglione cod_scaglione,
scaf.scaglione     scaglione,
to_number(0) colonna1, to_number(0) colonna2, to_number(0) colonna3 , to_number(0) colonna4
, nvl(asfa5.importo,0) + nvl(asfa5.integrativo,0) + nvl(asfa5.aumento,0)colonna5
,to_number(0) colonna6, to_number(0) colonna7, to_number(0) colonna8
from scaglioni_assegno_familiare scaf,
assegni_familiari asfa5
where ( scaf.dal, scaf.cod_scaglione ,asfa5.tabella) in 
( select vaaf.dal,cofa.cod_scaglione ,  cofa.tabella
from validita_assegni_familiari vaaf,     condizioni_familiari cofa 
where cofa.tabella is not null
)     
and scaf.dal = asfa5.dal (+)
and asfa5.numero       = 5
and scaf.numero_fascia = asfa5.numero_fascia (+)
union --colonna6
select scaf.dal    dal,
 scaf.al,
scaf.numero_fascia numero_fascia,
asfa6.tabella       tabella,
scaf.cod_scaglione cod_scaglione,
scaf.scaglione     scaglione,
to_number(0) colonna1, to_number(0) colonna2, to_number(0) colonna3, to_number(0) colonna4, to_number(0) colonna5,
nvl(asfa6.importo,0) + nvl(asfa6.integrativo,0) + nvl(asfa6.aumento,0) colonna6
, to_number(0) colonna7, to_number(0) colonna8
from scaglioni_assegno_familiare scaf,
assegni_familiari asfa6
where  ( scaf.dal, scaf.cod_scaglione ,asfa6.tabella) in 
( select vaaf.dal,cofa.cod_scaglione ,  cofa.tabella
from validita_assegni_familiari vaaf,     condizioni_familiari cofa 
where cofa.tabella is not null
)     
and scaf.dal = asfa6.dal (+)
and asfa6.numero       = 6
and scaf.numero_fascia = asfa6.numero_fascia (+)
union --colonna7
select scaf.dal    dal,
 scaf.al,
scaf.numero_fascia numero_fascia,
asfa7.tabella       tabella,
scaf.cod_scaglione cod_scaglione,
scaf.scaglione     scaglione,
to_number(0) colonna1, to_number(0) colonna2, to_number(0) colonna3, to_number(0) colonna4, to_number(0) colonna5, to_number(0) colonna6,
nvl(asfa7.importo,0) + nvl(asfa7.integrativo,0) + nvl(asfa7.aumento,0) colonna7, to_number(0) colonna8
from scaglioni_assegno_familiare scaf,
assegni_familiari asfa7
where  ( scaf.dal, scaf.cod_scaglione ,asfa7.tabella) in 
( select vaaf.dal,cofa.cod_scaglione ,  cofa.tabella
from validita_assegni_familiari vaaf,     condizioni_familiari cofa 
where cofa.tabella is not null
)     
and scaf.dal = asfa7.dal (+)
and asfa7.numero       = 7
and scaf.numero_fascia = asfa7.numero_fascia (+)
union -- colonna 8
select scaf.dal    dal,
 scaf.al,
scaf.numero_fascia numero_fascia,
asfa8.tabella       tabella,
scaf.cod_scaglione cod_scaglione,
scaf.scaglione     scaglione,
to_number(0) colonna1, to_number(0) colonna2, to_number(0) colonna3, to_number(0) colonna4, to_number(0) colonna5, to_number(0) colonna6,to_number(0) colonna7,
nvl(asfa8.importo,0) + nvl(asfa8.integrativo,0) + nvl(asfa8.aumento,0) colonna8
from scaglioni_assegno_familiare scaf,
assegni_familiari asfa8
where  ( scaf.dal, scaf.cod_scaglione ,asfa8.tabella) in 
( select vaaf.dal,cofa.cod_scaglione ,  cofa.tabella
from validita_assegni_familiari vaaf,     condizioni_familiari cofa 
where cofa.tabella is not null
)     
and asfa8.numero       = 8
and scaf.dal = asfa8.dal (+)
and scaf.numero_fascia = asfa8.numero_fascia (+)
) dati
group by dati.dal
, dati.al
, dati.numero_fascia
, dati.tabella
, dati.cod_scaglione
, dati.scaglione;


