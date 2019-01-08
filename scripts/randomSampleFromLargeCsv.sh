# this command will grab the first line of input file and append 1% (.01; change 
# accordingly) of random selected lines to the output file. 
head -1 FILE_IMPUT > FILE_OUTPUT && perl -ne 'print if (rand() < .01)' FILE_IMPUT >> FILE_OUTPUT
