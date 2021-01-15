function exampleForReadme2

e = mailspoon.HtmlEmail('to@example.com', 'Me <from@example.com>');
e.subject = 'Look at these inline images from MailSpoon!';

% Embed images first, to get their cids

fig = figure('Visible','off');
surf(peaks);
fig_cid = e.embed(fig);
close(fig);

file = fullfile(mailspoon.libinfo.distroot, 'examples', 'Brooklyn.jpg');
file_cid = e.embed(file);

% Then create your HTML using those cids

e.html = sprintf(strjoin({
  '<html>'
  '<body>'
  '<h1>Hello, World!</h1>'
  ''
  '<h2>A Matlab Figure</h2>'
  '<img src=cid:%s>'  % Do not put a "/" in the img tag!
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
  }, '\n'), fig_cid, file_cid);

e.send