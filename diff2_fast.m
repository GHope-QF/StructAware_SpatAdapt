function d2 = diff2_fast(img, k, axis)
    d2 = -divergence_fast(forward_diff_fast(img, k, axis), k, axis);
end