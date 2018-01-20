./tools/test_net.py \
  --gpu 1 \
  --def models/pascal_voc/ResNet_50/rfcn_end2end/test_agnostic_4anchors.prototxt \
  --net output/rfcn_end2end_ohem/kitti_train/resnet50_rfcn_4anchors_iter_iter_150000.caffemodel \
  --imdb kitti_test \
  --cfg experiments/cfgs/rfcn_end2end_ohem.yml
