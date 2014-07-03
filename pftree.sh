#!/bin/bash

pstree -Up "$@" | sed '
	s/[-a-zA-Z]\+/\x1B[32m&\x1B[0m/g
	s/[{}]/\x1B[31m&\x1B[0m/g
	s/[─┬─├─└│]/\x1B[34m&\x1B[0m/g
'
