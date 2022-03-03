alter  table addizionale_irpef_comunale 
modify ( dal date not null )
;

update addizionale_irpef_comunale set scaglione = 0
where scaglione is null
;

alter  table addizionale_irpef_comunale 
modify (  scaglione number(15,5) not null)
;
