[![Travis build status](https://travis-ci.org/PhanstielLab/bedtoolsr.svg?branch=master)](https://travis-ci.org/PhanstielLab/bedtoolsr)

## Overview

The [bedtools suite of programs](https://bedtools.readthedocs.io/) is a widely used set of various utilities for genomic analysis. This R package provides a convenient wrapper for bedtools functions allowing for the documentation and use of them from within the R environment. This includes manual pages for all functions as well as key added features including the ability to provide either file paths or R objects as inputs and outputs.

## Installation

bedtoolsr can be installed directly from GitHub using the following commands:

```
install.packages("devtools")
devtools::install_github("PhanstielLab/bedtoolsr")
```

Note that if `bedtools` is not found in R's PATH, or you want to use a specific version, you can manually specify the desired directory in R with:

```
options(bedtools.path = "[bedtools path]")
```

You can also install a specific [release](https://github.com/PhanstielLab/bedtoolsr/releases) for a particular version of bedtools. Download the corresponding zip file (*not* the source code), decompress, and install from R:

```
install.packages("/path/to/bedtools_v2.28.0-7", type="source", repos=NULL)
```

### Operating System Support

bedtoolsr should work on any system with R and bedtools installed. It has been tested on macOS (version 10.14 "Mojave") and Linux (Ubuntu version 18.04). bedtools is not available for Windows; however, you can either use a virtual machine or [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10). In either case, R from the Windows side would not be able to access bedtools running on the Linux side, so R and bedtoolsr would also have to be installed on the Linux side.

### Example Usage

```
A.bed <- data.frame(chrom=c("chr1", "chr1"), start=c(10, 30), end=c(20, 40))
B.bed <- data.frame(chrom=c("chr1"), start=15, end=20)

> bedtoolsr::bt.intersect(A.bed, B.bed)
    V1 V2 V3
1 chr1 15 20
```

## Authors

* [Mayura Patwardhan](https://github.com/mayurapatwardhan)
* [Craig Wenger](https://github.com/cwenger)
* [Doug Phanstiel](https://github.com/dphansti)

## Contact

douglas_phanstiel@med.unc.edu

## Building for a different version of bedtools

In order to more easily support past and future versions of bedtools we adopted a metaprogramming approach.  A single python script reads bedtools --help output and automatically generates the entire R package. It was designed to be generic so that it can be rebuilt quickly for any version of bedtools.

To generate a new version of bedtoolsr, run [makePackage.py](https://github.com/PhanstielLab/bedtoolsr/blob/master/dev/makePackage.py). There are command-line arguments for the location of bedtools, where the output package should go, and the package version suffix. Special cases are specified in [anomalies.json](https://github.com/PhanstielLab/bedtoolsr/blob/master/dev/anomalies.json).

## Testing

Bedtoolsr uses continuous integration made possible by unit tests using the [testthat](https://github.com/r-lib/testthat) R package.  Once installed you can perform unit tests for most of the bedtoolsr functions using the following code:

First, install [testthat](https://github.com/r-lib/testthat) if not already installed

```
install.packages('testthat')
````

Load bedtoolsr and testthat

```
library('testthat')
library('bedtoolsr')
```

Perform tests
```
testthat::test_package("bedtoolsr")
```

Expected results


```
══ testthat results  ══════════════════════════════════════════════════════
OK: 24 SKIPPED: 0 FAILED: 0
```

## Website

For more information please see the [bedtoolsr website](http://phanstiel-lab.med.unc.edu/bedtoolsr.html) 
