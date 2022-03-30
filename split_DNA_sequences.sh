#!/bin/bash

exec > out1.txt

#
# split the sequence into characters, quote, and print
#
flush() {
    if [[ -n $seq ]]; then
        mapfile -t ary < <(fold -w 1 <<< "$seq" | sed -E 's/(.)/"&"/')
        echo "${ary[*]}"
        seq=                            # clear the seq variable
    fi
}

while IFS= read -r line; do
    if [[ $line = ">"* ]]; then         # header line
        flush
        echo -n "$line" | sed -E 's/^>([^|]+\|)(.*)/"\1" "\2" /'
    else                                # sequence line(s)
        seq="$seq$line"                 # consider multi-line sequence
    fi
done < seqs_aligned_trimmed.fas
flush
