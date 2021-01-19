classdef HtmlBodyBuilder < mailspoon.internal.MailSpoonBaseHandle
  % Builds HTML documents incrementally, as emails or files
  %
  % Use this class if you want fine-grained control over how the HTML in your
  % email looks and is structured.
  
  %#ok<*AGROW>
  
  properties (SetAccess=private)
    % Whether this is going to an Email message or a set of files
    format (1,1) string {mustBeMember(format, ["email" "file"])} = "email"
  end
  properties
    % HTML content to go in the HTML's <head> area
    head (1,:) string
    % HTML content to go in the HTML's <body> area
    body (1,:) string
    % The MIME email message we're building, if this's format is email
    email (1,1) mailspoon.HtmlEmail = mailspoon.HtmlEmail
    % The directory this is building into, if this's format is file
    destDir (1,1) string
    % Whether to include the little MailSpoon ad at the end of the document.
    % Be a pal and consider leaving this on!
    includeMailspoonAd (1,1) logical = true
  end
  properties (SetAccess=private)
    % Collection of CSS style definitions. Unlike .head and .body, all the
    % elements of this array must individually be valid CSS definitions; they
    % can't be arbitrary string fragments.
    css (1,:) string = mailspoon.internal.Common.cssStyles.getDefaultStyle;
  end
  properties (Access=private)
    % A counter for producing distinct file names or identifiers
    counter (1,1) double = 1
  end
  properties (Constant, Hidden)
    tempDirBase (1,1) string = fullfile(tempdir, 'MailSpoon', 'docs');
  end
  
  methods
    
    function this = HtmlBodyBuilder(format, destDir)
      % Construct a new HtmlBodyBuilder object
      %
      % this = HtmlBodyBuilder(format, destDir)
      %
      % Format indicates whether this is building an EmailMessage or a directory
      % of files on disk. May be "email" (default) or "file".
      %
      % DestDir (string) is the directory to write to if format is "file". If
      % missing or omitted, this creates a new directory under the temporary
      % directory.
      arguments
        format (1,1) string = "email"
        destDir (1,1) string = missing
      end
      this.format = format;
      this.destDir = destDir;
      if this.format == "file"
        if ismissing(this.destDir)
          this.destDir = fullfile(this.tempDirBase, datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
        end
        if ~isfolder(this.destDir)
          mailspoon.internal.util.mkdir(this.destDir);
          mailspoon.internal.util.mkdir(fullfile(this.destDir, 'images'));
        end
      end
    end
    
    function out = nextCounter(this)
      out = this.counter;
      this.counter = this.counter + 1;
    end
    
    function add(this, thing)
      % Add content to this's body
      %
      % add(this, thing)
      %
      % The thing may be any of:
      %   - A string containing HTML
      %   - A string containing a filename
      %   - A mailspoon.File object
      %   - A mailspoon.Url object
      %   - A table array
      %   - A numeric array
      %   - Anything else that mailspoon.htmlify knows how to render
      %   - A cell array whose contents are any of the above
      %
      % See also:
      %     mailspoon.htmlify
      
      if isstring(thing) || ischar(thing)
        things = cellstr(thing);
      elseif iscell(thing)
        things = thing;
      else
        things = thing;
      end
      for i = 1:numel(things)
        buf = string([]);
        th = things{i};
        if isstringy(th)
          th = string(th);
          for ii = 1:numel(th)
            if isfile(th(ii))
              % TODO: Slurp and handle file
              buf(end+1) = this.addFromFile(th(ii));
            else
              % It's HTML content
              buf(end+1) = th(ii);
            end
          end
        elseif ishandle(th)
          % Figure handles get embedded as inline images
          for iTh = 1:numel(th)
            if this.format == "email"
              cid = this.email.embedFigure(th(iTh));
              % No "/" in the tag! That seems to break in some email clients.
              buf(end+1) = sprintf('<img src=cid:%s>', cid);
            else
              filename = sprintf('Plot %d.png', this.nextCounter);
              file = fullfile(this.destDir, 'images', filename);
              saveas(th(iTh), file);
              buf(end+1) = sprintf('<img src="images/%s">', filename);
            end
          end
        else
          % Anything else, delegate to htmlify()
          buf = [buf mailspoon.htmlify(th)];
        end
        this.body = [this.body buf];
      end
    end
    
    function addCss(this, newCss)
      % Add CSS definitions
      %
      % addCss(this, newCss)
      %
      % Adds new CSS style definitions to this' running collection of CSS (in
      % the .css property). All the elements of newCss must each be valid CSS on
      % their own.
      arguments
        this
        newCss string
      end
      % TODO: Validate input as CSS
      this.css = [this.css newCss(:)'];
    end
    
    function finish(this)
      % Finish up building and create the final HTML document
      %
      % finish(this)
      %
      % After you call this, grab this.email or this.destDir to get the results.
      if this.includeMailspoonAd
        adFooter = sprintf('<hr/>\n%s', this.mailspoonAd);
      else
        adFooter = '';
      end
      html = string(sprintf(strjoin({
        '<!DOCTYPE html>'
        '<html>'
        '<head>'
        '%s'
        '    <style>'
        '%s'
        '    </style>'
        '</head>'
        '<body>'
        '%s'
        ''
        '%s'
        '</body>'
        '</html>'
        ''
        }, '\n'), strjoin(this.head, '\n'), strjoin(this.css, '\n'), ...
        strjoin(this.body, '\n'), ...
        adFooter));
      if this.format == "email"
        this.email.html = html;
      else
        mailspoon.internal.writetext(fullfile(this.destDir, 'index.html'), html);
      end
    end
    
    function out = mailspoonAd(this) %#ok<MANU>
      out = strjoin({
        '<p>Powered by '
        '<a href="http://github.com/janklab/MailSpoon"><b>MailSpoon</b></a> '
        'for MATLAB®.</p>'
        }, '');
    end
    
  end
  
  methods (Access=private)
    
    function out = addFromFile(this, file)
      if this.format == "email"
        cid = this.email.embed(file);
        % No "/" in the tag! That seems to break in some email clients.
        out = sprintf('<img src=cid:%s>', cid);
      else
        [~,filebase,fext] = fileparts(file);
        filebase = [filebase fext];
        outFile = fullfile(this.destDir, 'images', filebase);
        copyfile(file, outFile);
        out = sprintf('<img src="images/%s">', filebase);
      end
    end
    
  end
  
end
