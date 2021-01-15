function writetext(file, text, encoding)
% Write text to a UTF-8 file
arguments
  file (1,1) string
  text string
  encoding (1,1) string = 'UTF-8'
end
text = strjoin(text, "");
[fid,msg] = fopen(file, 'w', 'n', encoding);
if fid < 1
  error('Failed opening file for writing: %s: %s', file, msg);
end
RAII.fh = onCleanup(@() fclose(fid));
fprintf(fid, '%s', text);
end
