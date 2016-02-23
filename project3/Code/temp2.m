% Initialization
pic = int32(rgb2gray(imread('fur_obs.jpg')));
[F, filters, width, height] = myfilters; %Calculate filter sets.
width = int32(width);
height = int32(height);

% Generate random image as iniital image
I = int32(rand(size(pic)) * 255);

hist_pic = getHistogram(pic, filters(3, :)', width(1), height(1)); %Compute histograms.
hist_I = getHistogram(I, filters(3, :)', width(1), height(1)); %Compute histograms.

selected_filters = [];

% Compute weighted error for each filter
num_bins = length(hist_I);
[num_filters, y] = size(filters);
errors = zeros(1, num_filters);
for i = 1:num_bins
	hist_pic = getHistogram(pic, filters(i, :)', width(1), height(1));
	hist_I = getHistogram(I, filters(i, :)', width(1), height(1));
	errors(i) = norm(hist_pic - hist_I);
end

[max_error, max_idx] = max(errors(5:15))

% Select the filter with most error


%histo1 = getHistogram(pic, filters(3, :)', width(1), height(1)); %Compute histograms.
%histo1
%plot(histo1)
%[synthesized1, histo1a] = Julesz(reshape(histo1', 15, 1), filters(1, :)', width(1), height(1)); %Sampling.
%imwrite(uint8(synthesized1), 'syn1.bmp', 'bmp');
