#!/bin/bash
#PBS -q njobs-g
#PBS -l select=1
#PBS -l walltime=0:10:00
#PBS -W group_list=gtxx

cd /ABSOLUTE/PATH/TO/pipeline/src
BASE=/ABSOLUTE/PATH/TO/pipeline

###############################################
# 1. 未処理バッチを 1 個だけ選ぶ（古い順）
###############################################
PENDING=$(ls -td ${BASE}/batch_pending/batch_*.opbs 2>/dev/null | tail -n 1)

if [ -z "$PENDING" ]; then
    echo "No pending batch. Exit."
    exit 0
fi

###############################################
# 2. processing に移動（排他制御）
###############################################
BNAME=$(basename "$PENDING")
PROC_DIR=${BASE}/batch_processing/${BNAME}

mv "$PENDING" "$PROC_DIR"

INDIR="$PROC_DIR"

###############################################
# 3. 出力先
###############################################
jid_num=${PBS_JOBID%%.*}
OUTDIR=${BASE}/result/result_${jid_num}.opbs
mkdir -p "$OUTDIR"

module purge
module load gcc cuda ompi-cuda

python train.py "$INDIR" "$OUTDIR"

###############################################
# 4. done に移動
###############################################
DONE_DIR=${BASE}/batch_done/${BNAME}
mv "$PROC_DIR" "$DONE_DIR"


