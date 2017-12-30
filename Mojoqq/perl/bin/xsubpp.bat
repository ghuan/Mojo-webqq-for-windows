@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -x -S %0 %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
#!perl
#line 15
    eval 'exec C:\strawberry\perl\bin\perl.exe -S $0 ${1+"$@"}'
	if $running_under_some_shell;
#!perl
use 5.006;
use strict;
eval {
  require ExtUtils::ParseXS;
  1;
}
or do {
  my $err = $@ || 'Zombie error';
  my $v = $ExtUtils::ParseXS::VERSION;
  $v = '<undef>' if not defined $v;
  die "Failed to load or import from ExtUtils::ParseXS (version $v). Please check that ExtUtils::ParseXS is installed correctly and that the newest version will be found in your \@INC path: $err";
};

use Getopt::Long;

my %args = ();

my $usage = "Usage: xsubpp [-v] [-csuffix csuffix] [-except] [-prototypes] [-noversioncheck] [-nolinenumbers] [-nooptimize] [-noinout] [-noargtypes] [-strip|s pattern] [-typemap typemap]... file.xs\n";

Getopt::Long::Configure qw(no_auto_abbrev no_ignore_case);

@ARGV = grep {$_ ne '-C++'} @ARGV;  # Allow -C++ for backward compatibility
GetOptions(\%args, qw(hiertype!
		      prototypes!
		      versioncheck!
		      linenumbers!
		      optimize!
		      inout!
		      argtypes!
		      object_capi!
		      except!
		      v
		      typemap=s@
		      output=s
		      s|strip=s
		      csuffix=s
		     ))
  or die $usage;

if ($args{v}) {
  print "xsubpp version $ExtUtils::ParseXS::VERSION\n";
  exit;
}

@ARGV == 1 or die $usage;

$args{filename} = shift @ARGV;

my $pxs = ExtUtils::ParseXS->new;
$pxs->process_file(%args);
exit( $pxs->report_error_count() ? 1 : 0 );

__END__

=head1 NAME

xsubpp - compiler to convert Perl XS code into C code

=head1 SYNOPSIS

B<xsubpp> [B<-v>] [B<-except>] [B<-s pattern>] [B<-prototypes>] [B<-noversioncheck>] [B<-nolinenumbers>] [B<-nooptimize>] [B<-typemap typemap>] [B<-output filename>]... file.xs

=head1 DESCRIPTION

This compiler is typically run by the makefiles created by L<ExtUtils::MakeMaker>
or by L<Module::Build> or other Perl module build tools.

I<xsubpp> will compile XS code into C code by embedding the constructs
necessary to let C functions manipulate Perl values and creates the glue
necessary to let Perl access those functions.  The compiler uses typemaps to
determine how to map C function parameters and variables to Perl values.

The compiler will search for typemap files called I<typemap>.  It will use
the following search path to find default typemaps, with the rightmost
typemap taking precedence.

	../../../typemap:../../typemap:../typemap:typemap

It will also use a default typemap installed as C<ExtUtils::typemap>.

=head1 OPTIONS

Note that the C<XSOPT> MakeMaker option may be used to add these options to
any makefiles generated by MakeMaker.

=over 5

=item B<-hiertype>

Retains '::' in type names so that C++ hierarchical types can be mapped.

=item B<-except>

Adds exception handling stubs to the C code.

=item B<-typemap typemap>

Indicates that a user-supplied typemap should take precedence over the
default typemaps.  This option may be used multiple times, with the last
typemap having the highest precedence.

=item B<-output filename>

Specifies the name of the output file to generate.  If no file is
specified, output will be written to standard output.

=item B<-v>

Prints the I<xsubpp> version number to standard output, then exits.

=item B<-prototypes>

By default I<xsubpp> will not automatically generate prototype code for
all xsubs. This flag will enable prototypes.

=item B<-noversioncheck>

Disables the run time test that determines if the object file (derived
from the C<.xs> file) and the C<.pm> files have the same version
number.

=item B<-nolinenumbers>

Prevents the inclusion of '#line' directives in the output.

=item B<-nooptimize>

Disables certain optimizations.  The only optimization that is currently
affected is the use of I<target>s by the output C code (see L<perlguts>).
This may significantly slow down the generated code, but this is the way
B<xsubpp> of 5.005 and earlier operated.

=item B<-noinout>

Disable recognition of C<IN>, C<OUT_LIST> and C<INOUT_LIST> declarations.

=item B<-noargtypes>

Disable recognition of ANSI-like descriptions of function signature.

=item B<-C++>

Currently doesn't do anything at all.  This flag has been a no-op for
many versions of perl, at least as far back as perl5.003_07.  It's
allowed here for backwards compatibility.

=item B<-s=...> or B<-strip=...>

I<This option is obscure and discouraged.>

If specified, the given string will be stripped off from the beginning
of the C function name in the generated XS functions (if it starts with that prefix).
This only applies to XSUBs without C<CODE> or C<PPCODE> blocks.
For example, the XS:

  void foo_bar(int i);

when C<xsubpp> is invoked with C<-s foo_> will install a C<foo_bar>
function in Perl, but really call C<bar(i)> in C. Most of the time,
this is the opposite of what you want and failure modes are somewhat
obscure, so please avoid this option where possible.

=back

=head1 ENVIRONMENT

No environment variables are used.

=head1 AUTHOR

Originally by Larry Wall.  Turned into the C<ExtUtils::ParseXS> module
by Ken Williams.

=head1 MODIFICATION HISTORY

See the file F<Changes>.

=head1 SEE ALSO

perl(1), perlxs(1), perlxstut(1), ExtUtils::ParseXS

=cut


__END__
:endofperl
