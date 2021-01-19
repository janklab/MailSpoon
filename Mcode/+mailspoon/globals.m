classdef globals < mailspoon.internal.MailSpoonBase
  % Global settings and resources for MailSpoon
  
  properties (Constant)
    % Path to the root directory of this MailSpoon distribution
    distroot = string(fileparts(fileparts(fileparts(mfilename('fullpath')))));
    % SMTP host and account settings
    smtpHost = mailspoon.SmtpHost
    % Miscellaneous settings
    settings = mailspoon.Settings
  end
  
  methods (Static)
    
    function inspect(indent)
      arguments
        indent (1,1) string = ""
      end
      function p(fmt, varargin)
        fprintf(indent + fmt + '\n', varargin{:});
      end
      p('MailSpoon globals:')
      p('SMTP settings:')
      mailspoon.globals.smtpHost.inspect(indent + "  ");
      p('Miscellaneous settings:')
      mailspoon.globals.settings.inspect(indent + "  ");
    end
    
    function out = version
      % The version of the MailSpoon library
      %
      % Returns a string.
      persistent val
      if isempty(val)
        versionFile = fullfile(mailspoon.globals.distroot, 'VERSION');
        val = strtrim(mailspoon.internal.readtext(versionFile));
      end
      out = val;
    end
    
  end
  
  methods (Access=private)
    
    %function out = globals
    %  % No instantiation!
    %end
    
  end
  
end