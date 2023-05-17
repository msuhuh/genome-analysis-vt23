#!/bin/bash -l
#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 10:00:00
#SBATCH -J misa1224_mappingg
#SBATCH --mail-type=ALL
#SBATCH --mail-user minna.sayehban.1224@student.uu.se

# LOAD MODULES
module load bioinfo-tools
module load bwa
module load samtools

# SET FILES
canu_in_file="/home/samuraii/genome-analysis-vt23/analyses/01_genome_assembly/assembly_canu.contigs.fasta"
reads_folder="/proj/genomeanalysis2023/Genome_Analysis/2_Christel_2017/RNA_trimmed_reads"
out_folder="/home/samuraii/genome-analysis-vt23/analyses/06_mapping_reads"

# RUN MAPPING
for read_file in $reads_folder/*.fastq.gz; do
  # EXTRACT THE FILENAME WITHOUT EXTENSION
  filename=$(basename "$read_file" .fastq.gz)

  # MAP READS TO THE GENOME AND DIRECTLY CONVERT TO BAM FORMAT
  bwa mem -t 4 $canu_in_file $read_file | samtools view -bS - > "$out_folder/${filename}.bam"

  # SORT THE BAM FILE
  samtools sort "$out_folder/${filename}.bam" -o "$out_folder/${filename}.sorted.bam"

  # INDEX THE SORTED BAM FILE
  samtools index "$out_folder/${filename}.sorted.bam"
done


