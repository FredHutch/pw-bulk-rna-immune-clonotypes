#!/usr/bin/env python3

import pandas as pd

pd.read_csv(
    "input.csv"
).to_csv(
    "output.csv",
    index=None
)