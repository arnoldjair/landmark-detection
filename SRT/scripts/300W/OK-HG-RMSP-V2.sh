# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#
#
#!/usr/bin/env sh
# bash scripts/300W/OK-HG-RMSP-V2.sh 0 GTL
echo script name: $0
echo $# arguments
if [ "$#" -ne 2 ] ;then
  echo "Input illegal number of parameters " $#
  echo "Need 2 parameters for gpu devices and the face bounding box"
  exit 1
fi
gpus=$1
det=$2
sigma=3
use_gray=1
batch_size=16
save_dir=./snapshots/WELL-300W-HG-V2-${det}-256x256-S${sigma}

rm -rf ${save_dir}
CUDA_VISIBLE_DEVICES=${gpus} python ./exps/BASE-main.py \
    --train_lists ./cache_data/lists/300W/300w.train.pth \
    --eval_ilists ./cache_data/lists/300W/300w.test-common.pth \
                  ./cache_data/lists/300W/300w.test-challenge.pth \
                  ./cache_data/lists/300W/300w.test-full.pth \
    --mean_point  ./cache_data/lists/300W/300w.train-mean.pth \
    --boxindicator ${det} --use_gray ${use_gray} \
    --num_pts 68 --data_indicator face68-300W \
    --procedure heatmap --rand_seed 90828 \
    --model_config ./configs/face/WELL/HG.300W.config \
    --opt_config   ./configs/face/R256/RMSP.300W.config \
    --save_path    ${save_dir} \
    --pre_crop_expand 0.2 --color_disturb 0.4 \
    --scale_prob 0.5 --scale_min 0.9 --scale_max 1.1 \
    --offset_max 0.1 --rotate_max 30 --rotate_prob 0.5 \
    --height 256 --width 256 --sigma ${sigma} --batch_size ${batch_size} \
    --print_freq 100 --print_freq_eval 200 --eval_freq 5 --workers 8 \
    --heatmap_type gaussian
