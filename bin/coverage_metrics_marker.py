#!/usr/bin/env python3
import pandas as pd
import argparse
from collections import OrderedDict
#Define class BGCbed to save coverage stats

def main( ):
    #Parse argument Bed file, sample name,
    #fraction covered to accept a gene is present
    #fraction of genes present to accept a BGC is present
    parser=argparse.ArgumentParser()
    parser.add_argument("--bedcoverage", required=True, metavar='FILE')
    parser.add_argument("--sample", required=True, metavar='STR')
    parser.add_argument("--gp_fraction", type=float, metavar='FLOAT', default=0.5, help="fraction of genes present needed to consider a BGC present (default 0.5)")
    parser.add_argument("--rpkmin",type=float, metavar='FLOAT', default=2, help="minimum rpk value to condiser a gene present (default 2)")
    parser.add_argument("--bp_fraction",type=float, metavar='FLOAT', default=0.3, help="covered gene legth fraction to consider a gene present (default 0.3)")
    args=parser.parse_args()

    bedlines=[]
    bgc_dict={}
    rowlist=[]
    #pandas dataframe columns
    #df = pd.DataFrame(columns=['sample','bgc_id','presence','avcov','rpk','reads','basecov','len','glen'])
    #Read bedfile of gene coverage and estimate BGC presence and coverage
    #input csv with mag names and taxonomy
    bedcov=pd.read_csv(args.bedcoverage, sep="\t", header=None)
    bedcov.columns=["contigid","start","end","marker","reads","basecov","glen","avcov"]
    bedcov["rpk"]=bedcov["reads"]*1000/bedcov["glen"]
    bedcov["presence"]=(bedcov.rpk>args.rpkmin) & (bedcov.avcov>args.bp_fraction)
    bedcov["magid"]=bedcov.contigid.str.split("|").str[0]

    magcov=bedcov.groupby("magid").sum()
    magcov["sample"]=args.sample
    magcov["rpk"]=magcov["reads"]*1000/magcov["glen"]
    magcov["avcov"]=magcov.basecov/magcov.glen
    magcov["presence"]= (magcov["presence"]/bedcov.groupby("magid").count()["contigid"])> args.gp_fraction

    magcov["rpm"]=magcov["reads"]*1000000/magcov["reads"].sum()
    magcov["rpkm"]=magcov["rpm"]*1000/magcov["glen"]
    magcov["tpm"]=magcov["rpk"]*1000000/magcov["rpk"].sum()
    column_names = ["sample","start","end","avcov","basecov","reads","rpk","presence","rpm","rpkm","tpm"]
    magcov=magcov.reindex(columns=column_names)
    #estimate RPM, RPKM and TPM
    magcov.to_csv("marker_coverage_stats.csv", index=True, header=False)


if __name__ == "__main__":
    main()
