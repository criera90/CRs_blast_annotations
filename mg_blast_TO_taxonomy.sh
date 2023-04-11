#!/bin/sh

#####################################################################################
#####################################################################################
# Program name      mg_mapping_contigs.sh
# Version           v1.1
# Author            Carlos Riera-Ruiz
# Date modified     230227
# Function
#
# Notes:            this version uses 
#                   
#                   
#                   * Specify input and output directories
#
#####################################################################################
#####################################################################################

#SBATCH --time=12:00:00          # Run time in hh:mm:ss
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=48GB       # Maximum memory required per CPU (in megabytes)
#SBATCH --cpus-per-task=16
#SBATCH --job-name=krista_blast_taxonomy
#SBATCH --error=/lustre/work/adamowiczlab/crieraruiz/PROJECTS/krista/SLURM_reports/job.%J.%x.err
#SBATCH --output=/lustre/work/adamowiczlab/crieraruiz/PROJECTS/krista/SLURM_reports/job.%J.%x.out
### counter start ###
STARTTIME=$(date +%s)
###############################################################################

INPUT_DIR="/lustre/work/adamowiczlab/crieraruiz/PROJECTS/krista/input"
OUT_DIR="/lustre/work/adamowiczlab/crieraruiz/PROJECTS/krista/output"

# load modules
module load blast/2.13
module load biodata

#TOTAL_MEMORY=`echo "scale=0;($SLURM_MEM_PER_CPU*$SLURM_CPUS_PER_TASK)/1024" | bc`
# as of now, $SLURM_MEM_PER_CPU doesn't apply because using --mem, not --mem-per-cpu

##------------------------#
## --- Create out dirs ---#
##------------------------#
#declare -a DIRS=("00_sorted 01_idxstats")
inputs=$(\ls $INPUT_DIR | cut -d. -f1)
for directories in $inputs; do
    if [ ! -d $OUT_DIR/$directories ]; then
        mkdir $OUT_DIR/$directories;
    fi
done

##--------------------------#
## --- BLAST fasta files ---#
##--------------------------#

for file in `\ls $INPUT_DIR`; do
    file_name=$(echo $file | cut -d. -f1)

    sh /lustre/work/adamowiczlab/crieraruiz/PROJECTS/NIJ2/06_blast_taxonomy_assignment/scripts/annotate4.sh -f $INPUT_DIR/$file -o $OUT_DIR/$file_name

done

##------------------------------------#
## --- Kaiju taxonomy assignation ---#
##------------------------------------#

###############################################################################
#### counter end ####
#####################
ENDTIME=$(date +%s)
#echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."
TOTALTIME=`echo "scale=2;($ENDTIME - $STARTTIME)/60" | bc`  # get time in min by
                                                            # by dividing by 60
echo "It took $TOTALTIME min to complete this task"

