classdef libinfo
  % Information about the MailSpoon library
  
  properties (Constant)
    % Path to the root directory of this MailSpoon distribution
    distroot = string(fileparts(fileparts(fileparts(mfilename('fullpath')))));
  end
  
  methods (Static)
    
    function out = version
      %
      % Returns a string.
      persistent val
      if isempty(val)
        versionFile = fullfile(mailspoon.libinfo.distroot, 'VERSION');
        val = strtrim(mailspoon.internal.readtext(versionFile));
      end
      out = val;
    end
    
  end
  
end