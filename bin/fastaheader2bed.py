#!/usr/bin/env python3
import argparse
def main():
    parser=argparse.ArgumentParser()
    parser.add_argument("--fastaheaders", required=True, metavar="FILE",
                help="Fasta headers fro marker genes")
    parser.add_argument("--output", metavar="STR",
                help="<output filename>" , default="marker.bed")
    args=parser.parse_args()
    with open(args.fastaheaders, "r") as f, open(args.output, "w") as o:
        for line in f:
            line=line.replace(">", "").rstrip()
            contig="|".join(line.split(" ")[0:2])
            start=line.split(" ")[2].split(";")[1].replace("start=","")
            end=line.split(" ")[2].split(";")[2].replace("end=","")
            name=line.split(" ")[3].split(";")[0].replace("marker=", "")
            o.write("%s\t%s\t%s\t%s\n" %(contig,start,end,name))

if __name__ == "__main__":
    main()
