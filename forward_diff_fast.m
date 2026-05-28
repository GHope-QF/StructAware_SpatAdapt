function grad = forward_diff_fast(img, k, axis)
    [h, w, c] = size(img);
    grad = zeros(h, w, c, 'single');
    k = round(k);
    if axis == 'x'
        grad(:, 1:w-k, :) = img(:, 1+k:w, :) - img(:, 1:w-k, :);
    else
        grad(1:h-k, :, :) = img(1+k:h, :, :) - img(1:h-k, :, :);
    end
end