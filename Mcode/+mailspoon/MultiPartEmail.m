classdef MultiPartEmail < mailspoon.Email
  
  properties (Dependent)
  end
  
  methods
    
    function this = MultiPartEmail()
      this.j = org.apache.commons.mail.MultiPartEmail;
    end
    
    function attach(this, file)
      arguments
        this (1,1)
        file (1,1) string
      end
      this.j.attach(java.io.File(file));
    end
    
    function attachUrl(this, url, name, description, disposition)
      arguments
        this (1,1)
        url (1,1) 
        name (1,1) string
        description (1,1) string
        disposition (1,1) string = missing
      end
      if isstring(url) || ischar(url)
        jUrl = java.net.URL(url);
      elseif isa(url, 'java.net.URL')
        jUrl = url;
      else
        error('mailspoon:InvalidInput', 'url must be a string or java.net.URL; got a %s', class(url))
      end
      if ismissing(disposition)
        this.j.attach(jUrl, name, description);
      else
        this.j.attach(jUrl, name, description, disposition);
      end
    end
    
    function inspect(this, indent)
      arguments
        this (1,1)
        indent (1,1) string = ""
      end
      function p(fmt, varargin)
        fprintf(indent + fmt + '\n', varargin{:});
      end
      inspect@mailspoon.Email(this, indent);
      if ~isempty(this.j.getSubType)
        p('MIME subtype: %s', this.j.getSubType)
      end
      p('Multipart Container:');
      mp = mailspoon.internal.MimeMultipart(this.j.reallyGetContainer);
      mp.inspect(indent);
    end
    
  end
  
end