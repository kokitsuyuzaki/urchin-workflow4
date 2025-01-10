# urchin-workflow4
This workflow consists of 6 workflows as follows:

- **workflow/download.smk**: Data downloading

![](https://github.com/kokitsuyuzaki/urchin-workflow4/blob/main/plot/download.png?raw=true)

- **workflow/qc.smk**: Deta quality check

![](https://github.com/kokitsuyuzaki/urchin-workflow4/blob/main/plot/qc.png?raw=true)

- **workflow/index.smk**: Indexing of genome and transcriptome sequences

![](https://github.com/kokitsuyuzaki/urchin-workflow4/blob/main/plot/index.png?raw=true)

- **workflow/quantification.smk**: Alignment-based/free quantification

![](https://github.com/kokitsuyuzaki/urchin-workflow4/blob/main/plot/quantification.png?raw=true)

- **workflow/summary.smk**: Summary of the data analysis

![](https://github.com/kokitsuyuzaki/urchin-workflow4/blob/main/plot/summary.png?raw=true)

- **workflow/deconvolution.smk**: Cell-type Deconvolution

![](https://github.com/kokitsuyuzaki/urchin-workflow4/blob/main/plot/deconvolution.png?raw=true)

## Requirements
- Bash: GNU bash, version 4.2.46(1)-release (x86_64-redhat-linux-gnu)
- Snakemake: 7.20.0
- Singularity: 3.9.2

## How to reproduce this workflow
### In Local Machine

```
snakemake -s workflow/download.smk -j 4 --use-singularity
snakemake -s workflow/qc.smk -j 4 --use-singularity
snakemake -s workflow/index.smk -j 4 --use-singularity
snakemake -s workflow/quantification.smk -j 4 --use-singularity
snakemake -s workflow/summary.smk -j 4 --use-singularity
# Copy XXXXX from urchin-workflow3 and then...
snakemake -s workflow/deconvolution.smk -j 4 --use-singularity
```

### In Open Grid Engine

```
snakemake -s workflow/download.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/qc.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/index.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/quantification.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/summary.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
# Copy XXXXX from urchin-workflow3 and then...
snakemake -s workflow/deconvolution.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
```

### In Slurm

```
snakemake -s workflow/download.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/qc.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/index.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/quantification.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/summary.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
# Copy XXXXX from urchin-workflow3 and then...
snakemake -s workflow/deconvolution.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
```

## License
Copyright (c) 2024 Koki Tsuyuzaki released under the [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

## Authors
- Koki Tsuyuzaki
- Shunsuke Yaguchi