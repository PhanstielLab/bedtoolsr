# bedtoolsr
R package wrapping bedtools

## Installing

bedtoolsr can be installed directly from GitHub using the following commands:

```
install.packages("devtools")
devtools::install_github("PhanstielLab/bedtoolsr")
```

Note that if `bedtools` is not found in R's PATH, or you want to use a specific version, you can manually specify the desired directory in R with:

```
options(bedtools.path = "[bedtools path]")
```

## Overview

[bedtools](https://bedtools.readthedocs.io/) is a widely used set of various utilities for genomic analysis. This R package provides a convenient wrapper for bedtools functions allowing for the documentation and use of them from within the R environment. This includes manual pages for all functions as well as key added features including the ability to provide either paths to files or R objects. The following functions are currently supported:

* intersect
* window
* closest
* coverage
* map
* genomecov
* merge
* cluster
* complement
* shift
* subtract
* slop
* flank
* sort
* random
* shuffle
* sample
* spacing
* annotate
* multiinter
* unionbedg
* pairtobed
* pairtopair
* bamtobed
* bedtobam
* bamtofastq
* bedpetobam
* bed12tobed6
* getfasta
* maskfasta
* nuc
* multicov
* tag
* jaccard
* reldist
* fisher
* overlap
* igv
* links
* makewindows
* groupby
* expand
* split

### Known limitations

* `window`: does not support `abam` parameter in replacement of `a` parameter as an input file

### Example Usage

```
A.bed = data.frame(chrom=c("chr1", "chr1"), start=c(10, 30), end=c(20, 40))
B.bed = data.frame(chrom=c("chr1"), start=15, end=20)

> bedtoolsr::intersect(A.bed, B.bed)
    V1 V2 V3
1 chr1 15 20
```

## Authors

* [Mayura Patwardhan](https://github.com/mayurapatwardhan)
* [Craig Wenger](https://github.com/cwenger)
* [Doug Phanstiel](https://github.com/dphansti)

## Contact

douglas_phanstiel@med.unc.edu

## Building for Your Version of Bedtools

This package was developed with a Python script that runs all bedtools utilities to determine their command-line usage, and automatically writes the wrapper R functions. It was designed to be generic so that it can be rebuilt quickly for any version of bedtools. If you want to do this, run [makePackage.py](https://github.com/PhanstielLab/bedtoolsr/blob/master/dev/makePackage.py). There are command-line arguments for the location of bedtools, where the output package should go, and the package version suffix. Special cases are specified in [anomalies.json](https://github.com/PhanstielLab/bedtoolsr/blob/master/dev/anomalies.json).

## Build Status

[![Travis build status](https://travis-ci.org/PhanstielLab/bedtoolsr.svg?branch=master)](https://travis-ci.org/PhanstielLab/bedtoolsr)


