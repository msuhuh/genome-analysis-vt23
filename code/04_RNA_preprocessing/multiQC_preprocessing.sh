#!/bin/bash -l
#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 05:00:00
#SBATCH -J misa1224_multiqc_raw
#SBATCH --mail-type=ALL
#SBATCH --mail-user minna.sayehban.1224@student.uu.se

# LOAD MODULES
module load bioinfo-tools
module load MultiQC

# SET FILES
in_data="/home/samuraii/genome-analysis-vt23/analyses/04_RNA_preprocessing/fastqc_raw/*.zip"

# RUN MULTIQC
multiqc $in_data

