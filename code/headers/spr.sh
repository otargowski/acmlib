for i in $(seq 1 1000); do
    ./f-gen > ina && ./f < ina > o1 && \
        ./f-bru < ina > o2 && diff o1 o2 || break
done
