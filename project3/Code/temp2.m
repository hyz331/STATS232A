% Initialization
pic = rgb2gray(imread('fur_obs.jpg'));
pic = imresize(pic, [256, 256]);
pic = int32(double(pic) ./ 255 .* 7);

[F, filters, width, height] = myfilters; %Calculate filter sets.
width = int32(width);
height = int32(height);

% Generate random image as iniital image
num_filters = 17;
histo5 = getHistogram(pic, filters(1:num_filters, :)', width(1:num_filters), height(1:num_filters));
[synthesized5, histo5a] = Julesz(reshape(histo5', 15, num_filters), filters(1:num_filters, :)', width(1:num_filters), height(1:num_filters));


imshow(synthesized5, []);
%imwrite(uint8(synthesized5), 'syn5.bmp', 'bmp');
