#!/bin/bash
#
# KPC Autoscaler (Kubernetes for PBS Clusters)
# -------------------------------------------
# C = Producer (preprocess)
# G = Consumer (train)
# pending = Queue length (HPA のメトリクス)
# このスクリプトは pending を監視し、G を自動スケールする。

BASE=$(cd "$(dirname "$0")/.." && pwd)
SRC="$BASE/src"

# --- Autoscaler parameters ---
INTERVAL=5          # ループ間隔（秒）
PENDING_HIGH=5       # pending がこの値を超えたら G をスケールアウト
G_SCALE_HIGH=3       # pending が多いときに投入する G の数
G_SCALE_LOW=1        # pending が少ないときに投入する G の数

while true; do
    # --- 現在の pending 数を取得 ---
    PENDING=$(ls $BASE/batch_pending | wc -l)

    # --- Producer: C を常に投入 ---
   qsub $SRC/sbatch_preprocess.sh
   echo "$(date) : submitted C"

    # --- Consumer: pending に応じて G をスケール ---
    if [ $PENDING -gt $PENDING_HIGH ]; then
        # pending が多い → G を複数投入（スケールアウト）
        for i in $(seq 1 $G_SCALE_HIGH); do
            qsub $SRC/sbatch_train.sh
        done
        echo "$(date) : scale up G x$G_SCALE_HIGH (pending=$PENDING)"

    elif [ $PENDING -gt 0 ]; then
        # pending が少ない → G を 1 つ投入
        for i in $(seq 1 $G_SCALE_LOW); do
            qsub $SRC/sbatch_train.sh
        done
        echo "$(date) : scale up G x$G_SCALE_LOW (pending=$PENDING)"

    else
        echo "$(date) : no pending"
    fi

    # --- 次のループまで待つ ---
    sleep $INTERVAL
done




