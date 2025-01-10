import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("7.20.0")

container: 'docker://koki/urchin_workflow_bioconda:20220527'

URCHIN_SAMPLES, = glob_wildcards('data/{sample}_1.fastq.gz')
TYPES = ['trim', 'raw']
DBS1 = ['hpbase']
DBS2 = ['hpbase', 'hpbase_nucl']

rule all:
    input:
        expand('data/{db1}/{type}/{sample}/featurecounts/featurecounts.summary',
            db1=DBS1,
            type=TYPES, sample=URCHIN_SAMPLES),
        expand('data/{db2}/{type}/{sample}/salmon/quant.sf',
            db2=['hpbase', 'hpbase_nucl'],
            type=TYPES, sample=URCHIN_SAMPLES)

#################################
# Alignment-based Quantification
#################################
rule star_raw:
    input:
        'data/{db1}/star_index',
        'data/{sample}_1.fastq.gz',
        'data/{sample}_2.fastq.gz'
    output:
        'data/{db1}/raw/{sample}/star/Aligned.out.sam'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/star_raw_{db1}_{sample}.txt'
    log:
        'logs/star_raw_{db1}_{sample}.log'
    shell:
        'src/star.sh {input} {output} >& {log}'

rule star_trim:
    input:
        'data/{db1}/star_index',
        'data/{sample}_1_paired.fastq.gz',
        'data/{sample}_2_paired.fastq.gz'
    output:
        'data/{db1}/trim/{sample}/star/Aligned.out.sam'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/star_trim_{db1}_{sample}.txt'
    log:
        'logs/star_trim_{db1}_{sample}.log'
    shell:
        'src/star.sh {input} {output} >& {log}'

rule featurecounts:
    input:
        'data/{db1}/{type}/{sample}/star/Aligned.out.sam',
    output:
        'data/{db1}/{type}/{sample}/featurecounts/featurecounts.summary'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/featurecounts_{db1}_{type}_{sample}.txt'
    log:
        'logs/featurecounts_{db1}_{type}_{sample}.log'
    shell:
        'src/featurecounts.sh {input} {output} {wildcards.db1} >& {log}'

#################################
# Alignment-free Quantification
#################################
rule salmon_count_raw:
    input:
        'data/{db2}/salmon_index',
        'data/{sample}_1.fastq.gz',
        'data/{sample}_2.fastq.gz'
    output:
        'data/{db2}/raw/{sample}/salmon/quant.sf'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/salmon_count_{db2}_raw_{sample}.txt'
    log:
        'logs/salmon_count_{db2}_raw_{sample}.log'
    shell:
        'src/salmon_count.sh {input} {wildcards.db2} raw {wildcards.sample} >& {log}'

rule salmon_count_trim:
    input:
        'data/{db2}/salmon_index',
        'data/{sample}_1_paired.fastq.gz',
        'data/{sample}_2_paired.fastq.gz'
    output:
        'data/{db2}/trim/{sample}/salmon/quant.sf'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/salmon_count_{db2}_trim_{sample}.txt'
    log:
        'logs/salmon_count_{db2}_trim_{sample}.log'
    shell:
        'src/salmon_count.sh {input} {wildcards.db2} trim {wildcards.sample} >& {log}'