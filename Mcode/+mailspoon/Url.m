classdef Url < mailspoon.internal.MailSpoonBase & dispstrlib.Displayable
  % A URL
  %
  % Technically, this represents a URI which could be either a URL or URN, but
  % nobody cares about that distinction
  
  properties (SetAccess=private, Hidden)
    j
  end
  properties (Dependent)
    authority
    protocol
    host
    path
    port
    query
    ref
    userinfo
    defaultPort
  end
  
  methods (Static)
    
    function out = fromContext(context, spec)
      arguments
        context (1,1) mailspoon.Url
        spec (1,1) string
      end
      out = mailspoon.Url(java.net.URL(context.j, spec));
    end
    
  end
  
  methods
    
    function this = Url(in)
      % Construct a new Url
      if nargin == 0
        return
      end
      if isa(in, 'java.net.URL')
        this.j = in;
        return
      end
      if isstringy(in)
        in = string(in);
      end
      this = repmat(this, size(in));
      for i = 1:numel(in)
        this(i).j = java.net.URL(in(i));
      end
    end
    
    function inspect(this, indent)
      % Print a debugging representation of this object
      arguments
        this (1,1)
        indent (1,1) string = ""
      end
      function p(fmt, varargin)
        %fprintf(indent + fmt + '\n', varargin{:});
        mailspoon.internal.util.printInspectElement(fmt, indent, varargin);
      end
      if ismissing(this)
        p('Url: <missing>')
        return
      end
      p('Url: %s', string(this))
      p('  authority: %s', this.authority);
      p('  protocol: %s', this.protocol);
      p('  host: %s', this.host)
      p('  path: %s', this.path)
      p('  port: %d', this.port)
      p('  query: %s', this.query)
      p('  ref: %s', this.ref)
      p('  userinfo: %s', this.userinfo);
      p('  defaultPort: %d', this.defaultPort);
    end
    
    function out = string(this)
      out = repmat(string(missing), size(this));
      for i = 1:numel(this)
        if ~isempty(this(i))
          out(i) = this(i).j.toString;
        end
      end
    end
    
    function out = ismissing(this)
      % True for missing value
      out = true(size(this));
      for i = 1:numel(this)
        out(i) = isempty(this(i).j);
      end
    end
    
    function out = get.authority(this)
      out = repmat(string(missing), size(this));
      for i = 1:numel(this)
        if ~isempty(this(i))
          out(i) = this(i).j.getAuthority;
        end
      end
    end
    
    function out = get.protocol(this)
      out = repmat(string(missing), size(this));
      for i = 1:numel(this)
        if ~isempty(this(i))
          out(i) = this(i).j.getProtocol;
        end
      end
    end
    
    function out = get.host(this)
      out = repmat(string(missing), size(this));
      for i = 1:numel(this)
        if ~isempty(this(i))
          out(i) = this(i).j.getHost;
        end
      end
    end
    
    function out = get.path(this)
      out = repmat(string(missing), size(this));
      for i = 1:numel(this)
        if ~isempty(this(i))
          out(i) = this(i).j.getPath;
        end
      end
    end
    
    function out = get.port(this)
      out = NaN(size(this));
      for i = 1:numel(this)
        if ~isempty(this(i))
          out(i) = this(i).j.getPort;
        end
      end
    end
    
    function out = get.defaultPort(this)
      out = NaN(size(this));
      for i = 1:numel(this)
        if ~isempty(this(i))
          out(i) = this(i).j.getDefaultPort;
        end
      end
    end
    
    function out = get.query(this)
      out = repmat(string(missing), size(this));
      for i = 1:numel(this)
        if ~isempty(this(i))
          val = this(i).j.getQuery;
          if ~isempty(val)
            out(i) = val;
          end
        end
      end
    end
    
    function out = get.ref(this)
      out = repmat(string(missing), size(this));
      for i = 1:numel(this)
        if ~isempty(this(i))
          val = this(i).j.getRef;
          if ~isempty(val)
            out(i) = val;
          end
        end
      end
    end
    
    function out = get.userinfo(this)
      out = repmat(string(missing), size(this));
      for i = 1:numel(this)
        if ~isempty(this(i))
          val = this(i).j.getUserInfo;
          if ~isempty(val)
            out(i) = val;
          end
        end
      end
    end
    
  end
  
  methods (Access=protected)
    
    function out = dispstr_scalar(this)
      out = string(this);
    end
    
  end
  
end

