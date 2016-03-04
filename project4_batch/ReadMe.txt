This code uses MatConvNet as the third-part package, which has been included in the code.
The code is tested in ubuntu 14.04, and windows 10 with matlab 2015a, and cuda-7.0.

1 You either use CPU or GPU. To use GPU, you may need to install cuda. Please refer https://developer.nvidia.com/cuda-toolkit for detail information.
  To use GPU, please set config.gpus = [1] in frame_config.m file, otherwise set it config.gpus = [].

2 Run setup.m to compile MatConvNet.

3 For experiment, please run experiment_learn_frame.m (please remember to include all 8 cateogries)

4 If you want to generate more images in one run, you can set nTileRow and nTileCol to generate nTileRow * nTileCol images.

5 If you want to learn 3 layer model, please set config.layer_to_learn = 3 in frame_config.m file.


Thank you for using the code.
