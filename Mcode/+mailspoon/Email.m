classdef Email < mailspoon.internal.MailSpoonBaseHandle
  % Abstract base class for email messages
  
  properties
    % The underlying org.apache.commons.mail.Email object
    j
  end
  properties (Dependent)
    from
    to
    subject
    cc
    bcc
    replyTo
    bounceAddress
    headers
    sentDate
    isSendPartial
  end
  
  methods
    
    function setFrom(this, varargin)
      narginchk(2,3)
      addr = mailspoon.InternetAddress(varargin{:});
      this.j.setFrom(addr.address, addr.personal);
    end
    
    function out = get.from(this)
      out = mailspoon.InternetAddress(this.j.getFromAddress);
    end
    
    function set.from(this, from)
      this.setFrom(from);
    end
    
    function out = get.to(this)
      out = ofJavaAddrList(this.j.getToAddresses);
    end
    
    function set.to(this, to)
      if ischar(to) || iscellstr(to) || isstring(to)
        to = string(to);
      end
      to = mailspoon.InternetAddress(to);
      jTo = java.util.ArrayList;
      for i = 1:numel(to)
        jTo.add(to(i).j);
      end
      this.j.setTo(jTo);
    end
    
    function addTo(this, varargin)
      this.j.addTo(varargin{:});
    end
    
    function out = get.cc(this)
      out = ofJavaAddrList(this.j.getCcAddresses);
    end
    
    function addCc(this, varargin)
      this.j.addCc(varargin{:});
    end
    
    function out = get.bcc(this)
      out = ofJavaAddrList(this.j.getBccAddresses);
    end
    
    function addBcc(this, varargin)
      this.j.addBcc(varargin{:});
    end
    
    function set.subject(this, subject)
      this.j.setSubject(subject);
    end
    
    function out = get.subject(this)
      out = string(this.j.getSubject);
    end
    
    function out = get.bounceAddress(this)
      out = string(this.j.getBounceAddress);
    end
    
    function set.bounceAddress(this, bounceAddress)
      this.j.setBounceAddress(bounceAddress);
    end
    
    function out = get.sentDate(this)
      out = mailspoon.internal.todatetime(this.j.getSentDate);
    end
    
    function addHeader(this, name, value)
      this.j.addHeader(name, value);
    end
    
    function out = get.isSendPartial(this)
      out = this.j.isSendPartial;
    end
    
    function set.isSendPartial(this, isSendPartial)
      this.j.setSendPartial(isSendPartial);
    end
    
    function setDebug(this, debug)
      this.j.setDebug(debug);
    end
    
    function out = get.headers(this)
      out = containers.Map;
      jhdrs = this.j.getHeaders;
      it = jhdrs.keySet.iterator;
      while it.hasNext
        key = it.next;
        val = jhdrs.get(key);
        out(string(key)) = string(val);
      end
    end
    
    function inspect(this, indent)
      arguments
        this (1,1)
        indent (1,1) string = ""
      end
      function p(fmt, varargin)
        fprintf(indent + fmt + '\n', varargin{:});
      end
      function pmaybe(label, val)
        if isempty(val) || ismissing(val)
          return
        end
        p(label + ": %s", val)
      end
      function paddrlist(label, addrs)
        if isempty(addrs)
          return
        end
        p('%-7s  %s', label + ":", string(addrs(1)))
        for ii = 2:numel(addrs)
          p('         %s', string(addrs(ii)))
        end
      end
      p('')
      p('%s:', class(this))
      p('')
      p('From:    %s', string(this.from))
      paddrlist('To', this.to)
      paddrlist('Cc', this.cc)
      paddrlist('Bcc', this.bcc)
      % No pmaybe here due to horizontal alignment
      if ~isempty(this.bounceAddress)
        p('Bounce:  %s', this.bounceAddress)
      end
      p('Subject: %s', this.subject)
      pmaybe('Date', this.sentDate)
      hdrs = this.headers;
      if ~isempty(hdrs)
        p('')
        p('Headers:')
        for key = string(hdrs.keys)
          val = hdrs(key);
          p('    %s: %s', key, val)
        end
      end
      p('')
      
    end
    
    function out = send(this)
      out = mailspoon.MailHost.default.send(this);
      if nargout == 0
        clear out
      end
    end
    
  end
  
end

function out = ofJavaAddrList(jaddrs)
out = repmat(mailspoon.InternetAddress, [1 jaddrs.size]);
for i = 1:jaddrs.size
  out(i) = jaddrs.get(i-1);
end
end
