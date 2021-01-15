classdef Email < mailspoon.internal.MailSpoonBaseHandle
  % Abstract base class for email messages
  %
  % This defines all the "envelope" information, like sender, recipients, 
  % subject, and so on.
  
  properties (Hidden)
    % The underlying org.apache.commons.mail.Email object
    j
  end
  properties (Dependent)
    % The email address of the sender
    from
    % List of email addresses of the recipients
    to
    % Mail subject line
    subject
    % List of addresses to Cc the email to
    cc
    % List of addresses to Bcc the email to
    bcc
    % Reply-to address
    replyTo
    % Address to contact in case of bounced emails (rarely used and little supported)
    bounceAddress
    % Custom message headers, as a read-only containers.Map
    headers
    % Date the message was created (not when it was actually sent through SMTP)
    sentDate
    % Whether to allow partial sending when some of the To addresses are invalid
    isSendPartial
  end
  
  methods
    
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
      arguments
        this (1,1)
        to mailspoon.InternetAddress
      end
      this.j.setTo(toJavaAddrList(to));
    end
    
    function out = get.cc(this)
      out = ofJavaAddrList(this.j.getCcAddresses);
    end
    
    function set.cc(this, cc)
      arguments
        this (1,1)
        cc mailspoon.InternetAddress
      end
      this.j.setTo(toJavaAddrList(cc));
    end
    
    function addCc(this, varargin)
      % Add an address to the Cc list
      this.j.addCc(varargin{:});
    end
    
    function out = get.bcc(this)
      out = ofJavaAddrList(this.j.getBccAddresses);
    end
    
    function set.bcc(this, bcc)
      arguments
        this (1,1)
        bcc mailspoon.InternetAddress
      end
      this.j.setTo(toJavaAddrList(bcc));
    end
    
    function addBcc(this, varargin)
      % Add an address to the Bcc list
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
      % Add a custom header
      this.j.addHeader(name, value);
    end
    
    function out = get.isSendPartial(this)
      out = this.j.isSendPartial;
    end
    
    function set.isSendPartial(this, isSendPartial)
      this.j.setSendPartial(isSendPartial);
    end
    
    function setDebug(this, debug)
      % Turn debugging output on or off
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
      % Print a debugging representation of this object
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
      % Send this message
      out = mailspoon.globals.smtpHost.send(this);
      if nargout == 0
        clear out
      end
    end
    
  end
  
  methods (Access=private)

    function setFrom(this, varargin)
      narginchk(2,3)
      addr = mailspoon.InternetAddress(varargin{:});
      this.j.setFrom(addr.address, addr.personal);
    end
    
  end
  
end

function out = ofJavaAddrList(jaddrs)
out = repmat(mailspoon.InternetAddress, [1 jaddrs.size]);
for i = 1:jaddrs.size
  out(i) = jaddrs.get(i-1);
end
end

function out = toJavaAddrList(addrs)
jList = java.util.ArrayList;
for i = 1:numel(addrs)
  jList.add(addrs(i).j);
end
out = jList;
end
