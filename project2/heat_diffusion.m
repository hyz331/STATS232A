function res = heat_diffusion(O, I, mask, num_iter)
    [h, w] = size(I);
    mask = uint8(mask > 0);
    err = zeros(1, num_iter);
	for iter = 1:num_iter
        % Compute gradient images
		gx = circshift(I, [0, 1]);
        gx(:, 1) = 0;
        gx = I - gx;
        gy = circshift(I, [1, 0]);
        gy(1, :) = 0;
        gy = I - gy;
        
        % Compute laplacian images
        gxx = circshift(gx, [0, 1]);
        gxx(:, 1) = 0;
        gxx = gx - gxx;
        gyy = circshift(gy, [1, 0]);
        gyy(1, :) = 0;
        gyy = gy - gyy;
        
        I = I - 0.1*(gxx .* mask + gyy .* mask);
        
        % Compute error
        err(iter) = norm((double(O)-double(I)) .* double(mask))^2 / (h*w);
	end
	res = I;
    plot(1:num_iter, err);
    xlabel('iteration');
    ylabel('error');
end