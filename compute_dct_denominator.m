function [Denom_DCT_1st, Denom_DCT_2nd] = compute_dct_denominator(h, w, k)
    x_idx = single(0:w-1);
    y_idx = single(0:h-1)';

    eig_x = 2 - 2 * cos((k * pi * x_idx) / w);
    eig_y = 2 - 2 * cos((k * pi * y_idx) / h);

    Denom_DCT_1st = eig_x + eig_y;
    Denom_DCT_2nd = eig_x.^2 + eig_y.^2;
end