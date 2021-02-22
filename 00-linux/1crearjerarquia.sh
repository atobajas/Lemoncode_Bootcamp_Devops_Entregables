#!/bin/bash
mkdir -p foo/dummy foo/empty && cd foo/dummy
echo $1 > file1.txt
echo '' > file2.txt