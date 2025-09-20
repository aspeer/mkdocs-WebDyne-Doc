# Introduction

WebDyne is a Perl based dynamic HTML engine. It works with web servers
(or from the command line) to render HTML documents with embedded Perl
code.

Once WebDyne is installed and initialised any file with a `.psp`
extension is treated as a WebDyne source file. It is parsed for WebDyne
pseudo-tags (such as `<perl>` and `<block>`) which are interpreted and
executed on the server. The resulting output is then sent to the
browser.

WebDyne works with common web server persistent Perl interpreters - such
as Apache `mod_perl` and `PSGI` - to provide fast dynamic content. It
works with PSGI servers such as Plack and Starman, and can be
implemented as a Docker container to run HTML with embedded Perl code.

Pages are parsed once, then stored in a partially compiled format -
speeding up subsequent processing by avoiding the need to re-parse a
page each time it is loaded.

Alternate syntaxes are available to enable WebDyne code to be used with
editors that do not recognise custom HTML tags, and the syntax supports
the use of PHP type processing instruction tags (`<?..?>`) or `<div>`
tags (via data attributes such as `<div data-webdyne-perl>`) to define
WebDyne blocks.

Perl code can be co-mingled in the HTML code for "quick and dirty" pages
or completed isolated into separate files or modules for separation of
presentation and logic layers. You can see examples in a dedicated
section - but here are a few very simple examples as an overview.

Simple HTML file with Perl code embedded using WebDyne :

``` html
<html>
<head><title>Server Time</title></head>
<body>
The local server time is:
<perl> localtime() </perl>
</body>
</html>
```

[Run](https://app.webdyne.org/example/introduction1.psp)

This can be abbreviated with some shortcut tags such as `<start_html>`
in WebDyne. This does exactly the same thing:

``` html
<start_html title="Server Time">
The local server time is: <? localtime() ?>
```

[Run](https://app.webdyne.org/example/introduction2.psp)

Don't like the co-mingling code and HTML but still want things in one
file ?

``` html
<start_html title="Server Time">
The local server time is <? print_time() ?>
</html>
__PERL__
sub print_time {
    print(scalar localtime);
}
    
```

[Run](https://app.webdyne.org/example/introduction3.psp)

Want further code and HTML separation ? You can import methods from any
external Perl module. Example from a core module below, but could be any
installed CPAN module or your own code:

``` html
<start_html title="Server Time">
Server Time::HiRes time:
<perl require="Time::HiRes" import="time">time()</perl>
```

[Run](https://app.webdyne.org/example/introduction4.psp)

Same concepts implemented in slightly different ways:

``` html
<start_html title="Server Time">
The local server epoch time (hires) is: <? time() ?>
<end_html>
__PERL__
use Time::HiRes qw(time);
1;
```

[Run](https://app.webdyne.org/example/introduction5.psp)

``` html
<start_html title="Server Time">
<perl require="Time::HiRes" import="time"/>
The local server time (hires) is: <? time() ?>
```

[Run](https://app.webdyne.org/example/introduction6.psp)

Using an editor that doesn't like custom tags ? Use of the <div\> tag
with a `data-*` attribute is legal HTML syntax and can be used to embed
Perl:

``` html
<start_html title="Server Time">
The local server time is: <div data-webdyne-perl> localtime() </div>
```

[Run](https://app.webdyne.org/example/introduction7.psp)

