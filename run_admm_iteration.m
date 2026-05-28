function S_out = run_admm_iteration(img_in, h, w, c, max_itr, anneal_base, tol, mu, rho, rho_max, ...
    sigma_start, sigma_end, Denom_DCT_1st, Denom_DCT_2nd, W_map, p_map, lambda2_map, p2_map)

    d_x = zeros(h, w, c, 'single'); d_y = zeros(h, w, c, 'single');
    z_x = zeros(h, w, c, 'single'); z_y = zeros(h, w, c, 'single');
    h_x = zeros(h, w, c, 'single'); h_y = zeros(h, w, c, 'single');
    z2_x = zeros(h, w, c, 'single'); z2_y = zeros(h, w, c, 'single');

    S = img_in;
    prev_S = S;
    rho2 = rho;
    k = 1;
    lambda = 3000;

    for iter = 1:max_itr
        t = min((iter-1) / (anneal_base-1), 1.0);
        curr_sigma = sigma_end + 0.5 * (sigma_start - sigma_end) * (1 + cos(pi * t));

        RHS = img_in + rho * (divergence_fast(d_x - z_x, k, 'x') + divergence_fast(d_y - z_y, k, 'y')) ...
            + rho2 * (diff2_fast(h_x - z2_x, k, 'x') + diff2_fast(h_y - z2_y, k, 'y'));

        inv_Denom = 1.0 ./ (1.0 + rho * Denom_DCT_1st + rho2 * Denom_DCT_2nd);
        for ch = 1:c
            dct_rhs = dct2(RHS(:,:,ch));
            S(:,:,ch) = idct2(dct_rhs .* inv_Denom);
        end

        if iter > anneal_base
            rel_diff = norm(S(:) - prev_S(:)) / norm(prev_S(:) + 1e-8);
            if rel_diff < tol
                break;
            end
        end
        prev_S = S;

        grad_x = forward_diff_fast(S, k, 'x');
        grad_y = forward_diff_fast(S, k, 'y');
        v_x = grad_x + z_x;
        v_y = grad_y + z_y;
        [d_x, d_y] = solve_joint_welsch_pure(v_x, v_y, lambda, W_map, curr_sigma, rho, p_map);

        grad2_x = diff2_fast(S, k, 'x');
        grad2_y = diff2_fast(S, k, 'y');
        v2_x = grad2_x + z2_x;
        v2_y = grad2_y + z2_y;
        [h_x, h_y] = solve_2nd_welsch_pure(v2_x, v2_y, lambda2_map, curr_sigma, rho2, p2_map);

        z_x = z_x + grad_x - d_x;
        z_y = z_y + grad_y - d_y;
        z2_x = z2_x + grad2_x - h_x;
        z2_y = z2_y + grad2_y - h_y;

        if rho < rho_max
            rho = rho * mu;
            rho2 = rho2 * mu;
        end
    end
    S_out = S;
end