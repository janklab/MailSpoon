classdef HeaderSet < mailspoon.internal.MailSpoonBase
  % A set of headers
  %
  % This class exists instead of using a containers.Map because technically a
  % message or HTTP response can have multiple headers with the same name.
  % Plus, containers.Map is pass-by-reference.
  
  properties
    headers (:,1) mailspoon.Header
  end
  
  methods
    
    function this = HeaderSet()
    end
    
    function disp(this)
      if isscalar(this)
        fprintf('%s:\n', class(this));
        disp(this.headers);
      else
        fprintf('<%s %s>\n', size2str(size(this)), class(this));
      end
    end
    
    function this = addHeader(this, name, value)
      this.headers(end+1) = mailspoon.Header(name, value);
    end
    
    function out = getHeader(this, name)
      arguments
        this
        name (1,1) string
      end
      found = false;
      for i = 1:numel(this.headers)
        h = this.headers(i);
        if h.name == name
          if found
            error('This HeaderSet contains multiple headers named "%s"', name);
          end
          out = h;
          found = true;
        end
        if ~found
          error('This HeaderSet contains no header named "%s"', name);
        end
      end
    end
    
  end
  
end