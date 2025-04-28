# Miscellaneous

## Command Line Utilities

Command line utilities are fairly basic at this stage. Installation location will vary depening on your distribution - most will default to `/usr/local/bin`, but may be installed elsewhere in some cases, especially if you have nominated a `PREFIX` option when using CPAN.

`wdapacheinit`

:   Runs the WebDyne initialization routines, which create needed
    directories, modify and create Apache .conf files etc.

`wdcompile`

:   Usage: `wdcompile filename.psp`. Will compile a .psp file and use
    Data::Dumper to display the WebDyne internal representation of the
    page tree structure. Useful as a troubleshooting tool to see how
    HTML::TreeBuilder has parsed your source file, and to show up any
    misplaced tags etc.

`wdrender`

:   Usage: `wdrender filename.psp`. Will attempt to render the source
    file to screen using WebDyne. Can only do basic tasks - any advanced
    use (such as calls to the Apache request object) will fail.

`wddump`

:   Usage: `wddump filename`. Where filename is a compiled WebDyne
    source file (usually in /var/webdyne/cache). Will dump out the saved
    data structure of the compiled file.

`wdfastcgi`

:   Used to run WebDyne under FastCGI - not usually invoked
    interactively

## Other files referenced by WebDyne

`/etc/webdyne.pm`

:   Used for storage of local constants that override WebDyne defaults.
    See the [WebDyne::Constant](#webdyne_constants) section for details

`/etc/perl5lib.pm`

:   Contains a list of directories that WebDyne will look in for
    libraries. Effectively extends Perl\'s `@INC` variable. If you
    install CPAN or other Perl modules to a particular directory using
    `perl Makefile.PL PREFIX=/opt/mylibs`, then add \'`/opt/mylibs`\' to
    the `perl5lib.pm` file, WebDyne will find them.

