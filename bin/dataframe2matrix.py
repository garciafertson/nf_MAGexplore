#!/usr/bin/env python3
import pandas as pd
import argparse
# read csv dataframe, no header, add column headers with appropiate names
#pd.pivot_table using  bgc as rows,sample as colunm and select value
#convert into numpu array and export biom format
#read metadata table and add columns to dddd
#df = pd.DataFrame(columns=['sample','bgc_id','presence','avcov','rpk','reads','basecov','len','glen','rpm','rpkm','tpm']
def main():
    #Parse argument Bed file, sample name,
    #fraction covered to accept a gene is present
    #fraction of genes present to accept a BGC is present
    parser=argparse.ArgumentParser()
    parser.add_argument("--coverage_stats", required=True, metavar='FILE')
    args=parser.parse_args()

    df=pd.read_csv(args.coverage_stats, names=["id","sample","len","glen","avcov","basecov","reads","rpk","presence","rpm","rpkm","tpm"])
    table=pd.pivot_table(df, values = "presence", index=["id"], columns=['sample'])
    table.to_csv(args.coverage_stats+".Presence_table.csv", index=True, header=True)
    table=pd.pivot_table(df, values = "rpkm", index=["id"], columns=['sample'])
    table.to_csv(args.coverage_stats+".RPKM_table.csv", index=True, header=True)
    table=pd.pivot_table(df, values = "tpm", index=["id"], columns=['sample'])
    table.to_csv(args.coverage_stats+".TPM_table.csv", index=True, header=True)
    table=pd.pivot_table(df, values = "avcov", index=["id"], columns=['sample'])
    table.to_csv(args.coverage_stats+".Coverage_table.csv", index=True, header=True)

    #add BGC annotation from file key BGCid, value predicted, consider multiple types
    #pandas crosstab read bgc type annotation file
    #pandas presence table group by sum(), tpm group by mean() var()

    #add samples metadata annotation, transverse table sample as rows and add columns


if __name__ == "__main__":
    main()
