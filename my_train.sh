./tools/train_net.py \
  --gpu 0 \
  --solver models/pascal_voc/ResNet_50/rfcn_end2end/solver_ohem.prototxt \
  --weights data/imagenet_models/ResNet_50_model.caffemodel \
  --imdb kitti_train \
  --iters 10000 \
  --cfg experiments/cfgs/rfcn_end2end_ohem.yml


