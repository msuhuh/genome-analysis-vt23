#!/bin/bash -l
#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 10:00:00
#SBATCH -J misa1224_blastn_synteny
#SBATCH --mail-type=ALL
#SBATCH --mail-user minna.sayehban.1224@student.uu.se

# LOAD MODULES
module load bioinfo-tools
module load blast

# SET FILES
canu_in_file="/home/samuraii/genome-analysis-vt23/analyses/01_genome_assembly/assembly_canu.contigs.fasta"
ref_in_file="/home/samuraii/genome-analysis-vt23/data/ref_genome_files/ncbi-genomes-2023-05-16/GCF_000299235.1_ASM29923v1_genomic.fna"
out_folder="/home/samuraii/genome-analysis-vt23/analyses/05_synteny_comparison"

# RUN BLASTN
blastn -query $canu_in_file -subject $ref_in_file -outfmt 6 -out $out_folder/blastn_comparison.txt
