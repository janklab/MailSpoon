classdef Settings < mailspoon.internal.MailSpoonBaseHandle
  
  properties
  end
  
  methods
    
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

