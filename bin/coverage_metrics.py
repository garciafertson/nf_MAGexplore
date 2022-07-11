#!/usr/bin/env python3
import pandas as pd
import argparse
from collections import OrderedDict
#Define class BGCbed to save coverage stats
def parsebed(name, sample, bedlines, gpfr, bpfr):
    d=OrderedDict()
    d["bgc_id"]=name
    d['sample']=sample
    d["len"]=0          # BGC total lenght
    d["glen"]=0       # BGC total length of CDS
    d["avcov"]=0        # average coverage fraction
    d["basecov"]=0      # bases covered
    d['reads']=0        # total number of reads mapping to genes
    d['rpk']=0          # number reads per kilobase
    d['presence']=False #
    total_cds= len(bedlines)
    cds_present=0
    for i,line in enumerate(bedlines):
        line=line.rstrip()
        reads,basecov,cdslen,cov=line.split("\t")[-4:]
        d['reads']+=int(reads)
        d['basecov']+=int(basecov)
        d['glen']+=int(cdslen)
        d['avcov']+=float(cov)
        rpk_g=int(reads)*1000/float(cdslen)
        if float(cov) > gpfr and rpk_g > 2:
            cds_present+=1
    if float(cds_present)/float(total_cds) > bpfr:
        d['presence']=True
    d['avcov']=d['avcov']/float(total_cds)
    d['rpk']=float(d["reads"])*1000/float(d["glen"])

    return(d)

def main( ):
    #Parse argument Bed file, sample name,
    #fraction covered to accept a gene is present
    #fraction of genes present to accept a BGC is present
    parser=argparse.ArgumentParser()
    parser.add_argument("--bedcoverage", required=True, metavar='FILE')
    parser.add_argument("--sample", required=True, metavar='STR')
    parser.add_argument("--gp_fraction", type=float, metavar='FLOAT', default=0.5, help="covered gene legth fraction to consider a gene present (default 0.5)")
    parser.add_argument("--bp_fraction",type=float, metavar='FLOAT', default=0.3, help="fraction of genes present needed to consider a BGC present (default 0.5)")
    args=parser.parse_args()

    bedlines=[]
    bgc_dict={}
    rowlist=[]
    #pandas dataframe columns
    #df = pd.DataFrame(columns=['sample','bgc_id','presence','avcov','rpk','reads','basecov','len','glen'])
    #Read bedfile of gene coverage and estimate BGC presence and coverage
    with open(args.bedcoverage, "r") as f:
        begin=True
        ct=0
        cl=0
        for line in f:
            bgcid=line.split("\t")[0]
            cl+=1
            if begin:
                bedlines.append(line)
                prevbgcid=bgcid
                begin=False
                #print(bgcid)
            elif bgcid==prevbgcid:
                bedlines.append(line)
                prevbgcid=bgcid
            else:
		#print(bedlines)
                ct+=1
                d=parsebed(prevbgcid, args.sample, bedlines, args.gp_fraction, args.bp_fraction)
                rowlist.append(d)
                bedlines=[]
                bedlines.append(line)
                prevbgcid=bgcid
    d=parsebed(bgcid, args.sample, bedlines, args.gp_fraction, args.bp_fraction)
    rowlist.append(d)
    print(d, ct,cl)
    df = pd.DataFrame(rowlist)
    #estimate RPM, RPKM and TPM
    df["rpm"]=df["reads"]*1000000/df["reads"].sum()
    df["rpkm"]=df["rpm"]*1000/df["glen"]
    df["tpm"]=df["rpk"]*1000000/df["rpk"].sum()
    #output as csv
    df.to_csv("coverage_stats.csv", index=False, header=False)


if __name__ == "__main__":
    main()
