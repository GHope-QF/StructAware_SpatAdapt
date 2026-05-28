function [Ixx, Iyy, Ixy] = compute_base_structure_tensor(img, h, w, c)
    Ixx = zeros(h, w, 'single');
    Iyy = zeros(h, w, 'single');
    Ixy = zeros(h, w, 'single');

    for ch = 1:c
        img_ch = img(:,:,ch);
        gx = zeros(h, w, 'single');
        gy = zeros(h, w, 'single');

        gx(:, 2:w-1) = (img_ch(:, 3:w) - img_ch(:, 1:w-2)) / 2.0;
        gx(:, 1)     = img_ch(:, 2) - img_ch(:, 1);
        gx(:, w)     = img_ch(:, w) - img_ch(:, w-1);

        gy(2:h-1, :) = (img_ch(3:h, :) - img_ch(1:h-2, :)) / 2.0;
        gy(1, :)     = img_ch(2, :) - img_ch(1, :);
        gy(h, :)     = img_ch(h, :) - img_ch(h-1, :);

        Ixx = Ixx + gx.^2;
        Iyy = Iyy + gy.^2;
        Ixy = Ixy + gx .* gy;
    end
end