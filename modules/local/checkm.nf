process CHECKM_MARKER{
//directives
container "nanozoo/checkm:1.1.3--c79a047"
publishDir "prepare"
cpus params.maxcores
time "6h"


input:
path(input_folder)

output:
path("mag_markerDomain.txt"), emit:marker

script:
"""
checkm tree -x fa -t ${task.cpus} ${input_folder} tree
checkm lineage_set --force_domain tree marker_Domain
checkm analyze -x fa -t ${task.cpus} marker_Domain ${input_folder} analyze_Domain
checkm qa -t ${task.cpus} -o 9 marker_Domain analyze_Domain/ | grep "^>" > mag_markerDomain.txt
"""
}

process FASHEAD2BED{
  //directives
  container "biopython/biopython"
  publishDir "prepare", mode: "move"
  cpus 1
  time "1h"

  input:
    path(markers)
  output:
    path("marker.bed"), emit:markerbed
  script:
  """
  fastaheader2bed.py --fastaheaders ${markers} --output tmp.bed
  sort -k1,1V -k2,2n -k3,3n tmp.bd > marker.bed
  """
}
