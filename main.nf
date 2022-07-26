nextflow.enable.dsl = 2

include {MAG_ABUNDANCE} from  "./workflows/macrodiversity"

workflow NF_MAGex{
	MAG_ABUNDANCE()
	}

workflow{
	NF_MAGex()
	}
