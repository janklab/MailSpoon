function out = sendhtmlmail(to, subject, content, attachments, from)
% Send HTML-formatted mail
%
% out = mailspoon.sendhtmlmail(to, subject, content, attachments, from)
arguments
  to string
  subject (1,1) string
  content
  attachments string = []
  from (1,1) string = missing
end

builder = mailspoon.HtmlBodyBuilder;
builder.add(content);
builder.finish;

email = builder.email;
email.to = to;
email.from = from;
email.subject = subject;
email.attach(attachments);

out = email.send;

if nargout < 1
  clear out
end

end

