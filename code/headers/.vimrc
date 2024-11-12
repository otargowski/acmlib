set ts=4 sw=4 et nu rnu cul scs ic udf so=3 mouse= hls gcr=a:b
au bufenter * sy keyword CppStatement REP FOR RFOR
au bufenter * sy keyword CppType ll V vi vll ci cll pii pll ld
au bufenter * sy keyword Constant C
colorscheme slate
filetype indent on
sy on
ca Hash w !cpp -dD -P -fpreprocessed \| tr -d '[:space:]' \
\| md5sum \| cut -c-6
