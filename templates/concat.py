#!/usr/bin/env python3

import os
import pandas as pd

pd.concat(
    [
        pd.read_csv(
            fp,
            sep="\\t"
        ).assign(
            sample=fp.replace(".tsv", "")
        )
        for fp in os.listdir(".")
        if fp.endswith(".tsv")
    ]
).to_csv(
    "TRUST4_report.csv",
    index=None
)