classdef MailHost
  % Configuration for the mail host through which emails will be sent

  properties (Constant)
    % The main configuration that MailSpoon will use in this session
    default = mailspoon.SmtpHost
  end
  
end

