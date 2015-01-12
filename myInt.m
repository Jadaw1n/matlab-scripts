function [out] = myInt(f, x, lower, upper, n)

dx = (upper-lower)/n;
xi = lower + (0:n-1)*dx;

out = sum(subs(f,x,xi)*dx);

end