./tools/test_net.py \
  --gpu 0 \
  --def models/pascal_voc/ResNet_50/rfcn_end2end/test_agnostic.prototxt \
  --net output/rfcn_end2end_ohem/kitti_train/resnet50_rfcn_area3_4scales_iter_150000.caffemodel \
  --imdb kitti_test \
  --cfg experiments/cfgs/rfcn_end2end_ohem.yml
