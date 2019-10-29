# copy multiple files to another folder and keep folder structure
# based on:
#	https://unix.stackexchange.com/questions/83593/
#	https://unix.stackexchange.com/questions/50612/
# here: 
#	copies all .log and .do files from current directory into /mavila/git_genesis
find \( -name '*.log' -o -name '*.do' \) -exec cp -v --parents '{}' //hume/soep-data/STUD/mavila/git_genesis \;

# same as abobe but in only in matching folders (*pgen*)
find -path '*pgen*' \( -name '*.log' -o -name '*.do' \) -exec cp -v --parents '{}' //hume/soep-data/STUD/mavila/git_genesis \;
