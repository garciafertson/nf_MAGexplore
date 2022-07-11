nextflow.enable.dsl = 2

include {METAPOP_MACRODIVERSITY} from  "./workflows/metapop_macrodiversity"

workflow NF_METAPOP_MACRODIVERSITY{
	METAPOP_MACRODIVERSITY()
	}

workflow{
	NF_METAPOP_MACRODIVERSITY()
	}
