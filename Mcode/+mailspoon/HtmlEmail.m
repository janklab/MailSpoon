classdef HtmlEmail < mailspoon.MultiPartEmail
  
  properties (Dependent)
  end
  
  methods
    
    function this = HtmlEmail()
      %this.j = org.apache.commons.mail.HtmlEmail;
      this.j = net.janklab.mailspoon.internal.DebuggableHtmlEmail;
    end
    
    function cid = embed(this, thing)
      % Embed a thing so it can be used as an inline image or other content
      %
      % The thing may be:
      %   - a string containing a file name
      %   - a figure handle
      %   -
      %
      % Returns the generated CID as a string.
      arguments
        this (1,1)
        thing (1,1)
      end
      
      if ishandle(thing)
        cid = this.embedFigure(thing);
      elseif ischar(thing) || isstring(thing)
        cid = string(this.j.embed(java.io.File(thing)));
      else
        error('mailspoon:InvalidInput', 'Invalid type for thing: expected string or handle; got a %s', class(thing));
      end
    end
    
    function cid = embedFromUrl(this, url, name)
      arguments
        this
        url (1,1)
        name (1,1) string
      end
      if ~isstring(url) && ~isa(url, 'java.net.URL')
        error('mailspoon:InvalidInput', 'url must be a string or java.net.URL; got a %s', class(url));
      end
      cid = string(this.j.embed(url, name));
    end
    
    function cid = embedFigure(this, fig, filename)
      arguments
        this
        fig
        filename (1,1) string = missing
      end
      persistent counter
      if isempty(counter)
        counter = 1;
      end
      if ismissing(filename)
        filename = sprintf("Plot %d.png", counter);
        counter = counter + 1;
      end
      tdir = [tempname '.d'];
      mkdir(tdir);
      filepath = fullfile(tdir, filename);
      saveas(fig, filepath);
      % We can't actually delete it, because Commons Email reads it at message
      % send time, not at embed time
      %RAII.file = onCleanup(@() delete(filepath));
      cid = this.embed(filepath);
    end
    
    function setHtmlMsg(this, html)
      this.j.setHtmlMsg(html);
    end
    
    function setTextMsg(this, text)
      this.j.setTextMsg(text);
    end
    
    function inspect(this, indent)
      arguments
        this (1,1)
        indent (1,1) string = ""
      end
      function p(fmt, varargin) %#ok<DEFNU>
        fprintf(indent + fmt + '\n', varargin{:});
      end
      inspect@mailspoon.MultiPartEmail(this, indent);
    end
    
  end
  
  methods (Access=protected)
    
    
  end
  
end