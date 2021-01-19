classdef Settings < mailspoon.internal.MailSpoonBaseHandle
  
  properties
    % The default CSS theme to use for generated HTML
    defaultCssTheme (1,1) string = "teal"
  end
  
  methods (Static)
    
    function out = discover()
      % Discover the initial settings for this package
      
      % TODO: Config file, env vars, and getpref('Internet')
      out = mailspoon.Settings;
    end
    
  end
  
  methods
    
    function inspect(this, indent)
      % Print a debugging representation of this object
      arguments
        this (1,1)
        indent (1,1) string = ""
      end
      function p(fmt, varargin) %#ok<DEFNU>
        fprintf(indent + fmt + '\n', varargin{:});
      end
      disp(this);
    end
    
    function set.defaultCssTheme(this, newTheme)
      % Setter for defaultCssTheme
      
      % TODO: Validate that newTheme is a defined theme
      this.defaultCssTheme = newTheme;
    end

  end
  
end

