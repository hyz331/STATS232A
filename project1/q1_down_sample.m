% Read and normalzie image
m = double(double(rgb2gray((imread('natural_scene_1.jpg')))) ./ 256 .* 32);
%[I D] = imgradient(m);
%gradient = I .* ((D>1) - (D<1));

% Apply gradient filter
filter_histogram(m, 'b');

[h, w] = size(m);
m = double(double(rgb2gray((imresize(imread('natural_scene_1.jpg'), size(m) ./ 4)))) ./ 256 .* 32);
hold on;
filter_histogram(m, 'y');
m = double(double(rgb2gray((imresize(imread('natural_scene_1.jpg'), size(m) ./ 4)))) ./ 256 .* 32);
filter_histogram(m, 'r');


%plot(bins, log(hist_normalized)); % log plot