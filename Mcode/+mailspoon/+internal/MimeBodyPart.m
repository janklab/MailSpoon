classdef MimeBodyPart < mailspoon.internal.MailSpoonBaseHandle
  % Wrapper for javax.mail.internet.MimeBodyPart
  
  properties
    j = javax.mail.internet.MimeBodyPart
  end
  
  properties (Dependent)
    contentId
    contentLanguages
    contentMD5
    contentType
    description
    disposition
    encoding
    fileName
    lineCount
    sizeInBytes
  end
  
  methods
    
    function this = MimeBodyPart(jobj)
      if nargin == 0
        return
      else
        mustBeA(jobj, 'javax.mail.internet.MimeBodyPart');
        this.j = jobj;
      end
    end
    
    function out = get.contentId(this)
      out = string(this.j.getContentID);
    end
    
    function out = get.contentLanguages(this)
      out = string(this.j.getContentLanguage);
    end
    
    function out = get.contentMD5(this)
      out = string(this.j.getContentMD5);
    end
    
    function out = get.contentType(this)
      out = string(this.j.getContentType);
    end
    
    function out = get.description(this)
      out = string(this.j.getDescription);
    end
    
    function out = get.disposition(this)
      out = string(this.j.getDisposition);
    end
    
    function out = get.encoding(this)
      out = string(this.j.getEncoding);
    end
    
    function out = get.fileName(this)
      out = string(this.j.getFileName);
    end
    
    function out = get.lineCount(this)
      out = this.j.getLineCount;
    end
    
    function out = get.sizeInBytes(this)
      out = this.j.getSize;
    end
    
    function inspect(this, indent)
      arguments
        this (1,1)
        indent (1,1) string = ""
      end
      function p(fmt, varargin)
        fprintf(indent + fmt + "\n", varargin{:});
      end
      function pmaybe(fmt, val)
        if ~isempty(val) && ~ismissing(val)
          p(fmt, val)
        end
      end
      p('contentType: %s', mailspoon.internal.flattext(this.contentType))
      p('contentId: %s, disposition: %s, MD5: %s', this.contentId, this.disposition, this.contentMD5)
      p('encoding: %s, fileName: %s, lineCount: %d, sizeInBytes: %d', ...
        this.encoding, this.fileName, this.lineCount, this.sizeInBytes);
      langs = this.contentLanguages;
      if ~isempty(langs)
        p('languages: %s', strjoin(langs, ', '))
      end
      pmaybe('description: %s', this.description)
      % TODO: Display headers that aren't covered by the above info
%       it = this.j.getAllHeaderLines;
%       if it.hasMoreElements
%         p('Headers:')
%         while it.hasMoreElements
%           p('  %s', it.nextElement)
%         end
%       end
      jContent = this.j.getContent;
      if isjava(jContent)
        %p('content as Java object: %s: %s', jContent.getClass.getName, jContent)
      end
      if isa(jContent, 'javax.mail.internet.MimeMultipart')
        p('MimeMultipart content:');
        mp = mailspoon.internal.MimeMultipart(jContent);
        mp.inspect(indent + "    ");
      elseif isa(jContent, 'java.io.FileInputStream')
        try
          p('File size: %d KB', round(jContent.getChannel.size / 1024))
        catch
          % quash
        end
      elseif ischar(jContent)
        p('Text: %d chars', numel(jContent))
      end
    end
    
  end
  
end

