% Read image and fft
m = rgb2gray(imread('natural_scene_3.jpg'));
% m = imresize(m, [120, 160]);
%A = abs(fft2(m));
A = abs(fft2(m)) .^ 2;

[h, w] = size(A);
[theta, r_max] = cart2pol(h, w);
[theta, r_min] = cart2pol(1, 1);

num_bins = 20;
bars = r_min:(r_max-r_min)/(num_bins):r_max;
power_sum = zeros(1, num_bins);
for i = 1:h
for j = 1:w
	[theta, r] = cart2pol(i, j);
	for k = 1:num_bins
		%if r >= bars(k) && r < 2 * bars(k)
        if abs(r - bars(k)) < 0.05
			power_sum(k) = power_sum(k) + (A(i, j));
		end 
	end
end
end
%x = bars(1:num_bins);
%y = power_sum;
x = log(bars(1:num_bins));
y = log(power_sum);

plot(x, y);
