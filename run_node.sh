#!/bin/bash

echo ${GATEPASS} | tee ${GATEHOME}/acc_pass.txt
gatecli account create --indent --output json < ${GATEHOME}/acc_pass.txt &> ${GATEHOME}/acc_log.json
gated start --pruning nothing
