function [dx, dy] = solve_joint_welsch_pure(vx, vy, base_lambda, weight_map, sigma, rho, p_map)
    mag = sqrt(max(sum(vx.^2, 3) + sum(vy.^2, 3), 1e-12));
    sigma_p_map = sigma .^ p_map;
    eff_factor_map = (weight_map .* base_lambda .* p_map) ./ (sigma_p_map + 1e-12);
    d_mag = mag;
    epsilon_d = 1e-6;
    power_idx = p_map - 2.0;

    for k = 1:5
        exp_term = exp(- (d_mag.^ p_map) ./ (sigma_p_map + 1e-12));
        d_power_term = max(d_mag, epsilon_d) .^power_idx;
        w_t = eff_factor_map .* exp_term .* d_power_term;
        d_mag = (rho .*mag) ./ (rho + w_t + 1e-12);
    end
    scale = d_mag ./ (mag + 1e-12);
    dx = vx .*scale;
    dy = vy .* scale;
end