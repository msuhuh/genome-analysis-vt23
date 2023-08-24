#!/bin/bash -l
#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 20:00:00
#SBATCH -J misa1224_....
#SBATCH --mail-type=ALL
#SBATCH --mail-user minna.sayehban.1224@student.uu.se

# LOAD MODULES
module load bioinfo-tools
module load htseq

# SET FILE
in_folder="/home/samuraii/genome-analysis-vt23/analyses/06_mapping_reads/"
annotation_file="/home/samuraii/genome-analysis-vt23/analyses/03_structural_annotation/annotation_prokka.gff"
out_folder="/home/samuraii/genome-analysis-vt23/analyses/07_count_mapped_reads/"

# ITERATE OVER THE SORTED BAM FILES AND PERFORM READ COUNTING
for i in ERR2036629 ERR2036630 ERR2036631 ERR2036632 ERR2036633
do
htseq-count -f bam -r pos -s reverse -t CDS -i ID $in_folder${i}.sorted.bam $annotation_file > $out_folder${i}.txt
done
