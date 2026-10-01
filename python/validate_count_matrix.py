#!/usr/bin/env python3
"""Minimal count-matrix validator. Standard library only."""

import csv
import sys
from pathlib import Path


def validate(path: str) -> None:
    rows = list(csv.reader(Path(path).open(newline="", encoding="utf-8")))
    if not rows or len(rows[0]) < 3:
        raise ValueError("Expected gene_id plus at least two sample columns")
    header = rows[0]
    if header[0].lower() not in {"gene_id", "gene", "symbol"}:
        raise ValueError("First column must identify genes")
    if len(set(header[1:])) != len(header[1:]):
        raise ValueError("Duplicate sample names")
    genes = set()
    for line_no, row in enumerate(rows[1:], start=2):
        if len(row) != len(header):
            raise ValueError(f"Line {line_no}: wrong number of columns")
        if row[0] in genes:
            raise ValueError(f"Duplicate gene identifier: {row[0]}")
        genes.add(row[0])
        for value in row[1:]:
            count = float(value)
            if count < 0 or not count.is_integer():
                raise ValueError(f"Line {line_no}: non-negative integers required")
    print(f"OK: {len(genes)} genes x {len(header) - 1} samples")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("Usage: validate_count_matrix.py counts.csv")
    validate(sys.argv[1])
