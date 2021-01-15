classdef InternetAddress < mailspoon.internal.MailSpoonBaseHandle & dispstrlib.DisplayableHandle
  % An Internet email address using the syntax of RFC822
  %
  % References:
  %
  %   RFC822 - https://www.ietf.org/rfc/rfc822.txt
  
  properties (SetAccess = private)
    j
  end
  properties (Dependent)
    address
    personal
    encodedPersonal
    isGroup
    type
  end
  
  methods
    
    function this = InternetAddress(varargin)
      args = varargin;
      if nargin == 0
        this.j = toJavaAddress;
      elseif nargin == 1
        a = args{1};
        if isa(a, 'javax.mail.internet.InternetAddress')
          this.j = a;
        elseif isa(a, 'mailspoon.InternetAddress')
          this = a;
        else
          a = string(a);
          this = repmat(this, size(a));
          for i = 1:numel(a)
            this(i).j = toJavaAddress(a(i));
          end
        end
      elseif nargin == 2
        if ~islogical(args{2})
          args{2} = string(args{2});
        end
        this.j = toJavaAddress(string(args{1}), args{2});
      elseif nargin == 3
        this.j = toJavaAddress(args{1}, args{2}, args{3});
      end
    end
    
    function out = get.address(this)
      out = string(this.j.getAddress);
    end
    
    function set.address(this, address)
      this.j.setAddress(address);
    end
    
    function out = get.personal(this)
      out = string(this.j.getPersonal);
    end
    
    function set.personal(this, personal)
      this.j.setPersonal(personal);
    end
    
    function out = get.isGroup(this)
      out = false(size(this));
      for i = 1:numel(this)
        out(i) = this(i).j.isGroup;
      end
    end
    
    function out = get.type(this)
      out = repmat(string(missing), size(this));
      for i = 1:numel(this)
        out(i) = this(i).j.getType;
      end
    end
    
    function out = string(this)
      out = repmat(string(missing), size(this));
      for i = 1:numel(this)
        out(i) = this(i).j.toString;
      end
    end
    
    function validate(this)
      for i = 1:numel(this)
        try
          this(i).j.validate;
        catch e
          error('mailspoon:InvalidAddress', 'Invalid address: "%s": %s', ...
            this(i).address, e.ExceptionObject.getMessage)
        end
      end
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = string(this.j.toString);
    end
    
  end
  
end

function out = toJavaAddress(varargin)
try
  out = javax.mail.internet.InternetAddress(varargin{:});
catch e
  error('mailspoon:InvalidAddress', 'Invalid email address: "%s": %s', ...
    varargin{1}, e.ExceptionObject.getMessage)
end
end
