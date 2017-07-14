#!/usr/bin/env perl
use Encode;

sub octal {
    my ($t) = (@_);  
    sprintf "\\%o", ord($t);
}

sub convert {
    my ($t) = (@_);  
    if ($t =~ /[\x80-\xFF]/) {
        Encode::from_to($t, "EUC-KR", "UTF-16BE");
        $t =~ s/(.)/${\octal($1)}/g;
        $t = "\\376\\377" . $t;
    }
    $t;
}

while (<>) {
    $_ =~ s/([^}]*}{)([^}]*)/$1${\convert($2)}/;
    print $_;
}
