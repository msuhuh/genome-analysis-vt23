#!/bin/bash -l
#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 15:00:00
#SBATCH -J misa1224_canu_assembly
#SBATCH --mail-type=ALL
#SBATCH --mail-user minna.sayehban.1224@student.uu.se

# LOAD MODULES
module load bioinfo-tools
module load canu


# ASSEMBLE USING CANU
in_file="/proj/genomeanalysis2023/Genome_Analysis/2_Christel_2017/DNA_raw_data/*" 
out_folder="/home/samuraii/genome-analysis-vt23/analyses/01_genome_assembly/"

canu -d $out_folder -p assembly_canu genomeSize=2.58m useGrid=false maxThreads=4 -raw -pacbio $in_file

