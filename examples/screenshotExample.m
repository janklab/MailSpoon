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

file = fullfile(mailspoon.libinfo.distroot, 'examples', 'Brooklyn.jpg');
file_cid = e.embed(file);

% Then create your HTML using those cids

e.html = sprintf(strjoin({
  '<html>'
  '<body>'
  '<h1>Hello, World!</h1>'
  ''
  '<h2>Matlab Figures</h2>'
  '<table border=0><tr>'
  '<td><img src=cid:%s></td>'
  '<td><img src=cid:%s></td>'
  '</tr></table>'
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
  }, '\n'), fig_cid, fig2_cid, file_cid);

e.send

end
