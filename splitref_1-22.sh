#!/bin/bash

#SBATCH --job-name=call
#SBATCH --mem=2G
#SBATCH --output=split%a.out
#SBATCH --error=split%a.err
#SBATCH -c 10
#SBATCH -t 3-00:00:00
#SBATCH --array=1-22

# Activate your environments here
source ~/.bashrc
source /share/apps/NYUAD5/miniconda/3-4.11.0/bin/activate
conda activate /scratch/nme3923/conda-envs/glimpse2

BIN=/scratch/nme3923/conda-envs/glimpse2/bin/GLIMPSE2_split_reference

# Get the chromosome number from the job array index
CHR=$SLURM_ARRAY_TASK_ID

# Set the reference and map files for the current chromosome
REF=all_refs/bcf/ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.bcf
MAP=../modern/gmaps/chr${CHR}.b37.gmap.gz

# Process each line in the chunks file for the current chromosome
while read -r LINE; do
  ID=$(echo $LINE | cut -d" " -f1)
  IRG=$(echo $LINE | cut -d" " -f3)
  ORG=$(echo $LINE | cut -d" " -f4)

  $BIN --reference $REF --map $MAP --input-region $IRG --output-region $ORG --output split/chr${CHR}_split_ref_${ID}.bcf
done < chunks/chunks.chr${CHR}.txt

