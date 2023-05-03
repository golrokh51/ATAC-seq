#!/bin/bash
#SBATCH --job-name=rmChrl
#SBATCH --time=24:00:00
#SBATCH --mem=10000M
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err
#SBATCH --mail-user=mamoolack@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --chdir=/scratch/banire/jobs/230119_ATACseq_zoe/scripts
inputFiles=_list_sam.txt
f1=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $inputFiles)	

# to remove reads mapped to chloroplast and index bam files

module load  StdEnv/2020  samtools/1.16.1

filtered="_filtered/"$f1	
filtered=${filtered/_sorted/_filtered}

python removeChrom.py $f1 $filtered GU592207.1