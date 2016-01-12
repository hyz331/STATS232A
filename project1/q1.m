% Read and normalzie image
m = double(double(rgb2gray((imread('natural_scene_1.jpg')))) ./ 256 .* 32);

% Apply gradient filter
[h, w] = size(m);
g = zeros(h, w);
for i = 2:h
    for j = 2:w
        g(i, j) = m(i-1, j) - m(i, j-1);
    end
end
g = reshape(g, [h * w, 1]);

% Compute and normalize the histogram
num_bins = 100;
counts = hist(g, num_bins);
bins = -31:62/(num_bins-1):31;
hist_normalized = counts ./ sum(counts);

% plot
bar(bins, hist_normalized, 'white');
%plot(bins, log(hist_normalized)); % log plot
% Superimpose fitted curve
hold on;
plot(x, gen_gaussian(x, sqrt(0.0029), 0.3240));

% Compute values
disp('Mean');
disp(mean(hist_normalized));
disp('Variance');
disp(var(hist_normalized));
disp('Kurtosis');
disp(kurtosis(hist_normalized));

% Plot and superimpose Gaussian
figure
bar(bins, counts, 'white');
hold on;
plot(bins, normpdf(bins, mean(hist_normalized), std(hist_normalized)));

% log plots
figure
plot(bins, log(hist_normalized));
hold on;
bins = -31:0.0001:31;
plot(bins, log(normpdf(bins, mean(hist_normalized), std(hist_normalized))), ':');
legend('log histogram', 'log Gaussian');