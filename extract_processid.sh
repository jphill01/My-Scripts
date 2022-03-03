
exec > out.txt
while read -r line; do tmp=${line/|*/}; [[ $line =~ '|' ]] && echo ${tmp:1}; done < seqs.fas
