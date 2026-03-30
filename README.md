# The Bill You Can't Read
### Notes from the Abstract — A. Rupert Crocker

Code and data for the chart accompanying "The Bill You Can't Read," published on *Notes from the Abstract* (andrewrcrocker.substack.com).

## Contents

| File | Description |
|------|-------------|
| `price_transparency_gap.R` | R script that generates the chart |
| `price_transparency_gap.png` | Rendered chart (1456 × 819px, 16:9) |
| `the_bill_you_cant_read.md` | Article draft with references |

## Data source

Centers for Medicare and Medicaid Services. *Medicare Inpatient Hospitals by Provider and Service, FY 2023.*
https://data.cms.gov/provider-summary-by-type-of-service/medicare-inpatient-hospitals/medicare-inpatient-hospitals-by-provider-and-service

The source CSV is not included in this repository due to file size. Download the full dataset from the CMS link above and place it in the working directory if you wish to reproduce the underlying aggregations. The R script uses pre-aggregated national averages by MS-DRG and does not require the raw file to render the chart.

## Requirements

```r
install.packages(c("ggplot2", "dplyr", "tidyr", "scales"))
```

Or via apt on Ubuntu:

```bash
sudo apt-get install r-cran-ggplot2 r-cran-dplyr r-cran-tidyr r-cran-scales
```

## Usage

```r
Rscript price_transparency_gap.R
```

Output: `price_transparency_gap.png` at 1456 × 819px on a `#FAF5E9` background.

## License

MIT License. Data from CMS is public domain.

## Citation

Crocker AR. The bill you can't read. *Notes from the Abstract*. 2026.
