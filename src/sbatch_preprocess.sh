#!/bin/bash
#PBS -q njobs-c
#PBS -l select=1:ompthreads=112
#PBS -l walltime=0:10:00
#PBS -W group_list=gtxx

module load intel/2025.2.0

# PBS でも確実に src に移動する絶対パス(Git公開用ダミーパス)
cd /ABSOLUTE/PATH/TO/pipeline/src

BASE=/ABSOLUTE/PATH/TO/pipeline
OUTDIR=${BASE}/batch_pending/batch_${PBS_JOBID}.opbs

mkdir -p "$OUTDIR"

export OMP_NUM_THREADS=112
export OMP_PROC_BIND=close
export OMP_PLACES=cores

python preprocess.py "$OUTDIR"

