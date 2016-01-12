function [r] = sample_len()
	x = rand();
	r = -0.5 - sqrt(1-x)/(2*(x-1));
end
