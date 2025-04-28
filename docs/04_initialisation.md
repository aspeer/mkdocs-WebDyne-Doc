# Initialisation

After installation Web Server configuration files must be updated so that the WebDyne software will be used to generate output when a .psp file is invoked. WebDyne comes bundled with an installer for Apache (`wdapacheinit`), and installers for selected other web servers (e.g. `WebDyne::Install::Lighttpd`) are available separately from CPAN.

Initialisation can be done via one of two methods:

Manual Initialisation

:   Web server configuration files can be hand-edited, and cache
    directories manualy created.

Script Initialisation

:   Scripts to automate the initialisation process for Apache and
    Lighttpd have been written - they will attempt to locate and update
    the Web Server config files (and create neccessary directories, set
    permissions etc.) as required. The scripts will work in common
    cases, but may have trouble on unusual distributions, or if a custom
    version of Apache (or other Web Server) is being used

Scripted installation is easiest if it works for your distribution - it will take care of all configuration file changes, directory permissions and ownership etc.

## Running `wdapacheinit` to initialise the software for use with Apache/mod_perl

Once the WebDyne software in installed it must be initialized. The `wdapacheinit` command must be run to update the Apache configuration files so that WebDyne pages will be correctly interpreted:

```
[root@localhost ~]# /opt/webdyne/bin/wdapacheinit

[install] - Installation source directory '/opt/webdyne'.
[install] - Using existing cache directory '/opt/webdyne/cache'.
[install] - Updating perl5lib config.
[install] - Writing Apache config file '/etc/httpd/conf.d/webdyne.conf'.
[install] - Granting Apache write access to cache directory.
[install] - Install completed.
```
 By default WebDyne will create a cache directory in `/var/cache/webdyne` on Linux systems when a default CPAN install is done (no PREFIX specified). If a PREFIX is specified the cache directory will be created as `PREFIX/cache`. Use the `--cache` command-line option to specify an alternate location.

Once `wdapacheinit` has been run the Apache server should be reloaded or restarted. Use a method appropriate for your Linux distribution.

```
[root@localhost ~]# service httpd restart
Stopping httpd:                                            [  OK  ]
Starting httpd:                                            [  OK  ]
```
 WebDyne should be now ready for use.

If the Apache service does not restart, examine the error log (usually `/var/log/httpd/error.log`) for details.

The script will look for Apache components (binary, configuration directories etc.) using common defaults. In the event that the script gives an error indicating that it cannot find a binary, directory or library you may need to specify the location manually. Run the script with the `--help` option to determine the appropriate syntax.

## Manual configuration of Apache

If the `wdapacheinit` command does not work as expected on your system the Apache config files can be modified manually.

Include the following section in the Apache httpd.conf file (or create a webdyne.conf file if you distribution supports conf.d style configuration files):

```
#  Put this in if WebDyne was installed using the PREFIX option to its own directory - replace
#  /opt/webdyne with the correct path to the perl5lib.pl library.
#
#  This will adjust the @INC path so all WebDyne modules (and modules WebDyne relies on) can be
#  located and loaded.
#  
#  Not needed if installed to default Perl library location, but does not hurt to leave in.
#
PerlRequire   "/opt/webdyne/bin/perl5lib.pl"


#  Preload the WebDyne and WebDyne::Compile module
#
PerlModule    WebDyne WebDyne::Compile


#  Associate psp files with WebDyne
#
AddHandler    perl-script    .psp
PerlHandler   WebDyne


#  Set a directory for storage of cache files. Make sure this exists already is writable by the 
#  Apache daemon process.
#
PerlSetVar    WEBDYNE_CACHE_DN    '/opt/webdyne/cache'


#  Allow Apache to access the cache directory if it needs to serve pre-compiled pages from there.
#
&lt;Directory "/opt/webdyne/cache"&gt;
Order allow,deny
Allow from all
Deny from none
&lt;/Directory&gt;
```


::: important
Substitute directory paths in the above example for the
relevant/correct/appropriate ones on your system.
:::

Create the cache directory and assign ownership and permission appropriate for your distribution (group name will vary by distribution - locate the correct one for your distribution)

```
[root@localhost ~]# mkdir /opt/webdyne/cache
[root@localhost ~]# chgrp apache /opt/webdyne/cache
[root@localhost ~]# chmod 770 /opt/webdyne/cache
```
 Restart Apache and check for any errors.

## Running `wdlighttpdinit` to initialise the software for use with Lighttpd/FastCGI

If using WebDyne with Lighttpd download and install the `WebDyne::Install::Lighttpd` module. Then run the `wdlighttpdinit` command to update the Lighttpd configuration files so that WebDyne pages will be correctly interpreted:

::: important
WebDyne depends on the Lighttpd mod_fastcgi module (on RPM systems the
package is sometimes called lighttpd-fastcgi). Please ensure the it is
installed before running the initialisation script.
:::

```
[root@localhost ~]# /opt/webdyne/bin/wdlighttpdinit

[install] - Installation source directory '/opt/webdyne'.
[install] - Using existing cache directory '/opt/webdyne/cache'.
[install] - Updating perl5lib config.
[install] - Writing Lighttpd config file '/etc/lighttpd/webdyne.conf'.
[install] - Lighttpd config file 'lighttpd_conf_fn'
[install] - Lighttpd config file '/etc/lighttpd/lighttpd.conf' updated.
[install] - Granting Lighttpd write access to cache directory.
[install] - Install completed.
```
 Once `wdlighttpinit` has been run the Lighttpd server should be reloaded or restarted. Use a method appropriate for your Linux distribution.

```
[root@localhost ~]# service lighttpd restart
Stopping lighttpd:                                            [  OK  ]
Starting lighttpd:                                            [  OK  ]
```
 WebDyne should be now ready for use.

If the Lighttpd service does not restart, examine the error log (usually `/var/log/lighttpd/error.log`) for details.

## Manual configuration of lighttpd

If the `wdlighttpdinit` command does not work on your system the Lighttpd config files can be modified manually..

Include the following section into the lighttpd configuration file:

```
#  Include the Lighttpd FastCGI module - make sure it is present on the system, install if not
#
#
server.modules += (
    "mod_fastcgi",
),


#  Register the psp extension with the FastCGI module
#
fastcgi.server = ( 

    ".psp" =&gt; ( 
        "localhost" =&gt; (

            #  Change paths as appropriate for your system, socket dir must be writable by
            #  Lighttpd daemon process owner.
            #
            "socket"           =&gt; "/opt/webdyne/cache/wdfastcgi-webdyne.sock",
            "bin-path"         =&gt; "/opt/webdyne/bin/wdfastcgi",

            #  Optional, must be writable by Lighttpd daemon process owner
            #
            "bin-environment"  =&gt; (
                "WEBDYNE_CACHE_DN"=&gt; "/opt/webdyne/cache"
            )
        )
    )
)
```
 # Getting Started/Basic Usage

Assuming the installation has completed with no errors you are now ready to start creating WebDyne pages and applications.

## Basics - integrating Perl into HTML

Some code fragments to give a very high-level overview of how WebDyne can be implemented. First the most basic usage example:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Note the perl tags --&gt;</span>

Hello World <span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span> localtime() <span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
</pre>



[Run](example/hello1.psp)

So far not too exciting - after all we are still mixing code and content. Lets try again:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Empty perl tag this time, but with method name as attribute --&gt;</span>

Hello World <span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">/&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123; return localtime &#125;
</pre>



[Run](example/hello2.psp)

Better - at least code and content are distinctly separated. Note that whatever the Perl code returns at the end of the routine is what is displayed. Although WebDyne will happily display returned strings or scalars, it is more efficient to return a scalar reference, e.g.:

```
#  Works
#
sub greeting { print "Hello World" }


#  Is the same as
#
sub greeting { return "Hello World }
sub greeting { my $var="Hello World"; return $var }


# But best is
#
sub greeting { my $var="Hello World"; return \$var }


# This will cause an error
#
sub greeting { return undef }


# If you don't want to display anything return \undef,
#
sub greeting { return \undef }


# This will fail also
#
sub greeting { return 0 }


#  If you want "0" to be displayed ..
#
sub greeting { return \0 }
```
 Perl code in WebDyne pages must always return a non-undef/non-0/non-empty string value (i.e. it must return something that evals as \"true\"). If the code returns a non-true value (e.g. 0, undef, \'\') then WebDyne assumes an error has occurred in the routine. If you actually want to run some Perl code, but not display anything, you should return a reference to undef, (`\undef)`, e.g.:

```
sub log { &amp;dosomething; return \undef }
```
 Up until now all the Perl code has been contained within the WebDyne file. The following example shows an instance where the code is contained in a separate Perl module, which should be available somewhere in the `@INC` path.

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Perl tag with call to external module method --&gt;</span>

Hello World <span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"MyModule::hello</span>"<span class="h-ab">/&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
</pre>



If not already resident the module (in this case \"MyModule\") will be loaded by WebDyne, so it must be available somewhere in the `@INC` path. The example above cannot be run because there is no \"MyModule\" package on this system.

## Use of the \<perl\> tag for in-line code.

The above examples show several variations of the `&lt;perl&gt;` tag in use. Perl code that is enclosed by `&lt;perl&gt;..&lt;/perl&gt;` tags is called *in-line* code:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">pre</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Perl tag containing perl code which generates output --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

for (0..3) &#123;
    print "Hello World\n"
&#125;

#  Must return a positive value, but don't want anything
#  else displayed, so use \undef
#
\undef;

<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>


<span class="h-ab">&lt;/</span><span class="h-tag">pre</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
</pre>



[Run](example/inline1.psp)

This is the most straight-forward use of Perl within a HTML document, but does not really make for easy reading - the Perl code and HTML are intermingled. It may be OK for quick scripts etc, but a page will quickly become hard to read if there is a lot of in-line Perl code interspersed between the HTML.

in-line Perl can be useful if you want a \"quick\" computation, e.g. insertion of the current year:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Very quick and dirty block of perl code --&gt;</span>

Copyright (C) <span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>(localtime())[5]+1900<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span> Foobar Gherkin corp.

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
</pre>



[Run](example/inline2.psp)

Which can be pretty handy, but looks a bit cumbersome - the tags interfere with the flow of the text, making it harder to read. For this reason in-line perl can also be flagged in a WebDyne page using the shortcuts `&amp;#033{&amp;#033&amp;#033}`, or by the use of processing instructions (**`&lt;? .. ?&gt;`**) e.g.:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Same code with alternative denotation --&gt;</span>

The time is: !&#123;! localtime() !&#125;

<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

The time is:  <span class="h-pi">&lt;? localtime() ?&gt;</span>


<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
</pre>



[Run](example/inline3.psp)

The `&amp;#033{&amp;#033&amp;#033}` denotation can also be used in tag attributes (processing instructions, and `&lt;perl&gt;` tags cannot):

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Perl code can be used in tag attributes also --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">font</span> <span class="h-attr">color</span>=<span class="h-attv">"!&#123;! (qw(red blue green))[rand 3] !&#125;</span>"<span class="h-ab">&gt;</span>

Hello World

<span class="h-ab">&lt;/</span><span class="h-tag">font</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
</pre>



[Run](example/inline4.psp)

## Use of the \<perl\> tag for non-inline code.

Any code that is not co-mingled with the HTML of a document is *non-inline* code. It can be segmented from the content HTML using the \_\_PERL\_\_ delimiter, or by being kept in a completely different package and referenced as an external Perl subroutine call. An example of non-inline code:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Empty perl tag this time, but with method name as attribute --&gt;</span>

Hello World <span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">/&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123; return localtime &#125;
</pre>



[Run](example/hello2.psp)

Note that the `&lt;perl&gt;` tag in this example is explicitly closed and does not contain any content. However non-inline code can enclose HTML or text within the tags:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- The perl method will be called, but "Hello World" will not be displayed ! --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>
Hello World 
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123; return localtime() &#125;
</pre>



[Run](example/noninline1.psp)

But this is not very interesting so far - the \"Hello World\" text is not displayed when the example is run !

In order for text or HTML within a non-inline perl block to be displayed, it must be \"rendered\" into the output stream by the WebDyne engine. This is done by calling the render() method. Let\'s try that again:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- The perl method will be called, and this time the "Hello World" will be displayed--&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>
Hello World 
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123;

    my $self=shift();
    $self->render();

&#125;
</pre>



[Run](example/noninline2.psp)

And again, this time showing how to render the text block multiple times. Note that an array reference is returned by the Perl routine - this is fine, and is interpreted as an array of HTML text, which is concatenated and send to the browser.

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- The "Hello World" text will be rendered multiple times --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
Hello World 
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123;

    my $self=shift();
    my @html;
    for (0..3) &#123; push @html, $self->render() &#125;;
    return \@html;
&#125;
</pre>



[Run](example/noninline3.psp)

## Passing parameters to subroutines

The behaviour of a called \_\_PERL\_\_ subroutine can be modified by passing parameters which it can act on:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- The "Hello World" text will be rendered with the param name --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>" <span class="h-attr">param</span>=<span class="h-attv">"Alice</span>"<span class="h-ab">/&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>" <span class="h-attr">param</span>=<span class="h-attv">"Bob</span>"<span class="h-ab">/&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- We can pass an array or hashref also - see variables section for more info on this syntax --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello_again</span>" <span class="h-attr">param</span>=<span class="h-attv">"%&#123; firstname=>'Alice', lastname=>'Smith' &#125;</span>"<span class="h-ab">/&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123;

    my ($self, $param)=@_;
    return \"Hello world $param"
&#125;

sub hello_again &#123;

    my ($self, $param_hr)=@_;
    my $firstname=$param_hr->&#123;'firstname'&#125;;
    my $lastname =$param_hr->&#123;'lastname'&#125;;
    return \"Hello world $firstname $lastname";

&#125;</pre>



[Run](example/noninline7.psp)

## Notes about \_\_PERL\_\_ sections

Code in \_\_PERL\_\_ sections has some particular properties. \_\_PERL\_\_ code is only executed once. Subroutines defined in a \_\_PERL\_\_ section can be called as many times as you want, but the code outside of subroutines is only executed the first time a page is loaded. No matter how many times it is run, in the following code `$i` will always be 1:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">/&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">/&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

my $i=0;
$i++;

my $x=0;

sub hello &#123;

    #  Note x may not increment as you expect because you will probably
    #  get a different Apache process each time you load this page
    #
    return sprintf("value of i: $i, value of x in PID $$: %s", $x++)
&#125;
</pre>



[Run](example/noninline4.psp)

Lexical variables are not accessible outside of the \_\_PERL\_\_ section due to the way perl\'s eval() function works. The following example will fail:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>

The value of $i is !&#123;! \$i !&#125;

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

my $i=5;</pre>



[Run](example/noninline5.psp)

Package defined vars declared in a \_\_PERL\_\_ section do work, with caveats:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Does not work --&gt;</span>
The value of $i is !&#123;! \$::i !&#125;
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Ugly hack, does work though --&gt;</span>
The value of $i is !&#123;! \$&#123;__PACKAGE__.::i&#125; !&#125;
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Probably best to just do this though --&gt;</span>
The value of $i is !&#123;! &get_i() !&#125;
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Or this - see variable substitution section  --&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"render_i</span>"<span class="h-ab">&gt;</span>
The value of $i is $&#123;i&#125;
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

our $i=5;

sub get_i &#123; \$i &#125;

sub render_i &#123; shift()->render(i=>$i) &#125;</pre>



[Run](example/noninline6.psp)

See the Variables/Substitution section for clean ways to insert variable contents into the page.

## Variables / Substitution

WebDyne starts to get more useful when variables are used to modify the content of a rendered text block. A simple example:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- The var $&#123;time&#125; will be substituted for the correspondingly named render parameter --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>
Hello World $&#123;time&#125;
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123; 
    my $self=shift();
    my $time=localtime();
    $self->render( time=>$time );
&#125;
</pre>



[Run](example/var1.psp)

Note the passing of the `time` value as a parameter to be substituted when the text is rendered.

Combine this with multiple call to the render() routine to display dynamic data:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Multiple variables can be supplied at once as render parameters --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello0</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
Hello World $&#123;time&#125;, loop iteration $&#123;i&#125;.
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">br</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">br</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello1</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
Hello World $&#123;time&#125;, loop iteration $&#123;i&#125;.
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello0 &#123;

    my $self=shift();
    my @html;
    my $time=localtime();
    for (my $i=0; $i<3; $i++) &#123; 
        push @html, $self->render( time=>$time, i=>$i) 
    &#125;;
    return \@html;
&#125;

sub hello1 &#123;

    #  Alternate syntax using print
    #
    my $self=shift();
    my $time=localtime();
    for (my $i=0; $i<3; $i++) &#123; 
        print $self->render( time=>$time, i=>$i)
    &#125;;
    return \undef
&#125;
</pre>



[Run](example/var2.psp)

Variables can also be used to modify tag attributes:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Render paramaters also work in tag attributes --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">font</span> <span class="h-attr">color</span>=<span class="h-attv">"$&#123;color&#125;</span>"<span class="h-ab">&gt;</span>
Hello World
<span class="h-ab">&lt;/</span><span class="h-tag">font</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123;

    my $self=shift();
    my @html;
    for (0..3) &#123;
        my $color=(qw(red green yellow blue orange))[rand 5];
        push @html, $self->render( color=>$color );
    &#125;
    \@html;

&#125;
</pre>



[Run](example/var3.psp)

Other variable types are available also, including:

    - `&amp;#064{var,var,..}` for arrays, e.g. `&amp;#064{'foo', 'bar'}`
    - `&amp;#037{key=&gt;value, key=&gt;value, ..}` for hashes e.g.`&amp;#037{ a=&gt;1, b=&gt;2 }`
    - `&amp;#043{varname}` for CGI form parameters, e.g. `&amp;#043{firstname}`
    - `&amp;#042{varname}`for environment variables, e.g. `&amp;#042{HTTP_USER_AGENT}`
    - `&amp;#094{requestmethod}` for Apache request (`$r=Apache-&gt;request`) object
    methods, e.g. `&amp;#094{protocol}`. Only available for in Apache/mod_perl,
    and only useful for request methods that return a scalar value.

The following template uses techniques and tags discussed later, but should provide an example of potential variable usage:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Variables<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Environment variables --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-com">&lt;!-- Short Way --&gt;</span>
Mod Perl Version: *&#123;MOD_PERL&#125;
<span class="h-ab">&lt;</span><span class="h-tag">br</span><span class="h-ab">&gt;</span>
<span class="h-com">&lt;!-- Same as Perl code --&gt;</span>
Mod Perl Version: 
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span> \$ENV&#123;'MOD_PERL'&#125; <span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>


<span class="h-com">&lt;!-- Apache request record methods. Only methods that return a scalar result are usable --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-com">&lt;!-- Short Way --&gt;</span>
Request Protocol: ^&#123;protocol&#125;
<span class="h-ab">&lt;</span><span class="h-tag">br</span><span class="h-ab">&gt;</span>
<span class="h-com">&lt;!-- Same as Perl code --&gt;</span>
Request Protocol: 
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span> my $self=shift(); my $r=$self->r(); \$r->protocol() <span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>


<span class="h-com">&lt;!-- CGI params --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>
Your Name: <span class="h-ab">&lt;</span><span class="h-cgi_tag">textfield</span> <span class="h-attr">name</span>=<span class="h-attv">"name</span>" <span class="h-attr">default</span>=<span class="h-attv">"Test</span>" <span class="h-attr">size</span>=<span class="h-attv">"12</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">submit</span> <span class="h-attr">name</span>=<span class="h-attv">"Submit</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-com">&lt;!-- Short Way --&gt;</span>
You Entered: +&#123;name&#125;
<span class="h-ab">&lt;</span><span class="h-tag">br</span><span class="h-ab">&gt;</span>
<span class="h-com">&lt;!-- Same as Perl code --&gt;</span>
You Entered: 
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span> my $self=shift(); my $cgi_or=$self->CGI(); \$cgi_or->param('name') <span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">br</span><span class="h-ab">&gt;</span>
<span class="h-com">&lt;!-- CGI vars are also loaded into the %_ global var, so the above is the same as --&gt;</span>
You Entered: 
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span> \$_&#123;'name'&#125; <span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>


<span class="h-com">&lt;!-- Arrays --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
Favourite colour 1:
<span class="h-ab">&lt;</span><span class="h-cgi_tag">popup_menu</span> <span class="h-attr">name</span>=<span class="h-attv">"popup_menu</span>" <span class="h-attr">values</span>=<span class="h-attv">"@&#123;qw(red green blue)&#125;</span>"<span class="h-ab">&gt;</span>


<span class="h-com">&lt;!-- Hashes --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
Favourite colour 2:
<span class="h-ab">&lt;</span><span class="h-cgi_tag">popup_menu</span> <span class="h-attr">name</span>=<span class="h-attv">"popup_menu</span>" 
    <span class="h-attr">values</span>=<span class="h-attv">"%&#123;red=>Red, green=>Green, blue=>Blue&#125;</span>"<span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

</pre>



[Run](example/var4.psp)

## Integration with Lincoln Stein\'s CGI.pm module

WebDyne makes extensive use of Lincoln Stein\'s CGI.pm module. Almost any CGI.pm function that renders HTML tags can be called from within a WebDyne template. The manual page for CGI.pm contains the following synopsis example:

```
use CGI qw/:standard/;
   print header,
         start_html('A Simple Example'),
         h1('A Simple Example'),
         start_form,
         "What's your name? ",textfield('name'),p,
         "What's the combination?", p,
         checkbox_group(-name=&gt;'words',
                        -values=&gt;['eenie','meenie','minie','moe'],
                        -defaults=&gt;['eenie','minie']), p,
         "What's your favorite color? ",
         popup_menu(-name=&gt;'color',
                    -values=&gt;['red','green','blue','chartreuse']),p,
         submit,
         end_form,
         hr;

    if (param()) {
        print "Your name is",em(param('name')),p,
              "The keywords are: ",em(join(", ",param('words'))),p,
```
 If the example was ported to a WebDyne compatible page it might look something like this:

<pre>
<span class="h-com">&lt;!-- The same form from the CGI example --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-cgi_tag">start_html</span> <span class="h-attr">title</span>=<span class="h-attv">"A simple example</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">h1</span><span class="h-ab">&gt;</span>A Simple Example<span class="h-ab">&lt;/</span><span class="h-tag">h1</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">start_form</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
What's your name ? <span class="h-ab">&lt;</span><span class="h-cgi_tag">textfield</span> <span class="h-attr">name</span>=<span class="h-attv">"name</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
What's the combination ? <span class="h-ab">&lt;</span><span class="h-cgi_tag">checkbox_group</span> 
    <span class="h-attr">name</span>=<span class="h-attv">"words</span>" <span class="h-attr">values</span>=<span class="h-attv">"@&#123;qw(eenie meenie minie moe)&#125;</span>" <span class="h-attr">defaults</span>=<span class="h-attv">"@&#123;qw(eenie minie)&#125;</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
What's your favourite color ? <span class="h-ab">&lt;</span><span class="h-cgi_tag">popup_menu</span> 
    <span class="h-attr">name</span>=<span class="h-attv">"color</span>" <span class="h-attr">values</span>=<span class="h-attv">"@&#123;qw(red green blue chartreuse)&#125;</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">submit</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">end_form</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">hr</span><span class="h-ab">&gt;</span>


<span class="h-com">&lt;!-- This section only rendered when form submitted --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"answers</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
Your name is: <span class="h-ab">&lt;</span><span class="h-tag">em</span><span class="h-ab">&gt;</span>+&#123;name&#125;<span class="h-ab">&lt;/</span><span class="h-tag">em</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
The keywords are: <span class="h-ab">&lt;</span><span class="h-tag">em</span><span class="h-ab">&gt;</span>$&#123;words&#125;<span class="h-ab">&lt;/</span><span class="h-tag">em</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
Your favorite color is: <span class="h-ab">&lt;</span><span class="h-tag">em</span><span class="h-ab">&gt;</span>+&#123;color&#125;<span class="h-ab">&lt;/</span><span class="h-tag">em</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub answers &#123;

    my $self=shift();
    my $cgi_or=$self->CGI();
    if ($cgi_or->param()) &#123;
        my $words=join(",", $cgi_or->param('words'));
        return $self->render( words=>$words )
    &#125;
    else &#123;
        return \undef;
    &#125;

&#125;
</pre>



[Run](example/cgi1.psp)

## More on CGI.pm generated tags

We can use CGI.pm tags such as \<popup_menu\>, instead of \<select\>\<option\>\...\</select\>. The following example:

```
&lt;popup_menu value="&amp;#037{red=&gt;Red, green=&gt;Green, blue=&gt;Blue}"/&gt;
```
 is arguably easier to read than:

```
&lt;select name="values" tabindex="1"&gt;
&lt;option value="green"&gt;Green&lt;/option&gt;
&lt;option value="blue"&gt;Blue&lt;/option&gt;
&lt;option value="red"&gt;Red&lt;/option&gt;
&lt;/select&gt;
```
 So there is some readability benefit, however the real advantage shows when we consider the next example:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Generate all country names for picklist --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>

Your Country ?
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"countries</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">popup_menu</span> <span class="h-attr">values</span>=<span class="h-attv">"$&#123;countries_ar&#125;</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

use Locale::Country;

sub countries &#123;

    my $self=shift();
    my @countries = sort &#123; $a cmp $b &#125; all_country_names();
    $self->render( countries_ar=>\@countries );

&#125;
</pre>



[Run](example/cgi5.psp)

That saved a lot of typing !

## Access to CGI query, form and keyword parameters

As mentioned above WebDyne makes extensive use of the CGI.pm Perl module. You can access a CGI object instance in any WebDyne template by calling the CGI() method:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Note use of CGI.pm derived textfield tag --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>
Enter your name: <span class="h-ab">&lt;</span><span class="h-cgi_tag">textfield</span> <span class="h-attr">name</span>=<span class="h-attv">"name</span>"<span class="h-ab">&gt;</span>
<span class="h-ent">&amp;nbsp;</span>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">submit</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>


<span class="h-com">&lt;!-- And print out name if we have it --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>
Hello $&#123;name&#125;, pleased to meet you.
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123; 
    my $self=shift();

    #  Get CGI instance
    #
    my $cgi_or=$self->CGI();

    #  Use CGI.pm param() method. Could also use other
    #  methods like keywords(), Vars() etc.
    #
    my $name=$cgi_or->param('name');

    $self->render( name=>$name);
&#125;
</pre>



[Run](example/cgi3.psp)

From there you can all any method supported by the CGI.pm module - see the CGI.pm manual page (`man CGI`)

Since one of the most common code tasks is to access query parameters, WebDyne stores them in the `%_` global variable before any user defined Perl methods are called. For example:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>
Enter your name: <span class="h-ab">&lt;</span><span class="h-cgi_tag">textfield</span> <span class="h-attr">name</span>=<span class="h-attv">"name</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">submit</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Quick and dirty, no perl code at all --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
Hello +&#123;name&#125;, pleased to meet you.


<span class="h-com">&lt;!-- Traditional, using the CGI.pm param() call --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello1</span>"<span class="h-ab">&gt;</span>
Hello $&#123;name&#125;, pleased to meet you.
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>


<span class="h-com">&lt;!-- Quicker method using %_ global var --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello2</span>"<span class="h-ab">&gt;</span>
Hello $&#123;name&#125;, pleased to meet you.
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>


<span class="h-com">&lt;!-- Quick and dirty using inline Perl --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
Hello !&#123;! \$_&#123;name&#125; !&#125;, pleased to meet you.

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>


&#095&#095PERL&#095&#095

sub hello1 &#123; 
    my $self=shift();
    my $cgi_or=$self->CGI();
    my $name=$cgi_or->param('name');
    $self->render( name=>$name);
&#125;

sub hello2 &#123; 

    my $self=shift();

    #  Quicker method of getting name param
    #
    my $name=$_&#123;'name'&#125;;
    $self->render( name=>$name);
&#125;

</pre>



[Run](example/cgi4.psp)

## Quick Pages using CGI.pm\'s \<start_html\>\<end_html\> tags

For rapid development you can take advantage of CGI.pm\'s \<start_html\> and \<end_html\> tags. The following page generates compliant HTML (view the page source after loading it to see for yourself):

<pre>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">start_html</span> <span class="h-attr">title</span>=<span class="h-attv">"Quick Page</span>"<span class="h-ab">&gt;</span>
The time is: !&#123;! localtime() !&#125;
<span class="h-ab">&lt;</span><span class="h-cgi_tag">end_html</span><span class="h-ab">&gt;</span></pre>



[Run](example/cgi6.psp)

The \<start_html\> tag generates all the \<html\>, \<head\>, \<title\> tags etc needed for a valid HTML page plus an opening body tag. Just enter the body content, then finish with \<end_html\> to generate the closing \<body\> and \<html\> tags. See the CGI.pm manual page for more information.

