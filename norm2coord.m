function [out] = norm2coord(r0, n)

if ~isvector(r0)
    error('r0 must be a vector')
end
if ~isvector(n)
    error('n must be a vector')
end

d = -(n(1)*r0(1)+n(2)*r0(2)+n(3)*r0(3));

out = coord([n(1) n(2) n(3) d]);

end
