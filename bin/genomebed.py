#!/usr/bin/env python3
import sys
import pandas as pd
bed=pd.read_csv(sys.argv[1],header=None, sep="\t")
genomebed=bed.groupby(0, sort=False)[2].max()
genomebed.to_csv("contigs.genome.bed", header=None, sep="\t")
