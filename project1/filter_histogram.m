function [g] = filter_histogram(m, c)
    % Apply filter
    [h, w] = size(m);
    g = zeros(h, w);
    for i = 2:h
        for j = 2:w
          g(i, j) = m(i-1, j) - m(i, j-1);
        end
    end
    g = reshape(g, [h * w, 1]);
    
    % Compute and normalize the histogram
    num_bins = 50;
    counts = hist(g, num_bins);
    bins = -31:62/(num_bins-1):31;
    hist_normalized = counts ./ sum(counts);

    % plot
    % bar(bins, hist_normalized, c);
    plot(bins, log(hist_normalized), c);%log plot
end