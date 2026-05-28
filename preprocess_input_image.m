function [img_out, is_norm_01, h, w, c] = preprocess_input_image(img_in)
    img_out = single(img_in);
    is_norm_01 = max(img_out(:)) <= 1.05;

    if is_norm_01
        img_out = img_out * 255.0;
    end

    [h, w, c] = size(img_out);
end