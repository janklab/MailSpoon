classdef Password < mailspoon.internal.MailSpoonBase & dispstrlib.Displayable
  % A masked password
  %
  % A Password is just a string that tries not to actually display itself, like
  % at the command window or during string interpolation.
  
  properties (Access=private)
    str string = missing
  end
  
  methods
    
    function this = Password(str)
      % Construct a new Password by wrapping a string
      if nargin == 0
        return
      end
      str = string(str);
      this = repmat(this, size(str));
      for i = 1:numel(str)
        this(i).str = str(i);
      end
    end
    
    function out = getActualPassword(this)
      % Get the actual password
      out = repmat(string(missing), size(this));
      for i = 1:numel(this)
        out(i) = this(i).str;
      end
    end
    
    function out = ismissing(this)
      % True for missing value
      out = false(size(this));
      for i = 1:numel(this)
        out(i) = ismissing(this(i).str);
      end
    end
    
  end
  
  methods (Access=protected)
    
    function out = dispstr_scalar(this)
      if ismissing(this)
        out = '<missing>';
      else
        out = '"********"';
      end
    end
    
  end
  
end
  