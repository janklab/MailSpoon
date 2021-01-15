classdef MimeMultipart < mailspoon.internal.MailSpoonBaseHandle
  % Wraps a javax.mail.internet.MimeMultipart
  
  properties
    j
  end
  
  properties (Dependent)
    numParts
    preamble
    contentType
  end
  
  methods
    
    function this = MimeMultipart(jobj)
      if nargin == 0
        this.j = javax.mail.internet.MimeMultipart;
      else
        this.j = jobj;
      end
    end
    
    function out = get.numParts(this)
      out = this.j.getCount;
    end
    
    function out = get.preamble(this)
      jp = this.j.getPreamble;
      if isempty(jp)
        out = string(missing);
      else
        out = string(jp);
      end
    end
    
    function out = get.contentType(this)
      out = string(this.j.getContentType);
    end
    
    function out = getBodyPart(this, indexOrId)
      if isnumeric(indexOrId)
        jobj = this.j.getBodyPart(indexOrId - 1);
      else
        jobj = this.j.getBodyPart(indexOrId);
      end
      out = mailspoon.internal.MimeBodyPart(jobj);
    end
    
    function inspect(this, indent)
      arguments
        this (1,1)
        indent (1,1) string = ""
      end
      function p(fmt, varargin)
        fprintf(indent + fmt + "\n", varargin{:});
      end
      p('MimeMultipart: %s, %d parts', mailspoon.internal.flattext(this.contentType), this.numParts)
      if ~ismissing(this.preamble)
        p('  Preamble: %s', this.preamble);
      end
      for i = 1:this.numParts
        part = this.getBodyPart(i);
        p('  Part %d: ', i)
        part.inspect(indent + "    ")
        p(' ')
      end
    end
    
  end
  
end
