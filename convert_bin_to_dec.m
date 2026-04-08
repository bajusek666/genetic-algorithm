function x_dec = convert_binary_to_decimal(x_bin)
    n = length(x_bin)
    powers = (n-1):-1:0;
    weights = 2 .^ powers;
    x_dec = sum(x_bin .* weights);
end