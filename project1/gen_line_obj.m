function [p] = gen_line_obj(o, theta, length)
	x_diff = cos(theta) * length;
	y_diff = sin(theta) * length;
	p = o + [x_diff, y_diff];	
	line([o(1), p(1)], [o(2), p(2)]);
end
