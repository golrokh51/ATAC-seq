#!/bin/bash
#SBATCH --job-name=bowtie2
#SBATCH --time=48:00:00
#SBATCH --mem=2057500M
#SBATCH --cpus-per-task=20
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
# bam=${sam/.sam/_sorted.bam}



ump=${sam/.sam/_unmapped.fastq} # les reads non paires
mmp=${sam/.sam/_multiple.fastq}  #mapped more than one time
metric=${sam/.sam/_metric.txt}

samstat=${sam/.sam/_stats.txt}

logf=${sam/.sam/_bowt2.log}
logf=${logf/_SAM/_logs\/_bowtie2}

rgID=$(sed -n "${SLURM_ARRAY_TASK_ID}p" _labels.txt)

rgname=$(sed -n "${SLURM_ARRAY_TASK_ID}p" _groups.txt) 

# IFS='\t' read -r -a array <<< "$rgID"
# 
# rgID="${array[1]}"
# rgname="${array[0]}"

rgline="--rg-id "$rgID" --rg SM:"$rgname" --rg LB:"$rgname
indx=/scratch/banire/genomes/AzucenaRS1/AzucenaRS1


module load  StdEnv/2020  bowtie2/2.4.4  samtools/1.16.1


bowtie2 --threads 40 --very-sensitive -X 1000  -k 10 --un $ump --al $mmp  --met-file $metric $rgline  -x $indx -1 $f1 -2 $f2 -S $sam 2>$logf
# echo Bowtie2
echo "bowtie2 --threads 40 --very-sensitive -X 1000  -k 10 --un $ump --al $mmp  --met-file $metric $rgline  -x $indx -1 $f1 -2 $f2 -S $sam 2>$logf"


#bowtie2 --threads 40 --very-sensitive -X 1000  -k 10  --met-file $metric $rgline  -x $indx -1 $f1 -2 $f2 -S $sam 


# echo $samstat >>_all_samstat.txt

# samtools sort  -@ 32 -n  -o $bam $sam
# echo "samtools sort"
# samtools stats $sam >$samstat
# echo "samtools stats"
# echo $bam >>_all_bam.txt
# echo $samstat >>_all_samstat.txt


# grep ">" /scratch/banire/genomes/AzucenaRS1/GCA_009830595.1_AzucenaRS1_genomic.12chr_chloroplast.fa | while read -r line; do  chr="${line:1}"; echo $chr>>_list_chr.txt; done
