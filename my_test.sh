./tools/test_net.py \
  --gpu 1 \
  --def models/pascal_voc/ResNet_50/rfcn_end2end/test_agnostic.prototxt \
  --net output/rfcn_end2end_ohem/kitti_train/resnet50_rfcn_ohem_iter_10000.caffemodel \
  --imdb kitti_test \
  --cfg experiments/cfgs/rfcn_end2end_ohem.yml
