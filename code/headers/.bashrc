export FLAGS="-Wall -Wextra -Wshadow -Wconversion -Wformat=2 -Wlogical-op -Wfloat-equal -D_GLIBCXX_DEBUG -DDEBUG -DLOCAL -fsanitize=address,undefined -std=c++23 -O0 -ggdb3"
export FFLAGS="-ggdb3 -O3 -std=c++23 -static -DLOCAL"
c(){ g++ $1.cpp $FLAGS -o $@; }
cf(){ g++ $1.cpp $FFLAGS -o $@; }
alias mv="mv -i"
alias cp="cp -i"
alias gdb="ASAN_OPTIONS=detect_leaks=0 gdb -q"
