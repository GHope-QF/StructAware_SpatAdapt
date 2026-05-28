function [hx, hy] = solve_2nd_welsch_pure(vx, vy, lambda2_map, sigma, rho2,p2_map)
    mag = sqrt(max(sum(vx.^2, 3) + sum(vy.^2, 3), 1e-12));
    sigma_p_map =sigma .^ p2_map;
    eff_factor_map = (lambda2_map .* p2_map) ./ (sigma_p_map + 1e-12);
    d_mag = mag;
    epsilon_d = 1e-6;
    power_idx = p2_map - 2.0;

    for k = 1:3
        exp_term = exp(- (d_mag .^ p2_map) ./ (sigma_p_map + 1e-12));
        d_power_term =max(d_mag, epsilon_d) .^ power_idx;
        w_t = eff_factor_map .* exp_term .*d_power_term;
        d_mag = (rho2 .* mag) ./ (rho2 + w_t + 1e-12);
    end
    scale = d_mag./ (mag + 1e-12);
    hx = vx .* scale;
    hy = vy .* scale;
end