function [W_map, p_map, lambda2_map, p2_map] = generate_weight_param_maps(...
    S_curr, Confidence_fused, h, w, lambda2_base, p2_min, tol)

    S_98 = prctile(S_curr(:), 99);
    norm_struct = min(S_curr / (S_98 + 1e-5), 1.0) .^ 3.0;

    w_min = 0.01;
    W_map = 1.0 - (1.0 - w_min) * norm_struct;
    W_map = W_map / mean(W_map(:));

    p_min_param = 0.8;
    p_map = p_min_param + (2.0 - p_min_param) * exp(-5.0 * norm_struct);
    lambda2_map = lambda2_base .* exp(-5.0 * norm_struct);
    p2_map = p2_min + (2.0 - p2_min) * exp(-5.0 * norm_struct);
end