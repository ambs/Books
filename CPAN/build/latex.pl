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

        s/\\scriptsize\n\\begin{Verbatim/\\small\n\\begin{Verbatim/g;
        # this depends on the previous one
        s/
          \\vspace{-6pt}\n(\\small\n\\begin{Verbatim}\[[^]]+frame=single[^]]+\])
         /
          "\\vspace{-2pt}\n$1" # this way I can keep the indentation O:-)
         /xge;

        s!frame=single,label=!frame=single,numbers=left,label=!g;

        s!}``!}''!g;

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
    $parser->output_fh($fh);
    $parser->accept_target_as_text('CPANinfo');
    $parser->accept_target('Perl');
    $parser->emit_environments('CPANinfo' => 'cpaninfo',
                               'Perl'     => 'lstlisting');
    $parser->parse_file($pod);
}

sub add_tex_preamble {
    my $fh = shift;
    # XXX - TODO: put this into a separate .tex file, and copy its
    #             contents here.
    print $fh <<'EOTeX'
\documentclass[a5paper,twoside,9pt]{extbook}
\usepackage[left=1.7cm,right=2.2cm,top=2cm,bottom=1.5cm,footskip=7mm,headsep=7mm]{geometry}
\usepackage{makeidx}
\makeindex

\usepackage{asbook}
\setdefaultlanguage{english}

\title{CPAN Modules and Frameworks}
\subtitle{A bunch of relevant Perl modules and frameworks available from CPAN}
\author{Alberto Simões \and Nuno Carvalho}
\date{First Edition}

\begin{document}
\frontmatter
\maketitle

EOTeX
}

sub add_tex_postamble {
    my $fh = shift;
    print $fh <<'EOTeX'
\printindex
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
