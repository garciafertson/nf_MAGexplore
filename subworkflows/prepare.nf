include {CATMAGS}       from "../modules/local/catmags"
include {BOWTIE2INDEX}  from "../modules/local/bowtie2"
include {PRODIGAL}      from "../modules/local/prodigal"
include {GFF2BED}       from "../modules/local/bedops"
include {GENOMEBED}     from "../modules/local/bedops"

workflow PREPARE{

  take:
    mags_folder
  main:
  //Define chanel fasta files with MAGS from the skin
    CATMAGS(mags_folder)
    concat_mags=CATMAGS.out.contigs
    //genomebed=CATMAGS.out.genomebed

    BOWTIE2INDEX(concat_mags)
    PRODIGAL(concat_mags)
    gff=PRODIGAL.out.gff

    GFF2BED(gff)
    genesbed=GFF2BED.out.genesbed
    //GENOMEBED(genesbed)

  emit:
    bowtie2index=BOWTIE2INDEX.out.index
    contigs=CATMAGS.out.contigs
    genomebed=CATMAGS.out.genomebed
    genes=PRODIGAL.out.genes
    genesbed=GFF2BED.out.genesbed
}
