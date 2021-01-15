classdef File < mailspoon.internal.MailSpoonBase & dispstrlib.Displayable
  % A file name or path
  %
  % A File is a representation of an abstract pathname pointing to a file on 
  % disk.
  
  properties (Hidden,SetAccess=private)
    % The underlying java.io.File object
    j
  end
  properties (Dependent)
    path
    name
    absoluteFile
    absolutePath
    canonicalFile
    canonicalPath
  end
  
  methods
    
    function this = File(str)
      % Construct a new File by wrapping a string
      if nargin == 0
        return
      end
      if isa(str, 'java.io.File')
        this.j = str;
        return
      end
      if isstringy(str)
        str = string(str);
      end
      this = repmat(this, size(str));
      for i = 1:numel(str)
        this(i).j = java.io.File(str(i));
      end
    end
    
    function out = get.path(this)
      if isempty(this.j)
        out = string(missing);
      else
        out = string(this.j.getPath);
      end
    end
    
    function out = get.name(this)
      if isempty(this.j)
        out = string(missing);
      else
        out = string(this.j.getName);
      end
    end
       
    function out = ismissing(this)
      % True for missing value
      out = true(size(this));
      for i = 1:numel(this)
        out(i) = ~isempty(this(i).j);
      end
    end
    
    function inspect(this, indent)
      % Print a debugging representation of this object
      arguments
        this (1,1)
        indent (1,1) string = ""
      end
      function p(fmt, varargin)
        fprintf(indent + fmt + '\n', varargin{:});
      end
      if ismissing(this)
        p('File: <missing>')
        return
      end
      p('File:')
      p('Path: %s', this.path)
      p('Name: %s', this.name)
    end

    function out = exists(this)
      if ismissing(this)
        out = false;
      else
        out = this.j.exists;
      end
    end
      
    function out = isfile(this)
      out = true(size(this));
      for i = 1:numel(this)
        if ismissing(this(i))
          out(i) = false;
        else
          out(i) = this(i).j.isFile;
        end
      end
    end
    
    function out = isfolder(this)
      if ismissing(this)
        out = false;
      else
        out = this.j.isDirectory;
      end
    end
    
    function out = isHidden(this)
      out = false(size(this));
      for i = 1:numel(this)
        if ~ismissing(this(i))
          out(i) = this(i).j.isHidden;
        end
      end
    end
    
    function out = mtime(this)
      out = repmat(datetime(missing), size(this));
      for i = 1:numel(this)
        if ~ismissing(this(i))
          out(i) = datetime(this(i).j.lastModified/1000, 'ConvertFrom','posixtime');
        end
      end
    end
    
    function out = up(this)
      if ismissing(this)
        out = this;
      else
        out = mailspoon.File(this.j.getParentFile);
      end
    end
    
    function [files, details] = dir(this, showHidden)
      arguments
        this (1,1) mailspoon.File
        showHidden (1,1) logical = true
      end
      if ~isfolder(this)
        error('Not a folder: %s', this.path);
      end
      d = dir(this.path);
      files = {d.name};
      tf = ~ismember(files, {'.' '..'});
      files = string(files(tf));
      d = d(tf);
      details = mailspoon.internal.util.stringifytable(struct2table(d));
      details.path = fullfile(details.folder, details.name);
      % Hidden filtering
      if ~showHidden || nargout > 1
        fileObjs = mailspoon.File(details.path);
      end
      if ~showHidden
        tf = ~fileObjs.isHidden;
        [files, d, details, fileObjs] = deal(files(tf), d(tf), details(tf,:), fileObjs(tf)); %#ok<ASGLU>
      end
      % Details
      if nargout > 1
        details.date = datetime(double(details.datenum), 'ConvertFrom','datenum');
        details.date.TimeZone = datetime.SystemTimeZone;
        details.datenum = [];
        details.mtime = fileObjs.mtime;
      end
    end
    
  end
  
  methods (Access=protected)
    
    function out = dispstr_scalar(this)
      if ismissing(this)
        p = '<missing>';
      else
        p = this.path;
      end
      out = sprintf('<File: %s>', p);
    end
    
  end
  
end

