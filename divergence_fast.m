function div = divergence_fast(v, k, axis)
    [h, w, c] = size(v);
    div = zeros(h, w, c, 'single');
    k = round(k);
    if axis == 'x'
        div(:, 1:w-k, :) = -v(:, 1:w-k, :);
        div(:, 1+k:w, :) = div(:, 1+k:w, :) + v(:, 1:w-k, :);
    else
        div(1:h-k, :, :) = -v(1:h-k, :, :);
        div(1+k:h, :, :) = div(1+k:h, :, :) + v(1:h-k, :, :);
    end
end