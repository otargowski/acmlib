set ts=4 sw=4 et nu rnu cul scs ic udf so=3 mouse= hls gcr=a:b
colorscheme slate
filetype indent on
sy on
ca Hash w !cpp -dD -P -fpreprocessed \| tr -d '[:space:]' \
\| md5sum \| cut -c-6
