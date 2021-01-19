classdef HtmlEmail < mailspoon.MultiPartEmail
  
  properties (Dependent)
    % The main message content, as HTML
    html
    % The main message content, as plain text
    text
  end
  properties (Hidden)
    DEBUG_preserveTempdir (1,1) logical = false
  end
  properties (Access=private)
    tempDir (1,1) string = [tempname '-MailSpoon.d'];
    counter (1,1) = 1
  end
  
  methods
    
    function this = HtmlEmail(to, from)
      % Create a new HtmlEmail object
      this.j = net.janklab.mailspoon.internal.DebuggableHtmlEmail;
      if nargin >= 1
        this.to = to;
      end
      if nargin >= 2
        this.from = from;
      end
      % TODO: lazy-create the temp dir on first actual usage
      mkdir(this.tempDir);
    end
    
    function delete(this)
      if ~this.DEBUG_preserveTempdir
        try
          if isfolder(this.tempDir)
            [ok,msg,msgid] = rmdir(this.tempDir, 's'); %#ok<ASGLU>
          end
        catch err %#ok<NASGU>
          % quash
        end
      end
    end
    
    function cid = embed(this, thing)
      % Embed a thing so it can be used as an inline image or other content
      %
      % The thing may be:
      %   - a string containing a file name
      %   - a figure handle
      %
      % Note that if you embed a file, you must leave that file in place until
      % the message is actually sent, or you'll get an error. The files are read
      % at message send time, not message construction time.
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
      % Embed a thing from a URL source
      %
      % Returns the generated CID as a string.
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
    
    function cid = embedFigurePrint(this, fig, filename, formattype, opts)
      % Advanced figure embedding using Matlab's print function
      arguments
        this
        fig
        filename (1,1) string
        formattype (1,1) string = missing
        opts cell = {}
      end
      if ismissing(filename)
        filename = sprintf("Plot %d.png", this.nextCounter);
      end
      if ismissing(formattype)
        [~,~,fext] = fileparts(char(filename));
        fext(1) = [];
        switch lower(fext)
          case 'png';           fmt = 'png';
          case {'jpg' 'jpeg'};  fmt = 'jpeg';
          case 'tif';           fmt = 'tiff';
          case 'emf';           fmt = 'meta';
          case 'bmp';           fmt = 'bmp';
          case 'pcx';           fmt = 'pcx256';
          case 'pdf';           fmt = 'pdf';
          case 'svg';           fmt = 'svg';
          otherwise;            error('Could not guess image file format type for file %s', filename)
        end
        formattype = fmt;
      end
      filepath = fullfile(this.tempDir, filename);
      print(fig, filepath, ['-d' formattype], opts{:});
      cid = this.embed(string(filepath));
    end
    
    function cid = embedFigure(this, fig, filename)
      % Embed an image from a Matlab figure window
      %
      % cid = embedFigure(this, fig, filename)
      %
      % fig is a Matlab figure handle.
      %
      % filename (optional) is a file basename to use for the figure. This will
      % affect the default name that the image is saved as if the recipient
      % right-clicks on the image and does a "Save As..." in their email client.
      %
      % Returns the generated CID as a string.
      arguments
        this
        fig
        filename (1,1) string = missing
      end
      if ismissing(filename)
        filename = sprintf("Plot %d.png", this.nextCounter);
      end
      filepath = fullfile(this.tempDir, filename);
      saveas(fig, filepath);
      cid = this.embed(filepath);
    end
    
    function set.html(this, html)
      this.setHtmlMsg(html);
    end
    
    function setHtmlMsg(this, html)
      % Set the HTML-format message contents
      this.j.setHtmlMsg(html);
    end
    
    function set.text(this, text)
      this.setTextMsg(text);
    end
    
    function setTextMsg(this, text)
      % Set the plain-text-format message contents
      this.j.setTextMsg(text);
    end
    
    function inspect(this, indent)
      % Print a debugging representation of this object
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
    
    function out = nextCounter(this)
      out = this.counter;
      this.counter = this.counter + 1;
    end
    
  end
  
end