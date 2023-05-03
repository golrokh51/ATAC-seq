#!/bin/bash
#SBATCH --job-name=sort
#SBATCH --time=48:00:00
#SBATCH --mem=2057500M
#SBATCH --cpus-per-task=40
#SBATCH --output=../results/_logs/%x_%A_%a.out
#SBATCH --error=../results/_logs/%x_%A_%a.err
#SBATCH --mail-user=mamoolack@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --chdir=/scratch/banire/jobs/230119_ATACseq_zoe/scripts
inputFiles=_all_fq.txt

# f1=../data/AUDEM_E10_S63_L006_1_P.fastq.gz
#rm ../data/*.fastq 


f1=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $inputFiles)	
# f1=../data/AUDEM_E10_S63_L006_1_P.fastq.gz
#rm ../data/*.fastq 
f2=${f1/_R1/_R2}

sam=${f1/_R1_P.fastq.gz/.sam}
sam=${sam/data\/_trimmed/results\/_SAM}
ssam=${sam/.sam/_sorted.sam}

module load  StdEnv/2020 samtools/1.16.1


# echo $samstat >>_all_samstat.txt

samtools sort  -@ 32 -n  -o $bam $sam
echo "samtools sort"
# echo $bam >>_all_bam.txt
# echo $samstat >>_all_samstat.txt


# grep ">" /scratch/banire/genomes/AzucenaRS1/GCA_009830595.1_AzucenaRS1_genomic.12chr_chloroplast.fa | while read -r line; do  chr="${line:1}"; echo $chr>>_list_chr.txt; done
