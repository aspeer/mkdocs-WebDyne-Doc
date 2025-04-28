#!/usr/bin/env perl


#  Pragma
#
use strict;
use warnings;
no warnings qw(redefine);
use utf8;


#  External modules
#
use File::Spec;
use Markdown::Parser;
use Data::Dumper;
use IO::File;


#  Blank out faulty Module::Generic message handlers
#
*Module::Generic::message_colour=sub {};
*Module::Generic::messagef_colour=sub {};
*Module::Generic::message=sub {};


#==============================================================================


#  Get file and open
#
my $fn=shift() ||
    die("Usage: $0 file.md");


#  Create parse object
#
my $md_or=Markdown::Parser->new({
    debug => 255, 
    mode => 'extended', 
    callback => undef 
});




#  Start parse
#
print "parse start\n";
my $doc_or = $md_or->parse_file($fn) ||
    die("unable to get document object from markdown parser");
print "parse complete\n";


#  Vars to hold sections and count them
#
my @md;
my $ix=0;
my %section;


#  Iterate through each node
#
print "section discovery start\n";
foreach my $node_or (@{$doc_or->{children}}) {


    #  Get markdown, skip blank lines at top
    my $md=$node_or->as_markdown();
    unless ($md) { next unless $ix };
    
    
    #  Get the tag name, p for tags
    #
    my $tn=$node_or->tag_name();
    if (($tn eq 'p') && $md=~/^#\s+/) {
    
    
        #  It's at title, increment index if 
        #
        print "found first level section: $md";
        $ix++ if keys %section;
        my $title=$md;
        $title =~ s/^#+\s*//;                   # Remove leading '#' and whitespace
        $title =~ s/[^A-Za-z0-9]+/_/g;          # Replace non-alphanumeric chars with underscores
        $title =~ s/^_+|_+$//g;                 # Trim leading/trailing underscores
        $title = lc($title); 
        $title = sprintf('%0.2d_%s.md', $ix, $title);
        $section{$ix}=$title;
        
    }
    elsif (($tn eq 'p') && $md=~/^##\s+/) {
        #print "S2: $md\n";
    }
    $md[$ix].=$md;
}
print "section disovery complete\n";


#  Write files out
#
while (my($ix, $fn)=each %section) {

    my $fn=File::Spec->catfile('docs', $fn);
    my $fh=IO::File->new($fn, O_WRONLY|O_TRUNC|O_CREAT) || 
        die ("unable to write to fn $fn, $!");
    print $fh $md[$ix];
    $fh->close();
    print "wrote: $fn\n"
    
}
