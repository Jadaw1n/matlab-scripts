function [out] = param2coord(r0, s, t)

if ~isvector(r0)
    error('r0 must be a vector')
end

if ~isvector(s)
    error('s must be a vector')
end

if ~isvector(t)
    error('t must be a vector')
end

n = cross(s,t);

out = norm2coord(r0, n);

end

