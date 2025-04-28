# WebDyne API

## WebDyne tags

Reference of WebDyne tags and supported attributes

\<perl\>

:   Run Perl code either in-line (between the \<perl\>..\</perl\>) tags,
    or non-inline via the method attribute

```
method=\[Module::Name\]::method

:   *Optional*. Call an external perl subroutine in a pre-loaded
    module, or a subroutine in a \_\_PERL\_\_ block at then of the
    HTML: file

param=scalar\|array\|hash

:   *Optional*. Parameters to be supplied to perl routine. Supply
    array and hash using \&#064{1,2} and &amp;#037{a=\>1, b=\>2} conventions
    respectively.

static=1

:   *Optional*. This Perl code to be run once only and the output
    cached for all subsequent requests.
```
 \<block\>

:   Block of HTML code to be optionally rendered if desired by call to
    render_block Webdyne method:

```
name=identifier

:   *Mandatory*. The name for this block of HTML.

display=1

:   *Optional.* Force display of this block even if not invoked by
    render_block WebDyne method. Useful for prototyping.

static=1

:   *Optional*. This block rendered once only and the output cached
    for all subsequent requests
```
 \<include\>

:   Include HTML or text from an external file

```
file=filename

:   *Mandatory*. Name of file we want to include. Can be relative to
    current directory or absolute path.

head=1

:   *Optional*. File is an HTML file and we want to include just the
    \<head\> section

body=1

:   *Optional*. File is an HTML file and we want to include just the
    \<body\> section.

block=blockname

:   *Optional*. File is a .psp file and we want to include a
    \<block\> section from that file.
```
 \<dump\>

:   Display CGI paramters in dump format via CGI-\>Dump call. Useful for
    debugging. Only rendered if `$WEBDYNE_DUMP_FLAG` global set to 1 in
    WebDyne constants (see below)

```
display=1

:   *Optional.* Force display even if `$WEBDYNE_DUMP_FLAG` global
    not set
```
 ## WebDyne methods

When running Perl code within a WebDyne page the very first parameter passed to any routine (in-line or in a \_\_PERL\_\_ block) is an instance of the WebDyne page object (referred to as `$self` in most of the examples). All methods return undef on failure, and raise an error using the `err()` function. The following methods are available to any instance of the WebDyne object:

CGI()

:   Returns an instance of the CGI.pm object for the current request.

r(), request()

:   Returns an instance of the Apache request object.

render( \<key=\>value, key=\>value\>, .. )

:   Called to render the text or HTML between \<perl\>..\</perl\> tags.
    Optional key and value pairs will be substituted into the output as
    per the variable section. Returns a scalar ref of the resulting
    HTML.

render_block( blockname, \<key=\>value, key=\>value, ..\>).

:   Called to render a block of text or HTML between
    \<block\>..\</block\> tags. Optional key and value pairs will be
    substituted into the output as per the variable section. Returns
    scalar ref of resulting HTML if called with from \<perl\>..\</perl\>
    section containing the block to be rendered, or true (\\undef) if
    the block is not within the \<perl\>..\</perl\> section (e.g.
    further into the document, see the block section for an example).

redirect({ uri=\>uri \| file=\>filename \| html=\>\\html_text })

:   Will redirect to URI or file nominated, or display only nominated
    text. Any rendering done to prior to this method is abandoned.

cache_inode( \<seed\> )

:   Returns the page unique ID (UID). Called inode for legacy reasons,
    as that is what the UID used to be based on. If a seed value is
    supplied a new UID will be generated based on an MD5 of the seed.
    Seed only needs to be supplied if using advanced cache handlers.

cache_mtime( \<uid\> )

:   Returns the mtime (modification time) of the cache file associated
    with the optionally supplied UID. If no UID supplied the current one
    will be used. Can be used to make cache compile decisions by
    WebDyne::Cache code (e.g if page \> x minutes old, recompile).

cache_compile( )

:   Force recompilation of cache file. Can be used in cache code to
    force recompilation of a page, even if it is flagged static. Returns
    current value if no parameters supplied, or sets if parameter
    supplied.

no_cache()

:   Send headers indicating that the page is not be cached by the
    browser or intermediate proxies. By default WebDyne pages
    automatically set the no-cache headers, although this behaviour can
    be modified by clearing the `$WEBDYNE_NO_CACHE` variable and using
    this function

meta()

:   Return a hash ref containing the meta data for this page.
    Alterations to meta data are persistent for this process, and carry
    across Apache requests (although not across different Apache
    processes)

## WebDyne Constants

Constants defined in the WebDyne::Constant package control various aspects of how WebDyne behaves. Constants can be modified globally by altering a system file (`/etc/webdyne.pm` under Linux distros), or by altering configuration parameters within the Apache or lighttpd/FastCGI web servers.

### Global constants file

WebDyne will look for a system constants file under `/etc/webdyne.pm` and set package variables according to values found in that file. The file is in Perl Data::Dumper format, and takes the format:

```
# sample /etc/webdyne.pm file
#
$VAR1={
        WebDyne::Constant =&gt; {

                WEBDYNE_CACHE_DN       =&gt; '/data1/webdyne/cache',
                WEBDYNE_STORE_COMMENTS =&gt; 1,
                #  ... more variables for WebDyne package

       },

       WebDyne::Session::Constant =&gt; {

                WEBDYNE_SESSION_ID_COOKIE_NAME =&gt; 'session_cookie',
                #  ... more variables for WebDyne::Session package

       },

};
```
 The file is not present by default and should be created if you wish to change any of the WebDyne constants from their default values.

::: important
Always check the syntax of the `/etc/webdyne.pm` file after editing by
running `perl -c -w /etc/webdyne.pm` to check that the file is readable
by Perl.
:::

### Setting WebDyne constants in Apache

WebDyne constants can be set in an Apache httpd.conf file using the PerlSetVar directive:

```
PerlHandler     WebDyne
PerlSetVar      WEBDYNE_CACHE_DN                '/data1/webdyne/cache'
PerlSetVar      WEBDYNE_STORE_COMMENTS          1

#  From WebDyne::Session package
#
PerlSetVar      WEBDYNE_SESSION_ID_COOKIE_NAME  'session_cookie'
```


::: important
WebDyne constants cannot be set on a per-location or per-directory
basis - they are read from the top level of the config file and set
globally.

Some 1.x versions of mod_perl do not read PerlSetVar variables correctly. If you encounter this problem use a \<Perl\>..\</Perl\> section in the httpd.conf file, e.g.:

```
# Mod_perl 1.x

PerlHandler     WebDyne
&lt;Perl&gt;
$WebDyne::Constant::WEBDYNE_CACHE_DN='/data1/webdyne/cache';
$WebDyne::Constant::WEBDYNE_STORE_COMMENTS=1;
$WebDyne::Session::Constant::WEBDYNE_SESSION_ID_COOKIE_NAME='session_cookie';
&lt;/Perl&gt;
```


:::

### Setting WebDyne constants in lighttpd/FastCGI

WebDyne constants can be set in lighttpd/FastCGI using the bin-environment directive. Here is a sample lighttpd.conf file showing WebDyne constants:

```
fastcgi.server = ( ".psp" =&gt;
                   ( "localhost" =&gt;
                      (
                        "socket" =&gt; "/tmp/psp-fastcgi.socket",
                        "bin-path" =&gt; "/opt/webdyne/bin/wdfastcgi",
                        "bin-environment"     =&gt; (
                          "WEBDYNE_CACHE_DN   =&gt; "/data1/webdyne/cache"
                        )
                     )
                   )
                 )
```
 ### Constants Reference

The following constants can be altered to change the behaviour of the WebDyne package. All these constants reside in the `WebDyne::Constant` package namespace.

`$WEBDYNE_CACHE_DN`

:   The name of the directory that will hold partially compiled WebDyne
    cache files. Must exist and be writable by the Apache process

`$WEBDYNE_STARTUP_CACHE_FLUSH`

:   Remove all existing disk cache files at Apache startup. 1=yes
    (default), 0=no. By default all disk cache files are removed at
    startup, and thus pages must be recompiled again the first time they
    are viewed. If you set this to 0 (no) then disk cache files will be
    saved between startups and pages will not need to be re-compiled if
    Apache is restarted.

`$WEBDYNE_CACHE_CHECK_FREQ`

:   Check the memory cache after this many request (per-process
    counter). default=256. After this many requests a housekeeping
    function will check compiled pages that are stored in memory and
    remove old ones according to the criteria below.

`$WEBDYNE_CACHE_HIGH_WATER`

:   Remove compiled from pages from memory when we have more than this
    many. default=64

`$WEBDYNE_CACHE_LOW_WATER`

:   After reaching HIGH_WATER delete until we get down to this amount.
    default=32

`$WEBDYNE_CACHE_CLEAN_METHOD`

:   Clean algorithm. default=1, means least used cleaned first, 0 means
    oldest last view cleaned first

`$WEBDYNE_EVAL_SAFE`

:   default=0 (no), If set to 1 means eval in a Safe.pm container.

`$WEBDYNE_EVAL_SAFE_OPCODE_AR`

:   The opcode set to use in Safe.pm evals (see the Safe man page).
    Defaults to \"\[\':default\'\]\". Use \[&Opcode::full_opset()\] for
    the full opset. CAUTION Use of WebDyne with Safe.pm not
    comprehensively tested.

`$WEBDYNE_EVAL_USE_STRICT`

:   The string to use before each eval. Defaults to \"use strict
    qw(vars);\". Set to undef if you do not want strict.pm. In Safe mode
    this becomes a flag only - set undef for \"no strict\", and
    non-undef for \"use strict\" equivalence in a Safe mode (checked
    under Perl 5.8.6 only, results in earlier versions of Perl may
    vary).

`$WEBDYNE_STRICT_VARS`

:   Check if a var is declared in a render block (e.g \$ {foo}) but not
    supplied as a render parameter. If so will throw an error. Set to 0
    to ignore. default=1

`$WEBDYNE_DUMP_FLAG`

:   If 1, any instance of the special \<dump\> tag will print out
    results from CGI-\>dump(). Use when debugging forms. default=0

`$WEBDYNE_DTD`

:   The DTD to place at the top of a rendered page. Defaults to:
    \<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"
    \"http://www.w3.org/TR/html4/loose.dtd\"\>

`$WEBDYNE_HTML_PARAM`

:   attributes for the \<html\> tag, e.g. { lang =\>\'en-US\' }. undef
    by default

`$WEBDYNE_COMPILE_IGNORE_WHITESPACE`

:   Ignore source file whitespace as per HTML::TreeBuilder
    ignore_ignorable_whitespace function. Defaults to 1

`$WEBDYNE_COMPILE_NO_SPACE_COMPACTING`

:   Do not compact source file whitespace as per HTML::TreeBuilder
    no_space_compacting function. Defaults to 0

`$WEBDYNE_STORE_COMMENTS`

:   By default comments are not rendered. Set to 1 to store and display
    comments from source files. Defaults to 0

`$WEBDYNE_NO_CACHE`.

:   WebDyne should send no-cache HTTP headers. Set to 0 to not send such
    headers. Defaults to 1

`$WEBDYNE_DELAYED_BLOCK_RENDER`

:   By default WebDyne will render blocks targeted by a render_block()
    call, even those that are outside the originating
    \<perl\>..\</perl\> section that made the call. Set to 0 to not
    render such blocks. Defaults to 1

`$WEBDYNE_WARNINGS_FATAL`

:   If a programs issues a warning via warn() this constant determines
    if it will be treated as a fatal error. Default is 0 (warnings not
    fatal). Set to 1 if you want any warn() to behave as if die() had
    been called..

`$WEBDYNE_CGI_DISABLE_UPLOADS`

:   Disable CGI.pm file uploads. Defaults to 1 (true - do not allow
    uploads).

`$WEBDYNE_CGI_POST_MAX`

:   Maximum size of a POST request. Defaults to 512Kb

`$WEBDYNE_ERROR_TEXT`

:   Display simplified errors in plain text rather than using HTML.
    Useful in interal WebDyne development only. By default this is 0 =\>
    the HTML error handler will be used.

`$WEBDYNE_ERROR_SHOW`

:   Display the error message. Only applicable in the HTML error handler

`$WEBDYNE_ERROR_SOURCE_CONTEXT_SHOW`

:   Display a fragment of the .psp source file around where the error
    occurred to give some context of where the error happened. Set to 0
    to not display context.

`$WEBDYNE_ERROR_SOURCE_CONTEXT_LINES_PRE`

:   Number of lines of the source file before the error occurred to
    display. Defaults to 4

`$WEBDYNE_ERROR_SOURCE_CONTEXT_LINES_POST`

:   Number of lines of the source file after the error occurred to
    display. Defaults to 4

`$WEBDYNE_ERROR_SOURCE_CONTEXT_LINE_FRAGMENT_MAX`

:   Max line length to show. Defaults to 80 characters.

`$WEBDYNE_ERROR_BACKTRACE_SHOW`

:   Show a backtrace of modules through which the error propagated. On
    by default, set to 0 to disable,

`$WEBDYNE_ERROR_BACKTRACE_SHORT`

:   Remove WebDyne internal modules from backtrace. Off by default, set
    to 1 to enable.

`$WEBDYNE_AUTOLOAD_POLLUTE`

:   When a method is called from a \<perl\> routine the WebDyne AUTOLOAD
    method must search multiple modules for the method owner. Setting
    this flag to 1 will pollute the WebDyne name space with the method
    name so that AUTOLOAD is not called if that method is used again
    (for the duration of the Perl process, not just that call to the
    page). This is dangerous and can cause confusion if different
    modules use the same name. In very strictly controlled
    environments - and ebev then only in some cases - it can result is
    faster throughput. Off by default, set to 1 to enable.

Extension modules (e.g., WebDyne::Session) have their own constants - see each package for details.

## WebDyne Directives

A limited number of directives are are available which change the way WebDyne processes pages. Directives are set in either the Apache or lighttpd .conf files and can be set differently per location. At this stage only one directive applies to the core WebDyne module:

`WebDyneHandler`

:   The name of the handler that WebDyne should invoke instead of
    handling the page internally. The only other handler available today
    is WebDyne::Chain.

This directive exists primarily to allow lighttpd/FastCGI to invoke WebDyne::Chain as the primary handler. An example from the lighttpd.conf file (see the WebDyne::Chain documentation for information on the `WebDyneChain` directive):

```
fastcgi.server = ( ".psp" =&gt;
                   ( "localhost" =&gt;
                      (
                        "socket" =&gt; "/tmp/psp-fastcgi.socket",
                        "bin-path" =&gt; "/opt/webdyne/bin/wdfastcgi",
                        "bin-environment"     =&gt; (
                          #  Handle WebDyne requests via WebDyne::Chain, which in turn will
                          #  pass all requests through WebDyne::Session so that a unique session 
                          #  cookie is assigned to each user.
                          "WebDyneHandler"    =&gt; "WebDyne::Chain",
                          "WebDyneChain"      =&gt; "WebDyne::Session",
                        )
                     )
                   )
                 )
```
 It can be used in Apache httpd.conf files, but is not very efficient:

```
#  This will work, but is not very efficient
#
&lt;location /shop/&gt;
PerlHandler     WebDyne
PerlSetVar      WebDyneHandler               'WebDyne::Chain'
PerlSetVar      WebDyneChain                 'WebDyne::Session'
&lt;/location&gt;


#  This is the same, and is more efficient
#
&lt;location /shop/&gt;
PerlHandler     WebDyne::Chain
PerlSetVar      WebDyneChain                 'WebDyne::Session'
&lt;/location&gt;
```
 As with Apache you can do per-location/directory configuration of WebDyne, however the configuration is a little more complex. The example below shows how to set different directives on a per location basis, using WebDyne and WebDyne::Chain directives as examples:

```
$HTTP["url"] =~"^/proxcube/" {

        server.document-root = "/opt/proxcube/lib/perl5/site_perl/5.8.6/ProxCube/HTML/html/",

        fastcgi.server = (

                ".psp" =&gt; (
                        "localhost" =&gt; (
                                "socket"      =&gt; "/tmp/psp-fastcgi-proxube.socket",
                                "bin-path"    =&gt; "/opt/webdyne/bin/wdfastcgi",
                                "bin-environment" =&gt; (
                                        "WebDyneHandler"  =&gt; "WebDyne::Chain",
                                        "WebDyneChain"    =&gt; "ProxCube::HTML ProxCube::License"
                                        "WebDyneTemplate" =&gt; "/opt/proxcube/lib/perl5/site_perl/5...
                                        "WebDyneFilter"   =&gt; "WebDyne::Template WebDyne::CGI",
                                        "MenuData"        =&gt; "/opt/proxcube/lib/perl5/site_perl/5...
                                        "WebDyneLocation" =&gt; "/proxcube/"
                                )
                        )
                )
        )

},


$HTTP["url"] =~"^/example/" {

        server.document-root = "/var/www/html/",

        fastcgi.server = (

                ".psp" =&gt; (
                        "localhost" =&gt; (
                                "socket"      =&gt; "/tmp/psp-fastcgi-example.socket",
                                "bin-path"    =&gt; "/opt/webdyne/bin/wdfastcgi",
                                "bin-environment" =&gt; (
                                        "WebDyneLocation" =&gt; "/example/"
                                )
                        )
                )
        )
}
```


::: important
As noted in the configuration file the socket file names must be unique
for each location that you want different WebDyne directives/constants
for.
:::

