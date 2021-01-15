function out = isstringy(x)
%ISSTRINGY True if input is string, char, or cellstr
out = ischar(x) || isstring(x) || iscellstr(x);
end