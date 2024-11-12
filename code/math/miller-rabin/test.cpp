#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	V <ll> v = {
		2047ll,
		1373653ll,
		25326001ll,
		3215031751ll,
		2152302898747ll,
		3474749660383ll,
		341550071728321ll,
		3825123056546413051ll
	};
	static int counter1 = ssize(v);
	if (counter1 > 0) {
		--counter1;
		debug(v[counter1]);
		assert(!miller_rabin(v[counter1]));
		return;
	}
	auto brute = [&](ll x) {
		if (x <= 1) return false;
		for (ll i = 2; i * i <= x; ++i) {
			if (x % i == 0) return false;
		}
		return true;
	};
	static int counter2 = 1e5;
	if (counter2 >= 0) {
		debug(counter2);
		assert(miller_rabin(counter2) == brute(counter2));
		--counter2;
		return;
	}
	ll mn = (1ll << 40);
	ll n = rd_ll(0, mn);
	assert(miller_rabin(n) == brute(n));
}
