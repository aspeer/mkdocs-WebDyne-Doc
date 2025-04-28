# Error Handling

## Error Messages

Sooner or later something is going to go wrong in your code. If this happens WebDyne will generate an error showing what the error was and attempting to give information on where it came from: Take the following example:

```
#include "example/err1.html"
```
 [Run](example/err1.psp)

If you run the above example an error message will be displayed:.

Error Message 1

![](images/err1.png)

In this example the backtrace is not particularly useful because the error occurred within in-line code, so all references in the backtrace are to internal WebDyne modules. However the code fragment clearly shows the line with the error, and the page line number where the error occurred (line 3) is given at the start of the message. The reference to "(eval 268) line 1" is a red herring - it is the 268th eval performed by this perl process, and the error occurred in line 1 of the text that the eval was passed - standard perl error text, but not really helpful here.

If we have a look at another example:

```
#include "example/err2.html"
```
 [Run](example/err2.psp)

And the corresponding screen shot:

Error Message 2

![](images/err2.png)

The backtrace is somewhat more helpful. Looking through the backtrace we can see that the error occurred in the "hello" subroutine (invoked at line 3 of the page) on line 5 - In this case "line 5" means the 5th line down from the \_\_PERL\_\_ delimiter. The 32 digit hexadecimal number is the page unique ID - it is different for each page. WebDyne runs the code for each page in a package name space that includes the page's UID - in this way pages with identical subroutine names (e.g. two pages with a "hello" subroutine) can be accommodated with no collision.

## Exceptions

Errors (exceptions) can be generated within a WebDyne page in two ways:

    - By calling die() as shown in example above.
    - By returning an error message via the err() method, exported by
    default.

Examples

```
__PERL__


#  Good
#
sub hello {

    return err('no foobar') if !$foobar;

}

# Also OK
#
sub hello {

    return die('no foobar') if !$foobar;

}
```
 ## Error Checking

So far all the code examples have just assumed that any call to a WebDyne API method has been successful - no error checking is done. WebDyne always returns "undef" if an API method call fails - which should be checked for after every call in a best practice scenario.

```
#include "example/err3.html"
```
 [Run](example/err3.psp)

You can use the err() function to check for errors in WebDyne Perl code associated with a page, e.g.:

```
#include "example/err4.html"
```
 [Run](example/err4.psp)

Note that the backtrace in this example shows clearly where the error was triggered from.

