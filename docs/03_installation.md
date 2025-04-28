# Installation

WebDyne can be installed via the following methods:

Perl CPAN

:   Install from the Perl CPAN library. Installs dependencies if
    required (also via CPAN). Use this method if you are familiar with
    CPAN. Destination of the installated files is dependent on the local
    CPAN configuration, however in most cases it wil be to the Perl site
    library location. WebDyne supports installation to an alternate
    location using the PREFIX option in CPAN. Binaries are usually
    installed to `/usr/bin` or `/usr/local/bin` by CPAN, but may vary by
    distribution/local configuration.

```
Assuming your CPAN environment is setup correctly you can run the
command:

`perl -MCPAN -e "install WebDyne"`

To install the base WebDyne module, which includes the Apache
installer.

To get the installer for Lighttpd (after the base package above is
installed) run

`perl -MCPAN -e "install WebDyne::Install::Lighttpd"`

To get the complete suite of WebDyne modules, including all
installers and externsion modules (Session manager etc.) run:

`perl -MCPAN -e "install Bundle::WebDyne"`
```


::: important
WebDyne must be initialised after installation. To get started quickly
run `wdapacheinit` after CPAN installation to setup WebDyne for an
Apache/mod_perl environment, or `wdlighttpdinit` for a Lighttpd/FastCGI
environment (make sure the Lighttpd FastCGI module is installed - it is
often packaged as a separate component in many Linux distributions). See
the [initialisation](#sect1-initialisation) section for more information
:::

## Prerequisites

WebDyne requires mod_perl available when running with Apache, or FastCGI support if running with Lighttpd. Installation on Windows requires ActiveState Perl be installed, and Apache/mod_perl be available.

In pathological cases WebDyne can run in CGI mode (does not need mod_perl or FastCGI) however such a configuration is not supported by the installation scripts, and would be extremely inefficient and CPU intensive under any non-trivial load.

## Compatibility

WebDyne should install on any modern Linux distribution. It will run with mod_perl 1.x, 1.99_x, 2.0.x and 2.2, and has been tested on a variety of distributions.

Installation from CPAN or the source code should be possible with little or no effort on most \*nix/compatible systems such a \*BSD, Solaris etc. so long as the correct development tools and libraries are available.

WebDyne has been installed onto a Windows 2003 SP1 server running Apache

2.0/mod_perl, Apache 2.2/mod_perl and IIS. The `wdapacheinit` installer
may work in other Windows environments but has not been tested.

