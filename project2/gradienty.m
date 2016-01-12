function res = gx(I)
	res = circshift(I, [1, 0]);
	res(1, :) = 0;
	res = I - res;
end
