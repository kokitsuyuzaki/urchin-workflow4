import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("7.20.0")

container: 'docker://koki/urchin_workflow_bioconda:20220527'

URCHIN_SAMPLES, = glob_wildcards('data/{sample}_1.fastq.gz')
DBS = ['hpbase']

rule all:
    input:
        expand('data/{db}/trim/{sample}_1/fastqc/{sample}_1_paired_fastqc.html',
            db=DBS, sample=URCHIN_SAMPLES),
        expand('data/{db}/trim/{sample}_2/fastqc/{sample}_2_paired_fastqc.html',
            db=DBS, sample=URCHIN_SAMPLES),
        expand('data/{db}/raw/{sample}_1/fastqc/{sample}_1_fastqc.html',
            db=DBS, sample=URCHIN_SAMPLES),
        expand('data/{db}/raw/{sample}_2/fastqc/{sample}_2_fastqc.html',
            db=DBS, sample=URCHIN_SAMPLES)

#################################
# QC, Trimming
#################################
rule trimmomatic:
    input:
        'data/{sample}_1.fastq.gz',
        'data/{sample}_2.fastq.gz',
        'data/all_sequencing_WTA_adopters.fa'
    output:
        'data/{sample}_1_paired.fastq.gz',
        'data/{sample}_1_unpaired.fastq.gz',
        'data/{sample}_2_paired.fastq.gz',
        'data/{sample}_2_unpaired.fastq.gz',
        'data/trim/{sample}/trim_out.log'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/trimmomatic_{sample}.txt'
    log:
        'logs/trimmomatic_{sample}.log'
    shell:
        'src/trimmomatic.sh {input} {output} >& {log}'

rule fastqc_trim_1:
    input:
        'data/{sample}_1_paired.fastq.gz',
    output:
        'data/{db}/trim/{sample}_1/fastqc/{sample}_1_paired_fastqc.html'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/fastqc_trim_1_{db}_{sample}.txt'
    log:
        'logs/fastqc_trim_1_{db}_{sample}.log'
    shell:
        'src/fastqc.sh {input} {wildcards.db} trim {wildcards.sample} 1 >& {log}'

rule fastqc_trim_2:
    input:
        'data/{sample}_2_paired.fastq.gz',
    output:
        'data/{db}/trim/{sample}_2/fastqc/{sample}_2_paired_fastqc.html'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/fastqc_trim_2_{db}_{sample}.txt'
    log:
        'logs/fastqc_trim_2_{db}_{sample}.log'
    shell:
        'src/fastqc.sh {input} {wildcards.db} trim {wildcards.sample} 2 >& {log}'

rule fastqc_raw_1:
    input:
        'data/{sample}_1.fastq.gz',
    output:
        'data/{db}/raw/{sample}_1/fastqc/{sample}_1_fastqc.html'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/fastqc_raw_1_{db}_{sample}.txt'
    log:
        'logs/fastqc_raw_1_{db}_{sample}.log'
    shell:
        'src/fastqc.sh {input} {wildcards.db} raw {wildcards.sample} 1 >& {log}'

rule fastqc_raw_2:
    input:
        'data/{sample}_2.fastq.gz',
    output:
        'data/{db}/raw/{sample}_2/fastqc/{sample}_2_fastqc.html'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/fastqc_raw_2_{db}_{sample}.txt'
    log:
        'logs/fastqc_raw_2_{db}_{sample}.log'
    shell:
        'src/fastqc.sh {input} {wildcards.db} raw {wildcards.sample} 2 >& {log}'