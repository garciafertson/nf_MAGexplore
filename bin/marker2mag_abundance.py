import pandas as pd
import argparse

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument("--contigscsv", required=True, metavar="FILE",
                help="File with contigs abundance")
    parser.add_argument("--output", default="MAG_abundance.csv", metavar="STR",
                help="Name for output file with MAG abundances")
    args=parser.parse_args()
    print("Convert CONTIGS abundance table into MAGS abundance table")

    #input csv with mag names and taxonomy
    contig_abundance=pd.read_csv(args.contigcsv, index_col=0)
    #Keep the the mag_id from contig id and create a new column
    contig_abunance["magid"]=contig_abundance["contigid"].str.split("|").str[0]
    #group contigs by MAG names and return mean,median, then normalize
    mag_abundance=contig_abundance.groupby("magid").median()
    mag_abundance.to_csv(args.output)
    #abundnace table by class,genus.
    #mag_tax=pd.read_csv(args.MAGtaxonomy, sep="\t")
    #mag_abundance.leftjoint(magtax, "magid")

if __name__ == "__main__":
    main()
