for %%f in (WEBUTIL.pll) do start /min /wait ifcmp60 module=%%f userid=p00/p00@svi module_type=library forms_doc=NO script=YES Output_File=%%f
@pause
