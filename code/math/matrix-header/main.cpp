/*
 * Opis: Funkcje pomocnicze do algorytmów macierzowych.
 */
#if 1
#include "../simple-modulo/main.cpp"
// BEGIN HASH
bool equal(int a, int b) { return a == b; }
int divide(int a, int b) { return mul(a, inv(b)); }
using T = int; // END HASH
#else
// BEGIN HASH
constexpr double eps = 1e-9;
bool equal(double a, double b) { return abs(a - b) < eps; }
#define OP(name, op) double name(double a, double b) { return a op b; }
OP(mul, *) OP(add, +) OP(divide, /) OP(sub, -)
using T = double; // END HASH
#endif
