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
        expand('plot/{db1}/{type}/{method}_celltype.html',
            db1=DBS1, type=TYPES, method=OMNIDECONV_METHODS),
        expand('plot/{db1}/{type}/{method}_cluster.html',
            db1=DBS1, type=TYPES, method=OMNIDECONV_METHODS)

rule bulk:
    input:
        'data/hpbase/HpulGenome_v1_annot.xlsx',
        'output/FeatureCounts_{db1}_{type}.txt'
    output:
        'data/{db1}/{type}/bulk.csv'
    resources:
        mem_mb=1000000
    container:
        'docker://koki/urchin_workflow_r:20220531'
    benchmark:
        'benchmarks/bulk_{db1}_{type}.txt'
    log:
        'logs/bulk_{db1}_{type}.log'
    shell:
        'src/bulk.sh {input} {output} >& {log}'

rule omnideconv_celltype:
    input:
        'data/seurat_annotated.RData',
        'data/{db1}/{type}/bulk.csv'
    output:
        'output/{db1}/{type}/{method}_celltype.RData'
    resources:
        mem_mb=1000000
    container:
        'docker://koki/omnideconv:20250110'
    benchmark:
        'benchmarks/omnideconv_celltype_{db1}_{type}_{method}.txt'
    log:
        'logs/omnideconv_celltype_{db1}_{type}_{method}.log'
    shell:
        'src/omnideconv_celltype.sh {input} {output} {wildcards.method} >& {log}'

rule omnideconv_cluster:
    input:
        'data/seurat_annotated.RData',
        'data/{db1}/{type}/bulk.csv'
    output:
        'output/{db1}/{type}/{method}_cluster.RData'
    resources:
        mem_mb=1000000
    container:
        'docker://koki/omnideconv:20250110'
    benchmark:
        'benchmarks/omnideconv_cluster_{db1}_{type}_{method}.txt'
    log:
        'logs/omnideconv_cluster_{db1}_{type}_{method}.log'
    shell:
        'src/omnideconv_cluster.sh {input} {output} {wildcards.method} >& {log}'

rule report_celltype:
    input:
        'output/{db1}/{type}/{method}_celltype.RData'
    output:
        'plot/{db1}/{type}/{method}_celltype.html'
    resources:
        mem_mb=1000000
    container:
        'docker://koki/omnideconv:20250110'
    benchmark:
        'benchmarks/report_celltype_{db1}_{type}_{method}.txt'
    log:
        'logs/report_celltype_{db1}_{type}_{method}.log'
    shell:
        'src/report.sh {input} {output} {wildcards.method} >& {log}'

rule report_cluster:
    input:
        'output/{db1}/{type}/{method}_cluster.RData'
    output:
        'plot/{db1}/{type}/{method}_cluster.html'
    resources:
        mem_mb=1000000
    container:
        'docker://koki/omnideconv:20250110'
    benchmark:
        'benchmarks/report_cluster_{db1}_{type}_{method}.txt'
    log:
        'logs/report_cluster_{db1}_{type}_{method}.log'
    shell:
        'src/report.sh {input} {output} {wildcards.method} >& {log}'

