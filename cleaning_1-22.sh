#!/bin/bash
#SBATCH --job-name=call
#SBATCH --array=1-3
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --time=8:00:00
#SBATCH --output=val0_%a.out
#SBATCH --error=val0_%a.er

# Activate your environments here
source ~/.bashrc
source /share/apps/NYUAD5/miniconda/3-4.11.0/bin/activate
conda activate /scratch/nme3923/conda-envs/glimpse2

#INPUT_DIR=
OUTPUT_DIR="bcf" 
#mkdir -p $OUTPUT_DIR

CHR=$SLURM_ARRAY_TASK_ID

INPUT_VCF="ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz"

# Output BCF file
OUTPUT_BCF="${OUTPUT_DIR}/ALL.chr${CHR}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.bcf"

# Normalize the VCF file
bcftools norm -m -any "$INPUT_VCF" -Ou --threads 4 | \

#  View and filter the VCF without excluding any samples
bcftools view -m 2 -M 2 -v snps --threads 4 -Ob -o "$OUTPUT_BCF"

#Index the output BCF file
bcftools index -f "$OUTPUT_BCF" --threads 4

echo "Processing for chromosome $CHR completed."
