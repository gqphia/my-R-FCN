./tools/test_net.py \
  --gpu 2 \
  --def models/pascal_voc/ResNet_50/rfcn_end2end/test_agnostic_anchor.prototxt \
  --net output/rfcn_end2end_ohem/kitti_train/resnet50_rfcn_anchor_iter_60000.caffemodel \
  --imdb kitti_test \
  --cfg experiments/cfgs/rfcn_end2end_ohem.yml
