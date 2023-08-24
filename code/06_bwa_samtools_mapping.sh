#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 10
#SBATCH -t 07:00:00
#SBATCH -J misa1224_bwa_samtools
#SBATCH --mail-type=ALL
#SBATCH --mail-user minna.sayehban.1224@student.uu.se

# Load modules
module load bioinfo-tools
module load bwa
module load samtools

# Variables
in_data="/proj/genomeanalysis2023/Genome_Analysis/2_Christel_2017/RNA_trimmed_reads/"
ref_canu="/home/samuraii/genome-analysis-vt23/analyses/01_genome_assembly/assembly_canu.contigs.fasta"

cd ~/proj/genomeanalysis2023/nobackup/work/samuraii/06_bwa_output/

# BWA index
bwa index $ref_canu -p lferr

# RUN BWA MEM for each pair of paired-end reads
# Then pipe them to samtools to create bam files and sort them
for i in ERR2036629 ERR2036630 ERR2036631 ERR2036632 ERR2036633 ERR2117288 ERR2117289 ERR2117290 ERR2117291 ERR2117292
do
bwa mem -t 4 lferr $in_data${i}_P1.trim.fastq.gz $in_data${i}_P2.trim.fastq.gz | samtools view -S -b | samtools sort -o ${i}.sorted.bam
done
