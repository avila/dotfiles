# copy multiple files to another folder and keep folder structure
# based on:
#	https://unix.stackexchange.com/questions/83593/
#	https://unix.stackexchange.com/questions/50612/
$ find . -name '*.log' -o -name '*.do' -exec cp --parents '{}' //hume/soep-data/STUD/mavila/git_genesis \;
