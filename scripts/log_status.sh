#!/bin/bash

BASE=/ABSOLUTE/PATH/TO/pipeline
LOG=$BASE/logs/pipeline_status.log

while true; do
    TS=$(date +%s)
    PENDING=$(ls $BASE/batch_pending | wc -l)
    PROCESS=$(ls $BASE/batch_processing | wc -l)
    DONE=$(ls $BASE/batch_done | wc -l)
    RESULT=$(ls $BASE/result | wc -l)

    echo "$TS,$PENDING,$PROCESS,$DONE,$RESULT" >> $LOG
    sleep 1
done

