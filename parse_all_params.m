function [lambda, sigma_start, sigma_end, max_itr, tol, mu, rho, p_min_param, anneal_base, lambda2_base, p2_min, scales, rho_max] = parse_all_params(param)
    lambda      = get_param(param, 'lambda', 3000);
    sigma_start = get_param(param, 'sigma', 20.0);
    sigma_end   = get_param(param, 'sigma_end', 0.25);
    max_itr     = get_param(param, 'itr_num', 50);
    tol         = get_param(param, 'tol', 1e-4);
    mu          = get_param(param, 'mu', 1.15);
    rho         = get_param(param, 'rho', 1.15);
    p_min_param = get_param(param, 'p_min', 0.8);

    default_anneal = max(2, round(max_itr * 0.8));
    anneal_base    = get_param(param, 'anneal_base', default_anneal);

    lambda2_base = get_param(param, 'lambda2', 0);
    p2_min       = get_param(param, 'p2_min', 1.0);

    scales  = [1];
    rho_max = 500;
end