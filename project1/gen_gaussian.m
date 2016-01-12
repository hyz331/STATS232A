function [y] = gen_gaussian(x, a, b)
    y = b / (2*a*gamma(1/b)) * exp(-power(abs(x+0.02)/a, b));
end

