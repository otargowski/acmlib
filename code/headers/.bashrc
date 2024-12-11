export FLAGS="-Wall -Wextra -Wshadow -Wconversion -Wformat=2 -Wlogical-op -Wfloat-equal -D_GLIBCXX_DEBUG -DDEBUG -DLOCAL -fsanitize=address,undefined -std=c++20 -O0 -ggdb3"
export FFLAGS="-ggdb3 -O3 -std=c++20 -static -DLOCAL"
c(){
    g++ $1.cpp $(echo $FLAGS) -o $@
}
cf(){
    g++ $1.cpp $(echo $FFLAGS) -o $@
}
alias mv="mv -i"
alias cp="cp -i"
alias gdb="ASAN_OPTIONS=detect_leaks=0 gdb -q"
