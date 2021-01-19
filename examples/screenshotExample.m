function screenshotExample
% Generate the email I use specifically for the screenshot in the README

e = mailspoon.HtmlEmail('to@example.com', 'MailSpoon <mailspoon@janklab.net>');
e.subject = 'Look at these inline images from MailSpoon!';

% Embed images first, to get their cids

function out = newfig
  out = figure('Visible','off', 'Position',[100 100 500 500]);
end

fig = newfig;
surf(peaks);
fig_cid = e.embedFigurePrint(fig, 'Surf Peaks.png', missing, {'-r300'});
close(fig);

fig = newfig;
x = 1:100; y = rand([1 100]);
plot(x, y);
fig2_cid = e.embedFigurePrint(fig, 'Some Lines.png');
close(fig);

fig = quiver3d;
fig3_cid = e.embedFigurePrint(fig, 'Quiver Plot.png');
close(fig);

file = fullfile(mailspoon.libinfo.distroot, 'examples', 'Brooklyn.jpg');
file_cid = e.embed(file);

tbl = sampledata.cereal;
tableHtml = mailspoon.htmlify(tbl(1:5,:));

css = mailspoon.internal.Common.cssStyles.teal;
% Flexbox
css = css + sprintf(strjoin({
  ''
  '.grid_row { display: flex }  .grid_col_3 { flex: 33%%; padding: 5px; }'
  }));

% Then create your HTML using those cids

e.html = sprintf(strjoin({
  '<html>'
  '<head>'
  '  <style>%s</style>'
  '</head>'
  '<body>'
  '<h1>Hello, World!</h1>'
  ''
  '<h2>Matlab Figures</h2>'  
  '<div class="grid_row">'
  '  <div class="grid_col_3"><img src=cid:%s style="width:100%%"></div>'
  '  <div class="grid_col_3"><img src=cid:%s style="width:100%%"></div>'
  '  <div class="grid_col_3"><img src=cid:%s style="width:100%%"></div>'
  '</div>'
  ''
  '<h2>A Table</h2>'
  '%s'
  ''
  '<h2>An Image File</h2>'
  '<img src=cid:%s>'
  ''
  '<p>This is a message sent from '
  '<a href="http://github.com/janklab/MailSpoon"><b>MailSpoon</b></a> '
  'for MATLAB®.</p>'
  ''
  '</html>'
  '</body>'
  }, '\n'), css, fig_cid, fig2_cid, fig3_cid, tableHtml, file_cid);

e.send

end

function out = quiver3d
% Create a grid of x,y, and z values
[x, y, z] = meshgrid(-0.8:0.2:0.8, -0.8:0.2:0.8, -0.8:0.8:0.8);
% Calculate homogenous turbulence values at each (x,y,z)
u = sin(pi*x).*cos(pi*y).*cos(pi*z);
v = -cos(pi*x).*sin(pi*y).*cos(pi*z);
w = sqrt(2/3)*cos(pi*x).*cos(pi*y).*sin(pi*z);
% Draw a 3 dimensional quiver plot using the quiver3 function
out = figure('Visible','off');
quiver3(x, y, z, u, v, z)
% Set the axis limits
axis([-1 1 -1 1 -1 1])
% Add title and axis labels
title('Turbulence Values')
xlabel('x')
ylabel('x')
zlabel('z')
end

