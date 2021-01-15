classdef HtmlTableWriter < mailspoon.internal.MailSpoonBaseHandle
  % Knows how to render Matlab table arrays as HTML tables
  
  % Settings that control its behavior
  properties
    
  end
  % State for when we're doing writing
  properties
    tempFile = string([tempname '-MailSpoon-HtmlTableWriter.html'])
    fid
  end
  
  methods
    
    function out = htmlify(this, in)
      if istable(in)
        t = in;
      elseif isa(in, 'dataset')
        t = dataset2table(in);
      elseif isnumeric(in)
        t = array2table(in);
      elseif iscell(in)
        t = cell2table(in);
      else
        t = table(in);
      end
      this.start;
      this.render(t);
      out = this.finish;
    end
    
    function start(this)
      this.fid = fopen(this.tempFile, 'w');
    end
    
    function p(this, fmt, varargin)
      % Emit text
      fprintf(this.fid, string(fmt)+"\n", varargin{:});
    end
    
    function out = finish(this)
      fclose(this.fid);
      out = mailspoon.internal.readtext(this.tempFile);
      delete(this.tempFile);
    end
    
    function render(o, t)
      colDataStrs = cell(1, width(t));
      for i = 1:width(t)
        colDataStrs{i} = o.colDataToHtmlStrs(t{:,i});
      end
      colDataStrs = [colDataStrs{:}];
      % TODO: Dimension names
      % TODO: Row names
      % Header
      o.p('<table border=1>')
      o.p('  <thead>')
      o.p('    <tr>')
      for iCol = 1:width(t)
        o.p('      <th>%s</th>', htmlescape(t.Properties.VariableNames{iCol}))
        % TODO: VariableUnits
      end
      o.p('    </tr>')
      o.p('  </thead>')
      % Body Data
      o.p('  <tbody>')
      for iRow = 1:height(t)
        o.p('     <tr> %s </tr>', strjoin(strcat('<td>', colDataStrs(iRow,:), '</td>'), ' '))
      end
      o.p('  </tbody>')
      % Footer
      % TODO: How would we specify this?
      o.p('  </table>')
    end
    
    function out = colDataToHtmlStrs(this, x)
      if size(x, 2) > 1
        error('Multi-column table variables are not supported');
      end
      if iscell(x)
        if iscellstr(x)
          x = string(x);
        else
          error('Non-cellstr cell variables are not supported');
        end
      end
      
      if isnumeric(x)
        out = num2string(x);
      elseif isstring(x)
        out = htmlescape(x);
      elseif iscategorical(x)
        % TODO: Do uniqueification trick. Probably do that for strings, too.
        out = htmlescape(string(x));
      else
        % TODO: whip out dispstrs() here
        error('Unsupported column type: %s', class(x));
      end
    end
    
  end
  
end

function out = num2string(x)
sz = size(x);
out = string(strtrim(cellstr(num2str(x(:)))));
out = reshape(out, sz);
end

function out = htmlescape(strs)
strs = string(strs);
out = repmat(string(missing), size(strs));
% TODO: Push this loop down into Java for performance
for i = 1:numel(strs)
  out(i) = org.apache.commons.lang.StringEscapeUtils.escapeHtml(strs(i));
end
end