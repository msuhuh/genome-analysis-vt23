#!/bin/bash -l
#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 00:30:00
#SBATCH -J misa1224_quast_eval
#SBATCH --mail-type=ALL
#SBATCH --mail-user minna.sayehban.1224@student.uu.se

# LOAD MODULES
module load bioinfo-tools
module load quast

# RUN ASSEMBLY EVALUATION
in_file="/home/samuraii/genome-analysis-vt23/analyses/01_genome_assembly/assembly_canu.contigs.fasta"
ref_file="/proj/genomeanalysis2023/Genome_Analysis/2_Christel_2017/reference/OBMB01.fasta"
out_folder="/home/samuraii/genome-analysis-vt23/analyses/02_structural_annotation"

quast.py $in_file -o $out_folder -r $ref_file

