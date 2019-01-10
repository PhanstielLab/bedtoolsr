# bedtoolsr
R package wrapping bedtools

## Installing

```
install.packages("devtools")
devtools::install_github("PhanstielLab/bedtoolsr")
```

Note that if `bedtools` is not found in R's PATH, or you want to use a specific version, you can manually specify the desired directory in R with:

```
options(bedtools.path = "[bedtools path]")
```

## Overview

[bedtools](https://bedtools.readthedocs.io/) is a set of various utilities for genomic analysis. This R package provides a convenient wrapper for calling them and getting the results without having to leave the R environment. The following functions are supported:

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
* igv
* links
* groupby
* expand

The following funtions are _not_ supported:

* split
* makewindows
* overlap

### Example Usage

```
> bedtoolsr::intersect("tests/A.bed", "tests/B.bed")
    V1 V2 V3
1 chr1 15 20
```

### Usage Notes

* `window`: does not support `abam` parameter in replacement of `a` parameter as an input file
* `genomecov`: `5` parameter changed to `five` and `3` parameter changed to `three` for R compatibility
* `getfasta`: `name+` parameter changed to `nameplus` for R compatibility

## Authors

* [Mayura Patwardhan](https://github.com/mayurapatwardhan)
* [Craig Wenger](https://github.com/cwenger)
* [Doug Phanstiel](https://github.com/dphansti)

## Contact

douglas_phanstiel@med.unc.edu

## Building for Your Version of Bedtools

This package was developed with a Python script that runs all bedtools utilities to determine their command-line usage, and automatically writes the wrapper R functions. It was designed to be generic so that it can be rebuilt quickly for any version of bedtools. If you want to do this, run [makePackage.py](https://github.com/PhanstielLab/bedtoolsr/blob/master/dev/makePackage.py). It will ask you where to build the package and where your instance of bedtools is located. Then run [createRdfiles.R](https://github.com/PhanstielLab/bedtoolsr/blob/master/dev/createRdfiles.R) with R to produce documentation.