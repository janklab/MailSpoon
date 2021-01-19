---
layout: default
---

# MailSpoon Documentation

## About

Describe your project!

## Installation

## Usage

### Examples

```matlab
classdef SomeClass < SomeOtherClass

  properties
    x (1,1) double = 42
    y
  end

  methods
    function this = SomeClass()
    end
  end

end

function anExampleFunction(foo, bar, baz, qux)
  arguments
    foo
    bar (1,1) double
    baz string = "whatever"
    qux string = "foo" {mustBeMember(qux, ["foo" "bar" "baz"])}
  end

  fprintf('Hello, world!\n')
end
```

## AsciiDoc

Some of the documentation pages use AsciiDoc. See [here](Use-AsciiDoc/index.html) for an example.

## Author

MailSpoon is written and maintained by [YOUR-NAME-HERE](https://your-website.com). The project home page is <https://github.com/janklab/MailSpoon>.

## Acknowledgments

This project was created with [MatlabProjectTemplate](https://github.com/apjanke/MatlabProjectTemplate) by [Andrew Janke](https://apjanke.net).
