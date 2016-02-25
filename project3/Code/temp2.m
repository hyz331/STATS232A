% Initialization
pic = rgb2gray(imread('fur_obs.jpg'));
pic = imresize(pic, [256, 256]);
pic = int32(double(pic) ./ 255 .* 7);

[F, filters, width, height] = myfilters;
width = int32(width);
height = int32(height);
weights = [8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7, 8];
num_filters = 17;

% Generate uniform image
I = int32(rand(256, 256) * 7);

% Filter selection
selected = [];
unselected = 1:num_filters;

for i = 1:10
	errors = zeros(1, length(unselected));
	for i = 1:length(unselected)
		idx = unselected(i);
		hist_P = getHistogram(pic, filters(idx, :)', width(idx), height(idx));
		hist_I = getHistogram(I, filters(idx, :)', width(idx), height(idx));
		errors(i) = abs(hist_P - hist_I) * weights';
	end
	[max_error, t] = max(errors);
	best_idx = unselected(t);
	selected = [selected, best_idx];
	unselected = unselected(unselected ~= best_idx);
	
	hist = getHistogram(pic, filters(selected, :)', width(selected), height(selected));
	[synthesized, hist] = Julesz(reshape(hist', 15, length(selected)), filters(selected, :)', width(selected), height(selected));

	imshow(synthesized, []);
	pause
end

% Generate random image as iniital image
%num_filters = 1;
%histo5 = getHistogram(pic, filters(1:num_filters, :)', width(1:num_filters), height(1:num_filters));
%[synthesized5, histo5a] = Julesz(reshape(histo5', 15, num_filters), filters(1:num_filters, :)', width(1:num_filters), height(1:num_filters));


%imshow(synthesized5, []);
%imwrite(uint8(synthesized5), 'syn5.bmp', 'bmp');
