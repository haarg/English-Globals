package English::Globals;
use strict;
use warnings;

our $VERSION = '0.001000';
$VERSION =~ tr/_//d;

my %vars = (
  '^INC'                           => 'INC',
  '^SIG'                           => 'SIG',
  '^ARGV'                          => 'ARGV',
  '^ARGVOUT'                       => 'ARGVOUT',
  '^STDIN'                         => 'STDIN',
  '^STDOUT'                        => 'STDOUT',
  '^STDERR'                        => 'STDERR',

  '^_'                             => '*_',
  '^ARG'                           => '*_',

  # '^MATCH'                         => '*&',
  # '^PREMATCH'                      => '*`',
  # '^POSTMATCH'                     => '*\'',

  '^LAST_PAREN_MATCH'              => '*+',
  '^LAST_SUBMATCH_RESULT'          => '*^N',
  '^LAST_MATCH_START'              => '@-',
  '^LAST_MATCH_END'                => '@+',

  '^INPUT_LINE_NUMBER'             => '*.',
  '^NR'                            => '*.',
  '^INPUT_RECORD_SEPARATOR'        => '*/',
  '^RS'                            => '*/',

  '^OUTPUT_AUTOFLUSH'              => '*|',
  '^OUTPUT_FIELD_SEPARATOR'        => '*,',
  '^OFS'                           => '*,',
  '^OUTPUT_RECORD_SEPARATOR'       => '*\\',
  '^ORS'                           => '*\\',

  '^LIST_SEPARATOR'                => '*"',
  '^SUBSCRIPT_SEPARATOR'           => '*;',
  '^SUBSEP'                        => '*;',

  '^FORMAT_PAGE_NUMBER'            => '*%',
  '^FORMAT_LINES_PER_PAGE'         => '*=',
  '^FORMAT_LINES_LEFT'             => '$-',
  '^FORMAT_NAME'                   => '*~',
  '^FORMAT_TOP_NAME'               => '*^',
  '^FORMAT_LINE_BREAK_CHARACTERS'  => '*:',
  '^FORMAT_FORMFEED'               => '*^L',

  '^CHILD_ERROR'                   => '*?',
  '^OS_ERROR'                      => '*!',
  '^ERRNO'                         => '*!',
  '^OS_ERROR'                      => '*!',
  '^ERRNO'                         => '*!',
  '^EXTENDED_OS_ERROR'             => '*^E',
  '^EVAL_ERROR'                    => '*@',

  '^PROCESS_ID'                    => '*$',
  '^PID'                           => '*$',
  '^REAL_USER_ID'                  => '*<',
  '^UID'                           => '*<',
  '^EFFECTIVE_USER_ID'             => '*>',
  '^EUID'                          => '*>',
  '^REAL_GROUP_ID'                 => '*(',
  '^GID'                           => '*(',
  '^EFFECTIVE_GROUP_ID'            => '*)',
  '^EGID'                          => '*)',
  '^PROGRAM_NAME'                  => '*0',

  '^PERL_VERSION'                  => '*^V',
  '^OLD_PERL_VERSION'              => '*]',
  '^ACCUMULATOR'                   => '*^A',
  '^COMPILING'                     => '*^C',
  '^DEBUGGING'                     => '*^D',
  '^SYSTEM_FD_MAX'                 => '*^F',
  '^INPLACE_EDIT'                  => '*^I',
  '^PERLDB'                        => '*^P',
  '^LAST_REGEXP_CODE_RESULT'       => '*^R',
  '^EXCEPTIONS_BEING_CAUGHT'       => '*^S',
  '^BASETIME'                      => '*^T',
  '^WARNING'                       => '*^W',
  '^EXECUTABLE_NAME'               => '*^X',
  '^OSNAME'                        => '*^O',

  '^ARRAY_BASE'                    => '*[',
  '^OFMT'                          => '*#',
);

my $done;
sub import {
  return
    if $done;
  for my $var (sort keys %vars) {
    my $to = $vars{$var};
    my $install_name = $var;
    my ($sig, $name) = $to =~ /\A([*@%\$]?)(.*)\z/s;
    s/\A\^(.)/$1 & "\x1f"/se
      for $name, $install_name;
    next
      if defined $::{$install_name};
    no strict 'refs';
    if    ($sig eq '*') { *{"main::$install_name"} = *{$name} }
    elsif ($sig eq '$') { *{"main::$install_name"} = \${$name} }
    elsif ($sig eq '@') { *{"main::$install_name"} = \@{$name} }
    elsif ($sig eq '%') { *{"main::$install_name"} = \%{$name} }
    else                { *{"main::$install_name"} = *{$name} }
  }
  $done++;
}

1;
__END__

=head1 NAME

English::Globals - Provide super-globals for English names of punctuation variables

=head1 SYNOPSIS

  use English::Globals;
  print "${^PROGRAM_NAME}\n";

=head1 DESCRIPTION

This module provides super-global variables in the form of C<${^ENGLISH_NAME}>
for the punctuation variables in L<perlfunc>. It uses the same names as
L<English>.

In contrast with L<English>, these variables are intended to be more
self-documenting, as the C<${^NAME}> form makes the variabes super-globals, and
implies that they are magic.

=head1 AUTHOR

haarg - Graham Knop (cpan:HAARG) <haarg@haarg.org>

=head1 CONTRIBUTORS

None so far.

=head1 COPYRIGHT

Copyright (c) 2020 the English::Globals L</AUTHOR> and L</CONTRIBUTORS>
as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself. See L<https://dev.perl.org/licenses/>.

=cut
