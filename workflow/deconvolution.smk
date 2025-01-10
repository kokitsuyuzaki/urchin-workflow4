import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("7.20.0")

URCHIN_SAMPLES, = glob_wildcards('data/{sample}_1.fastq.gz')
TYPES = ['trim', 'raw']
DBS1 = ['hpbase']
OMNIDECONV_METHODS = ['dwls', 'bayesprism', 'momf', 'scdc']

rule all:
    input:
        expand('plot/{db1}/{type}/{method}.html',
            db1=DBS1, type=TYPES, method=OMNIDECONV_METHODS)

rule bulk:
    input:
        'data/hpbase/HpulGenome_v1_annot.xlsx',
        'output/FeatureCounts_{db1}_{type}.txt'
    output:
        'data/{db1}/{type}/bulk.csv'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_r:20220531'
    benchmark:
        'benchmarks/bulk_{db1}_{type}.txt'
    log:
        'logs/bulk_{db1}_{type}.log'
    shell:
        'src/bulk.sh {input} {output} >& {log}'

rule omnideconv:
    input:
        'data/seurat_annotated.RData',
        'data/{db1}/{type}/bulk.csv'
    output:
        'output/{db1}/{type}/{method}.RData'
    resources:
        mem_gb=100
    container:
        'docker://koki/omnideconv:20250110'
    benchmark:
        'benchmarks/omnideconv_{db1}_{type}_{method}.txt'
    log:
        'logs/omnideconv_{db1}_{type}_{method}.log'
    shell:
        'src/omnideconv.sh {input} {output} {wildcards.method} >& {log}'

rule report:
    input:
        'output/{db1}/{type}/{method}.RData'
    output:
        'plot/{db1}/{type}/{method}.html'
    resources:
        mem_gb=100
    container:
        'docker://koki/omnideconv:20250110'
    benchmark:
        'benchmarks/report_{db1}_{type}_{method}.txt'
    log:
        'logs/report_{db1}_{type}_{method}.log'
    shell:
        'src/report.sh {input} {output} {wildcards.method} >& {log}'
