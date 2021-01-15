function out = todatetime(in)
% Convert a value to Matlab datetime, in a reasonable manner

if isa(in, 'double') || isa(in, 'single')
  out = datetime(in, 'ConvertFrom','datenum');
elseif isa(in, 'java.util.Date')
  out = ofJavaDate(in);
elseif isdatetime(in)
  out = in;
end

end

function out = ofJavaDate(jdate)
  out = datetime(jdate.getTime / 1000, 'ConvertFrom','posixtime');
  tzoff = jdate.getTimezoneOffset;
  if tzoff ~= 0
    if tzoff > 0
      sign = '-';
    else
      sign = '+';
    end
    absoff = abs(tzoff);
    offhours = floor(absoff / 60);
    offminutes = rem(absoff, 60);
    tzoffStr = sprintf('%s%02d:%02d', sign, offhours, offminutes);
    out.TimeZone = 'UTC';
    out.TimeZone = tzoffStr;
  end
end
