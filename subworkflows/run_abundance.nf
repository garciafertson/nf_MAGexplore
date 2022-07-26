include {FASTP}  from "../modules/local/fastp"
include {BOWTIE2}  from "../modules/local/bowtie2"
include {SAM2BAM}  from "../modules/local/samtools"
//include {METAPOP}  from "../modules/local/metapop"
include {BEDTOOLS_COVERAGE} from "../modules/local/bedtools"
include {COVERAGE_METRICS}  from "../modules/local/coverage"
include {COV_MATRIX}        from "../modules/local/coverage"
//coverage for checkm marker genes
include {BEDTOOLS_COVERAGE as BEDCOV_MARKER}     from "../modules/local/bedtools"
include {COVERAGE_METRICS as COVERAGE_METRICS_MARKER}   from "../modules/local/coverage"
include {COV_MATRIX as COV_MATRIX_MARKER}               from "../modules/local/coverage"

//include {READCOUNT} from "../modules/local/read_count"
//include {CONTIG2GENOME}  from "../modules/local/contig2genome"

workflow RUN_ABUNDANCE{
  take:
    bowtie_index
    genesbed
    genomebed
    markerbed
  main:
    //bedref=genesbed.mix(genomebed)
    //bedref=bedref.toList()
    //bedref.view()

    Channel
      .fromFilePairs(params.reads, size: params.single_end ? 1 : 2)
      .ifEmpty { exit 1, "Cannot find any reads matching: ${params.input}\nNB: Path needs to be enclosed in quotes!\nIf this is single-end data, please specify --single_end on the command line." }
      .map { row ->
                  def meta = [:]
                  meta.id           = row[0]
                  meta.group        = 0
                  meta.single_end   = params.single_end
                  return [ meta, row[1] ]
                }
      .set { ch_raw_short_reads }
    //Channel
    //  .fromPath("prepare/"+params.contigs_file)
    //  .set{contigs}
    //Channel
    //  .fromPath("prepare/"+params.genes_file)
    //  .set{genes}

    FASTP(ch_raw_short_reads)
    fqclean=FASTP.out.reads

    BOWTIE2(bowtie_index, fqclean)
    sam=BOWTIE2.out.sam

    SAM2BAM(sam)
    sortbam=SAM2BAM.out.sortbam
    nreads=SAM2BAM.out.nreads
    //single_bam=SAM2BAM.out.single_bam
    //all_bamfiles=single_bam.collect()
    //all_nreads=nreads.collectFile(name: "read_count.txt")

    bed_input= sortbam.combine(genesbed)
    bed_input=bed_input.combine(genomebed)
    //bed_input.view()
    BEDTOOLS_COVERAGE(bedinput)
    bedcov=BEDTOOLS_COVERAGE.out.bedcov
    bedcov.view()

    markerbed_input= sortbam.combine(markerbed)
    markerbed_input=markerbed_input.combine(genomebed)
    BEDCOV_MARKER{markerbed_input}
    bedcov_marker=BEDCOV_MARKER_CHECKM.out.bedcov

    gp=Channel.value(0.5)
    bp=Channel.value(0.3)

    cov_cutoff=gp.combine(bp)
    cov_input=bedcov.combine(cov_cutoff)
    COVERAGE_METRICS(cov_input)
    sample_cov=COVERAGE_METRICS.out.csv

    cov_input_marker=bedcov_marker.combine(cov_cutoff)
    COVERAGE_METRICS_MARKER(cov_input_marker)
    sample_cov_marker=COVERAGE_METRICS_MARKER.out.csv

    all_samplescov= sample_cov.collectFile(name:"abundance_dataframe.csv")
    all_samplescov_marker= sample_cov_marker.collectFile(name:"abundance_dataframe_marker.csv")
    COV_MATRIX(all_samplescov)
    COV_MATRIX_MARKER(all_samplescov_marker)

    //COV_MAGS(contigs_cov_mat)

    //METAPOP requires absolute path to Contigs and normalization file
    //METAPOP(all_bamfiles, contigs, genes, all_nreads)
    //abundance_table=METAPOP.out.macrodiversity_table
    //CONTIG2GENOME(abundance_table) //Reads csv with MAGs ids and taxonomy annotation

}
