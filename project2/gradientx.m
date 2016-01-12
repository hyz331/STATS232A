function res = gx(I)
	res = circshift(I, [0, 1]);
	res(:, 1) = 0;
	res = I - res;
end
