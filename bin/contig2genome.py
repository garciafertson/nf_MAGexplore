#!/usr/bin/env python3
import pandas as pd
import argparse

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument("--contigscsv", required=True, metavar="FILE",
                help="File with contigs abundance")
    parser.add_argument("--MAGtaxonomy", metavar="FILE",
                help="File with MAGs 7 level taxonomy, please provide a tsv file with taxonomu, the first line should contain the headers Magid Domain Phylum Class Order Family Genus Species")
    parser.add_argument("--output", default="MAG_abundance", metavar="STR",
                help="Name for output file with MAG abundances")
    args=parser.parse_args()
    print("Convert CONTIGS abundance table into MAGS abundance table")

    #input csv with mag names and taxonomy
    contig_abundance=pd.read_csv(args.contigcsv)
    #Keep the the mag_id from contig id and create a new column
    *contig_abunance["magid"]=contig_abundance["contigid"].str.split("\t").str[0]
    #group contigs by MAG names and return mean,median, then normalize
    mag_abundance=contig_abundance.groupby("magid").median()
    mag_ab
    #**abundnace table by class,genus.
    mag_tax=pd.read_csv(args.MAGtaxonomy, sep="\t")
    mag_abundance.leftjoint(magtax, "magid")

if __name__ == "__main__":
    main()
