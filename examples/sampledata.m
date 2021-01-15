classdef sampledata
  % Sample data sets, adapted for MailSpoon's style
  
  methods (Static)
    
    function t = cereal
      s = load('cereal');
      s.Name = string(s.Name);
      s.Mfg = categorical(cellstr(s.Mfg));
      vars = s.Variables;
      s = rmfield(s, 'Variables');
      t = struct2table(s);
      t.Properties.VariableDescriptions = vars(:,2);
    end
    
    function t = carbig
      s = load('carbig');
      t = cars2table(s);
    end
    
    function t = carsmall
      s = load('carsmall');
      t = cars2table(s);
    end
    
    function t = flu
      s = load('flu');
      t = dataset2table(s.flu);
      t.Date = datetime(t.Date);
    end
    
    function t = hospital
      s = load('hospital');
      t = dataset2table(s.hospital);
      t.LastName = string(t.LastName);
    end
    
    function t = lawdata
      s = load('lawdata');
      t = struct2table(s);
    end
    
  end
  
end

function out = cars2table(s)
s.Mfg = categorical(cellstr(s.Mfg));
s.Origin = categorical(cellstr(s.Origin));
s = charfields2string(s);
out = struct2table(s);
end

function out = charfields2string(s)
out = s;
fnames = fieldnames(s);
for i = 1:numel(fnames)
  x = s.(fnames{i});
  if ischar(x) || iscellstr(x) || isstring(x)
    out.(fnames{i}) = strtrim(string(x));
  end
end
end