#!/bin/bash
# requiries:
# - pdftk
# - pdfinfo
# - ps2pdf

if [ $# -ne 1 ]
then
  echo "Usage example: ./bashscript src.pdf"
  exit $E_BADARGS
else
  NUM=$(pdftk $1 dump_data | grep 'NumberOfPages' | awk '{split($0,a,": "); print a[2]}')
  PAGEW=$(pdfinfo $1 | grep 'Page size' | awk '{split($0,a," "); print a[3]}')
  PAGEH=$(pdfinfo $1 | grep 'Page size' | awk '{split($0,a," "); print a[5]}')

  COMMSTR=''

  for i in $(seq 1 $NUM);
	  do
    	COMMSTR="$COMMSTR A$i B1 " 
	  done
	  
  $(echo "" | ps2pdf -dDEVICEWIDTHPOINTS=$PAGEW -dDEVICEHEIGHTPOINTS=$PAGEH - /tmp/pageblanche.pdf)
  $(pdftk A=$1 B=/tmp/pageblanche.pdf cat $COMMSTR output 'mod_'$1)
  #$(pdfnup 'mod_'$1 --nup 2x2 --landscape --outfile 'print_'$1)
  $(rm /tmp/pageblanche.pdf)
  #$(rm 'mod_'$1)

fi

#https://stackoverflow.com/a/26647623/8237186
