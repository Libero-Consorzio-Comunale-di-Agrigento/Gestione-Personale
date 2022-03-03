for %%f in (PECSTDMA.rdf) do start /min /wait rwcon60 module=%%f userid=p00/p00@svi module_type=library forms_doc=NO script=YES Output_File=%%f
@pause

--for  %%c in (*.rdf) do start /w rwcon60 userid=P00/P00@SVI stype=rdffile source="%%c" dtype=repfile overwrite=yes batch=yes
--@pause
