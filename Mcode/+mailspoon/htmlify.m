function out = htmlify(x)
% Convert data (tables, arrays, etc) to HTML
%
% out = mailspoon.htmlify(x)
%
% This is mostly used for tabular data, and focuses on supporting Matlab table
% arrays.
%
% x is the table or other data to render. It may be a Matlab table array, cell
% array, numeric array, or anything that can convert to a table by calling 
% table(x).
%
% Examples:
%
% tbl = array2table(magic(5));
% htmlFragment = mailspoon.htmlify(tbl);
% html = sprintf(strjoin({
%   '<html><body>'
%   '<h1>Here is a table</h1>'
%   '  %s'
%   '</body></html>'
%   }, '\n'), htmlFragment);
%
% Returns an HTML fragment as a scalar string.

renderer = mailspoon.internal.HtmlTableWriter;
out = renderer.htmlify(x);

end