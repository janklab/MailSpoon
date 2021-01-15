function out = flattext(str)
map = {
  '\r'  char(8592) % '?'
  '\n'  char(8629) % '?'
  '\t'  char(8594) % '?'
  };
out = str;
for i = 1:size(map, 1)
  out = regexprep(out, map{i,1}, map{i,2});
end
end
