% Read and normalzie image
m = mod(rand(600, 600) * 100, 32);

% downsample
%m = imresize(m, [1200/4, 1200/4]);

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

% Fit normal
hf = histfit(g, 100);
h = get(gca,'Children');
set(h(2),'FaceColor',[.8 .8 1])
get(hf(1)) %properties of the histogram
get(hf(2)) %properties of the normal curve

x=get(hf(2),'XData'); 
y=get(hf(2),'YData');

% Compute values
disp('Mean');
disp(mean(y));
disp('Variance');
disp(var(y));
disp('Kurtosis');
disp(kurtosis(hist_normalized));

figure;
bar(bins, hist_normalized, 'w');
hold on;
plot(x, y ./ sum(counts));

% log plots
figure
plot(bins, log(hist_normalized));
hold on;
plot(x, log(y ./ sum(counts)), ':');
legend('log histogram', 'log Gaussian');