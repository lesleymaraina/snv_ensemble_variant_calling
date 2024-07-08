
configfile: "envs/config.yaml"
sampleID = config["sample_ids"]
home_dir = config["home_dir"]
parapath = config["para_path"]

rule all:
    input:
        expand("{homedir}/output/HC/{sample}_HC_output.g.vcf", sample=sampleID, homedir=home_dir)

############################
# Variant Discovery
############################
rule strelka: 
    input:
        ref = config['ref'],
        bam_germl = "./WGS/bam/{sample}.WholeGenome.bam",
        bam_germl_ind = "./WGS/bam/{sample}.WholeGenome.bam.bai"
    output:
        "{homedir}/{sample}.strelka_work/results/variants/variants.vcf.gz"
    log:
        "{homedir}/logs/strelka/{sample}_strelka.vcf.log"
    threads: 20
    shell:
        "rm -rf *.strelka_work && "
        "{parapath}/pbrun strelka "
        "--ref {input.ref} "
        "--in-bams {input.bam_germl} "
        "--out-prefix {wildcards.sample}"

rule HC:
    input:
        ref = config['ref'],
        bam_germl = "/data/AlexanderP3/SJCLOUD/RBL/retinoblastoma/germline/WGS/bam/{sample}.WholeGenome.bam",
        bam_germl_ind = "/data/AlexanderP3/SJCLOUD/RBL/retinoblastoma/germline/WGS/bam/{sample}.WholeGenome.bam.bai"
    output:
        "{homedir}/output/HC/{sample}_HC_output.g.vcf"
    log:
        "{homedir}/logs/HC/{sample}_HC.vcf.log"
    threads: 20
    shell:
        "{parapath}/pbrun haplotypecaller "
        "--ref {input.ref} "
        "--in-bam {input.bam_germl} "
        "--out-variants {wildcards.homedir}/output/HC/{wildcards.sample}_HC_output.g.vcf --gvcf"

rule DV:
    input:
        ref = config['ref'],
        bam_germl = "./WGS/bam/{sample}.WholeGenome.bam",
        bam_germl_ind = "./WGS/bam/{sample}.WholeGenome.bam.bai"
    output:
        "{homedir}/output/DV/{sample}_DV_output.g.vcf"
    log:
        "{homedir}/logs/DV/{sample}_DV.vcf.log"
    threads: 20
    shell:
        "{parapath}/pbrun deepvariant "
        "--ref {input.ref} "
        "--in-bam {input.bam_germl} "
        "--out-variants {wildcards.homedir}/output/DV/{wildcards.sample}_DV_output.g.vcf --gvcf"





