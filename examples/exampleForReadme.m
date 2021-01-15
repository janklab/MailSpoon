function exampleForReadme

e = mailspoon.HtmlEmail;
e.setDebug(true);
e.from = 'Alice Foo <alice@example.com>';
e.to = ["bob@example.com", "Carol Bar <carol@example.com>"];
e.subject = 'Hello, World!';

% Set HTML using setHtmlMsg()
e.html = strjoin({
  '<html><body>'
  '<h1>Hello, World!</h1>'
  ''
  '<p>This is a message sent from '
  '  <a href="http://github.com/janklab/MailSpoon"><b>MailSpoon</b></a> '
  'for MATLAB®.</p>'
  ''
  '</html></body>'
  }, '\n');

% Attach files using attach()
e.attach([mfilename('fullpath') '.m'])

% Now send it!
e.send