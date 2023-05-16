#!/bin/bash -l
#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 05:00:00
#SBATCH -J misa1224_fastQC_raw
#SBATCH --mail-type=ALL
#SBATCH --mail-user minna.sayehban.1224@student.uu.se

# LOAD MODULES
module load bioinfo-tools
module load FastQC

# SET FILES
out_folder="/home/samuraii/genome-analysis-vt23/analyses/04_RNA_preprocessing/fastqc_raw"
in_folder="/proj/genomeanalysis2023/Genome_Analysis/2_Christel_2017/RNA_raw_data"


# RUN QUALITY CHECK
for file in "$in_folder"/*.fastq.gz; do
  fastqc -t 4 -o "$out_folder" "$file"
done

