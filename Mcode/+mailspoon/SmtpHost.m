classdef SmtpHost < mailspoon.internal.MailSpoonBaseHandle
  % Configuration info for an SMTP server
  
  % TODO: Define a way of storing these settings in a config file or other
  % system setting.
  
  properties
    % Hostname of the SMTP server
    host (1,1) string
    % Username to log in to the SMTP server with
    username (1,1) string
    % Whether to use SSL when connecting
    useSsl (1,1) logical = false
    % Port for non-SSL connections
    port (1,1) double = NaN
    % Port for SSL connections
    sslPort (1,1) double = NaN
    % Password for the SMTP server account
    password (1,1) mailspoon.internal.Password = missing
  end
  properties (Hidden)
    DEBUG_force_from (1,1) string = missing
    DEBUG_force_to string = []
  end
  
  methods (Static)
    
    function out = discover()
      out = mailspoon.SmtpHost;
    end
    
  end
  
  methods
    
    function out = getHost(this)
      % Host name of smtp server
      
      % Defined host first
      out = string(missing);
      if ~ismissing(this.host)
        out = this.host;
        return
      end
      % Matlab pref next
      if isempty(out)
        try
          if ~isempty(getpref('Internet')) && ~isempty(getpref('Internet', 'SMTP_Server'))
            out = string(getpref('Internet', 'SMTP_Server'));
            return
          end
        catch
          % quash
        end
      end
      
    end
    
    function out = getUsername(this)
      % Effective SMTP username
      out = string(missing);
      if ~ismissing(this.username)
        out = this.username;
      end
    end
    
    function out = getPassword(this)
      % Effective SMTP password
      out = this.password;
    end
    
    function out = send(this, message)
      % Send an email message
      %
      % This is generally for MailSpoon's internal use. You should just call
      % send() on your email message object itself.
      arguments
        this (1,1)
        message (1,1) mailspoon.Email
      end
      % Debugging stuff
      if ~ismissing(this.DEBUG_force_from)
        message.from = this.DEBUG_force_from;
      end
      if ~isempty(this.DEBUG_force_to)
        message.to = this.DEBUG_force_to;
      end
      % Main stuff
      jmail = message.j;
      server = this.getHost;
      if ~ismissing(server)
        jmail.setHostName(server);
      end
      myuser = this.getUsername;
      mypass = this.getPassword.getActualPassword;
      if ~ismissing(myuser) || ~ismissing(mypass)
        jmail.setAuthentication(myuser, mypass);
      end
      jmail.setSSLOnConnect(this.useSsl);
      if ~isnan(this.port)
        jmail.setSmtpPort(this.port);
      end
      if ~isnan(this.sslPort)
        jmail.setSslSmtpPort(""+this.sslPort);
      end
        
      out = string(jmail.send);
    end
    
    function inspect(this, indent)
      % Print a debugging representation of this object
      arguments
        this (1,1)
        indent (1,1) string = ""
      end
      function p(fmt, varargin)
        fprintf(indent + fmt + '\n', varargin{:});
      end
      disp(this);
    end
    
  end
  
end

