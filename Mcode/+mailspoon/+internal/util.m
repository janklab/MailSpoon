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
    
    function out = stringifytable(tbl)
      out = tbl;
      for i = 1:width(tbl)
        if iscellstr(tbl{:,i})
          out.(tbl.Properties.VariableNames{i}) = string(tbl{:,i});
        end
      end
    end
    
    function printInspectElement(fmt, indent, argsIn)
      args = argsIn;
      for i = 1:numel(args)
        if isscalar(args{i}) && ismissing(args{i})
          args{i} = "<missing>";
        end
      end
      fprintf(indent + fmt + '\n', args{:});
    end
    
    function mkdir(dir)
        [ok,msg,msgid] = mkdir(dir);
        if ~ok
            error('Failed creating directory "%s": %s', dir, msg);
        end
    end
    
  end
  
end