function html = htmlview(x, style)
% View some data in the way that MailSpoon will HTML-ify it
%
% Examples:
%
% htmlview(sampledata.cereal)
% htmlview(sampledata.carbig, missing)
% htmlview(magic(4))
% htmlview(sampledata.flu, 'table-blur')

arguments
  x
  style (1,1) string = 'teal'
end

htmlFrag = mailspoon.htmlify(x);
tempDir = string(tempname) + "-MailSpoon-htmlview.d";
mkdir(tempDir);
filename = "MailSpoon HTML View.html";
filepath = fullfile(tempDir, filename);

maybeStyle = '';
if ~ismissing(style)
  css = mailspoon.internal.Common.CssStyles.getStyle(style);
  maybeStyle = sprintf('  <style>%s</style>', css);
end

html = sprintf(strjoin({
  '<!DOCTYPE html>'
  '<html>'
  '<head>'
  '  <title>MailSpoon view of a %s</title>'
  '%s'
  '<head>'
  '<body>'
  '%s'
  '</body>'
  '</html>'
  }, '\n'), class(x), maybeStyle, htmlFrag);
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