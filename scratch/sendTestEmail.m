% function sendTestEmail

e = mailspoon.HtmlEmail;
e.addTo('Andrew Janke <janke@pobox.com>');
e.from = 'Andrew Janke <andrew@apjanke.net>';
e.addCc('andrew.janke@gmail.com')
e.addBcc('andrew.janke@demextech.com')
e.addBcc('nobody@example.com')
e.subject = sprintf('mailspoon test (%s)', datestr(now, 'HH:MM:SS'));

fig1 = figure;
surf(peaks);

fig2 = figure;
plot(1:100, rand(1, 100));

cid1 = e.embed(fig1);
cid2 = e.embedFigure(fig2, 'My Plot.svg');

e.attach([mfilename('fullpath') '.m'])

close(fig1)
close(fig2)

html = sprintf(strjoin({
  '<html><body>'
  '<h1>Mail</h1>'
  '<img src=cid:%s>'
  '<p>Hello world</p>'
  '<h2>Stocks</h2>'
  '<img src=cid:%s>'
  '</body></html>'
  }, '\n'), cid1, cid2);

e.setHtmlMsg(html);

fprintf('\nSent. msgid = %s\n', e.send)

e.inspect
