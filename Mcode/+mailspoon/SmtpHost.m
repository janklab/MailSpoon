classdef SmtpHost < mailspoon.internal.MailSpoonBaseHandle
  % Knows how to actually send messages via SMTP
  
  % TODO: Define a way of storing these settings in a config file or other
  % system setting.
  
  properties
    host (1,1) string
    username (1,1) string
    useSsl (1,1) logical = false
    port (1,1) double = NaN
    sslPort (1,1) double = NaN
  end
  properties (GetAccess=private)
    password (1,1) string
  end
  properties (Hidden)
    DEBUG_force_from (1,1) string = missing
    DEBUG_force_to string = []
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
      out = string(missing);
      if ~ismissing(this.password)
        out = this.password;
      end
    end
    
    function out = send(this, message)
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
      mypass = this.getPassword;
      if ~ismissing(myuser) || ~ismissing(mypass)
        jmail.setAuthentication(this.username, this.password);
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
    
  end
  
end

