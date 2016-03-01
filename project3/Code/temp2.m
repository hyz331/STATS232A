mex getHistogram.c
mex Julesz.c

% Initialization
pic = imread('grass_obs.bmp');
pic = imresize(pic, [256, 256]);
pic = int32(double(pic) ./ 9 .* 7);
[F, filters, width, height] = myfilters;
width = int32(width);
height = int32(height);
weights = [8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7, 8];
[num_filters, t] = size(filters);

% Generate uniform image
I = int32(rand(256, 256) * 7);

% Filter selection
selected = [];
unselected = 1:num_filters;
syn_error = zeros(1, num_filters);

num_plot = 1;
for iter = 1:20
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
	[I, hist] = Julesz(reshape(hist', 15, length(selected)), filters(selected, :)', width(selected), height(selected));
	syn_error(iter) = norm(double(I-pic));

	if (iter == 3 || iter == 8 || iter == 15 || iter == 20)
		subplot(2, 2, num_plot)
		title(strcat('iteration=', iter));
		imshow(I, []);
		num_plot = num_plot + 1;
	end	

end

selected
figure;
plot(1:iter, syn_error(1:iter));
