#!/usr/bin/env python3
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
import argparse
import os,glob
from pathlib import Path

#input folder with MAG.fasta
#read fasta, append filename into fasta header
#save to common file

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument("--mags_folder", required=True, metavar="DIR",
                help="Path to Directory with MAGs or Genomes in fasta format for database")
    parser.add_argument("--out_contigs", default="contigs.fasta",metavar="STR",
                help="Output filename")
    parser.add_argument("--out_genomebed", default="contigs.genome.bed", metavar="STR",
                help="Output genome bed file")
    args=parser.parse_args()

    print("Running concat MAGs into one file and append MAG name")
    with open(args.out_contigs, "w") as out, open(args.out_genomebed, "w")as gnm:
        #find fasta files in folder
        fileext=["*.fa", "*.fna", "*.fasta", "*.fas"]
        for ext in fileext:
            for filename in glob.glob(os.path.join(args.mags_folder,ext)):
                with open(os.path.join(os.getcwd(), filename), 'r') as f:
                    for record in SeqIO.parse(f,"fasta"):
                        #prefix filename in fasta header
                        name=Path(filename).stem
                        record.id="|".join([name, record.id])
                        record.id=record.id.replace(" ","_")
                        record.id=(record.id[:100] + '..') if len(record.id) > 100 else record.id
                        #print sequnce in output
                        if len(record.seq) > 2500 : #if record.seq.find("N") == -1:
                            out.write(">%s\n%s\n" %(record.id, record.seq))
                            gnm.write("%s\t%s\n" %(record.id, len(record.seq)))

if __name__ == "__main__":
    main()
