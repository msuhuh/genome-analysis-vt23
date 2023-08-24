#!/bin/bash -l
#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 05:00:00
#SBATCH -J misa1224_multiqc_trimmed
#SBATCH --mail-type=ALL
#SBATCH --mail-user minna.sayehban.1224@student.uu.se

# LOAD MODULES
module load bioinfo-tools
module load MultiQC

# SET FILES
in_data="/proj/genomeanalysis2023/Genome_Analysis/2_Christel_2017/RNA_trimmed_reads/*"

# RUN MULTIQC
multiqc $in_data
