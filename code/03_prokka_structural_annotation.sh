#!/bin/bash -l
#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:15:00
#SBATCH -J misa1224_prokka
#SBATCH --mail-type=ALL
#SBATCH --mail-user minna.sayehban.1224@student.uu.se

# LOAD MODULES
module load bioinfo-tools
module load prokka

# ANNOTATE THE ASSEMBLY
in_file="/home/samuraii/genome-analysis-vt23/analyses/01_genome_assembly/assembly_canu.contigs.fasta"
out_folder="/home/samuraii/genome-analysis-vt23/analyses/03_structural_annotation"
out_file="annotation_prokka"

prokka --prefix $out_file --outdir $out_folder --force --cpus 2 $in_file
