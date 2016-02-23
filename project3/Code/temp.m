mex getHistogram.c
mex Julesz.c

pic = int32(rgb2gray(imread('fur_obs.jpg')));
[F, filters, width, height] = myfilters; %Calculate filter sets.
width = int32(width);
height = int32(height);

%pic = int32(double(pic)/255*15); %Convert the number of intensities from 256 to 16.

histo1 = getHistogram(pic, filters(1, :)', width(1), height(1)); %Compute histograms.
[synthesized1, histo1a] = Julesz(reshape(histo1', 15, 1), filters(1, :)', width(1), height(1)); %Sampling.
imwrite(uint8(synthesized1), 'syn1.bmp', 'bmp');

histo2 = getHistogram(pic, filters(1:2, :)', width(1:2), height(1:2));
[synthesized2, histo2a] = Julesz(reshape(histo2', 15, 2), filters(1:2, :)', width(1:2), height(1:2));
imwrite(uint8(synthesized2), 'syn2.bmp', 'bmp');

histo3 = getHistogram(pic, filters(1:3, :)', width(1:3), height(1:3));
[synthesized3, histo3a] = Julesz(reshape(histo3', 15, 3), filters(1:3, :)', width(1:3), height(1:3));
imwrite(uint8(synthesized3), 'syn3.bmp', 'bmp');

histo4 = getHistogram(pic, filters(1:4, :)', width(1:4), height(1:4));
[synthesized4, histo4a] = Julesz(reshape(histo4', 15, 4), filters(1:4, :)', width(1:4), height(1:4));
imwrite(uint8(synthesized4), 'syn4.bmp', 'bmp');

histo5 = getHistogram(pic, filters(1:5, :)', width(1:5), height(1:5));
[synthesized5, histo5a] = Julesz(reshape(histo5', 15, 5), filters(1:5, :)', width(1:5), height(1:5));
imwrite(uint8(synthesized5), 'syn5.bmp', 'bmp');
