//Import subworkflows
include { PREPARE } from  "../subworkflows/prepare"
include { RUN_METAPOP }      from "../subworkflows/run_metapop"

workflow METAPOP_MACRODIVERSITY{
  if (params.build_bowtie2index){
    Channel
      .fromPath(params.mags_folder, type: 'dir')
      .set {mags_folder}
    PREPARE(mags_folder)
    //Rertun database path in params variable and run METAPOP
    contigs=PREPARE.out.contigs
    bowtie2index=PREPARE.out.bowtie2index
  }else if(params.run_metapop){

    Channel
      .fromPath(["prepare/bowtieindex/mags_bowtieindex*"])
      .toList()
      .set{bowtie_index}
    Channel
      .fromPath("prepare/genes.bed")
      .set{genesbed}
    Channel
      .fromPath("prepare/contigs.genome.bed")
      .set{genomebed}

    RUN_METAPOP(bowtie_index,genesbed,genomebed)

  }
}
