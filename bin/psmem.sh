# show memory used by processes
FMT=%mem,rss,size,pid,user,args
ps -o $FMT | head -1
ps -e -o $FMT | sort -nr
ps -o $FMT | head -1
