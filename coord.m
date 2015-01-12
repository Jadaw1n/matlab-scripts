function [ out ] = coord(v)

if ~ismatrix(v) || numel(v) ~= 4 || ~isnumeric(v)
    error('Input must be a matrix with 4 numbers.')
end

syms x y z
out = struct('type','plane','value', v);


end

