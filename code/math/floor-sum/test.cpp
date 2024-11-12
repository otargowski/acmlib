#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	ll mn = 1e3;
	ll mc = 1e9;
	ll n = rd(1, mn);
	ll c = rd(1, mc);
	ll a = rd(0, c - 1);
	ll b = rd(0, c - 1);
	ll ans = floor_sum(n, a, b, c);
	ll brute = 0;
	REP(i, n) brute += (a * i + b) / c;
	assert(ans == brute);
}
