./tools/train_net.py \
  --gpu 1 \
  --solver models/pascal_voc/ResNet_50/rfcn_end2end/solver_ohem.prototxt \
  --weights data/imagenet_models/ResNet_50_model.caffemodel \
  --imdb kitti_train \
  --iters 100000 \
  --cfg experiments/cfgs/rfcn_end2end_ohem.yml > my_train_res50.log 2> my_train_res50.err


# if you want to see it you can use another screen terminal and try
# tail -f my_train_res50.log
# or .err for following the error output
# also things like this are useful
# cat my_train_res50.err | grep Accuracy
# that might show you how accuracy is changing and so on



