./tools/train_net.py \
  --gpu 1 \
  --solver models/pascal_voc/ResNet-101/rfcn_end2end/solver.prototxt \
  --weights data/imagenet_models/ResNet-101-model.caffemodel \
  --imdb kitti_train \
  --iters 150000 \
  --cfg experiments/cfgs/rfcn_end2end_ohem.yml > my_train_res101.log >my_train_res101.err


