#!/bin/sh
for directory in "$@" 
do
for filename in "$directory"/*
    do
    sed -e 's/\(.\)/\1\n/g' < "$filename" | sort | uniq -ic | sort -n
    echo $filename;
done
done
# Use the following to determine most common words
# sed -e 's/\(.\)/\1\n/g' < "第一章  34D，女神！.txt" | sort | uniq -ic | sort -n