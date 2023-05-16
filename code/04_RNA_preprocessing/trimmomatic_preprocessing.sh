#!/bin/bash -l
#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 05:00:00
#SBATCH -J misa1224_trimmomatic
#SBATCH --mail-type=ALL
#SBATCH --mail-user minna.sayehban.1224@student.uu.se

# LOAD NECESSARY MODULES
module load bioinfo-tools
module load trimmomatic


# SET FILES
out_folder="/home/samuraii/genome-analysis-vt23/analyses/04_RNA_preprocessing/fastqc_trim_mine"
in_folder="/proj/genomeanalysis2023/Genome_Analysis/2_Christel_2017/RNA_raw_data"

file_prefixes=("ERR2036629" "ERR2036630")

# RUN TRIMMOMATIC
for prefix in "${file_prefixes[@]}"; do
  r1="${in_folder}/${prefix}_1.fastq.gz"
  r2="${in_folder}/${prefix}_2.fastq.gz"

  trimmomatic PE -threads 4 \
    "$r1" "$r2" "$out_folder/trimmed_${prefix}_1.fastq.gz" "$out_folder/unpaired_${prefix}_1.fastq.gz" \
    "$out_folder/trimmed_${prefix}_2.fastq.gz" "$out_folder/unpaired_${prefix}_2.fastq.gz" \
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done


