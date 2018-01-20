./tools/train_net.py \
  --gpu 0 \
  --solver models/pascal_voc/ResNet_50/rfcn_end2end/solver.prototxt \
  --weights data/imagenet_models/ResNet_50_model.caffemodel \
  --imdb kitti_train \
  --iters 150000 \
  --cfg experiments/cfgs/rfcn_end2end_ohem.yml 2>&1 | tee experiments/logs/RFCN_rcnn_end2end_Res50_area1.3_12scales.log 

# > my_train_res50.log 2> my_train_res50.err

# if you want to see it you can use another screen terminal and try
# tail -f my_train_res50.log
# or .err for following the error output
# also things like this are useful
# cat my_train_res50.err | grep Accuracy
# that might show you how accuracy is changing and so on



