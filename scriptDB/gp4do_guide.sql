-- eliminazione dalle guide delle voci del modulo PO in caso di modulo DO

delete from a_guide_o 
 where guida_o = 'P_FIGI_Q' 
   and voce_menu = 'PPORPOPI';

delete from a_guide_o 
 where guida_o = 'P_FIGU'
   and voce_menu = 'PPORPOPI';

delete from a_guide_o 
 where guida_o = 'P_FIGU_Q'
   and voce_menu = 'PPORPOPI';

delete from a_guide_o 
 where guida_o = 'P_PEGI_E'
   and guida_v = 'P_POOR';

delete from a_guide_o 
 where guida_o = 'P_PEGI_F'
   and guida_v = 'P_POOR';

delete from a_guide_o 
 where guida_o = 'P_PEAS'
   and guida_v = 'P_POOR';

delete from a_guide_o 
 where guida_o = 'P_PEGI'
   and guida_v = 'P_POOR';

delete from a_guide_v where guida_v = 'P_POOR'; 