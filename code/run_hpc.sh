#!/bin/bash -l

# Standard output and error:
#SBATCH -o /ptmp/aenge/mask_children/code/slurm/tjob.out.%j
#SBATCH -e /ptmp/aenge/mask_children/code/slurm/tjob.err.%j
# Initial working directory:
#SBATCH -D /ptmp/aenge/mask_children/
# Job Name:
#SBATCH -J mask_children_sing
# Queue (Partition):
#SBATCH --partition=general
# Number of nodes and MPI tasks per node:
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=40
# Request main memory per node in units of MB:
#SBATCH --mem=185000
# Wall clock limit:
#SBATCH --time=24:00:00
# E-mail notifications
#SBATCH --mail-type=ALL
#SBATCH --mail-user=enge@cbs.mpg.de

# Run the program:

# Load singularity
module load singularity

# Store the parameters for all calls to singularity exec
SINGULARITY_PARAMS=(
    --no-home
    --pwd /home/workspaces/mask_children/code \
    --bind /ptmp/aenge/mask_children:/home/workspaces/mask_children \
    mask_children_latest.sif
)

# First, perform only the actual ALE analyses
srun -n1 singularity exec "${SINGULARITY_PARAMS[@]}" python3 nb01_ale.py

# Then, perform all of the other analyses in parallel
srun -n1 singularity exec "${SINGULARITY_PARAMS[@]}" python3 nb02_subtraction.py &
    srun -n1 singularity exec "${SINGULARITY_PARAMS[@]}" python3 nb03_adults.py