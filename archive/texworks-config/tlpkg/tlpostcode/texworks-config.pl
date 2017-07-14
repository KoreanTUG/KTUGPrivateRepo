# post action for texworks-config to install texworks configuration and
# document templates.
# Copyright 2014 Kihwang Lee <leekh@ktug.org>
# This file is licensed under the GNU General Public License version 2
# or any later version.
#

my $texdir;
my $mode;

BEGIN {
  $^W = 1;
  $mode = lc($ARGV[0]);
  $texdir = $ARGV[1];
  # make Perl find our packages first:
  unshift (@INC, "$texdir/tlpkg");
}

use TeXLive::TLUtils qw(win32 mkdirhier conv_to_w32_path);

if ($mode eq 'install') {
  do_install();
} elsif ($mode eq 'remove') {
  do_remove();
} else {
  die("unknown mode: $mode\n");
}

sub do_remove {
  # do nothing
}

sub do_install {
  return 0 unless win32();

  # bin-installs font-config related stuff
  chomp(my $tmfsysconf = `kpsewhich -var-value=TEXMFSYSCONFIG`);
  chomp(my $tmfconf = `kpsewhich -var-value=TEXMFCONFIG`);

  mkdirhier($tmfconf);

  if (-r "$tmfsysconf/texworks") {
    my @cpycmd = ();
    push @cpycmd, "xcopy", "/e", "/i", "/q", "/y";
    system(@cpycmd, conv_to_w32_path("$tmfsysconf/texworks/*.*"), 
           conv_to_w32_path("$tmfconf/texworks/"));
  }

  return 0;
}

### Local Variables:
### perl-indent-level: 2
### tab-width: 2
### indent-tabs-mode: nil
### End:
# vim:set tabstop=2 expandtab: #
