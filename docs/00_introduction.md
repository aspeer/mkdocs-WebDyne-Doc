# Introduction

WebDyne is a Perl based dynamic HTML engine. It works with web servers (or from the command line) to render HTML documents with embedded Perl code.

Once WebDyne is installed and initialised to work with a web server any file with a `.psp` extension is treated as a WebDyne source file. It is parsed for WebDyne or HTML shortcut pseudo-tags (such as `&lt;perl&gt;` and `&lt;block&gt;` for WebDyne, or `&lt;start_html&gt;`,`&lt;popup_menu&gt;` shortcuts) which are interpreted and executed on the server. The resulting output is then sent to the browser.

Pages are parsed once, then optionally stored in a partially compiled format - speeding up subsequent processing by avoiding the need to re-parse a page each time it is loaded. WebDyne works with common web server persistant/resident Perl modules such as mod_perl and PSGI to provide fast dynamic content.

Alternate syntaxes are available to enable WebDyne code to be used with editors that do no recognise custom HTML tags, and the syntax supports the use of PHP type processing instruction tags (`&lt;? perl ?&gt;`) or `&lt;div&gt;` tags (via data attributes such as `&lt;div data-webdyne-perl&gt;`) to define WebDyne blocks

