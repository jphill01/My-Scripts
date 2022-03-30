perl -e '
    use strict;
    use warnings;

    my @a;
    sub flush {
        if (@a) {
            print(join(" ", map {"\"" . $_ . "\""} @a), "\n");
            @a = ();
        }
    }

    while (<>) {
        chop;
        if (/^>/) {
            flush(@a);
            @a = /^>([^|]+\|)(.*)/;
        } else {
            push(@a, split("", $_));
        }
    }
    flush(@a);
' file.fasta > out.txt