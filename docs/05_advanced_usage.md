# Advanced Usage

A lot of tasks can be achieved just using the basic features detailed above. However there are more advanced features that can make life even easier

## Blocks

Blocks are a powerful dynamic content generation tool. WebDyne can render arbitrary blocks of text or HTML within a page, which makes generation of dynamic content generally more readable than similar output generated within Perl code. An example:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Blocks<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>
2 + 2 = <span class="h-ab">&lt;</span><span class="h-cgi_tag">textfield</span> <span class="h-attr">name</span>=<span class="h-attv">"sum</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">submit</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"check</span>"<span class="h-ab">&gt;</span>


<span class="h-com">&lt;!-- Each block below is only rendered if specifically requested by the Perl code --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">block</span> <span class="h-attr">name</span>=<span class="h-attv">"pass</span>"<span class="h-ab">&gt;</span>
Yes, +&#123;sum&#125; is the correct answer ! Brilliant ..
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">block</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">block</span> <span class="h-attr">name</span>=<span class="h-attv">"fail</span>"<span class="h-ab">&gt;</span>
I am sorry .. +&#123;sum&#125; is not correct .. Please try again !
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">block</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">block</span> <span class="h-attr">name</span>=<span class="h-attv">"silly</span>"<span class="h-ab">&gt;</span>
Danger, does not compute ! .. "+&#123;sum&#125;" is not a number !
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">block</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
Thanks for playing !

<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub check &#123;

    my $self=shift();

    if ((my $ans=$_&#123;'sum'&#125;) == 4) &#123;
        $self->render_block('pass')
    &#125;
    elsif ($ans=~/^[0-9.]+$/) &#123;
        $self->render_block('fail')
    &#125;
    elsif ($ans) &#123;
        $self->render_block('silly')
    &#125;

    #  Blocks aren't displayed until whole section rendered
    #
    return $self->render();

&#125;

</pre>



[Run](example/block1.psp)

There can be more than one block with the same name - any block with the target name will be rendered:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>
Enter your name: <span class="h-ab">&lt;</span><span class="h-cgi_tag">textfield</span> <span class="h-attr">name</span>=<span class="h-attv">"name</span>"<span class="h-ab">&gt;</span>
<span class="h-ent">&amp;nbsp;</span>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">submit</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>


<span class="h-com">&lt;!-- The following block is only rendered if we get a name - see the perl 
    code --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">block</span> <span class="h-attr">name</span>=<span class="h-attv">"greeting</span>"<span class="h-ab">&gt;</span>
Hello +&#123;name&#125;, pleased to meet you !
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">block</span><span class="h-ab">&gt;</span>


<span class="h-com">&lt;!-- This text is always rendered - it is not part of a block --&gt;</span>

The time here is !&#123;! localtime() !&#125;


<span class="h-com">&lt;!-- This block has the same name as the first one, so will be rendered
    whenever that one is --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">block</span> <span class="h-attr">name</span>=<span class="h-attv">"greeting</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
It has been a pleasure to serve you, +&#123;name&#125; !
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">block</span><span class="h-ab">&gt;</span>


<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123; 

    my $self=shift();

    #  Only render greeting blocks if name given. Both blocks
    #  will be rendered, as the both have the name "greeting"
    #
    if ($_&#123;'name'&#125;) &#123;
        $self->render_block('greeting');
    &#125;

    $self->render();
&#125;
</pre>



[Run](example/block2.psp)

Like any other text or HTML between \<perl\> tags, blocks can take parameters to substitute into the text:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>
Enter your name: <span class="h-ab">&lt;</span><span class="h-cgi_tag">textfield</span> <span class="h-attr">name</span>=<span class="h-attv">"name</span>"<span class="h-ab">&gt;</span>
<span class="h-ent">&amp;nbsp;</span>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">submit</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>


<span class="h-com">&lt;!-- This block will be rendered multiple times, the output changing depending
    on the variables values supplied as parameters --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">block</span> <span class="h-attr">name</span>=<span class="h-attv">"greeting</span>"<span class="h-ab">&gt;</span>
$&#123;i&#125; .. Hello +&#123;name&#125;, pleased to meet you !
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">block</span><span class="h-ab">&gt;</span>

The time here is <span class="h-pi">&lt;? localtime() ?&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123; 

    my $self=shift();

    #  Only render greeting blocks if name given. Both blocks
    #  will be rendered, as the both have the name "greeting"
    #
    if ($_&#123;'name'&#125;) &#123;
        for(my $i=0; $i<3; $i++) &#123;
            $self->render_block('greeting', i=>$i );
        &#125;
    &#125;

    $self->render();
&#125;
</pre>



[Run](example/block3.psp)

Blocks have a non-intuitive feature - they still display even if they are outside of the \<perl\> tags that made the call to render them. e.g. the following is OK:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Perl block with no content --&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- This block is not enclosed within the &lt;perl&gt; tags, but will still render --&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">block</span> <span class="h-attr">name</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>
Hello World
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">block</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- So will this one --&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">block</span> <span class="h-attr">name</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>
Again
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">block</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123;

    my $self=shift();
    $self->render_block('hello');

&#125;
</pre>



[Run](example/block4.psp)

You can mix the two styles:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- This block is rendered --&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">block</span> <span class="h-attr">name</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>
Hello World
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">block</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
<span class="h-com">&lt;!-- So is this one, even though it is outside the &lt;perl&gt;..&lt;/perl&gt; block --&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">block</span> <span class="h-attr">name</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>
Again
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">block</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123;

    my $self=shift();
    $self->render_block('hello');
    $self->render();

&#125;
</pre>



[Run](example/block5.psp)

## File inclusion

You can include other file fragments at compile time using the include tag:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
The protocols file on this machine:
<span class="h-ab">&lt;</span><span class="h-tag">pre</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">include</span> <span class="h-attr">file</span>=<span class="h-attv">"/etc/protocols</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">pre</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
</pre>



[Run](example/include1.psp)

If the file name is not an absolute path name is will be loaded relative to the directory of the parent file. For example if file "bar.psp" incorporates the tag\<include file="foo.psp"/\> it will be expected that "foo.psp" is in the same directory as "bar.psp".

!!! important

```
The include tag pulls in the target file at compile time. Changes to the
included file after the WebDyne page is run the first time (resulting in
compilation) are not reflected in subsequent output. Thus the include
tag should not be seen as a shortcut to a pseudo Content Management
System. For example \<include file=\"latest_news.txt\"/\> will probably
not behave in the way you expect. The first time you run it the latest
news is displayed. However updating the \"latest_news.txt\" file will
not result in changes to the output (it will be stale).

There are betters ways to build a CMS with WebDyne - use the include tag
sparingly !
```
 ## Static Sections

Sometimes you want to generate dynamic output in a page once only (e.g. a last modified date, a sidebar menu etc.) Using WebDyne this can be done with Perl or CGI code flagged with the "static" attribute. Any dynamic tag so flagged will be rendered at compile time, and the resulting output will become part of the compiled page - it will not change on subsequent page views, or have to be re-run each time the page is loaded. An example:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
Hello World
<span class="h-ab">&lt;</span><span class="h-tag">hr</span><span class="h-ab">&gt;</span>


<span class="h-com">&lt;!-- Note the static attribute --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"mtime</span>" <span class="h-attr">static</span>=<span class="h-attv">"1</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">em</span><span class="h-ab">&gt;</span>Last Modified: <span class="h-ab">&lt;/</span><span class="h-tag">em</span><span class="h-ab">&gt;</span>$&#123;mtime&#125;
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub mtime &#123;

    my $self=shift();
    my $r=$self->request();

    my $srce_pn=$r->filename();
        my $srce_mtime=(stat($srce_pn))[9];
    my $srce_localmtime=localtime $srce_mtime;

        return $self->render( mtime=>$srce_localmtime )

&#125;
</pre>



[Run](example/static1.psp)

In fact the above page will render very quickly because it has no dynamic content at all once the \<perl\> content is flagged as static. The WebDyne engine will recognise this and store the page as a static HTML file in its cache. Whenever it is called WebDyne will use the Apache lookup_file() function to return the page as if it was just serving up static content.

You can check this by looking at the content of the WebDyne cache directory (usually /var/webdyne/cache). Any file with a ".html" extension represents the static version of a page.

Of course you can still mix static and dynamic Perl sections:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
Hello World
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- A normal dynamic section - code is run each time page is loaded --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"localtime</span>"<span class="h-ab">&gt;</span>
Current time: $&#123;time&#125; 
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">hr</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Note the static attribute - code is run only once at compile time --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"mtime</span>" <span class="h-attr">static</span>=<span class="h-attv">"1</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">em</span><span class="h-ab">&gt;</span>Last Modified: <span class="h-ab">&lt;/</span><span class="h-tag">em</span><span class="h-ab">&gt;</span>$&#123;mtime&#125;
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>


<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095


sub localtime &#123;

    shift()->render(time=>scalar localtime);

&#125;


sub mtime &#123;

    my $self=shift();
    my $r=$self->request();

    my $srce_pn=$r->filename();
        my $srce_mtime=(stat($srce_pn))[9];
    my $srce_localmtime=localtime $srce_mtime;

        return $self->render( mtime=>$srce_localmtime )

&#125;
</pre>



[Run](example/static2.psp)

If you want the whole pages to be static, then flagging everything with the "static" attribute can be cumbersome. There is a special meta tag which flags the entire page as static:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Special meta tag --&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">meta</span> <span class="h-attr">name</span>=<span class="h-attv">"WebDyne</span>" <span class="h-attr">content</span>=<span class="h-attv">"static=1</span>"<span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
Hello World
<span class="h-ab">&lt;</span><span class="h-tag">hr</span><span class="h-ab">&gt;</span>


<span class="h-com">&lt;!-- A normal dynamic section, but because of the meta tag it will be frozen 
    at compile time --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"localtime</span>"<span class="h-ab">&gt;</span>
Current time: $&#123;time&#125; 
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ent">&amp;nbsp;</span>

<span class="h-com">&lt;!-- Note the static attribute. It is redundant now the whole page is flagged
    as static - it could be removed safely. --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"mtime</span>" <span class="h-attr">static</span>=<span class="h-attv">"1</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">em</span><span class="h-ab">&gt;</span>Last Modified: <span class="h-ab">&lt;/</span><span class="h-tag">em</span><span class="h-ab">&gt;</span>$&#123;mtime&#125;
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>


<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095


sub localtime &#123;

    shift()->render(time=>scalar localtime);

&#125;


sub mtime &#123;

    my $self=shift();
    my $r=$self->request();

    my $srce_pn=$r->filename();
        my $srce_mtime=(stat($srce_pn))[9];
    my $srce_localmtime=localtime $srce_mtime;

        return $self->render( mtime=>$srce_localmtime )

&#125;
</pre>



[Run](example/static3.psp)

If you don't like the idea of setting the static flag in meta data, then "using" the special package "WebDyne::Static" will have exactly the same effect:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>
Hello World
<span class="h-ab">&lt;</span><span class="h-tag">hr</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"localtime</span>"<span class="h-ab">&gt;</span>
Current time: $&#123;time&#125; 
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ent">&amp;nbsp;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"mtime</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">em</span><span class="h-ab">&gt;</span>Last Modified: <span class="h-ab">&lt;/</span><span class="h-tag">em</span><span class="h-ab">&gt;</span>$&#123;mtime&#125;
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095


#  Makes the whole page static
#
use WebDyne::Static;


sub localtime &#123;

    shift()->render(time=>scalar localtime);

&#125;


sub mtime &#123;

    my $self=shift();
    my $r=$self->request();

    my $srce_pn=$r->filename();
        my $srce_mtime=(stat($srce_pn))[9];
    my $srce_localmtime=localtime $srce_mtime;

        return $self->render( mtime=>$srce_localmtime )

&#125;
</pre>



[Run](example/static3a.psp)

If the static tag seems trivial consider the example that displayed country codes:

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

Every time the above example is viewed the Country Name list is generated dynamically via CGI.pm and the Locale::Country module (on a sample machine Apache Bench measured the output at around 55 pages/sec). This is a waste of resources because the list changes very infrequently. We can keep the code neat but gain a lot of speed by adding the static tag attribute:

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Hello World<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span><span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Generate all country names for picklist --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>

Your Country ?
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"countries</span>" <span class="h-attr">static</span>=<span class="h-attv">"1</span>"<span class="h-ab">&gt;</span>

<span class="h-com">&lt;!-- Note the addition of the static attribute --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-cgi_tag">popup_menu</span> <span class="h-attr">values</span>=<span class="h-attv">"$&#123;countries_ar&#125;</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;/</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

use Locale::Country;

sub countries &#123;

    my $self=shift();
    my @countries = sort &#123;$a cmp $b&#125; all_country_names();
    $self->render( countries_ar=>\@countries );

&#125;
</pre>



[Run](example/static4.psp)

By simply adding the "static" attribute output on a sample machine increased from 55 Pages/sec to 280 Pages/sec ! Judicious use of the static tag in places with slow changing data can markedly increase efficiency of the WebDyne engine.

## Caching

WebDyne has the ability to cache the compiled version of a dynamic page according to specs you set via the API. When coupled with pages/blocks that are flagged as static this presents some powerful possibilities.

!!! important

```
Caching will only work if `$WEBDYNE_CACHE_DN` is defined and set to a
directory that the web server has write access to. If caching does not
work check that \$`WEBDYNE_CACHE_DN` is defined and permissions set
correctly for your web server.
```
 There are many potential examples, but consider this one: you have a page that generates output by making a complex query to a database, which takes a lot of CPU and disk IO resources to generate. You need to update the page reasonably frequently (e.g. a weather forecast, near real time sales stats), but can't afford to have the query run every time someone view the page.

WebDyne allows you to configure the page to cache the output for a period of time (say 5 minutes) before re-running the query. In this way users sees near real-time data without imposing a high load on the database/Web server.

WebDyne knows to enable the caching code by looking for a meta tag, or by loading the `WebDyne::Cache` module in a \_\_PERL\_\_ block.

The cache code can command WebDyne to recompile a page based on any arbitrary criteria it desires. As an example the following code will recompile the page every 10 seconds. If viewed in between refresh intervals WebDyne will serve up the cached HTML result using Apache r\$-\>lookup_file() or the FCGI equivalent, which is very fast.

Try it by running the following example and clicking refresh a few times over a 20 second interval

<pre>
<span class="h-ab">&lt;</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>Caching<span class="h-ab">&lt;/</span><span class="h-tag">title</span><span class="h-ab">&gt;</span>
<span class="h-com">&lt;!-- Set static and cache meta parameters --&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">meta</span> <span class="h-attr">name</span>=<span class="h-attv">"WebDyne</span>" content="cache=<span class="h-ent">&amp;cache;</span>static=1"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">head</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

This page will update once every 10 seconds.

<span class="h-ab">&lt;</span><span class="h-tag">p</span><span class="h-ab">&gt;</span>

Hello World !&#123;! localtime() !&#125;

<span class="h-ab">&lt;/</span><span class="h-tag">body</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095


#  The following would work in place of the meta tags
#
#use WebDyne::Static;
#use WebDyne::Cache (\<span class="h-ent">&amp;cache);</span>


sub cache &#123;

    my $self=shift();

    #  Get cache file mtime (modified time)
        #
        my $mtime=$&#123; $self->cache_mtime() &#125;;


        #  If older than 10 seconds force recompile
        #
        if ((time()-$mtime) > 10) &#123; 
                $self->cache_compile(1) 
        &#125;;

    #  Done
    #
    return \undef;

&#125;</pre>



[Run](example/cache1.psp)

WebDyne uses the return value of the nominated cache routine to determine what UID (unique ID) to assign to the page. In the above example we returned \undef, which signifies that the UID will remain unchanged.

You can start to get more advanced in your handling of cached pages by returning a different UID based on some arbitrary criteria. To extend our example above: say we have a page that generated sales figures for a given month. The SQL code to do this takes a long time, and we do not want to hit the database every time someone loads up the page. However we cannot just cache the output, as it will vary depending on the month the user chooses. We can tell the cache code to generate a different UID based on the month selected, then cache the resulting output.

The following example simulates such a scenario:

<pre>
<span class="h-com">&lt;!-- Start to cheat by using start/end_html tags to save space --&gt;</span>

<span class="h-ab">&lt;</span><span class="h-cgi_tag">start_html</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">form</span> <span class="h-attr">method</span>=<span class="h-attv">"GET</span>"<span class="h-ab">&gt;</span>
Get sales results for:<span class="h-ent">&amp;nbsp;</span><span class="h-ab">&lt;</span><span class="h-cgi_tag">popup_menu</span> <span class="h-attr">name</span>=<span class="h-attv">"month</span>" <span class="h-attr">values</span>=<span class="h-attv">"@&#123;qw(January February March)&#125;</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">submit</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"results</span>"<span class="h-ab">&gt;</span>
Sales results for +&#123;month&#125;: $$&#123;results&#125;
<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>

<span class="h-ab">&lt;</span><span class="h-tag">hr</span><span class="h-ab">&gt;</span>
This page generated: !&#123;! localtime() !&#125;
<span class="h-ab">&lt;</span><span class="h-cgi_tag">end_html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

use WebDyne::Static;
use WebDyne::Cache (\<span class="h-ent">&amp;cache);</span>

my %results=(

    January     => 20,
    February    => 30,
    March       => 40
);

sub cache &#123;

    #  Return UID based on month
    #
    my $uid=undef;
    if (my $month=$_&#123;'month'&#125;) &#123;

        #  Make sure month is valid
        #
        $uid=$month if defined $results&#123;$month&#125;

    &#125;
    return \$uid;

&#125;


sub results &#123;

    my $self=shift();
    if (my $month=$_&#123;'month'&#125;) &#123;

        #  Could be a really long complex SQL query ...
        #
        my $results=$results&#123;$month&#125;;


        #  And display
        #
        return $self->render(results => $results);
    &#125;
    else &#123;
        return \undef;
    &#125;

&#125;</pre>



[Run](example/cache2.psp)

!!! important

```
Take care when using user-supplied input to generate the page UID. There
is no inbuilt code in WebDyne to limit the number of UID\'s associated
with a page. Unless we check it, a malicious user could potentially DOS
the server by supplying endless random \"months\" to the above page with
a script, causing WebDyne to create a new file for each UID - perhaps
eventually filling the disk partition that holds the cache directory.
That is why we check the month is valid in the code above.
```
 # Error Handling

## Error Messages

Sooner or later something is going to go wrong in your code. If this happens WebDyne will generate an error showing what the error was and attempting to give information on where it came from: Take the following example:

<pre>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">start_html</span> <span class="h-attr">title</span>=<span class="h-attv">"Error</span>"<span class="h-ab">&gt;</span>
Let's divide by zero: !&#123;! my $z=0; return 5/$z !&#125;
<span class="h-ab">&lt;</span><span class="h-cgi_tag">end_html</span><span class="h-ab">&gt;</span>
</pre>



[Run](example/err1.psp)

If you run the above example an error message will be displayed:.

Error Message 1

![](images/err1.png)

In this example the backtrace is not particularly useful because the error occurred within in-line code, so all references in the backtrace are to internal WebDyne modules. However the code fragment clearly shows the line with the error, and the page line number where the error occurred (line 3) is given at the start of the message. The reference to "(eval 268) line 1" is a red herring - it is the 268th eval performed by this perl process, and the error occurred in line 1 of the text that the eval was passed - standard perl error text, but not really helpful here.

If we have a look at another example:

<pre>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">start_html</span> <span class="h-attr">title</span>=<span class="h-attv">"Error</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">/&gt;</span>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">end_html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123;

    die('bang !');

&#125;
</pre>



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
&amp;#095&amp;#095PERL&amp;#095&amp;#095


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

<pre>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">start_html</span> <span class="h-attr">title</span>=<span class="h-attv">"Error</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"hello</span>"<span class="h-ab">&gt;</span>

Hello World $&#123;foo&#125;

<span class="h-ab">&lt;/</span><span class="h-webdyne_tag">perl</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">end_html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub hello &#123;

    #  Check for error after calling render function
    #
    shift()->render( bar=> 'Again') || return err();

&#125;
</pre>



[Run](example/err3.psp)

You can use the err() function to check for errors in WebDyne Perl code associated with a page, e.g.:

<pre>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">start_html</span> <span class="h-attr">title</span>=<span class="h-attv">"Error</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-cgi_tag">submit</span> <span class="h-attr">name</span>=<span class="h-attv">"Error</span>" <span class="h-attr">value</span>=<span class="h-attv">"Click here for error !</span>"<span class="h-ab">&gt;</span>
<span class="h-ab">&lt;/</span><span class="h-tag">form</span><span class="h-ab">&gt;</span>
<span class="h-ab">&lt;</span><span class="h-webdyne_tag">perl</span> <span class="h-attr">method</span>=<span class="h-attv">"foo</span>"<span class="h-ab">/&gt;</span><span class="h-ab">&lt;</span><span class="h-cgi_tag">end_html</span><span class="h-ab">&gt;</span>

&#095&#095PERL&#095&#095

sub foo &#123;

    <span class="h-ent">&amp;bar() || return err();</span>
    \undef;

&#125;

sub bar &#123;

    return err('bang !') if $_&#123;'Error'&#125;;
    \undef;
&#125;</pre>



[Run](example/err4.psp)

Note that the backtrace in this example shows clearly where the error was triggered from.

