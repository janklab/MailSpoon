classdef MailSpoonInit
  % Initializer for the MailSpoon library
  
  methods
    
    function this = MailSpoonInit()
        % Initializes the MailSpoon library
        %
        % This must be called before you do anything else with any MailSpoon code.
        % So we stick it in an Init class that is referenced by every other
        % MailSpoon class.
        
        ad = getappdata(0, 'mailspoon');
        if ~isempty(ad) && isfield(ad, 'initialized') && ad.initialized
          % Lib is already initialized
          return
        end
        
        % Get vendored Matlab libs on path
        distroot = fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
        libmat = fullfile(distroot, 'lib', 'matlab');
        addpath(fullfile(libmat, 'dispstr', 'Mcode'));
        
        % Get Java JARs on path
        libjava = fullfile(distroot, 'lib', 'java');
        javaaddpath(fullfile(libjava, 'MailSpoonJavaSupport-0.1.0-SNAPSHOT.jar'));
        libapache = fullfile(libjava, 'commons-email-1.5');
        jars = [
          "commons-email-1.5.jar"
          "commons-email-1.5-tests.jar"
          ];
        jpath = javaclasspath;
        for jar=jars'
          jarpath = fullfile(libapache, jar);
          if ~ismember(jarpath, jpath)
            javaaddpath(jarpath);
          end
        end
        
        % Record initialization
        s.initialized = true;
        mailspoon.internal.util.setpackageappdata('initialized', true);


        fprintf('MailSpoon %s initialized\n', libVersion(distroot));
        fprintf('This is prerelease, alpha-quality software! It may be buggy!\n');
      end
      
    end
    
end
  
function out = libVersion(distroot)
versionFile = fullfile(distroot, 'VERSION');
out = strtrim(mailspoon.internal.readtext(versionFile));
end
