include {CATMAGS}       from "../modules/local/catmags"
include {BOWTIE2INDEX}  from "../modules/local/bowtie2"
include {PRODIGAL}      from "../modules/local/prodigal"
include {GFF2BED}       from "../modules/local/bedops"
include {CHECKM_MARKER}        from "../modules/local/checkm"
include {FASHEAD2BED}   from "../modules/local/checkm"

workflow PREPARE{

  take:
    mags_folder
  main:
  //Define chanel fasta files with MAGS from the skin
    if (!params.no_bacterial_mag){
      CHECKM_MARKER(mags_folder)
      fnaname_markers=CHECKM_MARKER.out.marker
    }
    FASHEAD2BED(fnaname_markers)
    marker=FASHEAD2BED.out.markerbed

    CATMAGS(mags_folder)
    concat_mags=CATMAGS.out.contigs
    //genomebed=CATMAGS.out.genomebed

    BOWTIE2INDEX(concat_mags)
    PRODIGAL(concat_mags)
    gff=PRODIGAL.out.gff

    GFF2BED(gff)
    genesbed=GFF2BED.out.genesbed

  emit:
    bowtie2index=BOWTIE2INDEX.out.index
    //contigs=CATMAGS.out.contigs
    genesbed=GFF2BED.out.genesbed
    genomebed=CATMAGS.out.genomebed
    //genes=PRODIGAL.out.genes
    markerbed=FASHEAD2BED.out.markerbed
}
