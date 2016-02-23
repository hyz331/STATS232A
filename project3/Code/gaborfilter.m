function [Cosine, Sine] = gaborfilter(size, orientation)
% [Cosine, Sine] = gaborfilter(scale, orientation)
%
% Defintion of "scale": the sigma of short-gaussian-kernel used in gabor.
% Each pixel corresponds to one unit of length.
% The size of the filter is a square of size n by n.
% where n is an odd number that is larger than scale * 6 * 2 .
%
%

if mod(size, 2) == 0 || size < 1
    error('Size must be an positive odd number');
end

halfsize = ceil(size / 2);
theta = (pi * orientation) / 180;    % orientation in real number
Cosine = zeros(size);
Sine = zeros(size);
gauss = zeros(size);
scale = size / 6;


for i = 1:size
    for j = 1:size
        x = ((halfsize - i) * cos(theta) + (halfsize-j) * sin(theta)) / scale;
        y = ((i - halfsize) * sin(theta) + (halfsize-j) * cos(theta)) / scale;

        gauss(i, j) = exp(-(x^2 + y^2/4) / 2);
        Cosine(i, j) = gauss(i, j) * cos(2*x);
        Sine(i, j) = gauss(i, j) * sin(2*x);
    end
end

k = sum(sum(Cosine)) / sum(sum(gauss));
Cosine = Cosine - k * gauss;