#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use File::Slurp qw.edit_file.;
use Pod::PseudoPod::LaTeX;


my $pod = 'build/book.pod';
my $tex = "book.tex";


my @files = sort {
      $a =~ m!(\d+)-! and my $c = $1;
      $b =~ m!(\d+)-! and my $d = $1;
      $c <=> $d
} <chapters/*pod>;

create_single_pod   (pod => $pod, files => \@files);
create_tex_from_pod (pod => $pod, tex => $tex);
post_process_tex    ($tex);

unlink $pod;

sub post_process_tex {
    my $filename = shift;
    edit_file {
        s/section\*/section/g;
        s/section\{\*/section*{/g;
        s/chapter\{\*/chapter*{/g;

        s!\bLaTeX\b!\\LaTeX{}!g;
        s!\bTeX\b!\\TeX{}!g;
    } $filename;
}

sub create_single_pod {
    my %data  = @_;
    my $pod   = $data{pod} or die;
    my @files = @{$data{files}} or die;

    open my $out, ">:utf8", $pod or die "Can't create file!";

    for my $file (@files) {
        open X, "<:utf8", $file or die "Error opening file $!";
        while(<X>) {
            print $out $_;
        }
        close X;
    }

    close $out;
}

sub parse_pod_file {
    my %data   = @_;
    my $fh     = $data{out} or die;
    my $pod    = $data{pod} or die;
    my $parser = Pod::PseudoPod::LaTeX->new(keep_ligatures => 1);
    # $parser->emit_environments( sidebar => 'sidebar' );
    $parser->output_fh($fh);
    $parser->parse_file($pod);
}

sub add_tex_preamble {
    my $fh = shift;
    # XXX - TODO: put this into a separate .tex file, and copy its
    #             contents here.
    print $fh <<'EOTeX'
\documentclass[a4paper]{book}

\usepackage{asbook}
\setdefaultlanguage{english}

\title{CPAN Modules and Frameworks}
\subtitle{A bunch of relevant Perl modules and frameworks available from CPAN}
\author{Alberto Simões \and Nuno Carvalho}
\date{}

\begin{document}
\frontmatter
\maketitle

EOTeX
}

sub add_tex_postamble {
    my $fh = shift;
    print $fh <<'EOTeX'
\end{document}
EOTeX
}

sub create_tex_from_pod {
    my %data = @_;
    my $tex = $data{tex} or die;
    my $pod = $data{pod} or die;
    open my $tex_fh, ">:utf8", $tex;
    add_tex_preamble $tex_fh;
    parse_pod_file out => $tex_fh, pod => $pod;
    add_tex_postamble $tex_fh;
    close $tex_fh;

}
