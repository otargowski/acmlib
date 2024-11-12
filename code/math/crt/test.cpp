#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	ll mx = 10;
	ll n = rd(2, mx);
	ll a = rd(0, n - 1);
	ll m = rd(2, mx);
	ll b = rd(0, m - 1);
	if(__gcd(n, m) != 1) return;
	ll x = crt(a, n, b, m);
	debug(a, n, b, m, x);
	assert(x % n == a and x % m == b);
}
