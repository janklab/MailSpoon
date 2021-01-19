function out = sprintf(fmt, varargin)
% A version of sprintf that handles missing strings
args = varargin;
for i = 1:numel(args)
  if isstring(args{i})
    args{i} = renderMissing(args{i});
  end
end
out = sprintf(fmt, args{:});
end

function out = renderMissing(strs)
  out = strs;
  out(ismissing(strs)) = '<missing>';
end