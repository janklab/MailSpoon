function html = htmlview(x)
% View some data in the way that MailSpoon will HTML-ify it

htmlFrag = mailspoon.htmlify(x);
tempDir = string(tempname) + "-MailSpoon-htmlview.d";
mkdir(tempDir);
filename = "MailSpoon HTML View.html";
filepath = fullfile(tempDir, filename);

html = sprintf(strjoin({
  '<!DOCTYPE html>'
  '<html>'
  '<head>'
  '  <title>MailSpoon view of a %s</title>'
  '<head>'
  '<body>'
  '%s'
  '</body>'
  '</html>'
  }, '\n'), class(x), htmlFrag);
mailspoon.internal.writetext(filepath, html);

% Open in a browser

% open() uses Matlab's browser instead of an external browser. I don't like that
%TODO: Detect when running in Matlab Online and fall back to using open()
%open(filepath);

if ismac
  cmd = sprintf('open "%s"', filepath);
elseif ispc
  cmd = sprintf('cmd /c start "%s"', filepath);
else
  error('Linux is unimplemented here')
end
system(cmd);

if nargout < 1; clear html; end