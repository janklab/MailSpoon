classdef Header < mailspoon.internal.MailSpoonBase & dispstrlib.Displayable
  % A single header for an email or HTTP response
  
  properties
    name (1,1) string
    value (1,1) string
  end
  
  methods
    
    function this = Header(name, value)
      arguments
        name (1,1) string = missing
        value (1,1) string = missing
      end
      this.name = name;
      this.value = value;
    end
    
  end
  
  methods (Access=protected)
    
    function out = dispstr_scalar(this)
      out = mailspoon.internal.sprintf("%s: %s", this.name, this.value);
    end
    
  end
  
end

