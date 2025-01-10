import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("7.20.0")

container: 'docker://koki/urchin_workflow_bioconda:20220527'

rule all:
    input:
        expand('data/{db}/star_index/Log.out',
            db=['hpbase']),
        expand('data/{db}/salmon_index/sa.bin',
            db=['hpbase', 'hpbase_nucl'])

#################################
# Alignment-based Quantification
#################################
rule index_star_hpbase:
    input:
        'data/hpbase/HpulGenome_v1_scaffold.fa',
        'data/hpbase/HpulGenome_v1.gff3'
    output:
        'data/hpbase/star_index/Log.out'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/star_index_hpbase.txt'
    log:
        'logs/star_index_hpbase.log'
    shell:
        'src/star_index_hpbase.sh >& {log}'

#################################
# Alignment-free Quantification
#################################
rule index_salmon_hpbase:
    input:
        'data/hpbase/HpulTranscriptome.fa'
    output:
        'data/hpbase/salmon_index/sa.bin'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/index_salmon_hpbase.txt'
    log:
        'logs/index_salmon_hpbase.log'
    shell:
        'src/index_salmon_hpbase.sh >& {log}'

rule index_salmon_hpbase_nucl:
    input:
        'data/hpbase/HpulTranscriptome_nucl.fa'
    output:
        'data/hpbase_nucl/salmon_index/sa.bin'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/index_salmon_hpbase_nucl.txt'
    log:
        'logs/index_salmon_hpbase_nucl.log'
    shell:
        'src/index_salmon_hpbase_nucl.sh >& {log}'
