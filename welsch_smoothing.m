function [S] = welsch_smoothing(image, param)
    if nargin < 2
        param = struct();
    end

    % 1. 解析参数
    [lambda, sigma_start, sigma_end, max_itr, tol, mu, rho, p_min_param, ...
     anneal_base, lambda2_base, p2_min, scales, rho_max] = parse_all_params(param);

    % 2. 图像预处理
    [img_in, is_norm_01, h, w, c] = preprocess_input_image(image);

    % 3. 预计算 DCT 分母
    [Denom_DCT_1st, Denom_DCT_2nd] = compute_dct_denominator(h, w, scales(1));

    % 4. 计算基础结构张量
    [Ixx, Iyy, Ixy] = compute_base_structure_tensor(img_in, h, w, c);

    % 5. 多尺度置信度 & 基础幅度
    [Confidence_fused, Base_Magnitude] = compute_multi_scale_confidence(Ixx, Iyy, Ixy, h, w, tol);

    % 6. 生成自适应权重与参数图
    [W_map, p_map, lambda2_map, p2_map] = generate_weight_param_maps(...
        Base_Magnitude, Confidence_fused, h, w, lambda2_base, p2_min, tol);

    % 7. 执行 ADMM 迭代
    S = run_admm_iteration(img_in, h, w, c, max_itr, anneal_base, tol, mu, rho, rho_max, ...
        sigma_start, sigma_end, Denom_DCT_1st, Denom_DCT_2nd, W_map, p_map, lambda2_map, p2_map);

    % 8. 结果后处理
    S = postprocess_output(S, is_norm_01);
end