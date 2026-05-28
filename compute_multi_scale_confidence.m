function [Confidence_fused, Base_Magnitude] = compute_multi_scale_confidence(Ixx, Iyy, Ixy, h, w, tol)
    universal_scales = [1.0, 2.0, 3.0];
    Confidence_fused = ones(h, w, 'single');
    Base_Magnitude   = zeros(h, w, 'single');

    for s_idx = 1:length(universal_scales)
        current_rho = universal_scales(s_idx);
        k_size = round(2 * 3 * current_rho) + 1;
        h_gauss = double(fspecial('gaussian', [k_size, 1], current_rho));

        Sxx = imfilter(imfilter(Ixx, h_gauss, 'replicate'), h_gauss', 'replicate');
        Syy = imfilter(imfilter(Iyy, h_gauss, 'replicate'), h_gauss', 'replicate');
        Sxy = imfilter(imfilter(Ixy, h_gauss, 'replicate'), h_gauss', 'replicate');

        Trace = Sxx + Syy;
        Det   = max(Sxx .* Syy - Sxy.^2, 0);
        sqrt_delta = sqrt(max((Trace.^2) - 4 * Det, 1e-12));

        lambda1 = (Trace + sqrt_delta) / 2.0;
        lambda2 = (Trace - sqrt_delta) / 2.0;

        if s_idx == 1
            Base_Magnitude = lambda1;
        end

        L1_max = prctile(lambda1(:), 99) + 1e-5;
        l1_norm = lambda1 / L1_max;
        l2_norm = lambda2 / L1_max;

        E_s = l1_norm + l2_norm;
        W_mag = E_s ./ (E_s + tol);
        I_s = (4 .* l1_norm .* l2_norm) ./ (E_s.^2 + tol);

        Edge_Conf = W_mag .* sqrt(max(0, 1 - I_s));
        Corner_Conf = l2_norm;
        Scale_Conf = Edge_Conf + Corner_Conf;

        Confidence_fused = Confidence_fused .* (Scale_Conf + 1e-3);
    end

    Confidence_fused = Confidence_fused .^ (1.0 / length(universal_scales));

    k_size_1 = round(2 * 3 * 1.0) + 1;
    h_gauss_1 = double(fspecial('gaussian', [k_size_1, 1], 1.0));
    Base_Magnitude = imfilter(imfilter(Base_Magnitude, h_gauss_1, 'replicate'), h_gauss_1', 'replicate');
end