function [ out ] = line2vec(r0, a)

syms t;

out = struct('type','line','value', r0 + t*a);

end
