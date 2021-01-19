# MailSpoon TODO

## Documentation and branding

* How to incorporate the `examples/` into the Jekyll docs?

## Coding stuff

* `fff` string interpolation
* Logging
* Header-set object
* Unit tests
* Matlab CI
  * Set up Azure Pipelines
  * Set up CircleCI

## Content stuff

* Control over resolution/size of images saved from figures
* Embedding audio and video

## HTML generation

* HTML tables from:
  * numeric matrix
  * cell array
* Builder that takes mixed-content-type cell arrays and strings their htmlifications together
* Use the `InlineHtmlEmail` class from Commons Email
* `pre` formatting for code
* Syntax highlighting for code

## Authentication and configuration stuff

* SMTP configuration persistence
* Some decent way of storing passwords
* Multi-account definition
* System keychain integration
  * macOS keychain
  * Windows profile-based encryption
  * What the heck does Linux use for this?

## Misc

* Configuration persistence
* Configuration discovery
* `preview()` method for Emails
* MIME/HTML structure browser?
* Shortcut functions
* HtmlEmailBuilder
* CSS merging/incremental building
  * Semantic-aware CSS data structure
* Saving to email client Drafts?
* JMAP support?

## Doco and presentation

* Gallery of example emails
  * Requires ability to: generate email locally, open it in an email client, screencap it, all programmatically
    * Or maybe we could cheat and render just the body to a web page, like I want to do in Preview mode? No need to have From/To/Cc headers in all the gallery images
* Find some cooler plots
