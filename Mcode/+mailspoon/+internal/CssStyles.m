classdef CssStyles
  % A collection of sample CSS styles
  
  %#ok<*INUSA>
  %#ok<*MANU>
  
  methods
    
    function out = getStyle(this, name)
      arguments
        this
        name (1,1) string
      end
      cssFile = fullfile(this.stylesDir, lower(name) + ".css");
      if ~isfile(cssFile)
        error("Style %s is not defined.", name);
      end
      out = mailspoon.internal.readtext(cssFile);
    end
    
    function out = stylesDir(this)
      myDir = fileparts(mfilename('fullpath'));
      out = fullfile(myDir, 'resources', 'css-styles');
    end
    
    function out = listStyles(this)
      d = dir(this.stylesDir);
      names = setdiff({d.name}, {'.' '..'});
      out = string(regexprep(names, '\..*', ''));
    end
    
    function out = teal(this)
      out = this.getStyle('teal');
    end
    
  end
    
end

