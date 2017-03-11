# List interesting file types within directories.
# Work in progress.
# want something like:

# ./documents 44 docs; 13 images;
# docs === .doc .docx  images === .jpg .gif, etc
#find . -type f | perl -pne 'chomp; $_ =~ m{\A (.*? /) ([^/]+) \z}xms or die qq{no match for path/filename: [$_]\n}; my ($path, $filename) = ($1, $2); $_ = "$path $filename\n"'

DIR=${1:-.}
find $DIR -type f | grep -v node_modules | ls-types.pl | sort -n -r
# 32: ./path/ 12 documents, 20 images
