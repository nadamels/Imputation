#!/bin/bash

#SBATCH --job-name=call
#SBATCH --mem=2G
#SBATCH --output=call_%a.out
#SBATCH --error=call_%a.err
#SBATCH -c 10
#SBATCH -t 3-00:00:00
#SBATCH --array=1-22

# Activate your environments here
source ~/.bashrc
source /share/apps/NYUAD5/miniconda/3-4.11.0/bin/activate
conda activate /scratch/nme3923/conda-envs/glimpse2

BIN=/scratch/nme3923/conda-envs/glimpse2/bin/GLIMPSE2_chunk

CHR=$SLURM_ARRAY_TASK_ID

# Chunking for the specific chromosome
$BIN --input all_refs/bcf/ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.bcf \
     --region ${CHR} \
     --sequential \
     --output chunks/chunks.chr${CHR}.txt \
     --map ../modern/gmaps/chr${CHR}.b37.gmap.gz
