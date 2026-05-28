function S_out = postprocess_output(S_in, is_norm_01)
    S_out = max(0, min(255, S_in));
    if is_norm_01
        S_out = S_out / 255.0;
    else
        S_out = uint8(S_out);
    end
end