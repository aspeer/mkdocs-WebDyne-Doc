# Extending WebDyne

WebDyne can be extended by the installation and use of supplementary Perl packages. There are several standard packages that come with the Webdyne distribution, or you can build your own using one of the standard packages as a template.

The following gives an overview of the standard packages included in the distribution, or downloadable as extensions from CPAN.

## WebDyne::Chain

WebDyne::Chain is a module that will cascade a WebDyne request through one or more modules before delivery to the WebDyne engine. Most modules that extend WebDyne rely on WebDyne::Chain to get themselves inserted into the request lifecycle.

Whilst WebDyne::Chain does not modify content itself, it allows any of the modules below to intercept the request as if they had been loaded by the target page directly (i.e., loaded in the \_\_PERL\_\_ section of a page via the "use" or "require" functions).

Using WebDyne::Chain you can modify the behaviour of WebDyne pages based on their location. The WebDyne::Template module can be used in such scenario to wrap all pages in a location with a particular template. Another would be to make all pages in a particular location static without loading the WebDyne::Static module in each page:

```
&lt;Location /static&gt;

#  All pages in this location will be generated once only.
PerlHandler     WebDyne::Chain
PerlSetVar      WebDyneChain    'WebDyne::Static'

&lt;/Location&gt;
```
 Multiple modules can be chained at once:

```
&lt;Location /&gt;

#  We want templating and session cookies for all pages on our site.
PerlHandler     WebDyne::Chain
PerlSetVar      WebDyneChain    'WebDyne::Session WebDyne::Template'
PerlSetVar      WebDyneTemplate '/path/to/template.psp'

&lt;/Location&gt;
```
 The above example would place all pages within the named template, and make session information to all pages via \$self-\>session_id(). A good start to a rudimentary CMS.

WebDyneChain
Directive. Supply a space separated string of WebDyne modules that the request should be passed through.

## WebDyne::Static

Loading WebDyne::Static into a \_\_PERL\_\_ block flags to WebDyne that the entire page should be rendered once at compile time, then the static HTML resulting from that compile will be handed out on subsequent requests. Any active element or code in the page will only be run once. There are no API methods associated with this module

See the [Static Sections](#static_sections) reference for more information on how to use this module within an individual page.

WebDyne::Static can also be used in conjunction with the [WebDyne::Chain](#webdyne_chain) module to flag all files in a directory or location as static. An example httpd.conf snippet:

```
&lt;Location /static/&gt;

PerlHandler     WebDyne::Chain
PerlSetVar      WebDyneChain    'WebDyne::Static'

&lt;/Location&gt;
```
 ## WebDyne::Cache

Loading WebDyne::Cache into a \_\_PERL\_\_ block flags to WebDyne that the page wants the engine to call a designated routine every time it is run. The called routine can generate a new UID (Unique ID) for the page, or force it to be recompiled. There are no API methods associated with this module.

See the [Caching](#caching) section above for more information on how to use this module with an individual page.

WebDyne::Cache can also be used in conjunction with the [WebDyne::Chain](#webdyne_chain) module to flag all files in a particular location are subject to a cache handling routine. An example httpd.conf snippet:

```
&lt;Location /cache/&gt;

#  Run all requests through the MyModule::cache function to see if a page should
#  be recompiled before sending it out
#
PerlHandler     WebDyne::Chain
PerlSetVar      WebDyneChain    'WebDyne::Cache'
PerlSetVar      WebDyneCacheHandler '&amp;MyModule::cache'

&lt;/Location&gt;
```
 Note that any package used as the WebDyneCacheHandler target should be already loaded via "PerlRequire" or similar mechanism.

As an example of why this could be useful consider the [caching examples](#caching) above. Instead of flagging that an individual file should only be re-compiled every x seconds, that policy could be applied to a whole directory with no alteration to the individual pages.

## WebDyne::Session

WebDyne::Session generates a unique session ID for each browser connection and stores it in a cookie. It has the following API:

session_id()
Function. Returns the unique session id assigned to the browser. Call via \$self-\>session_id() from perl code.

`$WEBDYNE_SESSION_ID_COOKIE_NAME`
Constant. Holds the name of the cookie that will be used to assign the session id in the users browser. Defaults to "session". Set as per [WebDyne::Constants](#webdyne_constants) section. Resides in the `WebDyne::Session::Constant` package namespace.

Example:

```
#include "example/session1.html"
```
 [Run](example/session1.psp)

WebDyne::Session can also be used in conjunction with the [WebDyne::Chain](#webdyne_chain) module to make session information available to all pages within a location. An example httpd.conf snippet:

```
&lt;Location /&gt;

# We want session cookies for our whole site
#
PerlHandler     WebDyne::Chain
PerlSetVar      WebDyneChain    'WebDyne::Session'

#  Change cookie name from "session" to "gingernut" for something different
#
PerlSetVar      WEBDYNE_SESSION_ID_COOKIE_NAME    'gingernut'

&lt;/Location&gt;
```
 ## WebDyne::State::BerkeleyDB

WebDyne::State::BerkeleyDB works in conjunction with WebDyne::Session to maintain simple state information for a session. It inherits from WebDyne::State, and it could be used to build other state storage modules (e.g. WebDyne::State::MySQL)

login()
Function. Logs a user in, creating a state entry for them. Returns true if successful, undef if fails.

user()
Function. Returns scalar ref containing the name of the logged user for this session, undef if fails

logout()
Function. Logout the current user, deleting all state info.

state_store( \<key=\>value, key=\>value \| hashref\> )
Function. Store a key and associated value into the state database. Returns true for success, undef for failure. You can optionally pass a hash ref to state_store, in which case it will replace the existing state hash.

state_fetch( \<key\> )
Function.Fetch a previously stored key, Returns scalar ref to key value if successful, undef for failure. If no key name is supplied a hash ref of the current state hash will be returned.

state_delete()
Function.Delete the state database for this session. Returns true for success, undef for failure. Actual deletion does not take place until cleanup() phase of Apache lifecycle.

filename( \<filename\> )
Function.Fetch or set the name of the file where the state information will be held (defaults to `$WEBDYNE_CACHE_DIR``/state.db`). Must be set before any state operations take place.

`$WEBDYNE_BERKELEYDB_STATE_FN`
Constant. Name of the file that will hold the state database. Can be just a file name or an absolute path name. Set as per [WebDyne::Constants](#webdyne_constants) section. Defined in the `WebDyne::State::BerkeleyDB::Constant` namespace. Defaults to `state.db`

`$WEBDYNE_BERKELEYDB_STATE_DN`
Constant.Name of the directory where the state file will be located. If an absolute filename (i.e. one that includes a directory name) is given above then this variable is ignored. Set as per [WebDyne::Constants](#webdyne_constants) section. Defined in the `WebDyne::State::BerkeleyDB::Constant` namespace. Defaults to `$WEBDYNE_CACHE_DN`

Example:

```
#include "example/state1.html"
```
 [Run](example/state1.psp)

!!! important

State information is stored against the browser session ID, not against a user ID. The same user on two different machines will have two different state entries.

WebDyne::State is meant for simplistic storage of state information - it is not meant for long term storage of user preferences or other data, and should not be used as a persistent database.

WebDyne::State::BerkelyDB can also be used in conjunction with the [WebDyne::Chain](#webdyne_chain) module to make state information available to all pages within a location. An example httpd.conf snippet:

```
&lt;Location /&gt;

#  We want state information accessible across the whole site. WebDyne::State only works
#  in conjunction with WebDyne::Session, so it must be in the chain also.
#
PerlHandler     WebDyne::Chain
PerlSetVar      WebDyneChain    'WebDyne::Session WebDyne::State::BerkeleyDB'

&lt;/Location&gt;
```
 ## WebDyne::Template

One of the more powerful WebDyne extensions. WebDyne::Template can be used to build CMS (Content Management Systems). It will extract the \<head\> and \<body\> sections from an existing HTML or WebDyne page and insert them into the corresponding head and body blocks of a template file.

The merging is done once at compile time - there are no repeated search and replace operations each time the file is loaded, or server side includes, so the resulting pages are quite fast.

Both the template and content files should be complete - there is no need to write the content without a \<head\> section, or leave out \<html\> tags. As a result both the content and template files can be viewed as standalone documents.

The API:

template ( filename )
Function. Set the file name of the template to be used. If no path is specified file name will be relative to the current request directory

WebDyneTemplate
Directive. Can be used to supply the template file name in a Apache or lighttpd/FastCGI configuration file.

Example:

The template:

```
#include "example/template1.html"
```
 [Run](example/template1.psp)

The content, run to view resulting merge:

```
#include "example/content1.html"
```
 [Run](example/content1.psp)

In real life it is not desirable to put the template name into every content file (as was done in the above example), nor would we want to have to "use WebDyne::Template" in every content file.

To overcome this WebDyne::Template can read the template file name using the Apache dir_config function, and assign a template on a per location basis using the WebDyneTemplate directive. Here is a sample httpd.conf file:

```
&lt;Location /&gt;

PerlHandler     WebDyne::Chain
PerlSetVar      WebDyneChain    'WebDyne::Template'
PerlSetVar      WebDyneTemplate '/path/to/template.psp'

&lt;/Location&gt;
```
 # GNU General Public License

