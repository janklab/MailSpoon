classdef util
  
  methods (Static)
    
    function out = indent(str, indent)
      arguments
        str string
        indent (1,1) string = '    '
      end
      % TODO: Support Windows mode line endings?
      out = strjoin(strcat(indent, strsplit(str, '\n')), '\n');
    end
    
  end
  
end