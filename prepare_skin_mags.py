# 1 Prepare MAGS
# append mag id to contigs within mag files (for bacteria and )
# (build similarity network 95A% seq identity
# cat MAG files
# build bowtie Skin genomes Bacteria, eukariota, virus
#
# 2 Prepare reads
# Clean reads Fastp Docker
# Remove human, count reads non humans
# Run bowtie agaisnt bowtie, skin metagenome
# (optional run Nonpareil V3, quay.io/biocontainers/nonpareil)

### Run metapop with unsorted BAM alignments, Genome Fasta file, and read numbers Prepare docker image.
# Read abundance table, contigas against samples
# Convert abundance table of contigs into abundance table of species
# Metapop outputs Average read depth for each contig per BAM file
# The average read depth and nucleotide diversity per position for each contig per BAM file is output,
# so it is possible to derive the macrodiveristy abundance tables and microdiversity π values for binned contigs
# from MetaPop output.
