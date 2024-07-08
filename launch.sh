#!/bin/bash
#SBATCH --time=120:00:00
#SBATCH --cpus-per-task=10
#SBATCH --mail-type=ALL
#SBATCH --job-name snv_caller_batch_run
#SBATCH -o %j.out
#SBATCH -e %j.err

snakemake -j 999 \
    --keep-going \
    -s Snakefile \
    --local-cores 8 \
    --cluster-config config.json \
    --latency-wait=300 \
    --directory $PWD \
    --verbose \
    --rerun-incomplete \
    --jobname "s.{rulename}.{jobid}.sh" \
    --cluster "sbatch --mem {cluster.mem} --partition=gpu --gres=gpu:v100x:1 --cpus-per-task {threads} -t {cluster.time} --error=logs/{rule}.e.%j" \
    --use-conda \
    --conda-frontend conda




